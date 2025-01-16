
#include "kernel.h"

void kernel_main() {
    bios_print_char('H', 0x07);  
    bios_print_char('i', 0x07);
    bios_print_char('!', 0x07);


    kprint("Hi from kernel!");

    //halt
    while(1);
}
void kprint(const char *str) {
    volatile char *videomem = (volatile char *)0xB8000; // VGA text buffer address
    while (*str) {
        *videomem++ = *str++;  // Write character
        *videomem++ = 0x07;    // Attribute byte (light grey on black)
    }
}
void bios_print_char(char c, char color) {
    asm volatile (
        "int $0x10"               // Call BIOS video interrupt
        : /* no output operands */
        : "a"(0x0E00 | c),         // AH=0x0E (teletype output), AL=character
          "b"(0x0000 | color)      // BH (page number)=0, BL=attribute (color)
    );
}

// void print_char(char c, int row, int col, char attr) {
//     unsigned char *vidmem = (unsigned char *) 0xb8000;
//     int offset = 2 * (row * 80 + col);
//     vidmem[offset] = c;
//     vidmem[offset + 1] = attr;
// }

// void print_string(const char* str, int row, char attr) {
//     int col = 0;
//     while(*str != 0) {
//         print_char(*str, row, col, attr);
//         str++;
//         col++;
//     }
// }