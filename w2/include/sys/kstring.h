#ifndef _KSTRING_H
#define _KSTRING_H

#include <stdlib.h>

size_t strlen(const char * str);
void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n);
unsigned short *memsetw(unsigned short *dest, unsigned short val, int count);
void *memset(void *str, int c, size_t n);
#endif