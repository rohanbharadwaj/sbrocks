.PHONY: all mount_boot \
		install_vbr install_mbr install_stage1.5 install_kernel \
		vbr/vbr.bin mbr/mbr.bin stage1.5/stage1.5.ext2.bin kernel kernel/shovelos.kernel \
		clean clean_kernel

all: install_vbr install_mbr install_stage1.5 install_kernel

install_stage1.5: stage1.5/stage1.5.ext2.bin
	dd if=stage1.5/stage1.5.ext2.bin of=ATA0.img seek=1 bs=512 conv=notrunc

install_vbr: vbr/vbr.bin
	dd if=vbr/vbr.bin of=ATA0.img seek=63 bs=512 count=1 conv=notrunc

install_mbr: mbr/mbr.bin
	dd if=mbr/mbr.bin of=ATA0.img bs=446 count=1 conv=notrunc
	
install_kernel: kernel/shovelos.kernel
	cp -f kernel/shovelos.kernel /mnt/shovelos/boot
	
clean_kernel: 
	@make -C kernel clean

stage1.5/stage1.5.ext2.bin: stage1.5/*.c stage1.5/*.s stage1.5/Makefile stage1.5/link.script
	make -C stage1.5 stage1.5.ext2.bin

vbr/vbr.bin: vbr/vbr.s vbr/Makefile vbr/link.script
	make -C vbr vbr.bin

mbr/mbr.bin: mbr/mbr.s mbr/Makefile mbr/link.script
	make -C mbr mbr.bin

kernel: kernel/shovelos.kernel	
kernel/shovelos.kernel:
	make -C kernel shovelos.kernel 

mount_boot:
	modprobe loop
	/sbin/losetup --offset 32256 --sizelimit 8193024 /dev/loop1 ATA0.img
	mount /dev/loop1 /mnt/shovelos/boot

clean:
	make -C mbr clean
	make -C vbr clean
	make -C stage1.5 clean
	make -C kernel clean


