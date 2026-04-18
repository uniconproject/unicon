
include ../Makedefs

# pty_uni needs PTY I/O and multitasking (see pty_uni.icn / runtime).  Omit when either
# feature is unavailable (e.g. --enable-thin disables multiple programs).  See feature.h:
# _PTY "pseudo terminals", _MULTITASKING "multiple programs".
SKIP=
UCFEAT := $(shell $(UC) -features 2>/dev/null)
ifneq ($(UCFEAT),)
ifeq ($(findstring pseudo terminals,$(UCFEAT)),)
SKIP += pty_uni
else
ifeq ($(findstring multiple programs,$(UCFEAT)),)
SKIP += pty_uni
endif
endif
endif

TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
IGNORE=

# rusage/kill removed — golden output is portable; pty_uni/tcp/wait still Windows-inapplicable
WINSKIP=pty_uni tcp wait

BSDSKIP=pty_uni uxsocket

# default is to run all tests, using icont
Test:  DoTest


include ../Makefile.test


Icont Test-icont:
		IC=icont sh Test-icont icont

Iconc Test-iconc:
		IC=iconc sh Test-icont icont



