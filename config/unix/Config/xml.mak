BASE=../..
UNI=..
BIN=$(BASE)/bin
RM=rm -f
UNICON=$(UNI)/unicon/unicon
UNIDEP=$(UNI)/unidep/unidep
ICON_IPL=$(BASE)/ipl
export IPATH:=$(UNI)/lib $(ICON_IPL)/lib

.PHONY: all clean deps

all: libs testhtml testxml testpatterns testvalid testnotwf testinvalid globaldemo createdemo

clean:
	$(RM) testhtml testxml testpatterns testvalid testnotwf \
		testinvalid globaldemo createdemo *.u uniclass.dir uniclass.pag 

deps:
	$(UNIDEP) *.icn -p libs -f deps.out -nb

deps.out: ;

%.u: %.icn
	$(UNICON) -c $*

%: %.u
	$(UNICON) -o $@ $<

include deps.out
