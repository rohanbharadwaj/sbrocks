################################################################################
#  mem.s
#  Author: cds ( chris.stones _AT_ gmail.com )
#  17th Dec 2010
#  
#  i286 memcpy, memset and strcmp.
#
#  all given addresses are 20bit offsets from absolute zero.
#  any pre-set extra/data segments are ignored.
#
################################################################################

.code16gcc

################################################################
# void memcpy(void* dst,void* src,int size)
#
#   1) dst ( 20bit address ) ( absolute 0x00000 -> 0xfffff )
#   2) src ( 20bit address ) ( absolute 0x00000 -> 0xfffff )
#   3) size in bytes
################################################################
.global memcpy
            memcpy:
            pushl    %edi
            pushl    %esi
            pushl    %ds
            pushl    %es
						         # setup destination (es:edi)
            movl     20(%esp),    %edi       # edi = dst
            andl     $0x0ffff,    %edi       # edi &= 0xffff
            andl     $0xf0000,    20(%esp)   # dst  &= 0xf0000
            shrl     $4,          20(%esp)   # dst  >>= 4;
            movl     20(%esp),    %ecx       # es = dst
            movl     %ecx,        %es        #

			                           # setup source (ds::esi)
            movl     24(%esp),    %esi       # esi = src
            andl     $0x0ffff,    %esi       # esi &= 0xffff
            andl     $0xf0000,    24(%esp)   # src  &= 0xf0000
            shrl     $4,          24(%esp)   # src  >>= 4;
            movl     24(%esp),    %ecx       # ds = src
            movl     %ecx,        %ds

            xorl     %ecx,        %ecx
    .mc_begin:
            cmpl     %ecx,        28(%esp)   # increment counter and test for exit
            je       .mc_end
            incl     %ecx

	   ds movb     (%esi),      %al        # copy byte
         es movb     %al,         (%edi)

                                             # INCREMENT DST seg:offset
            incl     %edi
            cmpl     $0x10000,    %edi
            jne      .mc_edi
            movl     %es,         %edx
            addl     $0x1000,     %edx
            movl     %edx,        %es
            xorl     %edi,        %edi
    .mc_edi:
                                             # INCREMENT SRC seg:offset
            incl     %esi
            cmpl     $0x10000,    %esi
            jne     .mc_esi
            movl     %ds,         %edx
            addl     $0x1000,     %edx
            movl     %edx,        %ds
            xorl     %esi,        %esi
    .mc_esi:

            jmp .mc_begin

    .mc_end:
            popl     %es
            popl     %ds
            popl     %esi
            popl     %edi
            retl


################################################################
# void memset(void* dst,int fill,int size)
#
#   1) dst ( 20bit address ) ( absolute 0x00000 -> 0xfffff )
#   2) fill byte
#   3) size in bytes
################################################################
.global memset
            memset:
            pushl    %edi
			pushl    %es
						         # setup destination (es:edi)
            movl     12(%esp),    %edi       # edi = dst
            andl     $0x0ffff,    %edi       # edi &= 0xffff
            andl     $0xf0000,    12(%esp)   # dst  &= 0xf0000
            shrl     $4,          12(%esp)   # dst  >>= 4;
            movl     12(%esp),    %ecx       # es = dst
            movl     %ecx,        %es
            xorl     %ecx,        %ecx
    .ms_begin:
            cmpl     %ecx,        20(%esp)   # increment counter and test for exit
            je       .ms_end
            incl     %ecx

            movb     16(%esp),    %al        # es:edi = fill
         es movb     %al,         (%edi)

					               # INCREMENT DST seg:offset
            incl     %edi
            cmpl     $0x10000,    %edi
            jne      .ms_begin
            movl     %es,         %edx
            addl     $0x1000,     %edx
            movl     %edx,        %es
            xorl     %edi,        %edi
            jmp      .ms_begin
    .ms_end:
            popl     %es
            popl     %edi
            retl


################################################################
# int strlen(const void* s1)
#
#   1) s1 ( 20bit address ) ( absolute 0x00000 -> 0xfffff )
################################################################
.global strlen
		strlen:

            pushl    %ds
            pushl    %esi
				                             # setup source (ds:esi)
            movl     12(%esp),    %esi       # esi = src
            andl     $0x0ffff,    %esi       # esi &= 0xffff
            andl     $0xf0000,    12(%esp)   # src &= 0xf0000
            shrl     $4,          12(%esp)   # src >>= 4;
            movl     12(%esp),    %ecx       # ds = src
            movl     %ecx,        %ds

           xorl     %eax,        %eax        # reset return var

    .sl_loop:

         ds movb     (%esi),      %dl        # read s1

            cmpb     $0,         %dl         # null ?
            je      .sl_end

            incl     %eax                    # INCREMENT LENGTH

                                             # INCREMENT SRC seg:offset
            incl     %esi
            cmpl     $0x10000,    %esi
            jne      .sl_esi
            movl     %ds,         %edx
            addl     $0x1000,     %edx
            movl     %edx,        %ds
            xorl     %esi,        %esi
    .sl_esi:

            jmp      .sl_loop

    .sl_end:

            popl     %esi
            popl     %ds

            retl

################################################################
# int strcmp(void* s1, void* s2)
#
#   1) s1 ( 20bit address ) ( absolute 0x00000 -> 0xfffff )
#   2) s2 ( 20bit address ) ( absolute 0x00000 -> 0xfffff )
################################################################
.global strcmp
            strcmp:

            pushl    %es
            pushl    %edi
            pushl    %ds
            pushl    %esi

            xorl     %eax,        %eax
						         # setup destination (es:edi)
            movl     20(%esp),    %edi       # edi = dst
            andl     $0x0ffff,    %edi       # edi &= 0xffff
            andl     $0xf0000,    20(%esp)   # dst &= 0xf0000
            shrl     $4,          20(%esp)   # dst >>= 4;
            movl     20(%esp),    %ecx       # es = dst
            movl     %ecx,        %es        #

			                           # setup source (ds:esi)
            movl     24(%esp),    %esi       # esi = src
            andl     $0x0ffff,    %esi       # esi &= 0xffff
            andl     $0xf0000,    24(%esp)   # src &= 0xf0000
            shrl     $4,          24(%esp)   # src >>= 4;
            movl     24(%esp),    %ecx       # ds = src
            movl     %ecx,        %ds
           
    .sc_loop:

         ds movb     (%esi),      %ah        # read s1
         es movb     (%edi),      %al        # read s2

            cmpb     %al,         %ah        # different? return non-zero
            jnz      .sc_end

            cmpw     $0,          %ax        # both zero? return zero
            jz       .sc_end

                                             # same, not terminal, continue

                                             # INCREMENT DST seg:offset
            incl     %edi
            cmpl     $0x10000,    %edi
            jne      .sc_edi
            movl     %es,         %edx
            addl     $0x1000,     %edx
            movl     %edx,        %es
            xorl     %edi,        %edi
    .sc_edi:
                                             # INCREMENT SRC seg:offset
            incl     %esi
            cmpl     $0x10000,    %esi
            jne      .sc_esi
            movl     %ds,         %edx
            addl     $0x1000,     %edx
            movl     %edx,        %ds
            xorl     %esi,        %esi
    .sc_esi:

            jmp      .sc_loop

    .sc_end:

            popl     %esi
            popl     %ds
            popl     %edi
            popl     %es

            retl
