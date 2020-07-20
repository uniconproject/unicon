BASE=../..
include $(BASE)/Makedefs.uni

BINPROGS=ie uprof  umake 
PROGS= idxGen uget splitmail csv genAcc heap_demo mapStrings rpn $(BINPROGS)

all: $(PROGS)
	$(CP) $(BINPROGS) ../../bin

csv: csv.icn
	$(UNICON) $(UFLAGS) csv

ie: ie.icn
	$(UNICON) $(UFLAGS) ie

uprof: uprof.icn
	$(UNICON) $(UFLAGS) uprof

uget: uget.icn
	$(UNICON) $(UFLAGS) uget

umake: umake.icn
	$(UNICON) $(UFLAGS) -DMAIN umake

umake.u: umake.icn
	$(UNICON) $(UFLAGS) -c umake

idxGen: idxGen.icn
	$(UNICON) $(UFLAGS) -u idxGen

splitmail: splitmail.icn
	$(UNICON) $(UFLAGS) splitmail

clean Clean:
	@$(RM) $(PROGS) *.exe uniclass.pag uniclass.dir uniclass.db

