# makefile for v2-gui Unicon IDE, visual C++ edition

BASE=..\..
include ..\makedefs

WUC=$(UNICON) -G
UFLAGS=-c -u
UFLAGS2=-c
OBJ=ui.u
EXE=.exe

SRC=ui.icn ide.icn hfiledialog.icn buffertextlist.icn buffertabset.icn \
	buffertabitem.icn mainbar.icn modified.icn preferences.icn \
	templates.icn definitions.icn uproject.icn \
	classbrowser.icn tree.icn imgs.icn utags.icn matchparen.icn \
	qu_replace.icn online.icn about.icn is_binary.u

OBJ=ui.u ide.u hfiledialog.u buffertextlist.u buffertabset.u buffertabitem.u \
	mainbar.u modified.u preferences.u templates.u definitions.u \
	uproject.u classbrowser.u imgs.u utags.u matchparen.u qu_replace.u \
	online.u about.u is_binary.u


ui: $(OBJ)
	set IPATH=$(UNI)\lib;$(UNI)\unicon;$(UNI)\gui;$(UNI)\xml;$(ICON_IPL)\lib
	set LPATH=$(UNI)\gui;$(ICON_IPL)\incl;$(ICON_IPL)\gincl;$(ICON_IPL)\mincl
	$(WUC) -o ui $(OBJ)
	$(CP) ui$(EXE) $(BIN)

ide.u: ide.icn
	$(UNICON) $(UFLAGS) ide

printdlg.u: printdlg.icn
	$(UNICON) $(UFLAGS) printdlg

hfiledialog.u: hfiledialog.icn
	$(UNICON) $(UFLAGS) hfiledialog

online.u: online.icn
	$(UNICON) $(UFLAGS) online

about.u: about.icn
	$(UNICON) $(UFLAGS) about

is_binary.u: is_binary.icn
	$(UNICON) $(UFLAGS) is_binary

buffertextlist.u: buffertextlist.icn ../gui/editabletextlist.icn
	$(UNICON) $(UFLAGS) buffertextlist

buffertabitem.u: buffertabitem.icn
	$(UNICON) $(UFLAGS) buffertabitem

buffertabset.u: buffertabset.icn
	$(UNICON) $(UFLAGS) buffertabset

matchparen.u: matchparen.icn
	$(UNICON) $(UFLAGS)  matchparen

preferences.u: preferences.icn
	$(UNICON) $(UFLAGS)  preferences

mainbar.u: mainbar.icn
	$(UNICON) $(UFLAGS) mainbar

templates.u: templates.icn
	$(UNICON) $(UFLAGS) templates

definitions.u: definitions.icn
	$(UNICON) $(UFLAGS) definitions

uproject.u: uproject.icn
	$(UNICON) $(UFLAGS) uproject

qu_replace.u: qu_replace.icn
	$(UNICON) $(UFLAGS) qu_replace

#idol.u: idol.icn
#	$(UNICON) $(UFLAGS2) idol

#preproce.u: preproce.icn
#	$(UNICON) $(UFLAGS2) preproce

#yyerror.u: yyerror.icn
#	$(UNICON) $(UFLAGS2) yyerror

#unicon.u: unicon.icn
#	$(UNICON) $(UFLAGS2) unicon

classbrowser.u: classbrowser.icn  imgs.u
	$(UNICON) $(UFLAGS2) classbrowser

#tree.u: tree.icn
#	$(UNICON) $(UFLAGS2) tree

utags.u: utags.icn
	$(UNICON) $(UFLAGS2) utags

ui.u: ui.icn
	$(UNICON) $(UFLAGS) ui

ui.exe: ui

clean:
	$(RM) *.u 
	$(RM) uniclass.*
	$(RM) ui.exe

