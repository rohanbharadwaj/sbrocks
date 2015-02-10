
#define _GNU_SOURCE
       #include <dirent.h>     /* Defines DT_* constants */
       #include <fcntl.h>
       #include <stdio.h>
       #include <unistd.h>
       #include <stdlib.h>
       #include <sys/stat.h>
       #include <sys/syscall.h>

       #define handle_error(msg) \
               do { perror(msg); exit(EXIT_FAILURE); } while (0)

       struct linux_dirent {
           long           d_ino;
           off_t          d_off;
           unsigned short d_reclen;
           char           d_name[];
       };

       #define BUF_SIZE 1024

       int
       main(int argc, char *argv[])
       {
           int fd, nread;
           char buf[BUF_SIZE];
           struct linux_dirent *d = NULL;
           int bpos;
           char d_type;

           fd = open(argc > 1 ? argv[1] : ".", O_RDONLY | O_DIRECTORY);
           if (fd == -1)
               handle_error("open");

         //  for ( ; ; ) {
               nread = syscall(SYS_getdents, fd, buf, BUF_SIZE);
               if (nread == -1)
                   handle_error("getdents");
			void *addr = (void *)buf;
               /*if (nread == 0)
                   break;
*/
               printf("--------------- nread=%d ---------------\n", nread);
               printf("inode#    file type  d_reclen  d_off   d_name\n");
               //for (bpos = 0; bpos < nread;) {
		   int i = 0;
                  for (; i<14; i++) {
					  if(d == NULL)
                   d = (struct linux_dirent *)(addr);
					  else
						  d = (struct linux_dirent *)(addr + d->d_reclen);
                   printf("%8ld  ", d->d_ino);
                   /*d_type = *(buf + bpos + d->d_reclen - 1);
                   printf("%-10s ", (d_type == DT_REG) ?  "regular" :
                                    (d_type == DT_DIR) ?  "directory" :
                                    (d_type == DT_FIFO) ? "FIFO" :
                                    (d_type == DT_SOCK) ? "socket" :
                                    (d_type == DT_LNK) ?  "symlink" :
                                    (d_type == DT_BLK) ?  "block dev" :
                                    (d_type == DT_CHR) ?  "char dev" : "???");*/
                   printf("%4d %10lld  %s\n", d->d_reclen,
                           (long long) d->d_off, d->d_name);
                   //bpos += d->d_reclen;
				   addr = d;
               }
         //  }

           exit(EXIT_SUCCESS);
       }

#if 0
#include<stdio.h>
#include<sys/types.h>
#include<dirent.h>
#include<errno.h>

int main(int argc,char *argv[])
{

	printf("argc : %d \n",argc);
	DIR* dip;
	struct dirent *dit;
	int i = 0;
	if(argc<2)
	{
		printf("yo enter arg");
		return 0;
	}
	if((dip = opendir(argv[1]))==NULL)
	{
	perror("openddir");
	return 0;
	}
	while((dit = readdir(dip))!=NULL)
	{
		i++;
		printf("Name : %s , Inode : %d\n",dit->d_name,dit->d_ino);
	}
	if(closedir(dip)==-1)
	{
		perror("closedir");
		return 0;
	}
	return 1;
}
#endif
