O        [0-7]
D        [0-9]
L        [a-zA-Z_]
H        [a-fA-F0-9]
E        [Ee][+-]?{D}+
FS       (f|F|l|L)
IS       (u|U|l|L)
W        [ \t\f]*
LIT      \"(\\.|[^\\"])*\"

%{
$include "cgram.tab.icn"

global errors
global included_stdio
global saved_yyin
%}
%%

\n                      { yylineno +:= 1; }
[ \t\f]+                { }

"break"                 { return tok(BREAK); }
"case"                  { return tok(CASE); }
"char"                  { return tok(CHAR); }
"const"                 { return tok(CONST); }
"continue"              { return tok(CONTINUE); }
"default"               { return tok(DEFAULT); }
"do"                    { return tok(DO); }
"double"                { return tok(DOUBLE); }
"else"                  { return tok(ELSE); }
"enum"                  { return tok(ENUM); }
"extern"                { return tok(EXTERN); }
"float"                 { return tok(FLOAT); }
"for"                   { return tok(FOR); }
"goto"                  { return tok(GOTO); }
"if"                    { return tok(IF); }
"int"                   { return tok(INT); }
"long"                  { return tok(LONG); }
"register"              { return tok(REGISTER); }
"return"                { return tok(RETURN); }
"short"                 { return tok(SHORT); }
"signed"                { return tok(SIGNED); }
"sizeof"                { return tok(SIZEOF); }
"static"                { return tok(STATIC); }
"struct"                { return tok(STRUCT); }
"switch"                { return tok(SWITCH); }
"typedef"               { return tok(TYPEDEF); }
"union"                 { return tok(UNION); }
"unsigned"              { return tok(UNSIGNED); }
"void"                  { return tok(VOID); }
"volatile"              { return tok(VOLATILE); }
"while"                 { return tok(WHILE); }

{L}({L}|{D})*           { return tok(IDENTIFIER); }


0[xX]{H}+{IS}?          { lexerr("Hex not supported\n"); }

0{O}+{IS}?              { lexerr("Octal not supported\n"); }

{D}+{IS}?               { return tok(ICON); }

'(\\.|[^\\'])+'         { return tok(CCON); }

{D}+{E}{FS}?            { return tok(FCON); }
{D}*"."{D}+({E})?{FS}?  { return tok(FCON); }
{D}+"."{D}*({E})?{FS}?  { return tok(FCON); }

{LIT}                   { return tok(STRING); }

"#include"[ ]*\"[^\\"]+\"  { handle_include(); }

"#include <stdio.h>"   { included_stdio := 1; }
"#include"[ ]*\<[^\\"]+\>  { handle_system_include(); }

">>="                   { return tok(SRASN); }
"<<="                   { return tok(SLASN); }
"+="                    { return tok(PLASN); }
"-="                    { return tok(MIASN); }
"*="                    { return tok(MUASN); }
"/="                    { return tok(DIASN); }
"%="                    { return tok(MOASN); }
"&="                    { return tok(ANASN); }
"^="                    { return tok(ERASN); }
"|="                    { return tok(ORASN); }
">>"                    { return tok(SHR); }
"<<"                    { return tok(SHL); }
"++"                    { return tok(INCOP); }
"--"                    { return tok(DECOP); }
"->"                    { return tok(FOLLOW); }
"&&"                    { return tok(ANDAND); }
"||"                    { return tok(OROR); }
"<="                    { return tok(LE); }
">="                    { return tok(GE); }
"=="                    { return tok(EQ); }
"!="                    { return tok(NE); }
";"                     { return tok(SM); }
"{"                     { return tok(LC); }
"}"                     { return tok(RC); }
","                     { return tok(CM); }
":"                     { return tok(COLON); }
"="                     { return tok(ASN); }
"("                     { return tok(LP); }
")"                     { return tok(RP); }
"["                     { return tok(LB); }
"]"                     { return tok(RB); }
"."                     { return tok(DOT); }
"&"                     { return tok(AND); }
"!"                     { return tok(BANG); }
"~"                     { return tok(NOT); }
"-"                     { return tok(MINUS); }
"+"                     { return tok(PLUS); }
"*"                     { return tok(MUL); }
"/"                     { return tok(DIV); }
"%"                     { return tok(MOD); }
"<"                     { return tok(LT); }
">"                     { return tok(GT); }
"^"                     { return tok(ER); }
"|"                     { return tok(OR); }
"?"                     { return tok(QUEST); }
%%

procedure lexerr(s)
	errors+:=1
	writes(&errout, s, ": lexical error")

	# to do: add mechanism for reporting file name and line number

	write(&errout, ", token = \"",yytext,"\"");
end

#
# Return 1 if done, 0 if yyin points at more input
#
procedure yywrap()
   return 1
end

procedure handle_include()
$ifndef notdef
  stop("user includes not yet supported")
$else
   saved_yyin := yyin
  yytext ? {
     tab(find("\"")+1)
     fname := tab(find("\""))
     # fprintf(stdout, "included filename '%s'\n", fname); fflush(stdout);
     if not (yyin := open(fname)) then {
        lexerr("cannot open include file")
        exit(1)
        }
$endif
end

procedure memerr()
   write(&errout, "out of memory")
   exit(1)
end

global serial
global yytoken

# allocate a token structure, set a global like yytoken, return the integer code
record token(cat, text, line)
procedure tok(i)
   if type(i)=="string" then i := ord(i)
   yytoken := token(i, yytext, yylineno)
   return i
end
