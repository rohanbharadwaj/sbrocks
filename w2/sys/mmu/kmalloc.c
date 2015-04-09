#include <sys/mmu/kmalloc.h>

void init_kmalloc()
{
}

void *kmalloc(uint64_t size)
{
void *addr;
	uint64_t num_pages = size/PAGE_SIZE;
	if(size%PAGE_SIZE > 0)
		num_pages = num_pages + 1;
	addr = (void *)alloc_pages(num_pages, PT_PRESENT_FLAG | PT_WRITABLE_FLAG);
	kprintf("addr is %p \n", (uint64_t)addr);
	return addr;
}
void test_malloc()
{
	//char *ptr = (char*) kmalloc(4096);
	//ptr = "Shashi";
	//*(ptr+1) = '\0';
	//kprintf("main1 %p\t%s", ptr, ptr);
	char *addr= (char *)0xFFFF800000000000;
	alloc_pages_at_virt((uint64_t)addr, 4096,PT_PRESENT_FLAG | PT_WRITABLE_FLAG);
	addr = "shashi";
	kprintf("main1 %p\t%s", addr, addr);
}
