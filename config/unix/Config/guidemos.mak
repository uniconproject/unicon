base = $(shell dirname `dirname \`pwd\``)
RM=rm -f
UNICON=$(base)/unicon/unicon
UNIDEP=$(base)/unidep/unidep
export ICON_IPL:=$(shell dirname $(base))/ipl
export IPATH:=$(base)/lib $(base)/gui $(ICON_IPL)/lib
export LPATH:=$(base)/gui $(ICON_IPL)/incl

PROGS=lines editor multi tickdemo explorer secondtest menudemo demo palette tabs testdialog toolbar \
      listtest texttest tabletest editlisttest dndtest sliders spinners getweb fillpanel \
      filedialogtest sieve ticks leak textsize
all: $(PROGS)

clean: 
	$(RM) $(PROGS) uniclass.dir uniclass.pag

%: %.icn
	$(UNICON) $@
