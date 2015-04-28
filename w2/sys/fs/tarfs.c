#include <sys/tarfs.h>
#include <sys/kstring.h>
int fd_count = 2;
struct file *filelist;
void print_files();
void add_to_filelist(struct file *f);

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

void print_files()
{
	//clrscr();
	if(filelist == NULL)
	{
		return;
	}
	struct file *t = filelist;
	while(t != NULL)
	{
		kprintf("name: %s \t", t->name);
		kprintf("addr: %p \t", t->addr);
		kprintf("type: %d \t", t->type);
		kprintf("size: %d \n", t->size);
		t = t->next;	
	}
}


void add_to_filelist(struct file *f)
{
	if(filelist == NULL)
	{
		filelist = f;
		f->next = NULL;
	}
	else
	{
		struct file *t = filelist;
		while(t->next != NULL)
			t = t->next;
		t->next = f;
		f->next = NULL;
	}
}

void initialize_tarfs()
{
	//clrscr();
	kstrcpy(cwd, "rootfs/");
	kprintf("_binary_tarfs_start address is %p and %x \n", &_binary_tarfs_start, &_binary_tarfs_start);
	struct posix_header_ustar *ustart;
	//uint64_t count = 0;
	ustart = (struct posix_header_ustar *)(&_binary_tarfs_start);
	//count++;
	uint64_t offset = 0;
	int index = 0;
	struct file *f = NULL;
	while(strlen(ustart->name) != 0)
	{
		//kprintf("binary name is %s \n",ustart->name);
		f = kmalloc(sizeof(struct file)); 
		kstrcpy(f->name,ustart->name); 
		f->addr = (uint64_t)&_binary_tarfs_start + offset;
		f->fd = fd_count;
		fd_count++;
		f->type = atoi(ustart->typeflag);
		f->size = octal_to_decimal(atoi(ustart->size));
		f->offset=0;
		f->next = NULL;
		
		uint64_t size = octal_to_decimal(atoi(ustart->size));
		uint64_t align = 0;
		if(size != 0)
			align = (size%512==0) ? size : size + (512 - size%512);
		offset = offset+ 512 + align;
		ustart = (struct posix_header_ustar *)(&_binary_tarfs_start + offset);
		add_to_filelist(f);
		index++;
		//count++;
	}
	//file[index] = kmalloc(sizeof(struct file));
	print_files();
}

#if 0

void initialize_tarfs()
{
	//clrscr();
	kprintf("_binary_tarfs_start address is %p and %x \n", &_binary_tarfs_start, &_binary_tarfs_start);
	//uint64_t t = &_binary_tarfs_start;
	uint64_t count = 0;
	struct posix_header_ustar *ustart;
	//uint64_t end = 0;
	//while(end < (uint64_t)&_binary_tarfs_end)
	ustart = (struct posix_header_ustar *)(&_binary_tarfs_start + count*512);
	count++;
	//while(strlen(ustart->name) != 0)
	//while(count < 3)
	while(strlen(ustart->name) != 0)
	{
		//mend = (uint64_t)&_binary_tarfs_start + count*512;
		//if(count == 2)
		//	{
			kprintf("binary name is %s \n",ustart->name);
			#if 0
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
			#endif
		//}
		ustart = (struct posix_header_ustar *)(&_binary_tarfs_start + count*512);
		count++;
		
		//t = t + 512;
		//ustart = (struct posix_header_ustar *)t;
	}
	
}

#endif
int fopen(char *name)
{
	struct file *t = filelist;
	while(t->next != NULL)
	{
		if(kstrcmp(t->name,name)==0) //&& t->type==TYPE_FILE)
		{
			return t->fd;
		}
		t = t->next;
	}
	return -1;
}

int fread(uint64_t fd,char* buf,uint64_t nbytes)
{
	struct file *t =filelist;
	while(t->next != NULL)
	{	
		if(t->fd == fd)
		{	
		 uint64_t start= (uint64_t)(&_binary_tarfs_start + find_offset_for_file(t->name));
		 int size = t->size;
		   if(size - t->offset < nbytes)
			   nbytes = size - t->offset;

		   //kprintf("name of file read %s",t->name);
		   memcpy((void *)buf, (void *) (start+t->offset), nbytes);
		   t->offset = t->offset+nbytes;
		   return nbytes;	
		}
		t = t->next;
	}
	return -1;
}

uint64_t fwrite(uint64_t fd, char *buf, uint64_t nbytes)
{
	struct file *t = filelist;
	while(t->next != NULL)
	{	
		if(t->fd == fd)
		{	
			//write to this file
			 uint64_t addr = t->addr + t->offset;
			 memcpy((void *)addr, (void *) buf, nbytes);
			 t->offset = t->offset+nbytes;
			 return 0;
		}
		t = t->next;
	}
	return -1;
}

void fclose(uint64_t fd)
{
    struct file *t =filelist;
	while(t->next != NULL)
	{	
		if(t->fd == fd)
		{	
			 t->offset = 0;
			 return;
		}
		t = t->next;
	}
}

struct file *dopen(uint64_t fd, uint64_t buf)
	{
	struct file *t = filelist;
		while(t->next != NULL)
			{
			if(t->fd == fd && t->type == TYPE_DIRECTORY)
					{
					   int len = strlen(t->name); 
					   char* name = t->name;
				    if(t->next !=NULL && kstrncmp(t->next->name, name,len)==0){
							kprintf2("name of next file %s\n",t->next->name);
						  return t->next;
						}
						else{
							return NULL;
						}
			}
				t=t->next;
			}			
			return NULL;
}


/* int dopen(uint64_t fd, uint64_t buf)
	{
	struct file *t = filelist;
		while(t->next != NULL)
			{
			if(t->fd == fd && t->type == TYPE_DIRECTORY)
					{
					// int len = strlen(t->name); 
					// char* name = t->name;
					
						kprintf("name of next file%s\n",t->name);
						  return t->addr;
					}
				t=t->next;
			}			
			return -1;

}
 */
struct file *dread(struct file* f)
{
	struct file *t = filelist;
	while(t->next != NULL)
	{
		if(t->fd == f->fd)
		{
			char temp_name[1024];
			int j =0;
			char* iter_name = f->name;
			for(int i = 0; iter_name[i] != '/' ; i++) {
    					temp_name[j++]=iter_name[i];
			}
			int len = j++;
			 //int len = strlen(t->name); 
			 //char* name = t->name;
			  if(t->next !=NULL && kstrncmp(t->next->name, temp_name,len)==0){
							kprintf2("name of next file %s\n",t->next->name);
						  return t->next;
						}
						else{
							return NULL;
						}
			}
				t=t->next;
			}			
			return NULL;
}

void set_cwd(char *dpath)
{
	kstrcpy(cwd, dpath);	
}

char *get_cwd()
{
	return cwd;	
}

/*void dread(uint64_t fd)
	
	{
	struct file *t =filelist;
	while(t->next != NULL)
			{	
				if(t->fd == fd)
					{
					 int len = strlen(t->name); //abc  3
					 char* name = t->name;
					if(t->next == NULL)
						{ return;}
					 t= t->next;
					char* newname = t->name;
					while(kstrncmp(newname, name,len)==0)
					 {
						kprintf("%s\n",newname);
						 if(t->next == NULL)
						{ return;}
						t = t->next;
						newname = t->name;
					 }
					break;
				}
		t = t->next;
	}
	return ;
}
*/
