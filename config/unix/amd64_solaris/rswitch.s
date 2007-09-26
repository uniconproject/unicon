#
# Context switch for AMD64 small model.  (Position-independent code.)
# Barry Schwartz, January 2005.
#
# See http://www.amd64.org/ for information about AMD64 programming.
#

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
        movq    0(%rsi), %rsp      # new_cstate[0] -> new stack pointer
        movq    8(%rsi), %rbp      # new_cstate[1] -> new base pointer
        orl     %edx, %edx         # Is this the first activation?
        je      .L1                # If so, skip.
        ret                        # Otherwise we are done.
.L1:    xorl    %edi, %edi         # Call new_context((int) 0, (ptr) 0)
        xorl    %esi, %esi         # (Implicitly zero-extended to 64 bits)
        call    new_context@PLT
        leaq    .L0(%rip), %rdi    # Call syserr(...)
        movl    $0, %eax
        jmp     syserr@PLT
