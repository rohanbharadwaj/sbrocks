/*
web references:  http://www.brokenthorn.com/Resources/OSDev24.html
*/

#include <sys/process/elf.h>
#include <sys/tarfs.h>
#include <sys/mmu/assemblyutil.h>
#include <sys/process/process_manager.h>


void print_vma_list(struct mm_struct *mm);
void test(uint64_t start);
void setup_stack(struct task_struct *task, char *argv[], int argc, char *envp[], int envc);

struct task_struct *readElf(char *filename, char *argv[], int argc, char *envp[], int envc)
{
	//Elf64_Ehdr	
	uint64_t start, end, flags, fd;
	struct vm_area_struct *vma;
	uint64_t offset= find_offset_for_file(filename);
	//kprintf("file name found is %s \n",ustart->name);
	Elf64_Ehdr *elf_header = (Elf64_Ehdr *)(&_binary_tarfs_start+ offset);
	//kprintf("e_phnum in elf header is %d \n",elf_header->e_phnum);
	/*kprintf("\n\n e_ident in elf header is %s \n",elf_header->e_ident);
	kprintf("e_type in elf header is %d \n",elf_header->e_type);
	kprintf("e_machine in elf header is %d \n",elf_header->e_machine);
	kprintf("e_version in elf header is %p \n",elf_header->e_version);
	kprintf("e_entry in elf header is %p \n",elf_header->e_entry);
	kprintf("e_phoff in elf header is %d \n",elf_header->e_phoff);
	kprintf("e_shoff in elf header is %d \n",elf_header->e_shoff);
	kprintf("e_flags in elf header is %p \n",elf_header->e_flags);
	kprintf("e_ehsize in elf header is %d \n",elf_header->e_ehsize);
	kprintf("e_phentsize in elf header is %d \n",elf_header->e_phentsize);
	kprintf("e_phnum in elf header is %d \n",elf_header->e_phnum);
	kprintf("e_shentsize in elf header is %d \n",elf_header->e_shentsize);
	kprintf("e_shnum in elf header is %d \n",elf_header->e_shnum);
	kprintf("e_shstrndx in elf header is %d \n",elf_header->e_shstrndx);*/
	struct task_struct *task = create_new_task(filename);
	task->e_entry = elf_header->e_entry;
	kprintf("tsk name is %s \n", task->name);
	uint64_t old_cr3 = read_cr3();
	//kprintf("old cr3 is %p \n", old_cr3);
    
	//struct mm_struct *mm = create_new_mmstruct();
	int pgm_hdr_num = elf_header->e_phnum;
	Elf64_Phdr *phdr = (Elf64_Phdr *)((void*)elf_header + elf_header->e_phoff);
	//kprintf("p_vaddr in program header is %p \n",phdr->p_vaddr);
	//kprintf2("program headers are %d \n", pgm_hdr_num);
	//clrscr();
	for(int i = 0; i < pgm_hdr_num; i++)
	{
		//kprintf("phdr type %p \n", phdr->p_type);
		kprintf("phdr type \n");
		kprintf("start %p and end %p \n",  phdr->p_vaddr, phdr->p_vaddr + phdr->p_memsz);
		if(phdr->p_type == PT_LOAD)
		{
			
			kprintf("phdr type \n");
			start = phdr->p_vaddr;
			end = phdr->p_vaddr + phdr->p_memsz;
			flags = phdr->p_flags;
			fd = 0;
			
			//struct vm_area_struct * create_vma(struct mm_struct *vm_mm, 
			//								   uint64_t start, uint64_t end, uint64_t flags, uint64_t fd);
			//test(start);
			//char *addr= (char *)start;
			//addr = "";
			//kprintf("main1 %p\t%s\n", addr, addr);
			
			//void *destination = (void *)start;
			//uint8_t *dest = (uint8_t *)destination;
			//uint64_t phy = virt_to_phy(start, 0);
			//kprintf("physical address is %p \n", phy);
			//*dest = 'c';
			
			vma = create_vma(task->mm, start, end, VMA_NORMAL, flags, fd);
			add_to_vma_list(task->mm, vma);
			//kprintf("phdr type %c \n", *dest);
			//memset((void*)start, 0, phdr->p_memsz);
			write_cr3(virt_to_phy(task->pml4e, 0));
			kprintf("loadable start %p and end %p \n", start, start+ phdr->p_memsz);
			//kprintf2("shashi \n\n\n");
			if(phdr->p_flags == 0)   //text
			//todo check for flag permissions if text then read,execute,user flags
				alloc_pages_at_virt(start, phdr->p_memsz, PT_PRESENT_FLAG | PT_USER);
			else
				//TODO: read write user flags
				alloc_pages_at_virt(start, phdr->p_memsz, PT_PRESENT_FLAG | PT_WRITABLE_FLAG | PT_USER);
			//uint64_t vad = 0x602190UL;
			//kprintf("0x602190UL => %p \n", virt_to_phy(vad, 0));
			memcpy((void *)start, (void *) elf_header + phdr->p_offset, phdr->p_filesz);
			//kprintf("shahsi %c\n", *addr);
			//kprintf("phdr type \n");
			memset((void*)start + phdr->p_filesz, 0, phdr->p_memsz - phdr->p_filesz);
			write_cr3(old_cr3);
			//kprintf("phdr type \n");
			//kprintf("vma address is %p \n", vma->vm_start);
			
			task->mm->total_vm_size += phdr->p_memsz;
			//kprintf("phdr type \n");
			//write_cr3(old_cr3);
		}
		phdr = (Elf64_Phdr *)((void*)phdr + elf_header->e_phentsize);
		//kprintf("p_vaddr in program header is %p \n",phdr->p_vaddr);
	}
	//process heap vma
	task->mm->brk_start = USER_HEAP;
	task->mm->brk_end = USER_HEAP;
	vma = create_vma(task->mm, USER_HEAP, USER_HEAP, VMA_HEAP, VM_RW, 0);
	add_to_vma_list(task->mm, vma);
	
	//process stack vma
	vma = create_vma(task->mm, USER_STACK, USER_STACK - USER_STACK_SIZE, VMA_STACK, VM_RW, 0);
	add_to_vma_list(task->mm, vma);
	task->mm->total_vm_size += USER_STACK_SIZE;
	setup_stack(task, argv, argc, envp, envc);
	write_cr3(old_cr3);
	task->r.rsp = task->mm->stack_vm;
	task->r.rip = task->e_entry;
	//stack initialize
	//print_vma_list(task->mm);
	//add_to_task_list(task);
	/*struct task_struct *t = get_current_task();
	if(t == NULL)*/
	//load_process(task, elf_header->e_entry, task->mm->stack_vm);
	//kprintf2("Process loaded successfully \n");
	return task;
}


void setup_stack(struct task_struct *task, char *argv[], int argc, char *envp[], int envc)
{
	task->mm->stack_vm = USER_STACK - 0x8;
	write_cr3(virt_to_phy(task->pml4e, 0));
	//task->rip = task->e_entry;
	//task->rsp = task->mm->stack_vm;
	alloc_pages_at_virt(USER_STACK - PAGE_SIZE, PAGE_SIZE, PT_PRESENT_FLAG | PT_USER | PT_WRITABLE_FLAG);
	
	uint64_t *ustackptr = (uint64_t*) task->mm->stack_vm;
	
	uint64_t addr1[envc];
	//ustackptr--;
	for(int i = envc-1; i >=0; i--)
	{
		uint64_t length = strlen(envp[i]) + 1;
		ustackptr = (uint64_t*)((void*)ustackptr - length);
		memcpy((void *)ustackptr, (void *) envp[i], length);
		addr1[i] = (uint64_t) ustackptr;
	}
	//if(argc > 0)
	//ustackptr--;
    //*ustackptr = (uint64_t)envc;
	uint64_t addr[argc];
	for(int i = argc-1; i >=0; i--)
	{
		uint64_t length = strlen(argv[i]) + 1;
		ustackptr = (uint64_t*)((void*)ustackptr - length);
		memcpy((void *)ustackptr, (void *) argv[i], length);
		addr[i] = (uint64_t) ustackptr;
	}
	if(argc > 0)
		ustackptr--;
	//else
		
	for(int i = envc-1; i >= 0; i--)
	{
		ustackptr--;
   		*ustackptr = addr1[i];
	}
	//if(argc > 0)
	//ustackptr--;
	if(argc > 0)
		ustackptr--;
	else
	{
		ustackptr--;
		ustackptr--;
	}
	for(int i = argc-1; i >= 0; i--)
	{
		ustackptr--;
   		*ustackptr = addr[i];
	}
	//if(argc > 0)
	//	ustackptr--;
	//ustackptr--;
	//ustackptr--;
	
	ustackptr--;
    *ustackptr = (uint64_t)argc;
	
	
	//ustackptr--;
    //*ustackptr = (uint64_t)envc;
	
	/*uint64_t length = strlen(argv[0]);
	uint64_t *addr;
	//uint64_t *ustackptr = (uint64_t*) task->mm->stack_vm;
	ustackptr = (uint64_t*)((void*)ustackptr - length);
	memcpy((void *)ustackptr, (void *) argv[0], length);
	addr = ustackptr;*/
	
	//ustackptr--;
    //*ustackptr = (uint64_t)addr;
	//int argc = 10;
	
	//task->r.rsp = (uint64_t)ustackptr;
	task->mm->stack_vm = (uint64_t)ustackptr;
}

void test(uint64_t start)
{
	void *s = (void *)start;
	char *s1 = (char *)s;
	*s1 = 's';
	kprintf("char is %c \n", *s1);
	/*char *addr= (char *)start;
	addr = "shashi";
	kprintf("main1 %p\t%s\n", addr, addr);*/
}

void print_vma_list(struct mm_struct *mm)
{
	struct vm_area_struct *temp_vma = mm->vma_list;
	while(temp_vma != NULL)
	{
		kprintf("vma start address is %p \n", temp_vma->vm_start);
		temp_vma = temp_vma->next;
	}
}

