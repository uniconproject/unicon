ICONT=../../bin/icont
CP=cp
RM=rm -f
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

unicon$(EXE): unigram.u unilex.u tree.u preproce.u idol.u unicon.u unix.u tokens.u yyerror.u
	$(ICONT) unicon.u unigram.u unilex.u tree.u preproce.u idol.u unix.u tokens.u yyerror.u
	$(CP) unicon$(EXE) $(BIN)

# A windows-specific build option
wunicon$(EXE): unigram.u unilex.u tree.u preproce.u idol.u unicon.u unix.u tokens.u yyerror.u
	$(ICONT) -G -o wunicon.exe unicon.u unigram.u unilex.u tree.u preproce.u idol.u unix.u tokens.u yyerror.u
	$(CP) wunicon$(EXE) $(BIN)

%.u: %.icn

unicon.u : unicon.icn
	$(ICONT) -c unicon

unilex.u : unilex.icn ytab_h.icn
	$(ICONT) -c unilex

tree.u : tree.icn
	$(ICONT) -c tree

tokens.u : tokens.icn ytab_h.icn
	$(ICONT) -c tokens

preproce.u : preproce.icn
	$(ICONT) -c preproce

# Commented out to avoid bootstrap problem.
# Uncomment if you modify unigram.y/unigram.icn
#unigram.u: unigram.icn
#	$(UNICON) -c unigram

# build iyacc, and uncomment these lines, if you change the language grammar
#unigram.icn : unigram.y ytab_h.icn
#	$(IYACC) -i unigram.y

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
#idol.u: idol.icn
#	$(UNICON) -c idol

unix.u: unix.icn
	$(ICONT) -c unix

#
# Don't really clean, we need the .u files for bootstrapping.
#

Clean:
	$(RM) unicon$(EXE) uniclass.dir uniclass.pag
