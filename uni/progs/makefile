BASE=../..
include ../Makedefs

all: ie uprof idxGen umake
	$(CP) ie uprof umake ../../bin

ie: ie.icn
	$(UNICON) ie

uprof: uprof.icn
	$(UNICON) uprof

umake: umake.icn
	$(UNICON) -DMAIN umake

umake.u: umake.icn
	$(UNICON) -c umake

idxGen: idxGen.icn
	IPATH=../xml/ LPATH=../xml/ $(UNICON) -u idxGen
