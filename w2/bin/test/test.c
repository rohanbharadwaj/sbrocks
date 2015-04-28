#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char* argv[], char* envp[]) {
	
	//char c[1024];
	char *c = malloc(1024);
	//printf("address is: %p !\n", &c);
	printf("Enter the string !\n");
	scanf("%s", c);
	printf("read char : %s \n", c);
	/*
	int i = 0;
	while(1)
	{
		i++;
		//printf("beflore sleep \n");
		sleep(2);
		//printf("after sleep \n");
		//i++;
		printf("im in test %d \n", i);
		//if(i == 16)
		//	break;
	}
	*/
	//printf("%d \n", i);
	/*int i = 50;
    int j = 0;
    int k = i/j;*/
	return 0;
}