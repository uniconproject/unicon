/*
############################################################################
#
#	File:     icall.h
#
#	Subject:  Definitions for external C functions
#
#	Author:   Gregg M. Townsend, Kostas Oikonomou, Clinton Jeffery
#
#	Date:     February 25, 2012
#
############################################################################
#
#   This file is in the public domain.
#
############################################################################
#
#   These definitions assist in writing external C functions for use with
#   Version 12 of Unicon.
#
############################################################################
# 
#   From Unicon, loadfunc(libfile, funcname) loads a C function of the form
# 	int func(int argc, descriptor argv[])
#   where "descriptor" is the structure type defined here.  The C
#   function returns -1 to fail, 0 to succeed, or a positive integer
#   to report an error.  Argv[1] through argv[argc] are the incoming
#   arguments; the return value on success (or the offending value
#   in case of error) is stored in argv[0].
# 
#   In the macro descriptions below, d is a descriptor value, typically
#   a member of the argv array.  IMPORTANT: many macros assume that the
#   C function's parameters are named "argc" and "argv" as noted above.
#
############################################################################
# 
#   IconType(d) returns one of the characters {cfinprsCILRST} indicating
#   the type of a value according to the key on page 247 of the Red Book.
#   The character I indicates a large (multiprecision) integer.
# 
#   Only a few of these types (i, r, f, s) are easily manipulated in C.
#   Given that the type has been verified, the following macros return
#   the value of a descriptor in C terms:
# 
# 	IntegerVal(d)	value of a integer (type 'i') as a C long
# 	RealVal(d)	value of a real (type 'r') as a C double
# 	FileVal(d)	value of a file (type 'f') as a C FILE pointer
# 	FileStat(d)	status field of a file
# 	StringVal(d)	value of a string (type 's') as a C char pointer
# 			(copied if necessary to add \0 for termination)
# 
# 	StringAddr(d)	address of possibly unterminated string
# 	StringLen(d)	length of string
# 
#   These macros check the type of an argument, converting if necessary,
#   and returning an error code if the argument is wrong:
# 
# 	ArgInteger(i)		check that argv[i] is an integer
# 	ArgReal(i)		check that argv[i] is a real number
# 	ArgString(i)		check that argv[i] is a string
#
#   Caveats:
#      Allocation failure is not detected.
#
############################################################################
# 
#   These macros return from the C function back to Icon code:
# 
# 	Return			return argv[0] (initially &null)
# 	RetArg(i)		return argv[i]
# 	RetNull()		return &null
# 	RetInteger(i)		return integer value i
# 	RetReal(v)		return real value v
# 	RetFile(fp,status,name)	return (newly opened) file
# 	RetString(s)		return null-terminated string s
# 	RetStringN(s, n)	return string s whose length is n
# 	RetAlcString(s, n)	return already-allocated string
# 	RetConstString(s)	return constant string s
# 	RetConstStringN(s, n)	return constant string s of length n
# 	Fail			return failure status
# 	Error(n)		return error code n
# 	ArgError(i,n)		return argv[i] as offending value for error n
#
############################################################################
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>

#if INT_MAX == 32767
#define WordSize 16
#elif LONG_MAX == 2147483647L
#define WordSize 32
#else
#define WordSize 64
#endif

#if WordSize <= 32
#define F_Nqual    0x80000000		/* set if NOT string qualifier */
#define F_Var      0x40000000		/* set if variable */
#define F_Ptr      0x10000000		/* set if value field is pointer */
#define F_Typecode 0x20000000		/* set if dword includes type code */
#else
#define F_Nqual    0x8000000000000000	/* set if NOT string qualifier */
#define F_Var      0x4000000000000000	/* set if variable */
#define F_Ptr      0x1000000000000000	/* set if value field is pointer */
#define F_Typecode 0x2000000000000000	/* set if dword includes type code */
#endif

#define D_Typecode	(F_Nqual | F_Typecode)

#define T_Null		 0		/* null value */
#define T_Integer	 1		/* integer */
#define T_Real		 3		/* real number */
#define T_File		 5		/* file, including window */
#define T_List		 8		/* list header */

#define D_Null		(T_Null     | D_Typecode)
#define D_Integer	(T_Integer  | D_Typecode)
#define D_Real		(T_Real     | D_Typecode | F_Ptr)
#define D_File		(T_File     | D_Typecode | F_Ptr)
#define D_List		((word)(T_List     | D_Typecode | F_Ptr))

#define Fs_Read		0001		/* file open for reading */
#define Fs_Write	0002		/* file open for writing */
#define Fs_Pipe		0020		/* file is a [popen] pipe */
#define Fs_Window	0400		/* file is a window */


typedef long word;
typedef struct descrip {
   word dword;
   union {
      word integr;		/*   integer value */
      char *sptr;		/*   pointer to character string */
      union block *bptr;	/*   pointer to a block */
      struct descrip *descptr;	/*   pointer to a descriptor */
      } vword;
} descriptor, *dptr;

typedef struct b_real { word title; double rval; } realblock;
typedef struct b_file { word title; FILE *fp; word stat; descriptor fname; }
	fileblock;
typedef struct b_list { word title; word size; word id;
			union block *listhead, *listtail; } listblock;

union block {
     listblock List;
     realblock Real;
     fileblock File;
};

#define alcstr alcstr_0
#define alcreal alcreal_0
#define alcfile alcfile_0
#define cnv_int cnv_int_0
#define cnv_real cnv_real_0
#define cnv_str cnv_str_0

int cnv_int(descriptor *, descriptor *);
int cnv_str(descriptor *, descriptor *);
int cnv_real(descriptor *, descriptor *);
int cnv_c_str(descriptor *, descriptor *);
int chmod();
int umask(int);
char *alcstr(char *s, word len);
realblock *alcreal(double v);
fileblock *alcfile(FILE *fp, int stat, descriptor *name);
double getdbl(descriptor *d);
void cpslots(descriptor *, descriptor *, word, word);

extern descriptor nulldesc;		/* null descriptor */


#define IconType(d) ((d).dword>=0 ? 's' : "niIrcfpRL.S.T.....C"[(d).dword&31])


#define FileVal(d) (((fileblock *)((d).vword.bptr))->fp)
#define FileStat(d) (((fileblock *)((d).vword.bptr))->stat)

#define StringAddr(d) ((d).vword.sptr)
#define StringLen(d) ((d).dword)

#define RetArg(i) return (argv[0] = argv[i], 0)

#define RetNull() return (argv->dword = D_Null, argv->vword.integr = 0)

#define RetFile(fp,stat,name) \
do { descriptor dd; dd.vword.sptr = alcstr(name, dd.dword = strlen(name)); \
   argv->dword = D_File; argv->vword.bptr = (union block *)alcfile(fp, stat, &dd); \
   return 0; } while (0)

#define RetStringN(s,n) \
do { argv->dword = n; argv->vword.sptr = alcstr(s,n); return 0; } while (0)

#define RetConstStringN(s,n) return (argv->dword=n, argv->vword.sptr=s, 0)

#define RetAlcString(s,n) return (argv->dword=n, argv->vword.sptr=s, 0)


#define Fail return -1
#define Return return 0
#define Error(n) return n
#define ArgError(i,n) return (argv[0] = argv[i], n)

#ifdef WIN32
typedef struct rtentrypts
 {
  int (*cnv_int) (descriptor *, descriptor *);
} rtentryvector;
#define cnv_int (rtev->cnv_int)
#define RTEP rtentryvector *rtev,
#define RTEX __declspec(dllexport)
#else
#define RTEP
#define RTEX
#endif

/*
	      ===================================
              ICON PROCEDURES CALLING C FUNCTIONS
	      ===================================

	      0. Declaration of the C function.
	      1. Entering the C function:
	           a. Checking and converting arguments
		   b. Getting the C values
	      2. Allocations of Icon structures
	      3. Returning to Icon


	      NOTE: a C routine *must* contain code for *all* of the above
	      steps, as some macros assume that others have been called before
	      them.  In particular, 1b depends on 1a, and 2 on 1.
*/



/*
  0. Declaration of the C function.
  =================================

  To allow dynamic loading by Icon, the C function *must* be declared as
      int func(int argc, dptr argv)
   or like
      int func(int argc, struct descrip argv[])
   See src/runtime/fload.r.
   
   The call of this in Icon looks like "func(x,y,z,...)".

*/



/*  
  1a. Entering the C function: checking and converting arguments
  =============================================================

  This is the most conceptually difficult part.  Familiarity with the
  implementation book is necessary!  Also some familiarity with RTL.

  We have to check the types of the Icon descriptors and "convert" them.
  To understand the details, see the functions cnv_int(), cnv_real(), cnv_str()
  in runtime/cnv.r.  They convert a source descriptor "s" to a destination
  descriptor "d", and return 1 on success and 0 on failure.
  Instead of the following macros one could use the functions cnv_c_int(),
  cnv_c_dbl(), cnv_c_str() (see runtime/cnv.r), plus error checking.
    
*/

#define ArgInteger(i) do { if (argc < (i)) FailCode(101); \
if (!cnv_int(&argv[i],&argv[i])) ArgError(i,101); } while(0)

#define ArgReal(i) \
do {if (argc < (i))  FailCode(102); \
    if (!cnv_real(&argv[i],&argv[i])) ArgError(i,102); \
   } while(0);

#define ArgString(i) \
do {if (argc < (i))  FailCode(103); \
    if (!cnv_str(&argv[i],&argv[i])) ArgError(i,103); \
   } while(0);

#define ArgList(i) \
do {if (argc < (i))  FailCode(101); \
    if (argv[i].dword != D_List) ArgError(i,108); \
   } while(0);

#define ListLen(d)      ((d).vword.bptr->List.size)



/*  
  1b. Entering the C function: getting the C values
  =============================================================

  Here we get C values out of Icon descriptors.
  The following macros *assume* that the descriptor conversions in 1a above
  have taken place.
*/

#define IntegerVal(d) ((d).vword.integr)
#define RealVal(d)    getdbl(&(d))
#define StringVal(d) \
(*(char*)((d).vword.sptr+(d).dword) ? \
cnv_c_str(&(d),&(d)) : 0, (char*)((d).vword.sptr))


/*
   Given an Icon list descrip "d", fill the C array of ints "a".
   Using cpslots() shortens the necessary code, and takes care of lists that
   have been constructed or modified by put() and get(), etc.
*/
#define IListVal(d,a) \
do {if (sizeof(a[0]) != sizeof(int))  FailCode(101); \
    register int n = ListLen(d); \
    register int i; \
    struct descrip *slot = malloc((n + 1) * sizeof(struct descrip)); \
    cpslots(&(d),slot,1,n+1); \
    for(i=0; i<n; i++) a[i] = IntegerVal(slot[i]); \
   } while(0);

/* Given an Icon list descrip "d", fill the C array of doubles "a". */
#define RListVal(d,a) \
do {if (sizeof(a[0]) != sizeof(double))  FailCode(102); \
    register int n = ListLen(d); \
    register int i; \
    struct descrip slot[n]; \
    cpslots(&(d),&slot[0],1,n+1); \
    for (i=0; i<n; i++) a[i] = RealVal(slot[i]); \
   } while(0);


/*  
  2. Allocations of Icon structures.
  =============================================================

  The point here is this: if memory is allocated dynamically inside a C routine
  for an Icon structure, say for a block holding a real, the request for space
  to the Icon run-time system may trigger a garbage collection.  The garbage
  collector must be able to recognize and save all values that might be
  referenced after the collection.  Otherwise bugs that are virtually
  impossible to find will ensue.
  The garbage collector is informed by declaring pointers as "tended".  See
  section 4.2 of the RTL paper (The Run-Time Implementation Language for Icon).

  E.g. if "d" is a C double,

            tended struct b_real *bp;
	    Protect(bp = alcreal(d), ReturnErrNum(307,Error));

  Since "tended" is an RTL construct, this can be problematic; however, the
  effect of tended can be implemented manually in C with some additional code.
  (See below for "Protect".)

  The circumstances under which "tended" is needed are very specific. It is
  needed only and exactly when a heap pointer P assigned at some point A in
  a runtime routine must survive a subsequent point B at which an allocation
  can trigger a garbage collection because P is used at a later point C. To
  survive from definition to use, with a garbage collection in between, you
  must tend P.

  If a C routine wants to return an Icon real or string, the allocation occurs
  inside the macros RetReal() and RetString() below.
  For allocating lists of integers and reals see
                 mkIlist() and mkRlist()
  in "rstruct.r".
*/

// Protection macro from grttin.h  Checks that the request for space succeeded.
#define Protect(notnull,orelse) do {if ((notnull)==NULL) orelse;} while(0)

word mkIlist(int x[], int n);
word mkRlist(int x[], int n);


/* 
  3. Returning from the C function to Icon.
  =============================================================
*/

/* A dynamically-loaded C function returns 0 on success, -1 on failure, 
   or a positive error code. */
#define FailCode(n) return n;
/* Return argv[i] as offending value for error code n */
#define ArgError(i,n) return (argv[0] = argv[i], n)

/* Integers, reals, strings, lists */
#define RetInteger(n) \
  return (argv->dword = D_Integer, argv->vword.integr = n, 0)

/* Given a C double "x", return an Icon real to the calling routine. */
#define RetReal(x) do {  \
  struct b_real *d;  \
  Protect(d = alcreal(x), Error(307));  \
  return (argv->dword = D_Real, argv->vword.bptr = (union block *)d, 0);  \
} while(0)

/* Given a C string "s", return an Icon string to the calling routine. */
#define RetString(s) do {  \
  struct descrip d; \
  int len = strlen(s);  \
  Protect(StringAddr(d) = alcstr(s,len), Error(306));  \
  StringLen(d) = len;  \
  return (argv->dword = StringLen(d), argv->vword.sptr = StringAddr(d), 0);  \
} while (0);

#define RetConstString(s) \
  return (argv->dword = strlen(s), argv->vword.sptr = s, 0)

/* Here L is supposed to be L = mkIlist(...) or L = mkRlist(...). */
#define RetList(L) \
  return (argv[0].dword = D_List, argv[0].vword.bptr = (union block *)L, 0)
