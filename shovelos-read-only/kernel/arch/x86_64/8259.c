/*
 * 8259.c
 *
 *  Created on: Jan 8, 2011
 *      Author: cds
 */

#include<arch/x86_64/ports.h>

#define PIC1      0x20
#define PIC2      0xA0
#define PIC1_CMD  PIC1
#define PIC2_CMD  PIC2
#define PIC1_DATA PIC1+1
#define PIC2_DATA PIC2+1

/*** Initialisation control word 1 ***/
#define ICW1_ICW4   0x01 /* 0 = icw4 not required, 1 = required               */
#define ICW1_SNGL   0x02 /* 0 = cascade mode, 1 = single mode                 */
#define ICW1_ADI    0x04 /* 0 = call address interval of 8, 1 = interval of 4 */
#define ICW1_LTIM   0x08 /* 0 = edge triggered mode, 1 = level triggered mode */
#define ICW1_D4     0x10 /* required                                          */
#define ICW1_A5     0x20 /* interrupt vector address A5 (MCS-80/85 mode only) */
#define ICW1_A6     0x40 /* interrupt vector address A6 (MCS-80/85 mode only) */
#define ICW1_A7     0x80 /* interrupt vector address A7 (MCS-80/85 mode only) */

/*** Initialisation control word 3 ( irq connection master to slave - 2 on the IBM PC ) ***/
#define ICW3_MASTER(irq) 1 << irq
#define ICW3_SLAVE(irq)  irq

/*** Initialisation control word 4 ***/
#define ICW4_PM     0x01 /* 0 = MCS-80/85 Mode, 1 = 8086/8080 Mode                           */
#define ICW4_AEOI   0x02 /* 0 = Normal End of interrupt, 1 = auto End of interrupt           */
#define ICW4_MS     0x04 /* 0 = Buffered Mode Slave, 1 = Buffered Mode Master                */
#define ICW4_BUF    0x08 /* 0 = Non Buffered, 1 = Buffered                                   */
#define ICW4_SFNM   0x10 /* 0 = Not special fully nested mode, 1 = special fully nested mode */

void _8259_disable() {

	port_outb(PIC2_DATA, 0xff);
	port_outb(PIC1_DATA, 0xff);
}

void _8259_remap(uint8_t off1, uint8_t off2) {

    /*** Initialisation control word 1 - re-initialise PIC */
    port_outb(PIC1_CMD, ICW1_D4 | ICW1_ICW4);
    port_outb(PIC2_CMD, ICW1_D4 | ICW1_ICW4);

    /* Initialisation control word 2 - set interrupt vector address */
    port_outb(PIC1_DATA, off1);
    port_outb(PIC2_DATA, off2);

    /* Initialisation control word 3 - set master to slave IRQ */
    port_outb(PIC1_DATA, ICW3_MASTER(2));
    port_outb(PIC2_DATA, ICW3_SLAVE (2));

    /* Initialisation control word 4 - set mode */
    port_outb(PIC1_DATA, ICW4_PM); /* 8086 mode */
    port_outb(PIC2_DATA, ICW4_PM); /* 8086 mode */

}

