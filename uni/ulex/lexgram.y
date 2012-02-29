/*
 * Katie Ray
 * Project: ulex
 * March 15, 2003
 * lexgram.y: contains the YACC grammar for ulex
 */

%{
#include <stdio.h>
#include <string.h>
#include "tree.h"
#include "automata.h"
struct automata* convert(struct tree* tr);
int rulenumber = 1;
%}

%union {
  struct tree* tr;
  struct automata* aut;
  char *s;
  int numeric;
}

%token <numeric> OR
%token <numeric> BACKSLASH
%token <numeric> SQUAREBRACKETS  
%token <numeric> DOT             
%token <numeric> CSET            
%token <numeric> QUOTES          
%token <numeric> LINEBEGIN       
%token <numeric> LINEEND         
%token <numeric> OPTIONAL        
%token <numeric> ZEROORMORE      
%token <numeric> ONEORMORE
%token <numeric> PARENTHESES     
%token <numeric> FORWARDSLASH    
%token <numeric> CURLBRACKETS    
%token <numeric> OCCURRENCES     
%token <numeric> CLOSEPARENTHESES     
%token <numeric> PERCENTS
%token <numeric> CHARACTER
%token <numeric> COMMENT
%token <numeric> ACTION
%token <numeric> BEGINNING
%token <numeric> ENDING
%token <numeric> QUESTION
%token <numeric> STAR
%token <numeric> PLUS
%token <numeric> OREXPR
%token <numeric> PARENTHETIC
%token <numeric> FORSLASH
%token <numeric> EXPRESSION
%token <numeric> EXPRTREE
%token <numeric> NEWLINE
%token <numeric> CONCATEXPR
%token <numeric> CONCAT
%type <tr> Exprs
%type <tr> OneExpr
%type <tr> Expr
%type <tr> BeginLine
%type <tr> EndLine
%type <tr> Star
%type <tr> Plus
%type <tr> Question
%type <tr> ForSlash
%type <tr> Parenthetic
%type <tr> Occurrence
%type <tr> Regexps
%type <tr> Percentexp
%type <aut> Start Goal

%%

Goal: Start { labelaut($1); createicon($1); } ;

Start:    Newlines Percentexp Newlines { $$ = convert($2); }
        | Newlines Percentexp          { $$ = convert($2); }
        | Percentexp Newlines          { $$ = convert($1); }
        | Percentexp                   { $$ = convert($1); }
	;

Percentexp: Regexps ;

Regexps : Exprs Newlines { $$ = $1; } 
	| Exprs		 { $$ = $1; }
	;

Newlines:  NEWLINE Newlines
	| NEWLINE;

Exprs:    Exprs Newlines OneExpr {
	   $$ = alcnode(EXPRTREE); 
	   $$->children[0] = $1;
	   $$->children[1] = $3;
	   }
	| OneExpr
	;

OneExpr : Expr ACTION {
	   $$ = alcnode(EXPRESSION);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(ACTION);
	   $$->children[1]->text = yylval.s;
	   }

	| Expr {
	   $$ = alcnode(EXPRESSION);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(ACTION);
	   $$->children[1]->text = "# fail";
	   }
	;

Expr    : QUOTES { 
	   $$ = alcnode(QUOTES);
	   $$->text = yylval.s;
	   }

	| BACKSLASH {
	   $$ = alcnode(BACKSLASH);
	   $$->text = yylval.s;
	   }

	| CSET { 
	   $$ = alcnode(CSET);
	   $$->text = yylval.s;
	   }

	| CHARACTER { 
	   $$ = alcnode(CHARACTER);
	   $$->text = yylval.s;
	   }

	| DOT { $$ = alcnode(DOT); }

	| BeginLine
	| EndLine
	| Question
	| Star
	| Plus
	| Expr OR Expr {
	   $$ = alcnode(OREXPR);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(OR);
	   $$->children[2] = $3;
           }
	| Expr Expr {
	   $$ = alcnode(CONCATEXPR);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(CONCAT);
	   $$->children[2] = $2;
	   }
	| Parenthetic
	| ForSlash
	| Occurrence
	;

BeginLine: LINEBEGIN Expr {
	   $$ = alcnode(BEGINNING);
	   $$->children[0] = alcnode(LINEBEGIN);
	   $$->children[1] = $2;
	   }
	;

EndLine: Expr LINEEND {
	   $$ = alcnode(ENDING);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(LINEEND);
	   }
	;

Question: Expr OPTIONAL {
	   $$ = alcnode(QUESTION);
	   $$->children[1] = alcnode(OPTIONAL);
	   $$->children[0] = $1;
	   }
	;

Star: Expr ZEROORMORE {
	   $$ = alcnode(STAR);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(ZEROORMORE);
	   }
	;

Plus: Expr ONEORMORE {
	   $$ = alcnode(PLUS);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(ONEORMORE);
	   }
	;

Parenthetic: PARENTHESES Expr CLOSEPARENTHESES {
	   $$ = alcnode(PARENTHETIC);
	   $$->children[0] = alcnode(PARENTHESES);
	   $$->children[1] = $2;
	   $$->children[2] = alcnode(CLOSEPARENTHESES); 
	   }
	;

ForSlash: Expr FORWARDSLASH Expr {
	   $$ = alcnode(FORSLASH);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(FORWARDSLASH);
	   $$->children[2] = $3;
	   }
	;

Occurrence: Expr CURLBRACKETS {
	   $$ = alcnode(OCCURRENCES);
	   $$->children[0] = $1;
	   $$->children[1] = alcnode(CURLBRACKETS);
	   $$->text = yylval.s;
	   }
	;

%%

extern int yylineno;

int yyerror(char *s)
{
   /*
    * Eventually want to use merr for better error messaging.
    */

   fprintf(stderr, "%s on line %d\n", s, yylineno);
   return 0;
}

/*
 * convert() takes the tree as input and converts it into an automata.
 */ 
struct automata* convert(struct tree* tr)
{
   struct automata *returnvalue, *aut1, *aut2;
   struct anode *newnode1, *newnode2;
   struct anodelist *listptr, *listptr2;
   struct edgelist *elistptr;
   char *tempstring, *getsinglechar;
   int t1, t2, i;

   /*
    * Conversion is accomplished by breaking it down into separate cases and
    * exploiting recursion wherever possible.
    */

   switch (tr->label) {
   case EXPRTREE: {
	/*
	 * This case is handled by converting the two subtrees and then making
	 * a new start node with epsilon transitions to the start nodes of the
	 * two machines for each branch.
	 */

	returnvalue = alcautomata();
	returnvalue->start = alcanode(0);

	aut1 = convert(tr->children[0]);
	aut2 = convert(tr->children[1]);

	returnvalue->start->epsilon = alcnodelist();
	returnvalue->start->epsilon->current = aut1->start;
	returnvalue->start->epsilon->next = alcnodelist();
	returnvalue->start->epsilon->next->current = aut2->start;

	returnvalue->states = alcnodelist();
	returnvalue->states->current = returnvalue->start;

	returnvalue->states->next = aut1->states;
	listptr = aut1->states;

	while(listptr->next != NULL)
	  listptr = listptr->next;

	listptr->next = aut2->states;
	
	returnvalue->accepting = aut1->accepting;
	listptr = aut1->accepting;
	
	while (listptr->next != NULL)
	  listptr = listptr->next;
	
	listptr->next = aut2->accepting;

	return returnvalue;
      }

    case EXPRESSION: {
	/*
	 * This case is handled by converting the expression recursively and 
	 * associating the accepting states with the semantic action if there
	 * is one. This case is also the one that is used to set which rule
	 * number is associated with which states. This is accomplished by 
	 * using a global variable that is incremented each time that we 
	 * convert an expression.
	 */

	returnvalue = convert(tr->children[0]);

	if (tr->children[1] != NULL) {
	    listptr = returnvalue->accepting;
	    while (listptr != NULL) {
		listptr->current->semaction = tr->children[1]->text;
		listptr = listptr->next;
	      }
	  }
	
	listptr = returnvalue->states;
	
	while(listptr != NULL) {
	    listptr->current->rulenum = rulenumber;
	    listptr = listptr->next;
	  }
	
	rulenumber++;
	
	return returnvalue;
      }

    case OREXPR: {
	/*
	 * This case is handled by converting the two expressions that are 
	 * connected by the or and making a new start state with an epsilon
	 * transition to the start state of each of the other two machines.
	 */

	returnvalue = alcautomata();
	returnvalue->start = alcanode(0);
	
	aut1 = convert(tr->children[0]);
	aut2 = convert(tr->children[2]);

	returnvalue->start->epsilon = alcnodelist();
        returnvalue->start->epsilon->current = aut1->start;
        returnvalue->start->epsilon->next = alcnodelist();
        returnvalue->start->epsilon->next->current = aut2->start;

	returnvalue->states = alcnodelist();
	returnvalue->states->current = returnvalue->start;

        returnvalue->states->next = aut1->states;
        listptr = aut1->states;

        while(listptr->next != NULL)
          listptr = listptr->next;

        listptr->next = aut2->states;

        returnvalue->accepting = aut1->accepting;
        listptr = aut1->accepting;

        while (listptr->next != NULL)
          listptr = listptr->next;

        listptr->next = aut2->accepting;

        return returnvalue;
      }

    case CONCATEXPR: {
	/*
	 * This case is handled by converting the two subexpressions and 
	 * linking the accepting states of the first to the start state of the
	 * second. The accepting states are those of the second machine.
	 */

	aut1 = convert(tr->children[0]);
	aut2 = convert(tr->children[2]);

	listptr = aut1->accepting;
	
	while (listptr != NULL) {
	    if (listptr->current->epsilon == NULL) {
		listptr->current->epsilon = alcnodelist();
		listptr->current->epsilon->current = aut2->start;
	      }

	    else {
		listptr2 = listptr->current->epsilon;

		while (listptr2->next != NULL)
		  listptr2 = listptr2->next;
		
		listptr2->next = alcnodelist();
		listptr2->next->current = aut2->start;
	      }

	    listptr = listptr->next;
	  }

	listptr = aut1->states;

	while (listptr->next != NULL)
	  listptr = listptr->next;

	listptr->next = aut2->states;

	aut1->accepting = aut2->accepting;
	return aut1;
      }

    case QUOTES: {
	/*
	 * This case is handled by creating a chain of states with transitions
	 * that correspond to each individual letter of the string in quotes.
	 */

	returnvalue = alcautomata();

	newnode1 = alcanode(0);
	listptr = alcnodelist();
	listptr->current = newnode1;

        returnvalue->start = newnode1;
        returnvalue->states = listptr;

	tempstring = tr->text;
	tempstring++;

	while (*tempstring != 34) {
	    getsinglechar = (char *) alc(sizeof(char), "convert");
	    getsinglechar[0] = *tempstring;
	    getsinglechar[1] = '\0';
	    newnode2 = alcanode(0);
	    listptr->next = alcnodelist();
	    listptr->next->current = newnode2;

	    newnode1->edges = alcedgelist();
	    newnode1->edges->current = alcedge(getsinglechar);
	    newnode1->edges->current->destinations = alcnodelist();
	    newnode1->edges->current->destinations->current = newnode2;

	    newnode1 = newnode2;
	    listptr = listptr->next;
	    tempstring++;
	  }

	returnvalue->accepting = alcnodelist();
	returnvalue->accepting->current = newnode2;
	return returnvalue;
      }

    case BACKSLASH: {
	/*
	 * This case is handled by creating a two state automata with the edge
	 * labelled directly with the character that follows the backslash.
	 */

	returnvalue = alcautomata();

	newnode1 = alcanode(0);
        newnode2 = alcanode(0);
	
	listptr = alcnodelist();
	listptr->current = newnode1;
	listptr->next = alcnodelist();
	listptr->next->current = newnode2;

	elistptr = alcedgelist();
	tr->text++;

	if (*tr->text == 'n')
	  *tr->text = 10;
     
	else if (*tr->text == 't')
	  *tr->text = 9;

	elistptr->current = alcedge(tr->text);
	
	listptr2 = alcnodelist();
	listptr2->current = newnode2;

	elistptr->current->destinations = listptr2;

	newnode1->edges = elistptr;

	returnvalue->start = newnode1;
	returnvalue->states = listptr;
	returnvalue->accepting = alcnodelist();
	returnvalue->accepting->current = newnode2;
      }

    case CSET: {
	/*
	 * This case is handled by creating an automata with a start state and
	 * transitioning to a final state and the edge is labelled with the 
	 * entire string representing the cset. This becomes a special case in
	 * handling the simulation of the automata.
	 */

	returnvalue = alcautomata();
	returnvalue->start = alcanode(0);
	returnvalue->states = alcnodelist();
	returnvalue->accepting = alcnodelist();

	returnvalue->accepting->current = alcanode(0);

	returnvalue->states->current = returnvalue->start;
	returnvalue->states->next = alcnodelist();
	returnvalue->states->next->current = returnvalue->accepting->current;

	returnvalue->start->edges = alcedgelist();
	returnvalue->start->edges->current = alcedge(tr->text);
	returnvalue->start->edges->current->destinations = alcnodelist();
	returnvalue->start->edges->current->destinations->current =
	  returnvalue->accepting->current;

	return returnvalue;
      }

    case CHARACTER: {
	/*
	 * The most striaghtforward case - create a two state automata that
	 * transitions from the start to the final state on the specified 
	 * character.
	 */

	returnvalue = alcautomata();

	newnode1 = alcanode(0);
	newnode2 = alcanode(0);
	elistptr = newnode1->edges;

	newnode1->edges = alcedgelist();
	newnode1->edges->current = alcedge(tr->text);
	newnode1->edges->current->destinations = alcnodelist();
	newnode1->edges->current->destinations->current = newnode2;

	returnvalue->start = newnode1;

	returnvalue->states = alcnodelist();
	returnvalue->states->current = newnode1;
	returnvalue->states->next = alcnodelist();
	returnvalue->states->next->current = newnode2;

	returnvalue->accepting = alcnodelist();
	returnvalue->accepting->current = newnode2;

	return returnvalue;
      }

    case DOT: {
	/*
	 * This case uses a special feature of our automata that creates a 
	 * transition that simply means consume any character. Each node has
	 * an associated list of nodes called dot that it can reach on any 
	 * single character.
	 */

	returnvalue = alcautomata();
	returnvalue->start = alcanode(0);

	newnode1 = alcanode(0);
	listptr = alcnodelist();

	listptr->current = newnode1;
	returnvalue->start->dot = listptr;

	listptr = alcnodelist();
	listptr->current = returnvalue->start;
	listptr->next = alcnodelist();
	listptr->next->current = newnode1;
	returnvalue->states = listptr;

	returnvalue->accepting = alcnodelist();
	returnvalue->accepting->current = newnode1;

	return returnvalue;
      }

    case BEGINNING: {
	/*
	 * This is accomplished by converting the tree obtained from the 
	 * regular expression into an automata, and then adding a transition
	 * from all final states to themselves on any input.
	 */

	aut1 = convert(tr->children[1]);

	listptr = aut1->accepting;

	while(listptr != NULL) {
	    listptr2 = listptr->current->dot;

	    if (listptr2 == NULL) {
		listptr2 = alcnodelist();
		listptr2->current = listptr->current;
		listptr->current->dot = listptr2;
	      }

	    else {
		while (listptr2->next != NULL)
		  listptr2 = listptr2->next;
		
		listptr2->next = alcnodelist();
		listptr2->next->current = listptr->current;
	      }

	    listptr = listptr->next;
	  }

	return aut1;
      }

    case ENDING: {
	/*
	 * This case is handled by converting the regular expression and then
	 * adding a new start state that transitions to itself on any input
	 * and has an epsilon transition to the start state of the converted
	 * machine.
	 */

	aut1 = convert(tr->children[0]);

	newnode1 = alcanode(0);

	newnode1->dot = alcnodelist();
	newnode1->dot->current = newnode1;

	newnode1->epsilon = alcnodelist();
	newnode1->epsilon->current = aut1->start;

	listptr = aut1->states;
	aut1->states = alcnodelist();
	aut1->states->current = newnode1;
	aut1->states->next = listptr;

	aut1->start = newnode1;
	return aut1;
      }

    case QUESTION: {
	/*
	 * This adds the start state to the list of accepting states for the
	 * machine that is a conversion of the regular expression.
	 */

	aut1 = convert(tr->children[0]);

	listptr = aut1->accepting;
	if (listptr == NULL)
	  return aut1;

	while (listptr->next != NULL)
	  listptr = listptr->next;
	
	listptr->next = alcnodelist();
	listptr->next->current = aut1->start;

	return aut1;
      }

    case STAR: {
	/*
	 * This case converts the regular expression and then adds an epsilon
	 * transition from the final states to the start state and makes the
	 * start state a final state.
	 */

        aut1 = convert(tr->children[0]);

        listptr = aut1->accepting;

        while (listptr != NULL) {
	    listptr2 = listptr->current->epsilon;

	    if (listptr2 == NULL) {
		listptr2 = alcnodelist();
		listptr2->current = aut1->start;
		listptr->current->epsilon = listptr2;
	      }

	    else {
		while (listptr2->next != NULL)
		  listptr2 = listptr2->next;

		listptr2->next = alcnodelist();
		listptr2->next->current = aut1->start;
	      }

	    listptr = listptr->next;
	  }

	listptr = aut1->accepting;
	aut1->accepting = alcnodelist();
        aut1->accepting->current = aut1->start;
	aut1->accepting->next = listptr;

        return aut1;
      }

    case PLUS: {
	/*
	 * Works similar to the case for star except that it doesn't make the
	 * start state a final state.
	 */

        aut1 = convert(tr->children[0]);

        listptr = aut1->accepting;
        if (listptr == NULL)
          return aut1;

        while (listptr != NULL) {
            if (listptr->current->epsilon == NULL) {
                listptr->current->epsilon = alcnodelist();
                listptr->current->epsilon->current = aut1->start;
              }

            else {
                listptr2 = listptr->current->epsilon;

                while (listptr2->next != NULL)
                  listptr2 = listptr2->next;

		listptr2->next = alcnodelist();
                listptr2->next->current = aut1->start;
              }

            listptr = listptr->next;
          }

        return aut1;
      }

    case PARENTHETIC:
      return convert(tr->children[1]);

    case FORSLASH:
      // 

    case OCCURRENCES: {
	tempstring = tr->text;
	tempstring++;
	t1 = *tempstring - 48;                /* convert from char to int */
	tempstring+= 2;

	/*
	 * First we convert the regular expression that we are generating 
	 * multiple occurrences for.
	 */

	returnvalue = convert(tr->children[0]);

	for (i = 1; i < t1; i++) {
	    /*
	     * This loop will continue until the first number in the number of
	     * occurrences or theonly number as the case may be. It will 
	     * reconvert the regular expression to create a copy of the 
	     * automata and then it will link the previous final states to the
	     * start state of this machine turning off the previous final 
	     * states.
	     */

	    aut1 = convert(tr->children[0]);
	    
	    listptr = returnvalue->accepting;
	    while (listptr != NULL) {
		if (listptr->current->epsilon == NULL)
		  {
		    listptr->current->epsilon = alcnodelist();
		    listptr->current->epsilon->current = aut1->start;
		  }

		else {
		    listptr2 = listptr->current->epsilon;

		    while (listptr2->next != NULL)
		      listptr2 = listptr2->next;

		    listptr2->next = alcnodelist();
		    listptr2->next->current = aut1->start;
		  }

		listptr = listptr->next;
	      }

	    returnvalue->accepting = aut1->accepting; 

	    listptr = returnvalue->states;
	    while (listptr->next != NULL)
	      listptr = listptr->next;

	    listptr->next = aut1->states;
	  }

	if (tempstring != NULL) {
	    /*
	     * If there were two numbers in the set of occurrences then we do 
	     * basically the same as the above up to the second number except
	     * that we do not turn off the final states of the previous machine
	     * during each iteration.
	     */

	    t2 = *tempstring - 48;
	    for (i = t1; i < t2; i++) {
		aut1 = convert(tr->children[0]);
		listptr = returnvalue->accepting;

		while (listptr != NULL) {
		    if (listptr->current->epsilon == NULL) {
			listptr->current->epsilon = alcnodelist();
			listptr->current->epsilon->current = aut1->start;
		      }

		    else {
			listptr2 = listptr->current->epsilon;

			while (listptr2->next != NULL)
			  listptr2 = listptr2->next;

			listptr2->next = alcnodelist();
			listptr2->next->current = aut1->start;
		      }

		    listptr = listptr->next;
		  }

		listptr = returnvalue->accepting;

		while(listptr->next != NULL)
		  listptr = listptr->next;

		listptr->next = aut1->accepting;

		listptr = returnvalue->states;
		while (listptr->next != NULL)
		  listptr = listptr->next;

		listptr->next = aut1->states;
	      }
	  }
	return returnvalue;
      }
    }
}
