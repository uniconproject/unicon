base = $(shell dirname `pwd`)
RM=rm -f
UNICON=$(base)/unicon/unicon
UNIDEP=$(base)/unidep/unidep
IYACC=$(base)/iyacc/iyacc
export ICON_IPL:=$(shell dirname $(base))/ipl
export IPATH:=$(base)/lib $(ICON_IPL)/lib

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

showtree : showtree.u
	$(UNICON) -o showtree showtree.u

showdb : showdb.u
	$(UNICON) -o showdb showdb.u

include deps.out
