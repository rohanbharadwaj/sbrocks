#include <sys/process/process.h>
#include <sys/mmu/kmalloc.h>
static uint64_t pid = 0;
struct task_struct *task_list = NULL;
struct task_struct *free_task_list = NULL;
struct vm_area_struct *free_vm_list = NULL;

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

void add_to_free_task_list(struct task_struct *task){
	if(free_task_list==NULL) {
		free_task_list = task;	
		free_task_list->next = NULL;
	}
	else
	{	
		task->next = free_task_list;
		free_task_list = task;
	}	
}

struct task_struct* get_free_task(){
	struct task_struct *task;
	if(free_task_list!=NULL){ // If found free in task list 
		task = free_task_list;
		free_task_list = free_task_list->next;
		return task;
	}	
	//if no free task
	task = (struct task_struct *)kmalloc(sizeof(struct task_struct));
	return task; 

}


void add_to_free_vm_list(struct vm_area_struct *vma){
	if(free_vm_list==NULL) {
		free_vm_list = vma;
		free_vm_list->next = NULL;	
	}
	else
	{	
		vma->next = free_vm_list;
		free_vm_list = vma;
	}	
}

struct vm_area_struct* get_free_vma(){
	struct vm_area_struct *vma;
	if(free_vm_list!=NULL){ // If found free in task list 
		vma = free_vm_list;
		free_vm_list = free_vm_list->next;
		return vma;
	}	
	//if no free task
	vma = (struct vm_area_struct *)kmalloc(sizeof(struct vm_area_struct));
	return vma; 

}




void remove_from_task_list(struct task_struct *task){
	task->state = TASK_STOPPED;



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
	// TODO : Get trask struct from free_task_list
	// Else kmalloc
	//task = (struct task_struct *)kmalloc(sizeof(struct task_struct));
	task = get_free_task();
	task->pid = pid++;
	task->ppid = 0;
	kstrcpy(task->name, taskname);
	task->mm = create_new_mmstruct();
	task->state = TASK_RUNNABLE;
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

void free_task_struct(struct task_struct *task)
{

  uint64_t old_cr3 = read_cr3();
  write_cr3(virt_to_phy(task->pml4e, 0));
  task->state = TASK_STOPPED;
  //counter removed fromt ask 
  task->next = NULL;
  task->e_entry = 0;
  task->rip = 0;
  task->rsp = 0;
  //remove all page table entries
  reset_page_tables(task->pml4e);
  //clear kstack
  memset(task->kstack, 0, 512);
  free_task_mm_struct(task->mm);
  write_cr3(old_cr3);	
  task->pml4e = 0;
  //kfree(task);
  //add_to_free_task_list(task);
}

void free_task_mm_struct(struct mm_struct *mm){
	struct vm_area_struct *vma = mm->vma_list;
	mm->total_vm_size = 0;
	mm->stack_vm = 0;
	while(vma!=NULL){
		kfree(vma->vm_start,vma->vm_end-vma->vm_start);
		memset((void*)vma->vm_start,0,vma->vm_end-vma->vm_start);
		vma->vm_mm = NULL;
		vma->vm_start = 0;
		vma->vm_end = 0;
		vma->vm_flags = 0;
		vma->vm_file_descp = 0;
		add_to_free_vm_list(vma);
		vma = vma->next;
	}
}