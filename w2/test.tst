
rootfs/bin/malloctest:     file format elf64-x86-64


Disassembly of section .text:

00000000004000f0 <_start>:
#include <stdio.h>
#include <sys/defs.h>
#include <sys/syscall.h>
#include <string.h>

void _start() {
  4000f0:	48 83 ec 08          	sub    $0x8,%rsp
	uint64_t *rsp = 0;
	uint64_t *argc;
	char **argv = NULL;
	char **envp = NULL;
	__asm __volatile("movq %%rsp, %0;":
  4000f4:	48 89 e0             	mov    %rsp,%rax
					 	"=a" (rsp):
					 	:
					 	"cc","memory");
	
	argc = ((uint64_t *)rsp + 1);
	argv = ((char **)rsp + 0x2);
  4000f7:	48 8d 70 10          	lea    0x10(%rax),%rsi
	if(*argc > 1)
  4000fb:	48 8b 78 08          	mov    0x8(%rax),%rdi
  4000ff:	48 83 ff 01          	cmp    $0x1,%rdi
  400103:	76 07                	jbe    40010c <_start+0x1c>
		envp = argv + (*argc - 1) + 0x2;
  400105:	48 8d 54 fe 08       	lea    0x8(%rsi,%rdi,8),%rdx
  40010a:	eb 04                	jmp    400110 <_start+0x20>
	else
		envp = argv + 0x2;
  40010c:	48 8d 50 20          	lea    0x20(%rax),%rdx
	exit(main(*argc, argv, envp));
  400110:	e8 0c 00 00 00       	callq  400121 <main>
  400115:	89 c7                	mov    %eax,%edi
  400117:	e8 cc 0d 00 00       	callq  400ee8 <exit>
}
  40011c:	48 83 c4 08          	add    $0x8,%rsp
  400120:	c3                   	retq   

0000000000400121 <main>:
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void testmalloc();
void testfork();
int main(int argc, char* argv[], char* envp[]) {
  400121:	53                   	push   %rbx
		sleep(1);
		printf("shashi %d \n", i);
	}
	#endif
	
	char *c =(char*) malloc(20);
  400122:	bf 14 00 00 00       	mov    $0x14,%edi
  400127:	e8 a4 02 00 00       	callq  4003d0 <malloc>
  40012c:	48 89 c3             	mov    %rax,%rbx
	//char c[1024];
	strcpy(c, "shashi");
  40012f:	48 8d 35 da 13 00 00 	lea    0x13da(%rip),%rsi        # 401510 <atoi+0x33>
  400136:	48 89 c7             	mov    %rax,%rdi
  400139:	e8 f2 11 00 00       	callq  401330 <strcpy>
	//strcat(c, d);
	//printf("%p \n", &c);
	//printf("parent: %s \n", c);
	printf("parent::string is : %s \n", c);
  40013e:	48 89 de             	mov    %rbx,%rsi
  400141:	48 8d 3d cf 13 00 00 	lea    0x13cf(%rip),%rdi        # 401517 <atoi+0x3a>
  400148:	b8 00 00 00 00       	mov    $0x0,%eax
  40014d:	e8 d1 0a 00 00       	callq  400c23 <printf>
	char c[1024];
	scanf("%s", c);
	printf("read string : %s \n", c);
	testfork();*/
	return 0;
}
  400152:	b8 00 00 00 00       	mov    $0x0,%eax
  400157:	5b                   	pop    %rbx
  400158:	c3                   	retq   

0000000000400159 <testmalloc>:

void testmalloc()
{
  400159:	41 54                	push   %r12
  40015b:	55                   	push   %rbp
  40015c:	53                   	push   %rbx
	//printf("*********************************************\n");
	//printf("testing  malloc() and free() API \n");
	char *c[100];
	for(int i = 0; i<10; i++)
  40015d:	bb 00 00 00 00       	mov    $0x0,%ebx
	{
		c[i] =(char*) malloc(2048);
		strcpy(c[i], "shashi");
  400162:	4c 8d 25 a7 13 00 00 	lea    0x13a7(%rip),%r12        # 401510 <atoi+0x33>
	//printf("*********************************************\n");
	//printf("testing  malloc() and free() API \n");
	char *c[100];
	for(int i = 0; i<10; i++)
	{
		c[i] =(char*) malloc(2048);
  400169:	bf 00 08 00 00       	mov    $0x800,%edi
  40016e:	e8 5d 02 00 00       	callq  4003d0 <malloc>
  400173:	48 89 c5             	mov    %rax,%rbp
		strcpy(c[i], "shashi");
  400176:	4c 89 e6             	mov    %r12,%rsi
  400179:	48 89 c7             	mov    %rax,%rdi
  40017c:	e8 af 11 00 00       	callq  401330 <strcpy>
		printf("%s i=%d \n", c[i], i);
  400181:	89 da                	mov    %ebx,%edx
  400183:	48 89 ee             	mov    %rbp,%rsi
  400186:	48 8d 3d a3 13 00 00 	lea    0x13a3(%rip),%rdi        # 401530 <atoi+0x53>
  40018d:	b8 00 00 00 00       	mov    $0x0,%eax
  400192:	e8 8c 0a 00 00       	callq  400c23 <printf>
void testmalloc()
{
	//printf("*********************************************\n");
	//printf("testing  malloc() and free() API \n");
	char *c[100];
	for(int i = 0; i<10; i++)
  400197:	ff c3                	inc    %ebx
  400199:	83 fb 0a             	cmp    $0xa,%ebx
  40019c:	75 cb                	jne    400169 <testmalloc+0x10>
	//printf("shashi \n");
	printf("%s \n", e);
	printf("malloc API succesfull \n");
	printf("free API open succesfull \n");
	#endif
	printf("\n\n");
  40019e:	48 8d 3d 95 13 00 00 	lea    0x1395(%rip),%rdi        # 40153a <atoi+0x5d>
  4001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  4001aa:	e8 74 0a 00 00       	callq  400c23 <printf>
}
  4001af:	5b                   	pop    %rbx
  4001b0:	5d                   	pop    %rbp
  4001b1:	41 5c                	pop    %r12
  4001b3:	c3                   	retq   

00000000004001b4 <testfork>:

void testfork()
{
  4001b4:	55                   	push   %rbp
  4001b5:	53                   	push   %rbx
  4001b6:	48 83 ec 18          	sub    $0x18,%rsp
	printf("*********************************************\n");
  4001ba:	48 8d 3d 3f 14 00 00 	lea    0x143f(%rip),%rdi        # 401600 <atoi+0x123>
  4001c1:	b8 00 00 00 00       	mov    $0x0,%eax
  4001c6:	e8 58 0a 00 00       	callq  400c23 <printf>
	printf("Testing fork, waitpid, sleep system calls \n \n");
  4001cb:	48 8d 3d 5e 14 00 00 	lea    0x145e(%rip),%rdi        # 401630 <atoi+0x153>
  4001d2:	b8 00 00 00 00       	mov    $0x0,%eax
  4001d7:	e8 47 0a 00 00       	callq  400c23 <printf>
	//strcpy(c, "shashi");
	//printf("%s \n", c);
	//c =(char*) malloc(20);
	//strcpy(c, "ranjan");
	//printf("%s \n", c);
	char *c =(char*) malloc(20);
  4001dc:	bf 14 00 00 00       	mov    $0x14,%edi
  4001e1:	e8 ea 01 00 00       	callq  4003d0 <malloc>
  4001e6:	48 89 c3             	mov    %rax,%rbx
	//char c[1024];
	strcpy(c, "shashi");
  4001e9:	48 8d 35 20 13 00 00 	lea    0x1320(%rip),%rsi        # 401510 <atoi+0x33>
  4001f0:	48 89 c7             	mov    %rax,%rdi
  4001f3:	e8 38 11 00 00       	callq  401330 <strcpy>
	//strcat(c, d);
	//printf("%p \n", &c);
	//printf("parent: %s \n", c);
	printf("parent::string is : %s \n", c);
  4001f8:	48 89 de             	mov    %rbx,%rsi
  4001fb:	48 8d 3d 15 13 00 00 	lea    0x1315(%rip),%rdi        # 401517 <atoi+0x3a>
  400202:	b8 00 00 00 00       	mov    $0x0,%eax
  400207:	e8 17 0a 00 00       	callq  400c23 <printf>
	printf("I am in parent \n \n");
  40020c:	48 8d 3d 2a 13 00 00 	lea    0x132a(%rip),%rdi        # 40153d <atoi+0x60>
  400213:	b8 00 00 00 00       	mov    $0x0,%eax
  400218:	e8 06 0a 00 00       	callq  400c23 <printf>
	//free(c);
	//printf("%s \n", c);
	
	//printf("testing  fork() API  \n");
	int pid = fork();
  40021d:	e8 20 0d 00 00       	callq  400f42 <fork>
  400222:	89 c5                	mov    %eax,%ebp
	if(pid == 0)
  400224:	85 c0                	test   %eax,%eax
  400226:	0f 85 de 00 00 00    	jne    40030a <testfork+0x156>
	{
		printf("I am in child \n");
  40022c:	48 8d 3d 1d 13 00 00 	lea    0x131d(%rip),%rdi        # 401550 <atoi+0x73>
  400233:	b8 00 00 00 00       	mov    $0x0,%eax
  400238:	e8 e6 09 00 00       	callq  400c23 <printf>
		printf("child::string is : %s \n", c);
  40023d:	48 89 de             	mov    %rbx,%rsi
  400240:	48 8d 3d 19 13 00 00 	lea    0x1319(%rip),%rdi        # 401560 <atoi+0x83>
  400247:	b8 00 00 00 00       	mov    $0x0,%eax
  40024c:	e8 d2 09 00 00       	callq  400c23 <printf>
		//printf("%p \n", &c);
		//printf("child process is %s \n", c);
		strcpy(c, "ranjan");
  400251:	48 8d 35 20 13 00 00 	lea    0x1320(%rip),%rsi        # 401578 <atoi+0x9b>
  400258:	48 89 df             	mov    %rbx,%rdi
  40025b:	e8 d0 10 00 00       	callq  401330 <strcpy>
		printf("child::after modification: %s \n", c);
  400260:	48 89 de             	mov    %rbx,%rsi
  400263:	48 8d 3d f6 13 00 00 	lea    0x13f6(%rip),%rdi        # 401660 <atoi+0x183>
  40026a:	b8 00 00 00 00       	mov    $0x0,%eax
  40026f:	e8 af 09 00 00       	callq  400c23 <printf>
		char *d =(char*) malloc(20);	
  400274:	bf 14 00 00 00       	mov    $0x14,%edi
  400279:	e8 52 01 00 00       	callq  4003d0 <malloc>
  40027e:	48 89 c3             	mov    %rax,%rbx
		strcpy(d, "ashish");
  400281:	48 8d 35 f7 12 00 00 	lea    0x12f7(%rip),%rsi        # 40157f <atoi+0xa2>
  400288:	48 89 c7             	mov    %rax,%rdi
  40028b:	e8 a0 10 00 00       	callq  401330 <strcpy>
		printf("child::string d is : %s \n", d);
  400290:	48 89 de             	mov    %rbx,%rsi
  400293:	48 8d 3d ec 12 00 00 	lea    0x12ec(%rip),%rdi        # 401586 <atoi+0xa9>
  40029a:	b8 00 00 00 00       	mov    $0x0,%eax
  40029f:	e8 7f 09 00 00       	callq  400c23 <printf>
		c =(char*) malloc(20);	
  4002a4:	bf 14 00 00 00       	mov    $0x14,%edi
  4002a9:	e8 22 01 00 00       	callq  4003d0 <malloc>
  4002ae:	48 89 c3             	mov    %rax,%rbx
		strcpy(c, "goel");
  4002b1:	48 8d 35 e8 12 00 00 	lea    0x12e8(%rip),%rsi        # 4015a0 <atoi+0xc3>
  4002b8:	48 89 c7             	mov    %rax,%rdi
  4002bb:	e8 70 10 00 00       	callq  401330 <strcpy>
		printf("child::string d is : %s \n", c);
  4002c0:	48 89 de             	mov    %rbx,%rsi
  4002c3:	48 8d 3d bc 12 00 00 	lea    0x12bc(%rip),%rdi        # 401586 <atoi+0xa9>
  4002ca:	b8 00 00 00 00       	mov    $0x0,%eax
  4002cf:	e8 4f 09 00 00       	callq  400c23 <printf>
		strcpy(c, "ashish");
		printf("value inside  fork() API %s \n", d);
		printf("new value is %s \n", c);*/
		//printf("I am in child \n");
		//c = (char *)0x100;
		sleep(5);
  4002d4:	bf 05 00 00 00       	mov    $0x5,%edi
  4002d9:	e8 db 0c 00 00       	callq  400fb9 <sleep>
		printf("child: after sleep \n");
  4002de:	48 8d 3d c0 12 00 00 	lea    0x12c0(%rip),%rdi        # 4015a5 <atoi+0xc8>
  4002e5:	b8 00 00 00 00       	mov    $0x0,%eax
  4002ea:	e8 34 09 00 00       	callq  400c23 <printf>
		printf("child: Dying!!! \n");
  4002ef:	48 8d 3d c4 12 00 00 	lea    0x12c4(%rip),%rdi        # 4015ba <atoi+0xdd>
  4002f6:	b8 00 00 00 00       	mov    $0x0,%eax
  4002fb:	e8 23 09 00 00       	callq  400c23 <printf>
		
		exit(1);
  400300:	bf 01 00 00 00       	mov    $0x1,%edi
  400305:	e8 de 0b 00 00       	callq  400ee8 <exit>
	}
	//
	int status;
	//printf("testing  fork() API %s \n", c);
	printf("waiting for child to finish \n");
  40030a:	48 8d 3d bb 12 00 00 	lea    0x12bb(%rip),%rdi        # 4015cc <atoi+0xef>
  400311:	b8 00 00 00 00       	mov    $0x0,%eax
  400316:	e8 08 09 00 00       	callq  400c23 <printf>
	waitpid(pid,&status,0);
  40031b:	48 8d 74 24 0c       	lea    0xc(%rsp),%rsi
  400320:	ba 00 00 00 00       	mov    $0x0,%edx
  400325:	89 ef                	mov    %ebp,%edi
  400327:	e8 48 0f 00 00       	callq  401274 <waitpid>
	//printf("status : %d \n", status);
	//sleep(10);
	//while(1);
	//printf("parent pid is %d \n", pid);
	
	printf("Parent: Dying!!!!! \n");
  40032c:	48 8d 3d b7 12 00 00 	lea    0x12b7(%rip),%rdi        # 4015ea <atoi+0x10d>
  400333:	b8 00 00 00 00       	mov    $0x0,%eax
  400338:	e8 e6 08 00 00       	callq  400c23 <printf>
  40033d:	48 83 c4 18          	add    $0x18,%rsp
  400341:	5b                   	pop    %rbx
  400342:	5d                   	pop    %rbp
  400343:	c3                   	retq   
  400344:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  40034b:	00 00 00 
  40034e:	66 90                	xchg   %ax,%ax

0000000000400350 <free>:
}

void free(void *ptr)
{
	//printf("freed \n");
	if(ptr == NULL)
  400350:	48 85 ff             	test   %rdi,%rdi
  400353:	74 07                	je     40035c <free+0xc>
		return;
	struct mem_block *block = (struct mem_block *)ptr -1 ;
	block->free = FREE;
  400355:	c7 47 f0 01 00 00 00 	movl   $0x1,-0x10(%rdi)
  40035c:	f3 c3                	repz retq 

000000000040035e <find_free_mem_block>:

//our code
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size)
{
	//printf("find_free_mem_block called %d \n \n\n\n ", size);
	struct mem_block *temp = head;
  40035e:	48 8d 05 bb 20 20 00 	lea    0x2020bb(%rip),%rax        # 602420 <head>
  400365:	48 8b 00             	mov    (%rax),%rax
	while(temp && !(temp->free == FREE && temp->size >= size))
  400368:	48 85 c0             	test   %rax,%rax
  40036b:	75 0e                	jne    40037b <find_free_mem_block+0x1d>
  40036d:	f3 c3                	repz retq 
	{
		*last = temp;
  40036f:	48 89 07             	mov    %rax,(%rdi)
		temp = temp->next;	
  400372:	48 8b 40 10          	mov    0x10(%rax),%rax
//our code
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size)
{
	//printf("find_free_mem_block called %d \n \n\n\n ", size);
	struct mem_block *temp = head;
	while(temp && !(temp->free == FREE && temp->size >= size))
  400376:	48 85 c0             	test   %rax,%rax
  400379:	74 0b                	je     400386 <find_free_mem_block+0x28>
  40037b:	83 78 08 01          	cmpl   $0x1,0x8(%rax)
  40037f:	75 ee                	jne    40036f <find_free_mem_block+0x11>
  400381:	48 39 30             	cmp    %rsi,(%rax)
  400384:	72 e9                	jb     40036f <find_free_mem_block+0x11>
	{
		*last = temp;
		temp = temp->next;	
	}
	return temp;
}
  400386:	f3 c3                	repz retq 

0000000000400388 <allocateMemory>:

/* allocate memory of size  */
struct mem_block *allocateMemory(size_t size)
{
  400388:	55                   	push   %rbp
  400389:	53                   	push   %rbx
  40038a:	48 83 ec 08          	sub    $0x8,%rsp
  40038e:	48 89 fd             	mov    %rdi,%rbp
	struct mem_block *current;
	current = sbrk(0);
  400391:	bf 00 00 00 00       	mov    $0x0,%edi
  400396:	e8 79 0b 00 00       	callq  400f14 <sbrk>
  40039b:	48 89 c3             	mov    %rax,%rbx
	void *addr = sbrk(size + BLOCK_SIZE);
  40039e:	48 8d 7d 18          	lea    0x18(%rbp),%rdi
  4003a2:	e8 6d 0b 00 00       	callq  400f14 <sbrk>
	
	if (addr == (void*) -1) {
  4003a7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  4003ab:	74 17                	je     4003c4 <allocateMemory+0x3c>
		/* memory allocation failed */
		return NULL; 
  	}
	current->size = size;  //by removing memory block size
  4003ad:	48 89 2b             	mov    %rbp,(%rbx)
	current->next = NULL;
  4003b0:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  4003b7:	00 
	current->free = USED;
  4003b8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%rbx)
	return current;
  4003bf:	48 89 d8             	mov    %rbx,%rax
  4003c2:	eb 05                	jmp    4003c9 <allocateMemory+0x41>
	current = sbrk(0);
	void *addr = sbrk(size + BLOCK_SIZE);
	
	if (addr == (void*) -1) {
		/* memory allocation failed */
		return NULL; 
  4003c4:	b8 00 00 00 00       	mov    $0x0,%eax
  	}
	current->size = size;  //by removing memory block size
	current->next = NULL;
	current->free = USED;
	return current;
}
  4003c9:	48 83 c4 08          	add    $0x8,%rsp
  4003cd:	5b                   	pop    %rbx
  4003ce:	5d                   	pop    %rbp
  4003cf:	c3                   	retq   

00000000004003d0 <malloc>:
struct mem_block *allocateMemory(size_t size);
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size);
void *malloc(size_t size);

void *malloc(size_t size)
{
  4003d0:	53                   	push   %rbx
  4003d1:	48 83 ec 10          	sub    $0x10,%rsp
  4003d5:	48 89 fb             	mov    %rdi,%rbx
	//printf("malloc start \n");
	struct mem_block *block;
	if(size <= 0)
  4003d8:	48 85 ff             	test   %rdi,%rdi
  4003db:	74 61                	je     40043e <malloc+0x6e>
		return NULL;
	
	if(head == NULL)
  4003dd:	48 8d 05 3c 20 20 00 	lea    0x20203c(%rip),%rax        # 602420 <head>
  4003e4:	48 8b 00             	mov    (%rax),%rax
  4003e7:	48 85 c0             	test   %rax,%rax
  4003ea:	75 16                	jne    400402 <malloc+0x32>
	{
		//printf("first time allocation %d \n",size);
		block = allocateMemory(size);
  4003ec:	e8 97 ff ff ff       	callq  400388 <allocateMemory>
		if(block == NULL)
  4003f1:	48 85 c0             	test   %rax,%rax
  4003f4:	74 4f                	je     400445 <malloc+0x75>
		{
			/*memory allocation failed */
			return NULL;	
		}
		head = block;
  4003f6:	48 8d 15 23 20 20 00 	lea    0x202023(%rip),%rdx        # 602420 <head>
  4003fd:	48 89 02             	mov    %rax,(%rdx)
  400400:	eb 36                	jmp    400438 <malloc+0x68>
	}
	else
	{
		//search for free block
		struct mem_block *last = head;
  400402:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
		block = find_free_mem_block(&last, size);
  400407:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  40040c:	48 89 de             	mov    %rbx,%rsi
  40040f:	e8 4a ff ff ff       	callq  40035e <find_free_mem_block>
		//printf("found free memory block \n");
		if(block == NULL)
  400414:	48 85 c0             	test   %rax,%rax
  400417:	75 18                	jne    400431 <malloc+0x61>
		{
			//printf("added at the end %d \n", size);
			block = allocateMemory(size);
  400419:	48 89 df             	mov    %rbx,%rdi
  40041c:	e8 67 ff ff ff       	callq  400388 <allocateMemory>
			if(block == NULL)
  400421:	48 85 c0             	test   %rax,%rax
  400424:	74 24                	je     40044a <malloc+0x7a>
				return NULL;
			last->next = block;
  400426:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  40042b:	48 89 42 10          	mov    %rax,0x10(%rdx)
  40042f:	eb 07                	jmp    400438 <malloc+0x68>
		}
		else{
			//use free block found
			//printf("using free block \n");
			block->free = USED;
  400431:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
		}
	}
	//printf("malloc end \n");
 	return(block+1); 
  400438:	48 83 c0 18          	add    $0x18,%rax
  40043c:	eb 0c                	jmp    40044a <malloc+0x7a>
void *malloc(size_t size)
{
	//printf("malloc start \n");
	struct mem_block *block;
	if(size <= 0)
		return NULL;
  40043e:	b8 00 00 00 00       	mov    $0x0,%eax
  400443:	eb 05                	jmp    40044a <malloc+0x7a>
		//printf("first time allocation %d \n",size);
		block = allocateMemory(size);
		if(block == NULL)
		{
			/*memory allocation failed */
			return NULL;	
  400445:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	//printf("malloc end \n");
 	return(block+1); 
	//added 1 because block is a pointer of type struct and 
	//plus 1 increments the address by one sizeof(struct)
}
  40044a:	48 83 c4 10          	add    $0x10,%rsp
  40044e:	5b                   	pop    %rbx
  40044f:	c3                   	retq   

0000000000400450 <number>:
        return i;
}

static char *number(char *str, long num, int base, int size, int precision,
		    int type)
{
  400450:	41 57                	push   %r15
  400452:	41 56                	push   %r14
  400454:	41 55                	push   %r13
  400456:	41 54                	push   %r12
  400458:	55                   	push   %rbp
  400459:	53                   	push   %rbx
  40045a:	48 83 ec 55          	sub    $0x55,%rsp
  40045e:	41 89 d6             	mov    %edx,%r14d
	char c, sign, locase;
	int i;

	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
	 * produces same digits or (maybe lowercased) letters */
	locase = (type & SMALL);
  400461:	45 89 cd             	mov    %r9d,%r13d
  400464:	41 83 e5 20          	and    $0x20,%r13d
	if (type & LEFT)
  400468:	44 89 ca             	mov    %r9d,%edx
  40046b:	83 e2 10             	and    $0x10,%edx
		type &= ~ZEROPAD;
  40046e:	44 89 c8             	mov    %r9d,%eax
  400471:	83 e0 fe             	and    $0xfffffffe,%eax
  400474:	85 d2                	test   %edx,%edx
  400476:	44 0f 45 c8          	cmovne %eax,%r9d
	if (base < 2 || base > 16)
  40047a:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  40047e:	83 f8 0e             	cmp    $0xe,%eax
  400481:	0f 87 ee 01 00 00    	ja     400675 <number+0x225>
  400487:	45 89 f2             	mov    %r14d,%r10d
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
  40048a:	44 89 c8             	mov    %r9d,%eax
  40048d:	83 e0 01             	and    $0x1,%eax
  400490:	83 f8 01             	cmp    $0x1,%eax
  400493:	45 19 ff             	sbb    %r15d,%r15d
  400496:	41 83 e7 f0          	and    $0xfffffff0,%r15d
  40049a:	41 83 c7 30          	add    $0x30,%r15d
	sign = 0;
  40049e:	c6 04 24 00          	movb   $0x0,(%rsp)
	if (type & SIGN) {
  4004a2:	41 f6 c1 02          	test   $0x2,%r9b
  4004a6:	74 2e                	je     4004d6 <number+0x86>
		if (num < 0) {
  4004a8:	48 85 f6             	test   %rsi,%rsi
  4004ab:	79 0b                	jns    4004b8 <number+0x68>
			sign = '-';
			num = -num;
  4004ad:	48 f7 de             	neg    %rsi
			size--;
  4004b0:	ff c9                	dec    %ecx
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
	sign = 0;
	if (type & SIGN) {
		if (num < 0) {
			sign = '-';
  4004b2:	c6 04 24 2d          	movb   $0x2d,(%rsp)
  4004b6:	eb 1e                	jmp    4004d6 <number+0x86>
			num = -num;
			size--;
		} else if (type & PLUS) {
  4004b8:	41 f6 c1 04          	test   $0x4,%r9b
  4004bc:	74 08                	je     4004c6 <number+0x76>
			sign = '+';
			size--;
  4004be:	ff c9                	dec    %ecx
		if (num < 0) {
			sign = '-';
			num = -num;
			size--;
		} else if (type & PLUS) {
			sign = '+';
  4004c0:	c6 04 24 2b          	movb   $0x2b,(%rsp)
  4004c4:	eb 10                	jmp    4004d6 <number+0x86>
	if (type & LEFT)
		type &= ~ZEROPAD;
	if (base < 2 || base > 16)
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
	sign = 0;
  4004c6:	c6 04 24 00          	movb   $0x0,(%rsp)
			num = -num;
			size--;
		} else if (type & PLUS) {
			sign = '+';
			size--;
		} else if (type & SPACE) {
  4004ca:	41 f6 c1 08          	test   $0x8,%r9b
  4004ce:	74 06                	je     4004d6 <number+0x86>
			sign = ' ';
			size--;
  4004d0:	ff c9                	dec    %ecx
			size--;
		} else if (type & PLUS) {
			sign = '+';
			size--;
		} else if (type & SPACE) {
			sign = ' ';
  4004d2:	c6 04 24 20          	movb   $0x20,(%rsp)
			size--;
		}
	}
	if (type & SPECIAL) {
  4004d6:	44 89 c8             	mov    %r9d,%eax
  4004d9:	83 e0 40             	and    $0x40,%eax
  4004dc:	89 44 24 01          	mov    %eax,0x1(%rsp)
  4004e0:	74 17                	je     4004f9 <number+0xa9>
		if (base == 16)
  4004e2:	41 83 fe 10          	cmp    $0x10,%r14d
  4004e6:	75 05                	jne    4004ed <number+0x9d>
			size -= 2;
  4004e8:	83 e9 02             	sub    $0x2,%ecx
  4004eb:	eb 0c                	jmp    4004f9 <number+0xa9>
		else if (base == 8)
			size--;
  4004ed:	41 83 fe 08          	cmp    $0x8,%r14d
  4004f1:	0f 94 c0             	sete   %al
  4004f4:	0f b6 c0             	movzbl %al,%eax
  4004f7:	29 c1                	sub    %eax,%ecx
	}
	i = 0;
	if (num == 0)
  4004f9:	48 85 f6             	test   %rsi,%rsi
  4004fc:	75 0d                	jne    40050b <number+0xbb>
		tmp[i++] = '0';
  4004fe:	c6 44 24 13 30       	movb   $0x30,0x13(%rsp)
  400503:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  400509:	eb 4c                	jmp    400557 <number+0x107>
  40050b:	4c 8d 5c 24 13       	lea    0x13(%rsp),%r11
			size -= 2;
		else if (base == 8)
			size--;
	}
	i = 0;
	if (num == 0)
  400510:	41 bc 00 00 00 00    	mov    $0x0,%r12d
		tmp[i++] = '0';
	else
		while (num != 0)
			tmp[i++] = (digits[__do_div(num, base)] | locase);
  400516:	45 89 d2             	mov    %r10d,%r10d
  400519:	41 ff c4             	inc    %r12d
  40051c:	48 89 f5             	mov    %rsi,%rbp
  40051f:	48 89 f0             	mov    %rsi,%rax
  400522:	ba 00 00 00 00       	mov    $0x0,%edx
  400527:	49 f7 f2             	div    %r10
  40052a:	48 89 c3             	mov    %rax,%rbx
  40052d:	48 89 c6             	mov    %rax,%rsi
  400530:	48 89 e8             	mov    %rbp,%rax
  400533:	ba 00 00 00 00       	mov    $0x0,%edx
  400538:	49 f7 f2             	div    %r10
  40053b:	48 63 d2             	movslq %edx,%rdx
  40053e:	48 8d 05 7b 13 00 00 	lea    0x137b(%rip),%rax        # 4018c0 <digits.1229>
  400545:	44 89 ed             	mov    %r13d,%ebp
  400548:	40 0a 2c 10          	or     (%rax,%rdx,1),%bpl
  40054c:	41 88 2b             	mov    %bpl,(%r11)
  40054f:	49 ff c3             	inc    %r11
	}
	i = 0;
	if (num == 0)
		tmp[i++] = '0';
	else
		while (num != 0)
  400552:	48 85 db             	test   %rbx,%rbx
  400555:	75 c2                	jne    400519 <number+0xc9>
  400557:	45 39 c4             	cmp    %r8d,%r12d
  40055a:	45 0f 4d c4          	cmovge %r12d,%r8d
			tmp[i++] = (digits[__do_div(num, base)] | locase);
	if (i > precision)
		precision = i;
	size -= precision;
  40055e:	44 29 c1             	sub    %r8d,%ecx
	if (!(type & (ZEROPAD + LEFT)))
  400561:	41 f6 c1 11          	test   $0x11,%r9b
  400565:	75 2d                	jne    400594 <number+0x144>
		while (size-- > 0)
  400567:	8d 71 ff             	lea    -0x1(%rcx),%esi
  40056a:	85 c9                	test   %ecx,%ecx
  40056c:	7e 24                	jle    400592 <number+0x142>
  40056e:	ff c9                	dec    %ecx
  400570:	48 8d 54 0f 01       	lea    0x1(%rdi,%rcx,1),%rdx
  400575:	48 89 f8             	mov    %rdi,%rax
			*str++ = ' ';
  400578:	48 ff c0             	inc    %rax
  40057b:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
			tmp[i++] = (digits[__do_div(num, base)] | locase);
	if (i > precision)
		precision = i;
	size -= precision;
	if (!(type & (ZEROPAD + LEFT)))
		while (size-- > 0)
  40057f:	48 39 d0             	cmp    %rdx,%rax
  400582:	75 f4                	jne    400578 <number+0x128>
  400584:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  400589:	89 f6                	mov    %esi,%esi
  40058b:	48 8d 7c 37 01       	lea    0x1(%rdi,%rsi,1),%rdi
  400590:	eb 02                	jmp    400594 <number+0x144>
  400592:	89 f1                	mov    %esi,%ecx
			*str++ = ' ';
	if (sign)
  400594:	80 3c 24 00          	cmpb   $0x0,(%rsp)
  400598:	74 0a                	je     4005a4 <number+0x154>
		*str++ = sign;
  40059a:	0f b6 04 24          	movzbl (%rsp),%eax
  40059e:	88 07                	mov    %al,(%rdi)
  4005a0:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
	if (type & SPECIAL) {
  4005a4:	83 7c 24 01 00       	cmpl   $0x0,0x1(%rsp)
  4005a9:	74 24                	je     4005cf <number+0x17f>
		if (base == 8)
  4005ab:	41 83 fe 08          	cmp    $0x8,%r14d
  4005af:	75 09                	jne    4005ba <number+0x16a>
			*str++ = '0';
  4005b1:	c6 07 30             	movb   $0x30,(%rdi)
  4005b4:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
  4005b8:	eb 15                	jmp    4005cf <number+0x17f>
		else if (base == 16) {
  4005ba:	41 83 fe 10          	cmp    $0x10,%r14d
  4005be:	75 0f                	jne    4005cf <number+0x17f>
			*str++ = '0';
  4005c0:	c6 07 30             	movb   $0x30,(%rdi)
			*str++ = ('X' | locase);
  4005c3:	41 83 cd 58          	or     $0x58,%r13d
  4005c7:	44 88 6f 01          	mov    %r13b,0x1(%rdi)
  4005cb:	48 8d 7f 02          	lea    0x2(%rdi),%rdi
		}
	}
	if (!(type & LEFT))
  4005cf:	41 f6 c1 10          	test   $0x10,%r9b
  4005d3:	75 2d                	jne    400602 <number+0x1b2>
		while (size-- > 0)
  4005d5:	8d 71 ff             	lea    -0x1(%rcx),%esi
  4005d8:	85 c9                	test   %ecx,%ecx
  4005da:	7e 24                	jle    400600 <number+0x1b0>
  4005dc:	ff c9                	dec    %ecx
  4005de:	48 8d 54 0f 01       	lea    0x1(%rdi,%rcx,1),%rdx
  4005e3:	48 89 f8             	mov    %rdi,%rax
			*str++ = c;
  4005e6:	48 ff c0             	inc    %rax
  4005e9:	44 88 78 ff          	mov    %r15b,-0x1(%rax)
			*str++ = '0';
			*str++ = ('X' | locase);
		}
	}
	if (!(type & LEFT))
		while (size-- > 0)
  4005ed:	48 39 d0             	cmp    %rdx,%rax
  4005f0:	75 f4                	jne    4005e6 <number+0x196>
  4005f2:	89 f6                	mov    %esi,%esi
  4005f4:	48 8d 7c 37 01       	lea    0x1(%rdi,%rsi,1),%rdi
  4005f9:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  4005fe:	eb 02                	jmp    400602 <number+0x1b2>
  400600:	89 f1                	mov    %esi,%ecx
			*str++ = c;
	while (i < precision--)
  400602:	45 39 c4             	cmp    %r8d,%r12d
  400605:	7d 1a                	jge    400621 <number+0x1d1>
  400607:	45 29 e0             	sub    %r12d,%r8d
  40060a:	41 8d 40 ff          	lea    -0x1(%r8),%eax
  40060e:	4c 8d 44 07 01       	lea    0x1(%rdi,%rax,1),%r8
		*str++ = '0';
  400613:	48 ff c7             	inc    %rdi
  400616:	c6 47 ff 30          	movb   $0x30,-0x1(%rdi)
		}
	}
	if (!(type & LEFT))
		while (size-- > 0)
			*str++ = c;
	while (i < precision--)
  40061a:	4c 39 c7             	cmp    %r8,%rdi
  40061d:	75 f4                	jne    400613 <number+0x1c3>
  40061f:	eb 03                	jmp    400624 <number+0x1d4>
  400621:	49 89 f8             	mov    %rdi,%r8
		*str++ = '0';
	while (i-- > 0)
  400624:	41 8d 7c 24 ff       	lea    -0x1(%r12),%edi
  400629:	45 85 e4             	test   %r12d,%r12d
  40062c:	7e 21                	jle    40064f <number+0x1ff>
  40062e:	4c 89 c2             	mov    %r8,%rdx
  400631:	89 f8                	mov    %edi,%eax
		*str++ = tmp[i];
  400633:	48 63 f0             	movslq %eax,%rsi
  400636:	0f b6 74 34 13       	movzbl 0x13(%rsp,%rsi,1),%esi
  40063b:	40 88 32             	mov    %sil,(%rdx)
	if (!(type & LEFT))
		while (size-- > 0)
			*str++ = c;
	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
  40063e:	ff c8                	dec    %eax
  400640:	48 ff c2             	inc    %rdx
  400643:	83 f8 ff             	cmp    $0xffffffff,%eax
  400646:	75 eb                	jne    400633 <number+0x1e3>
  400648:	89 ff                	mov    %edi,%edi
  40064a:	4d 8d 44 38 01       	lea    0x1(%r8,%rdi,1),%r8
		*str++ = tmp[i];
	while (size-- > 0)
  40064f:	8d 71 ff             	lea    -0x1(%rcx),%esi
  400652:	85 c9                	test   %ecx,%ecx
  400654:	7e 26                	jle    40067c <number+0x22c>
  400656:	ff c9                	dec    %ecx
  400658:	49 8d 54 08 01       	lea    0x1(%r8,%rcx,1),%rdx
  40065d:	4c 89 c0             	mov    %r8,%rax
		*str++ = ' ';
  400660:	48 ff c0             	inc    %rax
  400663:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
			*str++ = c;
	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
		*str++ = tmp[i];
	while (size-- > 0)
  400667:	48 39 d0             	cmp    %rdx,%rax
  40066a:	75 f4                	jne    400660 <number+0x210>
  40066c:	89 f6                	mov    %esi,%esi
		*str++ = ' ';
  40066e:	49 8d 44 30 01       	lea    0x1(%r8,%rsi,1),%rax
  400673:	eb 0a                	jmp    40067f <number+0x22f>
	 * produces same digits or (maybe lowercased) letters */
	locase = (type & SMALL);
	if (type & LEFT)
		type &= ~ZEROPAD;
	if (base < 2 || base > 16)
		return NULL;
  400675:	b8 00 00 00 00       	mov    $0x0,%eax
  40067a:	eb 03                	jmp    40067f <number+0x22f>
			*str++ = c;
	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
		*str++ = tmp[i];
	while (size-- > 0)
  40067c:	4c 89 c0             	mov    %r8,%rax
		*str++ = ' ';
	return str;
}
  40067f:	48 83 c4 55          	add    $0x55,%rsp
  400683:	5b                   	pop    %rbx
  400684:	5d                   	pop    %rbp
  400685:	41 5c                	pop    %r12
  400687:	41 5d                	pop    %r13
  400689:	41 5e                	pop    %r14
  40068b:	41 5f                	pop    %r15
  40068d:	c3                   	retq   

000000000040068e <skip_atoi>:
n = ((unsigned long) n) / (unsigned) base; \
__res; })


static int skip_atoi(const char **s)
{
  40068e:	55                   	push   %rbp
  40068f:	53                   	push   %rbx
  400690:	48 83 ec 08          	sub    $0x8,%rsp
  400694:	48 89 fd             	mov    %rdi,%rbp
        int i = 0;
  400697:	bb 00 00 00 00       	mov    $0x0,%ebx

        while (isdigit(**s))
  40069c:	eb 1d                	jmp    4006bb <skip_atoi+0x2d>
                i = i * 10 + *((*s)++) - '0';
  40069e:	48 8b 45 00          	mov    0x0(%rbp),%rax
  4006a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  4006a6:	48 89 55 00          	mov    %rdx,0x0(%rbp)
  4006aa:	8d 14 dd 00 00 00 00 	lea    0x0(,%rbx,8),%edx
  4006b1:	8d 14 5a             	lea    (%rdx,%rbx,2),%edx
  4006b4:	0f be 00             	movsbl (%rax),%eax
  4006b7:	8d 5c 02 d0          	lea    -0x30(%rdx,%rax,1),%ebx

static int skip_atoi(const char **s)
{
        int i = 0;

        while (isdigit(**s))
  4006bb:	48 8b 45 00          	mov    0x0(%rbp),%rax
  4006bf:	0f be 38             	movsbl (%rax),%edi
  4006c2:	e8 b2 0d 00 00       	callq  401479 <isdigit>
  4006c7:	85 c0                	test   %eax,%eax
  4006c9:	75 d3                	jne    40069e <skip_atoi+0x10>
                i = i * 10 + *((*s)++) - '0';
        return i;
}
  4006cb:	89 d8                	mov    %ebx,%eax
  4006cd:	48 83 c4 08          	add    $0x8,%rsp
  4006d1:	5b                   	pop    %rbx
  4006d2:	5d                   	pop    %rbp
  4006d3:	c3                   	retq   

00000000004006d4 <vsprintf>:
	va_end(val);
	return printed;
}

int vsprintf(char *buf, const char *fmt, va_list args)
{
  4006d4:	41 57                	push   %r15
  4006d6:	41 56                	push   %r14
  4006d8:	41 55                	push   %r13
  4006da:	41 54                	push   %r12
  4006dc:	55                   	push   %rbp
  4006dd:	53                   	push   %rbx
  4006de:	48 83 ec 28          	sub    $0x28,%rsp
  4006e2:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  4006e7:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
	int field_width;	/* width of output field */
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L:' for integer fields */

	for (str = buf; *fmt; ++fmt) {
  4006ec:	0f b6 06             	movzbl (%rsi),%eax
  4006ef:	84 c0                	test   %al,%al
  4006f1:	0f 84 0d 05 00 00    	je     400c04 <vsprintf+0x530>
  4006f7:	49 89 d5             	mov    %rdx,%r13
  4006fa:	48 89 fb             	mov    %rdi,%rbx

		/* process flags */
		flags = 0;
	      repeat:
		++fmt;		/* this also skips first '%' */
		switch (*fmt) {
  4006fd:	4c 8d 25 7c 0f 00 00 	lea    0xf7c(%rip),%r12        # 401680 <atoi+0x1a3>
		/* get the precision */
		precision = -1;
		if (*fmt == '.') {
			++fmt;
			if (isdigit(*fmt))
				precision = skip_atoi(&fmt);
  400704:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
  400709:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L:' for integer fields */

	for (str = buf; *fmt; ++fmt) {
		if (*fmt != '%') {
  40070e:	bd 00 00 00 00       	mov    $0x0,%ebp
  400713:	3c 25                	cmp    $0x25,%al
  400715:	74 0b                	je     400722 <vsprintf+0x4e>
			*str++ = *fmt;
  400717:	88 03                	mov    %al,(%rbx)
  400719:	48 8d 5b 01          	lea    0x1(%rbx),%rbx
			continue;
  40071d:	e9 c6 04 00 00       	jmpq   400be8 <vsprintf+0x514>
		}

		/* process flags */
		flags = 0;
	      repeat:
		++fmt;		/* this also skips first '%' */
  400722:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  400727:	48 8d 50 01          	lea    0x1(%rax),%rdx
  40072b:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
		switch (*fmt) {
  400730:	0f b6 78 01          	movzbl 0x1(%rax),%edi
  400734:	8d 47 e0             	lea    -0x20(%rdi),%eax
  400737:	3c 10                	cmp    $0x10,%al
  400739:	77 27                	ja     400762 <vsprintf+0x8e>
  40073b:	0f b6 c0             	movzbl %al,%eax
  40073e:	49 63 04 84          	movslq (%r12,%rax,4),%rax
  400742:	4c 01 e0             	add    %r12,%rax
  400745:	ff e0                	jmpq   *%rax
		case '-':
			flags |= LEFT;
  400747:	83 cd 10             	or     $0x10,%ebp
			goto repeat;
  40074a:	eb d6                	jmp    400722 <vsprintf+0x4e>
		case '+':
			flags |= PLUS;
  40074c:	83 cd 04             	or     $0x4,%ebp
			goto repeat;
  40074f:	eb d1                	jmp    400722 <vsprintf+0x4e>
		case ' ':
			flags |= SPACE;
  400751:	83 cd 08             	or     $0x8,%ebp
			goto repeat;
  400754:	eb cc                	jmp    400722 <vsprintf+0x4e>
		case '#':
			flags |= SPECIAL;
  400756:	83 cd 40             	or     $0x40,%ebp
			goto repeat;
  400759:	eb c7                	jmp    400722 <vsprintf+0x4e>
		case '0':
			flags |= ZEROPAD;
  40075b:	83 cd 01             	or     $0x1,%ebp
  40075e:	66 90                	xchg   %ax,%ax
			goto repeat;
  400760:	eb c0                	jmp    400722 <vsprintf+0x4e>

		/* process flags */
		flags = 0;
	      repeat:
		++fmt;		/* this also skips first '%' */
		switch (*fmt) {
  400762:	41 89 ef             	mov    %ebp,%r15d
			goto repeat;
		}
	
		/* get field width */
		field_width = -1;
		if (isdigit(*fmt))
  400765:	40 0f be ff          	movsbl %dil,%edi
  400769:	e8 0b 0d 00 00       	callq  401479 <isdigit>
  40076e:	85 c0                	test   %eax,%eax
  400770:	74 0f                	je     400781 <vsprintf+0xad>
			field_width = skip_atoi(&fmt);
  400772:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  400777:	e8 12 ff ff ff       	callq  40068e <skip_atoi>
  40077c:	41 89 c6             	mov    %eax,%r14d
  40077f:	eb 4e                	jmp    4007cf <vsprintf+0xfb>
		else if (*fmt == '*') {
  400781:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
			flags |= ZEROPAD;
			goto repeat;
		}
	
		/* get field width */
		field_width = -1;
  400786:	41 be ff ff ff ff    	mov    $0xffffffff,%r14d
		if (isdigit(*fmt))
			field_width = skip_atoi(&fmt);
		else if (*fmt == '*') {
  40078c:	80 38 2a             	cmpb   $0x2a,(%rax)
  40078f:	75 3e                	jne    4007cf <vsprintf+0xfb>
			++fmt;
  400791:	48 ff c0             	inc    %rax
  400794:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
			/* it's the next argument */
			field_width = va_arg(args, int);
  400799:	41 8b 45 00          	mov    0x0(%r13),%eax
  40079d:	83 f8 30             	cmp    $0x30,%eax
  4007a0:	73 0f                	jae    4007b1 <vsprintf+0xdd>
  4007a2:	89 c2                	mov    %eax,%edx
  4007a4:	49 03 55 10          	add    0x10(%r13),%rdx
  4007a8:	83 c0 08             	add    $0x8,%eax
  4007ab:	41 89 45 00          	mov    %eax,0x0(%r13)
  4007af:	eb 0c                	jmp    4007bd <vsprintf+0xe9>
  4007b1:	49 8b 55 08          	mov    0x8(%r13),%rdx
  4007b5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  4007b9:	49 89 45 08          	mov    %rax,0x8(%r13)
  4007bd:	44 8b 32             	mov    (%rdx),%r14d
			if (field_width < 0) {
  4007c0:	45 85 f6             	test   %r14d,%r14d
  4007c3:	79 0a                	jns    4007cf <vsprintf+0xfb>
				field_width = -field_width;
  4007c5:	41 f7 de             	neg    %r14d
				flags |= LEFT;
  4007c8:	41 83 cf 10          	or     $0x10,%r15d
  4007cc:	44 89 fd             	mov    %r15d,%ebp
			}
		}

		/* get the precision */
		precision = -1;
		if (*fmt == '.') {
  4007cf:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
				flags |= LEFT;
			}
		}

		/* get the precision */
		precision = -1;
  4007d4:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
		if (*fmt == '.') {
  4007da:	80 38 2e             	cmpb   $0x2e,(%rax)
  4007dd:	75 6b                	jne    40084a <vsprintf+0x176>
			++fmt;
  4007df:	48 8d 50 01          	lea    0x1(%rax),%rdx
  4007e3:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
			if (isdigit(*fmt))
  4007e8:	0f be 78 01          	movsbl 0x1(%rax),%edi
  4007ec:	e8 88 0c 00 00       	callq  401479 <isdigit>
  4007f1:	85 c0                	test   %eax,%eax
  4007f3:	74 0c                	je     400801 <vsprintf+0x12d>
				precision = skip_atoi(&fmt);
  4007f5:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  4007fa:	e8 8f fe ff ff       	callq  40068e <skip_atoi>
  4007ff:	eb 3d                	jmp    40083e <vsprintf+0x16a>
			else if (*fmt == '*') {
  400801:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
				flags |= LEFT;
			}
		}

		/* get the precision */
		precision = -1;
  400806:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		if (*fmt == '.') {
			++fmt;
			if (isdigit(*fmt))
				precision = skip_atoi(&fmt);
			else if (*fmt == '*') {
  40080b:	80 3a 2a             	cmpb   $0x2a,(%rdx)
  40080e:	75 2e                	jne    40083e <vsprintf+0x16a>
				++fmt;
  400810:	48 ff c2             	inc    %rdx
  400813:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
				/* it's the next argument */
				precision = va_arg(args, int);
  400818:	41 8b 45 00          	mov    0x0(%r13),%eax
  40081c:	83 f8 30             	cmp    $0x30,%eax
  40081f:	73 0f                	jae    400830 <vsprintf+0x15c>
  400821:	89 c2                	mov    %eax,%edx
  400823:	49 03 55 10          	add    0x10(%r13),%rdx
  400827:	83 c0 08             	add    $0x8,%eax
  40082a:	41 89 45 00          	mov    %eax,0x0(%r13)
  40082e:	eb 0c                	jmp    40083c <vsprintf+0x168>
  400830:	49 8b 55 08          	mov    0x8(%r13),%rdx
  400834:	48 8d 42 08          	lea    0x8(%rdx),%rax
  400838:	49 89 45 08          	mov    %rax,0x8(%r13)
  40083c:	8b 02                	mov    (%rdx),%eax
  40083e:	85 c0                	test   %eax,%eax
  400840:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  400846:	44 0f 49 c0          	cmovns %eax,%r8d
				precision = 0;
		}

		/* get the conversion qualifier */
		qualifier = -1;
		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
  40084a:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  40084f:	0f b6 02             	movzbl (%rdx),%eax
  400852:	3c 68                	cmp    $0x68,%al
  400854:	74 10                	je     400866 <vsprintf+0x192>
  400856:	89 c6                	mov    %eax,%esi
  400858:	83 e6 df             	and    $0xffffffdf,%esi
			if (precision < 0)
				precision = 0;
		}

		/* get the conversion qualifier */
		qualifier = -1;
  40085b:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
  400860:	40 80 fe 4c          	cmp    $0x4c,%sil
  400864:	75 0b                	jne    400871 <vsprintf+0x19d>
			qualifier = *fmt;
  400866:	0f be c8             	movsbl %al,%ecx
			++fmt;
  400869:	48 ff c2             	inc    %rdx
  40086c:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
		}

		/* default base */
		base = 10;

		switch (*fmt) {
  400871:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  400876:	0f b6 00             	movzbl (%rax),%eax
  400879:	83 e8 25             	sub    $0x25,%eax
  40087c:	3c 53                	cmp    $0x53,%al
  40087e:	0f 87 52 02 00 00    	ja     400ad6 <vsprintf+0x402>
  400884:	0f b6 c0             	movzbl %al,%eax
  400887:	48 8d 35 36 0e 00 00 	lea    0xe36(%rip),%rsi        # 4016c4 <atoi+0x1e7>
  40088e:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
  400892:	48 01 f0             	add    %rsi,%rax
  400895:	ff e0                	jmpq   *%rax
		case 'c':
			if (!(flags & LEFT))
  400897:	40 f6 c5 10          	test   $0x10,%bpl
  40089b:	75 34                	jne    4008d1 <vsprintf+0x1fd>
				while (--field_width > 0)
  40089d:	41 8d 46 ff          	lea    -0x1(%r14),%eax
  4008a1:	85 c0                	test   %eax,%eax
  4008a3:	7e 29                	jle    4008ce <vsprintf+0x1fa>
  4008a5:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  4008a9:	48 8d 54 03 01       	lea    0x1(%rbx,%rax,1),%rdx
  4008ae:	48 89 d8             	mov    %rbx,%rax
					*str++ = ' ';
  4008b1:	48 ff c0             	inc    %rax
  4008b4:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
		base = 10;

		switch (*fmt) {
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
  4008b8:	48 39 d0             	cmp    %rdx,%rax
  4008bb:	75 f4                	jne    4008b1 <vsprintf+0x1dd>
  4008bd:	41 83 ee 02          	sub    $0x2,%r14d
  4008c1:	4a 8d 5c 33 01       	lea    0x1(%rbx,%r14,1),%rbx
  4008c6:	41 be 00 00 00 00    	mov    $0x0,%r14d
  4008cc:	eb 03                	jmp    4008d1 <vsprintf+0x1fd>
  4008ce:	41 89 c6             	mov    %eax,%r14d
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
  4008d1:	48 8d 4b 01          	lea    0x1(%rbx),%rcx
  4008d5:	41 8b 45 00          	mov    0x0(%r13),%eax
  4008d9:	83 f8 30             	cmp    $0x30,%eax
  4008dc:	73 0f                	jae    4008ed <vsprintf+0x219>
  4008de:	89 c2                	mov    %eax,%edx
  4008e0:	49 03 55 10          	add    0x10(%r13),%rdx
  4008e4:	83 c0 08             	add    $0x8,%eax
  4008e7:	41 89 45 00          	mov    %eax,0x0(%r13)
  4008eb:	eb 0c                	jmp    4008f9 <vsprintf+0x225>
  4008ed:	49 8b 55 08          	mov    0x8(%r13),%rdx
  4008f1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  4008f5:	49 89 45 08          	mov    %rax,0x8(%r13)
  4008f9:	8b 02                	mov    (%rdx),%eax
  4008fb:	88 03                	mov    %al,(%rbx)
			while (--field_width > 0)
  4008fd:	41 8d 46 ff          	lea    -0x1(%r14),%eax
  400901:	85 c0                	test   %eax,%eax
  400903:	0f 8e dc 02 00 00    	jle    400be5 <vsprintf+0x511>
  400909:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  40090d:	48 8d 54 03 02       	lea    0x2(%rbx,%rax,1),%rdx
		switch (*fmt) {
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
  400912:	48 89 c8             	mov    %rcx,%rax
			while (--field_width > 0)
				*str++ = ' ';
  400915:	48 ff c0             	inc    %rax
  400918:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
			while (--field_width > 0)
  40091c:	48 39 d0             	cmp    %rdx,%rax
  40091f:	75 f4                	jne    400915 <vsprintf+0x241>
  400921:	41 83 ee 02          	sub    $0x2,%r14d
  400925:	4a 8d 5c 31 01       	lea    0x1(%rcx,%r14,1),%rbx
  40092a:	e9 b9 02 00 00       	jmpq   400be8 <vsprintf+0x514>
				*str++ = ' ';
			continue;

		case 's':
			s = va_arg(args, char *);
  40092f:	41 8b 45 00          	mov    0x0(%r13),%eax
  400933:	83 f8 30             	cmp    $0x30,%eax
  400936:	73 0f                	jae    400947 <vsprintf+0x273>
  400938:	89 c2                	mov    %eax,%edx
  40093a:	49 03 55 10          	add    0x10(%r13),%rdx
  40093e:	83 c0 08             	add    $0x8,%eax
  400941:	41 89 45 00          	mov    %eax,0x0(%r13)
  400945:	eb 0c                	jmp    400953 <vsprintf+0x27f>
  400947:	49 8b 55 08          	mov    0x8(%r13),%rdx
  40094b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  40094f:	49 89 45 08          	mov    %rax,0x8(%r13)
  400953:	4c 8b 3a             	mov    (%rdx),%r15
			//len = strnlen(s, precision);
			len = strlen(s);
  400956:	4c 89 ff             	mov    %r15,%rdi
  400959:	e8 12 0a 00 00       	callq  401370 <strlen>
  40095e:	89 c6                	mov    %eax,%esi
			if (!(flags & LEFT))
  400960:	40 f6 c5 10          	test   $0x10,%bpl
  400964:	75 31                	jne    400997 <vsprintf+0x2c3>
				while (len < field_width--)
  400966:	41 8d 4e ff          	lea    -0x1(%r14),%ecx
  40096a:	41 39 c6             	cmp    %eax,%r14d
  40096d:	7e 25                	jle    400994 <vsprintf+0x2c0>
  40096f:	44 89 f7             	mov    %r14d,%edi
  400972:	41 89 ce             	mov    %ecx,%r14d
  400975:	41 29 c6             	sub    %eax,%r14d
  400978:	4a 8d 54 33 01       	lea    0x1(%rbx,%r14,1),%rdx
					*str++ = ' ';
  40097d:	48 ff c3             	inc    %rbx
  400980:	c6 43 ff 20          	movb   $0x20,-0x1(%rbx)
		case 's':
			s = va_arg(args, char *);
			//len = strnlen(s, precision);
			len = strlen(s);
			if (!(flags & LEFT))
				while (len < field_width--)
  400984:	48 39 d3             	cmp    %rdx,%rbx
  400987:	75 f4                	jne    40097d <vsprintf+0x2a9>
  400989:	29 f9                	sub    %edi,%ecx
  40098b:	44 8d 34 01          	lea    (%rcx,%rax,1),%r14d
					*str++ = ' ';
  40098f:	48 89 d3             	mov    %rdx,%rbx
  400992:	eb 03                	jmp    400997 <vsprintf+0x2c3>
		case 's':
			s = va_arg(args, char *);
			//len = strnlen(s, precision);
			len = strlen(s);
			if (!(flags & LEFT))
				while (len < field_width--)
  400994:	41 89 ce             	mov    %ecx,%r14d
					*str++ = ' ';
			for (i = 0; i < len; ++i)
  400997:	85 c0                	test   %eax,%eax
  400999:	7e 1c                	jle    4009b7 <vsprintf+0x2e3>
  40099b:	ba 00 00 00 00       	mov    $0x0,%edx
				*str++ = *s++;
  4009a0:	41 0f b6 0c 17       	movzbl (%r15,%rdx,1),%ecx
  4009a5:	88 0c 13             	mov    %cl,(%rbx,%rdx,1)
  4009a8:	48 ff c2             	inc    %rdx
			//len = strnlen(s, precision);
			len = strlen(s);
			if (!(flags & LEFT))
				while (len < field_width--)
					*str++ = ' ';
			for (i = 0; i < len; ++i)
  4009ab:	39 d6                	cmp    %edx,%esi
  4009ad:	7f f1                	jg     4009a0 <vsprintf+0x2cc>
  4009af:	8d 50 ff             	lea    -0x1(%rax),%edx
  4009b2:	48 8d 5c 13 01       	lea    0x1(%rbx,%rdx,1),%rbx
				*str++ = *s++;
			while (len < field_width--)
  4009b7:	41 39 c6             	cmp    %eax,%r14d
  4009ba:	0f 8e 28 02 00 00    	jle    400be8 <vsprintf+0x514>
  4009c0:	44 89 f6             	mov    %r14d,%esi
  4009c3:	89 c2                	mov    %eax,%edx
  4009c5:	f7 d2                	not    %edx
  4009c7:	41 01 d6             	add    %edx,%r14d
  4009ca:	4a 8d 4c 33 01       	lea    0x1(%rbx,%r14,1),%rcx
  4009cf:	48 89 da             	mov    %rbx,%rdx
				*str++ = ' ';
  4009d2:	48 ff c2             	inc    %rdx
  4009d5:	c6 42 ff 20          	movb   $0x20,-0x1(%rdx)
			if (!(flags & LEFT))
				while (len < field_width--)
					*str++ = ' ';
			for (i = 0; i < len; ++i)
				*str++ = *s++;
			while (len < field_width--)
  4009d9:	48 39 ca             	cmp    %rcx,%rdx
  4009dc:	75 f4                	jne    4009d2 <vsprintf+0x2fe>
  4009de:	f7 d0                	not    %eax
  4009e0:	01 f0                	add    %esi,%eax
  4009e2:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
  4009e7:	e9 fc 01 00 00       	jmpq   400be8 <vsprintf+0x514>
				*str++ = ' ';
			continue;

		case 'p':
			if (field_width == -1) {
  4009ec:	41 83 fe ff          	cmp    $0xffffffff,%r14d
  4009f0:	75 09                	jne    4009fb <vsprintf+0x327>
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
  4009f2:	83 cd 01             	or     $0x1,%ebp
				*str++ = ' ';
			continue;

		case 'p':
			if (field_width == -1) {
				field_width = 2 * sizeof(void *);
  4009f5:	41 be 10 00 00 00    	mov    $0x10,%r14d
				flags |= ZEROPAD;
			}
			str = number(str,
				     (unsigned long)va_arg(args, void *), 16,
  4009fb:	41 8b 45 00          	mov    0x0(%r13),%eax
  4009ff:	83 f8 30             	cmp    $0x30,%eax
  400a02:	73 0f                	jae    400a13 <vsprintf+0x33f>
  400a04:	89 c6                	mov    %eax,%esi
  400a06:	49 03 75 10          	add    0x10(%r13),%rsi
  400a0a:	83 c0 08             	add    $0x8,%eax
  400a0d:	41 89 45 00          	mov    %eax,0x0(%r13)
		case 'p':
			if (field_width == -1) {
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
			}
			str = number(str,
  400a11:	eb 0c                	jmp    400a1f <vsprintf+0x34b>
				     (unsigned long)va_arg(args, void *), 16,
  400a13:	49 8b 75 08          	mov    0x8(%r13),%rsi
  400a17:	48 8d 46 08          	lea    0x8(%rsi),%rax
  400a1b:	49 89 45 08          	mov    %rax,0x8(%r13)
		case 'p':
			if (field_width == -1) {
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
			}
			str = number(str,
  400a1f:	41 89 e9             	mov    %ebp,%r9d
  400a22:	44 89 f1             	mov    %r14d,%ecx
  400a25:	ba 10 00 00 00       	mov    $0x10,%edx
  400a2a:	48 8b 36             	mov    (%rsi),%rsi
  400a2d:	48 89 df             	mov    %rbx,%rdi
  400a30:	e8 1b fa ff ff       	callq  400450 <number>
  400a35:	48 89 c3             	mov    %rax,%rbx
				     (unsigned long)va_arg(args, void *), 16,
				     field_width, precision, flags);
			continue;
  400a38:	e9 ab 01 00 00       	jmpq   400be8 <vsprintf+0x514>

		case 'n':
			if (qualifier == 'l') {
  400a3d:	83 f9 6c             	cmp    $0x6c,%ecx
  400a40:	75 37                	jne    400a79 <vsprintf+0x3a5>
				long *ip = va_arg(args, long *);
  400a42:	41 8b 45 00          	mov    0x0(%r13),%eax
  400a46:	83 f8 30             	cmp    $0x30,%eax
  400a49:	73 0f                	jae    400a5a <vsprintf+0x386>
  400a4b:	89 c2                	mov    %eax,%edx
  400a4d:	49 03 55 10          	add    0x10(%r13),%rdx
  400a51:	83 c0 08             	add    $0x8,%eax
  400a54:	41 89 45 00          	mov    %eax,0x0(%r13)
  400a58:	eb 0c                	jmp    400a66 <vsprintf+0x392>
  400a5a:	49 8b 55 08          	mov    0x8(%r13),%rdx
  400a5e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  400a62:	49 89 45 08          	mov    %rax,0x8(%r13)
  400a66:	48 8b 02             	mov    (%rdx),%rax
				*ip = (str - buf);
  400a69:	48 89 da             	mov    %rbx,%rdx
  400a6c:	48 2b 54 24 08       	sub    0x8(%rsp),%rdx
  400a71:	48 89 10             	mov    %rdx,(%rax)
  400a74:	e9 6f 01 00 00       	jmpq   400be8 <vsprintf+0x514>
			} else {
				int *ip = va_arg(args, int *);
  400a79:	41 8b 45 00          	mov    0x0(%r13),%eax
  400a7d:	83 f8 30             	cmp    $0x30,%eax
  400a80:	73 0f                	jae    400a91 <vsprintf+0x3bd>
  400a82:	89 c2                	mov    %eax,%edx
  400a84:	49 03 55 10          	add    0x10(%r13),%rdx
  400a88:	83 c0 08             	add    $0x8,%eax
  400a8b:	41 89 45 00          	mov    %eax,0x0(%r13)
  400a8f:	eb 0c                	jmp    400a9d <vsprintf+0x3c9>
  400a91:	49 8b 55 08          	mov    0x8(%r13),%rdx
  400a95:	48 8d 42 08          	lea    0x8(%rdx),%rax
  400a99:	49 89 45 08          	mov    %rax,0x8(%r13)
  400a9d:	48 8b 02             	mov    (%rdx),%rax
				*ip = (str - buf);
  400aa0:	48 89 da             	mov    %rbx,%rdx
  400aa3:	48 2b 54 24 08       	sub    0x8(%rsp),%rdx
  400aa8:	89 10                	mov    %edx,(%rax)
  400aaa:	e9 39 01 00 00       	jmpq   400be8 <vsprintf+0x514>
			}
			continue;

		case '%':
			*str++ = '%';
  400aaf:	c6 03 25             	movb   $0x25,(%rbx)
  400ab2:	48 8d 5b 01          	lea    0x1(%rbx),%rbx
			continue;
  400ab6:	e9 2d 01 00 00       	jmpq   400be8 <vsprintf+0x514>

			/* integer number formats - set up the flags and "break" */
		case 'o':
			base = 8;
  400abb:	ba 08 00 00 00       	mov    $0x8,%edx
			break;
  400ac0:	eb 4b                	jmp    400b0d <vsprintf+0x439>

		case 'x':
			flags |= SMALL;
  400ac2:	83 cd 20             	or     $0x20,%ebp
		case 'X':
			base = 16;
  400ac5:	ba 10 00 00 00       	mov    $0x10,%edx
  400aca:	eb 41                	jmp    400b0d <vsprintf+0x439>
			break;

		case 'd':
		case 'i':
			flags |= SIGN;
  400acc:	83 cd 02             	or     $0x2,%ebp
			qualifier = *fmt;
			++fmt;
		}

		/* default base */
		base = 10;
  400acf:	ba 0a 00 00 00       	mov    $0xa,%edx
  400ad4:	eb 37                	jmp    400b0d <vsprintf+0x439>
			flags |= SIGN;
		case 'u':
			break;

		default:
			*str++ = '%';
  400ad6:	c6 03 25             	movb   $0x25,(%rbx)
			if (*fmt)
  400ad9:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  400ade:	0f b6 10             	movzbl (%rax),%edx
  400ae1:	84 d2                	test   %dl,%dl
  400ae3:	74 0c                	je     400af1 <vsprintf+0x41d>
				*str++ = *fmt;
  400ae5:	88 53 01             	mov    %dl,0x1(%rbx)
  400ae8:	48 8d 5b 02          	lea    0x2(%rbx),%rbx
  400aec:	e9 f7 00 00 00       	jmpq   400be8 <vsprintf+0x514>
			flags |= SIGN;
		case 'u':
			break;

		default:
			*str++ = '%';
  400af1:	48 ff c3             	inc    %rbx
			if (*fmt)
				*str++ = *fmt;
			else
				--fmt;
  400af4:	48 ff c8             	dec    %rax
  400af7:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  400afc:	e9 e7 00 00 00       	jmpq   400be8 <vsprintf+0x514>
			qualifier = *fmt;
			++fmt;
		}

		/* default base */
		base = 10;
  400b01:	ba 0a 00 00 00       	mov    $0xa,%edx
  400b06:	eb 05                	jmp    400b0d <vsprintf+0x439>
			break;

		case 'x':
			flags |= SMALL;
		case 'X':
			base = 16;
  400b08:	ba 10 00 00 00       	mov    $0x10,%edx
				*str++ = *fmt;
			else
				--fmt;
			continue;
		}
		if (qualifier == 'l')
  400b0d:	83 f9 6c             	cmp    $0x6c,%ecx
  400b10:	75 2c                	jne    400b3e <vsprintf+0x46a>
			num = va_arg(args, unsigned long);
  400b12:	41 8b 45 00          	mov    0x0(%r13),%eax
  400b16:	83 f8 30             	cmp    $0x30,%eax
  400b19:	73 0f                	jae    400b2a <vsprintf+0x456>
  400b1b:	89 c1                	mov    %eax,%ecx
  400b1d:	49 03 4d 10          	add    0x10(%r13),%rcx
  400b21:	83 c0 08             	add    $0x8,%eax
  400b24:	41 89 45 00          	mov    %eax,0x0(%r13)
  400b28:	eb 0c                	jmp    400b36 <vsprintf+0x462>
  400b2a:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  400b2e:	48 8d 41 08          	lea    0x8(%rcx),%rax
  400b32:	49 89 45 08          	mov    %rax,0x8(%r13)
  400b36:	48 8b 31             	mov    (%rcx),%rsi
  400b39:	e9 94 00 00 00       	jmpq   400bd2 <vsprintf+0x4fe>
		else if (qualifier == 'h') {
  400b3e:	83 f9 68             	cmp    $0x68,%ecx
  400b41:	75 3a                	jne    400b7d <vsprintf+0x4a9>
			num = (unsigned short)va_arg(args, int);
  400b43:	41 8b 45 00          	mov    0x0(%r13),%eax
  400b47:	83 f8 30             	cmp    $0x30,%eax
  400b4a:	73 0f                	jae    400b5b <vsprintf+0x487>
  400b4c:	89 c1                	mov    %eax,%ecx
  400b4e:	49 03 4d 10          	add    0x10(%r13),%rcx
  400b52:	83 c0 08             	add    $0x8,%eax
  400b55:	41 89 45 00          	mov    %eax,0x0(%r13)
  400b59:	eb 0c                	jmp    400b67 <vsprintf+0x493>
  400b5b:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  400b5f:	48 8d 41 08          	lea    0x8(%rcx),%rax
  400b63:	49 89 45 08          	mov    %rax,0x8(%r13)
  400b67:	8b 01                	mov    (%rcx),%eax
  400b69:	0f b7 c8             	movzwl %ax,%ecx
  400b6c:	48 0f bf c0          	movswq %ax,%rax
  400b70:	40 f6 c5 02          	test   $0x2,%bpl
  400b74:	48 0f 45 c8          	cmovne %rax,%rcx
  400b78:	48 89 ce             	mov    %rcx,%rsi
  400b7b:	eb 55                	jmp    400bd2 <vsprintf+0x4fe>
			if (flags & SIGN)
				num = (short)num;
		} else if (flags & SIGN)
  400b7d:	40 f6 c5 02          	test   $0x2,%bpl
  400b81:	74 29                	je     400bac <vsprintf+0x4d8>
			num = va_arg(args, int);
  400b83:	41 8b 45 00          	mov    0x0(%r13),%eax
  400b87:	83 f8 30             	cmp    $0x30,%eax
  400b8a:	73 0f                	jae    400b9b <vsprintf+0x4c7>
  400b8c:	89 c1                	mov    %eax,%ecx
  400b8e:	49 03 4d 10          	add    0x10(%r13),%rcx
  400b92:	83 c0 08             	add    $0x8,%eax
  400b95:	41 89 45 00          	mov    %eax,0x0(%r13)
  400b99:	eb 0c                	jmp    400ba7 <vsprintf+0x4d3>
  400b9b:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  400b9f:	48 8d 41 08          	lea    0x8(%rcx),%rax
  400ba3:	49 89 45 08          	mov    %rax,0x8(%r13)
  400ba7:	48 63 31             	movslq (%rcx),%rsi
  400baa:	eb 26                	jmp    400bd2 <vsprintf+0x4fe>
		else
			num = va_arg(args, unsigned int);
  400bac:	41 8b 45 00          	mov    0x0(%r13),%eax
  400bb0:	83 f8 30             	cmp    $0x30,%eax
  400bb3:	73 0f                	jae    400bc4 <vsprintf+0x4f0>
  400bb5:	89 c1                	mov    %eax,%ecx
  400bb7:	49 03 4d 10          	add    0x10(%r13),%rcx
  400bbb:	83 c0 08             	add    $0x8,%eax
  400bbe:	41 89 45 00          	mov    %eax,0x0(%r13)
  400bc2:	eb 0c                	jmp    400bd0 <vsprintf+0x4fc>
  400bc4:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  400bc8:	48 8d 41 08          	lea    0x8(%rcx),%rax
  400bcc:	49 89 45 08          	mov    %rax,0x8(%r13)
  400bd0:	8b 31                	mov    (%rcx),%esi
		str = number(str, num, base, field_width, precision, flags);
  400bd2:	41 89 e9             	mov    %ebp,%r9d
  400bd5:	44 89 f1             	mov    %r14d,%ecx
  400bd8:	48 89 df             	mov    %rbx,%rdi
  400bdb:	e8 70 f8 ff ff       	callq  400450 <number>
  400be0:	48 89 c3             	mov    %rax,%rbx
  400be3:	eb 03                	jmp    400be8 <vsprintf+0x514>
		switch (*fmt) {
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
  400be5:	48 89 cb             	mov    %rcx,%rbx
	int field_width;	/* width of output field */
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L:' for integer fields */

	for (str = buf; *fmt; ++fmt) {
  400be8:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  400bed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  400bf1:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  400bf6:	0f b6 40 01          	movzbl 0x1(%rax),%eax
  400bfa:	84 c0                	test   %al,%al
  400bfc:	0f 85 0c fb ff ff    	jne    40070e <vsprintf+0x3a>
  400c02:	eb 05                	jmp    400c09 <vsprintf+0x535>
  400c04:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
			num = va_arg(args, int);
		else
			num = va_arg(args, unsigned int);
		str = number(str, num, base, field_width, precision, flags);
	}
	*str = '\0';
  400c09:	c6 03 00             	movb   $0x0,(%rbx)
	return str - buf;
  400c0c:	48 89 d8             	mov    %rbx,%rax
  400c0f:	48 2b 44 24 08       	sub    0x8(%rsp),%rax
}
  400c14:	48 83 c4 28          	add    $0x28,%rsp
  400c18:	5b                   	pop    %rbx
  400c19:	5d                   	pop    %rbp
  400c1a:	41 5c                	pop    %r12
  400c1c:	41 5d                	pop    %r13
  400c1e:	41 5e                	pop    %r14
  400c20:	41 5f                	pop    %r15
  400c22:	c3                   	retq   

0000000000400c23 <printf>:
	return str;
}

//static char printf_buf[1024];

int printf(const char *format, ...) {
  400c23:	55                   	push   %rbp
  400c24:	53                   	push   %rbx
  400c25:	48 81 ec 58 04 00 00 	sub    $0x458,%rsp
  400c2c:	48 89 b4 24 28 04 00 	mov    %rsi,0x428(%rsp)
  400c33:	00 
  400c34:	48 89 94 24 30 04 00 	mov    %rdx,0x430(%rsp)
  400c3b:	00 
  400c3c:	48 89 8c 24 38 04 00 	mov    %rcx,0x438(%rsp)
  400c43:	00 
  400c44:	4c 89 84 24 40 04 00 	mov    %r8,0x440(%rsp)
  400c4b:	00 
  400c4c:	4c 89 8c 24 48 04 00 	mov    %r9,0x448(%rsp)
  400c53:	00 
  400c54:	48 89 fe             	mov    %rdi,%rsi
	va_list val;
	int printed = 0;
	char printf_buf[1024];
	//reset(printf_buf,1024);
	va_start(val, format);
  400c57:	c7 84 24 08 04 00 00 	movl   $0x8,0x408(%rsp)
  400c5e:	08 00 00 00 
  400c62:	48 8d 84 24 70 04 00 	lea    0x470(%rsp),%rax
  400c69:	00 
  400c6a:	48 89 84 24 10 04 00 	mov    %rax,0x410(%rsp)
  400c71:	00 
  400c72:	48 8d 84 24 20 04 00 	lea    0x420(%rsp),%rax
  400c79:	00 
  400c7a:	48 89 84 24 18 04 00 	mov    %rax,0x418(%rsp)
  400c81:	00 
	printed = vsprintf(printf_buf, format, val);
  400c82:	48 8d 94 24 08 04 00 	lea    0x408(%rsp),%rdx
  400c89:	00 
  400c8a:	48 8d 6c 24 08       	lea    0x8(%rsp),%rbp
  400c8f:	48 89 ef             	mov    %rbp,%rdi
  400c92:	e8 3d fa ff ff       	callq  4006d4 <vsprintf>
  400c97:	89 c3                	mov    %eax,%ebx
	write(1, printf_buf, printed);
  400c99:	48 63 d0             	movslq %eax,%rdx
  400c9c:	48 89 ee             	mov    %rbp,%rsi
  400c9f:	bf 01 00 00 00       	mov    $0x1,%edi
  400ca4:	e8 18 04 00 00       	callq  4010c1 <write>
	//write(1, format, printed);
	
	va_end(val);
	return printed;
}
  400ca9:	89 d8                	mov    %ebx,%eax
  400cab:	48 81 c4 58 04 00 00 	add    $0x458,%rsp
  400cb2:	5b                   	pop    %rbx
  400cb3:	5d                   	pop    %rbp
  400cb4:	c3                   	retq   

0000000000400cb5 <serror>:
	}
	*str = '\0';
	return str - buf;
}

void serror(int error){
  400cb5:	48 83 ec 08          	sub    $0x8,%rsp
    switch(error){
  400cb9:	83 ff 28             	cmp    $0x28,%edi
  400cbc:	0f 87 10 02 00 00    	ja     400ed2 <serror+0x21d>
  400cc2:	89 ff                	mov    %edi,%edi
  400cc4:	48 8d 05 49 0b 00 00 	lea    0xb49(%rip),%rax        # 401814 <atoi+0x337>
  400ccb:	48 63 14 b8          	movslq (%rax,%rdi,4),%rdx
  400ccf:	48 01 d0             	add    %rdx,%rax
  400cd2:	ff e0                	jmpq   *%rax
		case EPERM:	 
				printf("operation is not permitted \n");
  400cd4:	48 8d 3d f5 0b 00 00 	lea    0xbf5(%rip),%rdi        # 4018d0 <digits.1229+0x10>
  400cdb:	b8 00 00 00 00       	mov    $0x0,%eax
  400ce0:	e8 3e ff ff ff       	callq  400c23 <printf>
				break;
  400ce5:	e9 f9 01 00 00       	jmpq   400ee3 <serror+0x22e>
        case ENOENT : 
				printf("No Such File or directory\n"); 
  400cea:	48 8d 3d fc 0b 00 00 	lea    0xbfc(%rip),%rdi        # 4018ed <digits.1229+0x2d>
  400cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  400cf6:	e8 28 ff ff ff       	callq  400c23 <printf>
				break;
  400cfb:	e9 e3 01 00 00       	jmpq   400ee3 <serror+0x22e>
		case EINTR	:
				printf("Interrupted system call \n");
  400d00:	48 8d 3d 01 0c 00 00 	lea    0xc01(%rip),%rdi        # 401908 <digits.1229+0x48>
  400d07:	b8 00 00 00 00       	mov    $0x0,%eax
  400d0c:	e8 12 ff ff ff       	callq  400c23 <printf>
				break;
  400d11:	e9 cd 01 00 00       	jmpq   400ee3 <serror+0x22e>
		case EIO : 
				printf("Input outpur error \n"); 
  400d16:	48 8d 3d 05 0c 00 00 	lea    0xc05(%rip),%rdi        # 401922 <digits.1229+0x62>
  400d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  400d22:	e8 fc fe ff ff       	callq  400c23 <printf>
				break;
  400d27:	e9 b7 01 00 00       	jmpq   400ee3 <serror+0x22e>
		case E2BIG : 
				printf("Argument list too long \n"); 
  400d2c:	48 8d 3d 04 0c 00 00 	lea    0xc04(%rip),%rdi        # 401937 <digits.1229+0x77>
  400d33:	b8 00 00 00 00       	mov    $0x0,%eax
  400d38:	e8 e6 fe ff ff       	callq  400c23 <printf>
				break;	
  400d3d:	e9 a1 01 00 00       	jmpq   400ee3 <serror+0x22e>
		case ENOEXEC : 
				printf("Exec format error \n"); 
  400d42:	48 8d 3d 07 0c 00 00 	lea    0xc07(%rip),%rdi        # 401950 <digits.1229+0x90>
  400d49:	b8 00 00 00 00       	mov    $0x0,%eax
  400d4e:	e8 d0 fe ff ff       	callq  400c23 <printf>
				break;	
  400d53:	e9 8b 01 00 00       	jmpq   400ee3 <serror+0x22e>
		case EBADF 	 : 
				printf("Bad File number \n"); 
  400d58:	48 8d 3d 05 0c 00 00 	lea    0xc05(%rip),%rdi        # 401964 <digits.1229+0xa4>
  400d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  400d64:	e8 ba fe ff ff       	callq  400c23 <printf>
				break;
  400d69:	e9 75 01 00 00       	jmpq   400ee3 <serror+0x22e>
		case ECHILD : 
				printf("No child process \n"); 
  400d6e:	48 8d 3d 01 0c 00 00 	lea    0xc01(%rip),%rdi        # 401976 <digits.1229+0xb6>
  400d75:	b8 00 00 00 00       	mov    $0x0,%eax
  400d7a:	e8 a4 fe ff ff       	callq  400c23 <printf>
				break;
  400d7f:	e9 5f 01 00 00       	jmpq   400ee3 <serror+0x22e>
		case EAGAIN:
				printf("error: try again \n");
  400d84:	48 8d 3d fe 0b 00 00 	lea    0xbfe(%rip),%rdi        # 401989 <digits.1229+0xc9>
  400d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  400d90:	e8 8e fe ff ff       	callq  400c23 <printf>
				break;
  400d95:	e9 49 01 00 00       	jmpq   400ee3 <serror+0x22e>
        case ENOMEM : 
				printf("Out of memory\n");
  400d9a:	48 8d 3d fb 0b 00 00 	lea    0xbfb(%rip),%rdi        # 40199c <digits.1229+0xdc>
  400da1:	b8 00 00 00 00       	mov    $0x0,%eax
  400da6:	e8 78 fe ff ff       	callq  400c23 <printf>
				break;
  400dab:	e9 33 01 00 00       	jmpq   400ee3 <serror+0x22e>
        case EACCES : 
				printf("Permission denied\n"); 
  400db0:	48 8d 3d f4 0b 00 00 	lea    0xbf4(%rip),%rdi        # 4019ab <digits.1229+0xeb>
  400db7:	b8 00 00 00 00       	mov    $0x0,%eax
  400dbc:	e8 62 fe ff ff       	callq  400c23 <printf>
				break;
  400dc1:	e9 1d 01 00 00       	jmpq   400ee3 <serror+0x22e>
		case EFAULT : 
				printf("Bad address \n"); 
  400dc6:	48 8d 3d f1 0b 00 00 	lea    0xbf1(%rip),%rdi        # 4019be <digits.1229+0xfe>
  400dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  400dd2:	e8 4c fe ff ff       	callq  400c23 <printf>
				break;	
  400dd7:	e9 07 01 00 00       	jmpq   400ee3 <serror+0x22e>
		case EBUSY	:
				printf("Device or resource busy \n");
  400ddc:	48 8d 3d e9 0b 00 00 	lea    0xbe9(%rip),%rdi        # 4019cc <digits.1229+0x10c>
  400de3:	b8 00 00 00 00       	mov    $0x0,%eax
  400de8:	e8 36 fe ff ff       	callq  400c23 <printf>
				break;
  400ded:	e9 f1 00 00 00       	jmpq   400ee3 <serror+0x22e>
		case EEXIST : 
				printf("File exists \n"); 
  400df2:	48 8d 3d ed 0b 00 00 	lea    0xbed(%rip),%rdi        # 4019e6 <digits.1229+0x126>
  400df9:	b8 00 00 00 00       	mov    $0x0,%eax
  400dfe:	e8 20 fe ff ff       	callq  400c23 <printf>
				break;	
  400e03:	e9 db 00 00 00       	jmpq   400ee3 <serror+0x22e>
		case ENOTDIR : 
				printf("Not a directory \n"); 
  400e08:	48 8d 3d e5 0b 00 00 	lea    0xbe5(%rip),%rdi        # 4019f4 <digits.1229+0x134>
  400e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  400e14:	e8 0a fe ff ff       	callq  400c23 <printf>
				break;	
  400e19:	e9 c5 00 00 00       	jmpq   400ee3 <serror+0x22e>
		case EISDIR : 
				printf("is a directory \n"); 
  400e1e:	48 8d 3d e1 0b 00 00 	lea    0xbe1(%rip),%rdi        # 401a06 <digits.1229+0x146>
  400e25:	b8 00 00 00 00       	mov    $0x0,%eax
  400e2a:	e8 f4 fd ff ff       	callq  400c23 <printf>
				break;	
  400e2f:	e9 af 00 00 00       	jmpq   400ee3 <serror+0x22e>
		case EINVAL : 
				printf("Invalid Argument \n"); 
  400e34:	48 8d 3d dc 0b 00 00 	lea    0xbdc(%rip),%rdi        # 401a17 <digits.1229+0x157>
  400e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  400e40:	e8 de fd ff ff       	callq  400c23 <printf>
				break;
  400e45:	e9 99 00 00 00       	jmpq   400ee3 <serror+0x22e>
		case ENFILE	:
				printf("File table overflow \n");
  400e4a:	48 8d 3d d9 0b 00 00 	lea    0xbd9(%rip),%rdi        # 401a2a <digits.1229+0x16a>
  400e51:	b8 00 00 00 00       	mov    $0x0,%eax
  400e56:	e8 c8 fd ff ff       	callq  400c23 <printf>
				break;
  400e5b:	e9 83 00 00 00       	jmpq   400ee3 <serror+0x22e>
		case EMFILE :
				printf("Too many open files \n");
  400e60:	48 8d 3d d9 0b 00 00 	lea    0xbd9(%rip),%rdi        # 401a40 <digits.1229+0x180>
  400e67:	b8 00 00 00 00       	mov    $0x0,%eax
  400e6c:	e8 b2 fd ff ff       	callq  400c23 <printf>
				break;
  400e71:	eb 70                	jmp    400ee3 <serror+0x22e>
		case EFBIG : 
				printf("File too large \n"); 
  400e73:	48 8d 3d dc 0b 00 00 	lea    0xbdc(%rip),%rdi        # 401a56 <digits.1229+0x196>
  400e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  400e7f:	e8 9f fd ff ff       	callq  400c23 <printf>
				break;
  400e84:	eb 5d                	jmp    400ee3 <serror+0x22e>
        case EROFS : 
				printf("Read-only file system\n"); 
  400e86:	48 8d 3d da 0b 00 00 	lea    0xbda(%rip),%rdi        # 401a67 <digits.1229+0x1a7>
  400e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  400e92:	e8 8c fd ff ff       	callq  400c23 <printf>
				break;
  400e97:	eb 4a                	jmp    400ee3 <serror+0x22e>
		case ELOOP:
				printf("Too many symbolic links encountered \n");
  400e99:	48 8d 3d 08 0c 00 00 	lea    0xc08(%rip),%rdi        # 401aa8 <digits.1229+0x1e8>
  400ea0:	b8 00 00 00 00       	mov    $0x0,%eax
  400ea5:	e8 79 fd ff ff       	callq  400c23 <printf>
				break;
  400eaa:	eb 37                	jmp    400ee3 <serror+0x22e>
		case EPIPE: 
				printf("Broken pipe \n"); 
  400eac:	48 8d 3d cb 0b 00 00 	lea    0xbcb(%rip),%rdi        # 401a7e <digits.1229+0x1be>
  400eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  400eb8:	e8 66 fd ff ff       	callq  400c23 <printf>
				break;
  400ebd:	eb 24                	jmp    400ee3 <serror+0x22e>
		case ENAMETOOLONG : 
				printf("File name too long \n"); 
  400ebf:	48 8d 3d c6 0b 00 00 	lea    0xbc6(%rip),%rdi        # 401a8c <digits.1229+0x1cc>
  400ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  400ecb:	e8 53 fd ff ff       	callq  400c23 <printf>
				break;	
  400ed0:	eb 11                	jmp    400ee3 <serror+0x22e>
        default : 
			printf("Error in Opening or Executing\n");
  400ed2:	48 8d 3d f7 0b 00 00 	lea    0xbf7(%rip),%rdi        # 401ad0 <digits.1229+0x210>
  400ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  400ede:	e8 40 fd ff ff       	callq  400c23 <printf>
		
    }
  400ee3:	48 83 c4 08          	add    $0x8,%rsp
  400ee7:	c3                   	retq   

0000000000400ee8 <exit>:
#include <error.h>

//static void *breakPtr;
__thread int errno;
/*working*/
void exit(int status){
  400ee8:	53                   	push   %rbx
    syscall_1(SYS_exit, status);
  400ee9:	48 63 df             	movslq %edi,%rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  400eec:	b8 3c 00 00 00       	mov    $0x3c,%eax
  400ef1:	48 89 c0             	mov    %rax,%rax
  400ef4:	48 89 df             	mov    %rbx,%rdi
  400ef7:	cd 80                	int    $0x80
  400ef9:	48 89 c0             	mov    %rax,%rax
}
  400efc:	5b                   	pop    %rbx
  400efd:	c3                   	retq   

0000000000400efe <brk>:
/*working*/
uint64_t brk(void *end_data_segment){
  400efe:	53                   	push   %rbx
  400eff:	b8 0c 00 00 00       	mov    $0xc,%eax
  400f04:	48 89 fb             	mov    %rdi,%rbx
  400f07:	48 89 c0             	mov    %rax,%rax
  400f0a:	48 89 df             	mov    %rbx,%rdi
  400f0d:	cd 80                	int    $0x80
  400f0f:	48 89 c0             	mov    %rax,%rax
    return syscall_1(SYS_brk, (uint64_t)end_data_segment);
}
  400f12:	5b                   	pop    %rbx
  400f13:	c3                   	retq   

0000000000400f14 <sbrk>:

/*working*/
/*working*/
void *sbrk(size_t increment){
  400f14:	55                   	push   %rbp
  400f15:	53                   	push   %rbx
  400f16:	48 83 ec 08          	sub    $0x8,%rsp
  400f1a:	48 89 fd             	mov    %rdi,%rbp
	void *breakPtr;
	//if(breakPtr == NULL)
	//printf("size %p \n", increment);
	breakPtr = (void *)((uint64_t)brk(0));
  400f1d:	bf 00 00 00 00       	mov    $0x0,%edi
  400f22:	e8 d7 ff ff ff       	callq  400efe <brk>
  400f27:	48 89 c3             	mov    %rax,%rbx
	if(increment == 0)
  400f2a:	48 85 ed             	test   %rbp,%rbp
  400f2d:	74 09                	je     400f38 <sbrk+0x24>
	{
		return breakPtr;
	}
	void *startAddr = breakPtr;
	breakPtr = breakPtr+increment;
  400f2f:	48 8d 3c 28          	lea    (%rax,%rbp,1),%rdi
	brk(breakPtr);
  400f33:	e8 c6 ff ff ff       	callq  400efe <brk>
    return startAddr;
}
  400f38:	48 89 d8             	mov    %rbx,%rax
  400f3b:	48 83 c4 08          	add    $0x8,%rsp
  400f3f:	5b                   	pop    %rbx
  400f40:	5d                   	pop    %rbp
  400f41:	c3                   	retq   

0000000000400f42 <fork>:

//#define T_SYSCALL               0x80       /* System call */

static __inline uint64_t syscall_0(uint64_t n) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  400f42:	ba 39 00 00 00       	mov    $0x39,%edx
  400f47:	48 89 d0             	mov    %rdx,%rax
  400f4a:	cd 80                	int    $0x80
  400f4c:	48 89 c2             	mov    %rax,%rdx
	if((int)res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
  400f4f:	89 d0                	mov    %edx,%eax
}

/*working*/
pid_t fork(){
    uint32_t res = syscall_0(SYS_fork);
	if((int)res < 0)
  400f51:	85 d2                	test   %edx,%edx
  400f53:	79 10                	jns    400f65 <fork+0x23>
	{
		errno = -res;
  400f55:	f7 da                	neg    %edx
  400f57:	48 8b 05 9a 14 20 00 	mov    0x20149a(%rip),%rax        # 6023f8 <digits.1229+0x200b38>
  400f5e:	89 10                	mov    %edx,(%rax)
		return -1;
  400f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400f65:	f3 c3                	repz retq 

0000000000400f67 <getpid>:
  400f67:	b8 27 00 00 00       	mov    $0x27,%eax
  400f6c:	48 89 c0             	mov    %rax,%rax
  400f6f:	cd 80                	int    $0x80
  400f71:	48 89 c0             	mov    %rax,%rax

/*this method doesnt throw error always successful*/
pid_t getpid(){
    uint32_t res = syscall_0(SYS_getpid);
    return res;
}
  400f74:	c3                   	retq   

0000000000400f75 <getppid>:
  400f75:	b8 6e 00 00 00       	mov    $0x6e,%eax
  400f7a:	48 89 c0             	mov    %rax,%rax
  400f7d:	cd 80                	int    $0x80
  400f7f:	48 89 c0             	mov    %rax,%rax
/*working*/
pid_t getppid(){
    uint32_t res = syscall_0(SYS_getppid);
    return res;
}
  400f82:	c3                   	retq   

0000000000400f83 <execve>:
/*wrokig*/
int execve(const char *filename, char *const argv[], char *const envp[]){
  400f83:	53                   	push   %rbx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  400f84:	b8 3b 00 00 00       	mov    $0x3b,%eax
  400f89:	48 89 fb             	mov    %rdi,%rbx
  400f8c:	48 89 f1             	mov    %rsi,%rcx
  400f8f:	48 89 c0             	mov    %rax,%rax
  400f92:	48 89 df             	mov    %rbx,%rdi
  400f95:	48 89 ce             	mov    %rcx,%rsi
  400f98:	48 89 d2             	mov    %rdx,%rdx
  400f9b:	cd 80                	int    $0x80
  400f9d:	48 89 c0             	mov    %rax,%rax
  400fa0:	48 89 c2             	mov    %rax,%rdx
    uint64_t res = syscall_3(SYS_execve, (uint64_t)filename, (uint64_t)argv, (uint64_t)envp);
	if((int)res < 0)
  400fa3:	85 d2                	test   %edx,%edx
  400fa5:	79 10                	jns    400fb7 <execve+0x34>
	{
		errno = -res;
  400fa7:	f7 da                	neg    %edx
  400fa9:	48 8b 05 48 14 20 00 	mov    0x201448(%rip),%rax        # 6023f8 <digits.1229+0x200b38>
  400fb0:	89 10                	mov    %edx,(%rax)
		return -1;
  400fb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400fb7:	5b                   	pop    %rbx
  400fb8:	c3                   	retq   

0000000000400fb9 <sleep>:

unsigned int sleep(unsigned int seconds){
  400fb9:	53                   	push   %rbx
    unsigned int res = syscall_1(SYS_nanosleep, seconds);
  400fba:	89 fb                	mov    %edi,%ebx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  400fbc:	b8 23 00 00 00       	mov    $0x23,%eax
  400fc1:	48 89 c0             	mov    %rax,%rax
  400fc4:	48 89 df             	mov    %rbx,%rdi
  400fc7:	cd 80                	int    $0x80
  400fc9:	48 89 c0             	mov    %rax,%rax
    return res;
}
  400fcc:	5b                   	pop    %rbx
  400fcd:	c3                   	retq   

0000000000400fce <alarm>:

unsigned int alarm(unsigned int seconds){
  400fce:	53                   	push   %rbx
    unsigned int res = syscall_1(SYS_alarm, seconds);
  400fcf:	89 fb                	mov    %edi,%ebx
  400fd1:	b8 25 00 00 00       	mov    $0x25,%eax
  400fd6:	48 89 c0             	mov    %rax,%rax
  400fd9:	48 89 df             	mov    %rbx,%rdi
  400fdc:	cd 80                	int    $0x80
  400fde:	48 89 c0             	mov    %rax,%rax
    return res;
}
  400fe1:	5b                   	pop    %rbx
  400fe2:	c3                   	retq   

0000000000400fe3 <getcwd>:
/*working*/
char *getcwd(char *buf, size_t size){
  400fe3:	53                   	push   %rbx
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  400fe4:	b8 4f 00 00 00       	mov    $0x4f,%eax
  400fe9:	48 89 fb             	mov    %rdi,%rbx
  400fec:	48 89 f1             	mov    %rsi,%rcx
  400fef:	48 89 c0             	mov    %rax,%rax
  400ff2:	48 89 df             	mov    %rbx,%rdi
  400ff5:	48 89 ce             	mov    %rcx,%rsi
  400ff8:	cd 80                	int    $0x80
  400ffa:	48 89 c0             	mov    %rax,%rax
    uint64_t res = syscall_2(SYS_getcwd, (uint64_t) buf, (uint64_t) size);
	if((char *)res == NULL)
  400ffd:	48 85 c0             	test   %rax,%rax
  401000:	75 0d                	jne    40100f <getcwd+0x2c>
	{
		errno = EFAULT;
  401002:	48 8b 15 ef 13 20 00 	mov    0x2013ef(%rip),%rdx        # 6023f8 <digits.1229+0x200b38>
  401009:	c7 02 0e 00 00 00    	movl   $0xe,(%rdx)
	}
    return (char *)res;
}
  40100f:	5b                   	pop    %rbx
  401010:	c3                   	retq   

0000000000401011 <chdir>:
/*working*/ 
int chdir(const char *path){
  401011:	53                   	push   %rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  401012:	b8 50 00 00 00       	mov    $0x50,%eax
  401017:	48 89 fb             	mov    %rdi,%rbx
  40101a:	48 89 c0             	mov    %rax,%rax
  40101d:	48 89 df             	mov    %rbx,%rdi
  401020:	cd 80                	int    $0x80
  401022:	48 89 c0             	mov    %rax,%rax
    int res = syscall_1(SYS_chdir, (uint64_t)path);
	if(res < 0)
  401025:	85 c0                	test   %eax,%eax
  401027:	79 10                	jns    401039 <chdir+0x28>
	{
		errno = -res;
  401029:	f7 d8                	neg    %eax
  40102b:	48 8b 15 c6 13 20 00 	mov    0x2013c6(%rip),%rdx        # 6023f8 <digits.1229+0x200b38>
  401032:	89 02                	mov    %eax,(%rdx)
		return -1;
  401034:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  401039:	5b                   	pop    %rbx
  40103a:	c3                   	retq   

000000000040103b <open>:
/*working*/    
int open(const char *pathname, int flags){
  40103b:	53                   	push   %rbx
    uint64_t res = syscall_2(SYS_open, (uint64_t) pathname, (uint64_t) flags);
  40103c:	48 63 ce             	movslq %esi,%rcx
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  40103f:	b8 02 00 00 00       	mov    $0x2,%eax
  401044:	48 89 fb             	mov    %rdi,%rbx
  401047:	48 89 c0             	mov    %rax,%rax
  40104a:	48 89 df             	mov    %rbx,%rdi
  40104d:	48 89 ce             	mov    %rcx,%rsi
  401050:	cd 80                	int    $0x80
  401052:	48 89 c0             	mov    %rax,%rax
  401055:	48 89 c1             	mov    %rax,%rcx
	if((int)res < 0)
  401058:	85 c9                	test   %ecx,%ecx
  40105a:	79 10                	jns    40106c <open+0x31>
	{
		errno = -res;
  40105c:	f7 d9                	neg    %ecx
  40105e:	48 8b 05 93 13 20 00 	mov    0x201393(%rip),%rax        # 6023f8 <digits.1229+0x200b38>
  401065:	89 08                	mov    %ecx,(%rax)
		return -1;
  401067:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  40106c:	5b                   	pop    %rbx
  40106d:	c3                   	retq   

000000000040106e <read>:

/*working*/
ssize_t read(int fd, void *buf, size_t count){
  40106e:	41 54                	push   %r12
  401070:	55                   	push   %rbp
  401071:	53                   	push   %rbx
  401072:	89 fb                	mov    %edi,%ebx
  401074:	48 89 f5             	mov    %rsi,%rbp
  401077:	49 89 d4             	mov    %rdx,%r12
	memset(buf, 0, count);
  40107a:	be 00 00 00 00       	mov    $0x0,%esi
  40107f:	48 89 ef             	mov    %rbp,%rdi
  401082:	e8 6d 02 00 00       	callq  4012f4 <memset>
    ssize_t res = syscall_3(SYS_read, (uint64_t) fd, (uint64_t) buf, (uint64_t) count);
  401087:	48 63 db             	movslq %ebx,%rbx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  40108a:	b8 00 00 00 00       	mov    $0x0,%eax
  40108f:	48 89 e9             	mov    %rbp,%rcx
  401092:	4c 89 e2             	mov    %r12,%rdx
  401095:	48 89 c0             	mov    %rax,%rax
  401098:	48 89 df             	mov    %rbx,%rdi
  40109b:	48 89 ce             	mov    %rcx,%rsi
  40109e:	48 89 d2             	mov    %rdx,%rdx
  4010a1:	cd 80                	int    $0x80
  4010a3:	48 89 c0             	mov    %rax,%rax
	if((int)res < 0)
  4010a6:	85 c0                	test   %eax,%eax
  4010a8:	79 12                	jns    4010bc <read+0x4e>
	{
		errno = -res;
  4010aa:	f7 d8                	neg    %eax
  4010ac:	48 8b 15 45 13 20 00 	mov    0x201345(%rip),%rdx        # 6023f8 <digits.1229+0x200b38>
  4010b3:	89 02                	mov    %eax,(%rdx)
		return -1;
  4010b5:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
	}
    return res;
}
  4010bc:	5b                   	pop    %rbx
  4010bd:	5d                   	pop    %rbp
  4010be:	41 5c                	pop    %r12
  4010c0:	c3                   	retq   

00000000004010c1 <write>:

/*working*/
ssize_t write(int fd, const void *buf, size_t count){
  4010c1:	53                   	push   %rbx
    ssize_t res = syscall_3(SYS_write, (uint64_t) fd, (uint64_t) buf, (uint64_t) count);
  4010c2:	48 63 df             	movslq %edi,%rbx
  4010c5:	b8 01 00 00 00       	mov    $0x1,%eax
  4010ca:	48 89 f1             	mov    %rsi,%rcx
  4010cd:	48 89 c0             	mov    %rax,%rax
  4010d0:	48 89 df             	mov    %rbx,%rdi
  4010d3:	48 89 ce             	mov    %rcx,%rsi
  4010d6:	48 89 d2             	mov    %rdx,%rdx
  4010d9:	cd 80                	int    $0x80
  4010db:	48 89 c0             	mov    %rax,%rax
	if((int)res < 0)
  4010de:	85 c0                	test   %eax,%eax
  4010e0:	79 12                	jns    4010f4 <write+0x33>
	{
		errno = -res;
  4010e2:	f7 d8                	neg    %eax
  4010e4:	48 8b 15 0d 13 20 00 	mov    0x20130d(%rip),%rdx        # 6023f8 <digits.1229+0x200b38>
  4010eb:	89 02                	mov    %eax,(%rdx)
		return -1;
  4010ed:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
	}
    return res; 
}
  4010f4:	5b                   	pop    %rbx
  4010f5:	c3                   	retq   

00000000004010f6 <lseek>:

off_t lseek(int fildes, off_t offset, int whence){
  4010f6:	53                   	push   %rbx
    off_t res = syscall_3(SYS_lseek, (uint64_t) fildes, (uint64_t) offset, (uint64_t) whence);
  4010f7:	48 63 df             	movslq %edi,%rbx
  4010fa:	48 63 d2             	movslq %edx,%rdx
  4010fd:	b8 08 00 00 00       	mov    $0x8,%eax
  401102:	48 89 f1             	mov    %rsi,%rcx
  401105:	48 89 c0             	mov    %rax,%rax
  401108:	48 89 df             	mov    %rbx,%rdi
  40110b:	48 89 ce             	mov    %rcx,%rsi
  40110e:	48 89 d2             	mov    %rdx,%rdx
  401111:	cd 80                	int    $0x80
  401113:	48 89 c0             	mov    %rax,%rax
  401116:	48 89 c2             	mov    %rax,%rdx
	if((int)res < 0)
  401119:	85 d2                	test   %edx,%edx
  40111b:	79 12                	jns    40112f <lseek+0x39>
	{
		errno = -res;
  40111d:	f7 da                	neg    %edx
  40111f:	48 8b 05 d2 12 20 00 	mov    0x2012d2(%rip),%rax        # 6023f8 <digits.1229+0x200b38>
  401126:	89 10                	mov    %edx,(%rax)
		return -1;
  401128:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
	}
    return res;
}
  40112f:	5b                   	pop    %rbx
  401130:	c3                   	retq   

0000000000401131 <close>:
/*working*/
int close(int fd){
  401131:	53                   	push   %rbx
    int res = syscall_1(SYS_close, fd);
  401132:	48 63 df             	movslq %edi,%rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  401135:	b8 03 00 00 00       	mov    $0x3,%eax
  40113a:	48 89 c0             	mov    %rax,%rax
  40113d:	48 89 df             	mov    %rbx,%rdi
  401140:	cd 80                	int    $0x80
  401142:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  401145:	85 c0                	test   %eax,%eax
  401147:	79 10                	jns    401159 <close+0x28>
	{
		errno = -res;
  401149:	f7 d8                	neg    %eax
  40114b:	48 8b 15 a6 12 20 00 	mov    0x2012a6(%rip),%rdx        # 6023f8 <digits.1229+0x200b38>
  401152:	89 02                	mov    %eax,(%rdx)
		return -1;
  401154:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  401159:	5b                   	pop    %rbx
  40115a:	c3                   	retq   

000000000040115b <pipe>:
/*working*/
int pipe(int filedes[2]){
  40115b:	53                   	push   %rbx
  40115c:	b8 16 00 00 00       	mov    $0x16,%eax
  401161:	48 89 fb             	mov    %rdi,%rbx
  401164:	48 89 c0             	mov    %rax,%rax
  401167:	48 89 df             	mov    %rbx,%rdi
  40116a:	cd 80                	int    $0x80
  40116c:	48 89 c0             	mov    %rax,%rax
	//filedes[0] = 10;
	//filedes[1] = 20;
	
    int res = syscall_1(SYS_pipe, (uint64_t)filedes);
	if(res < 0)
  40116f:	85 c0                	test   %eax,%eax
  401171:	79 10                	jns    401183 <pipe+0x28>
	{
		errno = -res;
  401173:	f7 d8                	neg    %eax
  401175:	48 8b 15 7c 12 20 00 	mov    0x20127c(%rip),%rdx        # 6023f8 <digits.1229+0x200b38>
  40117c:	89 02                	mov    %eax,(%rdx)
		return -1;
  40117e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  401183:	5b                   	pop    %rbx
  401184:	c3                   	retq   

0000000000401185 <dup>:

int dup(int oldfd){
  401185:	53                   	push   %rbx
    int res = syscall_1(SYS_dup,oldfd);
  401186:	48 63 df             	movslq %edi,%rbx
  401189:	b8 20 00 00 00       	mov    $0x20,%eax
  40118e:	48 89 c0             	mov    %rax,%rax
  401191:	48 89 df             	mov    %rbx,%rdi
  401194:	cd 80                	int    $0x80
  401196:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  401199:	85 c0                	test   %eax,%eax
  40119b:	79 10                	jns    4011ad <dup+0x28>
	{
		errno = -res;
  40119d:	f7 d8                	neg    %eax
  40119f:	48 8b 15 52 12 20 00 	mov    0x201252(%rip),%rdx        # 6023f8 <digits.1229+0x200b38>
  4011a6:	89 02                	mov    %eax,(%rdx)
		return -1;
  4011a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  4011ad:	5b                   	pop    %rbx
  4011ae:	c3                   	retq   

00000000004011af <dup2>:

int dup2(int oldfd, int newfd){
  4011af:	53                   	push   %rbx
    int res = syscall_2(SYS_dup2, (uint64_t) oldfd, (uint64_t) newfd);
  4011b0:	48 63 df             	movslq %edi,%rbx
  4011b3:	48 63 ce             	movslq %esi,%rcx
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  4011b6:	b8 21 00 00 00       	mov    $0x21,%eax
  4011bb:	48 89 c0             	mov    %rax,%rax
  4011be:	48 89 df             	mov    %rbx,%rdi
  4011c1:	48 89 ce             	mov    %rcx,%rsi
  4011c4:	cd 80                	int    $0x80
  4011c6:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  4011c9:	85 c0                	test   %eax,%eax
  4011cb:	79 10                	jns    4011dd <dup2+0x2e>
	{
		errno = -res;
  4011cd:	f7 d8                	neg    %eax
  4011cf:	48 8b 15 22 12 20 00 	mov    0x201222(%rip),%rdx        # 6023f8 <digits.1229+0x200b38>
  4011d6:	89 02                	mov    %eax,(%rdx)
		return -1;
  4011d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  4011dd:	5b                   	pop    %rbx
  4011de:	c3                   	retq   

00000000004011df <opendir>:

void *opendir(const char *name){
  4011df:	53                   	push   %rbx
	int fd = open(name, O_DIRECTORY);
  4011e0:	be 00 00 01 00       	mov    $0x10000,%esi
  4011e5:	e8 51 fe ff ff       	callq  40103b <open>
  4011ea:	89 c3                	mov    %eax,%ebx
	//char buf[1024];
	struct dirent *buf = malloc(sizeof(struct dirent));
  4011ec:	bf 18 04 00 00       	mov    $0x418,%edi
  4011f1:	e8 da f1 ff ff       	callq  4003d0 <malloc>
  4011f6:	48 89 c1             	mov    %rax,%rcx
	//if(fd < 0)
	//	return -1;
	//static struct dirent dp;
	//printf("sashi 1 \n");
	//int res = 0;
	uint64_t res = syscall_3(SYS_getdents, (uint64_t)fd, (uint64_t)buf, (uint64_t)sizeof(struct dirent));
  4011f9:	48 63 db             	movslq %ebx,%rbx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  4011fc:	ba 18 04 00 00       	mov    $0x418,%edx
  401201:	b8 4e 00 00 00       	mov    $0x4e,%eax
  401206:	48 89 c0             	mov    %rax,%rax
  401209:	48 89 df             	mov    %rbx,%rdi
  40120c:	48 89 ce             	mov    %rcx,%rsi
  40120f:	48 89 d2             	mov    %rdx,%rdx
  401212:	cd 80                	int    $0x80
  401214:	48 89 c0             	mov    %rax,%rax
	//strcpy(d->d_name, name);
	//printf("sashi 2 \n");
	//d = (struct dirent *)buf;
    //return (uint64_t)f;
	return (void *)buf;
}
  401217:	48 89 c8             	mov    %rcx,%rax
  40121a:	5b                   	pop    %rbx
  40121b:	c3                   	retq   

000000000040121c <readdir>:
	d = (struct dirent *)buf;
    return (void *)d;
}
*/
struct dirent * readdir(struct dirent *dir)
{
  40121c:	53                   	push   %rbx
  40121d:	48 89 fb             	mov    %rdi,%rbx
	struct dirent *next;
	next = (struct dirent *)(dir + dip->d_reclen);
	if(next->d_reclen == 0)
		return NULL;
	return next; */
	struct dirent *buf = malloc(sizeof(struct dirent));
  401220:	bf 18 04 00 00       	mov    $0x418,%edi
  401225:	e8 a6 f1 ff ff       	callq  4003d0 <malloc>
  40122a:	48 89 c1             	mov    %rax,%rcx
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  40122d:	b8 51 00 00 00       	mov    $0x51,%eax
  401232:	48 89 c0             	mov    %rax,%rax
  401235:	48 89 df             	mov    %rbx,%rdi
  401238:	48 89 ce             	mov    %rcx,%rsi
  40123b:	cd 80                	int    $0x80
  40123d:	48 89 c0             	mov    %rax,%rax
	//printf("d_name %s \n",buf->d_name);
	//printf("End of readdir\n");
	return (struct dirent *)buf;
	//printf("dir inside readdir%s",dir->d_name);

}
  401240:	48 89 c8             	mov    %rcx,%rax
  401243:	5b                   	pop    %rbx
  401244:	c3                   	retq   

0000000000401245 <closedir>:

int closedir(void *dir){
  401245:	55                   	push   %rbp
  401246:	53                   	push   %rbx
  401247:	48 83 ec 08          	sub    $0x8,%rsp
  40124b:	48 89 fb             	mov    %rdi,%rbx
	struct dir *dp = (struct dir *)dir;
	int res = -1;
	if(dp != NULL)
  40124e:	48 85 ff             	test   %rdi,%rdi
  401251:	74 13                	je     401266 <closedir+0x21>
	{	
		res = close(dp->fd);
  401253:	8b 3f                	mov    (%rdi),%edi
  401255:	e8 d7 fe ff ff       	callq  401131 <close>
  40125a:	89 c5                	mov    %eax,%ebp
		free(dp);
  40125c:	48 89 df             	mov    %rbx,%rdi
  40125f:	e8 ec f0 ff ff       	callq  400350 <free>
  401264:	eb 05                	jmp    40126b <closedir+0x26>

}

int closedir(void *dir){
	struct dir *dp = (struct dir *)dir;
	int res = -1;
  401266:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
	{	
		res = close(dp->fd);
		free(dp);
	}
	return res;
}
  40126b:	89 e8                	mov    %ebp,%eax
  40126d:	48 83 c4 08          	add    $0x8,%rsp
  401271:	5b                   	pop    %rbx
  401272:	5d                   	pop    %rbp
  401273:	c3                   	retq   

0000000000401274 <waitpid>:

/*working*/
pid_t waitpid(pid_t pid,int *status, int options){
  401274:	53                   	push   %rbx
    pid_t res = syscall_3(SYS_wait4,(uint64_t)pid,(uint64_t)status,(uint64_t)options);
  401275:	89 fb                	mov    %edi,%ebx
  401277:	48 63 d2             	movslq %edx,%rdx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  40127a:	b8 3d 00 00 00       	mov    $0x3d,%eax
  40127f:	48 89 f1             	mov    %rsi,%rcx
  401282:	48 89 c0             	mov    %rax,%rax
  401285:	48 89 df             	mov    %rbx,%rdi
  401288:	48 89 ce             	mov    %rcx,%rsi
  40128b:	48 89 d2             	mov    %rdx,%rdx
  40128e:	cd 80                	int    $0x80
  401290:	48 89 c0             	mov    %rax,%rax
  401293:	48 89 c2             	mov    %rax,%rdx
	if((int)res < 0)
  401296:	85 d2                	test   %edx,%edx
  401298:	79 10                	jns    4012aa <waitpid+0x36>
	{
		errno = -res;	
  40129a:	f7 da                	neg    %edx
  40129c:	48 8b 05 55 11 20 00 	mov    0x201155(%rip),%rax        # 6023f8 <digits.1229+0x200b38>
  4012a3:	89 10                	mov    %edx,(%rax)
		return -1;
  4012a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  4012aa:	5b                   	pop    %rbx
  4012ab:	c3                   	retq   
  4012ac:	0f 1f 40 00          	nopl   0x0(%rax)

00000000004012b0 <memcmp>:

//Compare first n characters pointed by s1 to s2.
int memcmp(const void* s1, const void* s2,size_t n)
{
    const unsigned char *p1 = s1, *p2 = s2;
    while(n--)
  4012b0:	4c 8d 42 ff          	lea    -0x1(%rdx),%r8
  4012b4:	48 85 d2             	test   %rdx,%rdx
  4012b7:	74 35                	je     4012ee <memcmp+0x3e>
        if( *p1 != *p2 )
  4012b9:	0f b6 07             	movzbl (%rdi),%eax
  4012bc:	0f b6 0e             	movzbl (%rsi),%ecx
  4012bf:	ba 00 00 00 00       	mov    $0x0,%edx
  4012c4:	38 c8                	cmp    %cl,%al
  4012c6:	74 1b                	je     4012e3 <memcmp+0x33>
  4012c8:	eb 10                	jmp    4012da <memcmp+0x2a>
  4012ca:	0f b6 44 17 01       	movzbl 0x1(%rdi,%rdx,1),%eax
  4012cf:	48 ff c2             	inc    %rdx
  4012d2:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  4012d6:	38 c8                	cmp    %cl,%al
  4012d8:	74 09                	je     4012e3 <memcmp+0x33>
            return *p1 - *p2;
  4012da:	0f b6 c0             	movzbl %al,%eax
  4012dd:	0f b6 c9             	movzbl %cl,%ecx
  4012e0:	29 c8                	sub    %ecx,%eax
  4012e2:	c3                   	retq   

//Compare first n characters pointed by s1 to s2.
int memcmp(const void* s1, const void* s2,size_t n)
{
    const unsigned char *p1 = s1, *p2 = s2;
    while(n--)
  4012e3:	4c 39 c2             	cmp    %r8,%rdx
  4012e6:	75 e2                	jne    4012ca <memcmp+0x1a>
        if( *p1 != *p2 )
            return *p1 - *p2;
        else
            p1++,p2++;
    return 0;
  4012e8:	b8 00 00 00 00       	mov    $0x0,%eax
  4012ed:	c3                   	retq   
  4012ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  4012f3:	c3                   	retq   

00000000004012f4 <memset>:

void *memset(void *str, int c, size_t n)
{
  4012f4:	48 89 f8             	mov    %rdi,%rax
    char *dst = str;
    while(n-- != 0)
  4012f7:	48 85 d2             	test   %rdx,%rdx
  4012fa:	74 12                	je     40130e <memset+0x1a>
  4012fc:	48 01 fa             	add    %rdi,%rdx
    return 0;
}

void *memset(void *str, int c, size_t n)
{
    char *dst = str;
  4012ff:	48 89 f9             	mov    %rdi,%rcx
    while(n-- != 0)
    {
        *dst++ = c;
  401302:	48 ff c1             	inc    %rcx
  401305:	40 88 71 ff          	mov    %sil,-0x1(%rcx)
}

void *memset(void *str, int c, size_t n)
{
    char *dst = str;
    while(n-- != 0)
  401309:	48 39 d1             	cmp    %rdx,%rcx
  40130c:	75 f4                	jne    401302 <memset+0xe>
    {
        *dst++ = c;
    }
    return str;
}
  40130e:	f3 c3                	repz retq 

0000000000401310 <memcpy>:

void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n)
{
  401310:	48 89 f8             	mov    %rdi,%rax
     char *dst = s1;
     const char *src = s2;
     /* Loop and copy.  */
     while (n-- != 0)
  401313:	48 85 d2             	test   %rdx,%rdx
  401316:	74 16                	je     40132e <memcpy+0x1e>
  401318:	b9 00 00 00 00       	mov    $0x0,%ecx
         *dst++ = *src++;
  40131d:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  401322:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
  401326:	48 ff c1             	inc    %rcx
void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n)
{
     char *dst = s1;
     const char *src = s2;
     /* Loop and copy.  */
     while (n-- != 0)
  401329:	48 39 d1             	cmp    %rdx,%rcx
  40132c:	75 ef                	jne    40131d <memcpy+0xd>
         *dst++ = *src++;
     return s1;
 }
  40132e:	f3 c3                	repz retq 

0000000000401330 <strcpy>:

char *strcpy(char *dest, const char *src)
 {
  401330:	48 89 f8             	mov    %rdi,%rax
         char *tmp = dest; 
         while ((*dest++ = *src++) != '\0');
  401333:	48 89 fa             	mov    %rdi,%rdx
  401336:	48 ff c2             	inc    %rdx
  401339:	48 ff c6             	inc    %rsi
  40133c:	0f b6 4e ff          	movzbl -0x1(%rsi),%ecx
  401340:	88 4a ff             	mov    %cl,-0x1(%rdx)
  401343:	84 c9                	test   %cl,%cl
  401345:	75 ef                	jne    401336 <strcpy+0x6>
         return tmp;
 }
  401347:	f3 c3                	repz retq 

0000000000401349 <strncpy>:

char *strncpy(char *dest, const char *src, size_t count)
 {
  401349:	48 89 f8             	mov    %rdi,%rax
         char *tmp = dest; 
         while (count) {
  40134c:	48 85 d2             	test   %rdx,%rdx
  40134f:	74 1d                	je     40136e <strncpy+0x25>
  401351:	48 01 fa             	add    %rdi,%rdx
         return tmp;
 }

char *strncpy(char *dest, const char *src, size_t count)
 {
         char *tmp = dest; 
  401354:	48 89 f9             	mov    %rdi,%rcx
         while (count) {
                 if ((*tmp = *src) != 0)
  401357:	44 0f b6 06          	movzbl (%rsi),%r8d
  40135b:	44 88 01             	mov    %r8b,(%rcx)
                         src++;
  40135e:	41 80 f8 01          	cmp    $0x1,%r8b
  401362:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
                 tmp++;
  401366:	48 ff c1             	inc    %rcx
 }

char *strncpy(char *dest, const char *src, size_t count)
 {
         char *tmp = dest; 
         while (count) {
  401369:	48 39 d1             	cmp    %rdx,%rcx
  40136c:	75 e9                	jne    401357 <strncpy+0xe>
                         src++;
                 tmp++;
                 count--;
         }
         return dest;
 }
  40136e:	f3 c3                	repz retq 

0000000000401370 <strlen>:

size_t strlen(const char * str)
{
    const char *s;
    for (s = str; *s; ++s);
  401370:	80 3f 00             	cmpb   $0x0,(%rdi)
  401373:	74 0d                	je     401382 <strlen+0x12>
  401375:	48 89 f8             	mov    %rdi,%rax
  401378:	48 ff c0             	inc    %rax
  40137b:	80 38 00             	cmpb   $0x0,(%rax)
  40137e:	75 f8                	jne    401378 <strlen+0x8>
  401380:	eb 03                	jmp    401385 <strlen+0x15>
  401382:	48 89 f8             	mov    %rdi,%rax
    return(s - str);
  401385:	48 29 f8             	sub    %rdi,%rax
}
  401388:	c3                   	retq   

0000000000401389 <strcmp>:

int strcmp(const char *cs, const char *ct)
 {
         unsigned char c1, c2;
         while (1) {
                 c1 = *cs++;
  401389:	48 ff c7             	inc    %rdi
  40138c:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
                 c2 = *ct++;
  401390:	48 ff c6             	inc    %rsi
  401393:	0f b6 56 ff          	movzbl -0x1(%rsi),%edx
                 if (c1 != c2)
  401397:	38 d0                	cmp    %dl,%al
  401399:	74 08                	je     4013a3 <strcmp+0x1a>
                         return c1 < c2 ? -1 : 1;
  40139b:	38 d0                	cmp    %dl,%al
  40139d:	19 c0                	sbb    %eax,%eax
  40139f:	83 c8 01             	or     $0x1,%eax
  4013a2:	c3                   	retq   
                 if (!c1)
  4013a3:	84 c0                	test   %al,%al
  4013a5:	75 e2                	jne    401389 <strcmp>
                         break;
         }
         return 0;
  4013a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  4013ac:	c3                   	retq   

00000000004013ad <strstr>:

char *strstr(const char *s1, const char *s2)
{
  4013ad:	41 55                	push   %r13
  4013af:	41 54                	push   %r12
  4013b1:	55                   	push   %rbp
  4013b2:	53                   	push   %rbx
  4013b3:	48 83 ec 08          	sub    $0x8,%rsp
  4013b7:	48 89 fb             	mov    %rdi,%rbx
  4013ba:	49 89 f5             	mov    %rsi,%r13
         size_t l1, l2; 
         l2 = strlen(s2);
  4013bd:	48 89 f7             	mov    %rsi,%rdi
  4013c0:	e8 ab ff ff ff       	callq  401370 <strlen>
  4013c5:	49 89 c4             	mov    %rax,%r12
         if (!l2)
                 return (char *)s1;
  4013c8:	48 89 d8             	mov    %rbx,%rax

char *strstr(const char *s1, const char *s2)
{
         size_t l1, l2; 
         l2 = strlen(s2);
         if (!l2)
  4013cb:	4d 85 e4             	test   %r12,%r12
  4013ce:	74 43                	je     401413 <strstr+0x66>
                 return (char *)s1;
         l1 = strlen(s1);
  4013d0:	48 89 df             	mov    %rbx,%rdi
  4013d3:	e8 98 ff ff ff       	callq  401370 <strlen>
  4013d8:	48 89 c5             	mov    %rax,%rbp
         while (l1 >= l2) {
  4013db:	49 39 c4             	cmp    %rax,%r12
  4013de:	77 22                	ja     401402 <strstr+0x55>
                 l1--;
  4013e0:	48 ff cd             	dec    %rbp
                 if (!memcmp(s1, s2, l2))
  4013e3:	4c 89 e2             	mov    %r12,%rdx
  4013e6:	4c 89 ee             	mov    %r13,%rsi
  4013e9:	48 89 df             	mov    %rbx,%rdi
  4013ec:	e8 bf fe ff ff       	callq  4012b0 <memcmp>
  4013f1:	85 c0                	test   %eax,%eax
  4013f3:	74 14                	je     401409 <strstr+0x5c>
                         return (char *)s1;
                 s1++;
  4013f5:	48 ff c3             	inc    %rbx
         size_t l1, l2; 
         l2 = strlen(s2);
         if (!l2)
                 return (char *)s1;
         l1 = strlen(s1);
         while (l1 >= l2) {
  4013f8:	49 39 ec             	cmp    %rbp,%r12
  4013fb:	76 e3                	jbe    4013e0 <strstr+0x33>
  4013fd:	0f 1f 00             	nopl   (%rax)
  401400:	eb 0c                	jmp    40140e <strstr+0x61>
                 l1--;
                 if (!memcmp(s1, s2, l2))
                         return (char *)s1;
                 s1++;
         }
         return NULL;
  401402:	b8 00 00 00 00       	mov    $0x0,%eax
  401407:	eb 0a                	jmp    401413 <strstr+0x66>
  401409:	48 89 d8             	mov    %rbx,%rax
  40140c:	eb 05                	jmp    401413 <strstr+0x66>
  40140e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401413:	48 83 c4 08          	add    $0x8,%rsp
  401417:	5b                   	pop    %rbx
  401418:	5d                   	pop    %rbp
  401419:	41 5c                	pop    %r12
  40141b:	41 5d                	pop    %r13
  40141d:	c3                   	retq   

000000000040141e <strcat>:

char *strcat(char *dest, const char *src)
{
  40141e:	48 89 f8             	mov    %rdi,%rax
         char *tmp = dest; 
         while (*dest)
  401421:	80 3f 00             	cmpb   $0x0,(%rdi)
  401424:	74 0d                	je     401433 <strcat+0x15>
  401426:	48 89 fa             	mov    %rdi,%rdx
                 dest++;
  401429:	48 ff c2             	inc    %rdx
}

char *strcat(char *dest, const char *src)
{
         char *tmp = dest; 
         while (*dest)
  40142c:	80 3a 00             	cmpb   $0x0,(%rdx)
  40142f:	75 f8                	jne    401429 <strcat+0xb>
  401431:	eb 03                	jmp    401436 <strcat+0x18>
  401433:	48 89 fa             	mov    %rdi,%rdx
                 dest++;
         while ((*dest++ = *src++) != '\0')
  401436:	48 ff c2             	inc    %rdx
  401439:	48 ff c6             	inc    %rsi
  40143c:	0f b6 4e ff          	movzbl -0x1(%rsi),%ecx
  401440:	88 4a ff             	mov    %cl,-0x1(%rdx)
  401443:	84 c9                	test   %cl,%cl
  401445:	75 ef                	jne    401436 <strcat+0x18>
                 ;
         return tmp;
}
  401447:	f3 c3                	repz retq 

0000000000401449 <isspace>:

int isspace(char c)
{
    return (c == ' ' || c == '\t' || c == '\n' || c == '\12');
  401449:	8d 47 f7             	lea    -0x9(%rdi),%eax
  40144c:	3c 01                	cmp    $0x1,%al
  40144e:	0f 96 c2             	setbe  %dl
  401451:	40 80 ff 20          	cmp    $0x20,%dil
  401455:	0f 94 c0             	sete   %al
  401458:	09 d0                	or     %edx,%eax
  40145a:	0f b6 c0             	movzbl %al,%eax
}
  40145d:	c3                   	retq   

000000000040145e <strchr>:

char *strchr(const char *s, int c)
{
    while (*s != (char)c)
  40145e:	eb 07                	jmp    401467 <strchr+0x9>
        if (!*s++)
  401460:	48 ff c7             	inc    %rdi
  401463:	84 c0                	test   %al,%al
  401465:	74 0c                	je     401473 <strchr+0x15>
    return (c == ' ' || c == '\t' || c == '\n' || c == '\12');
}

char *strchr(const char *s, int c)
{
    while (*s != (char)c)
  401467:	0f b6 07             	movzbl (%rdi),%eax
  40146a:	40 38 f0             	cmp    %sil,%al
  40146d:	75 f1                	jne    401460 <strchr+0x2>
  40146f:	48 89 f8             	mov    %rdi,%rax
  401472:	c3                   	retq   
        if (!*s++)
            return 0;
  401473:	b8 00 00 00 00       	mov    $0x0,%eax
    return (char *)s;
}
  401478:	c3                   	retq   

0000000000401479 <isdigit>:

int isdigit(int ch)
{
        return (ch >= '0') && (ch <= '9');
  401479:	83 ef 30             	sub    $0x30,%edi
  40147c:	83 ff 09             	cmp    $0x9,%edi
  40147f:	0f 96 c0             	setbe  %al
  401482:	0f b6 c0             	movzbl %al,%eax
}
  401485:	c3                   	retq   

0000000000401486 <strcspn>:

size_t strcspn(const char *s, const char *reject) {
  401486:	41 54                	push   %r12
  401488:	55                   	push   %rbp
  401489:	53                   	push   %rbx
  40148a:	48 89 fd             	mov    %rdi,%rbp
        size_t count = 0;

        while (*s != '\0') {
  40148d:	0f b6 17             	movzbl (%rdi),%edx
  401490:	84 d2                	test   %dl,%dl
  401492:	74 26                	je     4014ba <strcspn+0x34>
  401494:	49 89 f4             	mov    %rsi,%r12
{
        return (ch >= '0') && (ch <= '9');
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;
  401497:	bb 00 00 00 00       	mov    $0x0,%ebx

        while (*s != '\0') {
                if (strchr(reject, *s++) == NULL) {
  40149c:	0f be f2             	movsbl %dl,%esi
  40149f:	4c 89 e7             	mov    %r12,%rdi
  4014a2:	e8 b7 ff ff ff       	callq  40145e <strchr>
  4014a7:	48 85 c0             	test   %rax,%rax
  4014aa:	75 13                	jne    4014bf <strcspn+0x39>
                        ++count;
  4014ac:	48 ff c3             	inc    %rbx
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;

        while (*s != '\0') {
  4014af:	0f b6 54 1d 00       	movzbl 0x0(%rbp,%rbx,1),%edx
  4014b4:	84 d2                	test   %dl,%dl
  4014b6:	75 e4                	jne    40149c <strcspn+0x16>
  4014b8:	eb 05                	jmp    4014bf <strcspn+0x39>
{
        return (ch >= '0') && (ch <= '9');
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;
  4014ba:	bb 00 00 00 00       	mov    $0x0,%ebx
                } else {
                        return count;
                }
        }
        return count;
}
  4014bf:	48 89 d8             	mov    %rbx,%rax
  4014c2:	5b                   	pop    %rbx
  4014c3:	5d                   	pop    %rbp
  4014c4:	41 5c                	pop    %r12
  4014c6:	c3                   	retq   

00000000004014c7 <reset>:
void reset(char str[], int len)
{
	for(int i = 0; i < len; i++)
  4014c7:	85 f6                	test   %esi,%esi
  4014c9:	7e 10                	jle    4014db <reset+0x14>
  4014cb:	b8 00 00 00 00       	mov    $0x0,%eax
		str[i] = '\0';
  4014d0:	c6 04 07 00          	movb   $0x0,(%rdi,%rax,1)
  4014d4:	48 ff c0             	inc    %rax
        }
        return count;
}
void reset(char str[], int len)
{
	for(int i = 0; i < len; i++)
  4014d7:	39 c6                	cmp    %eax,%esi
  4014d9:	7f f5                	jg     4014d0 <reset+0x9>
  4014db:	f3 c3                	repz retq 

00000000004014dd <atoi>:
}

int atoi(const char *str)
{
    int k = 0;
    for (int i = 0; str[i] != '\0'; ++i)
  4014dd:	0f b6 17             	movzbl (%rdi),%edx
  4014e0:	84 d2                	test   %dl,%dl
  4014e2:	74 26                	je     40150a <atoi+0x2d>
  4014e4:	b9 00 00 00 00       	mov    $0x0,%ecx
		str[i] = '\0';
}

int atoi(const char *str)
{
    int k = 0;
  4014e9:	b8 00 00 00 00       	mov    $0x0,%eax
    for (int i = 0; str[i] != '\0'; ++i)
        k = (k<<3)+(k<<1)+(str[i])-'0';
  4014ee:	8d 34 00             	lea    (%rax,%rax,1),%esi
  4014f1:	8d 04 c6             	lea    (%rsi,%rax,8),%eax
  4014f4:	0f be d2             	movsbl %dl,%edx
  4014f7:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
}

int atoi(const char *str)
{
    int k = 0;
    for (int i = 0; str[i] != '\0'; ++i)
  4014fb:	ff c1                	inc    %ecx
  4014fd:	48 63 d1             	movslq %ecx,%rdx
  401500:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  401504:	84 d2                	test   %dl,%dl
  401506:	75 e6                	jne    4014ee <atoi+0x11>
  401508:	f3 c3                	repz retq 
		str[i] = '\0';
}

int atoi(const char *str)
{
    int k = 0;
  40150a:	b8 00 00 00 00       	mov    $0x0,%eax
    for (int i = 0; str[i] != '\0'; ++i)
        k = (k<<3)+(k<<1)+(str[i])-'0';
    return k;
}
  40150f:	c3                   	retq   
