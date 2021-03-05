#
# Makefile for unicon TR's
#
# This file is unfinished/incomplete.
#
# Compile/generate PDF and/or HTML version of Unicon TR's.
# HTML versions may be special-purpose, for Unicon IDE's online help.
#
# Under Fedora (e.g. 27 or 28), you may need to install texlive-tabulary,
# texlive-wrapfig, and texlive-changepage in order to build utr16.pdf
# and/or utr18.pdf.
#

FILES=utr3.pdf utr15.pdf utr16.pdf utr18.pdf utr19.pdf utr22.pdf utr20.pdf

all: $(FILES)

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
	rm -f  utr*.png utr*.jpg *.log *.out htmlean $(FILES)
