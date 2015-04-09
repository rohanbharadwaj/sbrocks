#include <sys/mmu/pt.h>

uint64_t k_cr3 = 0;
uint64_t* get_phy_page_table(uint64_t *cr3);

#define isPresent(x)  ((x) & PT_PRESENT_FLAG)
#define PTE_SELF_REF  0xFFFFFF0000000000UL
#define PDE_SELF_REF  0xFFFFFF7F80000000UL
#define PDPE_SELF_REF 0xFFFFFF7FBFC00000UL
//#define PDPE_SELF_REF	0xFFFFFFFFFFE00000UL	
#define PML4_SELF_REF 0xFFFFFF7FBFDFE000UL
//#define PML4_SELF_REF   0xFFFFFFFFFFFFF000UL

//TODO: Change it using self referencing table 
uint64_t virt_to_phy(uint64_t virt, uint64_t pml4e) 
{
	uint64_t _pml4e_offset  = (0x1ff & (virt >> 39));
	uint64_t _pdpe_offset = (0x1ff & (virt >> 30));
	uint64_t _pde_offset = (0x1ff & (virt >> 21));
	uint64_t _pte_offset = (0x1ff & (virt >> 12));
	
	uint64_t *kpml4e = (uint64_t *)KADDR(k_cr3);
	if(!isPresent(kpml4e[_pml4e_offset]))
	{
		return 0;
	}
	
	//pdpe
	uint64_t *pdpetable = (uint64_t *)KADDR(ALIGN_DOWN(kpml4e[_pml4e_offset]));
	
	if(!isPresent(pdpetable[_pdpe_offset]))
	{
		return 0;
	}
	
	//pd
	uint64_t *pdetable = (uint64_t *)KADDR(ALIGN_DOWN(pdpetable[_pdpe_offset]));
	if(!isPresent(pdetable[_pde_offset]))
	{
		return 0;
	}
	uint64_t *pttable = (uint64_t *)KADDR(ALIGN_DOWN(pdetable[_pde_offset]));
	if(!isPresent(pttable[_pte_offset]))
	{
		return 0;
	}
	kprintf("physical address is %p \n", ALIGN_DOWN(pttable[_pte_offset]));
	return ALIGN_DOWN(pttable[_pte_offset]);	
}

uint64_t getCR3()
{
	return k_cr3;	
}

//TODO: Change it using self referencing table 
uint64_t virt_to_pde(uint64_t virt) {

	uint64_t cr3;
	cr3 = getCR3();
	
	uint64_t *_pml4e = 0x0000;
	uint64_t *_pdpe  = 0x0000;
	uint64_t *_pde   = 0x0000;
	
	_pml4e = (uint64_t *)cr3;
	_pml4e  += (0x1ff & (virt >> 39));
	_pml4e  = PHY_TO_VIRT(_pml4e, uint64_t*);

	if(!(*_pml4e & PT_PRESENT_FLAG)) {
		return 0;
	}

	_pdpe  = (uint64_t*)ALIGN_DOWN(*_pml4e);
	_pdpe += (0x1ff & (virt >> 30));
	_pdpe  = PHY_TO_VIRT(_pdpe, uint64_t*);

	if(!(*_pdpe & PT_PRESENT_FLAG)) {
		return 0;
	}

	_pde  = (uint64_t*)ALIGN_DOWN(*_pdpe);
	_pde += (0x1ff & (virt >> 21));
	_pde  = PHY_TO_VIRT(_pde, uint64_t*);
	return *_pde;
}
//convert from physical address to kernel virtual address when paging is enabled
uint64_t KADDR(uint64_t paddr)
{
	return paddr + VIRT_KERNEL_BASE;	
}
//convert from kernel virtual address to physical address when paging is enabled
uint64_t PADDR(uint64_t vddr)
{
	return vddr - VIRT_KERNEL_BASE;	
}

//TODO: method to map virtual address to physical address in page tables
void map_virt_to_phy(uint64_t virt, uint64_t phy, uint64_t flags)
{
	uint64_t _pml4e_offset = 0x0000;
	uint64_t _pdpe_offset  = 0x0000;
	uint64_t _pde_offset   = 0x0000;
	uint64_t _pte_offset = 0x0000;
	
	_pml4e_offset  = (0x1ff & (virt >> 39));
	_pdpe_offset = (0x1ff & (virt >> 30));
	_pde_offset = (0x1ff & (virt >> 21));
	_pte_offset = (0x1ff & (virt >> 12));
	uint64_t cr3 = read_cr3();
	uint64_t *kpml4e = (uint64_t *)KADDR(cr3);
	//kpml4e[_pml4e_offset] = pdpe | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	
	//uint64_t *kpml4e = (uint64_t *)PHY_TO_VIRT(pml4e, uint64_t *);
	//uint64_t *kpml4e = (uint64_t *)PML4_SELF_REF;
	//k_cr3 = kpml4e;
	//if pdpe entry is not presnet in pml4e 
	if(!isPresent(kpml4e[_pml4e_offset]))
	{
		uint64_t phy_page = mm_phy_alloc_page();
		kpml4e[_pml4e_offset] = mm_page_to_phy(phy_page) | flags;
		//kprintf("second page address : %p \n", kpml4e[_pml4e_offset]);
		//kprintf("second page address : %p \n", ALIGN_DOWN(kpml4e[_pml4e_offset]));
		//ALIGN_DOWN(pbase)
		//kprintf("first page address")
		//kpml4e[_pml4e_offset] = pdpe | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}
	else
	{
		//kprintf("usig existing pdpe entry in pml4e table \n");
		//kpml4e[_pml4e_offset] = kpml4e[_pml4e_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}
	
	//pdpe
	uint64_t *pdpetable = (uint64_t *)KADDR(ALIGN_DOWN(kpml4e[_pml4e_offset]));
	//uint64_t *pdpetable = (uint64_t *)PHY_TO_VIRT(ALIGN_DOWN(kpml4e[_pml4e_offset]), uint64_t *);
	//uint64_t *pdpetable = (uint64_t *)PDPE_SELF_REF;
	if(!isPresent(pdpetable[_pdpe_offset]))
	{
		uint64_t phy_page = mm_phy_alloc_page();
		phy_page = mm_phy_alloc_page();
		 pdpetable[_pdpe_offset] = mm_page_to_phy(phy_page) | flags;
		//kprintf("third page address : %p \n",  pdpetable[_pdpe_offset] );
		//pdpetable[_pdpe_offset] = pde | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}
	else
	{
		//kprintf("usig existing pde entry in pdpe table \n");
		//kpml4e[_pml4e_offset] = kpml4e[_pml4e_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}
	//pd
	uint64_t *pdetable = (uint64_t *)KADDR(ALIGN_DOWN(pdpetable[_pdpe_offset]));
	//uint64_t *pdetable = (uint64_t *)PHY_TO_VIRT(ALIGN_DOWN(pdpetable[_pdpe_offset]), uint64_t *);
	//uint64_t *pdetable = (uint64_t *)PML4_SELF_REF;
	if(!isPresent(pdetable[_pde_offset]))
	{
		uint64_t phy_page = mm_phy_alloc_page();
		pdetable[_pde_offset] = mm_page_to_phy(phy_page) | flags;
		//kprintf("fourth page address : %p \n", pdetable[_pde_offset]);
		//pdetable[_pde_offset]  = pt | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}
	else
	{
		//kprintf("usig existing pt entry in pde table \n");
		//kpml4e[_pml4e_offset] = kpml4e[_pml4e_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}

	uint64_t *pttable = (uint64_t *)KADDR(ALIGN_DOWN(pdetable[_pde_offset]));
	//uint64_t *pttable = (uint64_t *)PHY_TO_VIRT(ALIGN_DOWN(pdetable[_pde_offset]), uint64_t *);
	//uint64_t *pttable = (uint64_t *)PML4_SELF_REF;
	kprintf("physical address is %p %p \n", phy, flags);
	pttable[_pte_offset] = phy | flags;	
}

uint64_t kernmem_mapping(uint64_t virt, uint64_t pbase, uint64_t noofpages, uint64_t pml4e) {
	uint64_t _pml4e_offset = 0x0000;
	uint64_t _pdpe_offset  = 0x0000;
	uint64_t _pde_offset   = 0x0000;
	uint64_t _pte_offset = 0x0000;
	
	_pml4e_offset  = (0x1ff & (virt >> 39));
	_pdpe_offset = (0x1ff & (virt >> 30));
	_pde_offset = (0x1ff & (virt >> 21));
	_pte_offset = (0x1ff & (virt >> 12));
	
	//uint64_t *kpml4e = (uint64_t *)PHY_TO_VIRT(pml4e, uint64_t *);
	//kpml4e[_pml4e_offset] = pdpe | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	
	uint64_t *kpml4e = (uint64_t *)PHY_TO_VIRT(pml4e, uint64_t *);
	//kpml4e[510] = pml4e | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	//if pdpe entry is not presnet in pml4e 
	if(!isPresent(kpml4e[_pml4e_offset]))
	{
		uint64_t phy_page = mm_phy_alloc_page();
		kpml4e[_pml4e_offset] = mm_page_to_phy(phy_page) | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
		//uint64_t *pdpetable = (uint64_t *)PHY_TO_VIRT(ALIGN_DOWN(kpml4e[_pml4e_offset]), uint64_t *);
		//pdpetable[510] = kpml4e[_pml4e_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
		//kprintf("second page address : %p \n", kpml4e[_pml4e_offset]);
		//kprintf("second page address : %p \n", ALIGN_DOWN(kpml4e[_pml4e_offset]));
		//ALIGN_DOWN(pbase)
		//kprintf("first page address")
		//kpml4e[_pml4e_offset] = pdpe | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}
	else
	{
		//kprintf("usig existing pdpe entry in pml4e table \n");
		//kpml4e[_pml4e_offset] = kpml4e[_pml4e_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}
	
	//pdpe
	uint64_t *pdpetable = (uint64_t *)PHY_TO_VIRT(ALIGN_DOWN(kpml4e[_pml4e_offset]), uint64_t *);
	pdpetable[510] = kpml4e[_pml4e_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	if(!isPresent(pdpetable[_pdpe_offset]))
	{
		uint64_t phy_page = mm_phy_alloc_page();
		phy_page = mm_phy_alloc_page();
		 pdpetable[_pdpe_offset] = mm_page_to_phy(phy_page) | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	//	kprintf("third page address : %p \n",  pdpetable[_pdpe_offset] );
		//pdpetable[_pdpe_offset] = pde | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}
	else
	{
	//	kprintf("usig existing pde entry in pdpe table \n");
		//kpml4e[_pml4e_offset] = kpml4e[_pml4e_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}
	//pd
	
	uint64_t *pdetable = (uint64_t *)PHY_TO_VIRT(ALIGN_DOWN(pdpetable[_pdpe_offset]), uint64_t *);
	pdetable[510] = pdpetable[_pdpe_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	if(!isPresent(pdetable[_pde_offset]))
	{
		uint64_t phy_page = mm_phy_alloc_page();
		pdetable[_pde_offset] = mm_page_to_phy(phy_page) | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
		//kprintf("fourth page address : %p \n", pdetable[_pde_offset]);
		//pdetable[_pde_offset]  = pt | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}
	else
	{
	//	kprintf("usig existing pt entry in pde table \n");
		//kpml4e[_pml4e_offset] = kpml4e[_pml4e_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}


	uint64_t *pttable = (uint64_t *)PHY_TO_VIRT(ALIGN_DOWN(pdetable[_pde_offset]), uint64_t *);
	pttable[510] = pdetable[_pde_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	//uint64_t start = ALIGN_DOWN(pbase) /*+ 0x400000*/;
	//uint64_t end = ALIGN_UP(pfree); /*- 0x400000*/
	//k_cr3 = get_phy_page_table(k_cr3);
	uint64_t start = ALIGN_DOWN(pbase);
	if(_pte_offset+noofpages < 512)
	{
		for(uint64_t i = 0; i < noofpages; i++)
		{
			pttable[_pte_offset++] = start | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
			start = start + PAGE_SIZE;
			//kprintf("mapping to vaddress = [%p]  kernel pt cr3 [%p] \n \n\n", (uint64_t)PHY_TO_VIRT(i, uint64_t), k_pml4e);
		}
	}
	else
	{
		uint64_t remaining =_pte_offset - 512 + noofpages;     //1100
		for(uint64_t i = _pte_offset; i < 512; i++)            //112
		{
			pttable[i] = start | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
			start = start + PAGE_SIZE;
			//kprintf("mapping to vaddress = [%p]  kernel pt cr3 [%p] \n \n\n", (uint64_t)PHY_TO_VIRT(i, uint64_t), k_pml4e);
		}
		uint64_t num = remaining/512;              //2
		kprintf("num is %d remainig is %d \n", num, remaining);
		remaining = remaining % 512;           //76
		for(uint64_t i = 0; i < num; i++)          
		{
			uint64_t phy_page = mm_phy_alloc_page();
			_pde_offset = _pde_offset + 1;
			pdetable[_pde_offset] = mm_page_to_phy(phy_page) | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
			pttable = (uint64_t *)PHY_TO_VIRT(ALIGN_DOWN(pdetable[_pde_offset]), uint64_t *);
			for(uint64_t i = 0; i < 512; i++)
			{
				pttable[i] = start | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
				start = start + PAGE_SIZE;
				//kprintf("mapping to vaddress = [%p]  kernel pt cr3 [%p] \n \n\n", (uint64_t)PHY_TO_VIRT(i, uint64_t), k_pml4e);
			}
		}
		
		uint64_t phy_page = mm_phy_alloc_page();
		pdetable[_pde_offset + 1] = mm_page_to_phy(phy_page) | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
		pttable = (uint64_t *)PHY_TO_VIRT(ALIGN_DOWN(pdetable[_pde_offset + 1]), uint64_t *);
		for(uint64_t i = 0; i < remaining; i++)
		{
			pttable[i] = start | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
			start = start + PAGE_SIZE;
			//kprintf("mapping to vaddress = [%p]  kernel pt cr3 [%p] \n \n\n", (uint64_t)PHY_TO_VIRT(i, uint64_t), k_pml4e);
		}
	}
	return 0;
}

void setup_paging(uint64_t base, uint64_t physfree, uint64_t pbase, uint64_t pfree)
{
	kprintf("setup_paging .. started... phybase %p \n", ALIGN_DOWN(base));
	uint64_t phy_page = mm_phy_alloc_page();
	//kprintf("page no is %d \n", phy_page);
	k_cr3 = mm_page_to_phy(phy_page);	
	//kprintf("first page address : %p \n", pml4e);
	//uint64_t *kpml4e = (uint64_t *)PHY_TO_VIRT(k_cr3, uint64_t *);
	//kpml4e[510] = k_cr3 | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	
	uint64_t vaddr = VIRT_KERNEL_BASE + pbase;
	//uint64_t start = ALIGN_DOWN(pbase) /*+ 0x400000*/;
	//uint64_t end = ALIGN_UP(pfree); /*- 0x400000*/
	//uint64_t noofpages = (end - start)/PAGE_SIZE;
	uint64_t noofpages = 518;
	//kprintf("no of pages : %d \n", noofpages);
	kernmem_mapping(vaddr, pbase, noofpages , k_cr3);
	//video address
	kernmem_mapping(0xFFFFFFFF800B8000, 0xB8000, 1, k_cr3);
	map_all_phy(k_cr3);
	init_virtual_memory(vaddr+(PAGE_SIZE*noofpages));
	
	write_cr3(k_cr3);
	//phy_page = mm_phy_alloc_page();
	//pml4e = mm_page_to_phy(phy_page);
	//kernmem_mapping(0xFFFFFFFF800B8000, 0xB8000, k_cr3, PT_PRESENT_FLAG | PT_WRITABLE_FLAG);
	//map_virt_to_phy(0xffffffff80252000, 0x258000,  k_cr3, PT_PRESENT_FLAG | PT_WRITABLE_FLAG);
	//write_cr3(pml4e);
	
	//int j = 0;
	//clrscr();
	//kprintf("shashi %d \n", j);
	//kprintf("ranjan %d \n", j);
	//while(1);
	//LOAD_CR3(paddr);
	//int j = 0;
	//kprintf("shashi %d \n", j);
	//enable_paging();
}

void map_all_phy(uint64_t k_cr3)
{
	uint64_t start = 0 /*+ 0x400000*/;
	uint64_t end = ALIGN_DOWN(0x7ffe000); /*- 0x400000*/
	uint64_t no_of_pages = (end - start)/PAGE_SIZE;
	//uint64_t no_of_pages = 1024*1024;
	kernmem_mapping(VIRT_KERNEL_BASE, 0, no_of_pages , k_cr3);	
	//uint64_t end_addr = VIRT_KERNEL_BASE + no_of_pages*PAGE_SIZE;
	//kprintf("no_of_pages is %d \n", no_of_pages);
	//kprintf("start address is %p and end address is %p \n", VIRT_KERNEL_BASE , end_addr);
}

void initialize_new_pml4e(uint64_t pml4e)
{
	
}

/*** get a physical page for use in the page tables ***/
uint64_t* get_phy_page_table(uint64_t *cr3) {

        uint64_t *ret = 0;

        if(cr3 == 0) {
				
                uint64_t phy_page = mm_phy_alloc_page();
				//kprintf("page no si %d \n", phy_page);
				cr3 = (uint64_t *)mm_page_to_phy(phy_page);
				ret = cr3;
				//kprintf("ret address %d \n", mm_page_to_phy(phy_page));
                if(!phy_page)
                        goto done;
        }
		//else
		//	kprintf("page already allocated \n");
        ret = cr3;
done:

        if(ret)
                memset( PHY_TO_VIRT(ret,void*), 0x00, PAGE_SIZE);
        return ret;
}

uint64_t env_setup_vm()
{
	uint64_t pml4e = alloc_pages(1, PT_PRESENT_FLAG | PT_WRITABLE_FLAG | PT_USER);
	uint64_t *ptr = (uint64_t *)pml4e;
	uint64_t *kpml4e = (uint64_t *)KADDR(k_cr3);
	for(int i =0;i<512;i++)
	{
		//kprintf("%p\n",kpml4e[i]);
		ptr[i] = kpml4e[i];
	}
	//uint64_t phyaddr = virt_to_phy(pml4e, 0);
	//kernmem_mapping(0xFFFFFFFF800B8000, 0xB8000, 1, phyaddr);
	//kernmem_mapping(0xFFFFFFFF800B8000, 0xB8000, 1, k_cr3);
	//ptr[510] = virt_to_phy(pml4e, 0) & 0xfffff0;
	//ptr[511] = getCR3();
	return pml4e;
}
