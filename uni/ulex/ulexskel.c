#include <stdio.h>

void ulexskel(FILE *f)
{

fprintf(f, "%s\n", "#");
fprintf(f, "%s\n", "# ulex skeleton by Katrina Ray");
fprintf(f, "%s\n", "# May, 2003");
fprintf(f, "%s\n", "# do not edit by hand, this file is machine-generated");
fprintf(f, "%s\n\n", "#");

fprintf(f, "%s\n", "record edge(symbol, destinations)");
fprintf(f, "%s\n", "record anode(label, rulenum, edges, epsilon, dot)");
fprintf(f, "%s\n\n", "record automata(start, states, accepting)");

fprintf(f, "%s\n\n", "global yychar, yytext, yyin, yyleng");

fprintf(f, "%s\n", "#");
fprintf(f, "%s\n", "# matchstrings reads from a specified input file and calls the simulate ");
fprintf(f, "%s\n", "# function repeatedly on smaller and smaller pieces of the input until");
fprintf(f, "%s\n", "# it finds a match. It reports what parts of the input");
fprintf(f, "%s\n", "# it could parse and what rule accepted the string.");
fprintf(f, "%s\n\n", "#");

fprintf(f, "%s\n\n", "global stringseq");

fprintf(f, "%s\n", "procedure yyulex(aut)");
fprintf(f, "%s\n", "local rulenum, readfrom, position, less, currstring, getln");

fprintf(f, "%s\n", "initial {");
fprintf(f, "%s\n", "   if /yyin then yyin := &input");
fprintf(f, "%s\n", "   readfrom := yyin");

fprintf(f, "%s\n", "   stringseq := read(readfrom) || \"\\n\"");

fprintf(f, "%s\n", "   while getln := read(readfrom) do ");
fprintf(f, "%s\n", "      stringseq ||:= getln || \"\\n\"");

fprintf(f, "%s\n", "   close(readfrom)");
fprintf(f, "%s\n\n", "   }");

fprintf(f, "%s\n", "   if stringseq == \"\" then {");
fprintf(f, "%s\n", "      return yychar := -1");
fprintf(f, "%s\n\n", "      }");

fprintf(f, "%s\n", "   less := 0");
fprintf(f, "%s\n\n", "   position := *stringseq + 1");

fprintf(f, "%s\n", "   foo := 1");
fprintf(f, "%s\n", "   until (foo = *stringseq+1) | (simulate(aut, stringseq[1:foo]) === 0) do");
fprintf(f, "%s\n", "      foo+:=1");
fprintf(f, "%s\n", "   less := position-foo-1");
fprintf(f, "%s\n\n", "   if less < 0 then less := 0");

fprintf(f, "%s\n", "   while *stringseq > 0 do {");
fprintf(f, "%s\n", "      currstring := stringseq[1:position-less]");

fprintf(f, "%s\n", "      rulenum := simulate(aut, currstring)");

fprintf(f, "%s\n", "      if rulenum > 0 then {");
fprintf(f, "%s\n", "         yytext := currstring");
fprintf(f, "%s\n", "         yyleng := *yytext");

fprintf(f, "%s\n", "         stringseq := stringseq[position-less:position]");
fprintf(f, "%s\n", "         position := less + 1");

fprintf(f, "%s\n", "         foo := 1");
fprintf(f, "%s\n", "         until (foo = *stringseq+1) | (simulate(aut, stringseq[1:foo])=== 0) do");
fprintf(f, "%s\n", "            foo+:=1");
fprintf(f, "%s\n", "         less := position-foo-1");
fprintf(f, "%s\n", "         if less < 0 then less := 0");


fprintf(f, "%s\n", "         if yychar := (\\semantic_action)[rulenum] () then");
fprintf(f, "%s\n", "            return yychar");
fprintf(f, "%s\n", "         }");

fprintf(f, "%s\n", "      else {");
fprintf(f, "%s\n", "         less +:= 1");
fprintf(f, "%s\n", "         if less >= position then {");
fprintf(f, "%s\n", "            writes(stringseq[1]) # didn't match nothin', copy to stdout");
fprintf(f, "%s\n", "            stringseq := stringseq[2:0]");
fprintf(f, "%s\n", "            }");
fprintf(f, "%s\n", "         }");
fprintf(f, "%s\n", "    }");

fprintf(f, "%s\n", "end");

fprintf(f, "%s\n", "#");
fprintf(f, "%s\n", "# simulate takes an automata and a word and determines whether or not the ");
fprintf(f, "%s\n", "# word would be accepted by the given automata. It gets the possible ");
fprintf(f, "%s\n", "# destinations at each symbol of the string and then adds on wherever it");
fprintf(f, "%s\n", "# could also get if we use any epsilon transitions out of those states. Then");
fprintf(f, "%s\n", "# the list of accepting states is compared to the reachable set of states to");
fprintf(f, "%s\n", "# determine if the word was accepted and by which rule.");
fprintf(f, "%s\n", "#");

fprintf(f, "%s\n", "procedure simulate(myaut, word)");
fprintf(f, "%s\n", "local first, currstates, acceptcheck, currsymbol, build");

fprintf(f, "%s\n", "   currstates := list(0)");
fprintf(f, "%s\n", "   put(currstates, myaut.start)");

fprintf(f, "%s\n", "   acceptcheck := copy(myaut.accepting)");
fprintf(f, "%s\n", "   currsymbol := word");

fprintf(f, "%s\n", "   while *currsymbol > 0 do {");
fprintf(f, "%s\n", "      currstates := getdestinations(currstates, currsymbol)");
fprintf(f, "%s\n", "      if *currstates = 0 then");
fprintf(f, "%s\n", "         return 0");
fprintf(f, "%s\n", "      currsymbol := currsymbol[2:*currsymbol+1]");
fprintf(f, "%s\n", "      }");

fprintf(f, "%s\n", "   # add states reachable through epsilon transitions");

fprintf(f, "%s\n", "   build := copy(currstates)");
fprintf(f, "%s\n", "   while *build > 0 do {");
fprintf(f, "%s\n", "      current := pop(build)");
fprintf(f, "%s\n", "      currstates |||:= copy(current.epsilon)");
fprintf(f, "%s\n", "      build |||:= copy(current.epsilon)");
fprintf(f, "%s\n", "      }");
	
fprintf(f, "%s\n", "   while *acceptcheck > 0 do {");
fprintf(f, "%s\n", "      value1 := pop(acceptcheck)");
fprintf(f, "%s\n", "      check2 := copy(currstates)");

fprintf(f, "%s\n", "      while *check2 > 0 do {");
fprintf(f, "%s\n", "         value2 := pop(check2)");

fprintf(f, "%s\n", "         if value1.label = value2.label then");
fprintf(f, "%s\n", "            return value1.rulenum");
fprintf(f, "%s\n", "         }");
fprintf(f, "%s\n", "      }");
fprintf(f, "%s\n", "end");


fprintf(f, "%s\n", "#");
fprintf(f, "%s\n", "# getdestinations uses the current set of states and");
fprintf(f, "%s\n", "# simulates one step of automata computation on the given");
fprintf(f, "%s\n", "# string and returns the resulting set of destinations");
fprintf(f, "%s\n", "#");

fprintf(f, "%s\n", "procedure getdestinations(currstates, currsymbol)");
fprintf(f, "%s\n", "local result, current, buildresult");

fprintf(f, "%s\n", "   result := list(0)");
fprintf(f, "%s\n", "   if *currstates ~= 0 then {");

fprintf(f, "%s\n", "      # add states reachable through epsilon transitions");

fprintf(f, "%s\n", "      buildresult := copy(currstates)");

fprintf(f, "%s\n", "        while *buildresult > 0 do {");
fprintf(f, "%s\n", "          current := pop(buildresult)");
fprintf(f, "%s\n", "	  currstates |||:= copy(current.epsilon)");
fprintf(f, "%s\n", "          buildresult |||:= copy(current.epsilon)");
fprintf(f, "%s\n", "          }");

fprintf(f, "%s\n", "      buildresult := copy(currstates)");
fprintf(f, "%s\n", "      while *buildresult > 0 do");
fprintf(f, "%s\n", "          result |||:= reach(pop(buildresult), currsymbol)");
fprintf(f, "%s\n", "    }");
fprintf(f, "%s\n", "    return result");
fprintf(f, "%s\n", "end");

fprintf(f, "%s\n", "#");
fprintf(f, "%s\n", "# reach returns the list of states that can be reached");
fprintf(f, "%s\n", "# on character symbol from the state state.");
fprintf(f, "%s\n", "#");

fprintf(f, "%s\n", "procedure reach(state, symbol)");
fprintf(f, "%s\n", "local edgeset, answer, edgesymbol, bound1, bound2, curredge");

fprintf(f, "%s\n", "   edgeset := copy(state.edges)");
fprintf(f, "%s\n", "   answer := list(0)");

fprintf(f, "%s\n", "   while *edgeset > 0 do {");
fprintf(f, "%s\n", "      curredge := pop(edgeset)");
fprintf(f, "%s\n", "      edgesymbol := copy(curredge.symbol)");

fprintf(f, "%s\n", "      if edgesymbol[1] == symbol[1] then");
fprintf(f, "%s\n", "            answer |||:= curredge.destinations");

fprintf(f, "%s\n", "      else if edgesymbol[1] == \"[\" then {");

fprintf(f, "%s\n", "	  if edgesymbol[2]==\"^\" then {");
fprintf(f, "%s\n", "	      cs := edgesymbol[3:find(\"]\", edgesymbol)]");
fprintf(f, "%s\n", "	      if not find(symbol[1], cs) then");
fprintf(f, "%s\n", "		  answer |||:= curredge.destinations");
fprintf(f, "%s\n", "	  }");
fprintf(f, "%s\n", "	  else {");

fprintf(f, "%s\n", "         while edgesymbol[1] ~== \"]\" do {");
fprintf(f, "%s\n", "            edgesymbol := edgesymbol[2:*edgesymbol+1]");

fprintf(f, "%s\n", "            if edgesymbol[1] == \"\\\\\" then {");
fprintf(f, "%s\n", "               edgesymbol := edgesymbol[2:*edgesymbol+1]");

fprintf(f, "%s\n", "               if (edgesymbol[1] == \"n\") & (symbol[1] == \"\\n\") then");
fprintf(f, "%s\n", "                  answer |||:= curredge.destinations");
fprintf(f, "%s\n", "               else if (edgesymbol[1] == \"t\") & (symbol[1] == \"\\t\") then");
fprintf(f, "%s\n", "                  answer |||:= curredge.destinations");
fprintf(f, "%s\n", "               else if edgesymbol[1] == symbol[1] then");
fprintf(f, "%s\n", "                  answer |||:= curredge.destinations");
fprintf(f, "%s\n", "               }");

fprintf(f, "%s\n", "            else if edgesymbol[2] == \"-\" then {");
fprintf(f, "%s\n", "               bound1 := edgesymbol[1]");
fprintf(f, "%s\n", "               edgesymbol := edgesymbol[3:*edgesymbol+1]");
fprintf(f, "%s\n", "               bound2 := edgesymbol[1]");

fprintf(f, "%s\n", "               if ord(bound1) <= ord(symbol[1]) <= ord(bound2) then");
fprintf(f, "%s\n", "                  answer |||:= curredge.destinations");
fprintf(f, "%s\n", "               }");

fprintf(f, "%s\n", "            else if edgesymbol[1] == symbol[1] then");
fprintf(f, "%s\n", "                answer |||:= curredge.destinations");
fprintf(f, "%s\n", "          }");
fprintf(f, "%s\n", "          }");
fprintf(f, "%s\n", "      }");

fprintf(f, "%s\n", "      else if edgesymbol[1] == \"\\\\\" then {");
fprintf(f, "%s\n", "         if (edgesymbol[1] == \"n\") & (symbol[1] == \"\\n\") then");
fprintf(f, "%s\n", "            answer |||:= curredge.destinations");
fprintf(f, "%s\n", "         else if (edgesymbol[1] == \"t\") & (symbol[1] == \"\\t\") then");
fprintf(f, "%s\n", "            answer |||:= curredge.destinations");
fprintf(f, "%s\n", "         else if edgesymbol[1] == symbol[1] then");
fprintf(f, "%s\n", "            answer |||:= curredge.destinations");
fprintf(f, "%s\n", "         }");
fprintf(f, "%s\n", "      }");

fprintf(f, "%s\n", "   answer |||:= state.dot");
fprintf(f, "%s\n", "   return answer");
fprintf(f, "%s\n", "end");

fprintf(f, "%s\n", "procedure printstates(states)");
fprintf(f, "%s\n", "local statecopy, current");

fprintf(f, "%s\n", "   write(\"printstates on size \", *states, \" in entity \", image(states))");

fprintf(f, "%s\n", "   statecopy := copy(states)");

fprintf(f, "%s\n", "   while *statecopy > 1 do {");
fprintf(f, "%s\n", "      current := pop(statecopy)");
fprintf(f, "%s\n", "      write(current.label, \", \")");
fprintf(f, "%s\n", "      }");

fprintf(f, "%s\n", "   if *statecopy > 0 then {");
fprintf(f, "%s\n", "      current := pop(statecopy)");
fprintf(f, "%s\n", "      write(current.label)");
fprintf(f, "%s\n", "      }");

fprintf(f, "%s\n", "    else write(\"state list is empty\")");
fprintf(f, "%s\n", "end");
}
