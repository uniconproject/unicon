RM=-del 
CP=copy
BASE=..\..
UNI=..
BIN=$(BASE)\bin
UNICON=$(UNI)\unicon\unicon
UNIDEP=$(UNI)\unidep\unidep
ICON_IPL=$(BASE)\ipl

UFILES = filearg.u fileargclass.u main.u symbolinfo.u symboltable.u util.u

all: unidep.exe

clean:
	$(RM) unidep.exe
	$(RM) *.u 
	$(RM) uniclass.dir 
	$(RM) uniclass.pag

.SUFFIXES : .icn .u
.icn.u:
	set IPATH=$(UNI)\lib $(UNI)\parser $(ICON_IPL)\lib
	set PATH=$(BIN)
	$(UNICON) -c $*

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

unidep.exe: $(UFILES)
	set IPATH=$(UNI)\lib $(UNI)\parser $(ICON_IPL)\lib
	set PATH=$(BIN)
	$(UNICON) -o unidep $(UFILES)
	$(CP) unidep.exe $(BIN)

include deps.out
