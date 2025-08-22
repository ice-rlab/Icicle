CC=riscv64-unknown-elf-gcc
CFLAGS=-mcmodel=medany -Wall -O0 -fno-common -fno-builtin
LDFLAGS=-static -nostdlib -nostartfiles -lgcc

hello: hello.o crt.o syscalls.o
	$(CC) -O0 -T link.ld $(LDFLAGS) $^ -o $@

%.o: %.c util.h encoding.h
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o
	rm -rf *.dump
	rm -f hello
