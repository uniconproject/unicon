RM=rm -f
BASE=../..
UNI=..
UNICON=$(UNI)/unicon/unicon
UNIDEP=$(UNI)/unidep/unidep
export ICON_IPL:=$(BASE)/ipl
export IPATH:=$(UNI)/lib $(ICON_IPL)/lib
export LPATH:=$(ICON_IPL)/incl $(ICON_IPL)/gincl

RPFILES= border.icn buttongroup.icn _button.icn checkboxgroup.icn \
 checkbox.icn checkboxmenuitem.icn component.icn dispatcher.icn dropdown.icn \
 editabletextlist.icn editlist.icn iconbutton.icn icon.icn _image.icn \
 label.icn _list.icn menubar.icn menubutton.icn menucomponent.icn _menu.icn \
 menuseparator.icn _node.icn overlayitem.icn overlayset.icn _panel.icn \
 popupmenu.icn scrollarea.icn scrollbar.icn sizer.icn submenu.icn \
 tabitem.icn tablecolumn.icn _table.icn tabset.icn textbutton.icn \
 textfield.icn textlist.icn textmenuitem.icn _ticker.icn toggle.icn \
 toggleiconbutton.icn toggletextbutton.icn toolbar.icn _tree.icn

PACKAGE_LIBS=address.u base64handler.u basicclasscoding.u class.u classcoding.u \
 cltable.u comparator.u compoundedit.u contentdisposition.u contenttype.u cvsuser.u \
 cvsutil.u decode.u encode.u encodinghandler.u error.u format.u gethttp.u gethttpgui.u \
 gethttpincl.u gethttpprocess.u group.u httpclient.u httppage.u langprocs.u listener.u \
 listenerlist.u mailbox.u mailclient.u mailmisc.u message.u messagehandler.u method.u \
 methodlistener.u money.u msg.u multipart.u multiparthandler.u noophandler.u object.u \
 popclient.u process.u qsort.u quotedprintablehandler.u rfc822parser.u runnable.u \
 selectiveclasscoding.u sem.u setfields.u shm.u smtpclient.u str_util.u stringbuff.u \
 texthandler.u time.u timezone.u typehandler.u undoableedit.u undomanager.u url.u

.PHONY: all clean deps

all: gui.u file_dlg.u db.u font_dlg.u $(PACKAGE_LIBS)

deps:
	$(UNIDEP) *.icn -p libs -nb -f deps.out

deps.out: ;

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

clean Clean:
	$(RM) *.u uniclass.dir uniclass.pag

tar:
	tar zcvf guifiles.tgz gui.icn makefile ${RPFILES}

%.u: %.icn
	$(UNICON) -c $*

include deps.out
