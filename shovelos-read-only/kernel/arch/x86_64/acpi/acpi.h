/*
 * acpi.h
 *
 *  Created on: Jan 23, 2011
 *      Author: cds
 */

#ifndef ACPI_H_
#define ACPI_H_

struct acpi_header {

	sint8_t signature[4];
	uint32_t length;
	uint8_t revision;
	uint8_t checksum;
	sint8_t oemid[6];
	sint8_t oem_table_id[8];
	uint32_t oem_revision;
	sint8_t creator_id[4];
	uint32_t creator_revision;

} __attribute__((packed)) ;

#include "apic.h"

const void* acpi_find_first_table(const char * header);
const void* acpi_find_next_table(const void *last, const char * header);

#endif /* ACPI_H_ */

