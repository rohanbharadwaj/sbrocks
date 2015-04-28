#include <sys/kstring.h>
#include <sys/sbunix.h>
#include <sys/ioport.h>
#include <sys/idt.h>
#include <sys/mmu/assemblyutil.h>
#include <sys/syscall.h>
#include <sys/vgaconsole.h>
/*
*	http://www.osdever.net/bkerndev/Docs/idt.htm
*//* Defines an IDT entry */

void demand_paging(uint64_t addr);
void save_current_task_regs();

//interrupt service routines
extern void irq0();             //PIT irq handler
extern void irq1();             //KB irq handler

extern void isr0();
extern void isr1();
extern void isr2();
extern void isr3();
extern void isr4();
extern void isr5();
extern void isr6();
extern void isr7();
extern void isr8();
extern void isr9();
extern void isr10();
extern void isr11();
extern void isr12();
extern void isr13();
extern void isr14();
extern void isr15();
extern void isr16();
extern void isr17();
extern void isr18();
extern void isr19();
extern void isr20();
extern void isr21();
extern void isr22();
extern void isr23();
extern void isr24();
extern void isr25();
extern void isr26();
extern void isr27();
extern void isr28();
extern void isr29();
extern void isr30();
extern void isr31();
extern void isr128();

void testdivzero();
void gpf_fault_handler();
void page_fault_handler();
void test_page_fault();
void set_irqs();
void syscall_handler();

struct idt_entry
{
    uint16_t base_lo;
    uint16_t sel;        /* Our kernel segment goes here! */
    uint8_t ist_reserved;
    uint8_t flags;       /* Set using the above table! */
    uint16_t base_mid;
    uint32_t base_hi;
    uint32_t reserved;
} __attribute__((packed));

struct idt_entry idt[256];

struct idt_ptr {
    uint16_t size;
    uint64_t addr;
}__attribute__((packed));

static struct idt_ptr idtr = {
    sizeof(idt),
    (uint64_t)idt,
};

//void _x86_64_asm_idt(struct idt_ptr* idtr);
void _x86_64_asm_idt(struct idt_ptr *idtr);

void reload_idt() {
    _x86_64_asm_idt(&idtr);
}

//the function to set idt table entries
void idt_set_gate(int32_t num, uint64_t base, uint16_t sel, uint8_t flags)
{
    //idt[num].base_lo = base &  0x000000000000ffff;
    idt[num].base_lo = base & 0xffffUL;
    idt[num].sel = sel;
    idt[num].ist_reserved = 0x0;
    idt[num].flags = flags;
    //idt[num].base_mid = base & 0x00000000ffff0000;
    idt[num].base_mid = (base >> 16) & 0xffffUL;
    //idt[num].base_hi = base &  0xffffffff00000000;
    idt[num].base_hi = (base >> 32) & 0xffffffffUL;
    idt[num].reserved = 0x0;
}

void idt_install()
{
    memset(&idt, 0, sizeof(struct idt_entry) * 256);
    //DIV ZERO exception
    idt_set_gate(0, (uint64_t)isr0, 0x08, 0x8e);
	idt_set_gate(1, (uint64_t)isr1, 0x08, 0x8e);
	idt_set_gate(2, (uint64_t)isr2, 0x08, 0x8e);
	idt_set_gate(3, (uint64_t)isr3, 0x08, 0x8e);
	idt_set_gate(4, (uint64_t)isr4, 0x08, 0x8e);
	idt_set_gate(5, (uint64_t)isr5, 0x08, 0x8e);
	idt_set_gate(6, (uint64_t)isr6, 0x08, 0x8e);
	idt_set_gate(7, (uint64_t)isr7, 0x08, 0x8e);
	idt_set_gate(8, (uint64_t)isr8, 0x08, 0x8e);
	idt_set_gate(9, (uint64_t)isr9, 0x08, 0x8e);
	idt_set_gate(10, (uint64_t)isr10, 0x08, 0x8e);
	idt_set_gate(11, (uint64_t)isr11, 0x08, 0x8e);
	idt_set_gate(12, (uint64_t)isr12, 0x08, 0x8e);
	idt_set_gate(13, (uint64_t)isr13, 0x08, 0x8E);
	idt_set_gate(14, (uint64_t)isr14, 0x08, 0x8E);
	idt_set_gate(15, (uint64_t)isr15, 0x08, 0x8e);
	idt_set_gate(16, (uint64_t)isr16, 0x08, 0x8e);
	idt_set_gate(17, (uint64_t)isr17, 0x08, 0x8e);
	idt_set_gate(18, (uint64_t)isr18, 0x08, 0x8e);
	idt_set_gate(19, (uint64_t)isr19, 0x08, 0x8e);
	idt_set_gate(20, (uint64_t)isr20, 0x08, 0x8e);
	idt_set_gate(21, (uint64_t)isr21, 0x08, 0x8e);
	idt_set_gate(22, (uint64_t)isr22, 0x08, 0x8e);
	idt_set_gate(23, (uint64_t)isr23, 0x08, 0x8E);
	idt_set_gate(24, (uint64_t)isr24, 0x08, 0x8E);
	idt_set_gate(25, (uint64_t)isr25, 0x08, 0x8e);
	idt_set_gate(26, (uint64_t)isr26, 0x08, 0x8e);
	idt_set_gate(27, (uint64_t)isr27, 0x08, 0x8e);
	idt_set_gate(28, (uint64_t)isr28, 0x08, 0x8e);
	idt_set_gate(29, (uint64_t)isr29, 0x08, 0x8e);
	idt_set_gate(30, (uint64_t)isr30, 0x08, 0x8e);
	idt_set_gate(31, (uint64_t)isr31, 0x08, 0x8e);
    //PIT interrupt
    idt_set_gate(32, (uint64_t)irq0, 0x08, 0x8E);
	idt_set_gate(0x80, (uint64_t)isr128, 0x08, 0xEE);
    //Keyboard interrupt 
    idt_set_gate(33, (uint64_t)irq1, 0x08, 0x8E);
    reload_idt();
    //testdivzero();
}
#if 0
void syscall_handler()
{
	//kprintf("inside this \n");
	uint64_t syscall_num;
	uint64_t buf;
	__asm__(
		"movq %%rax, %0;"
		:"=g"(syscall_num)
		:);
	__asm__(
		"movq %%rsi, %0;"
		:"=g"(buf)
		:);
	char *b = (char *)buf;
	kprintf("system call no is %d \n", syscall_num);
	kprintf("%s \n", b);
	__asm__ __volatile__("iretq;");
}
#endif

void syscall_handler(struct regs *r)
{
	struct task_struct *task = get_current_task();
	if(task)
		task->r = *r;
	uint64_t first_arg = task->r.rbx;
	/*__asm__(
		"movq %%rbx, %0;"
		:"=g"(first_arg)
		:);*/
	
	//kprintf("inside this \n");
	uint64_t syscall_num,sec_arg,third_arg;
	//uint64_t buf;
	syscall_num = task->r.rax;
	sec_arg = task->r.rcx;
	third_arg = task->r.rdx;
	/*__asm__(
        "movq %%rax, %0;"
        "movq %%rcx, %1;"
        "movq %%rdx, %2;"
        :"=g"(syscall_num),
         "=g"(sec_arg),
         "=g"(third_arg)
        ::
        );*/
	kprintf("system call no is %d \n", syscall_num);
	uint64_t ret = switch_handler(syscall_num,first_arg,sec_arg,third_arg, r);
	task->r.rax = ret;
	/*__asm__(
		"movq %0,%%rax;"
		:"=g"(ret)
		:);*/
	//__asm__ __volatile__("iretq;");
	if(task)
	{
		*r = task->r;	
	}
}

void testdivzero()
{
    int i = 50;
    int j = 0;
    int k = i/j;
    kprintf("%d \n", k);
}

void test_page_fault()
{
	//TODO: access some memory that is not yet mapped to physical memory
	*(uint64_t *)10= 50;
}

void divide_by_zero_handler()
{
	kprintf("divide_by_zero_handler reached.... \n");	
	__asm__( "hlt" );
}

void gpf_fault_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside gpf");
}

void page_fault_handler(struct regs *r)
{
	clrscr();
	//kprintf2("error code %p \n", r->err_code);
	struct task_struct *task = get_current_task();
	if(task)
		task->r = *r;
	uint64_t vaddr;
	vaddr = read_cr2();
	//puts("shashi \n");
	//__asm__ __volatile__("cli;" : :);
	kprintf("page fault  handler reached.... \n");
	//kprintf2("fault is at address %p \n",vaddr);
	if(r->err_code & 0x1)
	{
		//page protectio voilation	
		//write_cr3(virt_to_phy(task->pml4e, 0)); 
		uint64_t *pte = get_pte_entry(vaddr);
		uint64_t paddr = *pte & 0x000FFFFFFFFFF000;
		if(pte != 0)
		{
			if(is_cow_set(pte) && !is_writable_page(pte))
			{
				//for fork
				//kprintf2("cow page \n");
				uint64_t start_addr = ALIGN_DOWN(vaddr);
				//allocate a new physical page at dummy virtual address
				uint64_t dummy_vaddr = alloc_pages(1, PT_PRESENT_FLAG | PT_USER | PT_WRITABLE_FLAG);
				uint64_t phy_addr = virt_to_phy(dummy_vaddr, 0);
				//copy alll the contents from faulting address to new dummy page
				memcpy((void *)dummy_vaddr, (void *) start_addr, PAGE_SIZE);
				//then map this page in child process
				//remove dummy page entry from parent
				//unmap_phy(dummy_vaddr);
				//alloc_pages_at_virt(vaddr, phy_addr, PT_PRESENT_FLAG | PT_USER | PT_WRITABLE_FLAG);
				//kprintf2("before \n\n");
				map_virt_to_phy(start_addr, phy_addr, PT_PRESENT_FLAG | PT_USER | PT_WRITABLE_FLAG);
				dec_ref_count(paddr);
				uint64_t *pte = get_pte_entry(start_addr);
				set_cow_bit(pte);
				//kprintf2("page allocated \n");
				//kprintf2("after \n\n");
			}
		}
	}
	else
	{
		//page is not present demand paging
		demand_paging(vaddr);
	}
	
	//save_task_registers();
	
	task = get_current_task();
	if(task)
	{
		*r = task->r;	
	}
	//__asm__( "hlt" );
}

void demand_paging(uint64_t addr)
{
	//save_current_task_regs();
	struct task_struct *task = get_current_task();
	struct vm_area_struct *temp_vma = task->mm->vma_list;
	while(temp_vma != NULL)
	{
		//clrscr();
		if(temp_vma->vma_type == VMA_HEAP)
		{
		//	kprintf2("start: %p end %p \n", temp_vma->vm_start, temp_vma->vm_end);	
			if(temp_vma->vm_start <= addr && temp_vma->vm_end > addr)
			{
				//allocate pages for this vma	
				//uint64_t k_cr3 = read_cr3();
				write_cr3(virt_to_phy(task->pml4e, 0));
				uint64_t vaddr = ALIGN_DOWN(addr);
				alloc_pages_at_virt(vaddr, PAGE_SIZE , PT_PRESENT_FLAG | PT_WRITABLE_FLAG | PT_USER);
				uint64_t phy = virt_to_phy(vaddr, 0);
				kprintf("vaddr %p and phys is %p \n",vaddr, phy);
				kprintf("start: %p end %p \n", temp_vma->vm_start, temp_vma->vm_end);
				//set_current_task(NULL);

				//write_cr3(k_cr3);
				//__asm__ __volatile__("movq %[next_rsp], %%rsp" : : [next_rsp] "m" (task->rsp));
				//__asm__ __volatile__("movq %[next_rip], %%rip" : : [next_rip] "m" (task->rip));
				//__asm__ __volatile__("sti;" : :);
				//__asm__ __volatile__("int $0x20;" : :);

				//while(1);

				return;
				//write_cr3(k_cr3);
				//__asm__ __volatile__("sti");
				//	while(1);
				//return;
			}
		}
		else if(temp_vma->vma_type == VMA_STACK)
		{
			//kprintf2("start: %p, end: %p \n", temp_vma->vm_start, temp_vma->vm_end);
			//kprintf2("fault addr: %p \n", addr);
			if(temp_vma->vm_start >= addr && temp_vma->vm_end < addr)
			{
				write_cr3(virt_to_phy(task->pml4e, 0));
				uint64_t vaddr = ALIGN_UP(addr) - 4096;
				alloc_pages_at_virt(vaddr, PAGE_SIZE , PT_PRESENT_FLAG | PT_WRITABLE_FLAG | PT_USER);
			}
		}
		temp_vma = temp_vma->next;
	}
	//__asm__ __volatile__("sti;" : :);
}

void save_current_task_regs()
{
	struct task_struct *task = get_current_task();
	
	task->state = TASK_RUNNABLE;
	int i = 1;
	while(task->kstack[KSTACK_SIZE - i] == 0)
		i++;
	task->rsp = task->kstack[KSTACK_SIZE - i - 1];
	task->rip = task->kstack[KSTACK_SIZE - i - 4];
}


//TODO: pass the interrupt numner from assembly
void fault_handler()
{
    kprintf("ashish \n");
/*	int int_no = 10;
	switch (int_no) {
        case 0:
            divide_by_zero_handler();
            break;
		case 14:
			page_fault_handler();
			break;
		default:
			break;
	}*/
}
void isr1_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr1 handler\n");
}

void isr2_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr2 handler\n");
}

void isr3_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr3 handler\n");
}

void isr4_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr4 handler\n");
}

void isr5_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr5 handler\n");
}

void isr6_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr6 handler\n");
}

void isr7_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr7 handler\n");
}

void isr8_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr8 handler\n");
}

void isr9_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr9 handler\n");
}

void isr10_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr10 handler\n");
}

void isr11_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr11 handler\n");
}

void isr12_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr12 handler\n");
}

void isr15_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr15 handler\n");
}

void isr16_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr16 handler\n");
}

void isr17_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr17 handler\n");
}

void isr18_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr18 handler\n");
}

void isr19_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr19 handler\n");
}

void isr20_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr20 handler\n");
}

void isr21_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr21 handler\n");
}

void isr22_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr22 handler\n");
}

void isr23_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr23 handler\n");
}

void isr24_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr24 handler\n");
}

void isr25_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr25 handler\n");
}

void isr26_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr26 handler\n");
}

void isr27_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr27 handler\n");
}

void isr28_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr28 handler\n");
}

void isr29_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr29 handler\n");
}

void isr30_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr30 handler\n");
}

void isr31_handler(struct regs *r)
{
	//clrscr();
	kprintf2("Inside isr31 handler\n");
}




