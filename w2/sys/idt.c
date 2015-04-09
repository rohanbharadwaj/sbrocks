#include <sys/kstring.h>
#include <sys/sbunix.h>
#include <sys/ioport.h>
#include <sys/idt.h>
#include <sys/mmu/assemblyutil.h>
/*
*	http://www.osdever.net/bkerndev/Docs/idt.htm
*//* Defines an IDT entry */

//interrupt service routines
extern void irq0();             //PIT irq handler
extern void irq1();             //KB irq handler
extern void isr0();
extern void isr14();
void testdivzero();
void page_fault_handler();
void test_page_fault();
void set_irqs();
void syscall_handler();

struct idt_entry
{
    uint16_t base_lo;
    uint16_t sel;        /* Our kernel segment goes here! */
    uint8_t ist_reserved;
    uint8_t flags;       /* Set using the above table! */
    uint16_t base_mid;
    uint32_t base_hi;
    uint32_t reserved;
} __attribute__((packed));

struct idt_entry idt[256];

struct idt_ptr {
    uint16_t size;
    uint64_t addr;
}__attribute__((packed));

static struct idt_ptr idtr = {
    sizeof(idt),
    (uint64_t)idt,
};

//void _x86_64_asm_idt(struct idt_ptr* idtr);
void _x86_64_asm_idt(struct idt_ptr *idtr);

void reload_idt() {
    _x86_64_asm_idt(&idtr);
}

//the function to set idt table entries
void idt_set_gate(int32_t num, uint64_t base, uint16_t sel, uint8_t flags)
{
    //idt[num].base_lo = base &  0x000000000000ffff;
    idt[num].base_lo = base & 0xffffUL;
    idt[num].sel = sel;
    idt[num].ist_reserved = 0x0;
    idt[num].flags = flags;
    //idt[num].base_mid = base & 0x00000000ffff0000;
    idt[num].base_mid = (base >> 16) & 0xffffUL;
    //idt[num].base_hi = base &  0xffffffff00000000;
    idt[num].base_hi = (base >> 32) & 0xffffffffUL;
    idt[num].reserved = 0x0;
}

void idt_install()
{
    memset(&idt, 0, sizeof(struct idt_entry) * 256);
    //DIV ZERO exception
    idt_set_gate(0, (uint64_t)isr0, 0x08, 0x8e);
	idt_set_gate(14, (uint64_t)isr14, 0x08, 0x8E);
    //PIT interrupt
    idt_set_gate(32, (uint64_t)irq0, 0x08, 0x8E);
	idt_set_gate(0x80, (uint64_t)syscall_handler, 0x08, 0xEE);
    //Keyboard interrupt 
    idt_set_gate(33, (uint64_t)irq1, 0x08, 0x8E);
    reload_idt();
    //testdivzero();
}

void syscall_handler()
{
	//kprintf("inside this \n");
	uint64_t syscall_num;
	uint64_t buf;
	__asm__(
		"movq %%rax, %0;"
		:"=g"(syscall_num)
		:);
	__asm__(
		"movq %%rsi, %0;"
		:"=g"(buf)
		:);
	char *b = (char *)buf;
	kprintf("system call no is %d \n", syscall_num);
	kprintf("%s \n", b);
	__asm__ __volatile__("iretq;");
}

void testdivzero()
{
    int i = 50;
    int j = 0;
    int k = i/j;
    kprintf("%d \n", k);
}



void test_page_fault()
{
	//TODO: access some memory that is not yet mapped to physical memory
	*(uint64_t *)10= 50;
}

void divide_by_zero_handler()
{
	kprintf("divide_by_zero_handler reached.... \n");	
	__asm__( "hlt" );
}
void page_fault_handler()
{
	uint64_t addr;
	addr = read_cr2();
	clrscr();
	kprintf("page fault  handler reached.... \n");
	kprintf("fault is at address %p \n",addr);
	__asm__( "hlt" );
}
//TODO: pass the interrupt numner from assembly
void fault_handler()
{
    kprintf("ashish \n");
/*	int int_no = 10;
	switch (int_no) {
        case 0:
            divide_by_zero_handler();
            break;
		case 14:
			page_fault_handler();
			break;
		default:
			break;
	}*/
}
