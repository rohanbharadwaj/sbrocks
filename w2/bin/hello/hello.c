#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void printEnvironments(char *envp[]);
	
int main(int argc, char* argv[], char* envp[]) {
	//int a = 10;
	/*printf("argc %d \n", argc);
	for(int i = 0; i < argc; i++)
		printf("argv %s \n", argv[i]);*/
	//printEnvironments(envp);
	//printf("done \n");
	while(1);
	//printf("shashi ranjan \n");
	//while(1);
	return 0;
}
void printEnvironments(char *envp[])
{
    printf("\n\n\n\n\n environments are \n");
   	//while(*envp)
    //    printf("%s\n",*envp++);
	printf("shashi::%s\n",envp[0]);
	//printf("shashi::%s\n",envp[1]);
	//printf("shashi::%s\n",envp[2]);
	//printf("shashi::%s\n",envp[3]);
	//printf("shashi::%s\n",envp[4]);
}
