#ifndef __MMAP_H
#define __MMAP_H

#include "inttypes.h"

struct mmap_e820h_reg {

  union {
	struct {
	  int lsi;
	  int msi;
    } b32;
    uint64_t b64;
  }b;

  union {
    struct {
      int lsi;
      int msi;
    } l32;
    uint64_t l64;
  }l;

  int type;
  int extended;
};

struct mmap_e820h {

  short size;
  struct mmap_e820h_reg *map;
};

struct mmap_e820h *read_mmap();

#endif /*** __MMAP_H ***/

