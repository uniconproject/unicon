# makefile for v2-gui Unicon IDE

BASE=../..
include ../makedefs

# Avoid picking up a link to dialog in ../gui
#export IPATH:=$(UNI)/lib $(ICON_IPL)/lib

# nothing to configure here yet
ifdef _WINDOWS_
	UC=..\..\bin\wunicon
else
	UC=../../bin/unicon
endif
UFLAGS=-c -u

CFLAGS= -c -u

CP=cp

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
	$(UC) -o ui $(OBJ)
ifdef _WINDOWS_
	$(CP) ui.exe ../../bin
else
	$(CP) ui ../../bin
endif

ide.u: ide.icn
	$(UC) -c ide

printdlg.u: printdlg.icn
	$(UC) -c printdlg

hfiledialog.u: hfiledialog.icn
	$(UC) -c hfiledialog

buffertextlist.u: buffertextlist.icn
	$(UC) -c buffertextlist

buffertabitem.u: buffertabitem.icn
	$(UC) -c buffertabitem

buffertabset.u: buffertabset.icn
	$(UC) -c buffertabset

matchparen.u: matchparen.icn
	$(UC) -c  matchparen

mainbar.u: mainbar.icn
	$(UC) -c mainbar

fontdialog.u: fontdialog.icn
	$(UC) -c fontdialog

templates.u: templates.icn
	$(UC) -c templates

definitions.u: definitions.icn
	$(UC) -c definitions

uproject.u: uproject.icn
	$(UC) -c uproject

idol.u: idol.icn
	$(UC) -c idol

preproce.u: preproce.icn
	$(UC) -c preproce

ytab_h.u: ytab_h.icn
	$(UC) -c ytab_h

yyerror.u: yyerror.icn
	$(UC) -c unigram
	$(UC) -c yyerror

unigram.u: unigram.icn yyerror.u
	$(UC) -c unigram
	$(UC) -c yyerror

unicon.u: unicon.icn
	$(UC) -c unicon

classbrowser.u: classbrowser.icn  imgs.u tree.u
	$(UC) -c classbrowser

tree.u: tree.icn
	$(UC) -c tree

utags.u: utags.icn
	$(UC) -c utags

ui.u: ui.icn
	$(UC) $(CFLAGS) ui

ui.exe: ui

clean:
ifdef _WINDOWS_
	$(RM) *.u *~ uniclass.dir uniclass.pag ui.exe
else
	$(RM) *.u *~ uniclass.dir uniclass.pag ui
endif


