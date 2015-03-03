/*
 * pt.h
 *
 *  Created on: Jan 10, 2011
 *      Author: cds
 */

#ifndef PT_H_
#define PT_H_

#include <inttypes.h>
#include <mm/region.h>

#include "ticket_lock.h"

struct page_table_mem {

	struct ticket_lock lock;

	uint64_t *pml4e;
	uint64_t table_stack_top;
	uint64_t table_stack_bottom;
};

struct page_table_mem* get_page_table_struct();

uint64_t virt_to_phy(uint64_t virt);
uint64_t virt_to_pde(uint64_t virt);

/* initialise page tables */
void pt_initialise(struct mm_phy_reg *regs, uint64_t regnum);

/*** add virt -> physical mapping to given page table ( null for table used kernel ) ***/
sint64_t mmap(uint64_t phy, uint64_t virt,  struct page_table_mem *tab);

/*** unmap virtual address for given tabe table ( null for table used by kernel )
 * returns old physical address
 */
uint64_t *munmap(uint64_t virt, struct page_table_mem *tab);

/*** the kenrel page tables ***/
extern struct page_table_mem kernel_page_tables;

/*** memory page size ***/
#define PAGE_SIZE 0x200000

/*** maximum number of pages supported ***/
#define PAGE_MAX 4096

/*** maximum amount of physical memory supported. ( 8 Gigabytes using above defaults ) ***/
#define MAX_PHY_MEM (PAGE_MAX * PAGE_SIZE)

/*** all available physical memory will be mapped to virtual address (physical + VIRT_OFFSET) ***/
#define VIRT_OFFSET 0xFFFF800000000000

/*** pointer arithmetic ***/
#define PHY_TO_VIRT(phy, _type) ((_type)(((uint8_t*)(uint64_t)phy) + VIRT_OFFSET))

#define VIRT_KERNEL_BASE 0xFFFFFFFF80000000

#define PT_PRESENT_FLAG  		(1<<0) // 0x01
#define PT_WRITABLE_FLAG 		(1<<1) // 0x02
#define PT_USER_FLAG     		(1<<2) // 0x04
#define PT_WRITE_THROUGH_FLAG	(1<<3) // 0x08
#define PT_TERMINAL_FLAG    	(1<<7) // 0x80
#define PT_GLOBAL_FLAG        	(1<<8) // 0x100

#endif /* PT_H_ */
