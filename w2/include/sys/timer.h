#ifndef _TIMER_H
#define _TIMER_H

#include <sys/ioport.h>
#include <sys/sbunix.h>
#include <sys/irq.h>
#include <sys/process/process_manager.h>

#define FREQUENCY 100

void timer_phase(int hz);
void timer_install();
void timer_handler(struct regs *r);
#endif