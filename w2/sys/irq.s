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

.global irq0
.global irq1
.global timer_handler
.global kb_handler
irq0:
    cli
    PUSHA
    callq timer_handler
    POPA
    sti
    iretq
 
irq1:
    cli
    PUSHA
    callq kb_handler
    POPA
    sti
    iretq    

