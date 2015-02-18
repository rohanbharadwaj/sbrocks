#include <sys/idt.h>

/*
*	http://www.osdever.net/bkerndev/Docs/idt.htm
*//* Defines an IDT entry */

extern void idt_load();
//interrupt service routines
extern void isr0();

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

struct idt_ptr
{
    uint16_t limit;
    uint64_t base;
} __attribute__((packed));

struct idt_entry idt[256];
struct idt_ptr idtp;


//the function to set idt table entries
void idt_set_gate(int32_t num, uint64_t base, uint16_t sel, uint8_t flags)
{
    idt[num].base_lo = base &  0x000000000000ffff;
    idt[num].sel = sel;
    idt[num].ist_reserved = 0x00;
    idt[num].flags = flags;
    idt[num].base_mid = base & 0x00000000ffff0000;
    idt[num].base_hi = base &  0xffffffff00000000;
    idt[num].reserved = 0x00;
}

void idt_install()
{
	idtp.limit = sizeof(struct idt_entry)*256 -1;
	idtp.base = (uint64_t)&idt;
	memset(&idt, 0, sizeof(struct idt_entry) * 256);
   // idt_set_gate(1, israddr, flags)
    //idt_set_gate(0, NULL, 0x08, 0x8e);
	//midt_load();
}