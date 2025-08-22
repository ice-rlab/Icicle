#include "pmu_defs.h"
#define MISS(n)  \
    asm volatile ("beq a5,zero,.LB" #n); \
    asm volatile ("addi x0, x0, 0"); \
    asm volatile ("j	.LA" #n); \
    asm volatile (".LB"#n ":"); \
    asm volatile ("addi x0, x0, 0"); \
    asm volatile ("j	.LA" #n); \
    asm volatile (".LA" #n":"); 


int main(){

    printf("Base:\n");
    // Branch miss
    start_counters(); 

	asm volatile("li a5,0");
    #include "generated_miss_1.h"


    end_counters();  


    printf("Inverted:\n");
    // Inverted
    start_counters(); 

	asm volatile("li a5,1");
    #include "generated_miss_2.h"


    end_counters();  
}