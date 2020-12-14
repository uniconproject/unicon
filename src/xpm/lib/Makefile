#
# Simple makefile for the C library part of XPM needed by Icon
#
# This file is a simplification of XPM's standard Makefile
#

TOPDIR=../../..

default: libXpm.a

include $(TOPDIR)/Makedefs

## if your system doesn't provide strcasecmp add -DNEED_STRCASECMP
## if your system doesn't provide pipe remove -DZPIPE
AR=ar qc
OBJS1 = data.o create.o misc.o rgb.o scan.o parse.o hashtab.o \
	  WrFFrP.o RdFToP.o CrPFrDat.o CrDatFrP.o \
	  WrFFrI.o RdFToI.o CrIFrDat.o CrDatFrI.o \
	  CrIFrBuf.o CrPFrBuf.o CrBufFrI.o CrBufFrP.o \
	  RdFToDat.o WrFFrDat.o \
	  Attrib.o CrIFrP.o CrPFrI.o Image.o Info.o RdFToBuf.o WrFFrBuf.o

%.o: %.c
	$(CMNT)@echo "   [XPM] $<"
	$(SLNT)$(CC) -c $(CPPFLAGS) $(CFLAGS) $(XPMDEFS) $<

libXpm.a: $(OBJS1)
	$(RM) $@
	$(AR) $@ $(OBJS1)
	$(CP) $@ ../../../rt/lib
	$(CP) xpm.h ../../../rt/include

$(OBJS1): xpm.h

Clean:
	$(RM) *.o *.a
