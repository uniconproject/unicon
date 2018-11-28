BASE=../..
include $(BASE)/Makedefs.uni

UFILES = filearg.u fileargclass.u main.u symbolinfo.u symboltable.u util.u

.PHONY: all clean deps

all: unidep$(EXE)

clean:
	$(RM) unidep$(EXE) *.u uniclass.dir uniclass.pag uniclass.db

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

unidep$(EXE): $(UFILES)
	$(UNICON) -o unidep $(UFILES)
	$(CP) unidep$(EXE) $(BIN)

%.u: %.icn
	$(UNICON) $(UFLAGS) -c $<

include deps.out
