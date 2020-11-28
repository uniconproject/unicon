#  Makefile for the dynamically loaded C function library.
#
#  If building with the compiler (instead of the interpreter)
#  use the "-fs" option to avoid problems.


TOPDIR=../..

default: default_target

include $(TOPDIR)/Makedefs

ICONT = icont
IFLAGS = -us
ITRAN = $(ICONT) $(IFLAGS)

# Macs should really use libcfunc.dylib, but libcfunc.so works just as well
#  (and requires no alterations to other makefiles to accommodate the change to dylib).
FUNCLIB = libcfunc.so

.SUFFIXES: .c .o
.c.o:
%.o: %.c
	$(CMNT)@echo "   [CFUNC] $<"
	$(SLNT)$(CC) $(CFLAGS) $(CFDYN) -c $<

FUNCS = bitcount.o files.o fpoll.o internal.o lgconv.o osf.o \
	pack.o ppm.o process.o tconnect.o
CSRC = bitcount.c files.c fpoll.c internal.c lgconv.c osf.c \
	pack.c ppm.c process.c tconnect.c



default_target: $(CFUNCTARGET)

cfun:	cfunc.u $(FUNCLIB)

disabled:
	echo plugins/cfuncs are disabled in this build

windows:
	echo cfuncs are not supported on Windows builds yet

# library
$(FUNCLIB):	$(FUNCS)
		$(CC) $(LDDYN) -o $(FUNCLIB) $(CFDYN) $(FUNCS)

$(FUNCS):	icall.h

# Icon interface
cfunc.u:	cfunc.icn
		$(ICONT) $(IFLAGS) -c cfunc.icn
cfunc.icn:	$(CSRC) mkfunc.sh
		sh mkfunc.sh $(FUNCLIB) $(FUNCS) >cfunc.icn


# cleanup
clean Clean:
	-$(RM) -f $(FUNCLIB) *.o *.u? *.so so_locations
