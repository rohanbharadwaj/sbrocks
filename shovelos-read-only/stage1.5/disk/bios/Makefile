.PHONY: clean

SRC32_C = bios_disk.c
SRC32_S = 

OBJ32 = $(SRC32_S:.s=.s.32.o) $(SRC32_C:.c=.c.32.o)

%.a : $(OBJ32)
	@echo Archiving $@
	@ar rcs $@ $(OBJ32)
	
%.c.32.o : %.c
	@echo Compiling $<
	@gcc $(CFLAGS) -o $@ $<
	
%.s.32.o : %.s
	@echo Assembling $<
	@gcc  $(CFLAGS) -o $@ $<
	
clean:
	@rm -f *~
	@rm -f *.o
	@rm -f *.a

	