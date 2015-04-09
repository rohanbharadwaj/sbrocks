#include <sys/mmu/assemblyutil.h>
#include <sys/sbunix.h>
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
		"movq %%cr3, %%rax;"
		"movq %%rax, %0;"
		:"=g"(cr3)
		:);
	return cr3;
}

uint64_t read_cr2()
{
	uint64_t cr2;
	__asm__(
		"movq %%cr2, %%rax;"
		"movq %%rax, %0;"
		:"=g"(cr2)
		:);
	return cr2;
}

void write_cr3(uint64_t cr3)
{
	__asm__(
		"movq %0, %%rax;"
		"movq %%rax, %%cr3;"
		:
		:"g"(cr3));
}

void write_rsp(uint64_t rsp)
{
	__asm__ __volatile__("movq %[next_rsp], %%rsp" : : [next_rsp] "m" (rsp));
	/*__asm__(
		"movq %0, %%rax;"
		"movq %%rax, %%rsp;"
		:
		:"g"(rsp));*/
}

uint64_t read_rsp()
{
	uint64_t rsp;
	__asm__(
		"movq %%rsp, %%rax;"
		"movq %%rax, %0;"
		:"=g"(rsp)
		:);
	return rsp;
}
/*web reference: http://www.jamesmolloy.co.uk/tutorial_html/10.-User%20Mode.html
task.c function
*/
void switch_to_usermode(uint64_t ustack, uint64_t binary_entry)
{
	/* user data segment load in all segment registers */
	
	__asm__ __volatile__(
		"movq $0x23, %%rax;" 
		"movq %%rax, %%ds;"
		"movq %%rax, %%es;"
		"movq %%rax, %%fs;"
		"movq %%rax, %%gs;"
		"pushq $0x23;"
		"pushq %0;"
		"pushq $0x200286;"
		"pushq $0x1b;"
		"pushq %1;"
		"sti;"
		"iretq;"
		:
		:"g"(ustack), "g"(binary_entry)
	);
	
	
	/*__asm__ __volatile__(
		"movq $0x23, %rax;" 
		"movq %rax, %ds;"
		"movq %rax, %es;"
		"movq %rax, %fs;"
		"movq %rax, %gs;"
		"pushq $0x23;"
		"pushq $0x23;"
		"retq;"
		);*/
	//kprintf("after switch_to_usermode\n");
}
	
