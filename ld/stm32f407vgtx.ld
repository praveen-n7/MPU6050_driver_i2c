/* STM32F407VGTx — 1MB Flash, 192KB RAM (128KB SRAM1 + 64KB SRAM2) */

ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 1024K
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

/* _estack is what the startup file expects — top of RAM */
_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
    /* ---- Vector table and code go into FLASH ---- */

    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))   /* Startup vector table — never strip this */
        . = ALIGN(4);
    } >FLASH

    .text :
    {
        . = ALIGN(4);
        *(.text)               /* All code */
        *(.text*)
        *(.rodata)             /* Read-only data (string literals, const) */
        *(.rodata*)
        . = ALIGN(4);
        _etext = .;            /* End of FLASH content — used by startup */
    } >FLASH

    /* ---- Initialised data: stored in FLASH, copied to RAM at boot ---- */

    .data :
    {
        . = ALIGN(4);
        _sdata = .;            /* Start of RAM data region */
        *(.data)
        *(.data*)
        . = ALIGN(4);
        _edata = .;            /* End of RAM data region */
    } >RAM AT>FLASH            /* VMA = RAM, LMA = FLASH */

    _sidata = LOADADDR(.data); /* Where .data lives in FLASH */

    /* ---- Zero-initialised data: just needs zeroing at boot ---- */

    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } >RAM

    /* ---- Heap (used by newlib malloc/printf — kept minimal) ---- */

    .heap :
    {
        . = ALIGN(8);
        _heap_start = .;
        . = . + 0x200;         /* 512 bytes — enough for vsnprintf internals */
        . = ALIGN(8);
        _heap_end = .;
    } >RAM

    /* ---- Stack (grows downward from top of RAM) ---- */

    ._stack :
    {
        . = ALIGN(8);
        . = . + 0x800;         /* 2KB stack */
        . = ALIGN(8);
    } >RAM
}
