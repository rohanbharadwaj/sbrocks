#include<stdio.h>
#include<stdlib.h>

int main(int argc, char *argv[],char *envp[]){
//printf("ashish\n");
	int f,n;
	char buf[80];
	printf("inside cat \n");
	//printf("num args are %d \n", argc);
	/*for(int i = 0; i < argc; i++)
		printf("arguments are %s \n", argv[i]);*/
	if(argc!=2)
	{
		printf("Usage : cat <file-name> %d \n ", argc);
		return 0;
	}
	printf("arg 1 :%s\n",argv[1]);
	f = open(argv[1],O_RDONLY);
	printf("fd = %d \n", f);
	while((n=read(f,buf,80))>0)
		write(1,buf,n);
	close(f);
	return 0;
}
