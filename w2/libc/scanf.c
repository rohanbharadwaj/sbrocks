#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include<string.h>
/*reference*/
/*http://mirror.fsf.org/pmon2000/3.x/src/lib/libc/scanf.c*/

#define MAXSIZE 1024

static char data[1024];
	
int scanf(const char *format, ...)
{
	va_list val;
	va_start(val, format);
	reset(data,1024);
	int size = -1;
	while(*format)
	{
		if(*format++ == '%')
		{
			switch(*format)
			{
				case 's':
				//read string;
					size = read(0, data, MAXSIZE);
					if(size != -1)
					{
						char *c = va_arg(val, char *);
						//printf("char c : %p \n", c);
						strcpy(c, data);
						//memcpy((void*)(c), (void*)data, size - 1);
						//memcpy((void*)(va_arg(val, char *)), (void*)data, size - 1);
						size--;
					}
				//printf("res is %s \n", data);
				break;
				case 'd':
				//read integer
					size = read(0, data, MAXSIZE);
					if(size == -1)
						return size;
					size--;
					data[size] = '\0';
					uint64_t *arg = va_arg(val, uint64_t *);
					*arg = atoi(data);
				break;
				case 'c':
					size = read(0, data, 1);
				
					if(size == -1)
						return size;
					char *c = va_arg(val, char *);
					*c = data[0];
					//printf("size of char is %d \n", size);
				break;
				case 'x':
					size = read(0, data, 1);
						
				//read character
				
			}
			format++;	
		}
	}
	//int res = read(0, data, 1);
	//printf("res is %d \n", size);
	va_end(val);
	return size;
}
