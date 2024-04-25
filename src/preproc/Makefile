
TOPDIR=../..

default: pp

include $(TOPDIR)/Makedefs

POBJS = pout.o pchars.o perr.o pmem.o bldtok.o macro.o preproc.o evaluate.o\
	files.o gettok.o pinit.o

OBJS= $(POBJS) $(COBJS)

DOT_H = preproc.h pproto.h ptoken.h ../h/define.h ../h/config.h\
        ../h/typedefs.h ../h/proto.h ../h/mproto.h

pp: pmain.o $(OBJS) ../../rt/lib/libucommon.a
	$(CC) $(CFLAGS) $(LDFLAGS) -o pp pmain.o $(OBJS) -lucommon
	$(CP) pp ../../bin
	$(STRIP) ../../bin/pp

%.o: %.c
	$(CMNT)@echo "   [PREPROC] $<"
	$(SLNT)$(CC) $(CFLAGS) -c $<

pmain.o:	$(DOT_H)
p_out.o:	$(DOT_H)
pchars.o:	$(DOT_H)
p_err.o:	$(DOT_H)
pmem.o:		$(DOT_H)
pstring.o:	$(DOT_H)
bldtok.o:	$(DOT_H)
macro.o:	$(DOT_H)
preproc.o:	$(DOT_H)
evaluate.o:	$(DOT_H)
files.o:	$(DOT_H)
gettok.o:	$(DOT_H)
p_init.o:	$(DOT_H)
