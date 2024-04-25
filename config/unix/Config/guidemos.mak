BASE=../../..
include ../../makedefs

PROGS=lines$(EXE) editor$(EXE) multi$(EXE) tickdemo$(EXE) explorer$(EXE) \
	secondtest$(EXE) menudemo$(EXE) demo$(EXE) palette$(EXE) tabs$(EXE) \
	testdialog$(EXE) toolbar$(EXE) listtest$(EXE) texttest$(EXE) tabletest$(EXE) \
	editlisttest$(EXE) dndtest$(EXE) sliders$(EXE) spinners$(EXE) getweb$(EXE) \
	fillpanel$(EXE) filedialogtest$(EXE) sieve$(EXE) ticks$(EXE) leak$(EXE) \
	textsize$(EXE) componentscrollareatest$(EXE) dyncomps$(EXE) imageview$(EXE) \
	ttexplorer$(EXE)

all: $(PROGS)

clean: 
	$(RM) $(PROGS) uniclass.dir uniclass.pag

