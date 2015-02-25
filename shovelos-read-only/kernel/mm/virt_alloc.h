/*
 * virt_alloc.h
 *
 *  Created on: March 19, 2011
 *      Author: cds
 */

#ifndef __MM_VIRT_ALLOC_H
#define __MM_VIRT_ALLOC_H

#include<arch/arch.h>

/***
 * with 2 meg pages, one PML4 entry maps 512 gigabytes
 *
 * PHY
 * HWMAP
 * SHARED TEXT
 * SHARED HEAP
 * K TEXT
 * K HEAP
 * K STACK
 *
 *
 * U TEXT
 * U HEAP
 * U SHARED
 ****/

#define VMM_PHY_BASE 			(0xffff800000000000)
#define VMM_PHY_SIZE            (0x0000008000000000) /* 512 gig (one PLM2 entry with 2 meg pages) */

#define VMM_HWMMAP_BASE 		(0xffffa00000000000)
#define VMM_HWMMAP_SIZE         (0x0000008000000000) /* 512 gig (one PLM2 entry with 2 meg pages) */

#define VMM_SHM_TEXT_BASE 		(0xffffb00000000000)
#define VMM_SHM_TEXT_SIZE       (0x0000008000000000) /* 512 gig (one PLM2 entry with 2 meg pages) */

#define VMM_SHM_HEAP_BASE 		(0xffffc00000000000)
#define VMM_SHM_HEAP_SIZE       (0x0000008000000000) /* 512 gig (one PLM2 entry with 2 meg pages) */

#define VMM_K_STACK_BASE		(0xffffd00000000000)
#define VMM_K_STACK_SIZE        (0x0000008000000000)

#define VMM_K_HEAP_BASE			(0xffffe00000000000)
#define VMM_K_HEAP_SIZE         (0x0000008000000000)

#define VMM_K_TEXT_BASE			(0xFFFFFFFF80000000)
#define VMM_K_TEXT_SIZE         (0x0000000080000000) /* 2 gig */


void *vmm_alloc_hw(uint64_t size);



#endif /*** __MM_VIRT_ALLOC_H ***/



/*** thinking space ***

 struct process {

     uint64_t pid;
     uint64_t uid;
     uint64_t stack_top;
     uint64_t stack_bot;
     uint64_t heap_top;
     uint64_t heap_bot;
     uint64_t text_top;
     uint64_t text_bot;

 };

struct

struct memory_namespace {

};


 */
