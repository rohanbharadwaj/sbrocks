/*
 * gdt.c
 *
 *  Created on: Dec 29, 2010
 *      Author: cds
 */

#include "x86_64.h"
#include <inttypes.h>

#define GDT_CS        (0x00180000000000)  /*** code segment descriptor ***/
#define GDT_DS        (0x00100000000000)  /*** data segment descriptor ***/

#define C             (0x00040000000000)  /*** conforming ***/
#define DPL0          (0x00000000000000)  /*** descriptor privilege level 0 ***/
#define DPL1          (0x00200000000000)  /*** descriptor privilege level 1 ***/
#define DPL2          (0x00400000000000)  /*** descriptor privilege level 2 ***/
#define DPL3          (0x00600000000000)  /*** descriptor privilege level 3 ***/
#define P             (0x00800000000000)  /*** present ***/
#define L             (0x20000000000000)  /*** long mode ***/
#define D             (0x40000000000000)  /*** default op size ***/
#define W             (0x00020000000000)  /***writable data segment ***/


static uint64_t gdt[] = {

    0,                      /*** NULL descriptor ***/
    GDT_CS | P | DPL0 | L,  /*** kernel code segment descriptor ***/
    GDT_DS | P | W,         /*** kernel data segment descriptor ***/
};

struct gdtr_t {

	uint16_t size;
	uint64_t addr;
}__attribute__((packed));

static struct gdtr_t gdtr = {

    sizeof(gdt),
    (uint64_t)gdt,
};

void _x86_64_load_gdt() {

	_x86_64_asm_lgdt(&gdtr, 8, 16);
}

