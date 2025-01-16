#include <stdint.h>

struct far_pointer {
    uint16_t segment;
    uint16_t offset;
};
void kernel_main() {

    //work
    asm volatile (
        "mov $0xB800, %ax \n"  // VGA memory in ES
        "mov %ax, %es \n"
        "mov $0x07, %ah \n"    // Light grey on black
        "mov $'Z', %al \n"     // Character 'Z'
        "mov $0x0000, %di \n"  // VGA memory location (row 0, col 0)
        "mov %ax, %es:(%di) \n" // Write the character and attribute
    );

 
    // // Example: Far pointer utilities
    // struct far_pointer vga_char = { 0xB800, 0x0000 };  // VGA memory at row 0, col 0
    // far_pointer_write_byte(vga_char, 'X');

    // struct far_pointer vga_attr = { 0xB800, 0x0001 };  // Attribute byte for row 0, col 0
    // far_pointer_write_byte(vga_attr, 0x09);  
 
    //halt
    while(1);
}

// static inline void set_es_segment(uint16_t segment) {
//     asm volatile (
//         "mov %0, %%ax \n"
//         "mov %%ax, %%es \n"
//         :
//         : "r" (segment)
//         : "ax"
//     );
// }
// void far_pointer_write_byte(struct far_pointer ptr, uint8_t value) {
//     set_es_segment(ptr.segment); // Set ES segment
    
//     asm volatile (
//         "mov %1, %%al \n"
//         "mov %0, %%di \n"       // Load offset into DI
//         "mov %%al, %%es:(%%di) \n"
//         :
//         : "r" (ptr.offset), "r" (value)
//         : "di", "al"
//     );
// }
// uint8_t far_pointer_read_byte(struct far_pointer ptr) {
//     uint8_t value;

//     set_es_segment(ptr.segment);

//     asm volatile (
//         "mov %1, %%di \n"       // Load offset into DI
//         "mov %%es:(%%di), %%al \n" // Read value from ES:DI
//         "mov %%al, %0 \n"       // Store value in output variable
//         : "=r" (value)
//         : "r" (ptr.offset)
//         : "di", "al"
//     );

//     return value;
// }