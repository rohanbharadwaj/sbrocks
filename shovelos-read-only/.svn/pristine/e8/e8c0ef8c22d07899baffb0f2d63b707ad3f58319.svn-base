
.code16gcc

#############################################
# setup segments, and allocate stack.
#   c code assumes all segments are equal.
#############################################
.global main
main:
    cli
    movw $0x0000, %ax
    movw     %ax, %ds
    movw     %ax, %ss
    movw     %ax, %es
    movl $0xffff, %esp

#############################################
# Enable A20 Line
#############################################
    movl $0x2401, %eax
    int $0x15

#############################################
# Zero memory
#############################################
    pushl $0x0200
    pushl $0x0000
    pushl $0x7c00
    call  memset
    movl  $0x70000, 8(%esp)
    movl  $0x10000, 0(%esp)
    call  memset
    movl  $0xffff, %esp

#############################################
# Jump to c main
#############################################
    ljmp $0x0000, $cmain

#############################################
# HALT EXECUTION
#############################################
.globl halt
halt:
    add $4, %esp
	call	puts
.halt_loop:
	jmp .halt_loop
