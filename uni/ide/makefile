# makefile for v2-gui Unicon IDE

BASE=../..
include ../makedefs

# Avoid picking up a link to dialog in ../gui
#export IPATH:=$(UNI)/lib $(ICON_IPL)/lib

# nothing to configure here yet
ifdef _WINDOWS_
	UC=wunicon
else
	UC=unicon
endif
UFLAGS=-c -u

CFLAGS= -c -u

CP=cp

SRC=ui.icn ide.icn hfiledialog.icn buffertextlist.icn buffertabset.icn \
	buffertabitem.icn mainbar.icn fontdialog.icn templates.icn \
	definitions.icn uproject.icn idol.icn preproce.icn \
	ytab_h.icn yyerror.icn unigram.icn unilex.icn unicon.icn \
	classbrowser.icn tree.icn imgs.icn utags.icn matchparen.icn \
	printdlg.icn

OBJ=ui.u ide.u hfiledialog.u buffertextlist.u buffertabset.u buffertabitem.u \
	mainbar.u fontdialog.u templates.u definitions.u uproject.u \
	idol.u preproce.u ytab_h.u yyerror.u unigram.u unilex.u unicon.u \
	classbrowser.u tree.u imgs.u utags.u matchparen.u printdlg.u

UNICONPACKAGE=idol.u preproce.u tree.u unicon.u unigram.u unilex.u yyerror.u

ui:	$(UNICONPACKAGE) $(OBJ)
	$(UC) -o ui $(OBJ)
ifdef _WINDOWS_
	$(CP) ui.exe ../../bin
else
	$(CP) ui ../../bin
endif

ide.u: ide.icn
	unicon -c ide

printdlg.u: printdlg.icn
	unicon -c printdlg

hfiledialog.u: hfiledialog.icn
	unicon -c hfiledialog

buffertextlist.u: buffertextlist.icn
	unicon -c buffertextlist

buffertabitem.u: buffertabitem.icn
	unicon -c buffertabitem

buffertabset.u: buffertabset.icn
	unicon -c buffertabset

matchparen.u: matchparen.icn
	unicon -c  matchparen

mainbar.u: mainbar.icn
	unicon -c mainbar

fontdialog.u: fontdialog.icn
	unicon -c fontdialog

templates.u: templates.icn
	unicon -c templates

definitions.u: definitions.icn
	unicon -c definitions

uproject.u: uproject.icn
	unicon -c uproject

idol.u: idol.icn
	unicon -c idol

preproce.u: preproce.icn
	unicon -c preproce

ytab_h.u: ytab_h.icn
	unicon -c ytab_h

yyerror.u: yyerror.icn
	unicon -c yyerror

unigram.u: unigram.icn unilex.u
	unicon -c unigram

unilex.u: unilex.icn
	unicon -c unilex

unicon.u: unicon.icn
	unicon -c unicon

classbrowser.u: classbrowser.icn  imgs.u tree.u
	unicon -c classbrowser

tree.u: tree.icn
	unicon -c tree

utags.u: utags.icn
	unicon -c utags

ui.u: ui.icn
	$(UC) $(CFLAGS) ui

ui.exe: ui

clean:
ifdef _WINDOWS_
	$(RM) *.u *~ uniclass.dir uniclass.pag ui.exe
else
	$(RM) *.u *~ uniclass.dir uniclass.pag ui
endif


