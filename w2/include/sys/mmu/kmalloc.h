#ifndef _KMALLOC_H
#define _KMALLOC_H

#include <sys/sbunix.h>
#include <sys/mmu/pt.h>
#include <sys/mmu/virtual_mm.h>

#define no_of_pages 512;
void init_kmalloc();
void *kmalloc(uint64_t size);
void kfree(uint64_t vaddr, uint64_t size);
void test_malloc();
#endif