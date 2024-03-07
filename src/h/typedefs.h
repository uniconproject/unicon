/*
 * typdefs for the run-time system.
 */

typedef int ALIGN;              /* pick most stringent type for alignment */
typedef unsigned int DIGIT;

/*
 * Default sizing and such.
 */

/*
 * Establish typedefs for word and uword.
 * intptr_t cannot be used because it is defined in stdint.h (rtt does not
 * process system include files) so establish the size explicitly using the
 * definitions in auto.h planted by the configure script..
 */
#if (SIZEOF_INT == SIZEOF_INT_P)
   typedef int word;
   typedef unsigned int uword;
#elif (SIZEOF_LONG_INT == SIZEOF_INT_P)
   typedef long int word;
   typedef unsigned long int uword;
#elif defined(SIZEOF_LONG_LONG_INT) && (SIZEOF_LONG_LONG_INT == SIZEOF_INT_P)
   typedef long long int word;
   typedef unsigned long long int uword;
#else
   #error Cannot determine suitable typedefs for word and uword
#endif

   typedef void *pointer;
   typedef AllocType msize;

/*
 * Typedefs to make some things easier.
 */

typedef int (*fptr)();
typedef struct descrip *dptr;

typedef word C_integer;

/*
 * A success continuation is referenced by a pointer to an integer function
 *  that takes no arguments.
 */
typedef int (*continuation) (void);

#ifdef PthreadCoswitch
/*
 * Treat an Icon "cstate" array as an array of context pointers.
 * cstate[0] is used by Icon code that thinks it's setting a stack pointer.
 * We use cstate[1] to point to the actual context struct.
 * (Both of these are initialized to NULL by Icon 9.4.1 or later.)
 */
//typedef struct context **cstate;
#endif                                  /* PthreadCoswitch */

#if !COMPILER

   /*
    * Typedefs for the interpreter.
    */

   /*
    * Icode consists of operators and arguments.  Operators are small integers,
    *  while arguments may be pointers.  To conserve space in icode files on
    *  computers with 16-bit ints, icode is written by the linker as a mixture
    *  of ints and words (longs).  When an icode file is read in and processed
    *  by the interpreter, it looks like a C array of mixed ints and words.
    *  Accessing this "nonstandard" structure is handled by a union of int and
    *  word pointers and incrementing is done by incrementing the appropriate
    *  member of the union (see the interpreter).  This is a rather dubious
    *  method and certainly not portable.  A better way might be to address
    *  icode with a char *, but the incrementing code might be inefficient
    *  (at a place that experiences a lot of execution activity).
    *
    * For the moment, the dubious coding is isolated under control of the
    *  size of integers.
    */

   #if IntBits != WordBits

      typedef union {
         int *op;
         word *opnd;
         } inst;

      #else                             /* IntBits != WordBits */

      typedef union {
         word *op;
         word *opnd;
         } inst;

   #endif                               /* IntBits != WordBits */

#endif                                  /* COMPILER */

typedef enum TRuntime_Status_states {
  RTSTATUS_NORMAL=0,    /* Normal operation       */
  RTSTATUS_GC,          /* Garbage collection     */
  RTSTATUS_SIGNAL,      /* Normal Signal Handling */
  RTSTATUS_EXIT,        /* Normal Shutdown        */
  RTSTATUS_RUNERROR,    /* Runtime Error shutdown */
  RTSTATUS_SYSERROR,    /* System Error shutdown  */
  RTSTATUS_HARDERROR    /* Hardware Error shutdown, triggered by signals
                           SIGBUS, SIGFPE, SIGILL, and SIGSEGV */
  } TRuntime_Status;
