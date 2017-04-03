BASE=../..
include ../makedefs

# add idxGen to dependencies, when ready
all: ie uprof
	$(CP) ie uprof ../../bin

ie: ie.icn
	$(UNICON) ie

uprof: uprof.icn
	$(UNICON) uprof

umake: umake.icn
	$(UNICON) -DMAIN umake

umake.u: umake.icn
	$(UNICON) -c umake

idxGen: idxGen.icn
	$(UNICON) -u idxGen
