/*
 * phy_alloc.h
 *
 *  Created on: Jan 8, 2011
 *      Author: cds
 */

#ifndef PHY_ALLOC_H_
#define PHY_ALLOC_H_

#include <mm/mm.h>
#include <arch/arch.h>
#include <inttypes.h>

void mm_phy_init(struct mm_phy_reg *regs, uint64_t regnum);

uint64_t mm_phy_alloc_page() ;

void     mm_phy_free_page(uint64_t page);

static inline uint64_t mm_phy_to_page(uint64_t phy) {

	return phy / PAGE_SIZE;
}

static inline uint64_t mm_page_to_phy(uint64_t page) {

	return page * PAGE_SIZE;
}

#endif /* PHY_ALLOC_H_ */

