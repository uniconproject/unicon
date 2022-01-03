#
# Clinton Jeffery
# Project: uflex
# Dec 31, 2021
#
# Based on Katie Ray's Project: ulex, March 15, 2003. Katie's unfinished
# C program is preserved in the deprecated legacy directory ulex/
#
CC=cc
CFLAGS= -c -g
LEX=flex
YACC=yacc

all: uflex

uflex: flexgram.u main.u uflex-lex.u ulexskel.u automata.u tree.u convert.u
	unicon -o uflex flexgram.u main.u uflex-lex.u ulexskel.u automata.u tree.u convert.u
	cp uflex ../../bin

main.u: main.icn
	unicon -c main

flexgram.u: flexgram.icn
	unicon -c flexgram

flexgram.icn flexgram_tab.icn: flexgram.y
	iyacc -i -d flexgram.y

uflex-lex.u: uflex-lex.icn
	unicon -c uflex-lex

ulexskel.u: ulexskel.icn
	unicon -c ulexskel

automata.u: automata.icn
	unicon -c automata

tree.u: tree.icn
	unicon -c tree

convert.u: convert.icn flexgram_tab.icn
	unicon -c convert

clean:
	rm *.u uflex
