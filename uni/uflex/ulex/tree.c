/*
 * Katie Ray
 * Project: ulex
 * March 15, 2003
 * tree.c: contains the functions used by tree structures
 */

#include <stdio.h>
#include "tree.h"
#include "y.tab.h"

extern char *alc(int, char *);

struct tree * alcnode(int lab)
{
   struct tree *x = (struct tree *) alc(sizeof(struct tree), "alcnode");
   x->label = lab;
   return x;
}

char *labelstr(int label)
{
   switch(label) {
   case OR: return "OR";
   case BACKSLASH: return "BACKSLASH";
   case SQUAREBRACKETS: return "SQUAREBRACKETS";
   case DOT: return "DOT";
   case CSET: return "CSET";
   case QUOTES: return "QUOTES";
   case LINEBEGIN: return "LINEBEGIN";
   case LINEEND: return "LINEEND";
   case OPTIONAL: return "OPTIONAL";
   case ZEROORMORE: return "ZEROORMORE";
   case ONEORMORE: return "ONEORMORE";
   case PARENTHESES: return "PARENTHESES";
   case FORWARDSLASH: return "FORWARDSLASH";
   case CURLBRACKETS: return "CURLBRACKETS";
   case OCCURRENCES: return "OCCURRENCES";
   case CLOSEPARENTHESES: return "CLOSEPARENTHESES";
   case PERCENTS: return "PERCENTS";
   case CHARACTER: return "CHARACTER";
   case COMMENT: return "COMMENT";
   case ACTION: return "ACTION";
   case BEGINNING: return "BEGINNING";
   case ENDING: return "ENDING";
   case QUESTION: return "QUESTION";
   case STAR: return "STAR";
   case PLUS: return "PLUS";
   case OREXPR: return "OREXPR";
   case PARENTHETIC: return "PARENTHETIC";
   case FORSLASH: return "FORSLASH";
   case EXPRESSION: return "EXPRESSION";
   case EXPRTREE: return "EXPRTREE";
   case NEWLINE: return "NEWLINE";
   case CONCATEXPR: return "CONCATEXPR";
   case CONCAT: return "CONCAT";
   default: return "undefined";
   }
}

void treeprint1(struct tree *t, int level)
{
   int i;
   for(i=0;i<level;i++) putchar(' ');
   printf("[ %s ]", labelstr(t->label));
   if (t->text != NULL)        printf(" %s", t->text);
   printf("\n");
   if (t->children[0] != NULL) treeprint1(t->children[0], level+1);
   if (t->children[1] != NULL) treeprint1(t->children[1], level+1);
   if (t->children[2] != NULL) treeprint1(t->children[2], level+1);
}

void treeprint(struct tree* t)
{
   treeprint1(t, 0);
}
