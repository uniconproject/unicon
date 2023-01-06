/*
 * Prototypes for run-time functions.
 */

/*
 * Prototypes common to the compiler and interpreter.
 */
void		EVInit		(void);
int		activate	(dptr val, struct b_coexpr *ncp, dptr result);
word		add		(word a,word b,int *over_flowp);
void		addmem 	(struct b_set *ps,struct b_selem *pe, union block **pl);
struct astkblk	*alcactiv	(void);
#ifdef MultiProgram
struct b_cset	*alccset_0	(void);
struct b_cset	*alccset_1	(void);
#undef alcfile
struct b_file	*alcfile	(FILE *fd,int status,dptr name);
#define alcfile (curpstate->Alcfile)
struct b_file	*alcfile_1	(FILE *fd,int status,dptr name);
union block	*alchash_0	(int tcode);
union block	*alchash_1	(int tcode);
struct b_slots	*alcsegment_0	(word nslots);
struct b_slots	*alcsegment_1	(word nslots);
#undef alclist_raw
struct b_list	*alclist_raw	(uword size, uword nslots);
#define alclist_raw (curpstate->Alclist_raw)
struct b_list	*alclist_raw_1	(uword size, uword nslots);
struct b_list	*alclist_0	(uword size, uword nslots);
struct b_list	*alclist_1	(uword size, uword nslots);
struct b_lelem	*alclstb_0	(uword nslots,uword first,uword nused);
struct b_lelem	*alclstb_1	(uword nslots,uword first,uword nused);
#undef alcreal
struct b_real	*alcreal	(double val);
#define alcreal (curpstate->Alcreal)
struct b_real	*alcreal_1	(double val);
struct b_selem	*alcselem_0	(dptr mbr,uword hn);
struct b_selem	*alcselem_1	(dptr mbr,uword hn);
#undef alcstr
char		*alcstr	(char	*s,word slen);
#define alcstr (curpstate->Alcstr)
char		*alcstr_1	(char	*s,word slen);
struct b_telem	*alctelem_0	(void);
struct b_telem	*alctelem_1	(void);
struct b_tvtbl	*alctvtbl_0	(dptr tbl,dptr ref,uword hashnum);
struct b_tvtbl	*alctvtbl_1	(dptr tbl,dptr ref,uword hashnum);
struct b_tvmonitored  *alctvmonitored	(dptr tv, word ipc_in);
void assign_event_functions(struct progstate *p, struct descrip cs);
int invaluemask(struct progstate *p, int evcode, struct descrip *val);
#ifdef PatternType
struct b_pattern	*alcpattern_0 (word size);
struct b_pattern	*alcpattern_1 (word size);
#if COMPILER
struct b_pelem	*alcpelem_0	(word);
struct b_pelem	*alcpelem_1	(word);
#else					/* COMPILER */
struct b_pelem	*alcpelem_0	(word, word *);
struct b_pelem	*alcpelem_1	(word, word *);
#endif					/* COMPILER */
#endif					/* PatternType */
#else					/* MultiProgram */
struct b_cset	*alccset	(void);
struct b_file	*alcfile	(FILE *fd,int status,dptr name);
union block	*alchash	(int tcode);
struct b_slots	*alcsegment	(word nslots);
struct b_list	*alclist_raw	(uword size, uword nslots);
struct b_list	*alclist	(uword size, uword nslots);
struct b_lelem	*alclstb	(uword nslots,uword first,uword nused);
struct b_real	*alcreal	(double val);
struct b_selem	*alcselem	(dptr mbr,uword hn);
char		*alcstr		(char	*s,word slen);
struct b_telem	*alctelem	(void);
struct b_tvtbl	*alctvtbl	(dptr tbl,dptr ref,uword hashnum);
#ifdef PatternType
struct b_pattern	*alcpattern	(word size);
#if COMPILER
struct b_pelem	*alcpelem(word pattern_code);
#else					/* COMPILER */
struct b_pelem	*alcpelem(word pattern_code, word *origin_ipc);
#endif					/* COMPILER */
#endif					/* PatternType */
#endif					/* MultiProgram */
#ifdef Arrays
struct b_list   *alclisthdr	(uword size, union block *bptr);
#endif					/* Arrays */

char		*alc_strerror	(int);
void		 set_errortext	(int i);
void		 set_syserrortext(int ern);
#if HAVE_LIBZ
void		 set_gzerrortext(gzFile f);
#endif					/* HAVE_LIBZ */

struct b_cons   *alccons	(union block *);

int		anycmp		(dptr dp1,dptr dp2);
int		anycmpBase	(dptr dp1,dptr dp2,int sortType);
#ifdef Arrays
int		arraytolist	(struct descrip *arr);
int		cplist2realarray(dptr dp, dptr dp2, word i, word j,
				 word skipcopyelements);
#endif					/* Arrays */
int		bfunc		(void);
struct b_proc	*bi_strprc	(dptr s, C_integer arity);
#if __clang__ || __GNUC__
/* Stop clang and gcc from warning "control may reach end of non-void function" when calling this function */
void		c_exit		(int i)  __attribute__ ((noreturn,nothrow));
#else
void		c_exit		(int i);
#endif /* __clang__ */
int		c_get		(struct b_list *hp, struct descrip *res);
void		c_put		(struct descrip *l, struct descrip *val);
int		c_inserttable	(union block **pbp, int n, dptr x);
int		c_insertset	(union block **pps, dptr pd);
int		CmdParamToArgv	(char *s, char ***avp, int dequote);
int		cnv_c_dbl	(dptr s, double *d);
int		cnv_c_int	(dptr s, C_integer *d);
int		cnv_c_str	(dptr s, dptr d);
#ifdef MultiProgram
int		cnv_cset_0	(dptr s, dptr d);
int		cnv_cset_1	(dptr s, dptr d);
#else
int		cnv_cset	(dptr s, dptr d);
#endif					/* MultiProgram */
int		cnv_ec_int	(dptr s, C_integer *d);
int		cnv_eint	(dptr s, dptr d);
int		cnv_list	(dptr s, dptr d);
#ifdef MultiProgram
#undef cnv_int
int		cnv_int		(dptr s, dptr d);
#define cnv_int (curpstate->Cnvint)
int		cnv_int_1	(dptr s, dptr d);
#undef cnv_real
int		cnv_real	(dptr s, dptr d);
#define cnv_real (curpstate->Cnvreal)
int		cnv_real_1	(dptr s, dptr d);
#undef cnv_str
int		cnv_str	(dptr s, dptr d);
#define cnv_str (curpstate->Cnvstr)
int		cnv_str_1	(dptr s, dptr d);
int		cnv_tcset_0	(struct b_cset *cbuf, dptr s, dptr d);
int		cnv_tcset_1	(struct b_cset *cbuf, dptr s, dptr d);
int		cnv_tstr_0	(char *sbuf, dptr s, dptr d);
int		cnv_tstr_1	(char *sbuf, dptr s, dptr d);
#else					/* MultiProgram */
int		cnv_int		(dptr s, dptr d);
int		cnv_real	(dptr s, dptr d);
int		cnv_str		(dptr s, dptr d);
int		cnv_tcset	(struct b_cset *cbuf, dptr s, dptr d);
int		cnv_tstr	(char *sbuf, dptr s, dptr d);
#endif					/* MultiProgram */
#ifdef PatternType
struct b_pelem * Alternate(struct b_pelem * L,struct b_pelem * R);
struct b_pelem * Arbno_Simple(struct b_pelem *pe);
struct b_pelem *Bracket(struct b_pelem *E,struct b_pelem * P,
			    struct b_pelem * A);
#ifdef MultiProgram
int 		cnv_pattern_0(dptr s, dptr p);
int 		cnv_pattern_1(dptr s, dptr p);
#else					/* MultiProgram */
int 		cnv_pattern(dptr s, dptr p);
#endif					/* MultiProgram */
struct b_pelem *Concat 		(struct b_pelem * L, struct b_pelem *R, int Incr );
struct b_pelem *Copy		(struct b_pelem * P);

union block *pattern_make(int stck_size, struct b_pelem * pnext,
			  int pattern_code, int index, struct descrip param);
union block *pelem_make(struct b_pelem * pnext, int pattern_code,
			int index, struct descrip param);

dptr		bi_pat		(int what);
int		arg_image	(struct descrip arg, int pcode, int type,
				   dptr result);
int		construct_image	(dptr left, dptr s, dptr r, dptr result);

struct b_pattern * breakx_make(struct b_pelem * B);
int pattern_image(union block *pe, int prev_index, dptr result,
		  int peCount, int pe_index, int stop_index); 
#endif					/* PatternType */
int		co_chng		(struct b_coexpr *ncp, struct descrip *valloc,
				   struct descrip *rsltloc,
				   int swtch_typ, int first);
void		co_init		(struct b_coexpr *sblkp);
void		coacttrace	(struct b_coexpr *ccp,struct b_coexpr *ncp);
void		cofailtrace	(struct b_coexpr *ccp,struct b_coexpr *ncp);
void		corettrace	(struct b_coexpr *ccp,struct b_coexpr *ncp);
int		coswitch	(word *old, word *new, int first);
int		cphash		(dptr dp1, dptr dp2, word n, int tcode);
#ifdef MultiProgram
int		cplist_0	(dptr dp1,dptr dp2,word i,word j);
int		cplist_1	(dptr dp1,dptr dp2,word i,word j);
#ifdef Arrays
int		cprealarray_0	(dptr dp1,dptr dp2,word i,word j);
int		cpintarray_0	(dptr dp1,dptr dp2,word i,word j);
int		cprealarray_1	(dptr dp1,dptr dp2,word i,word j);
int		cpintarray_1	(dptr dp1,dptr dp2,word i,word j);
struct descrip listtoarray(dptr l);
#endif					/* Arrays */
int		cpset_0		(dptr dp1,dptr dp2,word size);
int		cpset_1		(dptr dp1,dptr dp2,word size);
int		cptable_0	(dptr dp1,dptr dp2,word size);
int		cptable_1	(dptr dp1,dptr dp2,word size);
void		EVStrAlc_0	(word n);
void		EVStrAlc_1	(word n);
#else					/* MultiProgram */
int		cplist		(dptr dp1,dptr dp2,word i,word j);
int		cpset		(dptr dp1,dptr dp2,word size);
int		cptable		(dptr dp1,dptr dp2,word size);
#ifdef Arrays
int		cprealarray	(dptr dp1,dptr dp2,word i,word j);
int		cpintarray	(dptr dp1,dptr dp2,word i,word j);
struct descrip listtoarray(dptr l);
#endif					/* Arrays */
#endif					/* MultiProgram */
void		cpslots		(dptr dp1,dptr slotptr,word i, word j);
int		csetcmp		(unsigned int *cs1,unsigned int *cs2);
int		cssize		(dptr dp);
word		cvpos		(word pos, word len);
void		datainit	(void);
#ifdef MultiProgram
void		deallocate_0	(union block *bp);
void		deallocate_1	(union block *bp);
#else					/* MultiProgram */
void		deallocate	(union block *bp);
#endif					/* MultiProgram */
int		def_c_dbl	(dptr s, double df, double * d);
int		def_c_int	(dptr s, C_integer df, C_integer * d);
int		def_c_str	(dptr s, char * df, dptr d);
int		def_cset	(dptr s, struct b_cset * df, dptr d);
int		def_ec_int	(dptr s, C_integer df, C_integer * d);
int		def_eint	(dptr s, C_integer df, dptr d);
int		def_int		(dptr s, C_integer df, dptr d);
int		def_real	(dptr s, double df, dptr d);
int		def_str		(dptr s, dptr df, dptr d);
int		def_tcset (struct b_cset *cbuf,dptr s,struct b_cset *df,dptr d);
int		def_tstr	(char *sbuf, dptr s, dptr df, dptr d);
word		div3		(word a,word b, int *over_flowp);
int		doasgn		(dptr dp1,dptr dp2);
int		doimage		(int c,int q);
int		dp_pnmcmp	(struct pstrnm *pne,dptr dp);
void		drunerr		(int n, double v);
void		dumpact		(struct b_coexpr *ce);
struct b_proc * dynrecord	(dptr s, dptr fields, int n);
void		env_int	(char *name,word *variable,int non_neg, uword limit);
int		equiv		(dptr dp1,dptr dp2);
int		err		(void);
void		err_msg		(int n, dptr v);
void		error		(char *s1, char *s2);
#if __clang__ || __GNUC__
/* Stop clang and gcc from warning "control may reach end of non-void function" when calling this function */
void		fatalerr 	(int n,dptr v) __attribute__ ((noreturn,nothrow));
#else
void		fatalerr	(int n,dptr v);
#endif /* __clang__ || __GNUC__ */
int		findcol		(word *ipc_in);
char		*findfile	(word *ipc_in);
#ifdef MultiProgram
char		*findfile_p	(word *ipc_in, struct progstate *);
#endif					/* MultiProgram */
int		findipc		(int line);
word		* findoldipc	(struct b_coexpr *ce, int level);
int		findline	(word *ipc_in);
#ifdef MultiProgram
int		findline_p	(word *ipc_in, struct progstate *);
#endif					/* MultiProgram */
int		findloc		(word *ipc_in);
int		findsyntax	(word *ipc_in);
int		fldlookup	(struct b_record *rec, const char * const fld);
void		fpetrap		(void);

int		getenv_r	(const char *name, char *buf, size_t len);
word		getrandom	(void);
int		getvar		(char *s,dptr vp);

int 		getkeyword	(char *s, dptr vp);

int		get_CCompiler	(char *s);
int		get_num_cpu_cores();
uword		hash		(dptr dp);
union block	**hchain	(union block *pb,uword hn);
union block	*hgfirst	(union block *bp, struct hgstate *state);
union block	*hgnext		(union block*b,struct hgstate*s,union block *e);
int		hitsyntax	(word *ipc_in);
union block	*hmake		(int tcode,word nslots,word nelem);
void		icon_init	(char *name, int *argcp, char *argv[]);
void		iconhost	(char *hostname);
int		idelay		(int n);
#ifdef MultiProgram
#ifdef TSTATARG
int		interp_0	(int fsig,dptr cargp, struct threadstate *curtstate);
int		interp_1	(int fsig,dptr cargp, struct threadstate *curtstate);
#else 		 	   	  	 /* TSTATARG */
int		interp_0	(int fsig,dptr cargp);
int		interp_1	(int fsig,dptr cargp);
#endif		 	   	  	 /* TSTATARG */
#else					/* MultiProgram */
int		interp		(int fsig,dptr cargp);
#endif					/* MultiProgram */
#ifdef PatternType
#ifdef MultiProgram
int 		internal_match_0(char * pat_sub, int Length, int Pat_S, 
				 struct descrip op, struct b_pelem * pattern,
				 int *Start, int *Stop, int initial_cursor,
				 int Anchored_Mode);
int 		internal_match_1(char * pat_sub, int Length, int Pat_S, 
				 struct descrip op, struct b_pelem * pattern,
				 int *Start, int *Stop, int initial_cursor,
				 int Anchored_Mode);
#else					/* MultiProgram */
int 		internal_match	(char * pat_sub, int Length, int Pat_S, 
				 struct descrip op, struct b_pelem * pattern,
				 int *Start, int *Stop, int initial_cursor,
				 int Anchored_Mode);
#endif					/* MultiProgram */
#endif					/* PatternType */
void		inttrap		(void);
void		irunerr		(int n, C_integer v);
int		iselect		(int fd, int t);
int		is_in_a_block_region(char *block);
int		Kascii		(dptr cargp);
int		Kcset		(dptr cargp);
int		Kdigits		(dptr cargp);
int		Klcase		(dptr cargp);
int		Kletters	(dptr cargp);
int		Kucase		(dptr cargp);
int		lexcmp		(dptr dp1,dptr dp2);
word		longread	(char *s,int width, word len,FILE *fname);
#if HAVE_LIBZ
word		gzlongread	(char *s,int width, word len,FILE *fd);
#endif					/* HAVE_LIBZ */
#ifdef FAttrib
#if UNIX
char *  make_mode		(mode_t st_mode);
#endif					/* UNIX */
#if MSDOS
char *  make_mode		(unsigned short st_mode);
#ifndef NTGCC
int	strcasecmp		(char *s1, char *s2);
int	strncasecmp		(char *s1, char *s2, int n);
#endif					/* NTGCC */
#endif					/* MSDOS */
#endif					/* FAttrib */
union block	**memb		(union block *pb,dptr x,uword hn, int *res);
void		mksubs		(dptr var,dptr val,word i,word j, dptr result);
word		mod3		(word a,word b, int *over_flowp);
word		mul		(word a,word b, int *over_flowp);
word		neg		(word a, int *over_flowp);
void		new_context	(int fsig, dptr cargp); /* w/o CoExpr: a stub*/
int		numcmp		(dptr dp1,dptr dp2,dptr dp3);
void		openlog		(char *p);
void		outimage	(FILE *f,dptr dp,int noimage);
#ifdef PatternType

union block 	*pattern_make_pelem	(int stck_size, struct b_pelem * pe);
#endif					/* PatternType */
struct b_coexpr	*popact		(struct b_coexpr *ce);
#if NT
unsigned long long int memorysize(int);
unsigned long long int physicalmemorysize();
#else                           /* NT */
unsigned long memorysize(int);
unsigned long physicalmemorysize();
#endif                          /* NT */
word		prescan		(dptr d);
int		pstrnmcmp	(struct pstrnm *a,struct pstrnm *b);
#ifdef PseudoPty
void ptclose(struct ptstruct *ptStruct);
struct ptstruct *ptopen(char *command);
int ptgetstrt(char *buffer, const int bufsiz, struct ptstruct *ptStruct,
	      unsigned long waittime, int longread);
int ptgetstr(char *buffer, const int bufsiz, struct ptstruct *ptStruct,
	     struct timeval *timeout);
int ptlongread(char *buffer, const int nelem, struct ptstruct *ptStruct);
int ptputstr(struct ptstruct *ptStruct, char *buffer, int bufsize);
int ptputc(char c, struct ptstruct *ptStruct);
int ptflush(struct ptstruct *ptStruct);
#ifdef MSWindows
struct b_list *findactivepty(struct b_list *lps);
#endif					/* MSWindows */

/*
 * System pty prototypes missing from standard includes due to XOPEN_SOURCE
 * issues, resulting in compiler warnings, at least on Linux. Of course,
 * just providing our own prototypes for library functions may cause problems
 * on other platforms; we may need to fix this or put it under an ifdef.
 */
int grantpt(int);
int unlockpt(int);
int posix_openpt(int);
int ptsname_r(int, char *, size_t);
#endif					/* PseudoPty */
int		pushact		(struct b_coexpr *ce, struct b_coexpr *actvtr);
int		putstr		(FILE *f,dptr d);
char		*qsearch	(char *key, char *base, int nel, int width,
				   int (*cmp)());
int		qtos		(dptr dp,char *sbuf);
int    		 radix		(int sign, register int r, register char *s,
				 register char *end_s, union numeric *result);
#ifdef PatternType
struct b_pelem 	*ResolvePattern	(struct b_pattern *pat);
#endif					/* PatternType */
#ifdef MultiProgram
char		*reserve_0	(int region, word nbytes);
char		*reserve_1	(int region, word nbytes);
#else					/* MultiProgram */
char		*reserve	(int region, word nbytes);
#endif					/* MultiProgram */
void		retderef		(dptr valp, word *low, word *high);
#if !NT
void rusage2rec(struct rusage *usg, struct descrip *dp, struct b_record **rp);
#endif					/* NT */
void		segvtrap	(void);
void		stkdump		(int);
word		sub		(word a,word b, int *over_flowp);
#if __clang__ || __GNUC__
/* Stop clang and gcc from warning "control may reach end of non-void function" when calling this function */
void		syserr		(char *s) __attribute__ ((noreturn,nothrow));
#else
void		syserr		(char *s);
#endif /* __clang__ || __GNUC__ */
struct b_coexpr	*topact		(struct b_coexpr *ce);
void		xmfree		(void);
#ifdef MultiProgram
   void	resolve			(struct progstate *pstate);
   struct progstate *findicode	(word *opnd);
   struct b_coexpr *loadicode	(char *name, struct b_file *theInput,
      struct b_file *theOutput, struct b_file *theError,
      C_integer bs, C_integer ss, C_integer stk);
   void actparent (int eventcode);
   void mmrefresh		(void);
   int mt_activate   (dptr tvalp, dptr rslt, struct b_coexpr *ncp);
   struct progstate *findprogramforblock(union block *p);
   void EVVariable(dptr dx, int eventcode);
#else					/* MultiProgram */
   void	resolve			(void);
#endif					/* MultiProgram */

#ifdef ExternalFunctions
   dptr	extcall			(dptr x, int nargs, int *signal);
#endif					/* ExternalFunctions */

#ifdef LargeInts
#ifdef MultiProgram
   struct b_bignum *alcbignum_0	(word n);
   struct b_bignum *alcbignum_1	(word n);
#else					/* MultiProgram */
   struct b_bignum *alcbignum	(word n);
#endif					/* MultiProgram */
   word		bigradix	(int sign, int r, char *s, char *x,
						   union numeric *result);
int		bigtoreal	(dptr da, double *result);
   int		realtobig	(dptr da, dptr dx);
   int		bigtos		(dptr da, dptr dx);
   void		bigprint	(FILE *f, dptr da);
   int		cpbignum	(dptr da, dptr db);
   int		bigadd		(dptr da, dptr db, dptr dx);
   int		bigsub		(dptr da, dptr db, dptr dx);
   int		bigmul		(dptr da, dptr db, dptr dx);
   int		bigdiv		(dptr da, dptr db, dptr dx);
   int		bigmod		(dptr da, dptr db, dptr dx);
   int		bigneg		(dptr da, dptr dx);
   int		bigpow		(dptr da, dptr db, dptr dx);
   int		bigpowri        (double a, dptr db, dptr drslt);
   int		bigand		(dptr da, dptr db, dptr dx);
   int		bigor		(dptr da, dptr db, dptr dx);
   int		bigxor		(dptr da, dptr db, dptr dx);
   int		bigshift	(dptr da, dptr db, dptr dx);
   word		bigcmp		(dptr da, dptr db);
   int		bigrand		(dptr da, dptr dx);
#endif					/* LargeInts */

   int dup2(int h1, int h2);

void checkpollevent();
void detectRedirection();

int checkOpenConsole( FILE *w, char *s );

#ifdef MSWindows
   #ifdef FAttrib
      #if MSDOS
         char *make_mode(unsigned short st_mode);
         #ifndef NTGCC
         int strcasecmp(char *s1, char *s2);
         int strncasecmp(char *s1, char *s2, int n);
         #endif				/* NTGCC */
      #endif				/* MSDOS */
   #endif				/* FAttrib */
#endif					/* MSWindows */

#if defined(Graphics) || defined(PosixFns)
   struct b_list *findactivewindow(struct b_list *);
   char	*si_i2s		(siptr sip, int i);
   int	si_s2i		(siptr sip, char *s);
#endif					/* Graphics || PosixFns */

#ifdef Graphics
   /*
    * portable graphics routines in rwindow.r and rwinrsc.r
    */
   wcp	alc_context	(wbp w);
   wbp	alc_wbinding	(void);
   wsp	alc_winstate	(void);
   int	atobool		(char *s);
   void	c_push		(dptr l,dptr val);  /* in fstruct.r */
   int	docircles	(wbp w, int argc, dptr argv, int fill);
   void	drawCurve	(wbp w, XPoint *p, int n);
   char	*evquesub	(wbp w, int i);
   void	genCurve	(wbp w, XPoint *p, int n, void (*h)());
   void genCurve(wbp w, XPoint *p, int n, void (*helper)	(wbp, XPoint [], int));
   void	curveLister	(wbp w, XPoint *thepoints, int n);
   wsp	getactivewindow	(void);
   int	getpattern	(wbp w, char *answer);
   char *getselection	(wbp w, char *buf);
   void gotorc		(wbp w,int r,int c);
   void gotoxy		(wbp w, int x, int y);
   struct palentry *palsetup(int p);
   int	palnum		(dptr d);
   int	parsecolor	(wbp w, char *s, long *r, long *g, long *b, long *a);
   int	parsefont	(char *s, char *fam, int *sty, int *sz, int *tp);
   int	parsegeometry	(char *buf, SHORT *x, SHORT *y, SHORT *w, SHORT *h);
   int	parsepattern	(char *s, int len, int *w, int *nbits, C_integer *bits);
   void	qevent		(wsp ws, dptr e, int x, int y, uword t, long f);

   int readBMP		(char *filename, int p, struct imgdata *imd);
   int readGIF		(char *fname, int p, struct imgdata *d);

   int readImage        (char *filename, int p, struct imgdata *imd);
   int writeImage	(wbp w, char *filename, int x, int y, int width, int height);
   int	rectargs	(wbp w, int argc, dptr argv, int i,
   			   word *px, word *py, word *pw, word *ph);
   char	*rgbkey		(int p, double r, double g, double b);

   int	setrgbmode	(wbp w, char *s);
   int	setselection	(wbp w, dptr val);
   int	setsize		(wbp w, char *s);
   int	ulcmp		(pointer p1, pointer p2);
   int	wattrib		(wbp w, char *s, long len, dptr answer, char *abuf);
   int	wgetche		(wbp w, dptr res);
   int	wgetchne	(wbp w, dptr res);
   int	wgetevent	(wbp w, dptr res, int t);
   int	wgetstrg	(char *s, long maxlen, FILE *f);
   void	wgoto		(wbp w, int row, int col);
   int	wlongread	(char *s, int elsize, int nelem, FILE *f);
   void	wputstr		(wbp w, char *s, int len);
   int	writeGIF	(wbp w, char *filename,
   			  int x, int y, int width, int height);
   int	writeBMP	(wbp w, char *filename,
   			  int x, int y, int width, int height);
   int	xyrowcol	(dptr dx);

   /*
    * graphics implementation routines supplied for each platform
    * (excluding those defined as macros for X-windows)
    */
   int	SetPattern	(wbp w, char *name, int len);
   int	SetPatternBits	(wbp w, int width, C_integer *bits, int nbits);
   int	allowresize	(wbp w, int on);
   int	blimage		(wbp w, int x, int y, int wd, int h,
   			  int ch, unsigned char *s, word len);
   char child_window_stuff(wbp w, wbp wp, int child_window);
   char child_window_generic(wbp w, wbp wp, int child_window);
   wcp	clone_context	(wbp w);
   int	copyArea	(wbp w,wbp w2,int x,int y,int wd,int h,int x2,int y2);
   int	do_config	(wbp w, int status);
   int	dumpimage	(wbp w, char *filename, unsigned int x, unsigned int y,
			   unsigned int width, unsigned int height);
   void	eraseArea	(wbp w, int x, int y, int width, int height);
   void	fillrectangles	(wbp w, XRectangle *recs, int nrecs);
   void	free_binding	(wbp w);
   void	free_context	(wcp wc);
   void	free_mutable	(wbp w, int mute_index);
   int	free_window	(wsp ws);
   void	freecolor	(wbp w, char *s);
   char	*get_mutable_name (wbp w, int mute_index);
   void	getbg		(wbp w, char *answer);
   void	getcanvas	(wbp w, char *s);
   int	getdefault	(wbp w, char *prog, char *opt, char *answer);
   void	getdisplay	(wbp w, char *answer);
   void	getdrawop	(wbp w, char *answer);
   void	getfg		(wbp w, char *answer);
   void	getfntnam	(wbp w, char *answer);
   void	geticonic	(wbp w, char *answer);
   int	geticonpos	(wbp w, char *s);
   int	getimstr	(wbp w, int x, int y, int width, int hgt,
   			  struct palentry *ptbl, unsigned char *data);
   int	getimstr24	(wbp w, int xx, int yy, int width, int hgt,
			  unsigned char *d);
   void	getlinestyle	(wbp w, char *answer);
   int	getpixel_init	(wbp w, struct imgmem *imem);
   int	getpixel_term	(wbp w, struct imgmem *imem);
   int	getpixel	(wbp w,int x,int y,long *rv,char *s,struct imgmem *im);
   void	getpointername	(wbp w, char *answer);
   int	getpos		(wbp w);
   int	getvisual	(wbp w, char *answer);
   int	isetbg		(wbp w, int bg);
   int	isetfg		(wbp w, int fg);
   void linkfiletowindow(wbp w, struct b_file *fl);
   int	lowerWindow	(wbp w);
   int	mutable_color	(wbp w, dptr argv, int ac, int *retval);
   char my_wmap         (wbp w);
   int	nativecolor	(wbp w, char *s, long *r, long *g, long *b);

   /* Exclude those functions defined as macros */
   int pollevent	(void);
#ifndef MSWindows
      void wflush	(wbp w);
#endif

   int	query_pointer	(wbp w, XPoint *pp);
   int	query_rootpointer (XPoint *pp);
   int	raiseWindow	(wbp w);
   int	readimage	(wbp w, char *filename, int x, int y, int *status);
   int	rebind		(wbp w, wbp w2);
   int	set_mutable	(wbp w, int i, char *s);
   int	setbg		(wbp w, char *s);
   int	setcanvas	(wbp w, char *s);
   void	setclip		(wbp w);
   int	setcursor	(wbp w, int on);
   int	setdisplay	(wbp w, char *s);
   int	setdrawop	(wbp w, char *val);
   int	setfg		(wbp w, char *s);
   int	setfillstyle	(wbp w, char *s);
   int	setfont		(wbp w, char **s);
   int	setgamma	(wbp w, double gamma);
   int	setgeometry	(wbp w, char *geo);
   int	setheight	(wbp w, SHORT new_height);
   int	seticonicstate	(wbp w, char *s);
   int	seticonlabel	(wbp w, char *val);
   int	seticonpos	(wbp w, char *s);
   int	setimage	(wbp w, char *val);
   int  setinputmask	(wbp w, char *val);
   int	setleading	(wbp w, int i);
   int	setlinestyle	(wbp w, char *s);
   int	setlinewidth	(wbp w, LONG linewid);
   int	setpointer	(wbp w, char *val);
   int	setwidth	(wbp w, SHORT new_width);
   int	setwindowlabel	(wbp w, char *val);
   int	strimage	(wbp w, int x, int y, int width, int height,
			   struct palentry *e, unsigned char *s,
			   word len, int on_icon);
   void	toggle_fgbg	(wbp w);
   int	walert		(wbp w, int volume);
   void	warpPointer	(wbp w, int x, int y);
   int	wclose		(wbp w);
#ifndef MSWindows
   void	wflush		(wbp w);
#endif
   int	wgetq		(wbp w, dptr res, int t);
   FILE	*wopen		(char *nm, struct b_list *hp, dptr attr, int n, int *e, int is_3d, int is_gl);
#ifdef Graphics3D
   FILE	*wopengl	(char *nm, struct b_list *hp, dptr attr, int n,int *e);
#endif					/* Graphics3D */

   int	wputc		(int ci, wbp w);
#if HAVE_LIBPNG
   int writePNG(wbp w, char *filename, int x, int y, int width, int height);
#endif					/* HAVE_LIBJPEG */
#if HAVE_LIBJPEG
   int writeJPEG(wbp w, char *filename, int x, int y, int width, int height);
#endif					/* HAVE_LIBJPEG */
   void	wsync		(wbp w);
   void	xdis		(wbp w, char *s, int n);

   #ifdef ConsoleWindow
      FILE* OpenConsole		(void);
      int   Consolefprintf	(FILE *file, const char *format, ...);
      int   Consoleputc		(int c, FILE *file);
      int   Consolefflush	(FILE *file);
   #endif				/* ConsoleWindow */

   #ifdef MacGraph
      /*
       * Implementation routines specific to Macintosh
       */
      void hidecrsr (wsp ws);
      void showcrsr (wsp ws);
      void UpdateCursorPos(wsp ws, wcp wc);
      void GetEvents (void);
      void DoEvent (EventRecord *eventPtr);
      void DoMouseUp (EventRecord *eventPtr);
      void DoMouseDown (EventRecord *eventPtr);
      void DoGrowWindow (EventRecord *eventPtr, WindowPtr whichWindow);
      void GetLocUpdateRgn (WindowPtr whichWindow, RgnHandle localRgn);
      void DoKey (EventRecord *eventPtr, WindowPtr whichWindow);
      void EventLoop(void);
      void HandleMenuChoice (long menuChoice);
      void HandleAppleChoice (short item);
      void HandleFileChoice (short item);
      void HandleOptionsChoice (short item);
      void DoUpdate (EventRecord *eventPtr);
      void DoActivate (WindowPtr whichWindow, Boolean becomingActive);
      void RedrawWindow (WindowPtr whichWindow);
      const int ParseCmdLineStr (char *s, char *t, char **argv);
      pascal OSErr SetDialogDefaultItem (DialogPtr theDialog, short newItem) =
         { 0x303C, 0x0304, 0xAA68 };
      pascal OSErr SetDialogCancelItem (DialogPtr theDialog, short newItem) =
         { 0x303C, 0x0305, 0xAA68 };
      pascal OSErr SetDialogTracksCursor (DialogPtr theDialog, Boolean tracks) =
         { 0x303C, 0x0306, 0xAA68 };

      void drawarcs(wbinding *wb, XArc *arcs, int narcs);
      void drawlines(wbinding *wb, XPoint *points, int npoints);
      void drawpoints(wbinding *wb, XPoint *points, int npoints);
      void drawrectangles(wbp wb, XRectangle *recs, int nrecs);
      void drawsegments(wbinding *wb, XSegment *segs, int nsegs);
      void fillarcs(wbp wb, XArc *arcs, int narcs);
      void fillpolygon(wbp wb, XPoint *pts, int npts);
   #endif				/* MacGraph */

   #ifdef XWindows
      /*
       * Implementation routines specific to X-Windows
       */
      void	unsetclip		(wbp w);
      void	moveWindow		(wbp w, int x, int y);
      int	moveResizeWindow	(wbp w, int x, int y, int wd, int h);
      int	resetfg			(wbp w);
      int	setfgrgb		(wbp w, int r, int g, int b);
      int	setbgrgb		(wbp w, int r, int g, int b);

      XColor	xcolor			(wbp w, LinearColor clr);
      LinearColor	lcolor		(wbp w, XColor color);
      int	pixmap_open		(wbp w, dptr attribs, int argc);
      int	pixmap_init		(wbp w);
      int	remap			(wbp w, int x, int y);
      int	seticonimage		(wbp w, dptr dp);
      void	makeIcon		(wbp w, int x, int y);
      int	translate_key_event	(XKeyEvent *k1, char *s, KeySym *k2);
      int	handle_misc		(wdp display, wbp w);
      wdp	alc_display		(char *s);
      void	free_display		(wdp wd);
      wfp	alc_font		(wbp w, char **s);
      wfp	tryfont			(wbp w, char *s);
      wclrp	alc_rgb			(wbp w, char *s, unsigned int r,
					   unsigned int g, unsigned int b,
					   int is_iconcolor);
      wclrp	alc_rgb2		(wbp w, char *s, unsigned int r,
					   unsigned int g, unsigned int b);
      wclrp	alc_rgbTrueColor	(wbp w,unsigned long r,
					   unsigned long g, unsigned long b);
      int	alc_centry		(wdp wd);
      wclrp	alc_color		(wbp w, char *s);
      void	copy_colors		(wbp w1, wbp w2);
      void	free_xcolor		(wbp w, unsigned long c);
      void	free_xcolors		(wbp w, int extent);
      int	go_virtual		(wbp w);
      int	resizePixmap		(wbp w, int width, int height);
      void	wflushall		(void);
      void postcursor(wbp);
      void scrubcursor(wbp);
      void mkfont			(char *s, char is_3D);
#ifdef HAVE_XFT
      void drawstrng(wbp w, int x, int y, char *str, int slen);
#endif					/* HAVE_XFT */

   #endif				/* XWindows */

   int setglXVisual(wdp wd);

   #ifdef Graphics3D
      int init_3dcanvas(wbp  w);
      void apply_texmodechange(wbp w);
      int add_3dfont(char *fname, int fsize, char ftype);
      int c_traverse(struct b_list *hp, struct descrip * res, int position);
      int cpp_drawstring3d(double x, double y, double z, char *s, char *f,
			   int t, int size, void *tfont);
      void cube(double length, double x, double y, double z, int gen);
      void cylinder(double radius1, double radius2, double height,
		double x,  double y, double z, int slices, int rings, int gen);
      void disk(double radius1, double radius2, double angle1, double angle2,
	        double x, double y, double z, int slices, int rings, int gen);
      int drawpoly(wbp w, double* v, int num, int type, int dim);
      int drawstrng3d(wbp w, double x, double y, double z, char *s);
      int fileimage(wbp w, char* filename);
      int getlight(int light, char* buf);
      int getmaterials(char* buf);
      void getmeshmode(wbp w, char *answer);
      int gettexcoords(wbp w, char *buf);
      void gettexmode(wbp w, char *abuf, dptr answer);
      int gettexture(wbp w, dptr dp);
      int imagestr(wbp w, char* str);
      int init_3dcontext(wcp wc);
#ifdef HAVE_LIBGL
      int init_texnames(wcp wc);
#endif
      int copy_3dcontext(wcp wc, wcp rv);
      void makecurrent(wbp w);
      int make_enough_texture_space(wdp wc);
      int popmatrix();
      int pushmatrix();
      int pushmatrix_rd(wbp w, dptr f);
      int redraw3D(wbp w);
      int release_3d_resources(wbp w);
      int rotate(wbp w, dptr argv, int i, dptr f);
      int scale(wbp w, dptr argv, int i, dptr f);
      int section_length(wbp w);
      int setdim(wbp w, char* s);
      int seteye(wbp w, char *s);
      int seteyedir(wbp w, char *s);
      int seteyepos(wbp w, char *s);
      int seteyeup(wbp w, char *s);
      int setfov(wbp w, char* s);
      int setlight(wbp w, char* s, int light);
      int setlinewidth3D(wbp w, LONG linewid);
      int setmaterials(wbp w, char* s);
      int setmatrixmode(char *s);
      int setmeshmode(wbp w, char* s);
      int setnormode(wbp w, char* s);
      int setrings(wbp w, char *s);
      int setselectionmode(wbp w, char* s);
      int setslices(wbp w, char *s);
      int settexcoords(wbp w, char* s);
      int settexmode(wbp w, char* s);
      int settexture(wbp w, char* str, int len, struct descrip *f, int curtex, 
		     int is_init);
      void sphere(double radius, double x, double y, double z,
		  int slices, int rings, int gen);
      wfp srch_3dfont(char *fname, int fsize, char ftype);
      int TexDrawLine(wbp w, int texhandle, int x1, int y1, int x2, int y2);
      int TexDrawRect(wbp w, int texhandle, int x, int y, int width, int height);
      int TexFillRect(wbp w, int texhandle, int x, int y, int width, int height,
		     int isfg);
      int TexDrawPoint(wbp w, int texhandle, int x, int y);
      int TexReadImage(wbp w, int texhandle, int x, int y,struct imgdata *imd);
      int TexCopyArea(wbp w, wbp w2, int texhandle, int x, int y, int width, 
		      int height, int xt, int yt, int width2, int height2);
      int copyareaTexToTex(wbp w, int texhandle, int dest_texhandle,
      		     int x, int y, int width, int height, int xt, int yt);
      int texwindow2D(wbp w, wbp w2d);
      int texwindow3D(wbp w1, wbp w2);
      void torus(double radius1, double radius2, double x,double y, double z,
		 int slices, int rings, int gen);
      int translate(wbp w, dptr argv, int i, dptr f);
      int traversefunctionlist(wbp w);
      int create3Dlisthdr(dptr dp, char *strname, word size);

      int identitymatrix();
      int setautogen(wbp w, int i);
      int create3Dcontext(wbp w);
      void initializeviewport(int w, int h);
      int destroycontext(wbp w);
      int copytextures(wcp wc1, wcp wc2);
      void swapbuffers(wbp w, int flush);
      void erasetocolor(int r,int g,int b);
      void bindtexture(wbp w, int texturehandle);
      void applyAutomaticTextureCoords(int enable);
      void applymatrix(wbp w, double a[]);
      int create_display_list(wbp w, int size);     
   #endif					/* Graphics3D */

   #ifdef GraphicsGL
      /*
       * Implementation routines specific to OpenGL for 2D facilities
       */
      int create_display_list2d(wbp w, int size);
      dptr rec_structor2d(int type);
      dptr rec_structor2dinit(dptr dp, char *name, int nfields, char *field_names[]);
      int traversefunclist2d(wbp w);
      int updaterendercontext(wbp w, int intcode);

      int init_2dcanvas(wbp w);
      int init_canvas(wbp w);
      int init_2dcontext(wcp wc);
      int copy_2dcontext(wcp wcdest, wcp wcsrc);

      int get_tex_index(wdp wd, unsigned int ntex);
      int delete_first_tex(wdp wd, unsigned int ndel);
      int delete_last_tex(wdp wd, unsigned int ndel);

      int drawgeometry2d(wbp w, struct b_record *rp);
      int drawblimage2d(wbp w, struct b_record *rp);
      int drawreadimage2d(wbp w, struct b_record *rp);
      int drawstrimage2d(wbp w, struct b_record *rp);
      int copyarea2d(wbp w, struct b_record *rp);
      int erasearea2d(wbp w, struct b_record *rp);

      int setcolor2d(wbp w, struct b_record *rp, int type);
      int setdrawop2d(wbp w, struct b_record *rp);
      int setgamma2d(wbp w, struct b_record *rp);
      int togglefgbg2d(wbp w);

      int setlinewidth2d(wbp w, struct b_record *rp);
      int setlinestyle2d(wbp w, struct b_record *rp);
      int setfillstyle2d(wbp w, struct b_record *rp);
      int setpattern2d(wbp w, struct b_record *rp);

      int setclip2d(wbp w, struct b_record *rp);
      int setdx2d(wbp w, struct b_record *rp);
      int setdy2d(wbp w, struct b_record *rp);
      int setfont2d(wbp w, struct b_record *rp);
      int setleading2d(wbp w, struct b_record *rp);
      int drawstring2d(wbp w, struct b_record *rp);
      int drawstringhelper(wbp w, double x, double y, double z, char *s, int len, int fill, int draw);

      /* 
       * 2D API
       */

      /* 
       * Rendering functions
       */
      int gl_blimage(wbp w, int x, int y, int width, int height, int ch, unsigned char *s, word len);
      int gl_readimage(wbp w, char *filename, int x, int y, int *status);
      int gl_strimage(wbp w, int x, int y, int width, int height, struct palentry *e, unsigned char *s, word len, int on_icon);
      int gl_drawstrng(wbp w, int x, int y, char *s, int slen);
      int gl_xdis(wbp w, char *s, int s_len);
      int gl_copyArea(wbp w1, wbp w2, int x, int y, int width, int height, int x2, int y2);
      int gl_eraseArea(wbp w, int x, int y, int width, int height);
      int gl_arcs(wbp w, XArc *arcs, int n, int circle, int fill);
      int gl_fillarcs(wbp w, XArc *arcs, int n);
      int gl_drawarcs(wbp w, XArc *arcs, int n);
      int gl_fillcircles(wbp w, XArc *arcs, int n);
      int gl_drawcircles(wbp w, XArc *arcs, int n);
      int gl_rectangles(wbp w, XRectangle *recs, int n, int fill);
      int gl_fillrectangles(wbp w, XRectangle *recs, int n);
      int gl_drawrectangles(wbp w, XRectangle *recs, int n);
      int gl_drawlines(wbp w, XPoint *points, int n);
      int gl_drawpoints(wbp w, XPoint *points, int n);
      int gl_drawsegments(wbp w, XSegment *segs, int n);
      int gl_fillpolygon(wbp w, XPoint *pts, int n);

      int gl_dumpimage(wbp w, char *filename, unsigned int x, unsigned int y, unsigned int width, unsigned int height);
      int gl_getimstr(wbp w, int x, int y, int width, int height, struct palentry *ptbl, unsigned char *data);
      int gl_getimstr24(wbp w, int xx, int yy, int width, int height, unsigned char *data);
      int gl_getpixel_init(wbp w, struct imgmem *imem);
      int gl_getpixel_term(wbp w, struct imgmem *imem);
      int gl_getpixel(wbp w, int x, int y, long *rv, char *s, struct imgmem *imem);
      char *gl_loadimage(wbp w, char *filename, unsigned int *height, unsigned int *width, int atorigin, int *is_pixmap);

      /* 
       * Context functions
       */
      void gl_getfg(wbp w, char *s);
      void gl_getbg(wbp w, char *s);
      void gl_getdrawop(wbp w, char *s);
      void gl_getlinestyle(wbp w, char *s);
      void gl_getfntnam(wbp w, char *s);
      char *gl_get_mutable_name(wbp w, int mute_index);
      int gl_set_mutable(wbp w, int mute_index, char *s);
      void gl_free_mutable(wbp w, int mute_index);
      int gl_mutable_color(wbp w, dptr argv, int warg, int *rv);
      struct color *find_mutable(wbp w, int index);
      struct color *alc_mutable_color(wbp w);
      void free_mutables(wdp wd);

      int gl_color(wbp w, int intcode, int mindex, char *s);
      int gl_setbgrgb(wbp w, int r, int g, int b);
      int gl_setfgrgb(wbp w, int r, int g, int b);
      int gl_isetbg(wbp w, int mindex);
      int gl_isetfg(wbp w, int mindex);
      int gl_setbg(wbp w, char *s);
      int gl_setfg(wbp w, char *s);
      int gl_setdrawop(wbp w, char *s);
      int gl_setleading(wbp w, int i);
      int gl_setlinestyle(wbp w, char *s);
      int gl_setlinewidth(wbp w, LONG lwidth);
      int gl_SetPattern(wbp w, char *name, int len);
      int gl_setfillstyle(wbp w, char *s);
      int gl_setfont(wbp w, char **s);
      wfp gl_alc_font(wbp w, char **s, int len);
      int gl_setgamma(wbp w, double gamma);
      int gl_setclip(wbp w);
      int gl_unsetclip(wbp w);
      int gl_setdx(wbp w);
      int gl_setdy(wbp w);
      int gl_toggle_fgbg(wbp w);

      /*
       * Windowing functions (platform-neutral)
       */
      int gl_allowresize(wbp w, int on);
      char gl_child_window_stuff(wbp w, wbp wp, int child_window);
      wcp gl_clone_context(wbp w);
      int gl_rebind(wbp w, wbp w2);
      int gl_resizePixmap(wbp w, int width, int height);
      int gl_setcursor(wbp w, int on);
      int gl_wputc(int c, wbp w);

      /*
       * Windowing functions (platform-specific)
       */
      wcp gl_alc_context(wbp w);
      wdp gl_alc_display(char *s);
      wsp gl_alc_winstate();
      void gl_free_context(wcp wc);
      void gl_free_display(wdp wd);
      int gl_free_window(wsp ws);
      void gl_freecolor(wbp w, char *s);
      int gl_do_config(wbp w, int status);
      void gl_getcanvas(wbp w, char *s);
      int gl_getdefault(wbp w, char *prog, char *opt, char *answer);
      void gl_getdisplay(wbp w, char *s);
      void gl_geticonic(wbp w, char *s);
      int gl_geticonpos(wbp w, char *s);
      void gl_getpointername(wbp w, char *s);
      int gl_getpos(wbp w);
      int gl_getvisual(wbp w, char *s);
      int gl_nativecolor(wbp w, char *s, long *r, long *g, long *b);
      int gl_lowerWindow(wbp w);
      int gl_raiseWindow(wbp w);
      int gl_setcanvas(wbp w, char *s);
      int gl_setdisplay(wbp w, char *s);
      int gl_seticonicstate(wbp w, char *s);
      int gl_seticonimage(wbp w, dptr dp);
      int gl_seticonlabel(wbp w, char *s);
      int gl_seticonpos(wbp w, char *s);
      int gl_setimage(wbp w, char *s);
      int gl_setpointer(wbp w, char *s);
      int gl_setwidth(wbp w, SHORT new_width);
      int gl_setheight(wbp w, SHORT new_height);
      int gl_setgeometry(wbp w, char *s);
      int gl_setwindowlabel(wbp w, char *s);
      int gl_query_pointer(wbp w, XPoint *xp);
      int gl_query_rootpointer(XPoint *xp);
      int gl_walert(wbp w, int volume);
      void gl_warpPointer(wbp w, int x, int y);
      int gl_wclose(wbp w);
      void gl_wflush(wbp w);
      void gl_wflushall();
      int gl_wgetq(wbp w, dptr res, int t);
      FILE *gl_wopen(char *name, struct b_list *lp, dptr attrs, int n, int *err_index, int is_3d);
      int gl_wmap(wbp w);
      void gl_wsync(wbp w);
   #endif 					/* GraphicsGL */

   #ifdef MSWindows
      wdp	alc_display		(char *s);
      /*
       * Implementation routines specific to MS Windows
       */
      int playmedia		(wbp w, char *s);
      char *nativecolordialog	(wbp w,long r,long g, long b,char *s);
      int nativefontdialog	(wbp w, char *buf, int flags, int fheight,char*colr);
      char *nativeselectdialog	(wbp w,struct b_list *,char *s);
      char *nativefiledialog	(wbp w, char *s1, char *s2, char *s3,
				 char *s4, int i, int j, int k);
      HFONT mkfont		(char *s, char is_3D);
      int sysTextWidth		(wbp w, char *s, int n);
      int sysFontHeight		(wbp w);
      int mswinsystem		(char *s);
      void UpdateCursorPos	(wsp ws, wcp wc);
      LRESULT_CALLBACK WndProc	(HWND, UINT, WPARAM, LPARAM);
      HDC CreateWinDC		(wbp);
      HDC CreatePixDC		(wbp, HDC);
      HBITMAP loadimage	(wbp wb, char *filename, unsigned int *width,
      			unsigned int *height, int atorigin, int *status);
      void wfreersc();
      int getdepth(wbp w);
      HBITMAP CreateBitmapFromData(char *data);
      int resizePixmap(wbp w, int width, int height);
      int textWidth(wbp w, char *s, int n);
      int	seticonimage		(wbp w, dptr dp);
      int devicecaps(wbp w, int i);
      void fillarcs(wbp wb, XArc *arcs, int narcs);
      void drawarcs(wbp wb, XArc *arcs, int narcs);
      void drawlines(wbinding *wb, XPoint *points, int npoints);
      void drawpoints(wbinding *wb, XPoint *points, int npoints);
      void drawrectangles(wbp wb, XRectangle *recs, int nrecs);
      void fillpolygon(wbp w, XPoint *pts, int npts);
      void drawsegments(wbinding *wb, XSegment *segs, int nsegs);
      void drawstrng(wbinding *wb, int x, int y, char *s, int slen);
      void unsetclip(wbp w);

      void makebutton(wsp ws, childcontrol *cc, char *s);
      void makescrollbar(wsp ws, childcontrol *cc, char *s, int i1, int i2);
      int nativemenubar(wbp w, int total, int argc, dptr argv, int warg, dptr d);
      void makeeditregion(wbp w, childcontrol *cc, char *s);
      void cleareditregion(childcontrol *cc);
      void copyeditregion(childcontrol *cc);
      void cuteditregion(childcontrol *cc);
      void pasteeditregion(childcontrol *cc);
      int undoeditregion(childcontrol *cc);
      int modifiededitregion(childcontrol *cc);
      int setmodifiededitregion(childcontrol *cc, int i);
      void geteditregion(childcontrol *cc, dptr d);
      void seteditregion(childcontrol *cc, char *s2);
      void movechild(childcontrol *cc,
	             C_integer x, C_integer y, C_integer width, C_integer height);
      int setchildfont(childcontrol *cc, char *fontname);
      void setfocusonchild(wsp ws, childcontrol *cc, int width, int height);
      void setchildselection(wsp ws, childcontrol *cc, int x, int y);
      void getchildselection(wsp ws, childcontrol *cc, word *x, word *y);
      int sysScrollWidth();

      void waitkey(FILE *w);


      /* defined in src/common */
      int pathOpenHandle(char *fname, char *mode);
      void closelog();

#endif				/* MSWindows */

#endif					/* Graphics */


#ifdef Audio
int StartAudioThread(char filename[]);
void StopAudioThread(int index);
int AudioMixer(char * cmd);
void audio_exit();
struct AudioFile * StartMP3Thread(char filename[]);
struct AudioFile * StartWAVThread(char filename[]);
struct AudioFile * StartOggVorbisThread(char filename[]);
#endif					/* Audio */

/*
 * Prototypes for the run-time system.
 */

struct b_external *alcextrnl	(int n);
#ifdef MultiProgram
struct b_record *alcrecd_0	(int nflds,union block *recptr);
struct b_record *alcrecd_1	(int nflds,union block *recptr);
struct b_tvsubs *alcsubs_0	(word len,word pos,dptr var);
struct b_tvsubs *alcsubs_1	(word len,word pos,dptr var);
#else					/* MultiProgram */
struct b_record *alcrecd	(int nflds,union block *recptr);
struct b_tvsubs *alcsubs	(word len,word pos,dptr var);
#endif					/* MultiProgram */
int	bfunc		(void);
dptr	calliconproc	(struct descrip proc, dptr args, int nargs);
long	ckadd		(long i, long j);
long	ckmul		(long i, long j);
long	cksub		(long i, long j);
void	cmd_line	(int argc, char **argv, dptr rslt);
struct b_coexpr *create	(continuation fnc,struct b_proc *p,int ntmp,int wksz);
int	collect		(int region);
#ifdef CoClean
void coclean(struct b_coexpr *cp);
#endif
void	cotrace		(struct b_coexpr *ccp, struct b_coexpr *ncp,
			   int swtch_typ, dptr valloc);
#ifdef MultiProgram
void	deref_0		(dptr dp1, dptr dp2);
void	deref_1		(dptr dp1, dptr dp2);
#else					/* MultiProgram */
void	deref		(dptr dp1, dptr dp2);
#endif					/* MultiProgram */
void	envset		(void);
int	eq		(dptr dp1,dptr dp2);
int	fixtrap		(void);
int	get_name	(dptr dp1, dptr dp2);
int	getch		(void);
int	getche		(void);
double	getdbl		(dptr dp);
int	getimage	(dptr dp1, dptr dp2);
int	getstrg		(char *buf, int maxi, struct b_file *fbp);
void	hgrow		(union block *bp);
void	hshrink		(union block *bp);
C_integer iipow		(C_integer n1, C_integer n2, int *over_flowp);
void	init		(char *name, int *argcp, char *argv[], int trc_init);
int	kbhit		(void);
int	nthcmp		(dptr d1,dptr d2);
void	nxttab		(C_integer *col, dptr *tablst, dptr endlst,
			   C_integer *last, C_integer *interval);
int	order		(dptr dp, int sortType);
int	pathFind	(char target[], char buf[], int n);
int	printable	(int c);
int	ripow		(double r, C_integer n, dptr rslt);
void	rtos		(double n,dptr dp,char *s);
int	sig_rsm		(void);
struct b_proc *strprc	(dptr s, C_integer arity);
int	subs_asgn	(dptr dest, const dptr src);
int	tvmonitored_asgn(dptr dest, const dptr src);
int	trcmp3		(struct dpair *dp1,struct dpair *dp2);
int	trefcmp		(dptr d1,dptr d2);
int	tvalcmp		(dptr d1,dptr d2);
int	tvcmp4		(struct dpair *dp1,struct dpair *dp2);
int	tvtbl_asgn	(dptr dest, const dptr src);
void	varargs		(dptr argp, int nargs, dptr rslt);

#ifdef MultiProgram
   struct b_coexpr *alccoexp (long icodesize, long stacksize);
#else					/* MultiProgram */
   struct b_coexpr *alccoexp (void);
#endif					/* MultiProgram */

dptr rec_structinate(dptr dp, char *name, int nfields, char *a[]);

#ifdef Messaging
struct MFile* Mopen(URI* puri, dptr attr, int nattr, int shortreq, int status);
int Mclose(struct MFile* mf);
int Mpop_delete(struct MFile* mf, unsigned int msgnum);
void Mstartreading(struct MFile* mf);
#endif					/* Messaging */

#ifdef PosixFns
#if NT
FILE *mstmpfile();
void closetmpfiles();
int is_internal(char *s);
int StartupWinSocket(void);
void stat2rec			(struct _stat *st, dptr dp, struct b_record **rp);
#else					/* NT */
void stat2rec			(struct stat *st, dptr dp, struct b_record **rp);
dptr make_pwd			(struct passwd *pw, dptr result);
dptr make_group			(struct group *pw, dptr result);
#endif					/* NT */

dptr rec_structor		(char *s);
dptr rec_structor3d		(int type);
int sock_connect		(char *s, int udp, int timeout, int af_fam);
int sock_getstrg		(char *buf, int maxi, SOCKET fd);
int getmodefd			(int fd, char *mode);
int getmodenam			(char *path, char *mode);
int get_uid			(char *name);
int get_gid			(char *name);
#if !NT
dptr make_pwd			(struct passwd *pw, dptr result);
dptr make_group			(struct group *pw, dptr result);
#endif					/* NT */

dptr make_host			(struct hostent *pw, dptr result);

#ifdef HAVE_GETADDRINFO
dptr make_host_from_addrinfo(char *name, struct addrinfo *inforesult, dptr result);
#endif
struct addrinfo *uni_getaddrinfo(char* addr, char* p, int is_udp, int family);
void 		set_gaierrortext(int i);

dptr make_serv			(struct servent *pw, dptr result);
int sock_listen			(char *s, int udp, int af_fam);
int sock_name			(int sock, char* addr, char* addrbuf, int bufsize);
int sock_me			(int sock, char* addrbuf, int bufsize);
int sock_send			(char* addr, char* msg, int msglen, int af_fam);
int sock_recv			(int f, struct b_record **rp);
int sock_write			(int f, char *s, int n);
struct descrip register_sig	(int sig, struct descrip handler);
void signal_dispatcher		(int sig);
int get_fd			(struct descrip, unsigned int errmask);
dptr u_read			(dptr f, int n, int fstatus, dptr d);
void dup_fds			(dptr d_stdin, dptr d_stdout, dptr d_stderr);
int set_if_selectable		(struct descrip *f, fd_set *fdsp, int *n);
void post_if_ready		(dptr ldp, dptr f, fd_set *fdsp);
#endif					/* PosixFns */

#if COMPILER

   struct b_refresh *alcrefresh	(int na, int nl, int nt, int wk_sz);
   int  apply			(dptr, dptr, dptr, continuation);
   void	atrace			(void);
   void	ctrace			(void);
   void dynrec_start_set	(word);
   void	failtrace		(void);
   void	initalloc		(void);
   int	invoke			(int n, dptr args, dptr rslt, continuation c);
   void	rtrace			(void);
   void	strace			(void);
   void	tracebk			(struct p_frame *lcl_pfp, dptr argp, FILE *fd);
   int	xdisp			(struct p_frame *fp, dptr dp, int n, FILE *f);

#else					/* COMPILER */

#ifdef MultiProgram
   struct b_refresh *alcrefresh_0(word *e, int nl, int nt);
   struct b_refresh *alcrefresh_1(word *e, int nl, int nt);
#else					/* MultiProgram */
   struct b_refresh *alcrefresh	(word *e, int nl, int nt);
#endif					/* MultiProgram */
   void	atrace			(dptr dp);
   void	ctrace			(dptr dp, int nargs, dptr arg);
   void	failtrace		(dptr dp);
   int	invoke			(int nargs, dptr *cargs, int *n);
   void	rtrace			(dptr dp, dptr rval);
   void	strace			(dptr dp, dptr rval);
   void	tracebk			(struct pf_marker *lcl_pfp, dptr argp, FILE *fd);
   int	xdisp			(struct pf_marker *fp, dptr dp, int n, FILE *f);

   #define Fargs dptr cargp
   int	Obscan			(int nargs, Fargs);
   int	Ocreate			(word *entryp, Fargs);
   int	Oescan			(int nargs, Fargs);
   int	Ofield			(int nargs, Fargs);
   int	Omkrec			(int nargs, Fargs);
   int	Olimit			(int nargs, Fargs);
   int	Ollist			(int nargs, Fargs);

   #ifdef MultiProgram
      void	initalloc	(word codesize, struct progstate *p);
   #else				/* MultiProgram */
      void	initalloc	(word codesize);
   #endif				/* MultiProgram */

#endif					/* COMPILER */

/* dynamic records */
struct b_proc *dynrecord(dptr s, dptr fields, int n);

#ifdef ISQL
FILE   *isql_open (char *, dptr, dptr, dptr);
int     dbclose(struct ISQLFile *);
int     dbfetch(struct ISQLFile *, dptr);
void    odbcerror               (struct ISQLFile *fp, int errornum);
void    qalloc                  (struct ISQLFile *f, long n); /* query space alloc */
#endif					/* ISQL */

#ifdef DebugHeap
void heaperr(char *msg, union block *p, int t);
#endif					/* DebugHeap */

#ifdef LoadFunc
int makefunc	(dptr d, char *name, int (*func)());
#endif					/* LoadFunc */

#ifdef Arrays
struct b_intarray *alcintarray(uword n);
struct b_realarray *alcrealarray(uword n);
#endif					/* Arrays */

#ifdef PthreadCoswitch
void makesem(struct b_coexpr *cp);
void *nctramp(void *arg);
void handle_thread_error(int val, int func, char* msg);
#endif					/* PthreadCoswitch */

void init_threadstate(struct threadstate *ts);

#ifdef Concurrent 
#ifndef HAVE_KEYWORD__THREAD
struct threadstate *get_tstate();
#endif					/* HAVE_KEYWORD__THREAD */
void thread_control(int action);
void clean_threads();
void init_threads();
int msg_receive( dptr dccp, dptr dncp, dptr msg, int timeout);
int msg_send( dptr dccp, dptr dncp, dptr msg, int timeout);
word get_mutex( pthread_mutexattr_t *mattr);
word get_cv(word mtx);
#if COMPILER
void init_threadheap(struct threadstate *ts, word blksiz, word strsiz);
#else					/* COMPILER */
void init_threadheap(struct threadstate *ts, word blksiz, word strsiz,
			struct progstate *newp);
#endif					/* COMPILER */
int alcce_queues(struct b_coexpr *ep);
struct region *swap2publicheap(struct region * curr_private, 
			       struct region * curr_public, 
			       struct region ** p_public);
#endif					/* Concurrent */

struct region *newregion(word nbytes,word stdsize);


#ifdef MultiProgram
void init_sighandlers(struct progstate *pstate);
#else					/* MultiProgram */
void init_sighandlers();
#endif					/* MultiProgram */

#if UNIX && defined(HAVE_WORKING_VFORK)
void push_filepid(int pid, FILE *fp, word status);
#endif 	    		     	  /* UNIX && defined(HAVE_WORKING_VFORK */

#ifdef DescripAmpAllocated
int bigaddi      (dptr da, word i, dptr dx);
int bigsubi      (dptr da, word i, dptr dx);
int checkTypeInt (dptr da1, dptr da2, word n );
#endif					/* DescripAmpAllocated */

char * getenv_var(const char *name);

#if HAVE_LIBSSL
#define TLS_SERVER 1
#define TLS_CLIENT 2
#define DTLS_SERVER 3
#define DTLS_CLIENT 4

SSL_CTX* create_ssl_context(dptr attr, int n, int type);
void set_ssl_connection_errortext(SSL *ssl, int err);
void set_ssl_context_errortext(int err, char* errtext);
void set_errortext_with_val(int i, char* errval);
#endif					/* HAVE_LIBSSL */
