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