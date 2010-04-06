# makefile for v2-gui Unicon IDE

BASE=../..
include ../makedefs

# Avoid picking up a link to dialog in ../gui
#export IPATH:=$(UNI)/lib $(ICON_IPL)/lib

# nothing to configure here yet

UC=../../bin/unicon
WUC=../../bin/unicon
UFLAGS=-c -u

SRC=ui.icn ide.icn hfiledialog.icn buffertextlist.icn buffertabset.icn \
	buffertabitem.icn mainbar.icn fontdialog.icn templates.icn \
	definitions.icn uproject.icn idol.icn preproce.icn \
	ytab_h.icn yyerror.icn unigram.icn unicon.icn \
	classbrowser.icn tree.icn imgs.icn utags.icn matchparen.icn \
	printdlg.icn

OBJ=ui.u ide.u hfiledialog.u buffertextlist.u buffertabset.u buffertabitem.u \
	mainbar.u fontdialog.u templates.u definitions.u uproject.u \
	idol.u preproce.u ytab_h.u yyerror.u unigram.u unicon.u \
	classbrowser.u tree.u imgs.u utags.u matchparen.u printdlg.u

UNICONPACKAGE=idol.u preproce.u tree.u unicon.u unigram.u yyerror.u

ui:	$(UNICONPACKAGE) $(OBJ)
ifdef _WINDOWS_
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

buffertextlist.u: buffertextlist.icn
	$(UC) $(UFLAGS) buffertextlist

buffertabitem.u: buffertabitem.icn
	$(UC) $(UFLAGS) buffertabitem

buffertabset.u: buffertabset.icn
	$(UC) $(UFLAGS) buffertabset

matchparen.u: matchparen.icn
	$(UC) $(UFLAGS)  matchparen

mainbar.u: mainbar.icn
	$(UC) $(UFLAGS) mainbar

fontdialog.u: fontdialog.icn
	$(UC) $(UFLAGS) fontdialog

templates.u: templates.icn
	$(UC) $(UFLAGS) templates

definitions.u: definitions.icn
	$(UC) $(UFLAGS) definitions

uproject.u: uproject.icn
	$(UC) $(UFLAGS) uproject

idol.u: idol.icn
	$(UC) $(UFLAGS) idol

preproce.u: preproce.icn
	$(UC) $(UFLAGS) preproce

ytab_h.u: ytab_h.icn
	$(UC) $(UFLAGS) ytab_h

yyerror.u: yyerror.icn
	$(UC) $(UFLAGS) unigram
	$(UC) $(UFLAGS) yyerror

unigram.u: unigram.icn yyerror.u
	$(UC) $(UFLAGS) unigram
	$(UC) $(UFLAGS) yyerror

unicon.u: unicon.icn
	$(UC) $(UFLAGS) unicon

classbrowser.u: classbrowser.icn  imgs.u tree.u
	$(UC) $(UFLAGS) classbrowser

tree.u: tree.icn
	$(UC) $(UFLAGS) tree

utags.u: utags.icn
	$(UC) $(UFLAGS) utags

ui.u: ui.icn
	$(UC) $(CFLAGS) ui

ui.exe: ui

clean:
	$(RM) *.u *~ uniclass.dir uniclass.pag ui$(EXE)


