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

U= unicon.u unigram.u unilex.u tree.u preproce.u idol.u unix.u tokens.u yyerror.u main.u cfy.u ca.u
LIBFILES= ../lib/unilex.u ../lib/tree.u

all:	unicon.exe wunicon.exe

unicon.exe: $(U) $(LIBFILES)
	set PATH=$(BIN)
	$(ICONT) $(U)
	$(CP) unicon.exe $(BIN)

# A windows-specific build option
wunicon.exe: $(U)
	set PATH=$(BIN)
	$(ICONT) -G -o wunicon.exe $(U)
	$(CP) wunicon.exe $(BIN)

unicon.u : unicon.icn
	set PATH=$(BIN)
	$(ICONT) -c unicon

../lib/unilex.u: unilex.u
        $(CP) unilex.u ../lib

unilex.u : unilex.icn ytab_h.icn
	set PATH=$(BIN)
	$(ICONT) -c unilex

main.u: main.icn
	set PATH=$(BIN)
        $(ICONT) -c main

../lib/tree.u: tree.u
        $(CP) tree.u ../lib

tree.u : tree.icn
	set PATH=$(BIN)
	$(ICONT) -c tree

tokens.u : tokens.icn ytab_h.icn
	set PATH=$(BIN)
	$(ICONT) -c tokens

preproce.u : preproce.icn
	set PATH=$(BIN)
	$(ICONT) -c preproce

cfy.u : cfy.icn
        $(ICONT) -c cfy

ca.u : ca.icn
        $(ICONT) -c ca

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
