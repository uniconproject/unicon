/*
 * Name: lex.l
 * Author: Katie Ray
 * Last Updated: September 17, 2002
 *
 * This program is the flex(1) lexical specification file for ulex.
 * It may work just fine under lex(1) if you comment out the %option yylineno
 */

%option yylineno

%{
#include "y.tab.h"
#include <string.h>

extern YYSTYPE yylval;
extern int yylineno;
extern int debugtoken;
extern char *yyfilename, *outfilename;
extern FILE *outfile;
int whiteflag=0;

void grab_semantic_action();
int token(int);
int yyinput(void);
%}

%%

"}%"	{ printf("%s", "}% should read %}"); }

"%%"	{
	/*
	 * copy out remainder, up to EOF, into output file.
	 */
	int nextchar;
	FILE *foutfile = fopen("ulex.tmp","w");
	whiteflag = 1;

	if (foutfile == NULL) {
	   fprintf(stderr, "couldn't write to ulex.tmp; exiting\n");
	   fflush(stderr);
	   exit(1);
	   }
	fprintf(foutfile, "\n\n");
	fprintf(foutfile, "$line %d \"%s\"\n", yylineno, yyfilename);

	while ((nextchar = yyinput()) > 0) {
	   fprintf(foutfile,"%c",nextchar);
	   }

	fclose(foutfile);
/*	return -1; was token(PERCENTS) */;
	return 0;
	}

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
['a-zA-Z0-9_]                       {
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
   if (debugtoken)
      printf("\ttoken: %d '%s'\n", x, yytext);
   return x;
}

void grab_semantic_action()
{
    int numbrace = 1, quotemode = 0, slash = 0;
    int nextchar;
    char* temp;

    while (numbrace != 0) {
        nextchar = yyinput();
        if (nextchar == EOF) {
	   fprintf(stderr,"bad/unfinished semantic action\n");
	   fflush(stderr);
	   exit(-1);
	   }

        if (nextchar == '"' && slash == 0) {
           quotemode = 1 - quotemode;
	   }

        if (nextchar == '\\') {
	   slash = 1 - slash;
	   }
	else slash = 0;
        if (quotemode == 0) {
            if (nextchar == '{') {
	       numbrace ++;
	       }
            else if (nextchar == '}') {
	       numbrace --;
	       }
        }

        temp = yytext;
        while (*temp != '\0') temp++;
        *temp = nextchar;
        temp++;
        *temp = '\0';
    }
}

int yywrap()
{
   return -1;
}

int yyinput(void) { return input(); }

#ifdef MAIN
YYSTYPE yylval;
int yylineno;
char *yyfilename, *outfilename;
FILE *outfile;
int main(int argc, char *argv[])
{
   char ppcmdline[1024];
   sprintf(ppcmdline, "./ulpp < %s", argv[1]);
   if ((yyin = popen(ppcmdline,"r")) != NULL) {
      while(yylex() > 0) ;
   }
   return 0;
}
#endif
