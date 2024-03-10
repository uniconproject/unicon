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
        #     %edx     first (equals 0 if first activation)
        #

        movq    %rsp, 0(%rdi)      # Old stack pointer -> old_cstate[0]
        movq    %rbp, 8(%rdi)      # Old base pointer -> old_cstate[1]
        movq    %rbp, 16(%rdi)      # Old base pointer -> old_cstate[2]
        movq    %rbx, 24(%rdi)      # Old bx -> old_cstate[3]
        movq    %r12, 32(%rdi)      # Old r12 -> old_cstate[4]
        movq    %r13, 40(%rdi)      # Old r13 -> old_cstate[5]
        movq    %r14, 48(%rdi)      # Old r14 -> old_cstate[6]
        movq    %r15, 56(%rdi)      # Old r15 -> old_cstate[7]
        movq    0(%rsi), %rsp      # new_cstate[0] -> new stack pointer
        movq    8(%rsi), %rbp      # new_cstate[1] -> new base pointer
        movq    16(%rsi), %rbp      # new_cstate[2] -> new base pointer
        movq    24(%rsi), %rbx      # new_cstate[3] -> new bx
        movq    32(%rsi), %r12      # new_cstate[4] -> new r12
        movq    40(%rsi), %r13      # new_cstate[5] -> new r13
        movq    48(%rsi), %r14      # new_cstate[6] -> new r14
        movq    56(%rsi), %r15      # new_cstate[7] -> new r15

        orl     %edx, %edx         # Is this the first activation?
        je      .L1                # If so, skip.
        ret                        # Otherwise we are done.
.L1:    xorl    %edi, %edi         # Call new_context((int) 0, (ptr) 0)
        xorl    %esi, %esi         # (Implicitly zero-extended to 64 bits)
        call    new_context@PLT
        leaq    .L0(%rip), %rdi    # Call syserr(...)
        xorl    %eax, %eax         # 0 to return
        jmp     syserr@PLT
