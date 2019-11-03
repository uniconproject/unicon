/*
 * File: devmode.r
 *
 * This file is a home for code that is only intended to be present
 * when the --enable-devmode option has been supplied to configure.
 *
 * If any function is thought to be useful enough to be present in
 * the standard (non-developer) configuration, we'll probably change
 * its name and move it somewhere else.
 */

#ifdef DEVMODE

/* Used in test code where the criterion for a break point is complicated.   */
/* Easier to write code and call dbgbrkpoint() with a break on this function */
int dbgbrkpoint()
{
  return 0;
}

"dbgbrk() - allow a convenient debugger break point called from Unicon code"
function{1} dbgbrk()
abstract {  return null }
body {
  return nulldesc;  /* Set a break point on this line or use "-n Zdbgbrk" */
}
end

#endif /* DEVMODE */
