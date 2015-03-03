

#ifndef __INT_TYPES_H
#define __INT_TYPES_H

typedef char 			    sint8_t;
typedef unsigned char 	    uint8_t;
typedef short               sint16_t;
typedef unsigned short      uint16_t;
typedef int                 sint32_t;
typedef unsigned int        uint32_t;
typedef long long           sint64_t;
typedef unsigned long long  uint64_t;

typedef int					BOOL;
#define TRUE				1
#define FALSE				0
#define NULL				0

#define _64_DWORD_HI(x) (((int*)(&x))[1])
#define _64_DWORD_LO(x) (((int*)(&x))[0])

#endif /*** __INT_TYPES_H ***/

