#include<stdio.h>
#include<stdlib.h>
int main(int argc, char *argv[],char *envp[]){

int f,n;
char buf[80];
if(argc!=2)
printf("Usage : cat <file-name> %d \n ", argc);
f = open(argv[1],O_RDONLY);
while((n=read(f,buf,80))>0)
               write(1,buf,n);
return 0;
}
