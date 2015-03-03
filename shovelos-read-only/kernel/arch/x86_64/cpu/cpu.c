/*
 * cpu.c
 *
 *  Created on: 29 Aug 2011
 *      Author: cds
 */

#include<arch/arch.h>
#include<mm/mm.h>
#include<lib/lib.h>

#define CPU_MAX 32

enum cpu_flags {

	cpu_flag_initialised = 1,
	cpu_flag_running = 2,
};

static struct cpu_struct cpus[CPU_MAX];

static struct cpu_struct* cpu_find_free_struct(void) {

	for(uint64_t i=0; i<CPU_MAX; i++)
		if(!(cpus[i].flags & cpu_flag_initialised))
			return cpus + i;

	return 0;
}

struct cpu_struct* cpu_find_id(uint64_t id) {

	for(uint64_t i=0; i<CPU_MAX; i++)
		if((cpus[i].flags & cpu_flag_initialised) && (cpus[i].id == id))
			return &cpus[i];

	return (struct cpu_struct*)0;
}

struct cpu_struct* cpu_find_this(void) {

	uint64_t id = lapic_id();
	return cpu_find_id( id );
}

void cpu_initialise(void) {

	memset(cpus, 0, sizeof cpus);

	struct cpu_struct* cpu;

	for(uint64_t apic_id = acpi_find_first_lapic_id(); apic_id != (uint64_t)-1; apic_id = acpi_find_next_lapic_id(apic_id)) {

		cpu = cpu_find_free_struct();
		cpu->id 	= apic_id;
		cpu->flags 	= cpu_flag_initialised;
	}

	cpu = cpu_find_this();
	if(!cpu)
		HALT("can't find bootstrap processor!?");

	// set bootstrap processor as running
	cpu->flags |= cpu_flag_running;
}





