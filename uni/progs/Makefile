BASE=../..
include ../Makedefs

BINPROGS=ie uprof  umake
PROGS= idxGen $(BINPROGS)

all: $(PROGS)
	$(CP) $(BINPROGS) ../../bin

ie: ie.icn
	$(UNICON) $(UFLAGS) ie

uprof: uprof.icn
	$(UNICON) $(UFLAGS) uprof

umake: umake.icn
	$(UNICON) $(UFLAGS) -DMAIN umake

umake.u: umake.icn
	$(UNICON) $(UFLAGS) -c umake

idxGen: idxGen.icn
	IPATH=../xml/ LPATH=../xml/ $(UNICON) $(UFLAGS) -u idxGen

Clean: 
	$(RM) $(PROGS) uniclass.pag uniclass.dir

clean: 
	@$(RM) $(PROGS) uniclass.pag uniclass.dir

