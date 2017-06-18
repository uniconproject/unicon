BASE=../..
include ../Makedefs

all: ie uprof idxGen umake
	$(CP) ie uprof umake ../../bin

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
