BASE=..\..
include ..\makedefs

CFLAGS= -c -u
SRC=ui.icn msg_dlg.icn
OBJ=ui.u

ui.exe: ui.u msg_dlg.u
	set IPATH=$(UNI)\lib $(ICON_IPL)\lib
	set PATH=$(BIN)
	$(UNICON) ui.u
	$(CP) ui.exe $(BIN)

ui.u: ui.icn
	set IPATH=$(UNI)\lib $(ICON_IPL)\lib
	set PATH=$(BIN)
	$(UNICON) $(CFLAGS) ui

msg_dlg.u: msg_dlg.icn
	set IPATH=$(UNI)\lib $(ICON_IPL)\lib
	set PATH=$(BIN)
	$(UNICON) $(CFLAGS) msg_dlg

clean:
	$(RM) *.u 
	$(RM) uniclass.dir 
	$(RM) uniclass.pag
	$(RM) ui.exe
