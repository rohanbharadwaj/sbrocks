/*
 * phy_alloc.c
 *
 *  Created on: Jan 8, 2011
 *      Author: cds
 */

#include <mm/mm.h>
#include <mm/phy_alloc.h>
#include <mm/virt_alloc.h>
#include <arch/arch.h>
#include <lib/string.h>
#include <inttypes.h>

static TICKET_LOCK( phy_bitmap_lock );

static uint64_t phy_bitmap[(PAGE_MAX/64)+1];

#define PAGES_PER_GROUP ((sizeof phy_bitmap[0]) * 8)



static void set_page_free(uint64_t page) {

	if(page)
	    phy_bitmap[page/64] &= ~(1 << (page % 64));
}

static void set_page_used(uint64_t page) {

	if(page)
	    phy_bitmap[page/64] |= (1 << (page % 64));
}

void mm_phy_init(struct mm_phy_reg *regs, uint64_t regnum) {

	ticket_lock_wait( &phy_bitmap_lock );

	/* set all pages to used / unavailable */
	memset(phy_bitmap, 0xff, sizeof phy_bitmap);

	/* first pass - set pages that physically exist for general purpose as free */
	for(struct mm_phy_reg* r=regs; r<regs+regnum; r++) {

		if(r->type != MM_PHY_USABLE)
			continue;

		uint64_t b = r->base & PAGE_SIZE ? ((r->base + PAGE_SIZE) & PAGE_SIZE)  : r->base;
		uint64_t l = r->base & PAGE_SIZE ? ( r->len  - (r->base   & PAGE_SIZE)) : r->len;

		for(; l>=PAGE_SIZE; l-=PAGE_SIZE, b+=PAGE_SIZE) {
			set_page_free( mm_phy_to_page(b) );
		}
	}

	/*** the boot loader has mapped some memory for the kernel image in the top 2gig address space
	 * find it, and mark it as used.
	 */
	for(uint64_t v = VIRT_KERNEL_BASE; ; v += PAGE_SIZE) {

		uint64_t p = virt_to_phy(v);

		if(!p)
			break;

		set_page_used( mm_phy_to_page(p)  );
	}

	/*** never dynamically allocate low-memory ***/
	for(uint64_t lowmem=0; lowmem < 0x100000; lowmem += PAGE_SIZE)
		set_page_used( mm_phy_to_page(lowmem) );

	phy_bitmap[0] |= 1; // HACK set_page_*() ignores NULL page. manually make it un-available here!

	ticket_lock_signal( &phy_bitmap_lock );

}

/****************************************************
 * mm_phy_free_page: free given page.
 */
void mm_phy_free_page(uint64_t page) {

	if(!page)
		return;

	ticket_lock_wait( &phy_bitmap_lock );

	set_page_free(page);

	ticket_lock_signal( &phy_bitmap_lock );
}

/****************************************************
 * mm_phy_alloc_page: Allocate the first free page.
 * returns page number, or zero on out of memory.
 */
uint64_t mm_phy_alloc_page() {

	ticket_lock_wait( &phy_bitmap_lock );

	for(uint64_t g=0; g< sizeof phy_bitmap / sizeof phy_bitmap[0]; ++g) {
		uint64_t _g = phy_bitmap[g];
		if(_g != 0xffffffffffffffff)
			for(uint8_t p = 0; p< PAGES_PER_GROUP; ++p)
				if((_g & (1 << p)) == 0) {

					phy_bitmap[g] |= (1 << p);

					ticket_lock_signal( &phy_bitmap_lock );

					if(((g * PAGES_PER_GROUP) + p) == 0)
						kprintf("ERR: ALLOCATING PAGE ZERO!!!\n");

					return (g * PAGES_PER_GROUP) + p;
				}
	}

	ticket_lock_signal( &phy_bitmap_lock );

	return 0; /* no free pages  */
}

