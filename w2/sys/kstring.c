#include <sys/kstring.h>

void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n)
{
     char *dst = s1;
     const char *src = s2;
     /* Loop and copy.  */
     while (n-- != 0)
         *dst++ = *src++;
     return s1;
 }

 size_t strlen(const char * str)
{
    const char *s;
    for (s = str; *s; ++s);
    return(s - str);
}

unsigned short *memsetw(unsigned short *dest, unsigned short val, int count)
{
	int i;
    for(i = 0; i < count; i++)
    {
    	*dest = val;
    	dest++;
    }
    return dest;
}

void *memset(void *str, int c, size_t n)
{
    char *dst = str;
    while(n-- != 0)
    {
        *dst++ = c;
    }
    return str;
}