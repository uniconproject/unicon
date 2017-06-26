#
# Name:   makefile
# Author: Clinton Jeffery
#
# This is the Makefile for the LateX Version (2nd edition) of the Unicon Book.
# It has been built on several platforms with recent LaTeX versions that come
# with a pdflatex binary.
#
# Platform Notes:
#
# MacOS: installing MacTex and TeXShop is an easy way to build the document.
#
#
# CENTOS: rm -rf ~/.texlive2012 (or ...2013) to fix bogus latex errors.
#	  May need to install some weird xfntconfig package.
#
# Ubuntu: pdflatex is in texlive-latex-base
#         supertabular is in texlive-latex-extra but its no longer needed
#	  Need packages providing:
# color, array, hhline, makeidx, amsmath, amsfonts, amssymb,
# textcomp, fontenc, hyperref, pdftex, xtab
#
# Fedora 24, RHEL7: install packages texlive-base, texlive-latex,
# texlive-collection-latex, texlive-collection-latexrecommended,
# and texlive-xtab.
#

SRC=admin.tex advanced.tex assoc.tex cgi.tex classes.tex database.tex diffs.tex genetic.tex graphics.tex gui.tex internet.tex intro.tex ipl.tex langref.tex large.tex lexyacc.tex port.tex preface.tex programs.tex referenc.tex string.tex struct.tex system.tex thread.tex ub.tex ucl.tex usecase.tex install.tex

ub.pdf: $(SRC)
	pdflatex ub
	makeindex ub.idx
	pdflatex ub

ub.ps: ub.pdf
	echo "the following pdf2ps command runs silent and deep 1-2 minutes..."
	pdf2ps ub.pdf

zip:
	zip -r ub.zip $(SRC) makefile icon.sty ub-img

publish: ub.pdf
	scp ib.pdf web.sf.net:/home/project-web/unicon/htdocs/book/ub.pdf

nightly: ub.pdf
	scp ub.pdf web.sf.net:/home/project-web/unicon/htdocs/book/ub-nightly.pdf