#ifndef _ASSEMBLYUTIL_H
#define _ASSEMBLYUTIL_H

#include <sys/defs.h>

uint64_t read_cr0();
void write_cr0(uint64_t cr0);
uint64_t read_cr3();
void write_cr3(uint64_t cr3);

#endif