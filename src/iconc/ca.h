#ifndef CA_H
#define CA_H __DATE__" "__TIME__

extern int ca_apply_add(char *, struct node *);
extern int ca_cleanup(void);
extern int ca_init(char *, int, char **);
extern int ca_invk_add(char *, struct node *);
extern int ca_mark_parsed(char *);
extern int ca_resolve(void);

#endif /* CA_H */
