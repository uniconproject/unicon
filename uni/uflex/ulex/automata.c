/*
 * Katie Ray
 * Project: ulex
 * March 15, 2003
 * automata.c: contains the functions that allow the automata to operate.
 */

#include <stdio.h>
#include <stdlib.h>
#include "automata.h"
void ulexskel(FILE*);

extern int debugautomaton;

void *alc(int n, char *caller)
{
   void *rv = calloc(1, n);
   if (rv == NULL) {
      fprintf(stderr, "%s: calloc failed\n", caller); fflush(stderr);
      exit(-1);
      }
}

struct edge * alcedge(char* sym)
{
   struct edge *x = (struct edge *) alc(sizeof(struct edge), "alcedge");
   x->symbol = sym;
   return x;
}

struct edgelist * alcedgelist()
{
   return (struct edgelist *) alc(sizeof(struct edgelist), "alcedgelist");
}

struct anode * alcanode(int lab)
{
   struct anode *x = (struct anode *) alc(sizeof(struct anode), "alcanode");
   x->label = lab;
   return x;
}

struct anodelist * alcnodelist()
{
   return (struct anodelist *)alc(sizeof(struct anodelist), "alcnodelist");
}

struct automata * alcautomata()
{
   return (struct automata *) alc(sizeof(struct automata), "alcautomata");
}

/*
 * label all states in an automaton with an increasing numeric sequence.
 */
void labelaut(struct automata* aut)
{
   struct anodelist *statelist = aut->states;
   int lab = 0;

   while (statelist != NULL) {
      statelist->current->label = lab;
      statelist = statelist->next;
      lab++;
      }
}

void printautomata(struct automata *myautomata)
{
   struct anodelist *states, *states2;
   struct edgelist *edges;

   states = myautomata->states;
   while (states != NULL) {
      printf("state %d rule %d %s\n",
             states->current->label, states->current->rulenum,
             (member(states->current->label, myautomata->accepting)?"acc":""));

      edges = states->current->edges;
      while (edges != NULL) {
         printf("   %s -> ",
                strcmp(edges->current->symbol,"\n")?edges->current->symbol:"\\n");
         states2 = edges->current->destinations;
         while (states2 != NULL) {
            printf("%d ", states2->current->label);
            states2 = states2->next;
            }
         printf("\n");
         edges = edges->next;
         }
      states = states->next;
      }
}

extern FILE *outfile;
extern char *outfilename;

void createicon(struct automata *myautomata)
{
   struct anodelist *states, *states2;
   struct edgelist *edges;
   int maxrulenum = 0, i, *action;

   if (debugautomaton) {
      printautomata(myautomata);
      exit(0);
      }

   if ((outfile = fopen(outfilename, "w")) == NULL) {
      fprintf(stderr, "Unable to open output file %s\n", outfilename);
      exit(1);
      }

   /*
    * write out the standard skeleton automata code
    */
   ulexskel(outfile);

   if (begintext) {
      fprintf(outfile, "%s\n", begintext);
      }

   fprintf(outfile,
           "global semantic_action\n\n"
           "procedure yylex()\n"
           "static myautomata\n"
           "local currstate, state2, tempedge\n\n"
           "   myautomata := automata()\n\n"
           "   myautomata.states := []\n"
           "   myautomata.accepting := []\n");

   states = myautomata->states;
   while (states != NULL) {
      fprintf(outfile,
         "   put(myautomata.states, currstate := anode(%d, %d, [], [], []))\n",
              states->current->label, states->current->rulenum);

      if (states->current->label == myautomata->start->label)
        fprintf(outfile, "   myautomata.start := currstate\n");

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
      fprintf(outfile,
              "   currstate := pop(myautomata.states)\n"
              "   put(myautomata.states, currstate)\n\n"
              "   while currstate.label ~= %d do {\n"
              "      currstate := pop(myautomata.states)\n"
              "      put(myautomata.states, currstate)\n      }\n"
              "   state2 := currstate\n\n",
              states->current->label);

      states2 = states->current->epsilon;
      while (states2 != NULL) {
         fprintf(outfile,
                 "   currstate := pop(myautomata.states)\n"
                 "   put(myautomata.states, currstate)\n\n"
                 "   while currstate.label ~= %d do {\n"
                 "      currstate := pop(myautomata.states)\n"
                 "      put(myautomata.states, currstate)\n      }\n"
                 "   put(state2.epsilon, currstate)\n\n",
                 states2->current->label);
         states2 = states2->next;
         }

      states2 = states->current->dot;
      while (states2 != NULL) {
         fprintf(outfile,
                 "   currstate := pop(myautomata.states)\n"
                 "   put(myautomata.states, currstate)\n\n"
                 "   while currstate.label ~= %d do {\n"
                 "      currstate := pop(myautomata.states)\n"
                 "      put(myautomata.states, currstate)\n      }\n"
                 "   put(state2.dot, currstate)\n\n",
                 states2->current->label);
         states2 = states2->next;
         }

      edges = states->current->edges;
      while (edges != NULL) {
         fprintf(outfile, "   tempedge := edge()\n");

         if (*edges->current->symbol == 10)
            fprintf(outfile, "   tempedge.symbol := \"\\n\"\n");
         else {
            fprintf(outfile, "   tempedge.symbol := \"%s\"\n",
                    edges->current->symbol);
            }

         fprintf(outfile, "   tempedge.destinations := []\n");

         states2 = edges->current->destinations;
         while (states2 != NULL) {
            fprintf(outfile,
                    "   currstate := pop(myautomata.states)\n"
                    "   put(myautomata.states, currstate)\n\n"
                    "   while currstate.label ~= %d do {\n"
                    "      currstate := pop(myautomata.states)\n"
                    "      put(myautomata.states, currstate)\n      }\n"
                    "   put(tempedge.destinations, currstate)\n\n"
                    "   put(state2.edges, tempedge)\n",
                    states2->current->label);
            states2 = states2->next;
            }

         edges = edges->next;
         }

      states = states->next;
      }

   fprintf(outfile,
           "   init_semantic_actions()\n\n"
           "   return yyulex(myautomata)\n\n"
           "end\n\n"

           "procedure init_semantic_actions()\n\n"
           "   semantic_action := table()\n");

   action = (int*) alc((maxrulenum+1) * sizeof(int), "calloc");

   for (i = 1; i <= maxrulenum; i++) {
      fprintf(outfile, "   semantic_action[%d] := semantic_action_%d\n", i, i);
      }

   fprintf(outfile, "\nend\n\n");
   states = myautomata->accepting;

   while (states != NULL) {
      if (action[states->current->rulenum] == 0) {
         fprintf(outfile,
                 "procedure semantic_action_%d()\n"
                 "   %s\n"
                 "end\n\n",
                 states->current->rulenum,
                 states->current->semaction);
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
