
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

# Windows (WINSKIP): review case-by-case — many are skipped only because the NT runtime
# stubs POSIX pieces (see src/runtime/fxposix.ri).  Re-enable when the runtime or test is fixed.
#
#   pty_uni     Needs PTY + multitasking (SKIP above already); not Windows-specific only.
#   tcp, udp    Use fork() for client/server; need fork on NT or rewrite with threads/one process.
#   wait        fork + wait + signals (SIGTERM, SIGSTOP); mostly Unix semantics.
#   fork        Exercises fork(); stubbed on NT (immediate fail).
#   fdup, filepair, kill, pipe-select, select
#               All use fork(); same blocker unless rewritten without fork.
#   uxsocket    Unix-domain sockets + fork; AF_UNIX differs on Windows (and fork).
#   rusage      getrusage() stubbed on NT (fail); needs a Windows implementation or skip.
#   system      icont >file under MSYS: mswinsystem()+redirection can fail (rsys.c); run from
#               cmd or fix runtime, or rewrite test to avoid shell ">" (pipe from Icon).
#
WINSKIP=pty_uni tcp wait fork fdup filepair kill pipe-select select udp uxsocket rusage system

BSDSKIP=pty_uni uxsocket

# default is to run all tests, using icont
Test:  DoTest


include ../Makefile.test


Icont Test-icont:
		IC=icont sh Test-icont icont

Iconc Test-iconc:
		IC=iconc sh Test-icont icont



