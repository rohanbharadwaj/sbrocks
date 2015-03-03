/*
 * kprintf.c
 *
 *  Created on: Jan 25, 2011
 *      Author: cds
 */

#include<inttypes.h>
#include<stdarg.h>
#include<arch/arch.h>
#include<lib/lib.h>

//static TICKET_LOCK( console_lock );

static int puts(const char *s) {

    short i=0;
    char c;
    while((c = *s)) {
        ++i;
        cons_putc(c);
	    ++s;
    }
    return i;
}

static int putx(uint32_t n) {

	int      l=0;
    sint16_t s;   // shift
    uint8_t  x;
    for(s=28; s>=0; s-=4)
    	if((x = (n>>s)&15) || l || !s)
            l += cons_putc( x + ((x<10) ? '0' : ('a'-10)));

    return l;
}

static int putlx(uint64_t n) {

	int      l=0;
    sint16_t s;   // shift
    uint8_t  x;
    for(s=60; s>=0; s-=4)
    	if((x = (n>>s)&15) || l || !s)
            l += cons_putc( x + ((x<10) ? '0' : ('a'-10)));

    return l;
}

static int putu(uint32_t n) {

    uint32_t   d = 1000000000; // divisor
    sint16_t   h;              // digit
    sint16_t   l = 0;          // wrote length
    for(; d>=1; d/=10)
        if((h = ((n/d)%10)) || l || (d<=1)) {
            ++l;
            cons_putc('0' + h);
	    }
    return l;
}

static int putd(sint32_t n) {

    if(n>=0)
    	return putu((sint32_t)n);

    return cons_putc('-') + putd((sint32_t)(-n));
}

static int putlu(uint64_t n) {

    uint64_t d  = 1000000000;
	         d *= 1000000000;

    sint16_t   h;              // digit
    sint16_t   l = 0;          // wrote length
    for(; d>=1; d/=10)
        if((h = ((n/d)%10)) || l || (d<=1)) {
            ++l;
            cons_putc('0' + h);
	    }
    return l;
}

static int putll(sint64_t n) {

    if(n>=0)
    	return putlu((uint64_t)n);

    return cons_putc('-') + putlu((uint64_t)(-n));
}



static uint8_t isnum(char c) {

	return c >= '0' && c <= '9';
}

static uint64_t declen(const char *str) {

	uint64_t ret=0;

	if(*str == '-') {
		if(isnum(*(str+1))) {
			ret+=2;
			str+=2;
		}
		else
			return 0;
	}

	while(isnum(*str++))
		ret++;

	return ret;
}

static sint64_t req(sint64_t n, sint64_t base) {

	sint64_t ret;
	if(n<0) {
		ret  =  2;
		n   *= -1;
	}
	else
		ret = 1;

	while((n /= base)>0)
		ret++;

	return (ret);
}

int kprintf(const char * format, ... ) {

	va_list va;
	char c;
	int  l=0;
	int special=0;
	int zlead = 0;
	int nlead = 0;

	va_start(va, format);

//	ticket_lock_wait( &console_lock );

    while((c = *format++)) {

        if(special) {
        	special = 0;

        	switch(c) {

        	    case 's':
        	    {
        	    	const char *str = va_arg(va, const char*);
        	    	sint64_t    pad = nlead - strlen(str);
        	    	while(pad-- > 0)
        	    		l += cons_putc(' ');
                    l += puts( str );
			        break;
        	    }
        	    case 'c':
        	         l += cons_putc( va_arg(va, uint32_t) );
                     break;

        	    case 'd':
        	    case 'i':
        	    {
        	    	sint32_t n = va_arg(va, sint32_t);
        	    	sint64_t pad = nlead - req(n,10);
        	    	while(pad-- > 0)
        	    		l += cons_putc( zlead ? '0' : ' ');
        	    	l += putd( n );
        	        break;
        	    }

				case 'u':
				{
					uint32_t n = va_arg(va, uint32_t);
					sint64_t pad = nlead - req(n,10);
					while(pad-- > 0)
						l += cons_putc( zlead ? '0' : ' ');
					l += putu( n );
					break;
				}

				case 'x':
				case 'X':
				{
					uint32_t n = va_arg(va, uint32_t);
					sint64_t pad = nlead - req(n,16);
					while(pad-- > 0)
						l += cons_putc( zlead ? '0' : ' ');
					l += putx( n );
					break;
				}
				case 'l':

					if(*format == 'l') {
						sint64_t n = va_arg(va, sint64_t);
						sint64_t pad = nlead - req(n,10);
						while(pad-- > 0)
							l += cons_putc( zlead ? '0' : ' ');
						++format;
						l += putll( n );
					}

					if(*format == 'u') {
						uint64_t n = va_arg(va, uint64_t);
						sint64_t pad = nlead - req(n,10);
						while(pad-- > 0)
							l += cons_putc( zlead ? '0' : ' ');
						++format;
						l += putlu( n );
					}

					if(*format == 'x' || *format == 'X') {
						uint64_t n = va_arg(va, uint64_t);
						sint64_t pad = nlead - req(n,16);
						while(pad-- > 0)
							l += cons_putc( zlead ? '0' : ' ');
						++format;
						l += putlx( n );
					}

                    break;

				case '0':
					zlead = 1;
					++format;
				case '1':
				case '2':
				case '3':
				case '4':
				case '5':
				case '6':
				case '7':
				case '8':
				case '9':
					nlead    = atoi(format-1);
					format  += (declen(format-1)-1);
					special  = 1;
					break;

        	    default:
        		    l += cons_putc(c);
        		    break;
        	}
        }
        else if(c=='%')
        {
        	special = 1;
        	nlead   = 0;
        	zlead   = 0;
        }
        else
        	l += cons_putc(c);
    }

//    ticket_lock_signal( &console_lock );

    va_end(va);

	return l;
}


