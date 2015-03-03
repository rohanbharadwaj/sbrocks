#include <sys/ioport.h>
/*
*web referene : osdev::  http://www.osdever.net/bkerndev/Docs/creatingmain.htm
*/
inline void outportb(uint16_t port, uint8_t data)
{
	__asm __volatile("outb %0, %1;":
						:"a" (data), "d" (port));
}

unsigned char inportb(unsigned short _port)
{
    unsigned char rv;
    __asm__ __volatile__ ("inb %1, %0" : "=a" (rv) : "dN" (_port));
    return rv;
}