#include "../h/gsupport.h"
#include "ctrans.h"
#include "csym.h"
#include "ctree.h"
#include "ctoken.h"
#include "cglobals.h"
#include "ccode.h"
#include "cproto.h"
#include "tv.h"

#define AuraCpy(dst,src) ((dst)->aura = (src)->aura)
#define AuraSet(ent,n) ((ent)->aura = (n))
#define IsOnesVect(t) ((t)->ent == anytyp)
#define IsZeroVect(t) ((t)->ent == rttyp)
#define MemCmp memcmp
#define MemCpy memcpy
#define MemEqu(p,q,n) (memcmp((p),(q),(n))==0)
#define MemSet memset
#if (IntBits == VordBits)
#define NumIntsToNumVords(n) (n)
#else
#define NumIntsToNumVords(n) ((n)<<1)
#endif /* IntBits == VordBits */

static int n_tvtbl_bkts = 0;
static int n_tvs_per_pool = 0; /*n_tvpool_size*/
static int n_ents_per_pool = 0; /*n_entpool_size*/
static int n_vects_per_pool = 0; /*n_bitspool_size*/
static int n_auras_per_pool = 0; /*n_aurapool_size*/

static int n_vect_bytes = 0;
static int n_rttyp_bits = 0;
static int n_rttyp_vords = 0;
static int n_icntyp_bits = 0;
static int n_icntyp_vords = 0;
static int n_intrtyp_bits = 0;
static int n_intrtyp_vords = 0;

/*
 * buffer for tv_rng_get results
 */
static unsigned int * rng_buf = 0;
/*
 * mask for non-var types in last vord of type vector
 */
static vord val_mask = (vord)0;
/*
 * this stuff is visible outside this module
 * so that we can use it for reporting metrics
 */
int tv_nalcs = 0;
unsigned hash_mask = 0;
unsigned hash_upper = 0;
unsigned hash_upper_shr = 0;
unsigned hash_shifts = 0;

/*
 * module-wide tvents
 */
static struct tvent * rttyp = 0; /* this is a vector of zeroes (TI is on) */
static struct tvent * anytyp = 0;
static struct tvent * tmpent = 0;
static struct tvent ** tvtbl = 0;

#if NT && !defined(NTGCC)
/* keyword inline does not work on MSVC */
#define inline
#endif					/* NT && !NTGCC */

static inline vord * alcbits(void);
static inline struct tvent * alcent(void);
static inline struct tv * alctv(void);
static inline void aura_clr(struct tvent *, int);
static inline int aura_cmp(struct tvent *, struct tvent *);
static inline int aura_is_empty(struct tvent *);
static inline void aura_sync(struct tvent *);
static inline void bit_range(int, int *, int *);
static inline unsigned int hash_bh(ull);
static inline ull hash_th(vord *);
static inline int ints_or(struct tv *, struct tv *, int);
static inline struct tvent * insert(struct tvent *, unsigned int);
static inline int next_pwr_2(int);
static inline void printull(ull);
static inline void printvord(vord);

extern
struct tv *
tv_alc(nbits)
   int nbits;
{
   struct tv * rslt;

   tv_nalcs++;
   rslt = alctv();
   rslt->ent = rttyp;
   return rslt;
}

extern
struct tv *
tv_alc_set(nbits)
   int nbits;
{
   struct tv * rslt;
   static int ncalls = 0;

   if (ncalls++ >= 1) {
      /*
       * This routine is intended to be invoked once
       * per compilation (at start of type inferencing).
       */
      fprintf(stderr, "Internal compiler error: tv-alc-set: ncalls: %d.\n",
         ncalls);
      exit(-23);
      }
   tv_nalcs++;
   rslt = alctv();
   rslt->ent = anytyp;
   return rslt;
}

extern
void
tv_bit_clr(tv, bit)
   struct tv * tv;
   int bit;
{
   vord msk;
   unsigned int k;
   unsigned int idx;

   idx = DivVordBits(bit);
   msk = (vord)1;
   msk <<= ModVordBits(bit);
   if ((tv->ent->bits[idx] & msk) == 0)
      return;
   MemCpy(tmpent->bits, tv->ent->bits, n_vect_bytes);
   AuraCpy(tmpent, tv->ent);
   k = idx ? idx : 1;
   tmpent->raw_hash = tv->ent->raw_hash;
   tmpent->raw_hash -= (ull)(k * tmpent->bits[idx]);
   tmpent->bits[idx] &= ~msk;
   tmpent->raw_hash += (ull)(k * tmpent->bits[idx]);
   aura_sync(tmpent);
   tv->ent = insert(tmpent, hash_bh(tmpent->raw_hash));
   if (tv->ent == tmpent) {
      tmpent = alcent();
      tmpent->bits = alcbits();
      }
}

extern
int
tv_bit_get(tv, bit)
   struct tv * tv;
   int bit;
{
   vord v, msk;
   unsigned int idx;

   idx = DivVordBits(bit);
   msk = (vord)1;
   msk <<= ModVordBits(bit);
   v = tv->ent->bits[idx] & msk;
#if (VordBits == 64)
   if (v >= 0x100000000ULL)
      v >>= 32;
   return (v & 0x0ffffffff);
#else
   return v;
#endif /* VordBits == 64 */
}

extern
void
tv_bit_set(tv, bit)
   struct tv * tv;
   int bit;
{
   vord msk;
   unsigned int k;
   unsigned int idx;

   if (IsOnesVect(tv))
      return;
   idx = DivVordBits(bit);
   msk = (vord)1;
   msk <<= ModVordBits(bit);
   if (tv->ent->bits[idx] & msk)
      return;
   MemCpy(tmpent->bits, tv->ent->bits, n_vect_bytes);
   AuraCpy(tmpent, tv->ent);
   k = idx ? idx : 1;
   tmpent->raw_hash = tv->ent->raw_hash;
   tmpent->raw_hash -= (ull)(k * tmpent->bits[idx]);
   tmpent->bits[idx] |= msk;
   tmpent->raw_hash += (ull)(k * tmpent->bits[idx]);
   aura_sync(tmpent);
   tv->ent = insert(tmpent, hash_bh(tmpent->raw_hash));
   if (tv->ent == tmpent) {
      tmpent = alcent();
      tmpent->bits = alcbits();
      }
}

extern
void
tv_bits_clr(tv, nbits)
   struct tv * tv;
   int nbits;
{
   int i;
   int nvords;

   nvords = NumVords(nbits);
   if (nvords >= n_rttyp_vords) {
      tv->ent = rttyp;
      return;
      }
   if (MemEqu(tv->ent->bits, rttyp->bits, nvords * sizeof(vord)))
      return;
   MemCpy(tmpent->bits, tv->ent->bits, n_vect_bytes);
   tmpent->raw_hash = tv->ent->raw_hash - (ull)tmpent->bits[0];
   i = nvords - 1;
   while (i) {
      tmpent->raw_hash -= (ull)(i * tmpent->bits[i]);
      i--;
      }
   MemSet(tmpent->bits, 0, nvords * sizeof(vord));
   AuraCpy(tmpent, tv->ent);
   aura_clr(tmpent, nvords);
   tv->ent = insert(tmpent, hash_bh(tmpent->raw_hash));
   if (tv->ent == tmpent) {
      tmpent = alcent();
      tmpent->bits = alcbits();
      }
}

extern
void
tv_bits_cpy(dst, src, nbits)
   struct tv * dst;
   struct tv * src;
   int nbits;
{
   int i;
   int nvords;

   if (dst->ent == src->ent)
      return; 
   nvords = NumVords(nbits);
   tmpent->raw_hash = dst->ent->raw_hash;
   tmpent->raw_hash -= (ull)dst->ent->bits[0];
   for (i=1; i<nvords; i++)
      tmpent->raw_hash -= (ull)(dst->ent->bits[i] * i);
   MemCpy(tmpent->bits + nvords, dst->ent->bits + nvords,
      n_vect_bytes - nvords * sizeof(vord));
   MemCpy(tmpent->bits, src->ent->bits, nvords * sizeof(vord));
   tmpent->raw_hash += (ull)tmpent->bits[0];
   for (i=1; i<nvords; i++)
      tmpent->raw_hash += (ull)(tmpent->bits[i] * i);
   aura_sync(tmpent);
   /*
    * We no longer invoke hash_th here...
    *
   tmpent->raw_hash = hash_th(tmpent->bits);
    */
   dst->ent = insert(tmpent, hash_bh(tmpent->raw_hash));
   if (dst->ent == tmpent) {
      tmpent = alcent();
      tmpent->bits = alcbits();
      }
}

extern
void
tv_bits_or(dst, src, nbits)
   struct tv * dst;
   struct tv * src;
   int nbits;
{
   if (dst->ent == src->ent)
      return;
   if (IsZeroVect(src))
      return;
   if (IsZeroVect(dst)) {
      dst->ent = src->ent;
      return;
      }
   ints_or(dst, src, NumVords(nbits));
}

extern
int
tv_bits_or_chk(dst, src, nbits)
   struct tv * dst;
   struct tv * src;
   int nbits;
{
   int deltas;
   int nvords;
   extern long changed;

   if (dst->ent == src->ent)
      return 0;
   if (IsZeroVect(src))
      return 0;
   nvords = NumVords(nbits);
   deltas = ints_or(dst, src, nvords);
   changed += deltas;

   return deltas;
}

extern
int
tv_deref_prep(dst, src)
   struct tv * dst;
   struct tv * src;
{
   int i;
   vord v;
   int deltas;

   if (dst->ent == src->ent)
      return 0;
   /*
    * We only concern ourselves with the first n_icntyp_ints in
    * the vectors here in order to correctly mimick the original code.
    */
   if (MemEqu(dst->ent->bits, src->ent->bits, n_icntyp_vords * sizeof(vord)))
      return 0;

   deltas = 0;
   MemCpy(tmpent->bits, dst->ent->bits, n_vect_bytes);
   AuraCpy(tmpent, dst->ent);
   tmpent->raw_hash = dst->ent->raw_hash;

   v = tmpent->bits[0];
   tmpent->bits[0] |= src->ent->bits[0];
   if (v ^ tmpent->bits[0]) {
      tmpent->raw_hash -= (ull)v;
      tmpent->raw_hash += (ull)tmpent->bits[0];
      ++deltas;
      }
   for (i=1; i<n_icntyp_vords-1; i++) {
      if (src->ent->bits[i] == 0)
         continue;
      v = tmpent->bits[i];
      tmpent->bits[i] |= src->ent->bits[i];
      if (v ^ tmpent->bits[i]) {
         tmpent->raw_hash -= (ull)(i * v);
         tmpent->raw_hash += (ull)(i * tmpent->bits[i]);
         ++deltas;
         }
      }
   v = tmpent->bits[i];
   tmpent->bits[i] |= (src->ent->bits[i] & val_mask);
   if (v ^ tmpent->bits[i]) {
      tmpent->raw_hash -= (ull)(i * v);
      tmpent->raw_hash += (ull)(i * tmpent->bits[i]);
      ++deltas;
      }
   if (deltas == 0)
      return deltas;
   aura_sync(tmpent);
   dst->ent = insert(tmpent, hash_bh(tmpent->raw_hash));
   if (dst->ent == tmpent) {
      tmpent = alcent();
      tmpent->bits = alcbits();
      }
   return deltas;
}

extern
int
tv_has_type(tv, typcd, clr)
   struct tv * tv;
   int typcd;
   int clr;
{
   vord msk;
   int i, found;
   int frstbit, lastbit;

   found = 0;
   bit_range(typcd, &frstbit, &lastbit);
   for (i=frstbit; i<lastbit; i++) {
      msk = (vord)1;
      msk <<= ModVordBits(i);
      if (tv->ent->bits[DivVordBits(i)] & msk) {
         found = 1;
         if (clr)
            tv_bit_clr(tv, i);
         }
      }
   return found;
}

extern
void
tv_init(infer, nicntyp, nintrtyp, nrttyp)
   int infer;
   int nicntyp;
   int nintrtyp;
   int nrttyp;
{
   int i;
   unsigned int init;
   extern int verbose;

   n_tvtbl_bkts = next_pwr_2(nrttyp << 3);
   if (n_tvtbl_bkts < 256)
      n_tvtbl_bkts = 256;
   hash_mask = n_tvtbl_bkts - 1;
   if (verbose > 3)
      fprintf(stderr, "tv-init: nrttyp: %d n-tvtbl-bkts: %d\n",
         nrttyp, n_tvtbl_bkts);
   hash_upper = ~hash_mask;
   i = hash_upper;
   hash_upper_shr = 0;
   while ((i & 1) == 0) {
      i >>= 1;
      hash_upper_shr++;
      }
   hash_shifts = (VordBits / hash_upper_shr) + 1;
   if (verbose > 3)
      fprintf(stdout, "tv-init: hash-mask: %08x hash-upper: %08x "
         "hash-shifts: %d hash-upper-shift: %d\n",
         hash_mask, hash_upper, hash_shifts, hash_upper_shr);

   n_tvs_per_pool = n_tvtbl_bkts;
   n_ents_per_pool = n_tvtbl_bkts << 1;
   n_vects_per_pool = n_ents_per_pool;
   n_auras_per_pool = n_vects_per_pool;
   
   if (verbose > 3)
      fprintf(stdout, "n-tvs-per-pool: %d n-ents-per-pool: %d n-vects-per-pool:"
         " %d n-auras-per-pool: %d\n", n_tvs_per_pool, n_ents_per_pool,
         n_vects_per_pool, n_auras_per_pool);

   n_rttyp_bits = nrttyp;
   n_rttyp_vords = NumVords(nrttyp);
   n_icntyp_bits = nicntyp;
   n_icntyp_vords = NumVords(nicntyp);
   n_intrtyp_bits = nintrtyp;
   n_intrtyp_vords = NumVords(nintrtyp);
   n_vect_bytes = n_rttyp_vords * sizeof(vord);
   init = infer ? (unsigned int)0 : ~(unsigned int)0;

   if (verbose > 3)
      fprintf(stdout, "n-rttyp-bits: %d n-rttyp-vords: %d\n"
         "n-vect-bytes: %d sizeof-vord: %d\n", n_rttyp_bits, n_rttyp_vords,
         n_vect_bytes, (int)(sizeof(vord)));

   rng_buf = alloc(n_rttyp_bits * sizeof(unsigned int));

   tvtbl = alloc(n_tvtbl_bkts * sizeof(struct tvent *));
   for (i=n_tvtbl_bkts-1; i>=0; i--)
      tvtbl[i] = 0;

   rttyp = alloc(sizeof(struct tvent));
   rttyp->next = 0;
   rttyp->aura = 0;
   rttyp->bits = alloc(n_vect_bytes);
   MemSet(rttyp->bits, init, n_vect_bytes);
   rttyp->raw_hash = hash_th(rttyp->bits);
   if (verbose > 3)
      printf("tv-init: nrttyp: %d nints(nrttyp): %d\n", nrttyp, n_rttyp_vords);

   anytyp = alloc(sizeof(struct tvent));
   anytyp->next = 0;
   anytyp->aura = 0;
   anytyp->bits = alloc(n_vect_bytes);
   MemSet(anytyp->bits, ~(unsigned int)0, n_vect_bytes);
   anytyp->raw_hash = hash_th(anytyp->bits);

   /*
    * Create first "temporary" tvent
    */
   tmpent = alloc(sizeof(struct tvent));
   tmpent->next = 0;
   tmpent->aura = 0;
   tmpent->bits = alloc(n_vect_bytes);
   tmpent->raw_hash = 0ULL;

   /*
    * Create the val_mask to differentiate between icntyps and intrtyps.
    *  The division between bits for first-class types and variables types
    *  generally occurs in the middle of a word. Set up a mask for extracting
    *  the first-class types from this word.
    */
   val_mask = 0ULL;
   i = n_icntyp_bits - (n_icntyp_vords - 1) * VordBits;
   while (i--)
      val_mask = (val_mask << 1) | 1;
   /*printf("val_mask: "); printull(val_mask); printf("\n");*/
   /*
    * PON the allocation pools
    */
   alctv();
   alcent();
   alcbits();
}

extern
int
tv_int_get(tv, intidx)
   struct tv * tv;
   int intidx;
{
   vord v;
   int vidx;

   vidx = intidx >> 1;
   v = tv->ent->bits[vidx];
#if (VordBits == 64)
   if ((intidx & 1) == 0)
      v >>= 32;
   return (v & 0x0ffffffff);
#else
   return v;
#endif /* VordBits == 64 */
}

extern
void
tv_ints_and(dst, src, nints)
   struct tv * dst;
   struct tv * src;
   int nints;
{
   int i;
   int nvords;

   nvords = NumIntsToNumVords(nints);
   MemCpy(tmpent->bits, dst->ent->bits, n_vect_bytes);
   AuraCpy(tmpent, dst->ent);
   tmpent->raw_hash = dst->ent->raw_hash;

   tmpent->raw_hash -= (ull)tmpent->bits[0];
   tmpent->bits[0] &= src->ent->bits[0];
   tmpent->raw_hash += (ull)tmpent->bits[0];
   for (i=1; i<nvords; i++) {
      tmpent->raw_hash -= (ull)(i * tmpent->bits[i]);
      tmpent->bits[i] &= src->ent->bits[i];
      tmpent->raw_hash += (ull)(i * tmpent->bits[i]);
      }
   aura_sync(tmpent);
   dst->ent = insert(tmpent, hash_bh(tmpent->raw_hash));
   if(dst->ent == tmpent) {
      tmpent = alcent();
      tmpent->bits = alcbits();
      }
}

extern
void
tv_ints_or(dst, src, nints)
   struct tv * dst;
   struct tv * src;
   int nints;
{
   if (dst->ent == src->ent)
      return;
   if (IsZeroVect(src))
      return;
   if (IsZeroVect(dst)) {
      dst->ent = src->ent;
      return;
      }
   ints_or(dst, src, NumIntsToNumVords(nints));
}

extern
int
tv_ints_or_chk(dst, src, nints)
   struct tv * dst;
   struct tv * src;
   int nints;
{
   int deltas;
   int nvords;
   extern long changed;

   if (dst->ent == src->ent)
      return 0;
   if (IsZeroVect(src))
      return 0;
   nvords = NumIntsToNumVords(nints);
   deltas = ints_or(dst, src, nvords);
   changed += deltas;

   return deltas;
}

extern
int
tv_is_empty(tv)
   struct tv * tv;
{
   /*
    * the types.c is_empty() only uses NumInts(n_intrtyp) to check
    * for emptiness, so that's what we're doing here...
    *
   int i;
   for (i=0; i<intrtyp.nints; i++) {
      if (tv->ent->bits[i])
         return 0;
      }
    */
   /*
   for (i=0; i<n_intrtyp_ints; i++) {
      if (tv->ent->bits[i])
         return 0;
      }
   */
   return aura_is_empty(tv->ent);
}

extern
int
tv_is_dflt_vect(tv)
   struct tv * tv;
{
   return (tv->ent == rttyp);
}

extern
int
tv_other_type(tv, typcd)
   struct tv * tv;
   int typcd;
{
   int i;
   vord msk;
   int frstbit, lastbit;
   extern unsigned int n_intrtyp;

   bit_range(typcd, &frstbit, &lastbit);
   for (i=0; i<frstbit; i++) {
      msk = (vord)1;
      msk <<= ModVordBits(i);
      if (tv->ent->bits[DivVordBits(i)] & msk)
         return 1;
      }
   /*
    * the types.c other_type() only considers
    * the first n_intrtyp bits in this comparison,
    * so that's what we do here...
    */
   for (i=lastbit; i<n_intrtyp; i++) {
      msk = (vord)1;
      msk <<= ModVordBits(i);
      if (tv->ent->bits[DivVordBits(i)] & msk)
         return 1;
      }
   return 0;
}

/*
 * evaluate tv for bits set in range [bgn..end], returning
 * a buffer containing indices of all bits set, and modifies
 * the numset arg to contain number of set bits found in range.
 *
 * note: this is not reentrant.
 */
extern
unsigned int *
tv_rng_get(tv, bgn, end, numset)
   struct tv * tv;
   int bgn;
   int end;
   int * numset;
{
   int n;
   vord tgt, msk;
   int bidx;

   *numset = 0;
   if (end < bgn) {
      /*printf("tv-rng-get: range [%d .. %d] is invalid\n", bgn, end);*/
      return 0;
      }
   n = 0;
   bidx = DivVordBits(bgn);
   tgt = tv->ent->bits[bidx++];
   msk = 1;
   msk <<= ModVordBits(bgn);
   while (bgn <= end) {
      while (msk) {
         if (tgt & msk)
            rng_buf[n++] = bgn;
         if (n >= n_rttyp_bits) {
            printf("tv-rng-get: max (%d) exceeded\n", n_rttyp_bits);
            exit(-1);
            }
         if (bgn++ >= end)
            break;
         /*
          * removed vord dependency 
          *
         if (msk == VordHighBitMask)
            break;
          */
         if (msk == (vord)0)
            break;
         msk <<= 1;
         }
      tgt = tv->ent->bits[bidx++];
      while (tgt == 0) {
         bgn += (sizeof(vord) << 3);
         if (bgn > end)
            goto done;
         tgt = tv->ent->bits[bidx++];
         }
      msk = 1;
      }
done:
   *numset = n;
   return rng_buf;
}

extern
void
tv_stats(bgn, end)
   int bgn;
   int end;
{
   int i, j, n;
   extern int verbose;
   struct tvent * ent;
   int * bktsz = calloc(n_tvtbl_bkts, sizeof(int));
   if (bktsz==NULL) {
      fprintf(stderr, "tv_stats cannot allocate %d buckets\n", n_tvtbl_bkts);
      return;
      }

   for (i=0; i<n_tvtbl_bkts; i++) {
      for (n=0,ent=tvtbl[i]; ent; ent=ent->next)
         ++n;
      bktsz[i] = n;
      }
   printf("tv-stats:\n");
   for (i=0,n=0; i<n_tvtbl_bkts; i++)
      n += bktsz[i];
   printf("  total-vects: %d\n", n);

   if (bgn < 0)
      goto exit_point;
   if (end < 0)
      end = n_tvtbl_bkts;
   for (i=bgn; i<end; i++) {
      if (bktsz[i] == 0)
         continue;
      printf("bkt %d <%d>:\n", i, bktsz[i]);
      for (ent=tvtbl[i]; ent; ent=ent->next) {
         printf("%d ", ent->aura);
         printull(ent->raw_hash);
         printf(" [ ");
         for (j=0; j<n_rttyp_vords; j++) {
            printvord(ent->bits[j]);
            printf(" ");
            }
         printf("]\n");
         }
      }
exit_point:
   free(bktsz);
   printf("n-tvtbl-bkts: %d\n", n_tvtbl_bkts);
   printf("end tv-stats\n");
}

extern
void
tv_stores_or(dst, src, bgn, end)
   struct store * dst;
   struct store * src;
   int bgn;
   int end;
{
   while (bgn <= end) {
      if ((dst->types[bgn]->ent != src->types[bgn]->ent) &&
         (!IsZeroVect(src->types[bgn])))
         ints_or(dst->types[bgn], src->types[bgn], n_icntyp_vords);
      bgn++;
      }
}

extern
void
tv_type_bits_set(tv, typcd)
   struct tv * tv;
   int typcd;
{
   int i;
   int frstbit, lastbit;
   extern vord val_mask;
   extern unsigned int n_icntyp;

   if (typcd == TypEmpty)
      return;
   if (typcd == TypAny) {
      /* copy type bits into tmpent */
      MemCpy(tmpent->bits, tv->ent->bits, n_vect_bytes);
      AuraCpy(tmpent, tv->ent);
      tmpent->raw_hash = tv->ent->raw_hash;

      /* the 0th int in the vect is treated specially */
      tmpent->raw_hash -= (ull)tmpent->bits[0];
      tmpent->bits[0] = ~(vord)0;
      tmpent->raw_hash += (ull)tmpent->bits[0];

      /* set all the bits that are supposed to be set */
      for (i=1; i<NumVords(n_icntyp)-1; i++) {
         tmpent->raw_hash -= (ull)(i * tmpent->bits[i]);
         tmpent->bits[i] = ~(vord)0;
         tmpent->raw_hash += (ull)(i * tmpent->bits[i]);
         }
      tmpent->raw_hash -= (ull)(i * tmpent->bits[i]);
      tmpent->bits[i] |= val_mask;
      tmpent->raw_hash += (ull)(i * tmpent->bits[i]);
      aura_sync(tmpent);

      tv->ent = insert(tmpent, hash_bh(tmpent->raw_hash));
      if (tv->ent == tmpent) {
         tmpent = alcent();
         tmpent->bits = alcbits();
         }
      return;
      }
   /*
    * revisit: this may be ridiculously stupid if there are more than
    * a few bits in the type that are not already set in the tv...
    */
   bit_range(typcd, &frstbit, &lastbit);
   for (i=frstbit; i<lastbit; i++)
      tv_bit_set(tv, i);
}

#if 0
static
inline
vord *
alcbits_old_n_crufty(void)
{
   vord * rslt;
   static int idx = -31;
   static vord * pool = 0;

   if (idx == -31) {
      /*
       * this is an init call, not an alc.
       */
      idx = n_rttyp_vords * (n_vects_per_pool/*n_bitspool_size*/ - 1);
      pool = alloc(n_vect_bytes * n_vects_per_pool/*n_bitspool_size*/);
      return 0;
      }
   rslt = &pool[idx];
   idx -= n_vect_bytes;
   if (idx < 0) {
      idx = n_rttyp_vords * (n_vects_per_pool/*n_bitspool_size*/ - 1);
      pool = alloc(n_vect_bytes * n_vects_per_pool/*n_bitspool_size*/);
      }
   return rslt;
}
#endif  /* Not used */

static
inline
vord *
alcbits(void)
{
   vord * rslt;
   static int idx = -31;
   static char * pool = 0;

   if (idx == -31) {
      /*
       * this is an init call, not an alc.
       */
      idx = n_vects_per_pool - 1;
      pool = alloc(n_vect_bytes * n_vects_per_pool);
      return 0;
      }
   rslt = (vord *)&pool[idx * n_vect_bytes];
   idx -= 1;
   if (idx < 0) {
      idx = n_vects_per_pool - 1;
      pool = alloc(n_vect_bytes * n_vects_per_pool);
      }
   return rslt;
}

static
inline
struct tvent *
alcent(void)
{
   struct tvent * rslt;
   static int idx = -31;
   static struct tvent * pool = 0;

   if (idx == -31) {
      /*
       * this is an init call, not an alc.
       */
      idx = n_ents_per_pool - 1;
      pool = alloc(sizeof(struct tvent) * n_ents_per_pool);
      return 0;
      }
   rslt = &pool[idx];
   if (--idx < 0) {
      idx = n_ents_per_pool - 1;
      pool = alloc(sizeof(struct tvent) * n_ents_per_pool);
      }
   rslt->aura = 0;
   return rslt;
}

static
inline
struct tv *
alctv(void)
{
   struct tv * rslt;
   static int idx = -31;
   static struct tv * pool = 0;

   if (idx == -31) {
      /*
       * this is an init call, not an alc.
       */
      idx = n_tvs_per_pool - 1;
      pool = alloc(sizeof(struct tv) * n_tvs_per_pool);
      return 0;
      }
   rslt = &pool[idx];
   if (--idx < 0) {
      idx = n_tvs_per_pool - 1;
      pool = alloc(sizeof(struct tv) * n_tvs_per_pool);
      }
   return rslt;
}

static
inline
void
aura_clr(tvent, nbits)
   struct tvent * tvent;
   int nbits;
{
   int n;

   n = NumVords(nbits) - 1;
   while (n < n_rttyp_vords) {
      if (tvent->bits[n]) {
         tvent->aura = n;
         return;
         }
      n++;
      }
   tvent->aura = 0;
}

static
inline
int
aura_cmp(e1, e2)
   struct tvent * e1;
   struct tvent * e2;
{
   if (e1 == e2)
      return 0;
   if (e1->aura == e2->aura) {
      if (e1->bits[e1->aura] > e2->bits[e2->aura])
         return 1;
      if (e1->bits[e1->aura] < e2->bits[e2->aura])
         return -1;
      return 0;
      }
   else {
      if (e1->aura > e2->aura)
         return 1;
      if (e1->aura < e2->aura)
         return -1;
      return 0;
      }
}

static
inline
int
aura_is_empty(tvent)
   struct tvent * tvent;
{
   if (tvent->aura)
      return 0;
   if (tvent->bits[0])
      return 0;
   return 1;
}

static
inline
void
aura_sync(tvent)
   struct tvent * tvent;
{
   int i;

   for (i=0; i<n_rttyp_vords; i++) {
      if (tvent->bits[i]) {
         tvent->aura = i;
         return;
         }
      }
   tvent->aura = 0;
}

static
inline
void
bit_range(typcd, frstbit, lastbit)
   int typcd;
   int * frstbit;
   int * lastbit;
{
   extern unsigned int n_icntyp;
   extern unsigned int n_intrtyp;
   extern struct typ_info * type_array;

   if (typcd == TypVar) {
      /*
       * All variable types.
       */
      *frstbit = n_icntyp;
      *lastbit = n_intrtyp;
      }
   else {
      *frstbit = type_array[typcd].frst_bit;
      *lastbit = *frstbit + type_array[typcd].num_bits;
      }
}

static
inline
ull
hash_th(bits)
   vord * bits;
{
   int i;
   ull h;

   h = 0ULL;
   i = n_rttyp_vords - 1;
   while (i > 0) {
      h += (ull)(bits[i] * i);
      i--;
      }
   h += bits[0]; /* mul 0th int by 1 */
   return h;
}

static
inline
unsigned int
hash_bh(raw)
   ull raw;
{
   int i;
   unsigned int u;

   raw *= 0x20c49ba5e353f7cfULL /* hash_mage */;
   i = hash_shifts;
   u = raw & hash_mask;
   while (i > 0) {
      raw >>= hash_upper_shr;
      u ^= raw;
      i--;
      }
   return (u & hash_mask);
}

#if 0
static
int
is_tgt_vect(ent)
   struct tvent * ent;
{
   int i;

   if (ent->bits[0] != (vord)3)
      return 0;
   for (i=1; i<n_rttyp_vords; i++) {
      if (ent->bits[i])
         return 0;
      }
   return 1;
}
#endif  /* Not used anywhere*/

static
inline
struct tvent *
insert(ent, bkt)
   struct tvent * ent;
   unsigned int bkt;
{
   int cmp;
   struct tvent * e;

   if (tvtbl[bkt] == 0) {
      tvtbl[bkt] = ent;
      ent->next = 0;
      return ent;
      }
   e = tvtbl[bkt];
   cmp = aura_cmp(ent, e);
   if (cmp < 0) {
      ent->next = e;
      tvtbl[bkt] = ent;
      return ent;
      }
   if (cmp == 0 && MemEqu(ent->bits, e->bits, n_vect_bytes))
      return e;
   while (e->next) {
      cmp = aura_cmp(ent, e->next);
      if (cmp < 0) {
         ent->next = e->next;
         e->next = ent;
         return ent;
         }
      if (cmp == 0 && MemEqu(ent->bits, e->next->bits, n_vect_bytes))
         return e->next;
      e = e->next;
      }
   e->next = ent;
   ent->next = 0;
   return ent; 
}

static
inline
int
ints_or(dst, src, nvords)
   struct tv * dst;
   struct tv * src;
   int nvords;
{
   int i;
   vord v;
   int deltas;

   if (MemEqu(dst->ent->bits, src->ent->bits, nvords * sizeof(vord)))
      return 0;
   deltas = 0;
   MemCpy(tmpent->bits, dst->ent->bits, n_vect_bytes);
   AuraCpy(tmpent, dst->ent);
   tmpent->raw_hash = dst->ent->raw_hash;

   if (src->ent->bits[0]) {
      v = tmpent->bits[0];
      tmpent->bits[0] |= src->ent->bits[0];
      if (v ^ tmpent->bits[0]) {
         ++deltas;
         tmpent->raw_hash -= (ull)v;
         tmpent->raw_hash += (ull)tmpent->bits[0];
         }
      }
   for (i=1; i<nvords; i++) {
      if (src->ent->bits[i] == (vord)0)
         continue;
      v = tmpent->bits[i];
      tmpent->bits[i] |= src->ent->bits[i];
      if (v ^ tmpent->bits[i]) {
         ++deltas;
         tmpent->raw_hash -= (ull)(i * v);
         tmpent->raw_hash += (ull)(i * tmpent->bits[i]);
         }
      }
   if (deltas == 0)
      return deltas;
   aura_sync(tmpent);
   dst->ent = insert(tmpent, hash_bh(tmpent->raw_hash));
   if (dst->ent == tmpent) {
      tmpent = alcent();
      tmpent->bits = alcbits();
      }
   return deltas;
}

static
inline
int
next_pwr_2(n)
   int n;
{
   n--;
   n |= (n >> 1);
   n |= (n >> 2);
   n |= (n >> 4);
   n |= (n >> 8);
   n |= (n >> 16);
   n++;
   return n;
}

static
inline
void
printull(u)
   ull u;
{
   ull msk;
   int c, shr;
   char * ctbl[] = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a",
      "b", "c", "d", "e", "f" };

   shr = 60;
   msk = 0x0f000000000000000ULL;
   while (shr >= 0) {
      c = (u & msk) >> shr;
      printf("%s", ctbl[c]);
      msk >>= 4;
      shr -= 4;
      }
}

static
inline
void
printvord(v)
   vord v;
{
#if (VordBits == 64)
   printull(v);
#else
   printf("%x", v);
#endif
}

