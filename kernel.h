typedef unsigned int size_t;

// Inline assembly function to set ES segment register
static inline void set_es_segment(uint16_t segment) {
    asm volatile (
        "mov %0, %%ax \n"    // Load segment value into AX
        "mov %%ax, %%es \n"  // Set ES
        :
        : "r" (segment)
        : "ax"
    );
}

// Proxy class for accessing far pointer memory
class FarProxy {
private:
    uint16_t segment; // Segment part of the far pointer
    uint16_t offset;  // Offset part of the far pointer

public:
    // Constructor
    FarProxy(uint16_t seg, uint16_t ofs) : segment(seg), offset(ofs) {}

    // Write to the memory location
    FarProxy &operator=(uint8_t value) {
        set_es_segment(segment);
        asm volatile (
            "movb %0, %%al \n"             // Load value into AL
            "movw %1, %%di \n"             // Load offset into DI
            "movb %%al, %%es:(%%di) \n"    // Write value from AL into ES:DI
            :
            : "r" (value), "r" (offset)
            : "di", "al"
        );
        return *this;
    }

    uint8_t read() const {
        char value;
        //set_es_segment(segment);
        asm volatile (
            "pushw %%ds \n"                // Save the 16-bit DS register on the stack
            "mov %1, %%ax \n"              // Move segment into AX
            "mov %%ax, %%ds \n"            // Set DS to the segment
            "movw %2, %%si \n"             // Load offset into SI
            "movb %%ds:(%%si), %%al \n"    // Read value from DS:SI into AL
            "movb %%al, %0 \n"             // Store AL in the output variable
            "popw %%ds \n"                 // Restore the original DS register
            : "=r" (value)                 // Output operand
            : "r" (segment), "r" (offset)  // Input operands
            : "ax", "al", "si", "memory"   // Clobbered registers
        );
        return value;
    }

    operator uint8_t() const {
        return read(); 
    }
    
    // Overload assignment operator to assign from another FarProxy
    FarProxy &operator=(const FarProxy &other) {
        *this = other.read(); // Use `read()` to fetch the value from `other`
        return *this;
    }

};

// FarPointer class for array-like access to far memory
class FarPointer {
private:
    uint16_t segment; // Segment portion of the far pointer
    uint16_t offset;  // Base offset of the far pointer

public:
    // Constructor
    FarPointer(uint16_t seg, uint16_t ofs) : segment(seg), offset(ofs) {}

    // Overload operator[] for array-style access
    FarProxy operator[](size_t index) const {
        return FarProxy(segment, offset + index);
    }
};