/*
 * ioapic.c
 *
 *  Created on: 31 Jan 2011
 *      Author: Chris Stones
 */

#include <inttypes.h>
#include <lib/lib.h>
#include <mm/mm.h>
#include <arch/arch.h>

#define MAX_IOAPIC 	16

enum ioapic_mm_reg {
    IOREGSEL 	= 0x00,
    IOWIN		= 0x10,
};

enum ioapic_reg {

    IOAPICID	= 0x00,
    IOAPICVER	= 0x01,
    IOAPICARB	= 0x02,
    IOREDTBL00	= 0x10,
    IOREDTBL01	= 0x12,
    IOREDTBL02	= 0x14,
    IOREDTBL03	= 0x16,
    IOREDTBL04	= 0x18,
    IOREDTBL05	= 0x1a,
    IOREDTBL06	= 0x1c,
    IOREDTBL07	= 0x1e,
    IOREDTBL08	= 0x20,
    IOREDTBL09	= 0x22,
    IOREDTBL10	= 0x24,
    IOREDTBL11	= 0x26,
    IOREDTBL12	= 0x28,
    IOREDTBL13	= 0x2a,
    IOREDTBL14	= 0x2c,
    IOREDTBL15	= 0x2e,
    IOREDTBL16	= 0x30,
    IOREDTBL17	= 0x32,
    IOREDTBL18	= 0x34,
    IOREDTBL19	= 0x36,
    IOREDTBL20	= 0x38,
    IOREDTBL21	= 0x3a,
    IOREDTBL22	= 0x3c,
    IOREDTBL23	= 0x3e,
};

/** for building 64bit IOREDTBL## registers ***/
#define IOAPIC_RED_DST(x)  		((x & 0xff) << 56)
#define IOAPIC_RED_MASK(x) 		((x & 0x01) << 16)
#define IOAPIC_RED_TRIGGER(x)	((x & 0x01) << 15)
#define IOAPIC_RED_RIRR(x)		((x & 0x01) << 14)
#define IOAPIC_RED_INPOL(x)		((x & 0x01) << 13)
#define IOAPIC_RED_DELVIS(x)	((x & 0x01) << 12)
#define IOAPIC_RED_DESTMOD(x)	((x & 0x01) << 11)
#define IOAPIC_RED_DELMOD(x)	((x & 0x07) <<  8)
#define IOAPIC_RED_INTVEC(x)	((x & 0xff) <<  0)

/*** DESTINATION PARAMETERS ***/
enum ioapic_dest_param {

    IOAPIC_DEST_PHYSICAL	= 0x0, /* dst is APIC ID */
    IOAPIC_DEST_LOGICAL		= 0x1, /* dst is cpu set */
};

enum ioapic_trigger_param {

    IOAPIC_EDGE_TRIGGER		= 0x0,
    IOAPIC_LEVEL_TRIGGER	= 0x1,
};

/*** DELMOD PARAMETERS ***/
enum ioapic_delmod_param {

    IOAPIC_DELMOD_FIXED		= 0x0,
    IOAPIC_DEMLOD_LOWPR		= 0x1,
    IOAPIC_DELMOD_SMI		= 0x2,
    IOAPIC_DELMOD_NMI		= 0x4,
    IOAPIC_DELMOD_INIT		= 0x5,
    IOAPIC_DELMOD_EXTINIT	= 0x7,
};

/*** INTPOL PARAMETERS ***/
enum ioapic_intpol_param {

    IOAPIC_INTPOL_HI		=0x0,
    IOAPIC_INTPOL_LO		=0x1,
};

/*** other parameters ***/
enum ioapic_param {

    IOAPIC_CLEAR = 0x0,
    IOAPIC_SET	= 0x1,
};

struct ioapic_irq_map {

	struct ioapic_struct 	*ioapic;
	enum ioapic_reg 		redir_register;
};

static struct ioapic_struct ioapics[MAX_IOAPIC];

// Determine which register, or which IOAPIC is connected to the given system IRQ line.
struct ioapic_irq_map* ioapic_find_irq(uint8_t irq, struct ioapic_irq_map *irq_struct) {

	for(uint64_t i=0; i<MAX_IOAPIC; i++) {

		if(!ioapics[i].vaddr)
			continue;

		if(ioapics[i].irq_sys_interrupt_base > irq)
			continue;

		if((ioapics[i].irq_sys_interrupt_base + ioapics[i].irq_redirect_size) <= irq )
			continue;

		irq_struct->ioapic = &ioapics[i];
		irq_struct->redir_register = (enum ioapic_reg)(IOREDTBL00 + ((irq - ioapics[i].irq_sys_interrupt_base)*2));

		return irq_struct;
	}
	return 0;
}

static inline void io_apic_write32__nolock__(void* ioapic_base, enum ioapic_reg reg, uint32_t data) {

//	kprintf("io_apic_write32__nolock__(0x%lx, %d, 0x%lx);\n",ioapic_base,reg,data);

	__asm__ __volatile__ (
			"movl %2, %0;    \n" // select  register
			"movl %3, %1;    \n" // write register

		:	"=m" (*(volatile uint32_t*)((uint8_t*)ioapic_base + IOREGSEL)), /* output 0 register select */
		 	"=m" (*(volatile uint32_t*)((uint8_t*)ioapic_base + IOWIN   ))  /* output 1 io-window*/

		:	"r"	 (reg),		/* input 2 register */
		  	"r"  (data)		/* input 3 data */
		);
}

static inline uint32_t io_apic_read32__nolock__(void* ioapic_base, enum ioapic_reg reg) {

	uint32_t ret = 69;

	__asm__ __volatile__ (
			"movl %2, %0;    \n" // select  register
			"movl %3, %1;    \n" // read    register

		:	"=m" (*(volatile uint32_t*)((uint8_t*)ioapic_base + IOREGSEL)), /* output 0 register select */
		 	"=r" (ret)  													/* output 1 return value*/
		:	"r"	 (reg),														/* input 2 register */
		 	"m" (*(volatile uint32_t*)((uint8_t*)ioapic_base + IOWIN   ))	/* input 3 io-window*/
		);

	return (ret);
}

static inline void io_apic_write32(struct ioapic_struct *ioapic, enum ioapic_reg reg, uint32_t data) {

	ticket_lock_wait( &ioapic->lock );

	io_apic_write32__nolock__( ioapic->vaddr, reg, data );

	ticket_lock_signal( &ioapic->lock );
}

static inline uint32_t io_apic_read32(struct ioapic_struct *ioapic, enum ioapic_reg reg) {

	uint32_t ret = 69;

	ticket_lock_wait( &ioapic->lock );

	ret = io_apic_read32__nolock__(ioapic->vaddr,reg);

	ticket_lock_signal( &ioapic->lock );

	return ret;
}

static inline void io_apic_write64(struct ioapic_struct *ioapic, enum ioapic_reg reg, uint64_t data) {

	uint32_t hidata = data >> 32;
	uint32_t lodata = data  & 0xffffffff;
	uint32_t maskdata = IOAPIC_RED_MASK(IOAPIC_SET);

	ticket_lock_wait( &ioapic->lock );

	io_apic_write32__nolock__( ioapic->vaddr, reg+0, maskdata );
	io_apic_write32__nolock__( ioapic->vaddr, reg+1, hidata );
	io_apic_write32__nolock__( ioapic->vaddr, reg+0, lodata );

	ticket_lock_signal( &ioapic->lock );
}

static inline uint64_t io_apic_read64(struct ioapic_struct *ioapic, enum ioapic_reg reg) {

	uint64_t retlo = 0;
	uint64_t rethi = 0;

	ticket_lock_wait( &ioapic->lock );

	retlo = io_apic_read32__nolock__( ioapic->vaddr, reg+0 );
	rethi = io_apic_read32__nolock__( ioapic->vaddr, reg+1 );

	ticket_lock_signal( &ioapic->lock );

	return retlo | (rethi<<32);
}

uint64_t ioapic_detect() {

    uint64_t count = 0;

    for(uint64_t id = acpi_find_first_ioapic_id(); id != (uint64_t)-1; id = acpi_find_next_ioapic_id(id)) {

    	++count;
    }

    return count;
}

/*
sint8_t ioapic_setmask_irq(uint8_t irq, sint8_t mask) {

	if(mask)
		return ioapic_mask_irq(irq);

	return ioapic_unmask_irq(irq);
}

sint8_t ioapic_mask_irq(uint8_t irq)
{
	sint8_t wasmasked = 1;

	enum ioapic_reg reg = (enum ioapic_reg)(((int)IOREDTBL00) + (irq * 2));

	ticket_lock_wait( &lock );

	uint32_t lodword = io_apic_read32__nolock__(ioapic, reg);

	if(!(lodword & IOAPIC_RED_MASK(IOAPIC_SET))) {

		wasmasked = 0;
		lodword |=IOAPIC_RED_MASK(IOAPIC_SET);
		io_apic_write32__nolock__(ioapic, reg, lodword);
	}

	ticket_lock_signal( &lock );

	return wasmasked;
}

sint8_t ioapic_unmask_irq(uint8_t irq)
{
	sint8_t wasmasked = 0;

	enum ioapic_reg reg = (enum ioapic_reg)(((int)IOREDTBL00) + (irq * 2));

	ticket_lock_wait( &lock );

	uint32_t lodword = io_apic_read32__nolock__(ioapic, reg);

	if(lodword & IOAPIC_RED_MASK(IOAPIC_SET)) {

		wasmasked = 1;
		lodword &= ~IOAPIC_RED_MASK(IOAPIC_SET);
		io_apic_write32__nolock__(ioapic, reg, lodword);
	}

	ticket_lock_signal( &lock );

	return wasmasked;
}
*/

static struct ioapic_struct* find_free_ioapic_struct(void) {

	for(uint64_t i=0; i<MAX_IOAPIC; i++)
		if(ioapics[i].vaddr == 0)
			return &(ioapics[i]);

	return 0;
}



static void config(uint64_t id) {

    struct ioapic_struct* ioapic = find_free_ioapic_struct();

    if(!ioapic)
    	HALT("too many installed ioapics");

    uint64_t phy_addr = acpi_find_ioapic_address(id);

    uint64_t vpage = (uint64_t)vmm_alloc_hw( PAGE_SIZE );

   	mmap(phy_addr & ~(PAGE_SIZE-1), vpage, 0);

   	ioapic->id = id;
   	ioapic->irq_sys_interrupt_base = acpi_find_ioapic_system_interrupt_base(id);
    ioapic->vaddr = (void*)(vpage + (phy_addr & (PAGE_SIZE-1)));
    uint32_t ver = io_apic_read32(ioapic, IOAPICVER);
    ioapic->irq_redirect_size = 1 + ((ver >> 16) & 0xff);
}

uint16_t ioapic_configure() {

    uint16_t count = 0;

    memset(ioapics, 0, sizeof ioapics );

    for(uint64_t id = acpi_find_first_ioapic_id(); id != (uint64_t)-1; id = acpi_find_next_ioapic_id(id)) {

    	++count;
    	config( id );
    }

    // HACK - KEYBOURD IRQ
    struct ioapic_irq_map irq_map;

    if(ioapic_find_irq(1, &irq_map)) {

    	uint64_t red_ent = 	IOAPIC_RED_DST		( 0ll )						|
    	    				IOAPIC_RED_MASK		( IOAPIC_CLEAR )			|
    	    				IOAPIC_RED_TRIGGER	( IOAPIC_EDGE_TRIGGER )		|
    	    				IOAPIC_RED_INPOL	( IOAPIC_INTPOL_HI )		|
    	    				IOAPIC_RED_DELVIS	( IOAPIC_CLEAR )			|
    	    				IOAPIC_RED_DESTMOD	( IOAPIC_DEST_PHYSICAL )	|
    	    				IOAPIC_RED_DELMOD	( IOAPIC_DELMOD_FIXED ) 	|
    	    				IOAPIC_RED_INTVEC	( 64 ); /* HACK - KBC VECTOR */

    	io_apic_write64( irq_map.ioapic, irq_map.redir_register ,red_ent);
    }
    else
    	HALT("couldn't find ioapic for IRQ 1");

    // END HACK

    return count;
}

