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
	if (strcmp(argv[1],"..")==0)
		{
			char *buf = malloc(NAME_MAX);
	    	getcwd(buf, NAME_MAX+1);
			//printf("buf in ashish cd is %s\n",buf);
			//char temp_name[1024];
			char* iter_name = buf;
			int length = strlen(iter_name);
			int i = length-2;
			
			while(iter_name[i] != '/'&& i>0)
    			i--;	
			if(i==0)
				{
					printf("This is root directory\n");
					return 0;
			}
			else
				{
					length = i+1;
					char temp_name[1024];
					strncpy(temp_name,buf,length);
					//printf("temp name in cd is %s\n",temp_name);
					chdir(temp_name);
			}
	}
	else if(strcmp(argv[1],".")==0)
		{
		return 0;
	}
	else
		{
	int res = chdir(argv[1]);
	if(res<0){
		printf("Path does not exist \n");
	 }
	}
	return 0; 
}
