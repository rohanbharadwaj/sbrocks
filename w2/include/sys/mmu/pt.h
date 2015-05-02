#ifndef _PT_H
#define _PT_H

#include <sys/defs.h>
#include <sys/mmu/phy_alloc.h>
#include <sys/sbunix.h>
#include <sys/mmu/assemblyutil.h>
#include <sys/mmu/virtual_mm.h>

#define PAGE_TABLE_ALIGNLENT 0x1000     //4096 in decm

#define PAGE_SIZE 4096
//max no of pages supported
#define PAGE_MAX 32510
//#define VIRT_KERNEL_BASE 0xffffffff80000000
/*** all available physical memory will be mapped to virtual address (physical + VIRT_OFFSET) ***/
#define VIRT_KERNEL_BASE   0xFFFFFFFF80000000
#define ONE_ON_ONE_MAPPING 0xFFFFFFFF00000000
/*** pointer arithmetic ***/

#define PT_PRESENT_FLAG  (1<<0) // 0x01
#define PT_WRITABLE_FLAG (1<<1) // 0x02
#define PT_PCF_FLAG      (1<<4) // 0x08
#define PT_USER          (1<<2)	// 0x04

#define PHY_TO_VIRT(phy, _type) ((_type)(((uint64_t)phy + ONE_ON_ONE_MAPPING)))

//#define ALIGN_DOWN(x)   ((x) & ~(PAGE_TABLE_ALIGNLENT-1))
#define ALIGN_UP(x)     (((x) & (PAGE_TABLE_ALIGNLENT-1)) ? ALIGN_DOWN(x+PAGE_TABLE_ALIGNLENT) : (x))
#define ALIGN_DOWN(x) ((x) >> 12 << 12)
#define LOAD_CR3(lcr3) __asm__ __volatile__ ("movq %0, %%cr3;" :: "r"(lcr3));


uint64_t KADDR(uint64_t paddr);
//uint64_t PADDR(uint64_t vddr);
uint64_t kernmem_mapping(uint64_t virt, uint64_t pbase, uint64_t noofpages, uint64_t pml4e);
void map_all_phy(uint64_t k_cr3);
uint64_t virt_to_phy(uint64_t virt, uint64_t pml4e);
uint64_t getCR3();
void map_virt_to_phy(uint64_t virt, uint64_t phy, uint64_t flags);
void setup_paging(uint64_t phybase, uint64_t physfree);
void initialize_new_pml4e(uint64_t pml4e);
uint64_t env_setup_vm();
void free_page_tables(uint64_t pml4e);
void unmap_phy(uint64_t virt);
uint64_t *get_pte_entry(uint64_t virt);
void set_writable_bit(uint64_t *pte);
void reset_writable_bit(uint64_t *pte);
void set_cow_bit(uint64_t *pte);
void reset_cow_bit(uint64_t *pte);
uint64_t is_cow_set(uint64_t *pte);
uint64_t is_writable_page(uint64_t *pte);
#endif