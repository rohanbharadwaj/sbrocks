#ifndef _PROCESS_MANAGER_H
#define _PROCESS_MANAGER_H
#include<sys/defs.h>
#include<sys/process/process.h>
#include <sys/mmu/assemblyutil.h>
#include <sys/gdt.h>

void load_process(struct task_struct* task, uint64_t binary_entry, uint64_t ustack);
void schedule_process();
struct task_struct* get_current_task();
void set_current_task(struct task_struct* task);
//struct task_struct* current_task = NULL;
#endif