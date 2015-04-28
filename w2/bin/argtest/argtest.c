#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void pipetest1();

int main(int argc, char* argv[], char* envp[]) {
	printf("shashi \n");
	printf("argc %d \n", argc);
	for(int i = 0; i < argc; i++)
		printf("argv %s \n", argv[i]);
	pipetest1();	
	return 0;
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
