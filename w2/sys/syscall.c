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
				 system_chdir(first_arg);
				 break;
		case 8 : 
				 system_lseek(first_arg,sec_arg,third_arg); 
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
		case 81: system_readdir(first_arg);
		         break;
		default: break;
	}
	return ret;
}

uint64_t system_write(uint64_t fd,uint64_t buf,uint64_t nbytes)
{
	if(fd==1)//stdout
	{
		//clrscr();
		//char *b = (char *)(*sec_arg);
		//kprintf("system call no is %d \n", syscall_num);
		//kprintf("%s", buf);
		puts((char *)buf);
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



void system_exit(uint64_t first_arg)
{
	struct task_struct* task = get_current_task();
	if(task->ppid > 0)	//this is child process
	{
		//remote this child from parent process	
		remove_from_parent(task);
	}
	//free_task_struct(task);
	task->state = TASK_STOPPED;
	set_current_task(NULL);
	//kprintf2("reached exit end \n");
	__asm__ __volatile__("sti");
	__asm__ __volatile__("int $0x20;" : :);
	while(1);
	//__asm__ __volatile__("iretq;");
}

uint64_t system_brk(uint64_t end_brk)
{
//	 addr=kmalloc(first_arg);
//	 return addr;
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
	while(temp_vma->next != NULL)
	{
		if(temp_vma->vma_type != VMA_HEAP)
			temp_vma = temp_vma->next;
		else
		{
			if(temp_vma->vma_type == VMA_HEAP)
			{
				kprintf("allocating memory for heap \n");
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
	//create child process
	//__asm__ __volatile__("cli;");
	struct task_struct *parent = get_current_task();
	struct task_struct *child = create_new_task("child");
	child->ppid = parent->pid;
	child->r = parent->r;
	child->r.rax = 0;
	//child->rip = parent->kstack[KSTACK_SIZE-6];
	//__asm__ __volatile__("movq %%rsp, %[next_rsp]" :[next_rsp] "=m" (child->rsp): );
	child->mm->brk_end = parent->mm->brk_end;
	child->e_entry = parent->kstack[KSTACK_SIZE - 6];
	child->mm->stack_vm = USER_STACK - 0x8;
	setup_memory(child, parent);
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
	return child->pid;
	//return 0;
	//copy stack
	//map other vmas
}
extern void irq0();

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
					//alloc_pages_at_virt(vaddr, phy_addr, PT_PRESENT_FLAG | PT_USER | PT_WRITABLE_FLAG);
					map_virt_to_phy(vaddr, phy_addr, PT_PRESENT_FLAG | PT_USER | PT_WRITABLE_FLAG);
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
				uint64_t *pte = get_pte_entry(vaddr);
				
				kprintf("pte entry is %p \n", pte);
				//reset_writable_bit(pte);
				//uint64_t flags = *pte & 0xFFF0000000000FFF;
				//set_cow_bit(pte);
				kprintf("pte entry is %p \n", pte);
				//uint64_t flags = paddr & 0xFFF0000000000FFFUL;
				write_cr3(virt_to_phy(c->pml4e, 0));     //load child process cr3 to map vma
				//alloc_pages_at_virt(vaddr, paddr, PT_PRESENT_FLAG | PT_WRITABLE_FLAG | PT_USER);  //map that page into child's process page table
				map_virt_to_phy(vaddr, paddr, PT_PRESENT_FLAG | PT_WRITABLE_FLAG | PT_USER);
				pte = get_pte_entry(vaddr);
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
	kprintf("fd inside system_open %d \n",fd);
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
	//char *argv1[10];
	//char *a = (char *)((char *)argv_addr);
	//char **argv1[10];
	//argv1 = argv_addr;
	//argv1[0] = (char *)argv_addr;
	//argv1[1] = (char *)argv_addr;
	//argv1[2] = (char *)argv_addr;
	//char *argv1[] = (char *)argv_addr;
	//argv1 = argv_addr;
	//kprintf("filename is %s \n", argv1[0]);
	char *fname = (char *)filename;
	kprintf("filename is %s \n", fname);
 	char *argv[10];
	
	argv[0] = "abc\0";
	argv[1] = "def\0";
	struct task_struct *task = readElf(fname, argv, 2);
	kprintf("id is %d \n", task->pid);
	task = get_current_task();
	free_task_struct(task);
	set_current_task(NULL);
	__asm__ __volatile__("sti");
	__asm__ __volatile__("int $0x20;" : :);
	while(1);
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
	if(fd==0) //stdin
	{
		//__asm__ __volatile__("sti");
		struct task_struct *task = get_current_task();
		set_flag();
		task->state = TASK_WAITING;
		set_current_task(NULL);
		set_waiting_task(task);
		//kprintf2("reached \n");
		gets(buf, nbytes);
		__asm__ __volatile__("sti");
		__asm__ __volatile__("int $0x20;" : :);
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
	//char *currrent_dir = kmalloc(strlen(curr_cwd));
	kstrcpy((char *)buf, get_cwd());
	return buf;
}
void system_chdir(uint64_t path){
	set_cwd((char*)path);
}
void system_lseek(uint64_t first_arg,uint64_t sec_arg,uint64_t third_arg){
	
}	
void system_close(uint64_t fd){
	fclose(fd);
}
void system_pipe(uint64_t first_arg){
	#if 0
	//struct task_struct *task = get_current_task();
	struct file *f = NULL;
	f = kmalloc(sizeof(struct file)); 
	kstrcpy(f->name,"pipe"); 
	f->addr = 1;//allocate 1 page in user environment for this pipe
	f->fd = get_fdcount();
	fd_count++;
	//f->type = atoi(ustart->typeflag);
	f->size = PAGE_SIZE;
	f->offset=0;
	f->next = NULL;
	#endif
}
void system_dup(uint64_t first_arg){
	
}
void system_dup2(uint64_t first_arg,uint64_t sec_arg){
	
}
#if 0
struct dirent
{
	long d_ino;					/* file number of entry */
	off_t d_off;				
	unsigned short d_reclen;	/* length of this record */
	char d_name [NAME_MAX+1];	/* name must be no longer than this */
};
#endif

uint64_t system_getdents(uint64_t fd,uint64_t buf,uint64_t size){
	//clrscr();
//    dread(fd);
	struct dirent *dir = kmalloc(sizeof(struct dirent));
	
	//kprintf("fd inside system_getdents %d \n",fd);
	struct file *r = dopen(fd,buf);
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
	//kprintf("return from tarfs %p \n",r);
	//buf = r;
	/*__asm__(
		"movq %0,%%rax;"
		:"=g"(fd)
		:);*/
	//__asm__ __volatile__("iretq;");
//	buf = dopen(fd);
/* 	return fd;	 */
}

void system_readdir(uint64_t addr){
/* 	dread(addr); */
}




