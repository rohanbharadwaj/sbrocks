/*
 * lapic.c
 *
 *  Created on: 29 Aug 2011
 *      Author: cds
 */


#include <arch/arch.h>
#include <mm/mm.h>
#include <lib/lib.h>

struct acpi_madt {

	struct acpi_header header;
	uint32_t lapic_address;
	uint32_t flags;
} __attribute__((__packed__));

struct acpi_madt_lapic {

	uint8_t type;
	uint8_t length;
	uint8_t acpi_processor_id;
	uint8_t lapic_id;
	uint32_t flags;

} __attribute__((__packed__));

struct acpi_madt_ioapic {

	uint8_t type;
	uint8_t length;
	uint8_t ioapic_id;
	uint8_t reserved0;
	uint32_t phy_address;
	uint32_t global_system_interrupt_base;

} __attribute__((__packed__));

enum madt_type {

	madt_lapic = 0,
	madt_ioapic,
	madt_interrupt_source_override,
	madt_nmi_source,
	madt_lapic_nmi,
	madt_lapic_address_override,
	madt_iosapic,
	madt_lsapic,
	madt_platform_interrupt_sources,
	madt_lx2apic,
	madt_lx2apic_nmi,
};

uint64_t acpi_get_lapic_address(void) {

	const struct acpi_madt* madt = (const struct acpi_madt*)acpi_find_first_table("APIC");

	if(madt)
		return madt->lapic_address;

	return 0;
}

static const void* _acpi_find_next(uint64_t id, const void* last) {

	uint8_t returnflag = (last) ? 0 : 1 ;

	for(const struct acpi_madt* madt = (const struct acpi_madt*)acpi_find_first_table("APIC");
			madt;
			madt =  (const struct acpi_madt*)acpi_find_next_table(madt,"APIC")) {

		for(uint8_t *ptr = (uint8_t *)(madt + 1); ptr < (((uint8_t*)madt) + madt->header.length); ptr += ptr[1]) {

			if(ptr[0] == id) {

				if(returnflag)
					return ptr;
				else if((void*)ptr == last)
					returnflag = 1;
			}
		}
	}

	return 0;
}

static const struct acpi_madt_lapic* acpi_find_next_lapic(const struct acpi_madt_lapic *last) {

	uint8_t returnflag = last ? 0 : 1;

	for(const struct acpi_madt_lapic *lapic = (const struct acpi_madt_lapic*)_acpi_find_next(madt_lapic, 0);
			lapic;
			lapic = (const struct acpi_madt_lapic*)_acpi_find_next(madt_lapic, lapic)) {


		if(lapic->flags & 1) { /* enabled ? */

			if(returnflag)
				return lapic;
			else if(last->lapic_id == lapic->lapic_id)
				returnflag = 1;
		}
	}

	return 0;
}

static const struct acpi_madt_ioapic* acpi_find_next_ioapic(const struct acpi_madt_ioapic *last) {

	uint8_t returnflag = last ? 0 : 1;

	for(const struct acpi_madt_ioapic *ioapic = (const struct acpi_madt_ioapic*)_acpi_find_next(madt_ioapic, 0);
			ioapic;
			ioapic = (const struct acpi_madt_ioapic*)_acpi_find_next(madt_ioapic, ioapic)) {

		if(returnflag)
			return ioapic;
		else if(last->ioapic_id == ioapic->ioapic_id)
			returnflag = 1;
	}

	return 0;
}

static const struct acpi_madt_ioapic* acpi_find_first_ioapic() {

	return acpi_find_next_ioapic(0);
}

uint64_t acpi_find_first_lapic_id() {

	const struct acpi_madt_lapic *lapic = acpi_find_next_lapic( 0 );

	if(!lapic)
		return (uint64_t)-1;

	return lapic->lapic_id;
}

uint64_t acpi_find_next_lapic_id(uint64_t last) {

	struct acpi_madt_lapic tmp = {0,};

	tmp.lapic_id = last;

	const struct acpi_madt_lapic *lapic = acpi_find_next_lapic( &tmp );

	if(!lapic)
		return (uint64_t)-1;

	return lapic->lapic_id;
}

uint64_t acpi_find_first_ioapic_id() {

	const struct acpi_madt_ioapic *ioapic = acpi_find_next_ioapic( 0 );

	if(!ioapic)
		return (uint64_t)-1;

	return ioapic->ioapic_id;
}

uint64_t acpi_find_next_ioapic_id(uint64_t last) {

	struct acpi_madt_ioapic tmp = {0,};

	tmp.ioapic_id = last;

	const struct acpi_madt_ioapic *ioapic = acpi_find_next_ioapic( &tmp );

	if(!ioapic)
		return (uint64_t)-1;

	return ioapic->ioapic_id;
}

uint64_t acpi_find_ioapic_address(uint64_t id) {

	for(const struct acpi_madt_ioapic* ioapic = acpi_find_first_ioapic(); ioapic; ioapic = acpi_find_next_ioapic(ioapic)) {

		if(ioapic->ioapic_id == id)
			return ioapic->phy_address;
	}

	return 0;
}

uint64_t acpi_find_ioapic_system_interrupt_base(uint64_t id) {

	for(const struct acpi_madt_ioapic* ioapic = acpi_find_first_ioapic(); ioapic; ioapic = acpi_find_next_ioapic(ioapic)) {

		if(ioapic->ioapic_id == id)
			return ioapic->global_system_interrupt_base;
	}

	return 0;
}
