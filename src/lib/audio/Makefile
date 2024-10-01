# Makefile: written by Ziad Al-Sharif for building the libaudio.a
# May 14, 2005


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
	$(CC) $(INC) -c audio.c


clean:
	-rm *.o
	-rm *.a
