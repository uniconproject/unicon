extern int _yyerror(char *, int);
#define yyerror(s) _yyerror(s, yystate)
