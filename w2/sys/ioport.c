#include <sys/ioport.h>

inline void outportb(uint16_t port, uint8_t data)
{
	__asm __volatile("outb %0, %1;":
						:"a" (data), "d" (port));
}