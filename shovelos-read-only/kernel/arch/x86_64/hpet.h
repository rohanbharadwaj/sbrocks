/*
 * hpet.h
 *
 *  Created on: 23 Aug 2011
 *      Author: Chris Stones
 */

#ifndef HPET_H_
#define HPET_H_

#include <inttypes.h>

uint8_t hpet_init(void);


uint64_t hpet_read_main_counter(void);
uint64_t hpet_clock_period(void);
void hpet_wait_picoseconds(uint64_t picoseconds);
void hpet_wait_nanoseconds(uint64_t nanoseconds);
void hpet_wait_microseconds(uint64_t microseconds);
void hpet_wait_milliseconds(uint64_t milliseconds);
void hpet_wait_seconds(uint64_t seconds);

#endif /* HPET_H_ */

