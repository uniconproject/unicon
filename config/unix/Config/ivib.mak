BASE=../..
include ../makedefs

#
# makefile for constructing ivib
#

ICONDIR=icon

LIBFILES=../lib/gui.u \
      ../lib/file_dlg.u

UFILES=qsort.u \
      encode.u \
      cdialog.u \
      grid.u \
      canvcomp.u \
      ivib.u \
      groups.u \
      canvas.u \
      images.u \
      utils.u \
      code.u

ICONS=$(ICONDIR)/icn1.ico \
      $(ICONDIR)/icn2.ico \
      $(ICONDIR)/icn3.ico \
      $(ICONDIR)/icn4.ico \
      $(ICONDIR)/icn5.ico \
      $(ICONDIR)/icn6.ico \
      $(ICONDIR)/icn7.ico \
      $(ICONDIR)/icn8.ico \
      $(ICONDIR)/icn9.ico \
      $(ICONDIR)/icn10.ico \
      $(ICONDIR)/icn11.ico \
      $(ICONDIR)/icn12.ico \
      $(ICONDIR)/icn13.ico \
      $(ICONDIR)/icn14.ico \
      $(ICONDIR)/icn15.ico \
      $(ICONDIR)/icn16.ico \
      $(ICONDIR)/icn17.ico \
      $(ICONDIR)/icn18.ico \
      $(ICONDIR)/icn19.ico \
      $(ICONDIR)/icn20.ico \
      $(ICONDIR)/icn21.ico \
      $(ICONDIR)/icn22.ico \
      $(ICONDIR)/icn23.ico \
      $(ICONDIR)/icn24.ico \
      $(ICONDIR)/icn25.ico \
      $(ICONDIR)/icn26.ico \
      $(ICONDIR)/icn27.ico \
      $(ICONDIR)/icn28.ico \
      $(ICONDIR)/icn29.ico \
      $(ICONDIR)/icn30.ico \
      $(ICONDIR)/icn31.ico \
      $(ICONDIR)/icn32.ico \
      $(ICONDIR)/icon.ico

#
# Rule for making the object file
#
#
# Linking
#
ivib$(EXE): ivib

ivib: $(UFILES)
	$(UNICON) -o ivib $(UFILES) $(LIBFILES)
	$(CP) ivib$(EXE) $(BIN)/ivib-v1$(EXE)
	@echo Linking complete.

#
# Program to translate xpm to Icon image format.
#
# uncomment these if you modify the .xpm images
#
#$(ICONDIR)/xpmtoims: $(ICONDIR)/xpmtoims.icn
#	cd $(ICONDIR) && \
#	icont xpmtoims.icn

#
# Rule to translate xpm to icon image format.
#
#$(ICONDIR)/%.ico: $(ICONDIR)/%.xpm
#	$(ICONDIR)/xpmtoims $< >$@

#
# Class and include dependencies
#

cdialog.u : cdialog.icn ../lib/gui.u 
	$(UNICON) -c cdialog
grid.u : grid.icn
	$(UNICON) -c grid
canvcomp.u : canvcomp.icn ../lib/gui.u  cdialog.icn
	$(UNICON) -c canvcomp
ivib.u : ivib.icn ../lib/gui.u version.icn
	$(UNICON) -c ivib
groups.u : groups.icn ../lib/gui.u  cdialog.icn
	$(UNICON) -c groups
canvas.u : canvas.icn ../lib/gui.u  grid.icn cdialog.icn
	$(UNICON) -c canvas
images.u : images.icn $(ICONS)
	$(UNICON) -c images
utils.u : utils.icn
	$(UNICON) -c $?
code.u : code.icn
	$(UNICON) -c $?
qsort.u : qsort.icn
	$(UNICON) -c $?
encode.u : encode.icn
	$(UNICON) -c $?

Clean:
	$(RM) -f ivib$(EXE) *.u uniclass.dir uniclass.pag
