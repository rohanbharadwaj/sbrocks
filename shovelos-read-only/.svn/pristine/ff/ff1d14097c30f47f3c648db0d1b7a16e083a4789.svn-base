

#ifndef __STREAM_H
#define __STREAM_H

#include<inttypes.h>
#include<arch/arch.h>

struct stream {

	struct ticket_lock lock;
	sint64_t (*write)(const void* byte, size_t size);
	sint64_t (*read) (void* out, size_t size);
};

struct stream* global_console_stream();
struct stream* new_console_stream();

#endif /*** __STREAM_H ***/

