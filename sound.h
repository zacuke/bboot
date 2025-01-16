


// I/O Port Helper Functions for 16-bit Real Mode
inline void outb(unsigned short port, unsigned char value) {
    asm volatile ("outb %0, %1" : : "a"(value), "Nd"(port));
}

inline unsigned char inb(unsigned short port) {
    unsigned char result;
    asm volatile ("inb %1, %0" : "=a"(result) : "Nd"(port));
    return result;
}

// Busy-loop delay function
void delay(int milliseconds) {
    // This delay is approximate and depends on CPU speed
    for (volatile unsigned long i = 0; i < milliseconds * 1000; ++i) {
        asm volatile ("nop"); // Ensure the compiler doesn't optimize this away
    }
}

// Initialize and start sound at a given frequency
void play_sound(unsigned int frequency) {
    // Calculate the PIT divisor for the desired frequency
    unsigned int divisor = 1193180 / frequency;

    // Configure the PIT (Channel 2, Mode 3 - Square Wave Generator)
    outb(0x43, 0xB6);          // Command byte: Channel 2, Access mode: lobyte/hibyte, Square wave mode
    outb(0x42, divisor & 0xFF);        // Send low byte of divisor
    outb(0x42, (divisor >> 8) & 0xFF); // Send high byte of divisor

    // Enable the PC speaker (set bits 0 and 1 of port 0x61)
    unsigned char tmp = inb(0x61);
    if (tmp != (tmp | 3)) {    // Ensure the speaker is enabled
        outb(0x61, tmp | 3);   // Bitwise OR to set bits 0 and 1
    }
}

// Stop sound output
void stop_sound() {
    // Disable the PC speaker (clear bits 0 and 1 of port 0x61)
    unsigned char tmp = inb(0x61);
    outb(0x61, tmp & ~3); // Bitwise AND with complement of 3 to clear bits 0 and 1
}

// Play a beep sound at a given frequency and duration (in milliseconds)
void beep(unsigned int frequency, int duration) {
    play_sound(frequency);    // Start the sound
    delay(duration);          // Wait for the sound duration
    stop_sound();             // Stop the sound
}

