%{

# Simple Python scanner implementation in Flex

$include "punygram.tab.icn"
global yylineno, yytoken

global dentstack
global rows, words, column
global dedentcount
global firsttime, firsttime1
global lasttoken
global parencount, squarecount, curlycount

$define yylex real_yylex
%}
%%
<<EOF>>         { firsttime1 +:= 1
                  if (firsttime1 = 1) & (lasttoken ~= NEWLINE) then {
                     return alcleaf(NEWLINE); }
		  if *dentstack > 0 then { pop(dentstack); return alcleaf(DEDENT); }
                  firsttime +:= 1
                  if firsttime = 1 then return alcleaf(ENDMARKER)
                  else return -1; }
"#".*
\n[ \t]*"#".*
\\\n		{ rows +:=1; column := 1; }
\r		{ column:=1; }
\n[ \t]*((\r)?\n[ \t]*("#".*)?)* {

		  if (parencount=curlycount) &
		     (curlycount=squarecount) &
		     (squarecount=0) then {

                  il := indentlevel(yytext[2:0])
                  rows +:= 1; column := il+1;
                  if il > dentstack[1] then {
                    push(dentstack, il)
                    # return an INDENT token, except NEWLINE first
		    dedentcount := -1;
                    }
		  else if il < dentstack[1] then {
                    # return one or more DEDENT tokens
		    dedentcount := 0
                    # count how many
		    while *dentstack > 0 & dentstack[1]>il do {
                       dedentcount +:=1; pop(dentstack) }
		    if dentstack[1] ~= il then {

# disable this if you want blanklines on EOFs to trigger errors
c := input();
if c > 0 then {
unput(c);

		       fprintf(stderr, "Python indent error line %d\n", yylineno);
		       fflush(stderr); exit(1);
}
		       }
		    # need to dedent by dedentcount, but returning NEWLINE
                    }
		  else {
                    # still at ILEVEL il, no INDENT or DEDENT
                    }
                  rows+:=1; column+:=1;
                  return alcleaf(NEWLINE);
		  }
		}
"("             { parencount+:=1; return alcleaf("("); }
")"             { if parencount>0 then parencount-:=1; return alcleaf(")"); }
"{"             { curlycount+:=1; return alcleaf("{"); }
"}"             { if curlycount>0 then curlycount-:=1; return alcleaf("}"); }
"["             { squarecount+:=1; return alcleaf("["); }
"]"             { if squarecount>0 then squarecount-:=1; return alcleaf("]"); }
","		{ return alcleaf(","); }
":"		{ return alcleaf(":"); }
"<"             { return alcleaf("<"); }
">"             { return alcleaf(">"); }
"<="            { return alcleaf(LTEQ); }
">="            { return alcleaf(GTEQ); }
"="             { return alcleaf("="); }
"=="            { return alcleaf(EQUALS); }
"!="            { return alcleaf(NOTEQUALS); }
"<>"            { return alcleaf(NOTEQUALS); }
"+"		{ return alcleaf("+"); }
"-"		{ return alcleaf("-"); }
"~"		{ return alcleaf("~"); }
"->"            { return alcleaf(ARROW); }
"*"		{ return alcleaf("*"); }
"**"		{ return alcleaf(POWER); }
"."             { return alcleaf("."); }
"/"		{ return alcleaf("/"); }
"%"		{ return alcleaf("%"); }
("+="|"-=")	{ return alcleaf(AUGASGN); }
"\""[^"\n]*"\""     { return alcleaf(STRINGLIT); }
"\'"[^'\n]*"\'"     { return alcleaf(STRINGLIT); }
"\"\"\""([^"]|"\""[^"]|"\"\""[^"])*"\"\"\""     { return alcleaf(STRINGLIT); }
"\'\'\'"([^']|"\'"[^']|"\'\'"[^'])*"\'\'\'"     { return alcleaf(STRINGLIT); }
and    { return alcleaf(AND); }
or     { return alcleaf(OR); }
def    { return alcleaf(DEF); }
del    { return alcleaf(DEL); }
for    { return alcleaf(FOR); }
global { return alcleaf(GLOBAL); }
return { return alcleaf(RETURN); }
while  { return alcleaf(WHILE); }
elif   { return alcleaf(ELIF); }
else   { return alcleaf(ELSE); }
if     { return alcleaf(IF); }
import { return alcleaf(IMPORT); }
in     { return alcleaf(IN); }
as     { return alcleaf(AS); }
with   { return alcleaf(WITH); }
([0-9]+("."[0-9]+)?)|("."[0-9]+) {
     words+:=1; column +:= *yytext
     return alcleaf(NUMBER);
}
[A-Za-z_][A-Za-z0-9_]*	{
     words+:=1; column +:= *yytext
# ??? alctree a leaf node for this terminal symbol
     return alcleaf(NAME);
     }
[ ]		{ column+:=1; }
.		{ fprintf(stderr, "line %d: lexical error on '%c' (%d)\n",
		  yylineno,yytext[0],yytext[0]); fflush(stderr); exit(1); }
%%

#/*
# * This was originally a clean space counter.
# * It was extended to consume blank lines with spaces on them, so that extra
# * INDENT tokens would not be generated on blank lines that Python3 does not
# * complain about.
# */
procedure indentlevel(s)
   local s2
   local column := 1
   while i := find("\n", s) do s := s[i+1:0]
   while *s > 0 do {
      if (s[1] == "\t") then {
         column +:= 1;                            # tab adds at least one space
         while (((column-1) % 8) ~= 0) do
            column +:= 1;
      }
      else if (s[1] == " ") then column +:= 1
      else { column+:=1; printf("but wtf is %c\n", s[1]);}
      s := s[2:0]
   }
   return column-1
end

$undef yylex

procedure yylex()
local rv
   if dedentcount<0 then {
      dedentcount +:= 1
      lasttoken := INDENT
      return alcleaf(INDENT)
      }
   if dedentcount>0 then {
      dedentcount -:= 1
      lasttoken := DEDENT
      return alcleaf(DEDENT)
      }
   if rv := real_yylex() then {
      lasttoken := rv
      return rv
      }
end

# allocate a token structure, set a global like yytoken, return the integer code
record token(cat, text, line)
procedure alcleaf(i)
   if type(i)=="string" then i := ord(i)
   yytoken := token(i, yytext, yylineno)
   return i
end

global yylineno

procedure main(argv)
    dentstack := []
    words := 0
    rows := column := 1
    dedentcount := 0
    firsttime := firsttime1 := 0
    parencount := squarecount := curlycount := 0
    yylineno := 1
    yyin := open(argv[1]) | stop("usage: punylex filename")
    while (i := yylex()) do {
write("i: ", image(i))
write(yytoken.cat, ":",yytoken.line, " ", image(yytoken.text))
        yytoken := &null
    }
end
