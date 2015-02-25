
#include "16bitreal.h"

#include "mmap.h"
#include "alloc.h"
#include "print.h"
#include "mem.h"

/***********************************************************
 * read memory map from BIOS ( use int 15h EAX=e820h )
 * takes: nothing
 * writes: array to bottom of heap.
 ***********************************************************/
void _bios_15h_e820h();

__asm__("_bios_15h_e820h:\n"

  "push %edi\n"
  "push %ebx\n"
  "push $0x0018\n"				  // alloc parameter

  "xorl %ebx,         %ebx\n"     // clear ebx

".rmm_next:\n"

  "call alloc \n"
  "movw %ax, %di \n"

  "movl $0x00000001, 20(%di)\n"   // insitialise bytes 20..24 (incase the bios doesnt)
  "movl $0x534D4150,  %edx\n"
  "movl $0x0000e820,  %eax\n"
  "movl $0x00000018,  %ecx\n"
  "int  $0x00000015\n"            // call bios

  "jc   .rmm_exit\n"              // carry flag set? error
  "cmpl $0x534d4150,  %eax\n"     // eax not magic? error
  "jne  .rmm_exit\n"

  "cmpl $0, %ebx\n"               // should be non-zero. may be reset to zero after reading last entry ?
  "je  .rmm_exit\n"
  "jmp .rmm_next\n"               // next next region
".rmm_exit:\n"

  "pop %ebx\n" // pop alloc parameter
  "pop %ebx\n" // pop ebx
  "pop %edi\n" // pop edi

  "ret\n");


 // global storage for memory map. ( contains heap ptr )
 struct mmap_e820h mem = {0,0};

 /*
 static const char * types[] ={
   "UNKNOWN",
   "USABLE",
   "RESERVED",
   "ACPI RECLAIMABLE",
   "ACPI NVS",
   "BAD",
 };
 */

 struct mmap_e820h *read_mmap() {

   if(mem.map == 0) {

	   mem.map = (struct mmap_e820h_reg*)alloc(0);

	   _bios_15h_e820h();

	   mem.size = ((int)alloc(0) - (int)mem.map) / sizeof(struct mmap_e820h_reg);

	   if(!mem.size) {
		 halt("failed to read memory map!\n");
	   }

	   /* now convert this to multi-boot format for the kernel */
	   {
		   uint8_t *dst = MB_MMAP;
		   uint32_t size32 = mem.size;
		   struct mmap_e820h_reg *region = mem.map;

		   memcpy(dst, &size32, 4); dst += 4;
		   for(uint16_t i=0;i<mem.size; ++i)
		   {
			   memcpy(dst, &(region->b.b64), 8); dst += 8;
			   memcpy(dst, &(region->l.l64), 8); dst += 8;
			   memcpy(dst, &(region->type),  4); dst += 4;
			   ++region;
		   }
	   }
   }

   return &mem;
 }


