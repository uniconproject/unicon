%{
$include "../../unicon/ytab_h.icn"
$define Beginner 1
$define Ender 2
$define Newline 4
record token(tok, s, line, column, filename)
%}
%%
"procedure" { write("procedure"); return PROCEDURE }
[a-z_][a-z_]* { write("IDENT"); return IDENT }
.    { lex_error() }
%%
procedure lex_error()
   yyerror("token not recognized ", image(yytext))
end
procedure uni_error(s)
   /errors := 0
   /s := "token not recognized"
write("uni_error calls yyerror ", image(s))
   yyerror(s)
   errors +:= 1
end

# implement semi-colon insert here, swap yylex:=:yylex2
procedure yylex2()
  static saved_tok, saved_yytext, seen_eof
  local rv
  if \seen_eof then return 0
  if \saved_tok then {
    rv := saved_tok
    saved_tok := &null
    yytext := saved_yytext
    yylval := yytoken := token(rv, yytext, yylineno, yycolno, yyfilename)
    if \debuglex then
      write("yylex() : ", tokenstr(rv), "\t", image(yytext))
    return rv
  }
  if /ender := iand(tokflags, Ender) then
      tokflags := 0
  if not (rv := yylex2()) then {
	 yytext := ""
	 if \debuglex then
	     write("yylex() : EOFX")
         seen_eof := 1
         return EOFX
  }
  if ender~=0 & iand(tokflags, Beginner)~=0 & iand(tokflags, Newline)~=0 then {
    saved_tok := rv
    saved_yytext := yytext
    yytext := ";"
    rv := SEMICOL
    }
   yylval := yytoken := token(rv, yytext, yylineno, yycolno, yyfilename)
   if \debuglex then
      write("yylex() : ", tokenstr(rv), "\t", image(yytext))
   return rv
end

# handle multi-line string, eating underscore-newline pairs and the leading
# spaces of the next line
procedure mls()
  outs := ""
  yytext ? {
     while outs ||:= tab(find("_\n")) do {
       move(2); tab(many(' \t'))
       }
     outs ||:= tab(0)
     }
  yytext := outs
  yyleng := *yytext
end
