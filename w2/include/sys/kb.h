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
void gets(uint64_t buf, int nbytes);
void set_flag();
void unset_flag();
void set_waiting_task(struct task_struct *task);
struct task_struct *get_waiting_task();
void wake_waiting_task();
uint64_t get_flag();
#endif