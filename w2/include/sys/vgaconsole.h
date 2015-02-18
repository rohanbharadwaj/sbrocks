#ifndef __VGACONSOLE_H
#define __VGACONSOLE_H
#include <sys/kstring.h>

void putch(char ch);
void setcolor(char background, char foreground);
void puts(const char *str);
void clearscreen();
#endif