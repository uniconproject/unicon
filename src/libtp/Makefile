# Makefile for libtp library
# No longer generated automatically from Makefile.in by configure.
# Instead, it relies on main unicon autconf results in ../../Makedefs

include ../../Makedefs

SHELL = /bin/sh

RM = rm -f
AR = ar
SHTOOL = shtool/shtool
RANLIB=ranlib

CPPFLAGS = 
LIBS = -lnsl 

INCLUDES = -Iuri
DEFINES = -DHAVE_CONFIG_H -D_LIBTP_
#WARNINGS = -Wall -Werror -ansi
DEBUG = 
WARNINGS = 

SUBDIRS = uri . tests

OBJS = tp.o util.o tpdunix.o tpdssl.o tpmdaytm.o tpmfinge.o tpmhttp.o  \
       tpmpop.o tpmsmtp.o
SRCS = tp.c util.c tpdunix.c tpdssl.c tpmdaytm.c tpmfinge.c tpmhttp.c  \
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
	cp $@ ../../bin

$(LIBURI) uri:
	cd uri && $(MAKE)

clean:
	$(RM) libtp.a $(OBJS)

distclean: clean
	@for d in $(SUBDIRS); do \
	  if test "$$d" != "."; then \
	    (cd $$d && $(MAKE) $@); \
	  fi; \
	done
	$(RM) Makefile libtp.a

dist: Makefile distclean
	$(SHTOOL) fixperm -v *; \
	V=`date "+%y%m%d"`; \
	echo "Building libtp-$V.tar.gz"; \
	$(SHTOOL) tarball -o libtp-$V.tar.gz -c 'gzip -9' \
                          -e 'CVS,\.cvsignore,\.[oa]$$,\.core$$,~$$,^\.#' .

tp.o: tp.c config.h tp.h util.h uri/uri.h
tpdunix.o: tpdunix.c config.h util.h tp.h uri/uri.h tpdunix.h
tpdssl.o: tpdssl.c config.h util.h tp.h uri/uri.h tpdssl.h
tpmdaytm.o: tpmdaytm.c config.h tp.h util.h uri/uri.h
tpmfinge.o: tpmfinge.c config.h tp.h util.h uri/uri.h
tpmhttp.o: tpmhttp.c config.h tp.h uri/uri.h util.h
tpmsmtp.o: tpmsmtp.c config.h tp.h uri/uri.h util.h
util.o: util.c config.h
