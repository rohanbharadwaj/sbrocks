#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void testfork();
void testpipe();
void testExecve(char *envp[]);
void testchdir();
void getcwd1();
void testmalloc();
void fopentest();
	
int main(int argc, char* argv[], char* envp[]) {

	while(1)
	{
		printf("Enter 1 for open() and close() API test \n 2 for malloc() and free() API test \n 3 for pipe() api test \n 4 for chdir() API test \n 5 for cwd() API test \n 6 for execve() API test \n 7 for fork() API test \n 8 for exit  \n");
		int c;
		scanf("%d", &c);
		switch(c)
		{
			case 1:
				fopentest();
				break;
			case 2:
				testmalloc();
				break;
			case 3:
				testpipe();
				break;
			case 4:
				testchdir();
				break;
			case 5:
				getcwd1();
				break;
			case 6:
				testExecve(envp);
				break;
			case 7:
				testfork();
				break;
			case 8:
				exit(0);
			default:
				printf("Please enter valid option \n");
				break;					

		}
	}
	
	return 0;
}

void fopentest()
{
	printf("*********************************************\n");
	printf("testing  open() and close() API \n");
	char *name = malloc(12);
	strcpy(name, "/home/stufs1/sranjan/sbrocks/sbrocks_hw1_2/s15-w1/cse506-pubkey.txt"/*"abc"*/);
	int fd = open(name, O_RDONLY);
	//printf("fd no is %d error no is : %d \n", fd, errno);
	if(fd < 0)
		serror(errno);
	else
		printf("file open succesfull \n");
	int res = close(fd);
	if(res < 0)
		serror(errno);
	else
		printf("file close succesfull \n");
	printf("\n\n");
	//printf("res value is %d \n", res);
	
}

void testmalloc()
{
	printf("*********************************************\n");
	printf("testing  malloc() and free() API \n");
	char *c =(char*) malloc(10);
	strcpy(c, "shashi");
	
	printf("%s \n", c);

	char *d =(char*) malloc(10);
	//free(c);
	strcpy(d, "rajnjan");
	//printf("shashi \n");
	printf("%s \n", d);
	free(d);
	char *e =(char*) malloc(5);
	
	strcpy(e, "rohan");
	//printf("shashi \n");
	printf("%s \n", e);
	printf("malloc API succesfull \n");
	printf("free API open succesfull \n");
	printf("\n\n");
}

void testpipe()
{
	printf("*********************************************\n");
	printf("testing  pipe(), fork() and waitpid() API \n");
	int pipefd[2];
    int cpid;
    char buf;
  
    if (pipe(pipefd) == -1) {
        serror(errno);
        exit(1);
    }
    cpid = fork();
    if (cpid == -1) {
       // printf("fork");
    	serror(errno);
        //exit(1);
        return;
    }
    if (cpid == 0) {    /* Child reads from pipe */
      //  printf("child \n");
		close(pipefd[1]);          /* Close unused write end */
        while (read(pipefd[0], &buf, 1) > 0)
            write(1, &buf, 1);
        write(1, "\n", 1);
        close(pipefd[0]);
        //exit(0);
    } else {            /* Parent writes argv[1] to pipe */
        printf("parent \n");
		close(pipefd[0]);          /* Close unused read end */
        write(pipefd[1], "shashi", strlen("shashi"));
        close(pipefd[1]);          /* Reader will see EOF */
        waitpid(cpid, NULL, 0);                /* Wait for child */
        //exit(0);
    }
    printf("pipe() API succesfull \n");
	printf("fork() API open succesfull \n");
	printf("waitpid() API open succesfull \n");
	printf("\n\n");
}

void testchdir()
{
	printf("*********************************************\n");
	printf("testing  chdir() API \n");
	char *cmd = "/home/stufs1/sranjan/";
	if(chdir(cmd) < 0)
	{
		serror(errno);
		return;
		//printf("eoror in chanign dir \n");
	}
	printf("chdir() API open succesfull \n");
	printf("\n\n");
}

void getcwd1()
{
	printf("*********************************************\n");
	printf("testing  getcwd() API \n");
	char* cwd;
    char buff[1024];
	cwd = getcwd( buff, 1025 );
    if( cwd != NULL ) {
        printf( "My working directory is %s \n", buff );
    }
    else
    {
    	serror(errno);
    	return;
    }
    printf("getcwd() API open succesfull \n");
	printf("\n\n");
}

void testExecve(char *envp[])
{
	printf("*********************************************\n");
	printf("testing  execve() API \n");
	char *cmd = "/home/stufs1/sranjan/sbrocks/sbrocks_hw1_2/s15-w1/rootfs/bin/hello";
	if(execve(cmd, NULL, NULL) == -1)
	{
		serror(errno);
		return;
	}
	//printf("execve \n"); /* execve() only returns on error */
	//exit(1);
	printf("execve() API open succesfull \n");
	printf("\n\n");
}

void testfork()
{
	printf("*********************************************\n");
	printf("testing  fork() API \n");
	int pid = fork();
	if(pid == 0)
	{
		
		printf("I am in child \n");	
	}
	else
	{
		printf("I am in parent \n");	
	}
	if(pid <0)
	{
		serror(errno);
		return;
	}
	printf("fork() API open succesfull \n");
	printf("\n\n");
}


