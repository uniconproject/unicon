#  Makefile for iyacc, the Icon-enabled version of Berkeley YACC

TOPDIR=../..

default: all

include $(TOPDIR)/Makedefs

DEST	      = .
HDRS	      = defs.h
LIBS	      =
LINKER	      = $(CC)
MAKEFILE      = Makefile

OBJS	      = closure.o \
		error.o \
		lalr.o \
		lr0.o \
		main.o \
		mkpar.o \
		output.o \
		reader.o \
		skeleton.o \
		symtab.o \
		verbose.o \
		warshall.o

PRINT	      = pr -f -l88

PROGRAM	      = iyacc$(EXE)

SRCS	      = closure.c \
		error.c \
		lalr.c \
		lr0.c \
		main.c \
		mkpar.c \
		output.c \
		reader.c \
		skeleton.c \
		symtab.c \
		verbose.c \
		warshall.c

all:		$(PROGRAM)

$(PROGRAM):     $(OBJS) $(LIBS)
		@echo -n "Loading $(PROGRAM) ... "
		@$(LINKER) $(LDFLAGS) -o $(PROGRAM) $(OBJS) $(LIBS)
		@cp $(PROGRAM) ../../bin/
		strip ../../bin/$(PROGRAM)
		@cd test; $(MAKE)
		@echo "done"

Clean clean:;	$(RM) -f $(OBJS) $(PROGRAM)
		@cd test; $(MAKE) clean

clobber:;	$(RM)rm -f $(OBJS) $(PROGRAM)

depend:;	@mkmf -f $(MAKEFILE) PROGRAM=$(PROGRAM) DEST=$(DEST)

index:;		@ctags -wx $(HDRS) $(SRCS)

install:	$(PROGRAM)
		@echo Installing $(PROGRAM) in $(DEST)
		@install -s $(PROGRAM) $(DEST)

listing:;	@$(PRINT) Makefile $(HDRS) $(SRCS) | lpr

lint:;		@lint $(SRCS)

program:        $(PROGRAM)

tags:           $(HDRS) $(SRCS); @ctags $(HDRS) $(SRCS)

test:		$(PROGRAM)
		@cd test; $(MAKE)

###
%.o: %.c
	$(CMNT)@echo "   [IYACC] $<"
	$(SLNT)$(CC) $(CFLAGS) $(CPPFLAGS) $(DNT) -c $<

closure.o: defs.h
error.o: defs.h
lalr.o: defs.h
lr0.o: defs.h
main.o: defs.h
mkpar.o: defs.h
output.o: defs.h
reader.o: defs.h
skeleton.o: defs.h
symtab.o: defs.h
verbose.o: defs.h
warshall.o: defs.h
