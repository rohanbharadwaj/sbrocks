/*
*	web  reference: http://www.osdever.net/tutorials/view/implementing-basic-paging
*/
#include <sys/mmu/phy_alloc.h>
#include <sys/sbunix.h>

#define ALIGN_UP(x)     (((x) & (PAGE_TABLE_ALIGNLENT-1)) ? ALIGN_DOWN(x+PAGE_TABLE_ALIGNLENT) : (x))
#define ALIGN_DOWN(x) ((x) >> 12 << 12)

static uint64_t phy_bitmap[(PAGE_MAX/64) +1];
static void set_page_free(uint64_t page);
static void set_page_used(uint64_t page);
void enable_paging(void);

uint64_t *page_directory;
uint64_t *page_table;

#define PAGES_PER_GROUP ((sizeof phy_bitmap[0]) * 8)

void mm_phy_init(uint64_t base, uint64_t length, uint64_t type)
{
	//set all pages as unavailable
	memset(phy_bitmap, 0xff, sizeof(phy_bitmap));
	//kprintf("bitmap for group 9 is %s \n", byte_to_binary(phy_bitmap[9]));
	uint64_t start = ALIGN_DOWN(base) /*+ 0x400000*/;
	//kprintf("start address in phy_init is %p : ", start);
	uint64_t end = ALIGN_UP(base+length) /*- 0x400000*/;
	//TODO align start and end with PAGE size
	for(uint64_t i = start; i < end; i = i+PAGE_SIZE)
	{
		set_page_free(mm_phy_to_page(i));	
	}
	//mark low memory upto 1Mb or ox100,000 as used for real mode 
	for(uint64_t lowmem=0; lowmem < 0x100000; lowmem += PAGE_SIZE)
		set_page_used( mm_phy_to_page(lowmem) );
	phy_bitmap[0] |= 1;		//don't map 0th page it is for null pointe
	//kprintf("mm_phy_init initialized .... \n");
	//while(1);
}

static void set_page_free(uint64_t page) {
	//kprintf("shashi \n");
	//uint64_t flag = page%64;
	//kprintf("page %d \n", page%64);
	//uint64_t a = ~(1 << (page % 64));
	//kprintf("shashi %s \n", byte_to_binary(a));
	uint64_t i = 1;
	if(page)
	{
	    phy_bitmap[page/64] &= ~(i << (page % 64));
		//kprintf("shashi %s \n", byte_to_binary(phy_bitmap[page/64]));	
	}
	/*uint64_t g = page/64;
	if(g == 9)
	{
		uint64_t page_no = page %64;
			//kprintf("beyonf possible page no \n");
		//kprintf("bitmap %s \n", byte_to_binary(phy_bitmap[9]));
			kprintf("setting bit %d \n", page_no);
			kprintf("bitmap  %s \n", byte_to_binary(phy_bitmap[9]));
	}*/
}
static int count = 0;
static void set_page_used(uint64_t page) {

	if(page)
	{
		count = count + 1;
		//kprintf("page no # %d, count is %d \n", page/64, count);
	    phy_bitmap[page/64] |= (1 << (page % 64));
	}
}

/****************************************************
 * mm_phy_free_page: free given page.
 */
void mm_phy_free_page(uint64_t page) {

	if(!page)
		return;
	set_page_free(page);
}

/****************************************************
 * mm_phy_alloc_page: Allocate the first free page.
 * returns page number, or zero on out of memory.
 */
uint64_t mm_phy_alloc_page() {
	//kprintf("mm_phy_alloc_page \n");
	for(uint64_t g=0; g< sizeof phy_bitmap / sizeof phy_bitmap[0]; ++g) {
		uint64_t _g = phy_bitmap[g];
		if(_g != 0xffffffffffffffff)
			for(uint8_t p = 0; p< PAGES_PER_GROUP; ++p)
			{
				//kprintf("group no : %d ,  bitmap is %s \n", _g, byte_to_binary(phy_bitmap[g]));
				if((_g & (1 << p)) == 0) {

					phy_bitmap[g] |= (1 << p);

					if(((g * PAGES_PER_GROUP) + p) == 0)
						kprintf("ERR: ALLOCATING PAGE ZERO!!!\n");
					//kprintf(" group no: %p and page no %p \n", g, p);
					return (g * PAGES_PER_GROUP) + p;
				}
			}
	}
	kprintf("page not allocated \n");
	return 0; /* no free pages  */
}


