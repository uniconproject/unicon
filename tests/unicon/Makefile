
include ../Makedefs

# Concurrent threads: FxPtTest / list_test use testing::tester (mutex).
CON=$(shell $(UC) -features 2>/dev/null | grep -o "concurrent threads")

# Not part of `make Test` here. Manual: `make tester.u`, then
#   $(UC) -s ovld.icn && ./ovld
#   $(UC) -s FxPtTest_OVLD.icn && ./FxPtTest_OVLD
MANUAL_ONLY := ovld FxPtTest_OVLD
TARGETS=$(filter-out $(MANUAL_ONLY),$(patsubst %.icn,%,$(wildcard *.icn)))

UCFEAT := $(shell $(UC) -features 2>/dev/null)

ifneq ($(CON),concurrent threads)
SKIP += FxPtTest list_test
endif

Test: DoTest

include ../Makefile.test

# Precompiled package for import testing (list_test, FxPtTest).
tester.u: data/tester.icn
	@$(UC) -s -u -c $^

list_test FxPtTest: | tester.u
