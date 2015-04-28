
rootfs/bin/filetest:     file format elf64-x86-64


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
  400117:	e8 4c 0d 00 00       	callq  400e68 <exit>
}
  40011c:	48 83 c4 08          	add    $0x8,%rsp
  400120:	c3                   	retq   

0000000000400121 <main>:
#include <stdlib.h>
#include <string.h>

void fopentest();
void getcwd1();	
int main(int argc, char* argv[], char* envp[]) {
  400121:	48 83 ec 08          	sub    $0x8,%rsp
	opendir("bin/");
  400125:	48 8d 3d f4 13 00 00 	lea    0x13f4(%rip),%rdi        # 401520 <atoi+0x33>
  40012c:	e8 10 10 00 00       	callq  401141 <opendir>
	printf("in main after opendir");
  400131:	48 8d 3d ed 13 00 00 	lea    0x13ed(%rip),%rdi        # 401525 <atoi+0x38>
  400138:	b8 00 00 00 00       	mov    $0x0,%eax
  40013d:	e8 61 0a 00 00       	callq  400ba3 <printf>
	printf("the pid is %d\n",pid);
	printf("the ppid is %d\n",ppid);*/
	//fopentest();
	//getcwd1();
	return 0;
}
  400142:	b8 00 00 00 00       	mov    $0x0,%eax
  400147:	48 83 c4 08          	add    $0x8,%rsp
  40014b:	c3                   	retq   

000000000040014c <fopentest>:

void fopentest()
{
  40014c:	55                   	push   %rbp
  40014d:	53                   	push   %rbx
  40014e:	48 83 ec 78          	sub    $0x78,%rsp
	printf("*********************************************\n");
  400152:	48 8d 3d 57 14 00 00 	lea    0x1457(%rip),%rdi        # 4015b0 <atoi+0xc3>
  400159:	b8 00 00 00 00       	mov    $0x0,%eax
  40015e:	e8 40 0a 00 00       	callq  400ba3 <printf>
	printf("testing  open() and close() API \n");
  400163:	48 8d 3d 76 14 00 00 	lea    0x1476(%rip),%rdi        # 4015e0 <atoi+0xf3>
  40016a:	b8 00 00 00 00       	mov    $0x0,%eax
  40016f:	e8 2f 0a 00 00       	callq  400ba3 <printf>
	char *name = malloc(12);
  400174:	bf 0c 00 00 00       	mov    $0xc,%edi
  400179:	e8 d2 01 00 00       	callq  400350 <malloc>
  40017e:	48 89 c3             	mov    %rax,%rbx
	strcpy(name, "shashi.txt"/*"abc"*/);
  400181:	48 8d 35 b3 13 00 00 	lea    0x13b3(%rip),%rsi        # 40153b <atoi+0x4e>
  400188:	48 89 c7             	mov    %rax,%rdi
  40018b:	e8 b0 11 00 00       	callq  401340 <strcpy>
	int fd = open(name, O_RDONLY);
  400190:	be 00 00 00 00       	mov    $0x0,%esi
  400195:	48 89 df             	mov    %rbx,%rdi
  400198:	e8 1e 0e 00 00       	callq  400fbb <open>
  40019d:	89 c3                	mov    %eax,%ebx
	//printf("fd no is %d error no is : %d \n", fd, errno);
	//print("fd is %d \n", fd);
	if(fd < 0)
  40019f:	85 c0                	test   %eax,%eax
  4001a1:	79 10                	jns    4001b3 <fopentest+0x67>
	{
		serror(errno);
  4001a3:	48 8b 05 7e 22 20 00 	mov    0x20227e(%rip),%rax        # 602428 <digits.1229+0x200b98>
  4001aa:	8b 38                	mov    (%rax),%edi
  4001ac:	e8 84 0a 00 00       	callq  400c35 <serror>
  4001b1:	eb 78                	jmp    40022b <fopentest+0xdf>
		return;
	}
	else
		printf("file open succesfull: fd =  %d\n", fd);
  4001b3:	89 c6                	mov    %eax,%esi
  4001b5:	48 8d 3d 4c 14 00 00 	lea    0x144c(%rip),%rdi        # 401608 <atoi+0x11b>
  4001bc:	b8 00 00 00 00       	mov    $0x0,%eax
  4001c1:	e8 dd 09 00 00       	callq  400ba3 <printf>
	char buf[100];
	read(fd,(void *)buf,10);
  4001c6:	48 8d 6c 24 0c       	lea    0xc(%rsp),%rbp
  4001cb:	ba 0a 00 00 00       	mov    $0xa,%edx
  4001d0:	48 89 ee             	mov    %rbp,%rsi
  4001d3:	89 df                	mov    %ebx,%edi
  4001d5:	e8 14 0e 00 00       	callq  400fee <read>
	printf("read bytes: %s \n", buf);
  4001da:	48 89 ee             	mov    %rbp,%rsi
  4001dd:	48 8d 3d 62 13 00 00 	lea    0x1362(%rip),%rdi        # 401546 <atoi+0x59>
  4001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  4001e9:	e8 b5 09 00 00       	callq  400ba3 <printf>
	int res = close(fd);
  4001ee:	89 df                	mov    %ebx,%edi
  4001f0:	e8 9e 0e 00 00       	callq  401093 <close>
	if(res < 0)
  4001f5:	85 c0                	test   %eax,%eax
  4001f7:	79 10                	jns    400209 <fopentest+0xbd>
		serror(errno);
  4001f9:	48 8b 05 28 22 20 00 	mov    0x202228(%rip),%rax        # 602428 <digits.1229+0x200b98>
  400200:	8b 38                	mov    (%rax),%edi
  400202:	e8 2e 0a 00 00       	callq  400c35 <serror>
  400207:	eb 11                	jmp    40021a <fopentest+0xce>
	else
		printf("file close succesfull \n");
  400209:	48 8d 3d 47 13 00 00 	lea    0x1347(%rip),%rdi        # 401557 <atoi+0x6a>
  400210:	b8 00 00 00 00       	mov    $0x0,%eax
  400215:	e8 89 09 00 00       	callq  400ba3 <printf>
	 
	printf("\n\n");
  40021a:	48 8d 3d 4e 13 00 00 	lea    0x134e(%rip),%rdi        # 40156f <atoi+0x82>
  400221:	b8 00 00 00 00       	mov    $0x0,%eax
  400226:	e8 78 09 00 00       	callq  400ba3 <printf>
	//printf("res value is %d \n", res);
	
}
  40022b:	48 83 c4 78          	add    $0x78,%rsp
  40022f:	5b                   	pop    %rbx
  400230:	5d                   	pop    %rbp
  400231:	c3                   	retq   

0000000000400232 <getcwd1>:


void getcwd1()
{
  400232:	48 81 ec 08 04 00 00 	sub    $0x408,%rsp
	printf("*********************************************\n");
  400239:	48 8d 3d 70 13 00 00 	lea    0x1370(%rip),%rdi        # 4015b0 <atoi+0xc3>
  400240:	b8 00 00 00 00       	mov    $0x0,%eax
  400245:	e8 59 09 00 00       	callq  400ba3 <printf>
	printf("testing  getcwd() API \n");
  40024a:	48 8d 3d 21 13 00 00 	lea    0x1321(%rip),%rdi        # 401572 <atoi+0x85>
  400251:	b8 00 00 00 00       	mov    $0x0,%eax
  400256:	e8 48 09 00 00       	callq  400ba3 <printf>
	char* cwd;
	chdir("shashi");
  40025b:	48 8d 3d 28 13 00 00 	lea    0x1328(%rip),%rdi        # 40158a <atoi+0x9d>
  400262:	e8 2a 0d 00 00       	callq  400f91 <chdir>
    char buff[1024];
	cwd = getcwd( buff, 1025 );
  400267:	48 89 e7             	mov    %rsp,%rdi
  40026a:	be 01 04 00 00       	mov    $0x401,%esi
  40026f:	e8 ef 0c 00 00       	callq  400f63 <getcwd>
    if( cwd != NULL ) {
  400274:	48 85 c0             	test   %rax,%rax
  400277:	74 38                	je     4002b1 <getcwd1+0x7f>
        printf( "My working directory is %s \n", buff );
  400279:	48 89 e6             	mov    %rsp,%rsi
  40027c:	48 8d 3d 0e 13 00 00 	lea    0x130e(%rip),%rdi        # 401591 <atoi+0xa4>
  400283:	b8 00 00 00 00       	mov    $0x0,%eax
  400288:	e8 16 09 00 00       	callq  400ba3 <printf>
    else
    {
    	serror(errno);
    	return;
    }
    printf("getcwd() API open succesfull \n");
  40028d:	48 8d 3d 94 13 00 00 	lea    0x1394(%rip),%rdi        # 401628 <atoi+0x13b>
  400294:	b8 00 00 00 00       	mov    $0x0,%eax
  400299:	e8 05 09 00 00       	callq  400ba3 <printf>
	
	
	printf("\n\n");
  40029e:	48 8d 3d ca 12 00 00 	lea    0x12ca(%rip),%rdi        # 40156f <atoi+0x82>
  4002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  4002aa:	e8 f4 08 00 00       	callq  400ba3 <printf>
  4002af:	eb 0e                	jmp    4002bf <getcwd1+0x8d>
    if( cwd != NULL ) {
        printf( "My working directory is %s \n", buff );
    }
    else
    {
    	serror(errno);
  4002b1:	48 8b 05 70 21 20 00 	mov    0x202170(%rip),%rax        # 602428 <digits.1229+0x200b98>
  4002b8:	8b 38                	mov    (%rax),%edi
  4002ba:	e8 76 09 00 00       	callq  400c35 <serror>
    }
    printf("getcwd() API open succesfull \n");
	
	
	printf("\n\n");
}
  4002bf:	48 81 c4 08 04 00 00 	add    $0x408,%rsp
  4002c6:	c3                   	retq   
  4002c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  4002ce:	00 00 

00000000004002d0 <free>:
}

void free(void *ptr)
{
	//printf("freed \n");
	if(ptr == NULL)
  4002d0:	48 85 ff             	test   %rdi,%rdi
  4002d3:	74 07                	je     4002dc <free+0xc>
		return;
	struct mem_block *block = (struct mem_block *)ptr -1 ;
	block->free = FREE;
  4002d5:	c7 47 f0 01 00 00 00 	movl   $0x1,-0x10(%rdi)
  4002dc:	f3 c3                	repz retq 

00000000004002de <find_free_mem_block>:

//our code
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size)
{
	//printf("find_free_mem_block called %d \n \n\n\n ", size);
	struct mem_block *temp = head;
  4002de:	48 8d 05 6b 21 20 00 	lea    0x20216b(%rip),%rax        # 602450 <head>
  4002e5:	48 8b 00             	mov    (%rax),%rax
	while(temp && !(temp->free == FREE && temp->size >= size))
  4002e8:	48 85 c0             	test   %rax,%rax
  4002eb:	75 0e                	jne    4002fb <find_free_mem_block+0x1d>
  4002ed:	f3 c3                	repz retq 
	{
		*last = temp;
  4002ef:	48 89 07             	mov    %rax,(%rdi)
		temp = temp->next;	
  4002f2:	48 8b 40 10          	mov    0x10(%rax),%rax
//our code
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size)
{
	//printf("find_free_mem_block called %d \n \n\n\n ", size);
	struct mem_block *temp = head;
	while(temp && !(temp->free == FREE && temp->size >= size))
  4002f6:	48 85 c0             	test   %rax,%rax
  4002f9:	74 0b                	je     400306 <find_free_mem_block+0x28>
  4002fb:	83 78 08 01          	cmpl   $0x1,0x8(%rax)
  4002ff:	75 ee                	jne    4002ef <find_free_mem_block+0x11>
  400301:	48 39 30             	cmp    %rsi,(%rax)
  400304:	72 e9                	jb     4002ef <find_free_mem_block+0x11>
	{
		*last = temp;
		temp = temp->next;	
	}
	return temp;
}
  400306:	f3 c3                	repz retq 

0000000000400308 <allocateMemory>:

/* allocate memory of size  */
struct mem_block *allocateMemory(size_t size)
{
  400308:	55                   	push   %rbp
  400309:	53                   	push   %rbx
  40030a:	48 83 ec 08          	sub    $0x8,%rsp
  40030e:	48 89 fd             	mov    %rdi,%rbp
	struct mem_block *current;
	current = sbrk(0);
  400311:	bf 00 00 00 00       	mov    $0x0,%edi
  400316:	e8 79 0b 00 00       	callq  400e94 <sbrk>
  40031b:	48 89 c3             	mov    %rax,%rbx
	void *addr = sbrk(size + BLOCK_SIZE);
  40031e:	48 8d 7d 18          	lea    0x18(%rbp),%rdi
  400322:	e8 6d 0b 00 00       	callq  400e94 <sbrk>
	
	if (addr == (void*) -1) {
  400327:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  40032b:	74 17                	je     400344 <allocateMemory+0x3c>
		/* memory allocation failed */
		return NULL; 
  	}
	current->size = size;  //by removing memory block size
  40032d:	48 89 2b             	mov    %rbp,(%rbx)
	current->next = NULL;
  400330:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  400337:	00 
	current->free = USED;
  400338:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%rbx)
	return current;
  40033f:	48 89 d8             	mov    %rbx,%rax
  400342:	eb 05                	jmp    400349 <allocateMemory+0x41>
	current = sbrk(0);
	void *addr = sbrk(size + BLOCK_SIZE);
	
	if (addr == (void*) -1) {
		/* memory allocation failed */
		return NULL; 
  400344:	b8 00 00 00 00       	mov    $0x0,%eax
  	}
	current->size = size;  //by removing memory block size
	current->next = NULL;
	current->free = USED;
	return current;
}
  400349:	48 83 c4 08          	add    $0x8,%rsp
  40034d:	5b                   	pop    %rbx
  40034e:	5d                   	pop    %rbp
  40034f:	c3                   	retq   

0000000000400350 <malloc>:
struct mem_block *allocateMemory(size_t size);
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size);
void *malloc(size_t size);

void *malloc(size_t size)
{
  400350:	53                   	push   %rbx
  400351:	48 83 ec 10          	sub    $0x10,%rsp
  400355:	48 89 fb             	mov    %rdi,%rbx
	//printf("malloc start \n");
	struct mem_block *block;
	if(size <= 0)
  400358:	48 85 ff             	test   %rdi,%rdi
  40035b:	74 61                	je     4003be <malloc+0x6e>
		return NULL;
	
	if(head == NULL)
  40035d:	48 8d 05 ec 20 20 00 	lea    0x2020ec(%rip),%rax        # 602450 <head>
  400364:	48 8b 00             	mov    (%rax),%rax
  400367:	48 85 c0             	test   %rax,%rax
  40036a:	75 16                	jne    400382 <malloc+0x32>
	{
		//printf("first time allocation %d \n",size);
		block = allocateMemory(size);
  40036c:	e8 97 ff ff ff       	callq  400308 <allocateMemory>
		if(block == NULL)
  400371:	48 85 c0             	test   %rax,%rax
  400374:	74 4f                	je     4003c5 <malloc+0x75>
		{
			/*memory allocation failed */
			return NULL;	
		}
		head = block;
  400376:	48 8d 15 d3 20 20 00 	lea    0x2020d3(%rip),%rdx        # 602450 <head>
  40037d:	48 89 02             	mov    %rax,(%rdx)
  400380:	eb 36                	jmp    4003b8 <malloc+0x68>
	}
	else
	{
		//search for free block
		struct mem_block *last = head;
  400382:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
		block = find_free_mem_block(&last, size);
  400387:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  40038c:	48 89 de             	mov    %rbx,%rsi
  40038f:	e8 4a ff ff ff       	callq  4002de <find_free_mem_block>
		//printf("found free memory block \n");
		if(block == NULL)
  400394:	48 85 c0             	test   %rax,%rax
  400397:	75 18                	jne    4003b1 <malloc+0x61>
		{
			//printf("added at the end %d \n", size);
			block = allocateMemory(size);
  400399:	48 89 df             	mov    %rbx,%rdi
  40039c:	e8 67 ff ff ff       	callq  400308 <allocateMemory>
			if(block == NULL)
  4003a1:	48 85 c0             	test   %rax,%rax
  4003a4:	74 24                	je     4003ca <malloc+0x7a>
				return NULL;
			last->next = block;
  4003a6:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  4003ab:	48 89 42 10          	mov    %rax,0x10(%rdx)
  4003af:	eb 07                	jmp    4003b8 <malloc+0x68>
		}
		else{
			//use free block found
			//printf("using free block \n");
			block->free = USED;
  4003b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
		}
	}
	//printf("malloc end \n");
 	return(block+1); 
  4003b8:	48 83 c0 18          	add    $0x18,%rax
  4003bc:	eb 0c                	jmp    4003ca <malloc+0x7a>
void *malloc(size_t size)
{
	//printf("malloc start \n");
	struct mem_block *block;
	if(size <= 0)
		return NULL;
  4003be:	b8 00 00 00 00       	mov    $0x0,%eax
  4003c3:	eb 05                	jmp    4003ca <malloc+0x7a>
		//printf("first time allocation %d \n",size);
		block = allocateMemory(size);
		if(block == NULL)
		{
			/*memory allocation failed */
			return NULL;	
  4003c5:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	//printf("malloc end \n");
 	return(block+1); 
	//added 1 because block is a pointer of type struct and 
	//plus 1 increments the address by one sizeof(struct)
}
  4003ca:	48 83 c4 10          	add    $0x10,%rsp
  4003ce:	5b                   	pop    %rbx
  4003cf:	c3                   	retq   

00000000004003d0 <number>:
        return i;
}

static char *number(char *str, long num, int base, int size, int precision,
		    int type)
{
  4003d0:	41 57                	push   %r15
  4003d2:	41 56                	push   %r14
  4003d4:	41 55                	push   %r13
  4003d6:	41 54                	push   %r12
  4003d8:	55                   	push   %rbp
  4003d9:	53                   	push   %rbx
  4003da:	48 83 ec 55          	sub    $0x55,%rsp
  4003de:	41 89 d6             	mov    %edx,%r14d
	char c, sign, locase;
	int i;

	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
	 * produces same digits or (maybe lowercased) letters */
	locase = (type & SMALL);
  4003e1:	45 89 cd             	mov    %r9d,%r13d
  4003e4:	41 83 e5 20          	and    $0x20,%r13d
	if (type & LEFT)
  4003e8:	44 89 ca             	mov    %r9d,%edx
  4003eb:	83 e2 10             	and    $0x10,%edx
		type &= ~ZEROPAD;
  4003ee:	44 89 c8             	mov    %r9d,%eax
  4003f1:	83 e0 fe             	and    $0xfffffffe,%eax
  4003f4:	85 d2                	test   %edx,%edx
  4003f6:	44 0f 45 c8          	cmovne %eax,%r9d
	if (base < 2 || base > 16)
  4003fa:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  4003fe:	83 f8 0e             	cmp    $0xe,%eax
  400401:	0f 87 ee 01 00 00    	ja     4005f5 <number+0x225>
  400407:	45 89 f2             	mov    %r14d,%r10d
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
  40040a:	44 89 c8             	mov    %r9d,%eax
  40040d:	83 e0 01             	and    $0x1,%eax
  400410:	83 f8 01             	cmp    $0x1,%eax
  400413:	45 19 ff             	sbb    %r15d,%r15d
  400416:	41 83 e7 f0          	and    $0xfffffff0,%r15d
  40041a:	41 83 c7 30          	add    $0x30,%r15d
	sign = 0;
  40041e:	c6 04 24 00          	movb   $0x0,(%rsp)
	if (type & SIGN) {
  400422:	41 f6 c1 02          	test   $0x2,%r9b
  400426:	74 2e                	je     400456 <number+0x86>
		if (num < 0) {
  400428:	48 85 f6             	test   %rsi,%rsi
  40042b:	79 0b                	jns    400438 <number+0x68>
			sign = '-';
			num = -num;
  40042d:	48 f7 de             	neg    %rsi
			size--;
  400430:	ff c9                	dec    %ecx
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
	sign = 0;
	if (type & SIGN) {
		if (num < 0) {
			sign = '-';
  400432:	c6 04 24 2d          	movb   $0x2d,(%rsp)
  400436:	eb 1e                	jmp    400456 <number+0x86>
			num = -num;
			size--;
		} else if (type & PLUS) {
  400438:	41 f6 c1 04          	test   $0x4,%r9b
  40043c:	74 08                	je     400446 <number+0x76>
			sign = '+';
			size--;
  40043e:	ff c9                	dec    %ecx
		if (num < 0) {
			sign = '-';
			num = -num;
			size--;
		} else if (type & PLUS) {
			sign = '+';
  400440:	c6 04 24 2b          	movb   $0x2b,(%rsp)
  400444:	eb 10                	jmp    400456 <number+0x86>
	if (type & LEFT)
		type &= ~ZEROPAD;
	if (base < 2 || base > 16)
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
	sign = 0;
  400446:	c6 04 24 00          	movb   $0x0,(%rsp)
			num = -num;
			size--;
		} else if (type & PLUS) {
			sign = '+';
			size--;
		} else if (type & SPACE) {
  40044a:	41 f6 c1 08          	test   $0x8,%r9b
  40044e:	74 06                	je     400456 <number+0x86>
			sign = ' ';
			size--;
  400450:	ff c9                	dec    %ecx
			size--;
		} else if (type & PLUS) {
			sign = '+';
			size--;
		} else if (type & SPACE) {
			sign = ' ';
  400452:	c6 04 24 20          	movb   $0x20,(%rsp)
			size--;
		}
	}
	if (type & SPECIAL) {
  400456:	44 89 c8             	mov    %r9d,%eax
  400459:	83 e0 40             	and    $0x40,%eax
  40045c:	89 44 24 01          	mov    %eax,0x1(%rsp)
  400460:	74 17                	je     400479 <number+0xa9>
		if (base == 16)
  400462:	41 83 fe 10          	cmp    $0x10,%r14d
  400466:	75 05                	jne    40046d <number+0x9d>
			size -= 2;
  400468:	83 e9 02             	sub    $0x2,%ecx
  40046b:	eb 0c                	jmp    400479 <number+0xa9>
		else if (base == 8)
			size--;
  40046d:	41 83 fe 08          	cmp    $0x8,%r14d
  400471:	0f 94 c0             	sete   %al
  400474:	0f b6 c0             	movzbl %al,%eax
  400477:	29 c1                	sub    %eax,%ecx
	}
	i = 0;
	if (num == 0)
  400479:	48 85 f6             	test   %rsi,%rsi
  40047c:	75 0d                	jne    40048b <number+0xbb>
		tmp[i++] = '0';
  40047e:	c6 44 24 13 30       	movb   $0x30,0x13(%rsp)
  400483:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  400489:	eb 4c                	jmp    4004d7 <number+0x107>
  40048b:	4c 8d 5c 24 13       	lea    0x13(%rsp),%r11
			size -= 2;
		else if (base == 8)
			size--;
	}
	i = 0;
	if (num == 0)
  400490:	41 bc 00 00 00 00    	mov    $0x0,%r12d
		tmp[i++] = '0';
	else
		while (num != 0)
			tmp[i++] = (digits[__do_div(num, base)] | locase);
  400496:	45 89 d2             	mov    %r10d,%r10d
  400499:	41 ff c4             	inc    %r12d
  40049c:	48 89 f5             	mov    %rsi,%rbp
  40049f:	48 89 f0             	mov    %rsi,%rax
  4004a2:	ba 00 00 00 00       	mov    $0x0,%edx
  4004a7:	49 f7 f2             	div    %r10
  4004aa:	48 89 c3             	mov    %rax,%rbx
  4004ad:	48 89 c6             	mov    %rax,%rsi
  4004b0:	48 89 e8             	mov    %rbp,%rax
  4004b3:	ba 00 00 00 00       	mov    $0x0,%edx
  4004b8:	49 f7 f2             	div    %r10
  4004bb:	48 63 d2             	movslq %edx,%rdx
  4004be:	48 8d 05 cb 13 00 00 	lea    0x13cb(%rip),%rax        # 401890 <digits.1229>
  4004c5:	44 89 ed             	mov    %r13d,%ebp
  4004c8:	40 0a 2c 10          	or     (%rax,%rdx,1),%bpl
  4004cc:	41 88 2b             	mov    %bpl,(%r11)
  4004cf:	49 ff c3             	inc    %r11
	}
	i = 0;
	if (num == 0)
		tmp[i++] = '0';
	else
		while (num != 0)
  4004d2:	48 85 db             	test   %rbx,%rbx
  4004d5:	75 c2                	jne    400499 <number+0xc9>
  4004d7:	45 39 c4             	cmp    %r8d,%r12d
  4004da:	45 0f 4d c4          	cmovge %r12d,%r8d
			tmp[i++] = (digits[__do_div(num, base)] | locase);
	if (i > precision)
		precision = i;
	size -= precision;
  4004de:	44 29 c1             	sub    %r8d,%ecx
	if (!(type & (ZEROPAD + LEFT)))
  4004e1:	41 f6 c1 11          	test   $0x11,%r9b
  4004e5:	75 2d                	jne    400514 <number+0x144>
		while (size-- > 0)
  4004e7:	8d 71 ff             	lea    -0x1(%rcx),%esi
  4004ea:	85 c9                	test   %ecx,%ecx
  4004ec:	7e 24                	jle    400512 <number+0x142>
  4004ee:	ff c9                	dec    %ecx
  4004f0:	48 8d 54 0f 01       	lea    0x1(%rdi,%rcx,1),%rdx
  4004f5:	48 89 f8             	mov    %rdi,%rax
			*str++ = ' ';
  4004f8:	48 ff c0             	inc    %rax
  4004fb:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
			tmp[i++] = (digits[__do_div(num, base)] | locase);
	if (i > precision)
		precision = i;
	size -= precision;
	if (!(type & (ZEROPAD + LEFT)))
		while (size-- > 0)
  4004ff:	48 39 d0             	cmp    %rdx,%rax
  400502:	75 f4                	jne    4004f8 <number+0x128>
  400504:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  400509:	89 f6                	mov    %esi,%esi
  40050b:	48 8d 7c 37 01       	lea    0x1(%rdi,%rsi,1),%rdi
  400510:	eb 02                	jmp    400514 <number+0x144>
  400512:	89 f1                	mov    %esi,%ecx
			*str++ = ' ';
	if (sign)
  400514:	80 3c 24 00          	cmpb   $0x0,(%rsp)
  400518:	74 0a                	je     400524 <number+0x154>
		*str++ = sign;
  40051a:	0f b6 04 24          	movzbl (%rsp),%eax
  40051e:	88 07                	mov    %al,(%rdi)
  400520:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
	if (type & SPECIAL) {
  400524:	83 7c 24 01 00       	cmpl   $0x0,0x1(%rsp)
  400529:	74 24                	je     40054f <number+0x17f>
		if (base == 8)
  40052b:	41 83 fe 08          	cmp    $0x8,%r14d
  40052f:	75 09                	jne    40053a <number+0x16a>
			*str++ = '0';
  400531:	c6 07 30             	movb   $0x30,(%rdi)
  400534:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
  400538:	eb 15                	jmp    40054f <number+0x17f>
		else if (base == 16) {
  40053a:	41 83 fe 10          	cmp    $0x10,%r14d
  40053e:	75 0f                	jne    40054f <number+0x17f>
			*str++ = '0';
  400540:	c6 07 30             	movb   $0x30,(%rdi)
			*str++ = ('X' | locase);
  400543:	41 83 cd 58          	or     $0x58,%r13d
  400547:	44 88 6f 01          	mov    %r13b,0x1(%rdi)
  40054b:	48 8d 7f 02          	lea    0x2(%rdi),%rdi
		}
	}
	if (!(type & LEFT))
  40054f:	41 f6 c1 10          	test   $0x10,%r9b
  400553:	75 2d                	jne    400582 <number+0x1b2>
		while (size-- > 0)
  400555:	8d 71 ff             	lea    -0x1(%rcx),%esi
  400558:	85 c9                	test   %ecx,%ecx
  40055a:	7e 24                	jle    400580 <number+0x1b0>
  40055c:	ff c9                	dec    %ecx
  40055e:	48 8d 54 0f 01       	lea    0x1(%rdi,%rcx,1),%rdx
  400563:	48 89 f8             	mov    %rdi,%rax
			*str++ = c;
  400566:	48 ff c0             	inc    %rax
  400569:	44 88 78 ff          	mov    %r15b,-0x1(%rax)
			*str++ = '0';
			*str++ = ('X' | locase);
		}
	}
	if (!(type & LEFT))
		while (size-- > 0)
  40056d:	48 39 d0             	cmp    %rdx,%rax
  400570:	75 f4                	jne    400566 <number+0x196>
  400572:	89 f6                	mov    %esi,%esi
  400574:	48 8d 7c 37 01       	lea    0x1(%rdi,%rsi,1),%rdi
  400579:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  40057e:	eb 02                	jmp    400582 <number+0x1b2>
  400580:	89 f1                	mov    %esi,%ecx
			*str++ = c;
	while (i < precision--)
  400582:	45 39 c4             	cmp    %r8d,%r12d
  400585:	7d 1a                	jge    4005a1 <number+0x1d1>
  400587:	45 29 e0             	sub    %r12d,%r8d
  40058a:	41 8d 40 ff          	lea    -0x1(%r8),%eax
  40058e:	4c 8d 44 07 01       	lea    0x1(%rdi,%rax,1),%r8
		*str++ = '0';
  400593:	48 ff c7             	inc    %rdi
  400596:	c6 47 ff 30          	movb   $0x30,-0x1(%rdi)
		}
	}
	if (!(type & LEFT))
		while (size-- > 0)
			*str++ = c;
	while (i < precision--)
  40059a:	4c 39 c7             	cmp    %r8,%rdi
  40059d:	75 f4                	jne    400593 <number+0x1c3>
  40059f:	eb 03                	jmp    4005a4 <number+0x1d4>
  4005a1:	49 89 f8             	mov    %rdi,%r8
		*str++ = '0';
	while (i-- > 0)
  4005a4:	41 8d 7c 24 ff       	lea    -0x1(%r12),%edi
  4005a9:	45 85 e4             	test   %r12d,%r12d
  4005ac:	7e 21                	jle    4005cf <number+0x1ff>
  4005ae:	4c 89 c2             	mov    %r8,%rdx
  4005b1:	89 f8                	mov    %edi,%eax
		*str++ = tmp[i];
  4005b3:	48 63 f0             	movslq %eax,%rsi
  4005b6:	0f b6 74 34 13       	movzbl 0x13(%rsp,%rsi,1),%esi
  4005bb:	40 88 32             	mov    %sil,(%rdx)
	if (!(type & LEFT))
		while (size-- > 0)
			*str++ = c;
	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
  4005be:	ff c8                	dec    %eax
  4005c0:	48 ff c2             	inc    %rdx
  4005c3:	83 f8 ff             	cmp    $0xffffffff,%eax
  4005c6:	75 eb                	jne    4005b3 <number+0x1e3>
  4005c8:	89 ff                	mov    %edi,%edi
  4005ca:	4d 8d 44 38 01       	lea    0x1(%r8,%rdi,1),%r8
		*str++ = tmp[i];
	while (size-- > 0)
  4005cf:	8d 71 ff             	lea    -0x1(%rcx),%esi
  4005d2:	85 c9                	test   %ecx,%ecx
  4005d4:	7e 26                	jle    4005fc <number+0x22c>
  4005d6:	ff c9                	dec    %ecx
  4005d8:	49 8d 54 08 01       	lea    0x1(%r8,%rcx,1),%rdx
  4005dd:	4c 89 c0             	mov    %r8,%rax
		*str++ = ' ';
  4005e0:	48 ff c0             	inc    %rax
  4005e3:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
			*str++ = c;
	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
		*str++ = tmp[i];
	while (size-- > 0)
  4005e7:	48 39 d0             	cmp    %rdx,%rax
  4005ea:	75 f4                	jne    4005e0 <number+0x210>
  4005ec:	89 f6                	mov    %esi,%esi
		*str++ = ' ';
  4005ee:	49 8d 44 30 01       	lea    0x1(%r8,%rsi,1),%rax
  4005f3:	eb 0a                	jmp    4005ff <number+0x22f>
	 * produces same digits or (maybe lowercased) letters */
	locase = (type & SMALL);
	if (type & LEFT)
		type &= ~ZEROPAD;
	if (base < 2 || base > 16)
		return NULL;
  4005f5:	b8 00 00 00 00       	mov    $0x0,%eax
  4005fa:	eb 03                	jmp    4005ff <number+0x22f>
			*str++ = c;
	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
		*str++ = tmp[i];
	while (size-- > 0)
  4005fc:	4c 89 c0             	mov    %r8,%rax
		*str++ = ' ';
	return str;
}
  4005ff:	48 83 c4 55          	add    $0x55,%rsp
  400603:	5b                   	pop    %rbx
  400604:	5d                   	pop    %rbp
  400605:	41 5c                	pop    %r12
  400607:	41 5d                	pop    %r13
  400609:	41 5e                	pop    %r14
  40060b:	41 5f                	pop    %r15
  40060d:	c3                   	retq   

000000000040060e <skip_atoi>:
n = ((unsigned long) n) / (unsigned) base; \
__res; })


static int skip_atoi(const char **s)
{
  40060e:	55                   	push   %rbp
  40060f:	53                   	push   %rbx
  400610:	48 83 ec 08          	sub    $0x8,%rsp
  400614:	48 89 fd             	mov    %rdi,%rbp
        int i = 0;
  400617:	bb 00 00 00 00       	mov    $0x0,%ebx

        while (isdigit(**s))
  40061c:	eb 1d                	jmp    40063b <skip_atoi+0x2d>
                i = i * 10 + *((*s)++) - '0';
  40061e:	48 8b 45 00          	mov    0x0(%rbp),%rax
  400622:	48 8d 50 01          	lea    0x1(%rax),%rdx
  400626:	48 89 55 00          	mov    %rdx,0x0(%rbp)
  40062a:	8d 14 dd 00 00 00 00 	lea    0x0(,%rbx,8),%edx
  400631:	8d 14 5a             	lea    (%rdx,%rbx,2),%edx
  400634:	0f be 00             	movsbl (%rax),%eax
  400637:	8d 5c 02 d0          	lea    -0x30(%rdx,%rax,1),%ebx

static int skip_atoi(const char **s)
{
        int i = 0;

        while (isdigit(**s))
  40063b:	48 8b 45 00          	mov    0x0(%rbp),%rax
  40063f:	0f be 38             	movsbl (%rax),%edi
  400642:	e8 42 0e 00 00       	callq  401489 <isdigit>
  400647:	85 c0                	test   %eax,%eax
  400649:	75 d3                	jne    40061e <skip_atoi+0x10>
                i = i * 10 + *((*s)++) - '0';
        return i;
}
  40064b:	89 d8                	mov    %ebx,%eax
  40064d:	48 83 c4 08          	add    $0x8,%rsp
  400651:	5b                   	pop    %rbx
  400652:	5d                   	pop    %rbp
  400653:	c3                   	retq   

0000000000400654 <vsprintf>:
	va_end(val);
	return printed;
}

int vsprintf(char *buf, const char *fmt, va_list args)
{
  400654:	41 57                	push   %r15
  400656:	41 56                	push   %r14
  400658:	41 55                	push   %r13
  40065a:	41 54                	push   %r12
  40065c:	55                   	push   %rbp
  40065d:	53                   	push   %rbx
  40065e:	48 83 ec 28          	sub    $0x28,%rsp
  400662:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  400667:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
	int field_width;	/* width of output field */
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L:' for integer fields */

	for (str = buf; *fmt; ++fmt) {
  40066c:	0f b6 06             	movzbl (%rsi),%eax
  40066f:	84 c0                	test   %al,%al
  400671:	0f 84 0d 05 00 00    	je     400b84 <vsprintf+0x530>
  400677:	49 89 d5             	mov    %rdx,%r13
  40067a:	48 89 fb             	mov    %rdi,%rbx

		/* process flags */
		flags = 0;
	      repeat:
		++fmt;		/* this also skips first '%' */
		switch (*fmt) {
  40067d:	4c 8d 25 cc 0f 00 00 	lea    0xfcc(%rip),%r12        # 401650 <atoi+0x163>
		/* get the precision */
		precision = -1;
		if (*fmt == '.') {
			++fmt;
			if (isdigit(*fmt))
				precision = skip_atoi(&fmt);
  400684:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
  400689:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L:' for integer fields */

	for (str = buf; *fmt; ++fmt) {
		if (*fmt != '%') {
  40068e:	bd 00 00 00 00       	mov    $0x0,%ebp
  400693:	3c 25                	cmp    $0x25,%al
  400695:	74 0b                	je     4006a2 <vsprintf+0x4e>
			*str++ = *fmt;
  400697:	88 03                	mov    %al,(%rbx)
  400699:	48 8d 5b 01          	lea    0x1(%rbx),%rbx
			continue;
  40069d:	e9 c6 04 00 00       	jmpq   400b68 <vsprintf+0x514>
		}

		/* process flags */
		flags = 0;
	      repeat:
		++fmt;		/* this also skips first '%' */
  4006a2:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  4006a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  4006ab:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
		switch (*fmt) {
  4006b0:	0f b6 78 01          	movzbl 0x1(%rax),%edi
  4006b4:	8d 47 e0             	lea    -0x20(%rdi),%eax
  4006b7:	3c 10                	cmp    $0x10,%al
  4006b9:	77 27                	ja     4006e2 <vsprintf+0x8e>
  4006bb:	0f b6 c0             	movzbl %al,%eax
  4006be:	49 63 04 84          	movslq (%r12,%rax,4),%rax
  4006c2:	4c 01 e0             	add    %r12,%rax
  4006c5:	ff e0                	jmpq   *%rax
		case '-':
			flags |= LEFT;
  4006c7:	83 cd 10             	or     $0x10,%ebp
			goto repeat;
  4006ca:	eb d6                	jmp    4006a2 <vsprintf+0x4e>
		case '+':
			flags |= PLUS;
  4006cc:	83 cd 04             	or     $0x4,%ebp
			goto repeat;
  4006cf:	eb d1                	jmp    4006a2 <vsprintf+0x4e>
		case ' ':
			flags |= SPACE;
  4006d1:	83 cd 08             	or     $0x8,%ebp
			goto repeat;
  4006d4:	eb cc                	jmp    4006a2 <vsprintf+0x4e>
		case '#':
			flags |= SPECIAL;
  4006d6:	83 cd 40             	or     $0x40,%ebp
			goto repeat;
  4006d9:	eb c7                	jmp    4006a2 <vsprintf+0x4e>
		case '0':
			flags |= ZEROPAD;
  4006db:	83 cd 01             	or     $0x1,%ebp
  4006de:	66 90                	xchg   %ax,%ax
			goto repeat;
  4006e0:	eb c0                	jmp    4006a2 <vsprintf+0x4e>

		/* process flags */
		flags = 0;
	      repeat:
		++fmt;		/* this also skips first '%' */
		switch (*fmt) {
  4006e2:	41 89 ef             	mov    %ebp,%r15d
			goto repeat;
		}
	
		/* get field width */
		field_width = -1;
		if (isdigit(*fmt))
  4006e5:	40 0f be ff          	movsbl %dil,%edi
  4006e9:	e8 9b 0d 00 00       	callq  401489 <isdigit>
  4006ee:	85 c0                	test   %eax,%eax
  4006f0:	74 0f                	je     400701 <vsprintf+0xad>
			field_width = skip_atoi(&fmt);
  4006f2:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  4006f7:	e8 12 ff ff ff       	callq  40060e <skip_atoi>
  4006fc:	41 89 c6             	mov    %eax,%r14d
  4006ff:	eb 4e                	jmp    40074f <vsprintf+0xfb>
		else if (*fmt == '*') {
  400701:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
			flags |= ZEROPAD;
			goto repeat;
		}
	
		/* get field width */
		field_width = -1;
  400706:	41 be ff ff ff ff    	mov    $0xffffffff,%r14d
		if (isdigit(*fmt))
			field_width = skip_atoi(&fmt);
		else if (*fmt == '*') {
  40070c:	80 38 2a             	cmpb   $0x2a,(%rax)
  40070f:	75 3e                	jne    40074f <vsprintf+0xfb>
			++fmt;
  400711:	48 ff c0             	inc    %rax
  400714:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
			/* it's the next argument */
			field_width = va_arg(args, int);
  400719:	41 8b 45 00          	mov    0x0(%r13),%eax
  40071d:	83 f8 30             	cmp    $0x30,%eax
  400720:	73 0f                	jae    400731 <vsprintf+0xdd>
  400722:	89 c2                	mov    %eax,%edx
  400724:	49 03 55 10          	add    0x10(%r13),%rdx
  400728:	83 c0 08             	add    $0x8,%eax
  40072b:	41 89 45 00          	mov    %eax,0x0(%r13)
  40072f:	eb 0c                	jmp    40073d <vsprintf+0xe9>
  400731:	49 8b 55 08          	mov    0x8(%r13),%rdx
  400735:	48 8d 42 08          	lea    0x8(%rdx),%rax
  400739:	49 89 45 08          	mov    %rax,0x8(%r13)
  40073d:	44 8b 32             	mov    (%rdx),%r14d
			if (field_width < 0) {
  400740:	45 85 f6             	test   %r14d,%r14d
  400743:	79 0a                	jns    40074f <vsprintf+0xfb>
				field_width = -field_width;
  400745:	41 f7 de             	neg    %r14d
				flags |= LEFT;
  400748:	41 83 cf 10          	or     $0x10,%r15d
  40074c:	44 89 fd             	mov    %r15d,%ebp
			}
		}

		/* get the precision */
		precision = -1;
		if (*fmt == '.') {
  40074f:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
				flags |= LEFT;
			}
		}

		/* get the precision */
		precision = -1;
  400754:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
		if (*fmt == '.') {
  40075a:	80 38 2e             	cmpb   $0x2e,(%rax)
  40075d:	75 6b                	jne    4007ca <vsprintf+0x176>
			++fmt;
  40075f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  400763:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
			if (isdigit(*fmt))
  400768:	0f be 78 01          	movsbl 0x1(%rax),%edi
  40076c:	e8 18 0d 00 00       	callq  401489 <isdigit>
  400771:	85 c0                	test   %eax,%eax
  400773:	74 0c                	je     400781 <vsprintf+0x12d>
				precision = skip_atoi(&fmt);
  400775:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  40077a:	e8 8f fe ff ff       	callq  40060e <skip_atoi>
  40077f:	eb 3d                	jmp    4007be <vsprintf+0x16a>
			else if (*fmt == '*') {
  400781:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
				flags |= LEFT;
			}
		}

		/* get the precision */
		precision = -1;
  400786:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		if (*fmt == '.') {
			++fmt;
			if (isdigit(*fmt))
				precision = skip_atoi(&fmt);
			else if (*fmt == '*') {
  40078b:	80 3a 2a             	cmpb   $0x2a,(%rdx)
  40078e:	75 2e                	jne    4007be <vsprintf+0x16a>
				++fmt;
  400790:	48 ff c2             	inc    %rdx
  400793:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
				/* it's the next argument */
				precision = va_arg(args, int);
  400798:	41 8b 45 00          	mov    0x0(%r13),%eax
  40079c:	83 f8 30             	cmp    $0x30,%eax
  40079f:	73 0f                	jae    4007b0 <vsprintf+0x15c>
  4007a1:	89 c2                	mov    %eax,%edx
  4007a3:	49 03 55 10          	add    0x10(%r13),%rdx
  4007a7:	83 c0 08             	add    $0x8,%eax
  4007aa:	41 89 45 00          	mov    %eax,0x0(%r13)
  4007ae:	eb 0c                	jmp    4007bc <vsprintf+0x168>
  4007b0:	49 8b 55 08          	mov    0x8(%r13),%rdx
  4007b4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  4007b8:	49 89 45 08          	mov    %rax,0x8(%r13)
  4007bc:	8b 02                	mov    (%rdx),%eax
  4007be:	85 c0                	test   %eax,%eax
  4007c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  4007c6:	44 0f 49 c0          	cmovns %eax,%r8d
				precision = 0;
		}

		/* get the conversion qualifier */
		qualifier = -1;
		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
  4007ca:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  4007cf:	0f b6 02             	movzbl (%rdx),%eax
  4007d2:	3c 68                	cmp    $0x68,%al
  4007d4:	74 10                	je     4007e6 <vsprintf+0x192>
  4007d6:	89 c6                	mov    %eax,%esi
  4007d8:	83 e6 df             	and    $0xffffffdf,%esi
			if (precision < 0)
				precision = 0;
		}

		/* get the conversion qualifier */
		qualifier = -1;
  4007db:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
  4007e0:	40 80 fe 4c          	cmp    $0x4c,%sil
  4007e4:	75 0b                	jne    4007f1 <vsprintf+0x19d>
			qualifier = *fmt;
  4007e6:	0f be c8             	movsbl %al,%ecx
			++fmt;
  4007e9:	48 ff c2             	inc    %rdx
  4007ec:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
		}

		/* default base */
		base = 10;

		switch (*fmt) {
  4007f1:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  4007f6:	0f b6 00             	movzbl (%rax),%eax
  4007f9:	83 e8 25             	sub    $0x25,%eax
  4007fc:	3c 53                	cmp    $0x53,%al
  4007fe:	0f 87 52 02 00 00    	ja     400a56 <vsprintf+0x402>
  400804:	0f b6 c0             	movzbl %al,%eax
  400807:	48 8d 35 86 0e 00 00 	lea    0xe86(%rip),%rsi        # 401694 <atoi+0x1a7>
  40080e:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
  400812:	48 01 f0             	add    %rsi,%rax
  400815:	ff e0                	jmpq   *%rax
		case 'c':
			if (!(flags & LEFT))
  400817:	40 f6 c5 10          	test   $0x10,%bpl
  40081b:	75 34                	jne    400851 <vsprintf+0x1fd>
				while (--field_width > 0)
  40081d:	41 8d 46 ff          	lea    -0x1(%r14),%eax
  400821:	85 c0                	test   %eax,%eax
  400823:	7e 29                	jle    40084e <vsprintf+0x1fa>
  400825:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  400829:	48 8d 54 03 01       	lea    0x1(%rbx,%rax,1),%rdx
  40082e:	48 89 d8             	mov    %rbx,%rax
					*str++ = ' ';
  400831:	48 ff c0             	inc    %rax
  400834:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
		base = 10;

		switch (*fmt) {
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
  400838:	48 39 d0             	cmp    %rdx,%rax
  40083b:	75 f4                	jne    400831 <vsprintf+0x1dd>
  40083d:	41 83 ee 02          	sub    $0x2,%r14d
  400841:	4a 8d 5c 33 01       	lea    0x1(%rbx,%r14,1),%rbx
  400846:	41 be 00 00 00 00    	mov    $0x0,%r14d
  40084c:	eb 03                	jmp    400851 <vsprintf+0x1fd>
  40084e:	41 89 c6             	mov    %eax,%r14d
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
  400851:	48 8d 4b 01          	lea    0x1(%rbx),%rcx
  400855:	41 8b 45 00          	mov    0x0(%r13),%eax
  400859:	83 f8 30             	cmp    $0x30,%eax
  40085c:	73 0f                	jae    40086d <vsprintf+0x219>
  40085e:	89 c2                	mov    %eax,%edx
  400860:	49 03 55 10          	add    0x10(%r13),%rdx
  400864:	83 c0 08             	add    $0x8,%eax
  400867:	41 89 45 00          	mov    %eax,0x0(%r13)
  40086b:	eb 0c                	jmp    400879 <vsprintf+0x225>
  40086d:	49 8b 55 08          	mov    0x8(%r13),%rdx
  400871:	48 8d 42 08          	lea    0x8(%rdx),%rax
  400875:	49 89 45 08          	mov    %rax,0x8(%r13)
  400879:	8b 02                	mov    (%rdx),%eax
  40087b:	88 03                	mov    %al,(%rbx)
			while (--field_width > 0)
  40087d:	41 8d 46 ff          	lea    -0x1(%r14),%eax
  400881:	85 c0                	test   %eax,%eax
  400883:	0f 8e dc 02 00 00    	jle    400b65 <vsprintf+0x511>
  400889:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  40088d:	48 8d 54 03 02       	lea    0x2(%rbx,%rax,1),%rdx
		switch (*fmt) {
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
  400892:	48 89 c8             	mov    %rcx,%rax
			while (--field_width > 0)
				*str++ = ' ';
  400895:	48 ff c0             	inc    %rax
  400898:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
			while (--field_width > 0)
  40089c:	48 39 d0             	cmp    %rdx,%rax
  40089f:	75 f4                	jne    400895 <vsprintf+0x241>
  4008a1:	41 83 ee 02          	sub    $0x2,%r14d
  4008a5:	4a 8d 5c 31 01       	lea    0x1(%rcx,%r14,1),%rbx
  4008aa:	e9 b9 02 00 00       	jmpq   400b68 <vsprintf+0x514>
				*str++ = ' ';
			continue;

		case 's':
			s = va_arg(args, char *);
  4008af:	41 8b 45 00          	mov    0x0(%r13),%eax
  4008b3:	83 f8 30             	cmp    $0x30,%eax
  4008b6:	73 0f                	jae    4008c7 <vsprintf+0x273>
  4008b8:	89 c2                	mov    %eax,%edx
  4008ba:	49 03 55 10          	add    0x10(%r13),%rdx
  4008be:	83 c0 08             	add    $0x8,%eax
  4008c1:	41 89 45 00          	mov    %eax,0x0(%r13)
  4008c5:	eb 0c                	jmp    4008d3 <vsprintf+0x27f>
  4008c7:	49 8b 55 08          	mov    0x8(%r13),%rdx
  4008cb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  4008cf:	49 89 45 08          	mov    %rax,0x8(%r13)
  4008d3:	4c 8b 3a             	mov    (%rdx),%r15
			//len = strnlen(s, precision);
			len = strlen(s);
  4008d6:	4c 89 ff             	mov    %r15,%rdi
  4008d9:	e8 a2 0a 00 00       	callq  401380 <strlen>
  4008de:	89 c6                	mov    %eax,%esi
			if (!(flags & LEFT))
  4008e0:	40 f6 c5 10          	test   $0x10,%bpl
  4008e4:	75 31                	jne    400917 <vsprintf+0x2c3>
				while (len < field_width--)
  4008e6:	41 8d 4e ff          	lea    -0x1(%r14),%ecx
  4008ea:	41 39 c6             	cmp    %eax,%r14d
  4008ed:	7e 25                	jle    400914 <vsprintf+0x2c0>
  4008ef:	44 89 f7             	mov    %r14d,%edi
  4008f2:	41 89 ce             	mov    %ecx,%r14d
  4008f5:	41 29 c6             	sub    %eax,%r14d
  4008f8:	4a 8d 54 33 01       	lea    0x1(%rbx,%r14,1),%rdx
					*str++ = ' ';
  4008fd:	48 ff c3             	inc    %rbx
  400900:	c6 43 ff 20          	movb   $0x20,-0x1(%rbx)
		case 's':
			s = va_arg(args, char *);
			//len = strnlen(s, precision);
			len = strlen(s);
			if (!(flags & LEFT))
				while (len < field_width--)
  400904:	48 39 d3             	cmp    %rdx,%rbx
  400907:	75 f4                	jne    4008fd <vsprintf+0x2a9>
  400909:	29 f9                	sub    %edi,%ecx
  40090b:	44 8d 34 01          	lea    (%rcx,%rax,1),%r14d
					*str++ = ' ';
  40090f:	48 89 d3             	mov    %rdx,%rbx
  400912:	eb 03                	jmp    400917 <vsprintf+0x2c3>
		case 's':
			s = va_arg(args, char *);
			//len = strnlen(s, precision);
			len = strlen(s);
			if (!(flags & LEFT))
				while (len < field_width--)
  400914:	41 89 ce             	mov    %ecx,%r14d
					*str++ = ' ';
			for (i = 0; i < len; ++i)
  400917:	85 c0                	test   %eax,%eax
  400919:	7e 1c                	jle    400937 <vsprintf+0x2e3>
  40091b:	ba 00 00 00 00       	mov    $0x0,%edx
				*str++ = *s++;
  400920:	41 0f b6 0c 17       	movzbl (%r15,%rdx,1),%ecx
  400925:	88 0c 13             	mov    %cl,(%rbx,%rdx,1)
  400928:	48 ff c2             	inc    %rdx
			//len = strnlen(s, precision);
			len = strlen(s);
			if (!(flags & LEFT))
				while (len < field_width--)
					*str++ = ' ';
			for (i = 0; i < len; ++i)
  40092b:	39 d6                	cmp    %edx,%esi
  40092d:	7f f1                	jg     400920 <vsprintf+0x2cc>
  40092f:	8d 50 ff             	lea    -0x1(%rax),%edx
  400932:	48 8d 5c 13 01       	lea    0x1(%rbx,%rdx,1),%rbx
				*str++ = *s++;
			while (len < field_width--)
  400937:	41 39 c6             	cmp    %eax,%r14d
  40093a:	0f 8e 28 02 00 00    	jle    400b68 <vsprintf+0x514>
  400940:	44 89 f6             	mov    %r14d,%esi
  400943:	89 c2                	mov    %eax,%edx
  400945:	f7 d2                	not    %edx
  400947:	41 01 d6             	add    %edx,%r14d
  40094a:	4a 8d 4c 33 01       	lea    0x1(%rbx,%r14,1),%rcx
  40094f:	48 89 da             	mov    %rbx,%rdx
				*str++ = ' ';
  400952:	48 ff c2             	inc    %rdx
  400955:	c6 42 ff 20          	movb   $0x20,-0x1(%rdx)
			if (!(flags & LEFT))
				while (len < field_width--)
					*str++ = ' ';
			for (i = 0; i < len; ++i)
				*str++ = *s++;
			while (len < field_width--)
  400959:	48 39 ca             	cmp    %rcx,%rdx
  40095c:	75 f4                	jne    400952 <vsprintf+0x2fe>
  40095e:	f7 d0                	not    %eax
  400960:	01 f0                	add    %esi,%eax
  400962:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
  400967:	e9 fc 01 00 00       	jmpq   400b68 <vsprintf+0x514>
				*str++ = ' ';
			continue;

		case 'p':
			if (field_width == -1) {
  40096c:	41 83 fe ff          	cmp    $0xffffffff,%r14d
  400970:	75 09                	jne    40097b <vsprintf+0x327>
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
  400972:	83 cd 01             	or     $0x1,%ebp
				*str++ = ' ';
			continue;

		case 'p':
			if (field_width == -1) {
				field_width = 2 * sizeof(void *);
  400975:	41 be 10 00 00 00    	mov    $0x10,%r14d
				flags |= ZEROPAD;
			}
			str = number(str,
				     (unsigned long)va_arg(args, void *), 16,
  40097b:	41 8b 45 00          	mov    0x0(%r13),%eax
  40097f:	83 f8 30             	cmp    $0x30,%eax
  400982:	73 0f                	jae    400993 <vsprintf+0x33f>
  400984:	89 c6                	mov    %eax,%esi
  400986:	49 03 75 10          	add    0x10(%r13),%rsi
  40098a:	83 c0 08             	add    $0x8,%eax
  40098d:	41 89 45 00          	mov    %eax,0x0(%r13)
		case 'p':
			if (field_width == -1) {
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
			}
			str = number(str,
  400991:	eb 0c                	jmp    40099f <vsprintf+0x34b>
				     (unsigned long)va_arg(args, void *), 16,
  400993:	49 8b 75 08          	mov    0x8(%r13),%rsi
  400997:	48 8d 46 08          	lea    0x8(%rsi),%rax
  40099b:	49 89 45 08          	mov    %rax,0x8(%r13)
		case 'p':
			if (field_width == -1) {
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
			}
			str = number(str,
  40099f:	41 89 e9             	mov    %ebp,%r9d
  4009a2:	44 89 f1             	mov    %r14d,%ecx
  4009a5:	ba 10 00 00 00       	mov    $0x10,%edx
  4009aa:	48 8b 36             	mov    (%rsi),%rsi
  4009ad:	48 89 df             	mov    %rbx,%rdi
  4009b0:	e8 1b fa ff ff       	callq  4003d0 <number>
  4009b5:	48 89 c3             	mov    %rax,%rbx
				     (unsigned long)va_arg(args, void *), 16,
				     field_width, precision, flags);
			continue;
  4009b8:	e9 ab 01 00 00       	jmpq   400b68 <vsprintf+0x514>

		case 'n':
			if (qualifier == 'l') {
  4009bd:	83 f9 6c             	cmp    $0x6c,%ecx
  4009c0:	75 37                	jne    4009f9 <vsprintf+0x3a5>
				long *ip = va_arg(args, long *);
  4009c2:	41 8b 45 00          	mov    0x0(%r13),%eax
  4009c6:	83 f8 30             	cmp    $0x30,%eax
  4009c9:	73 0f                	jae    4009da <vsprintf+0x386>
  4009cb:	89 c2                	mov    %eax,%edx
  4009cd:	49 03 55 10          	add    0x10(%r13),%rdx
  4009d1:	83 c0 08             	add    $0x8,%eax
  4009d4:	41 89 45 00          	mov    %eax,0x0(%r13)
  4009d8:	eb 0c                	jmp    4009e6 <vsprintf+0x392>
  4009da:	49 8b 55 08          	mov    0x8(%r13),%rdx
  4009de:	48 8d 42 08          	lea    0x8(%rdx),%rax
  4009e2:	49 89 45 08          	mov    %rax,0x8(%r13)
  4009e6:	48 8b 02             	mov    (%rdx),%rax
				*ip = (str - buf);
  4009e9:	48 89 da             	mov    %rbx,%rdx
  4009ec:	48 2b 54 24 08       	sub    0x8(%rsp),%rdx
  4009f1:	48 89 10             	mov    %rdx,(%rax)
  4009f4:	e9 6f 01 00 00       	jmpq   400b68 <vsprintf+0x514>
			} else {
				int *ip = va_arg(args, int *);
  4009f9:	41 8b 45 00          	mov    0x0(%r13),%eax
  4009fd:	83 f8 30             	cmp    $0x30,%eax
  400a00:	73 0f                	jae    400a11 <vsprintf+0x3bd>
  400a02:	89 c2                	mov    %eax,%edx
  400a04:	49 03 55 10          	add    0x10(%r13),%rdx
  400a08:	83 c0 08             	add    $0x8,%eax
  400a0b:	41 89 45 00          	mov    %eax,0x0(%r13)
  400a0f:	eb 0c                	jmp    400a1d <vsprintf+0x3c9>
  400a11:	49 8b 55 08          	mov    0x8(%r13),%rdx
  400a15:	48 8d 42 08          	lea    0x8(%rdx),%rax
  400a19:	49 89 45 08          	mov    %rax,0x8(%r13)
  400a1d:	48 8b 02             	mov    (%rdx),%rax
				*ip = (str - buf);
  400a20:	48 89 da             	mov    %rbx,%rdx
  400a23:	48 2b 54 24 08       	sub    0x8(%rsp),%rdx
  400a28:	89 10                	mov    %edx,(%rax)
  400a2a:	e9 39 01 00 00       	jmpq   400b68 <vsprintf+0x514>
			}
			continue;

		case '%':
			*str++ = '%';
  400a2f:	c6 03 25             	movb   $0x25,(%rbx)
  400a32:	48 8d 5b 01          	lea    0x1(%rbx),%rbx
			continue;
  400a36:	e9 2d 01 00 00       	jmpq   400b68 <vsprintf+0x514>

			/* integer number formats - set up the flags and "break" */
		case 'o':
			base = 8;
  400a3b:	ba 08 00 00 00       	mov    $0x8,%edx
			break;
  400a40:	eb 4b                	jmp    400a8d <vsprintf+0x439>

		case 'x':
			flags |= SMALL;
  400a42:	83 cd 20             	or     $0x20,%ebp
		case 'X':
			base = 16;
  400a45:	ba 10 00 00 00       	mov    $0x10,%edx
  400a4a:	eb 41                	jmp    400a8d <vsprintf+0x439>
			break;

		case 'd':
		case 'i':
			flags |= SIGN;
  400a4c:	83 cd 02             	or     $0x2,%ebp
			qualifier = *fmt;
			++fmt;
		}

		/* default base */
		base = 10;
  400a4f:	ba 0a 00 00 00       	mov    $0xa,%edx
  400a54:	eb 37                	jmp    400a8d <vsprintf+0x439>
			flags |= SIGN;
		case 'u':
			break;

		default:
			*str++ = '%';
  400a56:	c6 03 25             	movb   $0x25,(%rbx)
			if (*fmt)
  400a59:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  400a5e:	0f b6 10             	movzbl (%rax),%edx
  400a61:	84 d2                	test   %dl,%dl
  400a63:	74 0c                	je     400a71 <vsprintf+0x41d>
				*str++ = *fmt;
  400a65:	88 53 01             	mov    %dl,0x1(%rbx)
  400a68:	48 8d 5b 02          	lea    0x2(%rbx),%rbx
  400a6c:	e9 f7 00 00 00       	jmpq   400b68 <vsprintf+0x514>
			flags |= SIGN;
		case 'u':
			break;

		default:
			*str++ = '%';
  400a71:	48 ff c3             	inc    %rbx
			if (*fmt)
				*str++ = *fmt;
			else
				--fmt;
  400a74:	48 ff c8             	dec    %rax
  400a77:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  400a7c:	e9 e7 00 00 00       	jmpq   400b68 <vsprintf+0x514>
			qualifier = *fmt;
			++fmt;
		}

		/* default base */
		base = 10;
  400a81:	ba 0a 00 00 00       	mov    $0xa,%edx
  400a86:	eb 05                	jmp    400a8d <vsprintf+0x439>
			break;

		case 'x':
			flags |= SMALL;
		case 'X':
			base = 16;
  400a88:	ba 10 00 00 00       	mov    $0x10,%edx
				*str++ = *fmt;
			else
				--fmt;
			continue;
		}
		if (qualifier == 'l')
  400a8d:	83 f9 6c             	cmp    $0x6c,%ecx
  400a90:	75 2c                	jne    400abe <vsprintf+0x46a>
			num = va_arg(args, unsigned long);
  400a92:	41 8b 45 00          	mov    0x0(%r13),%eax
  400a96:	83 f8 30             	cmp    $0x30,%eax
  400a99:	73 0f                	jae    400aaa <vsprintf+0x456>
  400a9b:	89 c1                	mov    %eax,%ecx
  400a9d:	49 03 4d 10          	add    0x10(%r13),%rcx
  400aa1:	83 c0 08             	add    $0x8,%eax
  400aa4:	41 89 45 00          	mov    %eax,0x0(%r13)
  400aa8:	eb 0c                	jmp    400ab6 <vsprintf+0x462>
  400aaa:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  400aae:	48 8d 41 08          	lea    0x8(%rcx),%rax
  400ab2:	49 89 45 08          	mov    %rax,0x8(%r13)
  400ab6:	48 8b 31             	mov    (%rcx),%rsi
  400ab9:	e9 94 00 00 00       	jmpq   400b52 <vsprintf+0x4fe>
		else if (qualifier == 'h') {
  400abe:	83 f9 68             	cmp    $0x68,%ecx
  400ac1:	75 3a                	jne    400afd <vsprintf+0x4a9>
			num = (unsigned short)va_arg(args, int);
  400ac3:	41 8b 45 00          	mov    0x0(%r13),%eax
  400ac7:	83 f8 30             	cmp    $0x30,%eax
  400aca:	73 0f                	jae    400adb <vsprintf+0x487>
  400acc:	89 c1                	mov    %eax,%ecx
  400ace:	49 03 4d 10          	add    0x10(%r13),%rcx
  400ad2:	83 c0 08             	add    $0x8,%eax
  400ad5:	41 89 45 00          	mov    %eax,0x0(%r13)
  400ad9:	eb 0c                	jmp    400ae7 <vsprintf+0x493>
  400adb:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  400adf:	48 8d 41 08          	lea    0x8(%rcx),%rax
  400ae3:	49 89 45 08          	mov    %rax,0x8(%r13)
  400ae7:	8b 01                	mov    (%rcx),%eax
  400ae9:	0f b7 c8             	movzwl %ax,%ecx
  400aec:	48 0f bf c0          	movswq %ax,%rax
  400af0:	40 f6 c5 02          	test   $0x2,%bpl
  400af4:	48 0f 45 c8          	cmovne %rax,%rcx
  400af8:	48 89 ce             	mov    %rcx,%rsi
  400afb:	eb 55                	jmp    400b52 <vsprintf+0x4fe>
			if (flags & SIGN)
				num = (short)num;
		} else if (flags & SIGN)
  400afd:	40 f6 c5 02          	test   $0x2,%bpl
  400b01:	74 29                	je     400b2c <vsprintf+0x4d8>
			num = va_arg(args, int);
  400b03:	41 8b 45 00          	mov    0x0(%r13),%eax
  400b07:	83 f8 30             	cmp    $0x30,%eax
  400b0a:	73 0f                	jae    400b1b <vsprintf+0x4c7>
  400b0c:	89 c1                	mov    %eax,%ecx
  400b0e:	49 03 4d 10          	add    0x10(%r13),%rcx
  400b12:	83 c0 08             	add    $0x8,%eax
  400b15:	41 89 45 00          	mov    %eax,0x0(%r13)
  400b19:	eb 0c                	jmp    400b27 <vsprintf+0x4d3>
  400b1b:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  400b1f:	48 8d 41 08          	lea    0x8(%rcx),%rax
  400b23:	49 89 45 08          	mov    %rax,0x8(%r13)
  400b27:	48 63 31             	movslq (%rcx),%rsi
  400b2a:	eb 26                	jmp    400b52 <vsprintf+0x4fe>
		else
			num = va_arg(args, unsigned int);
  400b2c:	41 8b 45 00          	mov    0x0(%r13),%eax
  400b30:	83 f8 30             	cmp    $0x30,%eax
  400b33:	73 0f                	jae    400b44 <vsprintf+0x4f0>
  400b35:	89 c1                	mov    %eax,%ecx
  400b37:	49 03 4d 10          	add    0x10(%r13),%rcx
  400b3b:	83 c0 08             	add    $0x8,%eax
  400b3e:	41 89 45 00          	mov    %eax,0x0(%r13)
  400b42:	eb 0c                	jmp    400b50 <vsprintf+0x4fc>
  400b44:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  400b48:	48 8d 41 08          	lea    0x8(%rcx),%rax
  400b4c:	49 89 45 08          	mov    %rax,0x8(%r13)
  400b50:	8b 31                	mov    (%rcx),%esi
		str = number(str, num, base, field_width, precision, flags);
  400b52:	41 89 e9             	mov    %ebp,%r9d
  400b55:	44 89 f1             	mov    %r14d,%ecx
  400b58:	48 89 df             	mov    %rbx,%rdi
  400b5b:	e8 70 f8 ff ff       	callq  4003d0 <number>
  400b60:	48 89 c3             	mov    %rax,%rbx
  400b63:	eb 03                	jmp    400b68 <vsprintf+0x514>
		switch (*fmt) {
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
  400b65:	48 89 cb             	mov    %rcx,%rbx
	int field_width;	/* width of output field */
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L:' for integer fields */

	for (str = buf; *fmt; ++fmt) {
  400b68:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  400b6d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  400b71:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  400b76:	0f b6 40 01          	movzbl 0x1(%rax),%eax
  400b7a:	84 c0                	test   %al,%al
  400b7c:	0f 85 0c fb ff ff    	jne    40068e <vsprintf+0x3a>
  400b82:	eb 05                	jmp    400b89 <vsprintf+0x535>
  400b84:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
			num = va_arg(args, int);
		else
			num = va_arg(args, unsigned int);
		str = number(str, num, base, field_width, precision, flags);
	}
	*str = '\0';
  400b89:	c6 03 00             	movb   $0x0,(%rbx)
	return str - buf;
  400b8c:	48 89 d8             	mov    %rbx,%rax
  400b8f:	48 2b 44 24 08       	sub    0x8(%rsp),%rax
}
  400b94:	48 83 c4 28          	add    $0x28,%rsp
  400b98:	5b                   	pop    %rbx
  400b99:	5d                   	pop    %rbp
  400b9a:	41 5c                	pop    %r12
  400b9c:	41 5d                	pop    %r13
  400b9e:	41 5e                	pop    %r14
  400ba0:	41 5f                	pop    %r15
  400ba2:	c3                   	retq   

0000000000400ba3 <printf>:
	return str;
}

//static char printf_buf[1024];

int printf(const char *format, ...) {
  400ba3:	55                   	push   %rbp
  400ba4:	53                   	push   %rbx
  400ba5:	48 81 ec 58 04 00 00 	sub    $0x458,%rsp
  400bac:	48 89 b4 24 28 04 00 	mov    %rsi,0x428(%rsp)
  400bb3:	00 
  400bb4:	48 89 94 24 30 04 00 	mov    %rdx,0x430(%rsp)
  400bbb:	00 
  400bbc:	48 89 8c 24 38 04 00 	mov    %rcx,0x438(%rsp)
  400bc3:	00 
  400bc4:	4c 89 84 24 40 04 00 	mov    %r8,0x440(%rsp)
  400bcb:	00 
  400bcc:	4c 89 8c 24 48 04 00 	mov    %r9,0x448(%rsp)
  400bd3:	00 
  400bd4:	48 89 fe             	mov    %rdi,%rsi
	va_list val;
	int printed = 0;
	char printf_buf[1024];
	//reset(printf_buf,1024);
	va_start(val, format);
  400bd7:	c7 84 24 08 04 00 00 	movl   $0x8,0x408(%rsp)
  400bde:	08 00 00 00 
  400be2:	48 8d 84 24 70 04 00 	lea    0x470(%rsp),%rax
  400be9:	00 
  400bea:	48 89 84 24 10 04 00 	mov    %rax,0x410(%rsp)
  400bf1:	00 
  400bf2:	48 8d 84 24 20 04 00 	lea    0x420(%rsp),%rax
  400bf9:	00 
  400bfa:	48 89 84 24 18 04 00 	mov    %rax,0x418(%rsp)
  400c01:	00 
	printed = vsprintf(printf_buf, format, val);
  400c02:	48 8d 94 24 08 04 00 	lea    0x408(%rsp),%rdx
  400c09:	00 
  400c0a:	48 8d 6c 24 08       	lea    0x8(%rsp),%rbp
  400c0f:	48 89 ef             	mov    %rbp,%rdi
  400c12:	e8 3d fa ff ff       	callq  400654 <vsprintf>
  400c17:	89 c3                	mov    %eax,%ebx
	write(1, printf_buf, printed);
  400c19:	48 63 d0             	movslq %eax,%rdx
  400c1c:	48 89 ee             	mov    %rbp,%rsi
  400c1f:	bf 01 00 00 00       	mov    $0x1,%edi
  400c24:	e8 fa 03 00 00       	callq  401023 <write>
	//write(1, format, printed);
	
	va_end(val);
	return printed;
}
  400c29:	89 d8                	mov    %ebx,%eax
  400c2b:	48 81 c4 58 04 00 00 	add    $0x458,%rsp
  400c32:	5b                   	pop    %rbx
  400c33:	5d                   	pop    %rbp
  400c34:	c3                   	retq   

0000000000400c35 <serror>:
	}
	*str = '\0';
	return str - buf;
}

void serror(int error){
  400c35:	48 83 ec 08          	sub    $0x8,%rsp
    switch(error){
  400c39:	83 ff 28             	cmp    $0x28,%edi
  400c3c:	0f 87 10 02 00 00    	ja     400e52 <serror+0x21d>
  400c42:	89 ff                	mov    %edi,%edi
  400c44:	48 8d 05 99 0b 00 00 	lea    0xb99(%rip),%rax        # 4017e4 <atoi+0x2f7>
  400c4b:	48 63 14 b8          	movslq (%rax,%rdi,4),%rdx
  400c4f:	48 01 d0             	add    %rdx,%rax
  400c52:	ff e0                	jmpq   *%rax
		case EPERM:	 
				printf("operation is not permitted \n");
  400c54:	48 8d 3d 45 0c 00 00 	lea    0xc45(%rip),%rdi        # 4018a0 <digits.1229+0x10>
  400c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  400c60:	e8 3e ff ff ff       	callq  400ba3 <printf>
				break;
  400c65:	e9 f9 01 00 00       	jmpq   400e63 <serror+0x22e>
        case ENOENT : 
				printf("No Such File or directory\n"); 
  400c6a:	48 8d 3d 4c 0c 00 00 	lea    0xc4c(%rip),%rdi        # 4018bd <digits.1229+0x2d>
  400c71:	b8 00 00 00 00       	mov    $0x0,%eax
  400c76:	e8 28 ff ff ff       	callq  400ba3 <printf>
				break;
  400c7b:	e9 e3 01 00 00       	jmpq   400e63 <serror+0x22e>
		case EINTR	:
				printf("Interrupted system call \n");
  400c80:	48 8d 3d 51 0c 00 00 	lea    0xc51(%rip),%rdi        # 4018d8 <digits.1229+0x48>
  400c87:	b8 00 00 00 00       	mov    $0x0,%eax
  400c8c:	e8 12 ff ff ff       	callq  400ba3 <printf>
				break;
  400c91:	e9 cd 01 00 00       	jmpq   400e63 <serror+0x22e>
		case EIO : 
				printf("Input outpur error \n"); 
  400c96:	48 8d 3d 55 0c 00 00 	lea    0xc55(%rip),%rdi        # 4018f2 <digits.1229+0x62>
  400c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  400ca2:	e8 fc fe ff ff       	callq  400ba3 <printf>
				break;
  400ca7:	e9 b7 01 00 00       	jmpq   400e63 <serror+0x22e>
		case E2BIG : 
				printf("Argument list too long \n"); 
  400cac:	48 8d 3d 54 0c 00 00 	lea    0xc54(%rip),%rdi        # 401907 <digits.1229+0x77>
  400cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  400cb8:	e8 e6 fe ff ff       	callq  400ba3 <printf>
				break;	
  400cbd:	e9 a1 01 00 00       	jmpq   400e63 <serror+0x22e>
		case ENOEXEC : 
				printf("Exec format error \n"); 
  400cc2:	48 8d 3d 57 0c 00 00 	lea    0xc57(%rip),%rdi        # 401920 <digits.1229+0x90>
  400cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  400cce:	e8 d0 fe ff ff       	callq  400ba3 <printf>
				break;	
  400cd3:	e9 8b 01 00 00       	jmpq   400e63 <serror+0x22e>
		case EBADF 	 : 
				printf("Bad File number \n"); 
  400cd8:	48 8d 3d 55 0c 00 00 	lea    0xc55(%rip),%rdi        # 401934 <digits.1229+0xa4>
  400cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  400ce4:	e8 ba fe ff ff       	callq  400ba3 <printf>
				break;
  400ce9:	e9 75 01 00 00       	jmpq   400e63 <serror+0x22e>
		case ECHILD : 
				printf("No child process \n"); 
  400cee:	48 8d 3d 51 0c 00 00 	lea    0xc51(%rip),%rdi        # 401946 <digits.1229+0xb6>
  400cf5:	b8 00 00 00 00       	mov    $0x0,%eax
  400cfa:	e8 a4 fe ff ff       	callq  400ba3 <printf>
				break;
  400cff:	e9 5f 01 00 00       	jmpq   400e63 <serror+0x22e>
		case EAGAIN:
				printf("error: try again \n");
  400d04:	48 8d 3d 4e 0c 00 00 	lea    0xc4e(%rip),%rdi        # 401959 <digits.1229+0xc9>
  400d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  400d10:	e8 8e fe ff ff       	callq  400ba3 <printf>
				break;
  400d15:	e9 49 01 00 00       	jmpq   400e63 <serror+0x22e>
        case ENOMEM : 
				printf("Out of memory\n");
  400d1a:	48 8d 3d 4b 0c 00 00 	lea    0xc4b(%rip),%rdi        # 40196c <digits.1229+0xdc>
  400d21:	b8 00 00 00 00       	mov    $0x0,%eax
  400d26:	e8 78 fe ff ff       	callq  400ba3 <printf>
				break;
  400d2b:	e9 33 01 00 00       	jmpq   400e63 <serror+0x22e>
        case EACCES : 
				printf("Permission denied\n"); 
  400d30:	48 8d 3d 44 0c 00 00 	lea    0xc44(%rip),%rdi        # 40197b <digits.1229+0xeb>
  400d37:	b8 00 00 00 00       	mov    $0x0,%eax
  400d3c:	e8 62 fe ff ff       	callq  400ba3 <printf>
				break;
  400d41:	e9 1d 01 00 00       	jmpq   400e63 <serror+0x22e>
		case EFAULT : 
				printf("Bad address \n"); 
  400d46:	48 8d 3d 41 0c 00 00 	lea    0xc41(%rip),%rdi        # 40198e <digits.1229+0xfe>
  400d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  400d52:	e8 4c fe ff ff       	callq  400ba3 <printf>
				break;	
  400d57:	e9 07 01 00 00       	jmpq   400e63 <serror+0x22e>
		case EBUSY	:
				printf("Device or resource busy \n");
  400d5c:	48 8d 3d 39 0c 00 00 	lea    0xc39(%rip),%rdi        # 40199c <digits.1229+0x10c>
  400d63:	b8 00 00 00 00       	mov    $0x0,%eax
  400d68:	e8 36 fe ff ff       	callq  400ba3 <printf>
				break;
  400d6d:	e9 f1 00 00 00       	jmpq   400e63 <serror+0x22e>
		case EEXIST : 
				printf("File exists \n"); 
  400d72:	48 8d 3d 3d 0c 00 00 	lea    0xc3d(%rip),%rdi        # 4019b6 <digits.1229+0x126>
  400d79:	b8 00 00 00 00       	mov    $0x0,%eax
  400d7e:	e8 20 fe ff ff       	callq  400ba3 <printf>
				break;	
  400d83:	e9 db 00 00 00       	jmpq   400e63 <serror+0x22e>
		case ENOTDIR : 
				printf("Not a directory \n"); 
  400d88:	48 8d 3d 35 0c 00 00 	lea    0xc35(%rip),%rdi        # 4019c4 <digits.1229+0x134>
  400d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  400d94:	e8 0a fe ff ff       	callq  400ba3 <printf>
				break;	
  400d99:	e9 c5 00 00 00       	jmpq   400e63 <serror+0x22e>
		case EISDIR : 
				printf("is a directory \n"); 
  400d9e:	48 8d 3d 31 0c 00 00 	lea    0xc31(%rip),%rdi        # 4019d6 <digits.1229+0x146>
  400da5:	b8 00 00 00 00       	mov    $0x0,%eax
  400daa:	e8 f4 fd ff ff       	callq  400ba3 <printf>
				break;	
  400daf:	e9 af 00 00 00       	jmpq   400e63 <serror+0x22e>
		case EINVAL : 
				printf("Invalid Argument \n"); 
  400db4:	48 8d 3d 2c 0c 00 00 	lea    0xc2c(%rip),%rdi        # 4019e7 <digits.1229+0x157>
  400dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  400dc0:	e8 de fd ff ff       	callq  400ba3 <printf>
				break;
  400dc5:	e9 99 00 00 00       	jmpq   400e63 <serror+0x22e>
		case ENFILE	:
				printf("File table overflow \n");
  400dca:	48 8d 3d 29 0c 00 00 	lea    0xc29(%rip),%rdi        # 4019fa <digits.1229+0x16a>
  400dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  400dd6:	e8 c8 fd ff ff       	callq  400ba3 <printf>
				break;
  400ddb:	e9 83 00 00 00       	jmpq   400e63 <serror+0x22e>
		case EMFILE :
				printf("Too many open files \n");
  400de0:	48 8d 3d 29 0c 00 00 	lea    0xc29(%rip),%rdi        # 401a10 <digits.1229+0x180>
  400de7:	b8 00 00 00 00       	mov    $0x0,%eax
  400dec:	e8 b2 fd ff ff       	callq  400ba3 <printf>
				break;
  400df1:	eb 70                	jmp    400e63 <serror+0x22e>
		case EFBIG : 
				printf("File too large \n"); 
  400df3:	48 8d 3d 2c 0c 00 00 	lea    0xc2c(%rip),%rdi        # 401a26 <digits.1229+0x196>
  400dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  400dff:	e8 9f fd ff ff       	callq  400ba3 <printf>
				break;
  400e04:	eb 5d                	jmp    400e63 <serror+0x22e>
        case EROFS : 
				printf("Read-only file system\n"); 
  400e06:	48 8d 3d 2a 0c 00 00 	lea    0xc2a(%rip),%rdi        # 401a37 <digits.1229+0x1a7>
  400e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  400e12:	e8 8c fd ff ff       	callq  400ba3 <printf>
				break;
  400e17:	eb 4a                	jmp    400e63 <serror+0x22e>
		case ELOOP:
				printf("Too many symbolic links encountered \n");
  400e19:	48 8d 3d 58 0c 00 00 	lea    0xc58(%rip),%rdi        # 401a78 <digits.1229+0x1e8>
  400e20:	b8 00 00 00 00       	mov    $0x0,%eax
  400e25:	e8 79 fd ff ff       	callq  400ba3 <printf>
				break;
  400e2a:	eb 37                	jmp    400e63 <serror+0x22e>
		case EPIPE: 
				printf("Broken pipe \n"); 
  400e2c:	48 8d 3d 1b 0c 00 00 	lea    0xc1b(%rip),%rdi        # 401a4e <digits.1229+0x1be>
  400e33:	b8 00 00 00 00       	mov    $0x0,%eax
  400e38:	e8 66 fd ff ff       	callq  400ba3 <printf>
				break;
  400e3d:	eb 24                	jmp    400e63 <serror+0x22e>
		case ENAMETOOLONG : 
				printf("File name too long \n"); 
  400e3f:	48 8d 3d 16 0c 00 00 	lea    0xc16(%rip),%rdi        # 401a5c <digits.1229+0x1cc>
  400e46:	b8 00 00 00 00       	mov    $0x0,%eax
  400e4b:	e8 53 fd ff ff       	callq  400ba3 <printf>
				break;	
  400e50:	eb 11                	jmp    400e63 <serror+0x22e>
        default : 
			printf("Error in Opening or Executing\n");
  400e52:	48 8d 3d 47 0c 00 00 	lea    0xc47(%rip),%rdi        # 401aa0 <digits.1229+0x210>
  400e59:	b8 00 00 00 00       	mov    $0x0,%eax
  400e5e:	e8 40 fd ff ff       	callq  400ba3 <printf>
		
    }
  400e63:	48 83 c4 08          	add    $0x8,%rsp
  400e67:	c3                   	retq   

0000000000400e68 <exit>:
#include <error.h>

//static void *breakPtr;
__thread int errno;
/*working*/
void exit(int status){
  400e68:	53                   	push   %rbx
    syscall_1(SYS_exit, status);
  400e69:	48 63 df             	movslq %edi,%rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  400e6c:	b8 3c 00 00 00       	mov    $0x3c,%eax
  400e71:	48 89 c0             	mov    %rax,%rax
  400e74:	48 89 df             	mov    %rbx,%rdi
  400e77:	cd 80                	int    $0x80
  400e79:	48 89 c0             	mov    %rax,%rax
}
  400e7c:	5b                   	pop    %rbx
  400e7d:	c3                   	retq   

0000000000400e7e <brk>:
/*working*/
uint64_t brk(void *end_data_segment){
  400e7e:	53                   	push   %rbx
  400e7f:	b8 0c 00 00 00       	mov    $0xc,%eax
  400e84:	48 89 fb             	mov    %rdi,%rbx
  400e87:	48 89 c0             	mov    %rax,%rax
  400e8a:	48 89 df             	mov    %rbx,%rdi
  400e8d:	cd 80                	int    $0x80
  400e8f:	48 89 c0             	mov    %rax,%rax
    return syscall_1(SYS_brk, (uint64_t)end_data_segment);
}
  400e92:	5b                   	pop    %rbx
  400e93:	c3                   	retq   

0000000000400e94 <sbrk>:

/*working*/
/*working*/
void *sbrk(size_t increment){
  400e94:	55                   	push   %rbp
  400e95:	53                   	push   %rbx
  400e96:	48 83 ec 08          	sub    $0x8,%rsp
  400e9a:	48 89 fd             	mov    %rdi,%rbp
	void *breakPtr;
	//if(breakPtr == NULL)
	//printf("size %p \n", increment);
	breakPtr = (void *)((uint64_t)brk(0));
  400e9d:	bf 00 00 00 00       	mov    $0x0,%edi
  400ea2:	e8 d7 ff ff ff       	callq  400e7e <brk>
  400ea7:	48 89 c3             	mov    %rax,%rbx
	if(increment == 0)
  400eaa:	48 85 ed             	test   %rbp,%rbp
  400ead:	74 09                	je     400eb8 <sbrk+0x24>
	{
		return breakPtr;
	}
	void *startAddr = breakPtr;
	breakPtr = breakPtr+increment;
  400eaf:	48 8d 3c 28          	lea    (%rax,%rbp,1),%rdi
	brk(breakPtr);
  400eb3:	e8 c6 ff ff ff       	callq  400e7e <brk>
    return startAddr;
}
  400eb8:	48 89 d8             	mov    %rbx,%rax
  400ebb:	48 83 c4 08          	add    $0x8,%rsp
  400ebf:	5b                   	pop    %rbx
  400ec0:	5d                   	pop    %rbp
  400ec1:	c3                   	retq   

0000000000400ec2 <fork>:

//#define T_SYSCALL               0x80       /* System call */

static __inline uint64_t syscall_0(uint64_t n) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  400ec2:	ba 39 00 00 00       	mov    $0x39,%edx
  400ec7:	48 89 d0             	mov    %rdx,%rax
  400eca:	cd 80                	int    $0x80
  400ecc:	48 89 c2             	mov    %rax,%rdx
	if((int)res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
  400ecf:	89 d0                	mov    %edx,%eax
}

/*working*/
pid_t fork(){
    uint32_t res = syscall_0(SYS_fork);
	if((int)res < 0)
  400ed1:	85 d2                	test   %edx,%edx
  400ed3:	79 10                	jns    400ee5 <fork+0x23>
	{
		errno = -res;
  400ed5:	f7 da                	neg    %edx
  400ed7:	48 8b 05 4a 15 20 00 	mov    0x20154a(%rip),%rax        # 602428 <digits.1229+0x200b98>
  400ede:	89 10                	mov    %edx,(%rax)
		return -1;
  400ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400ee5:	f3 c3                	repz retq 

0000000000400ee7 <getpid>:
  400ee7:	b8 27 00 00 00       	mov    $0x27,%eax
  400eec:	48 89 c0             	mov    %rax,%rax
  400eef:	cd 80                	int    $0x80
  400ef1:	48 89 c0             	mov    %rax,%rax

/*this method doesnt throw error always successful*/
pid_t getpid(){
    uint32_t res = syscall_0(SYS_getpid);
    return res;
}
  400ef4:	c3                   	retq   

0000000000400ef5 <getppid>:
  400ef5:	b8 6e 00 00 00       	mov    $0x6e,%eax
  400efa:	48 89 c0             	mov    %rax,%rax
  400efd:	cd 80                	int    $0x80
  400eff:	48 89 c0             	mov    %rax,%rax
/*working*/
pid_t getppid(){
    uint32_t res = syscall_0(SYS_getppid);
    return res;
}
  400f02:	c3                   	retq   

0000000000400f03 <execve>:
/*wrokig*/
int execve(const char *filename, char *const argv[], char *const envp[]){
  400f03:	53                   	push   %rbx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  400f04:	b8 3b 00 00 00       	mov    $0x3b,%eax
  400f09:	48 89 fb             	mov    %rdi,%rbx
  400f0c:	48 89 f1             	mov    %rsi,%rcx
  400f0f:	48 89 c0             	mov    %rax,%rax
  400f12:	48 89 df             	mov    %rbx,%rdi
  400f15:	48 89 ce             	mov    %rcx,%rsi
  400f18:	48 89 d2             	mov    %rdx,%rdx
  400f1b:	cd 80                	int    $0x80
  400f1d:	48 89 c0             	mov    %rax,%rax
  400f20:	48 89 c2             	mov    %rax,%rdx
    uint64_t res = syscall_3(SYS_execve, (uint64_t)filename, (uint64_t)argv, (uint64_t)envp);
	if((int)res < 0)
  400f23:	85 d2                	test   %edx,%edx
  400f25:	79 10                	jns    400f37 <execve+0x34>
	{
		errno = -res;
  400f27:	f7 da                	neg    %edx
  400f29:	48 8b 05 f8 14 20 00 	mov    0x2014f8(%rip),%rax        # 602428 <digits.1229+0x200b98>
  400f30:	89 10                	mov    %edx,(%rax)
		return -1;
  400f32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400f37:	5b                   	pop    %rbx
  400f38:	c3                   	retq   

0000000000400f39 <sleep>:

unsigned int sleep(unsigned int seconds){
  400f39:	53                   	push   %rbx
    unsigned int res = syscall_1(SYS_nanosleep, seconds);
  400f3a:	89 fb                	mov    %edi,%ebx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  400f3c:	b8 23 00 00 00       	mov    $0x23,%eax
  400f41:	48 89 c0             	mov    %rax,%rax
  400f44:	48 89 df             	mov    %rbx,%rdi
  400f47:	cd 80                	int    $0x80
  400f49:	48 89 c0             	mov    %rax,%rax
    return res;
}
  400f4c:	5b                   	pop    %rbx
  400f4d:	c3                   	retq   

0000000000400f4e <alarm>:

unsigned int alarm(unsigned int seconds){
  400f4e:	53                   	push   %rbx
    unsigned int res = syscall_1(SYS_alarm, seconds);
  400f4f:	89 fb                	mov    %edi,%ebx
  400f51:	b8 25 00 00 00       	mov    $0x25,%eax
  400f56:	48 89 c0             	mov    %rax,%rax
  400f59:	48 89 df             	mov    %rbx,%rdi
  400f5c:	cd 80                	int    $0x80
  400f5e:	48 89 c0             	mov    %rax,%rax
    return res;
}
  400f61:	5b                   	pop    %rbx
  400f62:	c3                   	retq   

0000000000400f63 <getcwd>:
/*working*/
char *getcwd(char *buf, size_t size){
  400f63:	53                   	push   %rbx
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  400f64:	b8 4f 00 00 00       	mov    $0x4f,%eax
  400f69:	48 89 fb             	mov    %rdi,%rbx
  400f6c:	48 89 f1             	mov    %rsi,%rcx
  400f6f:	48 89 c0             	mov    %rax,%rax
  400f72:	48 89 df             	mov    %rbx,%rdi
  400f75:	48 89 ce             	mov    %rcx,%rsi
  400f78:	cd 80                	int    $0x80
  400f7a:	48 89 c0             	mov    %rax,%rax
    uint64_t res = syscall_2(SYS_getcwd, (uint64_t) buf, (uint64_t) size);
	if((char *)res == NULL)
  400f7d:	48 85 c0             	test   %rax,%rax
  400f80:	75 0d                	jne    400f8f <getcwd+0x2c>
	{
		errno = EFAULT;
  400f82:	48 8b 15 9f 14 20 00 	mov    0x20149f(%rip),%rdx        # 602428 <digits.1229+0x200b98>
  400f89:	c7 02 0e 00 00 00    	movl   $0xe,(%rdx)
	}
    return (char *)res;
}
  400f8f:	5b                   	pop    %rbx
  400f90:	c3                   	retq   

0000000000400f91 <chdir>:
/*working*/ 
int chdir(const char *path){
  400f91:	53                   	push   %rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  400f92:	b8 50 00 00 00       	mov    $0x50,%eax
  400f97:	48 89 fb             	mov    %rdi,%rbx
  400f9a:	48 89 c0             	mov    %rax,%rax
  400f9d:	48 89 df             	mov    %rbx,%rdi
  400fa0:	cd 80                	int    $0x80
  400fa2:	48 89 c0             	mov    %rax,%rax
    int res = syscall_1(SYS_chdir, (uint64_t)path);
	if(res < 0)
  400fa5:	85 c0                	test   %eax,%eax
  400fa7:	79 10                	jns    400fb9 <chdir+0x28>
	{
		errno = -res;
  400fa9:	f7 d8                	neg    %eax
  400fab:	48 8b 15 76 14 20 00 	mov    0x201476(%rip),%rdx        # 602428 <digits.1229+0x200b98>
  400fb2:	89 02                	mov    %eax,(%rdx)
		return -1;
  400fb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400fb9:	5b                   	pop    %rbx
  400fba:	c3                   	retq   

0000000000400fbb <open>:
/*working*/    
int open(const char *pathname, int flags){
  400fbb:	53                   	push   %rbx
    uint64_t res = syscall_2(SYS_open, (uint64_t) pathname, (uint64_t) flags);
  400fbc:	48 63 ce             	movslq %esi,%rcx
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  400fbf:	b8 02 00 00 00       	mov    $0x2,%eax
  400fc4:	48 89 fb             	mov    %rdi,%rbx
  400fc7:	48 89 c0             	mov    %rax,%rax
  400fca:	48 89 df             	mov    %rbx,%rdi
  400fcd:	48 89 ce             	mov    %rcx,%rsi
  400fd0:	cd 80                	int    $0x80
  400fd2:	48 89 c0             	mov    %rax,%rax
  400fd5:	48 89 c1             	mov    %rax,%rcx
	if((int)res < 0)
  400fd8:	85 c9                	test   %ecx,%ecx
  400fda:	79 10                	jns    400fec <open+0x31>
	{
		errno = -res;
  400fdc:	f7 d9                	neg    %ecx
  400fde:	48 8b 05 43 14 20 00 	mov    0x201443(%rip),%rax        # 602428 <digits.1229+0x200b98>
  400fe5:	89 08                	mov    %ecx,(%rax)
		return -1;
  400fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400fec:	5b                   	pop    %rbx
  400fed:	c3                   	retq   

0000000000400fee <read>:

/*working*/
ssize_t read(int fd, void *buf, size_t count){
  400fee:	53                   	push   %rbx
    ssize_t res = syscall_3(SYS_read, (uint64_t) fd, (uint64_t) buf, (uint64_t) count);
  400fef:	48 63 df             	movslq %edi,%rbx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  400ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  400ff7:	48 89 f1             	mov    %rsi,%rcx
  400ffa:	48 89 c0             	mov    %rax,%rax
  400ffd:	48 89 df             	mov    %rbx,%rdi
  401000:	48 89 ce             	mov    %rcx,%rsi
  401003:	48 89 d2             	mov    %rdx,%rdx
  401006:	cd 80                	int    $0x80
  401008:	48 89 c0             	mov    %rax,%rax
	if((int)res < 0)
  40100b:	85 c0                	test   %eax,%eax
  40100d:	79 12                	jns    401021 <read+0x33>
	{
		errno = -res;
  40100f:	f7 d8                	neg    %eax
  401011:	48 8b 15 10 14 20 00 	mov    0x201410(%rip),%rdx        # 602428 <digits.1229+0x200b98>
  401018:	89 02                	mov    %eax,(%rdx)
		return -1;
  40101a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
	}
    return res;
}
  401021:	5b                   	pop    %rbx
  401022:	c3                   	retq   

0000000000401023 <write>:

/*working*/
ssize_t write(int fd, const void *buf, size_t count){
  401023:	53                   	push   %rbx
    ssize_t res = syscall_3(SYS_write, (uint64_t) fd, (uint64_t) buf, (uint64_t) count);
  401024:	48 63 df             	movslq %edi,%rbx
  401027:	b8 01 00 00 00       	mov    $0x1,%eax
  40102c:	48 89 f1             	mov    %rsi,%rcx
  40102f:	48 89 c0             	mov    %rax,%rax
  401032:	48 89 df             	mov    %rbx,%rdi
  401035:	48 89 ce             	mov    %rcx,%rsi
  401038:	48 89 d2             	mov    %rdx,%rdx
  40103b:	cd 80                	int    $0x80
  40103d:	48 89 c0             	mov    %rax,%rax
	if((int)res < 0)
  401040:	85 c0                	test   %eax,%eax
  401042:	79 12                	jns    401056 <write+0x33>
	{
		errno = -res;
  401044:	f7 d8                	neg    %eax
  401046:	48 8b 15 db 13 20 00 	mov    0x2013db(%rip),%rdx        # 602428 <digits.1229+0x200b98>
  40104d:	89 02                	mov    %eax,(%rdx)
		return -1;
  40104f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
	}
    return res; 
}
  401056:	5b                   	pop    %rbx
  401057:	c3                   	retq   

0000000000401058 <lseek>:

off_t lseek(int fildes, off_t offset, int whence){
  401058:	53                   	push   %rbx
    off_t res = syscall_3(SYS_lseek, (uint64_t) fildes, (uint64_t) offset, (uint64_t) whence);
  401059:	48 63 df             	movslq %edi,%rbx
  40105c:	48 63 d2             	movslq %edx,%rdx
  40105f:	b8 08 00 00 00       	mov    $0x8,%eax
  401064:	48 89 f1             	mov    %rsi,%rcx
  401067:	48 89 c0             	mov    %rax,%rax
  40106a:	48 89 df             	mov    %rbx,%rdi
  40106d:	48 89 ce             	mov    %rcx,%rsi
  401070:	48 89 d2             	mov    %rdx,%rdx
  401073:	cd 80                	int    $0x80
  401075:	48 89 c0             	mov    %rax,%rax
  401078:	48 89 c2             	mov    %rax,%rdx
	if((int)res < 0)
  40107b:	85 d2                	test   %edx,%edx
  40107d:	79 12                	jns    401091 <lseek+0x39>
	{
		errno = -res;
  40107f:	f7 da                	neg    %edx
  401081:	48 8b 05 a0 13 20 00 	mov    0x2013a0(%rip),%rax        # 602428 <digits.1229+0x200b98>
  401088:	89 10                	mov    %edx,(%rax)
		return -1;
  40108a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
	}
    return res;
}
  401091:	5b                   	pop    %rbx
  401092:	c3                   	retq   

0000000000401093 <close>:
/*working*/
int close(int fd){
  401093:	53                   	push   %rbx
    int res = syscall_1(SYS_close, fd);
  401094:	48 63 df             	movslq %edi,%rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  401097:	b8 03 00 00 00       	mov    $0x3,%eax
  40109c:	48 89 c0             	mov    %rax,%rax
  40109f:	48 89 df             	mov    %rbx,%rdi
  4010a2:	cd 80                	int    $0x80
  4010a4:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  4010a7:	85 c0                	test   %eax,%eax
  4010a9:	79 10                	jns    4010bb <close+0x28>
	{
		errno = -res;
  4010ab:	f7 d8                	neg    %eax
  4010ad:	48 8b 15 74 13 20 00 	mov    0x201374(%rip),%rdx        # 602428 <digits.1229+0x200b98>
  4010b4:	89 02                	mov    %eax,(%rdx)
		return -1;
  4010b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  4010bb:	5b                   	pop    %rbx
  4010bc:	c3                   	retq   

00000000004010bd <pipe>:
/*working*/
int pipe(int filedes[2]){
  4010bd:	53                   	push   %rbx
  4010be:	b8 16 00 00 00       	mov    $0x16,%eax
  4010c3:	48 89 fb             	mov    %rdi,%rbx
  4010c6:	48 89 c0             	mov    %rax,%rax
  4010c9:	48 89 df             	mov    %rbx,%rdi
  4010cc:	cd 80                	int    $0x80
  4010ce:	48 89 c0             	mov    %rax,%rax
    int res = syscall_1(SYS_pipe, (uint64_t)filedes);
	if(res < 0)
  4010d1:	85 c0                	test   %eax,%eax
  4010d3:	79 10                	jns    4010e5 <pipe+0x28>
	{
		errno = -res;
  4010d5:	f7 d8                	neg    %eax
  4010d7:	48 8b 15 4a 13 20 00 	mov    0x20134a(%rip),%rdx        # 602428 <digits.1229+0x200b98>
  4010de:	89 02                	mov    %eax,(%rdx)
		return -1;
  4010e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  4010e5:	5b                   	pop    %rbx
  4010e6:	c3                   	retq   

00000000004010e7 <dup>:

int dup(int oldfd){
  4010e7:	53                   	push   %rbx
    int res = syscall_1(SYS_dup,oldfd);
  4010e8:	48 63 df             	movslq %edi,%rbx
  4010eb:	b8 20 00 00 00       	mov    $0x20,%eax
  4010f0:	48 89 c0             	mov    %rax,%rax
  4010f3:	48 89 df             	mov    %rbx,%rdi
  4010f6:	cd 80                	int    $0x80
  4010f8:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  4010fb:	85 c0                	test   %eax,%eax
  4010fd:	79 10                	jns    40110f <dup+0x28>
	{
		errno = -res;
  4010ff:	f7 d8                	neg    %eax
  401101:	48 8b 15 20 13 20 00 	mov    0x201320(%rip),%rdx        # 602428 <digits.1229+0x200b98>
  401108:	89 02                	mov    %eax,(%rdx)
		return -1;
  40110a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  40110f:	5b                   	pop    %rbx
  401110:	c3                   	retq   

0000000000401111 <dup2>:

int dup2(int oldfd, int newfd){
  401111:	53                   	push   %rbx
    int res = syscall_2(SYS_dup2, (uint64_t) oldfd, (uint64_t) newfd);
  401112:	48 63 df             	movslq %edi,%rbx
  401115:	48 63 ce             	movslq %esi,%rcx
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  401118:	b8 21 00 00 00       	mov    $0x21,%eax
  40111d:	48 89 c0             	mov    %rax,%rax
  401120:	48 89 df             	mov    %rbx,%rdi
  401123:	48 89 ce             	mov    %rcx,%rsi
  401126:	cd 80                	int    $0x80
  401128:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  40112b:	85 c0                	test   %eax,%eax
  40112d:	79 10                	jns    40113f <dup2+0x2e>
	{
		errno = -res;
  40112f:	f7 d8                	neg    %eax
  401131:	48 8b 15 f0 12 20 00 	mov    0x2012f0(%rip),%rdx        # 602428 <digits.1229+0x200b98>
  401138:	89 02                	mov    %eax,(%rdx)
		return -1;
  40113a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  40113f:	5b                   	pop    %rbx
  401140:	c3                   	retq   

0000000000401141 <opendir>:

void *opendir(const char *name){
  401141:	53                   	push   %rbx
  401142:	48 81 ec 00 04 00 00 	sub    $0x400,%rsp
	int fd = open(name, O_DIRECTORY);
  401149:	be 00 00 01 00       	mov    $0x10000,%esi
  40114e:	e8 68 fe ff ff       	callq  400fbb <open>
	char buf[1024];
	//struct dirent *d = NULL;
	if(fd < 0)
  401153:	85 c0                	test   %eax,%eax
  401155:	0f 88 d1 00 00 00    	js     40122c <opendir+0xeb>
		return NULL;
	//static struct dirent dp;
	//printf("sashi 1 \n");
	uint64_t res = syscall_3(SYS_getdents, (uint64_t)fd, (uint64_t)buf, (uint64_t)sizeof(struct File));
  40115b:	48 63 d8             	movslq %eax,%rbx
  40115e:	48 89 e1             	mov    %rsp,%rcx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  401161:	ba 30 04 00 00       	mov    $0x430,%edx
  401166:	b8 4e 00 00 00       	mov    $0x4e,%eax
  40116b:	48 89 c0             	mov    %rax,%rax
  40116e:	48 89 df             	mov    %rbx,%rdi
  401171:	48 89 ce             	mov    %rcx,%rsi
  401174:	48 89 d2             	mov    %rdx,%rdx
  401177:	cd 80                	int    $0x80
  401179:	48 89 c0             	mov    %rax,%rax
	struct File *f = (struct File *)buf;
	printf("inside opendir name %s\n",f->name);
  40117c:	48 89 e6             	mov    %rsp,%rsi
  40117f:	48 8d 3d 3a 09 00 00 	lea    0x93a(%rip),%rdi        # 401ac0 <digits.1229+0x230>
  401186:	b8 00 00 00 00       	mov    $0x0,%eax
  40118b:	e8 13 fa ff ff       	callq  400ba3 <printf>
	printf("inside opendir fd %d\n",f->fd);
  401190:	48 8b b4 24 00 04 00 	mov    0x400(%rsp),%rsi
  401197:	00 
  401198:	48 8d 3d 39 09 00 00 	lea    0x939(%rip),%rdi        # 401ad8 <digits.1229+0x248>
  40119f:	b8 00 00 00 00       	mov    $0x0,%eax
  4011a4:	e8 fa f9 ff ff       	callq  400ba3 <printf>
	printf("inside opendir addr %p\n",f->addr);
  4011a9:	48 8b b4 24 08 04 00 	mov    0x408(%rsp),%rsi
  4011b0:	00 
  4011b1:	48 8d 3d 36 09 00 00 	lea    0x936(%rip),%rdi        # 401aee <digits.1229+0x25e>
  4011b8:	b8 00 00 00 00       	mov    $0x0,%eax
  4011bd:	e8 e1 f9 ff ff       	callq  400ba3 <printf>
	printf("inside opendir size %d\n",f->size);
  4011c2:	48 8b b4 24 18 04 00 	mov    0x418(%rsp),%rsi
  4011c9:	00 
  4011ca:	48 8d 3d 35 09 00 00 	lea    0x935(%rip),%rdi        # 401b06 <digits.1229+0x276>
  4011d1:	b8 00 00 00 00       	mov    $0x0,%eax
  4011d6:	e8 c8 f9 ff ff       	callq  400ba3 <printf>
	printf("inside opendir offset %d\n",f->offset);
  4011db:	48 8b b4 24 20 04 00 	mov    0x420(%rsp),%rsi
  4011e2:	00 
  4011e3:	48 8d 3d 34 09 00 00 	lea    0x934(%rip),%rdi        # 401b1e <digits.1229+0x28e>
  4011ea:	b8 00 00 00 00       	mov    $0x0,%eax
  4011ef:	e8 af f9 ff ff       	callq  400ba3 <printf>
	printf("End of opendir\n");
  4011f4:	48 8d 3d 3d 09 00 00 	lea    0x93d(%rip),%rdi        # 401b38 <digits.1229+0x2a8>
  4011fb:	b8 00 00 00 00       	mov    $0x0,%eax
  401200:	e8 9e f9 ff ff       	callq  400ba3 <printf>
	if(res < 0)
	{
		errno = -res;	
		return NULL;
	}
	printf("shashi1 \n");
  401205:	48 8d 3d 3c 09 00 00 	lea    0x93c(%rip),%rdi        # 401b48 <digits.1229+0x2b8>
  40120c:	b8 00 00 00 00       	mov    $0x0,%eax
  401211:	e8 8d f9 ff ff       	callq  400ba3 <printf>
	printf("shashi2 \n");
  401216:	48 8d 3d 35 09 00 00 	lea    0x935(%rip),%rdi        # 401b52 <digits.1229+0x2c2>
  40121d:	b8 00 00 00 00       	mov    $0x0,%eax
  401222:	e8 7c f9 ff ff       	callq  400ba3 <printf>
	//d->addr = (void *)res;
	//printf("sashi 1 \n");
	//strcpy(d->d_name, name);
	//printf("sashi 2 \n");
	//d = (struct dirent *)buf;
    return (void *)f;
  401227:	48 89 e0             	mov    %rsp,%rax
  40122a:	eb 05                	jmp    401231 <opendir+0xf0>
void *opendir(const char *name){
	int fd = open(name, O_DIRECTORY);
	char buf[1024];
	//struct dirent *d = NULL;
	if(fd < 0)
		return NULL;
  40122c:	b8 00 00 00 00       	mov    $0x0,%eax
	//printf("sashi 1 \n");
	//strcpy(d->d_name, name);
	//printf("sashi 2 \n");
	//d = (struct dirent *)buf;
    return (void *)f;
}
  401231:	48 81 c4 00 04 00 00 	add    $0x400,%rsp
  401238:	5b                   	pop    %rbx
  401239:	c3                   	retq   

000000000040123a <readdir>:
	d = (struct dirent *)buf;
    return (void *)d;
}
*/
void readdir(void *dir)
{
  40123a:	53                   	push   %rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  40123b:	48 8b 5f 08          	mov    0x8(%rdi),%rbx
  40123f:	b8 51 00 00 00       	mov    $0x51,%eax
  401244:	48 89 c0             	mov    %rax,%rax
  401247:	48 89 df             	mov    %rbx,%rdi
  40124a:	cd 80                	int    $0x80
  40124c:	48 89 c0             	mov    %rax,%rax
	struct dirent *next;
	next = (struct dirent *)(dir + dip->d_reclen);
	if(next->d_reclen == 0)
		return NULL;
	return next; */
}
  40124f:	5b                   	pop    %rbx
  401250:	c3                   	retq   

0000000000401251 <closedir>:

int closedir(void *dir){
  401251:	55                   	push   %rbp
  401252:	53                   	push   %rbx
  401253:	48 83 ec 08          	sub    $0x8,%rsp
  401257:	48 89 fb             	mov    %rdi,%rbx
	struct dir *dp = (struct dir *)dir;
	int res = -1;
	if(dp != NULL)
  40125a:	48 85 ff             	test   %rdi,%rdi
  40125d:	74 13                	je     401272 <closedir+0x21>
	{	
		res = close(dp->fd);
  40125f:	8b 3f                	mov    (%rdi),%edi
  401261:	e8 2d fe ff ff       	callq  401093 <close>
  401266:	89 c5                	mov    %eax,%ebp
		free(dp);
  401268:	48 89 df             	mov    %rbx,%rdi
  40126b:	e8 60 f0 ff ff       	callq  4002d0 <free>
  401270:	eb 05                	jmp    401277 <closedir+0x26>
	return next; */
}

int closedir(void *dir){
	struct dir *dp = (struct dir *)dir;
	int res = -1;
  401272:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
	{	
		res = close(dp->fd);
		free(dp);
	}
	return res;
}
  401277:	89 e8                	mov    %ebp,%eax
  401279:	48 83 c4 08          	add    $0x8,%rsp
  40127d:	5b                   	pop    %rbx
  40127e:	5d                   	pop    %rbp
  40127f:	c3                   	retq   

0000000000401280 <waitpid>:

/*working*/
pid_t waitpid(pid_t pid,int *status, int options){
  401280:	53                   	push   %rbx
    pid_t res = syscall_3(SYS_wait4,(uint64_t)pid,(uint64_t)status,(uint64_t)options);
  401281:	89 fb                	mov    %edi,%ebx
  401283:	48 63 d2             	movslq %edx,%rdx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  401286:	b8 3d 00 00 00       	mov    $0x3d,%eax
  40128b:	48 89 f1             	mov    %rsi,%rcx
  40128e:	48 89 c0             	mov    %rax,%rax
  401291:	48 89 df             	mov    %rbx,%rdi
  401294:	48 89 ce             	mov    %rcx,%rsi
  401297:	48 89 d2             	mov    %rdx,%rdx
  40129a:	cd 80                	int    $0x80
  40129c:	48 89 c0             	mov    %rax,%rax
  40129f:	48 89 c2             	mov    %rax,%rdx
	if((int)res < 0)
  4012a2:	85 d2                	test   %edx,%edx
  4012a4:	79 10                	jns    4012b6 <waitpid+0x36>
	{
		errno = -res;	
  4012a6:	f7 da                	neg    %edx
  4012a8:	48 8b 05 79 11 20 00 	mov    0x201179(%rip),%rax        # 602428 <digits.1229+0x200b98>
  4012af:	89 10                	mov    %edx,(%rax)
		return -1;
  4012b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  4012b6:	5b                   	pop    %rbx
  4012b7:	c3                   	retq   
  4012b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  4012bf:	00 

00000000004012c0 <memcmp>:

//Compare first n characters pointed by s1 to s2.
int memcmp(const void* s1, const void* s2,size_t n)
{
    const unsigned char *p1 = s1, *p2 = s2;
    while(n--)
  4012c0:	4c 8d 42 ff          	lea    -0x1(%rdx),%r8
  4012c4:	48 85 d2             	test   %rdx,%rdx
  4012c7:	74 35                	je     4012fe <memcmp+0x3e>
        if( *p1 != *p2 )
  4012c9:	0f b6 07             	movzbl (%rdi),%eax
  4012cc:	0f b6 0e             	movzbl (%rsi),%ecx
  4012cf:	ba 00 00 00 00       	mov    $0x0,%edx
  4012d4:	38 c8                	cmp    %cl,%al
  4012d6:	74 1b                	je     4012f3 <memcmp+0x33>
  4012d8:	eb 10                	jmp    4012ea <memcmp+0x2a>
  4012da:	0f b6 44 17 01       	movzbl 0x1(%rdi,%rdx,1),%eax
  4012df:	48 ff c2             	inc    %rdx
  4012e2:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  4012e6:	38 c8                	cmp    %cl,%al
  4012e8:	74 09                	je     4012f3 <memcmp+0x33>
            return *p1 - *p2;
  4012ea:	0f b6 c0             	movzbl %al,%eax
  4012ed:	0f b6 c9             	movzbl %cl,%ecx
  4012f0:	29 c8                	sub    %ecx,%eax
  4012f2:	c3                   	retq   

//Compare first n characters pointed by s1 to s2.
int memcmp(const void* s1, const void* s2,size_t n)
{
    const unsigned char *p1 = s1, *p2 = s2;
    while(n--)
  4012f3:	4c 39 c2             	cmp    %r8,%rdx
  4012f6:	75 e2                	jne    4012da <memcmp+0x1a>
        if( *p1 != *p2 )
            return *p1 - *p2;
        else
            p1++,p2++;
    return 0;
  4012f8:	b8 00 00 00 00       	mov    $0x0,%eax
  4012fd:	c3                   	retq   
  4012fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401303:	c3                   	retq   

0000000000401304 <memset>:

void *memset(void *str, int c, size_t n)
{
  401304:	48 89 f8             	mov    %rdi,%rax
    char *dst = str;
    while(n-- != 0)
  401307:	48 85 d2             	test   %rdx,%rdx
  40130a:	74 12                	je     40131e <memset+0x1a>
  40130c:	48 01 fa             	add    %rdi,%rdx
    return 0;
}

void *memset(void *str, int c, size_t n)
{
    char *dst = str;
  40130f:	48 89 f9             	mov    %rdi,%rcx
    while(n-- != 0)
    {
        *dst++ = c;
  401312:	48 ff c1             	inc    %rcx
  401315:	40 88 71 ff          	mov    %sil,-0x1(%rcx)
}

void *memset(void *str, int c, size_t n)
{
    char *dst = str;
    while(n-- != 0)
  401319:	48 39 d1             	cmp    %rdx,%rcx
  40131c:	75 f4                	jne    401312 <memset+0xe>
    {
        *dst++ = c;
    }
    return str;
}
  40131e:	f3 c3                	repz retq 

0000000000401320 <memcpy>:

void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n)
{
  401320:	48 89 f8             	mov    %rdi,%rax
     char *dst = s1;
     const char *src = s2;
     /* Loop and copy.  */
     while (n-- != 0)
  401323:	48 85 d2             	test   %rdx,%rdx
  401326:	74 16                	je     40133e <memcpy+0x1e>
  401328:	b9 00 00 00 00       	mov    $0x0,%ecx
         *dst++ = *src++;
  40132d:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  401332:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
  401336:	48 ff c1             	inc    %rcx
void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n)
{
     char *dst = s1;
     const char *src = s2;
     /* Loop and copy.  */
     while (n-- != 0)
  401339:	48 39 d1             	cmp    %rdx,%rcx
  40133c:	75 ef                	jne    40132d <memcpy+0xd>
         *dst++ = *src++;
     return s1;
 }
  40133e:	f3 c3                	repz retq 

0000000000401340 <strcpy>:

char *strcpy(char *dest, const char *src)
 {
  401340:	48 89 f8             	mov    %rdi,%rax
         char *tmp = dest; 
         while ((*dest++ = *src++) != '\0');
  401343:	48 89 fa             	mov    %rdi,%rdx
  401346:	48 ff c2             	inc    %rdx
  401349:	48 ff c6             	inc    %rsi
  40134c:	0f b6 4e ff          	movzbl -0x1(%rsi),%ecx
  401350:	88 4a ff             	mov    %cl,-0x1(%rdx)
  401353:	84 c9                	test   %cl,%cl
  401355:	75 ef                	jne    401346 <strcpy+0x6>
         return tmp;
 }
  401357:	f3 c3                	repz retq 

0000000000401359 <strncpy>:

char *strncpy(char *dest, const char *src, size_t count)
 {
  401359:	48 89 f8             	mov    %rdi,%rax
         char *tmp = dest; 
         while (count) {
  40135c:	48 85 d2             	test   %rdx,%rdx
  40135f:	74 1d                	je     40137e <strncpy+0x25>
  401361:	48 01 fa             	add    %rdi,%rdx
         return tmp;
 }

char *strncpy(char *dest, const char *src, size_t count)
 {
         char *tmp = dest; 
  401364:	48 89 f9             	mov    %rdi,%rcx
         while (count) {
                 if ((*tmp = *src) != 0)
  401367:	44 0f b6 06          	movzbl (%rsi),%r8d
  40136b:	44 88 01             	mov    %r8b,(%rcx)
                         src++;
  40136e:	41 80 f8 01          	cmp    $0x1,%r8b
  401372:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
                 tmp++;
  401376:	48 ff c1             	inc    %rcx
 }

char *strncpy(char *dest, const char *src, size_t count)
 {
         char *tmp = dest; 
         while (count) {
  401379:	48 39 d1             	cmp    %rdx,%rcx
  40137c:	75 e9                	jne    401367 <strncpy+0xe>
                         src++;
                 tmp++;
                 count--;
         }
         return dest;
 }
  40137e:	f3 c3                	repz retq 

0000000000401380 <strlen>:

size_t strlen(const char * str)
{
    const char *s;
    for (s = str; *s; ++s);
  401380:	80 3f 00             	cmpb   $0x0,(%rdi)
  401383:	74 0d                	je     401392 <strlen+0x12>
  401385:	48 89 f8             	mov    %rdi,%rax
  401388:	48 ff c0             	inc    %rax
  40138b:	80 38 00             	cmpb   $0x0,(%rax)
  40138e:	75 f8                	jne    401388 <strlen+0x8>
  401390:	eb 03                	jmp    401395 <strlen+0x15>
  401392:	48 89 f8             	mov    %rdi,%rax
    return(s - str);
  401395:	48 29 f8             	sub    %rdi,%rax
}
  401398:	c3                   	retq   

0000000000401399 <strcmp>:

int strcmp(const char *cs, const char *ct)
 {
         unsigned char c1, c2;
         while (1) {
                 c1 = *cs++;
  401399:	48 ff c7             	inc    %rdi
  40139c:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
                 c2 = *ct++;
  4013a0:	48 ff c6             	inc    %rsi
  4013a3:	0f b6 56 ff          	movzbl -0x1(%rsi),%edx
                 if (c1 != c2)
  4013a7:	38 d0                	cmp    %dl,%al
  4013a9:	74 08                	je     4013b3 <strcmp+0x1a>
                         return c1 < c2 ? -1 : 1;
  4013ab:	38 d0                	cmp    %dl,%al
  4013ad:	19 c0                	sbb    %eax,%eax
  4013af:	83 c8 01             	or     $0x1,%eax
  4013b2:	c3                   	retq   
                 if (!c1)
  4013b3:	84 c0                	test   %al,%al
  4013b5:	75 e2                	jne    401399 <strcmp>
                         break;
         }
         return 0;
  4013b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  4013bc:	c3                   	retq   

00000000004013bd <strstr>:

char *strstr(const char *s1, const char *s2)
{
  4013bd:	41 55                	push   %r13
  4013bf:	41 54                	push   %r12
  4013c1:	55                   	push   %rbp
  4013c2:	53                   	push   %rbx
  4013c3:	48 83 ec 08          	sub    $0x8,%rsp
  4013c7:	48 89 fb             	mov    %rdi,%rbx
  4013ca:	49 89 f5             	mov    %rsi,%r13
         size_t l1, l2; 
         l2 = strlen(s2);
  4013cd:	48 89 f7             	mov    %rsi,%rdi
  4013d0:	e8 ab ff ff ff       	callq  401380 <strlen>
  4013d5:	49 89 c4             	mov    %rax,%r12
         if (!l2)
                 return (char *)s1;
  4013d8:	48 89 d8             	mov    %rbx,%rax

char *strstr(const char *s1, const char *s2)
{
         size_t l1, l2; 
         l2 = strlen(s2);
         if (!l2)
  4013db:	4d 85 e4             	test   %r12,%r12
  4013de:	74 43                	je     401423 <strstr+0x66>
                 return (char *)s1;
         l1 = strlen(s1);
  4013e0:	48 89 df             	mov    %rbx,%rdi
  4013e3:	e8 98 ff ff ff       	callq  401380 <strlen>
  4013e8:	48 89 c5             	mov    %rax,%rbp
         while (l1 >= l2) {
  4013eb:	49 39 c4             	cmp    %rax,%r12
  4013ee:	77 22                	ja     401412 <strstr+0x55>
                 l1--;
  4013f0:	48 ff cd             	dec    %rbp
                 if (!memcmp(s1, s2, l2))
  4013f3:	4c 89 e2             	mov    %r12,%rdx
  4013f6:	4c 89 ee             	mov    %r13,%rsi
  4013f9:	48 89 df             	mov    %rbx,%rdi
  4013fc:	e8 bf fe ff ff       	callq  4012c0 <memcmp>
  401401:	85 c0                	test   %eax,%eax
  401403:	74 14                	je     401419 <strstr+0x5c>
                         return (char *)s1;
                 s1++;
  401405:	48 ff c3             	inc    %rbx
         size_t l1, l2; 
         l2 = strlen(s2);
         if (!l2)
                 return (char *)s1;
         l1 = strlen(s1);
         while (l1 >= l2) {
  401408:	49 39 ec             	cmp    %rbp,%r12
  40140b:	76 e3                	jbe    4013f0 <strstr+0x33>
  40140d:	0f 1f 00             	nopl   (%rax)
  401410:	eb 0c                	jmp    40141e <strstr+0x61>
                 l1--;
                 if (!memcmp(s1, s2, l2))
                         return (char *)s1;
                 s1++;
         }
         return NULL;
  401412:	b8 00 00 00 00       	mov    $0x0,%eax
  401417:	eb 0a                	jmp    401423 <strstr+0x66>
  401419:	48 89 d8             	mov    %rbx,%rax
  40141c:	eb 05                	jmp    401423 <strstr+0x66>
  40141e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401423:	48 83 c4 08          	add    $0x8,%rsp
  401427:	5b                   	pop    %rbx
  401428:	5d                   	pop    %rbp
  401429:	41 5c                	pop    %r12
  40142b:	41 5d                	pop    %r13
  40142d:	c3                   	retq   

000000000040142e <strcat>:

char *strcat(char *dest, const char *src)
{
  40142e:	48 89 f8             	mov    %rdi,%rax
         char *tmp = dest; 
         while (*dest)
  401431:	80 3f 00             	cmpb   $0x0,(%rdi)
  401434:	74 0d                	je     401443 <strcat+0x15>
  401436:	48 89 fa             	mov    %rdi,%rdx
                 dest++;
  401439:	48 ff c2             	inc    %rdx
}

char *strcat(char *dest, const char *src)
{
         char *tmp = dest; 
         while (*dest)
  40143c:	80 3a 00             	cmpb   $0x0,(%rdx)
  40143f:	75 f8                	jne    401439 <strcat+0xb>
  401441:	eb 03                	jmp    401446 <strcat+0x18>
  401443:	48 89 fa             	mov    %rdi,%rdx
                 dest++;
         while ((*dest++ = *src++) != '\0')
  401446:	48 ff c2             	inc    %rdx
  401449:	48 ff c6             	inc    %rsi
  40144c:	0f b6 4e ff          	movzbl -0x1(%rsi),%ecx
  401450:	88 4a ff             	mov    %cl,-0x1(%rdx)
  401453:	84 c9                	test   %cl,%cl
  401455:	75 ef                	jne    401446 <strcat+0x18>
                 ;
         return tmp;
}
  401457:	f3 c3                	repz retq 

0000000000401459 <isspace>:

int isspace(char c)
{
    return (c == ' ' || c == '\t' || c == '\n' || c == '\12');
  401459:	8d 47 f7             	lea    -0x9(%rdi),%eax
  40145c:	3c 01                	cmp    $0x1,%al
  40145e:	0f 96 c2             	setbe  %dl
  401461:	40 80 ff 20          	cmp    $0x20,%dil
  401465:	0f 94 c0             	sete   %al
  401468:	09 d0                	or     %edx,%eax
  40146a:	0f b6 c0             	movzbl %al,%eax
}
  40146d:	c3                   	retq   

000000000040146e <strchr>:

char *strchr(const char *s, int c)
{
    while (*s != (char)c)
  40146e:	eb 07                	jmp    401477 <strchr+0x9>
        if (!*s++)
  401470:	48 ff c7             	inc    %rdi
  401473:	84 c0                	test   %al,%al
  401475:	74 0c                	je     401483 <strchr+0x15>
    return (c == ' ' || c == '\t' || c == '\n' || c == '\12');
}

char *strchr(const char *s, int c)
{
    while (*s != (char)c)
  401477:	0f b6 07             	movzbl (%rdi),%eax
  40147a:	40 38 f0             	cmp    %sil,%al
  40147d:	75 f1                	jne    401470 <strchr+0x2>
  40147f:	48 89 f8             	mov    %rdi,%rax
  401482:	c3                   	retq   
        if (!*s++)
            return 0;
  401483:	b8 00 00 00 00       	mov    $0x0,%eax
    return (char *)s;
}
  401488:	c3                   	retq   

0000000000401489 <isdigit>:

int isdigit(int ch)
{
        return (ch >= '0') && (ch <= '9');
  401489:	83 ef 30             	sub    $0x30,%edi
  40148c:	83 ff 09             	cmp    $0x9,%edi
  40148f:	0f 96 c0             	setbe  %al
  401492:	0f b6 c0             	movzbl %al,%eax
}
  401495:	c3                   	retq   

0000000000401496 <strcspn>:

size_t strcspn(const char *s, const char *reject) {
  401496:	41 54                	push   %r12
  401498:	55                   	push   %rbp
  401499:	53                   	push   %rbx
  40149a:	48 89 fd             	mov    %rdi,%rbp
        size_t count = 0;

        while (*s != '\0') {
  40149d:	0f b6 17             	movzbl (%rdi),%edx
  4014a0:	84 d2                	test   %dl,%dl
  4014a2:	74 26                	je     4014ca <strcspn+0x34>
  4014a4:	49 89 f4             	mov    %rsi,%r12
{
        return (ch >= '0') && (ch <= '9');
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;
  4014a7:	bb 00 00 00 00       	mov    $0x0,%ebx

        while (*s != '\0') {
                if (strchr(reject, *s++) == NULL) {
  4014ac:	0f be f2             	movsbl %dl,%esi
  4014af:	4c 89 e7             	mov    %r12,%rdi
  4014b2:	e8 b7 ff ff ff       	callq  40146e <strchr>
  4014b7:	48 85 c0             	test   %rax,%rax
  4014ba:	75 13                	jne    4014cf <strcspn+0x39>
                        ++count;
  4014bc:	48 ff c3             	inc    %rbx
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;

        while (*s != '\0') {
  4014bf:	0f b6 54 1d 00       	movzbl 0x0(%rbp,%rbx,1),%edx
  4014c4:	84 d2                	test   %dl,%dl
  4014c6:	75 e4                	jne    4014ac <strcspn+0x16>
  4014c8:	eb 05                	jmp    4014cf <strcspn+0x39>
{
        return (ch >= '0') && (ch <= '9');
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;
  4014ca:	bb 00 00 00 00       	mov    $0x0,%ebx
                } else {
                        return count;
                }
        }
        return count;
}
  4014cf:	48 89 d8             	mov    %rbx,%rax
  4014d2:	5b                   	pop    %rbx
  4014d3:	5d                   	pop    %rbp
  4014d4:	41 5c                	pop    %r12
  4014d6:	c3                   	retq   

00000000004014d7 <reset>:
void reset(char str[], int len)
{
	for(int i = 0; i < len; i++)
  4014d7:	85 f6                	test   %esi,%esi
  4014d9:	7e 10                	jle    4014eb <reset+0x14>
  4014db:	b8 00 00 00 00       	mov    $0x0,%eax
		str[i] = '\0';
  4014e0:	c6 04 07 00          	movb   $0x0,(%rdi,%rax,1)
  4014e4:	48 ff c0             	inc    %rax
        }
        return count;
}
void reset(char str[], int len)
{
	for(int i = 0; i < len; i++)
  4014e7:	39 c6                	cmp    %eax,%esi
  4014e9:	7f f5                	jg     4014e0 <reset+0x9>
  4014eb:	f3 c3                	repz retq 

00000000004014ed <atoi>:
}

int atoi(const char *str)
{
    int k = 0;
    for (int i = 0; str[i] != '\0'; ++i)
  4014ed:	0f b6 17             	movzbl (%rdi),%edx
  4014f0:	84 d2                	test   %dl,%dl
  4014f2:	74 26                	je     40151a <atoi+0x2d>
  4014f4:	b9 00 00 00 00       	mov    $0x0,%ecx
		str[i] = '\0';
}

int atoi(const char *str)
{
    int k = 0;
  4014f9:	b8 00 00 00 00       	mov    $0x0,%eax
    for (int i = 0; str[i] != '\0'; ++i)
        k = (k<<3)+(k<<1)+(str[i])-'0';
  4014fe:	8d 34 00             	lea    (%rax,%rax,1),%esi
  401501:	8d 04 c6             	lea    (%rsi,%rax,8),%eax
  401504:	0f be d2             	movsbl %dl,%edx
  401507:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
}

int atoi(const char *str)
{
    int k = 0;
    for (int i = 0; str[i] != '\0'; ++i)
  40150b:	ff c1                	inc    %ecx
  40150d:	48 63 d1             	movslq %ecx,%rdx
  401510:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  401514:	84 d2                	test   %dl,%dl
  401516:	75 e6                	jne    4014fe <atoi+0x11>
  401518:	f3 c3                	repz retq 
		str[i] = '\0';
}

int atoi(const char *str)
{
    int k = 0;
  40151a:	b8 00 00 00 00       	mov    $0x0,%eax
    for (int i = 0; str[i] != '\0'; ++i)
        k = (k<<3)+(k<<1)+(str[i])-'0';
    return k;
}
  40151f:	c3                   	retq   
