

#include "16bitreal.h"
#include "alloc.h"
#include "mem.h"
#include "print.h"

#include<inttypes.h>

extern int _heap_start;

int read_sp();
__asm__("read_sp:                \n"
		"movl %esp, %eax         \n"
		"ret");

void *alloc(unsigned short size) {

	void *ret = (void*)(int)_heap_start;
	int  sp = read_sp();

	if(_heap_start + size >= sp) {
		printf("alloc(0x%x) err! heap(0x%x)=0x%x, stack=0x%x\n",size, &_heap_start,_heap_start, sp);
		halt("");
	}

	_heap_start += size;

	return ret;
}

void *zalloc(unsigned short size) {

	void *ret = alloc(size);

	memset(ret,0,size);

	return ret;
}

void *zalloc_align(unsigned short boundary, unsigned short size) {

	// move heap start to next boundary.
	if((int)alloc(0) % boundary)
		alloc(boundary - ((unsigned int)alloc(0) % boundary));

	return zalloc(size);
}

static int high_begin = (int)HIGH_HEAP_BEGIN;
static int high_limit = (int)HIGH_HEAP_LIMIT;

void* alloc_high(uint16_t size) {

	int t = high_begin;
			high_begin += size;

	if((high_begin) > high_limit)
		halt("out of high memory!");

	return (void*)t;
}

