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
 
    ; ; -- Load kernel into memory --
    ; mov bx, 0x1000    ; ES:BX = Target address for kernel (0x1000:0000)
    ; mov es, bx

    ; mov ah, 0x02      ; BIOS function 0x02: Read sectors into memory
    ; mov al, 2         ; Number of sectors to read (adjust as needed)
    ; mov ch, 0         ; Cylinder 0
    ; mov dh, 0         ; Head 0
    ; mov cl, 2         ; Read from sector 2 (after bootloader)
    ; int 0x13          ; BIOS disk interrupt - load sector into memory

    ; jc load_failed    ; If carry flag is set, loading failed

    ; -- Fill memory with static data (all 0xFF's) --
    mov bx, 0x1000    ; Set ES to the target segment 0x1000
    mov es, bx        ; ES = 0x1000

    xor di, di        ; Offset starts at 0x0000
    mov cx, 256       ; Number of bytes to write (adjust as needed)
    mov al, 0xFF      ; Value to write  

    .fill_memory:
        stosb          ; Store AL at ES:[DI], increment DI
        loop .fill_memory ; Repeat CX times
        

    mov si, kernel_message
    call print_string

    ; -- Jump to the kernel --
    ;jmp 0x1000:0000   ; Jump to the kernel loaded at 0x1000:0000

    ; Debug: Read and display the contents of memory at 0x1000:0000
    mov bx, 0x1000      ; Segment where kernel is loaded
    mov es, bx          ; Set ES to that segment
    xor di, di          ; Offset in segment starts at 0x0000
    mov cx, 256         ; Number of bytes to read/display (adjust as needed)
    call print_memory    ; Jump to the memory printing subroutine
    jmp halt            ; After displaying memory, halt the program

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

print_string:
    ; Print characters until null terminator
    pusha               ; Save all registers (optional, for safety)

.print_char:
    lodsb               ; Load byte at [SI] into AL
    or al, al           ; Check if AL is zero (end of string)
    jz .done            ; If zero, go to function end
    mov ah, 0x0E        ; Teletype output function
    int 0x10            ; BIOS interrupt
    jmp .print_char     ; Repeat for next character

.done:
    popa                ; Restore all registers (optional, if pusha was used)
    ret                 ; Return to the caller

print_memory:
    pusha               ; Save all registers

.memory_loop:
    ; Load byte from ES:[DI] into AL (memory segment is ES, offset is DI)
    mov al, es:[di]
    
    ; Convert the byte in AL to hexadecimal string and print it
    call print_hex_byte

    ; Print a space between bytes for readability
    mov ah, 0x0E
    mov al, ' '
    int 0x10

    ; Increment DI to move to the next byte
    inc di

    ; Decrement CX, stop when all bytes printed
    loop .memory_loop

    popa                ; Restore all registers
    ret                 ; Return to caller

print_hex_byte:
    push ax             ; Save the value in AX (because AL contains the byte to print)
    push bx             ; Save BX register (we'll use it for calculations)
    
    mov bl, al          ; Copy the byte (AL) into BL so we can work with it
    shr al, 4           ; Right-shift AL by 4 bits to isolate the high nibble
    and al, 0x0F        ; Mask to ensure only the lower 4 bits remain
    call print_hex_nibble ; Print the high nibble
    
    mov al, bl          ; Restore the original byte (from BL to AL)
    and al, 0x0F        ; Mask to isolate the low nibble
    call print_hex_nibble ; Print the low nibble
    
    pop bx              ; Restore the saved BX register
    pop ax              ; Restore the saved AX register
    ret                 ; Return to caller

print_hex_nibble:
    cmp al, 10          ; Compare nibble (low 4 bits) with 10
    jl .is_digit        ; If it's less than 10, it's a digit (0-9)

    ; If nibble >= 10, convert it to a letter (A-F)
    add al, 'A' - 10    ; Add offset to make it 'A'-'F'
    jmp .print_char

.is_digit:
    add al, '0'         ; Convert digit (0-9) to ASCII ('0'-'9')

.print_char:
    mov ah, 0x0E        ; BIOS teletype function to print a character
    int 0x10            ; Print the character in AL
    ret                 ; Return to caller

boot_message db 'Hello from boot.asm :)', 0Dh, 0Ah, 0;
loading_message db 'Loading kernel.c ...', 0Dh, 0Ah, 0;
kernel_message db 'Kernel loading now jumping ...', 0Dh, 0Ah, 0;
error_message db 'Error in boot.asm :(', 0Dh, 0Ah, 0;
halt_message db 'Halting </end>', 0Dh, 0Ah, 0;

times 510-($-$$) db 0
dw 0xAA55
