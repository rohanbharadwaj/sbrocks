#ifndef _VIRTUAL_MM_H
#define _VIRTUAL_MM_H

#include <sys/sbunix.h>
#include <sys/mmu/phy_alloc.h>
#include <sys/mmu/pt.h>

void init_virtual_memory(uint64_t virtual_start_address);
uint64_t alloc_pages(uint64_t no_of_pages, uint64_t flags);
uint64_t alloc_pages_at_virt(uint64_t virt, uint64_t no_of_pages, uint64_t flags);
void free_pages(uint64_t addr);
void reset_page_tables(uint64_t pml4e);
#endif