BASE=../../..
include ../../makedefs

PROGS=lines editor multi tickdemo explorer secondtest menudemo demo palette tabs testdialog toolbar \
      listtest texttest tabletest editlisttest dndtest sliders spinners getweb fillpanel \
      filedialogtest sieve ticks leak textsize
all: $(PROGS)

clean: 
	$(RM) $(PROGS) uniclass.dir uniclass.pag

