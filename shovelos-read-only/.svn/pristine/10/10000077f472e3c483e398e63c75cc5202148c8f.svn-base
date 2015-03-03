
#include "16bitreal.h"
#include "inttypes.h"
#include "print.h"
#include "alloc.h"
#include <fs/fs.h>
#include <disk/disk.h>
#include "mem.h"
#include "pt.h"

extern void* _pml4e;

void shuffle_high();

extern int call_boot_aux_cpu_begin;
extern int call_boot_aux_cpu_end;

void __attribute__((noreturn))
  cmain() {

  cls();

  puts("ShovelOS Stage 1.5\n");

  fs_init();

  printf("FreeMem 0x%x\n", 0xffff - (int)alloc(0));

  /*** soooooo ugly! ***/
  {
	  poke64(ADHOC_COMM+0x00, 0); // set no copy dst
	  poke64(ADHOC_COMM+0x08, 0); // set no copy src
	  poke64(ADHOC_COMM+0x10, 0); // set no copy size
	  poke64(ADHOC_COMM+0x18, 1); // call kernel!

	  // copy the 'jump to aux cpu' boot instructions
	  // to the set 4k page boundry
	  memcpy(APSTARTUP_ADDR, (void*)(int)(&call_boot_aux_cpu_begin),((int)(&call_boot_aux_cpu_end)) - ((int)(&call_boot_aux_cpu_begin)) );

	  //printf("memcpy(0x%x,0x%x,0x%x);\n",APSTARTUP_ADDR, (void*)(int)(&call_boot_aux_cpu_begin),((int)(&call_boot_aux_cpu_end)) - ((int)(&call_boot_aux_cpu_begin)) );
	  //for(;;);

	  shuffle_high();
  }

  halt("HALTING...");
}



__asm__(".global call_boot_aux_cpu_begin");
__asm__(".global call_boot_aux_cpu_end");
__asm__("call_boot_aux_cpu_begin:");
__asm__("movl $boot_aux_cpu, %eax");
__asm__("jmpl *%eax");
__asm__("call_boot_aux_cpu_end:");



