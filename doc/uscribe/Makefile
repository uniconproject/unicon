# uscribe User Guide (doc/uscribe)
# Built with uscribe from uni/uscribe/

SHELL=/bin/sh
TOPDIR=../..
UNICON_TOP_BUILDDIR ?= $(TOPDIR)
include $(UNICON_TOP_BUILDDIR)/Makedefs

USCRIBE_DIR = $(TOPDIR)/uni/uscribe
USCRIBE ?= $(USCRIBE_DIR)/uscribe
TITLE = uscribe User Guide
MANIFEST = manual.manifest
OUTDIR = out
THEME ?= basic
THEMES = $(USCRIBE_DIR)/themes

.PHONY: all html latex pdf basic classic dark clean

default: html
all: html

html: $(USCRIBE)
	mkdir -p $(OUTDIR)/images
	-cp -f images/* $(OUTDIR)/images/ 2>/dev/null || true
	$(USCRIBE) --manifest=$(MANIFEST) --title="$(TITLE)" \
		--copyright="2026, Jafar Al-Gharaibeh" \
		--logo=images/uscribe-logo.png \
		--targetDir=$(OUTDIR) --theme=$(THEME) --themePath=$(THEMES)

latex: $(USCRIBE)
	mkdir -p $(OUTDIR)/images
	-cp -f images/* $(OUTDIR)/images/ 2>/dev/null || true
	$(USCRIBE) --format=latex --manifest=$(MANIFEST) --title="$(TITLE)" \
		--targetDir=$(OUTDIR)

pdf: $(USCRIBE)
	mkdir -p $(OUTDIR)/images
	-cp -f images/* $(OUTDIR)/images/ 2>/dev/null || true
	$(USCRIBE) --format=pdf --manifest=$(MANIFEST) --title="$(TITLE)" \
		--targetDir=$(OUTDIR)

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
