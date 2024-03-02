
include ../Makedefs

ifneq ("$(wildcard $(UC))","")
TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))

SKIP= tester FxPtTests\
      audio dbi list_test nlm q rec test testnlm clin_err hello mintest ovld q2 sel to
else
skip:
	@echo "Unicon compiler not found"

TARGETS=skip
endif

Test: DoTest

include ../Makefile.test

FxPtTest: FxPtTest.icn tester.u

FxPtTest_OVLD: FxPtTest_OVLD.icn tester.u

tester.u: tester.icn
	$(UC) -s -u -c $^



