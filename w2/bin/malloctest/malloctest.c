#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void testmalloc();
void testfork();
int main(int argc, char* argv[], char* envp[]) {
	//testmalloc();
	/*printf("argc %d \n", argc);
	for(int i = 0; i < argc; i++)
		printf("argv %s \n", argv[i]);*/
	/*int i = 10;
	while(1)
	{
		i++;
		sleep(1);
		printf("in test malloc %d \n", i);	
		if(i == 15)
			break;
	}*/
	int i = 0;
	while(1)
	{
		//if(i == 10)
		//	break;
		i++;
		sleep(1);
		printf("shashi %d \n", i);
	}
	//testfork();
	return 0;
}

void testmalloc()
{
	//printf("*********************************************\n");
	//printf("testing  malloc() and free() API \n");
	char *c[100];
	for(int i = 0; i<10; i++)
	{
		c[i] =(char*) malloc(2048);
		strcpy(c[i], "shashi");
		printf("%s i=%d \n", c[i], i);
	}
	
	#if 0
	char *d =(char*) malloc(10);
	//free(c);
	strcpy(d, "rajnjan");
	//printf("shashi \n");
	printf("%s \n", d);
	free(d);
	char *e =(char*) malloc(5);
	
	strcpy(e, "rohan");
	//printf("shashi \n");
	printf("%s \n", e);
	printf("malloc API succesfull \n");
	printf("free API open succesfull \n");
	#endif
	printf("\n\n");
}

void testfork()
{
	//printf("*********************************************\n");
	//char *c =(char*) malloc(10);
	//char c[1024];
	//strcpy(c, "shashi");
	//printf("%s \n", c);
	//c =(char*) malloc(20);
	//strcpy(c, "ranjan");
	//printf("%s \n", c);
	char *c =(char*) malloc(20);
	//char c[1024];
	strcpy(c, "shashi");
	//strcat(c, d);
	//printf("%p \n", &c);
	printf("parent: %s \n", c);
	//free(c);
	//printf("%s \n", c);
	
	//printf("testing  fork() API  \n");
	int pid = fork();
	if(pid == 0)
	{
		//printf("%p \n", &c);
		printf("child process is %s \n", c);
		strcpy(c, "ranjan");
		printf("after modification: %s \n", c);
		/*char *d =(char*) malloc(10);
		strcpy(d, "ranjan");
		strcpy(c, "ashish");
		printf("value inside  fork() API %s \n", d);
		printf("new value is %s \n", c);*/
		//printf("I am in child \n");
		//c = (char *)0x100;
		sleep(5);
		printf("child: after sleep \n");
		exit(1);
	}
	//
	int status;
	//printf("testing  fork() API %s \n", c);
	waitpid(pid,&status,0);
	printf("status : %d \n", status);
	//sleep(10);
	//while(1);
	//printf("parent pid is %d \n", pid);
	
	printf("I am in parent \n");
}