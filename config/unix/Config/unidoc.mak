base = $(shell dirname `pwd`)
RM=rm -f
UNICON=$(base)/unicon/unicon
UNIDEP=$(base)/unidep/unidep
export ICON_IPL:=$(shell dirname $(base))/ipl
export IPATH:=$(base)/lib $(base)/parser $(base)/xml $(ICON_IPL)/lib

ufiles = class.u  classvar.u  comment.u  groffoutputter.u  htmloutputter.u  main.u  method.u  other.u  package.u  packageset.u file.u filepos.u

.PHONY: all clean deps

all: unidoc

clean:
	$(RM) *.u uniclass.dir uniclass.pag unidoc

%.u: %.icn
	$(UNICON) -c $*

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

unidoc: $(ufiles)
	$(UNICON) -o unidoc $(ufiles)
	cp unidoc ../../bin

include deps.out
