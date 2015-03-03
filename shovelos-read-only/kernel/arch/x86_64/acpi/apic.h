

#ifndef __ACPI_APIC_H
#define __ACPI_APIC_H

#include<inttypes.h>

uint64_t acpi_find_first_lapic_id();
uint64_t acpi_find_next_lapic_id(uint64_t last);

uint64_t acpi_find_first_ioapic_id();
uint64_t acpi_find_next_ioapic_id(uint64_t last);
uint64_t acpi_find_ioapic_address(uint64_t id);
uint64_t acpi_find_ioapic_system_interrupt_base(uint64_t id);


#endif /*** __ACPI_APIC_H ***/

