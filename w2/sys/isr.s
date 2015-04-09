.macro PUSHA
    pushq %rdi
    pushq %rax
    pushq %rbx
    pushq %rcx
    pushq %rdx
    pushq %rbp
    pushq %rsi
    pushq %r8
    pushq %r9
    pushq %r10
    pushq %r11
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    movq %ds, %rdx
    pushq %rdx
    movq %es, %rdx
    pushq %rdx
    movq %fs, %rdx
    pushq %rdx
    movq %gs, %rdx
    pushq %rdx
.endm

.macro POPA
    popq %rdx
    movq %rdx, %gs
    popq %rdx
    movq %rdx, %fs
    popq %rdx
    movq %rdx, %es
    popq %rdx
    movq %rdx, %ds
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %r11
    popq %r10
    popq %r9
    popq %r8
    popq %rsi
    popq %rbp
    popq %rdx
    popq %rcx
    popq %rbx
    popq %rax
    popq %rdi
.endm

.text

.extern divide_by_zero_handler
.extern  page_fault_handler

.global isr0
.global isr14

isr0:
	cli
	pushq $0
	pushq $0
	PUSHA
	movq %rsp, %rdi
	callq divide_by_zero_handler
	POPA
	add $0x10, %rsp
	sti
	iretq

isr14:
	cli
	pushq $14
	pushq $14
	PUSHA
	movq %rsp, %rdi
	callq  page_fault_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
