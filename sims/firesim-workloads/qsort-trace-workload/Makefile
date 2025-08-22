CC=riscv64-unknown-elf-gcc
CFLAGS=-mcmodel=medany -Wall -fno-common -fno-builtin
LDFLAGS=-static -nostartfiles -lgcc

qsort: qsort.o crt.o syscalls.o
	$(CC) -T link.ld $(LDFLAGS) $^ -o $@


%.o: %.c util.h
	$(CC) $(CFLAGS) -O2 -DPMU=1 -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o
	rm -f qsort
