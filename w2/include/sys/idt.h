#ifndef _IDT_H
#define _IDT_H

#include <sys/kstring.h>
#include <sys/defs.h>
#include <sys/timer.h>

void idt_set_gate(int32_t num, uint64_t base, uint16_t sel, uint8_t flags);
void idt_install();
void irq_remap();

#endif