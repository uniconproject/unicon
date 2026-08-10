#
# Unicode / uniqual string tests (UniconUnicode)
#

include ../Makedefs

UNICODTST = cafe_subsc cafe_subsc_loop cafe_size cafe_concat ascii_smoke ascii_ops languages

UCFEAT := $(shell $(UC) -features 2>/dev/null)

# 32-bit, -DNoUniconUnicode, or a build without the feature: skip the suite.
ifeq ($(findstring Unicode,$(UCFEAT)),)
TARGETS = skip
skip:
	@echo ""
	@echo "Unicode is not available in this build."
	@echo "SKIP: unicode tests"
else
TARGETS = $(UNICODTST)
endif

SKIP=
IGNORE=

Test: DoTest

include ../Makefile.test
