# makefile for v2-gui Unicon IDE

BASE=../..
include ../makedefs

# Avoid picking up a link to dialog in ../gui
#export IPATH:=$(UNI)/lib $(ICON_IPL)/lib

# nothing to configure here yet

UC=../../bin/unicon
WUC=../../bin/unicon -G
UFLAGS=-c -u
UFLAGS2=-c

SRC=ui.icn ide.icn hfiledialog.icn buffertextlist.icn buffertabset.icn \
	buffertabitem.icn mainbar.icn modified.icn templates.icn \
	definitions.icn uproject.icn \
	classbrowser.icn tree.icn imgs.icn utags.icn matchparen.icn

OBJ=ui.u ide.u hfiledialog.u buffertextlist.u buffertabset.u buffertabitem.u \
	mainbar.u modified.u templates.u definitions.u uproject.u \
	classbrowser.u imgs.u utags.u matchparen.u

ui:	$(OBJ)
ifdef EXE
	$(WUC) -o ui $(OBJ)
else
	$(UC) -o ui $(OBJ)
endif
	$(CP) ui$(EXE) ../../bin

ide.u: ide.icn
	$(UC) $(UFLAGS) ide

printdlg.u: printdlg.icn
	$(UC) $(UFLAGS) printdlg

hfiledialog.u: hfiledialog.icn
	$(UC) $(UFLAGS) hfiledialog

buffertextlist.u: buffertextlist.icn ../gui/editabletextlist.icn
	$(UC) $(UFLAGS) buffertextlist

buffertabitem.u: buffertabitem.icn
	$(UC) $(UFLAGS) buffertabitem

buffertabset.u: buffertabset.icn
	$(UC) $(UFLAGS) buffertabset

matchparen.u: matchparen.icn
	$(UC) $(UFLAGS)  matchparen

mainbar.u: mainbar.icn
	$(UC) $(UFLAGS) mainbar

templates.u: templates.icn
	$(UC) $(UFLAGS) templates

definitions.u: definitions.icn
	$(UC) $(UFLAGS) definitions

uproject.u: uproject.icn
	$(UC) $(UFLAGS) uproject

#idol.u: idol.icn
#	$(UC) $(UFLAGS2) idol

#preproce.u: preproce.icn
#	$(UC) $(UFLAGS2) preproce

#yyerror.u: yyerror.icn
#	$(UC) $(UFLAGS2) yyerror

#unicon.u: unicon.icn
#	$(UC) $(UFLAGS2) unicon

classbrowser.u: classbrowser.icn  imgs.u
	$(UC) $(UFLAGS2) classbrowser

#tree.u: tree.icn
#	$(UC) $(UFLAGS2) tree

utags.u: utags.icn
	$(UC) $(UFLAGS2) utags

ui.u: ui.icn
	$(UC) $(UFLAGS) ui

ui.exe: ui

clean:
	$(RM) *.u uniclass.dir uniclass.pag ui$(EXE)


