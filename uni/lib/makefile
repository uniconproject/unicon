RM=rm -f
UNICON=../unicon/unicon

all: qsort.u gui.u encode.u file_dlg.u db.u font_dlg.u

qsort.u : qsort.icn
	$(UNICON) -c $?
gui.u : gui.icn guiconst.icn posix.icn 
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
