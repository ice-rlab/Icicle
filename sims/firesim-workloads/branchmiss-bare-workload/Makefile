CC=riscv64-unknown-elf-gcc
CFLAGS=-mcmodel=medany -Wall -fno-common -fno-builtin
LDFLAGS=-static -nostdlib -nostartfiles -lgcc

branch_miss: branch_miss.o crt.o syscalls.o
	$(CC) -T link.ld $(LDFLAGS) $^ -o $@

# Make sure the actual branch_miss_experiment is not being compiled with O2
branch_miss.o:
	$(CC) $(CFLAGS) -O0 -DPMU=1 -c branch_miss.c -o branch_miss.o

%.o: %.c util.h
	$(CC) $(CFLAGS) -O2 -DPMU=1 -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o
	rm -f branch_miss
