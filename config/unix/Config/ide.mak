base = $(shell dirname `pwd`)
CP=cp
RM=rm -f
UNICON=$(base)/unicon/unicon
CFLAGS= -c -u
SRC=ui.icn msg_dlg.icn
OBJ=ui.u
export IPATH:=../lib ../../ipl/lib

ui: ui.u msg_dlg.u
	$(UNICON) ui.u
	$(CP) ui ../../bin

ui.u: ui.icn
	$(UNICON) $(CFLAGS) ui

msg_dlg.u: msg_dlg.icn
	$(UNICON) $(CFLAGS) msg_dlg

clean:
	$(RM) *.u uniclass.dir uniclass.pag 
