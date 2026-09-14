#
# ASCII string microbenchmarks: Unicode compiled off vs on.
# See README.
#

UC?=unicon
UFLAGS=-s

PROGS=size index concat concat-grow slice bang scan tab find match reverse

.PHONY: all run clean

all: $(PROGS)

$(PROGS): %: %.icn common.icn
	$(UC) $(UFLAGS) $<

run: all
	@for p in $(PROGS); do ./$$p; done

clean:
	rm -f $(PROGS) *.u
