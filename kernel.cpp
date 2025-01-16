#include <cstdint>
 
#include "lib/farpointer.c"
#include "lib/sound.c"

extern "C" void kernel_main() __attribute__((section(".text.kernel_main")));

// Kernel main entry point
extern "C" void kernel_main() {
    FarPointer vram(0xB800, 0x0000); // VGA text mode memory starts at 0xB800:0x0000
    
    vram[0] = 'H';
    vram[1] = 0x0E; // Yellow
    
    vram[2] = 'i';
    vram[3] = 0x0E; // Yellow 

    vram[4] = '!';
    vram[5] = 0x0E; // Yellow 

    //vram[10] = vram[0]; 
    //vram[12] = vram[0].read();
   
    beep(440, 500);
       
}