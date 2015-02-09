#include <string.h>

//Compare first n characters pointed by s1 to s2.
int memcmp(const void* s1, const void* s2,size_t n)
{
    const unsigned char *p1 = s1, *p2 = s2;
    while(n--)
        if( *p1 != *p2 )
            return *p1 - *p2;
        else
            p1++,p2++;
    return 0;
}

void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n)
{
     char *dst = s1;
     const char *src = s2;
     /* Loop and copy.  */
     while (n-- != 0)
         *dst++ = *src++;
     return s1;
 }

char *strcpy(char *dest, const char *src)
 {
         char *tmp = dest; 
         while ((*dest++ = *src++) != '\0');
         return tmp;
 }

char *strncpy(char *dest, const char *src, size_t count)
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

size_t strlen(const char * str)
{
    const char *s;
    for (s = str; *s; ++s);
    return(s - str);
}

int strcmp(const char *cs, const char *ct)
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

char *strstr(const char *s1, const char *s2)
{
         size_t l1, l2; 
         l2 = strlen(s2);
         if (!l2)
                 return (char *)s1;
         l1 = strlen(s1);
         while (l1 >= l2) {
                 l1--;
                 if (!memcmp(s1, s2, l2))
                         return (char *)s1;
                 s1++;
         }
         return NULL;
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
int isspace(char c)
{
    return (c == ' ' || c == '\t' || c == '\n' || c == '\12');
}

char *strchr(const char *s, int c)
{
    while (*s != (char)c)
        if (!*s++)
            return 0;
    return (char *)s;
}

int isdigit(int ch)
{
        return (ch >= '0') && (ch <= '9');
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;

        while (*s != '\0') {
                if (strchr(reject, *s++) == NULL) {
                        ++count;
                } else {
                        return count;
                }
        }
        return count;
}
void reset(char str[], int len)
{
	for(int i = 0; i < len; i++)
		str[i] = '\0';
}

int atoi(const char *str)
{
    int k = 0;
    for (int i = 0; str[i] != '\0'; ++i)
        k = (k<<3)+(k<<1)+(str[i])-'0';
    return k;
}
