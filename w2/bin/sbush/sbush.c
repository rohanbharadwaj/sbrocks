/*
 make
 
 Sample Commands to test
 $ls
 $ls -l
 $ls -l | head -5 | head -3
 $set PS1 sbush
 $set PATH abc
 $ $PATH (prints path)
 $env (prints env variables)
 $./run.sbush  (runs sbush scripts)
 $ ./rootfs/bin/sbush run.sbush   (script passed as argument)
 
 */


#include<stdio.h>
#include<string.h>
#include<stdlib.h>

#define MAX_LEN 1024
#define CMD_LEN 1024
#define MAX_CMD 5
#define MAX_ARG_LEN 128
#define MAX_ARG_COUNT 64
//#define NULL 0
#define EXIT_SUCCESS 0

__thread int errno;

char *commands[MAX_CMD][MAX_ARG_COUNT];
char PS1[MAX_LEN]="";
char path[MAX_LEN];
char *envp[10];
int cmdcount = 0;

void printPrompt();
int readInput(char *);
int parse(char*);
int isSpace(char c);
void welcome();
void executeProcess(char* evnp[]);
void getPATH(char *env[]);
void executeProcessPipe(int num_args,char* envp[]);
char* getAbsolutePath(char*,char* envp[]);
void printEnvironments();
void setPath(char *env[],char* newval);
void trim(char *input);
int handleCommand(char *cmd, char *args, char *env[]);
void changeDirectory(char *newdir, char *env[]);
char* getEnvironment(char *key, char *env[]);
int parseCommand(char *inputString);
char* tokenizeWithKey(char *inputString, char key, char **before);
void executeScript(char* name, char *env[]);
void serror(int ernum);


int main(int argc,char *argv[],char *envP[]){
    int script =1;
	envp[0] = malloc(1024);
	memset(envp[0],0,1024);
	strcpy(envp[0],envP[0]);
    if(argc==2){
        executeScript(argv[1],envp);
        script = 0;
    }
    if(script)
        welcome();
	//printEnvironments(envp);
	//return 0;
    while(1)
	{
        int num_args;
        char input_line[MAX_LEN];
        printPrompt();
        if(readInput(input_line) == 1)
        {
			//printf("%s len = %d \n",input_line, strlen(input_line));
			
			/*
			for(int i = 0; i < len; i++)
			{
				printf("%d , %c \n", i, input_line[i]);	
			}*/
			//#if 0
			int len = strlen(input_line);
            if(len < 1)
                continue;
            num_args =  parseCommand(input_line);
            //printf(" no of arguments are %d, env = %s \n",num_args, envp[0]);
            //#if 0
			switch (num_args) 
			{
                case 1:
                    executeProcess(envp);
                    break;
                case 2:
					//printf("executeProcessPipe should be called \n");
                    executeProcessPipe(num_args,envp);
					break;
				case 3:
					executeProcessPipe(num_args,envp);
                    break;
				default:
					printf("more than 2 pipes not supported \n");
					break;
            }

        }
    }
	
    return 0;
}

void executeScript(char* fname,char *envp[]){
    
    int fh,size;
        char buf[65];
        int i = 0;
        char cmd[MAX_LEN];
        fh = open(fname,O_RDONLY);
        size = read(fh,buf,1);
        while (size > 0) {
                if(buf[size -1] != '\n')
                {
                        cmd[i++] = buf[size -1];
                }
                else
                {
                        cmd[i] = '\0';
                        if(!strstr(cmd,"#!"))
                        {
                               int num_args;
                                num_args =  parseCommand(cmd);
                                //printf(" arguments are %d\n",num_args );
                                switch (num_args) {
                                    case 1:                             
                                        executeProcess(envp);
                                        break;
                                     default:                             
                                        executeProcessPipe(num_args,envp);
                                        break;
                                }
                        }
                        i = 0;
                }
                buf[size] = '\0';
                size = read(fh,buf,1);
        }
    
}
#if 0
int parseCommand(char *inputString)
{
   /* for(int i = 0; i < cmdcount; i++)
    {
        free(commands[i]);
    }*/
	//printf("parse command start \n");
	
	//char *srcPtr = malloc(strlen(inputString));
	//memset(srcPtr, 0, strlen(inputString));
	//char *srcPtr = NULL;
	//strcpy(srcPtr, inputString);
	
    char *srcPtr = inputString;
	
    int len = strlen(inputString);
	//printf("srcptr %s \n", srcPtr);
    char *str = NULL;
    int i = 0;
    cmdcount = 0;
    int argcount = 0;
    int found = 0;
    int count = 0;
	//printf("reached %s, %d\n", srcPtr, strlen(srcPtr));
    while(i < len)
    {
		if(str != NULL)
			memset(str, 0, strlen(str));
        str = srcPtr;
		//printf("str =%s \n", str);
        while((*srcPtr != ' '  && *srcPtr != '|') && i < len)
        {      
            //printf("%c \n", *srcPtr); 
            i++;
            count++;
            srcPtr++;
        }    
		//printf("reached2 \n");
		//this command is over
        if(*srcPtr == '|')
        {
			
            trim(str);
            int len = strlen(str);
            if(len > 0 && count > 0)
            {
                commands[cmdcount][argcount]=malloc(len);
				memset(commands[cmdcount][argcount], 0, len);
                strncpy(commands[cmdcount][argcount], str, count);
                printf("command is %s \n",commands[cmdcount][argcount]);
                argcount++;
            }
			if(*srcPtr == '|')
			{
				printf("pipe \n");
				//printf("new srcPtr = %c \n", *srcPtr);
				printf("new srcPtr = %s \n", srcPtr);	
				cmdcount++;
            	argcount = 0;
				found = 1;
            	srcPtr++;
			} 
            
			
        }
        //this is argument    
        if(found != 1)
        {
			printf("final \n");
            trim(str);
            int len = strlen(str);
            if(len > 0 && count > 0)
            {
				//printf("final before malloc %d %d %d \n", cmdcount, argcount, len);
				//listprocess();
                commands[cmdcount][argcount]=malloc(len);
				//printf("final after malloc \n");
				memset(commands[cmdcount][argcount], 0, len);
				//printf("final after memset \n");
                strncpy(commands[cmdcount][argcount], str, count);
				//printf("final after strncpy \n");
				printf("command is %s \n",commands[cmdcount][argcount]);
                argcount++;
            }
        }
        found = 0;
        count = 0;
		//remove spaces
        while (*srcPtr == ' ' && i<len) {
            *srcPtr = '\0';
            srcPtr++;
            i++;
        }
        //printf("shashi:  %c \n", *srcPtr); 
        commands[cmdcount][argcount]=NULL;

    }
	printf("parse command end \n");
	//printf("cmdcount = %d, argcount= %d \n", cmdcount, argcount);
    return cmdcount + 1;
}
#endif


int parseCommand(char *inputString)
{
   /* for(int i = 0; i < cmdcount; i++)
    {
        free(commands[i]);
    }*/
	//printf("parse command start \n");
    char *srcPtr = inputString;
	
    int len = strlen(inputString);
	//printf("srcptr %s \n", srcPtr);
    char *str = NULL;
    int i = 0;
    cmdcount = 0;
    int argcount = 0;
    int found = 0;
    int count = 0;
	//printf("reached %s, %d\n", srcPtr, strlen(srcPtr));
    while(i < len)
    {
		if(str != NULL)
			memset(str, 0, strlen(str));
        //str = srcPtr;
        str = srcPtr;
		//printf("str =%s \n", str);
        while((*srcPtr != ' '  && *srcPtr != '|') && i < len)
        {      
            //printf("%c \n", *srcPtr); 
            i++;
            count++;
            srcPtr++;
        }    
		//printf("reached2 \n");
        if(*srcPtr == '|')
        {
            trim(str);
            int len = strlen(str);
            if(len > 0 && count > 0)
            {
                commands[cmdcount][argcount]=malloc(len);
				memset(commands[cmdcount][argcount], 0, 1024);
                strncpy(commands[cmdcount][argcount], str, count);
                //printf("command is %s \n",commands[cmdcount][argcount]);
                argcount++;
            }
			//printf("new srcPtr = %s \n", srcPtr);
            cmdcount++;
            argcount = 0;
            found = 1;
            srcPtr++;
        }
            
        if(found != 1)
        {
			//printf("final \n");
            trim(str);
			//printf("after trim\n");
            int len = strlen(str);
			//printf("after str\n");
            if(len > 0 && count > 0)
            {
				//printf("inside id\n");
				//printf("final before malloc %d %d %d \n", cmdcount, argcount, len);
				//listprocess();
                commands[cmdcount][argcount]=malloc(len);
				//printf("final after malloc \n");
				memset(commands[cmdcount][argcount], 0, 1024);
				//printf("final after memset \n");
                strncpy(commands[cmdcount][argcount], str, count);
				//printf("final after strncpy \n");
				//printf("command is %s \n",commands[cmdcount][argcount]);
                argcount++;
            }
			//printf("final out\n");
        }
        found = 0;
        count = 0;
        while (*srcPtr == ' ' && i<len) {
            *srcPtr = '\0';
            srcPtr++;
            i++;
        }
        //printf("while end\n"); 
        //commands[cmdcount][argcount]=NULL;

    }
	//printf("parse command end \n");
	//printf("cmdcount = %d, argcount= %d \n", cmdcount, argcount);
    return cmdcount + 1;
}
void printPrompt(){
    if(strlen(PS1)<2)  
    {   
        printf("$ ");
      }  
    else
    {    
        printf("%s$ ",PS1);
       } 
}

char* getValue(char* keyvalue){
    //printf("in get value");
    char *value;
    value = malloc(strlen(keyvalue));
	memset(value, 0, strlen(keyvalue));
    int found = 0;
    while(*keyvalue++){
        if(*keyvalue=='=')
        {
            //printf("found");
            found =1;
        }
        if(found)
        {
            
            *value++=*keyvalue;
        }
    }
   // printf("%s\n in function", value);
    return value;
}

int handleCommand(char *cmd, char *args, char *env[])
{
	//printf("handle command:: cmd is %s \n", cmd);
    if(strcmp("set",cmd)==0&&args!=NULL){
        if(strstr(args,"PS1")){
            char temp[MAX_LEN] = "";
            int i = 2;
            if(commands[0][i] == NULL)
            {
                printf("Usage: set PS1 <prompt string>\n");
            }
            while(commands[0][i] != NULL)
            {
                if(commands[0][i]!=NULL){
                    strcat(temp,commands[0][i]);
                    strcat(temp, " ");
                    i++;
                }
            }
            strcpy(PS1,temp);
            return 1;
        }
        if(strstr(args,"PATH")){
            setPath(env,commands[0][2]);
            return 1;
        }
    }
    if(strstr(cmd,".sbush")){
        // printf("%s\n", cmd);
        executeScript(cmd,env);
        return 1;
    }
    if(strcmp("env",cmd)==0){
        printEnvironments(env);
        return 1;
    }
    if(strcmp("$PATH",cmd) == 0)
    {
        //printf("%s\n",getEnvironment("PATH",env));
		printf("%s\n",env[0]);
        return 1;
    }
    if(strcmp("exit", cmd) == 0)
    {
		printf("in exit\n");
        exit(1);
    }
    /*if(strcmp("cd", cmd) == 0)
    {
        changeDirectory(args, env);
        return 1;
    }*/
	if(strcmp("clear", cmd) == 0)
    {
		printf("clear \n");
        cls();
        return 1;
    }
	if(strcmp("pwd", cmd) == 0)
    {
		  char *buf;
      buf = malloc(1024);
    	if((getcwd(buf, 1024)) != NULL)
            printf("%s\n", buf);
   	 else
            printf("getcwd() error : ");
     return 1;
    }
	  if(strcmp("echo", cmd) == 0)
    {
		 printf("%s\n",commands[0][1]);	
     return 1;
    }
		
    return 0;
}


void changeDirectory(char *newdir, char *env[])
{
    char new[MAX_LEN];
    if(newdir == NULL)
    {
        strcpy(new,getEnvironment("HOME", env));
    }
    else
    {
        strcpy(new, newdir);
    }
    if(chdir(new) == -1)
        printf(" %s: no such directory \n", new);
}

char* getEnvironment(char *key, char *env[])
{
	//printf("getEnvironment start: env = %s  \n", env[0]);
    //while(strcmp(*env++, "NULL") != 0)
    //{
      //  if(strstr(*env, key) != NULL)
       // {
            char *res;
            // printf("found key %s \n", *env);
            char token[MAX_LEN];
            strcpy(token, env[0]);
            char *before;
			
            //return tokenizeWithKey(token, '=',&before);
            res = tokenizeWithKey(token, '=',&before);
			//printf("getEnvironment %s  \n", before);
            if(strcmp(before,key)==0)
            {
				//printf("getEnvironment end \n");
                return res;
            }
          //  continue;
        //}
    //}
	//printf("getEnvironment end \n");
    return NULL;
}

void setPath(char *envp[], char *newval)

{
			printf("In setpath %s   %s\n",newval,*envp);
			trim(*envp);
            int len = strlen(*envp) + strlen(newval) + 1;
            char *str = malloc(len);
			memset(str, 0, len);
            strcpy(str, *envp);
			printf("str 1 %s\n",str);
            //*envp = malloc(len);
			memset(*envp, 0, 1024);
            strcat(str, ":");
            strcat(str,newval);
			printf("str 2 %s\n",str);
            strcpy(*envp,str);
			printf("str 3 %s\n",str);
			printf("new envp %s \n",*envp);
            return;
/*     while(*envp++)
    {
        
        if(strstr(*envp, "PATH") != NULL)
        {
            
            trim(*envp);
            int len = strlen(*envp) + strlen(newval) + 1;
            char *str = malloc(len);
			memset(str, 0, len);
            strcpy(str, *envp);
            *envp = malloc(len);
			memset(envp, 0, len);
            strcat(str, ":");
            strcat(str,newval);
            strcpy(*envp,str);
            return;
        }
    } */
    
}

char* getAbsolutePath(char *cmd,char *envp[])
{
	//printf("command is %s len is %d \n",cmd, strlen(cmd));
	/*if(strcmp("cd", cmd) == 0)
    {
        return cmd;
    }*/
    if(strcmp("exit", cmd) == 0)
    {
        return cmd;
    }
    if(strstr(cmd, "/") != NULL)
    {    
        return cmd;
    }
	//printf("getAbsolutePath1 \n");
	char *env_path = malloc(MAX_LEN);
    //printf("getAbsolutePath1 after malloc \n");
	memset(env_path, 0, MAX_LEN);
	strcpy(env_path,getEnvironment("PATH", envp));
	//printf("envpath is %s \n", env_path);
    char *after = NULL;
    after = env_path;
	//printf("getAbsolutePath2 envpath=%s \n", after);
	
    while(after != NULL)
    {
        char *abspath=malloc(MAX_LEN);
		memset(abspath, 0, MAX_LEN);
		//printf("command is %s len is %d \n",cmd, strlen(cmd));
        char *before;
        after = tokenizeWithKey(after, ':', &before);
		//printf("command is %s len is %d \n",cmd, strlen(cmd));
        strcpy(abspath, before);
		//printf("absolute path is%s, len = %d \n", abspath, strlen()
        strcat(abspath, "/");
        strcat(abspath,cmd);
        trim(abspath);
		//printf("absolute path is : %s \n", abspath);
        int filedesc = open(abspath, O_RDONLY);
		//printf("absolute path is%s, len = %d fd is %d \n", abspath, strlen(abspath),filedesc);
        if(filedesc >= 0)
        {
			//printf("getAbsolutePath absolute path is %s \n", abspath);
            close(filedesc);
			//printf("getAbsolutePath3 \n");
            return abspath;
        }
    }
	//printf("getAbsolutePath4 \n");
    return NULL;
}


char* tokenizeWithKey(char *inputString, char key, char **before)
{
    char *srcPtr = inputString;
    char *str = NULL;
    int count = 0;
    int found = 0;
    int len = strlen(inputString);
    str = srcPtr;
    while(*srcPtr != key && count < len)
    {
        srcPtr++;
        if(*srcPtr == key)
            found = 1;
        count++;
    }
    trim(str);
    len = strlen(str);
    if(len > 0)
    {
		//if(*before != NULL)
		//	memset(*before, 0, strlen(*before));
        *before=malloc(len);
		memset(*before, 0, len);
		//printf("tokenizeWithKey : %s : len = %d count = %d \n", *before, strlen(*before), count);
        strncpy(*before, str, count);
		/*if(strlen(*before) > count)
		{
			for(int i = count; i < strlen(*before); i++)
				*before[i] = '\0';
		}*/
		//printf("tokenizeWithKey :
    }
    srcPtr++;
    if(found == 1)
    {
        str = srcPtr;
        trim(str);
        return str;
    }
    return NULL;
}

void getPATH(char *envp[])
{
    //printf("environments are \n");
    while(*envp++)
    {
        if(strstr(*envp, "PATH") != NULL)
        {
            //contails path environment
            char token[MAX_LEN];
            strcpy(token, *envp);
            char *before;
            strcpy(path,tokenizeWithKey(token, '=',&before));
        }
    }
}

// void executeScript(){

// }

void executeProcess(char *envp[]){
	//printf("executeProcess \n");
    int pid;
    int status = 0;
    char cmd[MAX_LEN];
	//printf("executeProcess: Command is %s\n", commands[0][0]);
	
    if(handleCommand(commands[0][0], commands[0][1], envp) == 1)
        return;
	//printf("executeProcess calling getAbsolutePath \n");
    if(getAbsolutePath(commands[0][0],envp) != NULL)
    {
        strcpy(cmd, getAbsolutePath(commands[0][0],envp));
		//printf("executeProcess:: cmd is %s \n", cmd);
    }
    else
    {
        printf("%s: Command not found. \n", commands[0][0]);
        return;
    }
	
	//printf("executeProcess: before fork \n");
	//#if 0
    pid = fork();
    if(pid==0){
		//printf("in Child \n");
        // printf("executeProcess\n");
        // printf("%s\n",cmd );
        //printf("%s\n", commands[0][0]);
        if(execve(cmd,&commands[0][0],envp)==-1)
            // printf("error execute\n");
            serror(errno);
		//sleep(1);
		//printf("in Child 1\n");
        // perror("error");
        exit(1);
    }
	//printf("in parent \n");
/* 	if(commands[0][1]==NULL)
		printf("Argument is null \n");
	else
		printf("Arg not null \n"); */
/* 	printf("%s  %s\n", commands[0][0],commands[0][1]); */
	//printf("In Parent %d\n",pid); 
	if(commands[0][1]!=NULL){
		//printf("Argument is not null \n");
		if(strcmp(commands[0][1],"&")==0)
		{
			
		}
		else{
			//sleep(1);
			waitpid(pid,&status,0);
		}
	}
	else{
		//sleep(1);
		waitpid(pid,&status,0);
	}	

	/*if(backgroundprocess)
		//no need to wait
	else*/
    	//waitpid(pid,&status,0);
	//#endif
	//printf("after waitpid %d \n", status);
    commands[0][1] = NULL;
}

void executeProcessPipe(int n,char *envp[]){
	//printf("executeProcessPipe %d \n", n);
    char cmd[MAX_LEN];
    int fd[2];
    int pid=0,status;
    int found = 0, i;
    int prev=0;
    
    for(i=0;i<n;i++)
    {
        if(getAbsolutePath(commands[i][0],envp) == NULL)
        {
            printf("%s: Command not found. \n", commands[i][0]);
            found = 1;
        }
    }
    //printf("found absolute path \n");
	
    if(found)
        return;
    
    pid = fork();
    if(pid ==0)
    {
		//printf("in child \n");
		//while(1);
		//int pid2;
        for (i = 0; i < n-1; ++i)
        {
            pipe (fd);
            pid = fork();
			//printf("second fork \n");
			//while(1);
            if(pid==0)
            {
				//printf("first command %s \n", getAbsolutePath(commands[i][0],envp));
                if(prev != 0)
                {
                    dup2 (prev,0);
                    //close(prev);
                }
                if(fd[1] != 1)
                {
					//printf("shashi \n");
                    dup2(fd[1],1);
                    //close(fd[1]);
                }
				
                strcpy(cmd, getAbsolutePath(commands[i][0],envp));
				//printf("first command successfull %s \n",cmd);
                if(handleCommand(cmd, commands[i][1], envp) == 0)
                {
					//printf("Executing first command \n");
                    if(execve(cmd,&commands[i][0],envp)==-1)
                        // printf("error\n");
                        serror(errno);
                }
                exit(1);
            }
			//waitpid(pid2,&status,0);
            //close (fd [1]);
            prev= fd [0];
        }
		//waitpid(pid,&status,0);
        //sleep(1);
		if (prev != 0)
            dup2 (prev, 0);
        strcpy(cmd, getAbsolutePath(commands[i][0],envp));
		sleep(1);
		//printf("second command %s \n",cmd);
        if(handleCommand(cmd, commands[i][1], envp) == 0)
        {
            if(execve(cmd,&commands[i][0],envp)==-1)
                // printf("error\n");
                serror(errno);
        }
        exit(1);
    }
    waitpid(pid,&status,0);
	//listprocess();
	//printf("parent exit \n");
    for(i=0;i<n;i++)
    {
        commands[i][1] = NULL;
    }
}

void printEnvironments(char *envp[])
{
    printf("\n\n\n\n\n environments are \n");
    //while(*envp)
     //   printf("%s\n",*envp++);
     printf("%s\n",envp[0]);
}
#if 0
void printEnvironments(char *envp[])
{
   // printf("\n\n\n\n\n environments are \n");
    while(strcmp(*envp, "NULL") != 0)
     printf("%s\n",*envp++);
	
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
#endif

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

void trim(char *input)
{
    char *dst = input, *src = input;
    char *end;
    
    
    while (isSpace((unsigned char)*src))
    {
        ++src;
    }
    
    
    end = src + strlen(src) - 1;
    while (end > src && isSpace((unsigned char)*end))
    {
        *end-- = 0;
    }
    
    if (src != dst)
    {
        while ((*dst++ = *src++));
    }
}

int isSpace(char c)
{
    return (c == ' ' || c == '\t' || c == '\n' || c == '\12');
}

void welcome()
{
    printf("\n-------------------------------------------------\n");
    printf("\tWelcome to SBUSH \n");
    printf("-------------------------------------------------\n");
    printf("\n\n");
}
