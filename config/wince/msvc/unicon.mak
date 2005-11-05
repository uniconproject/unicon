ARC=zip
ARCEXT=zip
IYACC=../iyacc/iyacc
RM=-del
CP=copy
BASE=..\..
EXE=.exe
UNI=..
BIN=$(BASE)\bin
ICONT=$(BIN)\icont

all:	unicon.exe wunicon.exe

unicon.exe: unigram.u unilex.u tree.u preproce.u idol.u unicon.u unix.u tokens.u yyerror.u
	set PATH=$(BIN)
	$(ICONT) unicon.u unigram.u unilex.u tree.u preproce.u idol.u unix.u tokens.u yyerror.u
	$(CP) unicon.exe $(BIN)

# A windows-specific build option
wunicon.exe: unigram.u unilex.u tree.u preproce.u idol.u unicon.u unix.u tokens.u yyerror.u
	set PATH=$(BIN)
	$(ICONT) -G -o wunicon.exe unicon.u unigram.u unilex.u tree.u preproce.u idol.u unix.u tokens.u yyerror.u
	$(CP) wunicon.exe $(BIN)

unicon.u : unicon.icn
	set PATH=$(BIN)
	$(ICONT) -c unicon

unilex.u : unilex.icn ytab_h.icn
	set PATH=$(BIN)
	$(ICONT) -c unilex

tree.u : tree.icn
	set PATH=$(BIN)
	$(ICONT) -c tree

tokens.u : tokens.icn ytab_h.icn
	set PATH=$(BIN)
	$(ICONT) -c tokens

preproce.u : preproce.icn
	set PATH=$(BIN)
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
	set PATH=$(BIN)
	$(ICONT) -c yyerror

# Uncomment if you modify idol.icn
#idol.u: idol.icn
#	$(UNICON) -c idol

unix.u: unix.icn
	set PATH=$(BIN)
	$(ICONT) -c unix

#
# Don't really clean, we need the .u files for bootstrapping.
#

Clean:
	$(RM) unicon.exe
	$(RM) uniclass.dir
	$(RM) uniclass.pag
