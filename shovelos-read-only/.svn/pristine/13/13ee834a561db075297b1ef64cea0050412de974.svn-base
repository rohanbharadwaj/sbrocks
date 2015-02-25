

########################################################################################
# high memory access
# * enter long mode
# * do work
# * return to real mode ( or jump to stage 2 )
########################################################################################

.code16


.global boot_aux_cpu
boot_aux_cpu:

    cli
    movw $0x0000, %ax
    movw     %ax, %ds
    movw     %ax, %ss
    movw     %ax, %es
    movl $0xffff, %esp

.global shuffle_high
shuffle_high:

  pushal									# store current state

  mov $0xa0, %eax							# Set PAE and PGE
  mov %eax,  %cr4

  movl $0x10000, %edx						# Load page tables (mem.h PML4E)
  movl %edx,    %cr3

  mov $0xC0000080, %ecx						# Enable long mode
  rdmsr
  or $0x00000100, %eax
  wrmsr

  movl %cr0,%ebx							# Enable paging and protection.
  orl  $0x80000001, %ebx					# to enter compatability mode.
  movl %ebx, %cr0

  movl $_gdt_reg, %eax						# Load GDT
  lgdt (%eax)

  jmp $8, $long_main						# jump to long mode
  											# cs selector index 1 (offset 8)

##############################################
#  LONG MODE BEINS HERE - DO WORK            #
##############################################
.code64
long_main:

  mov $24, %rax								# setup 64bit segments
  mov %rax,%ds
  mov %rax,%ss
  mov %rax,%es
  mov %rax,%gs
  mov %rax,%fs

   movq $0x30000,  %rax             		# (mem.h ADHOC_COMM)
   movq  0(%rax),  %rdi
   movq  8(%rax),  %rsi
   movq 16(%rax),  %rcx
   rep movsb

   cmpq $0, 24(%rax)
   je   exit_long_mode

   movq %rsp,     %r10
   andq $0xffff,  %r10
   subq $8,       %r10               # allocate uint64 on old stack
   movq $0xFFFFFFFF80000000, (%r10)  # set kernel address
   movq $0x7ffff, %rsp               # new stack
   movq $0x31000, %rdx
   movq $0x20000, %r12               # kernel parameter 2, size of memory map (mem.h MB_MMAP)
   movq (%r12), %rsi
   movq $0x20004, %rdi               # kernel parameter 1, ptr to memory map struct. (mem.h MB_MMAP+4)
   jmpq  *(%r10)                     # jump to kernel

##############################################
#  RETURN TO REAL MODE                       #
##############################################
 exit_long_mode:
  mov $24, %eax									# setup 32bit compatability segments
  mov %eax,%ds
  mov %eax,%ss
  mov %eax,%es
  mov %eax,%gs
  mov %eax,%fs
												# fake a far-return frame
  pushq $16										# push compataility mode code selector
  xorq %rcx,%rcx
  movw $compat_mode, %cx
  pushq %rcx									# push return address
  retfq											# far-return to compatability mode
compat_mode:

  .code16
    movl %cr0, %eax								#Disable Paging and protection
    andl $0x7FFFFFFE, %eax
    movl %eax, %cr0

	xor %ax, %ax								# reset segments
	mov %ax, %ds
	mov %ax, %ss
  	mov %ax, %es
  	mov %ax, %gs
  	mov %ax, %fs

    jmp $0, $return_from_long_mode				# and finaly, reset cs
return_from_long_mode:
  popal
  retl




##############################################
# Call the kernel ( never retrning )         #
#   first, switch to long mode               #
##############################################
.global call_kernel
call_kernel:

  mov $0xa0, %eax							# Set PAE and PGE
  mov %eax,  %cr4

  movl $0x10000, %edx						# Load page tables (mem.h PML4E)
  movl %edx,    %cr3

  mov $0xC0000080, %ecx						# Enable long mode
  rdmsr
  or $0x00000100, %eax
  wrmsr

  movl %cr0,%ebx							# Enable paging and protection.
  orl  $0x80000001, %ebx					# to enter compatability mode.
  movl %ebx, %cr0

  movl $_gdt_reg, %eax						# Load GDT
  lgdt (%eax)

  jmp $8, $.kernel_long_main				# jump to long mode
  											# cs selector index 1 (offset 8)

.code64
.kernel_long_main:

  mov $24, %rax								# setup 64bit segments
  mov %rax,%ds
  mov %rax,%ss
  mov %rax,%es
  mov %rax,%gs
  mov %rax,%fs

  movq $0xFFFFFFFF80000000, %r11    # set kernel address
  movq $0x7ffff, %rsp               # new stack
  movq $0x20000, %r12               # kernel parameter 2, size of memory map (mem.h MB_MMAP)
  xorq %rsi, %rsi
  movq (%r12), %rsi
  movq $0x20004, %rdi               # kernel parameter 1, ptr to memory map struct. (mem.h MB_MMAP+4)
  jmpq *%r11


