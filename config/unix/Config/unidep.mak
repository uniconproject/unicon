base = $(shell dirname `pwd`)
RM=rm -f
UNICON=$(base)/unicon/unicon
UNIDEP=$(base)/unidep/unidep
export ICON_IPL:=$(shell dirname $(base))/ipl
export IPATH:=$(base)/lib $(base)/parser $(ICON_IPL)/lib
ufiles = filearg.u  fileargclass.u  main.u  symbolinfo.u  symboltable.u  util.u

.PHONY: all clean deps

all: unidep

clean:
	$(RM) unidep *.u uniclass.dir uniclass.pag 

%.u: %.icn
	$(UNICON) -c $*

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

unidep: $(ufiles)
	$(UNICON) -o unidep $(ufiles)
	cp unidep ../../bin

include deps.out
