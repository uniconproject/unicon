#include "../h/gsupport.h"
#include "ctrans.h"
#include "csym.h"
#include "ctree.h"
#include "ctoken.h"
#include "cglobals.h"
#include "ccode.h"
#include "cproto.h"
#include "tv.h"

#define BitGet(t,n) ((t)->ent->bits[DivIntBits(n)] & (1<<(ModIntBits(n))))
#define MemCpy memcpy
#define MemEqu(p,q,n) (memcmp((p),(q),(n))==0)
#define MemSet memset
#define HashChk(p) do { \
   unsigned int h1 = hash(p->bits); \
   unsigned int h2 = hash_bh(p->raw_hash); \
   if (h1 != h2) { \
      printf("HashChk: h1: %x h2: %x line: %d\n", h1, h2, __LINE__); \
      mdw_gdbhook(); \
      } \
   } while (0)

#define ull unsigned long long

struct tvent {
   ull raw_hash;
   unsigned int * aura;
   unsigned int * bits;
   struct tvent * next;
   };

struct tv {
   struct tvent * ent;
   };

static int n_tvtbl_bkts = 0;
static int n_tvpool_size = 0;
static int n_entpool_size = 0;
static int n_bitspool_size = 0;
static int n_aurapool_size = 0;

static int n_aura_bits = 0;
static int n_aura_ints = 0;
static int n_aura_bytes = 0;

static int n_vect_bytes = 0;
static int n_rttyp_bits = 0;
static int n_rttyp_ints = 0;
static int n_icntyp_bits = 0;
static int n_icntyp_ints = 0;
static int n_intrtyp_bits = 0;
static int n_intrtyp_ints = 0;

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
static struct tvent * rttyp = 0;
static struct tvent * anytyp = 0;
static struct tvent * tmpent = 0;
static struct tvent ** tvtbl = 0;

/*
 * Vector of zeroes
 */
static unsigned int * zvect = 0;

static inline unsigned int * alcaura(void);
static inline unsigned int * alcbits(void);
static inline struct tvent * alcent(void);
static inline struct tv * alctv(void);
static inline void aura_clr(struct tvent *, int);
static inline int aura_cmp(struct tvent *, struct tvent *);
static inline int aura_is_empty(struct tvent *);
static inline void aura_sync(struct tvent *, int);
static inline void bit_range(int, int *, int *);
/* static inline unsigned int hash(unsigned int *); */
static inline unsigned int hash_bh(ull);
static inline ull hash_th(unsigned int *);
static inline int ints_or(struct tv *, struct tv *, int);
static inline struct tvent * insert(struct tvent *, unsigned int);
/* static inline struct tvent * lkup(struct tvent *, unsigned int); */
static inline int next_pwr_2(int);

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
   unsigned int k;
   unsigned int idx;
   unsigned int msk;

   idx = DivIntBits(bit);
   msk = (1 << (ModIntBits(bit)));
   if ((tv->ent->bits[idx] & msk) == 0)
      return;
   MemCpy(tmpent->bits, tv->ent->bits, n_vect_bytes);
   MemCpy(tmpent->aura, tv->ent->aura, n_aura_bytes);
   k = idx ? idx : 1;
   tmpent->raw_hash = tv->ent->raw_hash - k * msk;
   tmpent->bits[idx] &= ~msk;
   aura_sync(tmpent, idx);
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
#ifdef old_and_works
   unsigned int u;
   unsigned int idx;
   unsigned int msk;

   idx = DivIntBits(bit);
   msk = (1 << (ModIntBits(bit)));
   u = tv->ent->bits[idx];
   return (u & msk);
#endif
   return BitGet(tv, bit);
}

extern
void
tv_bit_set(tv, bit)
   struct tv * tv;
   int bit;
{
   unsigned int k;
   unsigned int idx;
   unsigned int msk;

   idx = DivIntBits(bit);
   msk = (1 << (ModIntBits(bit)));
   if (tv->ent->bits[idx] & msk)
      return;
   MemCpy(tmpent->bits, tv->ent->bits, n_vect_bytes);
   MemCpy(tmpent->aura, tv->ent->aura, n_aura_bytes);
   k = idx ? idx : 1;
   tmpent->raw_hash = tv->ent->raw_hash;
   tmpent->raw_hash -= k * tmpent->bits[idx];
   tmpent->bits[idx] |= msk;
   tmpent->raw_hash += k * tmpent->bits[idx];
   aura_sync(tmpent, idx);
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
   int nints;

   nints = NumInts(nbits);
/*
   if (MemEqu(tv->ent->bits, zvect, nints * sizeof(unsigned int)))
      return;
*/
   MemCpy(tmpent->bits, tv->ent->bits, n_vect_bytes);
   tmpent->raw_hash = tv->ent->raw_hash - tmpent->bits[0];
   i = nints - 1;
   while (i) {
      tmpent->raw_hash -= i * tmpent->bits[i];
      i--;
      }
   MemSet(tmpent->bits, 0, nints * sizeof(unsigned int));
   MemCpy(tmpent->aura, tv->ent->aura, n_aura_bytes);
   aura_clr(tmpent, nints);
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
   int nints;

   if (dst->ent == src->ent)
      return; 
   nints = NumInts(nbits);
/*
   if (MemEqu(dst->ent->bits, src->ent->bits, nints * sizeof(unsigned int)))
      return;
*/
   MemCpy(tmpent->bits + nints, dst->ent->bits + nints,
      n_vect_bytes - nints * sizeof(unsigned int));
   MemCpy(tmpent->bits, src->ent->bits, nints * sizeof(unsigned int));
   MemCpy(tmpent->aura, src->ent->aura, n_aura_bytes);
   /*
    * The logic necessary to correctly manipulate tmpent->raw_hash here
    * is sufficiently complex that returns diminish; so here we punt and
    * invoke hash_th.
    */
   tmpent->raw_hash = hash_th(tmpent->bits);
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
   ints_or(dst, src, NumInts(nbits));
}

extern
int
tv_bits_or_chk(dst, src, nbits)
   struct tv * dst;
   struct tv * src;
   int nbits;
{
   int nints;
   int deltas;

   nints = NumInts(nbits);
   deltas = ints_or(dst, src, nints);
   return deltas;
}

extern
int
tv_deref_prep(dst, src)
   struct tv * dst;
   struct tv * src;
{
   int i;
   int deltas;
   unsigned int u;
   extern unsigned int val_mask;

   if (dst->ent == src->ent)
      return 0;
   /*
    * We only concern ourselves with the first n_icntyp_ints in
    * the vectors here in order to correctly mimick the original code.
    */
/*
   if (MemEqu(dst->ent->bits, src->ent->bits, n_icntyp_ints *
      sizeof(unsigned int)))
      return 0;
*/

   deltas = 0;
   MemCpy(tmpent->bits, dst->ent->bits, n_vect_bytes);
   MemCpy(tmpent->aura, dst->ent->aura, n_aura_bytes);
   tmpent->raw_hash = dst->ent->raw_hash;

   u = tmpent->bits[0];
   tmpent->bits[0] |= src->ent->bits[0];
   if (u ^ tmpent->bits[0]) {
      tmpent->raw_hash -= u;
      tmpent->raw_hash += tmpent->bits[0];
      ++deltas;
      aura_sync(tmpent, 0);
      }
   for (i=1; i<n_icntyp_ints-1; i++) {
      u = tmpent->bits[i];
      tmpent->bits[i] |= src->ent->bits[i];
      if (u ^ tmpent->bits[i]) {
         tmpent->raw_hash -= i * u;
         tmpent->raw_hash += i * tmpent->bits[i];
         ++deltas;
         aura_sync(tmpent, i);
         }
      }
   u = tmpent->bits[i];
   tmpent->bits[i] |= (src->ent->bits[i] & val_mask);
   if (u ^ tmpent->bits[i]) {
      tmpent->raw_hash -= i * u;
      tmpent->raw_hash += i * tmpent->bits[i];
      ++deltas;
      aura_sync(tmpent, i);
      }
   if (deltas == 0)
      return deltas;
   /* tmpent->raw_hash = hash_th(tmpent->bits); temporary workaround */
   dst->ent = insert(tmpent, hash_bh(tmpent->raw_hash));
   if (dst->ent == tmpent) {
      tmpent = alcent();
      tmpent->bits = alcbits();
      }
   return deltas;
}

#ifdef DebugOnly
extern
void
tv_dump_vect(tv, nbits, linenum)
   struct tv * tv;
   int nbits;
   int linenum;
{
   int i;
   int nints;

   nints = NumInts(nbits);
   printf("%d: vect: [ ", linenum);
   for (i=0; i<nints; i++)
      printf("%x ", tv->ent->bits[i]);
   printf("]\n");
}
#endif

extern
int
tv_has_type(tv, typcd, clr)
   struct tv * tv;
   int typcd;
   int clr;
{
   int i, found;
   int frstbit, lastbit;

   found = 0;
   bit_range(typcd, &frstbit, &lastbit);
   for (i=frstbit; i<lastbit; i++) {
      if (BitGet(tv, i)) {
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
   hash_shifts = (WordBits / hash_upper_shr) + 1;
   if (verbose > 3)
      fprintf(stdout, "tv-init: hash-mask: %08x hash-upper: %08x "
         "hash-shifts: %d hash-upper-shift: %d\n",
         hash_mask, hash_upper, hash_shifts, hash_upper_shr);

   n_tvpool_size = n_tvtbl_bkts;
   n_entpool_size = n_tvtbl_bkts << 1;
   n_bitspool_size = n_entpool_size;
   n_aurapool_size = n_bitspool_size;
   
   n_rttyp_bits = nrttyp;
   n_rttyp_ints = NumInts(nrttyp);
   n_icntyp_bits = nicntyp;
   n_icntyp_ints = NumInts(nicntyp);
   n_intrtyp_bits = nintrtyp;
   n_intrtyp_ints = NumInts(nintrtyp);
   n_vect_bytes = n_rttyp_ints * sizeof(unsigned int);
   n_aura_bits = n_rttyp_ints;
   n_aura_ints = NumInts(n_aura_bits);
   n_aura_bytes = n_aura_ints * sizeof(unsigned int);
   init = infer ? (unsigned int)0 : ~(unsigned int)0;

   tvtbl = alloc(n_tvtbl_bkts * sizeof(struct tvent *));
   for (i=n_tvtbl_bkts-1; i>=0; i--)
      tvtbl[i] = 0;
   zvect = alloc(n_vect_bytes);
   MemSet(zvect, 0, n_vect_bytes);

   rttyp = alloc(sizeof(struct tvent));
   rttyp->next = 0;
   rttyp->aura = alloc(n_aura_bytes);
   MemSet(rttyp->aura, 0, n_aura_bytes);
   rttyp->bits = alloc(n_vect_bytes);
   MemSet(rttyp->bits, init, n_vect_bytes);
   rttyp->raw_hash = hash_th(rttyp->bits);
   if (verbose > 3) {
      printf("tv-init: nrttyp: %d nints(nrttyp): %d\n", nrttyp, n_rttyp_ints);
      printf("         n-aura-bits: %d n-aura-ints: %d n-aura-bytes: %d\n",
         n_aura_bits, n_aura_ints, n_aura_bytes);
      }

   anytyp = alloc(sizeof(struct tvent));
   anytyp->next = 0;
   anytyp->aura = alloc(n_aura_bytes);
   MemSet(anytyp->aura, ~(unsigned int)0, n_aura_bytes);
   anytyp->bits = alloc(n_vect_bytes);
   MemSet(anytyp->bits, ~(unsigned int)0, n_vect_bytes);
   anytyp->raw_hash = hash_th(anytyp->bits);

   /*
    * Create first "temporary" tvent
    */
   tmpent = alloc(sizeof(struct tvent));
   tmpent->next = 0;
   tmpent->aura = alloc(n_aura_bytes);
   tmpent->bits = alloc(n_vect_bytes);
   tmpent->raw_hash = 0ULL;

   /*
    * PON the allocation pools
    */
   alctv();
   alcaura();
   alcent();
   alcbits();
}

extern
int
tv_int_get(tv, idx)
   struct tv * tv;
   int idx;
{
   return tv->ent->bits[idx];
}

extern
void
tv_ints_and(dst, src, nints)
   struct tv * dst;
   struct tv * src;
   int nints;
{
   int i;

   MemCpy(tmpent->bits, dst->ent->bits, n_vect_bytes);
   MemCpy(tmpent->aura, dst->ent->aura, n_aura_bytes);
   tmpent->raw_hash = dst->ent->raw_hash;

   tmpent->raw_hash -= tmpent->bits[0];
   tmpent->bits[0] &= src->ent->bits[0];
   tmpent->raw_hash += tmpent->bits[0];
   aura_sync(tmpent, 0);
   for (i=1; i<nints; i++) {
      tmpent->raw_hash -= i * tmpent->bits[i];
      tmpent->bits[i] &= src->ent->bits[i];
      tmpent->raw_hash += i * tmpent->bits[i];
      aura_sync(tmpent, i);
      }
   /* tmpent->raw_hash = hash_th(tmpent->bits); temporary workaround */
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
   ints_or(dst, src, nints);
}

extern
int
tv_ints_or_chk(dst, src, nints)
   struct tv * dst;
   struct tv * src;
   int nints;
{
   int deltas;
   extern long changed;
   deltas = ints_or(dst, src, nints);
   changed += deltas;
   return deltas;
}

extern
int
tv_is_empty(tv)
   struct tv * tv;
{
   int i;
   /*
    * the types.c is_empty() only uses NumInts(n_intrtyp) to check
    * for emptiness, so that's what we're doing here...
    *
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
tv_other_type(tv, typcd)
   struct tv * tv;
   int typcd;
{
   int i;
   int frstbit, lastbit;
   extern unsigned int n_intrtyp;

   bit_range(typcd, &frstbit, &lastbit);
   for (i=0; i<frstbit; i++) {
      if (BitGet(tv, i))
         return 1;
      }
   /*
    * the types.c other_type() only considers
    * the first n_intrtyp bits in this comparison,
    * so that's what we do here...
    */
   for (i=lastbit; i<n_intrtyp; i++) {
      if (BitGet(tv, i))
         return 1;
      }
   return 0;
}

#ifdef DebugOnly
extern
void
tv_stats(indices, nindices)
   int * indices;
   int nindices;
{
   int i, n;
   extern int verbose;
   struct tvent * ent;
   int bktsz[n_tvtbl_bkts];

   if (verbose <= 3)
      return;
   for (i=0; i<n_tvtbl_bkts; i++) {
      for (n=0,ent=tvtbl[i]; ent; ent=ent->next)
         ++n;
      bktsz[i] = n;
      }
   printf("tv-stats:\n");
#ifdef dump_htbl_distribution
   for (i=0,n=0; i<n_tvtbl_bkts; i++) {
      printf("%d ", bktsz[i]);
      if (i && ((i % 16) == 0))
         printf("\n");
      n += bktsz[i];
      }
   printf("\n   total-vects: %d\n", n);
#else
   for (i=0,n=0; i<n_tvtbl_bkts; i++)
      n += bktsz[i];
   printf("  total-vects: %d\n", n);
#endif /* dump_htbl_distribution */
   if (nindices < 0) {
      for (i=0; i<n_tvtbl_bkts; i++) {
         printf("bkt %d:\n", i);
         for (ent=tvtbl[i]; ent; ent=ent->next) {
            int j;
            printf("[ ");
            for (j=0; j<n_rttyp_ints; j++)
               printf("%x ", ent->bits[j]);
            printf("]\n");
            }
         }
      return;
      }
   for (i=0; i<nindices; i++) {
      n = indices[i];
      printf("  bkt %d:\n", n);
      for (ent=tvtbl[n]; ent; ent=ent->next) {
         int j;
         printf("[ ");
         for (j=0; j<n_rttyp_ints; j++)
            printf("%x ", ent->bits[j]);
         printf("]\n");
         }
      }
   printf("end tv-stats\n");
}
#endif /* DebugOnly */

extern
void
tv_type_bits_set(tv, typcd)
   struct tv * tv;
   int typcd;
{
   int i;
   int frstbit, lastbit;
   extern unsigned int val_mask;
   extern unsigned int n_icntyp;

   if (typcd == TypEmpty)
      return;
   if (typcd == TypAny) {
      /* copy type bits into tmpent */
      MemCpy(tmpent->bits, tv->ent->bits, n_vect_bytes);
      MemCpy(tmpent->aura, tv->ent->aura, n_aura_bytes);
      tmpent->raw_hash = tv->ent->raw_hash;

      /* the 0th int in the vect is treated specially */
      tmpent->raw_hash -= tmpent->bits[0];
      tmpent->bits[0] = ~(unsigned int)0;
      tmpent->raw_hash += tmpent->bits[0];
      aura_sync(tmpent, 0);

      /* set all the bits that are supposed to be set */
      for (i=1; i<NumInts(n_icntyp)-1; i++) {
         tmpent->raw_hash -= i * tmpent->bits[i];
         tmpent->bits[i] = ~(unsigned int)0;
         tmpent->bits[i] += i * tmpent->bits[i];
         aura_sync(tmpent, i);
         }
      tmpent->raw_hash -= i * tmpent->bits[i];
      tmpent->bits[i] |= val_mask;
      tmpent->raw_hash += i * tmpent->bits[i];
      aura_sync(tmpent, i);

      /* see if the pattern already exists */
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

static
inline
unsigned int *
alcaura(void)
{
   unsigned int * rslt;
   static int idx = -31;
   static unsigned int * pool = 0;

   if (idx == -31) {
      /*
       * this is an init call, not an alc.
       */
      idx = n_aura_ints * (n_aurapool_size - 1);
      pool = alloc(n_aura_bytes * n_aurapool_size);
      return 0;
      }
   rslt = &pool[idx];
   idx -= n_aura_bytes;
   if (idx < 0) {
      idx = n_aura_ints * (n_aurapool_size - 1);
      pool = alloc(n_aura_bytes * n_aurapool_size);
      }
   return rslt;
}

static
inline
unsigned int *
alcbits(void)
{
   unsigned int * rslt;
   static int idx = -31;
   static unsigned int * pool = 0;

   if (idx == -31) {
      /*
       * this is an init call, not an alc.
       */
      idx = n_rttyp_ints * (n_bitspool_size - 1);
      pool = alloc(n_vect_bytes * n_bitspool_size);
      return 0;
      }
   rslt = &pool[idx];
   idx -= n_vect_bytes;
   if (idx < 0) {
      idx = n_rttyp_ints * (n_bitspool_size - 1);
      pool = alloc(n_vect_bytes * n_bitspool_size);
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
      idx = n_entpool_size - 1;
      pool = alloc(sizeof(struct tvent) * n_entpool_size);
      return 0;
      }
   rslt = &pool[idx];
   if (--idx < 0) {
      idx = n_entpool_size - 1;
      pool = alloc(sizeof(struct tvent) * n_entpool_size);
      }
   rslt->aura = alcaura();
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
      idx = n_tvpool_size - 1;
      pool = alloc(sizeof(struct tv) * n_tvpool_size);
      return 0;
      }
   rslt = &pool[idx];
   if (--idx < 0) {
      idx = n_tvpool_size - 1;
      pool = alloc(sizeof(struct tv) * n_tvpool_size);
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
   int i;
   int nints;

   nints = NumInts(nbits) - 1;
   for (i=0; i<nints; i++)
      tvent->aura[i] = (unsigned int)0;
   if ((nbits = ModIntBits(nbits)) == 0)
      return;
   tvent->aura[i] &= ~(word)((1 << nbits) - 1);
}

static
inline
int
aura_cmp(e1, e2)
   struct tvent * e1;
   struct tvent * e2;
{
   int i;

   if (e1 == e2)
      return 0;
   i = n_aura_ints - 1;
   while (i >= 0) {
      if (e1->aura[i] ^ e2->aura[i])
         return (e1->aura[i] > e2->aura[i] ? 1 : -1);
      i--;
      }
   return 0;
}

static
inline
int
aura_is_empty(tvent)
   struct tvent * tvent;
{
   int i;

   i = n_aura_ints - 1;
   while (i >= 0) {
      if (tvent->aura[i])
         return 0;
      i--;
      }
   return 1;
}

static
inline
void
aura_sync(tvent, intnum)
   struct tvent * tvent;
   int intnum;
{
   unsigned int idx;
   unsigned int msk;

   idx = DivIntBits(intnum);
   msk = (1 << (ModIntBits(intnum)));
   if (tvent->bits[intnum])
      tvent->aura[idx] |= msk;
   else
      tvent->aura[idx] &= ~msk;
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

#ifdef dont_compile_this
static
inline
unsigned int
hash_before_halving(bits)
   unsigned int * bits;
{
   int i;
   ull h, last;
   unsigned int u;
     
   h = last = 0ULL;
   i = n_rttyp_ints - 1;
   while (i >= 0) {
      h += last;
      h += bits[i];
      last ^= bits[i];
      i--;
      }
   /*
    * cls-gen 50 (in secs)
    * 
    * 0xaaaaaaaaaaaaaaabUL = 30.253
    * 0xe38e38e38e38e38fUL = 29.822
    * 0x2e8ba2e8ba2e8ba3UL = 29.334
    * 0x346dc5d63886594bUL = 29.269
    * 0xa3d70a3d70a3d70bUL = 29.257
    * 0x47ae147ae147ae15UL = 29.149
    * 0x0624dd2f1a9fbe77UL = 29.108
    * 0x20c49ba5e353f7cfUL = 28.998
    */
   h *= 0x20c49ba5e353f7cfULL;
   i = hash_shifts;
   u = h & hash_mask;
   while (i) {
      h >>= hash_upper_shr;
      u ^= h;
      i--;
      }
   return (u & hash_mask);
}
#endif /* dont_compile_this */

static
inline
ull
hash_th(bits)
   unsigned int * bits;
{
   int i;
   ull h;

   h = 0ULL;
   i = n_rttyp_ints - 1;
   while (i > 0) {
      h += bits[i] * i;
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

#ifdef dont_compile_this
static
inline
unsigned int
hash(bits)
   unsigned int * bits;
{
#ifdef now_in_separate_halves
   int i;
   ull h;
   unsigned int u;
   unsigned int last;

   h = 0ULL;
   last = 0U;
   i = n_rttyp_ints - 1;
   while (i >= 0) {
      h += bits[i] * i;
      h += last;
      last = bits[i];
      i--;
      }
   h *= 0x20c49ba5e353f7cfULL;
   i = hash_shifts;
   u = h & hash_mask;
   while (i) {
      h >>= hash_upper_shr;
      u ^= h;
      i--;
      }
   return (u & hash_mask);
#else
   return hash_bh(hash_th(bits));
#endif /* now_in_separate_halves */
}
#endif /* dont_compile_this */

#ifdef dont_compile_this
static
inline
struct tvent *
insert_before_halfing(ent)
   struct tvent * ent;
{
   int cmp;
   unsigned int bkt;
   struct tvent * e;

   bkt = hash(ent->bits);
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
#endif /* dont_compile_this */

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

#ifdef dont_compile_this
static
inline
int
ints_or_sluggish(dst, src, nints)
   struct tv * dst;
   struct tv * src;
   int nints;
{
   int i;
   int deltas;
   unsigned int u;
   unsigned int bkt;
   struct tvent * ent;

   MemCpy(tmpent->bits, dst->ent->bits, n_vect_bytes);
   MemCpy(tmpent->aura, dst->ent->aura, n_aura_bytes);
   for (i=0,deltas=0; i<nints; i++) {
      u = tmpent->bits[i];
      tmpent->bits[i] |= src->ent->bits[i];
      if (u != tmpent->bits[i]) {
         ++deltas;
         aura_sync(tmpent, i);
         }
      }
   dst->ent = insert(tmpent, hash(tmpent->bits));
   if (dst->ent == tmpent) {
      tmpent = alcent();
      tmpent->bits = alcbits();
      }
   return deltas;
}
#endif /* dont_compile_this */

static
inline
int
ints_or(dst, src, nints)
   struct tv * dst;
   struct tv * src;
   int nints;
{
   int i;
   int deltas;
   unsigned int u;

   if (dst->ent == src->ent)
      return 0;
   deltas = 0;
   MemCpy(tmpent->bits, dst->ent->bits, n_vect_bytes);
   MemCpy(tmpent->aura, dst->ent->aura, n_aura_bytes);
   tmpent->raw_hash = dst->ent->raw_hash;

   u = tmpent->bits[0];
   tmpent->bits[0] |= src->ent->bits[0];
   if (u ^ tmpent->bits[0]) {
      ++deltas;
      tmpent->raw_hash -= u;
      tmpent->raw_hash += tmpent->bits[0];
      aura_sync(tmpent, 0);
      }
   i = 1;
   while (i < nints) {
      u = tmpent->bits[i];
      tmpent->bits[i] |= src->ent->bits[i];
      if (u ^ tmpent->bits[i]) {
         ++deltas;
         tmpent->raw_hash -= i * u;
         tmpent->raw_hash += i * tmpent->bits[i];
         aura_sync(tmpent, i);
         }
      i++;
      }
   dst->ent = insert(tmpent, hash_bh(tmpent->raw_hash));
   if (dst->ent == tmpent) {
      tmpent = alcent();
      tmpent->bits = alcbits();
      }
   return deltas;
}

#ifdef dont_compile_this
static
inline
struct tvent *
lkup(tvent, bkt)
   struct tvent * tvent;
   unsigned int bkt;
{
   struct tvent * tmp;

   for (tmp=tvtbl[bkt]; tmp; tmp=tmp->next) {
      if (aura_cmp(tvent, tmp))
         continue;
      if (MemEqu(tvent->bits, tmp->bits, n_vect_bytes))
         return tmp;
      }
   return 0;
}
#endif /* dont_compile_this */

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
