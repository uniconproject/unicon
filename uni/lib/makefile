RM=rm -f
UNICON=../unicon/unicon

all: qsort.u gui.u encode.u file_dlg.u

qsort.u : qsort.icn
	$(UNICON) -c $?
gui.u : gui.icn guiconst.icn posix.icn 
	$(UNICON) -c gui
encode.u : encode.icn
	$(UNICON) -c $?
file_dlg.u : file_dlg.icn gui.u
	$(UNICON) -c file_dlg

Clean:
	$(RM) *.u?
