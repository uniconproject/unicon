#include <stdio.h>

int yyerror_isinitialized, yymaxstate = 739;
struct errtable {
   int i;
   union {
      char *msg;
      struct errtable *p;
      } u;
   } errtab[740];
void yyerror_init()
{
   errtab[94].i = 1;
   errtab[94].u.msg = "syntax error";
   errtab[136].i = 1;
   errtab[136].u.msg = "bad enumeration";
   errtab[246].i = 1;
   errtab[246].u.msg = "syntax error";
   errtab[52].i = 1;
   errtab[52].u.msg = "syntax error";
   errtab[99].i = 1;
   errtab[99].u.msg = "bad enumeration type";
   errtab[141].i = 1;
   errtab[141].u.msg = "syntax error";
   errtab[235].i = 1;
   errtab[235].u.msg = "syntax error";
   errtab[366].i = 1;
   errtab[366].u.msg = "syntax error";
   errtab[544].i = 1;
   errtab[544].u.msg = "syntax error";
   errtab[15].i = 1;
   errtab[15].u.msg = "global declaration expected";
   errtab[41].i = 1;
   errtab[41].u.msg = "syntax error";
   errtab[62].i = 1;
   errtab[62].u.msg = "syntax error";
   errtab[109].i = 1;
   errtab[109].u.msg = "syntax error";
   errtab[413].i = 1;
   errtab[413].u.msg = "syntax error";
   errtab[502].i = 1;
   errtab[502].u.msg = "syntax error";
   errtab[638].i = 1;
   errtab[638].u.msg = "syntax error";
   errtab[25].i = 1;
   errtab[25].u.msg = "global declaration expected";
   errtab[9].i = 1;
   errtab[9].u.msg = "syntax error";
   errtab[30].i = 1;
   errtab[30].u.msg = "bad structure declaration";
   errtab[140].i = 1;
   errtab[140].u.msg = "syntax error";
   errtab[234].i = 1;
   errtab[234].u.msg = "syntax error";
   errtab[365].i = 1;
   errtab[365].u.msg = "bad function prototype";
   errtab[103].i = 1;
   errtab[103].u.msg = "syntax error";
   errtab[328].i = 1;
   errtab[328].u.msg = "syntax error";
   errtab[370].i = 1;
   errtab[370].u.msg = "syntax error";
   errtab[506].i = 1;
   errtab[506].u.msg = "syntax error";
   errtab[134].i = 1;
   errtab[134].u.msg = "syntax error";
   errtab[155].i = 1;
   errtab[155].u.msg = "illegal array declaration";
   errtab[249].i = 1;
   errtab[249].u.msg = "syntax error";
   errtab[13].i = 1;
   errtab[13].u.msg = "illegal structure declaration";
   errtab[60].i = 1;
   errtab[60].u.msg = "global declaration expected";
   errtab[123].i = 1;
   errtab[123].u.msg = "syntax error";
   errtab[128].i = 1;
   errtab[128].u.msg = "syntax error";
   errtab[149].i = 1;
   errtab[149].u.msg = "syntax error";
   errtab[212].i = 1;
   errtab[212].u.msg = "illegal array declaration";
   errtab[222].i = 1;
   errtab[222].u.msg = "syntax error";
   errtab[54].i = 1;
   errtab[54].u.msg = "syntax error";
   errtab[227].i = 1;
   errtab[227].u.msg = "syntax error";
   errtab[253].i = 1;
   errtab[253].u.msg = "syntax error";
   errtab[452].i = 1;
   errtab[452].u.msg = "syntax error";
   errtab[59].i = 1;
   errtab[59].u.msg = "syntax error";
   errtab[101].i = 1;
   errtab[101].u.msg = "syntax error";
   errtab[216].i = 1;
   errtab[216].u.msg = "syntax error";
   errtab[504].i = 1;
   errtab[504].u.msg = "syntax error";
   errtab[373].i = 1;
   errtab[373].u.msg = "syntax error";
   errtab[640].i = 1;
   errtab[640].u.msg = "syntax error";
   errtab[687].i = 1;
   errtab[687].u.msg = "syntax error";
   errtab[48].i = 1;
   errtab[48].u.msg = "syntax error";
   errtab[95].i = 1;
   errtab[95].u.msg = "syntax error";
   errtab[739].i = 1;
   errtab[739].u.msg = "syntax error";
   errtab[53].i = 1;
   errtab[53].u.msg = "bad declaration list";
   errtab[58].i = 1;
   errtab[58].u.msg = "syntax error";
   errtab[147].i = 1;
   errtab[147].u.msg = "syntax error";
   errtab[42].i = 1;
   errtab[42].u.msg = "syntax error";
   errtab[110].i = 1;
   errtab[110].u.msg = "syntax error";
   errtab[215].i = 1;
   errtab[215].u.msg = "syntax error";
   errtab[639].i = 1;
   errtab[639].u.msg = "syntax error";
   errtab[686].i = 1;
   errtab[686].u.msg = "syntax error";
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
   if (!yylval.t)
     fprintf(stderr, "unexpected end of file:");
   else
     if(yylval.t->fname) fprintf(stderr, "%s:", yylval.t->fname);

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
      if (yylval.t)
        fprintf(stderr, "%d: # \"%s\": %s\n", yylval.t->line, yylval.t->image, s);
      else
        fprintf(stderr, "%s\n", s);
   return 0;
}
