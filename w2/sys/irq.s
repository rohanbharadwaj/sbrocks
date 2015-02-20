# web reference: http://www.osdever.net/tutorials/view/interrupts-exceptions-and-idts-part-1-interrupts-isrs-irqs-the-pic
# web reference: http://www.osdever.net/bkerndev/Docs/irqs.htm


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

#pushq %rsi
pushq %rsi
pushq %rbp

pushq %rdx
pushq %rcx
pushq %rbx
pushq %rax
pushq %rdi
.endm

.text

.global irq0
.global irq_rountine_handler
irq0:
	cli
	pushq $0
	pushq $32
	jmp isr_common_stub
    
isr_common_stub:
	# Pass to irq_rountine_handler:
    # pointer to interrupt number
    pushq %rdi
    pushq %rsi

    #Index of the Interrupt_No in Stack
    movq %rsp, %rdi
    addq $0x10, %rdi	
    movq %rsp, %rsi
    addq $0x18, %rsi

    # Saving all register states
    PUSHA

    # saving segment registers onto stack
    movq %ds, %rdx
    pushq %rdx
    movq %es, %rdx
    pushq %rdx
    movq %fs, %rdx
    pushq %rdx
    movq %gs, %rdx
    pushq %rdx

    call irq_rountine_handler

    # restoring segment registers from the stack
    popq %rdx
    movq %rdx, %gs
    popq %rdx
    movq %rdx, %fs
    popq %rdx
    movq %rdx, %es
    popq %rdx
    movq %rdx, %ds

    # Retrieving all registers states
    POPA
    # remove passing parameters from the stack
    popq %rsi	
    popq %rdi
    #sti
    iretq
