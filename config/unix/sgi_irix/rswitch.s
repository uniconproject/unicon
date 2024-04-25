	.data	
	.align	0
$$8:
	.ascii	"new_context() returned in coswitch\X00"
	.text	
	.align	2
	.globl	coswitch
 #    	coswitch(old_cs,new_cs,first)
 #    	int *old_cs,*new_cs;
 #    	int first;
 #	{
	.ent	coswitch
coswitch:
 #	standard entry code, including decrement of sp
	subu	$sp, 32
	sw	$31, 20($sp)
	.mask	0x80000000, -4
	.frame	$sp, 32, $31
 #    	save (decremented) sp and other registers in old_cs
	sw	$sp,  0($4)
	sw	$31,  4($4)
	sd	$16,  8($4)
	sd	$18, 16($4)
	sd	$20, 24($4)
	sd	$22, 32($4)
	s.d	$f20,40($4)
	s.d	$f22,48($4)
	s.d	$f24,56($4)
	s.d	$f26,64($4)
	s.d	$f28,72($4)
	s.d	$f30,80($4)
	sw	$gp,88($4)
	sw	$fp,96($4)
 #    	if first = 0, this is first activation
	bne	$6, 0, $33
 #    	load sp from new_cs[0] (ignore other registers)
	lw	$sp, 0($5)
 #    Decrement sp by the size of the stackframe.  
 #    Store decremented sp in new_cs.  Then call new_context().
        subu    $sp, 32
        sw      $sp,  0($5)
 #    	new_context(0,0);
	move	$4, $0
	move	$5, $0
	jal	new_context
 #    	syserr("new_context() returned in coswitch");
	la	$4, $$8
	jal	syserr
 #	if we're in control now, something is really wrong, so go into
 #	a tight loop until someone notices...
$32:
	b	$32
$33:
 #	here for not first activation
 #    	load sp and other registers from new_cs
	lw	$sp,  0($5)
	lw	$31,  4($5)
 #	(could compare $31 with 20($sp) as a consistency check now)
	ld	$16,  8($5)
	ld	$18, 16($5)
	ld	$20, 24($5)
	ld	$22, 32($5)
	l.d	$f20,40($5)
	l.d	$f22,48($5)
	l.d	$f24,56($5)
	l.d	$f26,64($5)
	l.d	$f28,72($5)
	l.d	$f30,80($5)
	lw	$gp,88($5)
	lw	$fp,96($5)
 #	increment sp as for normal return
	addu	$sp, 32
 #	return
	j	$31
 #	}
	.end	coswitch
