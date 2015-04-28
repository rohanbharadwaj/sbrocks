
/*
* http://www.osdever.net/bkerndev/Docs/keyboard.htm
*
*/
#include <sys/kb.h>

void kb_install(void);
void kb_handler(void);
void handlekey(unsigned char scancode);

enum control curentControl = NORMAL_KEY;

static volatile int flag = 0;
static volatile int i = 0;
static volatile char *str;
static volatile uint64_t count;
char a[1024];
char current_char;
struct task_struct *waiting_task = NULL;
/* KBDUS means US Keyboard Layout. This is a scancode table
*  used to layout a standard US keyboard. I have left some
*  comments in to give you an idea of what key is what, even
*  though I set it's array index to 0. You can change that to
*  whatever you want using a macro, if you wish! */




unsigned char kbdus[128] =
{
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8',	/* 9 */
  '9', '0', '-', '=', '\b',	/* Backspace */
  '\t',			/* Tab */
  'q', 'w', 'e', 'r',	/* 19 */
  't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',	/* Enter key */
    0,			/* 29   - Control */
  'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',	/* 39 */
 '\'', '`',   0,		/* Left shift */
 '\\', 'z', 'x', 'c', 'v', 'b', 'n',			/* 49 */
  'm', ',', '.', '/',   0,				/* Right shift */
  '*',
    0,	/* Alt */
  ' ',	/* Space bar */
    0,	/* Caps lock */
    0,	/* 59 - F1 key ... > */
    0,   0,   0,   0,   0,   0,   0,   0,
    0,	/* < ... F10 */
    0,	/* 69 - Num lock*/
    0,	/* Scroll Lock */
    0,	/* Home key */
    0,	/* Up Arrow */
    0,	/* Page Up */
  '-',
    0,	/* Left Arrow */
    0,
    0,	/* Right Arrow */
  '+',
    0,	/* 79 - End key*/
    0,	/* Down Arrow */
    0,	/* Page Down */
    0,	/* Insert Key */
    0,	/* Delete Key */
    0,   0,   0,
    0,	/* F11 Key */
    0,	/* F12 Key */
    0,	/* All other keys are undefined */
};	


//shift codes for scancodes
unsigned char shiftcodes[128] =
{
    0,  27, '!', '@', '#', '$', '%', '^', '&', '*', /* 9 */
    '(', ')', '_', '+', '\b', /* Backspace */
    '\t',           /* Tab */
    'Q', 'W', 'E', 'R',   /* 19 */
    'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n',   /* Enter key */
    0,          /* 29   - Control */
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', /* 39 */
    '\"', '~',   0,      /* Left shift */
    '|', 'Z', 'X', 'C', 'V', 'B', 'N',         /* 49 */
    'M', '<', '>', '?',   0,              /* Right shift */
  '*',
    0,  /* Alt */
  ' ',  /* Space bar */
    0,  /* Caps lock */
    0,  /* 59 - F1 key ... > */
    0,   0,   0,   0,   0,   0,   0,   0,
    0,  /* < ... F10 */
    0,  /* 69 - Num lock*/
    0,  /* Scroll Lock */
    0,  /* Home key */
    0,  /* Up Arrow */
    0,  /* Page Up */
  '-',
    0,  /* Left Arrow */
    0,
    0,  /* Right Arrow */
  '+',
    0,  /* 79 - End key*/
    0,  /* Down Arrow */
    0,  /* Page Down */
    0,  /* Insert Key */
    0,  /* Delete Key */
    0,   0,   0,
    0,  /* F11 Key */
    0,  /* F12 Key */
    0,  /* All other keys are undefined */
};  

void kb_install(void)
{
   irq_install_handler(1, kb_handler);
}

int shiftpressed = 0;

void kb_handler(void)
{
    unsigned char scancode;
    /* Read from the keyboard's data buffer */
    scancode = inportb(0x60);
    if (scancode & 0x80)
    {
        //ley is just pressed 
    }
    else
    {
        //key is released 
        switch(scancode)
        {
            case 42:  //shift
              curentControl = SHIFT_KEY;
              break;
            case 56:  //alt
              curentControl = ALT_KEY;
              break;
            case 29:  //control
                curentControl = CONTROL_KEY;
                break;
            default:
              handlekey(scancode);
              break;
        }
    }
    outportb(0x20,0x20);
}

void handlekey(unsigned char scancode)
{
      switch(curentControl)     
      {
         case SHIFT_KEY:
              kprintf("%c", shiftcodes[scancode]);
              kprintat(73,24, "glyph:%c", shiftcodes[scancode]);
		  	  current_char = shiftcodes[scancode];
              break;
          default:
              kprintf("%c", kbdus[scancode]);
              kprintat(73,24, "glyph:%c", kbdus[scancode]);
		  	  current_char = kbdus[scancode];
              break;
      }
	if(flag == 1)  //scanf mode
	{
		kprintf2("%c",current_char);
    	if(current_char=='\n')
		{
			//kprintf2(" new line reached ... \n");
			a[i++] = '\0';
			for(int j = i; j <count; j++)
			{
				a[j] = '\0';	
			}
   			unset_flag();
			uint64_t k_cr3 = read_cr3();
			write_cr3(virt_to_phy(waiting_task->pml4e, 0));
			memcpy((void *)str, (void *)a, count);
			//kprintf2("%s \n", str);
			write_cr3(k_cr3);
			i= 0;
			for(int j = 0; j <= i; j++)
				a[j] = '\0';
			wake_waiting_task();
   		}
		else
		{
		//	kprintf2("current char is %c ... \n", current_char);
			if(current_char == 0x08 && i > 0)
			{
				a[i]='\0';
				i--;
			}
			else
				a[i++]=current_char;
		}
	}
      curentControl = NORMAL_KEY;
}

void gets(uint64_t buf, int nbytes){
	str = (char *)buf;
	count = nbytes;
	#if 0
	if(i == 0)
		return;
	memcpy((void *)str, (void *)a, nbytes);	
	i= 0;
	for(int j = 0; j <= i; j++)
		a[j] = '\0';
	#endif
}

void set_flag()
{
	flag = 1;	
}

uint64_t get_flag()
{
	return flag;	
}

void unset_flag()
{
	flag = 0;
}

void set_waiting_task(struct task_struct *task)
{
	waiting_task = task;	
}

struct task_struct *get_waiting_task()
{
	return waiting_task;	
}


void wake_waiting_task()
{
	waiting_task->state = TASK_RUNNABLE;
	//waiting_task = NULL;	
}
