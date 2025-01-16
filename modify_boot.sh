#!/bin/bash

# Arguments
OUT_DIR=$1

# Ensure OUT_DIR is provided
if [ -z "$OUT_DIR" ]; then
    echo "Error: OUT_DIR argument is missing."
    exit 1
fi

# Paths to kernel and bootloader files
KERNEL_BIN="$OUT_DIR/kernel.bin"
BOOT_ASM_MODIFIED="$OUT_DIR/boot_with_sectors.asm"

# Calculate kernel size (in bytes) and sectors (512 bytes per sector)
KERNEL_SIZE=$(stat -c%s "$KERNEL_BIN")
KERNEL_SECTORS=$(( (KERNEL_SIZE + 511) / 512 ))

echo "Kernel size: $KERNEL_SIZE bytes (rounded up to $KERNEL_SECTORS sectors)."

# Modify the copy of boot.asm to set the calculated KERNEL_SECTORS
sed -i "s/^%define KERNEL_SECTORS .*/%define KERNEL_SECTORS $KERNEL_SECTORS/" "$BOOT_ASM_MODIFIED"

echo "Modified $BOOT_ASM_MODIFIED with KERNEL_SECTORS=$KERNEL_SECTORS."

exit 0