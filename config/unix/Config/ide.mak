# makefile for v2-gui Unicon IDE

BASE=../..
include ../makedefs

# Avoid picking up a link to dialog in ../gui
#export IPATH:=$(UNI)/lib $(ICON_IPL)/lib

# nothing to configure here yet
UC=unicon
UFLAGS=-s -c -u

CFLAGS=-s -c -u
SRC=ui.icn ide.icn hfiledialog.icn buffertextlist.icn buffertabset.icn buffertabitem.icn mainbar.icn \
	fontdialog.icn templates.icn definitions.icn uproject.icn cproject.icn jproject.icn \
	projedit.icn idol.icn preproce.icn ytab_h.icn yyerror.icn unigram.icn \
	unicon.icn classbrowser.icn tree.icn utags.icn

OBJ=ui.u ide.u hfiledialog.u buffertextlist.u buffertabset.u buffertabitem.u mainbar.u \
	fontdialog.u templates.u definitions.u uproject.u cproject.u jproject.u \
	projedit.u idol.u preproce.u yyerror.u unigram.u unicon.u \
	classbrowser.u tree.u utags.u

UNICONPACKAGE=idol.u preproce.u tree.u unicon.u unigram.u yyerror.u

ui:	$(UNICONPACKAGE) $(OBJ)
	$(UC) -o ui $(OBJ)
	-$(CP) ui ../../bin
	-$(CP) ui.exe ../../bin

ide.u: ide.icn
	unicon -c ide

hfiledialog.u: hfiledialog.icn
	unicon -c hfiledialog

buffertextlist.u: buffertextlist.icn
	unicon -c buffertextlist

buffertabitem.u: buffertabitem.icn
	unicon -c buffertabitem

buffertabset.u: buffertabset.icn
	unicon -c buffertabset

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

cproject.u: cproject.icn
	unicon -c cproject

jproject.u: jproject.icn
	unicon -c jproject

projedit.u: projedit.icn
	unicon -c projedit

idol.u: idol.icn
	unicon -c idol

preproce.u: preproce.icn
	unicon -c preproce

yyerror.u: yyerror.icn
	unicon -c unigram
	unicon -c yyerror

unigram.u: unigram.icn
	unicon -c unigram
	unicon -c yyerror

unicon.u: unicon.icn
	unicon -c unicon

classbrowser.u: classbrowser.icn
	unicon -c classbrowser

tree.u: tree.icn
	unicon -c tree

utags.u: utags.icn
	unicon -c utags

ui.u: ui.icn
	$(UC) $(CFLAGS) ui

ui.exe: ui

clean:
	$(RM) *.u *~ uniclass.dir uniclass.pag ui
