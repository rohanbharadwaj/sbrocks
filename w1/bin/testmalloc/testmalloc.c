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
	/*char *c;
	c = malloc(12);
	scanf("%c", &c);
	int res = printf("read char is %c \n", c);*/
	//testfork();
	//testpipe();
	//testExecve(envp);
	//testchdir();
   	//getcwd1();
	//testmalloc();
	fopentest();
	return 0;
}

void fopentest()
{
	char *name = malloc(12);
	strcpy(name, "/home/stufs1/sranjan/sbrocks/sbrocks_hw1_2/s15-w1/cse506-pubkey.txt"/*"abc"*/);
	int fd = open(name, O_RDONLY);
	//printf("fd no is %d error no is : %d \n", fd, errno);
	if(fd < 0)
		serror(errno);
	int res = close(fd);
	if(res < 0)
		serror(errno);
	//printf("res value is %d \n", res);
	
}

void testmalloc()
{
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
	
}
void testpipe()
{
	int pipefd[2];
    int cpid;
    char buf;
  
    if (pipe(pipefd) == -1) {
        printf("pipe");
        exit(1);
    }
    cpid = fork();
    if (cpid == -1) {
       // printf("fork");
        exit(1);
    }
    if (cpid == 0) {    /* Child reads from pipe */
      //  printf("child \n");
		close(pipefd[1]);          /* Close unused write end */
        while (read(pipefd[0], &buf, 1) > 0)
            write(1, &buf, 1);
        write(1, "\n", 1);
        close(pipefd[0]);
        exit(0);
    } else {            /* Parent writes argv[1] to pipe */
        printf("parent \n");
		close(pipefd[0]);          /* Close unused read end */
        write(pipefd[1], "shashi", strlen("shashi"));
        close(pipefd[1]);          /* Reader will see EOF */
        waitpid(cpid, NULL, 0);                /* Wait for child */
        exit(0);
    }
}

void testchdir()
{
	char *cmd = "/home/stufs1/sranjan/";
	if(chdir(cmd) < 0)
		printf("eoror in chanign dir \n");
	
}

void getcwd1()
{
	char* cwd;
    char buff[1024];
	cwd = getcwd( buff, 1025 );
    if( cwd != NULL ) {
        printf( "My working directory is %s \n", buff );
    }
}

void testExecve(char *envp[])
{
	char *cmd = "/home/stufs1/sranjan/sbrocks/sbrocks_hw1_2/s15-w1/rootfs/bin/hello";
	execve(cmd, NULL, NULL);
	printf("execve \n"); /* execve() only returns on error */
	exit(1);
}

void testfork()
{
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
		printf("erro in fork \n");
}


