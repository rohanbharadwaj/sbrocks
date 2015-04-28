#ifndef _ASSEMBLYUTIL_H
#define _ASSEMBLYUTIL_H

#include <sys/defs.h>
#include <sys/process/process.h>

uint64_t read_cr0();
void write_cr0(uint64_t cr0);
uint64_t read_cr3();
void write_cr3(uint64_t cr3);
uint64_t read_cr2();
uint64_t read_rsp();
void write_rsp(uint64_t rsp);
void switch_to_usermode();
//void switch_to_usermode(uint64_t rsp, uint64_t rip, struct task_struct* task);
#endif