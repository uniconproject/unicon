ws      [ \t]
nonws   [^ \t\n]
%{
global cc, wc, lc
%}
%%
{nonws}+        { cc+:=yyleng; wc+:= 1 }
{ws}+           { cc +:= yyleng }
\n              { lc +:= 1; cc +:= 1 }
%%
procedure main()
   cc := wc := lc := 0
   yylex()
   write(right(lc, 8), right(wc, 8), right(cc, 8))
end
