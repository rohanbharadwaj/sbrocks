/*
 * lapic.h
 *
 *  Created on: Apr 2, 2011
 *      Author: cds
 */

#ifndef __ARCH_X86_64_LAPIC_H
#define __ARCH_X86_64_LAPIC_H

#include <inttypes.h>

enum apic_base_msr {

	APIC_BSP_FLAG = (1<<8),
	APIC_GLOBAL_ENABLE_FLAG = (1<<11),
};

typedef union {

	uint32_t _register;
	uint64_t _128bits[2];

} _128bit_aligned_uint32;

struct local_apic_struct {

	const	_128bit_aligned_uint32		reserved_00[2];
	const	_128bit_aligned_uint32		id;
	const	_128bit_aligned_uint32		version;
	const	_128bit_aligned_uint32		reserved_01[4];
			_128bit_aligned_uint32		task_priority;
	const	_128bit_aligned_uint32		arbitration_priority;
	const	_128bit_aligned_uint32		processor_priority;
			_128bit_aligned_uint32		end_of_interrupt;
	const	_128bit_aligned_uint32		remote_read;
			_128bit_aligned_uint32		local_destination;
			_128bit_aligned_uint32		destination_format;
			_128bit_aligned_uint32		spurious_interrupt_vector;
	const	_128bit_aligned_uint32		in_service[8];
	const	_128bit_aligned_uint32		trigger_mode[8];
	const	_128bit_aligned_uint32		interrupt_request[8];
	const	_128bit_aligned_uint32		error_status;
	const	_128bit_aligned_uint32		reserved_02[6];
			_128bit_aligned_uint32		lvt_cmci;
			_128bit_aligned_uint32		interrupt_command[2];
			_128bit_aligned_uint32		lvt_timer;
			_128bit_aligned_uint32		lvt_thermal_sensor;
			_128bit_aligned_uint32		lvt_performance_monitoring_counters;
			_128bit_aligned_uint32		lvt_lint0;
			_128bit_aligned_uint32		lvt_lint1;
			_128bit_aligned_uint32		lvt_error;
			_128bit_aligned_uint32		initial_count;
	const	_128bit_aligned_uint32		current_count;
	const	_128bit_aligned_uint32		reserved_03[4];
			_128bit_aligned_uint32		divide_configuration;
	const	_128bit_aligned_uint32		reserved_04;
};

struct lapic_interrupt_command {

	unsigned 		vector : 8;					/* rw */
	unsigned 		message_type : 3;			/* rw */
	unsigned 		destination_mode : 1;		/* rw */
	unsigned		delivery_status : 1;		/* ro */
	unsigned  		reserved0 : 1;
	unsigned  		level : 1 ;					/* rw */
	unsigned  		trigger_mode : 1 ;			/* rw */
	unsigned 		remote_read_status : 2; 	/* ro */
	unsigned		destination_shorthand : 2;  /* rw */
	unsigned		reserved1 : 32;
	unsigned		reserved2 : 4;
	unsigned		destination : 8;				/* rw */
} __attribute__((__packed__)) ;

typedef union  {

	uint64_t						_register;
	struct lapic_interrupt_command 	bits;


} lapic_ipi_register;

enum lapic_ipi_enum {

	LAPIC_IPI_TRIGGERMODE_EDGE  = 0,
	LAPIC_IPI_TRIGGERMODE_LEVEL = 1,

	LAPIC_IPI_MESSAGETYPE_INIT = 5,
	LAPIC_IPI_MESSAGETYPE_STARTUP = 6,

	LAPIC_DESTINATION_MODE_LOGICAL = 1,
	LAPIC_DESTINATION_MODE_PHYSICAL = 0,
};


void lapic_configure();
void lapic_eoi(uint32_t vector);
void lapic_ipi_start(uint8_t lapic_id, void* address);
uint64_t lapic_id();

#endif /*** __ARCH_X86_64_LAPIC_H ***/

