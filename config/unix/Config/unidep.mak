BASE=../..
UNI=..
BIN=$(BASE)/bin
RM=rm -f
CP=cp
UNICON=$(UNI)/unicon/unicon
UNIDEP=$(UNI)/unidep/unidep
export ICON_IPL:=$(BASE)/ipl
export IPATH:=$(UNI)/lib $(UNI)/parser $(ICON_IPL)/lib
UFILES = filearg.u  fileargclass.u  main.u  symbolinfo.u  symboltable.u  util.u

.PHONY: all clean deps

all: unidep

clean:
	$(RM) unidep *.u uniclass.dir uniclass.pag 

%.u: %.icn
	$(UNICON) -c $*

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

unidep: $(UFILES)
	$(UNICON) -o unidep $(UFILES)
	$(CP) unidep $(BIN)

include deps.out
