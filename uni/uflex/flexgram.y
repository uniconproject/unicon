/*#
# flexgram.y - iyacc grammar for uflex
#
# derived from lexgram.y, which contains a C YACC grammar for ulex by Katie Ray
#*/

%{
global rulenumber
%}

%token OR
%token BACKSLASH
%token SQUAREBRACKETS  
%token DOT             
%token CSET            
%token QUOTES          
%token LINEBEGIN       
%token LINEEND         
%token OPTIONAL        
%token ZEROORMORE      
%token ONEORMORE
%token PARENTHESES     
%token FORWARDSLASH    
%token CURLBRACKETS    
%token OCCURRENCES     
%token CLOSEPARENTHESES     
%token PERCENTS
%token CHARACTER
%token COMMENT
%token ACTION
%token BEGINNING
%token ENDING
%token QUESTION
%token STAR
%token PLUS
%token OREXPR
%token PARENTHETIC
%token FORSLASH
%token EXPRESSION
%token EXPRTREE
%token NEWLINE
%token CONCATEXPR
%token CONCAT
%token CSETUNION
%token CSETDIFFERENCE

%%

Goal: Start { labelaut($1); createicon($1) } ;

Start:    Newlines Percentexp Newlines { $$ := convert($2) }
        | Newlines Percentexp          { $$ := convert($2) }
        | Percentexp Newlines          { $$ := convert($1) }
        | Percentexp                   { $$ := convert($1) }
	;

Percentexp: Regexps ;

Regexps : Exprs Newlines { $$ := $1 } 
	| Exprs		 { $$ := $1 }
	;

Newlines:  NEWLINE Newlines
	| NEWLINE;

Exprs:    Exprs Newlines OneExpr { $$ := alcnode(EXPRTREE, $1, $3) }
	| OneExpr		 { $$ := $1 }
	;

OneExpr : Expr ACTION { $$ := alcnode(EXPRESSION, $1, alcleaf(ACTION, yylval.s))}

	| Expr { $$ := alcnode(EXPRESSION, $1, alcleaf(ACTION, "# fail")) }
	;

Cset    : CSET         { $$ := alcleaf(CSET, yylval.s) }
| Cset CSETUNION Cset { $$ := $1;
  write("cset union of ", image(csetfromrecset($1.text)), " and ", image(csetfromrecset($3.text)))
    $$.text := "[" || string(csetfromrecset($1.text) ++ csetfromrecset($3.text)) || "]"
     write("resulted in ", image($$.text)) }
	| Cset CSETDIFFERENCE Cset { $$ := $1;
  write("cset difference of ", image(csetfromrecset($1.text)), " and ", image(csetfromrecset($3.text)))
    $$.text := "[" || string(csetfromrecset($1.text) -- csetfromrecset($3.text)) || "]"
     write("resulted in ", image($$.text)) }
	;

Expr    : QUOTES       { $$ := alcleaf(QUOTES, yylval.s) }
	| BACKSLASH    { $$ := alcleaf(BACKSLASH, yylval.s) }
	| Cset
	| CHARACTER    { $$ := alcleaf(CHARACTER, yylval.s) }
	| DOT          { $$ := alcleaf(DOT) }
	| BeginLine
	| EndLine
	| Question
	| Star
	| Plus
	| Expr OR Expr { $$ := alcnode(OREXPR, $1, alcleaf(OR), $3) }
	| Expr Expr    { $$ := alcnode(CONCATEXPR, $1, alcleaf(CONCAT), $2) }
	| Parenthetic
	| ForSlash
	| Occurrence
	;

BeginLine: LINEBEGIN Expr { $$ := alcnode(BEGINNING, alcleaf(LINEBEGIN), $2) }
	;

EndLine: Expr LINEEND { $$ := alcnode(ENDING, $1, alcleaf(LINEEND)) }
	;

Question: Expr OPTIONAL { $$ := alcnode(QUESTION, $1, alcleaf(OPTIONAL)) }
	;

Star: Expr ZEROORMORE { $$ := alcnode(STAR, $1, alcleaf(ZEROORMORE)) }
	;

Plus: Expr ONEORMORE { $$ := alcnode(PLUS, $1, alcleaf(ONEORMORE)) }
	;

Parenthetic: PARENTHESES Expr CLOSEPARENTHESES {
	    $$ := alcnode(PARENTHETIC, alcleaf(PARENTHESES),
			  $2, alcleaf(CLOSEPARENTHESES))
	   }
	;

ForSlash: Expr FORWARDSLASH Expr {
	   $$ := alcnode(FORSLASH, $1, alcleaf(FORWARDSLASH), $3)
	   }
	;

Occurrence: Expr CURLBRACKETS {
	   $$ := alcnode(OCCURRENCES, $1, alcleaf(CURLBRACKETS, yylval.s))
	   }
	;

%%

procedure yyerror(s)
   #
   # Eventually want to use merr for better error messaging.
   #

  write(&errout, s, " on line ", yylineno, " token '", yytext, "'")
  return 0
end
