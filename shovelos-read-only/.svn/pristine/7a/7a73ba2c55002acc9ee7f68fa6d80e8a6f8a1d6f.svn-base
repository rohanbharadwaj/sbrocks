/*
 * stdlib.h
 *
 *  Created on: Jan 25, 2011
 *      Author: cds
 */

#ifndef __STDLIB_H
#define __STDLIB_H

sint64_t atoq(const char * str);
sint64_t atoll(const char * str);
sint32_t atoi(const char * str);

uint8_t sum(const void * _data, uint64_t len);

void halt(const char *reason, const char * const file, const char * const function, uint32_t line);

#define HALT(reason) halt(reason,__FILE__,__FUNCTION__,__LINE__)

#endif /*** __STDLIB_H ***/

