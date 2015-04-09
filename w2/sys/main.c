#include <sys/sbunix.h>
#include <sys/gdt.h>
#include <sys/tarfs.h>
#include <sys/idt.h>
#include <sys/irq.h>
#include <sys/timer.h>
#include <sys/kb.h>
#include <sys/mmu/phy_alloc.h>
#include <sys/mmu/pt.h>
#include <sys/process/elf.h>
#include <sys/mmu/kmalloc.h>
#include <sys/process/process_manager.h>

//#include <sys/mmu/phy_alloc.h>
void wait();

void start(uint32_t* modulep, void* physbase, void* physfree)
{
	uint64_t base = 0;
	uint64_t length = 0;
	uint64_t type = 0;
	struct smap_t {
		uint64_t base, length;
		uint32_t type;
	}__attribute__((packed)) *smap;

	while(modulep[0] != 0x9001) modulep += modulep[1]+2;
	for(smap = (struct smap_t*)(modulep+2); smap < (struct smap_t*)((char*)modulep+modulep[1]+2*4); ++smap) {
		if (smap->type == 1 /* memory */ && smap->length != 0) {
			base = smap->base;
			length = smap->length;
			type = 	smap->type;
			kprintf("Available Physical Memory [%x-%x]\n", smap->base, smap->base + smap->length);
		}
	}
	
	kprintf("physbase and  physfree [%x-%x]\n", physbase, physfree);
	
	kprintf("smapbase and  smap length [%x-%x] % type %d \n", base, length, type);
	//mm_phy_init(base, length, type);
	//clrscr();
	mm_phy_init((uint64_t)physfree, length, type);
	setup_paging((uint64_t)physfree, (uint64_t)physfree,(uint64_t) physbase, (uint64_t)physfree);
	//
	//initialize_tarfs();
	//clrscr();
	readElf("bin/hello");
	//readElf("bin/test");
	//testdivzero();
	//test_page_fault();
	//test_malloc();
	//pt_initialise(base, length);
	//fb();
	//kprintf("tarfs in [%p:%p]\n", &_binary_tarfs_start, &_binary_tarfs_end);
	//setup_paging();
	schedule_process();
	while(1);
	// kernel starts here
}

#define INITIAL_STACK_SIZE 4096
char stack[INITIAL_STACK_SIZE];
uint32_t* loader_stack;
extern char kernmem, physbase;
struct tss_t tss;

void boot(void)
{
	// note: function changes rsp, local stack variables can't be practically used
	//register char *s, *v;

	__asm__(
		"movq %%rsp, %0;"
		"movq %1, %%rsp;"
		:"=g"(loader_stack)
		:"r"(&stack[INITIAL_STACK_SIZE])
	);
	reload_gdt();
	setup_tss();
	idt_install();
	install_irqs();
	timer_install();
	kb_install();
	__asm__("sti");
	//wait();
	start(
		(uint32_t*)((char*)(uint64_t)loader_stack[3] + (uint64_t)&kernmem - (uint64_t)&physbase),
		&physbase,
		(void*)(uint64_t)loader_stack[4]
	);
	//clrscr();
	//s = "!!!!! start() returned !!!!!";
	//for(v = (char*)0xb8000; *s; ++s, v += 2) *v = *s;
	//__asm__("sti");
	while(1);
}

void wait()
{
	uint64_t j1 = 1000000;
	while(j1>0)
	{
		uint64_t k1 = 1000;
		while(k1 > 0)
			k1--;
		j1--;
	}	
	uint64_t j = 1000000;
	while(j>0)
	{
		uint64_t k = 1000;
		while(k > 0)
			k--;
		j--;
	}		
}