#include <stdio.h>
#include <stdlib.h>

/*
 * yymaxstate must be YYNSTATES - 1 from the committed rttparse.c so every
 * parser state index is in range for _yyerror's errtab lookup.  Slots without
 * merr-generated rows remain zero-initialized; see yyerror_init below.
 */
int yyerror_isinitialized, yymaxstate = 844;
struct errtable {
   int i;
   union {
      char *msg;
      struct errtable *p;
      } u;
   } errtab[845];
void yyerror_init()
{
   errtab[89].i = 1;
   errtab[89].u.msg = "bad declaration list";
   errtab[94].i = 2;
   errtab[94].u.p = (struct errtable *)calloc(1,3 * sizeof(struct errtable));
   errtab[94].u.p[0].u.msg = "syntax error";
   errtab[94].u.p[1].i = 310;
   errtab[94].u.p[1].u.msg = "syntax error";
   errtab[94].u.p[2].i = 257;
   errtab[94].u.p[2].u.msg = "syntax error";
   errtab[183].i = 1;
   errtab[183].u.msg = "syntax error";
   errtab[109].i = 1;
   errtab[109].u.msg = "global declaration expected";
   errtab[193].i = 1;
   errtab[193].u.msg = "bad enumeration";
   errtab[481].i = 1;
   errtab[481].u.msg = "syntax error";
   errtab[706].i = 1;
   errtab[706].u.msg = "syntax error";
   errtab[166].i = 2;
   errtab[166].u.p = (struct errtable *)calloc(1,3 * sizeof(struct errtable));
   errtab[166].u.p[0].u.msg = "syntax error";
   errtab[166].u.p[1].i = 269;
   errtab[166].u.p[1].u.msg = "syntax error";
   errtab[166].u.p[2].i = 310;
   errtab[166].u.p[2].u.msg = "syntax error";
   errtab[255].i = 1;
   errtab[255].u.msg = "syntax error";
   errtab[548].i = 1;
   errtab[548].u.msg = "syntax error";
   errtab[658].i = 1;
   errtab[658].u.msg = "syntax error";
   errtab[176].i = 1;
   errtab[176].u.msg = "syntax error";
   errtab[270].i = 2;
   errtab[270].u.p = (struct errtable *)calloc(1,3 * sizeof(struct errtable));
   errtab[270].u.p[0].u.msg = "illegal array declaration";
   errtab[270].u.p[1].i = 269;
   errtab[270].u.p[1].u.msg = "illegal array declaration";
   errtab[270].u.p[2].i = 257;
   errtab[270].u.p[2].u.msg = "syntax error";
   errtab[76].i = 1;
   errtab[76].u.msg = "bad enumeration type";
   errtab[160].i = 1;
   errtab[160].u.msg = "syntax error";
   errtab[296].i = 1;
   errtab[296].u.msg = "syntax error";
   errtab[364].i = 1;
   errtab[364].u.msg = "syntax error";
   errtab[406].i = 2;
   errtab[406].u.p = (struct errtable *)calloc(1,3 * sizeof(struct errtable));
   errtab[406].u.p[0].u.msg = "syntax error";
   errtab[406].u.p[1].i = 269;
   errtab[406].u.p[1].u.msg = "syntax error";
   errtab[406].u.p[2].i = 257;
   errtab[406].u.p[2].u.msg = "syntax error";
   errtab[479].i = 1;
   errtab[479].u.msg = "syntax error";
   errtab[86].i = 1;
   errtab[86].u.msg = "syntax error";
   errtab[175].i = 1;
   errtab[175].u.msg = "syntax error";
   errtab[379].i = 2;
   errtab[379].u.p = (struct errtable *)calloc(1,3 * sizeof(struct errtable));
   errtab[379].u.p[0].u.msg = "bad function prototype";
   errtab[379].u.p[1].i = 258;
   errtab[379].u.p[1].u.msg = "bad function prototype";
   errtab[379].u.p[2].i = 257;
   errtab[379].u.p[2].u.msg = "syntax error";
   errtab[38].i = 1;
   errtab[38].u.msg = "illegal structure declaration";
   errtab[190].i = 1;
   errtab[190].u.msg = "syntax error";
   errtab[546].i = 1;
   errtab[546].u.msg = "syntax error";
   errtab[43].i = 2;
   errtab[43].u.p = (struct errtable *)calloc(1,3 * sizeof(struct errtable));
   errtab[43].u.p[0].u.msg = "global declaration expected";
   errtab[43].u.p[1].i = 261;
   errtab[43].u.p[1].u.msg = "global declaration expected";
   errtab[43].u.p[2].i = 258;
   errtab[43].u.p[2].u.msg = "global declaration expected";
   errtab[483].i = 1;
   errtab[483].u.msg = "syntax error";
   errtab[126].i = 1;
   errtab[126].u.msg = "syntax error";
   errtab[168].i = 1;
   errtab[168].u.msg = "syntax error";
   errtab[262].i = 1;
   errtab[262].u.msg = "syntax error";
   errtab[508].i = 1;
   errtab[508].u.msg = "syntax error";
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
