BASE=../..
include ../makedefs

IYACC=$(UNI)/iyacc/iyacc

.PHONY: all clean deps

UFILES=classinfo.u databaseinfo.u packageinfo.u parsedclass.u \
	parsedfunction.u parsedinitiallymethod.u parsedmethod.u \
	parsedobject.u parsedprocedure.u parsedprogram.u \
	parsedrecord.u parser.u preproce.u unigram.u \
	unilex.u

PROGS=showtree$(EXE) showdb$(EXE)

all: $(UFILES) $(PROGS)

clean:
	$(RM) $(PROGS) unigram.icn *.u uniclass.dir uniclass.pag 

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

unigram.icn : unigram.y ytab_h.icn
	$(IYACC) -i unigram.y

include deps.out
