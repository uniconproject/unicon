BASE=../..
UNI=..
BIN=$(BASE)/bin
RM=rm -f
UNICON=$(UNI)/unicon/unicon
UNIDEP=$(UNI)/unidep/unidep
export ICON_IPL:=$(BASE)/ipl
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

testhtml : testhtml.u
	$(UNICON) -o testhtml testhtml.u

testxml : testxml.u
	$(UNICON) -o testxml testxml.u

testvalid : testvalid.u
	$(UNICON) -o testvalid testvalid.u

testnotwf : testnotwf.u
	$(UNICON) -o testnotwf testnotwf.u

testinvalid : testinvalid.u
	$(UNICON) -o testinvalid testinvalid.u

testpatterns : testpatterns.u
	$(UNICON) -o testpatterns testpatterns.u

globaldemo : globaldemo.u
	$(UNICON) -o globaldemo globaldemo.u

createdemo : createdemo.u
	$(UNICON) -o createdemo createdemo.u

include deps.out
