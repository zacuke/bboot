BITS 16
ORG 0x7C00

start:
    ; Set video mode to 80x25 text mode (3)
    mov ax, 0x0003
    int 0x10

    ; Set DS register to 0
    xor ax, ax
    mov ds, ax

    ; Load the address of the string into SI
    mov si, boot_message

print_string:
    ; Print characters until null terminator
.print_char:
    lodsb           ; Load byte at [SI] into AL
    or al, al       ; Check if AL is zero (end of string)
    jz .done        ; If zero, string is done
    mov ah, 0x0E    ; Teletype output function
    int 0x10        ; BIOS interrupt
    jmp .print_char ; Repeat for next character

.done:
    jmp halt        ; Jump to halt after printing

halt:
    ; Infinite loop to halt the CPU
    cli
    hlt
    jmp halt

boot_message db 'Hello world!', 0

times 510-($-$$) db 0
dw 0xAA55
