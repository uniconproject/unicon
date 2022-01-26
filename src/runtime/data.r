/*
 * data.r -- Various interpreter data tables.
 */

#if !COMPILER

struct b_proc Bnoproc;

#ifdef MultiProgram
/*
 * A procedure block for list construction, used by event monitoring.
 */
struct b_iproc mt_llist = {
   6, (sizeof(struct b_proc) - sizeof(struct descrip)), Ollist,
   0, -1,  0, 0, {sizeof( "[...]")-1, "[...]"}};
#endif					/* MultiProgram */

/*
 * External declarations for function blocks.
 */

#define FncDef(p,n) extern struct b_proc Cat(B,p);
#define FncDefV(p) extern struct b_proc Cat(B,p);
#passthru #undef exit
#undef exit
/* there was an #undef Fail, and even a passthru of it here */
#include "../h/fdefs.h"
#undef FncDef
#undef FncDefV

#define OpDef(p,n,s,u) extern struct b_proc Cat(B,p);
#include "../h/odefs.h"
#undef OpDef

extern struct b_proc Bbscan;
extern struct b_proc Bescan;
extern struct b_proc Bfield;
extern struct b_proc Blimit;
extern struct b_proc Bllist;

 


struct b_proc *opblks[] = {
	NULL,
#define OpDef(p,n,s,u) Cat(&B,p),
#include "../h/odefs.h"
#undef OpDef
   &Bbscan,
   NULL,
   NULL,
   NULL,
   NULL,
   NULL,
   NULL,
   NULL,
   NULL,
   NULL,
   NULL,
   &Bescan,
   NULL,
   &Bfield,
   NULL,
   NULL,
   NULL,
   NULL,
   NULL,
   &Blimit,
   &Bllist,
   NULL,
   NULL,
   NULL
   };

/*
 * Array of names and corresponding functions.
 *  Operators are kept in a similar table, op_tbl.
 */

struct pstrnm pntab[] = {

#define FncDef(p,n) Lit(p), Cat(&B,p),
#define FncDefV(p) Lit(p), Cat(&B,p),
#include "../h/fdefs.h"
#undef FncDef
#undef FncDefV

	0,		 0
	};

int pnsize = (sizeof(pntab) / sizeof(struct pstrnm)) - 1;

#endif					/* COMPILER */

/*
 * Structures for built-in values.  Parts of some of these structures are
 *  initialized later. Since some C compilers cannot handle any partial
 *  initializations, all parts are initialized later if any have to be.
 */

/*
 * blankcs; a cset consisting solely of ' '.
 */
struct b_cset  blankcs = {
   T_Cset,
   1,
#if !EBCDIC
   cset_display(0, 0, 01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
#else					/* EBCDIC */
   cset_display(0, 0, 0, 0, 01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
#endif					/* EBCDIC */
   };

/*
 * lparcs; a cset consisting solely of '('.
 */
struct b_cset  lparcs = {
   T_Cset,
   1,
#if !EBCDIC
   cset_display(0, 0, 0400, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
#else					/* EBCDIC */
   cset_display(0, 0, 0, 0, 0x2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
#endif					/* EBCDIC */
   };

/*
 * rparcs; a cset consisting solely of ')'.
 */
struct b_cset  rparcs = {
   T_Cset,
   1,
#if !EBCDIC
   cset_display(0, 0, 01000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
#else					/* EBCDIC */
   cset_display(0, 0, 0, 0, 0, 0x2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
#endif					/* EBCDIC */
   };

/*
 * We removed these built-in csets in lieu of the ones that rtt
 * generates, but if PatternType is defined, the runtime system needs
 * a global way to get to these, and under COMPILER rtt may not generate
 * them at all. So here they are again.
 */
struct b_cset k_digits = {T_Cset, 10,
   cset_display(0, 0, 0,0x3ff, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
   };
struct b_cset k_lcase = {T_Cset, 26,
   cset_display(0, 0, 0, 0, 0, 0,0xfffe,0x7ff, 0, 0, 0, 0, 0, 0, 0, 0)
   };
struct b_cset k_ucase = {T_Cset, 26,
   cset_display(0, 0, 0, 0,0xfffe,0x7ff, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
   };
struct b_cset k_letters = {T_Cset, 52,
   cset_display(0, 0, 0, 0,0xfffe,0x7ff,0xfffe,0x7ff, 0, 0, 0, 0, 0, 0, 0, 0)
   };
struct b_cset k_ascii = {T_Cset, 128,
   cset_display(0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,
		0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0)
    };
struct b_cset k_cset = {T_Cset, 256,
   cset_display(0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,
		0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff)
   };

/*
 * Built-in files.
 */

#ifndef MultiProgram
/* input: is an Fs_Window if consolewindow; not doing that here anymore, add it to OpenConsole() */
struct b_file  k_errout = {T_File, NULL, Fs_Write};	/* &errout */
struct b_file  k_input = {T_File, NULL, Fs_Read};	/* &input */
struct b_file  k_output = {T_File, NULL, Fs_Write};	/* &output */
#endif					/* MultiProgram */

/*
 * Keyword variables.
 */
#ifndef MultiProgram
struct descrip kywd_err = {D_Integer};  /* &error */
struct descrip kywd_prog;		/* &progname */
struct descrip kywd_trc = {D_Integer};	/* &trace */
struct descrip k_eventcode = {D_Null};	/* &eventcode */
struct descrip k_eventsource = {D_Null};/* &eventsource */
struct descrip k_eventvalue = {D_Null};	/* &eventvalue */
#if !ConcurrentCOMPILER
struct descrip k_subject; 		/* &subject */
struct descrip kywd_ran = {D_Integer};	/* &random */
struct descrip kywd_pos = {D_Integer};	/* &pos */
#endif                                  /* ConcurrentCOMPILER */
#endif					/* MultiProgram */

#ifdef FncTrace
struct descrip kywd_ftrc = {D_Integer};	/* &ftrace */
#endif					/* FncTrace */

struct descrip kywd_dmp = {D_Integer};	/* &dump */

struct descrip nullptr =
   {((word)(F_Ptr | F_Nqual))};        /* descriptor with null block pointer */
struct descrip trashcan;		/* descriptor that is never read */

/*
 * Various constant descriptors.
 */

struct descrip blank; 			/* one-character blank string */
struct descrip emptystr; 		/* zero-length empty string */
struct descrip lcase;			/* string of lowercase letters */
struct descrip letr;			/* "r" */
struct descrip nulldesc = {D_Null};	/* null value */
struct descrip onedesc = {D_Integer};	/* integer 1 */
struct descrip ucase;			/* string of uppercase letters */
struct descrip zerodesc = {D_Integer};	/* integer 0 */

#ifdef MultiProgram
/*
 * Descriptors used by event monitoring.
 */
struct descrip csetdesc = {D_Cset};
struct descrip eventdesc;
#ifdef DescriptorDouble
struct descrip rzerodesc = {D_Real, 0.0};
#else					/* DescriptorDouble */
struct descrip rzerodesc = {D_Real};
/*
 *  Real block needed for event monitoring.
 */
struct b_real realzero = {T_Real, 0.0};
#endif					/* DescriptorDouble */
#endif					/* MultiProgram */

/*
 * An array of all characters for use in making one-character strings.
 */

unsigned char allchars[256] = {
     0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
    32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
    48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
    64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
    80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95,
    96, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111,
   112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,
   128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
   144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,
   160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,
   176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,
   192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,
   208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,
   224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,
   240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,
};

/*
 * Run-time error numbers and text.
 */
struct errtab errtab[] = {
   101, "integer expected or out of range",
   102, "numeric expected",
   103, "string expected",
   104, "cset expected",
   105, "file expected",
   106, "procedure or integer expected",
   107, "record expected",
   108, "list expected",
   109, "string or file expected",
   110, "string or list expected",
   111, "variable expected",
   112, "invalid type to size operation",
   113, "invalid type to random operation",
   114, "invalid type to subscript operation",
   115, "structure expected",
   116, "invalid type to element generator",
   117, "missing main procedure",
   118, "co-expression expected",
   119, "set expected",
   120, "two csets, two sets, or two tables expected",
   121, "function not supported",
   122, "set or table expected",
   123, "invalid type",
   124, "table expected",
   125, "list, record, or set expected",
   126, "list or record expected",
#ifdef PatternType
   127, "pattern expected",
   128, "unevaluated variable or function call expected",
   129, "unable to convert unevaluated variable to pattern",
#endif					/* PatternType */
   130, "incorrect number of arguments",
   131, "string is not a class name",
/*#ifdef Graphics*/
   140, "window expected",
   141, "program terminated by window manager",
   142, "attempt to read/write on closed window",
   143, "malformed event queue",
   144, "window system error",
   145, "bad window attribute",
   146, "incorrect number of arguments to drawing function",
   147, "window attribute cannot be read or written as requested",
   148, "graphics is not enabled in this virtual machine",
/*#endif*/					/* Graphics */

/*#ifdef Graphics3D*/
   150,  "drawing a 3D object while in 2D mode",
   151,  "pushed/popped too many matrices",
   152,  "modelview or projection expected",
   153,  "texture not in correct format",
   154,  "must have an even number of texture coordinates",
/*#else*/					/* Graphics3D */
   155,  "3D graphics is not enabled in this virtual machine",
/*#endif*/					/* Graphics3D */

#ifdef PatternType
   160,  "nonexistent variable name",
   161,  "cannot convert unevaluated variable to pattern",
   162,  "uninitialized pattern",
   163,  "object, method, or method parameter problem in unevaluated expression",
   164,  "unsupported unevaluated expression",
   165,  "null pattern argument where name was expected",
   166,  "unable to produce pattern image, possible malformed pattern",
#endif					/* PatternType */

#ifdef PosixFns
   /*
    * PosixFns errors related to incorrect usage are here; PosixFns errors
    * that result from failed system calls appear below with numbers > 1000.
    */
   170, "string or integer expected",
   171, "UDP socket expected",
   172, "signal handler procedure must take one argument",
   173, "cannot open directory for writing",
   174, "invalid file operation",
   175, "network connection expected",
#endif					/* PosixFns */

#ifdef Concurrent
   180, "invalid mutex",
   181, "invalid condition variable",
   182, "illegal recursion in initial clause",
   183, "concurrent threads are not enabled in this virtual machine",
   184, "structure cannot have more than one mutex at the same time",
   185, "converting an active co-expression to a thread is not yet supported",
#endif					/* Concurrent */

#ifdef Dbm
   190, "dbm database expected",
   191, "cannot open dbm database",
#endif					/* Dbm */

   201, "division by zero",
   202, "remaindering by zero",
   203, "integer overflow",
   204, "real overflow, underflow, or division by zero",
   205, "invalid value",
   206, "negative first argument to real exponentiation",
   207, "invalid field name",
   208, "second and third arguments to map of unequal length",
   209, "invalid second argument to open",
   210, "non-ascending arguments to detab/entab",
   211, "by value equal to zero",
   212, "attempt to read file not open for reading",
   213, "attempt to write file not open for writing",
   214, "input/output error",
   215, "attempt to refresh &main",
   216, "external function not found",
   217, "unsafe inter-program variable assignment",
   218, "invalid file name",

   301, "evaluation stack overflow",
   302, "memory violation",
   303, "inadequate space for evaluation stack",
   304, "inadequate space in qualifier list",
   305, "inadequate space for static allocation",
   306, "inadequate space in string region",
   307, "inadequate space in block region",
   308, "system stack overflow in co-expression",
#ifdef PatternType
   309, "pattern stack overflow",
#endif					/* PatternType */

#if IntBits == 16
   316, "interpreter stack too large",
   318, "co-expression stack too large",
#endif					/* IntBits == 16 */

#ifndef CoExpr
   401, "co-expressions not implemented",
#endif					/* CoExpr */
   402, "program not compiled with debugging option",

   500, "program malfunction",		/* for use by runerr() */
   600, "vidget usage error",		/* yeah! */

#ifdef PosixFns
   1040, "socket error",		 
   1041, "cannot initialize network library",
   1042, "fdup of closed file",
   1043, "invalid signal",
   1044, "invalid operation to flock/fcntl",
   1045, "invalid mode string",
   1046, "invalid permission string for umask",
   1047, "invalid protocol name",
   1048, "low-level read or select mixed with buffered read",
   1049, "nonexistent service or services database error",
#endif					/* PosixFns */

   1050, "command not found",
   1051, "cannot create temporary file",
   1052, "cannot create pipe",
   1053, "empty pipe",

#ifdef ISQL
   1100, "ODBC connection expected",
#endif					/* ISQL */

#ifdef Messaging
   1200, "system error (see errno)",
   1201, "malformed URL",
   1202, "missing username in URL",
   1203, "unknown scheme in URL",
   1204, "cannot parse URL",
   1205, "cannot connect",            /* TP_ECONNECT */
   1206, "unknown host",           /* TP_EHOST */
   /* TP_STATENOTREADING uses 212 */
   /* TP_STATENOTWRITING uses 213 */
   1207, "invalid field in header",
   1208, "messaging file expected",
   1209, "cannot determine smtpserver (set UNICON_SMTPSERVER)",
   1210, "cannot determine user return address (set UNICON_USERADDRESS)",
   1211, "invalid email address",
   1212, "server error",
   1213, "POP messaging file expected",

#ifdef HAVE_LIBSSL
   1214, "cannot find certificate store (set SSL_CERT_FILE or SSL_CERT_DIR)",
   1215, "cannot verify peer's certificate",
#endif					/* HAVE_LIBSSL */

#endif                                  /* Messaging */

/*
 * End of operating-system specific code.
 */

   0,	""
   };

/*
 * Note:  the following material is here to avoid a bug in the Cray C compiler.
 */

#if !COMPILER
#define OpDef(p,n,s,u) int Cat(O,p) (dptr cargp);
#include "../h/odefs.h"
#undef OpDef

/*
 * When an opcode n has a subroutine call associated with it, the
 *  nth word here is the routine to call.
 */

int (*optab[])() = {
	err,
#define OpDef(p,n,s,u) Cat(O,p),
#include "../h/odefs.h"
#undef OpDef
   Obscan,
   err,
   err,
   err,
   err,
   err,
   Ocreate,
   err,
   err,
   err,
   err,
   Oescan,
   err,
   Ofield
   };

/*
 *  Keyword function look-up table.
 */
#define KDef(p,n) int Cat(K,p) (dptr cargp);
#include "../h/kdefs.h"
#undef KDef

int (*keytab[])() = {
   err,
#define KDef(p,n) Cat(K,p),
#include "../h/kdefs.h"
   };
#endif					/* !COMPILER */
