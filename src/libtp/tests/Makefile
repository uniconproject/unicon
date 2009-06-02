# Makefile for libtp/tests. No longer generated from a local autoconf run.

include ../../../Makedefs

SHELL = /bin/sh

subdirs = tests uri

RM = rm -f
AR = ar
RANLIB = ranlib
SHTOOL = shtool/shtool

INCLUDES = -I../uri -I..
DEFINES = -DHAVE_CONFIG_H

LDLIBS = ../libtp.a $(LIBS)

PROGS = daytime fing hhead pop testuri wtrace
OBJS = daytime.o fing.o hhead.o pop.o testuri.o wtrace.o
SRCS = daytime.c fing.c hhead.c pop.c testuri.c wtrace.c

all: Makefile $(PROGS)

.c.o:
	$(CC) $(CFLAGS) -I.. -I../uri -c $*.c

clean:
	$(RM) $(OBJS)

distclean: clean
	$(RM) $(PROGS) Makefile

daytime: daytime.o ../libtp.a
	$(CC) -o daytime daytime.o $(LDFLAGS) $(LDLIBS)

fing: fing.o ../libtp.a
	$(CC) -o fing fing.o $(LDFLAGS) $(LDLIBS)

hhead: hhead.o ../libtp.a
	$(CC) -o hhead hhead.o $(LDFLAGS) $(LDLIBS)

pop: pop.o ../libtp.a
	$(CC) -o pop pop.o $(LDFLAGS) $(LDLIBS)

testuri: testuri.o ../libtp.a
	$(CC) -o testuri testuri.o $(LDFLAGS) $(LDLIBS)

wtrace: wtrace.o ../libtp.a
	$(CC) -o wtrace wtrace.o $(LDFLAGS) $(LDLIBS)
