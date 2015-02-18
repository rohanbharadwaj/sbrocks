#ifndef _SYSCALL_H
#define _SYSCALL_H

#include <sys/defs.h>
#include <sys/syscall.h>

//#define T_SYSCALL               0x80       /* System call */

static __inline uint64_t syscall_0(uint64_t n) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
                        "syscall;"
                        "movq %%rax, %0;":
                        "=rax" (ret):
                        "rax" (n):
                        "cc","memory");
         
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
			"movq %2 , %%rdi;"
			"syscall;"
			"movq %%rax, %0;":
			"=a" (ret):
			"a" (n),"b" (a1):
			"cc","memory");
	
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
                        "movq %2 , %%rdi;"
						"movq %3, %%rsi;"
                        "syscall;"
                        "movq %%rax, %0;":
                        "=a" (ret):
                        "a" (n),"b" (a1),"c" (a2):
                        "cc","memory");
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
                        "movq %2 , %%rdi;"
                        "movq %3, %%rsi;"
						"movq %4, %%rdx;"
                        "syscall;"
                        "movq %%rax, %0;":
                        "=a" (ret):
                        "a" (n),"b" ((uint64_t)(a1)),"c" ((uint64_t)(a2)),"d" ((uint64_t)(a3)):
                        "cc","memory"); 
        return ret;
}

#endif
