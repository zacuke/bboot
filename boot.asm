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
    xor bx, bx    
    mov es, bx    ; es should be 0

    mov bx, 0x7e00    ; ES:BX = Target address for kernel
 
    mov ah, 0x02      ; BIOS function 0x02: Read sectors into memory
    mov al, 6         ; Number of sectors to read (adjust as needed)
    mov ch, 0         ; Cylinder 0
    mov dh, 0         ; Head 0
    mov cl, 2        ; Read from sector 2 (after bootloader)

    int 0x13          ; BIOS disk interrupt - load sector into memory

    jc load_failed    ; If carry flag is set, loading failed


    mov si, kernel_message
    call print_string


    ;(memory segment is ES, offset is DI)
    mov ax, 0x0000      ; Set ES to 0x0000
    mov es, ax
    mov di, 0x7e00      ; Start at offset 0x7E00
    mov cx, 16         ; Print 256 bytes
    call print_memory    ; Call debug print routine

    mov si, new_line
    call print_string


    ; -- Jump to the kernel --
    jmp 0x7e00   
    
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
kernel_message db 'Kernel loaded, now jumping .. first 16 bytes of kernel below ...', 0Dh, 0Ah, 0;
error_message db 'Error in boot.asm :(', 0Dh, 0Ah, 0;
halt_message db 'Halting </end>', 0Dh, 0Ah, 0;
new_line db 0Dh, 0Ah, 0;

%include "debug.asm"

    
times 510-($-$$) db 0
dw 0xAA55
