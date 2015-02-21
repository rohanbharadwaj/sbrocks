#ifndef _IRQ_H
#define _IRQ_H

#include <sys/ioport.h>
#include <sys/sbunix.h>
#include <sys/idt.h>


void irq_install_handler(int irq, void (*handler)());
void irq_uninstall_handler(int irq);
void install_irqs();
#endif