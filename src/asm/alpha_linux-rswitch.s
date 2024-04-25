/*
 *  coswitch(old_cs, new_cs, first) for Dec Alpha architecture
 *             $16     $17    $18
 */
	.data
errmsg:	.ascii	"new_context() returned in coswitch\X00"

	.text
	.globl	coswitch
	.ent	coswitch
coswitch:
	lda	$sp, -72($sp)		/* make room on stack */
	stq	$sp, 0($16)		/* save stack pointer */
	stq	$9, 0($sp)		/* save registers on stack */
	stq	$10, 8($sp)
	stq	$11, 16($sp)
	stq	$12, 24($sp)
	stq	$13, 32($sp)
	stq	$14, 40($sp)
	stq	$15, 48($sp)
	stq	$27, 56($sp)
	stq	$26, 64($sp)		/* return address */
	beq	$18, first		/* if first time */

	ldq	$sp, 0($17)		/* load new stack pointer */
	ldq	$9, 0($sp)		/* load registers from stack */
	ldq	$10, 8($sp)
	ldq	$11, 16($sp)
	ldq	$12, 24($sp)
	ldq	$13, 32($sp)
	ldq	$14, 40($sp)
	ldq	$15, 48($sp)
	ldq	$27, 56($sp)
	ldq	$26, 64($sp)		/* return address */
	lda	$sp, 72($sp)		/* reset sp */
	jsr_coroutine	$31, ($26), 0	/* jump into new_context */

first:	
	ldq	$sp, 0($17)		/* load stack pointer only */
	bis	$31, $31, $16		/* r16 = 0 */
	bis	$31, $31, $17		/* r17 = 0 */
	jsr	$26, new_context	/* new_context(0,0) */
	lda	$16, errmsg
	jsr	$26, syserr		/* shouldn't get here */

	.end	coswitch
