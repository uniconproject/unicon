%{
# y_tab.icn contains the symbol definitions for integer values
# representing the terminal symbols NAME, NUMBER, and ASSIGNMENT.
# It is generated with iyacc -d calc.y

$include "y_tab.icn"
%}

letter [a-zA-Z_]
digiletter [a-zA-Z0-9_]

%%

{letter}{digiletter}*   { yylval := yytext; return NAME }

[0-9]+(\.[0-9]+)?       { yylval := numeric(yytext); return NUMBER }
\n                      { return 0 }
":="                    { return ASSIGNMENT }
[ \t]+
.                       { return ord(yytext) }

%%
