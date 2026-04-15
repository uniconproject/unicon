
include ../Makedefs

# Like tests/thread/Makefile: do not run FxPtTest* when mutex is unavailable.
CON=$(shell $(UC) -features 2>/dev/null | grep -o "concurrent threads")

TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))

SKIP=
#tester FxPtTests\
#      audio dbi list_test nlm q rec test testnlm clin_err hello mintest ovld q2 sel to

ifneq ($(CON),concurrent threads)
SKIP += FxPtTest FxPtTest_OVLD
endif

Test: DoTest

include ../Makefile.test

FxPtTest: FxPtTest.icn tester.u

FxPtTest_OVLD: FxPtTest_OVLD.icn tester.u

tester.u: tester.icn
	$(UC) -s -u -c $^


