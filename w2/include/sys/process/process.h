/*
web references: http://www.brokenthorn.com/Resources/OSDev24.html
*/
#ifndef _PROCESS_H
#define _PROCESS_H

#include <sys/sbunix.h>
#include <stdlib.h>
#include <sys/kstring.h>
#include <sys/mmu/virtual_mm.h>

enum task_states{
	TASK_RUNNING,		
	TASK_INTERRUPTIBLE,	
	TASK_UNINTERRUPTIBLE,	
	TASK_ZOMBIE,		
	TASK_STOPPED,		
	TASK_SWAPPING,
	TASK_RUNNABLE
};

#define KSTACK_SIZE 512
#define USER_STACK_SIZE 16*4096    
#define USER_STACK 0xF000000000UL

/*
 * vm_flags..
 */
#define VM_NONE 0
#define VM_X 1
#define VM_W 2
#define VM_WX 3
#define VM_R 4
#define VM_RX 5
#define VM_RW 6
#define VM_RWX 7



struct task_struct {
	pid_t pid;
	pid_t ppid;
	char name[16];
	uint64_t  state;	/* -1 unrunnable, 0 runnable, >0 stopped */
	uint64_t  counter;
	struct task_struct *next;
	
	/* memory management info */
	uint64_t e_entry;
	uint64_t rip;
	uint64_t rsp;
	uint64_t pml4e;
	uint64_t kstack[KSTACK_SIZE];
	struct mm_struct *mm;
};



struct mm_struct
{
	struct vm_area_struct *vma_list;
	uint64_t start_brk, end_brk, start_stack;
	uint64_t arg_start, arg_end, env_start, env_end;
	uint64_t total_vm_size;
	uint64_t stack_vm;
};

struct vm_area_struct {
        struct mm_struct *vm_mm;       /* VM area parameters */
        uint64_t  vm_start;
        uint64_t  vm_end;
        uint64_t vm_flags;
    	uint64_t vm_file_descp;
		struct vm_area_struct *next;
};

struct vm_area_struct * create_vma(struct mm_struct *vm_mm, uint64_t start, uint64_t end, uint64_t flags, uint64_t fd);
void add_to_task_list(struct task_struct *task);
struct task_struct *get_next_task();
void initialise_process();
struct task_struct *create_new_task();
struct mm_struct * create_new_mmstruct();
#endif