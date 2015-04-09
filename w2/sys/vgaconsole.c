#include <sys/vgaconsole.h>
#include <sys/ioport.h>
/*
* web reference:   http://www.osdever.net/bkerndev/Docs/printing.htm
*/

static char *vga_addr = (char*)0xFFFFFFFF800B8000;
uint64_t attrib = 0x03;
#define MAX_Y 25  				//Max row value
#define MAX_X 80				//Max column value
void scroll(void);
void move_csr(void);
void putch(char ch);
void setcolor(char background, char foreground);
void puts(const char *str);
void clearscreen();
void adjustcursor();
void handle_backspace();

uint64_t cursor_x = 0;
uint64_t cursor_y = 0;

void setcolor(char background, char foreground)
{
	attrib = (background<<4) | (foreground & 0x0F);
}

void puttimer(int x, int y, char *str)
{
    for(int i = 0; i < MAX_X; i++)
    {
        char *dst_addr  = vga_addr + (y*80 + i) * 2;
        dst_addr++;
        *dst_addr = 0x0A;
    }
	while(*str)
	{
		char *dst_addr  = vga_addr + (y*80 + x) * 2;
		*dst_addr++ = *str;
		*dst_addr = 0x0A;     //timer font color
		x++;
		str++;
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
        //backspace
        case 0x08:
            handle_backspace();
            break;
        //tabs 
        case 0x09:
            cursor_x = (cursor_x + 8) & ~(8 - 1);

            break;
        //carrage
        case '\r':
            cursor_x = 0; 
            break;
		default:
			dst_addr  = vga_addr + (cursor_y*80 + cursor_x) * 2;
			*dst_addr++ = ch;
			*dst_addr = attrib;
			cursor_x++;
		break;
	}
	/* Scroll the screen if needed, and finally move the cursor */
    scroll();
    move_csr();
	//adjustcursor();
}

/* Scrolls the screen */
void scroll(void)
{
    //unsigned blank, temp;
	uint64_t blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = /*0x20 | */(attrib << 8);

    /* Row 24 is the end, this means we need to scroll up */
    if(cursor_y >= 24)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = cursor_y - 24;
        memcpy (vga_addr, vga_addr + temp * 80*2, (24 - temp) * 80 * 2);

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memsetw (vga_addr + (24 - temp) * 80*2, blank, 80*2);
        cursor_y = 24 - 1;
    }
}

void handle_backspace()
{
    if(cursor_x != 0) 
    {
        
       // dst_add
        cursor_x--;
        unsigned blank = 0x20 | (attrib << 8);
        char *dst_addr  = vga_addr + (cursor_y*80 + cursor_x) * 2;
        *dst_addr = blank;
    }
    else if(cursor_y != 0)
    {
        cursor_x = 80;
        cursor_y--;
        unsigned blank = 0x20 | (attrib << 8);
        char *dst_addr  = vga_addr + (cursor_y*80 + cursor_x) * 2;
        *dst_addr = blank;
        cursor_x--;
    }
}

/* Updates the hardware cursor: the little blinking line
*  on the screen under the last character pressed! */
void move_csr(void)
{
    unsigned temp;

    /* The equation for finding the index in a linear
    *  chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    temp = cursor_y * 80 + cursor_x;

    /* This sends a command to indicies 14 and 15 in the
    *  CRT Control Register of the VGA controller. These
    *  are the high and low bytes of the index that show
    *  where the hardware cursor is to be 'blinking'. To
    *  learn more, you should look up some VGA specific
    *  programming documents. A great start to graphics:
    *  http://www.brackeen.com/home/vga */
    outportb(0x3D4, 14);
    outportb(0x3D5, temp >> 8);
    outportb(0x3D4, 15);
    outportb(0x3D5, temp);
}


void adjustcursor()
{
	if(cursor_x >= MAX_X)
	{
		//line is filled start new line
		cursor_x = 0;
		cursor_y++;
		
	}
	if(cursor_y >=MAX_Y -1)
	{
		//screen is full scroll one line above for all the lines starting from line 1 
		// and copy the last line content in 25th line 
		memcpy(vga_addr, vga_addr + MAX_X*2, MAX_Y * MAX_X * 2);
		int empty = /*0x20 | */(attrib << 8);
		memsetw(vga_addr +(2*MAX_X* (MAX_Y -1)), empty, 2*MAX_X);
		cursor_y = 24;	//last line
	}
}

void clearscreen()
{
    unsigned blank;
    uint64_t i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = (attrib << 8);

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 24; i++)
        memsetw (vga_addr + 2*i * MAX_X, blank, 2*MAX_X);

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    cursor_x = 0;
    cursor_y = 0;
    move_csr();
}
