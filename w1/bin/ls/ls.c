#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char* argv[], char* envp[]) {
        //int i = 10;
	//char cwd[1024];
	char* cwd;
    char buff[1024];

    cwd = getcwd( buff, 1025 );
    if( cwd != NULL ) {
        printf( "My working directory is %s \n", buff );
    }
//	buff = "shashi";
    //return EXIT_SUCCESS;
	#if 0
	char str[100];
	strcpy(str,getcwd(NULL, 0));
	if (str != NULL)
	{
		printf("current working directory is %s \n", str);
	}
        //printf("Hello World  %d !\n", i);
        #endif
	return 0;
}
