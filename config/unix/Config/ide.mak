BASE=../..
include ../makedefs

# Avoid picking up a link to dialog in ../gui
export IPATH:=$(UNI)/lib $(ICON_IPL)/lib

CFLAGS= -c -u
SRC=main.icn ui.icn filedlg.icn imgs.icn utags.icn classbrowser.icn \
	whitemenu.icn buffertabset.icn buffertabitem.icn editortabitem.icn \
	buffertextlist.icn icbbutton.icn whitemenubar.icn icbpanel.icn \
	templates.icn definitions.icn

OBJ=ui.u filedlg.u main.u imgs.u utags.u classbrowser.u whitemenu.u \
	buffertabset.u  buffertabitem.u editortabitem.u buffertextlist.u \
	icbbutton.u whitemenubar.u icbpanel.u templates.u definitions.u

ui: $(OBJ)
	$(UNICON) -o ui $(OBJ)
	$(CP) ui$(EXE) ../../bin

ui.u: ui.icn
	$(UNICON) $(CFLAGS) ui

clean:
	$(RM) *.u uniclass.dir uniclass.pag 
