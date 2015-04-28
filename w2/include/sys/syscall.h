#ifndef __SYS_SYSCALL_H
#define __SYS_SYSCALL_H

#include <sys/process/process.h>

#define SYS_exit       60
#define SYS_brk        12
#define SYS_fork       57
#define SYS_getpid     39
#define SYS_getppid    110
#define SYS_execve     59
#define SYS_wait4      61
#define SYS_nanosleep  35
#define SYS_alarm      37
#define SYS_getcwd     79
#define SYS_chdir      80
#define SYS_open        2
#define SYS_read        0
#define SYS_write       1
#define SYS_lseek       8
#define SYS_close       3
#define SYS_pipe       22
#define SYS_dup        32
#define SYS_dup2       33
#define SYS_getdents   78
#define SYS_readdir    81
uint64_t switch_handler(uint64_t syscall_num,uint64_t first_arg,uint64_t sec_arg,uint64_t third_arg, struct regs *r);
uint64_t system_write(uint64_t first_arg,uint64_t sec_arg,uint64_t third_arg);
void system_exit(uint64_t first_arg);
uint64_t system_brk(uint64_t size);
uint64_t system_read(uint64_t first_arg,uint64_t sec_arg,uint64_t third_arg);
uint64_t system_getpid();
uint64_t system_fork();
uint64_t system_getppid();
int system_open(uint64_t first_arg,uint64_t sec_arg);
void system_execve(uint64_t first_arg,uint64_t sec_arg,uint64_t third_arg);
uint64_t system_waitpid(uint64_t child_pid, uint64_t status , uint64_t options);
void system_sleep(uint64_t first_arg);
void system_alarm(uint64_t first_arg);
uint64_t system_getcwd(uint64_t first_arg,uint64_t sec_arg);
void system_chdir(uint64_t first_arg);
void system_lseek(uint64_t first_arg,uint64_t sec_arg,uint64_t third_arg);	
void system_close(uint64_t first_arg);
void system_pipe(uint64_t first_arg);
void system_dup(uint64_t first_arg);
void system_dup2(uint64_t first_arg,uint64_t sec_arg);
uint64_t system_getdents(uint64_t first_arg,uint64_t sec_arg,uint64_t third_arg);
void system_readdir(uint64_t first_arg);

					
					
					

#endif

