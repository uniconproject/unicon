%{
#
# VGo lexical analyzer, reference edition.
#

$include "go.tab.icn"

global lasttoken, yylineno
%}

float				([0-9]*\.[0-9]+)|([0-9]+\.)
exponent			[eE][-+]?[0-9]+

%%

"\n"			       { yylineno +:= 1
                                 if isender(lasttoken) then {
                                    yytext := ";"
                                    t := tok(";")
                                    yytoken.line := yylineno - 1
                                    return t
                                 }
                               }
[\t\f\v\r ]+		       {  }

"/*"([^*]|"*"+[^*/])*"*"+"/"   {  }
"//".*			       {  }

"{"			       { return tok("{") }
"}"			       { return tok("}") }
"["			       { return tok("[") }
"]"			       { return tok("]") }
"("			       { return tok("(") }
")"			       { return tok(")") }
";"			       { return tok(";") }
":"			       { return tok(":") }
"?"			       { return tok("?") }
"."			       { return tok(".") }
"..."			       { return tok(LDDD); }
"+"			       { return tok("+") }
"-"			       { return tok("-") }
"*"			       { return tok("*") }
"/"			       { return tok("/") }
"%"			       { return tok("%") }
"^"			       { return tok("^") }
"&"			       { return tok("&") }
"|"			       { return tok("|") }
"~"			       { return tok("~") }
"!"			       { return tok("!") }
"="			       { return tok(LASOP); }
":="			       { return tok(LCOLAS); }
"<"			       { return tok(LLT); }
">"			       { return tok(LGT); }
"+="			       { return tok(LASOP); }
"-="			       { return tok(LASOP); }
"*="			       { return tok(LASOP); }
"/="			       { return tok(LASOP); }
"%="			       { return tok(LASOP); }
"^="			       { return tok(LASOP); }
"&="			       { return tok(LASOP); }
"|="			       { return tok(LASOP); }
"<<"			       { return tok(LLSH); }
">>"			       { return tok(LRSH); }
"=="			       { return tok(LEQ); }
"!="			       { return tok(LNE); }
"<="			       { return tok(LLE); }
">="			       { return tok(LGE); }
"&&"			       { return tok(LANDAND); }
"&^"			       { return tok(LANDNOT); }
"||"			       { return tok(LOROR); }
"++"			       { return tok(LINC); }
"--"			       { return tok(LDEC); }
","			       { return tok(",") }
"<-"			       { return tok(LCOMM); }

"bool"			       { return tok(LNAME); }
"break"			       { return tok(LBREAK); }
"case"			       { return tok(LCASE); }
"chan"			       { return tok(LCHAN); }
"const"			       { return tok(LCONST); }
"continue"		       { return tok(LCONTINUE); }
"default"		       { return tok(LDEFAULT); }
"defer"			       { return tok(LDEFER); }
"else"			       { return tok(LELSE); }
"fallthrough"		       { return tok(LFALL); }
"float64"		       { return tok(LNAME); }
"for"			       { return tok(LFOR); }
"func"			       { return tok(LFUNC); }
"go"			       { return tok(LGO); }
"goto"			       { return tok(LGOTO); }
"if"			       { return tok(LIF); }
"import"		       { return tok(LIMPORT); }
"int"			       { return tok(LNAME); }
"interface"		       { return tok(LINTERFACE); }
"map"			       { return tok(LMAP); }
"package"		       { return tok(LPACKAGE); }
"range"			       { return tok(LRANGE); }
"return"		       { return tok(LRETURN); }
"select"		       { return tok(LSELECT); }
"struct"		       { return tok(LSTRUCT); }
"switch"		       { return tok(LSWITCH); }
"type"			       { return tok(LTYPE); }
"var"			       { return tok(LVAR); }

[a-zA-Z_][a-zA-Z_0-9]*	       { return tok(LNAME); }

"0"[xX][0-9a-fA-F]+	       { return tok(LLITERAL); }
"0"[0-7]+		       { return tok(LLITERAL); }
[0-9]+			       { return tok(LLITERAL); }

{float}{exponent}?	       { return tok(LLITERAL); }
[0-9]+{exponent}	       { return tok(LLITERAL); }

"'"(\\.|[^\\"])"'"	       { return tok(LCHLITERAL); }

"\""(\\.|[^\\"])*"\""	       { return tok(LSTLITERAL); }

.			       { stop(yylineno, ": unexpected character ",image(yytext[1])) }

%%

# succeed for tokens that require a newline to insert a semi-colon
# should be expanded
procedure isender(i)
   if i === (LNAME | LLITERAL | ord(")" | "}" | "]")) then return
end

global yytoken
record token(cat, text, line)

# allocate a token structure, set a global like yytoken; return the integer code
procedure tok(i)
   if type(i)=="string" then i := ord(i)
   yytoken := token(i, yytext, yylineno)
   lasttoken := i
   return i
end
