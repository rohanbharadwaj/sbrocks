#include <sys/tarfs.h>
#include <sys/kstring.h>

uint64_t find_offset_for_file(char *fname)
{
	struct posix_header_ustar *ustart;
	//uint64_t count = 0;
	ustart = (struct posix_header_ustar *)(&_binary_tarfs_start);
	//count++;
	uint64_t offset = 0;
	while(strlen(ustart->name) != 0)
	{
		uint64_t size = octal_to_decimal(atoi(ustart->size));
		//kprintf("binary name is %s \n",ustart->name);
		//kprintf("binary size is %d \n",size);
		//uint64_t align = 0;
		/*if(size != 0)
			align = (size%512==0) ? size : size + (512 - size%512);
		offset = offset+ 512 + align;
		*/
		if(kstrcmp(ustart->name, fname) == 0)
		{
			//kprintf("matched %d \n", offset);
			return offset + 512;
		}
		uint64_t align = 0;
		if(size != 0)
			align = (size%512==0) ? size : size + (512 - size%512);
		offset = offset+ 512 + align;
		ustart = (struct posix_header_ustar *)(&_binary_tarfs_start + offset);
		//count++;
	}
	return 0;	
}

void initialize_tarfs()
{
	clrscr();
	kprintf("_binary_tarfs_start address is %p and %x \n", &_binary_tarfs_start, &_binary_tarfs_start);
	//uint64_t t = &_binary_tarfs_start;
	uint64_t count = 0;
	struct posix_header_ustar *ustart;
	//uint64_t end = 0;
	//while(end < (uint64_t)&_binary_tarfs_end)
	ustart = (struct posix_header_ustar *)(&_binary_tarfs_start + count*512);
	count++;
	//while(strlen(ustart->name) != 0)
	while(count < 3)
	{
		//mend = (uint64_t)&_binary_tarfs_start + count*512;
		if(count == 2)
			{
			kprintf("binary name is %s \n",ustart->name);
			kprintf("binary mode is %s \n",ustart->mode);
			kprintf("binary uid is %s \n",ustart->uid);
			kprintf("binary gid is %s \n",ustart->gid);
			//char * s = "123";
			kprintf("binary size is %d \n",octal_to_decimal(atoi(ustart->size)));
			kprintf("binary mtime is %s \n",ustart->mtime);
			kprintf("binary checksum is %s \n",ustart->checksum);		
			kprintf("binary typeflag is %s \n",ustart->typeflag);		
			kprintf("binary linkname is %s \n",ustart->linkname);		
			kprintf("binary magic is %s \n",ustart->magic);		
			kprintf("binary version is %s \n",ustart->version);	
			kprintf("binary uname is %s \n",ustart->uname);
			kprintf("gname gid is %s \n",ustart->gname);
			kprintf("binary devmajor is %s \n",ustart->devmajor);
			kprintf("binary devminor is %s \n",ustart->devminor);
			kprintf("binary prefix is %s \n",ustart->prefix);
			kprintf("binary pad is %s \n",ustart->pad);
			
		}
		ustart = (struct posix_header_ustar *)(&_binary_tarfs_start + count*512);
		count++;
		//t = t + 512;
		//ustart = (struct posix_header_ustar *)t;
	}
}