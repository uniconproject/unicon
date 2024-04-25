BASE=..\..
include ..\makedefs

IYACC=$(UNI)\iyacc\iyacc

UFILES=classinfo.u databaseinfo.u packageinfo.u parsedclass.u \
	parsedfunction.u parsedinitiallymethod.u parsedmethod.u \
	parsedobject.u parsedprocedure.u parsedprogram.u \
	parsedrecord.u parser.u preproce.u unigram.u \
	unilex.u

PROGS=showtree.exe showdb.exe

all: $(UFILES) $(PROGS)

clean:
	$(RM) showtree.exe
	$(RM) showdb.exe
	$(RM) *.u 
	$(RM) uniclass.dir 
	$(RM) uniclass.pag

unigram.icn : unigram.y ytab_h.icn
	$(IYACC) -i unigram.y

include deps.out
