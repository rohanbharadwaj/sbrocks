#include <sys/mmu/virtual_mm.h>
#include <sys/mmu/pt.h>

uint64_t virtual_top;

void init_virtual_memory(uint64_t virtual_start_address)
{
	virtual_top = virtual_start_address;
}

uint64_t get_current_vm_top()
{
	return virtual_top;	
}

void set_current_vm_top(uint64_t new_top)
{
	virtual_top = new_top;
}

uint64_t alloc_pages(uint64_t no_of_pages, uint64_t flags)
{
	uint64_t retaddr = virtual_top;
	for(int i = 0; i < no_of_pages; i++)
	{
		uint64_t phy_page = mm_phy_alloc_page();	
		//kprintf("alloc_pages::page no %d \n", phy_page);
		uint64_t phy_addr = mm_page_to_phy(phy_page);
		//TODO map virtual to physical address
		map_virt_to_phy(virtual_top, phy_addr, flags);
		//kprintf("alloc_pages::phyaddr is %p \n", phy_addr);
		virtual_top = virtual_top + PAGE_SIZE;
	}
	return retaddr;
}

uint64_t alloc_pages_at_virt(uint64_t virt, uint64_t size, uint64_t flags)
{
	//uint64_t addr = ALIGN_UP(virt);
	uint64_t addr = virt;
	uint64_t no_of_pages = size/PAGE_SIZE;
	if(size%PAGE_SIZE != 0)
		no_of_pages = no_of_pages + 1;
	for(int i = 0; i < no_of_pages; i++)
	{
		uint64_t phy_page = mm_phy_alloc_page();	
		//kprintf("alloc_pages::page no %d \n", phy_page);
		uint64_t phy_addr = mm_page_to_phy(phy_page);
		//TODO map virtual to physical address
		map_virt_to_phy(virt, phy_addr, flags);
		//kprintf("alloc_pages::phyaddr is %p \n", phy_addr);
		virt = virt + PAGE_SIZE;
	}
	return addr;
}

void reset_page_tables(uint64_t pml4e){

	//TODO :  Load CR3 of process before calling free_page_tables
	//uint64_t old_cr3 = read_cr3();
	//write_cr3(virt_to_phy(pml4e, 0));
	free_page_tables(pml4e);
	//write_cr3(old_cr3);
}

void free_pages(uint64_t addr)
{
	
}