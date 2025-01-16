
# bboot

## Overview

`bboot` is an example 16 bit real-mode bootloader that prints some text to the screen, and also beeps when the system starts. This project demonstrates the basics of bootloader development, including setting up the environment, writing assembly code, and creating a bootable image.

## Features

- MBR style booting
- FarPointer implemention
- PC Speaker beep

## Requirements

- NASM 
- g++
- Windows / wsl (although should be buildable on Linux, I just have a build.bat that assumes Windows)

## Getting Started

### Prerequisites

Ensure you have the following tools installed on your system:

- NASM: [NASM Download](https://www.nasm.us/) in C:\Program Files\NASM

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

You can test the bootloader using QEMU, and it's also tested in 86Box, HyperV, and VirtualBox as floppy device.

```sh
qemu-system-x86_64 -fda out\floppy.img
```

You should see the bootloader code print on the screen.
