# Makefile for libtp/tests. No longer generated from a local autoconf run.


TOPDIR=../../..

default: all

include $(TOPDIR)/Makedefs

SHELL = /bin/sh

subdirs = tests uri

RM = rm -f
AR = ar
RANLIB = ranlib
SHTOOL = shtool/shtool

INCLUDES = -I../uri -I..
DEFINES = -DHAVE_CONFIG_H

LDLIBS = ../libtp.a $(LIBS)

PROGS = daytime$(EXE) fing$(EXE) hhead$(EXE) pop$(EXE) testuri$(EXE) wtrace$(EXE)
OBJS = daytime.o fing.o hhead.o pop.o testuri.o wtrace.o
SRCS = daytime.c fing.c hhead.c pop.c testuri.c wtrace.c

all: Makefile $(PROGS)

%.o: %.c
	$(CMNT)@echo "   [TP TESTS] $<"
	$(SLNT)$(CC) $(CFLAGS) -I.. -I../uri -c $<

clean:
	$(RM) $(OBJS) $(PROGS)

Pure distclean: clean

daytime$(EXE): daytime.o ../libtp.a
	$(CMNT)@echo "   [TP TESTS] $<"
	$(SLNT)$(CC) -o daytime daytime.o $(LDFLAGS) $(LDLIBS)

fing$(EXE): fing.o ../libtp.a
	$(CMNT)@echo "   [TP TESTS] $<"
	$(SLNT)$(CC) -o fing fing.o $(LDFLAGS) $(LDLIBS)

hhead$(EXE): hhead.o ../libtp.a
	$(CMNT)@echo "   [TP TESTS] $<"
	$(SLNT)$(CC) -o hhead hhead.o $(LDFLAGS) $(LDLIBS)

pop$(EXE): pop.o ../libtp.a
	$(CMNT)@echo "   [TP TESTS] $<"
	$(SLNT)$(CC) -o pop pop.o $(LDFLAGS) $(LDLIBS)

testuri$(EXE): testuri.o ../libtp.a
	$(CMNT)@echo "   [TP TESTS] $<"
	$(SLNT)$(CC) -o testuri testuri.o $(LDFLAGS) $(LDLIBS)

wtrace$(EXE): wtrace.o ../libtp.a
	$(CMNT)@echo "   [TP TESTS] $<"
	$(SLNT)$(CC) -o wtrace wtrace.o $(LDFLAGS) $(LDLIBS)
