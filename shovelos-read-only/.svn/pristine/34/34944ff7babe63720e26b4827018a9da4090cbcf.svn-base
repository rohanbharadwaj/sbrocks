
#ifndef __BIOS_DISK_H
#define __BIOS_DISK_H

#include "inttypes.h"

/****************************************************************************************************
 * DISK ADDRESS PACKET - for use with bios function INT 13h, AH=42h
 */
struct disk_address_packet {

	unsigned char packet_size;        // 0x10
	unsigned char reserved0;
	char          sectors;            // number of sectors to access
	unsigned char reserved1;
	union {
		unsigned int address;
		struct {
			unsigned short offset;    // memory offset to access
			unsigned short segment;   // memory segment to access
		} seg;
	} mem_addr;
	union {
		unsigned long long sector;    // absolute first sector
		struct {
			unsigned int lower;       // absolute first sector least sig dword
			unsigned int upper;       // absolute first sector most  sig dword
		} sec32;
	} disk_addr;
};

/******************************************************************************************************
 * EXTENDED DRIVE INFO BUFFER - for use with bios function INT 13h, AH=48h
 */
struct ext_drive_param_buffer {

	unsigned short         buffer_size;
	unsigned short         info_flags;
	unsigned int           phy_cylinders;
	unsigned int           phy_heads;
	unsigned int           phy_sectors_per_track;
	unsigned long long int abs_number_of_sectors;
	unsigned short         bytes_per_sector;
	unsigned int           edd_ptr;
};

struct disk {

	uint8_t  bios_drive;
	uint16_t sector_bytes;

} __attribute__((packed)) ;

struct partition {

	struct disk* disk;
	uint32_t     start_sector;
	uint32_t     sectors;

} __attribute__((packed)) ;

/********************************************************************************
 * Allocate a disk structure.
 *   takes 1) bios disk code. (0x80)
 *   returns non-empty struct on success
 */
struct disk open_disk(uint8_t bios_disk);

/********************************************************************************
 * Allocate a partition structure.
 *   takes 1) ptr to an open disk struct
 *         2) partition number to open
 *   returns: non-zero sized partition on success.
 */
struct partition open_partition(struct disk* disk, uint8_t pnum);


/********************************************************************************
 * raw disk read
 *   takes 1) ptr to an open disk struct
 *         2) address from start of disk in bytes
 *         3) size in bytes
 *         4) destination
 *   returns: zero on success
 */
int disk_read( struct disk *disk, unsigned long long abs_address, unsigned short abs_size, void* dst);

/********************************************************************************
 * raw partition read
 *   takes 1) ptr to an open partition struct.
 *         2) address from start of partition in bytes
 *         3) size in bytes
 *         4) destination
 *   returns: zero on success
 */
int partition_read( struct partition *part, unsigned long long abs_address, unsigned short abs_size, void* dst);

extern short _root_disk; /*** Declared  in link script, default root disk. set by installer ***/
extern int   _root_part; /*** Declared  in link script, default root partition. set by installer ***/

#endif /*** __BIOS_DISK_H ***/

