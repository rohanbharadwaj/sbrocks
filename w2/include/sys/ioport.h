#ifndef _IOPORT_H
#define _IOPORT_H
#include <sys/defs.h>

void outportb(uint16_t port, uint8_t data);
unsigned char inportb(unsigned short _port);

#endif