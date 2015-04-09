
rootfs/bin/hello:     file format elf64-x86-64


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
  400117:	e8 bc 0a 00 00       	callq  400bd8 <exit>
}
  40011c:	48 83 c4 08          	add    $0x8,%rsp
  400120:	c3                   	retq   

0000000000400121 <main>:
#include <stdio.h>

int main(int argc, char* argv[], char* envp[]) {
  400121:	48 83 ec 08          	sub    $0x8,%rsp
	printf("Hello World!\n");
  400125:	48 8d 3d 24 12 00 00 	lea    0x1224(%rip),%rdi        # 401350 <malloc+0x80>
  40012c:	b8 00 00 00 00       	mov    $0x0,%eax
  400131:	e8 dd 07 00 00       	callq  400913 <printf>
  400136:	eb fe                	jmp    400136 <main+0x15>
  400138:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  40013f:	00 

0000000000400140 <number>:
        return i;
}

static char *number(char *str, long num, int base, int size, int precision,
		    int type)
{
  400140:	41 57                	push   %r15
  400142:	41 56                	push   %r14
  400144:	41 55                	push   %r13
  400146:	41 54                	push   %r12
  400148:	55                   	push   %rbp
  400149:	53                   	push   %rbx
  40014a:	48 83 ec 55          	sub    $0x55,%rsp
  40014e:	41 89 d6             	mov    %edx,%r14d
	char c, sign, locase;
	int i;

	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
	 * produces same digits or (maybe lowercased) letters */
	locase = (type & SMALL);
  400151:	45 89 cd             	mov    %r9d,%r13d
  400154:	41 83 e5 20          	and    $0x20,%r13d
	if (type & LEFT)
  400158:	44 89 ca             	mov    %r9d,%edx
  40015b:	83 e2 10             	and    $0x10,%edx
		type &= ~ZEROPAD;
  40015e:	44 89 c8             	mov    %r9d,%eax
  400161:	83 e0 fe             	and    $0xfffffffe,%eax
  400164:	85 d2                	test   %edx,%edx
  400166:	44 0f 45 c8          	cmovne %eax,%r9d
	if (base < 2 || base > 16)
  40016a:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  40016e:	83 f8 0e             	cmp    $0xe,%eax
  400171:	0f 87 ee 01 00 00    	ja     400365 <number+0x225>
  400177:	45 89 f2             	mov    %r14d,%r10d
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
  40017a:	44 89 c8             	mov    %r9d,%eax
  40017d:	83 e0 01             	and    $0x1,%eax
  400180:	83 f8 01             	cmp    $0x1,%eax
  400183:	45 19 ff             	sbb    %r15d,%r15d
  400186:	41 83 e7 f0          	and    $0xfffffff0,%r15d
  40018a:	41 83 c7 30          	add    $0x30,%r15d
	sign = 0;
  40018e:	c6 04 24 00          	movb   $0x0,(%rsp)
	if (type & SIGN) {
  400192:	41 f6 c1 02          	test   $0x2,%r9b
  400196:	74 2e                	je     4001c6 <number+0x86>
		if (num < 0) {
  400198:	48 85 f6             	test   %rsi,%rsi
  40019b:	79 0b                	jns    4001a8 <number+0x68>
			sign = '-';
			num = -num;
  40019d:	48 f7 de             	neg    %rsi
			size--;
  4001a0:	ff c9                	dec    %ecx
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
	sign = 0;
	if (type & SIGN) {
		if (num < 0) {
			sign = '-';
  4001a2:	c6 04 24 2d          	movb   $0x2d,(%rsp)
  4001a6:	eb 1e                	jmp    4001c6 <number+0x86>
			num = -num;
			size--;
		} else if (type & PLUS) {
  4001a8:	41 f6 c1 04          	test   $0x4,%r9b
  4001ac:	74 08                	je     4001b6 <number+0x76>
			sign = '+';
			size--;
  4001ae:	ff c9                	dec    %ecx
		if (num < 0) {
			sign = '-';
			num = -num;
			size--;
		} else if (type & PLUS) {
			sign = '+';
  4001b0:	c6 04 24 2b          	movb   $0x2b,(%rsp)
  4001b4:	eb 10                	jmp    4001c6 <number+0x86>
	if (type & LEFT)
		type &= ~ZEROPAD;
	if (base < 2 || base > 16)
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
	sign = 0;
  4001b6:	c6 04 24 00          	movb   $0x0,(%rsp)
			num = -num;
			size--;
		} else if (type & PLUS) {
			sign = '+';
			size--;
		} else if (type & SPACE) {
  4001ba:	41 f6 c1 08          	test   $0x8,%r9b
  4001be:	74 06                	je     4001c6 <number+0x86>
			sign = ' ';
			size--;
  4001c0:	ff c9                	dec    %ecx
			size--;
		} else if (type & PLUS) {
			sign = '+';
			size--;
		} else if (type & SPACE) {
			sign = ' ';
  4001c2:	c6 04 24 20          	movb   $0x20,(%rsp)
			size--;
		}
	}
	if (type & SPECIAL) {
  4001c6:	44 89 c8             	mov    %r9d,%eax
  4001c9:	83 e0 40             	and    $0x40,%eax
  4001cc:	89 44 24 01          	mov    %eax,0x1(%rsp)
  4001d0:	74 17                	je     4001e9 <number+0xa9>
		if (base == 16)
  4001d2:	41 83 fe 10          	cmp    $0x10,%r14d
  4001d6:	75 05                	jne    4001dd <number+0x9d>
			size -= 2;
  4001d8:	83 e9 02             	sub    $0x2,%ecx
  4001db:	eb 0c                	jmp    4001e9 <number+0xa9>
		else if (base == 8)
			size--;
  4001dd:	41 83 fe 08          	cmp    $0x8,%r14d
  4001e1:	0f 94 c0             	sete   %al
  4001e4:	0f b6 c0             	movzbl %al,%eax
  4001e7:	29 c1                	sub    %eax,%ecx
	}
	i = 0;
	if (num == 0)
  4001e9:	48 85 f6             	test   %rsi,%rsi
  4001ec:	75 0d                	jne    4001fb <number+0xbb>
		tmp[i++] = '0';
  4001ee:	c6 44 24 13 30       	movb   $0x30,0x13(%rsp)
  4001f3:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  4001f9:	eb 4c                	jmp    400247 <number+0x107>
  4001fb:	4c 8d 5c 24 13       	lea    0x13(%rsp),%r11
			size -= 2;
		else if (base == 8)
			size--;
	}
	i = 0;
	if (num == 0)
  400200:	41 bc 00 00 00 00    	mov    $0x0,%r12d
		tmp[i++] = '0';
	else
		while (num != 0)
			tmp[i++] = (digits[__do_div(num, base)] | locase);
  400206:	45 89 d2             	mov    %r10d,%r10d
  400209:	41 ff c4             	inc    %r12d
  40020c:	48 89 f5             	mov    %rsi,%rbp
  40020f:	48 89 f0             	mov    %rsi,%rax
  400212:	ba 00 00 00 00       	mov    $0x0,%edx
  400217:	49 f7 f2             	div    %r10
  40021a:	48 89 c3             	mov    %rax,%rbx
  40021d:	48 89 c6             	mov    %rax,%rsi
  400220:	48 89 e8             	mov    %rbp,%rax
  400223:	ba 00 00 00 00       	mov    $0x0,%edx
  400228:	49 f7 f2             	div    %r10
  40022b:	48 63 d2             	movslq %edx,%rdx
  40022e:	48 8d 05 6b 13 00 00 	lea    0x136b(%rip),%rax        # 4015a0 <digits.1221>
  400235:	44 89 ed             	mov    %r13d,%ebp
  400238:	40 0a 2c 10          	or     (%rax,%rdx,1),%bpl
  40023c:	41 88 2b             	mov    %bpl,(%r11)
  40023f:	49 ff c3             	inc    %r11
	}
	i = 0;
	if (num == 0)
		tmp[i++] = '0';
	else
		while (num != 0)
  400242:	48 85 db             	test   %rbx,%rbx
  400245:	75 c2                	jne    400209 <number+0xc9>
  400247:	45 39 c4             	cmp    %r8d,%r12d
  40024a:	45 0f 4d c4          	cmovge %r12d,%r8d
			tmp[i++] = (digits[__do_div(num, base)] | locase);
	if (i > precision)
		precision = i;
	size -= precision;
  40024e:	44 29 c1             	sub    %r8d,%ecx
	if (!(type & (ZEROPAD + LEFT)))
  400251:	41 f6 c1 11          	test   $0x11,%r9b
  400255:	75 2d                	jne    400284 <number+0x144>
		while (size-- > 0)
  400257:	8d 71 ff             	lea    -0x1(%rcx),%esi
  40025a:	85 c9                	test   %ecx,%ecx
  40025c:	7e 24                	jle    400282 <number+0x142>
  40025e:	ff c9                	dec    %ecx
  400260:	48 8d 54 0f 01       	lea    0x1(%rdi,%rcx,1),%rdx
  400265:	48 89 f8             	mov    %rdi,%rax
			*str++ = ' ';
  400268:	48 ff c0             	inc    %rax
  40026b:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
			tmp[i++] = (digits[__do_div(num, base)] | locase);
	if (i > precision)
		precision = i;
	size -= precision;
	if (!(type & (ZEROPAD + LEFT)))
		while (size-- > 0)
  40026f:	48 39 d0             	cmp    %rdx,%rax
  400272:	75 f4                	jne    400268 <number+0x128>
  400274:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  400279:	89 f6                	mov    %esi,%esi
  40027b:	48 8d 7c 37 01       	lea    0x1(%rdi,%rsi,1),%rdi
  400280:	eb 02                	jmp    400284 <number+0x144>
  400282:	89 f1                	mov    %esi,%ecx
			*str++ = ' ';
	if (sign)
  400284:	80 3c 24 00          	cmpb   $0x0,(%rsp)
  400288:	74 0a                	je     400294 <number+0x154>
		*str++ = sign;
  40028a:	0f b6 04 24          	movzbl (%rsp),%eax
  40028e:	88 07                	mov    %al,(%rdi)
  400290:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
	if (type & SPECIAL) {
  400294:	83 7c 24 01 00       	cmpl   $0x0,0x1(%rsp)
  400299:	74 24                	je     4002bf <number+0x17f>
		if (base == 8)
  40029b:	41 83 fe 08          	cmp    $0x8,%r14d
  40029f:	75 09                	jne    4002aa <number+0x16a>
			*str++ = '0';
  4002a1:	c6 07 30             	movb   $0x30,(%rdi)
  4002a4:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
  4002a8:	eb 15                	jmp    4002bf <number+0x17f>
		else if (base == 16) {
  4002aa:	41 83 fe 10          	cmp    $0x10,%r14d
  4002ae:	75 0f                	jne    4002bf <number+0x17f>
			*str++ = '0';
  4002b0:	c6 07 30             	movb   $0x30,(%rdi)
			*str++ = ('X' | locase);
  4002b3:	41 83 cd 58          	or     $0x58,%r13d
  4002b7:	44 88 6f 01          	mov    %r13b,0x1(%rdi)
  4002bb:	48 8d 7f 02          	lea    0x2(%rdi),%rdi
		}
	}
	if (!(type & LEFT))
  4002bf:	41 f6 c1 10          	test   $0x10,%r9b
  4002c3:	75 2d                	jne    4002f2 <number+0x1b2>
		while (size-- > 0)
  4002c5:	8d 71 ff             	lea    -0x1(%rcx),%esi
  4002c8:	85 c9                	test   %ecx,%ecx
  4002ca:	7e 24                	jle    4002f0 <number+0x1b0>
  4002cc:	ff c9                	dec    %ecx
  4002ce:	48 8d 54 0f 01       	lea    0x1(%rdi,%rcx,1),%rdx
  4002d3:	48 89 f8             	mov    %rdi,%rax
			*str++ = c;
  4002d6:	48 ff c0             	inc    %rax
  4002d9:	44 88 78 ff          	mov    %r15b,-0x1(%rax)
			*str++ = '0';
			*str++ = ('X' | locase);
		}
	}
	if (!(type & LEFT))
		while (size-- > 0)
  4002dd:	48 39 d0             	cmp    %rdx,%rax
  4002e0:	75 f4                	jne    4002d6 <number+0x196>
  4002e2:	89 f6                	mov    %esi,%esi
  4002e4:	48 8d 7c 37 01       	lea    0x1(%rdi,%rsi,1),%rdi
  4002e9:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  4002ee:	eb 02                	jmp    4002f2 <number+0x1b2>
  4002f0:	89 f1                	mov    %esi,%ecx
			*str++ = c;
	while (i < precision--)
  4002f2:	45 39 c4             	cmp    %r8d,%r12d
  4002f5:	7d 1a                	jge    400311 <number+0x1d1>
  4002f7:	45 29 e0             	sub    %r12d,%r8d
  4002fa:	41 8d 40 ff          	lea    -0x1(%r8),%eax
  4002fe:	4c 8d 44 07 01       	lea    0x1(%rdi,%rax,1),%r8
		*str++ = '0';
  400303:	48 ff c7             	inc    %rdi
  400306:	c6 47 ff 30          	movb   $0x30,-0x1(%rdi)
		}
	}
	if (!(type & LEFT))
		while (size-- > 0)
			*str++ = c;
	while (i < precision--)
  40030a:	4c 39 c7             	cmp    %r8,%rdi
  40030d:	75 f4                	jne    400303 <number+0x1c3>
  40030f:	eb 03                	jmp    400314 <number+0x1d4>
  400311:	49 89 f8             	mov    %rdi,%r8
		*str++ = '0';
	while (i-- > 0)
  400314:	41 8d 7c 24 ff       	lea    -0x1(%r12),%edi
  400319:	45 85 e4             	test   %r12d,%r12d
  40031c:	7e 21                	jle    40033f <number+0x1ff>
  40031e:	4c 89 c2             	mov    %r8,%rdx
  400321:	89 f8                	mov    %edi,%eax
		*str++ = tmp[i];
  400323:	48 63 f0             	movslq %eax,%rsi
  400326:	0f b6 74 34 13       	movzbl 0x13(%rsp,%rsi,1),%esi
  40032b:	40 88 32             	mov    %sil,(%rdx)
	if (!(type & LEFT))
		while (size-- > 0)
			*str++ = c;
	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
  40032e:	ff c8                	dec    %eax
  400330:	48 ff c2             	inc    %rdx
  400333:	83 f8 ff             	cmp    $0xffffffff,%eax
  400336:	75 eb                	jne    400323 <number+0x1e3>
  400338:	89 ff                	mov    %edi,%edi
  40033a:	4d 8d 44 38 01       	lea    0x1(%r8,%rdi,1),%r8
		*str++ = tmp[i];
	while (size-- > 0)
  40033f:	8d 71 ff             	lea    -0x1(%rcx),%esi
  400342:	85 c9                	test   %ecx,%ecx
  400344:	7e 26                	jle    40036c <number+0x22c>
  400346:	ff c9                	dec    %ecx
  400348:	49 8d 54 08 01       	lea    0x1(%r8,%rcx,1),%rdx
  40034d:	4c 89 c0             	mov    %r8,%rax
		*str++ = ' ';
  400350:	48 ff c0             	inc    %rax
  400353:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
			*str++ = c;
	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
		*str++ = tmp[i];
	while (size-- > 0)
  400357:	48 39 d0             	cmp    %rdx,%rax
  40035a:	75 f4                	jne    400350 <number+0x210>
  40035c:	89 f6                	mov    %esi,%esi
		*str++ = ' ';
  40035e:	49 8d 44 30 01       	lea    0x1(%r8,%rsi,1),%rax
  400363:	eb 0a                	jmp    40036f <number+0x22f>
	 * produces same digits or (maybe lowercased) letters */
	locase = (type & SMALL);
	if (type & LEFT)
		type &= ~ZEROPAD;
	if (base < 2 || base > 16)
		return NULL;
  400365:	b8 00 00 00 00       	mov    $0x0,%eax
  40036a:	eb 03                	jmp    40036f <number+0x22f>
			*str++ = c;
	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
		*str++ = tmp[i];
	while (size-- > 0)
  40036c:	4c 89 c0             	mov    %r8,%rax
		*str++ = ' ';
	return str;
}
  40036f:	48 83 c4 55          	add    $0x55,%rsp
  400373:	5b                   	pop    %rbx
  400374:	5d                   	pop    %rbp
  400375:	41 5c                	pop    %r12
  400377:	41 5d                	pop    %r13
  400379:	41 5e                	pop    %r14
  40037b:	41 5f                	pop    %r15
  40037d:	c3                   	retq   

000000000040037e <skip_atoi>:
n = ((unsigned long) n) / (unsigned) base; \
__res; })


static int skip_atoi(const char **s)
{
  40037e:	55                   	push   %rbp
  40037f:	53                   	push   %rbx
  400380:	48 83 ec 08          	sub    $0x8,%rsp
  400384:	48 89 fd             	mov    %rdi,%rbp
        int i = 0;
  400387:	bb 00 00 00 00       	mov    $0x0,%ebx

        while (isdigit(**s))
  40038c:	eb 1d                	jmp    4003ab <skip_atoi+0x2d>
                i = i * 10 + *((*s)++) - '0';
  40038e:	48 8b 45 00          	mov    0x0(%rbp),%rax
  400392:	48 8d 50 01          	lea    0x1(%rax),%rdx
  400396:	48 89 55 00          	mov    %rdx,0x0(%rbp)
  40039a:	8d 14 dd 00 00 00 00 	lea    0x0(,%rbx,8),%edx
  4003a1:	8d 14 5a             	lea    (%rdx,%rbx,2),%edx
  4003a4:	0f be 00             	movsbl (%rax),%eax
  4003a7:	8d 5c 02 d0          	lea    -0x30(%rdx,%rax,1),%ebx

static int skip_atoi(const char **s)
{
        int i = 0;

        while (isdigit(**s))
  4003ab:	48 8b 45 00          	mov    0x0(%rbp),%rax
  4003af:	0f be 38             	movsbl (%rax),%edi
  4003b2:	e8 02 0e 00 00       	callq  4011b9 <isdigit>
  4003b7:	85 c0                	test   %eax,%eax
  4003b9:	75 d3                	jne    40038e <skip_atoi+0x10>
                i = i * 10 + *((*s)++) - '0';
        return i;
}
  4003bb:	89 d8                	mov    %ebx,%eax
  4003bd:	48 83 c4 08          	add    $0x8,%rsp
  4003c1:	5b                   	pop    %rbx
  4003c2:	5d                   	pop    %rbp
  4003c3:	c3                   	retq   

00000000004003c4 <vsprintf>:
	va_end(val);
	return printed;
}

int vsprintf(char *buf, const char *fmt, va_list args)
{
  4003c4:	41 57                	push   %r15
  4003c6:	41 56                	push   %r14
  4003c8:	41 55                	push   %r13
  4003ca:	41 54                	push   %r12
  4003cc:	55                   	push   %rbp
  4003cd:	53                   	push   %rbx
  4003ce:	48 83 ec 28          	sub    $0x28,%rsp
  4003d2:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  4003d7:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
	int field_width;	/* width of output field */
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L:' for integer fields */

	for (str = buf; *fmt; ++fmt) {
  4003dc:	0f b6 06             	movzbl (%rsi),%eax
  4003df:	84 c0                	test   %al,%al
  4003e1:	0f 84 0d 05 00 00    	je     4008f4 <vsprintf+0x530>
  4003e7:	49 89 d5             	mov    %rdx,%r13
  4003ea:	48 89 fb             	mov    %rdi,%rbx

		/* process flags */
		flags = 0;
	      repeat:
		++fmt;		/* this also skips first '%' */
		switch (*fmt) {
  4003ed:	4c 8d 25 6c 0f 00 00 	lea    0xf6c(%rip),%r12        # 401360 <malloc+0x90>
		/* get the precision */
		precision = -1;
		if (*fmt == '.') {
			++fmt;
			if (isdigit(*fmt))
				precision = skip_atoi(&fmt);
  4003f4:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
  4003f9:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L:' for integer fields */

	for (str = buf; *fmt; ++fmt) {
		if (*fmt != '%') {
  4003fe:	bd 00 00 00 00       	mov    $0x0,%ebp
  400403:	3c 25                	cmp    $0x25,%al
  400405:	74 0b                	je     400412 <vsprintf+0x4e>
			*str++ = *fmt;
  400407:	88 03                	mov    %al,(%rbx)
  400409:	48 8d 5b 01          	lea    0x1(%rbx),%rbx
			continue;
  40040d:	e9 c6 04 00 00       	jmpq   4008d8 <vsprintf+0x514>
		}

		/* process flags */
		flags = 0;
	      repeat:
		++fmt;		/* this also skips first '%' */
  400412:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  400417:	48 8d 50 01          	lea    0x1(%rax),%rdx
  40041b:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
		switch (*fmt) {
  400420:	0f b6 78 01          	movzbl 0x1(%rax),%edi
  400424:	8d 47 e0             	lea    -0x20(%rdi),%eax
  400427:	3c 10                	cmp    $0x10,%al
  400429:	77 27                	ja     400452 <vsprintf+0x8e>
  40042b:	0f b6 c0             	movzbl %al,%eax
  40042e:	49 63 04 84          	movslq (%r12,%rax,4),%rax
  400432:	4c 01 e0             	add    %r12,%rax
  400435:	ff e0                	jmpq   *%rax
		case '-':
			flags |= LEFT;
  400437:	83 cd 10             	or     $0x10,%ebp
			goto repeat;
  40043a:	eb d6                	jmp    400412 <vsprintf+0x4e>
		case '+':
			flags |= PLUS;
  40043c:	83 cd 04             	or     $0x4,%ebp
			goto repeat;
  40043f:	eb d1                	jmp    400412 <vsprintf+0x4e>
		case ' ':
			flags |= SPACE;
  400441:	83 cd 08             	or     $0x8,%ebp
			goto repeat;
  400444:	eb cc                	jmp    400412 <vsprintf+0x4e>
		case '#':
			flags |= SPECIAL;
  400446:	83 cd 40             	or     $0x40,%ebp
			goto repeat;
  400449:	eb c7                	jmp    400412 <vsprintf+0x4e>
		case '0':
			flags |= ZEROPAD;
  40044b:	83 cd 01             	or     $0x1,%ebp
  40044e:	66 90                	xchg   %ax,%ax
			goto repeat;
  400450:	eb c0                	jmp    400412 <vsprintf+0x4e>

		/* process flags */
		flags = 0;
	      repeat:
		++fmt;		/* this also skips first '%' */
		switch (*fmt) {
  400452:	41 89 ef             	mov    %ebp,%r15d
			goto repeat;
		}
	
		/* get field width */
		field_width = -1;
		if (isdigit(*fmt))
  400455:	40 0f be ff          	movsbl %dil,%edi
  400459:	e8 5b 0d 00 00       	callq  4011b9 <isdigit>
  40045e:	85 c0                	test   %eax,%eax
  400460:	74 0f                	je     400471 <vsprintf+0xad>
			field_width = skip_atoi(&fmt);
  400462:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  400467:	e8 12 ff ff ff       	callq  40037e <skip_atoi>
  40046c:	41 89 c6             	mov    %eax,%r14d
  40046f:	eb 4e                	jmp    4004bf <vsprintf+0xfb>
		else if (*fmt == '*') {
  400471:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
			flags |= ZEROPAD;
			goto repeat;
		}
	
		/* get field width */
		field_width = -1;
  400476:	41 be ff ff ff ff    	mov    $0xffffffff,%r14d
		if (isdigit(*fmt))
			field_width = skip_atoi(&fmt);
		else if (*fmt == '*') {
  40047c:	80 38 2a             	cmpb   $0x2a,(%rax)
  40047f:	75 3e                	jne    4004bf <vsprintf+0xfb>
			++fmt;
  400481:	48 ff c0             	inc    %rax
  400484:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
			/* it's the next argument */
			field_width = va_arg(args, int);
  400489:	41 8b 45 00          	mov    0x0(%r13),%eax
  40048d:	83 f8 30             	cmp    $0x30,%eax
  400490:	73 0f                	jae    4004a1 <vsprintf+0xdd>
  400492:	89 c2                	mov    %eax,%edx
  400494:	49 03 55 10          	add    0x10(%r13),%rdx
  400498:	83 c0 08             	add    $0x8,%eax
  40049b:	41 89 45 00          	mov    %eax,0x0(%r13)
  40049f:	eb 0c                	jmp    4004ad <vsprintf+0xe9>
  4004a1:	49 8b 55 08          	mov    0x8(%r13),%rdx
  4004a5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  4004a9:	49 89 45 08          	mov    %rax,0x8(%r13)
  4004ad:	44 8b 32             	mov    (%rdx),%r14d
			if (field_width < 0) {
  4004b0:	45 85 f6             	test   %r14d,%r14d
  4004b3:	79 0a                	jns    4004bf <vsprintf+0xfb>
				field_width = -field_width;
  4004b5:	41 f7 de             	neg    %r14d
				flags |= LEFT;
  4004b8:	41 83 cf 10          	or     $0x10,%r15d
  4004bc:	44 89 fd             	mov    %r15d,%ebp
			}
		}

		/* get the precision */
		precision = -1;
		if (*fmt == '.') {
  4004bf:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
				flags |= LEFT;
			}
		}

		/* get the precision */
		precision = -1;
  4004c4:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
		if (*fmt == '.') {
  4004ca:	80 38 2e             	cmpb   $0x2e,(%rax)
  4004cd:	75 6b                	jne    40053a <vsprintf+0x176>
			++fmt;
  4004cf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  4004d3:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
			if (isdigit(*fmt))
  4004d8:	0f be 78 01          	movsbl 0x1(%rax),%edi
  4004dc:	e8 d8 0c 00 00       	callq  4011b9 <isdigit>
  4004e1:	85 c0                	test   %eax,%eax
  4004e3:	74 0c                	je     4004f1 <vsprintf+0x12d>
				precision = skip_atoi(&fmt);
  4004e5:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  4004ea:	e8 8f fe ff ff       	callq  40037e <skip_atoi>
  4004ef:	eb 3d                	jmp    40052e <vsprintf+0x16a>
			else if (*fmt == '*') {
  4004f1:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
				flags |= LEFT;
			}
		}

		/* get the precision */
		precision = -1;
  4004f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		if (*fmt == '.') {
			++fmt;
			if (isdigit(*fmt))
				precision = skip_atoi(&fmt);
			else if (*fmt == '*') {
  4004fb:	80 3a 2a             	cmpb   $0x2a,(%rdx)
  4004fe:	75 2e                	jne    40052e <vsprintf+0x16a>
				++fmt;
  400500:	48 ff c2             	inc    %rdx
  400503:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
				/* it's the next argument */
				precision = va_arg(args, int);
  400508:	41 8b 45 00          	mov    0x0(%r13),%eax
  40050c:	83 f8 30             	cmp    $0x30,%eax
  40050f:	73 0f                	jae    400520 <vsprintf+0x15c>
  400511:	89 c2                	mov    %eax,%edx
  400513:	49 03 55 10          	add    0x10(%r13),%rdx
  400517:	83 c0 08             	add    $0x8,%eax
  40051a:	41 89 45 00          	mov    %eax,0x0(%r13)
  40051e:	eb 0c                	jmp    40052c <vsprintf+0x168>
  400520:	49 8b 55 08          	mov    0x8(%r13),%rdx
  400524:	48 8d 42 08          	lea    0x8(%rdx),%rax
  400528:	49 89 45 08          	mov    %rax,0x8(%r13)
  40052c:	8b 02                	mov    (%rdx),%eax
  40052e:	85 c0                	test   %eax,%eax
  400530:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  400536:	44 0f 49 c0          	cmovns %eax,%r8d
				precision = 0;
		}

		/* get the conversion qualifier */
		qualifier = -1;
		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
  40053a:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  40053f:	0f b6 02             	movzbl (%rdx),%eax
  400542:	3c 68                	cmp    $0x68,%al
  400544:	74 10                	je     400556 <vsprintf+0x192>
  400546:	89 c6                	mov    %eax,%esi
  400548:	83 e6 df             	and    $0xffffffdf,%esi
			if (precision < 0)
				precision = 0;
		}

		/* get the conversion qualifier */
		qualifier = -1;
  40054b:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
  400550:	40 80 fe 4c          	cmp    $0x4c,%sil
  400554:	75 0b                	jne    400561 <vsprintf+0x19d>
			qualifier = *fmt;
  400556:	0f be c8             	movsbl %al,%ecx
			++fmt;
  400559:	48 ff c2             	inc    %rdx
  40055c:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
		}

		/* default base */
		base = 10;

		switch (*fmt) {
  400561:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  400566:	0f b6 00             	movzbl (%rax),%eax
  400569:	83 e8 25             	sub    $0x25,%eax
  40056c:	3c 53                	cmp    $0x53,%al
  40056e:	0f 87 52 02 00 00    	ja     4007c6 <vsprintf+0x402>
  400574:	0f b6 c0             	movzbl %al,%eax
  400577:	48 8d 35 26 0e 00 00 	lea    0xe26(%rip),%rsi        # 4013a4 <malloc+0xd4>
  40057e:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
  400582:	48 01 f0             	add    %rsi,%rax
  400585:	ff e0                	jmpq   *%rax
		case 'c':
			if (!(flags & LEFT))
  400587:	40 f6 c5 10          	test   $0x10,%bpl
  40058b:	75 34                	jne    4005c1 <vsprintf+0x1fd>
				while (--field_width > 0)
  40058d:	41 8d 46 ff          	lea    -0x1(%r14),%eax
  400591:	85 c0                	test   %eax,%eax
  400593:	7e 29                	jle    4005be <vsprintf+0x1fa>
  400595:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  400599:	48 8d 54 03 01       	lea    0x1(%rbx,%rax,1),%rdx
  40059e:	48 89 d8             	mov    %rbx,%rax
					*str++ = ' ';
  4005a1:	48 ff c0             	inc    %rax
  4005a4:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
		base = 10;

		switch (*fmt) {
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
  4005a8:	48 39 d0             	cmp    %rdx,%rax
  4005ab:	75 f4                	jne    4005a1 <vsprintf+0x1dd>
  4005ad:	41 83 ee 02          	sub    $0x2,%r14d
  4005b1:	4a 8d 5c 33 01       	lea    0x1(%rbx,%r14,1),%rbx
  4005b6:	41 be 00 00 00 00    	mov    $0x0,%r14d
  4005bc:	eb 03                	jmp    4005c1 <vsprintf+0x1fd>
  4005be:	41 89 c6             	mov    %eax,%r14d
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
  4005c1:	48 8d 4b 01          	lea    0x1(%rbx),%rcx
  4005c5:	41 8b 45 00          	mov    0x0(%r13),%eax
  4005c9:	83 f8 30             	cmp    $0x30,%eax
  4005cc:	73 0f                	jae    4005dd <vsprintf+0x219>
  4005ce:	89 c2                	mov    %eax,%edx
  4005d0:	49 03 55 10          	add    0x10(%r13),%rdx
  4005d4:	83 c0 08             	add    $0x8,%eax
  4005d7:	41 89 45 00          	mov    %eax,0x0(%r13)
  4005db:	eb 0c                	jmp    4005e9 <vsprintf+0x225>
  4005dd:	49 8b 55 08          	mov    0x8(%r13),%rdx
  4005e1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  4005e5:	49 89 45 08          	mov    %rax,0x8(%r13)
  4005e9:	8b 02                	mov    (%rdx),%eax
  4005eb:	88 03                	mov    %al,(%rbx)
			while (--field_width > 0)
  4005ed:	41 8d 46 ff          	lea    -0x1(%r14),%eax
  4005f1:	85 c0                	test   %eax,%eax
  4005f3:	0f 8e dc 02 00 00    	jle    4008d5 <vsprintf+0x511>
  4005f9:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  4005fd:	48 8d 54 03 02       	lea    0x2(%rbx,%rax,1),%rdx
		switch (*fmt) {
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
  400602:	48 89 c8             	mov    %rcx,%rax
			while (--field_width > 0)
				*str++ = ' ';
  400605:	48 ff c0             	inc    %rax
  400608:	c6 40 ff 20          	movb   $0x20,-0x1(%rax)
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
			while (--field_width > 0)
  40060c:	48 39 d0             	cmp    %rdx,%rax
  40060f:	75 f4                	jne    400605 <vsprintf+0x241>
  400611:	41 83 ee 02          	sub    $0x2,%r14d
  400615:	4a 8d 5c 31 01       	lea    0x1(%rcx,%r14,1),%rbx
  40061a:	e9 b9 02 00 00       	jmpq   4008d8 <vsprintf+0x514>
				*str++ = ' ';
			continue;

		case 's':
			s = va_arg(args, char *);
  40061f:	41 8b 45 00          	mov    0x0(%r13),%eax
  400623:	83 f8 30             	cmp    $0x30,%eax
  400626:	73 0f                	jae    400637 <vsprintf+0x273>
  400628:	89 c2                	mov    %eax,%edx
  40062a:	49 03 55 10          	add    0x10(%r13),%rdx
  40062e:	83 c0 08             	add    $0x8,%eax
  400631:	41 89 45 00          	mov    %eax,0x0(%r13)
  400635:	eb 0c                	jmp    400643 <vsprintf+0x27f>
  400637:	49 8b 55 08          	mov    0x8(%r13),%rdx
  40063b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  40063f:	49 89 45 08          	mov    %rax,0x8(%r13)
  400643:	4c 8b 3a             	mov    (%rdx),%r15
			//len = strnlen(s, precision);
			len = strlen(s);
  400646:	4c 89 ff             	mov    %r15,%rdi
  400649:	e8 62 0a 00 00       	callq  4010b0 <strlen>
  40064e:	89 c6                	mov    %eax,%esi
			if (!(flags & LEFT))
  400650:	40 f6 c5 10          	test   $0x10,%bpl
  400654:	75 31                	jne    400687 <vsprintf+0x2c3>
				while (len < field_width--)
  400656:	41 8d 4e ff          	lea    -0x1(%r14),%ecx
  40065a:	41 39 c6             	cmp    %eax,%r14d
  40065d:	7e 25                	jle    400684 <vsprintf+0x2c0>
  40065f:	44 89 f7             	mov    %r14d,%edi
  400662:	41 89 ce             	mov    %ecx,%r14d
  400665:	41 29 c6             	sub    %eax,%r14d
  400668:	4a 8d 54 33 01       	lea    0x1(%rbx,%r14,1),%rdx
					*str++ = ' ';
  40066d:	48 ff c3             	inc    %rbx
  400670:	c6 43 ff 20          	movb   $0x20,-0x1(%rbx)
		case 's':
			s = va_arg(args, char *);
			//len = strnlen(s, precision);
			len = strlen(s);
			if (!(flags & LEFT))
				while (len < field_width--)
  400674:	48 39 d3             	cmp    %rdx,%rbx
  400677:	75 f4                	jne    40066d <vsprintf+0x2a9>
  400679:	29 f9                	sub    %edi,%ecx
  40067b:	44 8d 34 01          	lea    (%rcx,%rax,1),%r14d
					*str++ = ' ';
  40067f:	48 89 d3             	mov    %rdx,%rbx
  400682:	eb 03                	jmp    400687 <vsprintf+0x2c3>
		case 's':
			s = va_arg(args, char *);
			//len = strnlen(s, precision);
			len = strlen(s);
			if (!(flags & LEFT))
				while (len < field_width--)
  400684:	41 89 ce             	mov    %ecx,%r14d
					*str++ = ' ';
			for (i = 0; i < len; ++i)
  400687:	85 c0                	test   %eax,%eax
  400689:	7e 1c                	jle    4006a7 <vsprintf+0x2e3>
  40068b:	ba 00 00 00 00       	mov    $0x0,%edx
				*str++ = *s++;
  400690:	41 0f b6 0c 17       	movzbl (%r15,%rdx,1),%ecx
  400695:	88 0c 13             	mov    %cl,(%rbx,%rdx,1)
  400698:	48 ff c2             	inc    %rdx
			//len = strnlen(s, precision);
			len = strlen(s);
			if (!(flags & LEFT))
				while (len < field_width--)
					*str++ = ' ';
			for (i = 0; i < len; ++i)
  40069b:	39 d6                	cmp    %edx,%esi
  40069d:	7f f1                	jg     400690 <vsprintf+0x2cc>
  40069f:	8d 50 ff             	lea    -0x1(%rax),%edx
  4006a2:	48 8d 5c 13 01       	lea    0x1(%rbx,%rdx,1),%rbx
				*str++ = *s++;
			while (len < field_width--)
  4006a7:	41 39 c6             	cmp    %eax,%r14d
  4006aa:	0f 8e 28 02 00 00    	jle    4008d8 <vsprintf+0x514>
  4006b0:	44 89 f6             	mov    %r14d,%esi
  4006b3:	89 c2                	mov    %eax,%edx
  4006b5:	f7 d2                	not    %edx
  4006b7:	41 01 d6             	add    %edx,%r14d
  4006ba:	4a 8d 4c 33 01       	lea    0x1(%rbx,%r14,1),%rcx
  4006bf:	48 89 da             	mov    %rbx,%rdx
				*str++ = ' ';
  4006c2:	48 ff c2             	inc    %rdx
  4006c5:	c6 42 ff 20          	movb   $0x20,-0x1(%rdx)
			if (!(flags & LEFT))
				while (len < field_width--)
					*str++ = ' ';
			for (i = 0; i < len; ++i)
				*str++ = *s++;
			while (len < field_width--)
  4006c9:	48 39 ca             	cmp    %rcx,%rdx
  4006cc:	75 f4                	jne    4006c2 <vsprintf+0x2fe>
  4006ce:	f7 d0                	not    %eax
  4006d0:	01 f0                	add    %esi,%eax
  4006d2:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
  4006d7:	e9 fc 01 00 00       	jmpq   4008d8 <vsprintf+0x514>
				*str++ = ' ';
			continue;

		case 'p':
			if (field_width == -1) {
  4006dc:	41 83 fe ff          	cmp    $0xffffffff,%r14d
  4006e0:	75 09                	jne    4006eb <vsprintf+0x327>
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
  4006e2:	83 cd 01             	or     $0x1,%ebp
				*str++ = ' ';
			continue;

		case 'p':
			if (field_width == -1) {
				field_width = 2 * sizeof(void *);
  4006e5:	41 be 10 00 00 00    	mov    $0x10,%r14d
				flags |= ZEROPAD;
			}
			str = number(str,
				     (unsigned long)va_arg(args, void *), 16,
  4006eb:	41 8b 45 00          	mov    0x0(%r13),%eax
  4006ef:	83 f8 30             	cmp    $0x30,%eax
  4006f2:	73 0f                	jae    400703 <vsprintf+0x33f>
  4006f4:	89 c6                	mov    %eax,%esi
  4006f6:	49 03 75 10          	add    0x10(%r13),%rsi
  4006fa:	83 c0 08             	add    $0x8,%eax
  4006fd:	41 89 45 00          	mov    %eax,0x0(%r13)
		case 'p':
			if (field_width == -1) {
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
			}
			str = number(str,
  400701:	eb 0c                	jmp    40070f <vsprintf+0x34b>
				     (unsigned long)va_arg(args, void *), 16,
  400703:	49 8b 75 08          	mov    0x8(%r13),%rsi
  400707:	48 8d 46 08          	lea    0x8(%rsi),%rax
  40070b:	49 89 45 08          	mov    %rax,0x8(%r13)
		case 'p':
			if (field_width == -1) {
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
			}
			str = number(str,
  40070f:	41 89 e9             	mov    %ebp,%r9d
  400712:	44 89 f1             	mov    %r14d,%ecx
  400715:	ba 10 00 00 00       	mov    $0x10,%edx
  40071a:	48 8b 36             	mov    (%rsi),%rsi
  40071d:	48 89 df             	mov    %rbx,%rdi
  400720:	e8 1b fa ff ff       	callq  400140 <number>
  400725:	48 89 c3             	mov    %rax,%rbx
				     (unsigned long)va_arg(args, void *), 16,
				     field_width, precision, flags);
			continue;
  400728:	e9 ab 01 00 00       	jmpq   4008d8 <vsprintf+0x514>

		case 'n':
			if (qualifier == 'l') {
  40072d:	83 f9 6c             	cmp    $0x6c,%ecx
  400730:	75 37                	jne    400769 <vsprintf+0x3a5>
				long *ip = va_arg(args, long *);
  400732:	41 8b 45 00          	mov    0x0(%r13),%eax
  400736:	83 f8 30             	cmp    $0x30,%eax
  400739:	73 0f                	jae    40074a <vsprintf+0x386>
  40073b:	89 c2                	mov    %eax,%edx
  40073d:	49 03 55 10          	add    0x10(%r13),%rdx
  400741:	83 c0 08             	add    $0x8,%eax
  400744:	41 89 45 00          	mov    %eax,0x0(%r13)
  400748:	eb 0c                	jmp    400756 <vsprintf+0x392>
  40074a:	49 8b 55 08          	mov    0x8(%r13),%rdx
  40074e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  400752:	49 89 45 08          	mov    %rax,0x8(%r13)
  400756:	48 8b 02             	mov    (%rdx),%rax
				*ip = (str - buf);
  400759:	48 89 da             	mov    %rbx,%rdx
  40075c:	48 2b 54 24 08       	sub    0x8(%rsp),%rdx
  400761:	48 89 10             	mov    %rdx,(%rax)
  400764:	e9 6f 01 00 00       	jmpq   4008d8 <vsprintf+0x514>
			} else {
				int *ip = va_arg(args, int *);
  400769:	41 8b 45 00          	mov    0x0(%r13),%eax
  40076d:	83 f8 30             	cmp    $0x30,%eax
  400770:	73 0f                	jae    400781 <vsprintf+0x3bd>
  400772:	89 c2                	mov    %eax,%edx
  400774:	49 03 55 10          	add    0x10(%r13),%rdx
  400778:	83 c0 08             	add    $0x8,%eax
  40077b:	41 89 45 00          	mov    %eax,0x0(%r13)
  40077f:	eb 0c                	jmp    40078d <vsprintf+0x3c9>
  400781:	49 8b 55 08          	mov    0x8(%r13),%rdx
  400785:	48 8d 42 08          	lea    0x8(%rdx),%rax
  400789:	49 89 45 08          	mov    %rax,0x8(%r13)
  40078d:	48 8b 02             	mov    (%rdx),%rax
				*ip = (str - buf);
  400790:	48 89 da             	mov    %rbx,%rdx
  400793:	48 2b 54 24 08       	sub    0x8(%rsp),%rdx
  400798:	89 10                	mov    %edx,(%rax)
  40079a:	e9 39 01 00 00       	jmpq   4008d8 <vsprintf+0x514>
			}
			continue;

		case '%':
			*str++ = '%';
  40079f:	c6 03 25             	movb   $0x25,(%rbx)
  4007a2:	48 8d 5b 01          	lea    0x1(%rbx),%rbx
			continue;
  4007a6:	e9 2d 01 00 00       	jmpq   4008d8 <vsprintf+0x514>

			/* integer number formats - set up the flags and "break" */
		case 'o':
			base = 8;
  4007ab:	ba 08 00 00 00       	mov    $0x8,%edx
			break;
  4007b0:	eb 4b                	jmp    4007fd <vsprintf+0x439>

		case 'x':
			flags |= SMALL;
  4007b2:	83 cd 20             	or     $0x20,%ebp
		case 'X':
			base = 16;
  4007b5:	ba 10 00 00 00       	mov    $0x10,%edx
  4007ba:	eb 41                	jmp    4007fd <vsprintf+0x439>
			break;

		case 'd':
		case 'i':
			flags |= SIGN;
  4007bc:	83 cd 02             	or     $0x2,%ebp
			qualifier = *fmt;
			++fmt;
		}

		/* default base */
		base = 10;
  4007bf:	ba 0a 00 00 00       	mov    $0xa,%edx
  4007c4:	eb 37                	jmp    4007fd <vsprintf+0x439>
			flags |= SIGN;
		case 'u':
			break;

		default:
			*str++ = '%';
  4007c6:	c6 03 25             	movb   $0x25,(%rbx)
			if (*fmt)
  4007c9:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  4007ce:	0f b6 10             	movzbl (%rax),%edx
  4007d1:	84 d2                	test   %dl,%dl
  4007d3:	74 0c                	je     4007e1 <vsprintf+0x41d>
				*str++ = *fmt;
  4007d5:	88 53 01             	mov    %dl,0x1(%rbx)
  4007d8:	48 8d 5b 02          	lea    0x2(%rbx),%rbx
  4007dc:	e9 f7 00 00 00       	jmpq   4008d8 <vsprintf+0x514>
			flags |= SIGN;
		case 'u':
			break;

		default:
			*str++ = '%';
  4007e1:	48 ff c3             	inc    %rbx
			if (*fmt)
				*str++ = *fmt;
			else
				--fmt;
  4007e4:	48 ff c8             	dec    %rax
  4007e7:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  4007ec:	e9 e7 00 00 00       	jmpq   4008d8 <vsprintf+0x514>
			qualifier = *fmt;
			++fmt;
		}

		/* default base */
		base = 10;
  4007f1:	ba 0a 00 00 00       	mov    $0xa,%edx
  4007f6:	eb 05                	jmp    4007fd <vsprintf+0x439>
			break;

		case 'x':
			flags |= SMALL;
		case 'X':
			base = 16;
  4007f8:	ba 10 00 00 00       	mov    $0x10,%edx
				*str++ = *fmt;
			else
				--fmt;
			continue;
		}
		if (qualifier == 'l')
  4007fd:	83 f9 6c             	cmp    $0x6c,%ecx
  400800:	75 2c                	jne    40082e <vsprintf+0x46a>
			num = va_arg(args, unsigned long);
  400802:	41 8b 45 00          	mov    0x0(%r13),%eax
  400806:	83 f8 30             	cmp    $0x30,%eax
  400809:	73 0f                	jae    40081a <vsprintf+0x456>
  40080b:	89 c1                	mov    %eax,%ecx
  40080d:	49 03 4d 10          	add    0x10(%r13),%rcx
  400811:	83 c0 08             	add    $0x8,%eax
  400814:	41 89 45 00          	mov    %eax,0x0(%r13)
  400818:	eb 0c                	jmp    400826 <vsprintf+0x462>
  40081a:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  40081e:	48 8d 41 08          	lea    0x8(%rcx),%rax
  400822:	49 89 45 08          	mov    %rax,0x8(%r13)
  400826:	48 8b 31             	mov    (%rcx),%rsi
  400829:	e9 94 00 00 00       	jmpq   4008c2 <vsprintf+0x4fe>
		else if (qualifier == 'h') {
  40082e:	83 f9 68             	cmp    $0x68,%ecx
  400831:	75 3a                	jne    40086d <vsprintf+0x4a9>
			num = (unsigned short)va_arg(args, int);
  400833:	41 8b 45 00          	mov    0x0(%r13),%eax
  400837:	83 f8 30             	cmp    $0x30,%eax
  40083a:	73 0f                	jae    40084b <vsprintf+0x487>
  40083c:	89 c1                	mov    %eax,%ecx
  40083e:	49 03 4d 10          	add    0x10(%r13),%rcx
  400842:	83 c0 08             	add    $0x8,%eax
  400845:	41 89 45 00          	mov    %eax,0x0(%r13)
  400849:	eb 0c                	jmp    400857 <vsprintf+0x493>
  40084b:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  40084f:	48 8d 41 08          	lea    0x8(%rcx),%rax
  400853:	49 89 45 08          	mov    %rax,0x8(%r13)
  400857:	8b 01                	mov    (%rcx),%eax
  400859:	0f b7 c8             	movzwl %ax,%ecx
  40085c:	48 0f bf c0          	movswq %ax,%rax
  400860:	40 f6 c5 02          	test   $0x2,%bpl
  400864:	48 0f 45 c8          	cmovne %rax,%rcx
  400868:	48 89 ce             	mov    %rcx,%rsi
  40086b:	eb 55                	jmp    4008c2 <vsprintf+0x4fe>
			if (flags & SIGN)
				num = (short)num;
		} else if (flags & SIGN)
  40086d:	40 f6 c5 02          	test   $0x2,%bpl
  400871:	74 29                	je     40089c <vsprintf+0x4d8>
			num = va_arg(args, int);
  400873:	41 8b 45 00          	mov    0x0(%r13),%eax
  400877:	83 f8 30             	cmp    $0x30,%eax
  40087a:	73 0f                	jae    40088b <vsprintf+0x4c7>
  40087c:	89 c1                	mov    %eax,%ecx
  40087e:	49 03 4d 10          	add    0x10(%r13),%rcx
  400882:	83 c0 08             	add    $0x8,%eax
  400885:	41 89 45 00          	mov    %eax,0x0(%r13)
  400889:	eb 0c                	jmp    400897 <vsprintf+0x4d3>
  40088b:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  40088f:	48 8d 41 08          	lea    0x8(%rcx),%rax
  400893:	49 89 45 08          	mov    %rax,0x8(%r13)
  400897:	48 63 31             	movslq (%rcx),%rsi
  40089a:	eb 26                	jmp    4008c2 <vsprintf+0x4fe>
		else
			num = va_arg(args, unsigned int);
  40089c:	41 8b 45 00          	mov    0x0(%r13),%eax
  4008a0:	83 f8 30             	cmp    $0x30,%eax
  4008a3:	73 0f                	jae    4008b4 <vsprintf+0x4f0>
  4008a5:	89 c1                	mov    %eax,%ecx
  4008a7:	49 03 4d 10          	add    0x10(%r13),%rcx
  4008ab:	83 c0 08             	add    $0x8,%eax
  4008ae:	41 89 45 00          	mov    %eax,0x0(%r13)
  4008b2:	eb 0c                	jmp    4008c0 <vsprintf+0x4fc>
  4008b4:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  4008b8:	48 8d 41 08          	lea    0x8(%rcx),%rax
  4008bc:	49 89 45 08          	mov    %rax,0x8(%r13)
  4008c0:	8b 31                	mov    (%rcx),%esi
		str = number(str, num, base, field_width, precision, flags);
  4008c2:	41 89 e9             	mov    %ebp,%r9d
  4008c5:	44 89 f1             	mov    %r14d,%ecx
  4008c8:	48 89 df             	mov    %rbx,%rdi
  4008cb:	e8 70 f8 ff ff       	callq  400140 <number>
  4008d0:	48 89 c3             	mov    %rax,%rbx
  4008d3:	eb 03                	jmp    4008d8 <vsprintf+0x514>
		switch (*fmt) {
		case 'c':
			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (unsigned char)va_arg(args, int);
  4008d5:	48 89 cb             	mov    %rcx,%rbx
	int field_width;	/* width of output field */
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L:' for integer fields */

	for (str = buf; *fmt; ++fmt) {
  4008d8:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  4008dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  4008e1:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  4008e6:	0f b6 40 01          	movzbl 0x1(%rax),%eax
  4008ea:	84 c0                	test   %al,%al
  4008ec:	0f 85 0c fb ff ff    	jne    4003fe <vsprintf+0x3a>
  4008f2:	eb 05                	jmp    4008f9 <vsprintf+0x535>
  4008f4:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
			num = va_arg(args, int);
		else
			num = va_arg(args, unsigned int);
		str = number(str, num, base, field_width, precision, flags);
	}
	*str = '\0';
  4008f9:	c6 03 00             	movb   $0x0,(%rbx)
	return str - buf;
  4008fc:	48 89 d8             	mov    %rbx,%rax
  4008ff:	48 2b 44 24 08       	sub    0x8(%rsp),%rax
}
  400904:	48 83 c4 28          	add    $0x28,%rsp
  400908:	5b                   	pop    %rbx
  400909:	5d                   	pop    %rbp
  40090a:	41 5c                	pop    %r12
  40090c:	41 5d                	pop    %r13
  40090e:	41 5e                	pop    %r14
  400910:	41 5f                	pop    %r15
  400912:	c3                   	retq   

0000000000400913 <printf>:
	return str;
}

//static char printf_buf[1024];

int printf(const char *format, ...) {
  400913:	55                   	push   %rbp
  400914:	53                   	push   %rbx
  400915:	48 81 ec 58 04 00 00 	sub    $0x458,%rsp
  40091c:	48 89 b4 24 28 04 00 	mov    %rsi,0x428(%rsp)
  400923:	00 
  400924:	48 89 94 24 30 04 00 	mov    %rdx,0x430(%rsp)
  40092b:	00 
  40092c:	48 89 8c 24 38 04 00 	mov    %rcx,0x438(%rsp)
  400933:	00 
  400934:	4c 89 84 24 40 04 00 	mov    %r8,0x440(%rsp)
  40093b:	00 
  40093c:	4c 89 8c 24 48 04 00 	mov    %r9,0x448(%rsp)
  400943:	00 
  400944:	48 89 fe             	mov    %rdi,%rsi
	va_list val;
	int printed = 0;
	char printf_buf[1024];
	//reset(printf_buf,1024);
	va_start(val, format);
  400947:	c7 84 24 08 04 00 00 	movl   $0x8,0x408(%rsp)
  40094e:	08 00 00 00 
  400952:	48 8d 84 24 70 04 00 	lea    0x470(%rsp),%rax
  400959:	00 
  40095a:	48 89 84 24 10 04 00 	mov    %rax,0x410(%rsp)
  400961:	00 
  400962:	48 8d 84 24 20 04 00 	lea    0x420(%rsp),%rax
  400969:	00 
  40096a:	48 89 84 24 18 04 00 	mov    %rax,0x418(%rsp)
  400971:	00 
	printed = vsprintf(printf_buf, format, val);
  400972:	48 8d 94 24 08 04 00 	lea    0x408(%rsp),%rdx
  400979:	00 
  40097a:	48 8d 6c 24 08       	lea    0x8(%rsp),%rbp
  40097f:	48 89 ef             	mov    %rbp,%rdi
  400982:	e8 3d fa ff ff       	callq  4003c4 <vsprintf>
  400987:	89 c3                	mov    %eax,%ebx
	write(1, printf_buf, printed);
  400989:	48 63 d0             	movslq %eax,%rdx
  40098c:	48 89 ee             	mov    %rbp,%rsi
  40098f:	bf 01 00 00 00       	mov    $0x1,%edi
  400994:	e8 22 04 00 00       	callq  400dbb <write>
	//write(1, format, printed);
	
	va_end(val);
	return printed;
}
  400999:	89 d8                	mov    %ebx,%eax
  40099b:	48 81 c4 58 04 00 00 	add    $0x458,%rsp
  4009a2:	5b                   	pop    %rbx
  4009a3:	5d                   	pop    %rbp
  4009a4:	c3                   	retq   

00000000004009a5 <serror>:
	}
	*str = '\0';
	return str - buf;
}

void serror(int error){
  4009a5:	48 83 ec 08          	sub    $0x8,%rsp
    switch(error){
  4009a9:	83 ff 28             	cmp    $0x28,%edi
  4009ac:	0f 87 10 02 00 00    	ja     400bc2 <serror+0x21d>
  4009b2:	89 ff                	mov    %edi,%edi
  4009b4:	48 8d 05 39 0b 00 00 	lea    0xb39(%rip),%rax        # 4014f4 <malloc+0x224>
  4009bb:	48 63 14 b8          	movslq (%rax,%rdi,4),%rdx
  4009bf:	48 01 d0             	add    %rdx,%rax
  4009c2:	ff e0                	jmpq   *%rax
		case EPERM:	 
				printf("operation is not permitted \n");
  4009c4:	48 8d 3d e5 0b 00 00 	lea    0xbe5(%rip),%rdi        # 4015b0 <digits.1221+0x10>
  4009cb:	b8 00 00 00 00       	mov    $0x0,%eax
  4009d0:	e8 3e ff ff ff       	callq  400913 <printf>
				break;
  4009d5:	e9 f9 01 00 00       	jmpq   400bd3 <serror+0x22e>
        case ENOENT : 
				printf("No Such File or directory\n"); 
  4009da:	48 8d 3d ec 0b 00 00 	lea    0xbec(%rip),%rdi        # 4015cd <digits.1221+0x2d>
  4009e1:	b8 00 00 00 00       	mov    $0x0,%eax
  4009e6:	e8 28 ff ff ff       	callq  400913 <printf>
				break;
  4009eb:	e9 e3 01 00 00       	jmpq   400bd3 <serror+0x22e>
		case EINTR	:
				printf("Interrupted system call \n");
  4009f0:	48 8d 3d f1 0b 00 00 	lea    0xbf1(%rip),%rdi        # 4015e8 <digits.1221+0x48>
  4009f7:	b8 00 00 00 00       	mov    $0x0,%eax
  4009fc:	e8 12 ff ff ff       	callq  400913 <printf>
				break;
  400a01:	e9 cd 01 00 00       	jmpq   400bd3 <serror+0x22e>
		case EIO : 
				printf("Input outpur error \n"); 
  400a06:	48 8d 3d f5 0b 00 00 	lea    0xbf5(%rip),%rdi        # 401602 <digits.1221+0x62>
  400a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  400a12:	e8 fc fe ff ff       	callq  400913 <printf>
				break;
  400a17:	e9 b7 01 00 00       	jmpq   400bd3 <serror+0x22e>
		case E2BIG : 
				printf("Argument list too long \n"); 
  400a1c:	48 8d 3d f4 0b 00 00 	lea    0xbf4(%rip),%rdi        # 401617 <digits.1221+0x77>
  400a23:	b8 00 00 00 00       	mov    $0x0,%eax
  400a28:	e8 e6 fe ff ff       	callq  400913 <printf>
				break;	
  400a2d:	e9 a1 01 00 00       	jmpq   400bd3 <serror+0x22e>
		case ENOEXEC : 
				printf("Exec format error \n"); 
  400a32:	48 8d 3d f7 0b 00 00 	lea    0xbf7(%rip),%rdi        # 401630 <digits.1221+0x90>
  400a39:	b8 00 00 00 00       	mov    $0x0,%eax
  400a3e:	e8 d0 fe ff ff       	callq  400913 <printf>
				break;	
  400a43:	e9 8b 01 00 00       	jmpq   400bd3 <serror+0x22e>
		case EBADF 	 : 
				printf("Bad File number \n"); 
  400a48:	48 8d 3d f5 0b 00 00 	lea    0xbf5(%rip),%rdi        # 401644 <digits.1221+0xa4>
  400a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  400a54:	e8 ba fe ff ff       	callq  400913 <printf>
				break;
  400a59:	e9 75 01 00 00       	jmpq   400bd3 <serror+0x22e>
		case ECHILD : 
				printf("No child process \n"); 
  400a5e:	48 8d 3d f1 0b 00 00 	lea    0xbf1(%rip),%rdi        # 401656 <digits.1221+0xb6>
  400a65:	b8 00 00 00 00       	mov    $0x0,%eax
  400a6a:	e8 a4 fe ff ff       	callq  400913 <printf>
				break;
  400a6f:	e9 5f 01 00 00       	jmpq   400bd3 <serror+0x22e>
		case EAGAIN:
				printf("error: try again \n");
  400a74:	48 8d 3d ee 0b 00 00 	lea    0xbee(%rip),%rdi        # 401669 <digits.1221+0xc9>
  400a7b:	b8 00 00 00 00       	mov    $0x0,%eax
  400a80:	e8 8e fe ff ff       	callq  400913 <printf>
				break;
  400a85:	e9 49 01 00 00       	jmpq   400bd3 <serror+0x22e>
        case ENOMEM : 
				printf("Out of memory\n");
  400a8a:	48 8d 3d eb 0b 00 00 	lea    0xbeb(%rip),%rdi        # 40167c <digits.1221+0xdc>
  400a91:	b8 00 00 00 00       	mov    $0x0,%eax
  400a96:	e8 78 fe ff ff       	callq  400913 <printf>
				break;
  400a9b:	e9 33 01 00 00       	jmpq   400bd3 <serror+0x22e>
        case EACCES : 
				printf("Permission denied\n"); 
  400aa0:	48 8d 3d e4 0b 00 00 	lea    0xbe4(%rip),%rdi        # 40168b <digits.1221+0xeb>
  400aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  400aac:	e8 62 fe ff ff       	callq  400913 <printf>
				break;
  400ab1:	e9 1d 01 00 00       	jmpq   400bd3 <serror+0x22e>
		case EFAULT : 
				printf("Bad address \n"); 
  400ab6:	48 8d 3d e1 0b 00 00 	lea    0xbe1(%rip),%rdi        # 40169e <digits.1221+0xfe>
  400abd:	b8 00 00 00 00       	mov    $0x0,%eax
  400ac2:	e8 4c fe ff ff       	callq  400913 <printf>
				break;	
  400ac7:	e9 07 01 00 00       	jmpq   400bd3 <serror+0x22e>
		case EBUSY	:
				printf("Device or resource busy \n");
  400acc:	48 8d 3d d9 0b 00 00 	lea    0xbd9(%rip),%rdi        # 4016ac <digits.1221+0x10c>
  400ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  400ad8:	e8 36 fe ff ff       	callq  400913 <printf>
				break;
  400add:	e9 f1 00 00 00       	jmpq   400bd3 <serror+0x22e>
		case EEXIST : 
				printf("File exists \n"); 
  400ae2:	48 8d 3d dd 0b 00 00 	lea    0xbdd(%rip),%rdi        # 4016c6 <digits.1221+0x126>
  400ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  400aee:	e8 20 fe ff ff       	callq  400913 <printf>
				break;	
  400af3:	e9 db 00 00 00       	jmpq   400bd3 <serror+0x22e>
		case ENOTDIR : 
				printf("Not a directory \n"); 
  400af8:	48 8d 3d d5 0b 00 00 	lea    0xbd5(%rip),%rdi        # 4016d4 <digits.1221+0x134>
  400aff:	b8 00 00 00 00       	mov    $0x0,%eax
  400b04:	e8 0a fe ff ff       	callq  400913 <printf>
				break;	
  400b09:	e9 c5 00 00 00       	jmpq   400bd3 <serror+0x22e>
		case EISDIR : 
				printf("is a directory \n"); 
  400b0e:	48 8d 3d d1 0b 00 00 	lea    0xbd1(%rip),%rdi        # 4016e6 <digits.1221+0x146>
  400b15:	b8 00 00 00 00       	mov    $0x0,%eax
  400b1a:	e8 f4 fd ff ff       	callq  400913 <printf>
				break;	
  400b1f:	e9 af 00 00 00       	jmpq   400bd3 <serror+0x22e>
		case EINVAL : 
				printf("Invalid Argument \n"); 
  400b24:	48 8d 3d cc 0b 00 00 	lea    0xbcc(%rip),%rdi        # 4016f7 <digits.1221+0x157>
  400b2b:	b8 00 00 00 00       	mov    $0x0,%eax
  400b30:	e8 de fd ff ff       	callq  400913 <printf>
				break;
  400b35:	e9 99 00 00 00       	jmpq   400bd3 <serror+0x22e>
		case ENFILE	:
				printf("File table overflow \n");
  400b3a:	48 8d 3d c9 0b 00 00 	lea    0xbc9(%rip),%rdi        # 40170a <digits.1221+0x16a>
  400b41:	b8 00 00 00 00       	mov    $0x0,%eax
  400b46:	e8 c8 fd ff ff       	callq  400913 <printf>
				break;
  400b4b:	e9 83 00 00 00       	jmpq   400bd3 <serror+0x22e>
		case EMFILE :
				printf("Too many open files \n");
  400b50:	48 8d 3d c9 0b 00 00 	lea    0xbc9(%rip),%rdi        # 401720 <digits.1221+0x180>
  400b57:	b8 00 00 00 00       	mov    $0x0,%eax
  400b5c:	e8 b2 fd ff ff       	callq  400913 <printf>
				break;
  400b61:	eb 70                	jmp    400bd3 <serror+0x22e>
		case EFBIG : 
				printf("File too large \n"); 
  400b63:	48 8d 3d cc 0b 00 00 	lea    0xbcc(%rip),%rdi        # 401736 <digits.1221+0x196>
  400b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  400b6f:	e8 9f fd ff ff       	callq  400913 <printf>
				break;
  400b74:	eb 5d                	jmp    400bd3 <serror+0x22e>
        case EROFS : 
				printf("Read-only file system\n"); 
  400b76:	48 8d 3d ca 0b 00 00 	lea    0xbca(%rip),%rdi        # 401747 <digits.1221+0x1a7>
  400b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  400b82:	e8 8c fd ff ff       	callq  400913 <printf>
				break;
  400b87:	eb 4a                	jmp    400bd3 <serror+0x22e>
		case ELOOP:
				printf("Too many symbolic links encountered \n");
  400b89:	48 8d 3d f8 0b 00 00 	lea    0xbf8(%rip),%rdi        # 401788 <digits.1221+0x1e8>
  400b90:	b8 00 00 00 00       	mov    $0x0,%eax
  400b95:	e8 79 fd ff ff       	callq  400913 <printf>
				break;
  400b9a:	eb 37                	jmp    400bd3 <serror+0x22e>
		case EPIPE: 
				printf("Broken pipe \n"); 
  400b9c:	48 8d 3d bb 0b 00 00 	lea    0xbbb(%rip),%rdi        # 40175e <digits.1221+0x1be>
  400ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  400ba8:	e8 66 fd ff ff       	callq  400913 <printf>
				break;
  400bad:	eb 24                	jmp    400bd3 <serror+0x22e>
		case ENAMETOOLONG : 
				printf("File name too long \n"); 
  400baf:	48 8d 3d b6 0b 00 00 	lea    0xbb6(%rip),%rdi        # 40176c <digits.1221+0x1cc>
  400bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  400bbb:	e8 53 fd ff ff       	callq  400913 <printf>
				break;	
  400bc0:	eb 11                	jmp    400bd3 <serror+0x22e>
        default : 
			printf("Error in Opening or Executing\n");
  400bc2:	48 8d 3d e7 0b 00 00 	lea    0xbe7(%rip),%rdi        # 4017b0 <digits.1221+0x210>
  400bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  400bce:	e8 40 fd ff ff       	callq  400913 <printf>
		
    }
  400bd3:	48 83 c4 08          	add    $0x8,%rsp
  400bd7:	c3                   	retq   

0000000000400bd8 <exit>:
#include <error.h>

static void *breakPtr;
__thread int errno;
/*working*/
void exit(int status){
  400bd8:	53                   	push   %rbx
    syscall_1(SYS_exit, status);
  400bd9:	48 63 df             	movslq %edi,%rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  400bdc:	b8 3c 00 00 00       	mov    $0x3c,%eax
  400be1:	48 89 c0             	mov    %rax,%rax
  400be4:	48 89 df             	mov    %rbx,%rdi
  400be7:	0f 05                	syscall 
  400be9:	48 89 c0             	mov    %rax,%rax
}
  400bec:	5b                   	pop    %rbx
  400bed:	c3                   	retq   

0000000000400bee <brk>:
/*working*/
int brk(void *end_data_segment){
  400bee:	53                   	push   %rbx
  400bef:	b8 0c 00 00 00       	mov    $0xc,%eax
  400bf4:	48 89 fb             	mov    %rdi,%rbx
  400bf7:	48 89 c0             	mov    %rax,%rax
  400bfa:	48 89 df             	mov    %rbx,%rdi
  400bfd:	0f 05                	syscall 
  400bff:	48 89 c0             	mov    %rax,%rax
    return syscall_1(SYS_brk, (uint64_t)end_data_segment);
}
  400c02:	5b                   	pop    %rbx
  400c03:	c3                   	retq   

0000000000400c04 <sbrk>:

/*working*/
void *sbrk(size_t increment){
  400c04:	55                   	push   %rbp
  400c05:	53                   	push   %rbx
  400c06:	48 83 ec 08          	sub    $0x8,%rsp
  400c0a:	48 89 fb             	mov    %rdi,%rbx
	if(breakPtr == NULL)
  400c0d:	48 83 3d 4b 14 20 00 	cmpq   $0x0,0x20144b(%rip)        # 602060 <breakPtr>
  400c14:	00 
  400c15:	75 13                	jne    400c2a <sbrk+0x26>
		breakPtr = (void *)((uint64_t)brk(0));
  400c17:	bf 00 00 00 00       	mov    $0x0,%edi
  400c1c:	e8 cd ff ff ff       	callq  400bee <brk>
  400c21:	48 98                	cltq   
  400c23:	48 89 05 36 14 20 00 	mov    %rax,0x201436(%rip)        # 602060 <breakPtr>
	if(increment == 0)
  400c2a:	48 85 db             	test   %rbx,%rbx
  400c2d:	75 09                	jne    400c38 <sbrk+0x34>
	{
		return breakPtr;
  400c2f:	48 8b 05 2a 14 20 00 	mov    0x20142a(%rip),%rax        # 602060 <breakPtr>
  400c36:	eb 1b                	jmp    400c53 <sbrk+0x4f>
	}
	void *startAddr = breakPtr;
  400c38:	48 8b 2d 21 14 20 00 	mov    0x201421(%rip),%rbp        # 602060 <breakPtr>
	breakPtr = breakPtr+increment;
  400c3f:	48 8d 7c 1d 00       	lea    0x0(%rbp,%rbx,1),%rdi
  400c44:	48 89 3d 15 14 20 00 	mov    %rdi,0x201415(%rip)        # 602060 <breakPtr>
	brk(breakPtr);
  400c4b:	e8 9e ff ff ff       	callq  400bee <brk>
    return startAddr;
  400c50:	48 89 e8             	mov    %rbp,%rax
}
  400c53:	48 83 c4 08          	add    $0x8,%rsp
  400c57:	5b                   	pop    %rbx
  400c58:	5d                   	pop    %rbp
  400c59:	c3                   	retq   

0000000000400c5a <fork>:

//#define T_SYSCALL               0x80       /* System call */

static __inline uint64_t syscall_0(uint64_t n) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  400c5a:	ba 39 00 00 00       	mov    $0x39,%edx
  400c5f:	48 89 d0             	mov    %rdx,%rax
  400c62:	0f 05                	syscall 
  400c64:	48 89 c2             	mov    %rax,%rdx
	if((int)res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
  400c67:	89 d0                	mov    %edx,%eax
}

/*working*/
pid_t fork(){
    uint32_t res = syscall_0(SYS_fork);
	if((int)res < 0)
  400c69:	85 d2                	test   %edx,%edx
  400c6b:	79 10                	jns    400c7d <fork+0x23>
	{
		errno = -res;
  400c6d:	f7 da                	neg    %edx
  400c6f:	48 8b 05 c2 13 20 00 	mov    0x2013c2(%rip),%rax        # 602038 <digits.1221+0x200a98>
  400c76:	89 10                	mov    %edx,(%rax)
		return -1;
  400c78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400c7d:	f3 c3                	repz retq 

0000000000400c7f <getpid>:
  400c7f:	b8 27 00 00 00       	mov    $0x27,%eax
  400c84:	48 89 c0             	mov    %rax,%rax
  400c87:	0f 05                	syscall 
  400c89:	48 89 c0             	mov    %rax,%rax

/*this method doesnt throw error always successful*/
pid_t getpid(){
    uint32_t res = syscall_0(SYS_getpid);
    return res;
}
  400c8c:	c3                   	retq   

0000000000400c8d <getppid>:
  400c8d:	b8 6e 00 00 00       	mov    $0x6e,%eax
  400c92:	48 89 c0             	mov    %rax,%rax
  400c95:	0f 05                	syscall 
  400c97:	48 89 c0             	mov    %rax,%rax
/*working*/
pid_t getppid(){
    uint32_t res = syscall_0(SYS_getppid);
    return res;
}
  400c9a:	c3                   	retq   

0000000000400c9b <execve>:
/*wrokig*/
int execve(const char *filename, char *const argv[], char *const envp[]){
  400c9b:	53                   	push   %rbx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  400c9c:	b8 3b 00 00 00       	mov    $0x3b,%eax
  400ca1:	48 89 fb             	mov    %rdi,%rbx
  400ca4:	48 89 f1             	mov    %rsi,%rcx
  400ca7:	48 89 c0             	mov    %rax,%rax
  400caa:	48 89 df             	mov    %rbx,%rdi
  400cad:	48 89 ce             	mov    %rcx,%rsi
  400cb0:	48 89 d2             	mov    %rdx,%rdx
  400cb3:	0f 05                	syscall 
  400cb5:	48 89 c0             	mov    %rax,%rax
  400cb8:	48 89 c2             	mov    %rax,%rdx
    uint64_t res = syscall_3(SYS_execve, (uint64_t)filename, (uint64_t)argv, (uint64_t)envp);
	if((int)res < 0)
  400cbb:	85 d2                	test   %edx,%edx
  400cbd:	79 10                	jns    400ccf <execve+0x34>
	{
		errno = -res;
  400cbf:	f7 da                	neg    %edx
  400cc1:	48 8b 05 70 13 20 00 	mov    0x201370(%rip),%rax        # 602038 <digits.1221+0x200a98>
  400cc8:	89 10                	mov    %edx,(%rax)
		return -1;
  400cca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400ccf:	5b                   	pop    %rbx
  400cd0:	c3                   	retq   

0000000000400cd1 <sleep>:

unsigned int sleep(unsigned int seconds){
  400cd1:	53                   	push   %rbx
    unsigned int res = syscall_1(SYS_nanosleep, seconds);
  400cd2:	89 fb                	mov    %edi,%ebx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  400cd4:	b8 23 00 00 00       	mov    $0x23,%eax
  400cd9:	48 89 c0             	mov    %rax,%rax
  400cdc:	48 89 df             	mov    %rbx,%rdi
  400cdf:	0f 05                	syscall 
  400ce1:	48 89 c0             	mov    %rax,%rax
    return res;
}
  400ce4:	5b                   	pop    %rbx
  400ce5:	c3                   	retq   

0000000000400ce6 <alarm>:

unsigned int alarm(unsigned int seconds){
  400ce6:	53                   	push   %rbx
    unsigned int res = syscall_1(SYS_alarm, seconds);
  400ce7:	89 fb                	mov    %edi,%ebx
  400ce9:	b8 25 00 00 00       	mov    $0x25,%eax
  400cee:	48 89 c0             	mov    %rax,%rax
  400cf1:	48 89 df             	mov    %rbx,%rdi
  400cf4:	0f 05                	syscall 
  400cf6:	48 89 c0             	mov    %rax,%rax
    return res;
}
  400cf9:	5b                   	pop    %rbx
  400cfa:	c3                   	retq   

0000000000400cfb <getcwd>:
/*working*/
char *getcwd(char *buf, size_t size){
  400cfb:	53                   	push   %rbx
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  400cfc:	b8 4f 00 00 00       	mov    $0x4f,%eax
  400d01:	48 89 fb             	mov    %rdi,%rbx
  400d04:	48 89 f1             	mov    %rsi,%rcx
  400d07:	48 89 c0             	mov    %rax,%rax
  400d0a:	48 89 df             	mov    %rbx,%rdi
  400d0d:	48 89 ce             	mov    %rcx,%rsi
  400d10:	0f 05                	syscall 
  400d12:	48 89 c0             	mov    %rax,%rax
    uint64_t res = syscall_2(SYS_getcwd, (uint64_t) buf, (uint64_t) size);
	if((char *)res == NULL)
  400d15:	48 85 c0             	test   %rax,%rax
  400d18:	75 0d                	jne    400d27 <getcwd+0x2c>
	{
		errno = EFAULT;
  400d1a:	48 8b 15 17 13 20 00 	mov    0x201317(%rip),%rdx        # 602038 <digits.1221+0x200a98>
  400d21:	c7 02 0e 00 00 00    	movl   $0xe,(%rdx)
	}
    return (char *)res;
}
  400d27:	5b                   	pop    %rbx
  400d28:	c3                   	retq   

0000000000400d29 <chdir>:
/*working*/ 
int chdir(const char *path){
  400d29:	53                   	push   %rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  400d2a:	b8 50 00 00 00       	mov    $0x50,%eax
  400d2f:	48 89 fb             	mov    %rdi,%rbx
  400d32:	48 89 c0             	mov    %rax,%rax
  400d35:	48 89 df             	mov    %rbx,%rdi
  400d38:	0f 05                	syscall 
  400d3a:	48 89 c0             	mov    %rax,%rax
    int res = syscall_1(SYS_chdir, (uint64_t)path);
	if(res < 0)
  400d3d:	85 c0                	test   %eax,%eax
  400d3f:	79 10                	jns    400d51 <chdir+0x28>
	{
		errno = -res;
  400d41:	f7 d8                	neg    %eax
  400d43:	48 8b 15 ee 12 20 00 	mov    0x2012ee(%rip),%rdx        # 602038 <digits.1221+0x200a98>
  400d4a:	89 02                	mov    %eax,(%rdx)
		return -1;
  400d4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400d51:	5b                   	pop    %rbx
  400d52:	c3                   	retq   

0000000000400d53 <open>:
/*working*/    
int open(const char *pathname, int flags){
  400d53:	53                   	push   %rbx
    uint64_t res = syscall_2(SYS_open, (uint64_t) pathname, (uint64_t) flags);
  400d54:	48 63 ce             	movslq %esi,%rcx
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  400d57:	b8 02 00 00 00       	mov    $0x2,%eax
  400d5c:	48 89 fb             	mov    %rdi,%rbx
  400d5f:	48 89 c0             	mov    %rax,%rax
  400d62:	48 89 df             	mov    %rbx,%rdi
  400d65:	48 89 ce             	mov    %rcx,%rsi
  400d68:	0f 05                	syscall 
  400d6a:	48 89 c0             	mov    %rax,%rax
  400d6d:	48 89 c1             	mov    %rax,%rcx
	if((int)res < 0)
  400d70:	85 c9                	test   %ecx,%ecx
  400d72:	79 10                	jns    400d84 <open+0x31>
	{
		errno = -res;
  400d74:	f7 d9                	neg    %ecx
  400d76:	48 8b 05 bb 12 20 00 	mov    0x2012bb(%rip),%rax        # 602038 <digits.1221+0x200a98>
  400d7d:	89 08                	mov    %ecx,(%rax)
		return -1;
  400d7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400d84:	5b                   	pop    %rbx
  400d85:	c3                   	retq   

0000000000400d86 <read>:

/*working*/
ssize_t read(int fd, void *buf, size_t count){
  400d86:	53                   	push   %rbx
    ssize_t res = syscall_3(SYS_read, (uint64_t) fd, (uint64_t) buf, (uint64_t) count);
  400d87:	48 63 df             	movslq %edi,%rbx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  400d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  400d8f:	48 89 f1             	mov    %rsi,%rcx
  400d92:	48 89 c0             	mov    %rax,%rax
  400d95:	48 89 df             	mov    %rbx,%rdi
  400d98:	48 89 ce             	mov    %rcx,%rsi
  400d9b:	48 89 d2             	mov    %rdx,%rdx
  400d9e:	0f 05                	syscall 
  400da0:	48 89 c0             	mov    %rax,%rax
	if((int)res < 0)
  400da3:	85 c0                	test   %eax,%eax
  400da5:	79 12                	jns    400db9 <read+0x33>
	{
		errno = -res;
  400da7:	f7 d8                	neg    %eax
  400da9:	48 8b 15 88 12 20 00 	mov    0x201288(%rip),%rdx        # 602038 <digits.1221+0x200a98>
  400db0:	89 02                	mov    %eax,(%rdx)
		return -1;
  400db2:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
	}
    return res;
}
  400db9:	5b                   	pop    %rbx
  400dba:	c3                   	retq   

0000000000400dbb <write>:

/*working*/
ssize_t write(int fd, const void *buf, size_t count){
  400dbb:	53                   	push   %rbx
    ssize_t res = syscall_3(SYS_write, (uint64_t) fd, (uint64_t) buf, (uint64_t) count);
  400dbc:	48 63 df             	movslq %edi,%rbx
  400dbf:	b8 01 00 00 00       	mov    $0x1,%eax
  400dc4:	48 89 f1             	mov    %rsi,%rcx
  400dc7:	48 89 c0             	mov    %rax,%rax
  400dca:	48 89 df             	mov    %rbx,%rdi
  400dcd:	48 89 ce             	mov    %rcx,%rsi
  400dd0:	48 89 d2             	mov    %rdx,%rdx
  400dd3:	0f 05                	syscall 
  400dd5:	48 89 c0             	mov    %rax,%rax
	if((int)res < 0)
  400dd8:	85 c0                	test   %eax,%eax
  400dda:	79 12                	jns    400dee <write+0x33>
	{
		errno = -res;
  400ddc:	f7 d8                	neg    %eax
  400dde:	48 8b 15 53 12 20 00 	mov    0x201253(%rip),%rdx        # 602038 <digits.1221+0x200a98>
  400de5:	89 02                	mov    %eax,(%rdx)
		return -1;
  400de7:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
	}
    return res; 
}
  400dee:	5b                   	pop    %rbx
  400def:	c3                   	retq   

0000000000400df0 <lseek>:

off_t lseek(int fildes, off_t offset, int whence){
  400df0:	53                   	push   %rbx
    off_t res = syscall_3(SYS_lseek, (uint64_t) fildes, (uint64_t) offset, (uint64_t) whence);
  400df1:	48 63 df             	movslq %edi,%rbx
  400df4:	48 63 d2             	movslq %edx,%rdx
  400df7:	b8 08 00 00 00       	mov    $0x8,%eax
  400dfc:	48 89 f1             	mov    %rsi,%rcx
  400dff:	48 89 c0             	mov    %rax,%rax
  400e02:	48 89 df             	mov    %rbx,%rdi
  400e05:	48 89 ce             	mov    %rcx,%rsi
  400e08:	48 89 d2             	mov    %rdx,%rdx
  400e0b:	0f 05                	syscall 
  400e0d:	48 89 c0             	mov    %rax,%rax
  400e10:	48 89 c2             	mov    %rax,%rdx
	if((int)res < 0)
  400e13:	85 d2                	test   %edx,%edx
  400e15:	79 12                	jns    400e29 <lseek+0x39>
	{
		errno = -res;
  400e17:	f7 da                	neg    %edx
  400e19:	48 8b 05 18 12 20 00 	mov    0x201218(%rip),%rax        # 602038 <digits.1221+0x200a98>
  400e20:	89 10                	mov    %edx,(%rax)
		return -1;
  400e22:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
	}
    return res;
}
  400e29:	5b                   	pop    %rbx
  400e2a:	c3                   	retq   

0000000000400e2b <close>:
/*working*/
int close(int fd){
  400e2b:	53                   	push   %rbx
    int res = syscall_1(SYS_close, fd);
  400e2c:	48 63 df             	movslq %edi,%rbx
        return ret;
}

static __inline uint64_t syscall_1(uint64_t n, uint64_t a1) {
	uint64_t ret;
	__asm __volatile("movq %1, %%rax;"
  400e2f:	b8 03 00 00 00       	mov    $0x3,%eax
  400e34:	48 89 c0             	mov    %rax,%rax
  400e37:	48 89 df             	mov    %rbx,%rdi
  400e3a:	0f 05                	syscall 
  400e3c:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  400e3f:	85 c0                	test   %eax,%eax
  400e41:	79 10                	jns    400e53 <close+0x28>
	{
		errno = -res;
  400e43:	f7 d8                	neg    %eax
  400e45:	48 8b 15 ec 11 20 00 	mov    0x2011ec(%rip),%rdx        # 602038 <digits.1221+0x200a98>
  400e4c:	89 02                	mov    %eax,(%rdx)
		return -1;
  400e4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400e53:	5b                   	pop    %rbx
  400e54:	c3                   	retq   

0000000000400e55 <pipe>:
/*working*/
int pipe(int filedes[2]){
  400e55:	53                   	push   %rbx
  400e56:	b8 16 00 00 00       	mov    $0x16,%eax
  400e5b:	48 89 fb             	mov    %rdi,%rbx
  400e5e:	48 89 c0             	mov    %rax,%rax
  400e61:	48 89 df             	mov    %rbx,%rdi
  400e64:	0f 05                	syscall 
  400e66:	48 89 c0             	mov    %rax,%rax
    int res = syscall_1(SYS_pipe, (uint64_t)filedes);
	if(res < 0)
  400e69:	85 c0                	test   %eax,%eax
  400e6b:	79 10                	jns    400e7d <pipe+0x28>
	{
		errno = -res;
  400e6d:	f7 d8                	neg    %eax
  400e6f:	48 8b 15 c2 11 20 00 	mov    0x2011c2(%rip),%rdx        # 602038 <digits.1221+0x200a98>
  400e76:	89 02                	mov    %eax,(%rdx)
		return -1;
  400e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400e7d:	5b                   	pop    %rbx
  400e7e:	c3                   	retq   

0000000000400e7f <dup>:

int dup(int oldfd){
  400e7f:	53                   	push   %rbx
    int res = syscall_1(SYS_dup,oldfd);
  400e80:	48 63 df             	movslq %edi,%rbx
  400e83:	b8 20 00 00 00       	mov    $0x20,%eax
  400e88:	48 89 c0             	mov    %rax,%rax
  400e8b:	48 89 df             	mov    %rbx,%rdi
  400e8e:	0f 05                	syscall 
  400e90:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  400e93:	85 c0                	test   %eax,%eax
  400e95:	79 10                	jns    400ea7 <dup+0x28>
	{
		errno = -res;
  400e97:	f7 d8                	neg    %eax
  400e99:	48 8b 15 98 11 20 00 	mov    0x201198(%rip),%rdx        # 602038 <digits.1221+0x200a98>
  400ea0:	89 02                	mov    %eax,(%rdx)
		return -1;
  400ea2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400ea7:	5b                   	pop    %rbx
  400ea8:	c3                   	retq   

0000000000400ea9 <dup2>:

int dup2(int oldfd, int newfd){
  400ea9:	53                   	push   %rbx
    int res = syscall_2(SYS_dup2, (uint64_t) oldfd, (uint64_t) newfd);
  400eaa:	48 63 df             	movslq %edi,%rbx
  400ead:	48 63 ce             	movslq %esi,%rcx
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
	uint64_t ret;
        __asm __volatile("movq %1, %%rax;"
  400eb0:	b8 21 00 00 00       	mov    $0x21,%eax
  400eb5:	48 89 c0             	mov    %rax,%rax
  400eb8:	48 89 df             	mov    %rbx,%rdi
  400ebb:	48 89 ce             	mov    %rcx,%rsi
  400ebe:	0f 05                	syscall 
  400ec0:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  400ec3:	85 c0                	test   %eax,%eax
  400ec5:	79 10                	jns    400ed7 <dup2+0x2e>
	{
		errno = -res;
  400ec7:	f7 d8                	neg    %eax
  400ec9:	48 8b 15 68 11 20 00 	mov    0x201168(%rip),%rdx        # 602038 <digits.1221+0x200a98>
  400ed0:	89 02                	mov    %eax,(%rdx)
		return -1;
  400ed2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400ed7:	5b                   	pop    %rbx
  400ed8:	c3                   	retq   

0000000000400ed9 <opendir>:

void *opendir(const char *name){
  400ed9:	41 54                	push   %r12
  400edb:	55                   	push   %rbp
  400edc:	53                   	push   %rbx
  400edd:	48 81 ec 00 04 00 00 	sub    $0x400,%rsp
  400ee4:	49 89 fc             	mov    %rdi,%r12
	int fd = open(name, O_DIRECTORY);
  400ee7:	be 00 00 01 00       	mov    $0x10000,%esi
  400eec:	e8 62 fe ff ff       	callq  400d53 <open>
  400ef1:	89 c5                	mov    %eax,%ebp
	char buf[1024];
	//struct dirent *d = NULL;
	if(fd < 0)
  400ef3:	85 c0                	test   %eax,%eax
  400ef5:	78 5b                	js     400f52 <opendir+0x79>
		return NULL;
	//static struct dirent dp;
	//printf("sashi 1 \n");
	int res = syscall_3(SYS_getdents, (uint64_t)fd, (uint64_t)buf, (uint64_t)sizeof(struct dirent));
  400ef7:	48 63 d8             	movslq %eax,%rbx
  400efa:	48 89 e1             	mov    %rsp,%rcx
        return ret; 
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
	 uint64_t ret; 
        __asm __volatile("movq %1, %%rax;"
  400efd:	ba 18 04 00 00       	mov    $0x418,%edx
  400f02:	b8 4e 00 00 00       	mov    $0x4e,%eax
  400f07:	48 89 c0             	mov    %rax,%rax
  400f0a:	48 89 df             	mov    %rbx,%rdi
  400f0d:	48 89 ce             	mov    %rcx,%rsi
  400f10:	48 89 d2             	mov    %rdx,%rdx
  400f13:	0f 05                	syscall 
  400f15:	48 89 c0             	mov    %rax,%rax
	if(res < 0)
  400f18:	85 c0                	test   %eax,%eax
  400f1a:	79 12                	jns    400f2e <opendir+0x55>
	{
		errno = -res;	
  400f1c:	f7 d8                	neg    %eax
  400f1e:	48 8b 15 13 11 20 00 	mov    0x201113(%rip),%rdx        # 602038 <digits.1221+0x200a98>
  400f25:	89 02                	mov    %eax,(%rdx)
		return NULL;
  400f27:	b8 00 00 00 00       	mov    $0x0,%eax
  400f2c:	eb 29                	jmp    400f57 <opendir+0x7e>
	}
	//printf("sashi 2 \n");
	struct dir *d = malloc(sizeof(struct dir));
  400f2e:	bf 18 04 00 00       	mov    $0x418,%edi
  400f33:	e8 98 03 00 00       	callq  4012d0 <malloc>
  400f38:	48 89 c3             	mov    %rax,%rbx
	d->fd = fd;
  400f3b:	89 28                	mov    %ebp,(%rax)
	d->addr = (void *)buf;
  400f3d:	48 89 63 08          	mov    %rsp,0x8(%rbx)
	//printf("sashi 1 \n");
	strcpy(d->d_name, name);
  400f41:	48 8d 7b 10          	lea    0x10(%rbx),%rdi
  400f45:	4c 89 e6             	mov    %r12,%rsi
  400f48:	e8 23 01 00 00       	callq  401070 <strcpy>
	//printf("sashi 2 \n");
	//d = (struct dirent *)buf;
    return (void *)d;
  400f4d:	48 89 d8             	mov    %rbx,%rax
  400f50:	eb 05                	jmp    400f57 <opendir+0x7e>
void *opendir(const char *name){
	int fd = open(name, O_DIRECTORY);
	char buf[1024];
	//struct dirent *d = NULL;
	if(fd < 0)
		return NULL;
  400f52:	b8 00 00 00 00       	mov    $0x0,%eax
	//printf("sashi 1 \n");
	strcpy(d->d_name, name);
	//printf("sashi 2 \n");
	//d = (struct dirent *)buf;
    return (void *)d;
}
  400f57:	48 81 c4 00 04 00 00 	add    $0x400,%rsp
  400f5e:	5b                   	pop    %rbx
  400f5f:	5d                   	pop    %rbp
  400f60:	41 5c                	pop    %r12
  400f62:	c3                   	retq   

0000000000400f63 <readdir>:
*/
struct dirent *readdir(void *dir)
{
	struct dirent *dip = (struct dirent *)dir;
	struct dirent *next;
	next = (struct dirent *)(dir + dip->d_reclen);
  400f63:	0f b7 47 10          	movzwl 0x10(%rdi),%eax
	if(next->d_reclen == 0)
  400f67:	48 8d 04 38          	lea    (%rax,%rdi,1),%rax
		return NULL;
  400f6b:	66 83 78 10 00       	cmpw   $0x0,0x10(%rax)
  400f70:	ba 00 00 00 00       	mov    $0x0,%edx
  400f75:	48 0f 44 c2          	cmove  %rdx,%rax
	return next;
}
  400f79:	c3                   	retq   

0000000000400f7a <closedir>:

int closedir(void *dir){
  400f7a:	55                   	push   %rbp
  400f7b:	53                   	push   %rbx
  400f7c:	48 83 ec 08          	sub    $0x8,%rsp
  400f80:	48 89 fb             	mov    %rdi,%rbx
	struct dir *dp = (struct dir *)dir;
	int res = -1;
	if(dp != NULL)
  400f83:	48 85 ff             	test   %rdi,%rdi
  400f86:	74 13                	je     400f9b <closedir+0x21>
	{	
		res = close(dp->fd);
  400f88:	8b 3f                	mov    (%rdi),%edi
  400f8a:	e8 9c fe ff ff       	callq  400e2b <close>
  400f8f:	89 c5                	mov    %eax,%ebp
		free(dp);
  400f91:	48 89 df             	mov    %rbx,%rdi
  400f94:	e8 b7 02 00 00       	callq  401250 <free>
  400f99:	eb 05                	jmp    400fa0 <closedir+0x26>
	return next;
}

int closedir(void *dir){
	struct dir *dp = (struct dir *)dir;
	int res = -1;
  400f9b:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
	{	
		res = close(dp->fd);
		free(dp);
	}
	return res;
}
  400fa0:	89 e8                	mov    %ebp,%eax
  400fa2:	48 83 c4 08          	add    $0x8,%rsp
  400fa6:	5b                   	pop    %rbx
  400fa7:	5d                   	pop    %rbp
  400fa8:	c3                   	retq   

0000000000400fa9 <waitpid>:

/*working*/
pid_t waitpid(pid_t pid,int *status, int options){
  400fa9:	53                   	push   %rbx
    pid_t res = syscall_3(SYS_wait4,(uint64_t)pid,(uint64_t)status,(uint64_t)options);
  400faa:	89 fb                	mov    %edi,%ebx
  400fac:	48 63 d2             	movslq %edx,%rdx
  400faf:	b8 3d 00 00 00       	mov    $0x3d,%eax
  400fb4:	48 89 f1             	mov    %rsi,%rcx
  400fb7:	48 89 c0             	mov    %rax,%rax
  400fba:	48 89 df             	mov    %rbx,%rdi
  400fbd:	48 89 ce             	mov    %rcx,%rsi
  400fc0:	48 89 d2             	mov    %rdx,%rdx
  400fc3:	0f 05                	syscall 
  400fc5:	48 89 c0             	mov    %rax,%rax
  400fc8:	48 89 c2             	mov    %rax,%rdx
	if((int)res < 0)
  400fcb:	85 d2                	test   %edx,%edx
  400fcd:	79 10                	jns    400fdf <waitpid+0x36>
	{
		errno = -res;	
  400fcf:	f7 da                	neg    %edx
  400fd1:	48 8b 05 60 10 20 00 	mov    0x201060(%rip),%rax        # 602038 <digits.1221+0x200a98>
  400fd8:	89 10                	mov    %edx,(%rax)
		return -1;
  400fda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
    return res;
}
  400fdf:	5b                   	pop    %rbx
  400fe0:	c3                   	retq   
  400fe1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  400fe8:	00 00 00 
  400feb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000400ff0 <memcmp>:

//Compare first n characters pointed by s1 to s2.
int memcmp(const void* s1, const void* s2,size_t n)
{
    const unsigned char *p1 = s1, *p2 = s2;
    while(n--)
  400ff0:	4c 8d 42 ff          	lea    -0x1(%rdx),%r8
  400ff4:	48 85 d2             	test   %rdx,%rdx
  400ff7:	74 35                	je     40102e <memcmp+0x3e>
        if( *p1 != *p2 )
  400ff9:	0f b6 07             	movzbl (%rdi),%eax
  400ffc:	0f b6 0e             	movzbl (%rsi),%ecx
  400fff:	ba 00 00 00 00       	mov    $0x0,%edx
  401004:	38 c8                	cmp    %cl,%al
  401006:	74 1b                	je     401023 <memcmp+0x33>
  401008:	eb 10                	jmp    40101a <memcmp+0x2a>
  40100a:	0f b6 44 17 01       	movzbl 0x1(%rdi,%rdx,1),%eax
  40100f:	48 ff c2             	inc    %rdx
  401012:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  401016:	38 c8                	cmp    %cl,%al
  401018:	74 09                	je     401023 <memcmp+0x33>
            return *p1 - *p2;
  40101a:	0f b6 c0             	movzbl %al,%eax
  40101d:	0f b6 c9             	movzbl %cl,%ecx
  401020:	29 c8                	sub    %ecx,%eax
  401022:	c3                   	retq   

//Compare first n characters pointed by s1 to s2.
int memcmp(const void* s1, const void* s2,size_t n)
{
    const unsigned char *p1 = s1, *p2 = s2;
    while(n--)
  401023:	4c 39 c2             	cmp    %r8,%rdx
  401026:	75 e2                	jne    40100a <memcmp+0x1a>
        if( *p1 != *p2 )
            return *p1 - *p2;
        else
            p1++,p2++;
    return 0;
  401028:	b8 00 00 00 00       	mov    $0x0,%eax
  40102d:	c3                   	retq   
  40102e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401033:	c3                   	retq   

0000000000401034 <memset>:

void *memset(void *str, int c, size_t n)
{
  401034:	48 89 f8             	mov    %rdi,%rax
    char *dst = str;
    while(n-- != 0)
  401037:	48 85 d2             	test   %rdx,%rdx
  40103a:	74 12                	je     40104e <memset+0x1a>
  40103c:	48 01 fa             	add    %rdi,%rdx
    return 0;
}

void *memset(void *str, int c, size_t n)
{
    char *dst = str;
  40103f:	48 89 f9             	mov    %rdi,%rcx
    while(n-- != 0)
    {
        *dst++ = c;
  401042:	48 ff c1             	inc    %rcx
  401045:	40 88 71 ff          	mov    %sil,-0x1(%rcx)
}

void *memset(void *str, int c, size_t n)
{
    char *dst = str;
    while(n-- != 0)
  401049:	48 39 d1             	cmp    %rdx,%rcx
  40104c:	75 f4                	jne    401042 <memset+0xe>
    {
        *dst++ = c;
    }
    return str;
}
  40104e:	f3 c3                	repz retq 

0000000000401050 <memcpy>:

void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n)
{
  401050:	48 89 f8             	mov    %rdi,%rax
     char *dst = s1;
     const char *src = s2;
     /* Loop and copy.  */
     while (n-- != 0)
  401053:	48 85 d2             	test   %rdx,%rdx
  401056:	74 16                	je     40106e <memcpy+0x1e>
  401058:	b9 00 00 00 00       	mov    $0x0,%ecx
         *dst++ = *src++;
  40105d:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  401062:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
  401066:	48 ff c1             	inc    %rcx
void *(memcpy)(void * restrict s1, const void * restrict s2, size_t n)
{
     char *dst = s1;
     const char *src = s2;
     /* Loop and copy.  */
     while (n-- != 0)
  401069:	48 39 d1             	cmp    %rdx,%rcx
  40106c:	75 ef                	jne    40105d <memcpy+0xd>
         *dst++ = *src++;
     return s1;
 }
  40106e:	f3 c3                	repz retq 

0000000000401070 <strcpy>:

char *strcpy(char *dest, const char *src)
 {
  401070:	48 89 f8             	mov    %rdi,%rax
         char *tmp = dest; 
         while ((*dest++ = *src++) != '\0');
  401073:	48 89 fa             	mov    %rdi,%rdx
  401076:	48 ff c2             	inc    %rdx
  401079:	48 ff c6             	inc    %rsi
  40107c:	0f b6 4e ff          	movzbl -0x1(%rsi),%ecx
  401080:	88 4a ff             	mov    %cl,-0x1(%rdx)
  401083:	84 c9                	test   %cl,%cl
  401085:	75 ef                	jne    401076 <strcpy+0x6>
         return tmp;
 }
  401087:	f3 c3                	repz retq 

0000000000401089 <strncpy>:

char *strncpy(char *dest, const char *src, size_t count)
 {
  401089:	48 89 f8             	mov    %rdi,%rax
         char *tmp = dest; 
         while (count) {
  40108c:	48 85 d2             	test   %rdx,%rdx
  40108f:	74 1d                	je     4010ae <strncpy+0x25>
  401091:	48 01 fa             	add    %rdi,%rdx
         return tmp;
 }

char *strncpy(char *dest, const char *src, size_t count)
 {
         char *tmp = dest; 
  401094:	48 89 f9             	mov    %rdi,%rcx
         while (count) {
                 if ((*tmp = *src) != 0)
  401097:	44 0f b6 06          	movzbl (%rsi),%r8d
  40109b:	44 88 01             	mov    %r8b,(%rcx)
                         src++;
  40109e:	41 80 f8 01          	cmp    $0x1,%r8b
  4010a2:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
                 tmp++;
  4010a6:	48 ff c1             	inc    %rcx
 }

char *strncpy(char *dest, const char *src, size_t count)
 {
         char *tmp = dest; 
         while (count) {
  4010a9:	48 39 d1             	cmp    %rdx,%rcx
  4010ac:	75 e9                	jne    401097 <strncpy+0xe>
                         src++;
                 tmp++;
                 count--;
         }
         return dest;
 }
  4010ae:	f3 c3                	repz retq 

00000000004010b0 <strlen>:

size_t strlen(const char * str)
{
    const char *s;
    for (s = str; *s; ++s);
  4010b0:	80 3f 00             	cmpb   $0x0,(%rdi)
  4010b3:	74 0d                	je     4010c2 <strlen+0x12>
  4010b5:	48 89 f8             	mov    %rdi,%rax
  4010b8:	48 ff c0             	inc    %rax
  4010bb:	80 38 00             	cmpb   $0x0,(%rax)
  4010be:	75 f8                	jne    4010b8 <strlen+0x8>
  4010c0:	eb 03                	jmp    4010c5 <strlen+0x15>
  4010c2:	48 89 f8             	mov    %rdi,%rax
    return(s - str);
  4010c5:	48 29 f8             	sub    %rdi,%rax
}
  4010c8:	c3                   	retq   

00000000004010c9 <strcmp>:

int strcmp(const char *cs, const char *ct)
 {
         unsigned char c1, c2;
         while (1) {
                 c1 = *cs++;
  4010c9:	48 ff c7             	inc    %rdi
  4010cc:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
                 c2 = *ct++;
  4010d0:	48 ff c6             	inc    %rsi
  4010d3:	0f b6 56 ff          	movzbl -0x1(%rsi),%edx
                 if (c1 != c2)
  4010d7:	38 d0                	cmp    %dl,%al
  4010d9:	74 08                	je     4010e3 <strcmp+0x1a>
                         return c1 < c2 ? -1 : 1;
  4010db:	38 d0                	cmp    %dl,%al
  4010dd:	19 c0                	sbb    %eax,%eax
  4010df:	83 c8 01             	or     $0x1,%eax
  4010e2:	c3                   	retq   
                 if (!c1)
  4010e3:	84 c0                	test   %al,%al
  4010e5:	75 e2                	jne    4010c9 <strcmp>
                         break;
         }
         return 0;
  4010e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  4010ec:	c3                   	retq   

00000000004010ed <strstr>:

char *strstr(const char *s1, const char *s2)
{
  4010ed:	41 55                	push   %r13
  4010ef:	41 54                	push   %r12
  4010f1:	55                   	push   %rbp
  4010f2:	53                   	push   %rbx
  4010f3:	48 83 ec 08          	sub    $0x8,%rsp
  4010f7:	48 89 fb             	mov    %rdi,%rbx
  4010fa:	49 89 f5             	mov    %rsi,%r13
         size_t l1, l2; 
         l2 = strlen(s2);
  4010fd:	48 89 f7             	mov    %rsi,%rdi
  401100:	e8 ab ff ff ff       	callq  4010b0 <strlen>
  401105:	49 89 c4             	mov    %rax,%r12
         if (!l2)
                 return (char *)s1;
  401108:	48 89 d8             	mov    %rbx,%rax

char *strstr(const char *s1, const char *s2)
{
         size_t l1, l2; 
         l2 = strlen(s2);
         if (!l2)
  40110b:	4d 85 e4             	test   %r12,%r12
  40110e:	74 43                	je     401153 <strstr+0x66>
                 return (char *)s1;
         l1 = strlen(s1);
  401110:	48 89 df             	mov    %rbx,%rdi
  401113:	e8 98 ff ff ff       	callq  4010b0 <strlen>
  401118:	48 89 c5             	mov    %rax,%rbp
         while (l1 >= l2) {
  40111b:	49 39 c4             	cmp    %rax,%r12
  40111e:	77 22                	ja     401142 <strstr+0x55>
                 l1--;
  401120:	48 ff cd             	dec    %rbp
                 if (!memcmp(s1, s2, l2))
  401123:	4c 89 e2             	mov    %r12,%rdx
  401126:	4c 89 ee             	mov    %r13,%rsi
  401129:	48 89 df             	mov    %rbx,%rdi
  40112c:	e8 bf fe ff ff       	callq  400ff0 <memcmp>
  401131:	85 c0                	test   %eax,%eax
  401133:	74 14                	je     401149 <strstr+0x5c>
                         return (char *)s1;
                 s1++;
  401135:	48 ff c3             	inc    %rbx
         size_t l1, l2; 
         l2 = strlen(s2);
         if (!l2)
                 return (char *)s1;
         l1 = strlen(s1);
         while (l1 >= l2) {
  401138:	49 39 ec             	cmp    %rbp,%r12
  40113b:	76 e3                	jbe    401120 <strstr+0x33>
  40113d:	0f 1f 00             	nopl   (%rax)
  401140:	eb 0c                	jmp    40114e <strstr+0x61>
                 l1--;
                 if (!memcmp(s1, s2, l2))
                         return (char *)s1;
                 s1++;
         }
         return NULL;
  401142:	b8 00 00 00 00       	mov    $0x0,%eax
  401147:	eb 0a                	jmp    401153 <strstr+0x66>
  401149:	48 89 d8             	mov    %rbx,%rax
  40114c:	eb 05                	jmp    401153 <strstr+0x66>
  40114e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401153:	48 83 c4 08          	add    $0x8,%rsp
  401157:	5b                   	pop    %rbx
  401158:	5d                   	pop    %rbp
  401159:	41 5c                	pop    %r12
  40115b:	41 5d                	pop    %r13
  40115d:	c3                   	retq   

000000000040115e <strcat>:

char *strcat(char *dest, const char *src)
{
  40115e:	48 89 f8             	mov    %rdi,%rax
         char *tmp = dest; 
         while (*dest)
  401161:	80 3f 00             	cmpb   $0x0,(%rdi)
  401164:	74 0d                	je     401173 <strcat+0x15>
  401166:	48 89 fa             	mov    %rdi,%rdx
                 dest++;
  401169:	48 ff c2             	inc    %rdx
}

char *strcat(char *dest, const char *src)
{
         char *tmp = dest; 
         while (*dest)
  40116c:	80 3a 00             	cmpb   $0x0,(%rdx)
  40116f:	75 f8                	jne    401169 <strcat+0xb>
  401171:	eb 03                	jmp    401176 <strcat+0x18>
  401173:	48 89 fa             	mov    %rdi,%rdx
                 dest++;
         while ((*dest++ = *src++) != '\0')
  401176:	48 ff c2             	inc    %rdx
  401179:	48 ff c6             	inc    %rsi
  40117c:	0f b6 4e ff          	movzbl -0x1(%rsi),%ecx
  401180:	88 4a ff             	mov    %cl,-0x1(%rdx)
  401183:	84 c9                	test   %cl,%cl
  401185:	75 ef                	jne    401176 <strcat+0x18>
                 ;
         return tmp;
}
  401187:	f3 c3                	repz retq 

0000000000401189 <isspace>:

int isspace(char c)
{
    return (c == ' ' || c == '\t' || c == '\n' || c == '\12');
  401189:	8d 47 f7             	lea    -0x9(%rdi),%eax
  40118c:	3c 01                	cmp    $0x1,%al
  40118e:	0f 96 c2             	setbe  %dl
  401191:	40 80 ff 20          	cmp    $0x20,%dil
  401195:	0f 94 c0             	sete   %al
  401198:	09 d0                	or     %edx,%eax
  40119a:	0f b6 c0             	movzbl %al,%eax
}
  40119d:	c3                   	retq   

000000000040119e <strchr>:

char *strchr(const char *s, int c)
{
    while (*s != (char)c)
  40119e:	eb 07                	jmp    4011a7 <strchr+0x9>
        if (!*s++)
  4011a0:	48 ff c7             	inc    %rdi
  4011a3:	84 c0                	test   %al,%al
  4011a5:	74 0c                	je     4011b3 <strchr+0x15>
    return (c == ' ' || c == '\t' || c == '\n' || c == '\12');
}

char *strchr(const char *s, int c)
{
    while (*s != (char)c)
  4011a7:	0f b6 07             	movzbl (%rdi),%eax
  4011aa:	40 38 f0             	cmp    %sil,%al
  4011ad:	75 f1                	jne    4011a0 <strchr+0x2>
  4011af:	48 89 f8             	mov    %rdi,%rax
  4011b2:	c3                   	retq   
        if (!*s++)
            return 0;
  4011b3:	b8 00 00 00 00       	mov    $0x0,%eax
    return (char *)s;
}
  4011b8:	c3                   	retq   

00000000004011b9 <isdigit>:

int isdigit(int ch)
{
        return (ch >= '0') && (ch <= '9');
  4011b9:	83 ef 30             	sub    $0x30,%edi
  4011bc:	83 ff 09             	cmp    $0x9,%edi
  4011bf:	0f 96 c0             	setbe  %al
  4011c2:	0f b6 c0             	movzbl %al,%eax
}
  4011c5:	c3                   	retq   

00000000004011c6 <strcspn>:

size_t strcspn(const char *s, const char *reject) {
  4011c6:	41 54                	push   %r12
  4011c8:	55                   	push   %rbp
  4011c9:	53                   	push   %rbx
  4011ca:	48 89 fd             	mov    %rdi,%rbp
        size_t count = 0;

        while (*s != '\0') {
  4011cd:	0f b6 17             	movzbl (%rdi),%edx
  4011d0:	84 d2                	test   %dl,%dl
  4011d2:	74 26                	je     4011fa <strcspn+0x34>
  4011d4:	49 89 f4             	mov    %rsi,%r12
{
        return (ch >= '0') && (ch <= '9');
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;
  4011d7:	bb 00 00 00 00       	mov    $0x0,%ebx

        while (*s != '\0') {
                if (strchr(reject, *s++) == NULL) {
  4011dc:	0f be f2             	movsbl %dl,%esi
  4011df:	4c 89 e7             	mov    %r12,%rdi
  4011e2:	e8 b7 ff ff ff       	callq  40119e <strchr>
  4011e7:	48 85 c0             	test   %rax,%rax
  4011ea:	75 13                	jne    4011ff <strcspn+0x39>
                        ++count;
  4011ec:	48 ff c3             	inc    %rbx
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;

        while (*s != '\0') {
  4011ef:	0f b6 54 1d 00       	movzbl 0x0(%rbp,%rbx,1),%edx
  4011f4:	84 d2                	test   %dl,%dl
  4011f6:	75 e4                	jne    4011dc <strcspn+0x16>
  4011f8:	eb 05                	jmp    4011ff <strcspn+0x39>
{
        return (ch >= '0') && (ch <= '9');
}

size_t strcspn(const char *s, const char *reject) {
        size_t count = 0;
  4011fa:	bb 00 00 00 00       	mov    $0x0,%ebx
                } else {
                        return count;
                }
        }
        return count;
}
  4011ff:	48 89 d8             	mov    %rbx,%rax
  401202:	5b                   	pop    %rbx
  401203:	5d                   	pop    %rbp
  401204:	41 5c                	pop    %r12
  401206:	c3                   	retq   

0000000000401207 <reset>:
void reset(char str[], int len)
{
	for(int i = 0; i < len; i++)
  401207:	85 f6                	test   %esi,%esi
  401209:	7e 10                	jle    40121b <reset+0x14>
  40120b:	b8 00 00 00 00       	mov    $0x0,%eax
		str[i] = '\0';
  401210:	c6 04 07 00          	movb   $0x0,(%rdi,%rax,1)
  401214:	48 ff c0             	inc    %rax
        }
        return count;
}
void reset(char str[], int len)
{
	for(int i = 0; i < len; i++)
  401217:	39 c6                	cmp    %eax,%esi
  401219:	7f f5                	jg     401210 <reset+0x9>
  40121b:	f3 c3                	repz retq 

000000000040121d <atoi>:
}

int atoi(const char *str)
{
    int k = 0;
    for (int i = 0; str[i] != '\0'; ++i)
  40121d:	0f b6 17             	movzbl (%rdi),%edx
  401220:	84 d2                	test   %dl,%dl
  401222:	74 26                	je     40124a <atoi+0x2d>
  401224:	b9 00 00 00 00       	mov    $0x0,%ecx
		str[i] = '\0';
}

int atoi(const char *str)
{
    int k = 0;
  401229:	b8 00 00 00 00       	mov    $0x0,%eax
    for (int i = 0; str[i] != '\0'; ++i)
        k = (k<<3)+(k<<1)+(str[i])-'0';
  40122e:	8d 34 00             	lea    (%rax,%rax,1),%esi
  401231:	8d 04 c6             	lea    (%rsi,%rax,8),%eax
  401234:	0f be d2             	movsbl %dl,%edx
  401237:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
}

int atoi(const char *str)
{
    int k = 0;
    for (int i = 0; str[i] != '\0'; ++i)
  40123b:	ff c1                	inc    %ecx
  40123d:	48 63 d1             	movslq %ecx,%rdx
  401240:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  401244:	84 d2                	test   %dl,%dl
  401246:	75 e6                	jne    40122e <atoi+0x11>
  401248:	f3 c3                	repz retq 
		str[i] = '\0';
}

int atoi(const char *str)
{
    int k = 0;
  40124a:	b8 00 00 00 00       	mov    $0x0,%eax
    for (int i = 0; str[i] != '\0'; ++i)
        k = (k<<3)+(k<<1)+(str[i])-'0';
    return k;
}
  40124f:	c3                   	retq   

0000000000401250 <free>:
}

void free(void *ptr)
{
	//printf("freed \n");
	if(ptr == NULL)
  401250:	48 85 ff             	test   %rdi,%rdi
  401253:	74 07                	je     40125c <free+0xc>
		return;
	struct mem_block *block = (struct mem_block *)ptr -1 ;
	block->free = FREE;
  401255:	c7 47 f0 01 00 00 00 	movl   $0x1,-0x10(%rdi)
  40125c:	f3 c3                	repz retq 

000000000040125e <find_free_mem_block>:

//our code
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size)
{
	//printf("find_free_mem_block called %d \n \n\n\n ", size);
	struct mem_block *temp = head;
  40125e:	48 8d 05 03 0e 20 00 	lea    0x200e03(%rip),%rax        # 602068 <head>
  401265:	48 8b 00             	mov    (%rax),%rax
	while(temp && !(temp->free == FREE && temp->size >= size))
  401268:	48 85 c0             	test   %rax,%rax
  40126b:	75 0e                	jne    40127b <find_free_mem_block+0x1d>
  40126d:	f3 c3                	repz retq 
	{
		*last = temp;
  40126f:	48 89 07             	mov    %rax,(%rdi)
		temp = temp->next;	
  401272:	48 8b 40 10          	mov    0x10(%rax),%rax
//our code
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size)
{
	//printf("find_free_mem_block called %d \n \n\n\n ", size);
	struct mem_block *temp = head;
	while(temp && !(temp->free == FREE && temp->size >= size))
  401276:	48 85 c0             	test   %rax,%rax
  401279:	74 0b                	je     401286 <find_free_mem_block+0x28>
  40127b:	83 78 08 01          	cmpl   $0x1,0x8(%rax)
  40127f:	75 ee                	jne    40126f <find_free_mem_block+0x11>
  401281:	48 39 30             	cmp    %rsi,(%rax)
  401284:	72 e9                	jb     40126f <find_free_mem_block+0x11>
	{
		*last = temp;
		temp = temp->next;	
	}
	return temp;
}
  401286:	f3 c3                	repz retq 

0000000000401288 <allocateMemory>:

/* allocate memory of size  */
struct mem_block *allocateMemory(size_t size)
{
  401288:	55                   	push   %rbp
  401289:	53                   	push   %rbx
  40128a:	48 83 ec 08          	sub    $0x8,%rsp
  40128e:	48 89 fd             	mov    %rdi,%rbp
	struct mem_block *current;
	current = sbrk(0);
  401291:	bf 00 00 00 00       	mov    $0x0,%edi
  401296:	e8 69 f9 ff ff       	callq  400c04 <sbrk>
  40129b:	48 89 c3             	mov    %rax,%rbx
	void *addr = sbrk(size + BLOCK_SIZE);
  40129e:	48 8d 7d 18          	lea    0x18(%rbp),%rdi
  4012a2:	e8 5d f9 ff ff       	callq  400c04 <sbrk>
	
	if (addr == (void*) -1) {
  4012a7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  4012ab:	74 17                	je     4012c4 <allocateMemory+0x3c>
		/* memory allocation failed */
		return NULL; 
  	}
	current->size = size;  //by removing memory block size
  4012ad:	48 89 2b             	mov    %rbp,(%rbx)
	current->next = NULL;
  4012b0:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  4012b7:	00 
	current->free = USED;
  4012b8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%rbx)
	return current;
  4012bf:	48 89 d8             	mov    %rbx,%rax
  4012c2:	eb 05                	jmp    4012c9 <allocateMemory+0x41>
	current = sbrk(0);
	void *addr = sbrk(size + BLOCK_SIZE);
	
	if (addr == (void*) -1) {
		/* memory allocation failed */
		return NULL; 
  4012c4:	b8 00 00 00 00       	mov    $0x0,%eax
  	}
	current->size = size;  //by removing memory block size
	current->next = NULL;
	current->free = USED;
	return current;
}
  4012c9:	48 83 c4 08          	add    $0x8,%rsp
  4012cd:	5b                   	pop    %rbx
  4012ce:	5d                   	pop    %rbp
  4012cf:	c3                   	retq   

00000000004012d0 <malloc>:
struct mem_block *allocateMemory(size_t size);
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size);
void *malloc(size_t size);

void *malloc(size_t size)
{
  4012d0:	53                   	push   %rbx
  4012d1:	48 83 ec 10          	sub    $0x10,%rsp
  4012d5:	48 89 fb             	mov    %rdi,%rbx
	//printf("malloc start \n");
	struct mem_block *block;
	if(size <= 0)
  4012d8:	48 85 ff             	test   %rdi,%rdi
  4012db:	74 61                	je     40133e <malloc+0x6e>
		return NULL;
	
	if(head == NULL)
  4012dd:	48 8d 05 84 0d 20 00 	lea    0x200d84(%rip),%rax        # 602068 <head>
  4012e4:	48 8b 00             	mov    (%rax),%rax
  4012e7:	48 85 c0             	test   %rax,%rax
  4012ea:	75 16                	jne    401302 <malloc+0x32>
	{
		//printf("first time allocation %d \n",size);
		block = allocateMemory(size);
  4012ec:	e8 97 ff ff ff       	callq  401288 <allocateMemory>
		if(block == NULL)
  4012f1:	48 85 c0             	test   %rax,%rax
  4012f4:	74 4f                	je     401345 <malloc+0x75>
		{
			/*memory allocation failed */
			return NULL;	
		}
		head = block;
  4012f6:	48 8d 15 6b 0d 20 00 	lea    0x200d6b(%rip),%rdx        # 602068 <head>
  4012fd:	48 89 02             	mov    %rax,(%rdx)
  401300:	eb 36                	jmp    401338 <malloc+0x68>
	}
	else
	{
		//search for free block
		struct mem_block *last = head;
  401302:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
		block = find_free_mem_block(&last, size);
  401307:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  40130c:	48 89 de             	mov    %rbx,%rsi
  40130f:	e8 4a ff ff ff       	callq  40125e <find_free_mem_block>
		//printf("found free memory block \n");
		if(block == NULL)
  401314:	48 85 c0             	test   %rax,%rax
  401317:	75 18                	jne    401331 <malloc+0x61>
		{
			//printf("added at the end %d \n", size);
			block = allocateMemory(size);
  401319:	48 89 df             	mov    %rbx,%rdi
  40131c:	e8 67 ff ff ff       	callq  401288 <allocateMemory>
			if(block == NULL)
  401321:	48 85 c0             	test   %rax,%rax
  401324:	74 24                	je     40134a <malloc+0x7a>
				return NULL;
			last->next = block;
  401326:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  40132b:	48 89 42 10          	mov    %rax,0x10(%rdx)
  40132f:	eb 07                	jmp    401338 <malloc+0x68>
		}
		else{
			//use free block found
			//printf("using free block \n");
			block->free = USED;
  401331:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
		}
	}
	//printf("malloc end \n");
 	return(block+1); 
  401338:	48 83 c0 18          	add    $0x18,%rax
  40133c:	eb 0c                	jmp    40134a <malloc+0x7a>
void *malloc(size_t size)
{
	//printf("malloc start \n");
	struct mem_block *block;
	if(size <= 0)
		return NULL;
  40133e:	b8 00 00 00 00       	mov    $0x0,%eax
  401343:	eb 05                	jmp    40134a <malloc+0x7a>
		//printf("first time allocation %d \n",size);
		block = allocateMemory(size);
		if(block == NULL)
		{
			/*memory allocation failed */
			return NULL;	
  401345:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	//printf("malloc end \n");
 	return(block+1); 
	//added 1 because block is a pointer of type struct and 
	//plus 1 increments the address by one sizeof(struct)
}
  40134a:	48 83 c4 10          	add    $0x10,%rsp
  40134e:	5b                   	pop    %rbx
  40134f:	c3                   	retq   
