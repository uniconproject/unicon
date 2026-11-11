#
# threads test
#


include ../Makedefs

CON=$(shell $(UC) -features | grep -o "concurrent threads")

# make sure we have concurrent threads, otherwise skip...
ifeq ($(CON),concurrent threads)
TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
else
skip:
	@echo "\nConcurrent Threads are not available in this build"
	@echo "SKIP: concurrency test\n"

TARGETS=skip
endif


# Pin block region size so &collections in gc.icn is stable across hosts (see tests/general gc2).
GC_BLKSIZE ?= 1000000
gc: TEST_ENV := BLKSIZE=$(GC_BLKSIZE)

# Each thread owns inbox, outbox and cequeue blocks, about 35KB together.
# Thread-stress jobs set BLKSIZE=300000, which cannot hold the chain.
# The prefix overrides that for this test only.
tdeepgc: TEST_ENV := BLKSIZE=67108864 STRSIZE=1048576

# Do the tests
Test: DoTest

include ../Makefile.test
