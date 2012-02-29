
%{
#
# Lexical specification for numbers.
#
%}

%%
\-?[0-9]+\.[0-9]+([eE][-+][0-9]+)?     { 
 write("accepted by rule 1: ", yytext) 
}
\n                                     { 
write("accepted by rule 2: ", yytext)
return 64
}
[\t]                                   { 
 write("accepted by rule 3: ", yytext) 
}
%%

procedure add(Num1, Num2)

return Num1 + Num2

end
