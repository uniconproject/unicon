#
# Makefile for unicon TR's
#
# This file is unfinished/incomplete.
#
# Compile/generate PDF and/or HTML version of Unicon TR's.
# HTML versions may be special-purpose, for Unicon IDE's online help.
#
# Preferred path for new/converted reports: RST via uniphinx
# (``make html`` / ``make latex``). Legacy ``%.pdf: %.tex`` remains
# for older LaTeX-only sources.
#
# Under Fedora (e.g. 27 or 28), you may need to install texlive-tabulary,
# texlive-wrapfig, and texlive-changepage in order to build utr16.pdf
# and/or utr18.pdf.
#

TOPDIR=../..
UNIPHINX_DIR = $(TOPDIR)/uni/uniphinx
UNIPHINX ?= $(UNIPHINX_DIR)/uniphinx
THEMES = $(UNIPHINX_DIR)/themes
HTMLDIR = html
TEXDIR = latex
MANIFEST = utr.manifest
TITLE = Unicon Technical Reports

# Legacy LaTeX-only leftovers (not yet converted to RST).
LEGACY_PDF = utr9c.pdf

.PHONY: all html latex pdf-rst notes Clean clean

all: html

html: $(UNIPHINX)
	mkdir -p $(HTMLDIR)
	$(UNIPHINX) --manifest=$(MANIFEST) --title="$(TITLE)" \
		--themePath=$(THEMES) --targetDir=$(HTMLDIR) --format=html
	# Reference data linked from utf8.rst (not image assets)
	mkdir -p $(HTMLDIR)/assets/utf8
	cp -f assets/utf8/*.txt $(HTMLDIR)/assets/utf8/

latex: $(UNIPHINX)
	mkdir -p $(TEXDIR)
	$(UNIPHINX) --manifest=$(MANIFEST) --title="$(TITLE)" \
		--targetDir=$(TEXDIR) --format=latex

pdf-rst: $(UNIPHINX)
	mkdir -p $(TEXDIR)
	$(UNIPHINX) --manifest=$(MANIFEST) --title="$(TITLE)" \
		--targetDir=$(TEXDIR) --format=pdf

$(UNIPHINX):
	$(MAKE) -C $(UNIPHINX_DIR)

htmlean: htmlean.icn
	unicon htmlean.icn


utr9c.html: utr9c.pdf htmlean
	pdftohtml -noframes utr9c.pdf
	./htmlean utr9c.html

utr9c.pdf: utr9.tex
	pdflatex utr9.tex
	mv utr9.pdf utr9c.pdf

%.pdf: %.tex
	pdflatex $<

Clean clean:
	rm -f  utr*.png utr*.jpg *.log *.out htmlean $(LEGACY_PDF)
	rm -rf $(HTMLDIR) $(TEXDIR)

# utf8.rst is in the manifest; `notes` is an alias for a full html rebuild
notes: html

