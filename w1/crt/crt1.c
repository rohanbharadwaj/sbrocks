#include <stdlib.h>
#include <stdio.h>
#include <sys/defs.h>
#include <sys/syscall.h>

/*
http://www.scs.stanford.edu/histar/src/pkg/uclibc/libc/sysdeps/linux/e1/crt1.c
*/
void _start(uint64_t sTop) {
	uint64_t *argc;
	char **argv = NULL;
	char **envp = NULL;
	int res;
	//unsigned long *stack;

	//stack = (uint64_t*) ((void*)&sTop + 16);
	//argc = (uint64_t*)((void*)&sTop+0x10UL);
	//argv = (char**)((void*)&sTop+0x18UL);
	//int stacktop = 
	argc = (uint64_t*)(&sTop+1);
	argv = (char**)((void*)&sTop+32);
	envp = (char**)((void*)&sTop+32 + (*argc)*32 + 16);
	//printf("shashi %s \n", envp[0]);
	//argc = stack;
	//int i = 0x10UL;
	//printf("i is %d", i);
	//printf("crt1.c %d argv[1] : %s \n", *argc, argv[1]);
	//printf("shashi::   %d %s \n", /*(uint64_t*)((void*)&sTop + 0x10UL)*/*argc, argv[0]);
	res = main(*argc, argv, envp);
	exit(res);
}
