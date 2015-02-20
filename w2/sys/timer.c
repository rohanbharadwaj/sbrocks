#include <sys/timer.h>

int timer_ticks = 0;
extern void timer_handler();
extern void shashi();

void timer_phase(int hz)
{
	uint16_t divisor = 1193180 / hz;       /* Calculate our divisor */
    outportb(0x43, 0x36);             /* Set our command byte 0x36 */
    outportb(0x40, (uint8_t)(divisor & 0xFF));   /* Set low byte of divisor */
    outportb(0x40, (uint8_t)(divisor >> 8));     /* Set high byte of divisor */
}

/* This will continuously loop until the given time has
*  been reached */
void timer_wait(int ticks)
{
    unsigned long eticks;

    eticks = timer_ticks + ticks;
    while(timer_ticks < eticks);
}
void shashi()
{
	kprintf("shashi called \n");
	while(1);
}
void timer_handler(/*struct regs *r*/)
{
	//kprintf("timer_handler reached %d \n", timer_ticks);
    /* Increment our 'tick count' */
    timer_ticks++;
    //outportb(0x20,0x20);
    /* Every 18 clocks (approximately 1 second), we will
    *  display a message on the screen */
    if (timer_ticks % 18 == 0)
    {
       // kprintf("One second has passed\n");
    }
    //shashi();
    //while(1);
        //__asm__("sti");
    //__asm__("sti");
    //timer_wait(timer_ticks + 200);
   	//while(1);
}

/* Sets up the system clock by installing the timer handler
*  into IRQ0 */
void timer_install()
{
	timer_phase(FREQUENCY);
    /* Installs 'timer_handler' to IRQ0 */
    irq_install_handler(0, timer_handler);
    //handler();
    kprintf("timer installed .. \n");
}