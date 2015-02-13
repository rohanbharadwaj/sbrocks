#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char* argv[], char* envp[]) {
	char c[1024];
	printf("type some character \n");
	scanf("%s", c);
	printf("read char is %s \n", c);
	return 0;
}



