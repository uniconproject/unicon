/*
 * Katie Ray
 * Project: ulex
 * March 15, 2003
 * lexgram.y: contains the YACC grammar for ulex
 */

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int yylex();
int yyerror(char *s);
#include "tree.h"
#include "automata.h"
struct automata* convert(struct tree* tr);
%}

%union {
  struct tree* tr;
  struct automata* aut;
  char *s;
  int numeric;
}

%token <numeric> OR
%token <numeric> BACKSLASH
%token <numeric> SQUAREBRACKETS  
%token <numeric> DOT             
%token <numeric> CSET            
%token <numeric> QUOTES          
%token <numeric> LINEBEGIN       
%token <numeric> LINEEND         
%token <numeric> OPTIONAL        
%token <numeric> ZEROORMORE      
%token <numeric> ONEORMORE
%token <numeric> PARENTHESES     
%token <numeric> FORWARDSLASH    
%token <numeric> CURLBRACKETS    
%token <numeric> OCCURRENCES     
%token <numeric> CLOSEPARENTHESES     
%token <numeric> PERCENTS
%token <numeric> CHARACTER
%token <numeric> COMMENT
%token <numeric> ACTION
%token <numeric> BEGINNING
%token <numeric> ENDING
%token <numeric> QUESTION
%token <numeric> STAR
%token <numeric> PLUS
%token <numeric> OREXPR
%token <numeric> PARENTHETIC
%token <numeric> FORSLASH
%token <numeric> EXPRESSION
%token <numeric> EXPRTREE
%token <numeric> NEWLINE
%token <numeric> CONCATEXPR
%token <numeric> CONCAT
%type <tr> Exprs
%type <tr> OneExpr
%type <tr> Expr
%type <tr> BeginLine
%type <tr> EndLine
%type <tr> Star
%type <tr> Plus
%type <tr> Question
%type <tr> ForSlash
%type <tr> Parenthetic
%type <tr> Occurrence
%type <tr> Regexps
%type <tr> Percentexp
%type <aut> Start Goal

%%

Goal: Start { labelaut($1); createicon($1); } ;

Start:    Newlines Percentexp Newlines { $$ = convert($2); }
        | Newlines Percentexp          { $$ = convert($2); }
        | Percentexp Newlines          { $$ = convert($1); }
        | Percentexp                   { $$ = convert($1); }
	;

Percentexp: Regexps ;

Regexps : Exprs Newlines { $$ = $1; } 
	| Exprs		 { $$ = $1; }
	;

Newlines:  NEWLINE Newlines
	| NEWLINE;

Exprs:    Exprs Newlines OneExpr {
	   $$ = alcnode(EXPRTREE); 
	   $$->children[0] = $1;
	   $$->children[1] = $3;
	   }
	| OneExpr
	;

OneExpr : Expr ACTION {
	   $$ = alcnode(EXPRESSION);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(ACTION);
	   $$->children[1]->text = yylval.s;
	   }

	| Expr {
	   $$ = alcnode(EXPRESSION);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(ACTION);
	   $$->children[1]->text = "# fail";
	   }
	;

Expr    : QUOTES { 
	   $$ = alcnode(QUOTES);
	   $$->text = yylval.s;
	   }

	| BACKSLASH {
	   $$ = alcnode(BACKSLASH);
	   $$->text = yylval.s;
	   }

	| CSET { 
	   $$ = alcnode(CSET);
	   $$->text = yylval.s;
	   }

	| CHARACTER { 
	   $$ = alcnode(CHARACTER);
	   $$->text = yylval.s;
	   }

	| DOT { $$ = alcnode(DOT); }

	| BeginLine
	| EndLine
	| Question
	| Star
	| Plus
	| Expr OR Expr {
	   $$ = alcnode(OREXPR);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(OR);
	   $$->children[2] = $3;
           }
	| Expr Expr {
	   $$ = alcnode(CONCATEXPR);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(CONCAT);
	   $$->children[2] = $2;
	   }
	| Parenthetic
	| ForSlash
	| Occurrence
	;

BeginLine: LINEBEGIN Expr {
	   $$ = alcnode(BEGINNING);
	   $$->children[0] = alcnode(LINEBEGIN);
	   $$->children[1] = $2;
	   }
	;

EndLine: Expr LINEEND {
	   $$ = alcnode(ENDING);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(LINEEND);
	   }
	;

Question: Expr OPTIONAL {
	   $$ = alcnode(QUESTION);
	   $$->children[1] = alcnode(OPTIONAL);
	   $$->children[0] = $1;
	   }
	;

Star: Expr ZEROORMORE {
	   $$ = alcnode(STAR);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(ZEROORMORE);
	   }
	;

Plus: Expr ONEORMORE {
	   $$ = alcnode(PLUS);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(ONEORMORE);
	   }
	;

Parenthetic: PARENTHESES Expr CLOSEPARENTHESES {
	   $$ = alcnode(PARENTHETIC);
	   $$->children[0] = alcnode(PARENTHESES);
	   $$->children[1] = $2;
	   $$->children[2] = alcnode(CLOSEPARENTHESES); 
	   }
	;

ForSlash: Expr FORWARDSLASH Expr {
	   $$ = alcnode(FORSLASH);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(FORWARDSLASH);
	   $$->children[2] = $3;
	   }
	;

Occurrence: Expr CURLBRACKETS {
	   $$ = alcnode(OCCURRENCES);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(CURLBRACKETS);
	   $$->text = yylval.s;
	   }
	;

%%

extern int yylineno;

int yyerror(char *s)
{
   /*
    * Eventually want to use merr for better error messaging.
    */

   fprintf(stderr, "%s on line %d\n", s, yylineno);
   return 0;
}
