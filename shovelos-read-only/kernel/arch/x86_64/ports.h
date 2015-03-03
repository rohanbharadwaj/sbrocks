/*
 * ports.h
 *
 *  Created on: Jan 8, 2011
 *      Author: cds
 */

#ifndef PORTS_H_
#define PORTS_H_

#include <inttypes.h>

inline uint8_t port_inb(uint16_t port) {

    uint8_t ret;
    __asm__ __volatile__( "inb  %1, %0;"
                      	  :"=a" (ret)
                          :"d"  (port)   );
    return ret;
}

inline void port_outb(uint16_t port, uint8_t data) {

    __asm__ __volatile( "outb %0, %1;"
                    : /* void */
                    : "a" (data), "d" (port));

}

/*** write to an unused port ***/
inline void port_wait() {

    port_outb(0x80, 0);
}

inline uint16_t port_inw(uint16_t port) {

    uint16_t ret;
    __asm__ __volatile__( "inw %1, %0;"
                      :"=a" (ret)
                      :"d"  (port)   );
    return ret;
}

inline void port_outw(uint16_t port, uint16_t data) {

    __asm__ __volatile( "outw %0, %1;"
                    : /* void */
                    : "a" (data), "d" (port));

}

inline uint32_t port_inl(uint16_t port) {

    uint32_t ret;
    __asm__ __volatile__( "inl %1, %0;"
                      :"=a" (ret)
                      :"d"  (port)   );
    return ret;
}

inline void port_outl(uint16_t port, uint32_t data) {

    __asm__ __volatile( "outl %0, %1;"
                    : /* void */
                    : "a" (data), "d" (port));

}

inline void port_insb(uint8_t* dst, uint16_t port, uint32_t size) {

    __asm__ __volatile__(
    		"movl %0, %edi;   \n"
    		"movw %1  %dx;    \n"
    		"movl %2, %ecx;   \n"
    		"rep insb;        \n"
    	: 	/* void */
    	: 	"d" (port), "D" (dst), "c" (size)
    	:	"rdx", "rdi", "rcx" );
}

inline void port_outsb(uint16_t port, const uint8_t *src, uint32_t size) {

    __asm__ __volatile__( "rep outsb; "
                      : /* void */
                      : "d" (port), "S" (src), "c" (size) );
}

inline void port_insw(uint16_t* dst, uint16_t port, uint32_t size) {

    __asm__ __volatile__( "rep insw; "
                      : /* void */
                      : "d" (port), "D" (dst), "c" (size) );
}

inline void port_outsw(uint16_t port, const uint16_t *src, uint32_t size) {

    __asm__ __volatile__( "rep outsw; "
                      : /* void */
                      : "d" (port), "S" (src), "c" (size) );
}

inline void port_insl(uint32_t* dst, uint16_t port, uint32_t size) {

    __asm__ __volatile__( "rep insl; "
                      : /* void */
                      : "d" (port), "D" (dst), "c" (size) );
}

inline void port_outsl(uint16_t port, const uint32_t *src, uint32_t size) {

    __asm__ __volatile__( "rep outsl; "
                      : /* void */
                      : "d" (port), "S" (src), "c" (size) );
}

#endif /* PORTS_H_ */


