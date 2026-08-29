#
# Unicode / uniqual string tests (UniconUnicode)
#

include ../Makedefs

UNICODTST = size subsc subsc_loop concat convert scan section bang many match find \
	reverse file_i socket_i ascii_basic ascii_ops languages

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
WINSKIP=
ifeq ($(TOS),Windows)
# socket_i uses fork() like tests/posix/tcp.
WINSKIP=socket_i
endif

Test: DoTest

include ../Makefile.test
