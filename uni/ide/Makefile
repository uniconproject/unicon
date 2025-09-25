# makefile for v2-gui Unicon IDE

BASE=../..
include $(BASE)/Makedefs.uni

ICONDIR=ivib/icon

ICONS=$(ICONDIR)/icn1.icon \
      $(ICONDIR)/icn2.icon \
      $(ICONDIR)/icn3.icon \
      $(ICONDIR)/icn4.icon \
      $(ICONDIR)/icn5.icon \
      $(ICONDIR)/icn6.icon \
      $(ICONDIR)/icn7.icon \
      $(ICONDIR)/icn8.icon \
      $(ICONDIR)/icn9.icon \
      $(ICONDIR)/icn10.icon \
      $(ICONDIR)/icn11.icon \
      $(ICONDIR)/icn12.icon \
      $(ICONDIR)/icn13.icon \
      $(ICONDIR)/icn14.icon \
      $(ICONDIR)/icn15.icon \
      $(ICONDIR)/icn16.icon \
      $(ICONDIR)/icn17.icon \
      $(ICONDIR)/icn18.icon \
      $(ICONDIR)/icn19.icon \
      $(ICONDIR)/icn20.icon \
      $(ICONDIR)/icn21.icon \
      $(ICONDIR)/icn22.icon \
      $(ICONDIR)/icn23.icon \
      $(ICONDIR)/icn24.icon \
      $(ICONDIR)/icn25.icon \
      $(ICONDIR)/icn26.icon \
      $(ICONDIR)/icn27.icon \
      $(ICONDIR)/icn28.icon \
      $(ICONDIR)/icn29.icon \
      $(ICONDIR)/icn30.icon \
      $(ICONDIR)/icn31.icon \
      $(ICONDIR)/icn32.icon \
      $(ICONDIR)/icon.icon

# needed to link idol.u
export IPATH:=$(UNI)/unicon

# nothing to configure here yet

UFLAGS=-s -c -u
UFLAGS2=-s -c

SRC=ui.icn ide.icn hfiledialog.icn buffertextlist.icn buffertabset.icn \
	buffertabitem.icn mainbar.icn modified.icn preferences.icn \
	templates.icn definitions.icn uproject.icn \
	classbrowser.icn tree.icn imgs.icn utags.icn matchparen.icn \
	qu_replace.icn online.icn about.icn is_binary.icn ptyDispatcher.icn \
	shelletl.icn funclookup.icn ivibtab.icn


OBJ=ui.u ide.u hfiledialog.u buffertextlist.u buffertabset.u buffertabitem.u \
	mainbar.u modified.u preferences.u templates.u definitions.u \
	uproject.u classbrowser.u imgs.u utags.u matchparen.u qu_replace.u \
	online.u about.u is_binary.u ptyDispatcher.u shelletl.u funclookup.u\
	ivibtab.u

.PHONY: ivib

all: ivib ui

ivib:
	cd ivib && $(MAKE)

ui:	$(OBJ) #$(UFILES)
	$(UC) $(DASHG) -o ui $(OBJ)
	$(CP) ui$(EXE) ../../bin

funclookup.u: funclookup.icn
	$(UC) $(UFLAGS) funclookup


ide.u: ide.icn
	$(UC) $(UFLAGS) ide

hfiledialog.u: hfiledialog.icn
	$(UC) $(UFLAGS) hfiledialog

online.u: online.icn
	$(UC) $(UFLAGS) online

about.u: about.icn
	$(UC) $(UFLAGS) about

is_binary.u: is_binary.icn
	$(UC) $(UFLAGS) is_binary

buffertextlist.u: buffertextlist.icn ../gui/editabletextlist.icn
	$(UC) $(UFLAGS) buffertextlist

buffertabitem.u: buffertabitem.icn
	$(UC) $(UFLAGS) buffertabitem

buffertabset.u: buffertabset.icn
	$(UC) $(UFLAGS) buffertabset

matchparen.u: matchparen.icn
	$(UC) $(UFLAGS)  matchparen

preferences.u: preferences.icn
	$(UC) $(UFLAGS)  preferences

mainbar.u: mainbar.icn
	$(UC) $(UFLAGS) mainbar

templates.u: templates.icn
	$(UC) $(UFLAGS) templates

definitions.u: definitions.icn
	$(UC) $(UFLAGS) definitions

uproject.u: uproject.icn
	$(UC) $(UFLAGS) uproject

qu_replace.u: qu_replace.icn
	$(UC) $(UFLAGS) qu_replace

ptyDispatcher.u: ptyDispatcher.icn
	$(UC) $(UFLAGS) ptyDispatcher

shelletl.u: shelletl.icn
	$(UC) $(UFLAGS) shelletl

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

ivibtab.u: ivibtab.icn
	$(UC) $(UFLAGS) ivibtab

#tree.u: tree.icn
#	$(UC) $(UFLAGS2) tree

utags.u: utags.icn
	$(UC) $(UFLAGS2) utags

ui.u: ui.icn
	$(UC) $(UFLAGS) ui

ui.exe: ui

icons: $(ICONS)

cleanicons:
	cd $(ICONDIR) ; \
	$(RM) xpmtoims *.icon


# Program to translate xpm to Icon image format.
$(ICONDIR)/xpmtoims: $(ICONDIR)/xpmtoims.icn
	$(UNICON) -o $(ICONDIR)/xpmtoims $(ICONDIR)/xpmtoims.icn


# Rule to translate xpm to icon image format.
$(ICONDIR)/%.icon: $(ICONDIR)/%.xpm $(ICONDIR)/xpmtoims
	$(ICONDIR)/xpmtoims $< >$@

clean :
	$(RM) *.u uniclass.dir uniclass.pag uniclass.db ui$(EXE)
	cd ivib && $(MAKE) clean
