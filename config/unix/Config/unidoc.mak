BASE=../..
UNI=..
BIN=$(BASE)/bin
RM=rm -f
CP=cp
UNICON=$(UNI)/unicon/unicon
UNIDEP=$(UNI)/unidep/unidep
ICON_IPL=$(BASE)/ipl
export IPATH:=$(UNI)/lib $(UNI)/parser $(UNI)/xml $(ICON_IPL)/lib

UFILES = class.u  classvar.u  comment.u  groffoutputter.u  htmloutputter.u  main.u  method.u  other.u  package.u  packageset.u file.u filepos.u

.PHONY: all clean deps

all: unidoc

clean:
	$(RM) *.u uniclass.dir uniclass.pag unidoc

%.u: %.icn
	$(UNICON) -c $*

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

unidoc: $(UFILES)
	$(UNICON) -o unidoc linkfiles.icn
	$(CP) unidoc $(BIN)

include deps.out
