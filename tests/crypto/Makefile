#
# Cryptographic facilities (UTR 27) — hash, HMAC, sign/verify, encrypt,
# plus focused TLS socket coverage.
#

include ../Makedefs

TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
SKIP=
IGNORE=
TLS_TESTS = tlsplain tlsverify tlsauth tlsproto tlscipher tlspeek dtlsecho

# Skip the suite when the runtime was built without OpenSSL.
UCFEAT := $(shell $(UC) -features 2>/dev/null)
ifneq ($(UCFEAT),)
ifeq ($(findstring secure sockets layer encryption,$(UCFEAT)),)
SKIP += $(TARGETS)
else
# Link-only helper, not a standalone test.
SKIP += tlsutil
# TLS echo tests need concurrent threads for the server harness.
ifeq ($(findstring concurrent threads,$(UCFEAT)),)
SKIP += $(TLS_TESTS)
endif
endif
endif

# Test must be the first goal so `make -C crypto` runs the suite.
Test: DoTest

include ../Makefile.test

# Ensure tlsutil.u exists before any test that links it.
$(TLS_TESTS): tlsutil.u

tlsutil.u: tlsutil.icn
	@$(UC) -c -s tlsutil.icn
