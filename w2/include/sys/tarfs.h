#ifndef _TARFS_H
#define _TARFS_H

#include <sys/sbunix.h>
#include <sys/mmu/kmalloc.h>
#define TYPE_FILE 0
#define TYPE_DIRECTORY 5
void initialize_tarfs();
int fopen(char *name);
void fclose(uint64_t fd);
int fread(uint64_t fd,char* buf,uint64_t nbytes);
uint64_t fwrite(uint64_t fd, char *buf, uint64_t nbytes);
uint64_t find_offset_for_file(char *fname);
struct file *dopen(uint64_t fd, uint64_t buf);
struct file *dread(struct file* f);
void print_files();
void set_cwd(char *);
char* get_cwd();
uint64_t get_fdcount();
void set_fdcount(uint64_t c);
uint64_t fseek(uint64_t fd,uint64_t offset,uint64_t whence);
//current working directory
char cwd[1024];// = "rootfs/";


extern char _binary_tarfs_start;
extern char _binary_tarfs_end;

struct posix_header_ustar {
	char name[100];
	char mode[8];
	char uid[8];
	char gid[8];
	char size[12];
	char mtime[12];
	char checksum[8];
	char typeflag[1];
	char linkname[100];
	char magic[6];
	char version[2];
	char uname[32];
	char gname[32];
	char devmajor[8];
	char devminor[8];
	char prefix[155];
	char pad[12];
};

struct file
{
	char name[1024];
	uint64_t fd;
	uint64_t addr;
	uint64_t type;
	uint64_t size;
	uint64_t offset;
	struct file *next;
};

#endif
