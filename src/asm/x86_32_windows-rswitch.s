#
#  Assembler source for context switch — 32-bit Windows (cdecl).
#  Matches x86_32_linux cstate layout: esp, esp, ebp, ebx, esi, edi.
#

.file   "rswitch.s"
.data 1
.LC0:
        .byte 0x6e,0x65,0x77,0x5f,0x63,0x6f,0x6e,0x74,0x65,0x78
        .byte 0x74,0x28,0x29,0x20,0x72,0x65,0x74,0x75,0x72,0x6e
        .byte 0x65,0x64,0x20,0x69,0x6e,0x20,0x63,0x6f,0x73,0x77
        .byte 0x69,0x74,0x63,0x68,0x0
.text
        .align 4
.globl _coswitch


_coswitch:
        pushl %ebp
        movl 8(%esp),%eax
        movl %esp,0(%eax)
        movl %esp,4(%eax)
        movl %ebp,8(%eax)
        movl %ebx,12(%eax)
        movl %esi,16(%eax)
        movl %edi,20(%eax)
        movl %esp,%ebp
        movl 12(%esp),%eax
        cmpl $0,16(%ebp)
        movl 0(%eax),%esp
        je .L2

        movl 4(%eax),%ebp
        movl 12(%eax),%ebx
        movl 16(%eax),%esi
        movl 20(%eax),%edi
        jmp .L1

.L2:
        movl $0,%ebp
        pushl $0
        pushl $0
        call _new_context
        pushl $.LC0
        call _syserr
        addl $12,%esp

.L1:
        leave
        ret
