#ifndef __SBI_HPM_BOOM_H__
#define __SBI_HPM_BOOM_H__

#include <sbi/riscv_asm.h>
#include <sbi/sbi_console.h>
#include <sbi/riscv_encoding.h>
#include <sbi/core.h>
#include <sbi/tma_defs.h>

void __sbi_dump(){
    sbi_printf("========HPM CONFIG===========\n");
    sbi_printf("----HARNESS CONFIG----\n");
    sbi_printf("CORE: ROCKET\n");
    sbi_printf("COREWIDTH: %u\n", COREWIDTH);
    sbi_printf("TMA EVT: 0x%lx\n", TMA_EVT);

    sbi_printf("----MHPM EVENT CONFIG----\n");
    sbi_printf("CSR_MCOUNTEREN: 0x%lx\n",  csr_read(CSR_MCOUNTEREN));
    sbi_printf("CSR_SCOUNTEREN: 0x%lx\n",  csr_read(CSR_SCOUNTEREN));
    sbi_printf("MHPMEVENT3: 0x%lx\n",  csr_read(CSR_MHPMEVENT3));
    sbi_printf("MHPMEVENT4: 0x%lx\n",  csr_read(CSR_MHPMEVENT4));
    sbi_printf("MHPMEVENT5: 0x%lx\n",  csr_read(CSR_MHPMEVENT5));
    sbi_printf("MHPMEVENT6: 0x%lx\n",  csr_read(CSR_MHPMEVENT6));
    sbi_printf("MHPMEVENT7: 0x%lx\n",  csr_read(CSR_MHPMEVENT7));
    sbi_printf("MHPMEVENT8: 0x%lx\n",  csr_read(CSR_MHPMEVENT8));
    sbi_printf("MHPMEVENT9: 0x%lx\n",  csr_read(CSR_MHPMEVENT9));
    sbi_printf("MHPMEVENT10: 0x%lx\n",  csr_read(CSR_MHPMEVENT10));
    sbi_printf("MHPMEVENT11: 0x%lx\n",  csr_read(CSR_MHPMEVENT11));
    sbi_printf("MHPMEVENT12: 0x%lx\n",  csr_read(CSR_MHPMEVENT12));
    sbi_printf("MHPMEVENT13: 0x%lx\n",  csr_read(CSR_MHPMEVENT13));
    sbi_printf("MHPMEVENT14: 0x%lx\n",  csr_read(CSR_MHPMEVENT14));
    sbi_printf("MHPMEVENT15: 0x%lx\n",  csr_read(CSR_MHPMEVENT15));
    sbi_printf("MHPMEVENT16: 0x%lx\n",  csr_read(CSR_MHPMEVENT16));
    sbi_printf("MHPMEVENT17: 0x%lx\n",  csr_read(CSR_MHPMEVENT17));
    sbi_printf("MHPMEVENT18: 0x%lx\n",  csr_read(CSR_MHPMEVENT18));
    sbi_printf("MHPMEVENT19: 0x%lx\n",  csr_read(CSR_MHPMEVENT19));
    sbi_printf("MHPMEVENT20: 0x%lx\n",  csr_read(CSR_MHPMEVENT20));
    sbi_printf("MHPMEVENT21: 0x%lx\n",  csr_read(CSR_MHPMEVENT21));
    sbi_printf("MHPMEVENT22: 0x%lx\n",  csr_read(CSR_MHPMEVENT22));
    sbi_printf("MHPMEVENT23: 0x%lx\n",  csr_read(CSR_MHPMEVENT23));
    sbi_printf("MHPMEVENT24: 0x%lx\n",  csr_read(CSR_MHPMEVENT24));
    sbi_printf("MHPMEVENT25: 0x%lx\n",  csr_read(CSR_MHPMEVENT25));
    sbi_printf("MHPMEVENT26: 0x%lx\n",  csr_read(CSR_MHPMEVENT26));
    sbi_printf("MHPMEVENT27: 0x%lx\n",  csr_read(CSR_MHPMEVENT27));
    sbi_printf("MHPMEVENT28: 0x%lx\n",  csr_read(CSR_MHPMEVENT28));
    sbi_printf("MHPMEVENT29: 0x%lx\n",  csr_read(CSR_MHPMEVENT29));
    sbi_printf("MHPMEVENT30: 0x%lx\n",  csr_read(CSR_MHPMEVENT30));
    sbi_printf("MHPMEVENT31: 0x%lx\n",  csr_read(CSR_MHPMEVENT31));
    sbi_printf("========HPM CONFIG===========\n");
}


void __sbi_config_hpm_events(){
    // mhpmevent3: Cycle counter (Top-Down baseline slots)
    csr_write(CSR_MHPMEVENT3,  TMA_EVT | EVT(0));
    // mhpmevent4: Slots issued
    csr_write(CSR_MHPMEVENT4,  TMA_EVT | EVT(1));
    // mhpmevent5: Fetch bubbles
    csr_write(CSR_MHPMEVENT5,  TMA_EVT | EVT(2));
    // mhpmevent6: Recovering (pipeline recovery events)
    csr_write(CSR_MHPMEVENT6,  UOP_EVT | EVT(3));
    // mhpmevent7: ICache blocked
    csr_write(CSR_MHPMEVENT7,  UOP_EVT | EVT(4));
    // mhpmevent8: DCache blocked
    csr_write(CSR_MHPMEVENT8,  UOP_EVT | EVT(5));
    // mhpmevent9: Branch direction mispredict
    csr_write(CSR_MHPMEVENT9,  UOP_EVT | EVT(5));
    // mhpmevent10: Branch mispredict (direction + target)
    csr_write(CSR_MHPMEVENT10, UOP_EVT | EVT(7));

    csr_write(CSR_MCOUNTINHIBIT, 0);
    __sbi_dump();
}



#endif // __SBI_HPM_ROCKET_H__