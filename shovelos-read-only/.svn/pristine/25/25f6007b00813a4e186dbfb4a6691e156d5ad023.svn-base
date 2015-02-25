

#ifndef __KERNEL_ARCH_X86_64_CPU_H
#define __KERNEL_ARCH_X86_64_CPU_H

#define MAX_CPU 16

struct cpu_struct {

	uint64_t flags;
	uint64_t id;
};

struct cpu_struct* 	cpu_find_this(void);
struct cpu_struct* 	cpu_find_id(uint64_t id);
void				cpu_initialise(void);


#endif /** __KERNEL_ARCH_X86_64_CPU_H ***/

