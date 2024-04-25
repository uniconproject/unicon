%option noyywrap
%%
[a-zA-Z]+   { return 1; }
[0-9]+      { return 2; }
[ \t]+      { }
[^\n]       { fprintf(stderr, "unrecognized character %d yyleng %d\n",
               yytext[0], yyleng);
              exit(1); }
