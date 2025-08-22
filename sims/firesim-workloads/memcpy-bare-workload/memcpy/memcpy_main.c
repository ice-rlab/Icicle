// See LICENSE for license details.

//**************************************************************************
// Memcpy benchmark
//--------------------------------------------------------------------------
//
// This benchmark tests the memcpy implementation in syscalls.c.
// The input data (and reference data) should be generated using
// the memcpy_gendata.pl perl script and dumped to a file named
// dataset1.h.

#include <string.h>
#include "util.h"
#ifdef PMU
#include "pmu_defs.h"
#endif
#include "trigger.h"
// #define BARE

//--------------------------------------------------------------------------
// Input/Reference Data

#include "dataset1.h"

//--------------------------------------------------------------------------
// Main

int main( int argc, char* argv[] )
{
  int results_data[DATA_SIZE];

#if PREALLOCATE
  // If needed we preallocate everything in the caches
  memcpy(results_data, input_data, sizeof(int) * DATA_SIZE);
#endif
#ifdef PMU
  start_counters();
#endif
  // Do the riscv-linux memcpy
  FIRESIM_START_TRIGGER();
  FIRESIM_START_TRIGGER();
  FIRESIM_START_TRIGGER();
  FIRESIM_START_TRIGGER();
  FIRESIM_START_TRIGGER();
  FIRESIM_START_TRIGGER();
  memcpy(results_data, input_data, sizeof(int) * DATA_SIZE); //, DATA_SIZE * sizeof(int));
  FIRESIM_END_TRIGGER();
  FIRESIM_END_TRIGGER();
  FIRESIM_END_TRIGGER();
  FIRESIM_END_TRIGGER();
  FIRESIM_END_TRIGGER();
  FIRESIM_END_TRIGGER();
  FIRESIM_END_TRIGGER();

#ifdef PMU
  end_counters();
#endif
  // Check the results
  return verify( DATA_SIZE, results_data, input_data );
}
