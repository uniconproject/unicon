RM=rm -f
UNICON=../unicon/unicon

RPFILES= border.icn buttongroup.icn _button.icn checkboxgroup.icn \
 checkbox.icn checkboxmenuitem.icn component.icn dispatcher.icn dropdown.icn \
 editabletextlist.icn editlist.icn iconbutton.icn icon.icn _image.icn \
 label.icn _list.icn menubar.icn menubutton.icn menucomponent.icn _menu.icn \
 menuseparator.icn _node.icn overlayitem.icn overlayset.icn _panel.icn \
 popupmenu.icn scrollarea.icn scrollbar.icn sizer.icn submenu.icn \
 tabitem.icn tablecolumn.icn _table.icn tabset.icn textbutton.icn \
 textfield.icn textlist.icn textmenuitem.icn _ticker.icn toggle.icn \
 toggleiconbutton.icn toggletextbutton.icn toolbar.icn _tree.icn


all: qsort.u gui.u encode.u file_dlg.u db.u font_dlg.u

qsort.u : qsort.icn
	$(UNICON) -c $?

gui.u : gui.icn guiconst.icn posix.icn ${RPFILES}
	$(UNICON) -c gui

encode.u : encode.icn
	$(UNICON) -c $?
file_dlg.u : file_dlg.icn gui.u
	$(UNICON) -c file_dlg
font_dlg.u : font_dlg.icn gui.u
	$(UNICON) -c font_dlg
db.u : db.icn
	$(UNICON) -c db

Clean:
	$(RM) *.u uniclass.dir uniclass.pag

tar:
	tar zcvf guifiles.tgz gui.icn makefile ${RPFILES}

