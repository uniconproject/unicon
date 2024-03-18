/*
 * dlrgint.c - versions of "large integer" routines for compiled programs
 *   that do not support large integers.
 */
#define COMPILER 1
#include "../h/rt.h"

/*
 *****************************************************************
 *
 * Routines in the first set are only called when large integers
 *  exist and thus these versions will never be called. They need
 *  only have the correct signature and compile without error.
 */

/*
 *  bignum -> file
 */
void bigprint(FILE *f, dptr da)
{
}

/*
 *  bignum -> real
 */
int bigtoreal(dptr da, double *result)
   {
   return 0;
   }

/*
 *  bignum -> string
 */
int bigtos(dptr da, dptr dx)
   {
   return 0;
   }

/*
 *  da -> dx
 */
int cpbignum(dptr da, dptr dx)
   {
   return 0;
   }

/*
 *  da / db -> dx
 */
int bigdiv(dptr da, dptr db, dptr dx)
   {
   return 0;
   }

/*
 *  da % db -> dx
 */
int bigmod(dptr da, dptr db,dptr dx)
   {
   return 0;
   }

/*
 *  iand(da, db) -> dx
 */
int bigand(dptr da, dptr db, dptr dx)
   {
   return 0;
   }

/*
 *  ior(da, db) -> dx
 */
int bigor(dptr da, dptr db, dptr dx)
   {
   return 0;
   }

/*
 *  xor(da, db) -> dx
 */
int bigxor(dptr da, dptr db, dptr dx)
   {
   return 0;
   }

/*
 *  negative if da < db
 *  zero if da == db
 *  positive if da > db
 */
word bigcmp(dptr da, dptr db)
   {
   return (word)0;
   }

/*
 *  ?da -> dx
 */  
int bigrand(dptr da, dptr dx)
   {
   return 0;
   }

/*
 *************************************************************
 *
 * The following routines are called when overflow has occurred
 *   during ordinary arithmetic.
 */

/*
 *  da + db -> dx
 */
int bigadd(dptr da, dptr db, dptr dx)
   {
#if ConcurrentCOMPILER
   CURTSTATE();
#endif                                            /* ConcurrentCOMPILER */
   t_errornumber = 203;
   t_errorvalue = nulldesc;
   t_have_val = 0;
   return RunError;
   }

/*
 *  da * db -> dx
 */
int bigmul(dptr da, dptr db, dptr dx)
   {
#if ConcurrentCOMPILER
   CURTSTATE();
#endif                                            /* ConcurrentCOMPILER */
   t_errornumber = 203;
   t_errorvalue = nulldesc;
   t_have_val = 0;
   return RunError;
   }

/*
 *  -i -> dx
 */
int bigneg(dptr da, dptr dx)
   {
#if ConcurrentCOMPILER
   CURTSTATE();
#endif                                            /* ConcurrentCOMPILER */
   t_errornumber = 203;
   t_errorvalue = nulldesc;
   t_have_val = 0;
   return RunError;
   }

/*
 *  da - db -> dx
 */ 
int bigsub(dptr da, dptr db, dptr dx)
   {
#if ConcurrentCOMPILER
   CURTSTATE();
#endif                                            /* ConcurrentCOMPILER */
   t_errornumber = 203;
   t_errorvalue = nulldesc;
   t_have_val = 0;
   return RunError;
   }

/*
 * ********************************************************
 *
 * The remaining routines each requires different handling.
 */

/*
 *  real -> bignum
 */
int realtobig(dptr da, dptr dx)
   {
   return Failed;  /* conversion cannot be done */
   }

/*
 *  da ^ db -> dx
 */
int bigpow(dptr da, dptr db, dptr dx)
   {
   C_integer r;
   int over_flow;
#if ConcurrentCOMPILER
   CURTSTATE();
#endif                                            /* ConcurrentCOMPILER */

   /*
    * Just do ordinary interger exponentiation and check for overflow.
    */
   r = iipow(IntVal(*da), IntVal(*db), &over_flow);
   if (over_flow) {
      k_errornumber = 203;
      k_errortext = emptystr;
      k_errorvalue = nulldesc;
      have_errval = 0;
      return RunError;
      }
   MakeInt(r, dx);
   return Succeeded;
   }

/*
 *  string -> bignum
 */
word bigradix(int sign,              /* '-' or not */
              int r,                 /* radix 2 .. 36 */
              char *s, char *end_s,  /* input string */
              union numeric *result) /* output T_Integer or T_Lrgint */
   {
   /*
    * Just do string to ordinary integer.
    */
   return radix(sign, r, s, end_s, result);
   }

/*
 *  bigshift(da, db) -> dx
 */
int bigshift(dptr da, dptr db, dptr dx)
   {
   uword ci;                  /* shift in 0s, even if negative */
   C_integer cj;

   /*
    * Do an ordinary shift - note that db is always positive when this
    *   routine is called.
    */
   ci = (uword)IntVal(*da);
   cj = IntVal(*db);
   /*
    * Check for a shift of WordSize or greater; return an explicit 0 because
    *  this is beyond C's defined behavior.  Otherwise shift as requested.
    */
   if (cj >= WordBits)
      ci = 0;
   else
      ci <<= cj;
   MakeInt(ci, dx);
   return Succeeded;
   }
