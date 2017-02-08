
include ../../Makedefs

BASE=../..
LIBD=$(BASE)/plugins/lib

UC=$(BASE)/bin/unicon
WUC=$(BASE)/bin/unicon -G

UFLAGS=-s -u -c
SO=so

# plaform independent  plugins
PCMN=upexample

# Windows 
PWIN=

# *nix OS
PNIX=lxcunicon

# MacOS
PMOS=

.PHONY: clean zip $(PCMN) $(PWIN) $(PNIX) $(PMOS) windows linux macos

default:   $(LIBD)/uso.u $(PCMN)

all: uso.u

windows: $(PCMN) $(PWIN)

linux: $(PCMN) $(PNIX)

macos: $(PCMN) $(PMOS)

# Build cross platforms plugins
$(PCMN): $(LIBD)/uso.u
	make -C $@

# Build Windows plugins
$(PWIN): $(LIBD)/uso.u
	make -C $@

# Build *nix plugins
$(PNIX): $(LIBD)/uso.u
	make -C $@

# Build Mac OS plugins
$(PMOS): $(LIBD)/uso.u
	make -C $@

# Unicon interface
$(LIBD)/%.u:	%.icn $(CSRC)
	cp $< $(LIBD)/
	cd $(LIBD); $(UC) $(UFLAGS) $<
	rm $(LIBD)/$<

#TODO
zip:
	 zip uplugins.zip makefile *.icn *.c *.h

clean:
	echo $(SO)
	$(RM) *.u *.o *.$(SO) uniclass.* *~
	$(RM) $(RM) ../lib/* */*.u */*.o */*.$(SO) */uniclass.* */*~
