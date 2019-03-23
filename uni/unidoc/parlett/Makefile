BASE=../../..
include $(BASE)/Makedefs.uni

UFILES = class.u  classvar.u  comment.u  groffoutputter.u  htmloutputter.u  main.u  method.u  other.u  package.u  packageset.u file.u filepos.u

.PHONY: all clean deps

all: unidoc$(EXE)

clean:
	$(RM) *.u uniclass.dir uniclass.pag uniclass.db unidoc$(EXE)

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

unidoc$(EXE): $(UFILES)
	$(UNICON) -o unidoc linkfiles.icn
	$(CP) unidoc$(EXE) $(BIN)

%.u: %.icn
	$(UNICON) $(UFLAGS) -c $<
include deps.out
