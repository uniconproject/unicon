
TOPDIR=../..

default: default_target

UNICON_TOP_BUILDDIR ?= $(TOPDIR)
include $(UNICON_TOP_BUILDDIR)/Makedefs

LIBD=$(TOPDIR)/plugins/lib
ICALLDIR=$(TOPDIR)/uni/icall

UC=$(TOPDIR)/bin/unicon
WUC=$(TOPDIR)/bin/unicon -G

UFLAGS=-s -u -c
#SO=so

CFDYN2= $(CFDYN)

# platform-independent plugins
PCMN=upexample SHA bitman $(SQLITE)

# Windows 
PWIN=

# *nix OS
PNIX=lxcunicon

# macOS
PMOS=

.PHONY: clean zip $(PCMN) $(PWIN) $(PNIX) $(PMOS) windows linux macos

default_target:   icall.$(O) $(LIBD)/uso.u $(PCMN)

all: uso.u icall.$(O)

icall.$(O): $(ICALLDIR)/icall.h $(ICALLDIR)/icall.c
	$(CC) $(CFDYN2) -c $(ICALLDIR)/icall.c
	$(CP) icall.$(O) ../lib/

windows: $(PCMN) $(PWIN)

linux: $(PCMN) $(PNIX)

macos: $(PCMN) $(PMOS)

# Build cross-platform plugins
$(PCMN): $(LIBD)/uso.u
	$(MAKE) -C $@

# Build Windows plugins
$(PWIN): $(LIBD)/uso.u
	$(MAKE) -C $@

# Build *nix plugins
$(PNIX): $(LIBD)/uso.u
	$(MAKE) -C $@

# Build macOS plugins
$(PMOS): $(LIBD)/uso.u
	$(MAKE) -C $@

# Unicon interface
$(LIBD)/%.u:	%.icn $(CSRC)
	$(CP) $< $(LIBD)/
	cd $(LIBD); $(UC) $(UFLAGS) $<
	rm $(LIBD)/$<

#TODO
zip:
	 zip uplugins.zip makefile *.icn *.c *.h

clean:
	echo $(SO)
	$(RM) *.u *.o *.$(SO) uniclass.* *~
	$(RM) ../lib/* */*.u */*.o */*.$(SO) */uniclass.*
	for p in $(PCMN) $(PWIN) $(PNIX) $(PMOS); do \
		$(MAKE) -C $$p $@; \
	done
