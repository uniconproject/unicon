/*
 * Katie Ray
 * Project: ulex
 * March 15, 2003
 * automata.h: header file for automata structure
 */

#include <string.h>

struct edge {
   char* symbol;
   struct anodelist* destinations;
   };

struct edgelist {
   struct edge* current;
   struct edgelist* next;
   };

struct anode {
   int label;
   int rulenum;
   struct edgelist* edges;
   struct anodelist* epsilon;          /* states we can reach on no input */
   struct anodelist* dot;              /* states we can reach on any input */
                                       /* (just need to consume one symbol) */
   char* semaction;
   };

struct anodelist {
   struct anode* current;
   struct anodelist* next;
   };

struct automata {
   struct anode* start;
   struct anodelist* states;
   struct anodelist* accepting;
   };

void *alc(int n, char *caller);
struct edge * alcedge(char* sym);
struct edgelist * alcedgelist();
struct anode * alcanode(int lab);
struct anodelist * alcnodelist();
struct automata * alcautomata();
int matchstrings(struct automata* aut, char* filename);
char* extendarray(char* buffer, int size);
struct anodelist * reach(struct anode* source, char* sym);
struct anodelist * append(struct anodelist* list1, struct anodelist* list2);
int simulate(struct automata* myaut, char* word);
struct anodelist * getdestinations(struct anodelist* sources, char* symbol);
void printstates(struct anodelist *states);
void printautomata(struct automata* myautomata);
void labelaut(struct automata* aut);
void createicon(struct automata* myautomata);
int member(int nodelabel, struct anodelist* nodelist);

extern char* begintext;
