BASE=..\..\..
include ..\..\makedefs

PROGS=lines.exe editor.exe multi.exe tickdemo.exe explorer.exe secondtest.exe menudemo.exe \
	demo.exe palette.exe tabs.exe testdialog.exe toolbar.exe \
	listtest.exe texttest.exe tabletest.exe editlisttest.exe dndtest.exe \
	sliders.exe spinners.exe getweb.exe fillpanel.exe \
	filedialogtest.exe sieve.exe ticks.exe leak.exe textsize.exe \
	componentscrollareatest.exe dyncomps.exe imageview.exe \
	ttexplorer.exe

all: $(PROGS)

clean: 
	$(RM) uniclass.dir
	$(RM) uniclass.pag
