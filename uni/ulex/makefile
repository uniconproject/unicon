#
# Katie Ray
# Project: ulex
# March 15, 2003
# makefile 
#
LEX=flex

all: ulex ulpp

ulex: ulpp y.tab.o main.o lex.yy.o ulexskel.o automata.o
	cc -o ulex main.o lex.yy.o y.tab.o ulexskel.o automata.o
	cp ulex ulpp ../../bin

main.o: main.c automata.h tree.h automata.c tree.c
	cc -c -g main.c

lex.yy.o: lex.yy.c
	cc -c -g lex.yy.c

lex.yy.c: lex.l
	$(LEX) lex.l

ulexskel.o: ulexskel.c
	cc -c -g ulexskel.c

y.tab.o: y.tab.c
	cc -c -g y.tab.c

y.tab.c: lexgram.y automata.h tree.h automata.c tree.c
	yacc -d lexgram.y

ulpp: ulpp.icn
	unicon ulpp

clean:
	rm lex.yy.c y.tab.c y.tab.h *.o ulpp ulex
