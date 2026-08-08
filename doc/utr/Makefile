#
# Makefile for unicon TR's
#
# This file is unfinished/incomplete.
#
# Compile/generate PDF and/or HTML version of Unicon TR's.
# HTML versions may be special-purpose, for Unicon IDE's online help.
#
# Preferred path for new/converted reports: RST via uscribe
# (``make html`` / ``make latex``). Legacy ``%.pdf: %.tex`` remains
# for older LaTeX-only sources.
#
# Under Fedora (e.g. 27 or 28), you may need to install texlive-tabulary,
# texlive-wrapfig, and texlive-changepage in order to build utr16.pdf
# and/or utr18.pdf.
#

TOPDIR=../..
USCRIBE_DIR = $(TOPDIR)/uni/uscribe
USCRIBE ?= $(USCRIBE_DIR)/uscribe
THEMES = $(USCRIBE_DIR)/themes
HTMLDIR = html
TEXDIR = latex
MANIFEST = utr.manifest
TITLE = Unicon Technical Reports

# Legacy LaTeX-only leftovers (not yet converted to RST).
LEGACY_PDF = utr9c.pdf

.PHONY: all html latex pdf pdf-rst notes Clean clean

all: html

# Seed any checked-in *.pdf into $(HTMLDIR) so the index can link them,
# then build HTML. Run ``make pdf`` first (or in CI) for generated PDFs.
html: $(USCRIBE)
	mkdir -p $(HTMLDIR)
	-cp -f *.pdf $(HTMLDIR)/ 2>/dev/null || true
	$(USCRIBE) --manifest=$(MANIFEST) --title="$(TITLE)" \
		--themePath=$(THEMES) --targetDir=$(HTMLDIR) --format=html
	# Reference data linked from utf8.rst (not image assets)
	mkdir -p $(HTMLDIR)/assets/utf8
	cp -f assets/utf8/*.txt $(HTMLDIR)/assets/utf8/

latex: $(USCRIBE)
	mkdir -p $(TEXDIR)
	$(USCRIBE) --manifest=$(MANIFEST) --title="$(TITLE)" \
		--targetDir=$(TEXDIR) --format=latex

# Per-report PDFs beside the HTML (same names as the Download links).
# Continues past individual pdflatex failures (GIF figures, etc.).
pdf pdf-rst: $(USCRIBE)
	mkdir -p $(HTMLDIR)
	-cp -f *.pdf $(HTMLDIR)/ 2>/dev/null || true
	$(USCRIBE) --manifest=$(MANIFEST) --title="$(TITLE)" \
		--targetDir=$(HTMLDIR) --format=pdf

$(USCRIBE):
	$(MAKE) -C $(USCRIBE_DIR)

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

