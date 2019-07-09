#include <stdio.h>

void ulexskel(FILE *f)
{
fprintf(f, "%s",
   "#\n"
   "# ulex skeleton by Katrina Ray. hacked by jeffery.\n"
   "# do not edit by hand, this file is machine-generated\n"
   "#\n\n"

   "record edge(symbol, destinations)\n"
   "record anode(label, rulenum, edges, epsilon, dot)\n"
   "record automata(start, states, accepting)\n\n"

   "global yychar, yytext, yyin, yyleng\n\n"

   "#\n"
   "# matchstrings reads from a specified input file and calls the simulate\n"
   "# function repeatedly on smaller and smaller pieces of the input until\n"
   "# it finds a match. It reports what parts of the input\n"
   "# it could parse and what rule accepted the string.\n"
   "#\n\n"

   "global stringseq\n\n");

fprintf(f, "%s",
   "procedure yyulex(aut)\n"
   "local rulenum, readfrom, position, less, currstring, getln\n\n"

   "initial {\n"
   "   if /yyin then yyin := &input\n"
   "   readfrom := yyin\n\n"

   "   stringseq := read(readfrom) || \"\\n\"\n\n"

   "   while getln := read(readfrom) do\n"
   "      stringseq ||:= getln || \"\\n\"\n\n"

   "   close(readfrom)\n"
   "   }\n\n"

   "   if stringseq == \"\" then {\n"
   "      return yychar := -1\n"
   "      }\n\n"

   "   less := 0\n"
   "   position := *stringseq + 1\n\n"

   "   foo := 1\n"
   "   until (foo = *stringseq+1) | (simulate(aut, stringseq[1:foo])===0) do\n"
   "      foo +:= 1\n"
   "   less := position - foo - 1\n"
   "   if less < 0 then less := 0\n\n"

   "   while *stringseq > 0 do {\n"
   "      currstring := stringseq[1:position-less]\n"

   "      rulenum := simulate(aut, currstring)\n"

   "      if rulenum > 0 then {\n"
   "         yytext := currstring\n"
   "         yyleng := *yytext\n"

   "         stringseq := stringseq[position-less:position]\n"
   "         position := less + 1\n"

   "         foo := 1\n"
   "         until (foo = *stringseq+1) | (simulate(aut, stringseq[1:foo])=== 0) do\n"
   "            foo +:= 1\n"
   "         less := position-foo-1\n"
   "         if less < 0 then less := 0\n\n"

   "         if yychar := (\\semantic_action)[rulenum] () then\n"
   "            return yychar\n"
   "         }\n"

   "      else {\n"
   "         less +:= 1\n"
   "         if less >= position then {\n"
   "            writes(stringseq[1]) # didn't match nothin', copy to stdout\n"
   "            stringseq := stringseq[2:0]\n"
   "            }\n"
   "         }\n"
   "      }\n"

   "end\n\n");

fprintf(f, "%s",
   "#\n"
   "# simulate(automata, word) determines whether or not the word\n"
   "# would be accepted by the given automata. It gets the possible\n"
   "# destinations at each symbol of the string and then adds on wherever it\n"
   "# could also get if we use any epsilon transitions out of those states.\n"
   "# Then the list of accepting states is compared to the reachable set\n"
   "# of states to determine if the word was accepted and by which rule.\n"
   "#\n"

   "procedure simulate(myaut, word)\n"
   "local first, currstates, acceptcheck, currsymbol, build, rv\n"

   "   currstates := list(0) # should be set()\n"
   "   put(currstates, myaut.start) # insert(currstates, myaut.start)\n"

   "   acceptcheck := copy(myaut.accepting)\n"
   "   currsymbol := word\n"

   "   while *currsymbol > 0 do {\n"
   "      currstates := getdestinations(currstates, currsymbol)\n"
   "      if *currstates = 0 then\n"
   "         return 0\n"
   "      currsymbol := currsymbol[2:0]\n"

   "      # add states reachable through epsilon transitions\n"

   "      build := copy(currstates)\n"
   "      while *build > 0 do {\n"
   "         current := pop(build)\n"
   "         currstates |||:= copy(current.epsilon)\n"
   "         build |||:= copy(current.epsilon)\n"
   "         }\n"
   "      }\n\n"
	
   "   while *acceptcheck > 0 do {\n"
   "      value1 := pop(acceptcheck)\n"
   "      check2 := copy(currstates)\n"

   "      while *check2 > 0 do {\n"
   "         value2 := pop(check2)\n"

   "         if value1.label = value2.label then {\n"
   "            if /rv | rv > value1.rulenum then\n"
   "               rv := value1.rulenum\n"
   "            }\n"
   "         }\n"
   "      }\n"
   "   if \\yydebug>0 then write(\"simulate() returns \", image(\\rv)|0)\n"
   "   return \\rv | 0\n"
   "end\n\n");

fprintf(f, "%s",
   "#\n"
   "# getdestinations uses the current set of states and\n"
   "# simulates one step of automata computation on the given\n"
   "# string and returns the resulting set of destinations\n"
   "#\n"

   "procedure getdestinations(currstates, currsymbol)\n"
   "local result, current, buildresult\n\n"

   "   result := list(0)\n"
   "   if *currstates ~= 0 then {\n\n"

   "      # add states reachable through epsilon transitions\n"
   "      buildresult := copy(currstates)\n"

   "      while *buildresult > 0 do {\n"
   "         current := pop(buildresult)\n"
   "         currstates |||:= copy(current.epsilon)\n"
   "         buildresult |||:= copy(current.epsilon)\n"
   "         }\n\n"

   "      buildresult := copy(currstates)\n"
   "      while *buildresult > 0 do\n"
   "          result |||:= reach(pop(buildresult), currsymbol)\n"
   "      buildresult := copy(result)\n"
   "      while *buildresult > 0 do {\n"
   "         current := pop(buildresult)\n"
   "         result |||:= copy(current.epsilon)\n"
   "         buildresult |||:= copy(current.epsilon)\n"
   "         }\n"
   "    }\n"
   "    return result\n"
   "end\n\n");

fprintf(f, "%s",
   "#\n"
   "# reach returns the list of states that can be reached\n"
   "# on character symbol from the state state.\n"
   "#\n"

   "procedure reach(state, symbol)\n"
   "local edgeset, answer, edgesymbol, bound1, bound2, curredge\n\n"

   "   edgeset := copy(state.edges)\n"
   "   answer := list(0)\n\n"

   "   while *edgeset > 0 do {\n"
   "      curredge := pop(edgeset)\n"
   "      edgesymbol := copy(curredge.symbol)\n"

   "      if (edgesymbol[1] == symbol[1] ~== \"[\") |\n"
   "         (edgesymbol == symbol == \"[\") then # sometimes a [ is just a [\n"
   "            answer |||:= curredge.destinations\n"

   "      else if edgesymbol[1] == \"[\" then {\n\n"

   "	 if edgesymbol[2]==\"^\" then {\n"
   "	    cs := edgesymbol[3:find(\"]\", edgesymbol)]\n"
   "	    if not find(symbol[1], cs) then\n"
   "	       answer |||:= curredge.destinations\n"
   "	    }\n"
   "	 else {\n"

   "	    while edgesymbol[1] ~== \"]\" do {\n"
   "	       edgesymbol := edgesymbol[2:0]\n\n"

   "	       if edgesymbol[1] == \"\\\\\" then {\n"
   "	          edgesymbol := edgesymbol[2:0]\n"

   "	          if (edgesymbol[1] == \"n\") & (symbol[1] == \"\\n\") then\n"
   "	             answer |||:= curredge.destinations\n"
   "	          else if (edgesymbol[1] == \"t\") & (symbol[1] == \"\\t\") then\n"
   "	             answer |||:= curredge.destinations\n"
   "	          else if edgesymbol[1] == symbol[1] then\n"
   "	             answer |||:= curredge.destinations\n"
   "	          }\n\n"

   "	       else if edgesymbol[2] == \"-\" then {\n"
   "	          bound1 := edgesymbol[1]\n"
   "	          edgesymbol := edgesymbol[3:0]\n"
   "	          bound2 := edgesymbol[1]\n"

   "	          if ord(bound1) <= ord(symbol[1]) <= ord(bound2) then\n"
   "	             answer |||:= curredge.destinations\n"
   "	          }\n"

   "	       else if edgesymbol[1] == symbol[1] then\n"
   "	          answer |||:= curredge.destinations\n"
   "	       }\n"
   "	    }\n"
   "	 }\n\n"

   "	 else if edgesymbol[1] == \"\\\\\" then {\n"
   "	    if (edgesymbol[2] == \"n\") & (symbol[1] == \"\\n\") then\n"
   "	       answer |||:= curredge.destinations\n"
   "	    else if (edgesymbol[2] == \"t\") & (symbol[1] == \"\\t\") then\n"
   "	       answer |||:= curredge.destinations\n"
   "	    else if edgesymbol[2] == symbol[1] then\n"
   "	       answer |||:= curredge.destinations\n"
   "	    }\n"
   "	 }\n\n"

   "   answer |||:= state.dot\n"
   "   return answer\n"
   "end\n\n");

fprintf(f, "%s",
   "procedure printautomaton(a)\n"
   "   write(\"Automaton:\")\n"
   "   write(\"start: \", image(a.start.label),\n"
   "         \" for rulenum \", image(a.start.rulenum))\n"
   "   write(\"states:\")\n"
   "   every printstate(!a.states)\n"
   "   writes(\"accepting: \")\n"
   "   every writes((!a.accepting).label, \" \")\n"
   "   write()\n"
   "end\n\n");

fprintf(f, "%s",
   "procedure printstate(state)\n"
   "   write(\"state \", state.label, \" is for rule #\", state.rulenum)\n"
   "   if (*state.edges)>0 then {\n"
   "      writes(\"\\tedges: \"); every printedge(!state.edges); write()\n"
   "      }\n"
   "   if *state.epsilon>0 then {\n"
   "      writes(\"\\tepsilon: \")\n"
   "      every writes((!state.epsilon).label, \" \"); write()\n"
   "      }\n"
   "   if (*state.dot)>0 then {\n"
   "      writes(\"\\tdot: \")\n"
   "      every writes((!state.dot).label, \" \"); write()\n"
   "      }\n"
   "end\n\n");

fprintf(f, "%s",
   "procedure printedge(edge)\n"
   "   writes(image(edge.symbol), \" -> \")\n"
   "   every writes((!edge.destinations).label)\n"
   "   writes(\"; \")\n"
   "end\n\n");

fprintf(f, "%s",
   "procedure printstates(states)\n"
   "local statecopy, current\n\n"

   "   write(\"printstates size \", *states, \" in entity \", image(states))\n"

   "   statecopy := copy(states)\n\n"

   "   while *statecopy > 1 do {\n"
   "      current := pop(statecopy)\n"
   "      write(current.label, \", \")\n"
   "      }\n\n"

   "   if *statecopy > 0 then {\n"
   "      current := pop(statecopy)\n"
   "      write(current.label)\n"
   "      }\n"
   "    else write(\"state list is empty\")\n"
   "end\n");
}
