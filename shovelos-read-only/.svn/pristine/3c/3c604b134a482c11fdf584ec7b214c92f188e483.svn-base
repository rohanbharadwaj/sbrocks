mbr.bin : mbr.elf
	objcopy -O binary mbr.elf mbr.bin

mbr.o : mbr.s
	as mbr.s -o mbr.o

mbr.elf : mbr.o
	ld -static -Tlink.script -Map link.map -nostdlib --nmagic -o mbr.elf mbr.o

clean :
	rm -f mbr.o
	rm -f mbr.elf
	rm -f mbr.bin
	rm -f *~

