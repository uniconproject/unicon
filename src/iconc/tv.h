#ifndef TV_H
#define TV_H __DATE__" "__TIME__

#define tv_alloc_typ tv_alc
/*
#define tv_bit_get(t,n) ((t)->ent->bits[DivIntBits(n)] & (1<<(ModIntBits(n))))
*/
#define tv_bitset tv_bit_get
#define tv_clr_typ tv_bit_clr
#define tv_cpy(d,s) ((d)->ent = (s)->ent)
/*#define tv_int_get(t,n) ((t)->ent->bits[(n)])*/
#define tv_set_typ tv_bit_set
#define tv_typcd_bits(i,t) tv_type_bits_set((t),(i))
#define tv_vects_init tv_init

#define TvChkMrgTyp(n,s,d) tv_bits_or_chk((d),(s),(n))
#define TvChkMrgTyp2(n,s,d) tv_ints_or_chk((d),(s),((n)+1))
#define TvClrTyp(n,t) tv_bits_clr((t),(n))
#define TvCpyTyp(n,s,d) tv_bits_cpy((d),(s),(n))
#define TvMrgTyp(n,s,d) tv_bits_or((d),(s),(n))
#define TvMrgTyp2(n,s,d) tv_ints_or((d),(s),((n)+1))

#define ull unsigned long long

struct tvent {
   ull raw_hash;
   unsigned int aura;
   /* unsigned int * bits; */
   vord * bits;
   struct tvent * next;
   };

struct tv {
   struct tvent * ent;
   };

extern struct tv * tv_alc(int);
extern struct tv * tv_alc_set(int);
extern void tv_bit_clr(struct tv *, int);
#ifndef tv_bit_get
extern int tv_bit_get(struct tv *, int);
#endif                                  /* tv_bit_get */
extern void tv_bit_set(struct tv *, int);
extern void tv_bits_clr(struct tv *, int);
extern void tv_bits_cpy(struct tv *, struct tv *, int);
extern void tv_bits_or(struct tv *, struct tv *, int);
extern int tv_bits_or_chk(struct tv *, struct tv *, int);
extern int tv_deref_prep(struct tv *, struct tv *);
extern void tv_dump_vect(struct tv *, int, int);
extern int tv_has_type(struct tv *, int, int);
extern void tv_init(int, int, int, int);
extern int tv_int_get(struct tv *, int);
extern void tv_ints_and(struct tv *, struct tv *, int);
extern void tv_ints_or(struct tv *, struct tv *, int);
extern int tv_ints_or_chk(struct tv *, struct tv *, int);
extern int tv_is_empty(struct tv *);
extern int tv_other_type(struct tv *, int);
extern unsigned int * tv_rng_get(struct tv *, int, int, int *);
extern void tv_stores_or(struct store *, struct store *, int, int);
extern void tv_type_bits_set(struct tv *, int);

#endif /* TV_H */

