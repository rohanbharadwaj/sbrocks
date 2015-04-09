#ifndef _REGION_H
#define _REGION_H

#include <sys/defs.h>

enum mm_phy_reg
	{
	uint64_t base;
	uint64_t len;
	uint32_t type
} __attribute__((packet));

#endif