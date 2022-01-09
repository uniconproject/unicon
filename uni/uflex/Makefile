#
# Clinton Jeffery
# Project: uflex
# Dec 31, 2021
#
# Based on Katie Ray's Project: ulex, March 15, 2003. Katie's unfinished
# C program is preserved in the deprecated legacy directory ulex/
#
CC=gcc
CFLAGS= -c -g
LEX=win_flex
YACC=win_bison -y

all: uflex

uflex: flexgram.u main.u uflex-lex.u ulexskel.u automata.u tree.u convert.u automatadfa.u uflexskel.u
	unicon -o uflex flexgram.u main.u uflex-lex.u ulexskel.u uflexskel.u automata.u tree.u convert.u automatadfa.u ulpp.icn

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

uflexskel.u: uflexskel.icn
	unicon -c uflexskel

automata.u: automata.icn
	unicon -c automata

automatadfa.u: automatadfa.icn
	unicon -c automatadfa

tree.u: tree.icn
	unicon -c tree

nfa2dfa: nfa2dfa.icn
	unicon -o nfa2dfa nfa2dfa.icn

dfa2auto: dfa2auto.icn 
	unicon -o dfa2auto dfa2auto.icn	ulexskel

convert.u: convert.icn flexgram_tab.icn
	unicon -c convert

clean:
	rm *.u uflex
