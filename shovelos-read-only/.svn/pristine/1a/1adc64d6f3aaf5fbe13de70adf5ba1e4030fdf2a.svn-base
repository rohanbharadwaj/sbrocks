
#include <16bitreal.h>
#include "bios_disk.h"
#include "mem.h"
#include "alloc.h"
#include "print.h"

/******************************************************************************************************
 *   extended_read_drive_parameters
 *     call bios extended read sectors function.
 *     takes 1) BIOS disk ( 0x80 for C:, etc )
 *           2) result buffer (struct ext_drive_param_buffer*) .
 *     returns 0 on success, non-zero on error.
 */
int extended_read_drive_parameters(unsigned char bios_drive, struct ext_drive_param_buffer* out) {

	int ret = 0;

	__asm__ __volatile__ (
			"movb   $0x48,  %%ah;   \n"
			"movb   %1,     %%dl;   \n"   // bios_drive
			"movw   %2,     %%si;	\n"   // output ptr
			"int    $0x13;          \n"   // call bios
			"xorl   %0,       %0;   \n"
			"jnc extended_read_drive_parameters.ret;\n"
			"movl   $1,       %0;   \n"
			"extended_read_drive_parameters.ret:\n"
		:	"=r" (ret)
		:	"m" (bios_drive), "m" (out)
		:	"eax", "edx", "esi"
	);

	return (ret);
}

/******************************************************************************************************
 *   extended_read_sectors_from_drive
 *     call bios extended read sectors function.
 *     takes 1) BIOS disk ( 0x80 for C:, etc )
 *           2) initialised disk address packet.
 *     returns 0 on success, non-zero on error.
 */
int extended_read_sectors_from_drive(unsigned char bios_drive, struct disk_address_packet *dap)
{
	int ret = 0;

	__asm__ __volatile__(
			"movb     %1,  %%dl;   \n"
			"movw     %2,  %%si;   \n"
			"movb  $0x42,  %%ah;   \n"
			"int   $0x13;          \n"
			"xorl     %0,    %0;   \n"
			"jnc extended_read_sectors_from_drive.ret;\n"
			"movl   $1,       %0;   \n"
			"extended_read_sectors_from_drive.ret:\n"
		:	"=r" (ret)
		:	"m" (bios_drive), "m" (dap)
		:	"edx", "esi", "eax"
	);

	return ret;
}

/****************************************************************************************************
 * bytes_per_sector
 *     query the number of bytes per sector. ( probably 512 )
 *     takes 1) bios drive
 *     returns bytes per sector, or zero on error.
 */
int bytes_per_sector(unsigned char bios_disk) {

	struct ext_drive_param_buffer edpb;
	memset(&edpb, 0, sizeof edpb);
	edpb.buffer_size = 0x1e;

	if(extended_read_drive_parameters(bios_disk, &edpb) != 0)
		return 0;

	return edpb.bytes_per_sector;
}

/******************************************************************************************************
 *  disk_read_sector
 *     call bios extended read sectors function.
 *     takes 1) BIOS disk ( 0x80 for C:, etc )
 *           2) initialised disk address packet.
 *           3) read to address ( 20bit address )
 *     returns 0 on success, non-zero on error.
 */
int disk_read_sector( unsigned char bios_drive, unsigned long long sector, void *dst ) {

	static struct disk_address_packet dap;
	int addr20 = (int)dst;

	dap.packet_size = 0x10;
	dap.reserved0 = dap.reserved1 = 0;
	dap.sectors = 1;
	dap.mem_addr.seg.segment = (addr20>>4) & 0xf000; // 20bit address
	dap.mem_addr.seg.offset =  (addr20   ) & 0xffff; // 20bit address (unsigned short)(int)dst;
	dap.disk_addr.sector = sector;

	return extended_read_sectors_from_drive(bios_drive, &dap);
}



/******************************************************************************************************
 *  disk_read
 *     read absolute disk address to given address
 *     takes 1) BIOS disk ( 0x80 for C:, etc )
 *           2) disk relative address in bytes
 *           3) read size in bytes
 *           4) read to address ( 20bit address  )
 *     returns 0 on success.
 */
int disk_read( struct disk* disk, unsigned long long abs_address, unsigned short abs_size, void* dst) {

	int ret;

	while(abs_size) {

		unsigned long long sector = abs_address / disk->sector_bytes;
		unsigned short offset     = abs_address % disk->sector_bytes;
		unsigned short thisread   = disk->sector_bytes - offset;

		if(thisread > abs_size)
			thisread = abs_size;

		if(offset || (thisread != disk->sector_bytes)) {

			// not reading a whole sector, read to the disk buffer!

			static void* disk_buffer = NULL;
			static int   disk_buffer_size = 0;

			if(disk->sector_bytes > disk_buffer_size) {
				disk_buffer_size = disk->sector_bytes;
				disk_buffer      = alloc_high(disk_buffer_size);
			}

			if((ret = disk_read_sector( disk->bios_drive, sector, disk_buffer )) != 0)
				halt("disk read error!");

			memcpy(dst, (void*)(disk_buffer + offset), thisread);
		}
		else {
			// reading exactly one sector, let the bios write directly to destination.
			if((ret = disk_read_sector( disk->bios_drive, sector, dst )) != 0)
				return ret;
		}

		abs_address += thisread;
		abs_size    -= thisread;
		dst         += thisread;
	}
	return 0;
}

/******************************************************************************************************
 *  partition_read
 *     read absolute partition address to given address
 *     takes 1) opened partition struct.
 *           2) partition relative address in bytes
 *           3) read size in bytes
 *           4) read to address ( 20bit address  )
 *     returns 0 on success, non-zero on error.
 */
int partition_read( struct partition *part, unsigned long long abs_address, unsigned short abs_size, void* dst) {

	return disk_read(part->disk,abs_address + part->disk->sector_bytes * part->start_sector, abs_size, dst);
}

/******************************************************************************************************
 *  open_disk
 *     create a disk structure
 *     takes 1) bios disk code.
 *     returns zero filled struct on error.
 */
struct disk open_disk(uint8_t bios_disk) {

    struct disk d;

    memset(&d,0,sizeof d);

    d.sector_bytes = bytes_per_sector(bios_disk);

    if(d.sector_bytes)
    	d.bios_drive = bios_disk; // TODO: better way to detect disk presence?

    return d;
}

/******************************************************************************************************
 *  open_partition
 *     create a partition structure
 *     takes 1) opened disk structure
 *           2) partition number
 *     returns zero filled struct on error.
 */
struct partition open_partition(struct disk* disk, uint8_t pnum) {

	uint16_t part_base;
	struct partition p;
	memset(&p,0,sizeof p);

	part_base = 0x01BE + pnum * 0x10;

	p.disk = disk;
	disk_read(disk,  8 + part_base, 4,&(p.start_sector));
	disk_read(disk, 12 + part_base, 4,&(p.sectors));

	return p;
}


