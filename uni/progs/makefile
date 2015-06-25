BASE=../..
include ../makedefs

all: ie uprof
	$(CP) ie uprof ../../bin

ie: ie.icn
	$(UNICON) ie

uprof: uprof.icn
	$(UNICON) uprof

grok: grok.u

umake: umake.icn
	$(UNICON) -DMAIN umake

umake.u: umake.icn
	$(UNICON) -c umake
