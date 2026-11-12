#
# ulsp test
#
# Each test queues LSP messages with lspclient.icn, runs ulsp --stdio on
# them (../../bin/ulsp, or $ULSP if set), and prints the replies. The
# documents the tests open are in src/.
#

include ../Makedefs

TARGETS=$(filter-out lspclient,$(patsubst %.icn,%,$(wildcard *.icn)))
SKIP=
IGNORE=
# The tests use /-separated file URIs and a POSIX shell
WINSKIP=$(TARGETS)

# Do the tests
Test: DoTest

$(TARGETS): lspclient.u

include ../Makefile.test

# lspclient is linked by every test, not a test itself
lspclient.u: lspclient.icn
	@$(UC) -c -s lspclient.icn
