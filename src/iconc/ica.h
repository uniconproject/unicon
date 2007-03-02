#ifndef ICA_H
#define ICA_H __DATE__" "__TIME__

extern int ica_analyze(void);
extern int ica_init(void);
extern int ica_pcall_add(struct node *);
extern int ica_pdefn_add(struct gentry *);
extern int ica_pdefn_unused(struct gentry *);
extern int ica_rdecl_add(struct gentry *);
extern int ica_rdecl_unused(struct gentry *);
extern int ica_unit_add(char *);

#endif /* ICA_H */
