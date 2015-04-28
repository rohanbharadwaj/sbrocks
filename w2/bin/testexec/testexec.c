#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void testexec(char *envp[]);

int main(int argc, char* argv[], char* envp[]) {
	//testmalloc();
	char c = ' ';
	scanf("%c", &c);
	printf("%c", c);
	testexec(envp);
	return 0;
}

void testexec(char *envp[])
{
	//printf("*********************************************\n");
	//printf("testing  malloc() and free() API \n");
	printf("in testexec() \n");
	char cmd[100] = "bin/malloctest";
	char *argv[10];
	argv[0] = "abc\0";
	argv[1] = "def\0";
	execve(cmd,argv,envp);
}
