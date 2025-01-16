#include <cstdint>
#include "kernel.h"
#include "sound.h"

extern "C" void kernel_main() __attribute__((section(".text.kernel_main")));

// Kernel main entry point
extern "C" void kernel_main() {
    FarPointer vram(0xB800, 0x0000); // VGA text mode memory starts at 0xB800:0x0000
    
    vram[10] = vram[0]; 
    vram[12] = vram[0].read();
   
    vram[0] = 'X';  // Write ASCII 'X' to col 0
    vram[1] = 0x07; // Light gray text on black
    
    vram[2] = 'Y';  // Write ASCII 'Y' to col 1
    vram[3] = 0x0E; // Yellow text on black

    beep(440, 500);
       
}