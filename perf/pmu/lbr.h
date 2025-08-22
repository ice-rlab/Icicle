#ifndef LBR_H_
#define LBR_H_

#include <riscv-pk/encoding.h>
#include "lbr_encoding.h"
#include <stdio.h>

// Read all LBR entries
void __attribute__((always_inline)) dump_lbr()
{

    unsigned long long lb_to_0  = read_csr(0xcc0);
    unsigned long long lb_from_0 = read_csr(0xcc1);
    unsigned long long lb_to_1  = read_csr(0xcc2);
    unsigned long long lb_from_1 = read_csr(0xcc3);
    unsigned long long lb_to_2  = read_csr(0xcc4);
    unsigned long long lb_from_2 = read_csr(0xcc5);
    unsigned long long lb_to_3  = read_csr(0xcc6);
    unsigned long long lb_from_3 = read_csr(0xcc7);
    unsigned long long lb_to_4  = read_csr(0xcc8);
    unsigned long long lb_from_4 = read_csr(0xcc9);
    unsigned long long lb_to_5  = read_csr(0xcca);
    unsigned long long lb_from_5 = read_csr(0xccb);
    unsigned long long lb_to_6  = read_csr(0xccc);
    unsigned long long lb_from_6 = read_csr(0xccd);
    unsigned long long lb_to_7  = read_csr(0xcce);
    unsigned long long lb_from_7 = read_csr(0xccf);
    unsigned long long lb_to_8  = read_csr(0xcd0);
    unsigned long long lb_from_8 = read_csr(0xcd1);
    unsigned long long lb_to_9  = read_csr(0xcd2);
    unsigned long long lb_from_9 = read_csr(0xcd3);
    unsigned long long lb_to_10 = read_csr(0xcd4);
    unsigned long long lb_from_10= read_csr(0xcd5);
    unsigned long long lb_to_11 = read_csr(0xcd6);
    unsigned long long lb_from_11= read_csr(0xcd7);
    unsigned long long lb_to_12 = read_csr(0xcd8);
    unsigned long long lb_from_12= read_csr(0xcd9);
    unsigned long long lb_to_13 = read_csr(0xcda);
    unsigned long long lb_from_13= read_csr(0xcdb);
    unsigned long long lb_to_14 = read_csr(0xcdc);
    unsigned long long lb_from_14= read_csr(0xcdd);
    unsigned long long lb_to_15 = read_csr(0xcde);
    unsigned long long lb_from_15= read_csr(0xcdf);
    unsigned long long lb_to_16 = read_csr(0xce0);
    unsigned long long lb_from_16= read_csr(0xce1);
    unsigned long long lb_to_17 = read_csr(0xce2);
    unsigned long long lb_from_17= read_csr(0xce3);
    unsigned long long lb_to_18 = read_csr(0xce4);
    unsigned long long lb_from_18= read_csr(0xce5);
    unsigned long long lb_to_19 = read_csr(0xce6);
    unsigned long long lb_from_19= read_csr(0xce7);
    unsigned long long lb_to_20 = read_csr(0xce8);
    unsigned long long lb_from_20= read_csr(0xce9);
    unsigned long long lb_to_21 = read_csr(0xcea);
    unsigned long long lb_from_21= read_csr(0xceb);
    unsigned long long lb_to_22 = read_csr(0xcec);
    unsigned long long lb_from_22= read_csr(0xced);
    unsigned long long lb_to_23 = read_csr(0xcee);
    unsigned long long lb_from_23= read_csr(0xcef);
    unsigned long long lb_to_24 = read_csr(0xcf0);
    unsigned long long lb_from_24= read_csr(0xcf1);
    unsigned long long lb_to_25 = read_csr(0xcf2);
    unsigned long long lb_from_25= read_csr(0xcf3);
    unsigned long long lb_to_26 = read_csr(0xcf4);
    unsigned long long lb_from_26= read_csr(0xcf5);
    unsigned long long lb_to_27 = read_csr(0xcf6);
    unsigned long long lb_from_27= read_csr(0xcf7);
    unsigned long long lb_to_28 = read_csr(0xcf8);
    unsigned long long lb_from_28= read_csr(0xcf9);
    unsigned long long lb_to_29 = read_csr(0xcfa);
    unsigned long long lb_from_29= read_csr(0xcfb);
    unsigned long long lb_to_30 = read_csr(0xcfc);
    unsigned long long lb_from_30= read_csr(0xcfd);
    unsigned long long lb_to_31 = read_csr(0xcfe);
    unsigned long long lb_from_31= read_csr(0xcff);


    // TODO: Why these macros not working?
    // unsigned long long lb_to_0 = read_csr(CSR_LBTO0);
    // unsigned long long lb_from_0 = read_csr(lbfrom0);
    // unsigned long long lb_to_1 = read_csr(lbto1);
    // unsigned long long lb_from_1 = read_csr(lbfrom1);
    // unsigned long long lb_to_2 = read_csr(lbto2);
    // unsigned long long lb_from_2 = read_csr(lbfrom2);
    // unsigned long long lb_to_3 = read_csr(lbto3);
    // unsigned long long lb_from_3 = read_csr(lbfrom3);
    // unsigned long long lb_to_4 = read_csr(lbto4);
    // unsigned long long lb_from_4 = read_csr(lbfrom4);
    // unsigned long long lb_to_5 = read_csr(lbto5);
    // unsigned long long lb_from_5 = read_csr(lbfrom5);
    // unsigned long long lb_to_6 = read_csr(lbto6);
    // unsigned long long lb_from_6 = read_csr(lbfrom6);
    // unsigned long long lb_to_7 = read_csr(lbto7);
    // unsigned long long lb_from_7 = read_csr(lbfrom7);
    // unsigned long long lb_to_8 = read_csr(lbto8);
    // unsigned long long lb_from_8 = read_csr(lbfrom8);
    // unsigned long long lb_to_9 = read_csr(lbto9);
    // unsigned long long lb_from_9 = read_csr(lbfrom9);
    // unsigned long long lb_to_10 = read_csr(lbto10);
    // unsigned long long lb_from_10 = read_csr(lbfrom10);
    // unsigned long long lb_to_11 = read_csr(lbto11);
    // unsigned long long lb_from_11 = read_csr(lbfrom11);
    // unsigned long long lb_to_12 = read_csr(lbto12);
    // unsigned long long lb_from_12 = read_csr(lbfrom12);
    // unsigned long long lb_to_13 = read_csr(lbto13);
    // unsigned long long lb_from_13 = read_csr(lbfrom13);
    // unsigned long long lb_to_14 = read_csr(lbto14);
    // unsigned long long lb_from_14 = read_csr(lbfrom14);
    // unsigned long long lb_to_15 = read_csr(lbto15);
    // unsigned long long lb_from_15 = read_csr(lbfrom15);
    // unsigned long long lb_to_16 = read_csr(lbto16);
    // unsigned long long lb_from_16 = read_csr(lbfrom16);
    // unsigned long long lb_to_17 = read_csr(lbto17);
    // unsigned long long lb_from_17 = read_csr(lbfrom17);
    // unsigned long long lb_to_18 = read_csr(lbto18);
    // unsigned long long lb_from_18 = read_csr(lbfrom18);
    // unsigned long long lb_to_19 = read_csr(lbto19);
    // unsigned long long lb_from_19 = read_csr(lbfrom19);
    // unsigned long long lb_to_20 = read_csr(lbto20);
    // unsigned long long lb_from_20 = read_csr(lbfrom20);
    // unsigned long long lb_to_21 = read_csr(lbto21);
    // unsigned long long lb_from_21 = read_csr(lbfrom21);
    // unsigned long long lb_to_22 = read_csr(lbto22);
    // unsigned long long lb_from_22 = read_csr(lbfrom22);
    // unsigned long long lb_to_23 = read_csr(lbto23);
    // unsigned long long lb_from_23 = read_csr(lbfrom23);
    // unsigned long long lb_to_24 = read_csr(lbto24);
    // unsigned long long lb_from_24 = read_csr(lbfrom24);
    // unsigned long long lb_to_25 = read_csr(lbto25);
    // unsigned long long lb_from_25 = read_csr(lbfrom25);
    // unsigned long long lb_to_26 = read_csr(lbto26);
    // unsigned long long lb_from_26 = read_csr(lbfrom26);
    // unsigned long long lb_to_27 = read_csr(lbto27);
    // unsigned long long lb_from_27 = read_csr(lbfrom27);
    // unsigned long long lb_to_28 = read_csr(lbto28);
    // unsigned long long lb_from_28 = read_csr(lbfrom28);
    // unsigned long long lb_to_29 = read_csr(lbto29);
    // unsigned long long lb_from_29 = read_csr(lbfrom29);
    // unsigned long long lb_to_30 = read_csr(lbto30);
    // unsigned long long lb_from_30 = read_csr(lbfrom30);
    // unsigned long long lb_to_31 = read_csr(lbto31);
    // unsigned long long lb_from_31 = read_csr(lbfrom31);

    // Print each entry sequentially
    printf("LBR[0]:  %llx: --> %llx:\n", lb_from_0, lb_to_0);
    printf("LBR[1]:  %llx: --> %llx:\n", lb_from_1, lb_to_1);
    printf("LBR[2]:  %llx: --> %llx:\n", lb_from_2, lb_to_2);
    printf("LBR[3]:  %llx: --> %llx:\n", lb_from_3, lb_to_3);
    printf("LBR[4]:  %llx: --> %llx:\n", lb_from_4, lb_to_4);
    printf("LBR[5]:  %llx: --> %llx:\n", lb_from_5, lb_to_5);
    printf("LBR[6]:  %llx: --> %llx:\n", lb_from_6, lb_to_6);
    printf("LBR[7]:  %llx: --> %llx:\n", lb_from_7, lb_to_7);
    printf("LBR[8]:  %llx: --> %llx:\n", lb_from_8, lb_to_8);
    printf("LBR[9]:  %llx: --> %llx:\n", lb_from_9, lb_to_9);
    printf("LBR[10]: %llx: --> %llx:\n", lb_from_10, lb_to_10);
    printf("LBR[11]: %llx: --> %llx:\n", lb_from_11, lb_to_11);
    printf("LBR[12]: %llx: --> %llx:\n", lb_from_12, lb_to_12);
    printf("LBR[13]: %llx: --> %llx:\n", lb_from_13, lb_to_13);
    printf("LBR[14]: %llx: --> %llx:\n", lb_from_14, lb_to_14);
    printf("LBR[15]: %llx: --> %llx:\n", lb_from_15, lb_to_15);
    printf("LBR[16]: %llx: --> %llx:\n", lb_from_16, lb_to_16);
    printf("LBR[17]: %llx: --> %llx:\n", lb_from_17, lb_to_17);
    printf("LBR[18]: %llx: --> %llx:\n", lb_from_18, lb_to_18);
    printf("LBR[19]: %llx: --> %llx:\n", lb_from_19, lb_to_19);
    printf("LBR[20]: %llx: --> %llx:\n", lb_from_20, lb_to_20);
    printf("LBR[21]: %llx: --> %llx:\n", lb_from_21, lb_to_21);
    printf("LBR[22]: %llx: --> %llx:\n", lb_from_22, lb_to_22);
    printf("LBR[23]: %llx: --> %llx:\n", lb_from_23, lb_to_23);
    printf("LBR[24]: %llx: --> %llx:\n", lb_from_24, lb_to_24);
    printf("LBR[25]: %llx: --> %llx:\n", lb_from_25, lb_to_25);
    printf("LBR[26]: %llx: --> %llx:\n", lb_from_26, lb_to_26);
    printf("LBR[27]: %llx: --> %llx:\n", lb_from_27, lb_to_27);
    printf("LBR[28]: %llx: --> %llx:\n", lb_from_28, lb_to_28);
    printf("LBR[29]: %llx: --> %llx:\n", lb_from_29, lb_to_29);
    printf("LBR[30]: %llx: --> %llx:\n", lb_from_30, lb_to_30);
    printf("LBR[31]: %llx: --> %llx:\n", lb_from_31, lb_to_31);
}

#endif LBR_H_