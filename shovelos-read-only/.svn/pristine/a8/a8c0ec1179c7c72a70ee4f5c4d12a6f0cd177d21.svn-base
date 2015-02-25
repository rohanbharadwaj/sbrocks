

#ifndef __FS_FS_H
#define __FS_FS_H

#include "ext2/ext2.h"

sint32_t 	lstat(const char *path, struct stat *stat);
sint32_t 	 stat(const char *path, struct stat *stat);

FILE* 		fopen(const char *path);
void  		fclose(FILE   *file);
uint32_t	fseek(uint32_t pos, FILE *file);
uint32_t 	fread(void* dst, uint32_t size, uint32_t memb, FILE *file);

#endif /*** __FS_FS_H ***/

