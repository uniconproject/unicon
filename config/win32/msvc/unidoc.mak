RM=-del 
CP=copy
BASE=..\..
UNI=..
BIN=$(BASE)\bin
UNICON=$(UNI)\unicon\unicon
UNIDEP=$(UNI)\unidep\unidep
ICON_IPL=$(BASE)\ipl

UFILES = class.u classvar.u comment.u groffoutputter.u htmloutputter.u \
	main.u method.u other.u package.u packageset.u file.u filepos.u

all: unidoc.exe

clean:
	$(RM) unidoc.exe
	$(RM) *.u 
	$(RM) uniclass.dir 
	$(RM) uniclass.pag

.SUFFIXES : .icn .u
.icn.u:
	set IPATH=$(UNI)\lib $(UNI)\parser $(UNI)\xml $(ICON_IPL)\lib
	set PATH=$(BIN)
	$(UNICON) -c $*

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

unidoc.exe: $(UFILES)
	set IPATH=$(UNI)\lib $(UNI)\parser $(UNI)\xml $(ICON_IPL)\lib
	set PATH=$(BIN)
	$(UNICON) -o unidoc linkfiles.icn
	$(CP) unidoc.exe $(BIN)

include deps.out
