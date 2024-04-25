/*
 * Prototypes for functions in icont.
 */

void	addinvk			(char *name, int n);
void	addlfile		(char *name);
pointer	alloc			(unsigned int n);
void	alsolink		(char *name);
int	blocate			(word s);
struct	node *c_str_leaf	(int type,struct node *loc_model, char *c);
void	closelog		();
void	codegen			(struct node *t);
void	constout		(FILE *fd);
void	dummyda			(void);
int	file_comp		(char *filename);
struct	fentry *flocate		(word id);
struct	fileparts *fparse	(char *s);
void	gencode			(void);
void	gentables		(void);
int	getdec			(void);
int	getopr			(int ac, int *cc);
word	getid			(void);
word	getint			(int i, word *wp);
int	getlab			(void);
struct	lfile *getlfile		(struct lfile * *lptr);
int	getoct			(void);
int	getopc			(char * *id);
double	getreal			(void);
word	getrest			(void);
word	getstr			(void);
word	getstrlit		(int l);
word	getsynt			(char **);
struct	gentry *glocate		(word id);
void	gout			(FILE *fd);
struct	node *i_str_leaf	(int type,struct node *loc_model,char *c,int d);
int	ilink			(char * *ifiles,char *outname);
void	initglob		(void);
void	install			(char *name,int flag,int argcnt);
word	instid			(char *s);
struct	node *int_leaf		(int type,struct node *loc_model,int c);
int	klookup			(char *id);
int	lexeql			(int l,char *s1,char *s2);
void	lfatal			(char *s1,char *s2);
void	linit			(void);
void	lmfree			(void);
void	loc_init		(void);
void	locinit			(void);
int	lookup_linked_uid       (char *uid);
void	lout			(FILE *fd);
void	lwarn			(char *s1,char *s2,char *s3);
char	*makename		(char *dest,char *d,char *name,char *e);
void	newline			(void);
int	nextchar		(void);
void	nfatal			(struct node *n,char *s1,char *s2);
void	openlog			(char *p);
void	putconst		(int n,int flags,int len,word pc, union xval *valp);
void	putfield		(word fname,struct gentry *gp,int fnum);
struct	gentry *putglobal	(word id,int flags,int nargs, int procid);
char	*putid			(int len);
word	putident		(int len, int install);
int	putlit			(char *id,int idtype,int len);
int	putloc			(char *id,int id_type);
void	putlocal		(int n,word id,int flags,int imperror,
				   word procname);
void	quit			(char *msg);
void	quitf			(char *msg,char *arg);
int	readglob		(struct lfile *lf);
void report			(char *s);
unsigned int round2		(unsigned int n);
void	rout			(FILE *fd,char *name);
char	*salloc			(char *s);
void	scanrefs		(void);
void	setexe			(char *fname);
void	sizearg			(char *arg,char * *argv);
int	smatch			(char *s,char *t);
pointer	tcalloc			(unsigned int m,unsigned int n);
void	tfatal			(char *s1,char *s2);
void	tmalloc			(void);
void	tmfree			(void);
void	tminit			(void);
int	trans			(char * *ifiles);
pointer trealloc		(pointer table, pointer tblfree,
                                  unsigned int *size, int unit_size,
                                  int min_units, char *tbl_name);
struct	node *tree1		(int type);
struct	node *tree2		(int type,struct node *loc_model);
struct	node *tree3		(int type,struct node *loc_model,struct node *c);
struct	node *tree4		(int type,struct node *loc_model,struct node *c,struct node *d);
struct	node *tree5		(int type,struct node *loc_model,
				   struct node *c,struct node *d,
				   struct node *e);
struct	node *tree6		(int type,struct node *loc_model,
				   struct node *c, struct node *d,
				   struct node *e,struct node *f);
struct node *buildarray		(struct node *a,struct node *lb,
					struct node *e, struct node *rb);
void	treeinit		(void);
#if __clang__
/* Declaring tsyserr as noreturn stops clang from emitting false positive 
      "uninitialized variable" warning messages   */
void    tsyserr    (char *s) __attribute__ ((noreturn,nothrow));
#else
void	tsyserr			(char *s);
#endif
void	twarn			(char *s1, char *s2);

void	writecheck		(int rc);
void	yyerror			(char *s,int state);
int	yylex			(void);
int	yyparse			(void);

#ifdef MultipleRuns
void	tcodeinit		(void);
void yylexinit		(void);
#endif					/* MultipleRuns */


#ifdef DeBugTrans
void	cdump			(void);
void	gdump			(void);
void	ldump			(void);
#endif					/* DeBugTrans */

#ifdef DeBugLinker
void	idump			(char *c);
#endif					/* DeBugLinker */

int	SyntCode(char *);

int add_linked_file(char * file);
