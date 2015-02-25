/*
 * ioapic.h
 *
 *  Created on: Jan 29, 2011
 *      Author: cds
 */

#ifndef IOAPIC_H_
#define IOAPIC_H_

#include <inttypes.h>

uint64_t ioapic_detect();
uint16_t ioapic_configure();

sint8_t ioapic_setmask_irq(uint8_t irq, sint8_t mask);
sint8_t ioapic_mask_irq(uint8_t irq);
sint8_t ioapic_unmask_irq(uint8_t irq);

struct ioapic_struct {

	struct ticket_lock 	lock;
	uint16_t 			id;
	uint8_t				irq_sys_interrupt_base;
	uint8_t				irq_redirect_size;
	void	 			*vaddr;
};

#endif /* IOAPIC_H_ */

