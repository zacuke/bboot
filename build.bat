@echo off
setlocal

rem Designed for Windows and assumes wsl is installed with gcc, ld, and dd installed 

rem Define the out directory
set OUT_DIR=out

rem Clear the out directory if it exists, then recreate it
if exist %OUT_DIR% (
    rmdir /s /q %OUT_DIR%
)
mkdir %OUT_DIR%

rem Assemble the bootloader
"c:\program files\nasm\nasm.exe" -f bin boot.asm -o %OUT_DIR%\boot.bin

rem Compile the kernel (real mode C code)
wsl g++ -ffreestanding -fno-pie -m16 -nodefaultlibs -fno-exceptions -c kernel.cpp -o %OUT_DIR%/kernel.o

rem Link the kernel (include start.o)
wsl ld -T linker.ld -m elf_i386 --oformat binary -o %OUT_DIR%/kernel.bin  %OUT_DIR%/kernel.o

rem Create a bootable image
copy /b %OUT_DIR%\boot.bin + %OUT_DIR%\kernel.bin %OUT_DIR%\os-image.bin

rem Create a floppy image
fsutil file createnew %OUT_DIR%\floppy.img 1474560
wsl dd if=%OUT_DIR%/os-image.bin of=%OUT_DIR%/floppy.img bs=512 conv=notrunc

rem For Hyper-V (Optional)
copy %OUT_DIR%\floppy.img %OUT_DIR%\floppy.vfd

endlocal