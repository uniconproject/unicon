%{

## add any special linking stuff here

 %}
      
 /* YACC Declarations */
 %token NUM
 %left '-' '+'
 %left '*' '/'
 %left NEG     /* negation--unary minus */
 %right '^'    /* exponentiation        */
      
 /* Grammar follows */
 %%
 input:    /* empty string */
              | input line
      ;
      
 line:     '\n'
           | exp '\n'  { write($1) }
      ;
      
 exp:      NUM                     { $$ := $1         }
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
   
   if line == "" then 
      line := read() | exit()

   #line := " ( 3 + 5 ) * 2"
   line ? while tab(upto(token_char)) do {
     yylval := tab(many(token_char))
     if real(yylval) then tok := NUM
                     else tok := ord(yylval[1])
     line := tab(0)
     return tok
   }   

   tok := ord('\n')
   line := ""
   return tok  # So we look like classic YACC example
 end

 procedure main(args)
   yydebug := 0	 # set to 1 to print error recovery details
   debug   := 0  # comment out line to enable debug trace

   write("IYACC Calculator Demo")
   write("Note: Since this example uses a small string scanner")
   write("for simplicity, you will need to separate the items")
   write("with spaces, i.e.:  '( 3 + 5 ) * 2'")
   repeat {   
     write("expression:") 
     yyparse()
   }
end
