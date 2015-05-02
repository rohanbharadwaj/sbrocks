#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int readInput(char *input_line);

int main(int argc, char* argv[], char* envp[]) 
{
        char input[1024];
        readInput(input);
        printf("%s \n", input);
        return 1;
}

int readInput(char *input_line){
        char c = ' ';
    int i =0;
    int pipeFound = 0;
    while(c!='\n' || pipeFound == 1){
        scanf("%c", &c);
        if(pipeFound == 1 && c == '|')
        {
            printf("-bash: syntax error near unexpected token | \n");
            return 0;
        }
        if(c == '\n' && pipeFound ==1)
        {
            printf(">");
        }
        if(c!= '\n')
            input_line[i++] = c;
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
                                                                                                         