BASE=../..
include ../makedefs

# Avoid picking up a link to dialog in ../gui
export IPATH:=$(UNI)/lib $(ICON_IPL)/lib

CFLAGS= -c -u
SRC=ui.icn main.icn
OBJ=ui.u main.u

ui: ui.u main.u
	$(UNICON) ui.u main.u
	$(CP) ui$(EXE) ../../bin

ui.u: ui.icn
	$(UNICON) $(CFLAGS) ui

clean:
	$(RM) *.u uniclass.dir uniclass.pag 
