ENTRY(kernel_main)

SECTIONS {
    /* Place kernel code starting at 0x1000 (adjust as needed) */
    . = 0x7e00;

    /* Text (code) section */
    .text : {
        *(.text.kernel_main)   /* Ensure kernel_main is placed first */
        *(.text*)              /* Other .text sections */
    }

    /* Data section */
    .data : {
        *(.data)
    }

    /* BSS section (uninitialized data) */
    .bss : {
        *(.bss)
    }
}