BASE=../..
include ../makedefs

UFILES = filearg.u fileargclass.u main.u symbolinfo.u symboltable.u util.u

.PHONY: all clean deps

all: unidep

clean:
	$(RM) unidep *.u uniclass.dir uniclass.pag 

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

unidep: $(UFILES)
	$(UNICON) -o unidep $(UFILES)
	$(CP) unidep$(EXE) $(BIN)

include deps.out
