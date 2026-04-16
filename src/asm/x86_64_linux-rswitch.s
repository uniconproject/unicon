#
# Context switch for AMD64 small model.  (Position-independent code.)
# Barry Schwartz, January 2005.
#
# See http://www.amd64.org/ for information about AMD64 programming.
# update by cvevans
#  at users.sourceforge
#  dot net

#if defined(__linux__) && defined(__ELF__)
.section        .note.GNU-stack, "", %progbits
#endif

        .file       "rswitch.s"

        .section    .rodata
.L0:    .string     "new_context() returned in coswitch"

        .globl      coswitch

        .text
        .globl      coswitch
        .type       coswitch, @function
coswitch:
        # coswitch(old_cstate, new_cstate, first)
        #
        #     %rdi     old_cstate
        #     %rsi     new_cstate
        #     %edx     first (0 => first activation => new_context)
        #

        movq    %rsp, 0(%rdi)      # old %rsp -> old_cstate[0]
        movq    %rbp, 8(%rdi)      # old %rbp -> old_cstate[1]
        movq    %rbp, 16(%rdi)     # old %rbp again -> old_cstate[2] (duplicate slot; see runtime)
        movq    %rbx, 24(%rdi)     # old %rbx -> old_cstate[3]
        movq    %r12, 32(%rdi)     # old %r12 -> old_cstate[4]
        movq    %r13, 40(%rdi)     # old %r13 -> old_cstate[5]
        movq    %r14, 48(%rdi)     # old %r14 -> old_cstate[6]
        movq    %r15, 56(%rdi)     # old %r15 -> old_cstate[7]
        movq    0(%rsi), %rsp      # new_cstate[0] -> %rsp
        movq    8(%rsi), %rbp      # new_cstate[1] -> %rbp
        movq    16(%rsi), %rbp     # new_cstate[2] -> %rbp (second load, same as [1])
        movq    24(%rsi), %rbx     # new_cstate[3] -> %rbx
        movq    32(%rsi), %r12     # new_cstate[4] -> %r12
        movq    40(%rsi), %r13     # new_cstate[5] -> %r13
        movq    48(%rsi), %r14     # new_cstate[6] -> %r14
        movq    56(%rsi), %r15     # new_cstate[7] -> %r15

        orl     %edx, %edx         # ZF set if first==0 (first activation)
        je      .L1                # first==0 -> new_context path
        ret                        # first!=0 -> return into restored context
.L1:    xorl    %edi, %edi         # new_context first arg = 0
        xorl    %esi, %esi         # new_context second arg = 0
        call    new_context@PLT
        leaq    .L0(%rip), %rdi    # message pointer for syserr (first arg)
        xorl    %eax, %eax         # clear %rax (ABI hygiene before tail to syserr)
        jmp     syserr@PLT
