/*
 *  Definitions for macros and manifest constants used in the compiler
 *  interpreter.
 */

/*
 *  Definitions common to the compiler and interpreter.
 */

/*
 * Constants that are not likely to vary between implementations.
 */

#define BitOffMask (IntBits-1)
#define CsetSize (256/IntBits)  /* number of ints to hold 256 cset
                                 *  bits. Use (256/IntBits)+1 if
                                 *  256 % IntBits != 0 */
#define MinListSlots        8   /* number of elements in an expansion
                                 * list element block  */

#define MaxCvtLen          257  /* largest string in conversions; the extra
                                 *  one is for a terminating null */
#define MaxReadStr         512  /* largest string to read() in one piece */
#if IntBits==16
#define MaxIn             32767 /* largest number of bytes to read() at once */
#else
#define MaxIn           ((10*1024*1024)-1) /* max # of bytes to reads() at once */
#endif
#define RandA        1103515245 /* random seed multiplier */
#define RandC         453816694 /* random seed additive constant */
#define RanScale 4.65661286e-10 /* random scale factor = 1/(2^31-1) */

#define Pi 3.14159265358979323846264338327950288419716939937511

/*
 * File status flags in status field of file blocks.
 */
#define Fs_Read          01     /* read access */
#define Fs_Write         02     /* write access */
#define Fs_Create        04     /* file created on open */
#define Fs_Append       010     /* append mode */
#define Fs_Pipe         020     /* reading or writing on a pipe */
                                /* see also: BPipe down below */

/*                      040        this bit is now available */

#define Fs_Reading     0100     /* last file operation was read */
#define Fs_Writing     0200     /* last file operation was write */

/*#ifdef Graphics*/
   #define Fs_Window   0400     /* reading/writing on a window */
/*#endif */                                     /* Graphics */

#define Fs_Untrans    01000     /* untranslated mode file */
#define Fs_Directory  02000     /* reading a directory */

#ifdef Dbm
   #define Fs_Dbm       04000           /* a dbm file */
#endif                                  /* Dbm */

#ifdef PosixFns
   #define Fs_Socket    010000
   #define Fs_Buff      020000
   #define Fs_Unbuf     040000
   #define Fs_Listen   0100000
   #define Fs_BPipe    0200000          /* bidirectional pipe */

#if HAVE_LIBSSL
  #define Fs_Encrypt   0200000000      /* encrypted sockets */
#endif

#endif                                  /* PosixFns */

#ifdef ISQL
   #define Fs_ODBC      0400000
   #define RC_SUCCESSFUL(rc) (rc==SQL_SUCCESS || rc==SQL_SUCCESS_WITH_INFO)
   #define RC_NOTSUCCESSFUL(rc) (!(RC_SUCCESSFUL(rc)))
#endif                                  /* ISQL */

#ifdef Messaging
   #define Fs_Messaging 01000000
   #define Fs_Verify    02000000
#endif                                  /* Messaging */

/*#ifdef Graphics3D*/
   #define Fs_Window3D  04000000        /* reading/writing on a window */
/*#endif*/                                      /* Graphics3D */

#if HAVE_LIBZ
   #define Fs_Compress  010000000       /* reading/writing compressed file */
#endif                                  /* HAVE_LIBZ */

#ifdef HAVE_VOICE
   #define Fs_Voice     020000000               /* voice/audio connection */
#endif                                  /* HAVE_VOICE */

#ifdef PseudoPty
   #define Fs_Pty       040000000            /* pty */
#endif

#ifdef GraphicsGL
   #define Fs_WinGL2D   0100000000      /* for OpenGL 2D window */
#endif                                  /* GraphicsGL */

/*
 * Thread status flags in status field of coexpr blocks.
 * Ts_Native can only be Ts_Sync.  Ts_Posix may be Sync or Async.
 */
#define Ts_Main         01              /* This is the main co-expression */
#define Ts_Thread       02              /* This is a thread */
#define Ts_Attached     04              /* OS-level thread attached to this ce */

#define Ts_Async       010              /* asynchronous (concurrent) thread */
#define Ts_Actived     020              /* activated at least once */
#define Ts_Active      040              /* someone activated me */

#define Ts_WTinbox    0100              /* waiting on inbox Q */
#define Ts_WToutbox   0200              /* waiting on outbox Q */
#define Ts_Posix      0400              /* POSIX (pthread-based) coexpression */

#define Ts_SoftThread   01000           /* soft thread */

#define SET_FLAG(X,F)        (X) |= (F)
#define UNSET_FLAG(X,F)      (X) &= ~(F)
#define CHECK_FLAG(X,F)      ((X) & (F))
#define NOT_CHECK_FLAG(X,F)  (!CHECK_FLAG(X,F))

#define IS_TS_MAIN(X) CHECK_FLAG(X, Ts_Main)
#define IS_TS_THREAD(X) CHECK_FLAG(X, Ts_Thread)
#define IS_TS_ATTACHED(X) CHECK_FLAG(X, Ts_Attached)
#define IS_TS_POSIX(X) CHECK_FLAG(X, Ts_Posix)
#define IS_TS_ASYNC(X) CHECK_FLAG(X, Ts_Async)
#define IS_TS_SYNC(X) (!IS_TS_ASYNC(X))
#define IS_TS_SOFTTHREAD(X) CHECK_FLAG(X, Ts_SoftThread)

/*#ifdef Graphics*/
   #define XKey_Window 0
   #define XKey_Fg 1

   #ifndef SHORT
      #define SHORT int
   #endif                               /* SHORT */
   #ifndef LONG
      #define LONG int
   #endif                               /* LONG */

   /*
    * Perform a "C" return, not processed by RTT
    */
   #define VanquishReturn(s) return s;
/*#endif*/                                      /* Graphics */

/*
 * Codes returned by runtime support routines.
 *  Note, some conversion routines also return type codes. Other routines may
 *  return positive values other than return codes. sort() places restrictions
 *  on Less, Equal, and Greater.
 *
 * The symbol Error is used in Windows 8.1 header file ws2tcpip.h, so Unicon's
 * Error has been renamed RunError.
 */

#define Less            -1
#define Equal           0
#define Greater         1

#define CvtFail         -2
#define Cvt             -3
#define NoCvt           -4
#define Failed          -5
#define Defaulted       -6
#define Succeeded       -7
#define RunError        -8

#define GlobalName      0
#define StaticName      1
#define ParamName       2
#define LocalName       3

#undef ToAscii
#undef FromAscii
#if EBCDIC == 2
   #define ToAscii(e) (FromEBCDIC[e])
   #define FromAscii(e) (ToEBCDIC[e])
#else                                   /* EBCDIC == 2 */
   #define ToAscii(e) (e)
   #define FromAscii(e) (e)
#endif                                  /* EBCDIC == 2 */

/*
 * Pointer to block.
 */
#define BlkLoc(d)       ((d).vword.bptr)

#define BlkMask(d)      ((struct b_mask *)((d).vword.bptr))

/*
 * Block reference macros.  This abstraction of the act of dereferencing a
 * block pointer does not add clarity, it allows runtime type checking of
 * block references, if DebugHeap is enabled.
 *
 * Blk   ("Block") - convert union block ptr to a typed block ptr
 * BlkD  ("Block (from) Descriptor") - fetch typed block ptr for a descriptor
 * BlkPH ("Block )
 */
#define BlkD(d,u) Blk(BlkLoc(d),u)
#ifndef DebugHeap
#define Blk(p,u) (&((p)->u))
#define BlkPH(p,u,s) ((p)->u.s)
#define BlkPE(p,u,s) ((p)->u.s)
#else                                   /* !DebugHeap */

/*
 * Debug Heap macros.  These add runtime checks to catch (most)
 * illegal block references resulting from untended pointers.
 * Use during new code development, when gdb and valgrind fail to help.
 */

/*
 * could make the ValidPtr check much pickier -- check if it is
 * in a block or icode region (only places blocks can appear)
 */
#define ValidPtr(p) (((unsigned long)(p)) > 256)

/*
 * Block references that do not use (the address of) a particular field.
 */
#define Blk(p,u) ((((!ValidPtr(p)) || ((p)->u.title != T_ ## u)) ? \
      (heaperr("invalid block",p, T_ ## u) , 1) : 1), &((p)->u))

/*
 * Block references for generic (set|table) code.
 */
#define BlkPA(p,u,s,t,f) \
   ((ValidPtr(p) ? \
   ((((p)->Set.title == T_ ## s)||((p)->Set.title == T_ ## t)) ? ((p)->u.f) : \
      (heaperr("invalid block title", p, (p)->Set.title), ((p)->u.f))) : \
     (syserr("invalid pointer"), ((p)->u.f))))
#define BlkPH(p,u,f) BlkPA(p,u,Set,Table,f)
#define BlkPE(p,u,f) BlkPA(p,u,Selem,Telem,f)

#endif                                  /* DebugHeap */

/*
 * Check for null-valued descriptor.
 */
#define ChkNull(d)      ((d).dword==D_Null)

/*
 * Check for equivalent descriptors.
 */
#define EqlDesc(d1,d2)  ((d1).dword == (d2).dword && BlkLoc(d1) == BlkLoc(d2))

/*
 * Integer value.
 */
#define IntVal(d)       ((d).vword.integr)

/*
 * Offset from top of block to value of variable.
 */
#define Offset(d)       ((d).dword & OffsetMask)

/*
 * Check for pointer.
 */
#define Pointer(d)      ((d).dword & F_Ptr)

/*
 * Check for qualifier.
 */
#define Qual(d)         (!((d).dword & F_Nqual))

/*
 * Length of string.
 */
#define StrLen(q)       ((q).dword)

/*
 * Location of first character of string.
 */
#define StrLoc(q)       ((q).vword.sptr)

/*
 * Assign a C string to a descriptor. Assume it is reasonable to use the
 *   descriptor expression more than once, but not the string expression.
 */
#define AsgnCStr(d,s) (StrLoc(d) = (s), StrLen(d) = strlen(StrLoc(d)))

/*
 * Type of descriptor.
 */
#ifdef DebugHeap
#define Type(d)         (int)((((d).dword & F_Typecode) ? ((int)((d).dword & TypeMask)) : (heaperr("descriptor type error",BlkLoc(d),(d).dword), -1)))
#else                                   /* DebugHeap */
#define Type(d) (int)((d).dword & TypeMask)
#endif                                  /* DebugHeap */

/*
 * Check for variable.
 */
#define Var(d)          ((d).dword & F_Var)

/*
 * Location of the value of a variable.
 */
#define VarLoc(d)       ((d).vword.descptr)

/*
 *  Important note:  The code that follows is not strictly legal C.
 *   It tests to see if pointer p2 is between p1 and p3. This may
 *   involve the comparison of pointers in different arrays, which
 *   is not well-defined.  The casts of these pointers to unsigned "words"
 *   (longs or ints, depending) works with all C compilers and architectures
 *   on which Icon has been implemented.  However, it is possible it will
 *   not work on some system.  If it doesn't, there may be a "false
 *   positive" test, which is likely to cause a memory violation or a
 *   loop. It is not practical to implement Icon on a system on which this
 *   happens.
 */

#define InRange(p1,p2,p3) ((uword)(p2) >= (uword)(p1) && (uword)(p2) < (uword)(p3))

/*
 * Get floating-point number from real block.    * Get floating-point number into res from real block dp.
 * If Double is defined, the value may be misaligned.
 */
#ifdef Double
#ifdef DescriptorDouble
   #define GetReal(dp,res) *((struct size_dbl *)&(res)) =\
         *((struct size_dbl *)&((dp)->vword.realval))
#else                                   /* DescriptorDouble */
#ifdef DebugHeap
   #define GetReal(dp,res) (BlkD(*dp, Real), *((struct size_dbl *)&(res)) =\
         *((struct size_dbl *)&(BlkLoc(*dp)->Real.realval)))
#else                                   /* DebugHeap */
   #define GetReal(dp,res) *((struct size_dbl *)&(res)) =\
         *((struct size_dbl *)&((BlkLoc(*dp)->Real.realval)))
#endif                                  /* DebugHeap */
#endif                                  /* DescriptorDouble */

#else                                   /* Double */
#ifdef DescriptorDouble
   #define GetReal(dp,res)      res = dp->vword.realval
#else                                   /* DescriptorDouble */
   #define GetReal(dp,res)      res = BlkD(*dp,Real)->realval
#endif                                  /* DescriptorDouble */
#endif                                  /* Double */

#ifdef DescriptorDouble
   #define RealVal(d)           (d).vword.realval
#else                                   /* DescriptorDouble */
   #define RealVal(d)           BlkLoc(d)->Real.realval
#endif                                  /* DescriptorDouble */


/*
 * Absolute value, maximum, and minimum.
 */
   #define Abs(x) (((x) < 0) ? (-(x)) : (x))
   /*
    * gcc docs recommends these type-safe definitions for Max/Min
    */

#define Max(a,b)               \
  ({ __typeof__(a) _a = (a);   \
     __typeof__(b) _b = (b);   \
    _a > _b ? _a : _b; })

#define Min(a,b)               \
  ({ __typeof__ (a) _a = (a);  \
     __typeof__ (b) _b = (b);  \
    _a < _b ? _a : _b; })

/*
 * Number of elements of a C array, and element size.
 */
#define ElemCount(a) (sizeof(a)/sizeof(a[0]))
#define ElemSize(a) (sizeof(a[0]))

/*
 * Some C compilers take '\n' and '\r' to be the same, so the
 *  following definitions are used.
 */
#if EBCDIC
   /*
    * Note that, in EBCDIC, "line feed" and "new line" are distinct
    *  characters.  Icon's use of "line feed" is really "new line" in
    *  C terms.
    */
   #define LineFeed '\n'        /* if really "line feed", that's 37 */
   #define CarriageReturn '\r'
#else                                   /* EBCDIC */
   #define LineFeed  10
   #define CarriageReturn 13
   #define tonum(c)     (isdigit(c) ? (c - '0') : ((c & 037) + 9))
#endif                                  /* EBCDIC */


/*
 * Construct an integer descriptor.
 */
#define MakeInt(i,dp)           do { \
                         (dp)->dword = D_Integer; \
                         IntVal(*dp) = (word)(i); \
                         } while (0)

/*
 * Construct a real descriptor. dword set after vword so that we don't
 * have any half-baked reals tended at time of call to alcreal.
 */
#ifdef DescriptorDouble
#define MakeRealAlc(r,dp) do {\
   (dp)->vword.realval = r;\
   (dp)->dword = D_Real;\
   } while(0)
#else                                   /* !DescriptorDouble */
#define MakeRealAlc(r,dp) do { \
   BlkLoc(*dp) = (union block *)alcreal(r); \
   (dp)->dword = D_Real; \
   } while(0)
#endif                                  /* DescriptorDouble */

/*
 * Construct a string descriptor.
 */
#define MakeStr(s,len,dp)      do { \
                         StrLoc(*dp) = (s); \
                         StrLen(*dp) = (len); \
                         } while (0)

/*
 * Offset in word of cset bit.
 */
#define CsetOff(b)      ((b) & BitOffMask)

/*
 * Set bit b in cset c.
 */
#define Setb(b,c)       (*CsetPtr(b,c) |= (1u << CsetOff(b)))

/*
 * Test bit b in cset c.
 */
#define Testb(b,c)      ((*CsetPtr(b,c) >> CsetOff(b)) & 1u)

/*
 * Check whether a set or table needs resizing.
 */
#define SP(p) ((struct b_set *)p)
#define TooCrowded(p) \
   ((SP(p)->size > MaxHLoad*(SP(p)->mask+1)) && (SP(p)->hdir[HSegs-1] == NULL))
#define TooSparse(p) \
   ((SP(p)->hdir[1] != NULL) && (SP(p)->size < MinHLoad*(SP(p)->mask+1)))

/*
 * Definitions and declarations used for storage management.
 */
#define F_Mark          0100000         /* bit for marking blocks */

/*
 * Argument values for the built-in Icon user function "collect()".
 */
#define Static  1                       /* collection is for static region */
#define Strings 2                       /* collection is for strings */
#define Blocks  3                       /* collection is for blocks */

/*
 * Get type of block pointed at by x.
 */
#define BlkType(x)   (*(word *)x)

/*
 * BlkSize(x) takes the block pointed to by x and if the size of
 *  the block as indicated by bsizes[] is nonzero it returns the
 *  indicated size; otherwise it returns the second word in the
 *  block contains the size.
 */
#define BlkSize(x) (bsizes[*(word *)x & ~F_Mark] ? \
                     bsizes[*(word *)x & ~F_Mark] : *((word *)x + 1))

/*
 * Here are the events we support (in addition to keyboard characters)
 */
#define MOUSELEFT       (-1)
#define MOUSEMID        (-2)
#define MOUSERIGHT      (-3)
#define MOUSELEFTUP     (-4)
#define MOUSEMIDUP      (-5)
#define MOUSERIGHTUP    (-6)
#define MOUSELEFTDRAG   (-7)
#define MOUSEMIDDRAG    (-8)
#define MOUSERIGHTDRAG  (-9)
#define RESIZED         (-10)
#define WINDOWCLOSED    (-11)
#define MOUSEMOVED      (-12)
#define SCROLLUP        (-13)
#define SCROLLDOWN      (-14)
#define LASTEVENTCODE   SCROLLDOWN

/*
 * Type codes (descriptors and blocks).
 */
#define T_String        -1      /* string -- for reference; not used */
#define T_Null           0      /* null value */
#define T_Integer        1      /* integer */

#ifdef LargeInts
   #define T_Lrgint      2      /* long integer */
#endif                                  /* LargeInts */

#define T_Real           3      /* real number */
#define T_Cset           4      /* cset */
#define T_File           5      /* file */
#define T_Proc           6      /* procedure */
#define T_Record         7      /* record */
#define T_List           8      /* list header */
#define T_Lelem          9      /* list element */
#define T_Set           10      /* set header */
#define T_Selem         11      /* set element */
#define T_Table         12      /* table header */
#define T_Telem         13      /* table element */
#define T_Tvtbl         14      /* table element trapped variable */
#define T_Slots         15      /* set/table hash slots */
#define T_Tvsubs        16      /* substring trapped variable */
#define T_Refresh       17      /* refresh block */
#define T_Coexpr        18      /* co-expression */
#define T_External      19      /* external block */
#define T_Kywdint       20      /* integer keyword */
#define T_Kywdpos       21      /* keyword &pos */
#define T_Kywdsubj      22      /* keyword &subject */
#define T_Kywdwin       23      /* keyword &window */
#define T_Kywdstr       24      /* string keyword */
#define T_Kywdevent     25      /* keyword &eventsource, etc. */

#ifdef PatternType
#define T_Pattern       26      /* pattern header */
#define T_Pelem         27      /* pattern element */
#endif                                  /* PatternType */

#define T_Tvmonitored   28      /* Monitored trapped variable */
#define T_Intarray      29      /* integer array */
#define T_Realarray     30      /* real array */
#define T_Cons          31      /* generic link list element */

#define MaxType         31      /* maximum type number */

/*
 * Definitions for keywords.
 */

#define k_pos kywd_pos.vword.integr     /* value of &pos */
#define k_random kywd_ran.vword.integr  /* value of &random */
#define k_trace kywd_trc.vword.integr   /* value of &trace */
#define k_dump kywd_dmp.vword.integr    /* value of &dump */

#ifdef FncTrace
   #define k_ftrace kywd_ftrc.vword.integr      /* value of &ftrace */
#endif                                  /* FncTrace */

/*
 * Descriptor types and flags.
 */

#define D_Null          ((word)(T_Null     | D_Typecode))
#define D_Integer       ((word)(T_Integer  | D_Typecode))

#ifdef LargeInts
   #define D_Lrgint     ((word)(T_Lrgint | D_Typecode | F_Ptr))
#endif                                  /* LargeInts */

#ifdef DescriptorDouble
#define D_Real          ((word)(T_Real     | D_Typecode))
#else                                   /* DescriptorDouble */
#define D_Real          ((word)(T_Real     | D_Typecode | F_Ptr))
#endif                                  /* DescriptorDouble */
#define D_Cset          ((word)(T_Cset     | D_Typecode | F_Ptr))
#define D_File          ((word)(T_File     | D_Typecode | F_Ptr))
#define D_Proc          ((word)(T_Proc     | D_Typecode | F_Ptr))
#define D_List          ((word)(T_List     | D_Typecode | F_Ptr))
#define D_Lelem         ((word)(T_Lelem    | D_Typecode | F_Ptr))
#define D_Table         ((word)(T_Table    | D_Typecode | F_Ptr))
#define D_Telem         ((word)(T_Telem    | D_Typecode | F_Ptr))
#define D_Set           ((word)(T_Set      | D_Typecode | F_Ptr))
#define D_Selem         ((word)(T_Selem    | D_Typecode | F_Ptr))
#define D_Record        ((word)(T_Record   | D_Typecode | F_Ptr))
#define D_Tvsubs        ((word)(T_Tvsubs   | D_Typecode | F_Ptr | F_Var))
#define D_Tvtbl         ((word)(T_Tvtbl    | D_Typecode | F_Ptr | F_Var))
#define D_Tvmonitored   ((word)(T_Tvmonitored | D_Typecode | F_Ptr | F_Var))
#define D_Kywdint       ((word)(T_Kywdint  | D_Typecode | F_Ptr | F_Var))
#define D_Kywdpos       ((word)(T_Kywdpos  | D_Typecode | F_Ptr | F_Var))
#define D_Kywdsubj      ((word)(T_Kywdsubj | D_Typecode | F_Ptr | F_Var))
#define D_Refresh       ((word)(T_Refresh  | D_Typecode | F_Ptr))
#define D_Coexpr        ((word)(T_Coexpr   | D_Typecode | F_Ptr))
#define D_External      ((word)(T_External | D_Typecode | F_Ptr))
#define D_Slots         ((word)(T_Slots    | D_Typecode | F_Ptr))
#define D_Kywdwin       ((word)(T_Kywdwin  | D_Typecode | F_Ptr | F_Var))
#define D_Kywdstr       ((word)(T_Kywdstr  | D_Typecode | F_Ptr | F_Var))
#define D_Kywdevent     ((word)(T_Kywdevent | D_Typecode | F_Ptr | F_Var))
#ifdef PatternType
#define D_Pattern       ((word)(T_Pattern  | D_Typecode | F_Ptr))
#define D_Pelem         ((word)(T_Pelem    | D_Typecode | F_Ptr))
#endif                                  /* PatternType */
#define D_Intarray      ((word)(T_Intarray | D_Typecode | F_Ptr))
#define D_Realarray     ((word)(T_Realarray | D_Typecode | F_Ptr))

#define D_Var           ((word)(F_Var | F_Nqual | F_Ptr))
#define D_Typecode      ((word)(F_Nqual | F_Typecode))

#define TypeMask        63      /* type mask */
#define OffsetMask      (~(D_Var)) /* offset mask for variables */

/*
 * "In place" dereferencing. The 2nd version generates no E_Deref event;
 * it is for use during other events, to avoid spurious extra E_Deref's.
 */
#define Deref(d) if (Var(d)) deref(&d, &d)
#define Deref0(d) if (Var(d)) deref_0(&d, &d)

/*
 * Construct a substring trapped variable.
 */
#define SubStr(dest,var,len,pos)\
   if ((var)->dword == D_Tvsubs)\
      (dest)->vword.bptr = (union block *)alcsubs(len, (pos) +\
         BlkLoc(*(var))->Tvsubs.sspos - 1, &BlkLoc(*(var))->Tvsubs.ssvar);\
   else\
      (dest)->vword.bptr = (union block *)alcsubs(len, pos, (var));\
   (dest)->dword = D_Tvsubs;

/*
 * Find debug struct in procedure frame, assuming debugging is enabled.
 *  Note that there is always one descriptor in array even if it is not
 *  being used.
 */
#define PFDebug(pf) ((struct debug *)((char *)(pf).t.d +\
    sizeof(struct descrip) * ((pf).t.num ? (pf).t.num : 1)))

/*
 * Macro for initialized procedure block.
 */
#define B_IProc(n) struct {word title; word blksize; int (*ccode)();\
   word nparam; word ndynam; word nstatic; word fstatic;\
   struct sdescrip quals[n];}

/*
 * Check whether a number is not a power of 2
 */
#define not_poweroftwo(a) ((a) & (a-1))

#ifdef Concurrent

   #define CE_INBOX_SIZE        1024
   #define CE_OUTBOX_SIZE       1024
   #define CE_CEQUEUE_SIZE      64

   /* used in fmath.r, log() */
   #define lastbase             (curtstate->Lastbase)
   #define divisor              (curtstate->Divisor)

   /* used in fstr.r, map() */
   #define maptab               (curtstate->Maptab)
   #define maps2                (curtstate->Maps2)
   #define maps3                (curtstate->Maps3)

   /* used in rposix.r */
   #define callproc             (curtstate->Callproc)
   #define callproc_ibuf        (curtstate->Callproc_Ibuf)

   #define pollctr              (curtstate->Pollctr)

   #define curtstring           (curtstate->Curstring)
   #define curtblock            (curtstate->Curblock)


#define TURN_ON_CONCURRENT() do if (!is_concurrent) { \
      is_concurrent=1; global_curtstate = NULL; } while (0)

/*
#ifdef HAVE_KEYWORD__THREAD
#define CURTSTATE()
#define CURTSTATE_CE()
#else
*/

#define SYNC_GLOBAL_CURTSTATE()  do if (!is_concurrent) global_curtstate = \
      (struct threadstate *) pthread_getspecific(tstate_key); while (0)

#define TLS_CURTSTATE_ONLY()  struct threadstate *curtstate = \
      (struct threadstate *) pthread_getspecific(tstate_key);


#define GET_CURTSTATE()  struct threadstate *curtstate = \
    global_curtstate? global_curtstate: \
    (struct threadstate *) pthread_getspecific(tstate_key);

#define CURTSTATE_CE() struct b_coexpr *curtstate_ce = curtstate->c;

#ifdef NativeCoswitch
#define SYNC_CURTSTATE_CE() if (curtstate->c != curtstate_ce) curtstate_ce = curtstate->c;
#else                                   /* NativeCoswitch */
#define SYNC_CURTSTATE_CE()
#endif                                  /* NativeCoswitch */

#define CURTSTATE()  GET_CURTSTATE();
#define CURTSTATE_AND_CE() GET_CURTSTATE(); CURTSTATE_CE();

#ifdef TSTATARG
#define CURTSTATARG curtstate
#define RTTCURTSTATARG ,curtstate
#define CURTSTATVAR() CURTSTATE()
#else
#define CURTSTATARG
#define RTTCURTSTATARG
#if ConcurrentCOMPILER
#define CURTSTATVAR() CURTSTATE()
#else                                   /* ConcurrentCOMPILER */
#define CURTSTATVAR()
#endif                                  /* ConcurrentCOMPILER */
#endif                                  /* TSTATARG */
/*#endif*/

#define ssize    (curtstate->Curstring->size)
#define strbase  (curtstate->Curstring->base)
#define strend   (curtstate->Curstring->end)
#define strfree  (curtstate->Curstring->free)

#define abrsize  (curtstate->Curblock->size)
#define blkbase  (curtstate->Curblock->base)
#define blkend   (curtstate->Curblock->end)
#define blkfree  (curtstate->Curblock->free)

#else                                   /* Concurrent */

#define CURTSTATE()
#define CURTSTATE_CE()
#define CURTSTATE_AND_CE()
#define SYNC_GLOBAL_CURTSTATE()
#define TLS_CURTSTATE_ONLY()
#define SYNC_CURTSTATE_CE()

#define CURTSTATARG
#define RTTCURTSTATARG
#define CURTSTATVAR()
#define ssize    (curstring->size)
#define strbase  (curstring->base)
#define strend   (curstring->end)
#define strfree  (curstring->free)

#define abrsize  (curblock->size)
#define blkbase  (curblock->base)
#define blkend   (curblock->end)
#define blkfree  (curblock->free)
#endif                                  /* Concurrent */

#if COMPILER
#if ConcurrentCOMPILER
/*
 * ConcurrentCOMPILER claims to avoid threads hanging by periodically
 * answering thread_call's from within Poll().  This should probably
 * by reviewed by Jafar to answer: (A) is it correct and safe, and
 * (B) if so, should regular Concurrent be doing it?
 */
#ifdef Graphics
#define Poll() do{ \
  if (!pollctr--) pollctr = pollevent(); \
  if (thread_call){ \
    thread_control(TC_ANSWERCALL);}\
}while (0)
   #else                                /* Graphics */
#define Poll() do{ \
  if (thread_call){ \
  thread_control(TC_ANSWERCALL);\
  }\
  } while (0)
#endif                                   /* Graphics */
#else                                    /* ConcurrentCOMPILER */
   #ifdef Graphics
      #define Poll() if (!pollctr--) pollctr = pollevent()
   #else                                /* Graphics */
      #define Poll()
   #endif                               /* Graphics */
#endif                                  /* ConcurrentCOMPILER */

#else                                   /* COMPILER */

   /*
    * Definitions for the interpreter.
    */

   /*
    * Codes returned by invoke to indicate action.
    */
   #define I_Builtin    201     /* A built-in routine is to be invoked */
   #define I_Fail       202     /* goal-directed evaluation failed */
   #define I_Continue   203     /* Continue execution in the interp loop */
   #define I_Vararg     204     /* A function with a variable number of args */

   /*
    * Generator types.
    */
   #define G_Csusp              1
   #define G_Esusp              2
   #define G_Psusp              3
   #define G_Fsusp              4
   #define G_Osusp              5

   /*
    * Evaluation stack overflow margin
    */
   #define PerilDelta 100

   /*
    * Macro definitions related to descriptors.
    */

   /*
    * The following code is operating-system dependent [@rt.01].  Define
    *  PushAval for computers that store longs and pointers differently.
    */

   #if PORT
      #define PushAVal(x) PushVal(x)
      Deliberate Syntax Error
   #endif                               /* PORT */

   #if MVS || UNIX || VM || VMS
      #define PushAVal(x) PushVal(x)
   #endif                               /* MVS ... VMS */

   #if MSDOS
         #define PushAVal(x)  {sp++; \
                                stkword.stkadr = (char *)(x); \
                                *sp = stkword.stkint;}
   #endif                               /* MSDOS */

   /*
    * End of operating-system specific code.
    */

   /*
    * Macros for pushing values on the interpreter stack.
    */

   /*
    * Push descriptor.
    */
   #define PushDesc(d)  {*++sp = ((d).dword); sp++;*sp =((d).vword.integr);}

   /*
    * Push null-valued descriptor.
    */
   #define PushNull     {*++sp = D_Null; sp++; *sp = 0;}

   /*
    * Push word.
    */
   #define PushVal(v)   {*++sp = (word)(v);}

   /*
    * Macros related to function and operator definition.
    */

   /*
    * Procedure block for a function.
    */

   #if VMS
      #define FncBlock(f,nargs,deref) \
        struct b_iproc Cat(B,f) = {\
        T_Proc,\
        Vsizeof(struct b_proc),\
        Cat(Y,f),\
        nargs,\
        -1,\
        deref, 0,\
        {sizeof(Lit(f))-1,Lit(f)}};
   #else                                /* VMS */
      #define FncBlock(f,nargs,deref) \
        struct b_iproc Cat(B,f) = {\
        T_Proc,\
        Vsizeof(struct b_proc),\
        Cat(Z,f),\
        nargs,\
        -1,\
        deref, 0,\
        {sizeof(Lit(f))-1,Lit(f)}};
   #endif                               /* VMS */

   /*
    * Procedure block for an operator.
    */
   #define OpBlock(f,nargs,sname,xtrargs)\
        struct b_iproc Cat(B,f) = {\
        T_Proc,\
        Vsizeof(struct b_proc),\
        Cat(O,f),\
        nargs,\
        -1,\
        xtrargs,\
        0,\
        {sizeof(sname)-1,sname}};

   /*
    * Operator declaration.
    */
   #define OpDcl(nm,n,pn) OpBlock(nm,n,pn,0) Cat(O,nm)(cargp) register dptr cargp;

   /*
    * Operator declaration with extra working argument.
    */
   #define OpDclE(nm,n,pn) OpBlock(nm,-n,pn,0) Cat(O,nm)(cargp) register dptr cargp;

   /*
    * Agent routine declaration.
    */
   #define AgtDcl(nm) Cat(A,nm)(cargp) register dptr cargp;

   /*
    * Macros to access Icon arguments in C functions.
    */

   /*
    * n-th argument.
    */
   #define Arg(n)               (cargp[n])

   /*
    * Type field of n-th argument.
    */
   #define ArgType(n)   (cargp[n].dword)

   /*
    * Value field of n-th argument.
    */
   #define ArgVal(n)    (cargp[n].vword.integr)

   /*
    * Specific arguments.
    */
   #define Arg0 (cargp[0])
   #define Arg1 (cargp[1])
   #define Arg2 (cargp[2])
   #define Arg3 (cargp[3])
   #define Arg4 (cargp[4])
   #define Arg5 (cargp[5])
   #define Arg6 (cargp[6])
   #define Arg7 (cargp[7])
   #define Arg8 (cargp[8])

   /*
    * Miscellaneous macro definitions.
    */

   #ifdef MultiProgram
      #define handlers  (curpstate->Handlers)
      #define kywd_err  (curpstate->Kywd_err)
      #define kywd_prog  (curpstate->Kywd_prog)
      #define k_eventcode (curpstate->eventcode)
      #define k_eventsource (curpstate->eventsource)
      #define k_eventvalue (curpstate->eventval)
      #define kywd_trc  (curpstate->Kywd_trc)
      #define mainhead (curpstate->Mainhead)
      #define code (curpstate->Code)
      #define endcode (curpstate->Ecode)
      #define records (curpstate->Records)
      #define ftabp (curpstate->Ftabp)
      #ifdef FieldTableCompression
         #define ftabwidth (curpstate->Ftabwidth)
         #define foffwidth (curpstate->Foffwidth)
         #define ftabcp (curpstate->Ftabcp)
         #define ftabsp (curpstate->Ftabsp)
         #define focp (curpstate->Focp)
         #define fosp (curpstate->Fosp)
         #define fo (curpstate->Fo)
         #define bm (curpstate->Bm)
      #endif                            /* FieldTableCompression */
      #define fnames (curpstate->Fnames)
      #define efnames (curpstate->Efnames)
      #define globals (curpstate->Globals)
      #define eglobals (curpstate->Eglobals)
      #define gnames (curpstate->Gnames)
      #define egnames (curpstate->Egnames)
      #define statics (curpstate->Statics)
      #define estatics (curpstate->Estatics)
      #define n_globals (curpstate->NGlobals)
      #define n_statics (curpstate->NStatics)
      #define strcons (curpstate->Strcons)
      #define filenms (curpstate->Filenms)
      #define efilenms (curpstate->Efilenms)
      #define ilines (curpstate->Ilines)
      #define elines (curpstate->Elines)
      #define current_line_ptr (curpstate->Current_line_ptr)

/*#ifdef Graphics*/
         #define amperX   (curpstate->AmperX)
         #define amperY   (curpstate->AmperY)
         #define amperRow (curpstate->AmperRow)
         #define amperCol (curpstate->AmperCol)
         #define amperInterval (curpstate->AmperInterval)
         #define lastEventWin (curpstate->LastEventWin)
         #define lastEvFWidth (curpstate->LastEvFWidth)
         #define lastEvLeading (curpstate->LastEvLeading)
         #define lastEvAscent (curpstate->LastEvAscent)
         #define kywd_xwin (curpstate->Kywd_xwin)
         #define xmod_control (curpstate->Xmod_Control)
         #define xmod_shift (curpstate->Xmod_Shift)
         #define xmod_meta (curpstate->Xmod_Meta)
      #ifdef Graphics3D
         #define amperPick   (curpstate->AmperPick)
      #endif                            /* Graphics3D */
/*#endif*/                              /* Graphics */

      #define coexp_ser (curpstate->Coexp_ser)
      #define list_ser  (curpstate->List_ser)
      #define intern_list_ser  (curpstate->Intern_list_ser)
#ifdef PatternType
      #define pat_ser  (curpstate->Pat_ser)
#endif                                  /* PatternType */
      #define set_ser   (curpstate->Set_ser)
      #define table_ser (curpstate->Table_ser)
#endif                                  /* MultiProgram */
#endif                                  /* COMPILER */

#ifdef MultiProgram
      #define curstring (curpstate->stringregion)
      #define curblock  (curpstate->blockregion)

      #define coll_tot  (curpstate->colltot)
      #define coll_stat (curpstate->collstat)
      #define coll_str  (curpstate->collstr)
      #define coll_blk  (curpstate->collblk)

#ifdef Concurrent
      /* coexpr local*/
      #define lastop    (curtstate_ce->Lastop)
      #define lastopnd  (curtstate_ce->Lastopnd)
#else
      /* thread local*/
      #define lastop    (curtstate->Lastop)
      #define lastopnd  (curtstate->Lastopnd)
#endif                                  /* Concurrent */
#endif                                  /* MultiProgram */

#ifdef MultiProgram
      #define field_argp (curtstate->Field_argp)
      #define xargp     (curtstate->Xargp)
      #define xnargs    (curtstate->Xnargs)
      #ifdef PosixFns
         #define amperErrno (curtstate->AmperErrno)
      #endif

      #define line_num  (curtstate->Line_num)
#endif                                  /* MultiProgram */

#if defined(MultiProgram) || ConcurrentCOMPILER
      #define glbl_argp      (curtstate->Glbl_argp)

      #define kywd_pos       (curtstate->Kywd_pos)
      #define k_subject      (curtstate->ksub)
      #define kywd_ran       (curtstate->Kywd_ran)
      #define value_tmp      (curtstate->Value_tmp)

      #define k_current     (curtstate->K_current)
      #define k_errornumber (curtstate->K_errornumber)
      #define k_level       (curtstate->K_level)
      #define k_errortext   (curtstate->K_errortext)
      #define k_errorvalue  (curtstate->K_errorvalue)
#ifdef PatternType
      #define k_patindex    (curtstate->K_patindex)
#endif
      #define have_errval   (curtstate->Have_errval)
      #define t_errornumber (curtstate->T_errornumber)
      #define t_have_val    (curtstate->T_have_val)
      #define t_errorvalue  (curtstate->T_errorvalue)
      #define column    (curtstate->Column)
      #define lastline  (curtstate->Lastline)
      #define lastcol   (curtstate->Lastcol)

#ifdef Concurrent
      #define tend        (curtstate_ce->es_tend)
      #define pfp         (curtstate_ce->es_pfp)
#if !ConcurrentCOMPILER
      #define efp         (curtstate_ce->es_efp)
      #define gfp         (curtstate_ce->es_gfp)
      #define ipc         (curtstate_ce->es_ipc)
      #define oldipc      (curtstate_ce->es_oldipc)
      #define sp          (curtstate_ce->es_sp)
      #define ilevel      (curtstate_ce->es_ilevel)

      #define eret_tmp       (curtstate->Eret_tmp)
#endif                                  /* ConcurrentCOMPILER */

#ifndef StackCheck
      #define stack          (curtstate->Stack)
      #define stackend       (curtstate->Stackend)
#endif                                  /* StackCheck */

#ifdef PosixFns
      #define savedbuf       (curtstate->Savedbuf)
      #define nsaved         (curtstate->Nsaved)
#endif                                  /* PosixFns */

#endif                                  /* Concurrent */

#if !ConcurrentCOMPILER
      #define k_main        (curpstate->K_main)
      #define k_errout      (curpstate->K_errout)
      #define k_input       (curpstate->K_input)
      #define k_output      (curpstate->K_output)

      #define longest_dr    (curpstate->Longest_dr)
      #define dr_arrays     (curpstate->Dr_arrays)

#ifdef Arrays
      #define cprealarray   (curpstate->Cprealarray)
      #define cpintarray    (curpstate->Cpintarray)
#endif                                  /* Arrays */
      #define cplist        (curpstate->Cplist)
      #define cpset         (curpstate->Cpset)
      #define cptable       (curpstate->Cptable)
      #define EVStrAlc      (curpstate->EVstralc)
      #define interp        (curpstate->Interp)
      #define cnv_cset      (curpstate->Cnvcset)
      #define cnv_int       (curpstate->Cnvint)
      #define cnv_real      (curpstate->Cnvreal)
      #define cnv_str       (curpstate->Cnvstr)
      #define cnv_tcset     (curpstate->Cnvtcset)
      #define cnv_tstr      (curpstate->Cnvtstr)
      #define deref         (curpstate->Deref)
      #define alcbignum     (curpstate->Alcbignum)
      #define alccset       (curpstate->Alccset)
      #define alcfile       (curpstate->Alcfile)
      #define alchash       (curpstate->Alchash)
      #define alcsegment    (curpstate->Alcsegment)
#ifdef PatternType
      #define alcpattern    (curpstate->Alcpattern)
      #define alcpelem      (curpstate->Alcpelem)
      #define cnv_pattern   (curpstate->Cnvpattern)
      #define internal_match (curpstate->Internalmatch)
#endif                                  /* PatternType */
      #define alclist_raw   (curpstate->Alclist_raw)
      #define alclist       (curpstate->Alclist)
      #define alclstb       (curpstate->Alclstb)
      #define alcreal       (curpstate->Alcreal)
      #define alcrecd       (curpstate->Alcrecd)
      #define alcrefresh    (curpstate->Alcrefresh)
      #define alcselem      (curpstate->Alcselem)
      #define alcstr        (curpstate->Alcstr)
      #define alcsubs       (curpstate->Alcsubs)
      #define alctelem      (curpstate->Alctelem)
      #define alctvtbl      (curpstate->Alctvtbl)
      #define deallocate    (curpstate->Deallocate)
      #define reserve       (curpstate->Reserve)
#endif                                  /* ConcurrentCOMPILER */

#ifdef Concurrent
#if !ConcurrentCOMPILER
      #define ENTERPSTATE(p) if (((p)!=NULL)) { curpstate = (p); }
#endif                                  /* ConcurrentCOMPILER */
#else                                   /* Concurrent */
      #define ENTERPSTATE(p) if (((p)!=NULL)) { curpstate = (p); curtstate=p->tstate;}
#endif                                  /* Concurrent */

#else                                   /* MultiProgram */
 #define ENTERPSTATE(p)
#endif                                  /* MultiProgram */


#if COMPILER || !defined(MultiProgram)
   #define EVStrAlc(n)
#endif

/*
 * Constants controlling expression evaluation.
 */
#if COMPILER
   #define A_Resume     -1      /* expression failed: resume a generator */
   #define A_Continue   -2      /* expression returned: continue execution */
   #define A_FallThru   -3      /* body function: fell through end of code */
   #define A_Coact      1       /* co-expression activation */
   #define A_Coret      2       /* co-expression return */
   #define A_Cofail     3       /* co-expression failure */
#else                                   /* COMPILER */
   #define A_Resume     1       /* routine failed */
   #define A_Pret_uw    2       /* interp unwind for Op_Pret */
   #define A_Unmark_uw  3       /* interp unwind for Op_Unmark */
   #define A_Pfail_uw   4       /* interp unwind for Op_Pfail */
   #define A_Lsusp_uw   5       /* interp unwind for Op_Lsusp */
   #define A_Eret_uw    6       /* interp unwind for Op_Eret */
   #define A_Continue   7       /* routine returned */
   #define A_Coact      8       /* co-expression activated */
   #define A_Coret      9       /* co-expression returned */
   #define A_Cofail     10      /* co-expression failed */
   #ifdef MultiProgram
      #define A_MTEvent 11      /* multiProgram event */
   #endif                               /* MultiProgram */
   #ifdef PosixFns
      #define   A_Trapret       12      /* Return from stub  */
      #define   A_Trapfail      13      /* Fail from stub  */
   #endif                               /* PosixFns */
   #ifdef SoftThreads
      #define A_Coschedule      14      /* co-expression schedule */
   #endif                               /* SoftThreads */
#endif                                  /* COMPILER */

#ifdef SoftThreads
#define SOFT_THREADS_SIZE 16
#define SOFT_THREADS_TSLICE 500
#endif                          /* SoftThreads */

/*
 * Address of word containing cset bit b (c is a struct descrip of type Cset).
 */
#define CsetPtr(b,c)    (BlkD(c,Cset)->bits + (((b)&0377) >> LogIntBits))

#if MSDOS
      #define ptr2word(x) (uword)x
      #define word2ptr(x) ((char *)x)
#endif                                  /* MSDOS */

#if NT
#ifndef S_ISDIR
#define S_ISDIR(mod) ((mod) & _S_IFDIR)
#endif                                  /* no S_ISDIR */
#endif                                  /* NT */

#ifdef ISQL                             /* ODBC support */

   /*
    * Icon/ODBC error codes
    */
   #define ODBC_ERR_SZ            19

   #define NOT_ODBC_FILE_ERR    1100
   #define FREE_STMT_ERR        1101
   #define DISCONNECT_ERR       1102
   #define FREE_CONNECT_ERR     1103
   #define ALLOC_STMT_ERR       1104
   #define ALLOC_ENV_ERR        1105
   #define ALLOC_CONNECT_ERR    1106
   #define CONNECT_ERR          1107
   #define EXEC_DIRECT_ERR      1108
   #define CLOSE_CURSOR_ERR     1109
   #define COLUMNS_ERR          1110
   #define PRIMARY_KEYS_ERR     1111
   #define NUM_RESULT_COLS_ERR  1112
   #define DESCRIBE_COL_ERR     1113
   #define FETCH_ERR            1114
   #define TABLES_ERR           1115
   #define NO_KEY_DEFINED_ERR   1116
   #define TOO_MANY_KEYS_ERR    1117
   #define KEY_MISSING_ERR      1118

#endif                                  /* ISQL */


/*
 * flags for ConsoleFlags
 */
/* I/O redirection flags */
#define StdOutRedirect        1
#define StdErrRedirect        2
#define StdInRedirect         4
#define OutputToBuf           8

#define SEM_WAIT(semptr) while (sem_wait(semptr) != 0 ) { \
        if (errno==EINVAL) syserr("invalid semaphore"); \
        else if (errno != EINTR) {perror("sem_wait()"); syserr("sem_wait error");} }

#ifndef NamedSemaphores
#define SEM_CLOSE(sem_s) sem_destroy(sem_s)
#else
#define SEM_CLOSE(sem_s) sem_close(sem_s)
#endif /* NamedSemaphores */

#define FUNC_MUTEX_LOCK         1
#define FUNC_MUTEX_TRYLOCK      2
#define FUNC_MUTEX_UNLOCK       3
#define FUNC_MUTEX_INIT         4
#define FUNC_MUTEX_DESTROY      5
#define FUNC_COND_WAIT          6
#define FUNC_COND_INIT          7
#define FUNC_COND_DESTROY       8
#define FUNC_COND_TIMEDWAIT     9
#define FUNC_COND_SIGNAL        10
#define FUNC_THREAD_CREATE      11
#define FUNC_THREAD_JOIN        12
#define FUNC_SEM_OPEN           13
#define FUNC_SEM_INIT           14

#ifdef PthreadCoswitch
#define THREAD_CREATE(cp, t_stksize, msg)                               \
  do {                                                                  \
    int retval;                                                         \
    if (t_stksize){                                                     \
      pthread_attr_t attr;                                              \
      pthread_attr_init(&attr);                                         \
      pthread_attr_setstacksize(&attr, t_stksize);                      \
      retval = pthread_create(&cp->thread, &attr, nctramp, cp);         \
    }                                                                   \
    else                                                                \
      retval = pthread_create(&cp->thread, NULL, nctramp, cp);          \
    if (retval) handle_thread_error(retval, FUNC_THREAD_CREATE, msg);   \
  } while (0)

#define THREAD_JOIN( thrd, opt ) do { int retval;               \
        if ((retval=pthread_join(thrd, opt)) != 0)              \
          handle_thread_error(retval, FUNC_THREAD_JOIN, NULL);  \
      } while (0)

#define CREATE_CE_THREAD(cp, t_stksize, msg) do {                       \
        THREAD_CREATE(cp, t_stksize, msg);                              \
        cp->alive = 1;                                                  \
        cp->have_thread = 1;                                            \
        SET_FLAG(cp->status, Ts_Attached);                              \
        SET_FLAG(cp->status, Ts_Posix);                                 \
        /*if (!(nstat & Ts_Sync ))pthread_detach(&new->thread);*/       \
      } while (0)
#else                                  /* PthreadCoswitch */
#define THREAD_CREATE(cp, t_stksize, msg)
#define THREAD_JOIN(thrd, opt)
#define CREATE_CE_THREAD(cp, t_stksize, msg)
#endif                                  /* PthreadCoswitch */

#ifdef Concurrent

   #define MTX_OP_ASTR          0
   #define MTX_OP_AREAL         1
   #define MTX_OP_ACSET         2
   #define MTX_OP_ASTATIC       3
   #define MTX_OP_AGLOBAL       4
   #define MTX_OP_AMARK         5
   #define MTX_OP_AGOTO         6

   #define MTX_LIST_SER         7
   #define MTX_COEXP_SER        8
   #define MTX_SET_SER          9
   #define MTX_TABLE_SER        10
   #define MTX_PAT_SER          11

   #define MTX_STRHEAP          12
   #define MTX_BLKHEAP          13

   #define MTX_TLS_CHAIN        14

   #define MTX_CURFILE_HANDLE   15

   #define MTX_SEGVTRAP_N       16

   #define MTX_DR_TBL           17

   #define MTX_SOCK_MAP         18

   #define MTX_THREADCONTROL    19
   #define MTX_NARTHREADS       20
   #define MTX_COND_TC          21

   #define MTX_HANDLERS         22

   #define MTX_ALCNUM           23

   #define MTX_PUBLICSTRHEAP    24
   #define MTX_PUBLICBLKHEAP    25

   #define MTX_ROOT_FILEPIDS    26

   #define MTX_PATIMG_FUNCARR   27

   #define MTX_STKLIST          28
   #define MTX_POLLEVENT        29
   #define MTX_RECID            30

   #define MTX_NOMTEVENTS       31

   #define MTX_MUTEXES          32
   #define MTX_CONDVARS         33

   #define MTX_STRINGTOTAL      34
   #define MTX_BLOCKTOTAL       35
   #define MTX_COLL             36


   /* This should be the last mutex, becasue it has special initialization*/
   #define MTX_INITIAL          37


   /* total is:  */
   #define NUM_STATIC_MUTEXES   38

   /* used by wait4GC function*/


   #define TC_NONE -1

   #define TC_ANSWERCALL 0

   #define TC_CALLTHREADS 1
   #define TC_WAKEUPCALL 2
   #define TC_STOPALLTHREADS 3
   #define TC_KILLALLTHREADS 4

/*
 *  Lock mutex mtx. msg is a string name that refers to mtx, useful for
 *  error tracing.
 */

#define MUTEX_LOCK( mtx, msg)                                           \
      do                                                                \
        if (is_concurrent) {                                            \
          int __rv;                                                     \
          if ((__rv=pthread_mutex_lock(&(mtx))) != 0)                   \
            handle_thread_error(__rv, FUNC_MUTEX_LOCK, msg);            \
        }                                                               \
      while (0)

#define MUTEX_UNLOCK( mtx, msg)                                         \
      do                                                                \
        if (is_concurrent) {                                            \
          int __rv;                                                     \
          if ((__rv=pthread_mutex_unlock(&(mtx))) != 0)                 \
            handle_thread_error(__rv, FUNC_MUTEX_UNLOCK, msg);          \
        }                                                               \
      while (0)

#define MUTEX_TRYLOCK(mtx, isbusy, msg)                                 \
      do                                                                \
        if (is_concurrent) {                                            \
          if ((isbusy=pthread_mutex_trylock(&(mtx))) != 0) {    \
            if (isbusy != EBUSY){                                       \
              handle_thread_error(isbusy, FUNC_MUTEX_TRYLOCK, msg);     \
              isbusy = 0;                                               \
            }                                                           \
          }                                                             \
        } else isbusy = 0;                                              \
      while (0)

#define MUTEX_INIT( mtx, attr )                                 \
      do { int __rv;                                            \
        if ((__rv=pthread_mutex_init(&(mtx), attr)) != 0)       \
          handle_thread_error(__rv, FUNC_MUTEX_INIT, NULL);     \
      } while (0)

/*
 *  Lock mutex mutexes[mtx].
 */


#define MUTEX_INITID( mtx, attr )                                       \
      do {                                                              \
        int __rv;                                                       \
        mutexes[mtx] = malloc(sizeof(pthread_mutex_t));                 \
        if ((__rv=pthread_mutex_init(mutexes[mtx], attr)) != 0) \
          handle_thread_error(__rv, FUNC_MUTEX_INIT, NULL);             \
      } while (0)

#define MUTEXID(mtx) mutexes[mtx]

//BASIC: don't define __rv or check is_concurrent, enclosing code will do it
#define MUTEX_LOCKID_BASIC(mtx)                                         \
      if ((__rv=pthread_mutex_lock(mutexes[mtx])) != 0)                 \
          handle_thread_error(__rv, FUNC_MUTEX_LOCK, NULL);

#define MUTEX_UNLOCKID_BASIC(mtx)                                       \
          if ((__rv=pthread_mutex_unlock(mutexes[mtx])) != 0)           \
            handle_thread_error(__rv, FUNC_MUTEX_UNLOCK, NULL);


#define MUTEX_TRYLOCKID_BASIC(mtx, isbusy)                              \
      if ((isbusy=pthread_mutex_trylock(mutexes[mtx])) != 0) {          \
        if (isbusy != EBUSY){                                           \
          handle_thread_error(isbusy, FUNC_MUTEX_TRYLOCK, NULL);        \
          isbusy = 0;                                                   \
        }                                                               \
      }

// AWLAYS: Always lock the mutex, don't check is_concurrent
#define MUTEX_LOCKID_ALWAYS(mtx)                                        \
      do {                                                              \
        int __rv;                                                       \
        MUTEX_LOCKID_BASIC(mtx)                                         \
      } while (0)

#define MUTEX_UNLOCKID_ALWAYS(mtx)                                      \
      do {                                                              \
          int __rv;                                                     \
          MUTEX_UNLOCKID_BASIC(mtx);                                    \
      } while (0)

#define MUTEX_LOCKID(mtx) do if ( is_concurrent )  MUTEX_LOCKID_ALWAYS(mtx);  while (0)

#define MUTEX_UNLOCKID(mtx) do if ( is_concurrent )  MUTEX_UNLOCKID_ALWAYS(mtx);  while (0)

#define MUTEX_TRYLOCKID(mtx, isbusy)         \
      do                                     \
        if (is_concurrent) {                 \
          MUTEX_TRYLOCKID_BASIC(mtx, isbusy) \
            }  else isbusy = 0;              \
      while (0)

#define INC_LOCKID(x, mtx) do {MUTEX_LOCKID(mtx);  x++; MUTEX_UNLOCKID(mtx);} while (0)
#define DEC_LOCKID(x, mtx) do {MUTEX_LOCKID(mtx);  x--; MUTEX_UNLOCKID(mtx);} while (0)

#define INC_NARTHREADS_CONTROLLED_BASIC                 \
          MUTEX_LOCKID_BASIC(MTX_THREADCONTROL);        \
          MUTEX_LOCKID_BASIC(MTX_NARTHREADS);           \
          NARthreads++;                                 \
          MUTEX_UNLOCKID_BASIC(MTX_NARTHREADS);         \
          MUTEX_UNLOCKID_BASIC(MTX_THREADCONTROL);

#define INC_NARTHREADS_CONTROLLED_ALWAYS                \
      do {                                              \
        int __rv;                                       \
        INC_NARTHREADS_CONTROLLED_BASIC;                \
      } while (0)

#define INC_NARTHREADS_CONTROLLED                       \
      do                                                \
        if (is_concurrent) {                            \
          int __rv;                                     \
          INC_NARTHREADS_CONTROLLED_BASIC;              \
        }                                               \
        else                                            \
          NARthreads++;                                 \
      while (0)

#define DEC_NARTHREADS_BASIC                            \
          MUTEX_LOCKID_BASIC(MTX_NARTHREADS);           \
          NARthreads--;                                 \
          MUTEX_UNLOCKID_BASIC(MTX_NARTHREADS);

#define DEC_NARTHREADS_ALWAYS                           \
      do {                                              \
        int __rv;                                       \
        DEC_NARTHREADS_BASIC;                           \
      } while (0)


#define DEC_NARTHREADS                                  \
      do {                                              \
        if (is_concurrent) {                            \
          int __rv;                                     \
          DEC_NARTHREADS_BASIC;                         \
        }                                               \
        else                                            \
          NARthreads--;                                 \
      } while (0)

#define MUTEX_LOCKID_CONTROLLED_ALWAYS(mtx)             \
      do {                                              \
          int __rv;                                     \
          MUTEX_TRYLOCKID_BASIC(mtx, __rv);             \
          if (__rv==EBUSY){                             \
            DEC_NARTHREADS_BASIC;                       \
            MUTEX_LOCKID_BASIC(mtx);                    \
            INC_NARTHREADS_CONTROLLED_BASIC;            \
          }                                             \
      } while (0)

#define MUTEX_LOCKID_CONTROLLED(mtx)            \
      do                                        \
        if (is_concurrent)                      \
          MUTEX_LOCKID_CONTROLLED_ALWAYS(mtx);  \
      while (0)

#define MUTEX_LOCK_CONTROLLED(mtx, msg)         \
      do {                                      \
        if (is_concurrent) {                    \
          MUTEX_LOCKID_CONTROLLED_ALWAYS(mtx)   \
          int __rv;                             \
          MUTEX_TRYLOCK(mtx, __rv, msg);        \
          if (__rv==EBUSY){                     \
            DEC_NARTHREADS_BASIC;               \
            MUTEX_LOCK(mtx, msg);               \
            INC_NARTHREADS_CONTROLLED_BASIC;    \
          }                                     \
        }                                       \
      } while (0)

/********** block macros *************/
#define MUTEX_LOCKBLK(bp, msg) \
      do if (bp->shared) {MUTEX_LOCKID_ALWAYS(bp->mutexid);} while (0)

#define MUTEX_LOCKBLK_CONTROLLED(bp, msg) \
      do if (bp->shared) {MUTEX_LOCKID_CONTROLLED_ALWAYS(bp->mutexid);} while (0)

#define MUTEX_UNLOCKBLK(bp, msg) \
      do if (bp->shared) {MUTEX_UNLOCKID_ALWAYS(bp->mutexid);} while (0)

#define MUTEX_TRYLOCKBLK(bp, isbusy, msg) \
      do if (bp->shared) {MUTEX_TRYLOCKID_BASIC(bp->mutexid, isbusy);} while (0)


/* assume that the block is shared! */
#define MUTEX_LOCKBLK_NOCHK(bp, msg) \
   MUTEX_LOCKID(bp->mutexid)

#define MUTEX_LOCKBLK_CONTROLLED_NOCHK(bp, msg) \
   MUTEX_LOCKID_CONTROLLED(bp->mutexid)


#define MUTEX_UNLOCKBLK_NOCHK(bp, msg) \
   MUTEX_UNLOCKID(bp->mutexid)

#define MUTEX_TRYLOCKBLK_NOCHK(bp, isbusy, msg) \
   MUTEX_TRYLOCKID(bp->mutexid, isbusy)


#define C_PUT_PROTECTED(L, v)                                   \
      do {                                                      \
        MUTEX_LOCKBLK(BlkD(L, List));                           \
        c_put(&L, &v); MUTEX_UNLOCKBLK(BlkD(L, List));          \
      } while (0)

#define MUTEX_INITBLK(bp)                       \
      do {                                      \
        if (!bp->shared){                       \
          bp->mutexid = get_mutex(&rmtx_attr);  \
          bp->shared = 1;                       \
        }                                       \
      } while (0)

#define MUTEX_INITBLKID(bp, mtx)                \
      do {                                      \
        if (!bp->shared){                       \
          bp->mutexid = mtx;                    \
          bp->shared = 1;                       \
        }                                       \
      } while (0)

#define MUTEX_GETBLK(bp) mutexes[bp->mutexid]

#define CV_GETULLTBLK(bp) condvars[bp->cvfull]
#define CV_GETULLTBLK(bp) condvars[bp->cvfull]

#define CV_INITBLK(bp)                          \
      do {                                      \
        MUTEX_INITBLK(bp);                      \
        bp->cvfull = get_cv(bp->mutexid);       \
        bp->cvempty = get_cv(bp->mutexid);      \
        bp->full = 0;                           \
        bp->empty = 0;                          \
        bp->max = 1024;                         \
      } while (0)

#define CV_WAIT_ON_EXPR(expr, cv, mtxid)                                \
  while (expr) pthread_cond_wait(cv, MUTEXID(mtxid));

#define CV_WAIT(cv, mtxid)                                              \
      do {                                                              \
        int __rv;                                                       \
        if ((__rv=pthread_cond_wait(cv, MUTEXID(mtxid)))<0 ){           \
          fprintf(stderr, "condition variable wait failure %d\n", __rv); \
          exit(-1);                                                     \
        }                                                               \
      } while (0)

#define CV_INIT(cv, msg)                                                \
      do{                                                               \
        int __rv;                                                       \
        if ((__rv=pthread_cond_init(cv, NULL))<0 ){                     \
          handle_thread_error(__rv, FUNC_COND_INIT, msg);               \
        }                                                               \
      } while (0)

#define CV_WAIT_FULLBLK(bp) \
    pthread_cond_wait(condvars[bp->cvfull], MUTEX_GETBLK(bp));

#define CV_WAIT_EMPTYBLK(bp) \
    pthread_cond_wait(condvars[bp->cvempty], MUTEX_GETBLK(bp));

#define CV_SIGNAL_FULLBLK(bp) if (bp->full) { \
    pthread_cond_signal(condvars[bp->cvfull]);}

#define CV_SIGNAL_EMPTYBLK(bp) if (bp->empty) { \
    pthread_cond_signal(condvars[bp->cvempty]);}

#define CV_TIMEDWAIT_EMPTYBLK(bp, t)\
  pthread_cond_timedwait(condvars[bp->cvempty], MUTEX_GETBLK(bp), &t);

#define SUSPEND_THREADS() thread_control(TC_STOPALLTHREADS)
#define RESUME_THREADS() thread_control(TC_WAKEUPCALL)

#define DO_COLLECT(region) do { \
   SUSPEND_THREADS(); \
   collect(region); \
   RESUME_THREADS(); \
   } while(0)

#else                                   /* Concurrent */

#define MUTEX_INIT(mtx, attr)
#define MUTEX_INITID(mtx, attr)
#define MUTEXID(mtx)
#define MUTEX_LOCK(mtx, msg)
#define MUTEX_UNLOCK(mtx, msg)
#define MUTEX_TRYLOCK(mtx, isbusy, msg)

#define MUTEX_LOCKID(mtx)
#define MUTEX_UNLOCKID(mtx)
#define MUTEX_TRYLOCKID(mtx, isbusy)

#define MUTEX_LOCKID_ALWAYS(mtx)
#define MUTEX_UNLOCKID_ALWAYS(mtx)

#define MUTEX_LOCK_CONTROLLED(mtx, msg)
#define MUTEX_LOCKID_CONTROLLED(mtx)
#define INC_LOCKID(x, mtx)
#define DEC_LOCKID(x, mtx)
#define INC_NARTHREADS_CONTROLLED
#define DEC_NARTHREADS
#define INC_NARTHREADS_CONTROLLED_ALWAYS
#define DEC_NARTHREADS_CONTROLLED_ALWAYS

#define MUTEX_INITBLK(bp)
#define MUTEX_INITBLKID(bp, mtx)
#define MUTEX_LOCKBLK(bp, msg)
#define MUTEX_LOCKBLK_CONTROLLED(bp, msg)
#define MUTEX_LOCKBLK_NOCHK(bp, msg)
#define MUTEX_LOCKBLK_CONTROLLED_NOCHK(bp, msg)
#define MUTEX_UNLOCKBLK(bp, msg)
#define MUTEX_TRYLOCKBLK(bp, isbusy, msg)
#define C_PUT_PROTECTED(L, v)
#define CV_INITBLK(bp)
#define MUTEX_GETBLK(bp)
#define CV_GETULLTBLK(bp)
#define CV_GETULLTBLK(bp)

#define CV_WAIT_FULLBLK(bp)
#define CV_WAIT(cv, mtxid)

#define CV_WAIT_EMPTYBLK(bp)
#define CV_SIGNAL_FULLBLK(bp)

#define CV_SIGNAL_EMPTYBLK(bp)

#define CV_TIMEDWAIT_EMPTYBLK(bp, t)

#define SUSPEND_THREADS()
#define RESUME_THREADS()

#define DO_COLLECT(region) collect(region)

#define CV_WAIT_ON_EXPR(expr, cv, mtxid)

#define CV_INIT(cv, msg)

#define MUTEX_LOCKBLK_NOCHK(bp, msg)

#define MUTEX_UNLOCKBLK_NOCHK(bp, msg)

#define MUTEX_TRYLOCKBLK_NOCHK(bp, isbusy, msg)

#endif                                  /* Concurrent */

#ifdef LargeInts
/* determine the number of words needed for a bignum block with n digits */

#define LrgNeed(n)   ( ((sizeof(struct b_bignum) + ((n) - 1) * sizeof(DIGIT)) \
                       + WordSize - 1) & -WordSize )
#endif                                  /* LargeInts */


#define PRINT_TEXTURE_INFO(wt, msg)                     \
  do {\
  printf("%s\n", msg); \
  printf("refcount = %d", (wt)->refcount);      \
  printf("\ttexName  = %d", (wt)->texName);     \
  printf("\ttextype  = %d", (wt)->textype);     \
  printf("\tserial   = %d", (wt)->serial);      \
  printf("\twidth    = %d", (wt)->width);       \
  printf("\theight   = %d\n", (wt)->height);    \
  } while (0)


#define REPORT_OPENGL_ERROR(msg) \
 do { \
  int rc; \
   rc = glGetError(); \
   switch (rc){ \
 case GL_NO_ERROR : printf("%s NO GL ERROR\n", msg); break; \
 case GL_INVALID_ENUM : printf("%s GL ERROR: invalid enum\n", msg); break; \
 case GL_INVALID_OPERATION : printf("%s GL ERROR: invalid op\n", msg); break; \
 default: printf("%s GL ERROR: %d\n", msg, rc); \
    } \
 } while (0)

#ifdef Concurrent
#if ConcurrentCOMPILER
      #define public_stringregion  (Public_stringregion)
      #define public_blockregion  (Public_blockregion)
      #define coexpr_fnc (curtstate->Coexpr_fnc)
#else
      #define public_stringregion (curpstate->Public_stringregion)
      #define public_blockregion (curpstate->Public_blockregion)
#endif                                  /* ConcurrentCOMPILER */
      #define strtotal          (curtstate->stringtotal)
      #define blktotal          (curtstate->blocktotal)
#else                                   /* Concurrent */
#ifdef MultiProgram
      #define strtotal  (curpstate->stringtotal)
      #define blktotal  (curpstate->blocktotal)
#endif                                  /* MultiProgram */
#endif                                  /* Concurrent */

/*
 * Rationale for new pattern (element) codes.
 *
 * Append bottom 4 bits onto existing codes in order to encode their suffix.
 * There are apparently 5 extra values that can be associated with each family
 * that are not part of one of the suffixes, values 11-15.
 *
 * xxxx0000 ==  0 == not a code, a family
 * xxxx0001 ==  1 == not used
 * xxxx0010 ==  2 == _VP
 * xxxx0011 ==  3 == _CH
 * xxxx0100 ==  4 == _CS
 * xxxx0101 ==  5 == _Nat
 * xxxx0110 ==  6 == _NF
 * xxxx0111 ==  7 == _NP
 * xxxx1000 ==  8 == _VF
 * xxxx1001 ==  9 == _MF
 * xxxx1010 == 10 == _NMF
 *
 * The purpose of all this is so that code that analyzes and categorizes
 * pattern element codes, particularly debuggers and the like, can trivially
 * extract base function (family) and suffix, without lots of comparisons
 * and checks.
 *
 * Families. The next four bits will denote families:
 * 0000xxxx == Any    = 0
 * 0001xxxx == Break  = 16
 * 0010xxxx == Breakx = 32
 * 0011xxxx == NotAny = 48
 * 0100xxxx == NSpan  = 64
 * 0101xxxx == Span   = 80
 * 0110xxxx == Len    = 96
 * 0111xxxx == RPos   = 112
 * 1000xxxx == Pos    = 128
 * 1001xxxx == RTab   = 144
 * 1010xxxx == Tab    = 160
 * 1011xxxx == Arbno  = 176
 * 1100xxxx == String = 192
 *
 * According to this scheme, 207 or so is the highest assigned family-based
 * numbers. Numbers that are not part of a family are either a multiple of
 * 16 (+ 1) or else 208+.
 */
#ifdef PatternType
#define   PC_Arb_Y     208
#define   PC_Assign    209
#define   PC_Bal       210
#define   PC_BreakX_X   43
#define   PC_Abort     211
#define   PC_EOP       212
#define   PC_Fail      213
#define   PC_Fence     214
#define   PC_Fence_X   215
#define   PC_Fence_Y   216
#define   PC_R_Enter   217
#define   PC_R_Remove  218
#define   PC_R_Restore 219
#define   PC_Rest      220
#define   PC_Succeed   221
#define   PC_Unanchored 222

#define   PC_Alt        223
#define   PC_Arb_X      224
#define   PC_Arbno_S    187
#define   PC_Arbno_X    188

#define   PC_Rpat       225

#define   PC_Pred_Func  226

#define   PC_Assign_Imm  227
#define   PC_Assign_OnM  228

#define   PC_Any_VP        2
#define   PC_Break_VP     18
#define   PC_BreakX_VP    34
#define   PC_NotAny_VP    50
#define   PC_NSpan_VP     66
#define   PC_Span_VP      82
#define   PC_String_VP   194

#define   PC_Write_Imm   229
#define   PC_Write_OnM   230

#define   PC_Null        231
#define   PC_String      192

#define   PC_Setcur      232

#define   PC_Any_CH        3
#define   PC_Break_CH     19
#define   PC_BreakX_CH    35
#define   PC_Char        233
#define   PC_NotAny_CH    51
#define   PC_NSpan_CH     67
#define   PC_Span_CH      83

#define   PC_Any_CS        4
#define   PC_Break_CS     20
#define   PC_BreakX_CS    36
#define   PC_NotAny_CS    52
#define   PC_NSpan_CS     68
#define   PC_Span_CS      84

#define   PC_Arbno_Y     189

#define   PC_Len_Nat     101
#define   PC_Pos_Nat     133
#define   PC_RPos_Nat    117
#define   PC_RTab_Nat    149
#define   PC_Tab_Nat     165

#define   PC_Pos_NF      134
#define   PC_Len_NF      102
#define   PC_RPos_NF     118
#define   PC_RTab_NF     150
#define   PC_Tab_NF      166

#define   PC_Pos_NP      135
#define   PC_Len_NP      103
#define   PC_RPos_NP     119
#define   PC_RTab_NP     151
#define   PC_Tab_NP      167

#define   PC_Any_VF      8
#define   PC_Break_VF    24
#define   PC_BreakX_VF   40
#define   PC_NotAny_VF   56
#define   PC_NSpan_VF    72
#define   PC_Span_VF     88
#define   PC_String_VF  200
#define   PC_Func       234

   /*
    * These constants are added because of the way "unevaluated expressions"
    * are handled in unicon During the pattern construction process pattern
    * elements containing unevaluated expressions contain their string
    * representations. In the procedure pattern_match these string names are
    * resolved to the corresponding variable references.
    */

#define   PC_UNEVALVAR  235

#define   PC_STRINGFUNCCALL 236
#define   PC_BOOLFUNCCALL  237
#define   PC_STRINGMETHODCALL 238
#define   PC_BOOLMETHODCALL  239
#define   PC_String_MF  201
#define   PC_Pred_MF    240 /* suffix but no family? */

#define   PC_Pos_NMF    138
#define   PC_Len_NMF    106
#define   PC_RPos_NMF   122
#define   PC_RTab_NMF   154
#define   PC_Tab_NMF    170
#define   PC_Any_MF     9
#define   PC_Break_MF   25
#define   PC_BreakX_MF  41
#define   PC_NotAny_MF  57
#define   PC_NSpan_MF   73
#define   PC_Span_MF    89

#define   PC_Concat     241

/*
 * Symbols associated with providing detailed pattern images.
 */

/* pattern function and operator names. subscripts into patimg(). */
#define   PF_Any        0
#define   PF_Break      1
#define   PF_BreakX     2
#define   PF_NotAny     3
#define   PF_NSpan      4
#define   PF_Span       5
#define   PF_Len        6
#define   PF_RPos       7
#define   PF_Pos        8
#define   PF_RTab       9
#define   PF_Tab        10
#define   PF_Arbno      11
/* pattern image codes. parameters e.g. to get_patimage(). */
#define   PI_EMPTY      12
#define   PI_FPAREN     13
#define   PI_BPAREN     14
#define   PI_FBRACE     15
#define   PI_BBRACE     16
#define   PI_BQUOTE     17
#define   PI_QUOTE      18
#define   PI_SQUOTE     19
#define   PI_COMMA      20
#define   PI_PERIOD     21
#define   PI_CONCAT     22
#define   PI_ALT        23
#define   PI_ONM        24
#define   PI_IMM        25
#define   PI_SETCUR     26
#define   NUM_PATIMGS   27

/* pattern argument-type codes. argument #2 to arg_image(). */
#define   PT_MF  25
#define   PT_VF 26
#define   PT_VP 27
#define   PT_EVAL 28

#endif                                  /* PatternType */

#define INIT_ADDRINFO_HINTS(_hints, _fam, _sock, _flags, _proto)        \
      do {                                                              \
        memset(&_hints, 0, sizeof(struct addrinfo));                    \
        /* IPv4 or IPv6 or IP */                                        \
        _hints.ai_family = _fam;                                        \
        /* 0=>Any socket */                                             \
        _hints.ai_socktype = _sock;                                     \
        /* wildcard IP +  canonical name */                             \
        _hints.ai_flags = _flags;                                       \
        /* 0=>Any protocol */                                           \
        _hints.ai_protocol = _proto;                                    \
        _hints.ai_canonname = NULL;                                     \
        _hints.ai_addr = NULL;                                          \
        _hints.ai_next = NULL;                                          \
      } while (0)

#define SAFE_strncpy(_dst, _src, _bufsize)      \
      do {                                      \
        strncpy(_dst, _src, _bufsize - 1);      \
        _dst[_bufsize - 1] = '0';               \
      } while (0)

/*
 * Macro definition used by pollevent() to avoid magic numbers
 */
#define POLL_INTERVAL 400
