BASE=../..
include $(BASE)/Makedefs.uni

export PATH:=$(BIN):$(PATH)

U= unicon.u unigram.u unilex.u tree.u preproce.u idol.u unix.u tokens.u yyerror.u main.u cfy.u ca.u nocc.u

# Don't delete unigram.u and idol.u, needed for bootstrapping
UDEL= unicon.u unilex.u tree.u preproce.u unix.u tokens.u yyerror.u main.u cfy.u ca.u nocc.u

UCFILES= unicon.icn unigram.icn unilex.icn tree.icn preproce.icn idol.u unix.icn tokens.icn yyerror.icn main.icn cfy.icn ca.icn

# Files from this dir that (for now) we copy into lib/ for use by external
# programs.  Long term, need to reconcile with or replace by stuff in parser/
LIBFILES= ../lib/unilex.u ../lib/tree.u

all: unicon $(WUNICONTARGET)
unicon $(UNICONEXE): nocc.icn $(U) $(LIBFILES)
	$(ICONT) $(U)
	$(CP) unicon$(EXE) $(BIN)

# A windows-specific build option
wunicon $(WUNICONEXE): nocc.icn $(U)
	$(ICONT) -G -o wunicon$(EXE) $(U)
	$(CP) wunicon$(EXE) $(BIN)

%.u: %.icn

unicon.u : unicon.icn
	$(ICONT) $(UFLAGS) -c unicon

nocc.u : nocc.icn nocchelper$(EXE)
	$(ICONT) $(UFLAGS) -c nocc

nocc.icn : nocchelper$(EXE)
	./nocchelper$(EXE) > nocc.icn

nocchelper$(EXE) : nocchelper.c
# The explicit action helps Windows make do the right thing.
# Use gcc explicitly because Makedefs.uni does not have a definition of $(CC).
	gcc $^ -o $@

../lib/unilex.u: unilex.u
	$(CP) unilex.u ../lib

unilex.u : unilex.icn ytab_h.icn
	$(ICONT) $(UFLAGS) -c unilex

main.u: main.icn
	$(ICONT) $(UFLAGS) -c main

../lib/tree.u: tree.u
	$(CP) tree.u ../lib

tree.u : tree.icn
	$(ICONT) $(UFLAGS) -c tree

tokens.u : tokens.icn ytab_h.icn
	$(ICONT) $(UFLAGS) -c tokens

preproce.u : preproce.icn
	$(ICONT) $(UFLAGS) -c preproce

cfy.u : cfy.icn
	$(ICONT) $(UFLAGS) -c cfy

ca.u : ca.icn
	$(ICONT) $(UFLAGS) -c ca

# Commented out to avoid bootstrap problem.
# Uncomment if you modify unigram.y/unigram.icn
#unigram.u: unigram.icn
#	$(ICONT) -c unigram

# build iyacc, and uncomment these lines, if you change the language grammar (or unigram.y)
#unigram.icn : unigram.y ytab_h.icn
#	$(IYACC) -i unigram.y

#ytab_h.icn: unigram.y
#	$(IYACC) -i -d unigram.y
#	mv unigram_tab.icn ytab_h.icn

# these lines were used when Idol was involved in the build process
#unigram.icn : unigram.y ytab_h.icn
#	$(IYACC) -i unigram.y
#	mv unigram.icn unigram.iol
#	idol -c unigram.iol

#
# If you have other unicon binaries on your path (!) you might need this to say "./merr -u ./unicon".
# If you need it to run on Windows, you might have to use .\ instead of ./
#
#yyerror.icn: unigram.icn
#	./merr -u unicon

yyerror.u: yyerror.icn
	$(ICONT) -c yyerror

# Uncomment if you modify idol.icn
#idol.u: idol.icn
#	$(UNICON) -c idol

unix.u: unix.icn
	$(ICONT) $(UFLAGS) -c unix

#
# Don't clean everything, we need some .u files for bootstrapping.
#

clean Clean:
	$(RM) unicon$(EXE) wunicon$(EXE) uniclass.dir uniclass.pag uniclass.db $(UDEL) nocchelper$(EXE) nocc.icn
