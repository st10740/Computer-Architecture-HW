.PHONY: clean

include ~/rv32emu/mk/toolchain.mk

CFLAGS = -march=rv32i_zicsr_zifencei -mabi=ilp32 -Wall

OBJS = \
    getcycles.o \
    palindrome_detection_using_CLZ_origin.o \
    palindrome_detection_using_CLZ_modify1.o \
    palindrome_detection_using_CLZ_modify2.o \
    perfcount_asm.o
BIN = perfcount.elf

%.o: %.s
	$(CROSS_COMPILE)gcc $(CFLAGS) -c -o $@ $<

%.o: %.c
	$(CROSS_COMPILE)gcc $(CFLAGS) -c -o $@ $<

all: $(BIN)

$(BIN): $(OBJS)
	 $(CROSS_COMPILE)gcc -o $@ $^

clean:
	$(RM) $(BIN) $(OBJS)
