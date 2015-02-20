
.macro PUSHA
pushq %rax
pushq %rbx
pushq %rcx
pushq %rdx

pushq %rbp
pushq %rdi
pushq %rsi
pushq %r8
pushq %r9
pushq %r10
pushq %r11
pushq %r12
pushq %r13
pushq %r14
pushq %r15
.endm

.macro POPA
pushq %r15
pushq %r14
pushq %r13
pushq %r12
pushq %r11
pushq %r10
pushq %r9
pushq %r8

pushq %rsi
pushq %rdi
pushq %rbp

pushq %rdx
pushq %rcx
pushq %rbx
pushq %rax
.endm

.text

.extern fault_handler

.global isr0
isr0:
	cli
	pushq $0
	pushq $0
	PUSHA
	movq %rsp, %rdi
	callq fault_handler
	POPA
	add $0x10, %rsp
	sti
	iretq