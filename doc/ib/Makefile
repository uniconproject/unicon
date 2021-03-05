#
# Implementation Compendium makefile
# The Icon and Unicon implementation compendium is not considered part of the
# source code, for example "make Unicon" probably does not build it.  It is
# normally read in PDF form from the unicon.org website.  If you want to build
# it from source, you should do this on a machine
# that has the capacity to install LaTeX, potentially all of it.
#
# Known Binaries/Packages/Class Files/Style Files Used
# pdflatex, makeindex
# color, array, xtab, hhline, makeidx, amsmath, amsfonts, amssymb,
# textcomp, fontenc, hyperref, pdftex
#
#
# Platform Notes:
#
# MacOS: installing MacTex and TeXShop is an easy way to build the document.
#
#
# CENTOS: rm -rf ~/.texlive2012 (or ...2013) to fix bogus latex errors.
#	  Needed to install some weird xfntconfig package.
#
# Ubuntu: pdflatex is in texlive-latex-base
#         supertabular is in texlive-latex-extra but its no longer needed
#	  lmodern.sty is in lmodern
#	  Need packages providing:
# color, array, hhline, makeidx, amsmath, amsfonts, amssymb,
# textcomp, fontenc, hyperref, pdftex, xtab
#
# Fedora 24, RHEL7: install packages texlive-base, texlive-latex,
# texlive-collection-latex, texlive-collection-latexrecommended,
# and texlive-xtab.

# Many might have been installed as requirements as one of the main packages
# was installed.  Package names may change from distribution to distribution.
#
# tex-common, tex-gyre, texlive, texlive-base, texlive-binaries
# texlive-extra-utils, texlive-font-utils, texlive-fonts-recommended
# texlive-fonts-recommended-doc, texlive-generic-recommended
# texlive-lang-french, texlive-latex-base, texlive-latex-base-doc
# texlive-latex-extra, texlive-latex-extra-doc
# texlive-latex-recommended, texlive-latex-recommended-doc
# texlive-pictures, texlive-pictures-doc
# texlive-pstricks, texlive-pstricks-doc
#
# The resulting PDF file is at present in flux/under construction and has many
# warning messages indicating poor formatting, missing font shapes etc. For
# example, texlive-fonts-recommended is supposed to provide the helvetica bold
# font expected by Unicon books, but I am getting warnings that
# 'T1/phvb/bx/n' and 'T1/phvb/m/n' are is missing.
#

P1= p1-intro.tex p1-iconOverview.tex p1-organization.tex p1-values.tex p1-strings-csets.tex p1-lists.tex p1-sets-tables.tex p1-interpreter.tex p1-exprEval.tex p1-procs-coexprs.tex p1-records-classes.tex p1-storage.tex p1-runTime.tex
KW=kw/figure3-2.png kw/figure4-6.png
P2=p2-preface.tex p2-compiler.tex p2-transModel.tex p2-typeTheory.tex p2-liveness.tex p2-overview.tex p2-iconcOrg.tex p2-typeInfer.tex p2-codeGen.tex p2-ctrlflow.tex p2-invoke.tex p2-codePerform.tex p2-futureWork.tex p2-space.tex p2-iconcOpt.tex $(KW)
P3=p3-unicon.tex p3-network-posix.tex p3-database.tex p3-2D3D.tex p3-concur.tex p3-monitor.tex p3-uniconc.tex
P4=appA.tex appB.tex appC.tex appD.tex app-projects.tex app-solutions.tex app-rtl.tex appH.tex appI.tex
SRC=ib.tex intro.tex preface.tex $(P1) $(P2) $(P3) $(P4) references.tex gnudoclicence.tex idxterms.xml index-xref.tex

ib.pdf: $(SRC) ib.ind
	pdflatex ib.tex

publish: ib.pdf
	scp ib.pdf web.sf.net:/home/project-web/unicon/htdocs/book/ib.pdf

nightly: ib.pdf
	scp ib.pdf web.sf.net:/home/project-web/unicon/htdocs/book/ib-nightly.pdf

# Indexing:
#    The index terms are either put into the individual tex files manually, or
#    are inserted by the automatic indexer program idxGen.  IdxGen inserts
#    literally *thousands* of \index commands, which would make the original
#    source very hard to read. So, a "sacrificial copy" of the source is made in
#    a temporary directory, the indexing is done on the copy and the final
#    result (index.ind) is copied back into the main directory.
#
index: ib.ind

ib.ind: idxtmp $(SRC)
	../../uni/progs/idxGen -Dir idxtmp/ib -wait 60 -float *.tex
# Suppress the output from the two pdflatex commands in idxtmp
# Also ignore errors (because the error messages are also swallowed).
# Any errors will be seen when the final pdflatex command (above) is executed.
	-(cd idxtmp/ib; \
	pdflatex -interaction=nonstopmode ib.tex; \
	makeindex ib; \
	pdflatex -interaction=nonstopmode ib.tex; \
	makeindex ib ) >/dev/null
	mv idxtmp/ib/*.aux idxtmp/ib/*.[io]* idxtmp/ib/*.toc .

idxtmp:
	test ! -d idxtmp && mkdir idxtmp
	(cd ..; tar -c -f - --exclude '*idxtmp*' *.sty ib/* ) | (cd idxtmp; tar -x -f - )


# Temporary development aid: Just run idxGen with maximum output
indexrun:
	../../uni/progs/idxGen -V -Dir idxtmp/ib -wait 30  -float *.tex

Clean clean:
	rm -f *.aux *.log ib.ind
	rm -rdf idxtmp
