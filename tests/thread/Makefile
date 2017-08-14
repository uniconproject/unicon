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
	@echo "Skipping concurrency test...\n"

TARGETS=skip
endif


# Do the tests
Test: DoTest

include ../Makefile.test
