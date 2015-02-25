
.PHONY: all clean
all : stage1.5.ext2.bin

export SRC_ROOT := $(shell pwd)
export CFLAGS := -I$(SRC_ROOT) -c -Wall -Werror -std=c99 -m32 -Os -fno-unroll-loops -fomit-frame-pointer -mno-mmx -mno-sse -mno-sse2 -mno-sse3 -mno-3dnow -ffreestanding -nostdinc -nostdlib
export LDFLAGS := -s -Map link.map -static -nodefaultlibs -nostdlib --nmagic --oformat elf32-i386 -melf_i386 -Tlink.script

LIBS    = fs/fs.a disk/disk.a

# 32bit assembler source
SRC32_S = entry.s \
		  himem.s \
		  mem.s
		
# 32bit c source
SRC32_C = main.c \
		  print.c \
          mmap.c \
		  alloc.c \
		  pt.c \
		  math64.c \
		  mem.c

OBJ32=$(SRC32_S:.s=.s.32.o) $(SRC32_C:.c=.c.32.o)

# flatten an elf
%.bin : %.elf
	@echo Generating $@
	@objcopy -O binary $< $@

# Link objects into an elf.
stage1.5.ext2.elf : $(OBJ32) $(LIBS) link.script
	@echo Linking $@
	@$(LD) $(LDFLAGS) -o $@ $(OBJ64) $(OBJ32) $(LIBS)
	
%.c.32.o : %.c
	@echo Compiling $< 
	@gcc $(CFLAGS) -o $@ $<

%.s.32.o : %.s
	@echo Assembling $<
	@gcc $(CFLAGS) -o $@ $<
	
fs/fs.a:
	@make -C fs fs.a
	
disk/disk.a:
	@make -C disk disk.a
	
clean:
	make -C fs clean
	make -C disk clean
	rm -f *~
	rm -f *.o
	rm -f *.elf
	rm -f *.bin

	
	
