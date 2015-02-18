#include <stdlib.h>
#include <sys/defs.h>
#include <sys/syscall.h>
#include <syscall.h>
#include <string.h>
#include <stdio.h>
#include <error.h>

static void *breakPtr;
__thread int errno;
/*working*/
void exit(int status){
    syscall_1(SYS_exit, status);
}
/*working*/
int brk(void *end_data_segment){
    return syscall_1(SYS_brk, (uint64_t)end_data_segment);
}

/*working*/
void *sbrk(size_t increment){
	if(breakPtr == NULL)
		breakPtr = (void *)((uint64_t)brk(0));
	if(increment == 0)
	{
		return breakPtr;
	}
	void *startAddr = breakPtr;
	breakPtr = breakPtr+increment;
	brk(breakPtr);
    return startAddr;
}

/*working*/
pid_t fork(){
    uint32_t res = syscall_0(SYS_fork);
	if((int)res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
}

/*this method doesnt throw error always successful*/
pid_t getpid(){
    uint32_t res = syscall_0(SYS_getpid);
    return res;
}
/*working*/
pid_t getppid(){
    uint32_t res = syscall_0(SYS_getppid);
    return res;
}
/*wrokig*/
int execve(const char *filename, char *const argv[], char *const envp[]){
    uint64_t res = syscall_3(SYS_execve, (uint64_t)filename, (uint64_t)argv, (uint64_t)envp);
	if((int)res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
}

unsigned int sleep(unsigned int seconds){
    unsigned int res = syscall_1(SYS_nanosleep, seconds);
    return res;
}

unsigned int alarm(unsigned int seconds){
    unsigned int res = syscall_1(SYS_alarm, seconds);
    return res;
}
/*working*/
char *getcwd(char *buf, size_t size){
    uint64_t res = syscall_2(SYS_getcwd, (uint64_t) buf, (uint64_t) size);
	if((char *)res == NULL)
	{
		errno = EFAULT;
	}
    return (char *)res;
}
/*working*/ 
int chdir(const char *path){
    int res = syscall_1(SYS_chdir, (uint64_t)path);
	if(res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
}
/*working*/    
int open(const char *pathname, int flags){
    uint64_t res = syscall_2(SYS_open, (uint64_t) pathname, (uint64_t) flags);
	if((int)res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
}

/*working*/
ssize_t read(int fd, void *buf, size_t count){
    ssize_t res = syscall_3(SYS_read, (uint64_t) fd, (uint64_t) buf, (uint64_t) count);
	if((int)res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
}

/*working*/
ssize_t write(int fd, const void *buf, size_t count){
    ssize_t res = syscall_3(SYS_write, (uint64_t) fd, (uint64_t) buf, (uint64_t) count);
	if((int)res < 0)
	{
		errno = -res;
		return -1;
	}
    return res; 
}

off_t lseek(int fildes, off_t offset, int whence){
    off_t res = syscall_3(SYS_lseek, (uint64_t) fildes, (uint64_t) offset, (uint64_t) whence);
	if((int)res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
}
/*working*/
int close(int fd){
    int res = syscall_1(SYS_close, fd);
	if(res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
}
/*working*/
int pipe(int filedes[2]){
    int res = syscall_1(SYS_pipe, (uint64_t)filedes);
	if(res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
}

int dup(int oldfd){
    int res = syscall_1(SYS_dup,oldfd);
	if(res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
}

int dup2(int oldfd, int newfd){
    int res = syscall_2(SYS_dup2, (uint64_t) oldfd, (uint64_t) newfd);
	if(res < 0)
	{
		errno = -res;
		return -1;
	}
    return res;
}

void *opendir(const char *name){
	int fd = open(name, O_DIRECTORY);
	char buf[1024];
	//struct dirent *d = NULL;
	if(fd < 0)
		return NULL;
	//static struct dirent dp;
	//printf("sashi 1 \n");
	int res = syscall_3(SYS_getdents, (uint64_t)fd, (uint64_t)buf, (uint64_t)sizeof(struct dirent));
	if(res < 0)
	{
		errno = -res;	
		return NULL;
	}
	//printf("sashi 2 \n");
	struct dir *d = malloc(sizeof(struct dir));
	d->fd = fd;
	d->addr = (void *)buf;
	//printf("sashi 1 \n");
	strcpy(d->d_name, name);
	//printf("sashi 2 \n");
	//d = (struct dirent *)buf;
    return (void *)d;
}

/*
void *opendir(const char *name){
	int fd = open(name, O_DIRECTORY);
	char buf[1024];
	struct dirent *d = NULL;
	if(fd < 0)
		return NULL;
	static struct dirent dp;
	int res = syscall_3(SYS_getdents, (uint64_t)fd, (uint64_t)buf, (uint64_t)sizeof(dp));
	if(res == -1)
		return NULL;
	d = (struct dirent *)buf;
    return (void *)d;
}
*/
struct dirent *readdir(void *dir)
{
	struct dirent *dip = (struct dirent *)dir;
	struct dirent *next;
	next = (struct dirent *)(dir + dip->d_reclen);
	if(next->d_reclen == 0)
		return NULL;
	return next;
}

int closedir(void *dir){
	struct dir *dp = (struct dir *)dir;
	int res = -1;
	if(dp != NULL)
	{	
		res = close(dp->fd);
		free(dp);
	}
	return res;
}

/*working*/
pid_t waitpid(pid_t pid,int *status, int options){
    pid_t res = syscall_3(SYS_wait4,(uint64_t)pid,(uint64_t)status,(uint64_t)options);
	if((int)res < 0)
	{
		errno = -res;	
		return -1;
	}
    return res;
}
