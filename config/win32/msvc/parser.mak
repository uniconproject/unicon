RM=-del 
CP=copy
BASE=..\..
UNI=..
BIN=$(BASE)\bin
UNICON=$(UNI)\unicon\unicon
UNIDEP=$(UNI)\unidep\unidep
ICON_IPL=$(BASE)\ipl
IYACC=$(UNI)\iyacc\iyacc

all: libs showtree.exe showdb.exe

clean:
	$(RM) showtree.exe
	$(RM) showdb.exe
	$(RM) *.u 
	$(RM) uniclass.dir 
	$(RM) uniclass.pag

deps:
	$(UNIDEP) *.icn -p libs -f deps.out -nb

deps.out: ;

.SUFFIXES : .icn .u
.icn.u:
	set IPATH=$(UNI)\lib $(ICON_IPL)\lib
	set PATH=$(BIN)
	$(UNICON) -c $*

unigram.icn : unigram.y ytab_h.icn
	$(IYACC) -i unigram.y


.SUFFIXES : .u .exe
.u.exe:
	set IPATH=$(UNI)\lib $(ICON_IPL)\lib
	set PATH=$(BIN)
	$(UNICON) -o $@ $<

include deps.out
