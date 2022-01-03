#
# Katie Ray's Project: ulex, March 15, 2003, makefile 
# Extended by Jeffery. Deprecated and unfinished legacy code.
#
CC=gcc
CFLAGS= -c -g
LEX=flex
YACC=yacc

all: ulex

ulex: y.tab.o main.o lex.yy.o ulexskel.o automata.o tree.o convert.o
	$(CC) -o ulex main.o lex.yy.o y.tab.o ulexskel.o automata.o tree.o convert.o

main.o: main.c
	$(CC) $(CFLAGS) main.c

lex.yy.o: lex.yy.c y.tab.h
	$(CC) $(CFLAGS) lex.yy.c

lex.yy.c: lex.l
	$(LEX) lex.l

ulexskel.o: ulexskel.c
	$(CC) $(CFLAGS) ulexskel.c

automata.o: automata.c automata.h
	$(CC) $(CFLAGS) automata.c

y.tab.o: y.tab.c
	$(CC) $(CFLAGS) y.tab.c

y.tab.c y.tab.h: lexgram.y automata.h tree.h automata.c
	$(YACC) -d lexgram.y

tree.o: tree.c tree.h y.tab.h
	$(CC) $(CFLAGS) tree.c

convert.o: convert.c y.tab.h tree.h automata.h
	$(CC) $(CFLAGS) convert.c


#
# test w/ dummy main() used only for debugging ulex's lexical analyzer.
#
lexlex: lex.yy.c y.tab.h
	$(CC) $(CFLAGS) -DDEBUG -DMAIN lex.yy.c
	$(CC) -o lexlex lex.yy.o
	rm lex.yy.o

clean:
	rm lex.yy.c y.tab.c y.tab.h *.o ulex
