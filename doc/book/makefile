#
# Name:   makefile
# Author: Clinton Jeffery
#
# This is the Makefile for the LateX Version (2nd edition) of the Unicon Book.
# It has been built on several platforms with recent LaTeX versions that come
# with a pdflatex binary.
#
# Platforms:		Comments
#
# Linux Mint 13		install texlive-latex-extra to get fonts
# Fedora Core 18        install texlive-aeguill and texlive-supertabular
#

SRC=admin.tex advanced.tex assoc.tex cgi.tex classes.tex database.tex diffs.tex genetic.tex graphics.tex gui.tex internet.tex intro.tex ipl.tex langref.tex large.tex lexyacc.tex port.tex preface.tex programs.tex referenc.tex string.tex struct.tex system.tex ub.tex ucl.tex usecase.tex

ub.pdf: $(SRC) ub.ind
	pdflatex ub

ub.ps: ub.pdf
	pdf2ps ub.pdf

ub.ind: ub.idx
	makeindex ub.idx

ub.idx: $(SRC)
	pdflatex ub

zip:
	zip -r ub.zip $(SRC) makefile icon.sty ub-img
