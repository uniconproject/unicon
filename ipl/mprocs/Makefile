include ../../Makedefs.uni

TARGETS=$(patsubst %.icn,%.u,$(wildcard *.icn))

IC=../../bin/$(UNICONT)

UFLAGS= -usc

all:$(TARGETS)
	@$(CP) *.u ../lib/

%.u: %.icn
	@echo $<
	@LPATH="../incl ../gincl ../mincl" $(IC) $(UFLAGS) $<

clean Clean:
	rm -f *.u
