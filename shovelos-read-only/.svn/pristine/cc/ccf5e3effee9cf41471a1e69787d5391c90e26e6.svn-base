/*
 * ticket_lock.c
 *
 *  Created on: 30 Jun 2011
 *      Author: Chris Stones
 */

#include "ticket_lock.h"

void ticket_lock_wait_noinline(struct ticket_lock * ticket_lock) {

	ticket_lock_wait_inline(ticket_lock);
}

void ticket_lock_signal_noinline(struct ticket_lock * ticket_lock) {

	ticket_lock_signal_inline(ticket_lock);
}

