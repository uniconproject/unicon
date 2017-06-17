#
# Katie Ray
# Project: ulex
# March 15, 2003
# makefile 
#
CC=cc
CFLAGS= -c -g
LEX=flex
YACC=yacc

all: ulex ulpp

ulex: ulpp y.tab.o main.o lex.yy.o ulexskel.o automata.o tree.o
	$(CC) -o ulex main.o lex.yy.o y.tab.o ulexskel.o automata.o tree.o
	cp ulex ulpp ../../bin

main.o: main.c
	$(CC) $(CFLAGS) main.c

lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) lex.yy.c

lex.yy.c: lex.l
	$(LEX) lex.l

ulexskel.o: ulexskel.c
	$(CC) $(CFLAGS) ulexskel.c

y.tab.o: y.tab.c
	$(CC) $(CFLAGS) y.tab.c

y.tab.c: lexgram.y automata.h tree.h automata.c
	$(YACC) -d lexgram.y

tree.o: tree.c
	$(CC) $(CFLAGS) tree.c

ulpp: ulpp.icn
	unicon ulpp

clean:
	rm lex.yy.c y.tab.c y.tab.h *.o ulpp ulex
