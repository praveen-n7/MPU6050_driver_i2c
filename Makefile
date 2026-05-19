TARGET  = mpu6050_driver
ARCH    = arm-none-eabi

CC      = $(ARCH)-gcc
AS      = $(ARCH)-gcc
OBJCOPY = $(ARCH)-objcopy
SIZE    = $(ARCH)-size

CPU_FLAGS = -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard

CFLAGS  = $(CPU_FLAGS) -O1 -Wall -Wextra -g \
          -DSTM32F407xx \
          -Iinclude

LDFLAGS = $(CPU_FLAGS) \
          -Tld/stm32f407vgtx.ld \
          -nostartfiles \
          --specs=nano.specs \
          -Wl,--gc-sections \
          -Wl,-Map=$(TARGET).map

# CHANGED: added OpenOCD path and scripts dir since it lives inside MSYS2
OPENOCD         = C:/msys64/mingw64/bin/openocd.exe
OPENOCD_SCRIPTS = C:/msys64/mingw64/share/openocd/scripts

SRC_C   = $(wildcard src/*.c)
SRC_S   = $(wildcard src/*.s)
OBJS    = $(SRC_C:.c=.o) $(SRC_S:.s=.o)

all: $(TARGET).bin

# CHANGED: was "-o $@ $@" which is wrong (linking target into itself)
# correct is "-o $@ $^" where $^ expands to all prerequisites (the .o files)
$(TARGET).elf: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

# CHANGED: was "$(SIZE) $" — missing the target name, now "$(SIZE) $<"
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@
	$(SIZE) $<

# CHANGED: was "$(CC) $(CFLAGS) -c -o $@ $" — $ with nothing after it is invalid
# correct is "$<" which means "the first prerequisite" (the .c file)
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# CHANGED: same fix — was "$" now "$<"
%.o: %.s
	$(AS) $(CPU_FLAGS) -c -o $@ $<

# CHANGED: was bare "openocd" which may not resolve on Windows
# now uses full MSYS2 path and -s flag so "source [find ...]" inside the cfg works
flash: $(TARGET).elf
	$(OPENOCD) -s $(OPENOCD_SCRIPTS) \
	           -f openocd/stm32f4discovery.cfg \
	           -c "program $(TARGET).elf verify reset exit"

clean:
	rm -f src/*.o $(TARGET).elf $(TARGET).bin $(TARGET).map