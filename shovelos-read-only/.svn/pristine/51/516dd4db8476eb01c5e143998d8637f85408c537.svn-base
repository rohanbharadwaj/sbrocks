/*
 * kprintf.c
 *
 *  Created on: Jan 6, 2011
 *      Author: cds
 */

#include <stdarg.h>
#include <inttypes.h>
#include <arch/arch.h>
#include <lib/string.h>


#define ROWS 25
#define COLS 80

struct console_mem {
    uint16_t chars[ROWS][COLS];
};

struct console {

    struct console_mem *const mem;
    uint16_t xpos;
    uint16_t ypos;
    uint16_t colour;
};

struct console console = {
  PHY_TO_VIRT(0xb8000,struct console_mem *const), //  PC video address
    0,                              			    /* start at left      */
    ROWS-1,                          			    /* start at bottom    */
    0x0f00,                          	 		    /* white on black     */
};

static void scroll() {

    int r,c;

    for (r=0;r<ROWS-1;++r)
    	memcpy(console.mem->chars[r],console.mem->chars[r+1], sizeof console.mem->chars[0]);

    for (c=0;c<COLS;++c)
        console.mem->chars[r][c] = console.colour;
}

static TICKET_LOCK( console_lock );

int cons_putc(int c) {

    switch (c) {
    case '\n':

    	ticket_lock_wait(&console_lock);

        console.xpos = 0;
        if (console.ypos>=ROWS-1)
            scroll();
        else
            ++console.ypos;

        ticket_lock_signal(&console_lock);

        return 1;

    case '\r':
        return 0;

    default:

    	ticket_lock_wait(&console_lock);

        console.mem->chars[console.ypos][console.xpos] = (uint16_t)(console.colour | c);
        ++console.xpos;
        if (console.xpos>=COLS) {
            console.xpos = 0;
            if (console.ypos>=ROWS-1)
                scroll();
            else
                ++console.ypos;
        }

        ticket_lock_signal(&console_lock);

        return 1;
    }
}



