#ifndef _PHY_ALLOC_H
#define _PHY_ALLOC_H
#include <sys/mmu/pt.h>
#include <sys/defs.h>
#include <sys/mmu/assemblyutil.h>
//#include <sys/mmu/region.h>

#include <sys/kstring.h>

static inline uint64_t mm_phy_to_page(uint64_t phy) {

        return phy / 4096;
}

static inline uint64_t mm_page_to_phy(uint64_t page) {
		
        return page * 4096;
}

void mm_phy_init(uint64_t base, uint64_t length, uint64_t type);

uint64_t mm_phy_alloc_page();
void mm_phy_free_page(uint64_t page);

#endif