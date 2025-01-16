

print_memory:
    pusha               ; Save all registers
.memory_loop:
    ; Load a byte from memory segment ES:[DI] into AL
    mov al, es:[di]
    
    ; Convert the byte in AL to hexadecimal format and display
    call print_hex_byte

    ; Print a space for readability
    mov ah, 0x0E
    mov al, ' '             ; Space character
    int 0x10

    ; Increment the offset (DI) to move to the next byte
    inc di

    ; Decrement loop counter (CX), continue if CX > 0
    loop .memory_loop

    popa                    ; Restore all registers
    ret                     ; Return to caller

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
