BASE=../../..
UNI=../..
BIN=$(BASE)/bin
RM=rm -f
CP=cp
UNICON=$(UNI)/unicon/unicon
UNIDEP=$(UNI)/unidep/unidep
export ICON_IPL:=$(BASE)/ipl
export IPATH:=$(UNI)/lib $(UNI)/gui $(ICON_IPL)/lib
export LPATH:=$(UNI)/gui $(ICON_IPL)/incl

ICONDIR=icon

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

UFILES=attribtab.u basiccanvascomponentui.u buttongroupset.u canvas.u canvasborder.u \
canvasborderdialog.u canvasborderui.u canvasbutton.u canvasbuttondialog.u canvasbuttongroup.u \
canvascheckbox.u canvascheckboxdialog.u canvascheckboxgroup.u canvascheckboxmenuedit.u canvascheckboxmenuitem.u \
canvascheckboxui.u canvascomponent.u canvascomponentdialog.u canvascomponentui.u canvascustom.u \
canvascustomdialog.u canvascustomui.u canvaseditabletextlist.u canvaseditabletextlistdialog.u canvaseditabletextlistui.u \
canvaseditlist.u canvaseditlistdialog.u canvaseditlistui.u canvashscrollbarui.u canvasicon.u \
canvasiconbutton.u canvasiconbuttondialog.u canvasiconbuttonui.u canvasicondialog.u canvasiconui.u \
canvasimage.u canvasimagedialog.u canvasimageui.u canvaslabel.u canvaslabeldialog.u \
canvaslabelui.u canvaslist.u canvaslistdialog.u canvaslistui.u canvasmenu.u \
canvasmenubar.u canvasmenubardialog.u canvasmenubarui.u canvasmenubutton.u canvasmenubuttonui.u \
canvasmenucomponent.u canvasmenucomponentdialog.u canvasmenuseparator.u canvasmenuseparatoredit.u canvasoverlayitem.u \
canvasoverlayset.u canvasoverlaysetdialog.u canvasoverlaysetui.u canvaspanel.u canvaspaneldialog.u \
canvaspanelui.u canvasscrollbar.u canvasscrollbardialog.u canvastabitem.u canvastable.u \
canvastablecolumn.u canvastabledialog.u canvastableui.u canvastabset.u canvastabsetdialog.u \
canvastabsetui.u canvastextbutton.u canvastextbuttondialog.u canvastextbuttonui.u canvastextfield.u \
canvastextfielddialog.u canvastextfieldui.u canvastextlist.u canvastextlistdialog.u canvastextlistui.u \
canvastextmenuitem.u canvastoolbar.u canvastoolbardialog.u canvastoolbarui.u canvasvscrollbarui.u \
cdialog.u checkboxgroupset.u choicedialog.u code.u commondialog.u \
componentsort.u custom.u eventtab.u gridelement.u gridset.u \
group.u groupset.u groupsetdialog.u hcomponentsort.u infodialog.u \
ivib.u main.u menucomponentedit.u menutree.u menutreenode.u \
savechangesdialog.u utils.u vcomponentsort.u version.u \
canvashlineui.u  canvasline.u  canvaslinedialog.u  canvasvlineui.u

.PHONY: all clean deps

all: icons ivib

clean:	cleanicons
	$(RM) ivib *.u uniclass.dir uniclass.pag 

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

%.u: %.icn
	$(UNICON) -c $*

ivib: $(UFILES)
	$(UNICON) -o ivib $(UFILES)
	$(CP) ivib $(BIN)/ivib-v2

.PHONY: icons
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

include deps.out
