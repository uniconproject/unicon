/*
 * Katie Ray
 * Project: ulex
 * March 15, 2003
 * automata.c: contains the functions that allow the automata to operate.
 */

#include <stdio.h>
#include "automata.h"


struct edge * alcedge(char* sym)
{
   struct edge *x = (struct edge *) calloc(1, sizeof(struct edge));
   if (x == NULL) {
      fprintf(stderr, "alcedge: calloc failed\n"); fflush(stderr);
      exit(-1);
      }
   x->symbol = sym;
   return x;
}

struct edgelist * alcedgelist()
{
   struct edgelist *x = (struct edgelist *) calloc(1, sizeof(struct edgelist));
   if  (x == NULL) {
      fprintf(stderr, "alcedgelist: calloc failed\n"); fflush(stderr);
      exit(-1);
      }
   return x;
}

struct anode * alcanode(int lab)
{
   struct anode *x = (struct anode *) calloc(1, sizeof(struct anode));
   if (x == NULL) {
      fprintf(stderr, "alcanode: calloc failed\n"); fflush(stderr);
      exit(-1);
      }
   x->label = lab;
   return x;
}

struct anodelist * alcnodelist()
{
   struct anodelist *x =(struct anodelist *)calloc(1,sizeof(struct anodelist));
   if  (x == NULL) {
      fprintf(stderr, "alcnodelist: calloc failed\n"); fflush(stderr);
      exit(-1);
      }
  return x;
}

struct automata * alcautomata()
{
   struct automata *x = (struct automata *) calloc(1, sizeof(struct automata));
   if (x == NULL) {
      fprintf(stderr, "alcnode: calloc failed\n"); fflush(stderr);
      exit(-1);
      }
   return x;
}

void labelaut(struct automata* aut)
{
   struct anodelist *statelist;
   int lab;

   statelist = aut->states;
   lab = 0;

   while (statelist != NULL) {
      statelist->current->label = lab;
      statelist = statelist->next;
      lab++;
      }
}

extern FILE *outfile;
extern char *outfilename;

void createicon(struct automata *myautomata)
{
   struct anodelist *states, *states2;
   struct edgelist *edges;
   int maxrulenum = 0, i, *action;

   outfile = fopen(outfilename, "w");
   if (outfile == NULL) {
      fprintf(stderr, "Unable to open output file %s\n", outfilename);
      exit(1);
      }

   /*
    * write out the standard skeleton automata code
    */
   ulexskel(outfile);

   fprintf(outfile, "%s\n", begintext);
   fprintf(outfile, "global semantic_action\n\n");
   fprintf(outfile, "procedure yylex()\n");
   fprintf(outfile, "static myautomata\n");
   fprintf(outfile, "local currstate, state2, tempedge\n\n");

   fprintf(outfile, "   myautomata := automata()\n\n");
   fprintf(outfile, "   myautomata.states := []\n");
   fprintf(outfile, "   myautomata.accepting := []\n");

   states = myautomata->states;
   while (states != NULL) {
      fprintf(outfile, "   currstate := anode(%d, %d, [], [], [])\n",
	      states->current->label, states->current->rulenum);

      if (states->current->label == myautomata->start->label)
        fprintf(outfile, "   myautomata.start := currstate\n");

      fprintf(outfile, "   put(myautomata.states, currstate)\n");
 
      if (member(states->current->label, myautomata->accepting) == 1) {
	 fprintf(outfile, "   put(myautomata.accepting, currstate)\n");
	 if (states->current->rulenum > maxrulenum)
	    maxrulenum = states->current->rulenum;
	 }

      fprintf(outfile, "\n");
      states = states->next;
      }

   states = myautomata->states;
   while (states != NULL) {
      fprintf(outfile, "   currstate := pop(myautomata.states)\n");
      fprintf(outfile, "   put(myautomata.states, currstate)\n\n");
      fprintf(outfile, "   while currstate.label ~= %d do {\n",
	      states->current->label);
      fprintf(outfile, "      currstate := pop(myautomata.states)\n");
      fprintf(outfile, "      put(myautomata.states, currstate)\n   }\n");
      fprintf(outfile, "   state2 := currstate\n\n");

      states2 = states->current->epsilon;
      while (states2 != NULL) {
	 fprintf(outfile, "   currstate := pop(myautomata.states)\n");
	 fprintf(outfile, "   put(myautomata.states, currstate)\n\n");
	 fprintf(outfile, "   while currstate.label ~= %d do {\n",
		 states2->current->label);
	 fprintf(outfile, "      currstate := pop(myautomata.states)\n");
	 fprintf(outfile, "      put(myautomata.states, currstate)\n   }\n");
	 fprintf(outfile, "   put(state2.epsilon, currstate)\n\n");
	 states2 = states2->next;
	 }

      states2 = states->current->dot;
      while (states2 != NULL) {
	 fprintf(outfile, "   currstate := pop(myautomata.states)\n");
	 fprintf(outfile, "   put(myautomata.states, currstate)\n\n");
	 fprintf(outfile, "   while currstate.label ~= %d do {\n",
		 states2->current->label);
	 fprintf(outfile, "      currstate := pop(myautomata.states)\n");
	 fprintf(outfile, "      put(myautomata.states, currstate)\n   }\n");
	 fprintf(outfile, "   put(state2.dot, currstate)\n\n");
	 states2 = states2->next;
	 }

      edges = states->current->edges;
      while (edges != NULL) {
	 fprintf(outfile, "   tempedge := edge()\n");

	 if(*edges->current->symbol == 10)
	    fprintf(outfile, "   tempedge.symbol := \"\\n\"\n");
	 else {
	    fprintf(outfile, "   tempedge.symbol := \"");
	    fprintf(outfile, "%s\"\n", edges->current->symbol);
	    }

	 fprintf(outfile, "   tempedge.destinations := []\n");

	 states2 = edges->current->destinations;
	 while (states2 != NULL) {
	    fprintf(outfile, "   currstate := pop(myautomata.states)\n");
	    fprintf(outfile, "   put(myautomata.states, currstate)\n\n");
	    fprintf(outfile, "   while currstate.label ~= %d do {\n",
		    states2->current->label);
	    fprintf(outfile, "      currstate := pop(myautomata.states)\n");
	    fprintf(outfile, "      put(myautomata.states, currstate)\n   }\n");
	    fprintf(outfile, "   put(tempedge.destinations, currstate)\n\n");
	    fprintf(outfile, "   put(state2.edges, tempedge)\n");
	    states2 = states2->next;
	    }

	 edges = edges->next;
	 }

      states = states->next;
      }
 
   fprintf(outfile, "   init_semantic_actions()\n\n");
   fprintf(outfile, "   return yyulex(myautomata)\n\n");
   fprintf(outfile, "end\n\n");

   fprintf(outfile, "procedure init_semantic_actions()\n\n");
   fprintf(outfile, "   semantic_action := table()\n");

   action = (int*) calloc(maxrulenum+1, sizeof(int));

   for (i = 1; i <= maxrulenum; i++) {
      fprintf(outfile, "   semantic_action[%d] := semantic_action_%d\n", i, i);
      action[i] = 0;
      }

   fprintf(outfile, "\nend\n\n");
   states = myautomata->accepting;

   while (states != NULL) {
      if (action[states->current->rulenum] == 0) {
	 fprintf(outfile, "procedure semantic_action_%d()\n",
		 states->current->rulenum);
	 fprintf(outfile, "   %s\n", states->current->semaction);
	 fprintf(outfile, "end\n\n");
	 action[states->current->rulenum] = 1;
	 }
      states = states->next;
      }
}

int member(int nodelabel, struct anodelist* nodelist)
{
   struct anodelist *traverse = nodelist;

   while(traverse != NULL) {
      if (traverse->current->label == nodelabel)
	 return 1;
      traverse = traverse->next;
      }
   return 0;
}


/*
 * The rest of this file, is ifdef'ed out; it is a C language
 * NFA simulator that was used for testing purposes. File
 * ulexskel.c contains the code to write the corresponding
 * Icon/Unicon NFA simulator.
 */

#if 0
/*
 * matchstrings takes an automata and a filename and checks if that entire
 * string sequence in that file can be broken into a set of strings that will
 * be accepted by the automata with one stipulation: the longest possible
 * string will be matched at each stage of the computation.
 */
int matchstrings(struct automata* aut, char* filename)
{
   FILE *readfrom;
   char *stringseq, *currstring, currchar;
   int buffersize, position, less, rulenum;

   /*
    * The first part of this function will open the file that is to be read
    * from and store the entire file into one string. This is accomplished by
    * using an extendible array of characters and reading them one at a time
    * from the file.
    */
   readfrom = fopen(filename, "r");
   if (readfrom == NULL) {
      printf("Could not open file %s", filename);
      exit(-1);
      }

   buffersize = 20;                            /* This value is random */
   stringseq = (char *) calloc(buffersize, sizeof(char));
   if (stringseq == NULL) {
      printf("allocation of buffer failed.\n");
      exit(-1);
      }

   position = 0;
   currchar = fgetc(readfrom);

   while(currchar != EOF) {
      if (position >= buffersize-1) {
	 stringseq = extendarray(stringseq, buffersize);
	 buffersize += 20;
	 }
      stringseq[position] = currchar;
      currchar = fgetc(readfrom);
      position++;
      }

   stringseq[position] = '\0';

   currstring = (char *) calloc(buffersize, sizeof(char));
   if (currstring == NULL) {
      printf("Could not allocate string.\n");
      exit(-1);
      }

   printf("file contains: %s\n", stringseq);

   /*
    * Recall at this point that the value in position is the position of our 
    * null terminator. less is used to keep track of how many symbols we are 
    * removing before simulation. If we remove all of the positions then we 
    * return zero because it means that we could not accept any portion
    * of the remaining string according to the rules. After simulation, if it
    * was accepted it prints the corresponding rule number and then moves the
    * string position to that point and modifies the termination position by
    * same amount that we shrunk the string by. Otherwise it increments less
    * and starts over.
    */

   less = 0;

   while (*stringseq != 0) {
      currstring = strncpy(currstring, stringseq, position-less);
      currstring[position-less] = 0;

      rulenum = simulate(aut, currstring);

      if (rulenum > 0) {
	 printf("Accepted by rule number %d : %s\n", rulenum, currstring);
	 stringseq += (position-less);
	 position -= (position-less);
	 less = -1;
	 }
      else {
	 less++;
	 if (less > position)
	    return 0;
	 }
      }
   return 1;
}

/*
 * extendarray takes a string and the size of the string and returns the same
 * string but as part of a larger string and destroys the previous string.
 */
char* extendarray(char* buffer, int size)
{
   char *retvalue, *makecopy;
   int position = 0;

   retvalue = (char *) calloc(size+20, sizeof(char));
   if (retvalue == NULL) {
      printf("Allocation of buffer failed.\n");
      exit(-1);
      }
  
   while (position < size) {
      retvalue[position] = buffer[position];
      position++;
      }

   free(buffer);
   return retvalue;
}

/*
 * reach() returns the list of nodes that can be reached on character sym from
 * state source.
 */
struct anodelist * reach (struct anode* source, char* sym)
{
   struct edgelist *edgeset;
   struct anodelist *answer;
   char *edgesymbol, bound1, bound2;

   edgeset = source->edges;
   answer = NULL;

   while (edgeset != NULL) {
      edgesymbol = edgeset->current->symbol;

      /*
       * First we compare the symbol to the symbol on the current edge we are
       * looking at. If they match then we add the destinations to the answer.
       * If the symbols do not match, then we see if the edge is actually a 
       * cset since this is a special case and then we determine if the symbol
       * fits into the cset.
       */

      if (*edgesymbol == *sym)
	 answer = append(answer, edgeset->current->destinations);

      else if (*edgesymbol == '[') {
	 edgesymbol++;

	 while(*edgesymbol != ']') {
	    if (*edgesymbol == '\\') {
	       edgesymbol++;

	       if (*edgesymbol == 'n' && *sym == 10)
		  answer = append(answer, edgeset->current->destinations);

	       else if (*edgesymbol == 't' && *sym == 9) 
		  answer = append(answer, edgeset->current->destinations);

	       else if (*edgesymbol == *sym)
		  answer = append(answer, edgeset->current->destinations);
	       }
	    else if (edgesymbol[1] == '-') {
	       bound1 = *edgesymbol;
	       edgesymbol+=2;
	       bound2 = *edgesymbol;

	       if (bound1 <= *sym && *sym <= bound2)
		  answer = append(answer, edgeset->current->destinations);
	       }

	    else if (*edgesymbol == *sym)
	       answer = append(answer, edgeset->current->destinations);

	    edgesymbol++;
            }
        }

      edgeset = edgeset->next;
      }

   answer = append(answer, source->dot);
   return answer;
}

/*
 * append() takes two lists and returns a new list that is the result of
 * appending the two.
 */
struct anodelist* append(struct anodelist* list1, struct anodelist* list2)
{
   struct anodelist *makecopy, *makeresult, *retvalue;

   if (list1 == NULL && list2 == NULL)    
      return NULL;

   makeresult = alcnodelist();
   retvalue = makeresult;

   makecopy = list1;
   while (makecopy != NULL) {
      makeresult->current = makecopy->current;
      makecopy = makecopy->next;

      /*
       * This check is inserted here because we want the pointer to next to be
       * NULL if we run out of elements.
       */

      if (makecopy != NULL) {
	 makeresult->next = alcnodelist();
	 makeresult = makeresult->next;
	 }
      }

   makecopy = list2;
   while (makecopy != NULL) {
      makeresult->current = makecopy->current;
      makecopy = makecopy->next;

      /*
       * Similar to above. next pointer should be NULL if we run out of 
       * elements.
       */

      if (makecopy != NULL) {
	 makeresult->next = alcnodelist();
	 makeresult = makeresult->next;
	 }
      }
  return retvalue;
}

/*
 * NFA interpreter
 */
int simulate(struct automata* myaut, char* word)
{
   struct anodelist *currstates, *acceptcheck, *check2, *iterator;
   char* currsymbol;

   currstates = alcnodelist();
   currstates->current = myaut->start;
   acceptcheck = myaut->accepting;

   currsymbol = word;

   while (*currsymbol != 0) {
      currstates = getdestinations(currstates, currsymbol);
      
      if (currstates == NULL)
	 return 0;

      currsymbol++;
      }

   check2 = currstates;
   iterator = currstates;

   /*
    * The following section is added so that if there is an epsilon transition 
    * to a final state from the current set of states then it will accept. 
    */

   while (check2 != NULL) {
      while(iterator->next != NULL)
	 iterator = iterator->next;
 
      iterator->next = check2->current->epsilon;
      check2 = check2->next;
      }

   check2 = currstates;

   while (acceptcheck != NULL) {
      while (check2 != NULL) {
	 if (acceptcheck->current->label == check2->current->label)
            return acceptcheck->current->rulenum;
	 check2 = check2->next;
	 }

      acceptcheck = acceptcheck->next;
      check2 = currstates;
      }

   return 0;
}

/*
 * getdestinations() takes a set of source nodes and an input string and
 * returns the set of destinations reachable from the first character of
 * the input string.
 */
struct anodelist* getdestinations(struct anodelist* sources, char* input)
{
   struct anodelist *retlist, *listiterator, *buildresult, *iterator2;
   retlist = NULL;

   if (sources == NULL)
      return NULL;

   buildresult = append(sources, NULL);
   listiterator = buildresult;
   iterator2 = buildresult;

   /*
    * First we add any states that can be reached through an
    * epsilon transition.
    */

   while (listiterator != NULL) {
      while (iterator2->next != NULL)
	 iterator2 = iterator2->next;

      iterator2->next = append(listiterator->current->epsilon, NULL);
      listiterator = listiterator->next;
      }

   /*
    * Then we build the result from the current set of states.
    */
  
   while (retlist == NULL) {
      if (buildresult == NULL)
	 return NULL;

      retlist = reach(buildresult->current, input);
      buildresult = buildresult->next;
      }

   listiterator = retlist;

   while (buildresult != NULL) {
      while(listiterator->next != NULL)
	 listiterator = listiterator->next;  

      listiterator->next = reach(buildresult->current, input);
      buildresult = buildresult->next;
      }

   return retlist;
}

void printstates(struct anodelist* states)
{
  if (states != NULL) {
     printf(" %d", states->current->label);
     if (states->current->semaction != NULL)
        printf(" action: %s", states->current->semaction);
     if (states->next != NULL)
        printf(", ");
     printstates(states->next);
     }
}

void printautomata(struct automata *myautomata)
{
   struct anodelist* states;
   struct edgelist* edges;

   printf("States are: ");
   printstates(myautomata->states);
   printf("\nAccepting States: ");
   printstates(myautomata->accepting);
   printf("\n");
   printf("Starting in state: %d", myautomata->start->label);
   printf("\n");

   printf("Transitions:\n");
   states = myautomata->states;

   while (states != NULL) {
      if (states->current->epsilon != NULL) {
	 printf("Epsilon move from state %d", states->current->label);
	 printf(" to: ");
	 printstates(states->current->epsilon);
	 printf("\n");
	 }

      if (states->current->dot != NULL) {
	 printf("Move on any input from state %d", states->current->label);
	 printf(" to: ");
	 printstates(states->current->dot);
	 printf("\n");
	 }

      edges = states->current->edges;
      while (edges != NULL) {
	 printf("From: %d", states->current->label);
	 printf("  To: ");
	 printstates(edges->current->destinations);
	 printf("  Symbol: %s", edges->current->symbol);
	 edges = edges->next;
	 printf("\n");
	 }
      states = states->next;
      }
}
#endif
