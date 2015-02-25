
#ifndef __MEM_H
#define __MEM_H

#define PML4E_BUFFER ((uint8_t*)0x10000)
#define MB_MMAP      ((uint8_t*)0x20000) // ALSO in himem.s ( parameter 1 to kernel )
#define ADHOC_COMM   ((uint8_t*)0x30000)

#define APSTARTUP_VECTOR 0x31
#define APSTARTUP_ADDR	 ((uint8_t*)(APSTARTUP_VECTOR<<12))

#define HIGH_HEAP_BEGIN 0x32000
#define HIGH_HEAP_LIMIT 0x80000

#include <inttypes.h>

void *memcpy(void *dst,const void* src, int size);
void *memset(void* dst, int c, int s);
void *memmove(void* _dst, const void* _src, sint32_t size);

int strcmp(const char *s1, const char *s2);

int strlen(const void* s1);

int mkaddr20(int seg, void* offset);

int addds(void* offset);
int addes(void* offset);


sint8_t  peek8(const void* addr);
sint16_t peek16(const void* addr);
sint32_t peek32(const void* addr);
sint64_t peek64(const void* addr);

void poke8 (void* addr, sint8_t val);
void poke16(void* addr, sint16_t val);
void poke32(void* addr, sint32_t val);
void poke64(void* addr, sint64_t val);

#endif /*** __MEM_H ***/

