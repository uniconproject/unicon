%{
## add any special linking stuff here
global vars
 %}

 /* YACC Declarations */
 %token NUM NAME ASSIGNMENT
 %left '-' '+'
 %left '*' '/'
 %left NEG     /* negation--unary minus */
 %right '^'    /* exponentiation        */

 /* Grammar follows */
 %%
 input:    /* empty string */
              | input line
      ;

 line:  '\n'
        | exp '\n'  { write($1) }
        | NAME ASSIGNMENT exp '\n' {
              vars[$1] := $3
              write($3)
              }
        ;

 exp:      NUM                     { $$ := $1         }
        | NAME { $$ := vars[$1] }
              | exp '+' exp        { $$ := $1 + $3    }
              | exp '-' exp        { $$ := $1 - $3    }
              | exp '*' exp        { $$ := $1 * $3    }
              | exp '/' exp        { $$ := $1 / $3    }
              | '-' exp  %prec NEG { $$ := -$2        }
              | exp '^' exp        { $$ := $1 ^ $3    }
              | '(' exp ')'        { $$ := $2         }
      ;
 %%

 procedure yylex()
   local tok
   static token_char, line
   initial {
     token_char := ~ ' \t'
     line := ""
   }

   if line == "" then line := (read()||"\n") | exit()

   line ? while tab(upto(token_char)) do {
      if yylval := tab(many(&letters)) then tok := NAME
      else if yylval := tab(many(&digits++'.')) then tok := NUM
      else if yylval := =":=" then tok := ASSIGNMENT
      else { yylval := move(1); tok := ord(yylval) }
      line := tab(0)
      return tok
      }

   tok := ord('\n')
   line := ""
   return tok  # So we look like classic YACC example
 end

 procedure main(args)
   vars := table(0)
   write("IYACC Calculator Demo")
   repeat {
     write("expression:")
     yyparse()
   }
end
