#ifndef TRIGGER_H
#define TRIGGER_H

// firesim-start-trigger: emits `addi x0, x1, 0`
// Used to mark the beginning of a region of interest
#define FIRESIM_START_TRIGGER() \
    asm volatile ("addi x0, x1, 0" ::: "memory") 

// firesim-end-trigger: emits `addi x0, x2, 0`
// Used to mark the end of a region of interest
// repeat this instruction multiple times, as it otherwise sometimes won't get picked up?
#define FIRESIM_END_TRIGGER() \
  do {                                   \
    asm volatile("addi x0, x2, 0"::: "memory");         \
    asm volatile("addi x0, x2, 0"::: "memory");         \
    asm volatile("addi x0, x2, 0"::: "memory");         \
    asm volatile("addi x0, x2, 0"::: "memory");         \
    asm volatile("addi x0, x2, 0"::: "memory");         \
    asm volatile("addi x0, x2, 0"::: "memory");         \
    asm volatile("addi x0, x2, 0"::: "memory");         \
    asm volatile("addi x0, x2, 0"::: "memory");         \
  } while (0)

#endif 