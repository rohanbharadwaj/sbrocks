#ifndef __SBUNIX_H
#define __SBUNIX_H

#include <sys/defs.h>

char *envp[10];
/* This defines what the stack looks like after an ISR was running */
#if 0
struct regs
{
    unsigned int gs, fs, es, ds;      /* pushed the segs last */
    unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax;  /* pushed by 'pusha' */
    unsigned int int_no, err_code;    /* our 'push byte #' and ecodes do this */
    unsigned int eip, cs, eflags, useresp, ss;   /* pushed by the processor automatically */ 
};
#endif
void kprintf(const char *fmt, ...);
void kprintat(int x, int y, const char *fmt, ...);
void kprintf2(const char *fmt, ...);
void clrscr();
#endif
