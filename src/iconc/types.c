/*
 * typinfer.c - routines to perform type inference.
 */
#include "../h/gsupport.h"
#include "../h/lexdef.h"
#include "ctrans.h"
#include "csym.h"
#include "ctree.h"
#include "ctoken.h"
#include "cglobals.h"
#include "ccode.h"
#include "cproto.h"

extern unsigned int null_bit;   /* bit for null type */
extern unsigned int str_bit;    /* bit for string type */
extern unsigned int cset_bit;   /* bit for cset type */
extern unsigned int int_bit;    /* bit for integer type */
extern unsigned int real_bit;   /* bit for real type */
extern unsigned int n_icntyp;   /* number of non-variable types */
extern unsigned int n_intrtyp;  /* number of types in intermediate values */
extern unsigned int val_mask;   /* mask for non-var types in last int of type*/
extern struct typ_info *type_array;

typedef unsigned int uint;

/*
 * alloc_typ - allocate a compressed type structure and initializes
 *    the members to zero or NULL.
 */
extern
uint *
types_alloc_typ(n_types)
   int n_types;
{
   int n_ints;
   unsigned int *typ;
   int i;
   unsigned int init = 0;
   extern unsigned int n_rttyp;

   /* mdw: n_ints = NumInts(n_types); */
   n_ints = NumInts(n_rttyp);
   typ = (unsigned int *)alloc((unsigned int)((n_ints)*sizeof(unsigned int)));

   /*
    * Initialization: if we are doing inference, start out assuming no types.
    *  If we are not doing inference, assume any type.
    */
   if (!do_typinfer)
      init = ~init;
   for (i = 0; i < n_ints; ++i)
     typ[i] = init;
   return typ;
}

/*
 * set_typ - set a particular type bit in a type bit vector.
 */
extern
void
types_set_typ(type, bit)
   uint * type;
   unsigned int bit;
{
   unsigned int indx;
   unsigned int mask;

   indx = bit / IntBits;
   mask = 1;
   mask <<= bit % IntBits;
   type[indx] |= mask;
}

/*
 * clr_type - clear a particular type bit in a type bit vector.
 */
extern
void
types_clr_typ(type, bit)
   uint * type;
   unsigned int bit;
{
   unsigned int indx;
   unsigned int mask;

   indx = bit / IntBits;
   mask = 1;
   mask <<= bit % IntBits;
   type[indx] &= ~mask;
}

/*
 * has_type - determine if a bit vector representing types has any bits
 *  set that correspond to a specific type code from the data base.  Also,
 *  if requested, clear any such bits.
 */
extern
int
types_has_type(typ, typcd, clear)
   uint * typ;
   int typcd;
   int clear;
{
   int frst_bit, last_bit;
   int i;
   int found;
   extern void types_bitrange(int, int *, int *);

   found = 0;
   types_bitrange(typcd, &frst_bit, &last_bit);
   for (i = frst_bit; i < last_bit; ++i) {
      if (types_bitset(typ, i)) {
         found = 1;
         if (clear)
            types_clr_typ(typ, i);
         }
      }
   return found;
}

/*
 * other_type - determine if a bit vector representing types has any bits
 *  set that correspond to a type *other* than specific type code from the
 *  data base.
 */
extern
int
types_other_type(typ, typcd)
   uint * typ;
   int typcd;
{
   int frst_bit, last_bit;
   int i;

   types_bitrange(typcd, &frst_bit, &last_bit);
   for (i = 0; i < frst_bit; ++i)
      if (types_bitset(typ, i))
         return 1;
   for (i = last_bit; i < n_intrtyp; ++i)
      if (types_bitset(typ, i))
         return 1;
   return 0;
}

/*
 * bitrange - determine the range of bit positions in a type bit vector
 *  that correspond to a type code from the data base.
 */
void types_bitrange(typcd, frst_bit, last_bit)
int typcd;
int *frst_bit;
int *last_bit;
   {
   if (typcd == TypVar) {
      /*
       * All variable types.
       */
      *frst_bit = n_icntyp;
      *last_bit = n_intrtyp;
      }
   else {
      *frst_bit = type_array[typcd].frst_bit;
      *last_bit = *frst_bit + type_array[typcd].num_bits;
      }
   }

/*
 * typcd_bits - set the bits of a bit vector corresponding to a type
 *  code from the data base.
 */
void
types_typcd_bits(typcd, typ)
   int typcd;
   uint * typ;
{
   int i;
   int frstbit, lastbit;

   if (typcd == TypEmpty)
      return;
   if (typcd == TypAny) {
      for (i = 0; i < NumInts(n_icntyp) - 1; ++i)
         typ[i] |= ~(unsigned int)0;
      typ[i] |= val_mask;
      return;
      }
   types_bitrange(typcd, &frstbit, &lastbit);
   for (i=frstbit; i<lastbit; i++)
      types_set_typ(typ, i);
}


/*
 * types_bitset - determine if a specific bit in a bit vector is set.
 */
extern
int
types_bitset(typ, bit)
   uint * typ;
   int bit;
{
   int mask;
   int indx;

   indx = bit / IntBits;
   mask = 1;
   mask <<= bit % IntBits;
   return typ[indx] & mask;
}

/*
 * is_empty - determine if a type bit vector is empty.
 */
extern
int
types_is_empty(typ)
   uint * typ;
{
   int i;

   for (i = 0; i < NumInts(n_intrtyp); ++i) {
      if (typ[i] != 0)
         return 0;
      }
   return 1;
}
