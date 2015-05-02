#include <sys/kstring.h>
#include <sys/sbunix.h>
#include <sys/syscall.h>
#include <sys/tarfs.h>
#include <sys/process/process_manager.h>
#include <sys/process/process.h>
#include <sys/vgaconsole.h>
#include <sys/kb.h>
#include <sys/process/elf.h>

#define isPresent(x)  ((x) & PT_PRESENT_FLAG)

void increament_heap_vma(struct task_struct *task, uint64_t end_brk);
void setup_memory(struct task_struct *c, struct task_struct *p);
void copy_stack(struct task_struct *c, struct task_struct *p);
void save_regs(struct task_struct *task);
void add_pipe_to_task(struct task_struct *task, struct file *pipe);
void remove_pipe_from_task(struct task_struct *task, uint64_t fd);
uint64_t is_file_pipe(struct task_struct *task, uint64_t fd);
void print_pipe_from_task(struct task_struct *task);
void write_to_pipe(struct task_struct *task, uint64_t fd, char *buf, int nbytes);
void read_from_pipe(struct task_struct *task, uint64_t fd, char *outbuf, int nbytes);

void copy_pipe(struct file *dst, struct file *src);
struct task_struct *pipe_read_wait_queue = NULL;
static char *str;
static volatile uint64_t count;
void wake_up_waiting_task();
void add_to_pipe_read_waiting_queue(struct task_struct *task);
static int pipe_write_flag = 0;

uint64_t switch_handler( uint64_t syscall_num,uint64_t first_arg,uint64_t sec_arg,uint64_t third_arg, struct regs *r)
{
	uint64_t ret = 0;
	//kprintf2("syscall no %d \n", syscall_num);
	kprintf("first arg %d second arg %p third arg %p \n", first_arg, sec_arg, third_arg);
	switch(syscall_num)
	{
		case 0: ret = system_read(first_arg,sec_arg,third_arg);    //done
				 break;
		case 1: 
				ret = system_write(first_arg,sec_arg,third_arg);     //done
				 break;
		case 2: 
				ret = system_open(first_arg,sec_arg); 				//done
				 break;
		case 60: 
				system_exit(first_arg);							//done
				 break;
		case 12: 
				//system_fork();
				 ret = system_brk(first_arg);							//done
				 break;
		case 57: 
				 ret = system_fork();								//done: TODO: cow 
				 break;
		case 39: 
				 ret = system_getpid();								//done
				 break;
		case 110: 
				 ret = system_getppid();							//done
				 break;
		case 59: 
				 system_execve(first_arg,sec_arg,third_arg);
				 break;
		case 61: 
				 system_waitpid(first_arg,sec_arg,third_arg);
	             break;
		case 35: 
				system_sleep(first_arg);							//done
				 break;
		case 37: 
				system_alarm(first_arg);
				 break;
		case 79: 
				 ret = system_getcwd(first_arg,sec_arg);
				 break;
		case 80: 
				 ret = system_chdir(first_arg);
				 break;
		case 8 : 
				 ret = system_lseek(first_arg,sec_arg,third_arg);
				 break;
		case 3 : 
				 system_close(first_arg);
			     break;
		case 22: system_pipe(first_arg); 
				 break;
		case 32: system_dup(first_arg);
				 break;
		case 33: system_dup2(first_arg,sec_arg);
				 break;
		case 78: ret = system_getdents(first_arg,sec_arg,third_arg);
		         break;
		case 81: system_readdir(first_arg,sec_arg);
		         break;
		case 82: system_listprocess();
						break;
		case 83: system_clearscreen();
						break;
		case 84: ret = system_kill(first_arg);
				break;
		default: break;
	}
	return ret;
}

uint64_t system_write(uint64_t fd,uint64_t buf,uint64_t nbytes)
{
	struct task_struct *task = get_current_task();
	if(is_file_pipe(task, fd))
	{
		//remove pipe
		char *input = (char *)buf;
		write_to_pipe(task, fd, input, nbytes);
	}
	else if(fd==1)//stdout
	{
		if(task->write_redirection_fd != 0)
		{
			//redirect data to redirected fd	
			char *input = (char *)buf;
			write_to_pipe(task, task->write_redirection_fd, input, nbytes);
			pipe_write_flag = 1;
			wake_up_waiting_task();
		}
		else
			puts((char *)buf);
		//clrscr();
		//char *b = (char *)(*sec_arg);
		//kprintf("system call no is %d \n", syscall_num);
		//kprintf("%s", buf);
		
	}
	else if(fd == 2)
	{
		puts("Error:");
		puts((char*)buf);
	}
	else
	{
		//file write	
		return fwrite(fd, (char *)buf, nbytes);
	}
	//__asm__ __volatile__("sti");
	return nbytes;
}

uint64_t system_kill(uint64_t process_id)
{
/* 	kstrcpy(envp[0],"hjfer");
	kprintf2("PATH %s \n",envp[0]); */
	//kprintf2("sycall pid %d\n",process_id);
	struct task_struct *t = get_task(process_id);
	if(t!= NULL)
	{
		free_task_struct(t);
		t->state = TASK_STOPPED;
		return 0;
	}
	return -1;
}

void system_exit(uint64_t first_arg)
{
	struct task_struct* task = get_current_task();
	//kprintf2("reached exit end1 %s \n", task->name);
	if(task->ppid > 0)	//this is child process
	{
		//remote this child from parent process	
		task->parent->state = TASK_RUNNABLE;
		remove_from_parent(task);
		
	}
	free_task_struct(task);
	task->state = TASK_STOPPED;
	set_current_task(NULL);
	//kprintf2("exit called \n");
	//kprintf2("reached exit end2 %s \n", task->name);
	__asm__ __volatile__("sti");
	__asm__ __volatile__("int $0x20;" : :);
	while(1);
	//__asm__ __volatile__("iretq;");
}

uint64_t system_brk(uint64_t end_brk)
{
//	 addr=kmalloc(first_arg);
//	 return addr;
	//if(end_brk != 0)
		//kprintf2("task name %s ,new end brk = %p \n", get_current_task()->name, end_brk);
	struct task_struct *task = get_current_task();
	if(end_brk == 0)
	{
		return task->mm->brk_end;
	}
	//uint64_t n_pages = size/PAGE_SIZE;
	//if(size%PAGE_SIZE != 0)
	//	n_pages = n_pages + 1;
	//alloc_pages_at_virt(task->mm->brk_end, task->mm->brk_end + size, PT_PRESENT_FLAG | PT_WRITABLE_FLAG | PT_USER);
	//task->mm->brk_end = task->mm->brk_end + (n_pages * PAGE_SIZE);
	task->mm->brk_end = end_brk;
	increament_heap_vma(task, end_brk);
	return task->mm->brk_end;
}

void increament_heap_vma(struct task_struct *task, uint64_t end_brk)
{
	struct vm_area_struct *temp_vma = task->mm->vma_list;
	while(temp_vma != NULL)
	{
		if(temp_vma->vma_type != VMA_HEAP)
			temp_vma = temp_vma->next;
		else
		{
			if(temp_vma->vma_type == VMA_HEAP)
			{
				//kprintf2("increament_heap_vma::task name %s ,new end brk = %p \n", get_current_task()->name, end_brk);
				//kprintf("allocating memory for heap \n");
				//kprintf("start: %p end %p \n", temp_vma->vm_start, temp_vma->vm_end);
				temp_vma->vm_end = end_brk;	
				#if 0
				uint64_t k_cr3 = read_cr3();
				write_cr3(virt_to_phy(task->pml4e, 0));
				alloc_pages_at_virt(temp_vma->vm_start , temp_vma->vm_end - temp_vma->vm_start , PT_PRESENT_FLAG | PT_WRITABLE_FLAG | PT_USER);
				kprintf("start: %p end %p \n", temp_vma->vm_start, temp_vma->vm_end);
				//uint64_t phy = virt_to_phy(task->pml4e, 0);
				//kprintf("phys is %p \n", phy);
				write_cr3(k_cr3);
				#endif
				return;
			}
		}
	}
}

void system_listprocess(){
	print_task_list();
}

void system_clearscreen(){
	clearscreen();
}

uint64_t system_getpid()
{
	struct task_struct *task = get_current_task();
	//__asm__ __volatile__("movq %[next_rsp], %%rsp" : : [next_rsp] "m" (rsp));
	return task->pid;
}

uint64_t system_getppid()
{
	struct task_struct *task = get_current_task();
	//__asm__ __volatile__("movq %[next_rsp], %%rsp" : : [next_rsp] "m" (rsp));
	return task->ppid;		
}
/*web reference: http://www.jamesmolloy.co.uk/tutorial_html/9.-Multitasking.html */
uint64_t system_fork(){
	//kprintf2("in side fork \n");
	//create child process
	//__asm__ __volatile__("cli;");
	struct task_struct *parent = get_current_task();
	struct task_struct *child = create_new_task("child");
	child->ppid = parent->pid;
	child->r = parent->r;
	child->r.rax = 0;
	//child->pipe = parent->pipe;
	//child->rip = parent->kstack[KSTACK_SIZE-6];
	//__asm__ __volatile__("movq %%rsp, %[next_rsp]" :[next_rsp] "=m" (child->rsp): );
	child->mm->brk_end = parent->mm->brk_end;
	child->e_entry = parent->kstack[KSTACK_SIZE - 6];
	child->mm->stack_vm = USER_STACK - 0x8;
	setup_memory(child, parent);
	//copy_pipe(child, parent);
	child->parent = parent;
	parent->child_count++;
	//copy_stack(child, parent);
	//kprintf("parent stack entry %d \n", parent->kstack[KSTACK_SIZE-1]);
	//schedule_process();
	kprintf("child pid %d \n",child->pid);
	//child->kstack[KSTACK_SIZE - 9] = 0UL;  //rax for child
	//add_to_task_list(child);
	//print_task_list();
	//__asm__ __volatile__("sti");
	//__asm__ __volatile__("int $0x20;" : :);
	child->write_redirection_fd = parent->write_redirection_fd;
	child->read_redirection_fd = parent->read_redirection_fd;
	struct file *temp, *pipe;
	if(parent->pipe != NULL)
	{
		temp = parent->pipe;
		while(temp != NULL)
		{
			pipe = kmalloc(sizeof(struct file));
			copy_pipe(pipe, temp);
			//memcpy((void *)pipe, (void *)temp, sizeof(struct file));
			//kprintf2("adding fd = %d \n", pipe->fd);
			add_pipe_to_task(child, pipe);
			temp = temp->next;
		}
		//kprintf2("shashi \n");
		//while(1);
	}
	//pipe = kmalloc(sizeof(struct file));
	//temp = parent->pipe;
	//copy_pipe(pipe, temp);
	//kprintf2("adding fd = %d \n", pipe->fd);
	parent->r.rax =  child->pid;
	parent->state = TASK_RUNNABLE;
	set_current_task(NULL);
	//kprintf2("reached exit end \n");
	__asm__ __volatile__("sti");
	__asm__ __volatile__("int $0x20;" : :);
	//while(1);
	//return child->pid;
	return 0;
	//copy stack
	//map other vmas
}
extern void irq0();
#if 0
void copy_pipe(struct task_struct *c, struct task_struct *p)
{
	if(parent->pipe == NULL)
		return;
	struct file *temp = parent->pipe;
	while(temp != NULL)
	{
		file 	
	}
}
#endif

void copy_stack(struct task_struct *c, struct task_struct *p)
{
	//int i = 1;
	//while(p->kstack[KSTACK_SIZE - i] == 0)
	//	i++;
 
	//if(task->ppid == current_task->pid)
//	{
		c->rip = p->kstack[KSTACK_SIZE - 7];   //rip
		c->rsp = p->kstack[KSTACK_SIZE - 4];   //rsp
		//p->rip = p->kstack[KSTACK_SIZE - 7];   //rip
	//	p->rsp = p->kstack[KSTACK_SIZE - 4];   //rsp
		//c->kstack[KSTACK_SIZE-21] = (uint64_t)irq0 + 0x20;
		//c->rsp = (uint64_t)&c->kstack[KSTACK_SIZE-22];//c->kstack[KSTACK_SIZE - 21];
//	}

	//c->kstack[504] = p->kstack[KSTACK_SIZE - i - 6];//rax
	//c->kstack[503] = p->kstack[KSTACK_SIZE - i - 7];//rbx
	//c->kstack[502] = p->kstack[KSTACK_SIZE - i - 8];//rcx
	//c->kstack[501] = p->kstack[KSTACK_SIZE - i - 9];//rdxs
}

void setup_memory(struct task_struct *c, struct task_struct *p)
{
	//uint64_t kern_cr3 = read_cr3();
	struct vm_area_struct *vm_list = p->mm->vma_list;
	struct vm_area_struct *vma = NULL;
	uint64_t paddr;
	uint64_t start, end;
	//uint64_t k_cr3 = read_cr3();
	while(vm_list != NULL)
	{
		start = vm_list->vm_start;
		end = vm_list->vm_end;
		vma = create_vma(c->mm, start, end, vm_list->vma_type, vm_list->vm_flags, vm_list->vm_file_descp);
		add_to_vma_list(c->mm, vma);
		kprintf("vma type: %d \n", vm_list->vma_type);
		if(vm_list->vma_type == VMA_STACK)
		{
			//vm_list = vm_list->next;
			//continue;
			//stack vma create new physical page and 
			//uint64_t stack_vaddr =  ALIGN_DOWN(start) - PAGE_SIZE;
			//kprintf("start: %p , after alignment: %p \n", start, ALIGN_UP(start));
			//#if 0
			kprintf("start: %p \n", start);
			uint64_t vaddr = ALIGN_UP(start) - 4096;
			while(vaddr >= end)
			{
				//write_cr3(virt_to_phy(p->pml4e, 0));   //load parent process cr3
				uint64_t parent_page = virt_to_phy(vaddr, 0);
				if(parent_page != 0)
				{
					//write_cr3(k_cr3);
					uint64_t dummy_vaddr = alloc_pages(1, PT_PRESENT_FLAG | PT_USER | PT_WRITABLE_FLAG);
					uint64_t phy_addr = virt_to_phy(dummy_vaddr, 0);
						//map_virt_to_phy(virt, phy_addr, flags);
					//write_cr3(virt_to_phy(p->pml4e, 0));   //load parent process cr3
					//copy alll the contents from parent process and 
					memcpy((void *)dummy_vaddr, (void *) vaddr, PAGE_SIZE);
					//then map this page in child process
					//remove dummy page entry from parent
					//unmap_phy(dummy_vaddr);
					write_cr3(virt_to_phy(c->pml4e, 0));     //load child process cr3 to map vma
					//alloc_pages_at_virt(vaddr, PAGE_SIZE, PT_PRESENT_FLAG | PT_USER | PT_WRITABLE_FLAG);
					//kprintf2("before \n\n");
					map_virt_to_phy(vaddr, phy_addr, PT_PRESENT_FLAG | PT_USER | PT_WRITABLE_FLAG);
					//kprintf2("after \n\n");
					write_cr3(virt_to_phy(p->pml4e, 0));
					//kprintf2("mapped vaddr = %p \n", vaddr);
				}
				vaddr = vaddr - PAGE_SIZE;
			}
			//#endif
		}
		else
		{
			//copy of vma
			//kprintf("start: %p , end: %p \n", start, end);
			uint64_t vaddr = ALIGN_DOWN(start);
			while(vaddr < end)
			{
				//TODO: cow bit set and unset writable bit in flags
				//write_cr3(virt_to_phy(p->pml4e, 0));   //load parent process cr3
				//kprintf2("vaddr %p , end %p \n", vaddr, end);
				paddr = virt_to_phy(vaddr, 0);      // get physical page from parent process page table
				//TODO:remove write permission and set cow bit
				//uint64_t *pte = get_pte_entry(vaddr);
				//reset_writable_bit(pte);
				//set_cow_bit(pte);
				//uint64_t flags = *pte & 0xFFF000000000000F;				
				//kprintf("pte entry is %p \n", pte);
				//uint64_t flags = paddr & 0xFFF0000000000FFFUL;
				write_cr3(virt_to_phy(c->pml4e, 0));     //load child process cr3 to map vma
				//alloc_pages_at_virt(vaddr, paddr, PT_PRESENT_FLAG | PT_WRITABLE_FLAG | PT_USER);  //map that page into child's process page table
				//kprintf2("before \n\n");
				//map_virt_to_phy(vaddr, paddr, PT_PRESENT_FLAG | PT_WRITABLE_FLAG | PT_USER);
				
				map_virt_to_phy(vaddr, paddr, PT_PRESENT_FLAG | PT_WRITABLE_FLAG | PT_USER);
				//pte = get_pte_entry(vaddr);
				//reset_writable_bit(pte);
				//set_cow_bit(pte);
				//kprintf2("paddr: %p \n", paddr);
				//kprintf2("between \n\n");
				inc_ref_count(paddr);
				//kprintf2("after \n\n");
				//pte = get_pte_entry(vaddr);
			//	kprintf2("mapped vaddr:%p pte:%p \n", vaddr, *pte);
				//reset_writable_bit(pte);
				write_cr3(virt_to_phy(p->pml4e, 0));   //load parent process cr3
				vaddr = vaddr + PAGE_SIZE;
			}
		}
		//write_cr3(kern_cr3);
		vm_list = vm_list->next;
	}
	//write_cr3(k_cr3); //reload parent process's page table again at the end
}

int system_open(uint64_t filepath,uint64_t perm){
	
	int fd = fopen((char *)filepath);
	//kprintf2("fd inside system_open filename is %s and fd %d \n",(char *)filepath, fd);
	/*__asm__(
		"movq %0,%%rax;"
		:"=g"(fd)
		:);*/
	//__asm__ __volatile__("iretq;");
	return fd;
	//__asm__ __volatile__("sti");
}
void system_execve(uint64_t filename, uint64_t argv_addr, uint64_t envp_addr)
{
	
	char *argv[10];
	int i = 0;
	while(((char **)argv_addr)[i] != NULL)
	{
		argv[i] = kmalloc(strlen(((char **)argv_addr)[i]));
		//kprintf2("%s \n", ((char **)argv_addr)[i]);
		//argv[i] = 
		//argv[i] = kmalloc(strlen(((char **)argv_addr)[i]));
		kstrcpy(argv[i], ((char **)argv_addr)[i]);
		//strcat(argv[i], "\0");
		//memcpy(argv[i], ((char **)argv_addr)[i], strlen(((char **)argv_addr)[i]));
		//kprintf2("%s \n", ((char **)argv_addr)[0]);
		//kprintf2("%s \n", argv[i]);
		i++;
	}
	
	char *envp[10];
	//envp[0] = "PATH=bin:\0";
/* 	envp[0] = ((char **)envp_addr) [0];
	strcat(envp[0], "\0"); */
	envp[0] = kmalloc(strlen(((char **)envp_addr)[0]));
	kstrcpy(envp[0],((char **)envp_addr) [0]);
	//kprintf2("execve %s \n", envp[0]);
	/*char *argv[10];
	argv[0] = "abc\0";
	argv[1] = "shashi.txt\0";
	argv[2] = "shashi\0";
	char *envp[10];
	//kstrcpy(envp[0], "PATH=");
	envp[0] = "PATH=bin:\0";
	envp[1] = "shashi";
	*/
	char *fname = (char *)filename;
	struct task_struct *curr_task = get_current_task();
	struct task_struct *task = readElf(fname, argv, i, envp, 1);
	task->pid = curr_task->pid;
	task->ppid = curr_task->ppid;
	curr_task->ppid = 0;
	task->parent = curr_task->parent;
	task->write_redirection_fd = curr_task->write_redirection_fd;
	task->read_redirection_fd = curr_task->read_redirection_fd;
	
	struct file *temp, *pipe;
	if(curr_task->pipe != NULL)
	{
		temp = curr_task->pipe;
		while(temp != NULL)
		{
			pipe = kmalloc(sizeof(struct file));
			copy_pipe(pipe, temp);
			//memcpy((void *)pipe, (void *)temp, sizeof(struct file));
			//kprintf2("adding fd = %d \n", pipe->fd);
			add_pipe_to_task(task, pipe);
			temp = temp->next;
		}
		//kprintf2("shashi \n");
		//while(1);
	}
	//kprintf2("everything done!! %s \n",task->name);
	//readElf("bin/cat", argv, 2, envp,1);
	//task = get_current_task();
	//free_task_struct(task);
	//set_current_task(NULL);
	//__asm__ __volatile__("sti");
	//__asm__ __volatile__("int $0x20;" : :);
	//while(1);
}

uint64_t system_waitpid(uint64_t child_pid, uint64_t status , uint64_t options)
{	
	struct task_struct *task = get_current_task();
	uint64_t *st = (uint64_t*) status ;
	if(task->child_count == 0)
	{
		//no children
		*st = -1;
		return -1;
	}	
	else{
		task->state = TASK_WAITING;
		task->wait_for_child_pid = child_pid;
	}	
	set_current_task(NULL);
	__asm__ __volatile__("sti");
	__asm__ __volatile__("int $0x20;" : :);
	*st = -1;
	return child_pid;
}

uint64_t system_read(uint64_t fd,uint64_t buf,uint64_t nbytes)
{
	//uint64_t nbytes =0;
	//kprintf2("system read \n");
	struct task_struct *task = get_current_task();
	if(is_file_pipe(task, fd))
	{
		//remove pipe
		char *outbuf = (char *)buf;
		read_from_pipe(task,fd, outbuf, nbytes);
	}
	
	else if(fd==0) //stdin
	{
		if(task->read_redirection_fd != 0)
		{
			//read from redirected fd	
			
			//char *outbuf = (char *)buf;
			if(pipe_write_flag == 1)
			{
				pipe_write_flag = 0;
				read_from_pipe(task, task->read_redirection_fd, (char *)buf, nbytes);
			}
			else
			{
				str = (char *)buf;
				count = nbytes;
				add_to_pipe_read_waiting_queue(task);
				__asm__ __volatile__("sti");
				__asm__ __volatile__("int $0x20;" : :);
			}
			
		}
		//__asm__ __volatile__("sti");
		else
		{
			set_flag();
			task->state = TASK_WAITING;
			set_current_task(NULL);
			set_waiting_task(task);
			//kprintf2("reached \n");
			gets(buf, nbytes);
			__asm__ __volatile__("sti");
			__asm__ __volatile__("int $0x20;" : :);	
		}
		
		//while(get_flag() == 1);
		//{
		 	//__asm__ __volatile__("int $0x20;" : :);
	//	}
		
	}
	else
	{
		return fread(fd,(char *)buf,nbytes);	
	}
	return 0;
}

void system_sleep(uint64_t sec){
	__asm__ __volatile__("cli;");
	//clrscr();
	struct task_struct *task = get_current_task();
	task->state = TASK_SLEEP;
	task->sleep_time = sec - 1;
	set_current_task(NULL);
	//save_regs(task);
	__asm__ __volatile__("sti");
	__asm__ __volatile__("int $0x20;" : :);
	while(1);
	//schedule_process();
	 //__asm__ __volatile__("sti;");
	//__asm__ __volatile__("int $32;");
	//__asm__ __volatile__("int $0x20;" : :);
}

void save_regs(struct task_struct *task)
{
	int i = 1;
	while(task->kstack[KSTACK_SIZE - i] == 0)
		i++;
	task->rsp = task->kstack[KSTACK_SIZE - i - 1];
	task->rip = task->kstack[KSTACK_SIZE - i - 4];	
}

void system_alarm(uint64_t first_arg){
	
}
uint64_t system_getcwd(uint64_t buf, uint64_t size_t){
	//char *curr_cwd = get_cwd();
	//kprintf2("In getcwd \n");
	//char *currrent_dir = kmalloc(strlen(curr_cwd));
	kstrcpy((char *)buf, get_cwd());
	//kprintf2("buf is %s \n",buf);
	return buf;
}
uint64_t system_chdir(uint64_t path){
	int fd = fopen((char*)path);
	//kprintf2("path: %s , fd = %d \n", (char *)path, fd);
	if(fd<0)
		return -1;
	else
		{
		set_cwd((char*)path);
	}
	return 0;
}
uint64_t system_lseek(uint64_t fd,uint64_t offset,uint64_t whence){
	return fseek(fd,offset,whence);
}	
void system_close(uint64_t fd){
	struct task_struct *task = get_current_task();
	if(is_file_pipe(task, fd))
	{
		//remove pipe
		remove_pipe_from_task(task,fd);
		if(task->write_redirection_fd == fd)
			task->write_redirection_fd = 0;
		else if(task->read_redirection_fd == fd)
			task->read_redirection_fd = 0;
		print_pipe_from_task(task);
	}
	else
		fclose(fd);
}

void copy_pipe(struct file *dst, struct file *src)
{
	kstrcpy(dst->name, src->name); 	
	dst->addr = src->addr ;
	dst->fd = src->fd;
	dst->size = src->size;
	dst->offset = src->offset;
	dst->next = NULL;	
}

void system_pipe(uint64_t fds){
//	int fd[] = (int)fds;
	struct task_struct *task = get_current_task();
	struct file *p1 = NULL;
	struct file *p2 = NULL;
	p1 = kmalloc(sizeof(struct file)); 
	p2 = kmalloc(sizeof(struct file)); 
	
	
	kstrcpy(p1->name,"pipe1"); 
	kstrcpy(p2->name,"pipe2"); 
	
	uint64_t addr = alloc_pages(1, PT_PRESENT_FLAG | PT_WRITABLE_FLAG | PT_USER);
	p1->addr = p2->addr = addr;//allocate 1 page in user environment for this pipe
	
	p1->fd = get_fdcount();
	set_fdcount(get_fdcount() + 1);
	p2->fd = get_fdcount();
	set_fdcount(get_fdcount() + 1);
	
	//f->type = atoi(ustart->typeflag);
	p1->size = p2->size = PAGE_SIZE;
	p1->offset = p2->offset = 0;
	p1->next = p2->next = NULL;
	add_pipe_to_task(task, p1);
	add_pipe_to_task(task, p2);
	//kprintf2("system_fork: fd1= %d and fd2= %d \n", p1->fd, p2->fd);
	((int *)fds)[0] = p1->fd;
	((int *)fds)[1] = p2->fd;
}
void system_dup(uint64_t first_arg){
	
}
void system_dup2(uint64_t dstfd,uint64_t srcfd)
{
	struct task_struct * task = get_current_task();
	if(srcfd == 1)
	{
		task->write_redirection_fd = dstfd;	
	}
	else if(srcfd == 0)
	{
		//stdin redirection to new fds
		task->read_redirection_fd = dstfd;
	}
}

uint64_t system_getdents(uint64_t fd,uint64_t buf,uint64_t size){
	//clrscr();
//    dread(fd);
	struct dirent *dir = kmalloc(sizeof(struct dirent));
	
	//kprintf("fd inside system_getdents %d \n",fd);
	struct file *r = dopen(fd,buf);
	if(r == NULL)
	{
		return -1;
	}
	dir->d_ino = r->fd;
	dir->d_off = r->offset;
	dir->d_reclen = r->size;
	kstrcpy(dir->d_name, r->name);
	
	//kprintf2("%p \n", (uint64_t)r);
	uint64_t k_cr3 = read_cr3();
	struct task_struct * task = get_current_task();
	write_cr3(virt_to_phy(task->pml4e, 0));
	//
	//write_cr3(virt_to_phy(task->pml4e, 0)); 
	//buf =
	
	memcpy((void *)buf, (void *) dir, sizeof(struct dirent));
	write_cr3(k_cr3);
	//write_cr3(k_cr3);
	return 0;	

}

void system_readdir(uint64_t addr,uint64_t buf){
/* 	dread(addr); */
	struct dirent *temp = (struct dirent *)addr;
	struct file *dir = kmalloc(sizeof(struct file));
	kstrcpy(dir->name, temp->d_name);
	dir->fd = temp->d_ino;
	//kprintf2("fd %d",dir->fd);
    struct file *r = dread(dir);
	if(r == NULL)
	{
		return;
	}
	temp->d_ino = r->fd;
	temp->d_off = r->offset;
	temp->d_reclen = r->size;
	kstrcpy(temp->d_name, r->name);
	memcpy((void *)buf, (void *) temp, sizeof(struct dirent));
	
}

void add_pipe_to_task(struct task_struct *task, struct file *pipe)
{
	struct file *temp;
	if(task->pipe == NULL)
	{	
		task->pipe = pipe;
		task->pipe->next = NULL;
		return;
	}
	else
	{
		temp = task->pipe;
		while(temp->next != NULL)
			temp = temp->next;
		temp->next = pipe;
	}
	temp->next->next = NULL;
}

uint64_t is_file_pipe(struct task_struct *task, uint64_t fd)
{
	struct file *temp;
	if(task->pipe == NULL)
		return 0;
	else
	{
		temp = task->pipe;
		while(temp != NULL)
		{
			if(temp->fd == fd)
				return 1;
			temp = temp->next;
		}
	}
	return 0;
}
void print_pipe_from_task(struct task_struct *task)
{
	struct file *temp = NULL;
	temp = task->pipe;
	while(temp != NULL)
	{
		//kprintf2("inside syscall: fd:%d \n",temp->fd);
		temp=temp->next;
	}
}
void remove_pipe_from_task(struct task_struct *task, uint64_t fd)
{
	
	if(task == NULL)
		return;
	if(task->pipe == NULL)
		return;
	if(task->pipe->fd == fd)
	{
		
		task->pipe = task->pipe->next;
		//kfree((uint64_t)temp, sizeof(struct file));
		return;
	}
	else
	{
		struct file *prev = task->pipe;
		struct file *curr = task->pipe->next;
		
		while(curr != NULL)
		{
			if(curr->fd == fd)
			{
				prev->next = curr->next;
				//kfree((uint64_t)curr, sizeof(struct file));
				return;
			}
			prev = curr;
			curr = curr->next;
		}
	}
}

void write_to_pipe(struct task_struct *task, uint64_t fd, char *buf, int nbytes)
{
	//kprintf2("Writing to pipe \n");
	struct file *temp;
	if(task->pipe == NULL)
		return;
	else
	{
		temp = task->pipe;
		while(temp != NULL)
		{
			if(temp->fd == fd)
			{
				uint64_t addr = temp->addr + temp->offset;
				memcpy((void *)addr, (void *) buf, nbytes);
				//kprintf2("data in pipe written is %s \n", (char *)addr);
				temp->offset = temp->offset+nbytes;
			}	
			temp = temp->next;
		}
	}
	return;
}

void read_from_pipe(struct task_struct *task, uint64_t fd, char *outbuf, int nbytes)
{
	//kprintf2("reading from pipe \n");
	struct file *temp;
	if(task->pipe == NULL)
		return;
	else
	{
		temp = task->pipe;
		while(temp != NULL)
		{
			if(temp->fd == fd)
			{
				memcpy((void *)outbuf, (void *) (temp->addr+temp->offset), nbytes);
		   		temp->offset = temp->offset+nbytes;
				kprintf("read data is : %s \n", outbuf);
			}	
			temp = temp->next;
		}
	}
	return;
}

void add_to_pipe_read_waiting_queue(struct task_struct *task)
{
	task->state = TASK_WAITING;
	set_current_task(NULL);
	pipe_read_wait_queue = task;
}

void wake_up_waiting_task()
{
	if(pipe_read_wait_queue != NULL)
	{
		pipe_read_wait_queue->state = TASK_RUNNABLE;
		read_from_pipe(pipe_read_wait_queue, pipe_read_wait_queue->read_redirection_fd, str, count);
		pipe_write_flag = 0;
	}
}
