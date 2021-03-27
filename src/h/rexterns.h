/*
 * External declarations for the run-time system.
 */

/*
 * External declarations common to the compiler and interpreter.
 */

extern TRuntime_Status rt_status;
extern struct b_proc *op_tbl;   /* operators available for string invocation */
extern int op_tbl_sz;           /* number of operators in op_tbl */
extern int debug_info;		/* flag: debugging information is available */
extern int err_conv;		/* flag: error conversion is supported */
extern int dodump;		/* termination dump */
extern int line_info;		/* flag: line information is available */
extern char *file_name;		/* source file for current execution point */
#ifndef MultiProgram
extern int line_num;		/* line number for current execution point */
#endif					/* MultiProgram */

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
extern struct b_cset k_digits;  /* &digits */
extern struct b_cset k_lcase;   /* &lcase */
extern struct b_cset k_ucase;   /* &ucase */
extern struct b_cset k_letters; /* &letters */
extern struct b_cset k_ascii;   /* &ascii */
extern struct b_cset k_cset;    /* &cset */
extern struct descrip blank;	/* blank */
extern struct descrip emptystr;	/* empty string */

extern struct descrip kywd_dmp; /* descriptor for &dump */
extern struct descrip nullptr;	/* descriptor with null block pointer */
extern struct descrip lcase;	/* lowercase string */
extern struct descrip letr;	/* letter "r" */

#ifndef Concurrent
extern struct descrip maps2;	/* second argument to map() */
extern struct descrip maps3;	/* third argument to map() */
#endif /* Concurrent */

extern struct descrip nulldesc;	/* null value */
extern struct descrip onedesc;	/* one */
extern struct descrip ucase;	/* uppercase string */
extern struct descrip zerodesc;	/* zero */

extern word mstksize;		/* size of main stack in words */
extern word stksize;		/* size of co-expression stacks in words */
extern word qualsize;		/* size of string qualifier list */
extern word memcushion;		/* memory region cushion factor */
extern word memgrowth;		/* memory region growth factor */
#ifdef DescripAmpAllocated
extern struct descrip stattotal;/* cumulative total of all static allocations */
extern int blktotalIncrFlag;
#else					/* DescripAmpAllocated */
extern uword stattotal;		/* cumulative total of all static allocations */
#endif					/* DescripAmpAllocated */
				/* N.B. not currently set */

#ifdef HAVE_LIBPTHREAD
extern pthread_rwlock_t __environ_lock;
#endif					/*HAVE_LIBPTHREAD && !SUN */
   
#ifndef Concurrent
extern struct tend_desc *tend;  /* chain of tended descriptors */
#endif					/* Concurrent */

extern int num_cpu_cores;

#ifdef Concurrent
extern pthread_mutex_t **mutexes;
extern word nmutexes;
extern word maxmutexes;

extern pthread_mutexattr_t rmtx_attr;

extern pthread_t GCthread;
extern int thread_call;
extern int NARthreads;

extern pthread_cond_t **condvars;
extern word* condvarsmtxs;
extern word ncondvars; 
extern word maxcondvars; 

extern int is_concurrent; 
extern struct threadstate *global_curtstate;

#ifndef HAVE_KEYWORD__THREAD
   extern pthread_key_t tstate_key;
#endif

#if ConcurrentCOMPILER
extern struct region *Public_stringregion;
extern struct region *Public_blockregion;

extern word mutexid_stringtotal;
extern word mutexid_blocktotal;
extern word mutexid_coll;
extern word list_ser;
extern word intern_list_ser;
/*
 * Fake out a possible fail, to trick iconc.
 */
extern int improbable;
#endif                                   /* ConcurrentCOMPILER */

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

#if defined(Polling) && !defined(Concurrent)
   extern int pollctr;
#endif					/* Polling && !Concurrent */

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

   extern struct region rootstring;
   extern struct region rootblock;

/*
 * Externals conditional on MultiProgram: multi loaded programs.
 */
#ifndef MultiProgram
   extern struct region *curstring;
   extern struct region *curblock;
#if !ConcurrentCOMPILER
   extern dptr glbl_argp;		/* argument pointer */
   extern struct descrip value_tmp;	/* list argument to Op_Apply */
   extern struct descrip k_current;	/* &current */
   extern struct descrip k_errortext;	/* &errortext */
   extern int have_errval;		/* &errorvalue has a legal value */
   extern int k_errornumber;		/* value of &errornumber */
   extern int t_errornumber;		/* tentative k_errornumber value */
   extern int t_have_val;		/* tentative have_errval flag */
   extern struct descrip k_errorvalue;	/* value of &errorvalue */
   extern int k_level;			/* &level */
   extern struct descrip k_subject;	/* &subject */
   extern struct descrip kywd_pos;	/* descriptor for &pos */
#ifdef PatternType
   extern int k_patindex;               /* index for pattern element */
#endif                         /* Pattern Type */ 
   extern struct descrip kywd_ran;	/* descriptor for &random */
   extern struct descrip t_errorvalue;	/* tentative k_errorvalue value */

#ifdef DescripAmpAllocated
   extern struct descrip blktotal;	/* cumul total of all block allocs */
   extern struct descrip strtotal;	/* cumul total of all string allocs */
#else					/* DescripAmpAllocated */
   extern uword blktotal;		/* cumul total of all block allocs */
   extern uword strtotal;		/* cumul total of all string allocs */
#endif					/* DescripAmpAllocated */
#endif					/* ConcurrentCOMPILER */
   extern struct b_file k_errout;	/* value of &errout */
   extern struct b_file k_input;	/* value of &input */
   extern struct b_file k_output;	/* value of &output */
   extern struct descrip kywd_err;	/* &error */
   extern struct descrip kywd_prog;	/* descriptor for &prog */
   extern struct descrip kywd_trc;	/* descriptor for &trace */
   extern struct descrip k_eventcode;	/* &eventcode */
   extern struct descrip k_eventsource;	/* &eventsource */
   extern struct descrip k_eventvalue;	/* &eventvalue */
   extern struct descrip k_main;	/* value of &main */

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
#endif					/* MultiProgram */

#ifdef Concurrent
   #ifdef HAVE_KEYWORD__THREAD
   /*
    * HAVE_KEYWORD__THREAD should be detected by autoconf (and isn't yet).
    */
   extern __thread struct threadstate roottstate; 
   extern __thread struct threadstate *curtstate;
   #else					/* HAVE_KEYWORD__THREAD */
   extern struct threadstate roottstate;
   #endif					/* HAVE_KEYWORD__THREAD */
#else					/* Concurrent */
   extern struct threadstate roottstate; 
   extern struct threadstate *curtstate;
#endif					/* Concurrent */

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
#endif					/* !Concurrent */
#endif					/* !COMPILER */

#if !COMPILER || ConcurrentCOMPILER
   extern struct pstrnm pntab[];
   extern int pnsize;
   
/*probably Thread Safe*/
   #ifdef ExecImages
      extern int dumped;		/* the interpreter has been dumped */
   #endif				/* ExecImages */
#endif					/* !COMPILER || ConcurrentCOMPILER */

   #if defined(MultiProgram)
      extern struct progstate *curpstate;
      extern struct progstate rootpstate;
   #endif					/* MultiProgram */


#if !COMPILER
   #ifdef MultiProgram
      extern int noMTevents;		/* no MT events during GC */
   #ifdef Concurrent
      extern pthread_mutex_t mutex_noMTevents;
   #endif					/* Concurrent */

   #else				/* MultiProgram */
      extern char *code;		/* start of icode */
      extern char *ecode;		/* end of icode */
      extern char *endcode;		/* end of icode? */
      extern struct ipc_line *ilines;	/* start of line # table */
      extern struct ipc_line *elines;	/* end of line # table */
      extern struct ipc_fname *filenms;	/* start of file name table */
      extern struct ipc_fname *efilenms;/* end of file name table */
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
   #endif				/* MultiProgram */

      extern struct b_proc *stubrec;
   
#else					/* !COMPILER */

#if ConcurrentCOMPILER
   extern pthread_mutex_t mutex_noMTevents;
#endif                                  /* ConcurrentCOMPILER */
   extern struct descrip statics[];	/* array of static variables */
   extern struct b_proc *builtins[];	/* pointers to builtin functions */
   extern int noerrbuf;			/* error buffering */
#if !ConcurrentCOMPILER
   extern struct p_frame *pfp;		/* procedure frame pointer */
#endif					/* ConcurrentCOMPILER */
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

   #ifndef MultiProgram
      extern struct descrip kywd_xwin[];
      extern struct descrip lastEventWin;
      extern int lastEvFWidth, lastEvLeading, lastEvAscent;
      extern struct descrip amperCol;
      extern struct descrip amperRow;
      extern struct descrip amperX;
      extern struct descrip amperY;
      extern struct descrip amperInterval;
      extern uword xmod_control, xmod_shift, xmod_meta;
   #endif				/* MultiProgram */

   #ifdef XWindows
      extern struct _wdisplay * wdsplys;
      extern stringint cursorsyms[];
   #endif				/* XWindows */

   #ifdef MSWindows
      extern HINSTANCE mswinInstance;
      extern int ncmdShow;
   #endif				/* MSWindows */

   extern unsigned long ConsoleFlags;
   #ifdef ConsoleWindow
      extern FILE *ConsoleBinding;
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
   #ifndef MultiProgram
         extern struct descrip amperPick;
   #endif				/* MultiProgram */

extern wfont gfont;
extern wfont *start_font, *end_font, *curr_font;

#endif					/* Graphics3D */

#endif					/* Graphics */

#ifdef PosixFns
extern struct descrip posix_lock, posix_timeval, posix_stat, posix_message,
  posix_passwd, posix_group, posix_servent, posix_hostent, posix_rusage;
extern dptr timeval_constr;
#endif					/* PosixFns */

#ifdef Messaging
extern int M_open_timeout;
#endif					/* Messaging */

/* patchable globals */
extern char patchpath[];
extern char uniroot[];

extern char *lognam;
extern FILE *flog;

#ifdef PatternType
extern struct b_pelem EOP;
#endif					/* PatternType */

#if NT
extern struct  b_cons *LstTmpFiles;
#endif					/* NT */

#ifdef Audio
extern int isPlaying;
#endif					/* Audio */

#ifdef VerifyHeap
extern long vrfy;
extern long vrfyOpCtrl;
extern void vrfyLog(const char *fmt, ...);
extern void vrfy_Live_Table(struct b_table *b);
#endif                  /* VerifyHeap */

#ifdef DEVMODE
extern void dbgUFL();
extern void dbgUtrace();
extern int dbgbrkpoint();
#endif                  /* DEVMODE */
