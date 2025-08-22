#include <stdio.h>
// #include <stdint.h>
// #include <riscv-pk/encoding.h>

// #define read_csr_safe(reg) ({ register long __tmp asm("a0"); \
//   asm volatile ("csrr %0, " #reg : "=r"(__tmp)); \
//   __tmp; })


// #define EN_MASK 0xFFFFFFFF

// int main(void) {
//   printf("Starting CSR test1: !\n");
//   printf("Starting CSR test2: !\n");
//   printf("Starting CSR test3: !\n");
//   printf("Read mcounteren: \n");
//   printf("0x1: %lu\n", read_csr_safe(0x1));
//   printf("0x2: %lu\n", read_csr_safe(0x2));
//   printf("0x3: %lu\n", read_csr_safe(0x3));
//   printf("0xc00 (CSR_CYCLE): %lu\n", read_csr_safe(0xc00));
//   printf("0xc01 (CSR_TIME): %lu\n", read_csr_safe(0xc01));
//   printf("0xc00 (CSR_INSTRET): %lu\n", read_csr_safe(0xc02));
//   printf("0xc00 (CSR_CYCLE): %lu\n", read_csr_safe(0xc00));
//   printf("0xc01 (CSR_TIME): %lu\n", read_csr_safe(0xc01));
//   printf("0xc00 (CSR_INSTRET): %lu\n", read_csr_safe(0xc02));
//   printf("0xc00 (CSR_CYCLE): %lu\n", read_csr_safe(0xc00));
//   printf("0xc01 (CSR_TIME): %lu\n", read_csr_safe(0xc01));
//   printf("0xc00 (CSR_INSTRET): %lu\n", read_csr_safe(0xc02));
//   printf("0xc00 (CSR_CYCLE): %lu\n", read_csr_safe(0xc00));
//   printf("0xc01 (CSR_TIME): %lu\n", read_csr_safe(0xc01));
//   printf("0xc00 (CSR_INSTRET): %lu\n", read_csr_safe(0xc02));


//   printf("0xc00 (hpmevent3): %lu\n", read_csr_safe(0xc03));
//   // printf("0xc00 (CSR_CYCLE): %lu\n", read_csr_safe(0xc00));
//   // printf("0xc00 (CSR_CYCLE): %lu\n", read_csr_safe(0xc00));
//   // printf("0xc00 (CSR_CYCLE): %lu\n", read_csr_safe(0xc00));
//   // printf("0xc00 (CSR_CYCLE): %lu\n", read_csr_safe(0xc00));
//   // printf("0xc01: %lu\n", read_csr_safe(0xc01));
//   // printf("0xc02: %lu\n", read_csr_safe(0xc02));
//   // printf("0xc03: %lu\n", read_csr_safe(0xc03));
//   // printf("0xb00 (CSR_MCYCLE): %lu\n", read_csr_safe(0xb00));
//   // printf("0x8: %lu\n", read_csr_safe(0x8));
//   // printf("0x9: %lu\n", read_csr_safe(0x9));
//   // printf("0xa: %lu\n", read_csr_safe(0xa));
//   // printf("0xf: %lu\n", read_csr_safe(0xf));
//   // printf("0x11: %lu\n", read_csr_safe(0x11));
//   // printf("0x15: %lu\n", read_csr_safe(0x15));
//   // printf("0x17: %lu\n", read_csr_safe(0x17));
//   // printf("0x17: %lu\n", read_csr_safe(0x17));
//   // write_csr(0x306, EN_MASK);
//   return 0;
// }


int main(){
  printf("Hello world!\n");
}