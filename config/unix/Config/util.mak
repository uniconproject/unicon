BASE=../..
UNI=..
BIN=$(BASE)/bin
RM=rm -f
CP=cp
UNICON=$(UNI)/unicon/unicon
UNIDEP=$(UNI)/unidep/unidep
ICON_IPL=$(BASE)/ipl
export IPATH:=$(UNI)/lib $(UNI)/xml $(UNI)/parser $(ICON_IPL)/lib
export LPATH:=$(ICON_IPL)/incl

all:	ivibmigrate

clean:	
	$(RM) ivibmigrate \
              *.u uniclass.dir uniclass.pag 

ivibmigrate : ivibmigrate.icn
	$(UNICON) ivibmigrate.icn
	$(CP) ivibmigrate $(BIN)
