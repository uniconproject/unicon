#include "rtt.h"
/*
 * yyerror - error routine called by yacc.
 */
void yyerror(s)
char *s;
   {
   struct token *t;

   t = yylval.t;
   if (t == NULL)
      err2(s, " at end of file");
   else
      errt1(t, s);
   }
