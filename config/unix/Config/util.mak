base = $(shell dirname `pwd`)
export ICON_IPL:=$(shell dirname $(base))/ipl
export IPATH:=$(base)/lib $(base)/xml $(base)/parser $(base)/mysql $(ICON_IPL)/lib
export LPATH:=$(ICON_IPL)/incl

all:	ivibmigrate

clean:	
	rm -f ivibmigrate \
              *.u uniclass.dir uniclass.pag 

ivibmigrate : ivibmigrate.icn
	unicon ivibmigrate.icn
	cp ivibmigrate ../../bin
