#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//#define NAME_MAX 255

void showFiles();

int main(int argc, char* argv[], char* envp[]) {
	showFiles();
	return 0;
}

void showFiles()
{
	char *buf = malloc(NAME_MAX);
	getcwd(buf, NAME_MAX+1);
    struct dir *dip;
	struct dirent *dit;
	dip = (struct dir *)opendir(buf);
	if(dip == NULL)
	{
		//printf("Error in opening directory \n");	
		serror(errno);
		return;
	}
	struct dirent *d = (struct dirent *)dip->addr;
	printf("%s \n", d->d_name);
	dit = readdir(dip->addr);
	while(dit != NULL)
	{
		printf("%s \n", dit->d_name);	
		dit = readdir(dit);
	}
	//printf("\n");
	free(buf);
	if(closedir(dip) == -1)
	{
		serror(errno);
		return;
	}
}
