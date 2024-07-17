void print_char(char c, int row, int col, char attr) {
    unsigned char *vidmem = (unsigned char *) 0xb8000;
    int offset = 2 * (row * 80 + col);
    vidmem[offset] = c;
    vidmem[offset + 1] = attr;
}

void print_string(const char* str, int row, char attr) {
    int col = 0;
    while(*str != 0) {
        print_char(*str, row, col, attr);
        str++;
        col++;
    }
}

void kernel_main() {
    print_string("Hello from C kernel!", 1, 0x07);
    while(1);
}