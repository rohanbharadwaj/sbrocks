/*
 * kbc.c
 *
 *  Created on: 9 Aug 2011
 *      Author: Chris Stones
 */

#include <arch/arch.h>
#include <lib/lib.h>

struct kbc_buffer_struct
{
	struct ticket_lock lock;
	uint8_t buffer[32];
	size_t   buffersize;
	uint16_t writepos;
	uint16_t readpos;
};

/*** todo - put this on the heap? ***/
static struct kbc_buffer_struct _kbc_buffer;
static struct kbc_buffer_struct *kbc_buffer = &_kbc_buffer;

void kbc_initialise() {

	kbc_buffer = &_kbc_buffer;
	memset(kbc_buffer,0, sizeof *kbc_buffer);
	kbc_buffer->buffersize = sizeof(kbc_buffer->buffer);
}


static size_t kbc_bytes_in_buffer__nolock__() {

	if(kbc_buffer->writepos >= kbc_buffer->readpos)
		return kbc_buffer->writepos - kbc_buffer->readpos;

	return kbc_buffer->writepos + (kbc_buffer->buffersize - kbc_buffer->readpos);
}

size_t kbc_bytes_in_buffer() {

//	sint8_t oldmask = ioapic_mask_irq( KBC_IRQ);

	ticket_lock_wait(&kbc_buffer->lock);

	size_t result = kbc_bytes_in_buffer__nolock__();

	ticket_lock_signal(&kbc_buffer->lock);

//	ioapic_setmask_irq(KBC_IRQ, oldmask);

	return (result);
}

static sint32_t kbc_readchar__nolock__() {

	if(!kbc_bytes_in_buffer__nolock__())
		return -1;

	sint32_t ret = (sint32_t)(kbc_buffer->buffer[kbc_buffer->readpos]);

	kbc_buffer->readpos ++;
	kbc_buffer->readpos %= kbc_buffer->buffersize;

	return (ret);
}

sint32_t kbc_readchar() {

//	sint8_t oldmask = ioapic_mask_irq( KBC_IRQ);

	ticket_lock_wait(&kbc_buffer->lock);

	sint32_t result = kbc_readchar__nolock__();

	ticket_lock_signal(&kbc_buffer->lock);

//	ioapic_setmask_irq(KBC_IRQ, oldmask);

	return (result);
}

static sint32_t kbc_read__nolock__(void* _dst, size_t size) {

	sint32_t c = 0;
	uint8_t *dst = (uint8_t*)_dst;
	sint32_t i = 0;

	while(size-- && ((c = kbc_readchar__nolock__()) >= 0))
		dst[i++] = (uint8_t)c;

	return (i);
}

sint32_t kbc_read(void* dst, size_t size) {

//	sint8_t oldmask = ioapic_mask_irq( KBC_IRQ);
	ticket_lock_wait(&kbc_buffer->lock);

	sint32_t result = kbc_read__nolock__(dst,size);

	ticket_lock_signal(&kbc_buffer->lock);
//	ioapic_setmask_irq(KBC_IRQ, oldmask);

	return (result);
}


static void queue_byte(uint8_t b) {

//	ticket_lock_wait(&kbc_buffer->lock);

	kbc_buffer->buffer[kbc_buffer->writepos] = b;
	kbc_buffer->writepos ++;
	kbc_buffer->writepos %= kbc_buffer->buffersize;

//	ticket_lock_signal(&kbc_buffer->lock);
}

void kbc_irq() {

	static uint8_t shift = 0;

	uint8_t b = port_inb(0x60);

	switch(b)
	{
	case KBCSC_LEFTSHIFT:
		shift |= 1;
		break;
	case KBCSC_RIGHTSHIFT:
		shift |= 2;
		break;
	case (KBCSC_LEFTSHIFT | 0x80):
		shift &= ~1;
		break;
	case (KBCSC_RIGHTSHIFT | 0x80):
		shift &= ~2;
	default:
		break;
	}

	uint8_t c = kbcsc_tochar(b, shift);

	if(c)
		queue_byte(c);
}


