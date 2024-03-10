#
#  Assembler source for context switch using gas 1.38.1 + gcc 1.40 on
#  Xenix/386, revamped slightly for use with Linux by me (Richard Goer-
#  witz) on 7/25/94.
#  updated for iconc by cvevans
#  at sourceforge
#
#if defined(__linux__) && defined(__ELF__)
.section        .note.GNU-stack, "", %progbits
#endif

.file   "rswitch.s"
.data 1
.text
        .align 4
.LC0:
        .string "new_context() returned in coswitch"   # .string "\0"
#       .byte 0x6e,0x65,0x77,0x5f,0x63,0x6f,0x6e,0x74,0x65,0x78
#       .byte 0x74,0x28,0x29,0x20,0x72,0x65,0x74,0x75,0x72,0x6e
#       .byte 0x65,0x64,0x20,0x69,0x6e,0x20,0x63,0x6f,0x73,0x77
#       .byte 0x69,0x74,0x63,0x68,0x0
# ^ # ^ checked rswitch.o, svn 3/2011 cvevans
.globl coswitch
.type coswitch,@function
# from rproto.h:
# int           coswitch        (word *old, word *new, int first);

coswitch:                       # %ebp, %ebx, %esi, %edi must be saved.
        pushl %ebp              # save ebp on stk. arg1 now at %esp+8, arg2 @ +12

        movl 8(%esp),%eax       # 2nd above sp -> eax := arg1, above ret & old ebp
        movl %esp,0(%eax)       # esp to (eax)    : arg1[0]:=esp
        movl %esp,4(%eax)       # esp to (eax)+4  : arg1[1]:=esp # esp for ebp, see below
        movl %ebp,8(%eax)       # ebp to (eax)+8  : arg1[2]:=ebp # not used, see below
        movl %ebx,12(%eax)      # ebx to (eax)+12 : arg1[3]:=ebx
        movl %esi,16(%eax)      # esi to (eax)+16 : arg1[4]:=esi
        movl %edi,20(%eax)      # edi to (eax)+20 : arg1[5]:=edi
        movl %esp,%ebp          # ebp := esp. no locals. arg1 at %ebp+8, arg2 @ +12
        movl 12(%esp),%eax      # 3rd above sp -> eax := arg2
        cmpl $0,16(%ebp)        # cmp 0 to 4th above esp : 0 = arg3
        movl 0(%eax),%esp       # mv (eax) to esp := arg2[0]
        je .L2                  # if arg3 was 0, goto L2 # delayed jump is faster.

        movl 4(%eax),%ebp       # arg2[1] -> ebp := arg2[1] # sp loaded above.
                                        # ebp not restored, it gets old %esp.
#       movl 8(%eax),%ebp       # arg2[2] -> ebp := arg2[2] # not done.
# restoring %ebp did NOT work.
        movl 12(%eax),%ebx      # arg2[3] -> ebx := arg2[3]
        movl 16(%eax),%esi      # arg2[4] -> esi := arg2[4]
        movl 20(%eax),%edi      # arg2[5] -> edi := arg2[5]
        jmp .L1                 # to leave, ret

.L2:                            # new context, first==0 # yes backwards.
        movl $0,%ebp            # ebp:=0
        pushl $0                # 2 0's
        pushl $0                # on stack
        call new_context        # new_context(0,0)
        pushl $.LC0             # should not return, push errmsg
        call syserr             # syserr(errmsg) # does not return.
        addl $12,%esp           # pop args I pushed for new_context & syserr. Never done.

.L1:
        leave                   # movl esp,ebp; popl ebp; # pop any locals, restore ebp
        ret                     # resume new context, not most recent caller.
