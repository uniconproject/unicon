RM=-del 
CP=copy
BASE=..\..
UNI=..
BIN=$(BASE)\bin
UNICON=$(UNI)\unicon\unicon
UNIDEP=$(UNI)\unidep\unidep
ICON_IPL=$(BASE)\ipl

all: libs testhtml.exe testxml.exe testpatterns.exe testvalid.exe \
	testnotwf.exe testinvalid.exe globaldemo.exe createdemo.exe

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
	set PATH=$(BIN)
	$(UNICON) -c $*

.SUFFIXES : .u .exe
.u.exe:
	set IPATH=$(UNI)\lib $(ICON_IPL)\lib
	set PATH=$(BIN)
	$(UNICON) -o $@ $<

include deps.out
