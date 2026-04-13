#  Makefile for testing Icon

include ../Makedefs

SAMPLES = btrees diffwrds kross meander prefix recogn roman sieve wordcnt
TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))

# Do not include these tests in standard testing
SKIP=mem01 mem02

# cfuncs links loadable C code; omit when the runtime has no dynamic loading (e.g. --enable-thin).
UCFEAT := $(shell $(UC) -features 2>/dev/null)
ifneq ($(UCFEAT),)
ifeq ($(findstring dynamic loading,$(UCFEAT)),)
SKIP += cfuncs
endif
endif

WINSKIP=cfuncs

# Do the tests
Test: DoTest

include ../Makefile.test

# Default BLKSIZE follows host RAM (src/runtime/init.r); pin it so &collections match stand/gc2.std.
GC2_BLKSIZE ?= 1000000
gc2: TEST_ENV := BLKSIZE=$(GC2_BLKSIZE)


Icont Test-icont:
		IC=icont sh Test-icon

Samples Sicont Samples-icont:
		IC=icont sh Test-icon $(SAMPLES)

Iconc :
		IC=iconc sh Test-icon

Test-iconc : 
	./Test-iconc iconc
	./Test-iconc large -fld
	./Test-iconc coexpr -fds 
	./Test-iconc  invoke -fs
	./Test-iconc  errcnv -fa
	./Test-iconc  debug -fd


Siconc Samples-iconc:
		IC=iconc sh Test-icon $(SAMPLES)

