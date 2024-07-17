
# bboot

## Overview

`bboot` is a simple bootloader that prints "Hello, World!" to the screen when the system starts. This project demonstrates the basics of bootloader development, including setting up the environment, writing assembly code, and creating a bootable image.

## Features

- Initializes video mode to 80x25 text mode
- Prints "Hello, World!" to the screen
- Loads a kernel from disk and jumps to it

## Requirements

- NASM (Netwide Assembler)
- QEMU (for testing)
- A Windows environment (for building the bootable image)

## Getting Started

### Prerequisites

Ensure you have the following tools installed on your system:

- NASM: [NASM Download](https://www.nasm.us/)
- QEMU: [QEMU Download](https://www.qemu.org/)

### Building the Bootloader

1. Clone the repository:
   ```sh
   git clone https://github.com/zacuke/bboot.git
   cd bboot
   ```

2. Assemble the bootloader and create a bootable floppy image using `build.bat`:
   ```sh
   build.bat
   ```

### Running the Bootloader

You can test the bootloader using QEMU:

```sh
qemu-system-x86_64 -fda floppy.img
```

You should see the message "Hello, World!" printed on the screen.

### Files

- `boot.asm`: The main assembly file containing the bootloader code.
- `build.bat`: Batch script to assemble the bootloader and create a bootable image.
- `README.md`: This file, providing an overview and instructions.

## Contributing

Feel free to open issues or submit pull requests if you have any suggestions or improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Acknowledgements

- Inspired by the resources available on [OSDev Wiki](https://wiki.osdev.org)
- Based on tutorials from "The Little Book About OS Development" ([https://littleosbook.github.io/](https://littleosbook.github.io/))
