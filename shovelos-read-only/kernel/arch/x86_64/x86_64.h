/*
 * x86_64.h
 *
 *  Created on: Dec 31, 2010
 *      Author: cds
 */

#ifndef ARCH_X86_64_H_
#define ARCH_X86_64_H_

#include <inttypes.h>
#include "rflags.h"
#include "cpuid.h"
#include "msr.h"
#include "8259.h"
#include "ticket_lock.h"
#include "pt.h"
#include "semaphore.h"
#include "acpi/acpi.h"
#include "cpu/cpu.h"
#include "hpet.h"
#include "console.h"
#include "ioapic/ioapic.h"
#include "lapic/lapic.h"
#include "cpu/cpu.h"
#include "kbc.h"
#include "ports.h"
#include "kbc_scancodes.h"
#include "isr.h"

struct isr_error_stack_frame
{
	uint64_t error;
	uint64_t rip;
	uint64_t cs;
	uint64_t rflags;
	uint64_t rsp;
	uint64_t ss;
};

struct isr_stack_frame
{
	uint64_t rip;
	uint64_t cs;
	uint64_t rflags;
	uint64_t rsp;
	uint64_t ss;
};

struct isr_pf_stack_frame
{
	union {

		uint64_t reserved;
		struct {
			unsigned p 		: 1;
			unsigned wr 	: 1;
			unsigned us 	: 1;
			unsigned rsvd 	: 1;
			unsigned id 	: 1;
		}error;
	}error;
	uint64_t rip;
	uint64_t cs;
	uint64_t rflags;
	uint64_t rsp;
	uint64_t ss;
};

/*** todo: better home ***/

#define KBC_IRQ 1

typedef void (*main_func)(int argc, char **argv);
void call_main(main_func, void* stack, int argc, char **argv);


int  kprintf(const char * fmt, ...);

void _x86_64_load_gdt();
void _x86_64_asm_lgdt(void* gdtr, uint64_t cs, uint64_t ds);

void _x86_64_asm_lidt(void* gdtr);
void _x86_64_load_idt() ;

void _8259_remap(uint8_t off1, uint8_t off2);
void _8259_disable();

#endif /* ARCH_X86_64_H_ */

