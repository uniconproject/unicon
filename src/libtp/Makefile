# Makefile for libtp library
# No longer generated automatically from Makefile.in by configure.
# Instead, it relies on main unicon autconf results in ../../Makedefs

TOPDIR=../..

default: all

include $(TOPDIR)/Makedefs

SHTOOL = shtool/shtool
RANLIB=ranlib

INCLUDES = -Iuri
DEFINES = -DHAVE_CONFIG_H -D_LIBTP_
#WARNINGS = -Wall -Werror -ansi
DEBUG = 
WARNINGS = 

#SUBDIRS = uri . tests
SUBDIRS = uri .

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

libtp.a:  CP_HEADERS $(OBJS) $(LIBURI)
	$(RM) $@
	$(SHTOOL) arx -C $(AR) rc $@ $(OBJS) $(LIBURI)
	$(RANLIB) $@
	$(CP) $@ ../../rt/lib/

CP_HEADERS: tp.h uri/uri.h
	$(CP) tp.h ../../rt/include/
	$(CP) uri/uri.h ../../rt/include/uri/

$(LIBURI) uri:
	cd uri && $(MAKE)

clean:
	$(RM) libtp.a $(OBJS)

distclean:
	@for d in $(SUBDIRS); do \
	  if test "$$d" != "."; then \
	    (cd $$d && $(MAKE) $@); \
	  fi; \
	done
	$(RM) libtp.a $(OBJS)

dist: Makefile distclean
	$(SHTOOL) fixperm -v *; \
	V=`date "+%y%m%d"`; \
	echo "Building libtp-$V.tar.gz"; \
	$(SHTOOL) tarball -o libtp-$V.tar.gz -c 'gzip -9' \
                          -e 'CVS,\.cvsignore,\.[oa]$$,\.core$$,~$$,^\.#' .

%.o: %.c
	$(CMNT)@echo "   [TP] $<"
	$(SLNT)$(CC) $(CFLAGS) $(CPPFLAGS) -c $<

tp.o: tp.c ../h/auto.h ../h/auto.h tp.h util.h uri/uri.h
tpdunix.o: tpdunix.c ../h/auto.h ../h/config.h util.h tp.h uri/uri.h tpdunix.h
tpdssl.o: tpdssl.c ../h/auto.h ../h/config.h util.h tp.h uri/uri.h tpdssl.h
tpmdaytm.o: tpmdaytm.c ../h/auto.h ../h/config.h tp.h util.h uri/uri.h
tpmfinge.o: tpmfinge.c ../h/auto.h ../h/config.h tp.h util.h uri/uri.h
tpmhttp.o: tpmhttp.c ../h/auto.h ../h/config.h tp.h uri/uri.h util.h
tpmsmtp.o: tpmsmtp.c ../h/auto.h ../h/config.h tp.h uri/uri.h util.h
util.o: util.c ../h/auto.h ../h/config.h
