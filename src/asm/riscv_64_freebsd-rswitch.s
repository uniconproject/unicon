#
# Context switch for RISC-V 64 (RV64) / FreeBSD ELF.  Position-independent.
#
# cstate layout (14 words used; CStateSize is 15):
#   [0]  sp (x2)
#   [1]  ra (x1)
#   [2]  s0 / fp (x8)
#   [3]  s1 (x9)
#   [4]..[13]  s2-s11 (x18-x27)
#

        .file       "rswitch.s"
        .section    .rodata
.ERR:   .string     "new_context() returned in coswitch"
        .text
        .globl      coswitch
        .type       coswitch, @function

coswitch:
        # coswitch(old_cstate, new_cstate, first)
        #
        #     a0 (x10)  old_cstate
        #     a1 (x11)  new_cstate
        #     a2 (x12)  first (0 => first activation => new_context)
        #

        sd      sp,  0(a0)
        sd      ra,  8(a0)
        sd      s0,  16(a0)
        sd      s1,  24(a0)
        sd      s2,  32(a0)
        sd      s3,  40(a0)
        sd      s4,  48(a0)
        sd      s5,  56(a0)
        sd      s6,  64(a0)
        sd      s7,  72(a0)
        sd      s8,  80(a0)
        sd      s9,  88(a0)
        sd      s10, 96(a0)
        sd      s11, 104(a0)

        ld      sp,  0(a1)
        ld      ra,  8(a1)
        ld      s0,  16(a1)
        ld      s1,  24(a1)
        ld      s2,  32(a1)
        ld      s3,  40(a1)
        ld      s4,  48(a1)
        ld      s5,  56(a1)
        ld      s6,  64(a1)
        ld      s7,  72(a1)
        ld      s8,  80(a1)
        ld      s9,  88(a1)
        ld      s10, 96(a1)
        ld      s11, 104(a1)

        beqz    a2, .Lfirst
        ret

.Lfirst:
        li      a0, 0
        li      a1, 0
        call    new_context@plt
        lla     a0, .ERR
        tail    syserr@plt

        .size   coswitch, .-coswitch
