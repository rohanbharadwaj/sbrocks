/*
 * stdlib.c
 *
 *  Created on: Jan 25, 2011
 *      Author: cds
 */

#include<inttypes.h>
#include"kprintf.h"

static uint8_t isnum(char c) {

	return c >= '0' && c <= '9';
}

static uint64_t declen(const char *str) {

	uint64_t ret=0;

	if(*str == '-') {
		if(isnum(*(str+1))) {
			ret+=2;
			str+=2;
		}
		else
			return 0;
	}

	while(isnum(*str++))
		ret++;

	return ret;
}

uint8_t sum(const void * _data, uint64_t len) {

	uint8_t sum = 0;
	const uint8_t *data = (const uint8_t *)_data;

	while(len--)
		sum += *data++;

	return sum;
}

void halt(const char *reason, const char * const file, const char * const function, uint32_t line) {

	kprintf("%s %s:%d\n",file,function,line);
	if(reason && *reason)
		kprintf("%s\n",reason);
	kprintf("HALT");
	for(;;);
}

sint64_t atoq(const char * str) {

	sint32_t ret    = 0;
	uint8_t negflag = 0;
	uint16_t power  = 1;

	for(const char *c = str + declen(str)-1; c>=str; c--, power*=10)
		switch(*c) {
			default:
				return negflag ? -ret : ret;
			case '-':
				if(negflag)
					return 0;
				negflag = 0;
				break;

			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
			case '8':
			case '9':
				ret += power * ((uint64_t)(*c - '0'));
			case '0':
				break;
		}

	return negflag ? -ret : ret;
}

sint64_t atoll(const char * str) {
	return atoq(str);
}

sint32_t atoi(const char * str) {

	sint64_t r64 = atoq(str);
	sint32_t r32 = r64 & 0x7fffffff;

	return r64<0 ? -r32 : r32;
}

