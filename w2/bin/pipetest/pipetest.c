#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void testpipe();
void pipetest1();
void testpipe_with_exec(char *envp[]);

int main(int argc, char* argv[], char* envp[]) {
	testpipe_with_exec(envp);
	return 0;
}

void testpipe()
{
	char    string[] = "Hello, world!\n";
	char    readbuffer[80];
	int pipefd[2];
	
	pipe(pipefd);
	int pid = fork();
    if(pid == 0)
    {
		printf("child \n");
		
		dup2(pipefd[0], 0);
		//read(pipefd[0], readbuffer, sizeof(readbuffer));
		scanf("%s", readbuffer);
    	printf("Received string: %s", readbuffer);
		exit(0);
	}
	else
	{

		dup2(pipefd[1], 1);
		//printf("parent \n");
		printf("%s \n", string);
		//write(pipefd[1], string, (strlen(string)+1));
	}
			
}

void testpipe_with_exec(char *envp[])
{
	//char    string[] = "Hello, world!\n";
	//char    readbuffer[80];
	int pipefd[2];
	int status;
	pipe(pipefd);
	int pid = fork();
    if(pid == 0)
    {
		printf("child \n");
		char cmd[100] = "bin/scanftest";	
		dup2(pipefd[0], 0);
		char *argv[10];
		argv[0] = "shashi\0";
		argv[1] = "ranjan\0";
		execve(cmd,argv,envp);
		//read(pipefd[0], readbuffer, sizeof(readbuffer));
		//scanf("%s", readbuffer);
    	//printf("Received string: %s", readbuffer);
		exit(0);
	}
	else
	{
		char cmd[100] = "bin/printftest";
		dup2(pipefd[1], 1);
		//printf("parent \n");
		//printf("%s \n", string);
		char *argv[10];
		argv[0] = "shashi\0";
		argv[1] = "ranjan\0";
		execve(cmd,argv,envp);
		//write(pipefd[1], string, (strlen(string)+1));
	}
	close(pipefd[1]);
	waitpid(pid,&status,0);		
	printf("child killed now exit !!! \n");
}

void pipetest1()
{
	printf("inside pipetest \n");
	int     fd[2];
	char    string[] = "Hello, world!\n";
	char    readbuffer[80];
	
	pipe(fd);
	printf("pipe fds : %d  %d \n", fd[0], fd[1]);	
	int pid = fork();
	if(pid == 0)
	{
		printf("inside cchild \n");
		write(fd[1], string, (strlen(string)+1));
		//child
		close(fd[0]);

		/* Send "string" through the output side of pipe */
		//write(fd[1], string, (strlen(string)+1));
		exit(0);
	}
	read(fd[0], readbuffer, sizeof(readbuffer));
    printf("Received string: %s", readbuffer);
}
