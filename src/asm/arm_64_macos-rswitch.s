#
# Context switch for ARM64/macOS (aarch64).  (Position-independent code.)
# Jafar Al-Gharaibeh, Nov 2016.
# Ian McLinden, Feb 2025.
#
#

.data
.ERR:   .ascii     "new_context() returned in coswitch"

.text
        .p2align    4 ; 16 byte word boundary
        .file       "rswitch.s"
        .text
        .globl      _coswitch, _syserr

_coswitch:
        # _coswitch(old_cstate, new_cstate, first)
        #
        #     x0     old_cstate
        #     x1     new_cstate
        #     x2     first (equals 0 if first activation)
        #
        #     fp is x29
        #     lr is x30 , in arm32  r14
        #     sp        , in arm32  r13
        #     pc        , in arm32  r15
        #
        # args : x0-x7
        # r8 indirect location, c++?
        # Scratch      : x9-x15
        # Don't touch  : x18 (platform register - reserved by Rosetta)
        # Callee-saved : x19-x28 (must be restored if used)
        # Must save    : xr30, x31
        # Others       : ?
        #
        # Old stack pointer -> old_cstate[0]
        # Old link register -> old_cstate[1]
        mov     x9,  sp
        str     x9,  [x0]
        mov     x9,  x30
        str     x9,  [x0, #8]
        # frame pointer
        str     x29, [x0, #16]

        str     x19, [x0, #24]
        str     x20, [x0, #32]
        str     x21, [x0, #40]
        str     x22, [x0, #48]
        str     x23, [x0, #56]
        str     x24, [x0, #64]
        str     x25, [x0, #72]
        str     x26, [x0, #80]
        str     x27, [x0, #88]
        str     x28, [x0, #96]

        # Otherwise load the new state
        # new_cstate[0] -> new stack pointer
        # new_cstate[1] -> new link register
        ldr     x9,  [x1]
        mov     sp,  x9
        ldr     x9,  [x1, #8]
        mov     x30,  x9
        # frame pointer
        ldr     x29, [x1, #16]

        ldr     x19, [x1, #24]
        ldr     x20, [x1, #32]
        ldr     x21, [x1, #40]
        ldr     x22, [x1, #48]
        ldr     x23, [x1, #56]
        ldr     x24, [x1, #64]
        ldr     x25, [x1, #72]
        ldr     x26, [x1, #80]
        ldr     x27, [x1, #88]
        ldr     x28, [x1, #96]


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
        bl      _new_context
        # we should never get here, if we do call syserr(...)
        adrp    x0, .ERR@PAGE
        add     x0, x0, .ERR@PAGEOFF
        bl      _syserr
