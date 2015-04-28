#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char* argv[], char* envp[]) {
	char s[1024];
	scanf("%s", s);
	printf("read from pipe: %s \n", s);
	return 0;
}