#include <sys/mmu/assemblyutil.h>

uint64_t read_cr0()
{
	uint64_t cr0;
	__asm__(
		"movq %%cr0, %%rax;"
		"movq %%rax, %0;"
		:"=g"(cr0)
		:);
	return cr0;
}
void write_cr0(uint64_t cr0)
{
	__asm__(
		"movq %0, %%rax;"
		"movq %%rax, %%cr0;"
		:
		:"g"(cr0));
}
uint64_t read_cr3()
{
	uint64_t cr3;
	__asm__(
		"movq %%cr0, %%rax;"
		"movq %%rax, %0;"
		:"=g"(cr3)
		:);
	return cr3;
}
void write_cr3(uint64_t cr3)
{
	__asm__(
		"movq %0, %%rax;"
		"movq %%rax, %%cr3;"
		:
		:"g"(cr3));
}