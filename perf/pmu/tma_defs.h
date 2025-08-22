#ifndef TMA_DEFS_H_
#define TMA_DEFS_H_

#include "core.h"



#define read_csr_safe(reg) ({ register long __tmp asm("a0"); \
    asm volatile ("csrr %0, " #reg : "=r"(__tmp)); \
    __tmp; })


#define EN_MASK 0xFFFFFFFF
#define EVT(n) 1UL << (n + 8)
#define MAX_PMU_COUNT 31

#define UNUSED "UNUSED"




#if defined ROCKET


const char* counter_names[MAX_PMU_COUNT] = { \
    "Cycle", \
    "IntRet", \
    "SlotsIssued", \
    "Fetchbubbles", \
    "Recovering", \
    "ICacheBlocked", \
    "DCacheBlocked", \
    "BrDirMiss", \
    "Flush", \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED, \
    UNUSED \
};


// Existing Event Sets
#define INS_EVT 0x0UL
#define UOP_EVT 0x1UL
#define MEM_EVT 0x2UL
// Additional Event Sets
#define CUS_EVT 0x3UL
#define TMA_EVT 0x4UL

// Events for Event set INS_EVT
#define EXC_TAK EVT(0)
#define INT_LOAD_RET EVT(1)
#define INT_STORE_RET EVT(2)
#define ATOM_RET EVT(3)
#define SYST_INS_RET EVT(4)
#define INT_ARITH_RET EVT(5)
#define COND_BR_RET EVT(6)
#define JAL_RET EVT(7)
#define JALR_RET EVT(8)
#define INT_MULT_RET EVT(9)
#define INT_DIV_RET EVT(10)
#define FP_LOAD_RET EVT(11)
#define FP_STORE_RET EVT(12)
#define FP_ADD_RET EVT(13)
#define FP_MULT_RET EVT(14)
#define FP_FMA_RET EVT(15)
#define FP_DIV_SQRT_RET EVT(16)
#define FP_OTHER_RET EVT(17)

// Events for Event set UOP_EVT
#define LOAD_INTER EVT(0)
#define LONG_LAT_INTER EVT(1)
#define CSR_INTER EVT(2)
#define ICACHE_BUSY EVT(3)
#define DCACHE_BUSY EVT(4)
#define BR_DIR_MISPR EVT(5)
#define BR_TRG_MISPR EVT(6)
#define PIP_FLSH_WB EVT(7)
#define WB_REPLAY EVT(8)
#define INT_MULT_INTER EVT(9)
#define FP_INTER EVT(10)

// Events for Event set MEM_EVT
#define ICACHE_MISS EVT(0)
#define DCACHE_MISS EVT(1)
#define DCACHE_WB EVT(2)
#define ITLB_MISS EVT(3)
#define DTLB_MISS EVT(4)
#define L2_TLB_MISS EVT(5)

#elif defined BOOM

// Existing Event Sets
#define EX_EVT 0x0UL
#define UOP_EVT 0x1UL
#define MEM_EVT 0x2UL
// Additional Event Sets
#define TMA_EVT_SINGLE 0x3UL
#define TMA_EVT_COREWIDTH 0x4UL
#define TMA_EVT_RETIRE_WIDTH 0x5UL
#define TMA_EVT_ISSUE_WDITH 0x6UL

#define MAX_CORE_WIDTH 8

#ifndef COREWIDTH
#error "Corewidth not defined in BOOM setup"
#endif

// #if (COREWIDTH == 1)
//   #define ISSUEWIDTH 3   // Small BOOM
// #elif (COREWIDTH == 2)
//   #define ISSUEWIDTH 4   // Medium BOOM
// #elif (COREWIDTH == 3)
//   #define ISSUEWIDTH 5   // Large BOOM
// #elif (COREWIDTH == 4)
//   #define ISSUEWIDTH 8   // Mega BOOM
// #else
//   #error "Unsupported COREWIDTH"
// #endif


#if COREWIDTH > 3
#error "Corewidth is too large for all TMA events"
#endif

#if COREWIDTH == 0
#error "Cannot have corewidth of 0"
#endif


#if (SCALAR == 0)
const char* counter_names[MAX_PMU_COUNT] = { \
    "Cycle", \
    "IntRet", \
    "Branch Mispredict", \
    "Flush", \
    "I$ Miss", \
    "D$ Miss", \
    "I$ Blocked", \
    "Recovering", \
    "D$ Blocked", \
    "Uops Retired", \
    "Fence Retired", \
    "Fetch Bubble", \
    "Uops Issued", \
    UNUSED, \
    UNUSED, \
    UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, \
    UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, \
    UNUSED, UNUSED, UNUSED \
};

#elif (COREWIDTH == 1)
const char* counter_names[MAX_PMU_COUNT] = { \
    "Cycle", \
    "Int Ret", \
    "Branch Mispredict", \
    "Flush", \
    "I$ Miss", \
    "D$ Miss", \
    "I$ Blocked", \
    "Recovering", \
    "D$ Blocked0", \
    "Uops Retired0", \
    "Fence Retired0", \
    "Fetch Bubble0", \
    "Uops Issued0", \
    "Uops Issued1", \
    "Uops Issued2", \
    UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, \
    UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, \
    UNUSED, UNUSED, UNUSED , UNUSED  \
};

#elif (COREWIDTH == 2)
const char* counter_names[MAX_PMU_COUNT] = { \
    "Cycle", \
    "Int Ret", \
    "Branch Mispredict", \
    "Flush", \
    "I$ Miss", \
    "D$ Miss", \
    "I$ Blocked", \
    "Recovering", \
    "D$ Blocked0", \
    "D$ Blocked1", \
    "Uops Retired0", \
    "Uops Retired1", \
    "Fence Retired0", \
    "Fence Retired1", \
    "Fetch Bubble0", \
    "Fetch Bubble1", \
    "Uops Issued0", \
    "Uops Issued1", \
    "Uops Issued2", \
    "Uops Issued3", \
    UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, \
    UNUSED, UNUSED, UNUSED, UNUSED, UNUSED\
};
#elif (COREWIDTH == 3)
const char* counter_names[MAX_PMU_COUNT] = { \
    "Cycle", \
    "Int Ret", \
    "Branch Mispredict", \
    "Flush", \
    "I$ Miss", \
    "D$ Miss", \
    "I$ Blocked", \
    "Recovering", \
    "D$ Blocked0", \
    "D$ Blocked1", \
    "D$ Blocked2", \
    "Uops Retired0", \
    "Uops Retired1", \
    "Uops Retired2", \
    "Fence Retired0", \
    "Fence Retired1", \
    "Fence Retired2", \
    "Fetch Bubble0", \
    "Fetch Bubble1", \
    "Fetch Bubble2", \
    "Uops Issued0", \
    "Uops Issued1", \
    "Uops Issued2", \
    "Uops Issued3", \
    "Uops Issued4", \
    UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED \
};
#else
#error "Unsupported Corewidth, we cannot use SCALAR=1 with COREWIDTH > 3 as there are not enough counters"
#endif


#else
#error "No Processor specificed, set either BOOM or ROCKET"
#endif /*BOOM*/


#endif /*TMA_DEFS_H_*/
