BASE=../..
UNI=..
BIN=$(BASE)/bin
RM=rm -f
CP=cp
UNICON=$(UNI)/unicon/unicon
UNIDEP=$(UNI)/unidep/unidep
export ICON_IPL:=$(BASE)/ipl
export IPATH:=$(UNI)/lib $(ICON_IPL)/lib
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
