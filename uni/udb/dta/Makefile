#
# UDB's Temporal Assertion Support
# Ziad Al-Sharif
# zsharif@gmail.com
# June 2009
#
BASE=../../..
include $(BASE)/Makedefs.uni

CFLAGS     = $(UFLAGS) -c

UFILES  = atomic_agent.u temporals.u
SRC     = atomic_agent.icn temporals.icn

all: $(UFILES)

atomic_agent.u: atomic_agent.icn
	$(UC) $(CFLAGS) atomic_agent

temporals.u: temporals.icn
	$(UC) $(CFLAGS) temporals

clean:
	-rm *.u *.pag *.dir *.db *~
