BASE=../..
include ../makedefs

# Avoid picking up a link to dialog in ../gui
export IPATH:=$(UNI)/lib $(ICON_IPL)/lib

CFLAGS= -c -u
SRC=ui.icn msg_dlg.icn
OBJ=ui.u

ui: ui.u msg_dlg.u
	$(UNICON) ui.u 
	$(CP) ui$(EXE) ../../bin

ui.u: ui.icn
	$(UNICON) $(CFLAGS) ui

msg_dlg.u: msg_dlg.icn
	$(UNICON) $(CFLAGS) msg_dlg

clean:
	$(RM) *.u uniclass.dir uniclass.pag 
