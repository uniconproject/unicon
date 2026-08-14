#
# Cryptographic facilities (UTR 27) — hash, HMAC, sign/verify, encrypt,
# plus TLS/DTLS socket coverage (ssl.icn).
#

include ../Makedefs

TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
SKIP=
IGNORE=

# Skip the suite when the runtime was built without OpenSSL.
UCFEAT := $(shell $(UC) -features 2>/dev/null)
ifneq ($(UCFEAT),)
ifeq ($(findstring secure sockets layer encryption,$(UCFEAT)),)
SKIP += $(TARGETS)
else
# ssl.icn needs concurrent threads for its client/server harness.
ifeq ($(findstring concurrent threads,$(UCFEAT)),)
SKIP += ssl
endif
endif
endif

Test: DoTest

include ../Makefile.test
