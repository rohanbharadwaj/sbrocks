/*
 * atoi.c
 *
 *  Created on: Jan 21, 2011
 *      Author: cds
 */

#include <inttypes.h>

uint8_t memcmp(const void* s1, const void* s2, uint64_t len) {

	const uint8_t *a = (const uint8_t*)s1;
	const uint8_t *b = (const uint8_t*)s2;
	uint8_t ret;

	while(len--)
		if((ret = ((*a++) - (*b++))))
			return ret;

	return 0;
}

uint64_t strlen(const char * str) {

	uint64_t ret = 0;
	while(*str++)
		++ret;
	return ret;
}

