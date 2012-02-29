/*
 * Katie Ray
 * Project: ulex
 * March 15, 2003
 * tree.c: contains the functions used by tree structures
 */

#include <stdio.h>
#include "tree.h"

extern char *alc(int, char *);

struct tree * alcnode(int lab)
{
   struct tree *x = (struct tree *) alc(sizeof(struct tree), "alcnode");
   x->label = lab;
   return x;
}

void treeprint(struct tree* t)
{
   printf(" [ %d", t->label);
   if (t->text != NULL)        printf("%s", t->text);
   if (t->children[0] != NULL) treeprint(t->children[0]);
   if (t->children[1] != NULL) treeprint(t->children[1]);
   if (t->children[2] != NULL) treeprint(t->children[2]);
   printf(" ]");
}
