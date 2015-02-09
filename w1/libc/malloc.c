#include <stdlib.h>
#include <stdio.h>

/*reference:: http://danluu.com/malloc-tutorial/  */

struct mem_block
{
	size_t size;
	int free;  // if free 1 else 0
	struct mem_block *next;
};
struct mem_block mem;
void *head = NULL;

enum
{
	USED,
	FREE
};

#define sizeof(type) (char *)(&type+1)-(char*)(&type)
#define BLOCK_SIZE sizeof(mem)

struct mem_block *allocateMemory(size_t size);
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size);
void *malloc(size_t size);

void *malloc(size_t size)
{
	//printf("malloc start \n");
	struct mem_block *block;
	if(size <= 0)
		return NULL;
	
	if(head == NULL)
	{
		//printf("first time allocation %d \n",size);
		block = allocateMemory(size);
		if(block == NULL)
		{
			/*memory allocation failed */
			return NULL;	
		}
		head = block;
	}
	else
	{
		//search for free block
		struct mem_block *last = head;
		block = find_free_mem_block(&last, size);
		//printf("found free memory block \n");
		if(block == NULL)
		{
			//printf("added at the end %d \n", size);
			block = allocateMemory(size);
			if(block == NULL)
				return NULL;
			last->next = block;
		}
		else{
			//use free block found
			//printf("using free block \n");
			block->free = USED;
		}
	}
	//printf("malloc end \n");
 	return(block+1); 
	//added 1 because block is a pointer of type struct and 
	//plus 1 increments the address by one sizeof(struct)
}

void free(void *ptr)
{
	//printf("freed \n");
	if(ptr == NULL)
		return;
	struct mem_block *block = (struct mem_block *)ptr -1 ;
	block->free = FREE;
}

//our code
struct mem_block *find_free_mem_block(struct mem_block **last, size_t size)
{
	//printf("find_free_mem_block called %d \n \n\n\n ", size);
	struct mem_block *temp = head;
	while(temp && !(temp->free == FREE && temp->size >= size))
	{
		*last = temp;
		temp = temp->next;	
	}
	return temp;
}

/* allocate memory of size  */
struct mem_block *allocateMemory(size_t size)
{
	struct mem_block *current;
	current = sbrk(0);
	void *addr = sbrk(size + BLOCK_SIZE);
	
	if (addr == (void*) -1) {
		/* memory allocation failed */
		return NULL; 
  	}
	current->size = size;  //by removing memory block size
	current->next = NULL;
	current->free = USED;
	return current;
}


