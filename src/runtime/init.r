/*
 * File: init.r
 * Initialization, termination, and such.
 * Contents: readhdr, init/icon_init, envset, env_err, env_int,
 *  fpe_trap, inttrap, segvtrap, error, syserr, c_exit, err,
 *  fatalerr, pstrnmcmp, datainit, [loadicode]
 */

#if !COMPILER
#include "../h/header.h"

static FILE * readhdr	(char *name, struct header *hdr);
#endif					/* !COMPILER */

#if SCCX_MX
extern  int         thisIsIconx;
extern  char        settingsname[];
extern  setint_t    sizevar;
#endif  /* SCCX_MX */

/*
 * Prototypes.
 */

static void	env_err		(char *msg, char *name, char *val);
FILE		*pathOpen       (char *fname, char *mode);

/*
 * The following code is operating-system dependent [@init.01].  Declarations
 *   that are system-dependent.
 */

#if PORT
   /* probably needs something more */
Deliberate Syntax Error
#endif					/* PORT */

#if AMIGA
int chkbreak;				/* if nonzero, check for ^C */
  /* These override environment variables if set from ToolTypes. */
uword WBstrsize = 0;
uword WBblksize = 0;
uword WBmstksize = 0;
#endif					/* AMIGA */

#if MSDOS
#if HIGHC_386
int _fmode = 0;				/* force CR-LF on std.. files */
#endif					/* HIGHC_386 */
#endif					/* MSDOS */

#if ARM || MACINTOSH || MVS || VM || UNIX || VMS
   /* nothing needed */
#endif					/* ARM || MACINTOSH ... */

/*
 * End of operating-system specific code.
 */

char *prog_name;			/* name of icode file */

#if !COMPILER
#passthru #define OpDef(p,n,s,u) int Cat(O,p) (dptr cargp);
#passthru #include "../h/odefs.h"
#passthru #undef OpDef

/*
 * External declarations for operator blocks.
 */

#passthru #define OpDef(f,nargs,sname,underef)\
	{\
	T_Proc,\
	Vsizeof(struct b_proc),\
	Cat(O,f),\
	nargs,\
	-1,\
	underef,\
	0,\
	{{sizeof(sname)-1,sname}}},
#passthru static B_IProc(2) init_op_tbl[] = {
#passthru #include "../h/odefs.h"
#passthru   };
#undef OpDef
#endif					/* !COMPILER */

/*
 * A number of important variables follow.
 */

int line_info;				/* flag: line information is available */
int versioncheck_only;			/* flag: check version and exit */
char *file_name = NULL;			/* source file for current execution point */
#ifndef MultiThread
int line_num = 0;			/* line number for current execution point */
#endif					/* MultiThread */
struct b_proc *op_tbl;			/* operators available for string invocation */

extern struct errtab errtab[];		/* error numbers and messages */

word mstksize = MStackSize;		/* initial size of main stack */
word stksize = StackSize;		/* co-expression stack size */

#ifndef MultiThread
int k_level = 0;			/* &level */
struct descrip k_main;			/* &main */
#endif					/* MultiThread */

int set_up = 0;				/* set-up switch */
char *currend = NULL;			/* current end of memory region */
word qualsize = QualLstSize;		/* size of quallist for fixed regions */

word memcushion = RegionCushion;	/* memory region cushion factor */
word memgrowth = RegionGrowth;		/* memory region growth factor */

uword stattotal = 0;			/* cumulative total static allocation */
#ifndef MultiThread
uword strtotal = 0;			/* cumulative total string allocation */
uword blktotal = 0;			/* cumulative total block allocation */
#endif					/* MultiThread */

int dodump;				/* if nonzero, core dump on error */
int noerrbuf;				/* if nonzero, do not buffer stderr */

struct descrip maps2;			/* second cached argument of map */
struct descrip maps3;			/* third cached argument of map */

#ifndef MultiThread
struct descrip k_current;		/* current expression stack pointer */
int k_errornumber = 0;			/* &errornumber */
char *k_errortext = "";			/* &errortext */
struct descrip k_errorvalue;		/* &errorvalue */
int have_errval = 0;			/* &errorvalue has legal value */
int t_errornumber = 0;			/* tentative k_errornumber value */
int t_have_val = 0;			/* tentative have_errval flag */
struct descrip t_errorvalue;		/* tentative k_errorvalue value */
#endif					/* MultiThread */

struct b_coexpr *stklist;	/* base of co-expression block list */

#ifndef Concurrent /* or never? */
struct tend_desc *tend = NULL;  /* chain of tended descriptors */
#endif					/* Concurrent */

#ifdef Concurrent
pthread_mutex_t static_mutexes[NUM_STATIC_MUTEXES];
#endif					/* Concurrent */

struct region rootstring, rootblock;

#ifndef MultiThread
dptr glbl_argp = NULL;		/* argument pointer */
dptr globals, eglobals;			/* pointer to global variables */
dptr gnames, egnames;			/* pointer to global variable names */
dptr estatics;				/* pointer to end of static variables */

struct region *curstring, *curblock;
#endif					/* MultiThread */

#if COMPILER
struct p_frame *pfp = NULL;	/* procedure frame pointer */

int debug_info;				/* flag: is debugging information available */
int err_conv;				/* flag: is error conversion supported */
int largeints;				/* flag: large integers are supported */

struct b_coexpr *mainhead;		/* &main */

#else					/* COMPILER */

int debug_info=1;			/* flag: debugging information IS available */
int err_conv=1;				/* flag: error conversion IS supported */

int op_tbl_sz = (sizeof(init_op_tbl) / sizeof(struct b_proc));

#ifndef MaxHeader
#define MaxHeader MaxHdr
#endif					/* MaxHeader */

#ifdef OVLD
 int *OpTab;				/* pointer to op2fieldnum table */
#endif

#ifdef MultiThread
struct progstate *curpstate;		/* lastop accessed in program state */
struct progstate rootpstate;
#ifdef Concurrent
      struct tls_node *tlshead;
#ifdef HAVE_KEYWORD__THREAD
      #passthru __thread struct threadstate roottstate; 
      #passthru __thread struct threadstate *curtstate;
#endif					/* HAVE_KEYWORD__THREAD */
#else					/* Concurrent */
      struct threadstate roottstate; 
      struct threadstate *curtstate;
#endif					/* Concurrent */
#else					/* MultiThread */

struct b_coexpr *mainhead;		/* &main */

char *code;				/* interpreter code buffer */
char *ecode;				/* end of interpreter code buffer */
word *records;				/* pointer to record procedure blocks */

int *ftabp;				/* pointer to record/field table */
#ifdef FieldTableCompression
word ftabwidth;				/* field table entry width */
word foffwidth;				/* field offset entry width */
unsigned char *ftabcp, *focp;		/* pointers to record/field table */
unsigned short *ftabsp, *fosp;		/* pointers to record/field table */

int *fo;				/* field offset (row in field table) */
char *bm;				/* bitmap array of valid field bits */
#endif					/* FieldTableCompression */

dptr fnames, efnames;			/* pointer to field names */
dptr statics;				/* pointer to static variables */
char *strcons;				/* pointer to string constant table */
struct ipc_fname *filenms, *efilenms;	/* pointer to ipc/file name table */
struct ipc_line *ilines, *elines;	/* pointer to ipc/line number table */
#endif					/* MultiThread */

#ifdef TallyOpt
word tallybin[16];			/* counters for tallying */
int tallyopt = 0;			/* want tally results output? */
#endif					/* TallyOpt */

#ifdef ExecImages
int dumped = 0;				/* non-zero if reloaded from dump */
#endif					/* ExecImages */

#ifdef MultipleRuns
extern word coexp_ser;
extern word list_ser;
extern word set_ser;
extern word table_ser;
extern int first_time;
#endif					/* MultipleRuns */
#endif					/* COMPILER */

#if !COMPILER

int fdgets(int fd, char *buf, size_t count) 
{
  int i;
  char *temp=buf;

  for (i=0;i<count;i++) {
    if (read(fd,temp,1)==-1) {
      return -1;
    }
    if (*temp==EOF)  /* end of the file */
      break;
    if (*temp=='\n') { /* new line */
      i++;
      break;
    }
    temp++;
  }
  buf[i]='\0';
  return i;
}

int dgetc(int fd) {
  int rv;
  unsigned char c;
  rv = read(fd,&c,1);
  if (rv == -1)
    return -1;
  else if (rv == 0) return EOF;
  else {
    return c;
    }
}

/*
 * Find the sentinel string within an icode file.
 * Could replace this with a high powered string search.
 */
int superstr(char *needle, char *haystack, int n)
{
   int len = strlen(needle);
   int i;
   for(i=0; i<n-len; i++) {
      if (('\n' == haystack[i]) &&
	  (needle[0] == haystack[i+1]) && (needle[1] == haystack[i+2])) {
	 if ((strncmp(haystack+i+1,needle,len) == 0) &&
#if UNIX
	     (haystack[i+1+len] == '\n')
#else
	     (haystack[i+1+len] == '\015')
#endif
	     ) {
	    return i+1;
	    }
	 }
      }
   return -1;
}

char *filebuffer;	/* malloced copy of icode file */
char *precode;		/* pointer to start of code within filebuffer */

/*
 * Open the icode file and read the header.
 * Used by icon_init() as well as MultiThread's loadicode().
 * Note that if the icode is compressed, the FILE* returned may require gdzread().
 */
static FILE *readhdr(name,hdr)
char *name;
struct header *hdr;
   {
   int fdname = -1;
   int n;
   char tname[256];

#if MSDOS
   int thisIsAnExeFile = 0;
   char bytesThatBeginEveryExe[2] = {0,0};
   unsigned short originalExeBytesMod512, originalExePages;
   unsigned long originalExeBytes;
#endif					/* MSDOS */

   tname[0] = '\0';

   if (!name)
      error(name, "No interpreter file supplied");

   /*
    * Try adding the suffix if the file name doesn't end in it.
    */
   n = strlen(name);

#if MSDOS
   /* already has .exe extension */
   if (n >= 4 && !stricmp(".exe", name + n - 4)) {
      thisIsAnExeFile = 1;

      fdname = pathOpenHandle(name, ReadBinary);
      strcpy(tname, name);
         /*
          * ixhdr's code for calling iconx from an .exe passes iconx the
          * full path of the .exe, so using pathOpen() seems redundant &
          * potentially inefficient. However, pathOpen() first checks for a
          * complete path, & if one is present, doesn't search Path; & since
          * MS-DOS has a limited line length, it'd be possible for ixhdr
          * to check whether the full path will fit, & if not, use only the
          * name. The only price for this additional robustness would be
          * the time pathOpen() spends checking for a path, which is trivial.
          */
      }
   else {
#endif					/* MSDOS */

   if ((n <= 4) || (strcmp(IcodeSuffix, name + n - 4) != 0)) {
      if ((int)strlen(name) + 5 > 100)
	 error(name, "icode file name too long");
      strcpy(tname,name);
      strcat(tname,IcodeSuffix);

#if MSDOS
      fdname = pathOpenHandle(tname,ReadBinary);	/* try to find path */
#else					/* MSDOS */
      fdname = open(tname,O_RDONLY);
#endif					/* MSDOS */

#if NT
      /*
       * tried appending .exe, now try .bat or .cmd
       */
      if (fdname == -1) {
	 strcpy(tname,name);
	 if (strcmp(".bat", name + n - 4))
	    strcat(tname,".bat");
	 fdname = pathOpenHandle(tname, ReadBinary);
	 if (fdname == -1) {
	    strcpy(tname,name);
	    if (strcmp(".cmd", name + n - 4))
	       strcat(tname,".cmd");
	    fdname = pathOpenHandle(tname, ReadBinary);
            }
	 }
#endif					/* NT */

      }

   if (fdname == -1)			/* try the name as given */

#if MSDOS
      fdname = pathOpenHandle(name, ReadBinary);
#else					/* MSDOS */
      fdname = open(name, O_RDONLY);
#endif					/* MSDOS */

#if MSDOS
      } /* end if (n >= 4 && !stricmp(".exe", name + n - 4)) */
#endif					/* MSDOS */

   if (fdname == -1)
      return NULL;

   {
   static char errmsg[] = "can't read interpreter file header";

#ifdef Header

#ifdef ShellHeader
   char buf[200];
   char pathbuf[512];
   int offset;

#if NT
   struct _stat sbuf;
#define lstat _stat
#else					/* NT */
   struct stat sbuf;
#endif					/* NT */
   int t1 = millisec(), rv;
   FILE *ftmp;

   if ((rv = pathFind(tname, pathbuf, 150)) == 0) error(name, errmsg);
   if (lstat(pathbuf, &sbuf) != 0) error(name, errmsg);
   filebuffer = malloc(sbuf.st_size + 2);
   ftmp = fopen(pathbuf,"rb");
   if (ftmp == NULL) error(name, errmsg);
   if (fread(filebuffer, 1, sbuf.st_size, ftmp) <= 0) error(name, errmsg);
   fclose(ftmp);
#if UNIX
   offset = superstr("[executable Icon binary follows]",filebuffer,sbuf.st_size);
#else
   offset = superstr("rem [executable Icon binary follows]",filebuffer,sbuf.st_size);
#endif
   if (offset == -1) {
      error(name, errmsg);
      }

#if UNIX
   if (strncmp(filebuffer+offset, "[executable Icon binary follows]", 32)) {
#else
   if (strncmp(filebuffer+offset, "rem [executable Icon binary follows]", 36)) {
#endif
      error(name, "internal confusion over sentinel string");
      }
#if UNIX
   offset += 33; /* skip over string + ^j */
#else
   offset += 38; /* skip over string + ^m + ^j */
#endif

   if (lseek(fdname, offset, SEEK_SET) == (off_t)-1) error(name, errmsg);
   while ((n = dgetc(fdname)) != EOF && n != '\f') {	/* read thru \f\n\0 */
      if ((n != ' ') && (n != '\n') && (n != '\015')) {
	 error(name, "bad file format (unexpected chars) after sentinel string");
	 }
      offset++;
      }
   if ((n=dgetc(fdname)) != '\n') {
      error(name, "bad file format (missing newline) after sentinel string");
      }
   if ((n=dgetc(fdname)) != '\0') {
      error(name, "bad file format (missing NUL) after sentinel string");
      }
   offset += 3; /* \f\n\0 */
   precode = filebuffer + offset + sizeof(*hdr);

#else					/* ShellHeader */
#if HAVE_LIBZ
deliberate syntax errror
#endif					/* HAVE_LIBZ */
   if (fseek(fname, (long)MaxHeader, 0) == -1)
      error(name, errmsg);
#endif					/* ShellHeader */
#endif					/* Header */

   if (read(fdname,(char *)hdr, sizeof(*hdr)) != sizeof(*hdr))
      error(name, errmsg);
   }

   /*
    * Make sure the version number of the icode matches the interpreter version.
    * The string must equal IVersion or IVersion || "Z".
    */
   if (strncmp((char *)hdr->config, IVersion, strlen(IVersion)) ||
       ((((char *)hdr->config)[strlen(IVersion)]) &&
	strcmp(((char *)hdr->config) + strlen(IVersion), "Z"))  ) {
      fprintf(stderr,"icode version mismatch in %s\n", name);
      fprintf(stderr,"\ticode version: %s\n",(char *)hdr->config);
      fprintf(stderr,"\texpected version: %s\n",IVersion);
      close(fdname);
      if (versioncheck_only) exit(-1);
      error(name, "cannot run");
      }

   /*
    * Stop if we were only asked to do a version check.
    * All this code should modified to handle icode load() failure gracefully.
    */
   if (versioncheck_only) exit(0);

   /*
    * if version says to decompress, call gzdopen and read interpretable code
    * using gzread, else... call fdopen.
    */

#if HAVE_LIBZ
   if ((strchr((char *)(hdr->config), 'Z'))!=NULL) { /* to decompress */
      return gzdopen(fdname,"rb");
      }
   else
#endif					/* HAVE_LIBZ  */
      return fdopen(fdname,"rb");
   }
#endif					/* !COMPILER */


/*
 * init/icon_init - initialize memory and prepare for Icon execution.
 */
#if !COMPILER
   struct header hdr;
#endif					/* !COMPILER */

#ifdef Concurrent

void howmanyblock()
{
  int i=0;
  struct region *rp;
  
  printf("here is what I have:\n");
  rp = curpstate->stringregion;
  while (rp){ i++;   rp = rp->Gnext; }
  rp = curpstate->stringregion->Gprev;
  while (rp){ i++;   rp = rp->Gprev; }
  printf(" Global string= %d\n", i);

  rp = curpstate->stringregion;
  i=0;
  while (rp){ i++; rp = rp->next;}
  rp = curpstate->stringregion->prev;
  while (rp){ i++;   rp = rp->prev; }

  printf(" local string= %d\n", i);

  rp = curpstate->blockregion;
  i=0;
  while (rp){i++; rp = rp->Gnext;}
  rp = curpstate->blockregion->Gprev;
  while (rp){ i++;   rp = rp->Gprev; }

  printf(" Global block= %d\n", i);

  rp = curpstate->blockregion;
  i=0;
  while (rp){i++; rp = rp->next; }
  rp = curpstate->blockregion->prev;
  while (rp){ i++;   rp = rp->prev; }

  printf(" local block= %d\n", i);
}

/*
 * Initialize separate heaps for (concurrent) threads.
 * At present, PthreadCoswitch probably uses this for Pthread coexpressions.
 */
void init_threadheap(struct threadstate *ts, word blksiz, word strsiz)
{ 
   /*
    * This static doesn't cause a race condition because initial main
    * co-expression will be initialized before any other thread is ever
    * created.
    */
   static int first=1;
   struct region *rp;
   word size;

   /*
    * The main thread just points to the initial regions.
    */
   if (first){
      ts->Curstring = curstring;
      ts->Curblock = curblock;
      first = 0;
      return;
      }

   /*
    *  new string and block region should be allocated
    */

   size = 1024*1024*1;
   if (size < curpstate->stringregion->size / 4)
     size = curpstate->stringregion->size / 4;

   if ((rp = newregion(size, size)) != 0) {
      MUTEX_LOCKID(MTX_STRHEAP);
      rp->prev = curstring;
      rp->next = NULL;
      curstring->next = rp;
      rp->Gnext = curstring;
      rp->Gprev = curstring->Gprev;
      if (curstring->Gprev) curstring->Gprev->Gnext = rp;
      curstring->Gprev = rp;
      curstring = rp;
      MUTEX_UNLOCKID(MTX_STRHEAP);
      ts->Curstring = rp;
      }
    else
      syserr(" init_threadheap: insufficient memory");

   size = 1024*1024*4;
   if (size < curpstate->blockregion->size / 4)
      size = curpstate->blockregion->size / 4;


   if ((rp = newregion(size, size)) != 0) {
      MUTEX_LOCKID(MTX_BLKHEAP);
      rp->prev = curblock;
      rp->next = NULL;
      curblock->next = rp;
      rp->Gnext = curblock;
      rp->Gprev = curblock->Gprev;
      if (curblock->Gprev) curblock->Gprev->Gnext = rp;
      curblock->Gprev = rp;
      curblock = rp;

      MUTEX_UNLOCKID(MTX_BLKHEAP);
      ts->Curblock = rp;
      }
    else
      syserr(" init_threadheap: insufficient memory");
}
#endif 					/* Concurrent */

void init_threadstate(struct threadstate *ts)
{

#ifdef Concurrent
   ts->tid = pthread_self();
   ts->Pollctr=0;
   
   /* used in fmath.r, log() */
   ts->Lastbase=0.0;

#ifdef PosixFns
   ts->Nsaved=0;
#endif					/* PosixFns */
#endif					/* Concurrent */

   ts->Glbl_argp = NULL;

   MakeInt(1, &(ts->Kywd_pos));
   StrLen(ts->ksub) = 0;
   StrLoc(ts->ksub) = "";

   ts->Kywd_ran = zerodesc;
   IntVal(ts->Kywd_ran) = getrandom();
   ts->K_errornumber = 0;
   ts->K_level = 0;
   ts->T_errornumber = 0;
   ts->Have_errval = 0;
   ts->T_have_val = 0;
   ts->K_errortext = "";
   ts->K_errorvalue = nulldesc;
   ts->T_errorvalue = nulldesc;
#ifdef PosixFns
   ts->AmperErrno = zerodesc;
#endif					/* PosixFns */

#if !COMPILER
   ts->Lastop = 0;
   ts->Xargp = NULL;
   ts->Xnargs = 0;
   ts->Ipc.opnd = NULL;
   ts->Efp=NULL;		/* Expression frame pointer */
   ts->Gfp=NULL;		/* Generator frame pointer */
   ts->Pfp=NULL;	        /* procedure frame pointer */
   ts->Sp = NULL;		/* Stack pointer */
   ts->Ilevel=0;		/* Depth of recursion in interp() */

#ifndef StackCheck
   ts->Stack=NULL;		/* Interpreter stack */
   ts->Stackend=NULL; 		/* End of interpreter stack */
#endif					/* StackCheck */
#endif					/* !COMPILER */

   ts->Line_num = ts->Column = ts->Lastline = ts->Lastcol = 0;
   ts->Tend = NULL;

#ifdef Concurrent
   ts->Curstring = NULL;
   ts->Curblock = NULL;
   ts->stringtotal=0;
   ts->blocktotal=0;
#endif 					/* Concurrent */

}

#if COMPILER
void init(name, argcp, argv, trc_init)
char *name;
int *argcp;
char *argv[];
int trc_init;
#else					/* COMPILER */
void icon_init(name, argcp, argv)
char *name;
int *argcp;
char *argv[];
#endif					/* COMPILER */

   {
#if !COMPILER
   int fdname = -1;
   FILE *fname = 0;
   word cbread;
#endif					/* COMPILER */
   CURTSTATE();

   prog_name = name;			/* Set icode file name */

#if defined(HAVE_LIBPTHREAD) && !defined(SUN)
   pthread_rwlock_init(&__environ_lock, NULL);
#endif					/*HAVE_LIBPTHREAD && !SUN */

#if COMPILER
   curstring = &rootstring;
   curblock  = &rootblock;
   rootstring.size = MaxStrSpace;
   rootblock.size  = MaxAbrSize;
#else					/* COMPILER */

#ifdef MultiThread
   /*
    * initialize root pstate
    */
   curpstate = &rootpstate;
   
   init_sighandlers(curpstate);
   
   rootpstate.parent = rootpstate.next = NULL;
   rootpstate.parentdesc = nulldesc;
   rootpstate.eventmask= nulldesc;
   rootpstate.eventcount = zerodesc;
   rootpstate.valuemask = nulldesc;
   rootpstate.eventcode= nulldesc;
   rootpstate.eventval = nulldesc;
   rootpstate.eventsource = nulldesc;
   rootpstate.Kywd_err = zerodesc;

#if !defined(Concurrent) || defined(HAVE_KEYWORD__THREAD)
   rootpstate.tstate = &roottstate;
   curtstate = &roottstate;
#else					/* !Concurrent||HAVE_KEYWORD__THREAD */
   rootpstate.tstate = get_tstate();
#endif					/* !Concurrent||HAVE_KEYWORD__THREAD */
   init_threadstate(rootpstate.tstate);

   StrLen(rootpstate.Kywd_prog) = strlen(prog_name);
   StrLoc(rootpstate.Kywd_prog) = prog_name;

#ifdef Graphics
   rootpstate.AmperX = zerodesc;
   rootpstate.AmperY = zerodesc;
   rootpstate.AmperRow = zerodesc;
   rootpstate.AmperCol = zerodesc;
   rootpstate.AmperInterval = zerodesc;
   rootpstate.LastEventWin = nulldesc;
   rootpstate.Kywd_xwin[XKey_Window] = nulldesc;
#endif					/* Graphics */

   rootpstate.Coexp_ser = 2;
   rootpstate.List_ser  = 1;
   rootpstate.Set_ser   = 1;
   rootpstate.Table_ser = 1;
   rootpstate.Kywd_time_elsewhere = 0;
   rootpstate.Kywd_time_out = 0;
   rootpstate.stringregion = &rootstring;
   rootpstate.blockregion = &rootblock;

#ifdef Concurrent
   rootpstate.Public_stringregion = NULL;
   rootpstate.Public_blockregion = NULL;
#endif					/* Concurrent */

   rootpstate.Longest_dr=0;
   rootpstate.Dr_arrays=NULL;

#ifdef Arrays   
   rootpstate.Cprealarray = cprealarray_0;
   rootpstate.Cpintarray = cpintarray_0;
#endif					/* Arrays */   

   rootpstate.Cplist = cplist_0;
   rootpstate.Cpset = cpset_0;
   rootpstate.Cptable = cptable_0;
   rootpstate.EVstralc = EVStrAlc_0;
   rootpstate.Interp = interp_0;
   rootpstate.Cnvcset = cnv_cset_0;
#passthru #undef cnv_int
#passthru #undef cnv_real
#passthru #undef cnv_str
#passthru #undef alcfile
#passthru #undef alcreal
#passthru #undef alcstr
#passthru #undef alclist_raw
   rootpstate.Cnvint = cnv_int;
   rootpstate.Cnvreal = cnv_real;
   rootpstate.Cnvstr = cnv_str;
   rootpstate.Cnvtcset = cnv_tcset_0;
   rootpstate.Cnvtstr = cnv_tstr_0;
   rootpstate.Deref = deref_0;
   rootpstate.Alcbignum = alcbignum_0;
   rootpstate.Alccset = alccset_0;
   rootpstate.Alcfile = alcfile;
   rootpstate.Alchash = alchash_0;
   rootpstate.Alcsegment = alcsegment_0;
#ifdef PatternType
   rootpstate.Alcpattern = alcpattern_0;
   rootpstate.Alcpelem = alcpelem_0;
#endif					/* PatternType */
   rootpstate.Alclist_raw = alclist_raw;
   rootpstate.Alclist = alclist_0;
   rootpstate.Alclstb = alclstb_0;
   rootpstate.Alcreal = alcreal;
   rootpstate.Alcrecd = alcrecd_0;
   rootpstate.Alcrefresh = alcrefresh_0;
   rootpstate.Alcselem = alcselem_0;
   rootpstate.Alcstr = alcstr;
   rootpstate.Alcsubs = alcsubs_0;
   rootpstate.Alctelem = alctelem_0;
   rootpstate.Alctvtbl = alctvtbl_0;
   rootpstate.Deallocate = deallocate_0;
   rootpstate.Reserve = reserve_0;
   
#else					/* MultiThread */

   curstring = &rootstring;
   curblock  = &rootblock;
   init_sighandlers();
#endif					/* MultiThread */

   rootstring.size = MaxStrSpace;
   rootblock.size  = MaxAbrSize;

   /*
    * Set default string and block regions to 1% of physical memory.
    * Set the default interpreter stack size to (1%/4) of physical memory.
    */
   { unsigned long l, onepercent;
     if (l = physicalmemorysize()) {
	onepercent = l / 100;
	if (rootstring.size < onepercent) rootstring.size = onepercent;
	if (rootblock.size < onepercent) rootblock.size = onepercent;
	if (mstksize < (onepercent / 4) / WordSize) {
	   mstksize = (onepercent / 4) / WordSize;
	   }
	if (stksize < (onepercent / 100) / WordSize) {
	   stksize = (onepercent / 100) / WordSize;
	   }
	}
   }

#endif					/* COMPILER */

#if !COMPILER
   op_tbl = (struct b_proc*)init_op_tbl;
#endif					/* !COMPILER */

#ifdef Double
   if (sizeof(struct size_dbl) != sizeof(double))
      syserr("Icon configuration does not handle double alignment");
#endif					/* Double */

   /*
    * Catch floating-point traps and memory faults.
    */

/*
 * The following code is operating-system dependent [@init.02].  Set traps.
 */

#if PORT
   /* probably needs something */
Deliberate Syntax Error
#endif					/* PORT */

#if ARM
   signal(SIGFPE, SigFncCast fpetrap);
   signal(SIGSEGV, SigFncCast segvtrap);
#endif					/* ARM */

#if MACINTOSH
#if MPW
   {
      void MacInit(void);
      void SetFloatTrap(void (*fpetrap)());
      void fpetrap();

      MacInit();
      SetFloatTrap(fpetrap);
   }
#endif					/* MPW */
#endif					/* MACINTOSH */

#if MSDOS
#if MICROSOFT || TURBO || ZTC_386 || SCCX_MX
   signal(SIGFPE, SigFncCast fpetrap);
#endif					/* MICROSOFT || TURBO || ZTC_386 || SCCX_MX */
#endif					/* MSDOS */

#if UNIX || VMS
   signal(SIGSEGV, SigFncCast segvtrap);
   signal(SIGFPE, SigFncCast fpetrap);
#endif					/* UNIX || VMS */

/*
 * End of operating-system specific code.
 */

#if !COMPILER
#ifdef ExecImages
   /*
    * If reloading from a dumped out executable, skip most of init and
    *  just set up the buffer for stderr and do the timing initializations.
    */
   if (dumped)
      goto btinit;
#endif					/* ExecImages */
#endif					/* COMPILER */

   /*
    * Initialize data that can't be initialized statically.
    */

   datainit();

#if COMPILER
   IntVal(kywd_trc) = trc_init;
#endif					/* COMPILER */

#if !COMPILER
   fname = readhdr(name,&hdr);
   if (fname == NULL) {
      error(name, "cannot open interpreter file");
      }

   MakeInt(hdr.trace, &(kywd_trc));

#endif					/* COMPILER */

#ifdef Concurrent
   init_threadheap(curtstate, rootblock.size, rootstring.size);
#endif					/* Concurrent */

   /*
    * Examine the environment and make appropriate settings.    [[I?]]
    */
   envset();

   /*
    * Convert stack sizes from words to bytes.
    */

   stksize *= WordSize;
   mstksize *= WordSize;

   /*
    * Allocate memory for various regions.
    */
#if COMPILER
   initalloc();
#else					/* COMPILER */
#ifdef MultiThread
   initalloc(hdr.hsize,&rootpstate);
#else					/* MultiThread */
   initalloc(hdr.hsize);
#endif					/* MultiThread */
#endif					/* COMPILER */

#ifdef Concurrent_REMOVETHIS
   init_threadheap(curtstate);
#endif					/* Concurrent */

#if !COMPILER
   /*
    * Establish pointers to icode data regions.		[[I?]]
    */
   ecode = code + hdr.Records;
#ifdef OVLD
    OpTab = (int *)(code + hdr.OpTab);
#endif
   records = (word *)ecode;
   ftabp = (int *)(code + hdr.Ftab);
#ifdef FieldTableCompression
   fo = (int *)(code + hdr.Fo);
   focp = (unsigned char *)(fo);
   fosp = (unsigned short *)(fo);
   if (hdr.FoffWidth == 1) {
      bm = (char *)(focp + hdr.Nfields);
      }
   else if (hdr.FoffWidth == 2) {
      bm = (char *)(fosp + hdr.Nfields);
      }
   else
      bm = (char *)(fo + hdr.Nfields);

   ftabwidth = hdr.FtabWidth;
   foffwidth = hdr.FoffWidth;
   ftabcp = (unsigned char *)(code + hdr.Ftab);
   ftabsp = (unsigned short *)(code + hdr.Ftab);
#endif					/* FieldTableCompression */
   fnames = (dptr)(code + hdr.Fnames);
   globals = efnames = (dptr)(code + hdr.Globals);
   gnames = eglobals = (dptr)(code + hdr.Gnames);
   statics = egnames = (dptr)(code + hdr.Statics);
   estatics = (dptr)(code + hdr.Filenms);
   filenms = (struct ipc_fname *)estatics;
   efilenms = (struct ipc_fname *)(code + hdr.linenums);
   ilines = (struct ipc_line *)efilenms;
   elines = (struct ipc_line *)(code + hdr.Strcons);
   strcons = (char *)elines;
   n_globals = eglobals - globals;
   n_statics = estatics - statics;
#endif					/* COMPILER */

   /*
    * Allocate stack and initialize &main.
    */

#if COMPILER
   mainhead = (struct b_coexpr *)malloc((msize)sizeof(struct b_coexpr));
#else					/* COMPILER */
#ifdef StackCheck
   mainhead = (struct b_coexpr *)malloc((msize)mstksize);
#else					/* StackCheck */
   stack = (word *)malloc((msize)mstksize);
   mainhead = (struct b_coexpr *)stack;
#endif					/* StackCheck */
#endif					/* COMPILER */

   if (mainhead == NULL)
#if COMPILER
      err_msg(305, NULL);
#else					/* COMPILER */
      fatalerr(303, NULL);
#endif					/* COMPILER */

   mainhead->title = T_Coexpr;
   mainhead->size = 1;			/* pretend main() does an activation */
   mainhead->id = 1;
   mainhead->nextstk = NULL;
   mainhead->es_tend = NULL;
   mainhead->tvalloc = NULL;
   mainhead->freshblk = nulldesc;	/* &main has no refresh block. */
   mainhead->tvalloc = NULL;
#ifdef StackCheck
   mainhead->es_stack = (word *)(mainhead+1);
#endif					/* StackCheck */

					/*  This really is a bug. */
#ifdef MultiThread
   mainhead->program = &rootpstate;
#endif					/* MultiThread */
#if COMPILER
   mainhead->file_name = "";
   mainhead->line_num = 0;
#endif					/* COMPILER */

#ifdef CoExpr
   Protect(mainhead->es_actstk = alcactiv(), fatalerr(0,NULL));
   pushact(mainhead, mainhead);
#endif					/* CoExpr */

   /*
    * Point &main at the co-expression block for the main procedure and set
    *  k_current, the pointer to the current co-expression, to &main.
    */
   k_main.dword = D_Coexpr;
   BlkLoc(k_main) = (union block *) mainhead;
   k_current = k_main;

   /**/
#ifdef Concurrent
   thread_call=0;		/* The thread who requested a GC */
   NARthreads=1;	/* Number of Async Running threads*/
#ifdef AAAMSWindows
   ptw32_processInitialize();
#endif  				/* MSWindows */
#endif					/* Concurrent */
   

#ifdef PthreadCoswitch
/*
 * Allocate a struct context for the main co-expression.
 */
{
   cstate ncs = (cstate) (mainhead->cstate);
   context *ctx;
   ctx = ncs[1] = alloc(sizeof (struct context));
   makesem(ctx);
   ctx->c = mainhead;
   ctx->thread = pthread_self();
   ctx->alive = 1;
#ifdef Concurrent
   tlshead = (struct tls_node *)malloc(sizeof(struct tls_node));
   if (tlshead==NULL)
      fatalerr(305, NULL);
   /* 
    * This is the first node on the chain. It will be always the first.
    * New nodes will be added to the end of the chain, setting tlshead->prev
    * to point to the last node will make it easy to add at the end. The chain 
    * is circular in one direction, backward, but not forward.
    */
   tlshead->prev = tlshead; 
   tlshead->next = NULL;
   tlshead->ctx = ctx;
   tlshead->tstate = curtstate;
#endif					/* Concurrent */
}
#endif					/* PthreadCoswitch */

#if !COMPILER
   /*
    * Read the interpretable code and data into memory.
    */
   if ((strchr((char *)(hdr.config), 'Z'))!=NULL) { /* to decompress */
#if HAVE_LIBZ
      if ((cbread = gzlongread(code, sizeof(char), (long)hdr.hsize, fname)) !=
	   hdr.hsize) {
	 fprintf(stderr,"Tried to read %ld bytes of code, got %ld\n",
		(long)hdr.hsize,(long)cbread);
	 error(name, "bad icode file");
	 }
      gzclose(fname);
#else					/* HAVE_LIBZ */
      error(name, "this VM can't read compressed icode");
#endif					/* HAVE_LIBZ */
      }
   /* Don't need to decompress */
   else  {
      memmove(code, precode, hdr.hsize);
      free(filebuffer);
      fclose(fname);
      }
#endif					/* !COMPILER */

   /*
    * Initialize the event monitoring system, if configured.
    */

#ifdef MultiThread
   EVInit();
#endif					/* MultiThread */

/* this is the end of yonggang's compressed icode else-branch ! */

   /*
    * Check command line for redirected standard I/O.
    *  Assign a channel to the terminal if KeyboardFncs are enabled on VMS.
    */

#if VMS
   redirect(argcp, argv, 0);
#ifdef KeyboardFncs
   assign_channel_to_terminal();
#endif					/* KeyboardFncs */
#endif					/* VMS */

#if !COMPILER
   /*
    * Resolve references from icode to run-time system.
    */
#ifdef MultiThread
   resolve(NULL);
#else					/* MultiThread */
   resolve();
#endif					/* MultiThread */
#endif					/* COMPILER */

#if !COMPILER
#ifdef ExecImages
btinit:
#endif					/* ExecImages */
#endif					/* COMPILER */

/*
 * The following code is operating-system dependent [@init.03].  Allocate and
 *  assign a buffer to stderr if possible.
 */

#if PORT
   /* probably nothing */
Deliberate Syntax Error
#endif					/* PORT */

#if ARM || MACINTOSH || UNIX || OS2 || VMS
   if (noerrbuf)
      setbuf(stderr, NULL);
   else {
      char *buf;

      buf = (char *)malloc((msize)BUFSIZ);
      if (buf == NULL)
	 fatalerr(305, NULL);
      setbuf(stderr, buf);
      }
#endif					/* ARM || MACINTOSH ... */

#if MSDOS
#if !HIGHC_386
   if (noerrbuf)
      setbuf(stderr, NULL);
   else {
#ifndef MSWindows
      char *buf = (char *)malloc((msize)BUFSIZ);
      if (buf == NULL)
	 fatalerr(305, NULL);
      setbuf(stderr, buf);
#endif					/* MSWindows */
      }
#endif					/* !HIGHC_386 */
#endif					/* MSDOS */

/*
 * End of operating-system specific code.
 */

   /*
    * Start timing execution.
    */
   millisec();
   }

/*
 * Service routines related to getting things started.
 */

/*
 * Check for environment variables that Icon uses and set system
 *  values as is appropriate.  This is probably done once and pre-threads,
 *  but go ahead and use getenv_r() to allow for reinitialization.
 */
void envset()
   {
   char *p, sbuf[MaxCvtLen+1];
   CURTSTATE();

   if (getenv_r("NOERRBUF", sbuf, MaxCvtLen) == 0)
      noerrbuf++;
   env_int(TRACE, &k_trace, 0, (uword)0);
   env_int(COEXPSIZE, &stksize, 1, (uword)MaxUnsigned);
   env_int(STRSIZE, &ssize, 1, (uword)MaxBlock);
   env_int(HEAPSIZE, &abrsize, 1, (uword)MaxBlock);
#ifndef BSD_4_4_LITE
   env_int(BLOCKSIZE, &abrsize, 1, (uword)MaxBlock);    /* synonym */
#endif					/* BSD_4_4_LITE */
   env_int(BLKSIZE, &abrsize, 1, (uword)MaxBlock);      /* synonym */
   env_int(MSTKSIZE, &mstksize, 1, (uword)MaxUnsigned);
   env_int(QLSIZE, &qualsize, 1, (uword)MaxBlock);
   env_int("IXCUSHION", &memcushion, 1, (uword)100);	/* max 100 % */
   env_int("IXGROWTH", &memgrowth, 1, (uword)10000);	/* max 100x growth */

/*
 * The following code is operating-system dependent [@init.04].  Check any
 *  system-dependent environment variables.
 */

#if PORT
   /* nothing to do */
Deliberate Syntax Error
#endif					/* PORT */

#if ARM || MACINTOSH || MSDOS || MVS || OS2 || UNIX || VM || VMS
   /* nothing to do */
#endif					/* ARM || ... */

/*
 * End of operating-system specific code.
 */

   if ((getenv_r(ICONCORE, sbuf, MaxCvtLen) == 0) && *p != '\0') {

/*
 * The following code is operating-system dependent [@init.05].  Set trap to
 *  give dump on abnormal termination if ICONCORE is set.
 */

#if PORT
   /* can't handle */
Deliberate Syntax Error
#endif					/* PORT */

#if AMIGA || MACINTOSH
   /* can't handle */
#endif					/* AMIGA || ... */

#if ARM || OS2
      signal(SIGSEGV, SIG_DFL);
      signal(SIGFPE, SIG_DFL);
#endif					/* ARM || OS2 */

#if MSDOS
#if TURBO || BORLAND_386
      signal(SIGFPE, SIG_DFL);
#endif					/* TURBO || BORLAND_386 */
#endif					/* MSDOS */

#if MVS || VM
      /* Really nothing to do. */
#endif					/* MVS || VM */

#if UNIX || VMS
      signal(SIGSEGV, SIG_DFL);
#endif					/* UNIX || VMS */

/*
 * End of operating-system specific code.
 */
      dodump++;
      }
   }

/*
 * env_err - print an error mesage about the value of an environment
 *  variable.
 */
static void env_err(msg, name, val)
char *msg;
char *name;
char *val;
{
   char msg_buf[100];

   strncpy(msg_buf, msg, 99);
   strncat(msg_buf, ": ", 99 - (int)strlen(msg_buf));
   strncat(msg_buf, name, 99 - (int)strlen(msg_buf));
   strncat(msg_buf, "=", 99 - (int)strlen(msg_buf));
   strncat(msg_buf, val, 99 - (int)strlen(msg_buf));
   error("", msg_buf);
}

/*
 * env_int - get the value of an integer-valued environment variable.
 */
void env_int(name, variable, non_neg, limit)
char *name;
word *variable;
int non_neg;
uword limit;
{
   char *value, *s, sbuf[MaxCvtLen+1];
   register uword n = 0;
   register uword d;
   int sign = 1;

   if ((getenv_r(name, sbuf, MaxCvtLen) != 0) || (*sbuf == '\0'))
      return;

   value = s = sbuf;
   if (*s == '-') {
      if (non_neg)
	 env_err("environment variable out of range", name, value);
      sign = -1;
      ++s;
      }
   else if (*s == '+')
      ++s;
   while (isdigit(*s)) {
      d = *s++ - '0';
      /*
       * See if 10 * n + d > limit, but do it so there can be no overflow.
       */
      if ((d > (uword)(limit / 10 - n) * 10 + limit % 10) && (limit > 0))
	 env_err("environment variable out of range", name, value);
      n = n * 10 + d;
      }
   if (*s != '\0')
      env_err("environment variable not numeric", name, value);
   *variable = sign * n;
}

/*
 * Termination routines.
 */

/*
 * Produce run-time error 204 on floating-point traps.
 */

void fpetrap()
   {
   fatalerr(204, NULL);
   }

/*
 * Produce run-time error 320 on ^C interrupts. Not used at present,
 *  since malfunction may occur during traceback.
 */
void inttrap()
   {
   fatalerr(320, NULL);
   }

/*
 * Produce run-time error 302 on segmentation faults.
 */
void segvtrap()
   {
   static int n = 0;

   MUTEX_LOCKID(MTX_SEGVTRAP_N);
   if (n != 0) {			/* only try traceback once */
      fprintf(stderr, "[Traceback failed]\n");
      MUTEX_UNLOCKID(MTX_SEGVTRAP_N);
      exit(1);
      }
   n++;
   MUTEX_UNLOCKID(MTX_SEGVTRAP_N);

#if MVS || VM
#if SASC
   btrace(0);
#endif					/* SASC */
#endif					/* MVS || VM */

   fatalerr(302, NULL);
   }

/*
 * error - print error message from s1 and s2; used only in startup code.
 */
void error(s1, s2)
char *s1, *s2;
   {

#ifdef PresentationManager
   ConsoleFlags |= OutputToBuf;
   if (!s1 && s2)
      fprintf(stderr, s2);
   else if (s1 && s2)
      fprintf(stderr, "%s: %s\n", s1, s2);
#else					/* PresentationManager */
   if (!s1)
      fprintf(stderr, "error in startup code\n%s\n", s2);
   else
      fprintf(stderr, "error in startup code\n%s: %s\n", s1, s2);
#endif					/* PresentationManager */

   fflush(stderr);

#ifdef PresentationManager
   /* bring up the message box to display the error we constructed */
   WinMessageBox(HWND_DESKTOP, HWND_DESKTOP, ConsoleStringBuf,
		"Icon Runtime Initialization", 0,
		MB_OK|MB_ICONHAND|MB_MOVEABLE);
#endif					/* PresentationManager */

   if (dodump)
      abort();
   c_exit(EXIT_FAILURE);
   }

/*
 * syserr - print s as a system error.
 */
void syserr(s)
char *s;
   {
   CURTSTATE();

#ifdef PresentationManager
   ConsoleFlags |= OutputToBuf;
#endif					/* PresentationManager */
   fprintf(stderr, "System error");
   if (pfp == NULL)
      fprintf(stderr, " in startup code");
   else {
#if COMPILER
      if (line_info)
	 fprintf(stderr, " at line %d in %s", line_num, file_name);
#else					/* COMPILER */
      fprintf(stderr, " at line %ld in %s", (long)findline(ipc.opnd),
	 findfile(ipc.opnd));
#endif					/* COMPILER */
      }
  fprintf(stderr, "\n%s\n", s);
#ifdef PresentationManager
  error(NULL, NULL);
#endif					/* PresentationManager */

   fflush(stderr);
   if (dodump)
      abort();
   c_exit(EXIT_FAILURE);
   }


/*
 * c_exit(i) - flush all buffers and exit with status i.
 */
void c_exit(i)
int i;
{

#ifdef ConsoleWindow
#ifdef ScrollingConsoleWin
   char *msg = "Click the \"x\" to close console...";
#else					/* ScrollingConsoleWin */
   char *msg = "Strike any key to close console...";
#endif					/* ScrollingConsoleWin */
#endif					/* ConsoleWindow */

   CURTSTATE();

#if E_Exit
   if (curpstate != NULL)
      EVVal((word)i, E_Exit);
#endif					/* E_Exit */
#ifdef MultiThread
   if (curpstate != NULL && curpstate->parent != NULL) {
      /* might want to get to the lterm somehow, instead */
      while (1) {
	 struct descrip dummy;
	 co_chng(curpstate->parent->Mainhead, NULL, &dummy, A_Cofail, 1);
	 }
      }
#endif					/* MultiThread */

#ifdef TallyOpt
   {
   int j;

   if (tallyopt) {
      fprintf(stderr,"tallies: ");
      for (j=0; j<16; j++)
	 fprintf(stderr," %ld", (long)tallybin[j]);
	 fprintf(stderr,"\n");
	 }
      }
#endif					/* TallyOpt */

   if (k_dump && set_up) {
      fprintf(stderr,"\nTermination dump:\n\n");
      fflush(stderr);
       fprintf(stderr,"co-expression #%ld(%ld)\n",
	 (long)BlkD(k_current,Coexpr)->id,
	 (long)BlkD(k_current,Coexpr)->size);
      fflush(stderr);
      xdisp(pfp,glbl_argp,k_level,stderr);
      }

#ifdef ConsoleWindow
   /*
    * if the console was used for anything, pause it
    */
   closelog();
   if (ConsoleBinding) {
      char label[256], tossanswer[256];
      struct descrip answer;
      
      wputstr((wbp)ConsoleBinding, msg, strlen(msg));

      strcpy(tossanswer, "label=");
      strncpy(tossanswer+6, StrLoc(kywd_prog), StrLen(kywd_prog));
      tossanswer[ 6 + StrLen(kywd_prog) ] = '\0';
      strcat(tossanswer, " - execution terminated");
      wattrib((wbp)ConsoleBinding, tossanswer, strlen(tossanswer),
              &answer, tossanswer);
      waitkey(ConsoleBinding);
      }
/* undo the #define exit c_exit */
#undef exit
#passthru #undef exit

#endif					/* ConsoleWindow */

#if defined(MultipleRuns)
   /*
    * Free allocated memory so application can continue.
    */
   xmfree();
#endif					/* MultipleRuns */

#if MSDOS /* add others who need to free their resources here */
#ifdef ISQL
   /*
    * close ODBC connections left open
    */
   while (isqlfiles != NULL) {
      dbclose(isqlfiles);
      }
   if (ISQLEnv!=NULL) {
      SQLFreeEnv(ISQLEnv);  /* release ODBC environment */
      }
#endif					/* ISQL */
   /*
    * free dynamic record types
    */
#ifdef MultiThread
   if (curpstate && dr_arrays) {
#else					/* MultiThread */
   if (dr_arrays) {
#endif					/* MultiThread */
      int i, j;
      struct b_proc_list *bpelem, *to_free;
      for(i=0;i<longest_dr;i++) {
         if (dr_arrays[i] != NULL) {
	    for(bpelem = dr_arrays[i]; bpelem; ) {
	       free(StrLoc(bpelem->this->recname));
	       for(j=0;j<bpelem->this->nparam;j++)
	          free(StrLoc(bpelem->this->lnames[j]));
	       free(bpelem->this);
	       to_free = bpelem;
	       bpelem = bpelem->next;
	       free(to_free);
               }
            }
         }
      free(dr_arrays);
      }
#endif

#ifdef MSWindows
   PostQuitMessage(0);
   while (wstates != NULL) pollevent();
#endif					/* MSWindows */

#if TURBO || BORLAND_386
   flushall();
   _exit(i);
#else					/* TURBO || BORLAND_386 */
#ifdef PresentationManager
   /* tell thread 1 to shut down */
   WinPostQueueMsg(HMainMessageQueue, WM_QUIT, (MPARAM)0, (MPARAM)0);
   /* bye, bye */
   InterpThreadShutdown();
#else
#ifdef Concurrent
     clean_threads();
    /*pthread_exit(EXIT_SUCCESS);*/
#endif					/* PresentationManager */
   exit(i);
#endif					/* PresentationManager */
#endif					/* TURBO || BORLAND_386 */

}


/*
 * err() is called if an erroneous situation occurs in the virtual
 *  machine code.  It is typed as int to avoid declaration problems
 *  elsewhere.
 */
int err()
{
   syserr("call to 'err'\n");
   return 1;		/* unreachable; make compilers happy */
}

/*
 * fatalerr - disable error conversion and call run-time error routine.
 */
void fatalerr(n, v)
int n;
dptr v;
   {
   IntVal(kywd_err) = 0;
   err_msg(n, v);
   }

/*
 * pstrnmcmp - compare names in two pstrnm structs; used for qsort.
 */
int pstrnmcmp(a,b)
struct pstrnm *a, *b;
{
  return strcmp(a->pstrep, b->pstrep);
}

word getrandom()
{
#ifndef NoRandomize
/*
 * Set the random number seed randomly.
 * This code attempts to use the same algorithm as in ipl/procs/random.icn
 *   &random := map("sSmMhH", "Hh:Mm:Ss", &clock) +
 *    map("YyXxMmDd", "YyXx/Mm/Dd", &date) + &time + 1009 * ncalls
 */
   static int ncalls = 0;
   word krandom;
   int i;
   time_t t;
   struct tm *ct, ctstruct;

   time(&t);

#ifdef Concurrent
   ct = localtime_r(&t, &ctstruct);
#else					/* Concurrent */
   ct = localtime(&t);
#endif					/* Concurrent */

   if (ct == NULL) return 0;
   /* map &clock */
   krandom = ((ct->tm_sec % 10)*10+ct->tm_sec/10)*10+
       ((ct->tm_min % 10)*10+ct->tm_min/10)*10+
       ((ct->tm_hour % 10)*10+ct->tm_hour/10);
   /* + map &date */
   krandom += (((1900+ct->tm_year)*100+ct->tm_mon)*100)+ct->tm_mday;
   /* + map &time */

#ifndef HAVE_KEYWORD__THREAD
   ncalls++;
   krandom += millisec() + 1009 * ncalls;
#else
   krandom += millisec() + 1009 * (int)get_tstate();
#endif
   return krandom;
#else					/* NoRandomize */
   return 0;
#endif					/* NoRandomize */
}

/*
 * datainit - initialize some global variables.
 */
void datainit()
   {
#ifdef MSWindows
   extern FILE *finredir, *fouredir, *ferredir;
#endif					/* MSWindows */
   CURTSTATE();

   /*
    * Initializations that cannot be performed statically (at least for
    * some compilers).					[[I?]]
    */

#ifdef MultiThread
   k_errout.title = T_File;
   k_input.title = T_File;
   k_output.title = T_File;
#ifdef Concurrent
   pthread_mutex_init(&(k_errout.mutex), NULL);
   pthread_mutex_init(&(k_input.mutex), NULL);
   pthread_mutex_init(&(k_output.mutex), NULL);
#endif					/* Concurrent */
#endif					/* MultiThread */

#ifdef MSWindows
   if (ferredir != NULL)
      k_errout.fd.fp = ferredir;
   else
#endif					/* MSWindows */
   k_errout.fd.fp = stderr;
   StrLen(k_errout.fname) = 7;
   StrLoc(k_errout.fname) = "&errout";
#ifdef ConsoleWindow
   if (!(ConsoleFlags & StdErrRedirect))
      k_errout.status = Fs_Write | Fs_Window;
   else
#endif					/* Console Window */
      k_errout.status = Fs_Write;

#ifdef MSWindows
   if (finredir != NULL)
      k_input.fd.fp = finredir;
   else
#endif					/* MSWindows */
   if (k_input.fd.fp == NULL)
      k_input.fd.fp = stdin;
   StrLen(k_input.fname) = 6;
   StrLoc(k_input.fname) = "&input";
#ifdef ConsoleWindow
   if (!(ConsoleFlags & StdInRedirect))
      k_input.status = Fs_Read | Fs_Window;
   else
#endif					/* Console Window */
      k_input.status = Fs_Read;

#ifdef MSWindows
   if (fouredir != NULL)
      k_output.fd.fp = fouredir;
   else
#endif					/* MSWindows */
   if (k_output.fd.fp == NULL)
      k_output.fd.fp = stdout;
   StrLen(k_output.fname) = 7;
   StrLoc(k_output.fname) = "&output";
#ifdef ConsoleWindow
   if (!(ConsoleFlags & StdOutRedirect))
      k_output.status = Fs_Write | Fs_Window;
   else
#endif					/* Console Window */
      k_output.status = Fs_Write;

   IntVal(kywd_pos) = 1;
   IntVal(kywd_ran) = getrandom();

   StrLen(kywd_prog) = strlen(prog_name);
   StrLoc(kywd_prog) = prog_name;
   StrLen(k_subject) = 0;
   StrLoc(k_subject) = "";

   StrLen(blank) = 1;
   StrLoc(blank) = " ";
   StrLen(emptystr) = 0;
   StrLoc(emptystr) = "";
   BlkLoc(nullptr) = (union block *)NULL;
   StrLen(lcase) = 26;
   StrLoc(lcase) = "abcdefghijklmnopqrstuvwxyz";
   StrLen(letr) = 1;
   StrLoc(letr) = "r";
   IntVal(nulldesc) = 0;
   k_errorvalue = nulldesc;
   IntVal(onedesc) = 1;
   StrLen(ucase) = 26;
   StrLoc(ucase) = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
   IntVal(zerodesc) = 0;

#ifdef MultiThread
   /*
    *  Initialization needed for event monitoring
    */
   Kcset(&csetdesc);
   BlkLoc(rzerodesc) = (union block *)&realzero;
#endif					/* MultiThread */

   maps2 = nulldesc;
   maps3 = nulldesc;

#if !COMPILER
   qsort((char *)pntab, pnsize, sizeof(struct pstrnm),
	 (QSortFncCast)pstrnmcmp);

#ifdef MultipleRuns
   /*
    * Initializations required for repeated program runs
    */
					/* In this module:	*/
   k_level = 0;				/* &level */
   k_errornumber = 0;			/* &errornumber */
   k_errortext = "";			/* &errortext */
   currend = NULL;			/* current end of memory region */
   mstksize = MStackSize;		/* initial size of main stack */
   stksize = StackSize;			/* co-expression stack size */
   ssize = MaxStrSpace;			/* initial string space size (bytes) */
   abrsize = MaxAbrSize;		/* initial size of allocated block
					     region (bytes) */
   qualsize = QualLstSize;		/* size of quallist for fixed regions */

   dodump = 0;				/* produce dump on error */

#ifdef ExecImages
   dumped = 0;				/* This is a dumped image. */
#endif					/* ExecImages */

					/* In module interp.r:	*/
   pfp = 0;				/* Procedure frame pointer */
   sp = NULL;				/* Stack pointer */

					/* In module rmemmgt.r:	*/
   coexp_ser = 2;
   list_ser = 1;
   set_ser = 1;
   table_ser = 1;

   coll_stat = 0;
   coll_str = 0;
   coll_blk = 0;
   coll_tot = 0;

					/* In module time.c: */
   first_time = 1;

#endif					/* MultipleRuns */
#endif					/* COMPILER */

   }

#ifdef MultiThread

/*
 * Initialize a loaded program.  Unicon programs will have an
 * interesting icodesize; non-Unicon programs will send a fake
 * icodesize (nonzero, perhaps good if longword-aligned) to alccoexp.
 */
struct b_coexpr *initprogram(word icodesize, word stacksize,
			     word stringsiz, word blocksiz)
{
   struct b_coexpr *coexp = alccoexp(icodesize, stacksize);
   struct progstate *pstate = NULL;
   struct threadstate *tstate = NULL;
   if (coexp == NULL) return NULL;
   pstate = coexp->program;
   tstate = pstate->tstate;
   tstate->Stack = (word *)((char *)(tstate+1) + icodesize);
   tstate->Stackend = (word *)(((char *)(tstate->Stack)) + (stacksize/2));
#ifdef StackCheck
   coexp->es_stack = tstate->Stack;
   coexp->es_stackend = tstate->Stackend;
#endif					/* StackCheck */
   /*
    * Initialize values.
    */
   pstate->hsize = icodesize;
   pstate->parent= NULL;
   pstate->parentdesc= nulldesc;
   pstate->eventmask= nulldesc;
   pstate->eventcount = zerodesc;
   pstate->valuemask= nulldesc;
   pstate->eventcode= nulldesc;
   pstate->eventval = nulldesc;
   pstate->eventsource = nulldesc;

   pstate->Kywd_err = zerodesc;

   init_sighandlers(pstate);
   
   init_threadstate(tstate);

   pstate->Kywd_time_elsewhere = millisec();
   pstate->Kywd_time_out = 0;
   pstate->Mainhead= ((struct b_coexpr *)pstate)-1;
   pstate->K_main.dword = D_Coexpr;
   BlkLoc(pstate->K_main) = (union block *) pstate->Mainhead;

   pstate->Longest_dr=0;
   pstate->Dr_arrays=NULL;

#ifdef Graphics
   pstate->AmperX = zerodesc;
   pstate->AmperY = zerodesc;
   pstate->AmperRow = zerodesc;
   pstate->AmperCol = zerodesc;
   pstate->AmperInterval = zerodesc;
   pstate->LastEventWin = nulldesc;
   pstate->Kywd_xwin[XKey_Window] = nulldesc;
#endif					/* Graphics */

   pstate->Coexp_ser = 2;
   pstate->List_ser = 1;
   pstate->Set_ser = 1;
   pstate->Table_ser = 1;

   pstate->stringtotal = pstate->blocktotal =
   pstate->colltot     = pstate->collstat   =
   pstate->collstr     = pstate->collblk    = 0;

   pstate->stringregion = (struct region *)malloc(sizeof(struct region));
   pstate->blockregion  = (struct region *)malloc(sizeof(struct region));
   pstate->stringregion->size = stringsiz;
   pstate->blockregion->size = blocksiz;

   /*
    * the local program region list starts out with this region only
    */
   pstate->stringregion->prev = NULL;
   pstate->blockregion->prev = NULL;
   pstate->stringregion->next = NULL;
   pstate->blockregion->next = NULL;
   /*
    * the global region list links this region with curpstate's
    */
   pstate->stringregion->Gprev = curpstate->stringregion;
   pstate->blockregion->Gprev = curpstate->blockregion;
   pstate->stringregion->Gnext = curpstate->stringregion->Gnext;
   pstate->blockregion->Gnext = curpstate->blockregion->Gnext;
   if (curpstate->stringregion->Gnext)
      curpstate->stringregion->Gnext->Gprev = pstate->stringregion;
   curpstate->stringregion->Gnext = pstate->stringregion;
   if (curpstate->blockregion->Gnext)
      curpstate->blockregion->Gnext->Gprev = pstate->blockregion;
   curpstate->blockregion->Gnext = pstate->blockregion;
   initalloc(0, pstate);

#ifdef Arrays   
   pstate->Cprealarray = cprealarray_0;
   pstate->Cpintarray = cpintarray_0;
#endif					/* Arrays */      

   pstate->Cplist = cplist_0;
   pstate->Cpset = cpset_0;
   pstate->Cptable = cptable_0;
   pstate->EVstralc = EVStrAlc_0;
   pstate->Interp = interp_0;
   pstate->Cnvcset = cnv_cset_0;
   pstate->Cnvint = cnv_int;
   pstate->Cnvreal = cnv_real;
   pstate->Cnvstr = cnv_str;
   pstate->Cnvtcset = cnv_tcset_0;
   pstate->Cnvtstr = cnv_tstr_0;
   pstate->Deref = deref_0;
   pstate->Alcbignum = alcbignum_0;
   pstate->Alccset = alccset_0;
   pstate->Alcfile = alcfile;
   pstate->Alchash = alchash_0;
   pstate->Alcsegment = alcsegment_0;
   pstate->Alclist_raw = alclist_raw;
   pstate->Alclist = alclist_0;
   pstate->Alclstb = alclstb_0;
   pstate->Alcreal = alcreal;
   pstate->Alcrecd = alcrecd_0;
   pstate->Alcrefresh = alcrefresh_0;
   pstate->Alcselem = alcselem_0;
   pstate->Alcstr = alcstr;
   pstate->Alcsubs = alcsubs_0;
   pstate->Alctelem = alctelem_0;
   pstate->Alctvtbl = alctvtbl_0;
   pstate->Deallocate = deallocate_0;
   pstate->Reserve = reserve_0;

   return coexp;
}

/*
 * Given a pointer into icode, tell which program it came from.
 * At present this is a linear search of loaded programs in a
 * link list. For performance scalability, the link list should
 * be replaced by a sorted array so this routine can use binary search.
 */
struct progstate * findicode(word *opnd)
{
   struct progstate *p;
   CURTSTATE();

   for (p = &rootpstate; p != NULL; p = p->next) {
      if (InRange(p->Code, ipc.opnd, p->Ecode)) {
	 return p;
	 }
      }
   if (p == NULL)
      syserr("unidentified inter-program icode\n");
}

/*
 * loadicode - initialize memory particular to a given icode file
 */
struct b_coexpr * loadicode(name, theInput, theOutput, theError, bs, ss, stk)
char *name;
struct b_file *theInput, *theOutput, *theError;
C_integer bs, ss, stk;
   {
   struct b_coexpr *coexp;
   struct progstate *pstate;
   struct header hdr;
   int fdname;
   FILE *fname = NULL;
   word cbread;

   /*
    * open the icode file and read the header
    */
   fname = readhdr(name,&hdr);
   if (fname == NULL)
       return NULL;

   /*
    * Allocate memory for icode, the struct that describes it, and the
    * memory regions as follows.
    *
    * ----------------------
    * | struct b_coexpr    |
    * ----------------------
    * | struct progstate   |
    * ----------------------
    * | struct threadstate |
    * ----------------------
    * | icode              |
    * ----------------------
    * | stack              |
    * ----------------------
    */
   Protect(coexp = initprogram(hdr.hsize, stk, ss, bs),
    {fprintf(stderr,"can't malloc new icode region\n");c_exit(EXIT_FAILURE);});

   pstate = coexp->program;
   pstate->tstate->K_current.dword = D_Coexpr;

   StrLen(pstate->Kywd_prog) = strlen(prog_name);
   StrLoc(pstate->Kywd_prog) = prog_name;
   MakeInt(hdr.trace, &(pstate->Kywd_trc));

   /*
    * might want to override from TRACE environment variable here.
    */

   /*
    * Establish pointers to icode data regions.		[[I?]]
    */
   pstate->Code    = ((char *)(pstate + 1)) + sizeof(struct threadstate);
   pstate->Ecode    = (char *)(pstate->Code + hdr.Records);
   pstate->Records = (word *)(pstate->Code + hdr.Records);
   pstate->Ftabp   = (int *)(pstate->Code + hdr.Ftab);
#ifdef FieldTableCompression
   pstate->Fo = (int *)(pstate->Code + hdr.Fo);
   pstate->Focp =   (unsigned char *)(pstate->Fo);
   pstate->Fosp =   (unsigned short *)(pstate->Fo);
   pstate->Foffwidth = hdr.FoffWidth;
   if (hdr.FoffWidth == 1) {
      pstate->Bm = (char *)(pstate->Focp + hdr.Nfields);
      }
   else if (hdr.FoffWidth == 2) {
      pstate->Bm = (char *)(pstate->Fosp + hdr.Nfields);
      }
   else
      pstate->Bm = (char *)(pstate->Fo + hdr.Nfields);
   pstate->Ftabwidth= hdr.FtabWidth;
   pstate->Foffwidth = hdr.FoffWidth;
   pstate->Ftabcp   = (unsigned char *)(pstate->Code + hdr.Ftab);
   pstate->Ftabsp   = (unsigned short *)(pstate->Code + hdr.Ftab);
#endif					/* FieldTableCompression */
   pstate->Fnames  = (dptr)(pstate->Code + hdr.Fnames);
   pstate->Globals = pstate->Efnames = (dptr)(pstate->Code + hdr.Globals);
   pstate->Gnames  = pstate->Eglobals = (dptr)(pstate->Code + hdr.Gnames);
   pstate->NGlobals = pstate->Eglobals - pstate->Globals;
   pstate->Statics = pstate->Egnames = (dptr)(pstate->Code + hdr.Statics);
   pstate->Estatics = (dptr)(pstate->Code + hdr.Filenms);
   pstate->NStatics = pstate->Estatics - pstate->Statics;
   pstate->Filenms = (struct ipc_fname *)(pstate->Estatics);
   pstate->Efilenms = (struct ipc_fname *)(pstate->Code + hdr.linenums);
   pstate->Ilines = (struct ipc_line *)(pstate->Efilenms);
   pstate->Elines = (struct ipc_line *)(pstate->Code + hdr.Strcons);
   pstate->Strcons = (char *)(pstate->Elines);

   pstate->K_errout = *theError;
   pstate->K_input  = *theInput;
   pstate->K_output = *theOutput;

   /*
    * Read the interpretable code and data into memory.
    */

   if ((strchr((char *)(hdr.config), 'Z'))!=NULL) { /* to decompress */
#if HAVE_LIBZ
      if ((cbread = gzlongread(pstate->Code, sizeof(char), (long)hdr.hsize, fname))
      	   != hdr.hsize) {
	 fprintf(stderr,"Tried to read %ld bytes of code, got %ld\n",
		(long)hdr.hsize,(long)cbread);
	 error(name, "can't read interpreter code");
	 }
      gzclose(fname);
#else					/* HAVE_LIBZ */
	error(name, "this VM can't read compressed icode");
#endif					/* HAVE_LIBZ */
      }
   /* Don't need to decompress */
   else  {
      memmove(pstate->Code, precode, hdr.hsize);
      free(filebuffer);
      fclose(fname);
      }

   /*
    * Resolve references from icode to run-time system.
    * The first program has this done in icon_init after
    * initializing the event monitoring system.
    */
   resolve(pstate);

   return coexp;
   }

/*
 * To which program does arbitrary icode address p belong?
 *
 * For now, walk through the co-expression block list, looking for
 * programs that way.  Needs to be optimized; at the very least it
 * would be easy to build a sorted array of the programs' addresses
 * and do binary search.
 */
struct progstate *findprogramforblock(union block *p)
{
   struct b_coexpr *ce;
   struct progstate *tmpp;
   extern struct b_proc *stubrec;
   MUTEX_LOCKID(MTX_STKLIST);
   ce = stklist;
   while (ce != NULL) {
      tmpp = ce->program;
      if (InRange(tmpp->Code, p, tmpp->Elines)) {
	 MUTEX_UNLOCKID(MTX_STKLIST);
	 return tmpp;
	 }
      ce = ce->nextstk;
      }
   MUTEX_UNLOCKID(MTX_STKLIST);
   return NULL;
}

#endif					/* MultiThread */
