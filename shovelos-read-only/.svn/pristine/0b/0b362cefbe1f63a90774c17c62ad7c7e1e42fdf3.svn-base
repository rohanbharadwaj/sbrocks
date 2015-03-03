
.PHONY: all clean arch/arch.a lib/lib.a boot/boot.a mm/mm.a
.SECONDARY:
 
all : shovelos.kernel

SRC64_C = main.c
LIBS    = lib/lib.a arch/x86_64/arch.a mm/mm.a

export KERNEL_ROOT := $(shell pwd)
export CFLAGS := -I$(KERNEL_ROOT) -g -Wall -Werror -std=c99 -m64 -Os -mcmodel=kernel -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -mno-sse3 -mno-3dnow -ffreestanding -nostdinc -nostdlib

OBJ64 = $(SRC64_S:.s=.s.64.o) $(SRC64_C:.c=.c.64.o)

# Convert an elf to a flat
%.kernel : %.elf
	@echo Flatening $@
	@objcopy -O binary $< $@

shovelos.elf : $(OBJ64) $(LIBS) link.script
	@echo Linking   $@ $(OBJ64) $(LIBS)
	@$(LD) -s -Map link.map -static -nodefaultlibs -nostdlib --nmagic -Tlink.script -o $@ $(OBJ64) $(LIBS)

%.c.64.o : %.c
	@echo Compiling $<
	@gcc $(CFLAGS) -c -o $@ $<
	
%.64.o : %.s
	@echo Assembling $<
	@gcc -Wall -c -m64 -ffreestanding -o $@ $<
	
arch/x86_64/arch.a:
	@make -C arch/x86_64 arch.a
	
mm/mm.a:
	@make -C mm mm.a
	
lib/lib.a:
	@make -C lib lib.a

clean:
	@rm -f *~
	@rm -f *.o
	@rm -f *.elf
	@rm -f *.bin
	@make -C arch/x86_64 clean
	@make -C mm clean
	@make -C lib clean

	
	
	