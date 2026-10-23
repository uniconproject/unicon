ws      [ \t]
nonws   [^ \t\n]
%{
global cc, wc, lc, yyin
%}
%%
{nonws}+        { cc+:=yyleng; wc+:= 1 }
{ws}+           { cc +:= yyleng }
\n              { lc +:= 1; cc +:= 1 }
%%
# Count lines, words and characters in a file (or files).
# It should give the same results as wc.l but does it by supplying the input
# as a string one line at at a time to yylex() rather than via the standard input.
# The point is not efficiency -- this is less efficient -- but to test a sequence
# of string inputs to yylex().
procedure main(args)
   local f

   cc := wc := lc := 0
   while f := open(pop(args)) do {
      every yysetyyin(!f || "\n") do yylex()
      close(f)
   }
   write(right(lc, 8), right(wc, 8), right(cc, 8))
end

