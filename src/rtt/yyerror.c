#include <stdio.h>
#include <stdlib.h>

/*
 * yymaxstate must be YYNSTATES - 1 from the committed rttparse.c so every
 * parser state index is in range for _yyerror's errtab lookup.  Slots without
 * merr-generated rows remain zero-initialized; see yyerror_init below.
 */
int yyerror_isinitialized, yymaxstate = 842;
struct errtable {
   int i;
   union {
      char *msg;
      struct errtable *p;
      } u;
   } errtab[843];
void yyerror_init()
{
   errtab[167].i = 1;
   errtab[167].u.msg = "syntax error";
   errtab[544].i = 1;
   errtab[544].u.msg = "syntax error";
   errtab[125].i = 1;
   errtab[125].u.msg = "syntax error";
   errtab[261].i = 1;
   errtab[261].u.msg = "syntax error";
   errtab[481].i = 1;
   errtab[481].u.msg = "syntax error";
   errtab[88].i = 1;
   errtab[88].u.msg = "bad declaration list";
   errtab[93].i = 2;
   errtab[93].u.p = (struct errtable *)calloc(1,3 * sizeof(struct errtable));
   errtab[93].u.p[0].u.msg = "syntax error";
   errtab[93].u.p[1].i = 310;
   errtab[93].u.p[1].u.msg = "syntax error";
   errtab[93].u.p[2].i = 257;
   errtab[93].u.p[2].u.msg = "syntax error";
   errtab[182].i = 1;
   errtab[182].u.msg = "syntax error";
   errtab[108].i = 1;
   errtab[108].u.msg = "global declaration expected";
   errtab[192].i = 1;
   errtab[192].u.msg = "bad enumeration";
   errtab[506].i = 1;
   errtab[506].u.msg = "syntax error";
   errtab[165].i = 2;
   errtab[165].u.p = (struct errtable *)calloc(1,3 * sizeof(struct errtable));
   errtab[165].u.p[0].u.msg = "syntax error";
   errtab[165].u.p[1].i = 269;
   errtab[165].u.p[1].u.msg = "syntax error";
   errtab[165].u.p[2].i = 310;
   errtab[165].u.p[2].u.msg = "syntax error";
   errtab[254].i = 1;
   errtab[254].u.msg = "syntax error";
   errtab[479].i = 1;
   errtab[479].u.msg = "syntax error";
   errtab[704].i = 1;
   errtab[704].u.msg = "syntax error";
   errtab[175].i = 1;
   errtab[175].u.msg = "syntax error";
   errtab[75].i = 1;
   errtab[75].u.msg = "bad enumeration type";
   errtab[159].i = 1;
   errtab[159].u.msg = "syntax error";
   errtab[269].i = 2;
   errtab[269].u.p = (struct errtable *)calloc(1,3 * sizeof(struct errtable));
   errtab[269].u.p[0].u.msg = "illegal array declaration";
   errtab[269].u.p[1].i = 269;
   errtab[269].u.p[1].u.msg = "illegal array declaration";
   errtab[269].u.p[2].i = 257;
   errtab[269].u.p[2].u.msg = "syntax error";
   errtab[295].i = 1;
   errtab[295].u.msg = "syntax error";
   errtab[363].i = 1;
   errtab[363].u.msg = "syntax error";
   errtab[546].i = 1;
   errtab[546].u.msg = "syntax error";
   errtab[656].i = 1;
   errtab[656].u.msg = "syntax error";
   errtab[85].i = 1;
   errtab[85].u.msg = "syntax error";
   errtab[174].i = 1;
   errtab[174].u.msg = "syntax error";
   errtab[378].i = 2;
   errtab[378].u.p = (struct errtable *)calloc(1,3 * sizeof(struct errtable));
   errtab[378].u.p[0].u.msg = "bad function prototype";
   errtab[378].u.p[1].i = 258;
   errtab[378].u.p[1].u.msg = "bad function prototype";
   errtab[378].u.p[2].i = 257;
   errtab[378].u.p[2].u.msg = "syntax error";
   errtab[404].i = 2;
   errtab[404].u.p = (struct errtable *)calloc(1,3 * sizeof(struct errtable));
   errtab[404].u.p[0].u.msg = "syntax error";
   errtab[404].u.p[1].i = 269;
   errtab[404].u.p[1].u.msg = "syntax error";
   errtab[404].u.p[2].i = 257;
   errtab[404].u.p[2].u.msg = "syntax error";
   errtab[37].i = 1;
   errtab[37].u.msg = "illegal structure declaration";
   errtab[189].i = 1;
   errtab[189].u.msg = "syntax error";
   errtab[477].i = 1;
   errtab[477].u.msg = "syntax error";
   errtab[42].i = 2;
   errtab[42].u.p = (struct errtable *)calloc(1,3 * sizeof(struct errtable));
   errtab[42].u.p[0].u.msg = "global declaration expected";
   errtab[42].u.p[1].i = 261;
   errtab[42].u.p[1].u.msg = "global declaration expected";
   errtab[42].u.p[2].i = 258;
   errtab[42].u.p[2].u.msg = "global declaration expected";
}

int __merr_errors;
extern int yychar;
#include "rtt.h"
int _yyerror(char *s, int state)
{
   int i;
   char sbuf[128];
   if (! yyerror_isinitialized++) yyerror_init();
   if (strstr(s, "stack")) return 0;
   if (__merr_errors++ > 10) {
      fprintf(stderr, "too many errors, aborting");
      exit(__merr_errors); }
   if (yylval.t->fname) fprintf(stderr, "%s:", yylval.t->fname);
   if ((!strcmp(s, "syntax error") || !strcmp(s,"parse error"))&&
         (state>=0 && state<=yymaxstate)) {
       if (errtab[state].i==1)
         s = errtab[state].u.msg;
       else {
          for(i=1;i<=errtab[state].i;i++)
             if(yychar == errtab[state].u.p[i].i) {
                s=errtab[state].u.p[i].u.msg;break;}
          if(i>errtab[state].i && errtab[state].i > 0)
             s=errtab[state].u.p[0].u.msg;
          }
       }
   if (!strcmp(s, "syntax error") || !strcmp(s,"parse error")){
      sprintf(sbuf,"%s (%d;%d)", s, state, yychar);
      s=sbuf;
      }
   fprintf(stderr, "%d: # \"%s\": %s\n", yylval.t->line, yylval.t->image, s);
   return 0;
}
