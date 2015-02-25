/*
 * ext2.c
 *
 *  Created on: Nov 6, 2010
 *      Author: cds
 */

#include <16bitreal.h>
#include "../../inttypes.h"
#include <disk/disk.h>
#include "../../mem.h"
#include "../../print.h"
#include "../../pt.h"
#include "ext2.h"
#include <alloc.h>

#define EXT2_ROOT_INODE					  2

/****************************************************************************************/
/********************** SUPERBLOCK FIELD OFFSETS / SIZES ********************************/
/****************************************************************************************/
#define EXT2_SUPERBLOCK_OFFSET 			1024
#define EXT2_SUPERBLOCK_SIZE   			1024
#define EXT2_SB_INODES_OFFSET	    	   0		/*** total i-nodes ***/
#define EXT2_SB_INODES_SIZE	     		   4
#define EXT2_SB_BLOCKS_OFFSET	    	   4		/*** total blocks ***/
#define EXT2_SB_BLOCKS_SIZE	     		   4
#define EXT2_SB_BLOCK0_OFFSET             20        /*** block number of first superblock ***/
#define EXT2_SB_BLOCK0_SIZE                4
#define EXT2_SB_BS_OFFSET       		  24		/*** log2(block_size)-10 ***/
#define EXT2_SB_BS_SIZE          		   4
#define EXT2_SB_BPG_OFFSET      		  32		/*** blocks per group ***/
#define EXT2_SB_BPG_SIZE         		   4
#define EXT2_SB_IPG_OFFSET      		  40		/*** i-nodes per group ***/
#define EXT2_SB_IPG_SIZE         		   4
#define EXT2_SB_SIG_OFFSET	    		  56		/*** SUPERBLOCK MAGIC ***/
#define EXT2_SB_SIG_SIZE	     		   2
#define EXT2_SB_SIG_VALUE			  0xEF53
#define EXT2_SB_MAJVER_OFFSET             76		/*** ext2 major version ***/
#define EXT2_SB_MAJVER_SIZE                4
/*** ext2 version 1.0 and above ***/
#define EXT2_SB_INODE_SIZE_OFFSET         88		/*** inode structure size***/
#define EXT2_SB_INODE_SIZE_SIZE            2


/****************************************************************************************/
/******************* GROUP DESCRIPTOR FIELD OFFSETS / SIZES *****************************/
/****************************************************************************************/

#define EXT2_GD_INO_TBL_OFFSET			   8		/*** starting block address of i-node table ***/
#define EXT2_GD_INO_TBL_SIZE			   4

/****************************************************************************************/
/************************ INODE FIELD OFFSETS / SIZES ***********************************/
/****************************************************************************************/

#define EXT2_IN_MODE_OFFSET				   0		/*** INODE MODE ***/
#define EXT2_IN_MODE_SIZE				   2
#define EXT2_IN_SIZE_OFFSET				   4		/*** FILE SIZE IN BYTES ***/
#define EXT2_IN_SIZE_SIZE				   4
#define EXT2_IN_DIRECT_PTR		          40		/*** pointers to direct blocks, array of 12 ***/
#define EXT2_IN_INDIRECT_PTR		      88		/*** pointers to indirect blocks ***/
#define EXT2_IN_INDIRECT2_PTR		      92		/*** pointers to double indirect blocks ***/
#define EXT2_IN_INDIRECT3_PTR		      96		/*** pointers to triple indirect blocks ***/
#define EXT2_IN_PTR_SIZE			       4
#define EXT2_IN_PTR_ARRAY_LEN		      12

/****************************************************************************************/
/********************** DIRECTORY FIELD OFFSETS / SIZES *********************************/
/****************************************************************************************/

#define EXT2_DR_INODE_OFFSET			   0
#define EXT2_DR_INODE_SIZE				   4
#define EXT2_DR_RECLEN_OFFSET			   4
#define EXT2_DR_RECLEN_SIZE				   2
#define EXT2_DR_NAMLEN_OFFSET			   6
#define EXT2_DR_NAMLEN_SIZE				   1

static struct disk disk;
static struct partition partition;

struct superblock {
	int block_size;
	int total_inodes;
	int total_blocks;
	int blocks_per_group;
	int inodes_per_block_group;
	uint16_t inode_size;
	uint32_t block0;
} superblock ;

struct dirent {
	uint32_t inode;
	uint16_t size;
	uint8_t  name_length;
	uint8_t  _padding;    /*** Ignoring these fields as they depend of feature flags. ***/
	char     name[256];
} dirent;

static void parse_superblock();
void ext2_shuffle_hi();

int fs_init() {

	disk = open_disk(_root_disk);
	partition = open_partition(&disk, _root_part);

    int magic = 0;

    partition_read(&partition, EXT2_SUPERBLOCK_OFFSET + EXT2_SB_SIG_OFFSET, EXT2_SB_SIG_SIZE, &magic);

    if(magic != EXT2_SB_SIG_VALUE)
        halt("cannot find ext2 formatted boot partition");

    parse_superblock();

    ext2_shuffle_hi();

    return 0; // SUCCESS
}

/********************************************************************************
 * parse_superblock
 *   read needed fields from superblock
 */
void parse_superblock() {

	uint32_t version_major = 0;

	partition_read(&partition,EXT2_SUPERBLOCK_OFFSET + EXT2_SB_MAJVER_OFFSET, EXT2_SB_MAJVER_SIZE, &version_major);
	partition_read(&partition,EXT2_SUPERBLOCK_OFFSET + EXT2_SB_INODES_OFFSET, EXT2_SB_INODES_SIZE, &superblock.total_inodes);
	partition_read(&partition,EXT2_SUPERBLOCK_OFFSET + EXT2_SB_BLOCKS_OFFSET, EXT2_SB_BLOCKS_SIZE, &superblock.total_blocks);
	partition_read(&partition,EXT2_SUPERBLOCK_OFFSET + EXT2_SB_BPG_OFFSET,    EXT2_SB_BPG_SIZE,    &superblock.blocks_per_group);
	partition_read(&partition,EXT2_SUPERBLOCK_OFFSET + EXT2_SB_IPG_OFFSET,    EXT2_SB_IPG_SIZE,    &superblock.inodes_per_block_group);
	partition_read(&partition,EXT2_SUPERBLOCK_OFFSET + EXT2_SB_BLOCK0_OFFSET, EXT2_SB_BLOCK0_SIZE, &superblock.block0 );

	partition_read(&partition,EXT2_SUPERBLOCK_OFFSET + EXT2_SB_BS_OFFSET,     EXT2_SB_BS_SIZE,     &superblock.block_size );
	superblock.block_size = 1024 << superblock.block_size;

	superblock.inode_size = 128; // fixed in version < 1.0
	if(version_major >= 1)
		partition_read(&partition,EXT2_SUPERBLOCK_OFFSET + EXT2_SB_INODE_SIZE_OFFSET, EXT2_SB_INODE_SIZE_SIZE, &superblock.inode_size );

}

/*** read an ext2 block ***/
void read_block(uint32_t block, void* dst) {

	partition_read(&partition, block * superblock.block_size, superblock.block_size, dst );
}

/*** find the blockgroup containing the given inode ***/
uint32_t inode_to_blockgroup(uint32_t inode) {

	return (inode-1) / superblock.inodes_per_block_group;
}

/*** find inode table block address from blockgroup ***/
uint32_t blockgroup_to_inode_table(uint32_t blockgroup) {

	int ret = 0;
	int gd_addr = (superblock.block0 + 1) * superblock.block_size + blockgroup * 32;

    partition_read(&partition, gd_addr + EXT2_GD_INO_TBL_OFFSET, EXT2_GD_INO_TBL_SIZE, &ret);

	return ret;
}

/*** find an inodes index within a blockgroup ***/
uint32_t inode_to_blockgroup_index(uint32_t inode) {

	return (inode-1) % superblock.inodes_per_block_group;
}

/*** get an inodes on disk address (partition relative) ***/
uint64_t get_inode_phy_addr64(uint32_t inode) {

	uint64_t block  = blockgroup_to_inode_table(  inode_to_blockgroup(inode) );
	uint64_t inodeidx = inode_to_blockgroup_index(inode);
	uint64_t inodesize = superblock.inode_size;
	uint64_t blocksize = superblock.block_size;

	return block * blocksize + inodeidx * inodesize;
}

void ext2_read_block(uint32_t block, uint16_t offset, uint16_t size, void *dst) {

	uint64_t addr64  = block;
	         addr64 *= superblock.block_size;
	         addr64 += offset;

	partition_read(&partition, addr64, size, dst);

	return;
}

uint32_t ext2_read_block_32(uint32_t block, uint16_t offset) {

	uint32_t ret = 0;

	ext2_read_block(block, offset, sizeof ret, &ret);

	return ret;
}

uint32_t ext2_read_phy_32(uint64_t addr64) {

	uint32_t ret = 0;

	partition_read(&partition, addr64, sizeof ret, &ret);

	return ret;
}

uint16_t ext2_read_phy_16(uint64_t addr64) {

	uint16_t ret = 0;

	partition_read(&partition, addr64, sizeof ret, &ret);

	return ret;
}

void ext2_read_fast_symlink(uint32_t inode, uint8_t len, void* dst) {

	partition_read(&partition, get_inode_phy_addr64(inode) + EXT2_IN_DIRECT_PTR, len, dst);
}

uint32_t ext2_filesize(uint32_t inode) {

	return ext2_read_phy_32(get_inode_phy_addr64(inode) + EXT2_IN_SIZE_OFFSET);
}

uint32_t ext2_get_mode(uint32_t inode) {

	return ext2_read_phy_16(get_inode_phy_addr64(inode) + EXT2_IN_MODE_OFFSET);
}

uint32_t ext2_isdir(uint32_t inode) {

	return (ext2_get_mode(inode) & 0xF000) == S_IFDIR;
}

uint32_t ext2_isreg(uint32_t inode) {

	return (ext2_get_mode(inode) & 0xF000) == S_IFREG;
}

uint32_t ext2_issym(uint32_t inode) {

	return (ext2_get_mode(inode) & 0xF000) == S_IFSYM;
}

void read_inode_block(uint32_t inode, uint32_t block, uint32_t offset, uint16_t size, void* dst) {

	uint64_t direct0 = 12;
	uint64_t indirect1 = (superblock.block_size/4);
	uint64_t indirect2 = indirect1 * indirect1;
	uint64_t indirect3 = indirect1 * indirect2;
	uint64_t phy = get_inode_phy_addr64(inode);

	if(block < direct0) {

		uint32_t blk = ext2_read_phy_32(phy + EXT2_IN_DIRECT_PTR + block * 4);

		partition_read(&partition, (uint64_t)blk * superblock.block_size + offset, size, dst);

		return;
	}

	block -= 12;

	if(block < indirect1) {

		uint32_t blk = ext2_read_phy_32  (phy + EXT2_IN_INDIRECT_PTR);
		         blk = ext2_read_block_32(blk, block * 4);

		partition_read(&partition, (uint64_t)blk * superblock.block_size + offset, size, dst );

		return;
	}
	block -= indirect1;


	if(block < indirect2) {

		uint32_t blk = ext2_read_phy_32  (phy + EXT2_IN_INDIRECT2_PTR);
		         blk = ext2_read_block_32(blk, (block / indirect1) * 4); block %= indirect1;
		         blk = ext2_read_block_32(blk, (block            ) * 4);

		partition_read(&partition, (uint64_t)blk * superblock.block_size + offset, size, dst );

		return;
	}
	block -= indirect2;

	if(block < indirect3) {

		uint32_t blk = ext2_read_phy_32  (phy + EXT2_IN_INDIRECT2_PTR);
				 blk = ext2_read_block_32(blk, (block / indirect3) * 4);  block %= indirect3;
				 blk = ext2_read_block_32(blk, (block / indirect2) * 4);  block %= indirect2;
				 blk = ext2_read_block_32(blk, (block            ) * 4);

		partition_read(&partition, (uint64_t)blk * superblock.block_size + offset, size, dst );

		return;
	}
	halt("read_inode_block - overflow");
}

void read_inode(uint32_t inode, uint32_t offset, uint16_t size, void* dst) {

	uint32_t block = offset / superblock.block_size;
	uint32_t off   = offset % superblock.block_size;
	uint8_t* dst8  = (uint8_t*)dst;

	while(size>0) {

		uint16_t thissize = (size <= (superblock.block_size - off)) ? size : (superblock.block_size - off) ;

		read_inode_block(inode,block,off,thissize,dst8);

		off    = 0;
		block += 1;
		dst8  += thissize;
		size  -= thissize;
	}
}

// read the current inode name from path to name, and move path ptr to next inode.
// return 0 on success.
int next_inode_name(char **_path, char *name) {

	char *path = *_path;

	while(peek8(path) == '/')
		++path;

	int i;
	for(i=0; peek8(path+i) && (peek8(path+i) != '/'); ++i)
		poke8(name+i, peek8(path+i));

	poke8(name+i,0);

	*_path = path+i;

	if(i)
		return 0;

	return 1;
}


static sint32_t _stat(const char *_path, struct stat *stat, int lstat_mode) {

	// allocate some memory
	static char *path_buffer = NULL;
	static char *file_buffer = NULL;
	if(!path_buffer) {
		path_buffer = alloc_high(0x1000);
		file_buffer = alloc_high(0x0100);
	}

	char *path = path_buffer;

	// working copy of full path.
	memcpy(path_buffer, _path, strlen(_path)+1);

	// starting at root.
	stat->st_ino  = EXT2_ROOT_INODE;
	stat->st_size = ext2_filesize(stat->st_ino);
	stat->st_mode = ext2_get_mode(stat->st_ino);

	while( next_inode_name( &path, file_buffer ) == 0) {

		uint32_t offset = 0;

		int found_flag = 0;

		while(offset < stat->st_size) {

			read_inode(stat->st_ino,offset,sizeof dirent, &dirent);
			dirent.name[dirent.name_length] = '\0';
			offset += dirent.size;

			if(strcmp(dirent.name, file_buffer) == 0) {

				/* found it */
				found_flag = 1;
				struct stat parent = *stat;
				stat->st_ino = dirent.inode;
				stat->st_size = ext2_filesize(stat->st_ino);
				stat->st_mode = ext2_get_mode(stat->st_ino);

				if((stat->st_mode & 0xF000) == S_IFSYM)
				{
					/*** found a symbolic link ***/

					if(!peek8(path) && lstat_mode)
						return 0; // stat terminal links in lstat mode.

					// make space for sym-link in path buffer.
					memmove(path_buffer+stat->st_size,path,strlen(path)+1);

					if(stat->st_size <= 60)
						ext2_read_fast_symlink(stat->st_ino, stat->st_size, path_buffer);
					else
						read_inode(stat->st_ino, 0, stat->st_size, path_buffer);

					// keep searching.
					path = path_buffer;
					*stat = parent;

					break;
				}
				else if((stat->st_mode & 0xF000) == S_IFREG) {

					// found a file
					if(!peek8(path))
						return 0; // reached end of path! success

					return -1; // cannot cd into a file.
				}
				else if((stat->st_mode & 0xF000) == S_IFDIR) {

					// found a directory
					if(!peek8(path))
						return 0; // reached end of path! success!

					break;
				}
				else
					halt("ext2 fs error, unknown mode");
			}
		}
		if(!found_flag)
			return -1;
	}
	return -1;
}

sint32_t stat(const char *_path, struct stat *stat) {

	return _stat(_path, stat, 0);
}

sint32_t lstat(const char *_path, struct stat *stat) {

	return _stat(_path, stat, 1);
}

static FILE _FILE = {{0,0,0},0};

FILE* fopen(const char *path) {

	if(_FILE.stat.st_ino)
		halt("FIXME: can only have one file open at a time");

	if(stat(path, &_FILE.stat))
		return NULL; // no i-node

	if((_FILE.stat.st_mode & S_IFREG) == 0)
		return NULL; // not a file

	_FILE.pos = 0;

	return &_FILE;
}

void fclose(FILE   *file) {

	memset(&_FILE,0,sizeof _FILE);
}

uint32_t fread(void* dst, uint32_t size, uint32_t memb, FILE *file) {

	uint32_t ret = memb;

	if(file->pos >= file->stat.st_size)
		return 0;

	if((file->pos + size * memb) > file->stat.st_size)
		ret = (file->stat.st_size - file->pos) / size;

	read_inode( file->stat.st_ino,
				file->pos,
				size * ret,
				dst );

	file->pos += ret * size;

	return ret;
}

void shuffle_high();

void ext2_shuffle_hi() {

	FILE *kernel = fopen("/boot/shovelos.kernel");

	if(!kernel)
		halt("file not found: \"/boot/shovelos.kernel\"");

	uint64_t dst   = 0xFFFFFFFF80000000;

	/*** setup page tables, identity map lower memory,
	     and allocate enough hi-memory for kernel ***/
	setup_pt( kernel->stat.st_size );

	{
		static void* block_buffer = NULL;
		static int   block_buffer_size = 0;

		if(superblock.block_size > block_buffer_size) {
			block_buffer_size = superblock.block_size;
			block_buffer      = alloc_high(block_buffer_size);
		}

		for(;;) {

			int bytes_read = fread(block_buffer, 1, block_buffer_size, kernel);

			poke64(ADHOC_COMM+0x00, dst);
			poke64(ADHOC_COMM+0x08, (int)block_buffer);
			poke64(ADHOC_COMM+0x10, bytes_read);
			poke64(ADHOC_COMM+0x18, 0);

			shuffle_high();

			if(bytes_read < block_buffer_size)
				break;

			dst   += bytes_read;
		}
	}
}


