# Makefile: written by Ziad Al-Sharif for building the libaudio.a
# May 14, 2005

TOPDIR = ../../..
UNICON_TOP_BUILDDIR ?= $(TOPDIR)
AUTO_H = $(UNICON_TOP_BUILDDIR)/src/h/auto.h

CC=gcc
INC=

LIBRARYNAME	= libaudio
ARCHIVE 	= $(LIBRARYNAME).a
ARFLAGS 	= qc
OBJECTS		= al.o audio.o


all: staticlib

staticlib: $(ARCHIVE)

$(ARCHIVE): $(OBJECTS)
	rm -f $(ARCHIVE)
	ar $(ARFLAGS) $(ARCHIVE) $(OBJECTS)
	$(CP) $(ARCHIVE) ../../../bin
	rm *.o

al.o : al.c base.h config.h
	$(CC) $(INC) -c al.c

audio.o: audio.c
	$(CC) $(INC) -I$(dir $(AUTO_H)) -c audio.c


clean:
	-rm *.o
	-rm *.a
