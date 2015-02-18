#include <stdlib.h>
#include <stdio.h>
#include <sys/defs.h>
#include <sys/syscall.h>
#include <string.h>

void _start() {
	uint64_t *rsp = 0;
	uint64_t *argc;
	char **argv = NULL;
	char **envp = NULL;
	__asm __volatile("movq %%rsp, %0;":
					 	"=a" (rsp):
					 	:
					 	"cc","memory");
	
	argc = ((uint64_t *)rsp + 1);
	argv = ((char **)rsp + 0x2);
	if(*argc > 1)
		envp = argv + (*argc - 1) + 0x2;
	else
		envp = argv + 0x2;
	exit(main(*argc, argv, envp));
}
