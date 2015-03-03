
/************************************************************************************************************
 * Setup long-mode page tables.
 */

#include "16bitreal.h"
#include "inttypes.h"
#include "mem.h"
#include "pt.h"
#include "mmap.h"
#include "alloc.h"
#include "print.h"

extern int _pml4e;
extern int _pdpe_ident;
extern int _pde_ident;
extern int _pdpe_hi;
extern int _pde_hi;


/*** write a 64bit page table entry to a far address ***/
void write64( uint32_t addr20, uint64_t value ) {

	memcpy((void*)addr20, &value, 8);
}

/*** write a 64bit page table entry to a far address ***/
uint64_t read64( uint32_t addr20 ) {

	uint64_t value;
	memcpy(&value, (void*)addr20, 8);

	return value;
}

uint32_t pt_get_addr(uint32_t addr20) {

	uint64_t pt = 0 ;

	memcpy( &pt, (const void*)addr20, 8);


	return  (uint32_t)ALIGN_DOWN( pt );
}

static int page_table_heap  = (int)(PML4E_BUFFER + 0x01000);
static int page_table_limit = (int)(PML4E_BUFFER + 0x10000);

static int new_table() {
	int t = page_table_heap;
	        page_table_heap += 0x1000;

	if((t+0x1000) > page_table_limit)
		halt("no more free page tables");

	return t;
}

/************************************************************************************************************
 * Create a 64bit virtual -> physical page mapping
 * takes 1) virtual page base ( PAGE_SIZE aligned )
 *       2) physical page base ( PAGE_SIZE aligned )
 */
static int debug_flag = 0;

static void pt_map_page(uint64_t virt, uint64_t phy) {

        uint32_t pml4e = (uint32_t)PML4E_BUFFER;
        uint32_t pdpe;
        uint32_t pde;

        if(debug_flag) printf("_mmap 0x%lx,0x%lx\n",phy,virt);

        if(debug_flag) printf("pml4e += (%d)\n", (0x1ff & ( virt >> 39 )));
        pml4e += 8 * (0x1ff & (virt >> 39));

        pdpe = pt_get_addr(pml4e);

        if(pdpe == 0) {

                uint64_t data  = (pdpe = new_table()) |
                                 PT_PRESENT_FLAG      |
                                 PT_WRITABLE_FLAG     ;

                write64(pml4e, data);
              if(debug_flag) printf("new pdpe at 0x%x\n",pdpe);
        }
        else
        {
        	if(debug_flag) printf("existing pdpe at 0x%x\n",pdpe);
        }


        if(debug_flag) printf("pml4e[%d] = 0x%lx\n",0x1ff & ( virt >> 39 ), read64(pml4e) );

        pdpe += 8 * (0x1ff & (virt >> 30));
        pde = pt_get_addr(pdpe);

        if((pde == 0) || (PAGE_SIZE == _1GIG)) {

                uint64_t data  = 0;

                if(PAGE_SIZE == _1GIG)
                	data = phy | PT_TERMINAL_FLAG | //PT_GLOBAL_FLAG         |
								 PT_PRESENT_FLAG  | PT_WRITABLE_FLAG       ;//|
                				 //PT_USER_FLAG     | PT_WRITE_THROUGH_FLAG  ;

                else
                	data = (pde = new_table()) | PT_PRESENT_FLAG | PT_WRITABLE_FLAG      ;//|
						                      //PT_USER_FLAG    | PT_WRITE_THROUGH_FLAG ;

                write64(pdpe, data);
        }


        if(PAGE_SIZE<=_2MEG) {

        	pde += 8 * (0x1ff & (virt >> 21));

        	uint64_t data = phy             |
							PT_PRESENT_FLAG         |
							PT_WRITABLE_FLAG        |
//							PT_USER_FLAG            |
//							PT_WRITE_THROUGH_FLAG   |
							PT_TERMINAL_FLAG        ;
//							PT_GLOBAL_FLAG          ;

        	write64(pde, data);
        }


}

/************************************************************************************************************
 * Create a page table structure for use in long mode by our bootloader.
 * The first 1 megabyte will be identity mapped.
 * high-mem will be mapped to virtual address 2Meg
 * we will map untill we run out of physical memory, or fill a whole pdpe ( max 1 gig with 2meg pages )
 */


void setup_pt(uint32_t needed_himem) {

	uint64_t pb = 0; // physical base
	uint64_t pl = 0; // physical length
	uint64_t addr64 = 0;
	struct mmap_e820h_reg kernel_reg;

	// get physical memory layout.
	struct mmap_e820h     *mmap = read_mmap();

	/*** identity map memory ***/
	for(uint64_t i=0; i<PAGE_TABLE_SIZE; i++) {

		pt_map_page(addr64,addr64); // identity map

		//debug_flag = 1;
		pt_map_page(addr64+0xffff800000000000,addr64); // at higher half offset
	//	debug_flag = 0;

//		for(;;);

		addr64 += PAGE_SIZE;
	}

	/*** identity map I/O Apic ***/
	pt_map_page(0x00000000fec00000,0x00000000fec00000);

	if(needed_himem > PAGE_SIZE)
		halt("FIXME: kernel > PAGE_SIZE");

	memset(&kernel_reg, 0, sizeof kernel_reg);

	// iterate through physical memory regions.
	for(struct mmap_e820h_reg *mreg = mmap->map; mreg < (mmap->map + mmap->size); mreg++) {

		if(mreg->type != 1)
			continue; // NOT a usable region

		pb = mreg->b.b64; // this region base
		pl = mreg->l.l64; // this region length

		// adjust physical base/length for PAGE_SIZE alignment.
		if(pb & (PAGE_SIZE-1)) {

			uint64_t waste = PAGE_SIZE - (pb % PAGE_SIZE);
			if(waste > pl)
				continue; // region too small to align, try next region.
			pl -= waste;
			if(pl < PAGE_SIZE)
				continue; // aligned region is smaller than one page, try next region.
			pb += waste;
		}

		if(pb && (pl >= needed_himem) && (( pl < kernel_reg.l.l64 ) || !kernel_reg.l.l64 )) {
			kernel_reg.type = 1;
			kernel_reg.b.b64 = pb;
			kernel_reg.l.l64 = pl;
		}
	}

	if(kernel_reg.type == 1) {
		pt_map_page(0xFFFFFFFF80000000,kernel_reg.b.b64);
	}
	else
		halt("couldnt find a suitable place for the kernel!");

}

