#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void printEnvironments(char *envp[]);
	
int main(int argc, char* argv[], char* envp[]) {
	
	//printf("argc count %d \n", argc);
	if(argc < 2)
	{
		printf("kill: Too few arguments. \n");
		exit(1);
	}
	int pid = atoi(argv[1]);
	//printf("first : %s,second: %s\n",argv[0],argv[1]);
	int res = kill(pid);
	//printf("res: %d\n",res);
	if(res < 0)
	{
		printf("kill: Arguments should be jobs or process id's. \n");
	}
	
	return 0;
}
