#include <sys/vgaconsole.h>

/*
* web reference:   http://www.osdever.net/bkerndev/Docs/printing.htm
*/

static char *vga_addr = (char*)0xb8000;
int attrib = 0x03;
#define MAX_Y 25  				//Max row value
#define MAX_X 80				//Max column value

void putch(char ch);
void setcolor(char background, char foreground);
void puts(const char *str);
void clearscreen();
void adjustcursor();

int cursor_x = 0;
int cursor_y = 0;

void setcolor(char background, char foreground)
{
	attrib = (background<<4) | (foreground & 0x0F);
}

void putch(char ch)
{
	char *dst_addr;
	switch(ch)
	{
		case '\n':
			//new line: move cursor to new line
			cursor_x=0;
			cursor_y++;
		break;
		default:
			dst_addr  = vga_addr + (cursor_y*80 + cursor_x) * 2;
			*dst_addr++ = ch;
			*dst_addr = attrib;
			cursor_x++;
		break;
	}
	adjustcursor();
}

void adjustcursor()
{
	if(cursor_x >= MAX_X)
	{
		//line is filled start new line
		cursor_x = 0;
		cursor_y++;
		
	}
	if(cursor_y >=MAX_Y)
	{
		//screen is full scroll one line above for all the lines starting from line 1 
		// and copy the last line content in 25th line 
		memcpy(vga_addr, vga_addr + MAX_X*2, MAX_Y * MAX_X * 2);
		int empty = 0x20 | (attrib << 8);
		memsetw((unsigned short *)vga_addr +(MAX_X* (MAX_Y -1)), empty, MAX_X);
		cursor_y = 24;	//last line
	}
}

void puts(const char *str)
{
	while(*str)
	{
		putch(*str);
		str++;
	}
}

void clearscreen()
{
	int i;
	int empty = 0x20 | (attrib << 8);
	for(i = 0; i < 25; i++)
	{
		//clear screen row by row all 25 rows
		memsetw((unsigned short *)vga_addr  + (i*MAX_X), empty, MAX_X);
	}
	cursor_x = 0;
	cursor_y = 0;
}

