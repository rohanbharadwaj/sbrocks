#ifndef _KB_H
#define _KB_H


#include <sys/defs.h>
#include <sys/irq.h>
enum control
{
	NORMAL_KEY,
	CONTROL_KEY,
	SHIFT_KEY,
	ALT_KEY	
};
void kb_install(void);

#endif