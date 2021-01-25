BASE=../..
include $(BASE)/Makedefs.uni

IYACC=$(UNI)/iyacc/iyacc

.PHONY: all clean deps

UFILES=classinfo.u databaseinfo.u packageinfo.u parsedclass.u \
	parsedfunction.u parsedinitiallymethod.u parsedmethod.u \
	parsedobject.u parsedprocedure.u parsedprogram.u \
	parsedrecord.u parser.u preproce.u unigram.u \
	unilex.u unigram.action.u unigram.prefix.u unigram.suffix.u

PROGS=showtree$(EXE) showdb$(EXE)

all: $(UFILES) $(PROGS)

clean:
	$(RM) $(PROGS) unigram.icn *.u uniclass.dir uniclass.pag uniclass.db

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

unigram.icn : unigram.y ytab_h.icn unigram.action.icn unigram.prefix.icn unigram.suffix.icn
	$(IYACC) -i unigram.y

unigram.action.u: unigram.action.icn

unigram.prefix.u: unigram.prefix.icn

unigram.suffix.u: unigram.suffix.icn


include deps.out
