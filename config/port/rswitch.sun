/*
 * This is the co-expression context switch for the Sun Workstation
 * operating under Berkley 4.2bsd UNIX.
 */

/*
 * coswitch
 */
coswitch(old_cs, new_cs, first)
int *old_cs, *new_cs;
int first;
{
   asm("  movl a6@(8),a0");		/* a0 = old */
   asm("  movl a6@(12),a1");		/* a1 = new */
   asm("  movl a7,a0@");		/* save sp in cstate[0] */
   asm("  movl a6,a0@(4)");		/* save a6 (fp) in cstate[0] */
   asm("  moveml #0x3cfc,a0@(8)");	/* store d2-d7, a2-a6 in old->cstate */
   if (first == 0) {	/* this is first activation */
      asm("  movl a1@,a7");
      asm("  movl #0,a6");
      interp(0, 0);
      syserr("interp() returned in coswitch");
      }
   else {
      asm(" movl a1@,a7");		/* restore sp */
      asm(" movl a1@(4),a6");		/* restore fp */
      asm(" moveml a1@(8),#0x3cfc");	/* restore d2-d7, a2-a6 */
      }
}
