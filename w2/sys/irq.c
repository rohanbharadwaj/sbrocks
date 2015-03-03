#include <sys/irq.h>

/*
* web reference : osdev :: http://www.osdever.net/bkerndev/Docs/irqs.htm
*/

/* This array is actually an array of function pointers. We use
*  this to handle custom IRQ handlers for a given IRQ */
extern void irq_rountine_handler();
void *irq_routines[16] =
{
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0
};

/* This installs a custom IRQ handler for the given IRQ */
void irq_install_handler(int irq, void (*handler)())
{
    irq_routines[irq] = handler;
}

/* This clears the handler for a given IRQ */
void irq_uninstall_handler(int irq)
{
    irq_routines[irq] = 0;
}

void pic_remap(void)
{
    outportb(0x20, 0x11);
    outportb(0xA0, 0x11);
    outportb(0x21, 0x20);
    outportb(0xA1, 0x28);
    outportb(0x21, 0x04);
    outportb(0xA1, 0x02);
    outportb(0x21, 0x01);
    outportb(0xA1, 0x01);
    //unmask
    outportb(0x21, 0x0);
    outportb(0xA1, 0x0);
    kprintf("pic_remap done... \n");
}

void install_irqs()
{
    pic_remap();
}

void sleepk()
{
    long int i = 10000;
    while(i != -10000000)
    {
        i--;
    }
}

void irq_rountine_handler(uint64_t *r)
{
    //__asm__("cli");
	//kprintf("irq_rountine_handler %d \n", *r);
   // uint64_t irqNum = 32 -(*r);
    void (*handler)();
    handler =  irq_routines[0];
    handler();
    //sleepk();
    //kprintf("backk to irq_rountine_handler \n");
    
    //
    outportb(0x20,0x20);
    //outportb(0xa0,0x20);
    //__asm__("sti");
    //sleepk();
}