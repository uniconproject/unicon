# GDBM Makefile for Unicon.
#
# The .c and .h files here (other than autoconf.h and w32compat.*) are
# unmodified copies of upstream GNU dbm sources: the core library from
# gdbm-X.Y/src and the NDBM compatibility layer from gdbm-X.Y/compat,
# which is the interface the Unicon runtime uses (see src/h/sys.h).
# GDBM's own configure/automake machinery is not used; autoconf.h maps
# Unicon's configure results onto what the GDBM sources expect.
#
# To update GDBM: copy the files listed below from the new release,
# bump the version here and PACKAGE_VERSION in autoconf.h, and review
# the release's autoconf.h.in and src/Makefile.am for new requirements.

TOPDIR=../..

default: all

UNICON_TOP_BUILDDIR ?= $(TOPDIR)
include $(UNICON_TOP_BUILDDIR)/Makedefs

srcdir=.

# Keep in sync with PACKAGE_VERSION in autoconf.h.
GDBM_VERSION_MAJOR = 1
GDBM_VERSION_MINOR = 26
GDBM_VERSION_PATCH = 0

DEFS =

# This is third-party code we do not patch: report its warnings but do
# not let --enable-werror turn them into build failures.
GDBM_CFLAGS = $(filter-out -Werror,$(CFLAGS))

%.o: %.c
	$(CMNT)@echo "   [GDBM] $<"
	$(SLNT)$(CC) -c $(CPPFLAGS) $(DEFS) -I. -I$(srcdir) $(GDBM_CFLAGS) $<

# Core library: libgdbm_la_SOURCES in upstream src/Makefile.am
# (debug.c is only built with --enable-debug upstream).
GDBM_OF = gdbmclose.o gdbmcount.o gdbmdelete.o gdbmdump.o gdbmerrno.o \
	gdbmexists.o gdbmexp.o gdbmfdesc.o gdbmfetch.o gdbmload.o gdbmopen.o \
	gdbmimp.o gdbmreorg.o gdbmseq.o gdbmsetopt.o gdbmstore.o gdbmsync.o \
	avail.o base64.o bucket.o falloc.o findkey.o fullio.o hash.o lock.o \
	mmap.o recover.o update.o version.o

# NDBM compatibility layer: NDBM_CF in upstream compat/Makefile.am.
NDBM_OF = dbmopen.o dbmdelete.o dbmerr.o dbmfetch.o dbmstore.o dbmseq.o \
	dbmclose.o dbmdirfno.o dbmpagfno.o dbmrdonly.o

# Native Windows lacks the POSIX facilities used by lock.c (replaced by
# w32compat.c) and by the dump/load/import/export utilities (not used by
# Unicon, so simply left out).
ifeq ($(NT),NT)
GDBM_OF := $(filter-out lock.o gdbmdump.o gdbmload.o gdbmexp.o gdbmimp.o,$(GDBM_OF))
W32_OF = w32compat.o
W32_HDRS = w32compat.h
endif

OBJS = $(GDBM_OF) $(NDBM_OF) $(W32_OF)

HDRS = autoconf.h gdbm.h gdbmconst.h gdbmdefs.h gettext.h proto.h \
	systems.h ndbm.h $(W32_HDRS)

all: libgdbm.a

libgdbm.a: CP_HEADERS $(OBJS)
	$(RM) $@
	$(AR) q $@ $(OBJS)
	$(RANLIB) $@
	$(CP) $@ ../../rt/lib/

CP_HEADERS: gdbm.h ndbm.h
	$(CP) gdbm.h ../../rt/include/
	$(CP) ndbm.h ../../rt/include/

# Substitute what upstream configure would put into gdbm.h.
gdbm.h: gdbm.h.in Makefile
	$(RM) $@
	sed -e 's/@GDBM_VERSION_MAJOR@/$(GDBM_VERSION_MAJOR)/' \
	    -e 's/@GDBM_VERSION_MINOR@/$(GDBM_VERSION_MINOR)/' \
	    -e 's/@GDBM_VERSION_PATCH@/$(GDBM_VERSION_PATCH)/' \
	    -e 's/@GDBM_COUNT_T@/unsigned long long int/' \
	    -e 's/@GDBM_DEBUG_ENABLE@/0/' \
	    $(srcdir)/gdbm.h.in > $@

$(OBJS): $(HDRS) $(AUTO_H)

clean:
	$(RM) libgdbm.a *.o core

mostlyclean: clean

distclean: clean
	$(RM) gdbm.h *~

realclean: distclean

.PHONY: all default clean mostlyclean distclean realclean CP_HEADERS
