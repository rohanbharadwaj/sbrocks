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
	//printf("%s \n\n\n\n", *((char **)rsp + 0x02));
	//argc = *((int *)rsp + 0x2);
	//(char **)(rsp+0x10)
	//argc = *((int *)rsp + 0x2);
	
	/*printf("env is %s \n", *argv);	
	argv++;
	printf("env is %s \n", *argv);*/
	//envp = argv;
	argc = ((uint64_t *)rsp + 1);
	//uint64_t *i = 0;
	//memcpy(i, argc, sizeof(uint64_t) + 1);
	//i = (int)*argc;
	
	//i = *argc;
	//printf("%d\n", i);
//	int j = *argc;
	//int j = *((int *)rsp + 0x2);
	//printf("argc is %d \n", *((int *)rsp + 0x2));
	printf("argc is %d \n\n", *argc);
	argv = ((char **)rsp + 0x2);

	//printf("argv is %s \n", argv[0]);	
	//printf("argv is %s \n", argv[1]);	
	//envp = argv;
	if(*argc > 1)
		envp = argv + (*argc - 1) + 0x2;
	else
		envp = argv + 0x2;
	//envp = envp+ 0x2;
	#if 0
	for(int i = 0/*(int)*((int *)rsp + 0x2)*/; i < 2; i++)
	{
		printf("env is %s \n", *envp);	
		envp++;	
	};
	//if(*envp == NULL)
		printf("shashi \n");
	//envp = ((char **)argv + (*argc) +0x8);
	//printf("env is %s \n", *envp);	
	#endif
	//envp = ((char **)rsp + 0x02 + *((int *)rsp+0x02)*0x02);
	exit(main(*argc/**((int *)rsp + 0x2)*/, argv, envp));
}

/*
http://www.scs.stanford.edu/histar/src/pkg/uclibc/libc/sysdeps/linux/e1/crt1.c
*/
#if 0
void _start(uint64_t sTop) {
	int *argc;
	__asm __volatile("movq %%rsp, %0;":
					 	"=rsp" (argc):
					 	:
					 	"cc","memory");
					 	
	printf("argc is %d \n", *(argc));				 
	//uint64_t *argc =  (uint64_t*)(&sTop);
	#if 0
	uint64_t *argc;
	//printf("shashi argc")
	char **argv = NULL;
	char **envp = NULL;
	//int res;
	//unsigned long *stack;

	//stack = (uint64_t*) ((void*)&sTop + 16);
	//argc = (uint64_t*)((void*)&sTop+0x10UL);
	argc = (uint64_t*)((void*)&sTop+0x10UL);
	argv = (char**)((void*)&sTop+0x18UL);
	//int stacktop = 
	//argc = (uint64_t*)(&sTop+10UL);
	//argv = (char**)((void*)&sTop+32);
	envp = (char**)((void*)&sTop+32 + (*argc)*32 + 16);
	//printf("shashi %s \n", envp[0]);
	//argc = stack;
	//int i = 0x10UL;
	//printf("i is %d", i);
	//printf("crt1.c %d args are %s \n", *argc, argv[0]);
	//printf("shashi::   %d %s \n", /*(uint64_t*)((void*)&sTop + 0x10UL)*/*argc, argv[0]);
	#endif
	exit(main(*argc, NULL, NULL));
	//exit(res);
}
#endif
