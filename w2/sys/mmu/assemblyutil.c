#include <sys/mmu/assemblyutil.h>
#include <sys/sbunix.h>
uint64_t read_cr0()
{
	uint64_t cr0;
	__asm__ __volatile__(
/*		"movq %%cr0, %%rax;"
		"movq %%rax, %0;"
*/
		"movq %%cr0, %0;"
		:"=g"(cr0)		
		
		:);
	return cr0;
}
void write_cr0(uint64_t cr0)
{
	#if 0
	__asm__ __volatile__(
/*		
		"movq %0, %%rax;"
		"movq %%rax, %%cr0;"
*/
		"movq %0, %%cr0;"		
		:
		:"g"(cr0));
	#endif
}
uint64_t read_cr3()
{
	uint64_t cr3;
	__asm__ __volatile__(
		/*
		"movq %%cr3, %%rax;"
		"movq %%rax, %0;"
		*/
		"movq %%cr3, %0;"
		:"=g"(cr3)
		:);
	return cr3;
}

uint64_t read_cr2()
{
	uint64_t cr2;
	__asm__ __volatile__(
		"movq %%cr2, %0;"
		//"movq %%rax, %0;"
		:"=g"(cr2)
		:);
	return cr2;
}

void write_cr3(uint64_t cr3)
{
	__asm__ __volatile__(
//		"movq %0, %%rax;"
//		"movq %%rax, %%cr3;"
		"movq %0, %%cr3;"
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
	__asm__ __volatile__(
//		"movq %%rsp, %%rax;"
//		"movq %%rax, %0;"
		"movq %%rsp, %0;"
		:"=g"(rsp)
		:);
	return rsp;
}

extern void irq0();
/*web reference: http://www.jamesmolloy.co.uk/tutorial_html/10.-User%20Mode.html
task.c function
*/
void switch_to_usermode(uint64_t rsp, uint64_t rip, struct task_struct *task)
{
	/* user data segment load in all segment registers */
	
		__asm__ __volatile__(
		"movq $0x23, %%rax;" 
		"movq %%rax, %%ds;"
		"movq %%rax, %%es;"
		"movq %%rax, %%fs;"
		"movq %%rax, %%gs;"
		"movq $0, %%rax;"
		"movq $0, %%rbx;"
		/*"popq %%r15;"
		"popq %%r15;"
		"popq %%r15;"
		"popq %%r15;"
		"popq %%r15;"
		"popq %%r14;"
		"popq %%r13;"
		"popq %%r12;"
		"popq %%r11;"
		"popq %%r10;"
		"popq %%r9;"		
		"popq %%r8;"		
		"popq %%rsi;"
		"popq %%rbp;"
		"popq %%rdx;"
		"popq %%rcx;"
		"popq %%rbx;"
		"popq %%rdi;"
		"popq %%rdi;"*/
		"pushq $0x23;"            //ss
		"pushq %0;"				  //esp
		"pushq $0x200286;"        //rflags
		"pushq $0x1b;"			  //cs
		"pushq %1;"				  //eip
		
		//"sti;"
		//"iretq;"
		:
		:"g"(rsp), "g"(rip)
	);
	#if 0
	int i = 1;
	while(task->kstack[KSTACK_SIZE - i] == 0)
	{
		i++;
		if(i > 5)
			break;
	}
	if(i>=5)	
	{
		__asm__ __volatile__("sti;" : :);
		__asm__ __volatile__("iretq;" : :);	
	}
	else
	{
		kprintf("%d \n", i);
		__asm__ __volatile__(
			"movq %0, %%rax;"
			"movq %1, %%rbx;"
			"movq %2, %%rcx;"
			"movq %3, %%rdx;"
			"movq %4, %%rbp;"
			"movq %5, %%rsi;"
			"movq %6, %%r8;"
			"movq %7, %%r9;"
			"movq %8, %%r10;"
			"movq %9, %%r11;"
			"movq %10, %%r12;"
			"movq %11, %%r13;"
			"movq %12, %%r14;"
			"movq %13, %%r15;"
			:
			:"g"(task->kstack[KSTACK_SIZE - i - 6]), 
			"g"(task->kstack[KSTACK_SIZE - i - 7]), 
			"g"(task->kstack[KSTACK_SIZE - i - 8]), 
			"g"(task->kstack[KSTACK_SIZE - i - 9]),
			"g"(task->kstack[KSTACK_SIZE - i - 10]),
			"g"(task->kstack[KSTACK_SIZE - i - 11]),
			"g"(task->kstack[KSTACK_SIZE - i - 12]),
			"g"(task->kstack[KSTACK_SIZE - i - 13]),		
			"g"(task->kstack[KSTACK_SIZE - i - 14]),
			"g"(task->kstack[KSTACK_SIZE - i - 15]),
			"g"(task->kstack[KSTACK_SIZE - i - 16]),
			"g"(task->kstack[KSTACK_SIZE - i - 17]),
			"g"(task->kstack[KSTACK_SIZE - i - 18]),
			"g"(task->kstack[KSTACK_SIZE - i - 19])
		);
		__asm__ __volatile__("sti;" : :);
		__asm__ __volatile__("iretq;" : :);
	}
	#endif
	
	//__asm__ __volatile__("call irq0;" : :);
	
	//__asm__ __volatile__("sti;" : :);
	//__asm__ __volatile__("iretq;" : :);
	/*__asm__ __volatile__(
		"movq $0x23, %rax;" 
		"movq %rax, %ds;"
		"movq %rax, %es;"
		"movq %rax, %fs;"
		"movq %rax, %gs;"
		"pushq $0x23;"
		"pushq $0x23;"
		"retq;"
		
		
		"popq %%r15;"
		"popq %%r15;"
		"popq %%r15;"
		"popq %%r15;"
		"popq %%r15;"
		"popq %%r14;"
		"popq %%r13;"
		"popq %%r12;"
		"popq %%r11;"
		"popq %%r10;"
		"popq %%r9;"		
		"popq %%r8;"		
		"popq %%rsi;"
		"popq %%rbp;"
		"popq %%rdx;"
		"popq %%rcx;"
		"popq %%rbx;"
		"popq %%rdi;"
		"popq %%rdi;"
		
		
		
		);*/
	//kprintf("after switch_to_usermode\n");
}
	
