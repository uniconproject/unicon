BASE=..\..\..
include ..\..\makedefs

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
ivib.u ivibmigrate.u main.u menucomponentedit.u menutree.u menutreenode.u \
savechangesdialog.u utils.u vcomponentsort.u version.u \
canvashlineui.u  canvasline.u  canvaslinedialog.u  canvasvlineui.u \
canvastreeui.u canvastree.u canvastreedialog.u \
canvaslistspinui.u canvaslistspin.u canvaslistspindialog.u \
canvasrangespinui.u canvasrangespin.u canvasrangespindialog.u \
canvashsliderui.u  canvasslider.u  canvassliderdialog.u  canvasvsliderui.u \
canvashsizerui.u  canvassizer.u  canvassizerdialog.u  canvasvsizerui.u

all: ivib.exe

clean:
	$(RM) ivib.exe
	$(RM) *.u 
	$(RM) uniclass.dir 
	$(RM) uniclass.pag

ivib.exe: $(UFILES)
	set IPATH=$(UNI)\lib $(UNI)\gui $(ICON_IPL)\lib
	set PATH=$(BIN)
	$(UNICON) -o ivib linkfiles.icn
	$(CP) ivib.exe $(BIN)\ivib-v2.exe

include deps.out
