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
        # AAPCS callee-saved: r4-r11, r13 (sp), r14 (lr)
        #
        # Old stack pointer -> old_cstate[0]
        # Old link register -> old_cstate[1]
        str     sp,  [r0]
        str     lr,  [r0, #4]
        str     r11, [r0, #8]
        str     r10, [r0, #12]
        str     r9,  [r0, #16]
        str     r8,  [r0, #20]
        str     r7,  [r0, #24]
        str     r6,  [r0, #28]
        str     r5,  [r0, #32]
        str     r4,  [r0, #36]

        ldr     sp,  [r1]
        ldr     lr,  [r1, #4]
        ldr     r11, [r1, #8]
        ldr     r10, [r1, #12]
        ldr     r9,  [r1, #16]
        ldr     r8,  [r1, #20]
        ldr     r7,  [r1, #24]
        ldr     r6,  [r1, #28]
        ldr     r5,  [r1, #32]
        ldr     r4,  [r1, #36]

        # first==0 -> first activation -> new_context
        cmp     r2, #0
        beq     .L1

        # Return; lr (r14) holds the coswitch return address
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
