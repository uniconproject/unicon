/*
 * Structures for symbol table entries.
 */

#define MaybeTrue  1 /* condition might be true at run time */
#define MaybeFalse 2 /* condition might be false at run time */

#define MayConvert 1 /* type conversion may convert the value */
#define MayDefault 2 /* defaulting type conversion may use default */
#define MayKeep    4 /* conversion may succeed without any actual conversion */

/*
 * Data base type codes are mapped to type inferencing information using
 *  an array.
 */
struct typ_info {
   int frst_bit;      /* first bit in bit vector allocated to this type */
   int num_bits;      /* number of bits in bit vector allocated to this type */
   int new_indx;      /* index into arrays of allocated types for operation */
   typeinfo_t * typ;
   };

/*
 * A type is a bit vector representing a union of basic types. There
 *  are 3 sizes of types: first class types (Icon language types),
 *  intermediate value types (first class types plus variable references),
 *  run-time routine types (intermediate value types plus internal
 *  references to descriptors such as set elements). When the size of
 *  the type is known from context, a simple bit vector can be used.
 *  In other contexts, the size must be included.
 */
struct type {
   int size;
   typeinfo_t * bits;
   struct type *next;
   };

/*
 * NumInts - convert from the number of bits in a bit vector to the
 *  number of integers implementing it.
 *
 * mdw: let us shift this great divide.
 *
#define NumInts(n_bits) (n_bits - 1) / IntBits + 1
 */
#if (IntBits == 32)
#define DivIntBits(n) ((n) >> 5)
#define ModIntBits(n) ((n) & 31)
#define NumInts(nbits) ((((nbits) - 1) >> 5) + 1)
#elif (IntBits == 64)
#define DivIntBits(n) ((n) >> 6)
#define ModIntBits(n) ((n) & 63)
#define NumInts(nbits) ((((nbits) - 1) >> 6) + 1)
#else
#error ***
#error csym.h: IntBits not power of 2 >= 32.
#error ***
#endif

#if (WordBits == 32)
#define DivWordBits(n) ((n) >> 5)
#define ModWordBits(n) ((n) & 31)
#define NumWords(nbits) ((((nbits) - 1) >> 5) + 1)
#elif (WordBits == 64)
#define DivWordBits(n) ((n) >> 6)
#define ModWordBits(n) ((n) & 63)
#define NumWords(nbits) ((((nbits) - 1) >> 6) + 1)
#else
#error ***
#error csym.h: WordBits not power of 2 >= 32.
#error ***
#endif

/* mdw: vector-word defs */
/*typedef word vord;*/
typedef unsigned int vord;
#define DivVordBits DivIntBits
#define ModVordBits ModIntBits
#define NumVords NumInts
#define VordBits IntBits

struct centry {                 /* constant table entry */
   struct centry *blink;        /*   link for bucket chain */
   char *image;                 /*   pointer to string image of literal */
   int length;                  /*   length of string */
   union {
      unsigned short *cset;     /*   pointer to bit string for cset literal */
      long intgr;               /*   value of integer literal */
      } u;
   uword flag;                  /*   type of literal flag */
   char prefix[PrfxSz+1];       /*   unique prefix used in data block name */
   };

struct fentry {                 /* field table entry */
   struct fentry *blink;        /*   link for bucket chain */
   char *name;                  /*   name of field */
   struct par_rec *rlist;       /*   head of list of records */
   };

struct lentry {                 /* local table entry */
   struct lentry *blink;        /*   link for bucket chain */
   char *name;                  /*   name of variable */
   uword flag;                  /*   variable flags */
   union {
      struct gentry *global;    /*   for globals: global symbol table entry */
      int index;                /*   type index; run-time descriptor index */
      } val;
   struct lentry *next;         /*   used for linking a class of variables */
   };

struct gentry {                  /* global table entry */
   struct gentry *blink;         /*   link for bucket chain */
   char *name;                   /*   name of variable */
   uword flag;                   /*   variable flags */
   union {
      struct implement *builtin; /*   pointer to built-in function */
      struct pentry *proc;       /*   pointer to procedure entry */
      struct rentry *rec;        /*   pointer to record entry */
      } val;
   int index;                    /*   index into global array */
   int init_type;                /*   initial type if procedure */
   };

/*
 * Structure for list of parent records for a field name.
 */
struct par_rec {
   struct rentry *rec;          /* parent record */
   int offset;                  /* field's offset within this record */
   int mark;                    /* used during code generation */
   struct par_rec *next;
   };

/*
 * Structure for a procedure.
 */
struct pentry {
   char *name;                  /* name of procedure */
   char prefix[PrfxSz+1];       /* prefix to make name unique */
   struct lentry **lhash;       /* hash area for procedure's local table */
   int nargs;                   /* number of args */
   struct lentry *args;         /* list of arguments in reverse order */
   int ndynam;                  /* number of dynamic locals */
   struct lentry *dynams;       /* list of dynamics in reverse order */
   int nstatic;                 /* number of statics */
   struct lentry *statics;      /* list of statics in reverse order */
   struct node *tree;           /* syntax tree for procedure */
   int has_coexpr;              /* this procedure contains co-expressions */
   int tnd_loc;                 /* number of tended dynamic locals */
   int ret_flag;                /* proc returns, suspends, and/or fails */
   int reachable;               /* this procedure may be executed */
   int iteration;               /* last iteration of type inference performed */
   int arg_lst;                 /* for varargs - the type number of the list */
   typeinfo_t *ret_typ; /* type returned from procedure */
   struct store *in_store;      /* store at start of procedure */
   struct store *susp_store;    /* store for resumption points of procedure */
   struct store *out_store;     /* store on exiting procedure */
   struct lentry **vartypmap;   /* mapping from var types to symtab entries */
   typeinfo_t * coexprs; /* co-expressions in which proc may be called */
   struct pentry *next;
   };

/*
 * Structure for a record.
 */
struct rentry {
   char *name;                  /* name of record */
   char prefix[PrfxSz+1];       /* prefix to make name unique */
   int frst_fld;                /* offset of variable type of 1st field */
   int nfields;                 /* number of fields */
   struct fldname *fields;      /* list of field names in reverse order */
   int rec_num;                 /* id number for record */
   struct rentry *next;
   };

struct fldname {                /* record field */
   char *name;                  /* field name */
   struct fldname *next;
   };

/*
 * Structure used to analyze whether a type_case statement can be in-lined.
 *  Only one type check is supported: the type_case will be implemented
 *  as an "if" statement.
 */
struct case_anlz {
   int n_cases;             /* number of cases actually needed for this use */
   int typcd;               /* for "if" optimization, the type code to check */
   struct il_code *il_then; /* for "if" optimization, the then clause */
   struct il_code *il_else; /* for "if" optimization, the else clause */
   };

/*
 * spec_op contains the implementations for operations with do not have
 *  standard unary/binary syntax.
 */
#define ToOp      0  /* index into spec_op of i to j */
#define ToByOp    1  /* index into spec_op of i to j by k */
#define SectOp    2  /* index into spec_op of x[i:j] */
#define SubscOp   3  /* index into spec_op of x[i] */
#define ListOp    4  /* index into spec_op of [e1, e2, ... ] */
#define NumSpecOp 5
extern struct implement *spec_op[NumSpecOp];

/*
 * Flag values.
 */

#define F_Global     0000001  /* variable declared global externally */
#define F_Proc       0000004  /* procedure */
#define F_Record     0000010  /* record */
#define F_Dynamic    0000020  /* variable declared local dynamic */
#define F_Static     0000040  /* variable declared local static */
#define F_Builtin    0000100  /* identifier refers to built-in procedure */
#define F_StrInv     0000200  /* variable needed for string invocation */
#define F_ImpError   0000400  /* procedure has default error */
#define F_Argument   0001000  /* variable is a formal parameter */
#define F_IntLit     0002000  /* literal is an integer */
#define F_RealLit    0004000  /* literal is a real */
#define F_StrLit     0010000  /* literal is a string */
#define F_CsetLit    0020000  /* literal is a cset */
#define F_Field      0040000  /* identifier refers to a record field */
#define F_SmplInv    0100000  /* identifier only used in simple invocation */
#define F_Object     0200000  /* record represents a Unicon class instance */

/*
 * Symbol table region pointers.
 */

extern struct implement *bhash[];       /* hash area for built-in func table */
extern struct centry *chash[];          /* hash area for constant table */
extern struct fentry *fhash[];          /* hash area for field table */
extern struct gentry *ghash[];          /* hash area for global table */
extern struct implement *khash[];       /* hash area for keyword table */
extern struct implement *ohash[];       /* hash area for operator table */

extern struct pentry *proc_lst; /* procedure list */
extern struct rentry *rec_lst;  /* record list */

extern int max_sym; /* max number of parameter symbols in run-time routines */
extern int max_prm; /* max number of parameters for any invocable routine */

extern struct symtyps *cur_symtyps; /* maps run-time routine symbols to types */
extern struct pentry *cur_proc; /* procedure currently being translated */

/*
 * Hash functions for symbol tables. Note, hash table sizes (xHSize)
 *  are all a power of 2.
 */

#define CHasher(x)      (((word)x)&(CHSize-1))   /* constant symbol table */
#define FHasher(x)      (((word)x)&(FHSize-1))   /* field symbol table */
#define GHasher(x)      (((word)x)&(GHSize-1))   /* global symbol table */
#define LHasher(x)      (((word)x)&(LHSize-1))   /* local symbol table */

/*
 * flags for implementation entries.
 */
#define ProtoPrint 1  /* a prototype has already been printed */
#define InStrTbl   2  /* operator is in string table */

/*
 * Whether an operation can fail may depend on whether error conversion
 *  is allowed. The following macro checks this.
 */
#define MightFail(ret_flag) ((ret_flag & DoesFail) ||\
   (err_conv && (ret_flag & DoesEFail)))
