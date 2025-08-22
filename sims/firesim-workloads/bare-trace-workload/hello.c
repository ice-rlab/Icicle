#include <stdio.h>
#include "trigger.h"

int main(void)
{ 

  FIRESIM_START_TRIGGER();
  printf("Hello World\n");
  FIRESIM_END_TRIGGER();
  printf("Hello World\n");
  printf("Ended Trigger\n");
  printf("Ended Trigger\n");
  printf("Ended Trigger\n");
  // FIRESIM_START_TRIGGER();
  // printf("Hello World\n");
  // printf("Hello World\n");
  // printf("Hello World\n");
  // printf("Hello World\n");
  // printf("Hello World\n");
  // Add some floating point instructions to activate the FPU
  float f = 3.1414151251;
  float y = f / 3.0;
  f += 1.0;
  f += 1.0;
  f += 1.0;
  f += 1.0;
  int i = 0;
  i +=1;
  // FIRESIM_END_TRIGGER();
  i +=1;
  i +=1;
  printf("y: %f\n", y);
	return 0;
}
