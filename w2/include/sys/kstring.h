#ifndef _KSTRING_H
#define _KSTRING_H

#include <stdlib.h>
int kstrcmp(const char *cs, const char *ct);
size_t strlen(const char * str);
void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n);
//void *memcpy(void *destination, void *source, uint64_t num);
void *memsetw(void *dest, unsigned short val, uint64_t count);
void *memset(void *str, int c, size_t n);
const char *byte_to_binary(uint64_t x);
char *strcat(char *dest, const char *src);
int atoi(const char *str);
uint64_t octal_to_decimal(int oct);
char *kstrcpy(char *dest, const char *src);
char *kstrncpy(char *dest, const char *src, size_t count);
int kstrncmp(const char *cs, const char *ct,uint64_t size);
#endif