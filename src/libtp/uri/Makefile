# Generated automatically from Makefile.in by configure.

TOPDIR=../../..

default: all

include $(TOPDIR)/Makedefs

RM = rm -f
AR = ar
RANLIB = ranlib
SHTOOL = ../shtool/shtool

DEFINES = -DHAVE_CONFIG_H -D_LIBTP_

SRCS = uri.c uri_file.c uri_fing.c uri_ftp.c uri_http.c uri_pop.c \
       uri_mail.c uri_schm.c

OBJS = uri.o uri_file.o uri_fing.o uri_ftp.o uri_http.o uri_pop.o \
       uri_mail.o uri_schm.o

#----------------------------------------------------------------------#

all: liburi.a

liburi.a: $(OBJS)
	$(RM) $@
	$(SHTOOL) arx -C $(AR) rc $@ $(OBJS)
	$(RANLIB) $@

clean:
	$(RM) $(OBJS)

distclean: clean
	$(RM) liburi.a Makefile

%.o: %.c
	$(CMNT)@echo "   [TP URI] $<"
	$(SLNT)$(CC) $(CFLAGS) $(CPPFLAGS) -c $<

uri.o: uri.c uri.h uri_schm.h
uri_file.o: uri_file.c uri.h uri_schm.h
uri_fing.o: uri_fing.c uri.h uri_schm.h
uri_ftp.o: uri_ftp.c uri.h uri_schm.h
uri_http.o: uri_http.c uri.h uri_schm.h
uri_pop.o: uri_pop.c uri.h uri_schm.h
uri_mail.o: uri_mail.c uri.h uri_schm.h
uri_schm.o: uri_schm.c uri_schm.h uri.h
