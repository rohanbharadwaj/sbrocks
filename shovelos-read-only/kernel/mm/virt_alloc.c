/*
 * virt_alloc.c
 *
 *  Created on: March 19, 2011
 *      Author: cds
 */

#include<inttypes.h>
#include<arch/arch.h>
#include "mm.h"

void *vmm_alloc_hw(uint64_t size) {

	static TICKET_LOCK(tlock);
	static uint64_t base = VMM_HWMMAP_BASE;

	uint64_t pages = (size % PAGE_SIZE) ? (size / PAGE_SIZE) + 1 : size / PAGE_SIZE;
	void     *vmem = 0;

	ticket_lock_wait(&tlock);
	    if((base + size) < (VMM_HWMMAP_BASE + VMM_HWMMAP_SIZE)) {
	    	vmem = (void*)base;
			base += PAGE_SIZE * (pages+1);
	    }
	ticket_lock_signal(&tlock);

	return vmem;
}



