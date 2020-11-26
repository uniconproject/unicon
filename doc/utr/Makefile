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

all: utr9c.html utr18.pdf utr22.pdf

utr9c.html: utr9c.pdf htmlean
	pdftohtml -noframes utr9c.pdf
	./htmlean utr9c.html

htmlean: htmlean.icn
	unicon htmlean

utr18.pdf: utr18.tex
	pdflatex utr18

utr9c.pdf: utr9.tex
	pdflatex utr9
	mv utr9.pdf utr9c.pdf

utr20.pdf: utr20.tex
	pdflatex utr20

utr22.pdf: utr22.tex
	pdflatex utr22
