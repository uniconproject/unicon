#ifndef VTBL_H
#define VTBL_H __DATE__" "__TIME__

struct vtbl;

extern int           vtbl_add(char *);
extern struct vtbl * vtbl_get(struct gentry *);
extern int           vtbl_index_get(struct vtbl *);
extern int           vtbl_method_lkup(struct vtbl *, char *);
extern char *        vtbl_name(struct vtbl *);
extern int           vtbl_name_check(char *);

#endif /* VTBL_H */

