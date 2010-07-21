/*
 * External declarations for the run-time system.
 */

/*
 * External declarations common to the compiler and interpreter.
 */

extern struct b_proc *op_tbl;   /* operators available for string invocation */
extern int op_tbl_sz;           /* number of operators in op_tbl */
extern int debug_info;		/* flag: debugging information is available */
extern int err_conv;		/* flag: error conversion is supported */
extern int dodump;		/* termination dump */
extern int line_info;		/* flag: line information is available */
extern char *file_name;		/* source file for current execution point */
#ifndef MultiThread
extern int line_num;		/* line number for current execution point */
#endif					/* MultiThread */

extern unsigned char allchars[];/* array for making one-character strings */
extern char *blkname[];		/* print names for block types. */
extern char *currend;		/* current end of memory region */
extern dptr *quallist;		/* start of qualifier list */
extern int bsizes[];		/* sizes of blocks */
extern int firstd[];		/* offset (words) of first descrip. */
extern uword segsize[];		/* size of hash bucket segment */

extern struct b_coexpr *stklist;/* base of co-expression stack list */
extern struct b_cset blankcs;   /* ' ' */
extern struct b_cset lparcs;    /* '(' */
extern struct b_cset rparcs;    /* ')' */
extern struct b_cset fullcs;    /* cset containing all characters */
extern struct descrip blank;	/* blank */
extern struct descrip emptystr;	/* empty string */

extern struct descrip kywd_dmp; /* descriptor for &dump */
extern struct descrip nullptr;	/* descriptor with null block pointer */
extern struct descrip lcase;	/* lowercase string */
extern struct descrip letr;	/* letter "r" */
extern struct descrip maps2;	/* second argument to map() */
extern struct descrip maps3;	/* third argument to map() */
extern struct descrip nulldesc;	/* null value */
extern struct descrip onedesc;	/* one */
extern struct descrip ucase;	/* uppercase string */
extern struct descrip zerodesc;	/* zero */

extern word mstksize;		/* size of main stack in words */
extern word stksize;		/* size of co-expression stacks in words */
extern word qualsize;		/* size of string qualifier list */
extern word memcushion;		/* memory region cushion factor */
extern word memgrowth;		/* memory region growth factor */
extern uword stattotal;		/* cumulative total of all static allocations */
				/* N.B. not currently set */
#ifndef Concurrent
extern struct tend_desc *tend;  /* chain of tended descriptors */
#endif					/* Concurrent */

#ifdef Concurrent
extern struct tls_chain *tlshead;
extern pthread_mutex_t mutex_tls;
extern pthread_mutex_t mutex_pollevent;
extern pthread_mutex_t mutex_recid;
extern pthread_mutex_t mutex_stklist;
extern pthread_mutex_t *mutexes, mutex_mutex;
extern int maxmutexes, nmutexes;

extern pthread_mutex_t mutex_mutex;
extern pthread_mutex_t mutex_alcblk;
extern pthread_mutex_t mutex_alcstr;

extern pthread_mutex_t mutex_list_ser;
extern pthread_mutex_t mutex_coexp_ser;
extern pthread_mutex_t mutex_set_ser;
extern pthread_mutex_t mutex_table_ser;
#ifdef PatternType   
   extern pthread_mutex_t mutex_pat_ser;
#endif					/* PatternType */
#endif					/* Concurrent */

/*
 * Externals that are conditional on features.
 */

#ifdef ISQL
   extern HENV ISQLEnv;
   extern struct ISQLFile *isqlfiles;
#endif

#ifdef FncTrace
   extern struct descrip kywd_ftrc;	/* descriptor for &ftrace */
#endif					/* FncTrace */

#ifdef Polling
   extern int pollctr;
#endif					/* Polling */

extern char typech[];
extern word oldsum;
extern struct descrip csetdesc;		/* cset descriptor */
extern struct descrip eventdesc;	/* event descriptor */
extern struct b_iproc mt_llist;
extern struct descrip rzerodesc;	/* real descriptor */
extern struct b_real realzero;		/* real zero block */

#ifdef DosFncs
   extern char *zptr;
#endif					/* DosFncs */

#if EBCDIC == 2
   extern char ToEBCDIC[], FromEBCDIC[]; /* ASCII<->EBCDIC maps */
#endif					/* EBCDIC == 2 */

/*
 * Externals conditional on multithreading.
 */
#ifndef MultiThread
   extern dptr glbl_argp;		/* argument pointer */
   extern struct region *curstring;
   extern struct region *curblock;
   extern struct region rootstring;
   extern struct region rootblock;

   extern struct descrip k_current;	/* &current */
   extern char *k_errortext;		/* value of &errortext */
   extern int have_errval;		/* &errorvalue has a legal value */
   extern int k_errornumber;		/* value of &errornumber */
   extern int t_errornumber;		/* tentative k_errornumber value */
   extern int t_have_val;		/* tentative have_errval flag */
   extern struct b_file k_errout;	/* value of &errout */
   extern struct b_file k_input;	/* value of &input */
   extern struct b_file k_output;	/* value of &output */
   extern struct descrip k_errorvalue;	/* value of &errorvalue */
   extern struct descrip kywd_err;	/* &error */
   extern int k_level;			/* &level */
   extern struct descrip kywd_pos;	/* descriptor for &pos */
   extern struct descrip kywd_prog;	/* descriptor for &prog */
   extern struct descrip kywd_ran;	/* descriptor for &random */
   extern struct descrip k_subject;	/* &subject */
   extern struct descrip kywd_trc;	/* descriptor for &trace */
   extern struct descrip k_eventcode;	/* &eventcode */
   extern struct descrip k_eventsource;	/* &eventsource */
   extern struct descrip k_eventvalue;	/* &eventvalue */
   extern struct descrip k_main;	/* value of &main */

   extern struct descrip t_errorvalue;	/* tentative k_errorvalue value */

   extern uword blktotal;		/* cumul total of all block allocs */
   extern uword strtotal;		/* cumul total of all string allocs */

   extern word coll_tot;		/* total number of collections */
   extern word coll_stat;		/* collections from static reqests */
   extern word coll_str;		/* collections from string requests */
   extern word coll_blk;		/* collections from block requests */
   extern dptr globals;			/* start of global variables */
   extern dptr eglobals;		/* end of global variables */
   extern dptr gnames;			/* start of global variable names */
   extern dptr egnames;			/* end of global variable names */
   extern dptr estatics;		/* end of static variables */

   extern int n_globals;		/* number of global variables */
   extern int n_statics;		/* number of static variables */
   extern struct b_coexpr *mainhead;	/* &main */

   extern int longest_dr;
   extern struct b_proc_list **dr_arrays;

#ifdef PosixFns
extern struct descrip amperErrno;
#endif					/* PosixFns */
#endif					/* MultiThread */

/*
 * Externals that differ between compiler and interpreter.
 */
#if !COMPILER
   /*
    * External declarations for the interpreter.
    */

#ifndef Concurrent
   extern struct pf_marker *pfp;	        /* Procedure frame pointer */
   extern struct ef_marker *efp;		/* Expression frame pointer */
   extern struct gf_marker *gfp;		/* Generator frame pointer */
   extern inst ipc;			/* Interpreter program counter */
   extern inst oldipc;                    /* the previous ipc, fix returned line zero */
   extern word *sp;		/* Stack pointer */
   extern int ilevel;	
   extern word *stack;			/* interpreter stack base */
   extern word *stackend;		/* end of evaluation stack */
#endif					/* Concurrent */
   
/*delete
   extern int ntended;			/* number of active tended descriptors
*/
   extern struct b_cset k_ascii;	/* value of &ascii */
   extern struct b_cset k_cset;		/* value of &cset */
   extern struct b_cset k_digits;	/* value of &lcase */
   extern struct b_cset k_lcase;	/* value of &lcase */
   extern struct b_cset k_letters;	/* value of &letters */
   extern struct b_cset k_ucase;	/* value of &ucase */

/* delete
   extern struct descrip tended[];	/* tended descriptors
*/
   
   extern struct pstrnm pntab[];
   extern int pnsize;
   
/*probably Thread Safe*/
   #ifdef ExecImages
      extern int dumped;		/* the interpreter has been dumped */
   #endif				/* ExecImages */

   #ifdef MultiThread
      extern struct progstate *curpstate;
      extern struct progstate rootpstate;
   #ifdef Concurrent
   /*
    * This should be under something like HAS___THREAD, detected by autoconf.
    */
      extern __thread struct threadstate roottstate; 
      extern __thread struct threadstate *curtstate;
   #else					/* Concurrent */
      extern struct threadstate roottstate; 
      extern struct threadstate *curtstate;
   #endif					/* Concurrent */
      extern int noMTevents;		/* no MT events during GC */
   #ifdef Concurrent
      extern pthread_mutex_t mutex_noMTevents;
   #endif					/* Concurrent */

   #else				/* MultiThread */
      extern char *code;		/* start of icode */
      extern char *ecode;		/* end of icode */
      extern dptr statics;		/* start of static variables */
      extern char *strcons;		/* start of the string constants */
      extern dptr fnames;		/* field names */
      extern dptr efnames;		/* end of field names */
      extern word *records;
      extern int *ftabp;		/* field table pointer */
      #ifdef FieldTableCompression
         extern word ftabwidth, foffwidth;
         extern unsigned char *ftabcp;
         extern short *ftabsp;
      #endif				/* FieldTableCompression */
      extern dptr xargp;
      extern word xnargs;
      extern dptr field_argp;
      
      extern word lastop;
   #endif				/* MultiThread */
   
#else					/* COMPILER */

   extern struct descrip statics[];	/* array of static variables */
   extern struct b_proc *builtins[];	/* pointers to builtin functions */
   extern int noerrbuf;			/* error buffering */
   extern struct p_frame *pfp;		/* procedure frame pointer */
   extern struct descrip trashcan;	/* dummy descriptor, never read */
   extern int largeints;		/* flag: large integers supported */

#endif					/* COMPILER */

extern stringint attribs[], drawops[];

/*
 * graphics
 */
#ifdef Graphics
   
   extern wbp wbndngs;
   extern wcp wcntxts;
   extern wsp wstates;
   extern int GraphicsLeft, GraphicsUp, GraphicsRight, GraphicsDown;
   extern int GraphicsHome, GraphicsPrior, GraphicsNext, GraphicsEnd;
   extern int win_highwater, canvas_serial, context_serial;
   extern clock_t starttime;		/* start time in milliseconds */

   #ifndef MultiThread
      extern struct descrip kywd_xwin[];
      extern struct descrip lastEventWin;
      extern int lastEvFWidth, lastEvLeading, lastEvAscent;
      extern struct descrip amperCol;
      extern struct descrip amperRow;
      extern struct descrip amperX;
      extern struct descrip amperY;
      extern struct descrip amperInterval;
      extern uword xmod_control, xmod_shift, xmod_meta;
   #endif				/* MultiThread */

   #ifdef XWindows
      extern struct _wdisplay * wdsplys;
      extern stringint cursorsyms[];
   #endif				/* XWindows */

   #ifdef MSWindows
      extern HINSTANCE mswinInstance;
      extern int ncmdShow;
   #endif				/* MSWindows */

   #ifdef PresentationManager
      /* this is the handle to the interpreter thread's anchor block */
      extern HAB HInterpAnchorBlock;
      extern HAB HMainAnchorBlock;
      extern HMQ HInterpMessageQueue;
      extern HMQ HMainMessageQueue;
      extern lclIdentifier *LocalIds;
      extern stringint siMixModes[];
      extern stringint siLineTypes[];
      extern stringint siColorNames[];
      extern stringint siCursorSyms[];
      extern LONG ScreenWidth;
      extern LONG ScreenHeight;
      extern LONG NumWindows;
      extern LONG MaxPSColors;
      extern colorEntry *ColorTable;
      extern ULONG areaAttrs;
      extern ULONG lineAttrs;
      extern ULONG charAttrs;
      extern ULONG imageAttrs;
   #endif				/* PresentationManager */

   #ifdef ConsoleWindow
      extern FILE *ConsoleBinding, *flog;
      extern unsigned long ConsoleFlags;
      extern char ConsoleStringBuf[];
      extern char *ConsoleStringBufPtr;
   #endif				/* ConsoleWindow */

#ifdef Graphics3D
   extern struct descrip gl_torus;
   extern struct descrip gl_cube;
   extern struct descrip gl_sphere;
   extern struct descrip gl_cylinder;
   extern struct descrip gl_disk;
   extern struct descrip gl_rotate;
   extern struct descrip gl_translate;
   extern struct descrip gl_scale;
   extern struct descrip gl_popmatrix;
   extern struct descrip gl_pushmatrix;
   extern struct descrip gl_identity;
   extern struct descrip gl_matrixmode;
   extern struct descrip gl_texture;
   extern stringint redraw3Dnames[];
   #ifndef MultiThread
         extern struct descrip amperPick;
   #endif				/* MultiThread */

extern wfont gfont;
extern wfont *start_font, *end_font, *curr_font;

#endif					/* Graphics3D */

#endif					/* Graphics */

#ifdef PosixFns
extern struct descrip posix_lock, posix_timeval, posix_stat, posix_message,
  posix_passwd, posix_group, posix_servent, posix_hostent;
#endif					/* PosixFns */

#ifdef Messaging
extern int M_open_timeout;
#endif					/* Messaging */
