#include <sys/kstring.h>
#include <sys/sbunix.h>
#include <sys/ioport.h>
#include <sys/idt.h>
/*
*	http://www.osdever.net/bkerndev/Docs/idt.htm
*//* Defines an IDT entry */

//interrupt service routines
extern void irq0();             //PIT irq handler
extern void irq1();             //KB irq handler
extern void isr0();
void testdivzero();
void set_irqs();

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
    //idt_set_gate(0, (uint64_t)isr0, 0x08, 0x8e);
    //PIT interrupt
    idt_set_gate(32, (uint64_t)irq0, 0x08, 0x8E);
    //Keyboard interrupt 
    idt_set_gate(33, (uint64_t)irq1, 0x08, 0x8E);
    reload_idt();
    //testdivzero();
}

void testdivzero()
{
    int i = 50;
    int j = 0;
    int k = i/j;
    kprintf("%d \n", k);
}

void fault_handler()
{
    kprintf("exception_messages[r->int_no] \n");
    //puts(" Exception. System Halted!\n");
    //for (;;);
}
