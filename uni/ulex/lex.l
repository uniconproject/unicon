/*
 * Katie's n'th attempt at writing a lex specification for lex.
 * Last Updated: September 17, 2002
 */

%{
/*
 * This program is the lexical specification file for lex
 */

#include "y.tab.h"
#include <string.h>

extern YYSTYPE yylval;
extern yylineno;
extern char *yyfilename;
int whiteflag=0;
%}

%%

"}%"			            { printf("}% should read %}"); }

"%%"			            { whiteflag = 1;
                                      yylineno++;
					return -1 /* token(PERCENTS) */; }

"["("^")?([^\]\\]|((\\\\)*\\.))+"]" { 
                                      yylval.s = strdup(yytext);
                                      return token(CSET); 
                                    }
"."			            { return token(DOT); } 
"\""(((\\\\)*\\.)|[^\"\\])+"\""     { 
                                      yylval.s = strdup(yytext);
                                      return token(QUOTES); 
                                    }
"\\".			            { 
                                      yylval.s = strdup(yytext);
				      return token(BACKSLASH); 
                                    }
"^"                                 { return token(LINEBEGIN); }
"$"                                 { return token(LINEEND); }
"?"                                 { return token(OPTIONAL); }
"*"                                 { return token(ZEROORMORE); }
"+"                                 { return token(ONEORMORE); }
"|"                                 { return token(OR); }
"("                                 { return token(PARENTHESES); }
")"                                 { return token(CLOSEPARENTHESES); }
"/"                                 { return token(FORWARDSLASH); }
"{"[0-9]+","[0-9]+"}"|"{"[0-9]"}"   { 
                                      yylval.s = strdup(yytext);
                                      return token(CURLBRACKETS); 
                                    }
"{"			  	    { 
                                      grab_semantic_action();
                                      yylval.s = strdup(yytext);
                                      return token(ACTION); 
                                    }
[a-zA-Z0-9_]                        { 
                                      yylval.s = strdup(yytext);
                                      return token(CHARACTER);
                                    }

\n                                  { return token(NEWLINE); }
"# ".*\n
^[\t ]*\n				{ if (whiteflag) return 1; }

[ \t\n]			            {  if (whiteflag) return 1; }
.			            {  if (whiteflag) return 1;
					else fprintf(stderr, "%s:%d: lexical error on token '%s'\n", yyfilename, yylineno, yytext); }

%%
int token(int x)
{
   //if (1) printf("\t %d %s \n", x, yytext);
   return x;
}

int grab_semantic_action()
{
    int numbrace, quotemode, slash;
    char nextchar;
    char* temp;
    numbrace = 1;
    quotemode = 0;
    slash = 0;

    while (numbrace != 0) {
        nextchar = yyinput();

        if (nextchar == '"' && slash == 0) 
            quotemode = 1 - quotemode;

        if (nextchar == '\\') slash = 1 - slash;
        
        if (quotemode == 0) { 
            if (nextchar == '{') numbrace ++;
            else if (nextchar == '}') numbrace --; 
        }

        temp = yytext;
        while (*temp != '\0') temp++;
        *temp = nextchar;
        temp++;
        *temp = '\0';
    }
    
    return 0;
}

int yywrap()
{
   return 1;
}

int yyinput(void) { return input(); }
