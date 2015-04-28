#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#define NAME_MAX 255
void showFiles();

int main(int argc, char* argv[], char* envp[]) {
	//printf("ashish\n");
	showFiles();
	return 0;
}

void showFiles()
{
	//char *buf = malloc(NAME_MAX);
	//getcwd(buf, NAME_MAX+1);
	//printf("getcwd returns %s\n",buf);
	struct dirent *dit = (struct dirent *)opendir("bin/");	

	if(dit == NULL)
	{
		serror(errno);
		return;
	}
	printf("%s \n", dit->d_name);
	struct dirent *dip = (struct dirent *)readdir(dit);

	while (dip!=NULL)
	{
		printf("%s \n", dip->d_name);
		dip = (struct dirent *)readdir(dip);
	}
	printf("finished \n");
	//printf("\n");
	//free(buf);
	if(closedir(dit) == -1)
	{
		serror(errno);
		return;
	}
	else
		printf("directory closed\n");
}