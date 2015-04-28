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
.extern  gpf_fault_handler
.extern  syscall_handler

.global isr0
.global isr1
.global isr2
.global isr3
.global isr4
.global isr5
.global isr6
.global isr7
.global isr8
.global isr9
.global isr10
.global isr11
.global isr12
.global isr13
.global isr14
.global isr15
.global isr16
.global isr17
.global isr18
.global isr19
.global isr20
.global isr21
.global isr22
.global isr23
.global isr24
.global isr25
.global isr26
.global isr27
.global isr28
.global isr29
.global isr30
.global isr31
.global isr128
isr0:
	cli
	pushq $0
	PUSHA
	movq %rsp, %rdi
	callq divide_by_zero_handler
	POPA
	add $0x10, %rsp
	sti
	iretq

isr1:
	cli
	pushq $1
	PUSHA
	movq %rsp, %rdi
	callq isr1_handler
	POPA
	add $0x10, %rsp
	sti
	iretq

isr2:
	cli
	pushq $2
	PUSHA
	movq %rsp, %rdi
	callq isr2_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr3:
	cli
	pushq $3
	PUSHA
	movq %rsp, %rdi
	callq isr3_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr4:
	cli
	pushq $4
	PUSHA
	movq %rsp, %rdi
	callq isr4_handler
	POPA
	add $0x10, %rsp
	sti
	iretq

isr5:
	cli
	pushq $5
	PUSHA
	movq %rsp, %rdi
	callq isr5_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr6:
	cli
	pushq $6
	PUSHA
	movq %rsp, %rdi
	callq isr6_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr7:
	cli
	pushq $7
	PUSHA
	movq %rsp, %rdi
	callq isr7_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr8:
	cli
	pushq $8
	PUSHA
	movq %rsp, %rdi
	callq isr8_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr9:
	cli
	pushq $9
	PUSHA
	movq %rsp, %rdi
	callq isr9_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr10:
	cli
	pushq $10
	PUSHA
	movq %rsp, %rdi
	callq isr10_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr11:
	cli
	pushq $11
	PUSHA
	movq %rsp, %rdi
	callq isr11_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr12:
	cli
	pushq $12
	PUSHA
	movq %rsp, %rdi
	callq isr12_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr15:
	cli
	pushq $15
	PUSHA
	movq %rsp, %rdi
	callq isr15_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr16:
	cli
	pushq $16
	PUSHA
	movq %rsp, %rdi
	callq isr16_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr17:
	cli
	pushq $17
	PUSHA
	movq %rsp, %rdi
	callq isr17_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr18:
	cli
	pushq $18
	PUSHA
	movq %rsp, %rdi
	callq isr18_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr19:
	cli
	pushq $19
	PUSHA
	movq %rsp, %rdi
	callq isr19_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr20:
	cli
	pushq $20
	PUSHA
	movq %rsp, %rdi
	callq isr20_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr21:
	cli
	pushq $21
	PUSHA
	movq %rsp, %rdi
	callq isr21_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr22:
	cli
	pushq $22
	PUSHA
	movq %rsp, %rdi
	callq isr22_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr23:
	cli
	pushq $23
	PUSHA
	movq %rsp, %rdi
	callq isr23_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr24:
	cli
	pushq $24
	PUSHA
	movq %rsp, %rdi
	callq isr24_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr25:
	cli
	pushq $25
	PUSHA
	movq %rsp, %rdi
	callq isr25_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr26:
	cli
	pushq $26
	PUSHA
	movq %rsp, %rdi
	callq isr26_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr27:
	cli
	pushq $27
	PUSHA
	movq %rsp, %rdi
	callq isr27_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr28:
	cli
	pushq $28
	PUSHA
	movq %rsp, %rdi
	callq isr28_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr29:
	cli
	pushq $29
	PUSHA
	movq %rsp, %rdi
	callq isr29_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr30:
	cli
	pushq $30
	PUSHA
	movq %rsp, %rdi
	callq isr30_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
	
isr31:
	cli
	pushq $31
	PUSHA
	movq %rsp, %rdi
	callq isr31_handler
	POPA
	add $0x10, %rsp
	sti
	iretq

isr128:
	cli
	pushq $80
	pushq $80
	PUSHA
	movq %rsp, %rdi
	callq syscall_handler
	POPA
	add $0x10, %rsp
	sti
	iretq

isr13:
	cli
	pushq $13
	PUSHA
	movq %rsp, %rdi
	callq  gpf_fault_handler
	POPA
	add $0x10, %rsp
	sti
	iretq

isr14:
	cli
	pushq $14
	PUSHA
	movq %rsp, %rdi
	callq  page_fault_handler
	POPA
	add $0x10, %rsp
	sti
	iretq
