RM=-del 
CP=copy
BASE=..\..
UNI=..
BIN=$(BASE)\bin
UNICON=$(UNI)\unicon\unicon
UNIDEP=$(UNI)\unidep\unidep
ICON_IPL=$(BASE)\ipl

all: libs

clean:
	$(RM) *.u 
	$(RM) uniclass.dir 
	$(RM) uniclass.pag

deps:
	$(UNIDEP) *.icn -p libs -f deps.out -nb

deps.out: ;

.SUFFIXES : .icn .u
.icn.u:
	set IPATH=$(UNI)\lib $(ICON_IPL)\lib
	set LPATH=$(ICON_IPL)\incl $(ICON_IPL)\gincl
	set PATH=$(BIN)
	$(UNICON) -c $*

include deps.out
