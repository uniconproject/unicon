#
# The src level makefile for utop program
# By:    Ziad AL-Sharif
# Date:  June 20, 2008
#

UC         = unicon
CFLAGS     = -u -c 
LDFLAGS    = -u -G
STANDALONE = -DStandAlone

SRC    = listener.icn memory.icn structaliases.icn structusage.icn \
         looptime.icn proctime.icn procprofile.icn varprofile.icn \
         deadvar.icn failedloop.icn failedsubscript.icn typechange.icn
UFILES = listener.u memory.u structaliases.u structusage.u \
         looptime.u proctime.u procprofile.u varprofile.u \
         deadvar.u failedloop.u failedsubscript.u typechange.u
Tools  = memory structaliases structusage \
         looptime proctime procprofile varprofile \
         deadvar failedloop failedsubscript typechange

lib: $(UFILES)


tools: listener.u $(Tools)
	mv $(Tools) ../../bin

$(Tools): $%
	$(UC) $(STANDALONE) $(LDFLAGS) $@

listener.u: listener.icn
	$(UC) $(CFLAGS) listener.icn

memory.u: memory.icn listener.u
	$(UC) $(CFLAGS) memory.icn

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


clean:
	-rm *.u *.pag *.dir *.db *~ *.ps

cleantools:
	@for i in $(Tools) ; do\
		(rm ../../bin/$$i; );\
	done

