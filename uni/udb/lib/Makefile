#
# The src level makefile for utop program
# By:     Ziad AL-Sharif
# Date:   June 20, 2008
# e-mail: zsharif@gmail.com
#
BASE=../../..
include $(BASE)/Makedefs.uni

CFLAGS     = $(UFLAGS) -c
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
	$(CP) $(Tools) ../../../bin

$(Tools): $%
	$(UC) $(UFLAGS) $(STANDALONE) $(LDFLAGS) $@

listener.u: listener.icn
	$(UC) $(CFLAGS) listener.icn

memory.u: memory.icn listener.u
	$(UC) $(CFLAGS) memory.icn

memory_alloc.u: memory_alloc.icn
	$(UC) $(CFLAGS) memory_alloc.icn

structaliases.u: structaliases.icn listener.u
	$(UC) $(CFLAGS) structaliases.icn

structusage.u: structusage.icn listener.u
	$(UC) $(CFLAGS) structusage.icn

looptime.u: looptime.icn listener.u
	$(UC) $(CFLAGS) looptime.icn

proctime.u: proctime.icn listener.u
	$(UC) $(CFLAGS) proctime.icn

procprofile.u: procprofile.icn listener.u
	$(UC) $(CFLAGS) procprofile.icn

varprofile.u: varprofile.icn listener.u
	$(UC) $(CFLAGS) varprofile.icn

deadvar.u: deadvar.icn listener.u
	$(UC) $(CFLAGS) deadvar.icn

typechange.u: typechange.icn listener.u
	$(UC) $(CFLAGS) typechange.icn

failedloop.u: failedloop.icn listener.u
	$(UC) $(CFLAGS) failedloop.icn

failedsubscript.u: failedsubscript.icn listener.u
	$(UC) $(CFLAGS) failedsubscript.icn

counter_deref.u: counter_deref.icn listener.u
	$(UC) $(CFLAGS) counter_deref.icn

counter_pcall.u: counter_pcall.icn listener.u
	$(UC) $(CFLAGS) counter_pcall.icn

counter_line.u: counter_line.icn listener.u
	$(UC) $(CFLAGS) counter_line.icn

counter_syntax.u: counter_syntax.icn listener.u
	$(UC) $(CFLAGS) counter_syntax.icn

clean:
	-$(RM) *.u *.pag *.dir *.db *~ *.ps *.exe $(Tools)

cleantools:
	@for i in $(Tools) ; do\
		($(RM) ../../../bin/$$i; );\
		($(RM) $$i; );\
	done

