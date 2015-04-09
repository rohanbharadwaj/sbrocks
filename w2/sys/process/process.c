#include <sys/process/process.h>
#include <sys/mmu/kmalloc.h>
static uint64_t pid = 0;
struct task_struct *task_list = NULL;
void print_task_list();

struct vm_area_struct * create_vma(struct mm_struct *vm_mm, uint64_t start, uint64_t end, uint64_t flags, uint64_t fd)     
{
	struct vm_area_struct *vma = NULL;
	//TODO allocate memory vma
	vma = (struct vm_area_struct *)kmalloc(sizeof(struct vm_area_struct));
	vma->vm_mm = vm_mm;
	vma->vm_start = start;
	vma->vm_end = end;
	vma->vm_flags = flags;
	vma->vm_file_descp = fd;
	vma->next = NULL;
	return vma;
}

void add_to_task_list(struct task_struct *task)
{
	if(task_list == NULL)
	{
		task_list = task;
	}
	else{
		struct task_struct *t = task_list;
		while(t->next != NULL)
		{
			t = t->next;	
		}
		t->next = task;
	}
}

struct task_struct *get_next_task(struct task_struct *current_task)
{
	if(task_list == NULL)
	{
		return NULL;
	}
	else
	{
		clrscr();
		print_task_list();
		struct task_struct *t = task_list;
		while(t != NULL)
		{
			if(t != current_task && t->state == TASK_RUNNABLE)	
				return t;
			t = t->next;
		}
	}
	return NULL;
}

void print_task_list()
{
	struct task_struct *t = task_list;
	while(t != NULL)
	{
		kprintf("task id %d \n", t->pid);
		kprintf("task state %d \n", t->state);
		t = t->next;
	}
}

void initialise_process()
{
	
}
//TODO : Not working 

struct task_struct *create_new_task(char *taskname)
{
	struct task_struct *task = NULL;
	task = (struct task_struct *)kmalloc(sizeof(struct task_struct));
	task->pid = pid++;
	task->ppid = 0;
	kstrcpy(task->name, taskname);
	task->mm = create_new_mmstruct();
	task->state = TASK_RUNNABLE;
	task->counter = 0;	
	task->pml4e = env_setup_vm();	//virtual address
	memset((void*)task->kstack, 0, KSTACK_SIZE);
	task->next = NULL;
	kprintf("task pid is %d \n", task->pid);
	return task;
}

struct mm_struct * create_new_mmstruct()
{
	struct mm_struct *mm = NULL;
	mm = (struct mm_struct *)kmalloc(sizeof(struct mm_struct));
	mm->vma_list = NULL;
	mm->start_brk = 0;
	mm->end_brk = 0;
	mm->start_stack = 0;
	mm->arg_start = 0;
	mm->arg_end = 0;
	mm->env_start = 0;
	mm->env_end = 0;
	mm->total_vm_size = 0;
	mm->stack_vm = 0;
	return mm;
	
}