/*
 * isr.c
 *
 *  Created on: 3 Jul 2011
 *      Author: cds
 */

#include<arch/arch.h>
#include<lib/lib.h>

#define INTERRUPT(vector) \
	__asm__(".global x86_64_isr_vector" #vector "\n"\
			"x86_64_isr_vector" #vector ":\n" \
			"    pushq %rax;" \
			"    pushq %rcx;" \
			"    pushq %rdx;" \
			"    pushq %rsi;" \
			"    pushq %rdi;" \
			"    pushq %r8;" \
			"    pushq %r9;" \
			"    pushq %r10;" \
			"    pushq %r11;" \
			"    movq  %rsp,%rdi;" \
			"    addq  $72, %rdi;"  \
			"    call x86_64_handle_isr_vector" #vector ";" \
			"    popq %r11;" \
			"    popq %r10;" \
			"    popq %r9;" \
			"    popq %r8;" \
			"    popq %rdi;" \
			"    popq %rsi;" \
			"    popq %rdx;" \
			"    popq %rcx;" \
			"    popq %rax;" \
	"iretq;")

INTERRUPT(0);	// divide by zero
INTERRUPT(1);
INTERRUPT(2);
INTERRUPT(3);
INTERRUPT(4);
INTERRUPT(5);
INTERRUPT(6);
INTERRUPT(7);
INTERRUPT(8);
INTERRUPT(9);
INTERRUPT(10);
INTERRUPT(11);
INTERRUPT(12);
INTERRUPT(13);
INTERRUPT(14);
INTERRUPT(15);
INTERRUPT(16);
INTERRUPT(17);
INTERRUPT(18);
INTERRUPT(19);
INTERRUPT(20);
INTERRUPT(21);
INTERRUPT(22);
INTERRUPT(23);
INTERRUPT(24);
INTERRUPT(25);
INTERRUPT(26);
INTERRUPT(27);
INTERRUPT(28);
INTERRUPT(29);
INTERRUPT(30);
INTERRUPT(31);


/*** IRQ-1 (keyboard) ***/
INTERRUPT(64);
void x86_64_handle_isr_vector64( struct isr_stack_frame *stack) {

	kbc_irq();
	lapic_eoi(64);
}

void x86_64_handle_isr_vector0(struct isr_stack_frame *stack) {

	kprintf("DIVIDE ERROR EXCEPTION!\n");
	kprintf("    CS:0x%x\n",stack->cs);
	kprintf("   RIP:0x%x\n",stack->rip);

	HALT("");
}

void x86_64_handle_isr_vector8(struct isr_error_stack_frame *stack) {

	kprintf("DOUBLE FAULT!\n");
	kprintf("   ERR:%d\n",stack->error);
	kprintf("    CS:0x%x\n",stack->cs);
	kprintf("   RIP:0x%lx\n",stack->rip);

	HALT("");
}

// TODO - what does thispush onto the stack ?
void x86_64_handle_isr_vector11(struct isr_error_stack_frame *stack) {

	kprintf("SEGMENT NOT PRESENT!\n");
	kprintf("    CS:0x%x\n",stack->cs);
	kprintf("   RIP:0x%lx\n",stack->rip);

	HALT("");
}

void x86_64_handle_isr_vector13(struct isr_error_stack_frame *stack) {

	kprintf("GENERAL PROTECTION EXCEPTION!\n");
	kprintf("    CS:0x%x\n",stack->cs);
	kprintf("   RIP:0x%lx\n",stack->rip);

	HALT("");
}

void x86_64_handle_isr_vector14(struct isr_pf_stack_frame *stack) {

	uint64_t vaddr = cpu_read_cr2();
	uint64_t   pde = virt_to_pde(vaddr);
//	uint64_t stale_tlb = 1;

	/*
	if(stack->error.error.p && !(pde & PT_PRESENT_FLAG))
		stale_tlb = 0; // real page fault on present status.

	if(stack->error.error.wr && !(pde & PT_WRITABLE_FLAG))
		stale_tlb = 0; // real page fault on writable status.

	if(stack->error.error.us && !(pde & PT_USER_FLAG))
		stale_tlb = 0; // real page fault on user permission.

	if(stale_tlb) {

		cpu_invlpg((uint64_t*)vaddr);
	}
	else {
	*/
		kprintf("PAGE FAULT!\n");
		kprintf("          pde  : 0x%lx\n", pde);
		kprintf("     v-address : 0x%lx\n", vaddr);
		kprintf("             p : %d\n", stack->error.error.p);
		kprintf("            id : %d\n", stack->error.error.id);
		kprintf("            wr : %d\n", stack->error.error.wr);
		kprintf("            us : %d\n", stack->error.error.us);
		kprintf("          rsvd : %d\n", stack->error.error.rsvd);
		kprintf("            CS : 0x%x\n", stack->cs);
		kprintf("           RIP : 0x%lx\n",stack->rip);

		HALT("");
//	}
}




