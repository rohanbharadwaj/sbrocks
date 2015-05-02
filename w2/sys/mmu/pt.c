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
	//clrscr();
	uint64_t _pml4e_offset  = (0x1ff & (virt >> 39));
	uint64_t _pdpe_offset = (0x1ff & (virt >> 30));
	uint64_t _pde_offset = (0x1ff & (virt >> 21));
	uint64_t _pte_offset = (0x1ff & (virt >> 12));
	uint64_t cr3 = read_cr3();
	uint64_t *kpml4e = (uint64_t *)KADDR(cr3);
	//uint64_t *kpml4e = (uint64_t *)KADDR(k_cr3);
	kprintf("cr3 %p \n", cr3);
	kprintf("kpml4e %p \n", kpml4e);
	kprintf("_pml4e_offset %p \n", _pml4e_offset);
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

uint64_t *get_pte_entry(uint64_t virt)
{
	uint64_t _pml4e_offset  = (0x1ff & (virt >> 39));
	uint64_t _pdpe_offset = (0x1ff & (virt >> 30));
	uint64_t _pde_offset = (0x1ff & (virt >> 21));
	uint64_t _pte_offset = (0x1ff & (virt >> 12));
	uint64_t cr3 = read_cr3();
	uint64_t *kpml4e = (uint64_t *)KADDR(cr3);
	//uint64_t *kpml4e = (uint64_t *)KADDR(k_cr3);
	kprintf("cr3 %p \n", cr3);
	kprintf("kpml4e %p \n", kpml4e);
	kprintf("_pml4e_offset %p \n", _pml4e_offset);
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
	//return ALIGN_DOWN(pttable[_pte_offset]);
	return &pttable[_pte_offset];
}

//TODO: Change it using self referencing table 
void unmap_phy(uint64_t virt) {

	//clrscr();
	uint64_t _pml4e_offset  = (0x1ff & (virt >> 39));
	uint64_t _pdpe_offset = (0x1ff & (virt >> 30));
	uint64_t _pde_offset = (0x1ff & (virt >> 21));
	uint64_t _pte_offset = (0x1ff & (virt >> 12));
	uint64_t cr3 = read_cr3();
	uint64_t *kpml4e = (uint64_t *)KADDR(cr3);
	//uint64_t *kpml4e = (uint64_t *)KADDR(k_cr3);
	kprintf("cr3 %p \n", cr3);
	kprintf("kpml4e %p \n", kpml4e);
	kprintf("_pml4e_offset %p \n", _pml4e_offset);
	if(!isPresent(kpml4e[_pml4e_offset]))
	{
		return;
	}
	
	//pdpe
	uint64_t *pdpetable = (uint64_t *)KADDR(ALIGN_DOWN(kpml4e[_pml4e_offset]));
	
	if(!isPresent(pdpetable[_pdpe_offset]))
	{
		return;
	}
	
	//pd
	uint64_t *pdetable = (uint64_t *)KADDR(ALIGN_DOWN(pdpetable[_pdpe_offset]));
	if(!isPresent(pdetable[_pde_offset]))
	{
		return;
	}
	uint64_t *pttable = (uint64_t *)KADDR(ALIGN_DOWN(pdetable[_pde_offset]));
	/*if(!isPresent(pttable[_pte_offset]))
	{
		return 0;
	}
	
	kprintf("physical address is %p \n", ALIGN_DOWN(pttable[_pte_offset]));
	return ALIGN_DOWN(pttable[_pte_offset]);	*/
	if(isPresent(pttable[_pte_offset]))
	{
		uint64_t phy = ALIGN_DOWN(pttable[_pte_offset]);
		dec_ref_count(phy);
		pttable[_pte_offset] = 0;
	}
}

//convert from physical address to kernel virtual address when paging is enabled
uint64_t KADDR(uint64_t paddr)
{
	return paddr + ONE_ON_ONE_MAPPING;	
}
//convert from kernel virtual address to physical address when paging is enabled
/*uint64_t PADDR(uint64_t vddr)
{
	return vddr - ONE_ON_ONE_MAPPING;	
}*/

//TODO: method to map virtual address to physical address in page tables
void map_virt_to_phy(uint64_t virt, uint64_t phy, uint64_t flags)
{
	//clrscr();
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
	kprintf("cr3 %p \n", cr3);
	kprintf("kpml4e %p \n", kpml4e);
	kprintf("_pml4e_offset %p \n", _pml4e_offset);
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
		//kpml4e[_pml4e_offset] = ALIGN_DOWN(kpml4e[_pml4e_offset]) | flags;
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
		pdpetable[_pdpe_offset] = mm_page_to_phy(phy_page) | flags;
		//kprintf("third page address : %p \n",  pdpetable[_pdpe_offset] );
		//pdpetable[_pdpe_offset] = pde | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}
	else
	{
		pdpetable[_pdpe_offset] = ALIGN_DOWN(pdpetable[_pdpe_offset]) | flags;
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
		pdetable[_pde_offset] = ALIGN_DOWN(pdetable[_pde_offset]) | flags;
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
	int flags = PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	uint64_t *kpml4e = (uint64_t *)PHY_TO_VIRT(pml4e, uint64_t *);
	//kprintf("cr3 %p \n", cr3);
	//kprintf("kpml4e %p \n", kpml4e);
	//kprintf("_pml4e_offset %p \n", _pml4e_offset);
	//kpml4e[_pml4e_offset] = pdpe | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	
	//uint64_t *kpml4e = (uint64_t *)PHY_TO_VIRT(pml4e, uint64_t *);
	//uint64_t *kpml4e = (uint64_t *)PML4_SELF_REF;
	//k_cr3 = kpml4e;
	//if pdpe entry is not presnet in pml4e 
	if(!isPresent(kpml4e[_pml4e_offset]))
	{
		//kprintf2("allocating new page for pdpe at offset %d \n", _pml4e_offset);
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
		//kpml4e[_pml4e_offset] = ALIGN_DOWN(kpml4e[_pml4e_offset]) | flags;
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
		pdpetable[_pdpe_offset] = mm_page_to_phy(phy_page) | flags;
		//kprintf("third page address : %p \n",  pdpetable[_pdpe_offset] );
		//pdpetable[_pdpe_offset] = pde | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	}
	else
	{
		//pdpetable[_pdpe_offset] = ALIGN_DOWN(pdpetable[_pdpe_offset]) | flags;
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
		//pdetable[_pde_offset] = ALIGN_DOWN(pdetable[_pde_offset]) | flags;
		//kprintf("usig existing pt entry in pde table \n");
		//kpml4e[_pml4e_offset] = kpml4e[_pml4e_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
		
	}

	uint64_t *pttable = (uint64_t *)KADDR(ALIGN_DOWN(pdetable[_pde_offset]));
	//uint64_t *pttable = (uint64_t *)PHY_TO_VIRT(ALIGN_DOWN(pdetable[_pde_offset]), uint64_t *);
	//uint64_t *pttable = (uint64_t *)PML4_SELF_REF;
	kprintf("physical address is %p %p \n", pbase, flags);
	pttable[_pte_offset] = pbase | flags;	
	return 0;
}

#if 0
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
	//pdpetable[510] = kpml4e[_pml4e_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
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
	//pdetable[510] = pdpetable[_pdpe_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
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
	//pttable[510] = pdetable[_pde_offset] | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
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
		//kprintf2("remaining %d \n", remaining);
		for(uint64_t i = _pte_offset; i < 512; i++)            //112
		{
			pttable[i] = start | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
			start = start + PAGE_SIZE;
			//kprintf("mapping to vaddress = [%p]  kernel pt cr3 [%p] \n \n\n", (uint64_t)PHY_TO_VIRT(i, uint64_t), k_pml4e);
		}
		uint64_t num = remaining/512;              //2
		//kprintf2("num is %d remainig is %d \n", num, remaining);
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
#endif
void setup_paging(uint64_t phybase, uint64_t physfree)
{
	//kprintf("setup_paging .. started... phybase %p \n", ALIGN_DOWN(base));
	uint64_t phy_page = mm_phy_alloc_page();
	//kprintf("page no is %d \n", phy_page);
	k_cr3 = mm_page_to_phy(phy_page);	
	kprintf("first page address : %p \n", k_cr3);
	//uint64_t *kpml4e = (uint64_t *)PHY_TO_VIRT(k_cr3, uint64_t *);
	//kpml4e[510] = k_cr3 | PT_PRESENT_FLAG | PT_WRITABLE_FLAG;
	//map_all_phy(k_cr3);
	
	uint64_t vaddr = VIRT_KERNEL_BASE + phybase;

	uint64_t start = ALIGN_DOWN(phybase) /*+ 0x400000*/;
	uint64_t end = ALIGN_UP(physfree); /*- 0x400000*/
	//uint64_t end = ALIGN_UP(0x7ffe000);
	uint64_t size = end-start;
	uint64_t noofpages = (size)/PAGE_SIZE;
	if(size%PAGE_SIZE != 0)
		noofpages = noofpages + 1;
	//uint64_t noofpages = 518;
	kprintf("no of pages : %d \n", noofpages);
	for(uint64_t i = 0; i < noofpages; i++)
	{
		kernmem_mapping(vaddr, start, 1, k_cr3);
		vaddr = vaddr + PAGE_SIZE;
		start = start + PAGE_SIZE;
	}
	//kernmem_mapping(vaddr, phybase, noofpages , k_cr3);
	//video address
	kernmem_mapping(0xFFFFFFFF800B8000, 0xB8000, 1, k_cr3);
	map_all_phy(k_cr3);
	init_virtual_memory(vaddr+PAGE_SIZE);
	
	write_cr3(k_cr3);
}
//TODO: free physical pages for other directories
void free_page_tables(uint64_t pml4e){

	uint64_t *pdpe,*pde,*pte;
	uint64_t *pml4e_t = (uint64_t *)pml4e;
	for (int i = 0; i < 511; ++i)     //level 1 loop pml4e
	{
		if(isPresent(pml4e_t[i]))
		{
			pdpe = (uint64_t *)KADDR(ALIGN_DOWN(pml4e_t[i]));
			//pdpe = (uint64_t *)KADDR(pml4e_t[i]);
			for (int j = 0; j < 511; ++j)     //level 2 loop  pdpe
			{
				if(isPresent(pdpe[j]))
				{
					pde = (uint64_t *)KADDR(ALIGN_DOWN(pdpe[j]));
					//pde = (uint64_t *)KADDR(pdpe[j]);
					for (int k = 0; k < 511; ++k)     //level 3 loop pde
					{
						if(isPresent(pde[k]))
						{
							pte = (uint64_t *)KADDR(ALIGN_DOWN(pde[k]));
							//pte = (uint64_t *)KADDR(pde[k]);
							for (int n = 0; n < 511; ++n)   //level 4 loop pte
							{
								if(isPresent(pte[n]))
								{
									//kprintf2("freeing page \n");
									//mm_phy_free_page(mm_phy_to_page(ALIGN_DOWN(pte[n])));
									pte[n]=0;
								}
							}
						}
						mm_phy_free_page(mm_phy_to_page(ALIGN_DOWN(pde[k])));
						pde[k]=0;
					}
				}
				mm_phy_free_page(mm_phy_to_page(ALIGN_DOWN(pdpe[j])));
				pdpe[j]=0;
			} 
		}
		mm_phy_free_page(mm_phy_to_page(ALIGN_DOWN(pml4e_t[i])));
		pml4e_t[i] = 0;
		//kprintf2("%d \n", i);
	}
	//kprintf2("Done \n");
}
//}

void dummy_catch()
{
	int i = 0;
	kprintf("%d", i);
	return;	
}
void map_all_phy(uint64_t k_cr3)
{
	uint64_t start = 0 /*+ 0x400000*/;
	uint64_t end = ALIGN_DOWN(0x40000000); /*- 0x400000*/
	uint64_t no_of_pages = (end - start)/PAGE_SIZE;
	//kprintf2("map_all_phy: noofpages=%d \n", no_of_pages);
	//uint64_t no_of_pages = 0x3599+0x1;
	//no_of_pages = /*0x3599;*/13721;
	//no_of_pages = 13311;//0x33FF;//14846;
	uint64_t vstart = ALIGN_UP(0xffffffff00000000);
	for(uint64_t i = 0; i < no_of_pages; i++)
	{
		if(i == 13310)
		{
			dummy_catch();		
		}
		kernmem_mapping(vstart, start, 1, k_cr3);
		vstart = vstart + PAGE_SIZE;
		start = start + PAGE_SIZE;
	}
	kprintf2("One-one done\n");
	//kernmem_mapping(vstart, start, 1, k_cr3);
	//while(1);
	//kprintf2("vstart : %p pstart : %p \n", vstart, start);
	//kernmem_mapping(vstart, start, 1, k_cr3);
	//uint64_t no_of_pages = 1024*1024;
	//kernmem_mapping(VIRT_KERNEL_BASE, 0, no_of_pages , k_cr3);	
	//uint64_t end_addr = VIRT_KERNEL_BASE + no_of_pages*PAGE_SIZE;
	//kprintf("no_of_pages is %d \n", no_of_pages);
	//kprintf("start address is %p and end address is %p \n", VIRT_KERNEL_BASE , end_addr);
}
#if 0
void map_all_phy(uint64_t k_cr3, uint64_t phyfree)
{
	uint64_t start = 0 /*+ 0x400000*/;
	uint64_t end = ALIGN_DOWN(0x7ffe000); /*- 0x400000*/
	uint64_t no_of_pages = (end - start)/PAGE_SIZE;
	//uint64_t no_of_pages = 1024*1024;
	uint64_t vstart = ALIGN_UP(VIRT_KERNEL_BASE + phyfree);
	for(uint64_t i = 0; i < no_of_pages; i++)
	{
		kernmem_mapping(vstart, start, 1, k_cr3);
		vstart = vstart + PAGE_SIZE;
		start = start + PAGE_SIZE;
	}
	//uint64_t end_addr = VIRT_KERNEL_BASE + no_of_pages*PAGE_SIZE;
	//kprintf("no_of_pages is %d \n", no_of_pages);
	//kprintf("start address is %p and end address is %p \n", VIRT_KERNEL_BASE , end_addr);
}
#endif

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

void set_writable_bit(uint64_t *pte)
{
	*pte = *pte | 0x02UL;	
}

void reset_writable_bit(uint64_t *pte)
{
	*pte = *pte & 0xFFFFFFFFFFFFFFFDUL;	
}

void set_cow_bit(uint64_t *pte)
{
	*pte = *pte | 0x4000000000000000UL;	
}

void reset_cow_bit(uint64_t *pte)
{
	*pte = *pte & 0xBFFFFFFFFFFFFFFFUL;	
}

uint64_t is_cow_set(uint64_t *pte)
{
	return *pte & 0x4000000000000000UL;
}

uint64_t is_writable_page(uint64_t *pte)
{
	return *pte & 0x02;
}