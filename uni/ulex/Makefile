#
# Clinton Jeffery
# Project: uflex
# May 15, 2018
#
# Phase 1:  replace ulex C implementation with ulex .icn implementation.
#	1a: get the ulex .icn implementation to where it is producing tokens
# Phase 2:  convert NFA->DFA
#
# Based on Katie Ray's Project: ulex, March 15, 2003, makefile 
#
CC=cc
CFLAGS= -c -g
LEX=flex
YACC=yacc

all: ulex ulpp

uflex: ulpp flexgram.u main.u uflex-lex.u ulexskel.u automata.u tree.u
	unicon -o uflex flexgram.u main.u uflex-lex.u ulexskel.u automata.u tree.u
	cp uflex ulpp ../../bin

ulex: ulpp y.tab.o main.o lex.yy.o ulexskel.o automata.o tree.o
	$(CC) -o ulex main.o lex.yy.o y.tab.o ulexskel.o automata.o tree.o
	cp ulex ulpp ../../bin

main.u: main.icn
	unicon -c main

main.o: main.c
	$(CC) $(CFLAGS) main.c

flexgram.u: flexgram.icn
	unicon -c flexgram

flexgram.icn: flexgram.y
	iyacc -i flexgram.y

uflex-lex.u: uflex-lex.icn
	unicon -c uflex-lex

lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) lex.yy.c

lex.yy.c: lex.l
	$(LEX) lex.l

ulexskel.u: ulexskel.icn
	unicon -c ulexskel

ulexskel.o: ulexskel.c
	$(CC) $(CFLAGS) ulexskel.c

y.tab.o: y.tab.c
	$(CC) $(CFLAGS) y.tab.c

y.tab.c: lexgram.y automata.h tree.h automata.c
	$(YACC) -d lexgram.y

automata.u: automata.icn
	unicon -c automata

tree.u: tree.icn
	unicon -c tree

tree.o: tree.c
	$(CC) $(CFLAGS) tree.c

ulpp: ulpp.icn
	unicon ulpp

clean:
	rm lex.yy.c y.tab.c y.tab.h *.o ulpp ulex
