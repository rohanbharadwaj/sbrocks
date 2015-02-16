#ifndef _STRING_H
#define _STRING_H
#include<stdlib.h>

#define ISSPACE " \t\n\r\f\v"

char *strcpy(char *dest, const char *src);
size_t strlen(const char *str);
char *strtok(char *str, const char *delim);
int strcmp(const char *s1, const char *s2);
char *strstr(const char *haystack, const char *needle);
char *strcat(char *dest, const char *src);
int sscanf(const char *str, const char *format, ...);
char *strncpy(char *dest, const char *src, size_t n);
size_t strnlen(const char *s, size_t maxlen);
int isspace(char c);
char *strchr(const char *s, int c);
int isdigit(int ch);
size_t strcspn(const char *s, const char *reject);
void reset(char str[], int len);
void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n);
int memcmp(const void* s1, const void* s2,size_t n);
int atoi(const char *str);
int64_t htol(char *str);
#endif

