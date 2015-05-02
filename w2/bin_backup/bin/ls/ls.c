#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#define NAME_MAX 255
void showFiles();
//int readInput(char *input_line);
int main(int argc, char* argv[], char* envp[]) {
	
	showFiles();
	return 0;
}
#if 0
int readInput(char *input_line){
	char c = ' ';
    int i =0;
    int pipeFound = 0;
    while(c!='\n' || pipeFound == 1){
        scanf("%c", &c);
		//printf("%c", c);
        if(pipeFound == 1 && c == '|')
        {
            printf("-bash: syntax error near unexpected token | \n");
            return 0;
        }
        if(c == '\n' && pipeFound ==1)
        {
            printf(">");
        }
        if(c == '\b')
		{	
			//input_line[i]='\0';
			i--;
			input_line[i]='\0';
		}
		else if(c!= '\n')
            input_line[i++] = c;
		
			//printf("backspace \n");
        if(c == '|')
        {
            //printf("pipe found \n");
            pipeFound = 1;
        }
        else if(pipeFound == 1 && c != ' ' && c != '\n')
        {
            pipeFound = 0;
        }
    }
    input_line[i]='\0';
    if(i<1)
        return 0;
    return 1;
}
#endif
void showFiles()
{
	char *buf = malloc(NAME_MAX);
	getcwd(buf, NAME_MAX+1);
	//printf("getcwd returns %s\n",buf);
	
	struct dirent *dit = (struct dirent *)opendir(buf);	

	if(dit == NULL)
	{
		serror(errno);
		return;
	}
	//printf("ashish\n");
	printf("%s \n", dit->d_name);
	struct dirent *dip = (struct dirent *)readdir(dit);

	while (dip!=NULL)
	{
		printf("%s \n", dip->d_name);
		dip = (struct dirent *)readdir(dip);
	}
	//printf("finished \n");
	//printf("\n");
	//free(buf);
	if(closedir(dit) == -1)
	{
		serror(errno);
		return;
	}
	/*else
		printf("directory closed\n");*/
}
