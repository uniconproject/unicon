%{
#/* 
# * Adapted from from the Rust project's deleted lexer.l
# * via the Wayback Machine.

#// Copyright 2015 The Rust Project Developers. See the COPYRIGHT
#// file at the top-level directory of this distribution and at
#// http://rust-lang.org/COPYRIGHT.
#//
#// Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
#// http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
#// <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
#// option. This file may not be copied, modified, or distributed
#// except according to those terms.

# */

#include "token.h"
$include "rustgram.tab.icn"

global yylval
global yylineno
%}

ident [a-zA-Z\x80-\xff_][a-zA-Z0-9\x80-\xff_]*

%%

[ \t\r]               { }
[\n]                  { yylineno +:= 1 }
"//".*                { }
"\""([^\n"\\]|"\\"[\\nt"])*"\""            { return tok(LIT_STR); }

_        { return tok(UNDERSCORE); }
abstract { return tok(ABSTRACT); }
alignof  { return tok(ALIGNOF); }
as       { return tok(AS); }
become   { return tok(BECOME); }
box      { return tok(BOX); }
break    { return tok(BREAK); }
catch    { return tok(CATCH); }
const    { return tok(CONST); }
continue { return tok(CONTINUE); }
crate    { return tok(CRATE); }
default  { return tok(DEFAULT); }
do       { return tok(DO); }
else     { return tok(ELSE); }
enum     { return tok(ENUM); }
extern   { return tok(EXTERN); }
false    { return tok(FALSE); }
final    { return tok(FINAL); }
fn       { return tok(FN); }
for      { return tok(FOR); }
if       { return tok(IF); }
impl     { return tok(IMPL); }
in       { return tok(IN); }
let      { return tok(LET); }
loop     { return tok(LOOP); }
macro    { return tok(MACRO); }
match    { return tok(MATCH); }
mod      { return tok(MOD); }
move     { return tok(MOVE); }
mut      { return tok(MUT); }
offsetof { return tok(OFFSETOF); }
override { return tok(OVERRIDE); }
priv     { return tok(PRIV); }
proc     { return tok(PROC); }
pure     { return tok(PURE); }
pub      { return tok(PUB); }
ref      { return tok(REF); }
return   { return tok(RETURN); }
self     { return tok(SELF); }
sizeof   { return tok(SIZEOF); }
static   { return tok(STATIC); }
struct   { return tok(STRUCT); }
super    { return tok(SUPER); }
trait    { return tok(TRAIT); }
true     { return tok(TRUE); }
type     { return tok(TYPE); }
typeof   { return tok(TYPEOF); }
union    { return tok(UNION); }
unsafe   { return tok(UNSAFE); }
unsized  { return tok(UNSIZED); }
use      { return tok(USE); }
virtual  { return tok(VIRTUAL); }
where    { return tok(WHERE); }
while    { return tok(WHILE); }
yield    { return tok(YIELD); }

{ident}  { return tok(IDENT); }

0x[0-9a-fA-F_]+                                    { return tok(LIT_INTEGER); }
0o[0-7_]+                                          { return tok(LIT_INTEGER); }
0b[01_]+                                           { return tok(LIT_INTEGER); }
[0-9][0-9_]*                                       { return tok(LIT_INTEGER); }
[0-9][0-9_]*\.(\.|[a-zA-Z])    { yyless(yyleng - 2); return tok(LIT_INTEGER); }

[0-9][0-9_]*\.[0-9_]*([eE][-\+]?[0-9_]+)?          { return tok(LIT_FLOAT); }
[0-9][0-9_]*(\.[0-9_]*)?[eE][-\+]?[0-9_]+          { return tok(LIT_FLOAT); }

;      { return tok(';'); }
,      { return tok(','); }
\.\.\. { return tok(DOTDOTDOT); }
\.\.   { return tok(DOTDOT); }
\.     { return tok('.'); }
\(     { return tok('('); }
\)     { return tok(')'); }
\{     { return tok('{'); }
\}     { return tok('}'); }
\[     { return tok('['); }
\]     { return tok(']'); }
@      { return tok('@'); }

\~     { return tok('~'); }
::     { return tok(MOD_SEP); }
:      { return tok(':'); }
\$     { return tok('$'); }
\?     { return tok('?'); }

==    { return tok(EQEQ); }
=>    { return tok(FAT_ARROW); }
=     { return tok('='); }
\!=   { return tok(NE); }
\!    { return tok('!'); }
\<=   { return tok(LE); }
\<\<  { return tok(SHL); }
\<\<= { return tok(SHLEQ); }
\<    { return tok('<'); }
\>=   { return tok(GE); }
\>\>  { return tok(SHR); }
\>\>= { return tok(SHREQ); }
\>    { return tok('>'); }

\<-  { return tok(LARROW); }
-\>  { return tok(RARROW); }
-    { return tok('-'); }
-=   { return tok(MINUSEQ); }
&&   { return tok(ANDAND); }
&    { return tok('&'); }
&=   { return tok(ANDEQ); }
\|\| { return tok(OROR); }
\|   { return tok('|'); }
\|=  { return tok(OREQ); }
\+   { return tok('+'); }
\+=  { return tok(PLUSEQ); }
\*   { return tok('*'); }
\*=  { return tok(STAREQ); }
\/   { return tok('/'); }
\/=  { return tok(SLASHEQ); }
\^   { return tok('^'); }
\^=  { return tok(CARETEQ); }
%    { return tok('%'); }
%=   { return tok(PERCENTEQ); }

<<EOF>> { return 0; }

%%

global yytoken
record token(cat, text, line)

# allocate a token structure, set a global like yytoken, return the integer code
procedure tok(i)
   if type(i)=="string" then i := ord(i)
   yytoken := token(i, yytext, yylineno)
   return i
end
