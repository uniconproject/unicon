#
# Clinton Jeffery
# Project: uflex
# Dec 31, 2021
#
# Based on Katie Ray's Project: ulex, March 15, 2003.
#
BASE=../..
include $(BASE)/Makedefs.uni

all: uflex

uflex: flexgram.u main.u uflex-lex.u ulexskel.u automata.u tree.u convert.u automatadfa.u uflexskel.u
	$(UNICON) -o uflex flexgram.u main.u uflex-lex.u ulexskel.u uflexskel.u automata.u tree.u convert.u automatadfa.u ulpp.icn

main.u: main.icn
	$(UNICON) -c main

flexgram.u: flexgram.icn
	$(UNICON) -c flexgram

flexgram.icn flexgram_tab.icn: flexgram.y
	$(IYACC) -i -d flexgram.y

uflex-lex.u: uflex-lex.icn
	$(UNICON) -c uflex-lex

ulexskel.u: ulexskel.icn
	$(UNICON) -c ulexskel

uflexskel.u: uflexskel.icn
	$(UNICON) -c uflexskel

automata.u: automata.icn
	$(UNICON) -c automata

automatadfa.u: automatadfa.icn
	$(UNICON) -c automatadfa

tree.u: tree.icn
	$(UNICON) -c tree

nfa2dfa: nfa2dfa.icn
	$(UNICON) -o nfa2dfa nfa2dfa.icn

dfa2auto: dfa2auto.icn 
	$(UNICON) -o dfa2auto dfa2auto.icn ulexskel

convert.u: convert.icn flexgram_tab.icn
	$(UNICON) -c convert

clean:
	$(RM) *.u uflex
