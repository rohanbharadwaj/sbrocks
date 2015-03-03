/*
 * rflags.h
 *
 *  Created on: March 16, 2011
 *      Author: cds
 */

#ifndef __ARCH_X86_64_RFLAGS_H
#define __ARCH_X86_64_RFLAGS_H

#define RFLAG_CF 			(1<<0)
#define RFLAG_PF 			(1<<2)
#define RFLAG_AF 			(1<<4)
#define RFLAG_ZF 			(1<<6)
#define RFLAG_SF 			(1<<7)
#define RFLAG_TF 			(1<<8)
#define RFLAG_IF 			(1<<9)
#define RFLAG_DF 			(1<<10)
#define RFLAG_OF 			(1<<11)
#define RFLAG_IOPL      	((1<<12)|(1<<13))
#define RFLAG_NT 			(1<<14)
#define RFLAG_RF 			(1<<16)
#define RFLAG_VM 			(1<<17)
#define RFLAG_AC 			(1<<18)
#define RFLAG_VIF 			(1<<19)
#define RFLAG_VIP 			(1<<20)
#define RFLAG_ID 			(1<<21)

static inline uint64_t cpu_read_rflags() {

	uint64_t rflags;

	__asm__ __volatile__(
			"pushfq;"
			"movq (%%rsp), %0;"
			"addq  $8, %%rsp;"
			: "=a" (rflags)
			: /* no input */
			);

	return rflags;
}

static inline void cpu_write_rflags(uint64_t rflags) {

	__asm__ __volatile__(
			"pushq %0;"
			"popfq;"
		: 	/* no output */
		:	"D" (rflags) );
}

#endif /***  __ARCH_X86_64_RFLAGS_H ***/


