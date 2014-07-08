#
# The src level makefile for utop program
# By:     Ziad AL-Sharif
# Date:   June 20, 2008
# e-mail: zsharif@gmail.com
#
BASE=..\..\..
include ../../makedefs
CFLAGS     = -u -c 
LDFLAGS    = -u
STANDALONE = -DStandAlone

SRC    = listener.icn memory.icn structaliases.icn structusage.icn \
         looptime.icn proctime.icn procprofile.icn varprofile.icn \
         deadvar.icn failedloop.icn failedsubscript.icn typechange.icn\
         counter_deref.icn counter_pcall.icn counter_line.icn counter_syntax.icn \
         memory_alloc.icn
UFILES = listener.u memory.u structaliases.u structusage.u \
         looptime.u proctime.u procprofile.u varprofile.u \
         deadvar.u failedloop.u failedsubscript.u typechange.u \
         counter_deref.u counter_pcall.u counter_line.u counter_syntax.u \
         memory_alloc.u
Tools  = memory structaliases structusage \
         looptime proctime procprofile varprofile \
         deadvar failedloop failedsubscript typechange \
         counter_deref counter_pcall counter_line counter_syntax \
         memory_alloc

lib: $(UFILES)


tools: listener.u $(Tools)
	cp $(Tools) ../../../bin

$(Tools): $@
	$(UNICON) $(STANDALONE) $(LDFLAGS) $@

listener.u: listener.icn
	$(UNICON) $(CFLAGS) listener.icn

memory.u: memory.icn listener.u
	$(UNICON) $(CFLAGS) memory.icn

memory_alloc.u: memory_alloc.icn
	$(UNICON) $(CFLAGS) memory_alloc.icn

structaliases.u: structaliases.icn listener.u
	$(UNICON) $(CFLAGS) structaliases.icn

structusage.u: structusage.icn listener.u
	$(UNICON) $(CFLAGS) structusage.icn

looptime.u: looptime.icn listener.u
	$(UNICON) $(CFLAGS) looptime.icn

proctime.u: proctime.icn listener.u
	$(UNICON) $(CFLAGS) proctime.icn

procprofile.u: procprofile.icn listener.u
	$(UNICON) $(CFLAGS) procprofile.icn

varprofile.u: varprofile.icn listener.u
	$(UNICON) $(CFLAGS) varprofile.icn

deadvar.u: deadvar.icn listener.u
	$(UNICON) $(CFLAGS) deadvar.icn

typechange.u: typechange.icn listener.u
	$(UNICON) $(CFLAGS) typechange.icn

failedloop.u: failedloop.icn listener.u
	$(UNICON) $(CFLAGS) failedloop.icn

failedsubscript.u: failedsubscript.icn listener.u
	$(UNICON) $(CFLAGS) failedsubscript.icn

counter_deref.u: counter_deref.icn listener.u
	$(UNICON) $(CFLAGS) counter_deref.icn

counter_pcall.u: counter_pcall.icn listener.u
	$(UNICON) $(CFLAGS) counter_pcall.icn

counter_line.u: counter_line.icn listener.u
	$(UNICON) $(CFLAGS) counter_line.icn

counter_syntax.u: counter_syntax.icn listener.u
	$(UNICON) $(CFLAGS) counter_syntax.icn

clean:
	-rm *.u *.pag *.dir *.db *~ *.ps

cleantools:
	@for i in $(Tools) ; do\
		(rm ../../../bin/$$i; );\
		(rm $$i; );\
	done

