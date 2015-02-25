.PHONY: clean

vbr.bin : vbr.elf
	objcopy -O binary vbr.elf vbr.bin

vbr.o : vbr.s
	as vbr.s -o vbr.o

vbr.elf : vbr.o
	ld -static -Tlink.script -Map link.map -nostdlib --nmagic -o vbr.elf vbr.o

clean :
	rm -f vbr.o
	rm -f vbr.elf
	rm -f vbr.bin
	rm -f *~

