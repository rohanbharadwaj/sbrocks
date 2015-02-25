/*
 * mem.c
 *
 *  Created on: Mar 5, 2011
 *      Author: cds
 */

#include <16bitreal.h>
#include <inttypes.h>
#include <mem.h>
#include <print.h>

/*** 20bit memmove ***/
void *memmove(void* _dst, const void* _src, sint32_t size) {

  int dst = (int)_dst;
  int src = (int)_src;

  if((src > dst) || (dst>dst ? dst-src : src-dst)>=size)
    return memcpy((void*)dst,(void*)src,size);

  while(size--)
	  poke8( (void*)(dst+size), peek8((void*)(src+size) ) );

  return _dst;
}

/*** read / write to 20bit addresses ***/

#define DEFINE_PEEK_FUNC(name, type) 		\
		type name(const void *addr) { 		\
			type ret;						\
			memcpy(&ret, addr, sizeof ret);	\
			return ret;						\
		}

#define DEFINE_POKE_FUNC(name, type)		\
		void name(void *addr, type val) { 	\
			memcpy(addr, &val, sizeof val);	\
		}

DEFINE_PEEK_FUNC(peek8,  sint8_t)
DEFINE_PEEK_FUNC(peek16, sint16_t)
DEFINE_PEEK_FUNC(peek32, sint32_t)
DEFINE_PEEK_FUNC(peek64, sint64_t)

DEFINE_POKE_FUNC(poke8,  sint8_t)
DEFINE_POKE_FUNC(poke16, sint16_t)
DEFINE_POKE_FUNC(poke32, sint32_t)
DEFINE_POKE_FUNC(poke64, sint64_t)

