ICONT=../../bin/icont
CP=cp
RM=rm -f
TOUCH=touch
BIN=../../bin
UNICON=../unicon/unicon
ARC=zip
ARCEXT=zip
IYACC=../iyacc/iyacc
ifeq ($(findstring WindowsNT, $(shell uname)),WindowsNT)
	EXE=.exe
else
	ifeq ($(findstring CYGWIN, $(shell uname)),)
		EXE=
	else
		EXE=.exe
	endif
endif
export PATH:=$(BIN):$(PATH)

U= unicon.u unigram.u unilex.u tree.u preproce.u idol.u unix.u tokens.u yyerror.u main.u cfy.u

UCFILES= unicon.icn unigram.icn unilex.icn tree.icn preproce.icn idol.icn unix.icn tokens.icn yyerror.icn main.icn cfy.icn

unicon$(EXE): Unicon

#unicon: $(U)
#	$(ICONT) $(U)
#	$(CP) unicon$(EXE) $(BIN)

Unicon:
	$(TOUCH) idol.u
	-(test -f ./.dummy && make unicon-fresh) || (test -f ./.dummy2 && make unicon-update) || (make unicon-fresh)

unicon-fresh: $(U)
	$(RM) unigram.icn
	$(IYACC) -i unigram.y
	$(ICONT) unicon.u unigram.u unilex.u tree.u preproce.u idol.u unix.u tokens.u yyerror.u main.u cfy.u
	$(CP) unicon$(EXE) $(BIN)
	$(RM) ./.dummy
	$(TOUCH) ./.dummy2

unicon-update: $(U)
	$(ICONT) $(U)
	$(CP) unicon$(EXE) $(BIN)

#uniconc: $(UCFILES)
#	$(RM) $(U) unigram.icn
#	$(IYACC) -i unigram.y
#	$(UNICON) -DUniconc $(UCFILES) -o unicon
#	$(CP) unicon $(BIN)

uniconc:
	-(test -f ./.dummy && make uniconc-update) || (make uniconc-fresh)

uniconc-fresh: $(UCFILES)
	$(RM) unigram.icn
	$(IYACC) -i unigram.y
	$(UNICON) -DUniconc $(UCFILES) -o unicon
	$(CP) unicon $(BIN)
	$(TOUCH) ./.dummy

uniconc-update: $(U)
	$(UNICON) -DUnicon $(U) -o unicon

# A windows-specific build option
wunicon$(EXE): wunicon

wunicon: $(U)
	$(ICONT) -G -o wunicon.exe $(U)
	$(CP) wunicon$(EXE) $(BIN)

%.u: %.icn

unicon.u : unicon.icn
	$(ICONT) -c unicon

unilex.u : unilex.icn ytab_h.icn
	$(ICONT) -c unilex

main.u: main.icn
	$(ICONT) -c main

tree.u : tree.icn
	$(ICONT) -c tree

tokens.u : tokens.icn ytab_h.icn
	$(ICONT) -c tokens

preproce.u : preproce.icn
	$(ICONT) -c preproce

cfy.u : cfy.icn
	$(ICONT) -c cfy

# Commented out to avoid bootstrap problem.
# Uncomment if you modify unigram.y/unigram.icn
unigram.u: unigram.icn
	$(ICONT) -c unigram

# build iyacc, and uncomment these lines, if you change the language grammar
unigram.icn : unigram.y ytab_h.icn
	$(IYACC) -i unigram.y

# these lines were used when Idol was involved in the build process
#unigram.icn : unigram.y ytab_h.icn
#	$(IYACC) -i unigram.y
#	mv unigram.icn unigram.iol
#	idol -c unigram.iol

#yyerror.icn: unigram.icn
#	merr unicon

yyerror.u: yyerror.icn
	$(ICONT) -c yyerror

# Uncomment if you modify idol.icn
idol.u: idol.icn
	$(UNICON) -c idol

unix.u: unix.icn
	$(ICONT) -c unix

#
# Don't really clean, we need the .u files for bootstrapping.
#

Clean:
	$(RM) unicon$(EXE) uniclass.dir uniclass.pag
