#include <sys/process/process_manager.h>
extern void irq0();
struct task_struct* current_task = NULL;
void start_process(struct task_struct* task, uint64_t ustack, uint64_t binary_entry);
void save_registers(struct task_struct *p, struct task_struct *task);
//void start_process(struct task_struct* task);
/* web reference: http://www.jamesmolloy.co.uk/tutorial_html/10.-User%20Mode.html   */

struct task_struct* get_current_task()
{
	return current_task;	
}

void set_current_task(struct task_struct* task)
{
	current_task = task;
}


void load_process(struct task_struct* task, uint64_t binary_entry, uint64_t ustack)
{
	current_task = task;
	task->state = TASK_RUNNING;
	/* setting up kernel stack for user process */
	//task->rip = binary_entry;
	/*web reference: http://wiki.osdev.org/Getting_to_Ring_3*/
	
	//task->rsp = (uint64_t)&task->kstack[KSTACK_SIZE-6];    //rsp
	//task->rsp = (uint64_t)&task->kstack[KSTACK_SIZE-6];
	//if(task->ppid == -1)   //no child process
	//{
	//	task->rsp = ustack;    //rsp
	//	task->rip = binary_entry;
	//}
	start_process(task, ustack, binary_entry);
	//kprintf("yeye process is loaded successfully \n");
 }

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
			//task->rsp = task->mm->stack_vm;    //rsp
			//task->rip = task->e_entry;
			current_task = task;
			start_process(task, task->mm->stack_vm, task->e_entry);
			//load_process(task, task->e_entry, task->mm->stack_vm);
			
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
			//__asm__ __volatile__("movq %%rsp, %[next_rsp]" :[next_rsp] "=m" (current_task->rsp): );
			//current_task->rsp = current_task->kstack[KSTACK_SIZE-3];
			//current_task->rip = current_task->kstack[KSTACK_SIZE-6];
			//save_registers(current_task, task);
			current_task->state = TASK_RUNNABLE;
			kprintf("schedule called...%d \n", current_task->pid);
			current_task = task;
			start_process(task, task->mm->stack_vm, task->e_entry);
			//load_process(task, task->e_entry, task->mm->stack_vm);
		}
	}
	current_task->state = TASK_RUNNING;	
}

void save_registers(struct task_struct *p, struct task_struct *task)
{
	int i = 1;
	while(p->kstack[KSTACK_SIZE - i] == 0)
		i++;
	p->rsp = p->kstack[KSTACK_SIZE - i - 1];
	p->rip = p->kstack[KSTACK_SIZE - i - 4];
	/*if(task->ppid == current_task->pid)
	{
		task->rsp = p->rsp;
		task->rip = p->rip;
	}*/
}

void start_process(struct task_struct* task, uint64_t ustack, uint64_t binary_entry)
{
	//1. load cr3
	write_cr3(virt_to_phy(task->pml4e,0));
	//task->r.rsp = ustack;
	//task->r.rip = task->e_entry;
	//task->r.rsp = ustack;
	//task->r.rip = task->e_entry;
	
	task->r.ss = 0x23;
	task->r.cs = 0x1b;
	task->r.rflag = 0x200;
			
	//2. swtich process stack to process stack
	//TODO change to assemblyutil function
	//write_rsp(task->rsp);
	//__asm__ __volatile__("sti" : :);
	//__asm__ __volatile__("movq %[next_rsp], %%rsp" : : [next_rsp] "m" (task->rsp));
	//TODO
	//task->kstack[KSTACK_SIZE-21] = (uint64_t)irq0 + 0x20;
	//uint64_t rsp = (uint64_t)&task->kstack[KSTACK_SIZE-22];
	//__asm__ __volatile__("movq %[next_rsp], %%rsp" : : [next_rsp] "m" (rsp));
	//3. set rsp
	//set_tss_rsp0(task->rsp);   //use  
	set_tss_rsp0((uint64_t)&task->kstack[KSTACK_SIZE-1]);
	//set_tss_rsp0((uint64_t)&task->kstack);
	//"int $0x80;"
	//__asm__ __volatile__("int $0x20;" : :);	
	//switch to ring 3 or user mode
	//switch_to_usermode(task->rsp, task->rip, task);

}



