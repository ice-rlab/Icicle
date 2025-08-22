#include "encoding.h"
#include "tma_defs.h"
#include <stdio.h>

unsigned long long counters[31];

int main(){
    counters[0] = read_csr_safe(cycle);
    counters[1] = read_csr_safe(instret);
    counters[2] = read_csr_safe(hpmcounter3);
    counters[3] = read_csr_safe(hpmcounter4);
    counters[4] = read_csr_safe(hpmcounter5);
    counters[5] = read_csr_safe(hpmcounter6);
    counters[6] = read_csr_safe(hpmcounter7);
    counters[7] = read_csr_safe(hpmcounter8);
    counters[8] = read_csr_safe(hpmcounter9);
    counters[9] = read_csr_safe(hpmcounter10);
    counters[10] = read_csr_safe(hpmcounter11);
    counters[11] = read_csr_safe(hpmcounter12);
    counters[12] = read_csr_safe(hpmcounter13);
    counters[13] = read_csr_safe(hpmcounter14);
    counters[14] = read_csr_safe(hpmcounter15);
    counters[15] = read_csr_safe(hpmcounter16);
    counters[16] = read_csr_safe(hpmcounter17);
    counters[17] = read_csr_safe(hpmcounter18);
    counters[18] = read_csr_safe(hpmcounter19);
    counters[19] = read_csr_safe(hpmcounter20);
    counters[20] = read_csr_safe(hpmcounter21);
    counters[21] = read_csr_safe(hpmcounter22);
    counters[22] = read_csr_safe(hpmcounter23);
    counters[23] = read_csr_safe(hpmcounter24);
    counters[24] = read_csr_safe(hpmcounter25);
    counters[25] = read_csr_safe(hpmcounter26);
    counters[26] = read_csr_safe(hpmcounter27);
    counters[27] = read_csr_safe(hpmcounter28);
    counters[28] = read_csr_safe(hpmcounter29);
    counters[29] = read_csr_safe(hpmcounter30);
    counters[30] = read_csr_safe(hpmcounter31);

    printf("==============Counters==============\n");
    for (int i = 0; i < 31;++i){
        printf("%s: %llu\n", counter_names[i], counters[i]);
    }
}