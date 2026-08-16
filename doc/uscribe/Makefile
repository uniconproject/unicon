# uscribe User Guide (doc/uscribe)
# Built with uscribe from uni/uscribe/

SHELL=/bin/sh
TOPDIR=../..
UNICON_TOP_BUILDDIR ?= $(TOPDIR)
include $(UNICON_TOP_BUILDDIR)/Makedefs

USCRIBE_DIR = $(TOPDIR)/uni/uscribe
USCRIBE ?= $(USCRIBE_DIR)/uscribe
OUTDIR = out
THEME ?= basic
USCRIBE_FLAGS = --targetDir=$(OUTDIR)

.PHONY: all html latex pdf basic classic dark clean

default: html
all: html

html: $(USCRIBE)
	mkdir -p $(OUTDIR)/images
	-cp -f images/* $(OUTDIR)/images/ 2>/dev/null || true
	$(USCRIBE) $(USCRIBE_FLAGS) --theme=$(THEME)

latex: $(USCRIBE)
	mkdir -p $(OUTDIR)/images
	-cp -f images/* $(OUTDIR)/images/ 2>/dev/null || true
	$(USCRIBE) --format=latex $(USCRIBE_FLAGS)

pdf: $(USCRIBE)
	mkdir -p $(OUTDIR)/images
	-cp -f images/* $(OUTDIR)/images/ 2>/dev/null || true
	$(USCRIBE) --format=pdf $(USCRIBE_FLAGS)

basic:
	$(MAKE) html THEME=basic

classic:
	$(MAKE) html THEME=classic

dark:
	$(MAKE) html THEME=dark

$(USCRIBE):
	$(MAKE) -C $(USCRIBE_DIR)

clean:
	rm -rf $(OUTDIR)
