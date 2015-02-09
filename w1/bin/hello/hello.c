#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char* argv[], char* envp[]) {
	//char *s = "shashi ranjan abcefg";
	
	//printf("%s \n", envp[1]);
	/*int n = printf("%d\n",getpid());
	printf("%d\n",getppid());
	printf("%d num",n);*/
	//char c[2014] = "\0";
	char c[1024];
	scanf("%s", c);
	printf("read char is %s \n", c);
	return 0;
}



