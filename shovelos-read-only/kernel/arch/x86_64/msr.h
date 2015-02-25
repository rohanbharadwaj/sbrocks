/*
 * msr.h
 *
 *	x86_64 model specific register
 *
 *  Created on: 3 Feb 2011
 *      Author: Chris Stones
 */

#ifndef MSR_H_
#define MSR_H_

#include<inttypes.h>

#define IA32_APIC_BASE (0x0000001B)


/*** read a 64bit model specific register from x86_64 cpu ***/
static inline uint64_t cpu_rdmsr64( uint32_t ecx ) {

    uint32_t edx,eax;
    uint64_t ret;

    __asm__ __volatile__(
	"movl %2, %%ecx;"
        "rdmsr;"
        "mov %%eax, %0;"
        "mov %%edx, %1;"
        :"=r" (eax), "=r" (edx)
        : "r" (ecx)
        : "rax", "rdx", "rcx");

    ret   = edx;
    ret <<=  32;
    ret  |= eax;

    return ret;
}

/*** write a 64bit model specific register to x86_64 cpu ***/
static inline void cpu_wrmsr64( uint32_t ecx, uint64_t edx_eax ) {

    uint32_t eax = edx_eax  & 0xffffffff;
    uint32_t edx = edx_eax >> 32;

    __asm__ __volatile__(
	"movl %0, %%ecx;"
        "movl %1, %%eax;"
        "movl %2, %%edx;"
        "wrmsr;"
        :/* no output */
        :"r" (ecx), "r" (eax), "r" (edx)
        : "rcx", "rax", "rdx" );
}


#if(need_testing)
/*** read a 32bit model specific register from x86_64 cpu ***/
static inline uint32_t cpu_rdmsr32( uint32_t ecx ) {

    uint32_t eax;

    __asm__ __volatile__(
    	"movl %1, %%ecx;"
        "rdmsr;"
        "mov %%eax, %0;"
        : "=a" (eax)
        :  "r" (ecx)
        : "ecx" );

    return eax;
}



/*** write a 32bit model specific register to x86_64 cpu ***/
static inline void cpu_wrmsr32( uint32_t ecx, uint32_t eax ) {

    __asm__ __volatile__(
	"movl %0, %%ecx;"
        "movl %1, %%eax;"
        "wrmsr;"
        :/* no output */
        :"r" (ecx), "r" (eax));
}

#endif

#endif /* MSR_H_ */
