#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//#define NAME_MAX 255

void showFiles();
#if 0
/*structure taken from linux code */
/* structure describing an open directory. */
typedef struct {
        int     __dd_fd;        /* file descriptor associated with directory */
        long    __dd_loc;       /* offset in current buffer */
        long    __dd_size;      /* amount of data returned */
        char    *__dd_buf;      /* data buffer */
        int     __dd_len;       /* size of data buffer */
        long    __dd_seek;      /* magic cookie returned */
        long    __dd_rewind;    /* magic cookie for rewinding */
        int     __dd_flags;     /* flags for readdir */
       /* __darwin_pthread_mutex_t __dd_lock; *//* for thread locking */
        struct _telldir *__dd_td; /* telldir position recording */
} DIR;
#endif
int main(int argc, char* argv[], char* envp[]) {
        //int i = 10;
	//char cwd[1024];
	/*char* cwd;
    char buff[1024];

    cwd = getcwd( buff, 1025 );
    if( cwd != NULL ) {
        printf( "My working directory is %s \n", buff );
    }*/
	showFiles();

	return 0;
}

void showFiles()
{
	char *buf = malloc(NAME_MAX);
	getcwd( buf, NAME_MAX+1);
    //printf( "My working directory is %s \n", buf );
	struct dir *dip;
	struct dirent *dit;
	dip = (struct dir *)opendir(buf);
	//printf("open dir successfull \n");
	if(dip == NULL)
	{
		printf("Error in opening directory \n");	
		return;
	}
	printf("dir name is %s \n", dip->d_name);
	struct dirent *d = (struct dirent *)dip->addr;
	printf("%s \n", d->d_name);
	//printf("dir name is %s \n", dip->d_name);
	
	dit = readdir(dip->addr);
	//printf("read dir successfull %s \n", dit->d_name);
	while(dit != NULL)
	{
		printf("%s \n", dit->d_name);	
		//printf("reclen %d \n", dit->d_reclen);
		dit = readdir(dit);
	}
	printf("\n");
	
	if(closedir(dip) == -1)
	{
		printf("Error in closing directory \n");
		return;
	}
}
