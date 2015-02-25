/*
 * string.h
 *
 *  Created on: Jan 21, 2011
 *      Author: cds
 */

#ifndef STRING_H_
#define STRING_H_

uint8_t memcmp(const void* s1, const void* s2, uint64_t len);

uint64_t strlen(const char * str);

#define memcpy __builtin_memcpy
#define memset __builtin_memset

#endif /* STRING_H_ */
