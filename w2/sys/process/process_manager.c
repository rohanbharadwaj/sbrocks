#include <sys/process/process_manager.h>
extern void irq0();
struct task_struct* current_task = NULL;
void start_process(struct task_struct* task, uint64_t ustack, uint64_t binary_entry);
//void start_process(struct task_struct* task);
/* web reference: http://www.jamesmolloy.co.uk/tutorial_html/10.-User%20Mode.html   */

struct task_struct* get_current_task()
{
	return current_task;	
}

void load_process(struct task_struct* task, uint64_t binary_entry, uint64_t ustack)
{
	current_task = task;
	task->state = TASK_RUNNING;
	/* setting up kernel stack for user process */
	#if 0
	task->kstack[KSTACK_SIZE-1] = 0x23;    //user data segment or ss
	task->kstack[KSTACK_SIZE-2] = ustack;        //rsp      
	task->kstack[KSTACK_SIZE-3] = 0x200286   /*0x200202UL*/;   //RFLAGS 
	task->kstack[KSTACK_SIZE-4] = 0x1b; 	 //user code segment
	task->kstack[KSTACK_SIZE-5] = binary_entry;
	#endif
	//task->kstack[20] = (uint64_t)irq0 + 34;
	task->rip = binary_entry;
	/*web reference: http://wiki.osdev.org/Getting_to_Ring_3*/
	
	//task->rsp = (uint64_t)&task->kstack[KSTACK_SIZE-6];    //rsp
	//task->rsp = (uint64_t)&task->kstack[KSTACK_SIZE-6];
	task->rsp = ustack;    //rsp
	start_process(task, ustack, binary_entry);
	//kprintf("yeye process is loaded successfully \n");
 }
#if 0
void load_process(struct task_struct* task, uint64_t binary_entry, uint64_t ustack)
{
	current_task = task;
	task->state = TASK_RUNNING;
	/* setting up kernel stack for user process */
	task->kstack[KSTACK_SIZE-1] = 0x23;    //user data segment or ss
	task->kstack[KSTACK_SIZE-2] = ustack;        //rsp      
	task->kstack[KSTACK_SIZE-3] = 0x200286   /*0x200202UL*/;   //RFLAGS 
	task->kstack[KSTACK_SIZE-4] = 0x1b; 	 //user code segment
	task->kstack[KSTACK_SIZE-5] = binary_entry;
	task->kstack[KSTACK_SIZE-6] = (uint64_t)irq0 + 0x20;
	//task->kstack[20] = (uint64_t)irq0 + 34;
	task->rip = binary_entry;
	/*web reference: htt p://wiki.osdev.org/Getting_to_Ring_3*/
	
	task->rsp = (uint64_t)&task->kstack[KSTACK_SIZE-18];   //rsp
	//task->rsp = (uint64_t)&task->kstack[KSTACK_SIZE-6];
	//task->rsp = ustack;    //rsp
	start_process(task, ustack, binary_entry);
	//kprintf("yeye process is loaded successfully \n");
 }
#endif
void schedule_process()
{
	kprintf("scheduling process stared.........\n");
	struct task_struct *task = NULL;
	if(current_task == NULL)
	{
		task = get_next_task(current_task);
		if(task == NULL)
			return;
		else
		{
			//schedule new task
			load_process(task, task->e_entry, task->mm->stack_vm);
			current_task = task;
		}
	}
	else
	{
		//task switching is required	
		task = get_next_task(current_task);
		if(task == NULL)
			return;
		else
		{
			//switch new task and save previous task state	
			__asm__ __volatile__("movq %%rsp, %[next_rsp]" :[next_rsp] "=m" (current_task->rsp): );
			load_process(task, task->e_entry, task->mm->stack_vm);
			current_task = task;
		}
	}
	kprintf("schedule called...\n");	
}

void start_process(struct task_struct* task, uint64_t ustack, uint64_t binary_entry)
{
	//1. load cr3
	write_cr3(virt_to_phy(task->pml4e,0));
	//2. swtich process stack to process stack
	//TODO change to assemblyutil function
	//write_rsp(task->rsp);
	//__asm__ __volatile__("sti" : :);
	__asm__ __volatile__("movq %[next_rsp], %%rsp" : : [next_rsp] "m" (task->rsp));
	//TODO
	
	//3. set rsp
	//set_tss_rsp0(task->rsp);   //use  
	set_tss_rsp0((uint64_t)&task->kstack[KSTACK_SIZE-1]);
	//set_tss_rsp0((uint64_t)&task->kstack);
	
	//switch to ring 3 or user mode
	switch_to_usermode(ustack, binary_entry);
}



