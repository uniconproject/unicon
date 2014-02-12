BASE=..\..
include ..\makedefs

UFILES = filearg.u fileargclass.u main.u symbolinfo.u symboltable.u util.u

all: unidep.exe

clean:
	$(RM) unidep.exe
	$(RM) *.u 
	$(RM) uniclass.dir 
	$(RM) uniclass.pag

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out:

unidep.exe: $(UFILES)
	set IPATH=$(UNI)\lib;$(UNI)\parser;$(ICON_IPL)\lib
	set PATH=$(BIN)
	$(UNICON) -o unidep $(UFILES)
	$(CP) unidep.exe $(BIN)

include deps.out
