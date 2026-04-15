#
# Context switch for AMD64 Windows.  (Position-independent code.)
# Barry Schwartz, January 2005.
# Modified for x64 Windows by Shea Newton, June 2014
#
# Saves Microsoft x64 non-volatile GPRs: rsp, rbp (slots [0]-[2] as on
# SysV), rbx [3], rdi [4], rsi [5], r12-r15 [6]-[9].
#

        .file       "x86_64_windows-rswitch.s"
        .text
        .globl      coswitch

coswitch:
        # coswitch(old_cstate, new_cstate, first)
        #
        #     %rcx     old_cstate
        #     %rdx     new_cstate
        #     %r8d     first (0 => first activation => new_context)
        #

        movq    %rsp, 0(%rcx)      # old %rsp -> old_cstate[0]
        movq    %rbp, 8(%rcx)      # old %rbp -> old_cstate[1]
        movq    %rbp, 16(%rcx)     # old %rbp again -> old_cstate[2] (duplicate slot; see runtime)
        movq    %rbx, 24(%rcx)     # old %rbx -> old_cstate[3]
        movq    %rdi, 32(%rcx)     # old %rdi -> old_cstate[4] (Windows non-volatile)
        movq    %rsi, 40(%rcx)     # old %rsi -> old_cstate[5] (Windows non-volatile)
        movq    %r12, 48(%rcx)     # old %r12 -> old_cstate[6]
        movq    %r13, 56(%rcx)     # old %r13 -> old_cstate[7]
        movq    %r14, 64(%rcx)     # old %r14 -> old_cstate[8]
        movq    %r15, 72(%rcx)     # old %r15 -> old_cstate[9]

        movq    0(%rdx), %rsp      # new_cstate[0] -> %rsp
        movq    8(%rdx), %rbp      # new_cstate[1] -> %rbp
        movq    16(%rdx), %rbp     # new_cstate[2] -> %rbp (second load, same as [1])
        movq    24(%rdx), %rbx     # new_cstate[3] -> %rbx
        movq    32(%rdx), %rdi     # new_cstate[4] -> %rdi
        movq    40(%rdx), %rsi     # new_cstate[5] -> %rsi
        movq    48(%rdx), %r12     # new_cstate[6] -> %r12
        movq    56(%rdx), %r13     # new_cstate[7] -> %r13
        movq    64(%rdx), %r14     # new_cstate[8] -> %r14
        movq    72(%rdx), %r15     # new_cstate[9] -> %r15

        orl     %r8d, %r8d         # ZF set if first==0 (first activation)
        je      .L1                # first==0 -> new_context path
        ret                        # first!=0 -> return into restored context
.L1:
        xorl    %ecx, %ecx         # new_context first arg = 0 (RCX)
        xorl    %edx, %edx         # new_context second arg = 0 (RDX)
        call    new_context@PLT
        leaq    .LC0(%rip), %rcx   # message pointer for syserr (first arg on Windows)
        xorl    %eax, %eax
        jmp     syserr@PLT
.LC0:
        .string     "new_context() returned in coswitch"
