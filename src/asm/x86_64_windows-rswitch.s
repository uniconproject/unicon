#
# Context switch for AMD64 small model.  (Position-independent code.)
# Barry Schwartz, January 2005.
# Modified for x64 Windows by Shea Newton, June 2014
#
# See http://www.amd64.org/ for information about AMD64 programming.
#

        .file       "x86_64_windows-rswitch.s"
        .text
        .globl      coswitch

coswitch:
        # coswitch(old_cstate, new_cstate, first)
        #
        #     %rcx     old_cstate
        #     %rdx     new_cstate
        #     %r8d     first (equals 0 if first activation)
        #

        movq    %rsp, 0(%rcx)      # Old stack pointer -> old_cstate[0]
        movq    %rbp, 8(%rcx)      # Old base pointer -> old_cstate[1]
        movq    0(%rdx), %rsp      # new_cstate[0] -> new stack pointer
        movq    8(%rdx), %rbp      # new_cstate[1] -> new base pointer
        orl     %r8d, %r8d         # Is this the first activation?
        je      .L1                # If so, skip.
        ret                        # Otherwise we are done.
.L1:    xorl    %ecx, %ecx         # Call new_context((int) 0, (ptr) 0)
        xorl    %edx, %edx         # (Implicitly zero-extended to 64 bits)
        call    new_context@PLT
        leaq    .LC0(%rip), %rcx   # Call syserr(...)
        movl    $0, %eax
        jmp     syserr@PLT
.LC0:   .string     "new_context() returned in coswitch"
