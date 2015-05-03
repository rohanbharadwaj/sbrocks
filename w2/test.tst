
rootfs/bin/sbush:     file format elf64-x86-64


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
  400110:	e8 86 10 00 00       	callq  40119b <main>
  400115:	89 c7                	mov    %eax,%edi
  400117:	e8 d4 1e 00 00       	callq  401ff0 <exit>
}
  40011c:	48 83 c4 08          	add    $0x8,%rsp
  400120:	c3                   	retq   
  400121:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  400128:	00 00 00 
  40012b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000400130 <printPrompt>:
	//printf("parse command end \n");
	//printf("cmdcount = %d, argcount= %d \n", cmdcount, argcount);
    return cmdcount + 1;
}

void printPrompt(){
  400130:	48 83 ec 08          	sub    $0x8,%rsp
    if(strlen(PS1)<2)  
  400134:	48 8d 3d 05 3c 20 00 	lea    0x203c05(%rip),%rdi        # 603d40 <PS1>
  40013b:	e8 f0 23 00 00       	callq  402530 <strlen>
  400140:	48 83 f8 01          	cmp    $0x1,%rax
  400144:	77 13                	ja     400159 <printPrompt+0x29>
    {   
        printf("$ ");
  400146:	48 8d 3d 85 25 00 00 	lea    0x2585(%rip),%rdi        # 4026d2 <atoi+0x35>
  40014d:	b8 00 00 00 00       	mov    $0x0,%eax
  400152:	e8 dc 19 00 00       	callq  401b33 <printf>
  400157:	eb 18                	jmp    400171 <printPrompt+0x41>
      }  
    else
    {    
        printf("%s$ ",PS1);
  400159:	48 8d 35 e0 3b 20 00 	lea    0x203be0(%rip),%rsi        # 603d40 <PS1>
  400160:	48 8d 3d 69 25 00 00 	lea    0x2569(%rip),%rdi        # 4026d0 <atoi+0x33>
  400167:	b8 00 00 00 00       	mov    $0x0,%eax
  40016c:	e8 c2 19 00 00       	callq  401b33 <printf>
       } 
}
  400171:	48 83 c4 08          	add    $0x8,%rsp
  400175:	c3                   	retq   

0000000000400176 <getValue>:

char* getValue(char* keyvalue){
  400176:	55                   	push   %rbp
  400177:	53                   	push   %rbx
  400178:	48 83 ec 08          	sub    $0x8,%rsp
  40017c:	48 89 fb             	mov    %rdi,%rbx
    //printf("in get value");
    char *value;
    value = malloc(strlen(keyvalue));
  40017f:	e8 ac 23 00 00       	callq  402530 <strlen>
  400184:	48 89 c7             	mov    %rax,%rdi
  400187:	e8 54 11 00 00       	callq  4012e0 <malloc>
  40018c:	48 89 c5             	mov    %rax,%rbp
	memset(value, 0, strlen(keyvalue));
  40018f:	48 89 df             	mov    %rbx,%rdi
  400192:	e8 99 23 00 00       	callq  402530 <strlen>
  400197:	48 89 c2             	mov    %rax,%rdx
  40019a:	be 00 00 00 00       	mov    $0x0,%esi
  40019f:	48 89 ef             	mov    %rbp,%rdi
  4001a2:	e8 0d 23 00 00       	callq  4024b4 <memset>
    int found = 0;
  4001a7:	b8 00 00 00 00       	mov    $0x0,%eax
    while(*keyvalue++){
  4001ac:	eb 1a                	jmp    4001c8 <getValue+0x52>
        if(*keyvalue=='=')
  4001ae:	0f b6 13             	movzbl (%rbx),%edx
  4001b1:	80 fa 3d             	cmp    $0x3d,%dl
  4001b4:	74 06                	je     4001bc <getValue+0x46>
        {
            //printf("found");
            found =1;
        }
        if(found)
  4001b6:	85 c0                	test   %eax,%eax
  4001b8:	74 0e                	je     4001c8 <getValue+0x52>
  4001ba:	eb 05                	jmp    4001c1 <getValue+0x4b>
    int found = 0;
    while(*keyvalue++){
        if(*keyvalue=='=')
        {
            //printf("found");
            found =1;
  4001bc:	b8 01 00 00 00       	mov    $0x1,%eax
        }
        if(found)
        {
            
            *value++=*keyvalue;
  4001c1:	88 55 00             	mov    %dl,0x0(%rbp)
  4001c4:	48 8d 6d 01          	lea    0x1(%rbp),%rbp
    //printf("in get value");
    char *value;
    value = malloc(strlen(keyvalue));
	memset(value, 0, strlen(keyvalue));
    int found = 0;
    while(*keyvalue++){
  4001c8:	48 ff c3             	inc    %rbx
  4001cb:	80 7b ff 00          	cmpb   $0x0,-0x1(%rbx)
  4001cf:	75 dd                	jne    4001ae <getValue+0x38>
            *value++=*keyvalue;
        }
    }
   // printf("%s\n in function", value);
    return value;
}
  4001d1:	48 89 e8             	mov    %rbp,%rax
  4001d4:	48 83 c4 08          	add    $0x8,%rsp
  4001d8:	5b                   	pop    %rbx
  4001d9:	5d                   	pop    %rbp
  4001da:	c3                   	retq   

00000000004001db <printEnvironments>:
        commands[i][1] = NULL;
    }
}

void printEnvironments(char *envp[])
{
  4001db:	53                   	push   %rbx
  4001dc:	48 89 fb             	mov    %rdi,%rbx
    printf("\n\n\n\n\n environments are \n");
  4001df:	48 8d 3d ef 24 00 00 	lea    0x24ef(%rip),%rdi        # 4026d5 <atoi+0x38>
  4001e6:	b8 00 00 00 00       	mov    $0x0,%eax
  4001eb:	e8 43 19 00 00       	callq  401b33 <printf>
    //while(*envp)
     //   printf("%s\n",*envp++);
     printf("%s\n",envp[0]);
  4001f0:	48 8b 33             	mov    (%rbx),%rsi
  4001f3:	48 8d 3d 09 25 00 00 	lea    0x2509(%rip),%rdi        # 402703 <atoi+0x66>
  4001fa:	b8 00 00 00 00       	mov    $0x0,%eax
  4001ff:	e8 2f 19 00 00       	callq  401b33 <printf>
}
  400204:	5b                   	pop    %rbx
  400205:	c3                   	retq   

0000000000400206 <readInput>:
        return 0;
    return 1;
}
#endif

int readInput(char *input_line){
  400206:	41 56                	push   %r14
  400208:	41 55                	push   %r13
  40020a:	41 54                	push   %r12
  40020c:	55                   	push   %rbp
  40020d:	53                   	push   %rbx
  40020e:	48 83 ec 10          	sub    $0x10,%rsp
  400212:	49 89 fe             	mov    %rdi,%r14
	char c = ' ';
  400215:	c6 44 24 0f 20       	movb   $0x20,0xf(%rsp)
    int i =0;
    int pipeFound = 0;
    while(c!='\n' || pipeFound == 1){
  40021a:	bb 00 00 00 00       	mov    $0x0,%ebx
#endif

int readInput(char *input_line){
	char c = ' ';
    int i =0;
    int pipeFound = 0;
  40021f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
}
#endif

int readInput(char *input_line){
	char c = ' ';
    int i =0;
  400225:	bd 00 00 00 00       	mov    $0x0,%ebp
    int pipeFound = 0;
    while(c!='\n' || pipeFound == 1){
        scanf("%c", &c);
  40022a:	4c 8d 6c 24 0f       	lea    0xf(%rsp),%r13
  40022f:	4c 89 ee             	mov    %r13,%rsi
  400232:	48 8d 3d b5 24 00 00 	lea    0x24b5(%rip),%rdi        # 4026ee <atoi+0x51>
  400239:	b8 00 00 00 00       	mov    $0x0,%eax
  40023e:	e8 bd 1b 00 00       	callq  401e00 <scanf>
		//printf("%c", c);
        if(pipeFound == 1 && c == '|')
  400243:	84 db                	test   %bl,%bl
  400245:	74 39                	je     400280 <readInput+0x7a>
  400247:	0f b6 44 24 0f       	movzbl 0xf(%rsp),%eax
  40024c:	3c 7c                	cmp    $0x7c,%al
  40024e:	0f 85 9d 00 00 00    	jne    4002f1 <readInput+0xeb>
        {
            printf("-bash: syntax error near unexpected token | \n");
  400254:	48 8d 3d 85 25 00 00 	lea    0x2585(%rip),%rdi        # 4027e0 <atoi+0x143>
  40025b:	b8 00 00 00 00       	mov    $0x0,%eax
  400260:	e8 ce 18 00 00       	callq  401b33 <printf>
            return 0;
  400265:	b8 00 00 00 00       	mov    $0x0,%eax
  40026a:	e9 a1 00 00 00       	jmpq   400310 <readInput+0x10a>
        }
        if(c == '\n' && pipeFound ==1)
        {
            printf(">");
  40026f:	48 8d 3d 7b 24 00 00 	lea    0x247b(%rip),%rdi        # 4026f1 <atoi+0x54>
  400276:	b8 00 00 00 00       	mov    $0x0,%eax
  40027b:	e8 b3 18 00 00       	callq  401b33 <printf>
        }
        if(c == '\b')
  400280:	0f b6 44 24 0f       	movzbl 0xf(%rsp),%eax
  400285:	3c 08                	cmp    $0x8,%al
  400287:	75 0d                	jne    400296 <readInput+0x90>
		{	
			//input_line[i]='\0';
			i--;
  400289:	8d 55 ff             	lea    -0x1(%rbp),%edx
			input_line[i]='\0';
  40028c:	48 63 ca             	movslq %edx,%rcx
  40028f:	41 c6 04 0e 00       	movb   $0x0,(%r14,%rcx,1)
  400294:	eb 12                	jmp    4002a8 <readInput+0xa2>
		}
		else if(c!= '\n')
  400296:	3c 0a                	cmp    $0xa,%al
  400298:	74 60                	je     4002fa <readInput+0xf4>
            input_line[i++] = c;
  40029a:	8d 55 01             	lea    0x1(%rbp),%edx
  40029d:	48 63 ed             	movslq %ebp,%rbp
  4002a0:	41 88 04 2e          	mov    %al,(%r14,%rbp,1)
		
			//printf("backspace \n");
        if(c == '|')
  4002a4:	3c 7c                	cmp    $0x7c,%al
  4002a6:	74 25                	je     4002cd <readInput+0xc7>
        {
            //printf("pipe found \n");
            pipeFound = 1;
        }
        else if(pipeFound == 1 && c != ' ' && c != '\n')
  4002a8:	84 db                	test   %bl,%bl
  4002aa:	74 0f                	je     4002bb <readInput+0xb5>
  4002ac:	3c 20                	cmp    $0x20,%al
  4002ae:	74 0b                	je     4002bb <readInput+0xb5>
        {
            pipeFound = 0;
  4002b0:	3c 0a                	cmp    $0xa,%al
  4002b2:	b8 00 00 00 00       	mov    $0x0,%eax
  4002b7:	44 0f 45 e0          	cmovne %eax,%r12d

int readInput(char *input_line){
	char c = ' ';
    int i =0;
    int pipeFound = 0;
    while(c!='\n' || pipeFound == 1){
  4002bb:	41 83 fc 01          	cmp    $0x1,%r12d
  4002bf:	0f 94 c3             	sete   %bl
  4002c2:	74 14                	je     4002d8 <readInput+0xd2>
  4002c4:	80 7c 24 0f 0a       	cmpb   $0xa,0xf(%rsp)
  4002c9:	75 0d                	jne    4002d8 <readInput+0xd2>
  4002cb:	eb 12                	jmp    4002df <readInput+0xd9>
		
			//printf("backspace \n");
        if(c == '|')
        {
            //printf("pipe found \n");
            pipeFound = 1;
  4002cd:	41 bc 01 00 00 00    	mov    $0x1,%r12d

int readInput(char *input_line){
	char c = ' ';
    int i =0;
    int pipeFound = 0;
    while(c!='\n' || pipeFound == 1){
  4002d3:	bb 01 00 00 00       	mov    $0x1,%ebx
        return 0;
    return 1;
}
#endif

int readInput(char *input_line){
  4002d8:	89 d5                	mov    %edx,%ebp
  4002da:	e9 50 ff ff ff       	jmpq   40022f <readInput+0x29>
        else if(pipeFound == 1 && c != ' ' && c != '\n')
        {
            pipeFound = 0;
        }
    }
    input_line[i]='\0';
  4002df:	48 63 c2             	movslq %edx,%rax
  4002e2:	41 c6 04 06 00       	movb   $0x0,(%r14,%rax,1)
    if(i<1)
  4002e7:	85 d2                	test   %edx,%edx
  4002e9:	0f 9f c0             	setg   %al
  4002ec:	0f b6 c0             	movzbl %al,%eax
  4002ef:	eb 1f                	jmp    400310 <readInput+0x10a>
        if(pipeFound == 1 && c == '|')
        {
            printf("-bash: syntax error near unexpected token | \n");
            return 0;
        }
        if(c == '\n' && pipeFound ==1)
  4002f1:	3c 0a                	cmp    $0xa,%al
  4002f3:	75 0d                	jne    400302 <readInput+0xfc>
  4002f5:	e9 75 ff ff ff       	jmpq   40026f <readInput+0x69>
  4002fa:	89 ea                	mov    %ebp,%edx
  4002fc:	0f 1f 40 00          	nopl   0x0(%rax)
  400300:	eb a6                	jmp    4002a8 <readInput+0xa2>
        {
            printf(">");
        }
        if(c == '\b')
  400302:	0f b6 44 24 0f       	movzbl 0xf(%rsp),%eax
  400307:	3c 08                	cmp    $0x8,%al
  400309:	75 8f                	jne    40029a <readInput+0x94>
  40030b:	e9 79 ff ff ff       	jmpq   400289 <readInput+0x83>
    }
    input_line[i]='\0';
    if(i<1)
        return 0;
    return 1;
}
  400310:	48 83 c4 10          	add    $0x10,%rsp
  400314:	5b                   	pop    %rbx
  400315:	5d                   	pop    %rbp
  400316:	41 5c                	pop    %r12
  400318:	41 5d                	pop    %r13
  40031a:	41 5e                	pop    %r14
  40031c:	c3                   	retq   

000000000040031d <isSpace>:
    }
}

int isSpace(char c)
{
    return (c == ' ' || c == '\t' || c == '\n' || c == '\12');
  40031d:	8d 47 f7             	lea    -0x9(%rdi),%eax
  400320:	3c 01                	cmp    $0x1,%al
  400322:	0f 96 c2             	setbe  %dl
  400325:	40 80 ff 20          	cmp    $0x20,%dil
  400329:	0f 94 c0             	sete   %al
  40032c:	09 d0                	or     %edx,%eax
  40032e:	0f b6 c0             	movzbl %al,%eax
}
  400331:	c3                   	retq   

0000000000400332 <trim>:
        return 0;
    return 1;
}

void trim(char *input)
{
  400332:	41 55                	push   %r13
  400334:	41 54                	push   %r12
  400336:	55                   	push   %rbp
  400337:	53                   	push   %rbx
  400338:	48 83 ec 08          	sub    $0x8,%rsp
  40033c:	49 89 fc             	mov    %rdi,%r12
    char *dst = input, *src = input;
  40033f:	48 89 fb             	mov    %rdi,%rbx
    char *end;
    
    
    while (isSpace((unsigned char)*src))
  400342:	eb 03                	jmp    400347 <trim+0x15>
    {
        ++src;
  400344:	48 ff c3             	inc    %rbx
{
    char *dst = input, *src = input;
    char *end;
    
    
    while (isSpace((unsigned char)*src))
  400347:	0f be 3b             	movsbl (%rbx),%edi
  40034a:	e8 ce ff ff ff       	callq  40031d <isSpace>
  40034f:	85 c0                	test   %eax,%eax
  400351:	75 f1                	jne    400344 <trim+0x12>
  400353:	49 89 dd             	mov    %rbx,%r13
    {
        ++src;
    }
    
    
    end = src + strlen(src) - 1;
  400356:	48 89 df             	mov    %rbx,%rdi
  400359:	e8 d2 21 00 00       	callq  402530 <strlen>
  40035e:	48 8d 6c 03 ff       	lea    -0x1(%rbx,%rax,1),%rbp
    while (end > src && isSpace((unsigned char)*end))
  400363:	48 39 eb             	cmp    %rbp,%rbx
  400366:	72 0e                	jb     400376 <trim+0x44>
  400368:	eb 19                	jmp    400383 <trim+0x51>
    {
        *end-- = 0;
  40036a:	48 ff cd             	dec    %rbp
  40036d:	c6 45 01 00          	movb   $0x0,0x1(%rbp)
        ++src;
    }
    
    
    end = src + strlen(src) - 1;
    while (end > src && isSpace((unsigned char)*end))
  400371:	4c 39 ed             	cmp    %r13,%rbp
  400374:	74 0d                	je     400383 <trim+0x51>
  400376:	0f be 7d 00          	movsbl 0x0(%rbp),%edi
  40037a:	e8 9e ff ff ff       	callq  40031d <isSpace>
  40037f:	85 c0                	test   %eax,%eax
  400381:	75 e7                	jne    40036a <trim+0x38>
    {
        *end-- = 0;
    }
    
    if (src != dst)
  400383:	4d 39 e5             	cmp    %r12,%r13
  400386:	74 13                	je     40039b <trim+0x69>
    {
        while ((*dst++ = *src++));
  400388:	49 ff c4             	inc    %r12
  40038b:	48 ff c3             	inc    %rbx
  40038e:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  400392:	41 88 44 24 ff       	mov    %al,-0x1(%r12)
  400397:	84 c0                	test   %al,%al
  400399:	75 ed                	jne    400388 <trim+0x56>
    }
}
  40039b:	48 83 c4 08          	add    $0x8,%rsp
  40039f:	5b                   	pop    %rbx
  4003a0:	5d                   	pop    %rbp
  4003a1:	41 5c                	pop    %r12
  4003a3:	41 5d                	pop    %r13
  4003a5:	c3                   	retq   

00000000004003a6 <parseCommand>:
        }
    
}

int parseCommand(char *inputString)
{
  4003a6:	41 57                	push   %r15
  4003a8:	41 56                	push   %r14
  4003aa:	41 55                	push   %r13
  4003ac:	41 54                	push   %r12
  4003ae:	55                   	push   %rbp
  4003af:	53                   	push   %rbx
  4003b0:	48 83 ec 18          	sub    $0x18,%rsp
  4003b4:	49 89 fe             	mov    %rdi,%r14
        free(commands[i]);
    }*/
	//printf("parse command start \n");
    char *srcPtr = inputString;
	
    int len = strlen(inputString);
  4003b7:	e8 74 21 00 00       	callq  402530 <strlen>
	//printf("srcptr %s \n", srcPtr);
    char *str = NULL;
    int i = 0;
    cmdcount = 0;
  4003bc:	48 8d 15 5d 39 20 00 	lea    0x20395d(%rip),%rdx        # 603d20 <cmdcount>
  4003c3:	c7 02 00 00 00 00    	movl   $0x0,(%rdx)
    int argcount = 0;
    int found = 0;
    int count = 0;
	//printf("reached %s, %d\n", srcPtr, strlen(srcPtr));
    while(i < len)
  4003c9:	85 c0                	test   %eax,%eax
  4003cb:	0f 8e 5c 02 00 00    	jle    40062d <parseCommand+0x287>
  4003d1:	41 89 c4             	mov    %eax,%r12d
    int len = strlen(inputString);
	//printf("srcptr %s \n", srcPtr);
    char *str = NULL;
    int i = 0;
    cmdcount = 0;
    int argcount = 0;
  4003d4:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    char *srcPtr = inputString;
	
    int len = strlen(inputString);
	//printf("srcptr %s \n", srcPtr);
    char *str = NULL;
    int i = 0;
  4003da:	ba 00 00 00 00       	mov    $0x0,%edx
  4003df:	e9 d9 01 00 00       	jmpq   4005bd <parseCommand+0x217>
        str = srcPtr;
		//printf("str =%s \n", str);
        while((*srcPtr != ' '  && *srcPtr != '|') && i < len)
        {      
            //printf("%c \n", *srcPtr); 
            i++;
  4003e4:	ff c5                	inc    %ebp
  4003e6:	41 89 ed             	mov    %ebp,%r13d
  4003e9:	41 29 d5             	sub    %edx,%r13d
            count++;
            srcPtr++;
  4003ec:	48 ff c3             	inc    %rbx
	//printf("reached %s, %d\n", srcPtr, strlen(srcPtr));
    while(i < len)
    {
        str = srcPtr;
		//printf("str =%s \n", str);
        while((*srcPtr != ' '  && *srcPtr != '|') && i < len)
  4003ef:	0f b6 03             	movzbl (%rbx),%eax
  4003f2:	3c 7c                	cmp    $0x7c,%al
  4003f4:	74 24                	je     40041a <parseCommand+0x74>
  4003f6:	3c 20                	cmp    $0x20,%al
  4003f8:	74 20                	je     40041a <parseCommand+0x74>
  4003fa:	41 39 ec             	cmp    %ebp,%r12d
  4003fd:	7f e5                	jg     4003e4 <parseCommand+0x3e>
  4003ff:	90                   	nop
  400400:	eb 18                	jmp    40041a <parseCommand+0x74>
  400402:	89 d5                	mov    %edx,%ebp
  400404:	4c 89 f3             	mov    %r14,%rbx
  400407:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  40040d:	eb 0b                	jmp    40041a <parseCommand+0x74>
  40040f:	89 d5                	mov    %edx,%ebp
  400411:	4c 89 f3             	mov    %r14,%rbx
  400414:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            i++;
            count++;
            srcPtr++;
        }    
		//printf("reached2 \n");
        if(*srcPtr == '|')
  40041a:	3c 7c                	cmp    $0x7c,%al
  40041c:	0f 85 c2 01 00 00    	jne    4005e4 <parseCommand+0x23e>
        {
            trim(str);
  400422:	4c 89 f7             	mov    %r14,%rdi
  400425:	e8 08 ff ff ff       	callq  400332 <trim>
            int len = strlen(str);
  40042a:	4c 89 f7             	mov    %r14,%rdi
  40042d:	e8 fe 20 00 00       	callq  402530 <strlen>
            if(len > 0 && count > 0)
  400432:	85 c0                	test   %eax,%eax
  400434:	0f 8e 8f 00 00 00    	jle    4004c9 <parseCommand+0x123>
  40043a:	45 85 ed             	test   %r13d,%r13d
  40043d:	0f 8e 86 00 00 00    	jle    4004c9 <parseCommand+0x123>
            {
                commands[cmdcount][argcount]=malloc(len);
  400443:	48 8d 0d d6 38 20 00 	lea    0x2038d6(%rip),%rcx        # 603d20 <cmdcount>
  40044a:	8b 09                	mov    (%rcx),%ecx
  40044c:	89 0c 24             	mov    %ecx,(%rsp)
  40044f:	48 98                	cltq   
  400451:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  400456:	48 89 c7             	mov    %rax,%rdi
  400459:	e8 82 0e 00 00       	callq  4012e0 <malloc>
  40045e:	4d 63 ff             	movslq %r15d,%r15
  400461:	48 63 14 24          	movslq (%rsp),%rdx
  400465:	48 c1 e2 06          	shl    $0x6,%rdx
  400469:	4c 01 fa             	add    %r15,%rdx
  40046c:	48 8b 0d 7d 38 20 00 	mov    0x20387d(%rip),%rcx        # 603cf0 <digits.1233+0x201210>
  400473:	48 89 04 d1          	mov    %rax,(%rcx,%rdx,8)
				memset(commands[cmdcount][argcount], 0, len);
  400477:	48 8d 0d a2 38 20 00 	lea    0x2038a2(%rip),%rcx        # 603d20 <cmdcount>
  40047e:	48 63 01             	movslq (%rcx),%rax
  400481:	48 c1 e0 06          	shl    $0x6,%rax
  400485:	4c 01 f8             	add    %r15,%rax
  400488:	48 8b 0d 61 38 20 00 	mov    0x203861(%rip),%rcx        # 603cf0 <digits.1233+0x201210>
  40048f:	48 8b 3c c1          	mov    (%rcx,%rax,8),%rdi
  400493:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  400498:	be 00 00 00 00       	mov    $0x0,%esi
  40049d:	e8 12 20 00 00       	callq  4024b4 <memset>
                strncpy(commands[cmdcount][argcount], str, count);
  4004a2:	49 63 d5             	movslq %r13d,%rdx
  4004a5:	48 8d 05 74 38 20 00 	lea    0x203874(%rip),%rax        # 603d20 <cmdcount>
  4004ac:	48 63 00             	movslq (%rax),%rax
  4004af:	48 c1 e0 06          	shl    $0x6,%rax
  4004b3:	49 01 c7             	add    %rax,%r15
  4004b6:	48 8b 05 33 38 20 00 	mov    0x203833(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  4004bd:	4a 8b 3c f8          	mov    (%rax,%r15,8),%rdi
  4004c1:	4c 89 f6             	mov    %r14,%rsi
  4004c4:	e8 40 20 00 00       	callq  402509 <strncpy>
                //printf("command is %s \n",commands[cmdcount][argcount]);
                argcount++;
            }
            cmdcount++;
  4004c9:	48 8d 05 50 38 20 00 	lea    0x203850(%rip),%rax        # 603d20 <cmdcount>
  4004d0:	ff 00                	incl   (%rax)
            argcount = 0;
            found = 1;
            srcPtr++;
  4004d2:	48 ff c3             	inc    %rbx
                strncpy(commands[cmdcount][argcount], str, count);
                //printf("command is %s \n",commands[cmdcount][argcount]);
                argcount++;
            }
            cmdcount++;
            argcount = 0;
  4004d5:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  4004db:	e9 8e 00 00 00       	jmpq   40056e <parseCommand+0x1c8>
            int len = strlen(str);
            if(len > 0 && count > 0)
            {
				//printf("final before malloc %d %d %d \n", cmdcount, argcount, len);
				//listprocess();
                commands[cmdcount][argcount]=malloc(len);
  4004e0:	48 8d 35 39 38 20 00 	lea    0x203839(%rip),%rsi        # 603d20 <cmdcount>
  4004e7:	8b 36                	mov    (%rsi),%esi
  4004e9:	89 34 24             	mov    %esi,(%rsp)
  4004ec:	48 98                	cltq   
  4004ee:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4004f3:	48 89 c7             	mov    %rax,%rdi
  4004f6:	e8 e5 0d 00 00       	callq  4012e0 <malloc>
  4004fb:	49 63 cf             	movslq %r15d,%rcx
  4004fe:	48 63 14 24          	movslq (%rsp),%rdx
  400502:	48 c1 e2 06          	shl    $0x6,%rdx
  400506:	48 01 ca             	add    %rcx,%rdx
  400509:	48 8b 35 e0 37 20 00 	mov    0x2037e0(%rip),%rsi        # 603cf0 <digits.1233+0x201210>
  400510:	48 89 04 d6          	mov    %rax,(%rsi,%rdx,8)
				//printf("final after malloc \n");
				memset(commands[cmdcount][argcount], 0, len);
  400514:	48 8d 35 05 38 20 00 	lea    0x203805(%rip),%rsi        # 603d20 <cmdcount>
  40051b:	48 63 06             	movslq (%rsi),%rax
  40051e:	48 c1 e0 06          	shl    $0x6,%rax
  400522:	48 89 0c 24          	mov    %rcx,(%rsp)
  400526:	48 01 c8             	add    %rcx,%rax
  400529:	48 8b 35 c0 37 20 00 	mov    0x2037c0(%rip),%rsi        # 603cf0 <digits.1233+0x201210>
  400530:	48 8b 3c c6          	mov    (%rsi,%rax,8),%rdi
  400534:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  400539:	be 00 00 00 00       	mov    $0x0,%esi
  40053e:	e8 71 1f 00 00       	callq  4024b4 <memset>
				//printf("final after memset \n");
                strncpy(commands[cmdcount][argcount], str, count);
  400543:	49 63 d5             	movslq %r13d,%rdx
  400546:	48 8d 05 d3 37 20 00 	lea    0x2037d3(%rip),%rax        # 603d20 <cmdcount>
  40054d:	48 63 00             	movslq (%rax),%rax
  400550:	48 c1 e0 06          	shl    $0x6,%rax
  400554:	48 03 04 24          	add    (%rsp),%rax
  400558:	48 8b 0d 91 37 20 00 	mov    0x203791(%rip),%rcx        # 603cf0 <digits.1233+0x201210>
  40055f:	48 8b 3c c1          	mov    (%rcx,%rax,8),%rdi
  400563:	4c 89 f6             	mov    %r14,%rsi
  400566:	e8 9e 1f 00 00       	callq  402509 <strncpy>
				//printf("final after strncpy \n");
				//printf("command is %s \n",commands[cmdcount][argcount]);
                argcount++;
  40056b:	41 ff c7             	inc    %r15d
            }
        }
        found = 0;
        count = 0;
        while (*srcPtr == ' ' && i<len) {
  40056e:	80 3b 20             	cmpb   $0x20,(%rbx)
  400571:	75 1d                	jne    400590 <parseCommand+0x1ea>
  400573:	41 39 ec             	cmp    %ebp,%r12d
  400576:	0f 8e 8e 00 00 00    	jle    40060a <parseCommand+0x264>
            *srcPtr = '\0';
  40057c:	c6 03 00             	movb   $0x0,(%rbx)
            srcPtr++;
  40057f:	48 ff c3             	inc    %rbx
            i++;
  400582:	ff c5                	inc    %ebp
                argcount++;
            }
        }
        found = 0;
        count = 0;
        while (*srcPtr == ' ' && i<len) {
  400584:	80 3b 20             	cmpb   $0x20,(%rbx)
  400587:	75 07                	jne    400590 <parseCommand+0x1ea>
  400589:	41 39 ec             	cmp    %ebp,%r12d
  40058c:	7f ee                	jg     40057c <parseCommand+0x1d6>
  40058e:	eb 7a                	jmp    40060a <parseCommand+0x264>
            *srcPtr = '\0';
            srcPtr++;
            i++;
        }
        //printf("shashi:  %c \n", *srcPtr); 
        commands[cmdcount][argcount]=NULL;
  400590:	49 63 d7             	movslq %r15d,%rdx
  400593:	48 8d 05 86 37 20 00 	lea    0x203786(%rip),%rax        # 603d20 <cmdcount>
  40059a:	48 63 00             	movslq (%rax),%rax
  40059d:	48 c1 e0 06          	shl    $0x6,%rax
  4005a1:	48 01 c2             	add    %rax,%rdx
  4005a4:	48 8b 05 45 37 20 00 	mov    0x203745(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  4005ab:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  4005b2:	00 
    cmdcount = 0;
    int argcount = 0;
    int found = 0;
    int count = 0;
	//printf("reached %s, %d\n", srcPtr, strlen(srcPtr));
    while(i < len)
  4005b3:	41 39 ec             	cmp    %ebp,%r12d
  4005b6:	7e 75                	jle    40062d <parseCommand+0x287>
  4005b8:	89 ea                	mov    %ebp,%edx
  4005ba:	49 89 de             	mov    %rbx,%r14
    {
        str = srcPtr;
		//printf("str =%s \n", str);
        while((*srcPtr != ' '  && *srcPtr != '|') && i < len)
  4005bd:	41 0f b6 06          	movzbl (%r14),%eax
  4005c1:	3c 20                	cmp    $0x20,%al
  4005c3:	0f 84 39 fe ff ff    	je     400402 <parseCommand+0x5c>
  4005c9:	3c 7c                	cmp    $0x7c,%al
  4005cb:	0f 84 31 fe ff ff    	je     400402 <parseCommand+0x5c>
  4005d1:	44 39 e2             	cmp    %r12d,%edx
  4005d4:	0f 8d 35 fe ff ff    	jge    40040f <parseCommand+0x69>
  4005da:	89 d5                	mov    %edx,%ebp
  4005dc:	4c 89 f3             	mov    %r14,%rbx
  4005df:	e9 00 fe ff ff       	jmpq   4003e4 <parseCommand+0x3e>
        }
            
        if(found != 1)
        {
			//printf("final \n");
            trim(str);
  4005e4:	4c 89 f7             	mov    %r14,%rdi
  4005e7:	e8 46 fd ff ff       	callq  400332 <trim>
            int len = strlen(str);
  4005ec:	4c 89 f7             	mov    %r14,%rdi
  4005ef:	e8 3c 1f 00 00       	callq  402530 <strlen>
            if(len > 0 && count > 0)
  4005f4:	85 c0                	test   %eax,%eax
  4005f6:	0f 8e 72 ff ff ff    	jle    40056e <parseCommand+0x1c8>
  4005fc:	45 85 ed             	test   %r13d,%r13d
  4005ff:	0f 8e 69 ff ff ff    	jle    40056e <parseCommand+0x1c8>
  400605:	e9 d6 fe ff ff       	jmpq   4004e0 <parseCommand+0x13a>
            *srcPtr = '\0';
            srcPtr++;
            i++;
        }
        //printf("shashi:  %c \n", *srcPtr); 
        commands[cmdcount][argcount]=NULL;
  40060a:	4d 63 ff             	movslq %r15d,%r15
  40060d:	48 8d 05 0c 37 20 00 	lea    0x20370c(%rip),%rax        # 603d20 <cmdcount>
  400614:	48 63 00             	movslq (%rax),%rax
  400617:	48 c1 e0 06          	shl    $0x6,%rax
  40061b:	49 01 c7             	add    %rax,%r15
  40061e:	48 8b 05 cb 36 20 00 	mov    0x2036cb(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  400625:	4a c7 04 f8 00 00 00 	movq   $0x0,(%rax,%r15,8)
  40062c:	00 

    }
	//printf("parse command end \n");
	//printf("cmdcount = %d, argcount= %d \n", cmdcount, argcount);
    return cmdcount + 1;
  40062d:	48 8d 05 ec 36 20 00 	lea    0x2036ec(%rip),%rax        # 603d20 <cmdcount>
  400634:	8b 00                	mov    (%rax),%eax
  400636:	ff c0                	inc    %eax
}
  400638:	48 83 c4 18          	add    $0x18,%rsp
  40063c:	5b                   	pop    %rbx
  40063d:	5d                   	pop    %rbp
  40063e:	41 5c                	pop    %r12
  400640:	41 5d                	pop    %r13
  400642:	41 5e                	pop    %r14
  400644:	41 5f                	pop    %r15
  400646:	c3                   	retq   

0000000000400647 <setPath>:
    return NULL;
}

void setPath(char *envp[], char *newval)

{
  400647:	41 55                	push   %r13
  400649:	41 54                	push   %r12
  40064b:	55                   	push   %rbp
  40064c:	53                   	push   %rbx
  40064d:	48 83 ec 08          	sub    $0x8,%rsp
  400651:	48 89 fd             	mov    %rdi,%rbp
  400654:	49 89 f4             	mov    %rsi,%r12
			printf("In setpath %s   %s\n",newval,*envp);
  400657:	48 8b 17             	mov    (%rdi),%rdx
  40065a:	48 8d 3d 92 20 00 00 	lea    0x2092(%rip),%rdi        # 4026f3 <atoi+0x56>
  400661:	b8 00 00 00 00       	mov    $0x0,%eax
  400666:	e8 c8 14 00 00       	callq  401b33 <printf>
			trim(*envp);
  40066b:	48 8b 7d 00          	mov    0x0(%rbp),%rdi
  40066f:	e8 be fc ff ff       	callq  400332 <trim>
            int len = strlen(*envp) + strlen(newval) + 1;
  400674:	48 8b 7d 00          	mov    0x0(%rbp),%rdi
  400678:	e8 b3 1e 00 00       	callq  402530 <strlen>
  40067d:	48 89 c3             	mov    %rax,%rbx
  400680:	4c 89 e7             	mov    %r12,%rdi
  400683:	e8 a8 1e 00 00       	callq  402530 <strlen>
  400688:	44 8d 6c 03 01       	lea    0x1(%rbx,%rax,1),%r13d
            char *str = malloc(len);
  40068d:	4d 63 ed             	movslq %r13d,%r13
  400690:	4c 89 ef             	mov    %r13,%rdi
  400693:	e8 48 0c 00 00       	callq  4012e0 <malloc>
  400698:	48 89 c3             	mov    %rax,%rbx
			memset(str, 0, len);
  40069b:	4c 89 ea             	mov    %r13,%rdx
  40069e:	be 00 00 00 00       	mov    $0x0,%esi
  4006a3:	48 89 c7             	mov    %rax,%rdi
  4006a6:	e8 09 1e 00 00       	callq  4024b4 <memset>
            strcpy(str, *envp);
  4006ab:	48 8b 75 00          	mov    0x0(%rbp),%rsi
  4006af:	48 89 df             	mov    %rbx,%rdi
  4006b2:	e8 39 1e 00 00       	callq  4024f0 <strcpy>
			printf("str 1 %s\n",str);
  4006b7:	48 89 de             	mov    %rbx,%rsi
  4006ba:	48 8d 3d 46 20 00 00 	lea    0x2046(%rip),%rdi        # 402707 <atoi+0x6a>
  4006c1:	b8 00 00 00 00       	mov    $0x0,%eax
  4006c6:	e8 68 14 00 00       	callq  401b33 <printf>
            //*envp = malloc(len);
			memset(*envp, 0, 1024);
  4006cb:	ba 00 04 00 00       	mov    $0x400,%edx
  4006d0:	be 00 00 00 00       	mov    $0x0,%esi
  4006d5:	48 8b 7d 00          	mov    0x0(%rbp),%rdi
  4006d9:	e8 d6 1d 00 00       	callq  4024b4 <memset>
            strcat(str, ":");
  4006de:	48 8d 35 2c 20 00 00 	lea    0x202c(%rip),%rsi        # 402711 <atoi+0x74>
  4006e5:	48 89 df             	mov    %rbx,%rdi
  4006e8:	e8 f1 1e 00 00       	callq  4025de <strcat>
            strcat(str,newval);
  4006ed:	4c 89 e6             	mov    %r12,%rsi
  4006f0:	48 89 df             	mov    %rbx,%rdi
  4006f3:	e8 e6 1e 00 00       	callq  4025de <strcat>
			printf("str 2 %s\n",str);
  4006f8:	48 89 de             	mov    %rbx,%rsi
  4006fb:	48 8d 3d 11 20 00 00 	lea    0x2011(%rip),%rdi        # 402713 <atoi+0x76>
  400702:	b8 00 00 00 00       	mov    $0x0,%eax
  400707:	e8 27 14 00 00       	callq  401b33 <printf>
            strcpy(*envp,str);
  40070c:	48 89 de             	mov    %rbx,%rsi
  40070f:	48 8b 7d 00          	mov    0x0(%rbp),%rdi
  400713:	e8 d8 1d 00 00       	callq  4024f0 <strcpy>
			printf("str 3 %s\n",str);
  400718:	48 89 de             	mov    %rbx,%rsi
  40071b:	48 8d 3d fb 1f 00 00 	lea    0x1ffb(%rip),%rdi        # 40271d <atoi+0x80>
  400722:	b8 00 00 00 00       	mov    $0x0,%eax
  400727:	e8 07 14 00 00       	callq  401b33 <printf>
			printf("new envp %s \n",*envp);
  40072c:	48 8b 75 00          	mov    0x0(%rbp),%rsi
  400730:	48 8d 3d f0 1f 00 00 	lea    0x1ff0(%rip),%rdi        # 402727 <atoi+0x8a>
  400737:	b8 00 00 00 00       	mov    $0x0,%eax
  40073c:	e8 f2 13 00 00       	callq  401b33 <printf>
            strcpy(*envp,str);
            return;
        }
    } */
    
}
  400741:	48 83 c4 08          	add    $0x8,%rsp
  400745:	5b                   	pop    %rbx
  400746:	5d                   	pop    %rbp
  400747:	41 5c                	pop    %r12
  400749:	41 5d                	pop    %r13
  40074b:	c3                   	retq   

000000000040074c <tokenizeWithKey>:
    return NULL;
}


char* tokenizeWithKey(char *inputString, char key, char **before)
{
  40074c:	41 57                	push   %r15
  40074e:	41 56                	push   %r14
  400750:	41 55                	push   %r13
  400752:	41 54                	push   %r12
  400754:	55                   	push   %rbp
  400755:	53                   	push   %rbx
  400756:	48 83 ec 08          	sub    $0x8,%rsp
  40075a:	49 89 fd             	mov    %rdi,%r13
  40075d:	89 f3                	mov    %esi,%ebx
  40075f:	49 89 d6             	mov    %rdx,%r14
    char *srcPtr = inputString;
    char *str = NULL;
    int count = 0;
    int found = 0;
    int len = strlen(inputString);
  400762:	e8 c9 1d 00 00       	callq  402530 <strlen>
    str = srcPtr;
    while(*srcPtr != key && count < len)
  400767:	41 38 5d 00          	cmp    %bl,0x0(%r13)
  40076b:	74 22                	je     40078f <tokenizeWithKey+0x43>
  40076d:	85 c0                	test   %eax,%eax
  40076f:	7e 2e                	jle    40079f <tokenizeWithKey+0x53>
  400771:	41 89 dc             	mov    %ebx,%r12d
  400774:	89 c1                	mov    %eax,%ecx
}


char* tokenizeWithKey(char *inputString, char key, char **before)
{
    char *srcPtr = inputString;
  400776:	4c 89 eb             	mov    %r13,%rbx
    char *str = NULL;
    int count = 0;
  400779:	bd 00 00 00 00       	mov    $0x0,%ebp
    int found = 0;
    int len = strlen(inputString);
    str = srcPtr;
    while(*srcPtr != key && count < len)
    {
        srcPtr++;
  40077e:	48 ff c3             	inc    %rbx
        if(*srcPtr == key)
  400781:	44 38 23             	cmp    %r12b,(%rbx)
  400784:	0f 85 86 00 00 00    	jne    400810 <tokenizeWithKey+0xc4>
  40078a:	e9 8d 00 00 00       	jmpq   40081c <tokenizeWithKey+0xd0>
}


char* tokenizeWithKey(char *inputString, char key, char **before)
{
    char *srcPtr = inputString;
  40078f:	4c 89 eb             	mov    %r13,%rbx
    char *str = NULL;
    int count = 0;
    int found = 0;
  400792:	41 bc 00 00 00 00    	mov    $0x0,%r12d

char* tokenizeWithKey(char *inputString, char key, char **before)
{
    char *srcPtr = inputString;
    char *str = NULL;
    int count = 0;
  400798:	bd 00 00 00 00       	mov    $0x0,%ebp
  40079d:	eb 16                	jmp    4007b5 <tokenizeWithKey+0x69>
}


char* tokenizeWithKey(char *inputString, char key, char **before)
{
    char *srcPtr = inputString;
  40079f:	4c 89 eb             	mov    %r13,%rbx
    char *str = NULL;
    int count = 0;
    int found = 0;
  4007a2:	41 bc 00 00 00 00    	mov    $0x0,%r12d

char* tokenizeWithKey(char *inputString, char key, char **before)
{
    char *srcPtr = inputString;
    char *str = NULL;
    int count = 0;
  4007a8:	bd 00 00 00 00       	mov    $0x0,%ebp
  4007ad:	eb 06                	jmp    4007b5 <tokenizeWithKey+0x69>
  4007af:	41 bc 00 00 00 00    	mov    $0x0,%r12d
        srcPtr++;
        if(*srcPtr == key)
            found = 1;
        count++;
    }
    trim(str);
  4007b5:	4c 89 ef             	mov    %r13,%rdi
  4007b8:	e8 75 fb ff ff       	callq  400332 <trim>
    len = strlen(str);
  4007bd:	4c 89 ef             	mov    %r13,%rdi
  4007c0:	e8 6b 1d 00 00       	callq  402530 <strlen>
    if(len > 0)
  4007c5:	85 c0                	test   %eax,%eax
  4007c7:	7e 2c                	jle    4007f5 <tokenizeWithKey+0xa9>
    {
		//if(*before != NULL)
		//	memset(*before, 0, strlen(*before));
        *before=malloc(len);
  4007c9:	4c 63 f8             	movslq %eax,%r15
  4007cc:	4c 89 ff             	mov    %r15,%rdi
  4007cf:	e8 0c 0b 00 00       	callq  4012e0 <malloc>
  4007d4:	49 89 06             	mov    %rax,(%r14)
		memset(*before, 0, len);
  4007d7:	4c 89 fa             	mov    %r15,%rdx
  4007da:	be 00 00 00 00       	mov    $0x0,%esi
  4007df:	48 89 c7             	mov    %rax,%rdi
  4007e2:	e8 cd 1c 00 00       	callq  4024b4 <memset>
		//printf("tokenizeWithKey : %s : len = %d count = %d \n", *before, strlen(*before), count);
        strncpy(*before, str, count);
  4007e7:	48 63 d5             	movslq %ebp,%rdx
  4007ea:	4c 89 ee             	mov    %r13,%rsi
  4007ed:	49 8b 3e             	mov    (%r14),%rdi
  4007f0:	e8 14 1d 00 00       	callq  402509 <strncpy>
    {
        str = srcPtr;
        trim(str);
        return str;
    }
    return NULL;
  4007f5:	b8 00 00 00 00       	mov    $0x0,%eax
				*before[i] = '\0';
		}*/
		//printf("tokenizeWithKey :
    }
    srcPtr++;
    if(found == 1)
  4007fa:	41 83 fc 01          	cmp    $0x1,%r12d
  4007fe:	75 26                	jne    400826 <tokenizeWithKey+0xda>
    {
        str = srcPtr;
  400800:	48 ff c3             	inc    %rbx
        trim(str);
  400803:	48 89 df             	mov    %rbx,%rdi
  400806:	e8 27 fb ff ff       	callq  400332 <trim>
        return str;
  40080b:	48 89 d8             	mov    %rbx,%rax
  40080e:	eb 16                	jmp    400826 <tokenizeWithKey+0xda>
    while(*srcPtr != key && count < len)
    {
        srcPtr++;
        if(*srcPtr == key)
            found = 1;
        count++;
  400810:	ff c5                	inc    %ebp
    char *str = NULL;
    int count = 0;
    int found = 0;
    int len = strlen(inputString);
    str = srcPtr;
    while(*srcPtr != key && count < len)
  400812:	39 cd                	cmp    %ecx,%ebp
  400814:	0f 8c 64 ff ff ff    	jl     40077e <tokenizeWithKey+0x32>
  40081a:	eb 93                	jmp    4007af <tokenizeWithKey+0x63>
    {
        srcPtr++;
        if(*srcPtr == key)
            found = 1;
        count++;
  40081c:	ff c5                	inc    %ebp
    str = srcPtr;
    while(*srcPtr != key && count < len)
    {
        srcPtr++;
        if(*srcPtr == key)
            found = 1;
  40081e:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  400824:	eb 8f                	jmp    4007b5 <tokenizeWithKey+0x69>
        str = srcPtr;
        trim(str);
        return str;
    }
    return NULL;
}
  400826:	48 83 c4 08          	add    $0x8,%rsp
  40082a:	5b                   	pop    %rbx
  40082b:	5d                   	pop    %rbp
  40082c:	41 5c                	pop    %r12
  40082e:	41 5d                	pop    %r13
  400830:	41 5e                	pop    %r14
  400832:	41 5f                	pop    %r15
  400834:	c3                   	retq   

0000000000400835 <getEnvironment>:
    if(chdir(new) == -1)
        printf(" %s: no such directory \n", new);
}

char* getEnvironment(char *key, char *env[])
{
  400835:	55                   	push   %rbp
  400836:	53                   	push   %rbx
  400837:	48 81 ec 18 04 00 00 	sub    $0x418,%rsp
  40083e:	48 89 fd             	mov    %rdi,%rbp
      //  if(strstr(*env, key) != NULL)
       // {
            char *res;
            // printf("found key %s \n", *env);
            char token[MAX_LEN];
            strcpy(token, env[0]);
  400841:	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
  400846:	48 8b 36             	mov    (%rsi),%rsi
  400849:	48 89 df             	mov    %rbx,%rdi
  40084c:	e8 9f 1c 00 00       	callq  4024f0 <strcpy>
            char *before;
			
            //return tokenizeWithKey(token, '=',&before);
            res = tokenizeWithKey(token, '=',&before);
  400851:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  400856:	be 3d 00 00 00       	mov    $0x3d,%esi
  40085b:	48 89 df             	mov    %rbx,%rdi
  40085e:	e8 e9 fe ff ff       	callq  40074c <tokenizeWithKey>
  400863:	48 89 c3             	mov    %rax,%rbx
			//printf("getEnvironment %s  \n", before);
            if(strcmp(before,key)==0)
  400866:	48 89 ee             	mov    %rbp,%rsi
  400869:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  40086e:	e8 d6 1c 00 00       	callq  402549 <strcmp>
  400873:	85 c0                	test   %eax,%eax
            }
          //  continue;
        //}
    //}
	//printf("getEnvironment end \n");
    return NULL;
  400875:	b8 00 00 00 00       	mov    $0x0,%eax
  40087a:	48 0f 44 c3          	cmove  %rbx,%rax
}
  40087e:	48 81 c4 18 04 00 00 	add    $0x418,%rsp
  400885:	5b                   	pop    %rbx
  400886:	5d                   	pop    %rbp
  400887:	c3                   	retq   

0000000000400888 <changeDirectory>:
    return 0;
}


void changeDirectory(char *newdir, char *env[])
{
  400888:	48 81 ec 08 04 00 00 	sub    $0x408,%rsp
  40088f:	48 89 f8             	mov    %rdi,%rax
    char new[MAX_LEN];
    if(newdir == NULL)
  400892:	48 85 ff             	test   %rdi,%rdi
  400895:	75 19                	jne    4008b0 <changeDirectory+0x28>
    {
        strcpy(new,getEnvironment("HOME", env));
  400897:	48 8d 3d 97 1e 00 00 	lea    0x1e97(%rip),%rdi        # 402735 <atoi+0x98>
  40089e:	e8 92 ff ff ff       	callq  400835 <getEnvironment>
  4008a3:	48 89 e7             	mov    %rsp,%rdi
  4008a6:	48 89 c6             	mov    %rax,%rsi
  4008a9:	e8 42 1c 00 00       	callq  4024f0 <strcpy>
  4008ae:	eb 0b                	jmp    4008bb <changeDirectory+0x33>
    }
    else
    {
        strcpy(new, newdir);
  4008b0:	48 89 e7             	mov    %rsp,%rdi
  4008b3:	48 89 c6             	mov    %rax,%rsi
  4008b6:	e8 35 1c 00 00       	callq  4024f0 <strcpy>
    }
    if(chdir(new) == -1)
  4008bb:	48 89 e7             	mov    %rsp,%rdi
  4008be:	e8 a4 18 00 00       	callq  402167 <chdir>
  4008c3:	83 f8 ff             	cmp    $0xffffffff,%eax
  4008c6:	75 14                	jne    4008dc <changeDirectory+0x54>
        printf(" %s: no such directory \n", new);
  4008c8:	48 89 e6             	mov    %rsp,%rsi
  4008cb:	48 8d 3d 68 1e 00 00 	lea    0x1e68(%rip),%rdi        # 40273a <atoi+0x9d>
  4008d2:	b8 00 00 00 00       	mov    $0x0,%eax
  4008d7:	e8 57 12 00 00       	callq  401b33 <printf>
}
  4008dc:	48 81 c4 08 04 00 00 	add    $0x408,%rsp
  4008e3:	c3                   	retq   

00000000004008e4 <getPATH>:
    }
    return NULL;
}

void getPATH(char *envp[])
{
  4008e4:	41 55                	push   %r13
  4008e6:	41 54                	push   %r12
  4008e8:	55                   	push   %rbp
  4008e9:	53                   	push   %rbx
  4008ea:	48 81 ec 18 04 00 00 	sub    $0x418,%rsp
  4008f1:	48 89 fb             	mov    %rdi,%rbx
    //printf("environments are \n");
    while(*envp++)
    {
        if(strstr(*envp, "PATH") != NULL)
  4008f4:	4c 8d 25 91 1e 00 00 	lea    0x1e91(%rip),%r12        # 40278c <atoi+0xef>
        {
            //contails path environment
            char token[MAX_LEN];
            strcpy(token, *envp);
  4008fb:	48 8d 6c 24 10       	lea    0x10(%rsp),%rbp
            char *before;
            strcpy(path,tokenizeWithKey(token, '=',&before));
  400900:	4c 8d 6c 24 08       	lea    0x8(%rsp),%r13
}

void getPATH(char *envp[])
{
    //printf("environments are \n");
    while(*envp++)
  400905:	eb 3a                	jmp    400941 <getPATH+0x5d>
    {
        if(strstr(*envp, "PATH") != NULL)
  400907:	4c 89 e6             	mov    %r12,%rsi
  40090a:	48 8b 3b             	mov    (%rbx),%rdi
  40090d:	e8 5b 1c 00 00       	callq  40256d <strstr>
  400912:	48 85 c0             	test   %rax,%rax
  400915:	74 2a                	je     400941 <getPATH+0x5d>
        {
            //contails path environment
            char token[MAX_LEN];
            strcpy(token, *envp);
  400917:	48 8b 33             	mov    (%rbx),%rsi
  40091a:	48 89 ef             	mov    %rbp,%rdi
  40091d:	e8 ce 1b 00 00       	callq  4024f0 <strcpy>
            char *before;
            strcpy(path,tokenizeWithKey(token, '=',&before));
  400922:	4c 89 ea             	mov    %r13,%rdx
  400925:	be 3d 00 00 00       	mov    $0x3d,%esi
  40092a:	48 89 ef             	mov    %rbp,%rdi
  40092d:	e8 1a fe ff ff       	callq  40074c <tokenizeWithKey>
  400932:	48 89 c6             	mov    %rax,%rsi
  400935:	48 8b 3d 9c 33 20 00 	mov    0x20339c(%rip),%rdi        # 603cd8 <digits.1233+0x2011f8>
  40093c:	e8 af 1b 00 00       	callq  4024f0 <strcpy>
}

void getPATH(char *envp[])
{
    //printf("environments are \n");
    while(*envp++)
  400941:	48 83 c3 08          	add    $0x8,%rbx
  400945:	48 83 7b f8 00       	cmpq   $0x0,-0x8(%rbx)
  40094a:	75 bb                	jne    400907 <getPATH+0x23>
            strcpy(token, *envp);
            char *before;
            strcpy(path,tokenizeWithKey(token, '=',&before));
        }
    }
}
  40094c:	48 81 c4 18 04 00 00 	add    $0x418,%rsp
  400953:	5b                   	pop    %rbx
  400954:	5d                   	pop    %rbp
  400955:	41 5c                	pop    %r12
  400957:	41 5d                	pop    %r13
  400959:	c3                   	retq   

000000000040095a <getAbsolutePath>:
    } */
    
}

char* getAbsolutePath(char *cmd,char *envp[])
{
  40095a:	41 56                	push   %r14
  40095c:	41 55                	push   %r13
  40095e:	41 54                	push   %r12
  400960:	55                   	push   %rbp
  400961:	53                   	push   %rbx
  400962:	48 83 ec 10          	sub    $0x10,%rsp
  400966:	48 89 fb             	mov    %rdi,%rbx
  400969:	49 89 f4             	mov    %rsi,%r12
	//printf("command is %s len is %d \n",cmd, strlen(cmd));
	/*if(strcmp("cd", cmd) == 0)
    {
        return cmd;
    }*/
    if(strcmp("exit", cmd) == 0)
  40096c:	48 89 fe             	mov    %rdi,%rsi
  40096f:	48 8d 3d dd 1d 00 00 	lea    0x1ddd(%rip),%rdi        # 402753 <atoi+0xb6>
  400976:	e8 ce 1b 00 00       	callq  402549 <strcmp>
    {
        return cmd;
  40097b:	48 89 dd             	mov    %rbx,%rbp
	//printf("command is %s len is %d \n",cmd, strlen(cmd));
	/*if(strcmp("cd", cmd) == 0)
    {
        return cmd;
    }*/
    if(strcmp("exit", cmd) == 0)
  40097e:	85 c0                	test   %eax,%eax
  400980:	0f 84 ef 00 00 00    	je     400a75 <getAbsolutePath+0x11b>
    {
        return cmd;
    }
    if(strstr(cmd, "/") != NULL)
  400986:	48 8d 35 cb 1d 00 00 	lea    0x1dcb(%rip),%rsi        # 402758 <atoi+0xbb>
  40098d:	48 89 df             	mov    %rbx,%rdi
  400990:	e8 d8 1b 00 00       	callq  40256d <strstr>
  400995:	48 89 c5             	mov    %rax,%rbp
  400998:	48 85 c0             	test   %rax,%rax
  40099b:	0f 85 d1 00 00 00    	jne    400a72 <getAbsolutePath+0x118>
    {    
        return cmd;
    }
	//printf("getAbsolutePath1 \n");
	char *env_path = malloc(MAX_LEN);
  4009a1:	bf 00 04 00 00       	mov    $0x400,%edi
  4009a6:	e8 35 09 00 00       	callq  4012e0 <malloc>
  4009ab:	49 89 c5             	mov    %rax,%r13
    //printf("getAbsolutePath1 after malloc \n");
	memset(env_path, 0, MAX_LEN);
  4009ae:	ba 00 04 00 00       	mov    $0x400,%edx
  4009b3:	be 00 00 00 00       	mov    $0x0,%esi
  4009b8:	48 89 c7             	mov    %rax,%rdi
  4009bb:	e8 f4 1a 00 00       	callq  4024b4 <memset>
	strcpy(env_path,getEnvironment("PATH", envp));
  4009c0:	4c 89 e6             	mov    %r12,%rsi
  4009c3:	48 8d 3d c2 1d 00 00 	lea    0x1dc2(%rip),%rdi        # 40278c <atoi+0xef>
  4009ca:	e8 66 fe ff ff       	callq  400835 <getEnvironment>
  4009cf:	48 89 c6             	mov    %rax,%rsi
  4009d2:	4c 89 ef             	mov    %r13,%rdi
  4009d5:	e8 16 1b 00 00       	callq  4024f0 <strcpy>
	//printf("envpath is %s \n", env_path);
    char *after = NULL;
    after = env_path;
	//printf("getAbsolutePath2 envpath=%s \n", after);
	
    while(after != NULL)
  4009da:	4d 85 ed             	test   %r13,%r13
  4009dd:	0f 84 92 00 00 00    	je     400a75 <getAbsolutePath+0x11b>
    {
        char *abspath=malloc(MAX_LEN);
		memset(abspath, 0, MAX_LEN);
		//printf("command is %s len is %d \n",cmd, strlen(cmd));
        char *before;
        after = tokenizeWithKey(after, ':', &before);
  4009e3:	4c 8d 74 24 08       	lea    0x8(%rsp),%r14
    after = env_path;
	//printf("getAbsolutePath2 envpath=%s \n", after);
	
    while(after != NULL)
    {
        char *abspath=malloc(MAX_LEN);
  4009e8:	bf 00 04 00 00       	mov    $0x400,%edi
  4009ed:	e8 ee 08 00 00       	callq  4012e0 <malloc>
  4009f2:	49 89 c4             	mov    %rax,%r12
		memset(abspath, 0, MAX_LEN);
  4009f5:	ba 00 04 00 00       	mov    $0x400,%edx
  4009fa:	be 00 00 00 00       	mov    $0x0,%esi
  4009ff:	48 89 c7             	mov    %rax,%rdi
  400a02:	e8 ad 1a 00 00       	callq  4024b4 <memset>
		//printf("command is %s len is %d \n",cmd, strlen(cmd));
        char *before;
        after = tokenizeWithKey(after, ':', &before);
  400a07:	4c 89 f2             	mov    %r14,%rdx
  400a0a:	be 3a 00 00 00       	mov    $0x3a,%esi
  400a0f:	4c 89 ef             	mov    %r13,%rdi
  400a12:	e8 35 fd ff ff       	callq  40074c <tokenizeWithKey>
  400a17:	49 89 c5             	mov    %rax,%r13
		//printf("command is %s len is %d \n",cmd, strlen(cmd));
        strcpy(abspath, before);
  400a1a:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  400a1f:	4c 89 e7             	mov    %r12,%rdi
  400a22:	e8 c9 1a 00 00       	callq  4024f0 <strcpy>
        strcat(abspath, "/");
  400a27:	48 8d 35 2a 1d 00 00 	lea    0x1d2a(%rip),%rsi        # 402758 <atoi+0xbb>
  400a2e:	4c 89 e7             	mov    %r12,%rdi
  400a31:	e8 a8 1b 00 00       	callq  4025de <strcat>
        strcat(abspath,cmd);
  400a36:	48 89 de             	mov    %rbx,%rsi
  400a39:	4c 89 e7             	mov    %r12,%rdi
  400a3c:	e8 9d 1b 00 00       	callq  4025de <strcat>
        trim(abspath);
  400a41:	4c 89 e7             	mov    %r12,%rdi
  400a44:	e8 e9 f8 ff ff       	callq  400332 <trim>
		//printf("absolute path is : %s \n", abspath);
        int filedesc = open(abspath, O_RDONLY);
  400a49:	be 00 00 00 00       	mov    $0x0,%esi
  400a4e:	4c 89 e7             	mov    %r12,%rdi
  400a51:	e8 3b 17 00 00       	callq  402191 <open>
		//printf("absolute path is %s fd is %d \n", abspath, filedesc);
        if(filedesc >= 0)
  400a56:	85 c0                	test   %eax,%eax
  400a58:	78 0c                	js     400a66 <getAbsolutePath+0x10c>
        {
			//printf("getAbsolutePath absolute path is %s \n", abspath);
            close(filedesc);
  400a5a:	89 c7                	mov    %eax,%edi
  400a5c:	e8 26 18 00 00       	callq  402287 <close>
    after = env_path;
	//printf("getAbsolutePath2 envpath=%s \n", after);
	
    while(after != NULL)
    {
        char *abspath=malloc(MAX_LEN);
  400a61:	4c 89 e5             	mov    %r12,%rbp
  400a64:	eb 0f                	jmp    400a75 <getAbsolutePath+0x11b>
	//printf("envpath is %s \n", env_path);
    char *after = NULL;
    after = env_path;
	//printf("getAbsolutePath2 envpath=%s \n", after);
	
    while(after != NULL)
  400a66:	4d 85 ed             	test   %r13,%r13
  400a69:	0f 85 79 ff ff ff    	jne    4009e8 <getAbsolutePath+0x8e>
  400a6f:	90                   	nop
  400a70:	eb 03                	jmp    400a75 <getAbsolutePath+0x11b>
    {
        return cmd;
    }
    if(strstr(cmd, "/") != NULL)
    {    
        return cmd;
  400a72:	48 89 dd             	mov    %rbx,%rbp
            return abspath;
        }
    }
	//printf("getAbsolutePath4 \n");
    return NULL;
}
  400a75:	48 89 e8             	mov    %rbp,%rax
  400a78:	48 83 c4 10          	add    $0x10,%rsp
  400a7c:	5b                   	pop    %rbx
  400a7d:	5d                   	pop    %rbp
  400a7e:	41 5c                	pop    %r12
  400a80:	41 5d                	pop    %r13
  400a82:	41 5e                	pop    %r14
  400a84:	c3                   	retq   

0000000000400a85 <executeProcess>:

// void executeScript(){

// }

void executeProcess(char *envp[]){
  400a85:	55                   	push   %rbp
  400a86:	53                   	push   %rbx
  400a87:	48 81 ec 18 04 00 00 	sub    $0x418,%rsp
  400a8e:	48 89 fb             	mov    %rdi,%rbx
	//printf("executeProcess \n");
    int pid;
    int status = 0;
  400a91:	c7 84 24 0c 04 00 00 	movl   $0x0,0x40c(%rsp)
  400a98:	00 00 00 00 
    char cmd[MAX_LEN];
	//printf("executeProcess: Command is %s\n", commands[0][0]);
	
    if(handleCommand(commands[0][0], commands[0][1], envp) == 1)
  400a9c:	48 8b 05 4d 32 20 00 	mov    0x20324d(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  400aa3:	48 8b 70 08          	mov    0x8(%rax),%rsi
  400aa7:	48 89 fa             	mov    %rdi,%rdx
  400aaa:	48 8b 38             	mov    (%rax),%rdi
  400aad:	e8 f9 01 00 00       	callq  400cab <handleCommand>
  400ab2:	83 f8 01             	cmp    $0x1,%eax
  400ab5:	0f 84 f1 00 00 00    	je     400bac <executeProcess+0x127>
        return;
	//printf("executeProcess calling getAbsolutePath \n");
    if(getAbsolutePath(commands[0][0],envp) != NULL)
  400abb:	48 89 de             	mov    %rbx,%rsi
  400abe:	48 8b 05 2b 32 20 00 	mov    0x20322b(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  400ac5:	48 8b 38             	mov    (%rax),%rdi
  400ac8:	e8 8d fe ff ff       	callq  40095a <getAbsolutePath>
  400acd:	48 85 c0             	test   %rax,%rax
  400ad0:	74 30                	je     400b02 <executeProcess+0x7d>
    {
        strcpy(cmd, getAbsolutePath(commands[0][0],envp));
  400ad2:	48 89 de             	mov    %rbx,%rsi
  400ad5:	48 8b 05 14 32 20 00 	mov    0x203214(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  400adc:	48 8b 38             	mov    (%rax),%rdi
  400adf:	e8 76 fe ff ff       	callq  40095a <getAbsolutePath>
  400ae4:	48 8d 7c 24 0c       	lea    0xc(%rsp),%rdi
  400ae9:	48 89 c6             	mov    %rax,%rsi
  400aec:	e8 ff 19 00 00       	callq  4024f0 <strcpy>
        return;
    }
	
	//printf("executeProcess: before fork \n");
	//#if 0
    pid = fork();
  400af1:	e8 6c 15 00 00       	callq  402062 <fork>
  400af6:	89 c5                	mov    %eax,%ebp
    if(pid==0){
  400af8:	85 c0                	test   %eax,%eax
  400afa:	75 57                	jne    400b53 <executeProcess+0xce>
  400afc:	0f 1f 40 00          	nopl   0x0(%rax)
  400b00:	eb 20                	jmp    400b22 <executeProcess+0x9d>
        strcpy(cmd, getAbsolutePath(commands[0][0],envp));
		//printf("executeProcess:: cmd is %s \n", cmd);
    }
    else
    {
        printf("%s: Command not found. \n", commands[0][0]);
  400b02:	48 8b 05 e7 31 20 00 	mov    0x2031e7(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  400b09:	48 8b 30             	mov    (%rax),%rsi
  400b0c:	48 8d 3d 47 1c 00 00 	lea    0x1c47(%rip),%rdi        # 40275a <atoi+0xbd>
  400b13:	b8 00 00 00 00       	mov    $0x0,%eax
  400b18:	e8 16 10 00 00       	callq  401b33 <printf>
        return;
  400b1d:	e9 8a 00 00 00       	jmpq   400bac <executeProcess+0x127>
    if(pid==0){
		//printf("in Child \n");
        // printf("executeProcess\n");
        // printf("%s\n",cmd );
        //printf("%s\n", commands[0][0]);
        if(execve(cmd,&commands[0][0],envp)==-1)
  400b22:	48 8d 7c 24 0c       	lea    0xc(%rsp),%rdi
  400b27:	48 89 da             	mov    %rbx,%rdx
  400b2a:	48 8b 35 bf 31 20 00 	mov    0x2031bf(%rip),%rsi        # 603cf0 <digits.1233+0x201210>
  400b31:	e8 6d 15 00 00       	callq  4020a3 <execve>
  400b36:	83 f8 ff             	cmp    $0xffffffff,%eax
  400b39:	75 0e                	jne    400b49 <executeProcess+0xc4>
            // printf("error execute\n");
            serror(errno);
  400b3b:	48 8b 05 9e 31 20 00 	mov    0x20319e(%rip),%rax        # 603ce0 <digits.1233+0x201200>
  400b42:	8b 38                	mov    (%rax),%edi
  400b44:	e8 7c 10 00 00       	callq  401bc5 <serror>
		//sleep(1);
		//printf("in Child 1\n");
        // perror("error");
        exit(1);
  400b49:	bf 01 00 00 00       	mov    $0x1,%edi
  400b4e:	e8 9d 14 00 00       	callq  401ff0 <exit>
		printf("Argument is null \n");
	else
		printf("Arg not null \n"); */
/* 	printf("%s  %s\n", commands[0][0],commands[0][1]); */
	//printf("In Parent %d\n",pid); 
	if(commands[0][1]!=NULL){
  400b53:	48 8b 05 96 31 20 00 	mov    0x203196(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  400b5a:	48 8b 78 08          	mov    0x8(%rax),%rdi
  400b5e:	48 85 ff             	test   %rdi,%rdi
  400b61:	74 26                	je     400b89 <executeProcess+0x104>
		//printf("Argument is not null \n");
		if(strcmp(commands[0][1],"&")==0)
  400b63:	48 8d 35 09 1c 00 00 	lea    0x1c09(%rip),%rsi        # 402773 <atoi+0xd6>
  400b6a:	e8 da 19 00 00       	callq  402549 <strcmp>
  400b6f:	85 c0                	test   %eax,%eax
  400b71:	74 2a                	je     400b9d <executeProcess+0x118>
		{
			
		}
		else{
			//sleep(1);
			waitpid(pid,&status,0);
  400b73:	48 8d b4 24 0c 04 00 	lea    0x40c(%rsp),%rsi
  400b7a:	00 
  400b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  400b80:	89 ef                	mov    %ebp,%edi
  400b82:	e8 a0 18 00 00       	callq  402427 <waitpid>
  400b87:	eb 14                	jmp    400b9d <executeProcess+0x118>
		}
	}
	else{
		//sleep(1);
		waitpid(pid,&status,0);
  400b89:	48 8d b4 24 0c 04 00 	lea    0x40c(%rsp),%rsi
  400b90:	00 
  400b91:	ba 00 00 00 00       	mov    $0x0,%edx
  400b96:	89 ef                	mov    %ebp,%edi
  400b98:	e8 8a 18 00 00       	callq  402427 <waitpid>
		//no need to wait
	else*/
    	//waitpid(pid,&status,0);
	//#endif
	//printf("after waitpid %d \n", status);
    commands[0][1] = NULL;
  400b9d:	48 8b 05 4c 31 20 00 	mov    0x20314c(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  400ba4:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
  400bab:	00 
}
  400bac:	48 81 c4 18 04 00 00 	add    $0x418,%rsp
  400bb3:	5b                   	pop    %rbx
  400bb4:	5d                   	pop    %rbp
  400bb5:	c3                   	retq   

0000000000400bb6 <executeScript>:
    }
	
    return 0;
}

void executeScript(char* fname,char *envp[]){
  400bb6:	41 57                	push   %r15
  400bb8:	41 56                	push   %r14
  400bba:	41 55                	push   %r13
  400bbc:	41 54                	push   %r12
  400bbe:	55                   	push   %rbp
  400bbf:	53                   	push   %rbx
  400bc0:	48 81 ec 68 04 00 00 	sub    $0x468,%rsp
  400bc7:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
    
    int fh,size;
        char buf[65];
        int i = 0;
        char cmd[MAX_LEN];
        fh = open(fname,O_RDONLY);
  400bcc:	be 00 00 00 00       	mov    $0x0,%esi
  400bd1:	e8 bb 15 00 00       	callq  402191 <open>
  400bd6:	41 89 c4             	mov    %eax,%r12d
        size = read(fh,buf,1);
  400bd9:	48 8d b4 24 1f 04 00 	lea    0x41f(%rsp),%rsi
  400be0:	00 
  400be1:	ba 01 00 00 00       	mov    $0x1,%edx
  400be6:	89 c7                	mov    %eax,%edi
  400be8:	e8 d7 15 00 00       	callq  4021c4 <read>
        while (size > 0) {
  400bed:	85 c0                	test   %eax,%eax
  400bef:	0f 8e a4 00 00 00    	jle    400c99 <executeScript+0xe3>
  400bf5:	89 c3                	mov    %eax,%ebx

void executeScript(char* fname,char *envp[]){
    
    int fh,size;
        char buf[65];
        int i = 0;
  400bf7:	bd 00 00 00 00       	mov    $0x0,%ebp
                        cmd[i++] = buf[size -1];
                }
                else
                {
                        cmd[i] = '\0';
                        if(!strstr(cmd,"#!"))
  400bfc:	4c 8d 74 24 1f       	lea    0x1f(%rsp),%r14
  400c01:	4c 8d 3d 6d 1b 00 00 	lea    0x1b6d(%rip),%r15        # 402775 <atoi+0xd8>
                                }
                        }
                        i = 0;
                }
                buf[size] = '\0';
                size = read(fh,buf,1);
  400c08:	4c 8d ac 24 1f 04 00 	lea    0x41f(%rsp),%r13
  400c0f:	00 
        int i = 0;
        char cmd[MAX_LEN];
        fh = open(fname,O_RDONLY);
        size = read(fh,buf,1);
        while (size > 0) {
                if(buf[size -1] != '\n')
  400c10:	8d 43 ff             	lea    -0x1(%rbx),%eax
  400c13:	48 98                	cltq   
  400c15:	0f b6 84 04 1f 04 00 	movzbl 0x41f(%rsp,%rax,1),%eax
  400c1c:	00 
  400c1d:	3c 0a                	cmp    $0xa,%al
  400c1f:	74 0c                	je     400c2d <executeScript+0x77>
                {
                        cmd[i++] = buf[size -1];
  400c21:	48 63 d5             	movslq %ebp,%rdx
  400c24:	88 44 14 1f          	mov    %al,0x1f(%rsp,%rdx,1)
  400c28:	8d 6d 01             	lea    0x1(%rbp),%ebp
  400c2b:	eb 47                	jmp    400c74 <executeScript+0xbe>
                }
                else
                {
                        cmd[i] = '\0';
  400c2d:	48 63 ed             	movslq %ebp,%rbp
  400c30:	c6 44 2c 1f 00       	movb   $0x0,0x1f(%rsp,%rbp,1)
                        if(!strstr(cmd,"#!"))
  400c35:	4c 89 fe             	mov    %r15,%rsi
  400c38:	4c 89 f7             	mov    %r14,%rdi
  400c3b:	e8 2d 19 00 00       	callq  40256d <strstr>
                                     default:                             
                                        executeProcessPipe(num_args,envp);
                                        break;
                                }
                        }
                        i = 0;
  400c40:	bd 00 00 00 00       	mov    $0x0,%ebp
                        cmd[i++] = buf[size -1];
                }
                else
                {
                        cmd[i] = '\0';
                        if(!strstr(cmd,"#!"))
  400c45:	48 85 c0             	test   %rax,%rax
  400c48:	75 2a                	jne    400c74 <executeScript+0xbe>
                        {
                               int num_args;
                                num_args =  parseCommand(cmd);
  400c4a:	4c 89 f7             	mov    %r14,%rdi
  400c4d:	e8 54 f7 ff ff       	callq  4003a6 <parseCommand>
                                //printf(" arguments are %d\n",num_args );
                                switch (num_args) {
  400c52:	83 f8 01             	cmp    $0x1,%eax
  400c55:	75 0c                	jne    400c63 <executeScript+0xad>
                                    case 1:                             
                                        executeProcess(envp);
  400c57:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  400c5c:	e8 24 fe ff ff       	callq  400a85 <executeProcess>
                                        break;
  400c61:	eb 11                	jmp    400c74 <executeScript+0xbe>
                                     default:                             
                                        executeProcessPipe(num_args,envp);
  400c63:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  400c68:	89 c7                	mov    %eax,%edi
  400c6a:	e8 78 02 00 00       	callq  400ee7 <executeProcessPipe>
                                        break;
                                }
                        }
                        i = 0;
  400c6f:	bd 00 00 00 00       	mov    $0x0,%ebp
                }
                buf[size] = '\0';
  400c74:	48 63 db             	movslq %ebx,%rbx
  400c77:	c6 84 1c 1f 04 00 00 	movb   $0x0,0x41f(%rsp,%rbx,1)
  400c7e:	00 
                size = read(fh,buf,1);
  400c7f:	ba 01 00 00 00       	mov    $0x1,%edx
  400c84:	4c 89 ee             	mov    %r13,%rsi
  400c87:	44 89 e7             	mov    %r12d,%edi
  400c8a:	e8 35 15 00 00       	callq  4021c4 <read>
  400c8f:	89 c3                	mov    %eax,%ebx
        char buf[65];
        int i = 0;
        char cmd[MAX_LEN];
        fh = open(fname,O_RDONLY);
        size = read(fh,buf,1);
        while (size > 0) {
  400c91:	85 c0                	test   %eax,%eax
  400c93:	0f 8f 77 ff ff ff    	jg     400c10 <executeScript+0x5a>
                }
                buf[size] = '\0';
                size = read(fh,buf,1);
        }
    
}
  400c99:	48 81 c4 68 04 00 00 	add    $0x468,%rsp
  400ca0:	5b                   	pop    %rbx
  400ca1:	5d                   	pop    %rbp
  400ca2:	41 5c                	pop    %r12
  400ca4:	41 5d                	pop    %r13
  400ca6:	41 5e                	pop    %r14
  400ca8:	41 5f                	pop    %r15
  400caa:	c3                   	retq   

0000000000400cab <handleCommand>:
   // printf("%s\n in function", value);
    return value;
}

int handleCommand(char *cmd, char *args, char *env[])
{
  400cab:	41 54                	push   %r12
  400cad:	55                   	push   %rbp
  400cae:	53                   	push   %rbx
  400caf:	48 81 ec 00 04 00 00 	sub    $0x400,%rsp
  400cb6:	48 89 fb             	mov    %rdi,%rbx
  400cb9:	48 89 f5             	mov    %rsi,%rbp
  400cbc:	49 89 d4             	mov    %rdx,%r12
	//printf("handle command:: cmd is %s \n", cmd);
    if(strcmp("set",cmd)==0&&args!=NULL){
  400cbf:	48 89 fe             	mov    %rdi,%rsi
  400cc2:	48 8d 3d af 1a 00 00 	lea    0x1aaf(%rip),%rdi        # 402778 <atoi+0xdb>
  400cc9:	e8 7b 18 00 00       	callq  402549 <strcmp>
  400cce:	85 c0                	test   %eax,%eax
  400cd0:	0f 85 d8 00 00 00    	jne    400dae <handleCommand+0x103>
  400cd6:	48 85 ed             	test   %rbp,%rbp
  400cd9:	0f 84 cf 00 00 00    	je     400dae <handleCommand+0x103>
        if(strstr(args,"PS1")){
  400cdf:	48 8d 35 96 1a 00 00 	lea    0x1a96(%rip),%rsi        # 40277c <atoi+0xdf>
  400ce6:	48 89 ef             	mov    %rbp,%rdi
  400ce9:	e8 7f 18 00 00       	callq  40256d <strstr>
  400cee:	48 85 c0             	test   %rax,%rax
  400cf1:	0f 84 86 00 00 00    	je     400d7d <handleCommand+0xd2>
            char temp[MAX_LEN] = "";
  400cf7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  400cfe:	00 
  400cff:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  400d04:	b9 7f 00 00 00       	mov    $0x7f,%ecx
  400d09:	b8 00 00 00 00       	mov    $0x0,%eax
  400d0e:	f3 48 ab             	rep stos %rax,%es:(%rdi)
            int i = 2;
            if(commands[0][i] == NULL)
  400d11:	48 8b 05 d8 2f 20 00 	mov    0x202fd8(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  400d18:	48 83 78 10 00       	cmpq   $0x0,0x10(%rax)
  400d1d:	75 11                	jne    400d30 <handleCommand+0x85>
            {
                printf("Usage: set PS1 <prompt string>\n");
  400d1f:	48 8d 3d ea 1a 00 00 	lea    0x1aea(%rip),%rdi        # 402810 <atoi+0x173>
  400d26:	b8 00 00 00 00       	mov    $0x0,%eax
  400d2b:	e8 03 0e 00 00       	callq  401b33 <printf>
  400d30:	48 8b 05 b9 2f 20 00 	mov    0x202fb9(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  400d37:	48 8d 58 10          	lea    0x10(%rax),%rbx
            }
            while(commands[0][i] != NULL)
            {
                if(commands[0][i]!=NULL){
                    strcat(temp,commands[0][i]);
  400d3b:	48 89 e5             	mov    %rsp,%rbp
  400d3e:	eb 17                	jmp    400d57 <handleCommand+0xac>
  400d40:	48 89 ef             	mov    %rbp,%rdi
  400d43:	e8 96 18 00 00       	callq  4025de <strcat>
                    strcat(temp, " ");
  400d48:	48 8d 35 84 19 00 00 	lea    0x1984(%rip),%rsi        # 4026d3 <atoi+0x36>
  400d4f:	48 89 ef             	mov    %rbp,%rdi
  400d52:	e8 87 18 00 00       	callq  4025de <strcat>
  400d57:	48 83 c3 08          	add    $0x8,%rbx
            int i = 2;
            if(commands[0][i] == NULL)
            {
                printf("Usage: set PS1 <prompt string>\n");
            }
            while(commands[0][i] != NULL)
  400d5b:	48 8b 73 f8          	mov    -0x8(%rbx),%rsi
  400d5f:	48 85 f6             	test   %rsi,%rsi
  400d62:	75 dc                	jne    400d40 <handleCommand+0x95>
                    strcat(temp,commands[0][i]);
                    strcat(temp, " ");
                    i++;
                }
            }
            strcpy(PS1,temp);
  400d64:	48 89 e6             	mov    %rsp,%rsi
  400d67:	48 8d 3d d2 2f 20 00 	lea    0x202fd2(%rip),%rdi        # 603d40 <PS1>
  400d6e:	e8 7d 17 00 00       	callq  4024f0 <strcpy>
            return 1;
  400d73:	b8 01 00 00 00       	mov    $0x1,%eax
  400d78:	e9 5e 01 00 00       	jmpq   400edb <handleCommand+0x230>
        }
        if(strstr(args,"PATH")){
  400d7d:	48 8d 35 08 1a 00 00 	lea    0x1a08(%rip),%rsi        # 40278c <atoi+0xef>
  400d84:	48 89 ef             	mov    %rbp,%rdi
  400d87:	e8 e1 17 00 00       	callq  40256d <strstr>
  400d8c:	48 85 c0             	test   %rax,%rax
  400d8f:	74 1d                	je     400dae <handleCommand+0x103>
            setPath(env,commands[0][2]);
  400d91:	48 8b 05 58 2f 20 00 	mov    0x202f58(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  400d98:	48 8b 70 10          	mov    0x10(%rax),%rsi
  400d9c:	4c 89 e7             	mov    %r12,%rdi
  400d9f:	e8 a3 f8 ff ff       	callq  400647 <setPath>
            return 1;
  400da4:	b8 01 00 00 00       	mov    $0x1,%eax
  400da9:	e9 2d 01 00 00       	jmpq   400edb <handleCommand+0x230>
        }
    }
    if(strstr(cmd,".sbush")){
  400dae:	48 8d 35 cb 19 00 00 	lea    0x19cb(%rip),%rsi        # 402780 <atoi+0xe3>
  400db5:	48 89 df             	mov    %rbx,%rdi
  400db8:	e8 b0 17 00 00       	callq  40256d <strstr>
  400dbd:	48 85 c0             	test   %rax,%rax
  400dc0:	74 15                	je     400dd7 <handleCommand+0x12c>
        // printf("%s\n", cmd);
        executeScript(cmd,env);
  400dc2:	4c 89 e6             	mov    %r12,%rsi
  400dc5:	48 89 df             	mov    %rbx,%rdi
  400dc8:	e8 e9 fd ff ff       	callq  400bb6 <executeScript>
        return 1;
  400dcd:	b8 01 00 00 00       	mov    $0x1,%eax
  400dd2:	e9 04 01 00 00       	jmpq   400edb <handleCommand+0x230>
    }
    if(strcmp("env",cmd)==0){
  400dd7:	48 89 de             	mov    %rbx,%rsi
  400dda:	48 8d 3d a6 19 00 00 	lea    0x19a6(%rip),%rdi        # 402787 <atoi+0xea>
  400de1:	e8 63 17 00 00       	callq  402549 <strcmp>
  400de6:	85 c0                	test   %eax,%eax
  400de8:	75 12                	jne    400dfc <handleCommand+0x151>
        printEnvironments(env);
  400dea:	4c 89 e7             	mov    %r12,%rdi
  400ded:	e8 e9 f3 ff ff       	callq  4001db <printEnvironments>
        return 1;
  400df2:	b8 01 00 00 00       	mov    $0x1,%eax
  400df7:	e9 df 00 00 00       	jmpq   400edb <handleCommand+0x230>
    }
    if(strcmp("$PATH",cmd) == 0)
  400dfc:	48 89 de             	mov    %rbx,%rsi
  400dff:	48 8d 3d 85 19 00 00 	lea    0x1985(%rip),%rdi        # 40278b <atoi+0xee>
  400e06:	e8 3e 17 00 00       	callq  402549 <strcmp>
  400e0b:	85 c0                	test   %eax,%eax
  400e0d:	75 1a                	jne    400e29 <handleCommand+0x17e>
    {
        //printf("%s\n",getEnvironment("PATH",env));
		printf("%s\n",env[0]);
  400e0f:	49 8b 34 24          	mov    (%r12),%rsi
  400e13:	48 8d 3d e9 18 00 00 	lea    0x18e9(%rip),%rdi        # 402703 <atoi+0x66>
  400e1a:	e8 14 0d 00 00       	callq  401b33 <printf>
        return 1;
  400e1f:	b8 01 00 00 00       	mov    $0x1,%eax
  400e24:	e9 b2 00 00 00       	jmpq   400edb <handleCommand+0x230>
    }
    if(strcmp("exit", cmd) == 0)
  400e29:	48 89 de             	mov    %rbx,%rsi
  400e2c:	48 8d 3d 20 19 00 00 	lea    0x1920(%rip),%rdi        # 402753 <atoi+0xb6>
  400e33:	e8 11 17 00 00       	callq  402549 <strcmp>
  400e38:	85 c0                	test   %eax,%eax
  400e3a:	75 16                	jne    400e52 <handleCommand+0x1a7>
    {
		printf("in exit\n");
  400e3c:	48 8d 3d 4e 19 00 00 	lea    0x194e(%rip),%rdi        # 402791 <atoi+0xf4>
  400e43:	e8 eb 0c 00 00       	callq  401b33 <printf>
        exit(1);
  400e48:	bf 01 00 00 00       	mov    $0x1,%edi
  400e4d:	e8 9e 11 00 00       	callq  401ff0 <exit>
    /*if(strcmp("cd", cmd) == 0)
    {
        changeDirectory(args, env);
        return 1;
    }*/
	if(strcmp("clear", cmd) == 0)
  400e52:	48 89 de             	mov    %rbx,%rsi
  400e55:	48 8d 3d 3e 19 00 00 	lea    0x193e(%rip),%rdi        # 40279a <atoi+0xfd>
  400e5c:	e8 e8 16 00 00       	callq  402549 <strcmp>
  400e61:	85 c0                	test   %eax,%eax
  400e63:	75 0c                	jne    400e71 <handleCommand+0x1c6>
    {
        cls();
  400e65:	e8 7d 12 00 00       	callq  4020e7 <cls>
        return 1;
  400e6a:	b8 01 00 00 00       	mov    $0x1,%eax
  400e6f:	eb 6a                	jmp    400edb <handleCommand+0x230>
    }
	if(strcmp("pwd", cmd) == 0)
  400e71:	48 89 de             	mov    %rbx,%rsi
  400e74:	48 8d 3d 25 19 00 00 	lea    0x1925(%rip),%rdi        # 4027a0 <atoi+0x103>
  400e7b:	e8 c9 16 00 00       	callq  402549 <strcmp>
  400e80:	89 c2                	mov    %eax,%edx
   	 else
            printf("getcwd() error : ");
     return 1;
    }
		
    return 0;
  400e82:	b8 00 00 00 00       	mov    $0x0,%eax
	if(strcmp("clear", cmd) == 0)
    {
        cls();
        return 1;
    }
	if(strcmp("pwd", cmd) == 0)
  400e87:	85 d2                	test   %edx,%edx
  400e89:	75 50                	jne    400edb <handleCommand+0x230>
    {
		  char *buf;
      buf = malloc(1024);
  400e8b:	bf 00 04 00 00       	mov    $0x400,%edi
  400e90:	e8 4b 04 00 00       	callq  4012e0 <malloc>
  400e95:	48 89 c3             	mov    %rax,%rbx
    	if((getcwd(buf, 1024)) != NULL)
  400e98:	be 00 04 00 00       	mov    $0x400,%esi
  400e9d:	48 89 c7             	mov    %rax,%rdi
  400ea0:	e8 7a 12 00 00       	callq  40211f <getcwd>
  400ea5:	48 85 c0             	test   %rax,%rax
  400ea8:	74 1b                	je     400ec5 <handleCommand+0x21a>
            printf("%s\n", buf);
  400eaa:	48 89 de             	mov    %rbx,%rsi
  400ead:	48 8d 3d 4f 18 00 00 	lea    0x184f(%rip),%rdi        # 402703 <atoi+0x66>
  400eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  400eb9:	e8 75 0c 00 00       	callq  401b33 <printf>
   	 else
            printf("getcwd() error : ");
     return 1;
  400ebe:	b8 01 00 00 00       	mov    $0x1,%eax
  400ec3:	eb 16                	jmp    400edb <handleCommand+0x230>
		  char *buf;
      buf = malloc(1024);
    	if((getcwd(buf, 1024)) != NULL)
            printf("%s\n", buf);
   	 else
            printf("getcwd() error : ");
  400ec5:	48 8d 3d d8 18 00 00 	lea    0x18d8(%rip),%rdi        # 4027a4 <atoi+0x107>
  400ecc:	b8 00 00 00 00       	mov    $0x0,%eax
  400ed1:	e8 5d 0c 00 00       	callq  401b33 <printf>
     return 1;
  400ed6:	b8 01 00 00 00       	mov    $0x1,%eax
    }
		
    return 0;
}
  400edb:	48 81 c4 00 04 00 00 	add    $0x400,%rsp
  400ee2:	5b                   	pop    %rbx
  400ee3:	5d                   	pop    %rbp
  400ee4:	41 5c                	pop    %r12
  400ee6:	c3                   	retq   

0000000000400ee7 <executeProcessPipe>:
	//#endif
	//printf("after waitpid %d \n", status);
    commands[0][1] = NULL;
}

void executeProcessPipe(int n,char *envp[]){
  400ee7:	41 57                	push   %r15
  400ee9:	41 56                	push   %r14
  400eeb:	41 55                	push   %r13
  400eed:	41 54                	push   %r12
  400eef:	55                   	push   %rbp
  400ef0:	53                   	push   %rbx
  400ef1:	48 81 ec 28 04 00 00 	sub    $0x428,%rsp
  400ef8:	41 89 fd             	mov    %edi,%r13d
  400efb:	48 89 f5             	mov    %rsi,%rbp
    int fd[2];
    int pid=0,status;
    int found = 0, i;
    int prev=0;
    
    for(i=0;i<n;i++)
  400efe:	85 ff                	test   %edi,%edi
  400f00:	7e 65                	jle    400f67 <executeProcessPipe+0x80>
  400f02:	44 8d 77 ff          	lea    -0x1(%rdi),%r14d
  400f06:	49 ff c6             	inc    %r14
  400f09:	49 c1 e6 09          	shl    $0x9,%r14
  400f0d:	bb 00 00 00 00       	mov    $0x0,%ebx

void executeProcessPipe(int n,char *envp[]){
    char cmd[MAX_LEN];
    int fd[2];
    int pid=0,status;
    int found = 0, i;
  400f12:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    int prev=0;
    
    for(i=0;i<n;i++)
    {
        if(getAbsolutePath(commands[i][0],envp) == NULL)
  400f18:	4c 8b 25 d1 2d 20 00 	mov    0x202dd1(%rip),%r12        # 603cf0 <digits.1233+0x201210>
  400f1f:	4a 8b 3c 23          	mov    (%rbx,%r12,1),%rdi
  400f23:	48 89 ee             	mov    %rbp,%rsi
  400f26:	e8 2f fa ff ff       	callq  40095a <getAbsolutePath>
  400f2b:	48 85 c0             	test   %rax,%rax
  400f2e:	75 22                	jne    400f52 <executeProcessPipe+0x6b>
        {
            printf("%s: Command not found. \n", commands[i][0]);
  400f30:	48 8b 05 b9 2d 20 00 	mov    0x202db9(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  400f37:	48 8b 34 03          	mov    (%rbx,%rax,1),%rsi
  400f3b:	48 8d 3d 18 18 00 00 	lea    0x1818(%rip),%rdi        # 40275a <atoi+0xbd>
  400f42:	b8 00 00 00 00       	mov    $0x0,%eax
  400f47:	e8 e7 0b 00 00       	callq  401b33 <printf>
            found = 1;
  400f4c:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  400f52:	48 81 c3 00 02 00 00 	add    $0x200,%rbx
    int fd[2];
    int pid=0,status;
    int found = 0, i;
    int prev=0;
    
    for(i=0;i<n;i++)
  400f59:	4c 39 f3             	cmp    %r14,%rbx
  400f5c:	75 c1                	jne    400f1f <executeProcessPipe+0x38>
            found = 1;
        }
    }
    //printf("found absolute path \n");
	
    if(found)
  400f5e:	45 85 ff             	test   %r15d,%r15d
  400f61:	0f 85 d5 01 00 00    	jne    40113c <executeProcessPipe+0x255>
        return;
    
    pid = fork();
  400f67:	e8 f6 10 00 00       	callq  402062 <fork>
  400f6c:	41 89 c4             	mov    %eax,%r12d
    if(pid ==0)
  400f6f:	85 c0                	test   %eax,%eax
  400f71:	0f 85 7d 01 00 00    	jne    4010f4 <executeProcessPipe+0x20d>
    {
		//printf("in child \n");
		//while(1);
		//int pid2;
        for (i = 0; i < n-1; ++i)
  400f77:	41 8d 45 ff          	lea    -0x1(%r13),%eax
  400f7b:	85 c0                	test   %eax,%eax
  400f7d:	0f 8e ed 00 00 00    	jle    401070 <executeProcessPipe+0x189>
  400f83:	48 8b 1d 66 2d 20 00 	mov    0x202d66(%rip),%rbx        # 603cf0 <digits.1233+0x201210>
  400f8a:	41 8d 45 fe          	lea    -0x2(%r13),%eax
  400f8e:	48 c1 e0 09          	shl    $0x9,%rax
  400f92:	48 8d 84 03 00 02 00 	lea    0x200(%rbx,%rax,1),%rax
  400f99:	00 
  400f9a:	48 89 04 24          	mov    %rax,(%rsp)
  400f9e:	41 be 00 00 00 00    	mov    $0x0,%r14d
        {
            pipe (fd);
  400fa4:	48 8d 44 24 18       	lea    0x18(%rsp),%rax
  400fa9:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
					//printf("shashi \n");
                    dup2(fd[1],1);
                    //close(fd[1]);
                }
				
                strcpy(cmd, getAbsolutePath(commands[i][0],envp));
  400fae:	4c 8d 7c 24 20       	lea    0x20(%rsp),%r15
		//printf("in child \n");
		//while(1);
		//int pid2;
        for (i = 0; i < n-1; ++i)
        {
            pipe (fd);
  400fb3:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  400fb8:	e8 f4 12 00 00       	callq  4022b1 <pipe>
            pid = fork();
  400fbd:	e8 a0 10 00 00       	callq  402062 <fork>
  400fc2:	41 89 c4             	mov    %eax,%r12d
			//printf("second fork \n");
			//while(1);
            if(pid==0)
  400fc5:	85 c0                	test   %eax,%eax
  400fc7:	75 79                	jne    401042 <executeProcessPipe+0x15b>
            {
				//printf("first command %s \n", getAbsolutePath(commands[i][0],envp));
                if(prev != 0)
  400fc9:	45 85 f6             	test   %r14d,%r14d
  400fcc:	74 0d                	je     400fdb <executeProcessPipe+0xf4>
                {
                    dup2 (prev,0);
  400fce:	be 00 00 00 00       	mov    $0x0,%esi
  400fd3:	44 89 f7             	mov    %r14d,%edi
  400fd6:	e8 37 13 00 00       	callq  402312 <dup2>
                    //close(prev);
                }
                if(fd[1] != 1)
  400fdb:	8b 7c 24 1c          	mov    0x1c(%rsp),%edi
  400fdf:	83 ff 01             	cmp    $0x1,%edi
  400fe2:	74 0a                	je     400fee <executeProcessPipe+0x107>
                {
					//printf("shashi \n");
                    dup2(fd[1],1);
  400fe4:	be 01 00 00 00       	mov    $0x1,%esi
  400fe9:	e8 24 13 00 00       	callq  402312 <dup2>
                    //close(fd[1]);
                }
				
                strcpy(cmd, getAbsolutePath(commands[i][0],envp));
  400fee:	48 89 ee             	mov    %rbp,%rsi
  400ff1:	48 8b 3b             	mov    (%rbx),%rdi
  400ff4:	e8 61 f9 ff ff       	callq  40095a <getAbsolutePath>
  400ff9:	48 89 c6             	mov    %rax,%rsi
  400ffc:	4c 89 ff             	mov    %r15,%rdi
  400fff:	e8 ec 14 00 00       	callq  4024f0 <strcpy>
				//printf("first command successfull %s \n",cmd);
                if(handleCommand(cmd, commands[i][1], envp) == 0)
  401004:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  401008:	48 89 ea             	mov    %rbp,%rdx
  40100b:	4c 89 ff             	mov    %r15,%rdi
  40100e:	e8 98 fc ff ff       	callq  400cab <handleCommand>
  401013:	85 c0                	test   %eax,%eax
  401015:	75 21                	jne    401038 <executeProcessPipe+0x151>
                {
					//printf("Executing first command \n");
                    if(execve(cmd,&commands[i][0],envp)==-1)
  401017:	48 89 ea             	mov    %rbp,%rdx
  40101a:	48 89 de             	mov    %rbx,%rsi
  40101d:	4c 89 ff             	mov    %r15,%rdi
  401020:	e8 7e 10 00 00       	callq  4020a3 <execve>
  401025:	83 f8 ff             	cmp    $0xffffffff,%eax
  401028:	75 0e                	jne    401038 <executeProcessPipe+0x151>
                        // printf("error\n");
                        serror(errno);
  40102a:	48 8b 05 af 2c 20 00 	mov    0x202caf(%rip),%rax        # 603ce0 <digits.1233+0x201200>
  401031:	8b 38                	mov    (%rax),%edi
  401033:	e8 8d 0b 00 00       	callq  401bc5 <serror>
                }
                exit(1);
  401038:	bf 01 00 00 00       	mov    $0x1,%edi
  40103d:	e8 ae 0f 00 00       	callq  401ff0 <exit>
            }
			//waitpid(pid2,&status,0);
            //close (fd [1]);
            prev= fd [0];
  401042:	44 8b 74 24 18       	mov    0x18(%rsp),%r14d
  401047:	48 81 c3 00 02 00 00 	add    $0x200,%rbx
    if(pid ==0)
    {
		//printf("in child \n");
		//while(1);
		//int pid2;
        for (i = 0; i < n-1; ++i)
  40104e:	48 3b 1c 24          	cmp    (%rsp),%rbx
  401052:	0f 85 5b ff ff ff    	jne    400fb3 <executeProcessPipe+0xcc>
  401058:	45 8d 7d ff          	lea    -0x1(%r13),%r15d
            //close (fd [1]);
            prev= fd [0];
        }
		//waitpid(pid,&status,0);
        //sleep(1);
		if (prev != 0)
  40105c:	45 85 f6             	test   %r14d,%r14d
  40105f:	74 15                	je     401076 <executeProcessPipe+0x18f>
            dup2 (prev, 0);
  401061:	be 00 00 00 00       	mov    $0x0,%esi
  401066:	44 89 f7             	mov    %r14d,%edi
  401069:	e8 a4 12 00 00       	callq  402312 <dup2>
  40106e:	eb 06                	jmp    401076 <executeProcessPipe+0x18f>
    if(pid ==0)
    {
		//printf("in child \n");
		//while(1);
		//int pid2;
        for (i = 0; i < n-1; ++i)
  401070:	41 bf 00 00 00 00    	mov    $0x0,%r15d
        }
		//waitpid(pid,&status,0);
        //sleep(1);
		if (prev != 0)
            dup2 (prev, 0);
        strcpy(cmd, getAbsolutePath(commands[i][0],envp));
  401076:	4d 63 f7             	movslq %r15d,%r14
  401079:	49 c1 e6 09          	shl    $0x9,%r14
  40107d:	4c 03 35 6c 2c 20 00 	add    0x202c6c(%rip),%r14        # 603cf0 <digits.1233+0x201210>
  401084:	48 89 ee             	mov    %rbp,%rsi
  401087:	49 8b 3e             	mov    (%r14),%rdi
  40108a:	e8 cb f8 ff ff       	callq  40095a <getAbsolutePath>
  40108f:	48 8d 5c 24 20       	lea    0x20(%rsp),%rbx
  401094:	48 89 c6             	mov    %rax,%rsi
  401097:	48 89 df             	mov    %rbx,%rdi
  40109a:	e8 51 14 00 00       	callq  4024f0 <strcpy>
		sleep(1);
  40109f:	bf 01 00 00 00       	mov    $0x1,%edi
  4010a4:	e8 4c 10 00 00       	callq  4020f5 <sleep>
		//printf("second command %s \n",cmd);
        if(handleCommand(cmd, commands[i][1], envp) == 0)
  4010a9:	48 89 ea             	mov    %rbp,%rdx
  4010ac:	49 8b 76 08          	mov    0x8(%r14),%rsi
  4010b0:	48 89 df             	mov    %rbx,%rdi
  4010b3:	e8 f3 fb ff ff       	callq  400cab <handleCommand>
  4010b8:	85 c0                	test   %eax,%eax
  4010ba:	75 2e                	jne    4010ea <executeProcessPipe+0x203>
        {
            if(execve(cmd,&commands[i][0],envp)==-1)
  4010bc:	49 63 f7             	movslq %r15d,%rsi
  4010bf:	48 c1 e6 09          	shl    $0x9,%rsi
  4010c3:	48 03 35 26 2c 20 00 	add    0x202c26(%rip),%rsi        # 603cf0 <digits.1233+0x201210>
  4010ca:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  4010cf:	48 89 ea             	mov    %rbp,%rdx
  4010d2:	e8 cc 0f 00 00       	callq  4020a3 <execve>
  4010d7:	83 f8 ff             	cmp    $0xffffffff,%eax
  4010da:	75 0e                	jne    4010ea <executeProcessPipe+0x203>
                // printf("error\n");
                serror(errno);
  4010dc:	48 8b 05 fd 2b 20 00 	mov    0x202bfd(%rip),%rax        # 603ce0 <digits.1233+0x201200>
  4010e3:	8b 38                	mov    (%rax),%edi
  4010e5:	e8 db 0a 00 00       	callq  401bc5 <serror>
        }
        exit(1);
  4010ea:	bf 01 00 00 00       	mov    $0x1,%edi
  4010ef:	e8 fc 0e 00 00       	callq  401ff0 <exit>
    }
    waitpid(pid,&status,0);
  4010f4:	48 8d 74 24 14       	lea    0x14(%rsp),%rsi
  4010f9:	ba 00 00 00 00       	mov    $0x0,%edx
  4010fe:	44 89 e7             	mov    %r12d,%edi
  401101:	e8 21 13 00 00       	callq  402427 <waitpid>
	//listprocess();
	printf("parent exit \n");
  401106:	48 8d 3d a9 16 00 00 	lea    0x16a9(%rip),%rdi        # 4027b6 <atoi+0x119>
  40110d:	b8 00 00 00 00       	mov    $0x0,%eax
  401112:	e8 1c 0a 00 00       	callq  401b33 <printf>
    for(i=0;i<n;i++)
  401117:	45 85 ed             	test   %r13d,%r13d
  40111a:	7e 20                	jle    40113c <executeProcessPipe+0x255>
    {
        commands[i][1] = NULL;
  40111c:	48 8b 05 cd 2b 20 00 	mov    0x202bcd(%rip),%rax        # 603cf0 <digits.1233+0x201210>
  401123:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
  40112a:	00 
        exit(1);
    }
    waitpid(pid,&status,0);
	//listprocess();
	printf("parent exit \n");
    for(i=0;i<n;i++)
  40112b:	41 83 fd 01          	cmp    $0x1,%r13d
  40112f:	7e 0b                	jle    40113c <executeProcessPipe+0x255>
    {
        commands[i][1] = NULL;
  401131:	48 c7 80 08 02 00 00 	movq   $0x0,0x208(%rax)
  401138:	00 00 00 00 
    }
}
  40113c:	48 81 c4 28 04 00 00 	add    $0x428,%rsp
  401143:	5b                   	pop    %rbx
  401144:	5d                   	pop    %rbp
  401145:	41 5c                	pop    %r12
  401147:	41 5d                	pop    %r13
  401149:	41 5e                	pop    %r14
  40114b:	41 5f                	pop    %r15
  40114d:	c3                   	retq   

000000000040114e <welcome>:
{
    return (c == ' ' || c == '\t' || c == '\n' || c == '\12');
}

void welcome()
{
  40114e:	48 83 ec 08          	sub    $0x8,%rsp
    printf("\n-------------------------------------------------\n");
  401152:	48 8d 3d d7 16 00 00 	lea    0x16d7(%rip),%rdi        # 402830 <atoi+0x193>
  401159:	b8 00 00 00 00       	mov    $0x0,%eax
  40115e:	e8 d0 09 00 00       	callq  401b33 <printf>
    printf("\tWelcome to SBUSH \n");
  401163:	48 8d 3d 5a 16 00 00 	lea    0x165a(%rip),%rdi        # 4027c4 <atoi+0x127>
  40116a:	b8 00 00 00 00       	mov    $0x0,%eax
  40116f:	e8 bf 09 00 00       	callq  401b33 <printf>
    printf("-------------------------------------------------\n");
  401174:	48 8d 3d ed 16 00 00 	lea    0x16ed(%rip),%rdi        # 402868 <atoi+0x1cb>
  40117b:	b8 00 00 00 00       	mov    $0x0,%eax
  401180:	e8 ae 09 00 00       	callq  401b33 <printf>
    printf("\n\n");
  401185:	48 8d 3d 4c 16 00 00 	lea    0x164c(%rip),%rdi        # 4027d8 <atoi+0x13b>
  40118c:	b8 00 00 00 00       	mov    $0x0,%eax
  401191:	e8 9d 09 00 00       	callq  401b33 <printf>
}
  401196:	48 83 c4 08          	add    $0x8,%rsp
  40119a:	c3                   	retq   

000000000040119b <main>:
char* tokenizeWithKey(char *inputString, char key, char **before);
void executeScript(char* name, char *env[]);
void serror(int ernum);


int main(int argc,char *argv[],char *envP[]){
  40119b:	41 55                	push   %r13
  40119d:	41 54                	push   %r12
  40119f:	55                   	push   %rbp
  4011a0:	53                   	push   %rbx
  4011a1:	48 81 ec 08 04 00 00 	sub    $0x408,%rsp
  4011a8:	41 89 fc             	mov    %edi,%r12d
  4011ab:	48 89 f5             	mov    %rsi,%rbp
  4011ae:	49 89 d5             	mov    %rdx,%r13
    int script =1;
	envp[0] = malloc(1024);
  4011b1:	bf 00 04 00 00       	mov    $0x400,%edi
  4011b6:	e8 25 01 00 00       	callq  4012e0 <malloc>
  4011bb:	48 8b 1d 26 2b 20 00 	mov    0x202b26(%rip),%rbx        # 603ce8 <digits.1233+0x201208>
  4011c2:	48 89 03             	mov    %rax,(%rbx)
	memset(envp[0],0,1024);
  4011c5:	ba 00 04 00 00       	mov    $0x400,%edx
  4011ca:	be 00 00 00 00       	mov    $0x0,%esi
  4011cf:	48 89 c7             	mov    %rax,%rdi
  4011d2:	e8 dd 12 00 00       	callq  4024b4 <memset>
	strcpy(envp[0],envP[0]);
  4011d7:	49 8b 75 00          	mov    0x0(%r13),%rsi
  4011db:	48 8b 3b             	mov    (%rbx),%rdi
  4011de:	e8 0d 13 00 00       	callq  4024f0 <strcpy>
    if(argc==2){
  4011e3:	41 83 fc 02          	cmp    $0x2,%r12d
  4011e7:	75 61                	jne    40124a <main+0xaf>
        executeScript(argv[1],envp);
  4011e9:	48 8b 7d 08          	mov    0x8(%rbp),%rdi
  4011ed:	48 8b 35 f4 2a 20 00 	mov    0x202af4(%rip),%rsi        # 603ce8 <digits.1233+0x201208>
  4011f4:	e8 bd f9 ff ff       	callq  400bb6 <executeScript>
    while(1)
	{
        int num_args;
        char input_line[MAX_LEN];
        printPrompt();
        if(readInput(input_line) == 1)
  4011f9:	48 89 e3             	mov    %rsp,%rbx
	//return 0;
    while(1)
	{
        int num_args;
        char input_line[MAX_LEN];
        printPrompt();
  4011fc:	b8 00 00 00 00       	mov    $0x0,%eax
  401201:	e8 2a ef ff ff       	callq  400130 <printPrompt>
        if(readInput(input_line) == 1)
  401206:	48 89 df             	mov    %rbx,%rdi
  401209:	e8 f8 ef ff ff       	callq  400206 <readInput>
  40120e:	83 f8 01             	cmp    $0x1,%eax
  401211:	75 e9                	jne    4011fc <main+0x61>
			for(int i = 0; i < len; i++)
			{
				printf("%d , %c \n", i, input_line[i]);	
			}*/
			//#if 0
			int len = strlen(input_line);
  401213:	48 89 df             	mov    %rbx,%rdi
  401216:	e8 15 13 00 00       	callq  402530 <strlen>
            if(len < 1)
  40121b:	85 c0                	test   %eax,%eax
  40121d:	7e dd                	jle    4011fc <main+0x61>
                continue;
            num_args =  parseCommand(input_line);
  40121f:	48 89 df             	mov    %rbx,%rdi
  401222:	e8 7f f1 ff ff       	callq  4003a6 <parseCommand>
            //printf(" no of arguments are %d, env = %s \n",num_args, envp[0]);
            //#if 0
			switch (num_args) 
  401227:	83 f8 01             	cmp    $0x1,%eax
  40122a:	75 0e                	jne    40123a <main+0x9f>
			{
                case 1:
                    executeProcess(envp);
  40122c:	48 8b 3d b5 2a 20 00 	mov    0x202ab5(%rip),%rdi        # 603ce8 <digits.1233+0x201208>
  401233:	e8 4d f8 ff ff       	callq  400a85 <executeProcess>
                    break;
  401238:	eb c2                	jmp    4011fc <main+0x61>
                default:
					//printf("executeProcessPipe should be called \n");
                    executeProcessPipe(num_args,envp);
  40123a:	48 8b 35 a7 2a 20 00 	mov    0x202aa7(%rip),%rsi        # 603ce8 <digits.1233+0x201208>
  401241:	89 c7                	mov    %eax,%edi
  401243:	e8 9f fc ff ff       	callq  400ee7 <executeProcessPipe>
                    break;
  401248:	eb b2                	jmp    4011fc <main+0x61>
    if(argc==2){
        executeScript(argv[1],envp);
        script = 0;
    }
    if(script)
        welcome();
  40124a:	b8 00 00 00 00       	mov    $0x0,%eax
  40124f:	e8 fa fe ff ff       	callq  40114e <welcome>
  401254:	eb a3                	jmp    4011f9 <main+0x5e>
  401256:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  40125d:	00 00 00 

0000000000401260 <free>:
}

void free(void *ptr)
{
	//printf("freed \n");
	if(ptr == NULL)
  401260:	48 85 ff             	test   %rdi,%rdi
  401263:	74 07                	je     40126c <free+0xc>
		return;
	struct mem_block *block = (struct mem_block *)ptr -1 ;
	block->free = FREE;
  401265:	c7 47 f0 01 00 00 00 	movl   $0x1,-0x10(%rdi)
  40126c:	f3 c3                	repz retq 

000000000040126e <find_free_mem_block>:

//our code
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size)
{
	//printf("find_free_mem_block called %d \n \n\n\n ", size);
	struct mem_block *temp = head;
  40126e:	48 8d 05 cb 2e 20 00 	lea    0x202ecb(%rip),%rax        # 604140 <head>
  401275:	48 8b 00             	mov    (%rax),%rax
	while(temp && !(temp->free == FREE && temp->size >= size))
  401278:	48 85 c0             	test   %rax,%rax
  40127b:	75 0e                	jne    40128b <find_free_mem_block+0x1d>
  40127d:	f3 c3                	repz retq 
	{
		*last = temp;
  40127f:	48 89 07             	mov    %rax,(%rdi)
		temp = temp->next;	
  401282:	48 8b 40 10          	mov    0x10(%rax),%rax
//our code
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size)
{
	//printf("find_free_mem_block called %d \n \n\n\n ", size);
	struct mem_block *temp = head;
	while(temp && !(temp->free == FREE && temp->size >= size))
  401286:	48 85 c0             	test   %rax,%rax
  401289:	74 0b                	je     401296 <find_free_mem_block+0x28>
  40128b:	83 78 08 01          	cmpl   $0x1,0x8(%rax)
  40128f:	75 ee                	jne    40127f <find_free_mem_block+0x11>
  401291:	48 39 30             	cmp    %rsi,(%rax)
  401294:	72 e9                	jb     40127f <find_free_mem_block+0x11>
	{
		*last = temp;
		temp = temp->next;	
	}
	return temp;
}
  401296:	f3 c3                	repz retq 

0000000000401298 <allocateMemory>:

/* allocate memory of size  */
struct mem_block *allocateMemory(size_t size)
{
  401298:	55                   	push   %rbp
  401299:	53                   	push   %rbx
  40129a:	48 83 ec 08          	sub    $0x8,%rsp
  40129e:	48 89 fd             	mov    %rdi,%rbp
	struct mem_block *current;
	current = sbrk(0);
  4012a1:	bf 00 00 00 00       	mov    $0x0,%edi
  4012a6:	e8 89 0d 00 00       	callq  402034 <sbrk>
  4012ab:	48 89 c3             	mov    %rax,%rbx
	void *addr = sbrk(size + BLOCK_SIZE);
  4012ae:	48 8d 7d 18          	lea    0x18(%rbp),%rdi
  4012b2:	e8 7d 0d 00 00       	callq  402034 <sbrk>
	
	if (addr == (void*) -1) {
  4012b7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  4012bb:	74 17                	je     4012d4 <allocateMemory+0x3c>
		/* memory allocation failed */
		return NULL; 
  	}
	current->size = size;  //by removing memory block size
  4012bd:	48 89 2b             	mov    %rbp,(%rbx)
	current->next = NULL;
  4012c0:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  4012c7:	00 
	current->free = USED;
  4012c8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%rbx)
	return current;
  4012cf:	48 89 d8             	mov    %rbx,%rax
  4012d2:	eb 05                	jmp    4012d9 <allocateMemory+0x41>
	current = sbrk(0);
	void *addr = sbrk(size + BLOCK_SIZE);
	
	if (addr == (void*) -1) {
		/* memory allocation failed */
		return NULL; 
  4012d4:	b8 00 00 00 00       	mov    $0x0,%eax
  	}
	current->size = size;  //by removing memory block size
	current->next = NULL;
	current->free = USED;
	return current;
}
  4012d9:	48 83 c4 08          	add    $0x8,%rsp
  4012dd:	5b                   	pop    %rbx
  4012de:	5d                   	pop    %rbp
  4012df:	c3                   	retq   

00000000004012e0 <malloc>:
struct mem_block *allocateMemory(size_t size);
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size);
void *malloc(size_t size);

void *malloc(size_t size)
{
  4012e0:	53                   	push   %rbx
  4012e1:	48 83 ec 10          	sub    $0x10,%rsp
  4012e5:	48 89 fb             	mov    %rdi,%rbx
	//printf("malloc start \n");
	struct mem_block *block;
	if(size <= 0)
  4012e8:	48 85 ff             	test   %rdi,%rdi
  4012eb:	74 61                	je     40134e <malloc+0x6e>
		return NULL;
	
	if(head == NULL)
  4012ed:	48 8d 05 4c 2e 20 00 	lea    0x202e4c(%rip),%rax        # 604140 <head>
  4012f4:	48 8b 00             	mov    (%rax),%rax
  4012f7:	48 85 c0             	test   %rax,%rax
  4012fa:	75 16                	jne    401312 <malloc+0x32>
	{
		//printf("first time allocation %d \n",size);
		block = allocateMemory(size);
  4012fc:	e8 97 ff ff ff       	callq  401298 <allocateMemory>
		if(block == NULL)
  401301:	48 85 c0             	test   %rax,%rax
  401304:	74 4f                	je     401355 <malloc+0x75>
		{
			/*memory allocation failed */
			return NULL;	
		}
		head = block;
  401306:	48 8d 15 33 2e 20 00 	lea    0x202e33(%rip),%rdx        # 604140 <head>
  40130d:	48 89 02             	mov    %rax,(%rdx)
  401310:	eb 36                	jmp    401348 <malloc+0x68>
	}
	else
	{
		//search for free block
		struct mem_block *last = head;
  401312:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
		block = find_free_mem_block(&last, size);
  401317:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  40131c:	48 89 de             	mov    %rbx,%rsi
  40131f:	e8 4a ff ff ff       	callq  40126e <find_free_mem_block>
		//printf("found free memory block \n");
		if(block == NULL)
  401324:	48 85 c0             	test   %rax,%rax
  401327:	75 18                	jne    401341 <malloc+0x61>
		{
			//printf("added at the end %d \n", size);
			block = allocateMemory(size);
  401329:	48 89 df             	mov    %rbx,%rdi
  40132c:	e8 67 ff ff ff       	callq  401298 <allocateMemory>
			if(block == NULL)
  401331:	48 85 c0             	test   %rax,%rax
  401334:	74 24                	je     40135a <malloc+0x7a>
				return NULL;
			last->next = block;
  401336:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  40133b:	48 89 42 10          	mov    %rax,0x10(%rdx)
  40133f:	eb 07                	jmp    401348 <malloc+0x68>
		}
		else{
			//use free block found
			//printf("using free block \n");
			block->free = USED;
  401341:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
		}
	}
	//printf("malloc end \n");
 	return(block+1); 
  401348:	48 83 c0 18          	add    $0x18,%rax
  40134c:	eb 0c                	jmp    40135a <malloc+0x7a>
void *malloc(size_t size)
{
	//printf("malloc start \n");
	struct mem_block *block;
	if(size <= 0)
		return NULL;
  40134e:	b8 00 00 00 00       	mov    $0x0,%eax
  401353:	eb 05                	jmp    40135a <malloc+0x7a>
		//printf("first time allocation %d \n",size);
		block = allocateMemory(size);
		if(block == NULL)
		{
			/*memory allocation failed */
			return NULL;	
  401355:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	//printf("malloc end \n");
 	return(block+1); 
	//added 1 because block is a pointer of type struct and 
	//plus 1 increments the address by one sizeof(struct)
}
  40135a:	48 83 c4 10          	add    $0x10,%rsp
  40135e:	5b                   	pop    %rbx
  40135f:	c3                   	retq   

0000000000401360 <number>:
        return i;
}

static char *number(char *str, long num, int base, int size, int precision,
		    int type)
{
  401360:	41 57                	push   %r15
  401362:	41 56                	push   %r14
  401364:	41 55                	push   %r13
  401366:	41 54                	push   %r12
  401368:	55                   	push   %rbp
  401369:	53                   	push   %rbx
  40136a:	48 83 ec 55          	sub    $0x55,%rsp
  40136e:	41 89 d6             	mov    %edx,%r14d
	char c, sign, locase;
	int i;

	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
	 * produces same digits or (maybe lowercased) letters */
	locase = (type & SMALL);
  401371:	45 89 cd             	mov    %r9d,%r13d
  401374:	41 83 e5 20          	and    $0x20,%r13d
	if (type & LEFT)
  401378:	44 89 ca             	mov    %r9d,%edx
  40137b:	83 e2 10             	and    $0x10,%edx
		type &= ~ZEROPAD;
  40137e:	44 89 c8             	mov    %r9d,%eax
  401381:	83 e0 fe             	and    $0xfffffffe,%eax
  401384:	85 d2                	test   %edx,%edx
  401386:	44 0f 45 c8          	cmovne %eax,%r9d
	if (base < 2 || base > 16)
  40138a:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  40138e:	83 f8 0e             	cmp    $0xe,%eax
  401391:	0f 87 ee 01 00 00    	ja     401585 <number+0x225>
  401397:	45 89 f2             	mov    %r14d,%r10d
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
  40139a:	44 89 c8             	mov    %r9d,%eax
  40139d:	83 e0 01             	and    $0x1,%eax
  4013a0:	83 f8 01             	cmp    $0x1,%eax
  4013a3:	45 19 ff             	sbb    %r15d,%r15d
  4013a6:	41 83 e7 f0          	and    $0xfffffff0,%r15d
  4013aa:	41 83 c7 30          	add    $0x30,%r15d
	sign = 0;
  4013ae:	c6 04 24 00          	movb   $0x0,(%rsp)
	if (type & SIGN) {
  4013b2:	41 f6 c1 02          	test   $0x2,%r9b
  4013b6:	74 2e                	je     4013e6 <number+0x86>
		if (num < 0) {
  4013b8:	48 85 f6             	test   %rsi,%rsi
  4013bb:	79 0b                	jns    4013c8 <number+0x68>
			sign = '-';
			num = -num;
  4013bd:	48 f7 de             	neg    %rsi
			size--;
  4013c0:	ff c9                	dec    %ecx
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
	sign = 0;
	if (type & SIGN) {
		if (num < 0) {
			sign = '-';
  4013c2:	c6 04 24 2d          	movb   $0x2d,(%rsp)
  4013c6:	eb 1e                	jmp    4013e6 <number+0x86>
			num = -num;
			size--;
		} else if (type & PLUS) {
  4013c8:	41 f6 c1 04          	test   $0x4,%r9b
  4013cc:	74 08                	je     4013d6 <number+0x76>
			sign = '+';
			size--;
  4013ce:	ff c9                	dec    %ecx
		if (num < 0) {
			sign = '-';
			num = -num;
			size--;
		} else if (type & PLUS) {
			sign = '+';
  4013d0:	c6 04 24 2b          	movb   $0x2b,(%rsp)
  4013d4:	eb 10                	jmp    4013e6 <number+0x86>
	if (type & LEFT)
		type &= ~ZEROPAD;
	if (base < 2 || base > 16)
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
	sign = 0;
  4013d6:	c6 04 24 00          	movb   $0x0,(%rsp)
			num = -num;
			size--;
		} else if (type & PLUS) {
			sign = '+';
			size--;
		} else if (type & SPACE) {
  4013da:	41 f6 c1 08          	test   $0x8,%r9b
  4013de:	74 06                	je     4013e6 <number+0x86>
			sign = ' ';
			size--;
  4013e0:	ff c9                	dec    %ecx
			size--;
		} else if (type & PLUS) {
			sign = '+';
			size--;
		} else if (type & SPACE) {
			sign = ' ';
  4013e2:	c6 04 24 20          	movb   $0x20,(%rsp)
			size--;
		}
	}
	if (type & SPECIAL) {
  4013e6:	44 89 c8             	mov    %r9d,%eax
  4013e9:	83 e0 40             	and    $0x40,%eax
  4013ec:	89 44 24 01          	mov    %eax,0x1(%rsp)
  4013f0:	74 17                	je     401409 <number+0xa9>
		if (base == 16)
  4013f2:	41 83 fe 10          	cmp    $0x10,%r14d
  4013f6:	75 05                	jne    4013fd <number+0x9d>
			size -= 2;
  4013f8:	83 e9 02             	sub    $0x2,%ecx
  4013fb:	eb 0c                	jmp    401409 <number+0xa9>
		else if (base == 8)
			size--;
  4013fd:	41 83 fe 08          	cmp    $0x8,%r14d
  401401:	0f 94 c0             	sete   %al
  401404:	0f b6 c0             	movzbl %al,%eax
  401407:	29 c1                	sub    %eax,%ecx
	}
	i = 0;
	if (num == 0)
  401409:	48 85 f6             	test   %rsi,%rsi
  40140c:	75 0d                	jne    40141b <number+0xbb>
		tmp[i++] = '0';
  40140e:	c6 44 24 13 30       	movb   $0x30,0x13(%rsp)
  401413:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  401419:	eb 4c                	jmp    401467 <number+0x107>
  40141b:	4c 8d 5c 24 13       	lea    0x13(%rsp),%r11
			size -= 2;
		else if (base == 8)
			size--;
	}
	i = 0;
	if (num == 0)
  401420:	41 bc 00 00 00 00    	mov    $0x0,%r12d
		tmp[i++] = '0';
	else
		while (num != 0)
			tmp[i++] = (digits[__do_div(num, base)] | locase);
  401426:	45 89 d2             	mov    %r10d,%r10d
  401429:	41 ff c4             	inc    %r12d
  40142c:	48 89 f5             	mov    %rsi,%rbp
  40142f:	48 89 f0             	mov    %rsi,%rax
  401432:	ba 00 00 00 00       	mov    $0x0,%edx
  401437:	49 f7 f2             	div    %r10
  40143a:	48 89 c3             	mov    %rax,%rbx
  40143d:	48 89 c6             	mov    %rax,%rsi
  401440:	48 89 e8             	mov    %rbp,%rax
  401443:	ba 00 00 00 00       	mov    $0x0,%edx
  401448:	49 f7 f2             	div    %r10
  40144b:	48 63 d2             	movslq %edx,%rdx
  40144e:	48 8d 05 8b 16 00 00 	lea    0x168b(%rip),%rax        # 402ae0 <digits.1233>
  401455:	44 89 ed             	mov    %r13d,%ebp
  401458:	40 0a 2c 10          	or     (%rax,%rdx,1),%bpl
  40145c:	41 88 2b             	mov    %bpl,(%r11)
  40145f:	49 ff c3             	inc    %r11
	}
	i = 0;
	if (num == 0)
		tmp[i++] = '0';
	else
		while (num != 0)
  401462:	48 85 db             	test   %rbx,%rbx
  401465:	75 c2                	jne    401429 <number+0xc9>
  401467:	45 39 c4             	cmp    %r8d,%r12d
  40146a:	45 0f 4d c4          	cmovge %r12d,%r8d
			tmp[i++] = (digits[__do_div(num, base)] | locase);
	if (i > precision)
		precision = i;
	size -= precision;
  40146e:	44 29 c1             	sub    %r8d,%ecx
	if (!(type & (ZEROPAD + LEFT)))
  401471:	41 f6 c1 11          	test   $0x11,%r9b
  401475:	75 2d                	jne    4014a4 <number+0x144>
		while (size-- > 0)
  401477:	8d 71 ff             	lea    -0x1(%rcx),%esi
  40147a:	85 c9                	test   %ecx,%ecx
  40147c:	7e 24                	jle    4014a2 <number+0x142>
  40147e:	ff c9                	dec    %ecx
  401480:	48 8d 54 0f 01       	lea    0x1(%rdi,%rcx,1),%rdx
  401485:	48 89 f8             	mov    %rdi,%rax
			*str++ = ' ';
  401488:	48 ff c0             	inc    %rax
  40148b:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
			tmp[i++] = (digits[__do_div(num, base)] | locase);
	if (i > precision)
		precision = i;
	size -= precision;
	if (!(type & (ZEROPAD + LEFT)))
		while (size-- > 0)
  40148f:	48 39 d0             	cmp    %rdx,%rax
  401492:	75 f4                	jne    401488 <number+0x128>
  401494:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  401499:	89 f6                	mov    %esi,%esi
  40149b:	48 8d 7c 37 01       	lea    0x1(%rdi,%rsi,1),%rdi
  4014a0:	eb 02                	jmp    4014a4 <number+0x144>
  4014a2:	89 f1                	mov    %esi,%ecx
			*str++ = ' ';
	if (sign)
  4014a4:	80 3c 24 00          	cmpb   $0x0,(%rsp)
  4014a8:	74 0a                	je     4014b4 <number+0x154>
		*str++ = sign;
  4014aa:	0f b6 04 24          	movzbl (%rsp),%eax
  4014ae:	88 07                	mov    %al,(%rdi)
  4014b0:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
	if (type & SPECIAL) {
  4014b4:	83 7c 24 01 00       	cmpl   $0x0,0x1(%rsp)
  4014b9:	74 24                	je     4014df <number+0x17f>
		if (base == 8)
  4014bb:	41 83 fe 08          	cmp    $0x8,%r14d
  4014bf:	75 09                	jne    4014ca <number+0x16a>
			*str++ = '0';
  4014c1:	c6 07 30             	movb   $0x30,(%rdi)
  4014c4:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
  4014c8:	eb 15                	jmp    4014df <number+0x17f>
		else if (base == 16) {
  4014ca:	41 83 fe 10          	cmp    $0x10,%r14d
  4014ce:	75 0f                	jne    4014df <number+0x17f>
			*str++ = '0';
  4014d0:	c6 07 30             	movb   $0x30,(%rdi)
			*str++ = ('X' | locase);
  4014d3:	41 83 cd 58          	or     $0x58,%r13d
  4014d7:	44 88 6f 01          	mov    %r13b,0x1(%rdi)
  4014db:	48 8d 7f 02          	lea    0x2(%rdi),%rdi
		}
	}
	if (!(type & LEFT))
  4014df:	41 f6 c1 10          	test   $0x10,%r9b
  4014e3:	75 2d                	jne    401512 <number+0x1b2>
		while (size-- > 0)
  4014e5:	8d 71 ff             	lea    -0x1(%rcx),%esi
  4014e8:	85 c9                	test   %ecx,%ecx
  4014ea:	7e 24                	jle    401510 <number+0x1b0>
  4014ec:	ff c9                	dec    %ecx
  4014ee:	48 8d 54 0f 01       	lea    0x1(%rdi,%rcx,1),%rdx
  4014f3:	48 89 f8             	mov    %rdi,%rax
			*str++ = c;
  4014f6:	48 ff c0             	inc    %rax
  4014f9:	44 88 78 ff          	mov    %r15b,-0x1(%rax)
			*str++ = '0';
			*str++ = ('X' | locase);
		}
	}
	if (!(type & LEFT))
		while (size-- > 0)
  4014fd:	48 39 d0             	cmp    %rdx,%rax
  401500:	75 f4                	jne    4014f6 <number+0x196>
  401502:	89 f6                	mov    %esi,%esi
  401504:	48 8d 7c 37 01       	lea    0x1(%rdi,%rsi,1),%rdi
  401509:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  40150e:	eb 02                	jmp    401512 <number+0x1b2>
  401510:	89 f1                	mov    %esi,%ecx
			*str++ = c;
	while (i < precision--)
  401512:	45 39 c4             	cmp    %r8d,%r12d
  401515:	7d 1a                	jge    401531 <number+0x1d1>
  401517:	45 29 e0             	sub    %r12d,%r8d
  40151a:	41 8d 40 ff          	lea    -0x1(%r8),%eax
  40151e:	4c 8d 44 07 01       	lea    0x1(%rdi,%rax,1),%r8
		*str++ = '0';
  401523:	48 ff c7             	inc    %rdi
  401526:	c6 47 ff 30          	movb   $0x30,-0x1(%rdi)
		}
	}
	if (!(type & LEFT))
		while (size-- > 0)
			*str++ = c;
	while (i < precision--)
  40152a:	4c 39 c7             	cmp    %r8,%rdi
  40152d:	75 f4                	jne    401523 <number+0x1c3>
  40152f:	eb 03                	jmp    401534 <number+0x1d4>
  401531:	49 89 f8             	mov    %rdi,%r8
		*str++ = '0';
	while (i-- > 0)
  401534:	41 8d 7c 24 ff       	lea    -0x1(%r12),%edi
  401539:	45 85 e4             	test   %r12d,%r12d
  40153c:	7e 21                	jle    40155f <number+0x1ff>
  40153e:	4c 89 c2             	mov    %r8,%rdx
  401541:	89 f8                	mov    %edi,%eax
		*str++ = tmp[i];
  401543:	48 63 f0             	movslq %eax,%rsi
  401546:	0f b6 74 34 13       	movzbl 0x13(%rsp,%rsi,1),%esi
  40154b:	40 88 32             	mov    %sil,(%rdx)
	if (!(type & LEFT))
		while (size-- > 0)
			*str++ = c;
	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
  40154e:	ff c8                	dec    %eax
  401550:	48 ff c2             	inc    %rdx
  401553:	83 f8 ff             	cmp    $0xffffffff,%eax
  401556:	75 eb                	jne    401543 <number+0x1e3>
  401558:	89 ff                	mov    %edi,%edi
  40155a:	4d 8d 44 38 01       	lea    0x1(%r8,%rdi,1),%r8
		*str++ = tmp[i];
	while (size-- > 0)
  40155f:	8d 71 ff             	lea    -0x1(%rcx),%esi
  401562:	85 c9                	test   %ecx,%ecx
  401564:	7e 26                	jle    40158c <number+0x22c>
  401566:	ff c9                	dec    %ecx
  401568:	49 8d 54 08 01       	lea    0x1(%r8,%rcx,1),%rdx
  40156d:	4c 89 c0             	mov    %r8,%rax
		*str++ = ' ';
  401570:	48 ff c0             	inc    %rax
  401573:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
			*str++ = c;
	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
		*str++ = tmp[i];
	while (size-- > 0)
  401577:	48 39 d0             	cmp    %rdx,%rax
  40157a:	75 f4                	jne    401570 <number+0x210>
  40157c:	89 f6                	mov    %esi,%esi
		*str++ = ' ';
  40157e:	49 8d 44 30 01       	lea    0x1(%r8,%rsi,1),%rax
  401583:	eb 0a                	jmp    40158f <number+0x22f>
	 * produces same digits or (maybe lowercased) letters */
	locase = (type & SMALL);
	if (type & LEFT)
		type &= ~ZEROPAD;
	if (base < 2 || base > 16)
		return NULL;
  401585:	b8 00 00 00 00       	mov    $0x0,%eax
  40158a:	eb 03                	jmp    40158f <number+0x22f>
			*str++ = c;
	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
		*str++ = tmp[i];
	while (size-- > 0)
  40158c:	4c 89 c0             	mov    %r8,%rax
		*str++ = ' ';
	return str;
}
  40158f:	48 83 c4 55          	add    $0x55,%rsp
  401593:	5b                   	pop    %rbx
  401594:	5d                   	pop    %rbp
  401595:	41 5c                	pop    %r12
  401597:	41 5d                	pop    %r13
  401599:	41 5e                	pop    %r14
  40159b:	41 5f                	pop    %r15
  40159d:	c3                   	retq   

000000000040159e <skip_atoi>:
n = ((unsigned long) n) / (unsigned) base; \
__res; })


static int skip_atoi(const char **s)
{
  40159e:	55                   	push   %rbp
  40159f:	53                   	push   %rbx
  4015a0:	48 83 ec 08          	sub    $0x8,%rsp
  4015a4:	48 89 fd             	mov    %rdi,%rbp
        int i = 0;
  4015a7:	bb 00 00 00 00       	mov    $0x0,%ebx

        while (isdigit(**s))
  4015ac:	eb 1d                	jmp    4015cb <skip_atoi+0x2d>
                i = i * 10 + *((*s)++) - '0';
  4015ae:	48 8b 45 00          	mov    0x0(%rbp),%rax
  4015b2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  4015b6:	48 89 55 00          	mov    %rdx,0x0(%rbp)
  4015ba:	8d 14 dd 00 00 00 00 	lea    0x0(,%rbx,8),%edx
  4015c1:	8d 14 5a             	lea    (%rdx,%rbx,2),%edx
  4015c4:	0f be 00             	movsbl (%rax),%eax
  4015c7:	8d 5c 02 d0          	lea    -0x30(%rdx,%rax,1),%ebx

static int skip_atoi(const char **s)
{
        int i = 0;

        while (isdigit(**s))
  4015cb:	48 8b 45 00          	mov    0x0(%rbp),%rax
  4015cf:	0f be 38             	movsbl (%rax),%edi
  4015d2:	e8 62 10 00 00       	callq  402639 <isdigit>
  4015d7:	85 c0                	test   %eax,%eax
  4015d9:	75 d3                	jne    4015ae <skip_atoi+0x10>
                i = i * 10 + *((*s)++) - '0';
        return i;
}
  4015db:	89 d8                	mov    %ebx,%eax
  4015dd:	48 83 c4 08          	add    $0x8,%rsp
  4015e1:	5b                   	pop    %rbx
  4015e2:	5d                   	pop    %rbp
  4015e3:	c3                   	retq   

00000000004015e4 <vsprintf>:
	va_end(val);
	return printed;
}

int vsprintf(char *buf, const char *fmt, va_list args)
{
  4015e4:	41 57                	push   %r15
  4015e6:	41 56                	push   %r14
  4015e8:	41 55                	push   %r13
  4015ea:	41 54                	push   %r12
  4015ec:	55                   	push   %rbp
  4015ed:	53                   	push   %rbx
  4015ee:	48 83 ec 28          	sub    $0x28,%rsp
  4015f2:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  4015f7:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
	int field_width;	/* width of output field */
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L:' for integer fields */

	for (str = buf; *fmt; ++fmt) {
  4015fc:	0f b6 06             	movzbl (%rsi),%eax
  4015ff:	84 c0                	test   %al,%al
  401601:	0f 84 0d 05 00 00    	je     401b14 <vsprintf+0x530>
  401607:	49 89 d5             	mov    %rdx,%r13
  40160a:	48 89 fb             	mov    %rdi,%rbx

		/* process flags */
		flags = 0;
	      repeat:
		++fmt;		/* this also skips first '%' */
		switch (*fmt) {
  40160d:	4c 8d 25 8c 12 00 00 	lea    0x128c(%rip),%r12        # 4028a0 <atoi+0x203>
		/* get the precision */
		precision = -1;
		if (*fmt == '.') {
			++fmt;
			if (isdigit(*fmt))
				precision = skip_atoi(&fmt);
  401614:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
  401619:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L:' for integer fields */

	for (str = buf; *fmt; ++fmt) {
		if (*fmt != '%') {
  40161e:	bd 00 00 00 00       	mov    $0x0,%ebp
  401623:	3c 25                	cmp    $0x25,%al
  401625:	74 0b                	je     401632 <vsprintf+0x4e>
			*str++ = *fmt;
  401627:	88 03                	mov    %al,(%rbx)
  401629:	48 8d 5b 01          	lea    0x1(%rbx),%rbx
			continue;
  40162d:	e9 c6 04 00 00       	jmpq   401af8 <vsprintf+0x514>
		}

		/* process flags */
		flags = 0;
	      repeat:
		++fmt;		/* this also skips first '%' */
  401632:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  401637:	48 8d 50 01          	lea    0x1(%rax),%rdx
  40163b:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
		switch (*fmt) {
  401640:	0f b6 78 01          	movzbl 0x1(%rax),%edi
  401644:	8d 47 e0             	lea    -0x20(%rdi),%eax
  401647:	3c 10                	cmp    $0x10,%al
  401649:	77 27                	ja     401672 <vsprintf+0x8e>
  40164b:	0f b6 c0             	movzbl %al,%eax
  40164e:	49 63 04 84          	movslq (%r12,%rax,4),%rax
  401652:	4c 01 e0             	add    %r12,%rax
  401655:	ff e0                	jmpq   *%rax
		case '-':
			flags |= LEFT;
  401657:	83 cd 10             	or     $0x10,%ebp
			goto repeat;
  40165a:	eb d6                	jmp    401632 <vsprintf+0x4e>
		case '+':
			flags |= PLUS;
  40165c:	83 cd 04             	or     $0x4,%ebp
			goto repeat;
  40165f:	eb d1                	jmp    401632 <vsprintf+0x4e>
		case ' ':
			flags |= SPACE;
  401661:	83 cd 08             	or     $0x8,%ebp
			goto repeat;
  401664:	eb cc                	jmp    401632 <vsprintf+0x4e>
		case '#':
			flags |= SPECIAL;
  401666:	83 cd 40             	or     $0x40,%ebp
			goto repeat;
  401669:	eb c7                	jmp    401632 <vsprintf+0x4e>
		case '0':
			flags |= ZEROPAD;
  40166b:	83 cd 01             	or     $0x1,%ebp
  40166e:	66 90                	xchg   %ax,%ax
			goto repeat;
  401670:	eb c0                	jmp    401632 <vsprintf+0x4e>

		/* process flags */
		flags = 0;
	      repeat:
		++fmt;		/* this also skips first '%' */
		switch (*fmt) {
  401672:	41 89 ef             	mov    %ebp,%r15d
			goto repeat;
		}
	
		/* get field width */
		field_width = -1;
		if (isdigit(*fmt))
  401675:	40 0f be ff          	movsbl %dil,%edi
  401679:	e8 bb 0f 00 00       	callq  402639 <isdigit>
  40167e:	85 c0                	test   %eax,%eax
  401680:	74 0f                	je     401691 <vsprintf+0xad>
			field_width = skip_atoi(&fmt);
  401682:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  401687:	e8 12 ff ff ff       	callq  40159e <skip_atoi>
  40168c:	41 89 c6             	mov    %eax,%r14d
  40168f:	eb 4e                	jmp    4016df <vsprintf+0xfb>
		else if (*fmt == '*') {
  401691:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
			flags |= ZEROPAD;
			goto repeat;
		}
	
		/* get field width */
		field_width = -1;
  401696:	41 be ff ff ff ff    	mov    $0xffffffff,%r14d
		if (isdigit(*fmt))
			field_width = skip_atoi(&fmt);
		else if (*fmt == '*') {
  40169c:	80 38 2a             	cmpb   $0x2a,(%rax)
  40169f:	75 3e                	jne    4016df <vsprintf+0xfb>
			++fmt;
  4016a1:	48 ff c0             	inc    %rax
  4016a4:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
			/* it's the next argument */
			field_width = va_arg(args, int);
  4016a9:	41 8b 45 00          	mov    0x0(%r13),%eax
  4016ad:	83 f8 30             	cmp    $0x30,%eax
  4016b0:	73 0f                	jae    4016c1 <vsprintf+0xdd>
  4016b2:	89 c2                	mov    %eax,%edx
  4016b4:	49 03 55 10          	add    0x10(%r13),%rdx
  4016b8:	83 c0 08             	add    $0x8,%eax
  4016bb:	41 89 45 00          	mov    %eax,0x0(%r13)
  4016bf:	eb 0c                	jmp    4016cd <vsprintf+0xe9>
  4016c1:	49 8b 55 08          	mov    0x8(%r13),%rdx
  4016c5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  4016c9:	49 89 45 08          	mov    %rax,0x8(%r13)
  4016cd:	44 8b 32             	mov    (%rdx),%r14d
			if (field_width < 0) {
  4016d0:	45 85 f6             	test   %r14d,%r14d
  4016d3:	79 0a                	jns    4016df <vsprintf+0xfb>
				field_width = -field_width;
  4016d5:	41 f7 de             	neg    %r14d
				flags |= LEFT;
  4016d8:	41 83 cf 10          	or     $0x10,%r15d
  4016dc:	44 89 fd             	mov    %r15d,%ebp
			}
		}

		/* get the precision */
		precision = -1;
		if (*fmt == '.') {
  4016df:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
				flags |= LEFT;
			}
		}

		/* get the precision */
		precision = -1;
  4016e4:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
		if (*fmt == '.') {
  4016ea:	80 38 2e             	cmpb   $0x2e,(%rax)
  4016ed:	75 6b                	jne    40175a <vsprintf+0x176>
			++fmt;
  4016ef:	48 8d 50 01          	lea    0x1(%rax),%rdx
  4016f3:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
			if (isdigit(*fmt))
  4016f8:	0f be 78 01          	movsbl 0x1(%rax),%edi
  4016fc:	e8 38 0f 00 00       	callq  402639 <isdigit>
  401701:	85 c0                	test   %eax,%eax
  401703:	74 0c                	je     401711 <vsprintf+0x12d>
				precision = skip_atoi(&fmt);
  401705:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  40170a:	e8 8f fe ff ff       	callq  40159e <skip_atoi>
  40170f:	eb 3d                	jmp    40174e <vsprintf+0x16a>
			else if (*fmt == '*') {
  401711:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
				flags |= LEFT;
			}
		}

		/* get the precision */
		precision = -1;
  401716:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		if (*fmt == '.') {
			++fmt;
			if (isdigit(*fmt))
				precision = skip_atoi(&fmt);
			else if (*fmt == '*') {
  40171b:	80 3a 2a             	cmpb   $0x2a,(%rdx)
  40171e:	75 2e                	jne    40174e <vsprintf+0x16a>
				++fmt;
  401720:	48 ff c2             	inc    %rdx
  401723:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
				/* it's the next argument */
				precision = va_arg(args, int);
  401728:	41 8b 45 00          	mov    0x0(%r13),%eax
  40172c:	83 f8 30             	cmp    $0x30,%eax
  40172f:	73 0f                	jae    401740 <vsprintf+0x15c>
  401731:	89 c2                	mov    %eax,%edx
  401733:	49 03 55 10          	add    0x10(%r13),%rdx
  401737:	83 c0 08             	add    $0x8,%eax
  40173a:	41 89 45 00          	mov    %eax,0x0(%r13)
  40173e:	eb 0c                	jmp    40174c <vsprintf+0x168>
  401740:	49 8b 55 08          	mov    0x8(%r13),%rdx
  401744:	48 8d 42 08          	lea    0x8(%rdx),%rax
  401748:	49 89 45 08          	mov    %rax,0x8(%r13)
  40174c:	8b 02                	mov    (%rdx),%eax
  40174e:	85 c0                	test   %eax,%eax
  401750:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  401756:	44 0f 49 c0          	cmovns %eax,%r8d
				precision = 0;
		}

		/* get the conversion qualifier */
		qualifier = -1;
		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
  40175a:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  40175f:	0f b6 02             	movzbl (%rdx),%eax
  401762:	3c 68                	cmp    $0x68,%al
  401764:	74 10                	je     401776 <vsprintf+0x192>
  401766:	89 c6                	mov    %eax,%esi
  401768:	83 e6 df             	and    $0xffffffdf,%esi
			if (precision < 0)
				precision = 0;
		}

		/* get the conversion qualifier */
		qualifier = -1;
  40176b:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
  401770:	40 80 fe 4c          	cmp    $0x4c,%sil
  401774:	75 0b                	jne    401781 <vsprintf+0x19d>
			qualifier = *fmt;
  401776:	0f be c8             	movsbl %al,%ecx
			++fmt;
  401779:	48 ff c2             	inc    %rdx
  40177c:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
		}

		/* default base */
		base = 10;

		switch (*fmt) {
  401781:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  401786:	0f b6 00             	movzbl (%rax),%eax
  401789:	83 e8 25             	sub    $0x25,%eax
  40178c:	3c 53                	cmp    $0x53,%al
  40178e:	0f 87 52 02 00 00    	ja     4019e6 <vsprintf+0x402>
  401794:	0f b6 c0             	movzbl %al,%eax
  401797:	48 8d 35 46 11 00 00 	lea    0x1146(%rip),%rsi        # 4028e4 <atoi+0x247>
  40179e:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
  4017a2:	48 01 f0             	add    %rsi,%rax
  4017a5:	ff e0                	jmpq   *%rax
		case 'c':
			if (!(flags & LEFT))
  4017a7:	40 f6 c5 10          	test   $0x10,%bpl
  4017ab:	75 34                	jne    4017e1 <vsprintf+0x1fd>
				while (--field_width > 0)
  4017ad:	41 8d 46 ff          	lea    -0x1(%r14),%eax
  4017b1:	85 c0                	test   %eax,%eax
  4017b3:	7e 29                	jle    4017de <vsprintf+0x1fa>
  4017b5:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  4017b9:	48 8d 54 03 01       	lea    0x1(%rbx,%rax,1),%rdx
  4017be:	48 89 d8             	mov    %rbx,%rax
					*str++ = ' ';
  4017c1:	48 ff c0             	inc    %rax
  4017c4:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
		base = 10;

		switch (*fmt) {
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
  4017c8:	48 39 d0             	cmp    %rdx,%rax
  4017cb:	75 f4                	jne    4017c1 <vsprintf+0x1dd>
  4017cd:	41 83 ee 02          	sub    $0x2,%r14d
  4017d1:	4a 8d 5c 33 01       	lea    0x1(%rbx,%r14,1),%rbx
  4017d6:	41 be 00 00 00 00    	mov    $0x0,%r14d
  4017dc:	eb 03                	jmp    4017e1 <vsprintf+0x1fd>
  4017de:	41 89 c6             	mov    %eax,%r14d
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
  4017e1:	48 8d 4b 01          	lea    0x1(%rbx),%rcx
  4017e5:	41 8b 45 00          	mov    0x0(%r13),%eax
  4017e9:	83 f8 30             	cmp    $0x30,%eax
  4017ec:	73 0f                	jae    4017fd <vsprintf+0x219>
  4017ee:	89 c2                	mov    %eax,%edx
  4017f0:	49 03 55 10          	add    0x10(%r13),%rdx
  4017f4:	83 c0 08             	add    $0x8,%eax
  4017f7:	41 89 45 00          	mov    %eax,0x0(%r13)
  4017fb:	eb 0c                	jmp    401809 <vsprintf+0x225>
  4017fd:	49 8b 55 08          	mov    0x8(%r13),%rdx
  401801:	48 8d 42 08          	lea    0x8(%rdx),%rax
  401805:	49 89 45 08          	mov    %rax,0x8(%r13)
  401809:	8b 02                	mov    (%rdx),%eax
  40180b:	88 03                	mov    %al,(%rbx)
			while (--field_width > 0)
  40180d:	41 8d 46 ff          	lea    -0x1(%r14),%eax
  401811:	85 c0                	test   %eax,%eax
  401813:	0f 8e dc 02 00 00    	jle    401af5 <vsprintf+0x511>
  401819:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  40181d:	48 8d 54 03 02       	lea    0x2(%rbx,%rax,1),%rdx
		switch (*fmt) {
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
  401822:	48 89 c8             	mov    %rcx,%rax
			while (--field_width > 0)
				*str++ = ' ';
  401825:	48 ff c0             	inc    %rax
  401828:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
			while (--field_width > 0)
  40182c:	48 39 d0             	cmp    %rdx,%rax
  40182f:	75 f4                	jne    401825 <vsprintf+0x241>
  401831:	41 83 ee 02          	sub    $0x2,%r14d
  401835:	4a 8d 5c 31 01       	lea    0x1(%rcx,%r14,1),%rbx
  40183a:	e9 b9 02 00 00       	jmpq   401af8 <vsprintf+0x514>
				*str++ = ' ';
			continue;

		case 's':
			s = va_arg(args, char *);
  40183f:	41 8b 45 00          	mov    0x0(%r13),%eax
  401843:	83 f8 30             	cmp    $0x30,%eax
  401846:	73 0f                	jae    401857 <vsprintf+0x273>
  401848:	89 c2                	mov    %eax,%edx
  40184a:	49 03 55 10          	add    0x10(%r13),%rdx
  40184e:	83 c0 08             	add    $0x8,%eax
  401851:	41 89 45 00          	mov    %eax,0x0(%r13)
  401855:	eb 0c                	jmp    401863 <vsprintf+0x27f>
  401857:	49 8b 55 08          	mov    0x8(%r13),%rdx
  40185b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  40185f:	49 89 45 08          	mov    %rax,0x8(%r13)
  401863:	4c 8b 3a             	mov    (%rdx),%r15
			//len = strnlen(s, precision);
			len = strlen(s);
  401866:	4c 89 ff             	mov    %r15,%rdi
  401869:	e8 c2 0c 00 00       	callq  402530 <strlen>
  40186e:	89 c6                	mov    %eax,%esi
			if (!(flags & LEFT))
  401870:	40 f6 c5 10          	test   $0x10,%bpl
  401874:	75 31                	jne    4018a7 <vsprintf+0x2c3>
				while (len < field_width--)
  401876:	41 8d 4e ff          	lea    -0x1(%r14),%ecx
  40187a:	41 39 c6             	cmp    %eax,%r14d
  40187d:	7e 25                	jle    4018a4 <vsprintf+0x2c0>
  40187f:	44 89 f7             	mov    %r14d,%edi
  401882:	41 89 ce             	mov    %ecx,%r14d
  401885:	41 29 c6             	sub    %eax,%r14d
  401888:	4a 8d 54 33 01       	lea    0x1(%rbx,%r14,1),%rdx
					*str++ = ' ';
  40188d:	48 ff c3             	inc    %rbx
  401890:	c6 43 ff 20          	movb   $0x20,-0x1(%rbx)
		case 's':
			s = va_arg(args, char *);
			//len = strnlen(s, precision);
			len = strlen(s);
			if (!(flags & LEFT))
				while (len < field_width--)
  401894:	48 39 d3             	cmp    %rdx,%rbx
  401897:	75 f4                	jne    40188d <vsprintf+0x2a9>
  401899:	29 f9                	sub    %edi,%ecx
  40189b:	44 8d 34 01          	lea    (%rcx,%rax,1),%r14d
					*str++ = ' ';
  40189f:	48 89 d3             	mov    %rdx,%rbx
  4018a2:	eb 03                	jmp    4018a7 <vsprintf+0x2c3>
		case 's':
			s = va_arg(args, char *);
			//len = strnlen(s, precision);
			len = strlen(s);
			if (!(flags & LEFT))
				while (len < field_width--)
  4018a4:	41 89 ce             	mov    %ecx,%r14d
					*str++ = ' ';
			for (i = 0; i < len; ++i)
  4018a7:	85 c0                	test   %eax,%eax
  4018a9:	7e 1c                	jle    4018c7 <vsprintf+0x2e3>
  4018ab:	ba 00 00 00 00       	mov    $0x0,%edx
				*str++ = *s++;
  4018b0:	41 0f b6 0c 17       	movzbl (%r15,%rdx,1),%ecx
  4018b5:	88 0c 13             	mov    %cl,(%rbx,%rdx,1)
  4018b8:	48 ff c2             	inc    %rdx
			//len = strnlen(s, precision);
			len = strlen(s);
			if (!(flags & LEFT))
				while (len < field_width--)
					*str++ = ' ';
			for (i = 0; i < len; ++i)
  4018bb:	39 d6                	cmp    %edx,%esi
  4018bd:	7f f1                	jg     4018b0 <vsprintf+0x2cc>
  4018bf:	8d 50 ff             	lea    -0x1(%rax),%edx
  4018c2:	48 8d 5c 13 01       	lea    0x1(%rbx,%rdx,1),%rbx
				*str++ = *s++;
			while (len < field_width--)
  4018c7:	41 39 c6             	cmp    %eax,%r14d
  4018ca:	0f 8e 28 02 00 00    	jle    401af8 <vsprintf+0x514>
  4018d0:	44 89 f6             	mov    %r14d,%esi
  4018d3:	89 c2                	mov    %eax,%edx
  4018d5:	f7 d2                	not    %edx
  4018d7:	41 01 d6             	add    %edx,%r14d
  4018da:	4a 8d 4c 33 01       	lea    0x1(%rbx,%r14,1),%rcx
  4018df:	48 89 da             	mov    %rbx,%rdx
				*str++ = ' ';
  4018e2:	48 ff c2             	inc    %rdx
  4018e5:	c6 42 ff 20          	movb   $0x20,-0x1(%rdx)
			if (!(flags & LEFT))
				while (len < field_width--)
					*str++ = ' ';
			for (i = 0; i < len; ++i)
				*str++ = *s++;
			while (len < field_width--)
  4018e9:	48 39 ca             	cmp    %rcx,%rdx
  4018ec:	75 f4                	jne    4018e2 <vsprintf+0x2fe>
  4018ee:	f7 d0                	not    %eax
  4018f0:	01 f0                	add    %esi,%eax
  4018f2:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
  4018f7:	e9 fc 01 00 00       	jmpq   401af8 <vsprintf+0x514>
				*str++ = ' ';
			continue;

		case 'p':
			if (field_width == -1) {
  4018fc:	41 83 fe ff          	cmp    $0xffffffff,%r14d
  401900:	75 09                	jne    40190b <vsprintf+0x327>
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
  401902:	83 cd 01             	or     $0x1,%ebp
				*str++ = ' ';
			continue;

		case 'p':
			if (field_width == -1) {
				field_width = 2 * sizeof(void *);
  401905:	41 be 10 00 00 00    	mov    $0x10,%r14d
				flags |= ZEROPAD;
			}
			str = number(str,
				     (unsigned long)va_arg(args, void *), 16,
  40190b:	41 8b 45 00          	mov    0x0(%r13),%eax
  40190f:	83 f8 30             	cmp    $0x30,%eax
  401912:	73 0f                	jae    401923 <vsprintf+0x33f>
  401914:	89 c6                	mov    %eax,%esi
  401916:	49 03 75 10          	add    0x10(%r13),%rsi
  40191a:	83 c0 08             	add    $0x8,%eax
  40191d:	41 89 45 00          	mov    %eax,0x0(%r13)
		case 'p':
			if (field_width == -1) {
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
			}
			str = number(str,
  401921:	eb 0c                	jmp    40192f <vsprintf+0x34b>
				     (unsigned long)va_arg(args, void *), 16,
  401923:	49 8b 75 08          	mov    0x8(%r13),%rsi
  401927:	48 8d 46 08          	lea    0x8(%rsi),%rax
  40192b:	49 89 45 08          	mov    %rax,0x8(%r13)
		case 'p':
			if (field_width == -1) {
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
			}
			str = number(str,
  40192f:	41 89 e9             	mov    %ebp,%r9d
  401932:	44 89 f1             	mov    %r14d,%ecx
  401935:	ba 10 00 00 00       	mov    $0x10,%edx
  40193a:	48 8b 36             	mov    (%rsi),%rsi
  40193d:	48 89 df             	mov    %rbx,%rdi
  401940:	e8 1b fa ff ff       	callq  401360 <number>
  401945:	48 89 c3             	mov    %rax,%rbx
				     (unsigned long)va_arg(args, void *), 16,
				     field_width, precision, flags);
			continue;
  401948:	e9 ab 01 00 00       	jmpq   401af8 <vsprintf+0x514>

		case 'n':
			if (qualifier == 'l') {
  40194d:	83 f9 6c             	cmp    $0x6c,%ecx
  401950:	75 37                	jne    401989 <vsprintf+0x3a5>
				long *ip = va_arg(args, long *);
  401952:	41 8b 45 00          	mov    0x0(%r13),%eax
  401956:	83 f8 30             	cmp    $0x30,%eax
  401959:	73 0f                	jae    40196a <vsprintf+0x386>
  40195b:	89 c2                	mov    %eax,%edx
  40195d:	49 03 55 10          	add    0x10(%r13),%rdx
  401961:	83 c0 08             	add    $0x8,%eax
  401964:	41 89 45 00          	mov    %eax,0x0(%r13)
  401968:	eb 0c                	jmp    401976 <vsprintf+0x392>
  40196a:	49 8b 55 08          	mov    0x8(%r13),%rdx
  40196e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  401972:	49 89 45 08          	mov    %rax,0x8(%r13)
  401976:	48 8b 02             	mov    (%rdx),%rax
				*ip = (str - buf);
  401979:	48 89 da             	mov    %rbx,%rdx
  40197c:	48 2b 54 24 08       	sub    0x8(%rsp),%rdx
  401981:	48 89 10             	mov    %rdx,(%rax)
  401984:	e9 6f 01 00 00       	jmpq   401af8 <vsprintf+0x514>
			} else {
				int *ip = va_arg(args, int *);
  401989:	41 8b 45 00          	mov    0x0(%r13),%eax
  40198d:	83 f8 30             	cmp    $0x30,%eax
  401990:	73 0f                	jae    4019a1 <vsprintf+0x3bd>
  401992:	89 c2                	mov    %eax,%edx
  401994:	49 03 55 10          	add    0x10(%r13),%rdx
  401998:	83 c0 08             	add    $0x8,%eax
  40199b:	41 89 45 00          	mov    %eax,0x0(%r13)
  40199f:	eb 0c                	jmp    4019ad <vsprintf+0x3c9>
  4019a1:	49 8b 55 08          	mov    0x8(%r13),%rdx
  4019a5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  4019a9:	49 89 45 08          	mov    %rax,0x8(%r13)
  4019ad:	48 8b 02             	mov    (%rdx),%rax
				*ip = (str - buf);
  4019b0:	48 89 da             	mov    %rbx,%rdx
  4019b3:	48 2b 54 24 08       	sub    0x8(%rsp),%rdx
  4019b8:	89 10                	mov    %edx,(%rax)
  4019ba:	e9 39 01 00 00       	jmpq   401af8 <vsprintf+0x514>
			}
			continue;

		case '%':
			*str++ = '%';
  4019bf:	c6 03 25             	movb   $0x25,(%rbx)
  4019c2:	48 8d 5b 01          	lea    0x1(%rbx),%rbx
			continue;
  4019c6:	e9 2d 01 00 00       	jmpq   401af8 <vsprintf+0x514>

			/* integer number formats - set up the flags and "break" */
		case 'o':
			base = 8;
  4019cb:	ba 08 00 00 00       	mov    $0x8,%edx
			break;
  4019d0:	eb 4b                	jmp    401a1d <vsprintf+0x439>

		case 'x':
			flags |= SMALL;
  4019d2:	83 cd 20             	or     $0x20,%ebp
		case 'X':
			base = 16;
  4019d5:	ba 10 00 00 00       	mov    $0x10,%edx
  4019da:	eb 41                	jmp    401a1d <vsprintf+0x439>
			break;

		case 'd':
		case 'i':
			flags |= SIGN;
  4019dc:	83 cd 02             	or     $0x2,%ebp
			qualifier = *fmt;
			++fmt;
		}

		/* default base */
		base = 10;
  4019df:	ba 0a 00 00 00       	mov    $0xa,%edx
  4019e4:	eb 37                	jmp    401a1d <vsprintf+0x439>
			flags |= SIGN;
		case 'u':
			break;

		default:
			*str++ = '%';
  4019e6:	c6 03 25             	movb   $0x25,(%rbx)
			if (*fmt)
  4019e9:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  4019ee:	0f b6 10             	movzbl (%rax),%edx
  4019f1:	84 d2                	test   %dl,%dl
  4019f3:	74 0c                	je     401a01 <vsprintf+0x41d>
				*str++ = *fmt;
  4019f5:	88 53 01             	mov    %dl,0x1(%rbx)
  4019f8:	48 8d 5b 02          	lea    0x2(%rbx),%rbx
  4019fc:	e9 f7 00 00 00       	jmpq   401af8 <vsprintf+0x514>
			flags |= SIGN;
		case 'u':
			break;

		default:
			*str++ = '%';
  401a01:	48 ff c3             	inc    %rbx
			if (*fmt)
				*str++ = *fmt;
			else
				--fmt;
  401a04:	48 ff c8             	dec    %rax
  401a07:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  401a0c:	e9 e7 00 00 00       	jmpq   401af8 <vsprintf+0x514>
			qualifier = *fmt;
			++fmt;
		}

		/* default base */
		base = 10;
  401a11:	ba 0a 00 00 00       	mov    $0xa,%edx
  401a16:	eb 05                	jmp    401a1d <vsprintf+0x439>
			break;

		case 'x':
			flags |= SMALL;
		case 'X':
			base = 16;
  401a18:	ba 10 00 00 00       	mov    $0x10,%edx
				*str++ = *fmt;
			else
				--fmt;
			continue;
		}
		if (qualifier == 'l')
  401a1d:	83 f9 6c             	cmp    $0x6c,%ecx
  401a20:	75 2c                	jne    401a4e <vsprintf+0x46a>
			num = va_arg(args, unsigned long);
  401a22:	41 8b 45 00          	mov    0x0(%r13),%eax
  401a26:	83 f8 30             	cmp    $0x30,%eax
  401a29:	73 0f                	jae    401a3a <vsprintf+0x456>
  401a2b:	89 c1                	mov    %eax,%ecx
  401a2d:	49 03 4d 10          	add    0x10(%r13),%rcx
  401a31:	83 c0 08             	add    $0x8,%eax
  401a34:	41 89 45 00          	mov    %eax,0x0(%r13)
  401a38:	eb 0c                	jmp    401a46 <vsprintf+0x462>
  401a3a:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  401a3e:	48 8d 41 08          	lea    0x8(%rcx),%rax
  401a42:	49 89 45 08          	mov    %rax,0x8(%r13)
  401a46:	48 8b 31             	mov    (%rcx),%rsi
  401a49:	e9 94 00 00 00       	jmpq   401ae2 <vsprintf+0x4fe>
		else if (qualifier == 'h') {
  401a4e:	83 f9 68             	cmp    $0x68,%ecx
  401a51:	75 3a                	jne    401a8d <vsprintf+0x4a9>
			num = (unsigned short)va_arg(args, int);
  401a53:	41 8b 45 00          	mov    0x0(%r13),%eax
  401a57:	83 f8 30             	cmp    $0x30,%eax
  401a5a:	73 0f                	jae    401a6b <vsprintf+0x487>
  401a5c:	89 c1                	mov    %eax,%ecx
  401a5e:	49 03 4d 10          	add    0x10(%r13),%rcx
  401a62:	83 c0 08             	add    $0x8,%eax
  401a65:	41 89 45 00          	mov    %eax,0x0(%r13)
  401a69:	eb 0c                	jmp    401a77 <vsprintf+0x493>
  401a6b:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  401a6f:	48 8d 41 08          	lea    0x8(%rcx),%rax
  401a73:	49 89 45 08          	mov    %rax,0x8(%r13)
  401a77:	8b 01                	mov    (%rcx),%eax
  401a79:	0f b7 c8             	movzwl %ax,%ecx
  401a7c:	48 0f bf c0          	movswq %ax,%rax
  401a80:	40 f6 c5 02          	test   $0x2,%bpl
  401a84:	48 0f 45 c8          	cmovne %rax,%rcx
  401a88:	48 89 ce             	mov    %rcx,%rsi
  401a8b:	eb 55                	jmp    401ae2 <vsprintf+0x4fe>
			if (flags & SIGN)
				num = (short)num;
		} else if (flags & SIGN)
  401a8d:	40 f6 c5 02          	test   $0x2,%bpl
  401a91:	74 29                	je     401abc <vsprintf+0x4d8>
			num = va_arg(args, int);
  401a93:	41 8b 45 00          	mov    0x0(%r13),%eax
  401a97:	83 f8 30             	cmp    $0x30,%eax
  401a9a:	73 0f                	jae    401aab <vsprintf+0x4c7>
  401a9c:	89 c1                	mov    %eax,%ecx
  401a9e:	49 03 4d 10          	add    0x10(%r13),%rcx
  401aa2:	83 c0 08             	add    $0x8,%eax
  401aa5:	41 89 45 00          	mov    %eax,0x0(%r13)
  401aa9:	eb 0c                	jmp    401ab7 <vsprintf+0x4d3>
  401aab:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  401aaf:	48 8d 41 08          	lea    0x8(%rcx),%rax
  401ab3:	49 89 45 08          	mov    %rax,0x8(%r13)
  401ab7:	48 63 31             	movslq (%rcx),%rsi
  401aba:	eb 26                	jmp    401ae2 <vsprintf+0x4fe>
		else
			num = va_arg(args, unsigned int);
  401abc:	41 8b 45 00          	mov    0x0(%r13),%eax
  401ac0:	83 f8 30             	cmp    $0x30,%eax
  401ac3:	73 0f                	jae    401ad4 <vsprintf+0x4f0>
  401ac5:	89 c1                	mov    %eax,%ecx
  401ac7:	49 03 4d 10          	add    0x10(%r13),%rcx
  401acb:	83 c0 08             	add    $0x8,%eax
  401ace:	41 89 45 00          	mov    %eax,0x0(%r13)
  401ad2:	eb 0c                	jmp    401ae0 <vsprintf+0x4fc>
  401ad4:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  401ad8:	48 8d 41 08          	lea    0x8(%rcx),%rax
  401adc:	49 89 45 08          	mov    %rax,0x8(%r13)
  401ae0:	8b 31                	mov    (%rcx),%esi
		str = number(str, num, base, field_width, precision, flags);
  401ae2:	41 89 e9             	mov    %ebp,%r9d
  401ae5:	44 89 f1             	mov    %r14d,%ecx
  401ae8:	48 89 df             	mov    %rbx,%rdi
  401aeb:	e8 70 f8 ff ff       	callq  401360 <number>
  401af0:	48 89 c3             	mov    %rax,%rbx
  401af3:	eb 03                	jmp    401af8 <vsprintf+0x514>
		switch (*fmt) {
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
  401af5:	48 89 cb             	mov    %rcx,%rbx
	int field_width;	/* width of output field */
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L:' for integer fields */

	for (str = buf; *fmt; ++fmt) {
  401af8:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  401afd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  401b01:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  401b06:	0f b6 40 01          	movzbl 0x1(%rax),%eax
  401b0a:	84 c0                	test   %al,%al
  401b0c:	0f 85 0c fb ff ff    	jne    40161e <vsprintf+0x3a>
  401b12:	eb 05                	jmp    401b19 <vsprintf+0x535>
  401b14:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
			num = va_arg(args, int);
		else
			num = va_arg(args, unsigned int);
		str = number(str, num, base, field_width, precision, flags);
	}
	*str = '\0';
  401b19:	c6 03 00             	movb   $0x0,(%rbx)
	return str - buf;
  401b1c:	48 89 d8             	mov    %rbx,%rax
  401b1f:	48 2b 44 24 08       	sub    0x8(%rsp),%rax
}
  401b24:	48 83 c4 28          	add    $0x28,%rsp
  401b28:	5b                   	pop    %rbx
  401b29:	5d                   	pop    %rbp
  401b2a:	41 5c                	pop    %r12
  401b2c:	41 5d                	pop    %r13
  401b2e:	41 5e                	pop    %r14
  401b30:	41 5f                	pop    %r15
  401b32:	c3                   	retq   

0000000000401b33 <printf>:
	return str;
}

//static char printf_buf[1024];

int printf(const char *format, ...) {
  401b33:	55                   	push   %rbp
  401b34:	53                   	push   %rbx
  401b35:	48 81 ec 58 04 00 00 	sub    $0x458,%rsp
  401b3c:	48 89 b4 24 28 04 00 	mov    %rsi,0x428(%rsp)
  401b43:	00 
  401b44:	48 89 94 24 30 04 00 	mov    %rdx,0x430(%rsp)
  401b4b:	00 
  401b4c:	48 89 8c 24 38 04 00 	mov    %rcx,0x438(%rsp)
  401b53:	00 
  401b54:	4c 89 84 24 40 04 00 	mov    %r8,0x440(%rsp)
  401b5b:	00 
  401b5c:	4c 89 8c 24 48 04 00 	mov    %r9,0x448(%rsp)
  401b63:	00 
  401b64:	48 89 fe             	mov    %rdi,%rsi
	va_list val;
	int printed = 0;
	char printf_buf[1024];
	//reset(printf_buf,1024);
	va_start(val, format);
  401b67:	c7 84 24 08 04 00 00 	movl   $0x8,0x408(%rsp)
  401b6e:	08 00 00 00 
  401b72:	48 8d 84 24 70 04 00 	lea    0x470(%rsp),%rax
  401b79:	00 
  401b7a:	48 89 84 24 10 04 00 	mov    %rax,0x410(%rsp)
  401b81:	00 
  401b82:	48 8d 84 24 20 04 00 	lea    0x420(%rsp),%rax
  401b89:	00 
  401b8a:	48 89 84 24 18 04 00 	mov    %rax,0x418(%rsp)
  401b91:	00 
	printed = vsprintf(printf_buf, format, val);
  401b92:	48 8d 94 24 08 04 00 	lea    0x408(%rsp),%rdx
  401b99:	00 
  401b9a:	48 8d 6c 24 08       	lea    0x8(%rsp),%rbp
  401b9f:	48 89 ef             	mov    %rbp,%rdi
  401ba2:	e8 3d fa ff ff       	callq  4015e4 <vsprintf>
  401ba7:	89 c3                	mov    %eax,%ebx
	write(1, printf_buf, printed);
  401ba9:	48 63 d0             	movslq %eax,%rdx
  401bac:	48 89 ee             	mov    %rbp,%rsi
  401baf:	bf 01 00 00 00       	mov    $0x1,%edi
  401bb4:	e8 5e 06 00 00       	callq  402217 <write>
	//write(1, format, printed);
	
	va_end(val);
	return printed;
}
  401bb9:	89 d8                	mov    %ebx,%eax
  401bbb:	48 81 c4 58 04 00 00 	add    $0x458,%rsp
  401bc2:	5b                   	pop    %rbx
  401bc3:	5d                   	pop    %rbp
  401bc4:	c3                   	retq   

0000000000401bc5 <serror>:
	}
	*str = '\0';
	return str - buf;
}

void serror(int error){
  401bc5:	48 83 ec 08          	sub    $0x8,%rsp
    switch(error){
  401bc9:	83 ff 28             	cmp    $0x28,%edi
  401bcc:	0f 87 10 02 00 00    	ja     401de2 <serror+0x21d>
  401bd2:	89 ff                	mov    %edi,%edi
  401bd4:	48 8d 05 59 0e 00 00 	lea    0xe59(%rip),%rax        # 402a34 <atoi+0x397>
  401bdb:	48 63 14 b8          	movslq (%rax,%rdi,4),%rdx
  401bdf:	48 01 d0             	add    %rdx,%rax
  401be2:	ff e0                	jmpq   *%rax
		case EPERM:	 
				printf("operation is not permitted \n");
  401be4:	48 8d 3d 05 0f 00 00 	lea    0xf05(%rip),%rdi        # 402af0 <digits.1233+0x10>
  401beb:	b8 00 00 00 00       	mov    $0x0,%eax
  401bf0:	e8 3e ff ff ff       	callq  401b33 <printf>
				break;
  401bf5:	e9 f9 01 00 00       	jmpq   401df3 <serror+0x22e>
        case ENOENT : 
				printf("No Such File or directory\n"); 
  401bfa:	48 8d 3d 0c 0f 00 00 	lea    0xf0c(%rip),%rdi        # 402b0d <digits.1233+0x2d>
  401c01:	b8 00 00 00 00       	mov    $0x0,%eax
  401c06:	e8 28 ff ff ff       	callq  401b33 <printf>
				break;
  401c0b:	e9 e3 01 00 00       	jmpq   401df3 <serror+0x22e>
		case EINTR	:
				printf("Interrupted system call \n");
  401c10:	48 8d 3d 11 0f 00 00 	lea    0xf11(%rip),%rdi        # 402b28 <digits.1233+0x48>
  401c17:	b8 00 00 00 00       	mov    $0x0,%eax
  401c1c:	e8 12 ff ff ff       	callq  401b33 <printf>
				break;
  401c21:	e9 cd 01 00 00       	jmpq   401df3 <serror+0x22e>
		case EIO : 
				printf("Input outpur error \n"); 
  401c26:	48 8d 3d 15 0f 00 00 	lea    0xf15(%rip),%rdi        # 402b42 <digits.1233+0x62>
  401c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  401c32:	e8 fc fe ff ff       	callq  401b33 <printf>
				break;
  401c37:	e9 b7 01 00 00       	jmpq   401df3 <serror+0x22e>
		case E2BIG : 
				printf("Argument list too long \n"); 
  401c3c:	48 8d 3d 14 0f 00 00 	lea    0xf14(%rip),%rdi        # 402b57 <digits.1233+0x77>
  401c43:	b8 00 00 00 00       	mov    $0x0,%eax
  401c48:	e8 e6 fe ff ff       	callq  401b33 <printf>
				break;	
  401c4d:	e9 a1 01 00 00       	jmpq   401df3 <serror+0x22e>
		case ENOEXEC : 
				printf("Exec format error \n"); 
  401c52:	48 8d 3d 17 0f 00 00 	lea    0xf17(%rip),%rdi        # 402b70 <digits.1233+0x90>
  401c59:	b8 00 00 00 00       	mov    $0x0,%eax
  401c5e:	e8 d0 fe ff ff       	callq  401b33 <printf>
				break;	
  401c63:	e9 8b 01 00 00       	jmpq   401df3 <serror+0x22e>
		case EBADF 	 : 
				printf("Bad File number \n"); 
  401c68:	48 8d 3d 15 0f 00 00 	lea    0xf15(%rip),%rdi        # 402b84 <digits.1233+0xa4>
  401c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  401c74:	e8 ba fe ff ff       	callq  401b33 <printf>
				break;
  401c79:	e9 75 01 00 00       	jmpq   401df3 <serror+0x22e>
		case ECHILD : 
				printf("No child process \n"); 
  401c7e:	48 8d 3d 11 0f 00 00 	lea    0xf11(%rip),%rdi        # 402b96 <digits.1233+0xb6>
  401c85:	b8 00 00 00 00       	mov    $0x0,%eax
  401c8a:	e8 a4 fe ff ff       	callq  401b33 <printf>
				break;
  401c8f:	e9 5f 01 00 00       	jmpq   401df3 <serror+0x22e>
		case EAGAIN:
				printf("error: try again \n");
  401c94:	48 8d 3d 0e 0f 00 00 	lea    0xf0e(%rip),%rdi        # 402ba9 <digits.1233+0xc9>
  401c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  401ca0:	e8 8e fe ff ff       	callq  401b33 <printf>
				break;
  401ca5:	e9 49 01 00 00       	jmpq   401df3 <serror+0x22e>
        case ENOMEM : 
				printf("Out of memory\n");
  401caa:	48 8d 3d 0b 0f 00 00 	lea    0xf0b(%rip),%rdi        # 402bbc <digits.1233+0xdc>
  401cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  401cb6:	e8 78 fe ff ff       	callq  401b33 <printf>
				break;
  401cbb:	e9 33 01 00 00       	jmpq   401df3 <serror+0x22e>
        case EACCES : 
				printf("Permission denied\n"); 
  401cc0:	48 8d 3d 04 0f 00 00 	lea    0xf04(%rip),%rdi        # 402bcb <digits.1233+0xeb>
  401cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  401ccc:	e8 62 fe ff ff       	callq  401b33 <printf>
				break;
  401cd1:	e9 1d 01 00 00       	jmpq   401df3 <serror+0x22e>
		case EFAULT : 
				printf("Bad address \n"); 
  401cd6:	48 8d 3d 01 0f 00 00 	lea    0xf01(%rip),%rdi        # 402bde <digits.1233+0xfe>
  401cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  401ce2:	e8 4c fe ff ff       	callq  401b33 <printf>
				break;	
  401ce7:	e9 07 01 00 00       	jmpq   401df3 <serror+0x22e>
		case EBUSY	:
				printf("Device or resource busy \n");
  401cec:	48 8d 3d f9 0e 00 00 	lea    0xef9(%rip),%rdi        # 402bec <digits.1233+0x10c>
  401cf3:	b8 00 00 00 00       	mov    $0x0,%eax
  401cf8:	e8 36 fe ff ff       	callq  401b33 <printf>
				break;
  401cfd:	e9 f1 00 00 00       	jmpq   401df3 <serror+0x22e>
		case EEXIST : 
				printf("File exists \n"); 
  401d02:	48 8d 3d fd 0e 00 00 	lea    0xefd(%rip),%rdi        # 402c06 <digits.1233+0x126>
  401d09:	b8 00 00 00 00       	mov    $0x0,%eax
  401d0e:	e8 20 fe ff ff       	callq  401b33 <printf>
				break;	
  401d13:	e9 db 00 00 00       	jmpq   401df3 <serror+0x22e>
		case ENOTDIR : 
				printf("Not a directory \n"); 
  401d18:	48 8d 3d f5 0e 00 00 	lea    0xef5(%rip),%rdi        # 402c14 <digits.1233+0x134>
  401d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  401d24:	e8 0a fe ff ff       	callq  401b33 <printf>
				break;	
  401d29:	e9 c5 00 00 00       	jmpq   401df3 <serror+0x22e>
		case EISDIR : 
				printf("is a directory \n"); 
  401d2e:	48 8d 3d f1 0e 00 00 	lea    0xef1(%rip),%rdi        # 402c26 <digits.1233+0x146>
  401d35:	b8 00 00 00 00       	mov    $0x0,%eax
  401d3a:	e8 f4 fd ff ff       	callq  401b33 <printf>
				break;	
  401d3f:	e9 af 00 00 00       	jmpq   401df3 <serror+0x22e>
		case EINVAL : 
				printf("Invalid Argument \n"); 
  401d44:	48 8d 3d ec 0e 00 00 	lea    0xeec(%rip),%rdi        # 402c37 <digits.1233+0x157>
  401d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  401d50:	e8 de fd ff ff       	callq  401b33 <printf>
				break;
  401d55:	e9 99 00 00 00       	jmpq   401df3 <serror+0x22e>
		case ENFILE	:
				printf("File table overflow \n");
  401d5a:	48 8d 3d e9 0e 00 00 	lea    0xee9(%rip),%rdi        # 402c4a <digits.1233+0x16a>
  401d61:	b8 00 00 00 00       	mov    $0x0,%eax
  401d66:	e8 c8 fd ff ff       	callq  401b33 <printf>
				break;
  401d6b:	e9 83 00 00 00       	jmpq   401df3 <serror+0x22e>
		case EMFILE :
				printf("Too many open files \n");
  401d70:	48 8d 3d e9 0e 00 00 	lea    0xee9(%rip),%rdi        # 402c60 <digits.1233+0x180>
  401d77:	b8 00 00 00 00       	mov    $0x0,%eax
  401d7c:	e8 b2 fd ff ff       	callq  401b33 <printf>
				break;
  401d81:	eb 70                	jmp    401df3 <serror+0x22e>
		case EFBIG : 
				printf("File too large \n"); 
  401d83:	48 8d 3d ec 0e 00 00 	lea    0xeec(%rip),%rdi        # 402c76 <digits.1233+0x196>
  401d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  401d8f:	e8 9f fd ff ff       	callq  401b33 <printf>
				break;
  401d94:	eb 5d                	jmp    401df3 <serror+0x22e>
        case EROFS : 
				printf("Read-only file system\n"); 
  401d96:	48 8d 3d ea 0e 00 00 	lea    0xeea(%rip),%rdi        # 402c87 <digits.1233+0x1a7>
  401d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  401da2:	e8 8c fd ff ff       	callq  401b33 <printf>
				break;
  401da7:	eb 4a                	jmp    401df3 <serror+0x22e>
		case ELOOP:
				printf("Too many symbolic links encountered \n");
  401da9:	48 8d 3d 18 0f 00 00 	lea    0xf18(%rip),%rdi        # 402cc8 <digits.1233+0x1e8>
  401db0:	b8 00 00 00 00       	mov    $0x0,%eax
  401db5:	e8 79 fd ff ff       	callq  401b33 <printf>
				break;
  401dba:	eb 37                	jmp    401df3 <serror+0x22e>
		case EPIPE: 
				printf("Broken pipe \n"); 
  401dbc:	48 8d 3d db 0e 00 00 	lea    0xedb(%rip),%rdi        # 402c9e <digits.1233+0x1be>
  401dc3:	b8 00 00 00 00       	mov    $0x0,%eax
  401dc8:	e8 66 fd ff ff       	callq  401b33 <printf>
				break;
  401dcd:	eb 24                	jmp    401df3 <serror+0x22e>
		case ENAMETOOLONG : 
				printf("File name too long \n"); 
  401dcf:	48 8d 3d d6 0e 00 00 	lea    0xed6(%rip),%rdi        # 402cac <digits.1233+0x1cc>
  401dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  401ddb:	e8 53 fd ff ff       	callq  401b33 <printf>
				break;	
  401de0:	eb 11                	jmp    401df3 <serror+0x22e>
        default : 
			printf("Error in Opening or Executing\n");
  401de2:	48 8d 3d 07 0f 00 00 	lea    0xf07(%rip),%rdi        # 402cf0 <digits.1233+0x210>
  401de9:	b8 00 00 00 00       	mov    $0x0,%eax
  401dee:	e8 40 fd ff ff       	callq  401b33 <printf>
		
    }
  401df3:	48 83 c4 08          	add    $0x8,%rsp
  401df7:	c3                   	retq   
  401df8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  401dff:	00 

0000000000401e00 <scanf>:
#define MAXSIZE 1024

static char data[1024];
	
int scanf(const char *format, ...)
{
  401e00:	41 55                	push   %r13
  401e02:	41 54                	push   %r12
  401e04:	55                   	push   %rbp
  401e05:	53                   	push   %rbx
  401e06:	48 83 ec 58          	sub    $0x58,%rsp
  401e0a:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  401e0f:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
  401e14:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  401e19:	4c 89 44 24 40       	mov    %r8,0x40(%rsp)
  401e1e:	4c 89 4c 24 48       	mov    %r9,0x48(%rsp)
  401e23:	48 89 fb             	mov    %rdi,%rbx
	va_list val;
	va_start(val, format);
  401e26:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%rsp)
  401e2d:	00 
  401e2e:	48 8d 84 24 80 00 00 	lea    0x80(%rsp),%rax
  401e35:	00 
  401e36:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  401e3b:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  401e40:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
	reset(data,1024);
  401e45:	be 00 04 00 00       	mov    $0x400,%esi
  401e4a:	48 8d 3d 0f 23 20 00 	lea    0x20230f(%rip),%rdi        # 604160 <data>
  401e51:	e8 31 08 00 00       	callq  402687 <reset>
	int size = -1;
  401e56:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
					}
				//printf("res is %s \n", data);
				break;
				case 'd':
				//read integer
					size = read(0, data, MAXSIZE);
  401e5b:	4c 8d 25 fe 22 20 00 	lea    0x2022fe(%rip),%r12        # 604160 <data>
{
	va_list val;
	va_start(val, format);
	reset(data,1024);
	int size = -1;
	while(*format)
  401e62:	e9 6d 01 00 00       	jmpq   401fd4 <scanf+0x1d4>
	{
		if(*format++ == '%')
  401e67:	48 8d 4b 01          	lea    0x1(%rbx),%rcx
  401e6b:	80 fa 25             	cmp    $0x25,%dl
  401e6e:	74 08                	je     401e78 <scanf+0x78>
  401e70:	48 89 cb             	mov    %rcx,%rbx
  401e73:	e9 5c 01 00 00       	jmpq   401fd4 <scanf+0x1d4>
		{
			switch(*format)
  401e78:	0f b6 53 01          	movzbl 0x1(%rbx),%edx
  401e7c:	80 fa 64             	cmp    $0x64,%dl
  401e7f:	0f 84 8b 00 00 00    	je     401f10 <scanf+0x110>
  401e85:	80 fa 64             	cmp    $0x64,%dl
  401e88:	7f 0e                	jg     401e98 <scanf+0x98>
  401e8a:	80 fa 63             	cmp    $0x63,%dl
  401e8d:	0f 84 dd 00 00 00    	je     401f70 <scanf+0x170>
  401e93:	e9 38 01 00 00       	jmpq   401fd0 <scanf+0x1d0>
  401e98:	80 fa 73             	cmp    $0x73,%dl
  401e9b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  401ea0:	74 13                	je     401eb5 <scanf+0xb5>
  401ea2:	80 fa 78             	cmp    $0x78,%dl
  401ea5:	0f 84 11 01 00 00    	je     401fbc <scanf+0x1bc>
  401eab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  401eb0:	e9 1b 01 00 00       	jmpq   401fd0 <scanf+0x1d0>
			{
				case 's':
				//read string;
					size = read(0, data, MAXSIZE);
  401eb5:	ba 00 04 00 00       	mov    $0x400,%edx
  401eba:	4c 89 e6             	mov    %r12,%rsi
  401ebd:	bf 00 00 00 00       	mov    $0x0,%edi
  401ec2:	e8 fd 02 00 00       	callq  4021c4 <read>
  401ec7:	49 89 c5             	mov    %rax,%r13
  401eca:	89 c5                	mov    %eax,%ebp
					if(size != -1)
  401ecc:	83 f8 ff             	cmp    $0xffffffff,%eax
  401ecf:	0f 84 fb 00 00 00    	je     401fd0 <scanf+0x1d0>
					{
						char *c = va_arg(val, char *);
  401ed5:	8b 44 24 08          	mov    0x8(%rsp),%eax
  401ed9:	83 f8 30             	cmp    $0x30,%eax
  401edc:	73 10                	jae    401eee <scanf+0xee>
  401ede:	89 c2                	mov    %eax,%edx
  401ee0:	48 03 54 24 18       	add    0x18(%rsp),%rdx
  401ee5:	83 c0 08             	add    $0x8,%eax
  401ee8:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401eec:	eb 0e                	jmp    401efc <scanf+0xfc>
  401eee:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  401ef3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  401ef7:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
						//printf("char c : %p \n", c);
						strcpy(c, data);
  401efc:	4c 89 e6             	mov    %r12,%rsi
  401eff:	48 8b 3a             	mov    (%rdx),%rdi
  401f02:	e8 e9 05 00 00       	callq  4024f0 <strcpy>
						//memcpy((void*)(c), (void*)data, size - 1);
						//memcpy((void*)(va_arg(val, char *)), (void*)data, size - 1);
						size--;
  401f07:	41 8d 6d ff          	lea    -0x1(%r13),%ebp
  401f0b:	e9 c0 00 00 00       	jmpq   401fd0 <scanf+0x1d0>
					}
				//printf("res is %s \n", data);
				break;
				case 'd':
				//read integer
					size = read(0, data, MAXSIZE);
  401f10:	ba 00 04 00 00       	mov    $0x400,%edx
  401f15:	4c 89 e6             	mov    %r12,%rsi
  401f18:	bf 00 00 00 00       	mov    $0x0,%edi
  401f1d:	e8 a2 02 00 00       	callq  4021c4 <read>
					if(size == -1)
  401f22:	83 f8 ff             	cmp    $0xffffffff,%eax
  401f25:	0f 84 b8 00 00 00    	je     401fe3 <scanf+0x1e3>
						return size;
					size--;
  401f2b:	8d 68 ff             	lea    -0x1(%rax),%ebp
					data[size] = '\0';
  401f2e:	48 63 c5             	movslq %ebp,%rax
  401f31:	41 c6 04 04 00       	movb   $0x0,(%r12,%rax,1)
					uint64_t *arg = va_arg(val, uint64_t *);
  401f36:	8b 44 24 08          	mov    0x8(%rsp),%eax
  401f3a:	83 f8 30             	cmp    $0x30,%eax
  401f3d:	73 10                	jae    401f4f <scanf+0x14f>
  401f3f:	89 c2                	mov    %eax,%edx
  401f41:	48 03 54 24 18       	add    0x18(%rsp),%rdx
  401f46:	83 c0 08             	add    $0x8,%eax
  401f49:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401f4d:	eb 0e                	jmp    401f5d <scanf+0x15d>
  401f4f:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  401f54:	48 8d 42 08          	lea    0x8(%rdx),%rax
  401f58:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  401f5d:	4c 8b 2a             	mov    (%rdx),%r13
					*arg = atoi(data);
  401f60:	4c 89 e7             	mov    %r12,%rdi
  401f63:	e8 35 07 00 00       	callq  40269d <atoi>
  401f68:	48 98                	cltq   
  401f6a:	49 89 45 00          	mov    %rax,0x0(%r13)
				break;
  401f6e:	eb 60                	jmp    401fd0 <scanf+0x1d0>
				case 'c':
					size = read(0, data, 1);
  401f70:	ba 01 00 00 00       	mov    $0x1,%edx
  401f75:	4c 89 e6             	mov    %r12,%rsi
  401f78:	bf 00 00 00 00       	mov    $0x0,%edi
  401f7d:	e8 42 02 00 00       	callq  4021c4 <read>
  401f82:	89 c5                	mov    %eax,%ebp
				
					if(size == -1)
  401f84:	83 f8 ff             	cmp    $0xffffffff,%eax
  401f87:	74 5c                	je     401fe5 <scanf+0x1e5>
						return size;
					char *c = va_arg(val, char *);
  401f89:	8b 44 24 08          	mov    0x8(%rsp),%eax
  401f8d:	83 f8 30             	cmp    $0x30,%eax
  401f90:	73 10                	jae    401fa2 <scanf+0x1a2>
  401f92:	89 c2                	mov    %eax,%edx
  401f94:	48 03 54 24 18       	add    0x18(%rsp),%rdx
  401f99:	83 c0 08             	add    $0x8,%eax
  401f9c:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401fa0:	eb 0e                	jmp    401fb0 <scanf+0x1b0>
  401fa2:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  401fa7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  401fab:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  401fb0:	48 8b 02             	mov    (%rdx),%rax
					*c = data[0];
  401fb3:	41 0f b6 14 24       	movzbl (%r12),%edx
  401fb8:	88 10                	mov    %dl,(%rax)
					//printf("size of char is %d \n", size);
				break;
  401fba:	eb 14                	jmp    401fd0 <scanf+0x1d0>
				case 'x':
					size = read(0, data, 1);
  401fbc:	ba 01 00 00 00       	mov    $0x1,%edx
  401fc1:	4c 89 e6             	mov    %r12,%rsi
  401fc4:	bf 00 00 00 00       	mov    $0x0,%edi
  401fc9:	e8 f6 01 00 00       	callq  4021c4 <read>
  401fce:	89 c5                	mov    %eax,%ebp
						
				//read character
				
			}
			format++;	
  401fd0:	48 83 c3 02          	add    $0x2,%rbx
{
	va_list val;
	va_start(val, format);
	reset(data,1024);
	int size = -1;
	while(*format)
  401fd4:	0f b6 13             	movzbl (%rbx),%edx
  401fd7:	84 d2                	test   %dl,%dl
  401fd9:	0f 85 88 fe ff ff    	jne    401e67 <scanf+0x67>
		}
	}
	//int res = read(0, data, 1);
	//printf("res is %d \n", size);
	va_end(val);
	return size;
  401fdf:	89 e8                	mov    %ebp,%eax
  401fe1:	eb 02                	jmp    401fe5 <scanf+0x1e5>
  401fe3:	eb 00                	jmp    401fe5 <scanf+0x1e5>
}
  401fe5:	48 83 c4 58          	add    $0x58,%rsp
  401fe9:	5b                   	pop    %rbx
  401fea:	5d                   	pop    %rbp
  401feb:	41 5c                	pop    %r12
  401fed:	41 5d                	pop    %r13
  401fef:	c3                   	retq   

0000000000401ff0 <exit>:
#include <error.h>

//static void *breakPtr;
__thread int errno;
/*working*/
void exit(int status){
  401ff0:	53                   	push   %rbx
	//printf("In libc exit %d\n",status);
    syscall_1(SYS_exit, status);
  401ff1:	48 63 df             	movslq %edi,%rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  401ff4:	b8 3c 00 00 00       	mov    $0x3c,%eax
  401ff9:	48 89 c0             	mov    %rax,%rax
  401ffc:	48 89 df             	mov    %rbx,%rdi
  401fff:	cd 80                	int    $0x80
  402001:	48 89 c0             	mov    %rax,%rax
}
  402004:	5b                   	pop    %rbx
  402005:	c3                   	retq   

0000000000402006 <kill>:

uint64_t kill(uint64_t pid)
{
  402006:	53                   	push   %rbx
  402007:	b8 54 00 00 00       	mov    $0x54,%eax
  40200c:	48 89 fb             	mov    %rdi,%rbx
  40200f:	48 89 c0             	mov    %rax,%rax
  402012:	48 89 df             	mov    %rbx,%rdi
  402015:	cd 80                	int    $0x80
  402017:	48 89 c0             	mov    %rax,%rax
	int ret = syscall_1(SYS_Kill, pid);	
/* 	printf("in libc ret : %d",ret); */
	return ret;
  40201a:	48 98                	cltq   
}
  40201c:	5b                   	pop    %rbx
  40201d:	c3                   	retq   

000000000040201e <brk>:

/*working*/
uint64_t brk(void *end_data_segment){
  40201e:	53                   	push   %rbx
  40201f:	b8 0c 00 00 00       	mov    $0xc,%eax
  402024:	48 89 fb             	mov    %rdi,%rbx
  402027:	48 89 c0             	mov    %rax,%rax
  40202a:	48 89 df             	mov    %rbx,%rdi
  40202d:	cd 80                	int    $0x80
  40202f:	48 89 c0             	mov    %rax,%rax
    return syscall_1(SYS_brk, (uint64_t)end_data_segment);
}
  402032:	5b                   	pop    %rbx
  402033:	c3                   	retq   

0000000000402034 <sbrk>:

/*working*/
/*working*/
void *sbrk(size_t increment){
  402034:	55                   	push   %rbp
  402035:	53                   	push   %rbx
  402036:	48 83 ec 08          	sub    $0x8,%rsp
  40203a:	48 89 fd             	mov    %rdi,%rbp
	void *breakPtr;
	//if(breakPtr == NULL)
	//printf("size %p \n", increment);
	breakPtr = (void *)((uint64_t)brk(0));
  40203d:	bf 00 00 00 00       	mov    $0x0,%edi
  402042:	e8 d7 ff ff ff       	callq  40201e <brk>
  402047:	48 89 c3             	mov    %rax,%rbx
	if(increment == 0)
  40204a:	48 85 ed             	test   %rbp,%rbp
  40204d:	74 09                	je     402058 <sbrk+0x24>
	{
		return breakPtr;
	}
	void *startAddr = breakPtr;
	breakPtr = breakPtr+increment;
  40204f:	48 8d 3c 28          	lea    (%rax,%rbp,1),%rdi
	brk(breakPtr);
  402053:	e8 c6 ff ff ff       	callq  40201e <brk>
    return startAddr;
}
  402058:	48 89 d8             	mov    %rbx,%rax
  40205b:	48 83 c4 08          	add    $0x8,%rsp
  40205f:	5b                   	pop    %rbx
  402060:	5d                   	pop    %rbp
  402061:	c3                   	retq   

0000000000402062 <fork>:

//#define T_SYSCALL               0x80       /* System call */

static __inline uint64_t syscall_0(uint64_t n) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  402062:	ba 39 00 00 00       	mov    $0x39,%edx
  402067:	48 89 d0             	mov    %rdx,%rax
  40206a:	cd 80                	int    $0x80
  40206c:	48 89 c2             	mov    %rax,%rdx
	if((int)res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
  40206f:	89 d0                	mov    %edx,%eax
}

/*working*/
pid_t fork(){
    uint32_t res = syscall_0(SYS_fork);
	if((int)res < 0)
  402071:	85 d2                	test   %edx,%edx
  402073:	79 10                	jns    402085 <fork+0x23>
	{
		errno = -res;
  402075:	f7 da                	neg    %edx
  402077:	48 8b 05 62 1c 20 00 	mov    0x201c62(%rip),%rax        # 603ce0 <digits.1233+0x201200>
  40207e:	89 10                	mov    %edx,(%rax)
		return -1;
  402080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  402085:	f3 c3                	repz retq 

0000000000402087 <getpid>:
  402087:	b8 27 00 00 00       	mov    $0x27,%eax
  40208c:	48 89 c0             	mov    %rax,%rax
  40208f:	cd 80                	int    $0x80
  402091:	48 89 c0             	mov    %rax,%rax

/*this method doesnt throw error always successful*/
pid_t getpid(){
    uint32_t res = syscall_0(SYS_getpid);
    return res;
}
  402094:	c3                   	retq   

0000000000402095 <getppid>:
  402095:	b8 6e 00 00 00       	mov    $0x6e,%eax
  40209a:	48 89 c0             	mov    %rax,%rax
  40209d:	cd 80                	int    $0x80
  40209f:	48 89 c0             	mov    %rax,%rax
/*working*/
pid_t getppid(){
    uint32_t res = syscall_0(SYS_getppid);
    return res;
}
  4020a2:	c3                   	retq   

00000000004020a3 <execve>:
/*wrokig*/
int execve(const char *filename, char *const argv[], char *const envp[]){
  4020a3:	53                   	push   %rbx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  4020a4:	b8 3b 00 00 00       	mov    $0x3b,%eax
  4020a9:	48 89 fb             	mov    %rdi,%rbx
  4020ac:	48 89 f1             	mov    %rsi,%rcx
  4020af:	48 89 c0             	mov    %rax,%rax
  4020b2:	48 89 df             	mov    %rbx,%rdi
  4020b5:	48 89 ce             	mov    %rcx,%rsi
  4020b8:	48 89 d2             	mov    %rdx,%rdx
  4020bb:	cd 80                	int    $0x80
  4020bd:	48 89 c0             	mov    %rax,%rax
  4020c0:	48 89 c2             	mov    %rax,%rdx
    uint64_t res = syscall_3(SYS_execve, (uint64_t)filename, (uint64_t)argv, (uint64_t)envp);
	if((int)res < 0)
  4020c3:	85 d2                	test   %edx,%edx
  4020c5:	79 10                	jns    4020d7 <execve+0x34>
	{
		errno = -res;
  4020c7:	f7 da                	neg    %edx
  4020c9:	48 8b 05 10 1c 20 00 	mov    0x201c10(%rip),%rax        # 603ce0 <digits.1233+0x201200>
  4020d0:	89 10                	mov    %edx,(%rax)
		return -1;
  4020d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  4020d7:	5b                   	pop    %rbx
  4020d8:	c3                   	retq   

00000000004020d9 <listprocess>:

//#define T_SYSCALL               0x80       /* System call */

static __inline uint64_t syscall_0(uint64_t n) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  4020d9:	b8 52 00 00 00       	mov    $0x52,%eax
  4020de:	48 89 c0             	mov    %rax,%rax
  4020e1:	cd 80                	int    $0x80
  4020e3:	48 89 c0             	mov    %rax,%rax
  4020e6:	c3                   	retq   

00000000004020e7 <cls>:
  4020e7:	b8 53 00 00 00       	mov    $0x53,%eax
  4020ec:	48 89 c0             	mov    %rax,%rax
  4020ef:	cd 80                	int    $0x80
  4020f1:	48 89 c0             	mov    %rax,%rax
  4020f4:	c3                   	retq   

00000000004020f5 <sleep>:
}
void cls(){
	syscall_0(SYS_clearscreen);
}

unsigned int sleep(unsigned int seconds){
  4020f5:	53                   	push   %rbx
    unsigned int res = syscall_1(SYS_nanosleep, seconds);
  4020f6:	89 fb                	mov    %edi,%ebx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  4020f8:	b8 23 00 00 00       	mov    $0x23,%eax
  4020fd:	48 89 c0             	mov    %rax,%rax
  402100:	48 89 df             	mov    %rbx,%rdi
  402103:	cd 80                	int    $0x80
  402105:	48 89 c0             	mov    %rax,%rax
    return res;
}
  402108:	5b                   	pop    %rbx
  402109:	c3                   	retq   

000000000040210a <alarm>:

unsigned int alarm(unsigned int seconds){
  40210a:	53                   	push   %rbx
    unsigned int res = syscall_1(SYS_alarm, seconds);
  40210b:	89 fb                	mov    %edi,%ebx
  40210d:	b8 25 00 00 00       	mov    $0x25,%eax
  402112:	48 89 c0             	mov    %rax,%rax
  402115:	48 89 df             	mov    %rbx,%rdi
  402118:	cd 80                	int    $0x80
  40211a:	48 89 c0             	mov    %rax,%rax
    return res;
}
  40211d:	5b                   	pop    %rbx
  40211e:	c3                   	retq   

000000000040211f <getcwd>:
/*working*/
char *getcwd(char *buf, size_t size){
  40211f:	55                   	push   %rbp
  402120:	53                   	push   %rbx
  402121:	48 83 ec 08          	sub    $0x8,%rsp
  402125:	48 89 fb             	mov    %rdi,%rbx
  402128:	48 89 f5             	mov    %rsi,%rbp
	memset(buf, 0, size);
  40212b:	48 89 f2             	mov    %rsi,%rdx
  40212e:	be 00 00 00 00       	mov    $0x0,%esi
  402133:	e8 7c 03 00 00       	callq  4024b4 <memset>
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  402138:	b8 4f 00 00 00       	mov    $0x4f,%eax
  40213d:	48 89 e9             	mov    %rbp,%rcx
  402140:	48 89 c0             	mov    %rax,%rax
  402143:	48 89 df             	mov    %rbx,%rdi
  402146:	48 89 ce             	mov    %rcx,%rsi
  402149:	cd 80                	int    $0x80
  40214b:	48 89 c0             	mov    %rax,%rax
    uint64_t res = syscall_2(SYS_getcwd, (uint64_t) buf, (uint64_t) size);
	if((char *)res == NULL)
  40214e:	48 85 c0             	test   %rax,%rax
  402151:	75 0d                	jne    402160 <getcwd+0x41>
	{
		errno = EFAULT;
  402153:	48 8b 15 86 1b 20 00 	mov    0x201b86(%rip),%rdx        # 603ce0 <digits.1233+0x201200>
  40215a:	c7 02 0e 00 00 00    	movl   $0xe,(%rdx)
	}
    return (char *)res;
}
  402160:	48 83 c4 08          	add    $0x8,%rsp
  402164:	5b                   	pop    %rbx
  402165:	5d                   	pop    %rbp
  402166:	c3                   	retq   

0000000000402167 <chdir>:
/*working*/ 
int chdir(const char *path){
  402167:	53                   	push   %rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  402168:	b8 50 00 00 00       	mov    $0x50,%eax
  40216d:	48 89 fb             	mov    %rdi,%rbx
  402170:	48 89 c0             	mov    %rax,%rax
  402173:	48 89 df             	mov    %rbx,%rdi
  402176:	cd 80                	int    $0x80
  402178:	48 89 c0             	mov    %rax,%rax
    int res = syscall_1(SYS_chdir, (uint64_t)path);
	if(res < 0)
  40217b:	85 c0                	test   %eax,%eax
  40217d:	79 10                	jns    40218f <chdir+0x28>
	{
		errno = -res;
  40217f:	f7 d8                	neg    %eax
  402181:	48 8b 15 58 1b 20 00 	mov    0x201b58(%rip),%rdx        # 603ce0 <digits.1233+0x201200>
  402188:	89 02                	mov    %eax,(%rdx)
		return -1;
  40218a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  40218f:	5b                   	pop    %rbx
  402190:	c3                   	retq   

0000000000402191 <open>:
/*working*/    
int open(const char *pathname, int flags){
  402191:	53                   	push   %rbx
    uint64_t res = syscall_2(SYS_open, (uint64_t) pathname, (uint64_t) flags);
  402192:	48 63 ce             	movslq %esi,%rcx
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  402195:	b8 02 00 00 00       	mov    $0x2,%eax
  40219a:	48 89 fb             	mov    %rdi,%rbx
  40219d:	48 89 c0             	mov    %rax,%rax
  4021a0:	48 89 df             	mov    %rbx,%rdi
  4021a3:	48 89 ce             	mov    %rcx,%rsi
  4021a6:	cd 80                	int    $0x80
  4021a8:	48 89 c0             	mov    %rax,%rax
  4021ab:	48 89 c1             	mov    %rax,%rcx
	if((int)res < 0)
  4021ae:	85 c9                	test   %ecx,%ecx
  4021b0:	79 10                	jns    4021c2 <open+0x31>
	{
		errno = -res;
  4021b2:	f7 d9                	neg    %ecx
  4021b4:	48 8b 05 25 1b 20 00 	mov    0x201b25(%rip),%rax        # 603ce0 <digits.1233+0x201200>
  4021bb:	89 08                	mov    %ecx,(%rax)
		return -1;
  4021bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  4021c2:	5b                   	pop    %rbx
  4021c3:	c3                   	retq   

00000000004021c4 <read>:

/*working*/
ssize_t read(int fd, void *buf, size_t count){
  4021c4:	41 54                	push   %r12
  4021c6:	55                   	push   %rbp
  4021c7:	53                   	push   %rbx
  4021c8:	89 fb                	mov    %edi,%ebx
  4021ca:	48 89 f5             	mov    %rsi,%rbp
  4021cd:	49 89 d4             	mov    %rdx,%r12
	memset(buf, 0, count);
  4021d0:	be 00 00 00 00       	mov    $0x0,%esi
  4021d5:	48 89 ef             	mov    %rbp,%rdi
  4021d8:	e8 d7 02 00 00       	callq  4024b4 <memset>
    ssize_t res = syscall_3(SYS_read, (uint64_t) fd, (uint64_t) buf, (uint64_t) count);
  4021dd:	48 63 db             	movslq %ebx,%rbx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  4021e0:	b8 00 00 00 00       	mov    $0x0,%eax
  4021e5:	48 89 e9             	mov    %rbp,%rcx
  4021e8:	4c 89 e2             	mov    %r12,%rdx
  4021eb:	48 89 c0             	mov    %rax,%rax
  4021ee:	48 89 df             	mov    %rbx,%rdi
  4021f1:	48 89 ce             	mov    %rcx,%rsi
  4021f4:	48 89 d2             	mov    %rdx,%rdx
  4021f7:	cd 80                	int    $0x80
  4021f9:	48 89 c0             	mov    %rax,%rax
	if((int)res < 0)
  4021fc:	85 c0                	test   %eax,%eax
  4021fe:	79 12                	jns    402212 <read+0x4e>
	{
		errno = -res;
  402200:	f7 d8                	neg    %eax
  402202:	48 8b 15 d7 1a 20 00 	mov    0x201ad7(%rip),%rdx        # 603ce0 <digits.1233+0x201200>
  402209:	89 02                	mov    %eax,(%rdx)
		return -1;
  40220b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
	}
    return res;
}
  402212:	5b                   	pop    %rbx
  402213:	5d                   	pop    %rbp
  402214:	41 5c                	pop    %r12
  402216:	c3                   	retq   

0000000000402217 <write>:

/*working*/
ssize_t write(int fd, const void *buf, size_t count){
  402217:	53                   	push   %rbx
    ssize_t res = syscall_3(SYS_write, (uint64_t) fd, (uint64_t) buf, (uint64_t) count);
  402218:	48 63 df             	movslq %edi,%rbx
  40221b:	b8 01 00 00 00       	mov    $0x1,%eax
  402220:	48 89 f1             	mov    %rsi,%rcx
  402223:	48 89 c0             	mov    %rax,%rax
  402226:	48 89 df             	mov    %rbx,%rdi
  402229:	48 89 ce             	mov    %rcx,%rsi
  40222c:	48 89 d2             	mov    %rdx,%rdx
  40222f:	cd 80                	int    $0x80
  402231:	48 89 c0             	mov    %rax,%rax
	if((int)res < 0)
  402234:	85 c0                	test   %eax,%eax
  402236:	79 12                	jns    40224a <write+0x33>
	{
		errno = -res;
  402238:	f7 d8                	neg    %eax
  40223a:	48 8b 15 9f 1a 20 00 	mov    0x201a9f(%rip),%rdx        # 603ce0 <digits.1233+0x201200>
  402241:	89 02                	mov    %eax,(%rdx)
		return -1;
  402243:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
	}
    return res; 
}
  40224a:	5b                   	pop    %rbx
  40224b:	c3                   	retq   

000000000040224c <lseek>:

off_t lseek(int fildes, off_t offset, int whence){
  40224c:	53                   	push   %rbx
    off_t res = syscall_3(SYS_lseek, (uint64_t) fildes, (uint64_t) offset, (uint64_t) whence);
  40224d:	48 63 df             	movslq %edi,%rbx
  402250:	48 63 d2             	movslq %edx,%rdx
  402253:	b8 08 00 00 00       	mov    $0x8,%eax
  402258:	48 89 f1             	mov    %rsi,%rcx
  40225b:	48 89 c0             	mov    %rax,%rax
  40225e:	48 89 df             	mov    %rbx,%rdi
  402261:	48 89 ce             	mov    %rcx,%rsi
  402264:	48 89 d2             	mov    %rdx,%rdx
  402267:	cd 80                	int    $0x80
  402269:	48 89 c0             	mov    %rax,%rax
  40226c:	48 89 c2             	mov    %rax,%rdx
	if((int)res < 0)
  40226f:	85 d2                	test   %edx,%edx
  402271:	79 12                	jns    402285 <lseek+0x39>
	{
		errno = -res;
  402273:	f7 da                	neg    %edx
  402275:	48 8b 05 64 1a 20 00 	mov    0x201a64(%rip),%rax        # 603ce0 <digits.1233+0x201200>
  40227c:	89 10                	mov    %edx,(%rax)
		return -1;
  40227e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
	}
    return res;
}
  402285:	5b                   	pop    %rbx
  402286:	c3                   	retq   

0000000000402287 <close>:
/*working*/
int close(int fd){
  402287:	53                   	push   %rbx
    int res = syscall_1(SYS_close, fd);
  402288:	48 63 df             	movslq %edi,%rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  40228b:	b8 03 00 00 00       	mov    $0x3,%eax
  402290:	48 89 c0             	mov    %rax,%rax
  402293:	48 89 df             	mov    %rbx,%rdi
  402296:	cd 80                	int    $0x80
  402298:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  40229b:	85 c0                	test   %eax,%eax
  40229d:	79 10                	jns    4022af <close+0x28>
	{
		errno = -res;
  40229f:	f7 d8                	neg    %eax
  4022a1:	48 8b 15 38 1a 20 00 	mov    0x201a38(%rip),%rdx        # 603ce0 <digits.1233+0x201200>
  4022a8:	89 02                	mov    %eax,(%rdx)
		return -1;
  4022aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  4022af:	5b                   	pop    %rbx
  4022b0:	c3                   	retq   

00000000004022b1 <pipe>:
/*working*/
int pipe(int filedes[2]){
  4022b1:	53                   	push   %rbx
	filedes[0] = -1;
  4022b2:	c7 07 ff ff ff ff    	movl   $0xffffffff,(%rdi)
	filedes[1] = -1;
  4022b8:	c7 47 04 ff ff ff ff 	movl   $0xffffffff,0x4(%rdi)
  4022bf:	b8 16 00 00 00       	mov    $0x16,%eax
  4022c4:	48 89 fb             	mov    %rdi,%rbx
  4022c7:	48 89 c0             	mov    %rax,%rax
  4022ca:	48 89 df             	mov    %rbx,%rdi
  4022cd:	cd 80                	int    $0x80
  4022cf:	48 89 c0             	mov    %rax,%rax
    int res = syscall_1(SYS_pipe, (uint64_t)filedes);
	if(res < 0)
  4022d2:	85 c0                	test   %eax,%eax
  4022d4:	79 10                	jns    4022e6 <pipe+0x35>
	{
		errno = -res;
  4022d6:	f7 d8                	neg    %eax
  4022d8:	48 8b 15 01 1a 20 00 	mov    0x201a01(%rip),%rdx        # 603ce0 <digits.1233+0x201200>
  4022df:	89 02                	mov    %eax,(%rdx)
		return -1;
  4022e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  4022e6:	5b                   	pop    %rbx
  4022e7:	c3                   	retq   

00000000004022e8 <dup>:

int dup(int oldfd){
  4022e8:	53                   	push   %rbx
    int res = syscall_1(SYS_dup,oldfd);
  4022e9:	48 63 df             	movslq %edi,%rbx
  4022ec:	b8 20 00 00 00       	mov    $0x20,%eax
  4022f1:	48 89 c0             	mov    %rax,%rax
  4022f4:	48 89 df             	mov    %rbx,%rdi
  4022f7:	cd 80                	int    $0x80
  4022f9:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  4022fc:	85 c0                	test   %eax,%eax
  4022fe:	79 10                	jns    402310 <dup+0x28>
	{
		errno = -res;
  402300:	f7 d8                	neg    %eax
  402302:	48 8b 15 d7 19 20 00 	mov    0x2019d7(%rip),%rdx        # 603ce0 <digits.1233+0x201200>
  402309:	89 02                	mov    %eax,(%rdx)
		return -1;
  40230b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  402310:	5b                   	pop    %rbx
  402311:	c3                   	retq   

0000000000402312 <dup2>:

int dup2(int oldfd, int newfd){
  402312:	53                   	push   %rbx
    int res = syscall_2(SYS_dup2, (uint64_t) oldfd, (uint64_t) newfd);
  402313:	48 63 df             	movslq %edi,%rbx
  402316:	48 63 ce             	movslq %esi,%rcx
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  402319:	b8 21 00 00 00       	mov    $0x21,%eax
  40231e:	48 89 c0             	mov    %rax,%rax
  402321:	48 89 df             	mov    %rbx,%rdi
  402324:	48 89 ce             	mov    %rcx,%rsi
  402327:	cd 80                	int    $0x80
  402329:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  40232c:	85 c0                	test   %eax,%eax
  40232e:	79 10                	jns    402340 <dup2+0x2e>
	{
		errno = -res;
  402330:	f7 d8                	neg    %eax
  402332:	48 8b 15 a7 19 20 00 	mov    0x2019a7(%rip),%rdx        # 603ce0 <digits.1233+0x201200>
  402339:	89 02                	mov    %eax,(%rdx)
		return -1;
  40233b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  402340:	5b                   	pop    %rbx
  402341:	c3                   	retq   

0000000000402342 <opendir>:

void *opendir(const char *name){
  402342:	55                   	push   %rbp
  402343:	53                   	push   %rbx
  402344:	48 83 ec 08          	sub    $0x8,%rsp
	int fd = open(name, O_DIRECTORY);
  402348:	be 00 00 01 00       	mov    $0x10000,%esi
  40234d:	e8 3f fe ff ff       	callq  402191 <open>
  402352:	89 c3                	mov    %eax,%ebx
	//char buf[1024];
	struct dirent *buf = malloc(sizeof(struct dirent));
  402354:	bf 18 04 00 00       	mov    $0x418,%edi
  402359:	e8 82 ef ff ff       	callq  4012e0 <malloc>
  40235e:	48 89 c5             	mov    %rax,%rbp
	memset(buf, 0, sizeof(struct dirent));
  402361:	ba 18 04 00 00       	mov    $0x418,%edx
  402366:	be 00 00 00 00       	mov    $0x0,%esi
  40236b:	48 89 c7             	mov    %rax,%rdi
  40236e:	e8 41 01 00 00       	callq  4024b4 <memset>
	//if(fd < 0)
	//	return -1;
	//static struct dirent dp;
	//printf("sashi 1 \n");
	//int res = 0;
	uint64_t res = syscall_3(SYS_getdents, (uint64_t)fd, (uint64_t)buf, (uint64_t)sizeof(struct dirent));
  402373:	48 63 db             	movslq %ebx,%rbx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  402376:	ba 18 04 00 00       	mov    $0x418,%edx
  40237b:	b8 4e 00 00 00       	mov    $0x4e,%eax
  402380:	48 89 e9             	mov    %rbp,%rcx
  402383:	48 89 c0             	mov    %rax,%rax
  402386:	48 89 df             	mov    %rbx,%rdi
  402389:	48 89 ce             	mov    %rcx,%rsi
  40238c:	48 89 d2             	mov    %rdx,%rdx
  40238f:	cd 80                	int    $0x80
  402391:	48 89 c0             	mov    %rax,%rax
	//strcpy(d->d_name, name);
	//printf("sashi 2 \n");
	//d = (struct dirent *)buf;
    //return (uint64_t)f;
	return (void *)buf;
}
  402394:	48 89 e8             	mov    %rbp,%rax
  402397:	48 83 c4 08          	add    $0x8,%rsp
  40239b:	5b                   	pop    %rbx
  40239c:	5d                   	pop    %rbp
  40239d:	c3                   	retq   

000000000040239e <readdir>:
	d = (struct dirent *)buf;
    return (void *)d;
}
*/
struct dirent * readdir(struct dirent *dir)
{
  40239e:	55                   	push   %rbp
  40239f:	53                   	push   %rbx
  4023a0:	48 83 ec 08          	sub    $0x8,%rsp
  4023a4:	48 89 fb             	mov    %rdi,%rbx
	struct dirent *next;
	next = (struct dirent *)(dir + dip->d_reclen);
	if(next->d_reclen == 0)
		return NULL;
	return next; */
	struct dirent *buf = malloc(sizeof(struct dirent));
  4023a7:	bf 18 04 00 00       	mov    $0x418,%edi
  4023ac:	e8 2f ef ff ff       	callq  4012e0 <malloc>
  4023b1:	48 89 c5             	mov    %rax,%rbp
	
	memset(buf, 0, sizeof(struct dirent));
  4023b4:	ba 18 04 00 00       	mov    $0x418,%edx
  4023b9:	be 00 00 00 00       	mov    $0x0,%esi
  4023be:	48 89 c7             	mov    %rax,%rdi
  4023c1:	e8 ee 00 00 00       	callq  4024b4 <memset>
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  4023c6:	b8 51 00 00 00       	mov    $0x51,%eax
  4023cb:	48 89 e9             	mov    %rbp,%rcx
  4023ce:	48 89 c0             	mov    %rax,%rax
  4023d1:	48 89 df             	mov    %rbx,%rdi
  4023d4:	48 89 ce             	mov    %rcx,%rsi
  4023d7:	cd 80                	int    $0x80
  4023d9:	48 89 c0             	mov    %rax,%rax
	//buf = NULL;
	syscall_2(SYS_readdir, (uint64_t)dir,(uint64_t)buf);
	//printf("in stdlib : %s ", buf->d_name);
	if(strlen(buf->d_name) == 0)
  4023dc:	48 8d 7d 12          	lea    0x12(%rbp),%rdi
  4023e0:	e8 4b 01 00 00       	callq  402530 <strlen>
  4023e5:	48 85 c0             	test   %rax,%rax
		return NULL;
  4023e8:	b8 00 00 00 00       	mov    $0x0,%eax
  4023ed:	48 0f 45 c5          	cmovne %rbp,%rax
	//printf("d_name %s \n",buf->d_name);
	//printf("End of readdir\n");
	return (struct dirent *)buf;
	//printf("dir inside readdir%s",dir->d_name);

}
  4023f1:	48 83 c4 08          	add    $0x8,%rsp
  4023f5:	5b                   	pop    %rbx
  4023f6:	5d                   	pop    %rbp
  4023f7:	c3                   	retq   

00000000004023f8 <closedir>:

int closedir(void *dir){
  4023f8:	55                   	push   %rbp
  4023f9:	53                   	push   %rbx
  4023fa:	48 83 ec 08          	sub    $0x8,%rsp
  4023fe:	48 89 fb             	mov    %rdi,%rbx
	struct dir *dp = (struct dir *)dir;
	int res = -1;
	if(dp != NULL)
  402401:	48 85 ff             	test   %rdi,%rdi
  402404:	74 13                	je     402419 <closedir+0x21>
	{	
		res = close(dp->fd);
  402406:	8b 3f                	mov    (%rdi),%edi
  402408:	e8 7a fe ff ff       	callq  402287 <close>
  40240d:	89 c5                	mov    %eax,%ebp
		free(dp);
  40240f:	48 89 df             	mov    %rbx,%rdi
  402412:	e8 49 ee ff ff       	callq  401260 <free>
  402417:	eb 05                	jmp    40241e <closedir+0x26>

}

int closedir(void *dir){
	struct dir *dp = (struct dir *)dir;
	int res = -1;
  402419:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
	{	
		res = close(dp->fd);
		free(dp);
	}
	return res;
}
  40241e:	89 e8                	mov    %ebp,%eax
  402420:	48 83 c4 08          	add    $0x8,%rsp
  402424:	5b                   	pop    %rbx
  402425:	5d                   	pop    %rbp
  402426:	c3                   	retq   

0000000000402427 <waitpid>:

/*working*/
pid_t waitpid(pid_t pid,int *status, int options){
  402427:	53                   	push   %rbx
	*status = -1;
  402428:	c7 06 ff ff ff ff    	movl   $0xffffffff,(%rsi)
    pid_t res = syscall_3(SYS_wait4,(uint64_t)pid,(uint64_t)status,(uint64_t)options);
  40242e:	89 fb                	mov    %edi,%ebx
  402430:	48 63 d2             	movslq %edx,%rdx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  402433:	b8 3d 00 00 00       	mov    $0x3d,%eax
  402438:	48 89 f1             	mov    %rsi,%rcx
  40243b:	48 89 c0             	mov    %rax,%rax
  40243e:	48 89 df             	mov    %rbx,%rdi
  402441:	48 89 ce             	mov    %rcx,%rsi
  402444:	48 89 d2             	mov    %rdx,%rdx
  402447:	cd 80                	int    $0x80
  402449:	48 89 c0             	mov    %rax,%rax
  40244c:	48 89 c2             	mov    %rax,%rdx
	if((int)res < 0)
  40244f:	85 d2                	test   %edx,%edx
  402451:	79 10                	jns    402463 <waitpid+0x3c>
	{
		errno = -res;	
  402453:	f7 da                	neg    %edx
  402455:	48 8b 05 84 18 20 00 	mov    0x201884(%rip),%rax        # 603ce0 <digits.1233+0x201200>
  40245c:	89 10                	mov    %edx,(%rax)
		return -1;
  40245e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  402463:	5b                   	pop    %rbx
  402464:	c3                   	retq   
  402465:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  40246c:	00 00 00 
  40246f:	90                   	nop

0000000000402470 <memcmp>:

//Compare first n characters pointed by s1 to s2.
int memcmp(const void* s1, const void* s2,size_t n)
{
    const unsigned char *p1 = s1, *p2 = s2;
    while(n--)
  402470:	4c 8d 42 ff          	lea    -0x1(%rdx),%r8
  402474:	48 85 d2             	test   %rdx,%rdx
  402477:	74 35                	je     4024ae <memcmp+0x3e>
        if( *p1 != *p2 )
  402479:	0f b6 07             	movzbl (%rdi),%eax
  40247c:	0f b6 0e             	movzbl (%rsi),%ecx
  40247f:	ba 00 00 00 00       	mov    $0x0,%edx
  402484:	38 c8                	cmp    %cl,%al
  402486:	74 1b                	je     4024a3 <memcmp+0x33>
  402488:	eb 10                	jmp    40249a <memcmp+0x2a>
  40248a:	0f b6 44 17 01       	movzbl 0x1(%rdi,%rdx,1),%eax
  40248f:	48 ff c2             	inc    %rdx
  402492:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  402496:	38 c8                	cmp    %cl,%al
  402498:	74 09                	je     4024a3 <memcmp+0x33>
            return *p1 - *p2;
  40249a:	0f b6 c0             	movzbl %al,%eax
  40249d:	0f b6 c9             	movzbl %cl,%ecx
  4024a0:	29 c8                	sub    %ecx,%eax
  4024a2:	c3                   	retq   

//Compare first n characters pointed by s1 to s2.
int memcmp(const void* s1, const void* s2,size_t n)
{
    const unsigned char *p1 = s1, *p2 = s2;
    while(n--)
  4024a3:	4c 39 c2             	cmp    %r8,%rdx
  4024a6:	75 e2                	jne    40248a <memcmp+0x1a>
        if( *p1 != *p2 )
            return *p1 - *p2;
        else
            p1++,p2++;
    return 0;
  4024a8:	b8 00 00 00 00       	mov    $0x0,%eax
  4024ad:	c3                   	retq   
  4024ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  4024b3:	c3                   	retq   

00000000004024b4 <memset>:

void *memset(void *str, int c, size_t n)
{
  4024b4:	48 89 f8             	mov    %rdi,%rax
    char *dst = str;
    while(n-- != 0)
  4024b7:	48 85 d2             	test   %rdx,%rdx
  4024ba:	74 12                	je     4024ce <memset+0x1a>
  4024bc:	48 01 fa             	add    %rdi,%rdx
    return 0;
}

void *memset(void *str, int c, size_t n)
{
    char *dst = str;
  4024bf:	48 89 f9             	mov    %rdi,%rcx
    while(n-- != 0)
    {
        *dst++ = c;
  4024c2:	48 ff c1             	inc    %rcx
  4024c5:	40 88 71 ff          	mov    %sil,-0x1(%rcx)
}

void *memset(void *str, int c, size_t n)
{
    char *dst = str;
    while(n-- != 0)
  4024c9:	48 39 d1             	cmp    %rdx,%rcx
  4024cc:	75 f4                	jne    4024c2 <memset+0xe>
    {
        *dst++ = c;
    }
    return str;
}
  4024ce:	f3 c3                	repz retq 

00000000004024d0 <memcpy>:

void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n)
{
  4024d0:	48 89 f8             	mov    %rdi,%rax
     char *dst = s1;
     const char *src = s2;
     /* Loop and copy.  */
     while (n-- != 0)
  4024d3:	48 85 d2             	test   %rdx,%rdx
  4024d6:	74 16                	je     4024ee <memcpy+0x1e>
  4024d8:	b9 00 00 00 00       	mov    $0x0,%ecx
         *dst++ = *src++;
  4024dd:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  4024e2:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
  4024e6:	48 ff c1             	inc    %rcx
void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n)
{
     char *dst = s1;
     const char *src = s2;
     /* Loop and copy.  */
     while (n-- != 0)
  4024e9:	48 39 d1             	cmp    %rdx,%rcx
  4024ec:	75 ef                	jne    4024dd <memcpy+0xd>
         *dst++ = *src++;
     return s1;
 }
  4024ee:	f3 c3                	repz retq 

00000000004024f0 <strcpy>:

char *strcpy(char *dest, const char *src)
 {
  4024f0:	48 89 f8             	mov    %rdi,%rax
         char *tmp = dest; 
         while ((*dest++ = *src++) != '\0');
  4024f3:	48 89 fa             	mov    %rdi,%rdx
  4024f6:	48 ff c2             	inc    %rdx
  4024f9:	48 ff c6             	inc    %rsi
  4024fc:	0f b6 4e ff          	movzbl -0x1(%rsi),%ecx
  402500:	88 4a ff             	mov    %cl,-0x1(%rdx)
  402503:	84 c9                	test   %cl,%cl
  402505:	75 ef                	jne    4024f6 <strcpy+0x6>
         return tmp;
 }
  402507:	f3 c3                	repz retq 

0000000000402509 <strncpy>:

char *strncpy(char *dest, const char *src, size_t count)
 {
  402509:	48 89 f8             	mov    %rdi,%rax
         char *tmp = dest; 
         while (count) {
  40250c:	48 85 d2             	test   %rdx,%rdx
  40250f:	74 1d                	je     40252e <strncpy+0x25>
  402511:	48 01 fa             	add    %rdi,%rdx
         return tmp;
 }

char *strncpy(char *dest, const char *src, size_t count)
 {
         char *tmp = dest; 
  402514:	48 89 f9             	mov    %rdi,%rcx
         while (count) {
                 if ((*tmp = *src) != 0)
  402517:	44 0f b6 06          	movzbl (%rsi),%r8d
  40251b:	44 88 01             	mov    %r8b,(%rcx)
                         src++;
  40251e:	41 80 f8 01          	cmp    $0x1,%r8b
  402522:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
                 tmp++;
  402526:	48 ff c1             	inc    %rcx
 }

char *strncpy(char *dest, const char *src, size_t count)
 {
         char *tmp = dest; 
         while (count) {
  402529:	48 39 d1             	cmp    %rdx,%rcx
  40252c:	75 e9                	jne    402517 <strncpy+0xe>
                         src++;
                 tmp++;
                 count--;
         }
         return dest;
 }
  40252e:	f3 c3                	repz retq 

0000000000402530 <strlen>:

size_t strlen(const char * str)
{
    const char *s;
    for (s = str; *s; ++s);
  402530:	80 3f 00             	cmpb   $0x0,(%rdi)
  402533:	74 0d                	je     402542 <strlen+0x12>
  402535:	48 89 f8             	mov    %rdi,%rax
  402538:	48 ff c0             	inc    %rax
  40253b:	80 38 00             	cmpb   $0x0,(%rax)
  40253e:	75 f8                	jne    402538 <strlen+0x8>
  402540:	eb 03                	jmp    402545 <strlen+0x15>
  402542:	48 89 f8             	mov    %rdi,%rax
    return(s - str);
  402545:	48 29 f8             	sub    %rdi,%rax
}
  402548:	c3                   	retq   

0000000000402549 <strcmp>:

int strcmp(const char *cs, const char *ct)
 {
         unsigned char c1, c2;
         while (1) {
                 c1 = *cs++;
  402549:	48 ff c7             	inc    %rdi
  40254c:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
                 c2 = *ct++;
  402550:	48 ff c6             	inc    %rsi
  402553:	0f b6 56 ff          	movzbl -0x1(%rsi),%edx
                 if (c1 != c2)
  402557:	38 d0                	cmp    %dl,%al
  402559:	74 08                	je     402563 <strcmp+0x1a>
                         return c1 < c2 ? -1 : 1;
  40255b:	38 d0                	cmp    %dl,%al
  40255d:	19 c0                	sbb    %eax,%eax
  40255f:	83 c8 01             	or     $0x1,%eax
  402562:	c3                   	retq   
                 if (!c1)
  402563:	84 c0                	test   %al,%al
  402565:	75 e2                	jne    402549 <strcmp>
                         break;
         }
         return 0;
  402567:	b8 00 00 00 00       	mov    $0x0,%eax
}
  40256c:	c3                   	retq   

000000000040256d <strstr>:

char *strstr(const char *s1, const char *s2)
{
  40256d:	41 55                	push   %r13
  40256f:	41 54                	push   %r12
  402571:	55                   	push   %rbp
  402572:	53                   	push   %rbx
  402573:	48 83 ec 08          	sub    $0x8,%rsp
  402577:	48 89 fb             	mov    %rdi,%rbx
  40257a:	49 89 f5             	mov    %rsi,%r13
         size_t l1, l2; 
         l2 = strlen(s2);
  40257d:	48 89 f7             	mov    %rsi,%rdi
  402580:	e8 ab ff ff ff       	callq  402530 <strlen>
  402585:	49 89 c4             	mov    %rax,%r12
         if (!l2)
                 return (char *)s1;
  402588:	48 89 d8             	mov    %rbx,%rax

char *strstr(const char *s1, const char *s2)
{
         size_t l1, l2; 
         l2 = strlen(s2);
         if (!l2)
  40258b:	4d 85 e4             	test   %r12,%r12
  40258e:	74 43                	je     4025d3 <strstr+0x66>
                 return (char *)s1;
         l1 = strlen(s1);
  402590:	48 89 df             	mov    %rbx,%rdi
  402593:	e8 98 ff ff ff       	callq  402530 <strlen>
  402598:	48 89 c5             	mov    %rax,%rbp
         while (l1 >= l2) {
  40259b:	49 39 c4             	cmp    %rax,%r12
  40259e:	77 22                	ja     4025c2 <strstr+0x55>
                 l1--;
  4025a0:	48 ff cd             	dec    %rbp
                 if (!memcmp(s1, s2, l2))
  4025a3:	4c 89 e2             	mov    %r12,%rdx
  4025a6:	4c 89 ee             	mov    %r13,%rsi
  4025a9:	48 89 df             	mov    %rbx,%rdi
  4025ac:	e8 bf fe ff ff       	callq  402470 <memcmp>
  4025b1:	85 c0                	test   %eax,%eax
  4025b3:	74 14                	je     4025c9 <strstr+0x5c>
                         return (char *)s1;
                 s1++;
  4025b5:	48 ff c3             	inc    %rbx
         size_t l1, l2; 
         l2 = strlen(s2);
         if (!l2)
                 return (char *)s1;
         l1 = strlen(s1);
         while (l1 >= l2) {
  4025b8:	49 39 ec             	cmp    %rbp,%r12
  4025bb:	76 e3                	jbe    4025a0 <strstr+0x33>
  4025bd:	0f 1f 00             	nopl   (%rax)
  4025c0:	eb 0c                	jmp    4025ce <strstr+0x61>
                 l1--;
                 if (!memcmp(s1, s2, l2))
                         return (char *)s1;
                 s1++;
         }
         return NULL;
  4025c2:	b8 00 00 00 00       	mov    $0x0,%eax
  4025c7:	eb 0a                	jmp    4025d3 <strstr+0x66>
  4025c9:	48 89 d8             	mov    %rbx,%rax
  4025cc:	eb 05                	jmp    4025d3 <strstr+0x66>
  4025ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  4025d3:	48 83 c4 08          	add    $0x8,%rsp
  4025d7:	5b                   	pop    %rbx
  4025d8:	5d                   	pop    %rbp
  4025d9:	41 5c                	pop    %r12
  4025db:	41 5d                	pop    %r13
  4025dd:	c3                   	retq   

00000000004025de <strcat>:

char *strcat(char *dest, const char *src)
{
  4025de:	48 89 f8             	mov    %rdi,%rax
         char *tmp = dest; 
         while (*dest)
  4025e1:	80 3f 00             	cmpb   $0x0,(%rdi)
  4025e4:	74 0d                	je     4025f3 <strcat+0x15>
  4025e6:	48 89 fa             	mov    %rdi,%rdx
                 dest++;
  4025e9:	48 ff c2             	inc    %rdx
}

char *strcat(char *dest, const char *src)
{
         char *tmp = dest; 
         while (*dest)
  4025ec:	80 3a 00             	cmpb   $0x0,(%rdx)
  4025ef:	75 f8                	jne    4025e9 <strcat+0xb>
  4025f1:	eb 03                	jmp    4025f6 <strcat+0x18>
  4025f3:	48 89 fa             	mov    %rdi,%rdx
                 dest++;
         while ((*dest++ = *src++) != '\0')
  4025f6:	48 ff c2             	inc    %rdx
  4025f9:	48 ff c6             	inc    %rsi
  4025fc:	0f b6 4e ff          	movzbl -0x1(%rsi),%ecx
  402600:	88 4a ff             	mov    %cl,-0x1(%rdx)
  402603:	84 c9                	test   %cl,%cl
  402605:	75 ef                	jne    4025f6 <strcat+0x18>
                 ;
         return tmp;
}
  402607:	f3 c3                	repz retq 

0000000000402609 <isspace>:

int isspace(char c)
{
    return (c == ' ' || c == '\t' || c == '\n' || c == '\12');
  402609:	8d 47 f7             	lea    -0x9(%rdi),%eax
  40260c:	3c 01                	cmp    $0x1,%al
  40260e:	0f 96 c2             	setbe  %dl
  402611:	40 80 ff 20          	cmp    $0x20,%dil
  402615:	0f 94 c0             	sete   %al
  402618:	09 d0                	or     %edx,%eax
  40261a:	0f b6 c0             	movzbl %al,%eax
}
  40261d:	c3                   	retq   

000000000040261e <strchr>:

char *strchr(const char *s, int c)
{
    while (*s != (char)c)
  40261e:	eb 07                	jmp    402627 <strchr+0x9>
        if (!*s++)
  402620:	48 ff c7             	inc    %rdi
  402623:	84 c0                	test   %al,%al
  402625:	74 0c                	je     402633 <strchr+0x15>
    return (c == ' ' || c == '\t' || c == '\n' || c == '\12');
}

char *strchr(const char *s, int c)
{
    while (*s != (char)c)
  402627:	0f b6 07             	movzbl (%rdi),%eax
  40262a:	40 38 f0             	cmp    %sil,%al
  40262d:	75 f1                	jne    402620 <strchr+0x2>
  40262f:	48 89 f8             	mov    %rdi,%rax
  402632:	c3                   	retq   
        if (!*s++)
            return 0;
  402633:	b8 00 00 00 00       	mov    $0x0,%eax
    return (char *)s;
}
  402638:	c3                   	retq   

0000000000402639 <isdigit>:

int isdigit(int ch)
{
        return (ch >= '0') && (ch <= '9');
  402639:	83 ef 30             	sub    $0x30,%edi
  40263c:	83 ff 09             	cmp    $0x9,%edi
  40263f:	0f 96 c0             	setbe  %al
  402642:	0f b6 c0             	movzbl %al,%eax
}
  402645:	c3                   	retq   

0000000000402646 <strcspn>:

size_t strcspn(const char *s, const char *reject) {
  402646:	41 54                	push   %r12
  402648:	55                   	push   %rbp
  402649:	53                   	push   %rbx
  40264a:	48 89 fd             	mov    %rdi,%rbp
        size_t count = 0;

        while (*s != '\0') {
  40264d:	0f b6 17             	movzbl (%rdi),%edx
  402650:	84 d2                	test   %dl,%dl
  402652:	74 26                	je     40267a <strcspn+0x34>
  402654:	49 89 f4             	mov    %rsi,%r12
{
        return (ch >= '0') && (ch <= '9');
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;
  402657:	bb 00 00 00 00       	mov    $0x0,%ebx

        while (*s != '\0') {
                if (strchr(reject, *s++) == NULL) {
  40265c:	0f be f2             	movsbl %dl,%esi
  40265f:	4c 89 e7             	mov    %r12,%rdi
  402662:	e8 b7 ff ff ff       	callq  40261e <strchr>
  402667:	48 85 c0             	test   %rax,%rax
  40266a:	75 13                	jne    40267f <strcspn+0x39>
                        ++count;
  40266c:	48 ff c3             	inc    %rbx
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;

        while (*s != '\0') {
  40266f:	0f b6 54 1d 00       	movzbl 0x0(%rbp,%rbx,1),%edx
  402674:	84 d2                	test   %dl,%dl
  402676:	75 e4                	jne    40265c <strcspn+0x16>
  402678:	eb 05                	jmp    40267f <strcspn+0x39>
{
        return (ch >= '0') && (ch <= '9');
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;
  40267a:	bb 00 00 00 00       	mov    $0x0,%ebx
                } else {
                        return count;
                }
        }
        return count;
}
  40267f:	48 89 d8             	mov    %rbx,%rax
  402682:	5b                   	pop    %rbx
  402683:	5d                   	pop    %rbp
  402684:	41 5c                	pop    %r12
  402686:	c3                   	retq   

0000000000402687 <reset>:
void reset(char str[], int len)
{
	for(int i = 0; i < len; i++)
  402687:	85 f6                	test   %esi,%esi
  402689:	7e 10                	jle    40269b <reset+0x14>
  40268b:	b8 00 00 00 00       	mov    $0x0,%eax
		str[i] = '\0';
  402690:	c6 04 07 00          	movb   $0x0,(%rdi,%rax,1)
  402694:	48 ff c0             	inc    %rax
        }
        return count;
}
void reset(char str[], int len)
{
	for(int i = 0; i < len; i++)
  402697:	39 c6                	cmp    %eax,%esi
  402699:	7f f5                	jg     402690 <reset+0x9>
  40269b:	f3 c3                	repz retq 

000000000040269d <atoi>:
}

int atoi(const char *str)
{
    int k = 0;
    for (int i = 0; str[i] != '\0'; ++i)
  40269d:	0f b6 17             	movzbl (%rdi),%edx
  4026a0:	84 d2                	test   %dl,%dl
  4026a2:	74 26                	je     4026ca <atoi+0x2d>
  4026a4:	b9 00 00 00 00       	mov    $0x0,%ecx
		str[i] = '\0';
}

int atoi(const char *str)
{
    int k = 0;
  4026a9:	b8 00 00 00 00       	mov    $0x0,%eax
    for (int i = 0; str[i] != '\0'; ++i)
        k = (k<<3)+(k<<1)+(str[i])-'0';
  4026ae:	8d 34 00             	lea    (%rax,%rax,1),%esi
  4026b1:	8d 04 c6             	lea    (%rsi,%rax,8),%eax
  4026b4:	0f be d2             	movsbl %dl,%edx
  4026b7:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
}

int atoi(const char *str)
{
    int k = 0;
    for (int i = 0; str[i] != '\0'; ++i)
  4026bb:	ff c1                	inc    %ecx
  4026bd:	48 63 d1             	movslq %ecx,%rdx
  4026c0:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  4026c4:	84 d2                	test   %dl,%dl
  4026c6:	75 e6                	jne    4026ae <atoi+0x11>
  4026c8:	f3 c3                	repz retq 
		str[i] = '\0';
}

int atoi(const char *str)
{
    int k = 0;
  4026ca:	b8 00 00 00 00       	mov    $0x0,%eax
    for (int i = 0; str[i] != '\0'; ++i)
        k = (k<<3)+(k<<1)+(str[i])-'0';
    return k;
}
  4026cf:	c3                   	retq   
