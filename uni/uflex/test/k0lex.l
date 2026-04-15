%{
$include "k0tok.icn"
%}

%%

"\n"					{ yylineno +:= 1
                                     if (isender(lasttoken)) then return tok(SEMI); }
[\t\f\v\r ]+				{ # Ignore whitespace.
					}

"//".*		{ # delete comment
                }

"fun"           { return tok(FUN); }
"while"         { return tok(WHILE); }
"if"            { return tok(IF); }
"null"          { return tok(NULLLITERAL); }
"true"          { return tok(BOOLEANLITERAL); }
"false"         { return tok(BOOLEANLITERAL); }
":"             { return tok(COLON); }
[a-z][a-z0-9]*  { return tok(IDENT); }
"("             { return tok(LPAREN); }
")"             { return tok(RPAREN); }
"{"             { return tok(LCURL); }
"}"             { return tok(RCURL); }
"<"             { return tok(LANGLE); }
">"             { return tok(RANGLE); }
";"             { return tok(SEMI); }
"="             { return tok(ASSIGNMENT); }
","             { return tok(COMMA); }
"?"             { return tok(QUEST); }
[0-9]+"."[0-9]* { return tok(REALLITERAL); }
[0-9]+          { return tok(INTEGERLITERAL); }
"\""[^\"]*"\""	{ return tok(STRINGLITERAL); }
"\'"[^\']*"\'"	{ return tok(CHARACTERLITERAL); }

%%

#
# return true for tokens that require a newline to insert a semi-colon
procedure isender(i)
#	switch(i) {
#	case IDENT: case RPAREN: case RCURL: /* case ']': */
 #       case REALLITERAL:
#        case NULLLITERAL:
#        case BOOLEANLITERAL:
#        case STRINGLITERAL:
#        case INTEGERLITERAL:
#        case CHARACTERLITERAL:
#	     return 1;
#	}
#	return 0;
end

global yytoken
record token(cat, text, line)
procedure tok(i)
   yytoken := token(i, yytext, yylineno)
   lasttoken := i
   return i
end
