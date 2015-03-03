/*
 * ticket_lock.s
 *
 *  Created on: Mar 16, 2011
 *      Author: cds
 */

.text

######################################################################
# ticket_lock_wait
#   aquire a fifo spin-lock
#   void ticket_lock_wait( struct ticket_lock * ticket_lock)
######################################################################

.global ticket_lock_wait
ticket_lock_wait:

          movw       $1,       %ax      # take a ticket
	lock  xaddw     %ax,      (%rdi)

.ticket_lock_wait_retry:                # wait our turn ?
          pause
          cmpw      %ax,     2(%rdi)
          jne .ticket_lock_wait_retry

.ticket_lock_aquired:

          # store the lock holders interrupt state
          movb         $0,      4(%rdi)
          pushfq
          testq    $0x200,       (%rsp)
          jz .ticket_lock_done
          movb         $1,      4(%rdi)
.ticket_lock_done:
          addq         $8, %rsp

		  cli
		  retq


######################################################################
# ticket_lock_signal
#   release a fifo spin-lock
#   void ticket_lock_signal( struct ticket_lock * ticket_lock)
######################################################################

.global ticket_lock_signal
ticket_lock_signal:

         movb   4(%rdi), %al     # read callers old interrupt state

.ticket_lock_signal_rlease:

    lock incw 2(%rdi)

.ticket_lock_released:

         cmpb        $0,   %al

         je .ticket_lock_return

         sti

.ticket_lock_return:
         retq

