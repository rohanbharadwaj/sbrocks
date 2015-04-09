#include <sys/timer.h>
/* 
* web reference : http://www.osdever.net/bkerndev/Docs/pit.htm
*/
int timer_ticks = 0;
int prev_secs;

extern void timer_handler();
extern void shashi();
struct time
{
    uint32_t hh;
    uint32_t mm;
    uint32_t ss;
};

struct time curr_time;

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

void timer_handler(/*struct regs *r*/)
{
	//kprintf("timer_handler reached %d \n", timer_ticks);
    /* Increment our 'tick count' */
    timer_ticks++;
    /* Every 18 clocks (approximately 1 second), we will
    *  display a message on the screen */
    if (timer_ticks % 18 == 0)
    {   
        uint32_t secs = timer_ticks/100;
        if(prev_secs != secs)			//second change
        {
            //kprintf("second : %d\n", (secs%60));
            curr_time.ss = secs%60;
			//schedule_process();
            if(secs%60 == 0)
            {
                //one min passed
                curr_time.mm++;
                if(curr_time.mm % 60 == 0)  //hour change
                {
                    //one hour passed
                    curr_time.hh++;
                    if(curr_time.hh > 24)
                        curr_time.hh = 0;
                    curr_time.mm = 0;
                }
            }
            kprintat(40,24,"Time Since Boot %d:%d:%d", curr_time.hh,curr_time.mm,curr_time.ss);
            prev_secs = secs;  
        }
    }
    outportb(0x20,0x20);
}

/* Sets up the system clock by installing the timer handler
*  into IRQ0 */
void timer_install()
{
	timer_phase(FREQUENCY);
    /* Installs 'timer_handler' to IRQ0 */
    irq_install_handler(0, &timer_handler);
    //handler();
}