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
    call print_string

    mov si, loading_message
    call print_string

    ; call debug_fill_memory
    
    ; -- Load kernel into memory --
    mov bx, 0x1000    ; ES:BX = Target address for kernel (0x1000:0000)
    mov es, bx

    mov ah, 0x02      ; BIOS function 0x02: Read sectors into memory
    mov al, 2         ; Number of sectors to read (adjust as needed)
    mov ch, 0         ; Cylinder 0
    mov dh, 0         ; Head 0
    mov cl, 2         ; Read from sector 2 (after bootloader)
    int 0x13          ; BIOS disk interrupt - load sector into memory

    jc load_failed    ; If carry flag is set, loading failed


    ; Debug: Read and display the contents of memory at 0x1000:0000
    mov bx, 0x1000      ; Segment where kernel is loaded
    mov es, bx          ; Set ES to that segment
    xor di, di          ; Offset in segment starts at 0x0000
    mov cx, 256         ; Number of bytes to read/display (adjust as needed)
    call print_memory    ; Jump to the memory printing subroutine

    mov si, new_line
    call print_string


    mov si, kernel_message
    call print_string

    ; -- Jump to the kernel --
    ;jmp 0x1000:0000   ; Jump to the kernel loaded at 0x1000:0000
    
    jmp halt

load_failed:
    ; -- Display error message if kernel loading fails --
    mov si, error_message
    call print_string ; Reuse print subroutine
    jmp halt          ; Hang the system (halt)

halt:
    mov si, halt_message
    call print_string

    ; Infinite loop to halt the CPU
    cli
    hlt
    jmp halt

boot_message db 'Hello from boot.asm :)', 0Dh, 0Ah, 0;
loading_message db 'Loading kernel.c ...', 0Dh, 0Ah, 0;
kernel_message db 'Kernel loading now jumping ...', 0Dh, 0Ah, 0;
error_message db 'Error in boot.asm :(', 0Dh, 0Ah, 0;
halt_message db 'Halting </end>', 0Dh, 0Ah, 0;
new_line db 0Dh, 0Ah, 0;

%include "debug.asm"
times 510-($-$$) db 0
dw 0xAA55
