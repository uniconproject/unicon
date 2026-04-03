DIGIT=[0-9]
ID=[a-zA-Z][a-zA-Z0-9]*
%%
{DIGIT}+                   { write("An integer: ", yytext); }

{DIGIT}+"."{DIGIT}*        { write("An float: ", yytext); }

if|then|begin|end|procedure|function        {
                       write( "A keyword: ", yytext );
                       }

{ID}        { write( "An identifier: ", yytext ); }

"+"|"-"|"*"|"/"   { write( "An operator: ", yytext ); }

"'"|","|";"|"!"|"("|")"|"."   { write( "Punctuation: ", yytext ); }

"{"[^}\n]*"}"     { }

[ \t\n]+          { }

.         {  write( "Unrecognized character: ", image(yytext) ); }

%%
