#include<stdlib.h>
#include<stdio.h>
int main(int argc, char* argv[], char* envp[]){
	if(argc<2){
		printf("usage : echo <string> \n");
		return 1;
	}
/* char str[1024];
while(argv[1])	
scanf("%[^\n]+", str);
printf("%s\n", str); */
 printf("%s\n",argv[1]);	
 return 0;
}
