#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void fopentest();
void getcwd1();	
int main(int argc, char* argv[], char* envp[]) {
	struct dirent *buf = (struct dirent *)opendir("bin/");
	printf("in main after opendir %s \n", buf->d_name);
	printf("shashi final \n");
/* 	char buf[100];
	int fd =fopen("bin/");
	kprintf2("bin fd %d\n",fd);
  struct file *f= dopen(fd,(uint64_t)buf);
	while(f!=NULL){
		f = dread(f);
		if(f!=NULL)
		kprintf2("name %s\n",f->name);
	} */
	//struct dirent *dent;
/* 	printf("dir name %s\n",d->d_name);
	printf("dir addr %p\n",d->addr);
	printf("\n after opendir call");
	readdir(d);
	printf("End of program"); */
	//char buf[100];
	//read(fd,(void *)buf,10);
	//printf("after reading is %d\n",fd);
	/*int pid = getpid();
	int ppid = getppid();
	printf("the pid is %d\n",pid);
	printf("the ppid is %d\n",ppid);*/
	//fopentest();
	//getcwd1();
	return 0;
}

void fopentest()
{
	printf("*********************************************\n");
	printf("testing  open() and close() API \n");
	char *name = malloc(12);
	strcpy(name, "shashi.txt"/*"abc"*/);
	int fd = open(name, O_RDONLY);
	//printf("fd no is %d error no is : %d \n", fd, errno);
	//print("fd is %d \n", fd);
	if(fd < 0)
	{
		serror(errno);
		return;
	}
	else
		printf("file open succesfull: fd =  %d\n", fd);
	char buf[100];
	read(fd,(void *)buf,10);
	printf("read bytes: %s \n", buf);
	int res = close(fd);
	if(res < 0)
		serror(errno);
	else
		printf("file close succesfull \n");
	 
	printf("\n\n");
	//printf("res value is %d \n", res);
	
}


void getcwd1()
{
	printf("*********************************************\n");
	printf("testing  getcwd() API \n");
	char* cwd;
	chdir("shashi");
    char buff[1024];
	cwd = getcwd( buff, 1025 );
    if( cwd != NULL ) {
        printf( "My working directory is %s \n", buff );
    }
    else
    {
    	serror(errno);
    	return;
    }
    printf("getcwd() API open succesfull \n");
	
	
	printf("\n\n");
}
