%{
# A Uflex Unicon lexer

$include "ytab_h.icn"
$define Beginner 1
$define Ender 2
$define Newline 4
record token(tok, s, line, column, filename)
%}

O [0-7]
D [0-9]
L [[:alpha:]_]
H [[:xdigit:]]
R [[:alnum:]]
FS [fFlL]
IS [uUlL]
W [ \t\v]
idchars [[:alnum:]_]
global yylineno, yycolno, yyfilename, tokflags, lastid, buffer, lastchar

%%

"abstract"  { return ABSTRACT }
"break"     { tokflags +:= Beginner+Ender; return BREAK }
"by"        { return BY }
"case"      { tokflags +:= Beginner; return CASE }
"class"     { return CLASS }
"create"    { tokflags +:= Beginner; return CREATE }
"critical"  { tokflags +:= Beginner; return CRITICAL }
"default"   { tokflags +:= Beginner; return DEFAULT }
"do"        { return DO }
"else"      { return ELSE }
"end"       { tokflags +:= Beginner; return END }
"every"     { tokflags +:= Beginner; return EVERY }
"fail"      { tokflags +:= Beginner+Ender; return FAIL }
"global"    { return GLOBAL }
"if"        { tokflags +:= Beginner; return IF }
"import"    { return IMPORT }
"initial"   { tokflags +:= Beginner; return iconINITIAL }
"initially" { tokflags +:= Ender; return INITIALLY }
"invocable" { return INVOCABLE }
"link"      { return LINK }
"local"     { tokflags +:= Beginner; return LOCAL }
"method"    { return METHOD }
"next"      { tokflags +:= Beginner+Ender; return NEXT }
"not"       { tokflags +:= Beginner; return NOT }
"of"        { return OF }
"package"   { return PACKAGE }
"procedure" { return PROCEDURE }
"record"    { return RECORD }
"repeat"    { tokflags +:= Beginner; return REPEAT }
"return"    { tokflags +:= Beginner+Ender; return RETURN }
"static"    { tokflags +:= Beginner; return STATIC }
"suspend"   { tokflags +:= Beginner+Ender; return SUSPEND }
"then"      { return THEN }
"thread"    { tokflags +:= Beginner; return THREAD }
"to"        { return TO }
"until"     { tokflags +:= Beginner; return UNTIL }
"while"     { tokflags +:= Beginner; return WHILE }
{L}{idchars}* { tokflags +:= Beginner+Ender; return IDENT }

\'([^'\\\n]|"\\"([bdeflnrtv'"\\+\-]|("^"[a-z])|("x"[0-9a-fA-F][0-9a-fA-F])|0|([0123][0-7][0-7])))*\' { tokflags +:= Beginner + Ender; return CSETLIT }
\"([^"\\\n]|"_\n"|"\\"([bdeflnrtv'"\\+\-]|("^"[a-z])|("x"[0-9a-fA-F][0-9a-fA-F])|0|([0123][0-7][0-7])))*\" { tokflags +:= Beginner + Ender; mls(); return STRINGLIT }
"!"    { tokflags +:= Beginner; return BANG }
"%"    { return MOD }
"%:="  { return AUGMOD }
"&"    { tokflags +:= Beginner; return AND }
"&&"   { return PAND }
"&:="  { return AUGAND }
"*"    { tokflags +:= Beginner; return STAR }
"**"   { tokflags +:= Beginner; return INTER }
"**:=" { return AUGINTER }
"*:="  { return AUGSTAR }
"+"    { tokflags +:= Beginner; return PLUS }
"++"   { tokflags +:= Beginner; return UNION }
"++:=" { return AUGUNION }
"+:"   { return PCOLON }
"+:="  { return AUGPLUS }
"-"    { tokflags +:= Beginner; return MINUS }
"->"   { return PASSNONMATCH }
"--"   { tokflags +:= Beginner; return DIFF }
"--:=" { return AUGDIFF }
"-:"   { return MCOLON }
"-:="  { return AUGMINUS }
"."    { tokflags +:= Beginner; return DOT }
".$"   { return PSETCUR }
".>"   {
   # missing logic here if next_gt_is_ender === 1 then ...
   return PSETCUR
   }
".|" { return POR }
"."[0-9]+ { tokflags +:= Beginner + Ender; return REALLIT }
"/"     { tokflags +:= Beginner; return SLASH }
"/:="   { return AUGSLASH }
":"     { return COLON }
"::"    { tokflags +:= Beginner; return COLONCOLON }
":="    { return ASSIGN }
":=:"   { return SWAP }
"<"     { return NMLT }
"<="    { return NMLE }
"<=:="  { return AUGNMLE }
"<<"    { return SLT }
"<<="   { return SLE }
"<<=:=" { return AUGSLE }
"<<:=" { return AUGSLT }
"<<@" { tokflags +:= Beginner + Ender; return RCVBK }
"<-" { return REVASSIGN }
"<->" { return REVSWAP }
"<:=" { return AUGNMLT }
"<@" { tokflags +:= Beginner + Ender; return RCV }
"=" { tokflags +:= Beginner; return NMEQ }
"=>" { return PIMDASSN }
"=:=" { return AUGNMEQ }
"==" { tokflags +:= Beginner; return SEQ }
"==:=" { return AUGSEQ }
"===" { tokflags  +:= Beginner; return EQUIV }
"===:=" { return AUGEQUIV }
">" {
   if \next_gt_is_ender then {
      tokflags +:= Ender
      next_gt_is_ender := &null
      }
   return NMGT
   }
">=" { return NMGE }
">=:=" { return AUGNMGE }
">>" { return SGT }
">>=" { return SGE }
">>=:=" { return AUGSGE }
">>:=" { return AUGSGT }
">:=" { return AUGNMGT }
"?" { tokflags +:= Beginner; return QMARK }
"??" { return PMATCH }
"?:=" { return AUGQMARK  }
"@" { tokflags +:= Beginner; return AT }
"@>>" { tokflags +:= Beginner + Ender; return SNDBK }
"@>"  { tokflags +:= Beginner + Ender; return SND }
"@:=" { return AUGAT }
"\\" { tokflags +:= Beginner; return BACKSLASH }
"^" { tokflags +:= Beginner; return CARET }
"^:=" { return AUGCARET }
"|" { tokflags +:= Beginner; return BAR }
"||" { tokflags +:= Beginner; return CONCAT }
"|||" { tokflags +:= Beginner; return LCONCAT }
"||:=" { return AUGCONCAT }
"|||:=" { return AUGLCONCAT }
"~" { tokflags +:= Beginner; return TILDE }
"~=" { tokflags +:= Beginner; return NMNE }
"~=:=" { return AUGNMNE }
"~==" { tokflags +:= Beginner; return SNE }
"~==:=" { return AUGSNE }
"~===" { tokflags +:= Beginner; return NEQUIV }
"~===:=" { return AUGNEQUIV }
"(" { tokflags +:= Beginner; return LPAREN }
")" { tokflags +:= Ender; return RPAREN }
"[" { tokflags +:= Beginner; return LBRACK }
"]" { tokflags +:= Ender; return RBRACK }
"{" { tokflags +:= Beginner; return LBRACE }
"}" { tokflags +:= Ender; return RBRACE }
"," { return COMMA }
";" { return SEMICOL }
"$(" { tokflags +:= Beginner; return LBRACE }
"$)" { tokflags +:= Ender; return RBRACE }
"$<" { tokflags +:= Beginner; return LBRACK }
"$>" { tokflags +:= Ender; return RBRACK}
"$$" { return PIMDASSN }
"$" { return DOLLAR }
"``"[^`]*"``" { tokflags +:= Ender; return PUNEVAL }
"`"[^`]*"`" { tokeflags +:= Ender; return PUNEVAL }
{D}+ { tokflags +:= Beginner+Ender; return INTLIT }
{D}+[rR]{R}+ { tokflags +:= Beginner+Ender; return INTLIT }
{D}+[kK] { tokflags +:= Beginner+Ender; yytext:=string(yytext[1:-1]*1024); return INTLIT }
{D}+[mM] { tokflags +:= Beginner+Ender; yytext:=string(yytext[1:-1]*1024^2); return INTLIT }
{D}+[gG] { tokflags +:= Beginner+Ender; yytext:=string(yytext[1:-1]*1024^3); return INTLIT }
{D}+[tT] { tokflags +:= Beginner+Ender; yytext:=string(yytext[1:-1]*1024^4); return INTLIT }
{D}+[pP] { tokflags +:= Beginner+Ender; yytext:=string(yytext[1:-1]*1024^5); return INTLIT }
{D}+[dD]{D}+ { tokflags +:= Beginner+Ender; return INTLIT }
{D}+((([eE][+\-]?){D}+)?) { tokflags +:= Beginner+Ender; return REALLIT }
{D}+\.{D}+ { tokflags +:= Beginner+Ender; return REALLIT }
{D}+\.{D}*((([eE][+\-]?){D}+)?) { tokflags +:= Beginner+Ender; return REALLIT }
"#line "[0-9]+ \"[^\"]*\".* {
   yytext ? { move(6)
      yylineno := integer(tab(many(&digits)));
      if =" \"" & (new_filename := tab(find("\""))) then
         yyfilename := new_filename
      }
   }
"#".* { }
"\n" { yylineno +:= 1; yycolno := 1;
       if tokflags < Newline then tokflags +:= Newline }
" " { yycolno +:= 1 }
[\v\014] { }
"\t"  { yycolno +:= 1; while(yycolno-1)%8~=0 do yycolno +:= 1 }
. { stop("unrecognized character ", yytext) }

%%

procedure lex_error()
   yyerror("token not recognized")
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
