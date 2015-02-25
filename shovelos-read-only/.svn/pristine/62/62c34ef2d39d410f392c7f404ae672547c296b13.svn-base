/*
 * ext2.h
 *
 *  Created on: Nov 6, 2010
 *      Author: cds
 */

#ifndef __STAGE_1_5_FS_EXT2_EXT2_H
#define __STAGE_1_5_FS_EXT2_EXT2_H

#include <inttypes.h>

int fs_init();

struct stat {
	uint32_t st_ino;
	uint32_t st_size;
	uint32_t st_mode;
};

typedef struct {

	struct stat stat;
	uint32_t pos;

} FILE;

#define S_IFREG	0x8000	/* regular file */
#define S_IFDIR	0x4000	/* directory */
#define S_IFSYM 0xA000  /* symbolic link */

#endif /* __STAGE_1_5_FS_EXT2_EXT2_H */

