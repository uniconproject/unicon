RM=-del 
CP=copy
BASE=..\..\..
UNI=..\..
BIN=$(BASE)\bin
UNICON=$(UNI)\unicon\unicon
UNIDEP=$(UNI)\unidep\unidep
ICON_IPL=$(BASE)\ipl

PROGS=lines.exe editor.exe multi.exe tickdemo.exe explorer.exe secondtest.exe menudemo.exe \
	demo.exe palette.exe tabs.exe testdialog.exe toolbar.exe \
	listtest.exe texttest.exe tabletest.exe editlisttest.exe dndtest.exe \
	sliders.exe spinners.exe getweb.exe fillpanel.exe \
	filedialogtest.exe sieve.exe ticks.exe leak.exe textsize.exe

all: $(PROGS)

clean: 
	$(RM) uniclass.dir
	$(RM) uniclass.pag

.SUFFIXES : .icn .exe
.icn.exe:
	set IPATH=$(UNI)\lib $(UNI)\gui $(ICON_IPL)\lib
	set LPATH=$(ICON_IPL)\incl $(ICON_IPL)\gincl
	set PATH=$(BIN)
	$(UNICON) $<
