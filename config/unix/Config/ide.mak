UNICON=unicon
CP=cp
CFLAGS= -c -u
SRC=ui.icn msg_dlg.icn
OBJ=ui.u
ui: ui.u msg_dlg.u
	$(UNICON) ui.u
	$(CP) ui ../../bin

ui.u: ui.icn
	$(UNICON) $(CFLAGS) ui

msg_dlg.u: msg_dlg.icn
	$(UNICON) $(CFLAGS) msg_dlg
