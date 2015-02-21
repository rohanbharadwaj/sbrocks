#include <sys/ioport.h>

inline void outportb(uint16_t port, uint8_t data)
{
	__asm __volatile("outb %0, %1;":
						:"a" (data), "d" (port));
}

/* We will use this later on for reading from the I/O ports to get data
*  from devices such as the keyboard. We are using what is called
*  'inline assembly' in these routines to actually do the work */
unsigned char inportb(unsigned short _port)
{
    unsigned char rv;
    __asm__ __volatile__ ("inb %1, %0" : "=a" (rv) : "dN" (_port));
    return rv;
}