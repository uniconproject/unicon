# Generated automatically from Makefile.in by configure.
# Makefile for libtp library

SHELL = /bin/sh

top_srcdir = .
srcdir = .
prefix = /usr/local
exec_prefix = ${prefix}
libdir = ${exec_prefix}/lib
includedir = ${prefix}/include

AUTOCONF = autoconf
AUTOHEADER = autoheader

CC = gcc

RM = rm -f
AR = ar
RANLIB = ranlib
SHTOOL = shtool/shtool

CPPFLAGS = 
LDFLAGS = 
LIBS = -lnsl 

INCLUDES = -Iuri
DEFINES = -DHAVE_CONFIG_H -D_LIBTP_
#WARNINGS = -Wall -Werror -ansi
DEBUG = 
WARNINGS = 
CFLAGS = $(WARNINGS) $(DEBUG) $(DEFINES) $(INCLUDES) $(CPPFLAGS) 

SUBDIRS = uri . tests

OBJS = tp.o util.o tpdunix.o tpmdaytm.o tpmfinge.o tpmhttp.o  \
       tpmpop.o tpmsmtp.o
SRCS = tp.c util.c tpdunix.c tpmdaytm.c tpmfinge.c tpmhttp.c  \
       tpmpop.c tpmsmtp.c
LIBURI = uri/liburi.a

all: Makefile
	@for dir in $(SUBDIRS); do \
	  if test "$$dir" = "."; then \
	    echo "Making the libtp library"; \
	    $(MAKE) libtp.a; \
	  else \
	    echo "Making $@ in $$dir"; \
	    (cd $$dir && $(MAKE)); \
	  fi; \
	done

libtp.a: $(OBJS) $(LIBURI)
	$(RM) $@
	$(SHTOOL) arx -C $(AR) rc $@ $(OBJS) $(LIBURI)
	$(RANLIB) $@

uri:
	cd uri && $(MAKE)

clean:
	$(RM) $(OBJS)

distclean: clean
	@for d in $(SUBDIRS); do \
	  if test "$$d" != "."; then \
	    (cd $$d && $(MAKE) $@); \
	  fi; \
	done
	$(RM) Makefile config.h config.status config.cache config.log libtp.a

dist: Makefile distclean
	$(SHTOOL) fixperm -v *; \
	V=`date "+%y%m%d"`; \
	echo "Building libtp-$V.tar.gz"; \
	$(SHTOOL) tarball -o libtp-$V.tar.gz -c 'gzip -9' \
                          -e 'CVS,\.cvsignore,\.[oa]$$,\.core$$,~$$,^\.#' .

Makefile: Makefile.in config.status
	cd $(top_srcdir) && $(SHELL) ./config.status

config.status: $(srcdir)/configure 
	$(SHELL) ./config.status --recheck

$(srcdir)/configure: $(srcdir)/configure.in
	cd $(srcdir) && $(AUTOHEADER) && $(AUTOCONF)

tp.o: tp.c config.h tp.h util.h uri/uri.h
tpdunix.o: tpdunix.c config.h util.h tp.h uri/uri.h tpdunix.h
tpmdaytm.o: tpmdaytm.c config.h tp.h util.h uri/uri.h
tpmfinge.o: tpmfinge.c config.h tp.h util.h uri/uri.h
tpmhttp.o: tpmhttp.c config.h tp.h uri/uri.h util.h
tpmsmtp.o: tpmsmtp.c config.h tp.h uri/uri.h util.h
util.o: util.c config.h
