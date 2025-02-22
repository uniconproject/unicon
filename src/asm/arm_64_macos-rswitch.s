#
# Context switch for ARM64/Linux (aarch64).  (Position-independent code.)
# Jafar Al-Gharaibeh, Nov 2016.
#
#
        .file       "rswitch.s"
        .section    .rodata
        .ERR:       .string     "new_context() returned in coswitch"
        .text
        .globl     coswitch
        .type      coswitch, %function

coswitch:
        # coswitch(old_cstate, new_cstate, first)
        #
        #     x0     old_cstate
        #     x1     new_cstate
        #     x2     first (equals 0 if first activation)
        #
        #     sp   x31? , in arm32  r13
        #     pc        , in arm32  r15
        #     lr is x30 , in arm32  r14
        #
        # args : r0-r7
        # r8 indirect location, c++?
        # Must save   : r30, r31, r18
        # Don't touch : r?
        # Good measure: r18-28
        # Scratch     : r9-r15
        # Others      : ?
        #
        # Old stack pointer -> old_cstate[0]
        # Old link register -> old_cstate[1]
        mov     x9,  sp
        str     x9,  [x0]
        mov     x9,  x30
        str     x9,  [x0, #8]
        # frame pointer
        str     x29, [x0, #16]

        str     x18, [x0, #24]
        str     x19, [x0, #32]
        str     x20, [x0, #40]
        str     x21, [x0, #48]
        str     x22, [x0, #56]
        str     x23, [x0, #64]
        str     x24, [x0, #72]
        str     x25, [x0, #80]
        str     x26, [x0, #88]
        str     x27, [x0, #96]
        str     x28, [x0, #104]

        # Otherwise load the new state
        # new_cstate[0] -> new stack pointer
        # new_cstate[1] -> new link register
        ldr     x9,  [x1]
        mov     sp,  x9
        ldr     x9,  [x1, #8]
        mov     x30,  x9
        # frame pointer
        ldr     x29, [x1, #16]

        ldr     x18, [x1, #24]
        ldr     x19, [x1, #32]
        ldr     x20, [x1, #40]
        ldr     x21, [x1, #48]
        ldr     x22, [x1, #56]
        ldr     x23, [x1, #64]
        ldr     x24, [x1, #72]
        ldr     x25, [x1, #80]
        ldr     x26, [x1, #88]
        ldr     x27, [x1, #96]
        ldr     x28, [x1, #104]


        # If this the first activation
        # skip to call new_context()
        cmp     x2, #0
        beq     .L1

        # Ready to return
        ret

.L1:
        # Executed only once, first==0
        #
        # Call new_context((int) 0, (ptr) 0)
        # set the arguments x0 and x1 to zeros
        mov     x0, #0
        mov     x1, #0
        bl      new_context
        # we should never get here, if we do call syserr(...)
        ldr     x0, =.ERR
        bl      syserr
