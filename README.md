# sbrocks
A 64 bit Unix OS developed at SBU

##Warm-up Project #1 (Part 1 of 2): The Shell
- Implement a shell – sbush, must be able to …
- Support changing current directory ( cd )
- Execute binaries interactively
- Execute scripts
- Execute pipelines of binaries ( /bin/ls | /bin/grep test )
- Set and use PATH and PS1 variables

##Warm-up Project #1 (Part 2 of 2): The Standard Library
- Implement a standard library – sblibc, must be able to …
- Provide all functionality needed by your sbush
- Implement all functions from include/stdlib.h
- implement bin/ls and bin/cat to test them
- Rely on 64-bit Linux syscall numbers and conventions

How to test ??
```
- ls -l
- ls -l | head -5 | tail -3 (give spaces)
- cd 
- cd ../.. (and other variants)
- set PS1 any-string 
- set PATH any-path 
```

Warm -Up project 1:
Instructions to Compile & Run:
The provided Makefile:will compile the sbush.c and copies the object file in to rootfs/bin
the below functionality can be checked by running the provided sample commands

Support changing current director     - By typing cd and the directory name at command prompt.
Execute binaries interactively
Execute scripts
Execute pipelines of binaries - By typing commands like `ls -l | head -5 | tail -2` at command prompt.
Set and use PATH and PS1 variables : Using the below commands at command prompt
```
$set PS1 sbush
$set PATH abc
$ $PATH
```
