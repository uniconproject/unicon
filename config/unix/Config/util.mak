base = $(shell dirname `pwd`)
RM=rm -f
UNICON=$(base)/unicon/unicon
UNIDEP=$(base)/unidep/unidep
export ICON_IPL:=$(shell dirname $(base))/ipl
export IPATH:=$(base)/lib $(base)/xml $(base)/parser $(base)/mysql $(ICON_IPL)/lib
export LPATH:=$(ICON_IPL)/incl

all:	ivibmigrate

clean:	
	$(RM) ivibmigrate \
              *.u uniclass.dir uniclass.pag 

ivibmigrate : ivibmigrate.icn
	$(UNICON) ivibmigrate.icn
	cp ivibmigrate ../../bin
