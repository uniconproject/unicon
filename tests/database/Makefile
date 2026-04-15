#
# Database integration tests (MySQL / NLM / ODBC DSNs).
# Not part of top-level tests/ Makefile TESTS (all skipped); run manually:
#   make -C tests/database Test
#

include ../Makedefs

TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
SKIP := $(TARGETS)

Test: DoTest

include ../Makefile.test
