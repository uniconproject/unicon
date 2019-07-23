#
# Clinton Jeffery
# Project: uflex
# May 15, 2018
#
# Phase 1:  replace ulex C implementation with ulex .icn implementation. (done)
#       1a: clean up
# Phase 2:  convert NFA->DFA
#
# Based on Katie Ray's Project: ulex, March 15, 2003, makefile 
#
CC=cc
CFLAGS= -c -g
LEX=flex
YACC=yacc

all: ulex ulpp uflex

uflex: ulpp flexgram.u main.u uflex-lex.u ulexskel.u automata.u tree.u convert.u
	unicon -o uflex flexgram.u main.u uflex-lex.u ulexskel.u automata.u tree.u convert.u
	cp uflex ulpp ../../bin

ulex: ulpp y.tab.o main.o lex.yy.o ulexskel.o automata.o tree.o convert.o
	$(CC) -o ulex main.o lex.yy.o y.tab.o ulexskel.o automata.o tree.o convert.o
	cp ulex ulpp ../../bin

main.u: main.icn
	unicon -c main

main.o: main.c
	$(CC) $(CFLAGS) main.c

flexgram.u: flexgram.icn
	unicon -c flexgram

flexgram.icn flexgram_tab.icn: flexgram.y
	iyacc -i -d flexgram.y

uflex-lex.u: uflex-lex.icn
	unicon -c uflex-lex

lex.yy.o: lex.yy.c y.tab.h
	$(CC) $(CFLAGS) lex.yy.c

lex.yy.c: lex.l
	$(LEX) lex.l

ulexskel.u: ulexskel.icn
	unicon -c ulexskel

ulexskel.o: ulexskel.c
	$(CC) $(CFLAGS) ulexskel.c

automata.o: automata.c automata.h
	$(CC) $(CFLAGS) automata.c

automata.u: automata.icn
	unicon -c automata

y.tab.o: y.tab.c
	$(CC) $(CFLAGS) y.tab.c

y.tab.c y.tab.h: lexgram.y automata.h tree.h automata.c
	$(YACC) -d lexgram.y

tree.u: tree.icn
	unicon -c tree

tree.o: tree.c tree.h y.tab.h
	$(CC) $(CFLAGS) tree.c

convert.o: convert.c y.tab.h tree.h automata.h
	$(CC) $(CFLAGS) convert.c

convert.u: convert.icn flexgram_tab.icn
	unicon -c convert

#
# test w/ dummy main() used only for debugging ulex's lexical analyzer.
#
lexlex: lex.yy.c y.tab.h
	$(CC) $(CFLAGS) -DDEBUG -DMAIN lex.yy.c
	$(CC) -o lexlex lex.yy.o
	rm lex.yy.o

ulpp: ulpp.icn
	unicon ulpp
	cp ulpp ../../bin

clean:
	rm lex.yy.c y.tab.c y.tab.h *.o ulpp ulex
