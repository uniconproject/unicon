BASE=../..
UNI=..
BIN=$(BASE)/bin
RM=rm -f
UNICON=$(UNI)/unicon/unicon
UNIDEP=$(UNI)/unidep/unidep
IYACC=$(UNI)/iyacc/iyacc
ICON_IPL=$(BASE)/ipl
export IPATH:=$(UNI)/lib $(ICON_IPL)/lib

.PHONY: all clean deps

all: libs showtree showdb

clean:
	$(RM) showtree showdb unigram.icn *.u uniclass.dir uniclass.pag 

deps:
	$(UNIDEP) *.icn -p libs -f deps.out -nb

deps.out: ;

%.u: %.icn
	$(UNICON) -c $*

unigram.icn : unigram.y ytab_h.icn
	$(IYACC) -i unigram.y

%: %.u
	$(UNICON) -o $@ $*

include deps.out
