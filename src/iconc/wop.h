#ifndef WOP_H
#define WOP_H __DATE__" "__TIME__

#define Wop_Min         (0)
#define Wop_ArgDerefs   (Wop_Min + 0)
#define Wop_OpArgDerefs (Wop_Min + 1)
#define Wop_FldDerefs   (Wop_Min + 2)
#define Wop_Max         (Wop_FldDerefs)

extern void wop_arg_deref_insitu(struct val_loc *);
extern void wop_fld_deref(struct val_loc *);
extern int wop_get(unsigned);
extern int wop_set(unsigned);

#endif /* WOP_H */
