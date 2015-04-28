#include <sys/kstring.h>

void *(memcpy)(void * s1, const void * s2, size_t n)
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

char *kstrcpy(char *dest, const char *src)
 {
         char *tmp = dest; 
         while ((*dest++ = *src++) != '\0');
         return tmp;
 }

uint64_t power(uint64_t x, uint64_t y)
{
    if( y == 0)
        return 1;
    else if (y%2 == 0)
        return power(x, y/2)*power(x, y/2);
    else
        return x*power(x, y/2)*power(x, y/2);
 
}

// from stack overflow
const char *byte_to_binary(uint64_t x)
{
    static char b[65];
    b[0] = '\0';

    uint64_t z;
    for (z = power(2,63); z > 0; z >>= 1)
    {
        strcat(b, ((x & z) == z) ? "1" : "0");
    }

    return b;
}

void *memsetw(void *s1, unsigned short val, uint64_t count)
{
	int i;
	char *dest = s1;
    for(i = 0; i < count; i++)
    {
    	*dest = val;
    	dest++;
    }
    return dest;
}

char *strcat(char *dest, const char *src)
{
         char *tmp = dest; 
         while (*dest)
                 dest++;
         while ((*dest++ = *src++) != '\0')
                 ;
         return tmp;
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

int atoi(const char *str)
{
    int k = 0;
    for (int i = 0; str[i] != '\0'; ++i)
        k = (k<<3)+(k<<1)+(str[i])-'0';
    return k;
}

uint64_t octal_to_decimal(int oct)
{
	uint64_t res = 0;
	int i = 0;
	while(oct!=0){
		int digit = oct%10;
		oct = oct/10;
		res = res + digit*power(8, i);
		i++;
	}
	return res;
}

int kstrcmp(const char *cs, const char *ct)
 {
         unsigned char c1, c2;
         while (1) {
                 c1 = *cs++;
                 c2 = *ct++;
                 if (c1 != c2)
                         return c1 < c2 ? -1 : 1;
                 if (!c1)
                         break;
         }
         return 0;
}
int kstrncmp(const char *cs, const char *ct,uint64_t size)
 {
         unsigned char c1, c2;
         while (size != 0) {
                 c1 = *cs++;
                 c2 = *ct++;
                 if (c1 != c2)
                         return c1 < c2 ? -1 : 1;
                 if (!c1)
                         break;
			 size--;
         }
         return 0;
}


char *kstrncpy(char *dest, const char *src, size_t count)
 {
         char *tmp = dest; 
         while (count) {
                 if ((*tmp = *src) != 0)
                         src++;
                 tmp++;
                 count--;
         }
         return dest;
 }