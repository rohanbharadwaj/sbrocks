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
	uint64_t *a;
	a = (uint64_t *)0x120;
	printf("%d \n", *a);
	//while(1);
	//printf("shashi ranjan \n");
	//while(1);
	return 0;
}