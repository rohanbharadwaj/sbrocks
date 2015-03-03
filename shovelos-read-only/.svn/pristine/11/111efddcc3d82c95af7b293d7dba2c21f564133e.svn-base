/*
 * ticket_lock.h
 *
 *  Created on: March 12, 2011
 *      Author: cds
 */

#ifndef __X86_64_TICKET_LOCK_H
#define __X86_64_TICKET_LOCK_H

#include <inttypes.h>
#include "rflags.h"
#include "cpuid.h"

struct ticket_lock {

	volatile uint16_t queue;
	volatile uint16_t dequeue;
	uint8_t  rflag_if;
};

#define TICKET_LOCK(name) struct ticket_lock name = { 0,0,0 }

#define ticket_lock_wait 	ticket_lock_wait_noinline
#define ticket_lock_signal 	ticket_lock_signal_noinline


void ticket_lock_wait_noinline( struct ticket_lock * ticket_lock);

void ticket_lock_signal_noinline( struct ticket_lock * ticket_lock);

static inline void ticket_lock_wait_inline(struct ticket_lock * ticket_lock) {

	register uint16_t ticket;

	__asm__ __volatile__ (
			"     movw   $1,  %1;"
			"lock xaddw  %1,  %0;"
		:	"=m" (ticket_lock->queue), "=r"  (ticket)
	);

	do {
		__asm__ __volatile__ ( "pause;" );
	}while(ticket != ticket_lock->dequeue);

	ticket_lock->rflag_if = (cpu_read_rflags() & RFLAG_IF) ? 1 : 0;

	cpu_cli();
}


static inline void ticket_lock_signal_inline(struct ticket_lock * ticket_lock) {

	register uint8_t rflag_if = ticket_lock->rflag_if;

	__asm__ __volatile__ (
			"lock incw %0;"
			: "=m" (ticket_lock->dequeue)
	);

	if(rflag_if) {
		cpu_sti();
	}
}



#endif /*** __X86_64_TICKET_LOCK_H ***/

