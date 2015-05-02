#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int main(int argc, char* argv[], char* envp[]){
	//printf("In cd.c argc : %d\n",argc);
	if(argc==1)
	{
		chdir("rootfs/");
		//printf("return %d \n",res);
		return 0;
	}
	int res = chdir(argv[1]);
	if(res<0){
		printf("Path does not exist \n");
	}
	return 0; 
}