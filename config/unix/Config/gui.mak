base = $(shell dirname `pwd`)
RM=rm -f
UNICON=$(base)/unicon/unicon
UNIDEP=$(base)/unidep/unidep
export ICON_IPL:=$(shell dirname $(base))/ipl
export IPATH:=$(base)/lib $(ICON_IPL)/lib
export LPATH:=$(ICON_IPL)/incl

.PHONY: all clean deps

all: libs

clean:
	$(RM) *.u uniclass.dir uniclass.pag 

deps:
	$(UNIDEP) *.icn -p libs -f deps.out -nb

deps.out: ;

%.u: %.icn
	$(UNICON) -c $*

include deps.out
