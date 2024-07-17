del floppy.img
nasm -f bin boot.asm -o boot.bin
wsl dd if=/dev/zero of=floppy.img bs=512 count=2880
wsl dd if=boot.bin of=floppy.img conv=notrunc