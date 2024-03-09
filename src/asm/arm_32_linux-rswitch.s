#
# Context switch for ARM32/Linux.  (Position-independent code.)
# Jafar Al-Gharaibeh, April 2016.
#
#
        .file       "rswitch.s"
        .section    .rodata
        .ERR:        .string     "new_context() returned in coswitch"
        .text
        .globl     coswitch
        .type      coswitch, %function

coswitch:
        # coswitch(old_cstate, new_cstate, first)
        #
        #     r0     old_cstate
        #     r1     new_cstate
        #     r2     first (equals 0 if first activation)
        #
        #     sp is r13
        #     lr is r14
        #     pc is r15
        #
        # Must save   : r11, r13-r14
        # Don't touch : r15
        # Good measure: r10
        # Scratch     : r0-r3, r12
        # Others      : r4-r9
        #
        # Old stack pointer -> old_cstate[0]
        # Old link register -> old_cstate[1]
        str     sp,  [r0]
        str     lr,  [r0, #4]
        # frame pointer
        str     r11, [r0, #8]
        str     r10, [r0, #12]

#       str     r9,  [r0, #16]
#       str     r8,  [r0, #20]
#       str     r7,  [r0, #24]
#       str     r6,  [r0, #28]
#       str     r5,  [r0, #32]
#       str     r4,  [r0, #36]

        # Otherwise load the new state
        # new_cstate[0] -> new stack pointer
        # new_cstate[1] -> new link register
        ldr     sp,  [r1]
        ldr     lr,  [r1, #4]
        # frame pointer
        ldr     r11, [r1, #8]
        ldr     r10, [r1, #12]

#       ldr     r9,  [r1, #16]
#       ldr     r8,  [r1, #20]
#       ldr     r7,  [r1, #24]
#       ldr     r6,  [r1, #28]
#       ldr     r5,  [r1, #32]
#       ldr     r4,  [r1, #36]

        # If this the first activation
        # skip to call new_context()
        cmp     r2, #0
        beq     .L1

        # Ready to return, lr (r13) now has the return address
        bx      lr

.L1:
        # Executed only once, first==0
        #
        # Call new_context((int) 0, (ptr) 0)
        # set the arguments r0 and r1 to zeros
        mov     r0, #0
        mov     r1, #0
        bl      new_context@PLT
        # we should never get here, if we do call syserr(...)
        ldr     r0, =.ERR
        bl      syserr@PLT
