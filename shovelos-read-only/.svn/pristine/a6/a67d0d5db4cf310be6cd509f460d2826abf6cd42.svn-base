/*
 * hpet.c
 *
 *  Created on: 23 Aug 2011
 *      Author: Chris Stones
 */

#include<arch/arch.h>
#include<lib/lib.h>
#include<mm/mm.h>

struct  event_timer_block_id {

	unsigned hardware_rev_id_1st : 8;
	unsigned comparators_1st : 5;
	unsigned count_size_cap : 1;
	unsigned reserved0 : 1;
	unsigned legacy_replacement_irq_route_cap : 1;
	unsigned pci_vendor_id : 16;

}__attribute__((__packed__));

enum GAS_address_space_id {

	system_mem = 0,
	system_io  = 1,
};

enum page_protection {

	no_guarantee=0,
	page_protected_4k=1,
	page_protected_64k=2,

};

struct generic_address_struct {

	uint8_t 	address_space_id;
	uint8_t  	register_bit_width;
	uint8_t  	register_bit_offset;
	uint8_t  	reserved0;
	uint64_t 	base_address;

}__attribute__((__packed__));

struct hpet_descr_table {

	uint8_t 						signature[4];
	uint32_t 						length;
	uint8_t							revision;
	uint8_t							checksum;
	uint8_t							oem_id[6];
	uint8_t							oem_table_id[8];
	uint32_t 						oem_revision;
	uint32_t						creator_id;
	uint32_t						creator_revision;
	struct  event_timer_block_id 	event_timer_block_id;
	struct  generic_address_struct	base_address;
	uint8_t							hpet_number;
	uint16_t						min_periodic_tick;
	unsigned						page_protection : 4;
	unsigned						oem_attribute : 4;

} __attribute__((__packed__));


enum hpet_registers {

	hpet_general_cap_reg 	= 0x0000 / sizeof(uint64_t),
	hpet_general_conf_reg 	= 0x0010 / sizeof(uint64_t),
	hpet_main_counter		= 0x00f0 / sizeof(uint64_t),
};

enum hpet_register_bits {

	hpet_general_conf_general_enable		= (1<<0),
	hpet_general_conf_legacy_replacement 	= (1<<1),
};

static volatile uint64_t * hpet_mmap(uint64_t phy) {

	uint64_t size   = 1024; // TODO: correct?

	uint64_t pages  = (size / PAGE_SIZE)
					+((size % PAGE_SIZE) ? 1 : 0);

	uint64_t virt = (uint64_t)vmm_alloc_hw(pages);

	for(uint64_t i=0; i<pages; i++)
		mmap((phy + i*PAGE_SIZE ) & ~(PAGE_SIZE-1), virt + PAGE_SIZE*i, 0);

	volatile uint64_t *s = (volatile uint64_t *)(virt + (phy & (PAGE_SIZE-1)));

	return s;
}

static uint64_t hpet_read_register(volatile uint64_t *hpet_base, enum hpet_registers reg ) {

	return hpet_base[reg];
}

static void hpet_write_register(volatile uint64_t *hpet_base, enum hpet_registers reg, uint64_t val) {

	hpet_base[reg] = val;
}

/*static*/ void hpet_set_register_bits(volatile uint64_t *hpet_base, enum hpet_registers reg, uint64_t bits) {

	hpet_write_register(hpet_base, reg,
		hpet_read_register(hpet_base, reg) | bits);
}

static void hpet_clear_register_bits(volatile uint64_t *hpet_base, enum hpet_registers reg, uint64_t bits) {

	hpet_write_register(hpet_base, reg,
		hpet_read_register(hpet_base, reg) & ~bits);
}

/*static */void hpet_update_register_bits(volatile uint64_t *hpet_base, enum hpet_registers reg, uint64_t clear, uint64_t set) {

	hpet_write_register(hpet_base, reg,
			(hpet_read_register(hpet_base, reg) | set) & ~clear);
}

volatile uint64_t *hpet_base = 0;

uint64_t hpet_clock_period(void) {

	uint64_t reg = hpet_read_register(hpet_base, hpet_general_cap_reg);

	return reg >> 32;
}


void hpet_wait_femtoseconds(uint64_t femtoseconds) {

	uint64_t period = hpet_clock_period();

	uint64_t ticks = femtoseconds / period;

	if(!ticks)
		return;

	uint64_t timenow  	= hpet_read_register(hpet_base, hpet_main_counter);
	uint64_t timeafter 	= timenow + ticks;

	if(timeafter < timenow) {

		// need to wait for wrap around
		while(hpet_read_register(hpet_base, hpet_main_counter) >= timenow) {

			__asm__ __volatile__(" nop ");
			__asm__ __volatile__(" nop ");
			__asm__ __volatile__(" nop ");
			__asm__ __volatile__(" nop ");
		}
	}

	while(hpet_read_register(hpet_base, hpet_main_counter) <= timeafter) {

		__asm__ __volatile__(" nop ");
		__asm__ __volatile__(" nop ");
		__asm__ __volatile__(" nop ");
		__asm__ __volatile__(" nop ");
	}
}

void hpet_wait_picoseconds(uint64_t picoseconds) {

	hpet_wait_femtoseconds(picoseconds * 1000);
}

void hpet_wait_nanoseconds(uint64_t nanoseconds) {

	hpet_wait_femtoseconds(nanoseconds * 1000000);
}

void hpet_wait_microseconds(uint64_t microseconds) {

	hpet_wait_femtoseconds(microseconds * 1000000000);
}

void hpet_wait_milliseconds(uint64_t milliseconds) {

	hpet_wait_femtoseconds(milliseconds * 1000000000000);
}

void hpet_wait_seconds(uint64_t seconds) {

	hpet_wait_femtoseconds(seconds * 1000000000000000);
}

uint64_t hpet_read_main_counter(void) {

	return hpet_read_register(hpet_base, hpet_main_counter);
}

uint8_t hpet_init(void) {

	const struct hpet_descr_table* hpet_tab =
			(const struct hpet_descr_table*) acpi_find_first_table("HPET");

	if(!hpet_tab)
		return -1;

	if(sum(hpet_tab,hpet_tab->length) != 0)
		return -1;

	hpet_base = hpet_mmap( hpet_tab->base_address.base_address );

	// stop ticking
	hpet_clear_register_bits( hpet_base, hpet_general_conf_reg, hpet_general_conf_general_enable );

	// zero counter
	hpet_write_register( hpet_base, hpet_main_counter, 0);

	//start ticking and kill legacy emulation.
	hpet_clear_register_bits ( hpet_base, hpet_general_conf_reg, hpet_general_conf_legacy_replacement);
	hpet_set_register_bits( hpet_base, hpet_general_conf_reg, hpet_general_conf_general_enable );

	return 0;
}






