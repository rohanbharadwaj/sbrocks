
.PHONY: clean
.SECONDARY:

SRC64_C = string.c stdlib.c kprintf.c
SRC64_S = 

OBJ64=$(SRC64_S:.s=.s.64.o) $(SRC64_C:.c=.c.64.o)

%.a : $(OBJ64)
	@echo Archiving $@
	@ar csrT $@ $(OBJ64)
	
%.c.64.o : %.c
	@echo Compiling $<
	@gcc $(CFLAGS) -c -o $@ $<
	
%.s.64.o : %.s
	@echo Assembling $<
	@gcc -Wall -c -m64  -mcmodel=kernel -o $@ $<
	
clean:
	@rm -f *~
	@rm -f *.o
	@rm -f *.a

	