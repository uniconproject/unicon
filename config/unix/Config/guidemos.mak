BASE=../../..
UNI=../..
RM=rm -f
UNICON=$(UNI)/unicon/unicon
UNIDEP=$(UNI)/unidep/unidep
export ICON_IPL:=$(BASE)/ipl
export IPATH:=$(UNI)/lib $(UNI)/gui $(ICON_IPL)/lib
export LPATH:=$(UNI)/gui $(ICON_IPL)/incl

PROGS=lines editor multi tickdemo explorer secondtest menudemo demo palette tabs testdialog toolbar \
      listtest texttest tabletest editlisttest dndtest sliders spinners getweb fillpanel \
      filedialogtest sieve ticks leak textsize
all: $(PROGS)

clean: 
	$(RM) $(PROGS) uniclass.dir uniclass.pag

%: %.icn
	$(UNICON) $@
