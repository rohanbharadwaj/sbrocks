/*
 * acpi.c
 *
 *  MINIMAL acpi implementation.
 *  we just need to be able to find hardware vital for booting ( HPET )
 *
 *  Created on: Jan 23, 2011
 *      Author: cds
 */

#include<mm/mm.h>
#include<arch/arch.h>
#include<lib/lib.h>

struct rsdp_header {

	struct {

		sint8_t signature[8];
		uint8_t checksum;
		sint8_t oemid[6];
		uint8_t revision;
		uint32_t rsdt_address;
	} ver1;

	struct {

		uint32_t length;
		uint64_t xsdt_address;
		uint8_t  extended_checksum;
		uint8_t  reserved[3];
	} ver2;

} __attribute__((packed));


struct _header {

	sint8_t signature[4];
	uint32_t length;
	uint8_t revision;
	uint8_t checksum;
	sint8_t oemid[6];
	sint8_t oem_table_id[8];
	uint32_t oem_revision;
	sint8_t creator_id[4];
	uint32_t creator_revision;

} __attribute__((packed)) ;

struct rsdt_struct {

	struct _header header;
	uint32_t entry0;
}__attribute__((packed)) ;

struct xsdt_struct {

	struct _header header;
	uint64_t entry0;
}__attribute__((packed)) ;

struct madt_struct {

	struct _header header;
	uint32_t local_apic_address;
	uint32_t flags;

}__attribute__((packed)) ;

static sint8_t validate(const struct rsdp_header* header) {

	if(memcmp(header,"RSD PTR ",8)!=0)
		return -1; // no magic!

	if(sum(&(header->ver1), sizeof header->ver1) != 0)
		return -1; // corrupt or invalid.

      if(header->ver1.revision && (sum(&(header->ver2), sizeof header->ver2) != 0))
            return -1; // corrupt of invalid extended data.

	return 0; // all good!
}

/***
 * find the extended BIOS data area
 */
static const uint8_t* ebda_addr() {

	uint64_t seg_addr = PHY_TO_VIRT(0x40e, const uint16_t*)[0];
	         seg_addr <<= 4;

	return  PHY_TO_VIRT(seg_addr, const uint8_t*);
}

/***
 * search given range for root system descriptor pointer.
 */
static const struct rsdp_header* scan_for_rsdp(const uint8_t *_addr, uint64_t size) {

	for(const uint8_t* addr = _addr; addr < _addr + size; addr+=0x10)
		if(validate((const struct rsdp_header*)addr)==0)
			return (const struct rsdp_header*)addr;

	return (const struct rsdp_header*)0;
}

/***
 * search for root system descriptor pointer.
 */
static const struct rsdp_header* find_rsdp() {

	const struct rsdp_header* rsdp;

	/*** search extended BIOS data area ***/
	{
		const uint8_t* ebda = ebda_addr();
		if(((uint64_t)ebda) & 0x0f) {
			ebda +=  0x10;
			ebda -= (((uint64_t)ebda) & 0x0f);
		}

		if((rsdp = scan_for_rsdp(ebda, 0x400)))
			return rsdp;
	}

	/*** search BIOS main area ***/
	if((rsdp = scan_for_rsdp(PHY_TO_VIRT(0xE0000, const uint8_t*), 0x20000)))
		return rsdp;

	return (const struct rsdp_header*)0;
}

static const struct xsdt_struct* find_xsdt( void ) {

	const struct rsdp_header * rsdp = find_rsdp();

	if(rsdp->ver1.revision == 0) {
		HALT("trying to use xsdt, when rsdp revision is 0");
	}

	const struct xsdt_struct * xsdt =
		PHY_TO_VIRT( rsdp->ver2.xsdt_address, const struct xsdt_struct *);

	if(memcmp(xsdt->header.signature ,"XSDT",4)!=0)
		return 0; // no magic!

	if(sum(xsdt, xsdt->header.length) != 0)
		return 0; // corrupt or invalid

	return xsdt;
}

static const struct rsdt_struct* find_rsdt( void ) {

	const struct rsdp_header * rsdp = find_rsdp();

	if(rsdp->ver1.revision > 0) {
		HALT("trying to use rsdt, when xsdt is available!");
	}

	const struct rsdt_struct * rsdt =
		PHY_TO_VIRT( rsdp->ver1.rsdt_address, const struct rsdt_struct *);

	if(memcmp(rsdt->header.signature ,"RSDT",4)!=0)
			return 0; // no magic!

	if(sum(rsdt, rsdt->header.length) != 0)
			return 0; // corrupt or invalid.

	return rsdt;
}

static void* acpi_find_next_table_revX(const void *last, const char *target_sig, const struct _header *header,uint8_t addrsize) {

	if(!header || !target_sig)
		return 0;

	uint64_t 	ents 		= (header->length - sizeof *header) / addrsize;
	uint8_t  	returnflag 	= (!last) ? 1 : 0;
	uint32_t*	entry0 		= (uint32_t*)(header+1);

	for(uint32_t* entry = entry0; ((uint64_t)entry) < ((uint64_t)(entry0 + ents * (addrsize/sizeof *entry))); entry += (addrsize/sizeof *entry)) {

		uint64_t phy_addr = 0;

		memcpy(&phy_addr, entry, addrsize);

		struct _header *header = PHY_TO_VIRT(phy_addr, struct _header *);

		if(sum(header, header->length)!=0)
			continue;

		if(memcmp(header->signature, target_sig, sizeof header->signature)==0) {

			if(returnflag)
				return header;
			else if(header==(struct _header *)last)
				returnflag = 1;
		}
	}
	return 0;
}

static const void* acpi_find_next_table_rev0(const void *last, const char *header) {

	const struct rsdt_struct * rsdt = find_rsdt( );

	return acpi_find_next_table_revX(last, header, &rsdt->header, sizeof rsdt->entry0);
}

static const void* acpi_find_next_table_rev1(const void *last, const char *header) {

	const struct xsdt_struct * xsdt = find_xsdt( );

	return acpi_find_next_table_revX(last, header, &xsdt->header, sizeof xsdt->entry0);
}

const void* acpi_find_next_table(const void *last, const char *header) {

	const struct rsdp_header* rsdp = find_rsdp();

	if(!rsdp)
		return 0;

	if(rsdp->ver1.revision == 0)
		return acpi_find_next_table_rev0(last,header);

	return acpi_find_next_table_rev1(last,header);
}

const void *acpi_find_first_table(const char * header) {

	return acpi_find_next_table(0, header);
}

