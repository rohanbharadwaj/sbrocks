#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

#define MAXSIZE 2014

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
						memcpy((void*)(va_arg(val, char *)), (void*)data, size - 1);
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
					size = read(0, data, MAXSIZE);
					if(size == -1)
						return size;
					size--;	data[size] = '\0';
					int64_t *arg1 = va_arg(val, int64_t *);
					*arg1 = htol(data);
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
