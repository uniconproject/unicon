BASE=..\..
include ..\makedefs

all:	ivibmigrate.exe

clean:	
	$(RM) ivibmigrate.exe
	$(RM) *.u
	$(RM) uniclass.dir
	$(RM) uniclass.pag

ivibmigrate.exe : ivibmigrate.icn
	set IPATH=$(UNI)\lib $(UNI)\gui $(ICON_IPL)\lib
	set LPATH=$(ICON_IPL)\incl $(ICON_IPL)\gincl
	set PATH=$(BIN)
	$(UNICON) ivibmigrate.icn
	$(CP) ivibmigrate.exe $(BIN)
