SRC=admin.tex advanced.tex assoc.tex cgi.tex classes.tex database.tex diffs.tex genetic.tex graphics.tex gui.tex internet.tex intro.tex ipl.tex langref.tex large.tex lexyacc.tex object.tex port.tex preface.tex programs.tex referenc.tex string.tex struct.tex system.tex ub.tex ucl.tex usecase.tex

ub.pdf: $(SRC) ub.ind
	pdflatex ub

ub.ind: ub.idx
	makeindex ub.idx

ub.idx: $(SRC)
	pdflatex ub

zip:
	zip -r ub.zip $(SRC) makefile icon.sty ub-img
