#
# Clinton Jeffery
# Project: uflex
# Dec 31, 2021
#
# Based on Katie Ray's Project: ulex, March 15, 2003.
#
BASE=../..
include $(BASE)/Makedefs.uni

PROGRAM = uflex$(EXE)

all: $(PROGRAM)

$(PROGRAM): flexgram.u main.u uflex-lex.u ulexskel.u automata.u tree.u convert.u automatadfa.u uflexskel.u
	$(UNICON) -s -o uflex flexgram.u main.u uflex-lex.u ulexskel.u uflexskel.u automata.u tree.u convert.u automatadfa.u ulpp.icn
	@cp $(PROGRAM) ../../bin/
	@cd test; $(MAKE)

flexgram.icn flexgram_tab.icn: flexgram.y
	$(IYACC) -i -d flexgram.y

nfa2dfa: nfa2dfa.icn nfa2dfa.icn
	$(UNICON) -s -o nfa2dfa nfa2dfa.icn

dfa2auto: dfa2auto.icn dfa2auto.icn ulexskel.icn
	$(UNICON) -s -o dfa2auto dfa2auto.icn ulexskel.u

convert.u: convert.icn flexgram_tab.icn


clean:
	$(RM) *.u uflex$(EXE) nfa2dfa$(EXE) dfa2auto$(EXE)
	make -C test clean
