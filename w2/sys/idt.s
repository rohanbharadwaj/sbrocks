#	web reference from 	
#  	http://www.osdever.net/bkerndev/Docs/idt.htm


######
# load a new IDT
#  parameter 1: address of idtr
.text

.global _x86_64_asm_idt
_x86_64_asm_idt:
    lidt (%rdi)
    retq

