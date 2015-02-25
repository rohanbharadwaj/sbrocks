/*
 * kbc_scancodes.c
 *
 *  Created on: 11 Aug 2011
 *      Author: Chris Stones
 */

#include <inttypes.h>
#include "kbc_scancodes.h"

static uint8_t char_shift_adjust(uint8_t c, uint8_t shift) {

	return c + (shift ? ('A'-'a') : 0);
}

uint8_t kbcsc_tochar(uint8_t b, uint8_t shift) {

	if(b==KBCSC_SPACE)
		return ' ';

	if(b==KBCSC_RETURN)
		return '\n';

	if((b >= KBCSC_Q) && (b <= KBCSC_P))
		return char_shift_adjust("qwertyuiop"[b-KBCSC_Q], shift);

	if((b >= KBCSC_A) && (b <= KBCSC_L))
		return char_shift_adjust("asdfghjkl"[b-KBCSC_A], shift);

	if((b >= KBCSC_Z) && (b <= KBCSC_M))
		return char_shift_adjust("zxcvbnm"[b-KBCSC_Z], shift);

	if((b >= KBCSC_1) && (b <= KBCSC_9)) {
		if(shift)
			return "!\"£$%^&*("[b-KBCSC_1];
		return '1' + b-KBCSC_1;
	}

	if(b == KBCSC_0)
		return shift ? ')' : '0';

	return 0;
}

