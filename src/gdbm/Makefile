# GDBM Makefile, modified for Unicon
# No longer generated automatically from Makefile.in by configure.

TOPDIR=../..

default: all

include $(TOPDIR)/Makedefs

srcdir=.

DEFS =

# Where the system [n]dbm routines are...
LIBS =  -lc

# SunOS users might wish to add '-fpcc-struct-return' to CFLAGS. see INSTALL.

%.o: %.c
	$(CMNT)@echo "   [GDBM] $<"
	$(SLNT)$(CC) -c $(CPPFLAGS) $(DEFS) -I. -I$(srcdir) $(CFLAGS) $<


PROGS = libgdbm.a testgdbm testdbm testndbm tndbm tdbm conv2gdbm

DBM_CF = dbminit.c delete.c fetch.c store.c seq.c close.c

NDBM_CF = dbmopen.c dbmdelete.c dbmfetch.c dbmstore.c dbmseq.c \
	dbmclose.c dbmdirfno.c dbmpagfno.c dbmrdonly.c

GDBM_CF = gdbmopen.c gdbmdelete.c gdbmfetch.c  gdbmstore.c gdbmclose.c \
	gdbmreorg.c gdbmseq.c gdbmsync.c gdbmerrno.c gdbmexists.c gdbmsetopt.c \
	bucket.c falloc.c findkey.c global.c hash.c update.c \
	version.c

TEST_CF = testdbm.c testndbm.c testgdbm.c


DBM_OF = dbminit.o delete.o fetch.o store.o seq.o close.o

NDBM_OF = dbmopen.o dbmdelete.o dbmfetch.o dbmstore.o dbmseq.o \
	dbmclose.o dbmdirfno.o dbmpagfno.o dbmrdonly.o

GDBM_OF = gdbmopen.o gdbmdelete.o gdbmfetch.o  gdbmstore.o gdbmclose.o \
	gdbmreorg.o gdbmseq.o gdbmsync.o gdbmerrno.o gdbmexists.o gdbmsetopt.o \
	bucket.o falloc.o findkey.o global.o hash.o update.o \
	version.o

TEX_F = gdbm.aux gdbm.cp gdbm.dvi gdbm.fn gdbm.ky gdbm.log gdbm.pg \
	gdbm.toc gdbm.tp gdbm.vr

TEXI_F = gdbm.info

SRCS = $(DBM_CF) $(NDBM_CF) $(GDBM_CF) $(TEST_CF)

OBJS = $(DBM_OF) $(NDBM_OF) $(GDBM_OF) 

HDRS = gdbmdefs.h extern.h gdbmerrno.h systems.h dbm.h ndbm.h gdbmconst.h \
	proto.h

MSCFILES = COPYING ChangeLog Makefile README gdbm.3 gdbm.texinfo \
	gdbm.info NEWS INSTALL gdbm.proto gdbm.proto2 conv2gdbm.c \
	alloca.c getopt.c getopt.h samp1.cc

DISTFILES = $(SRCS) $(HDRS) $(MSCFILES)

all: libgdbm.a

progs: $(PROGS)

libgdbm.a: CP_HEADERS $(OBJS) gdbm.h
	$(RM) $@
	$(AR) q $@ $(OBJS)
	$(RANLIB) $@
	$(CP) $@ ../../rt/lib/

CP_HEADERS:gdbm.h ndbm.h
	$(CP) gdbm.h ../../rt/include/
	$(CP) ndbm.h ../../rt/include/


gdbm.h:	gdbm.proto gdbmerrno.h gdbm.proto2
	$(RM) gdbm.h
	$(CP) $(srcdir)/gdbm.proto gdbm.h
	-chmod +w gdbm.h
	grep _ $(srcdir)/gdbmerrno.h >> gdbm.h
	cat $(srcdir)/gdbm.proto2 >> gdbm.h
	-chmod -w gdbm.h

testgdbm: testgdbm.o libgdbm.a 
	$(CC) $(LDFLAGS) -o testgdbm testgdbm.o libgdbm.a 

testdbm: testdbm.o libgdbm.a
	$(CC) $(LDFLAGS) -o testdbm testdbm.o libgdbm.a

tdbm: testdbm.o libgdbm.a
	$(CC) $(LDFLAGS) -o tdbm testdbm.o $(LIBS)

testndbm.o: testndbm.c
	$(CC) -c -I. -I$(srcdir) $(CFLAGS) $(DEFS) -DGNU $(srcdir)/testndbm.c

testndbm: testndbm.o libgdbm.a
	$(CC) $(LDFLAGS) -o testndbm testndbm.o libgdbm.a

tndbm.o: testndbm.c
	$(CP) $(srcdir)/testndbm.c ./tndbm.c
	$(CC) -c -I. -I$(srcdir) $(CFLAGS) $(DEFS) ./tndbm.c
	rm -f ./tndbm.c

tndbm: tndbm.o libgdbm.a
	$(CC) $(LDFLAGS) -o tndbm tndbm.o $(LIBS)

conv2gdbm: conv2gdbm.o libgdbm.a 
	$(CC) $(LDFLAGS) -o conv2gdbm conv2gdbm.o $(LIBS) libgdbm.a 

lintgdbm: 
	lint $(DEFS) $(LFLAGS) $(DBM_CF) $(NDBM_CF) $(GDBM_CF) testgdbm.c

TAGS: $(SRCS)
	etags $(SRCS)

info: gdbm.info

gdbm.info:
	$(MAKEINFO) $(srcdir)/gdbm.texinfo

dvi: gdbm.dvi

gdbm.dvi:
	$(TEXI2DVI) $(srcdir)/gdbm.texinfo

clean:
	$(RM) $(PROGS) $(TEX_F) *.o core junk*

mostlyclean: clean

distclean: clean
	$(RM) gdbm.h $(TEXI_F) *~

realclean: distclean
	$(RM) TAGS
	-$(RM) \
	  `sed -n 's/.*\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/gdbm-\1/p' \
		version.c`.tar.gz

dist:
	echo \
	  `sed -n 's/.*\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/gdbm-\1/p' \
		version.c` > .fname
	$(RM) -r `cat .fname`
	mkdir `cat .fname`
	ln $(DISTFILES) `cat .fname`
	tar chf `cat .fname`.tar `cat .fname`
	gzip `cat .fname`.tar
	$(RM) -r `cat .fname` .fname

# dbm files
dbminit.o:	../h/config.h gdbmdefs.h proto.h extern.h gdbmerrno.h
delete.o:	../h/config.h gdbmdefs.h proto.h extern.h
fetch.o:	../h/config.h gdbmdefs.h proto.h extern.h
store.o:	../h/config.h gdbmdefs.h proto.h extern.h
seq.o:		../h/config.h gdbmdefs.h proto.h extern.h

# ndbm files
dbmopen.o:	../h/config.h gdbmdefs.h extern.h gdbmerrno.h
dbmdelete.o:	../h/config.h gdbmdefs.h extern.h
dbmfetch.o:	../h/config.h gdbmdefs.h extern.h
dbmstore.o:	../h/config.h gdbmdefs.h extern.h
dbmseq.o:	../h/config.h gdbmdefs.h extern.h
dbmclose.o:	../h/config.h gdbmdefs.h systems.h
dbmpagfno.o:	../h/config.h gdbmdefs.h extern.h
dbmdirfno.o:	../h/config.h gdbmdefs.h extern.h


# gdbm files
gdbmclose.o:	../h/config.h gdbmdefs.h 
gdbmdelete.o:	../h/config.h gdbmdefs.h gdbmerrno.h 
gdbmfetch.o:	../h/config.h gdbmdefs.h gdbmerrno.h 
gdbmopen.o:	../h/config.h gdbmdefs.h gdbmerrno.h 
gdbmreorg.o:	../h/config.h gdbmdefs.h gdbmerrno.h extern.h
gdbmseq.o:	../h/config.h gdbmdefs.h 
gdbmstore.o:	../h/config.h gdbmdefs.h gdbmerrno.h 

# gdbm support files
bucket.o:	../h/config.h gdbmdefs.h
falloc.o:	../h/config.h gdbmdefs.h
findkey.o:	../h/config.h gdbmdefs.h
global.o:	../h/config.h gdbmdefs.h gdbmerrno.h 
hash.o:		../h/config.h gdbmdefs.h
update.o:	../h/config.h gdbmdefs.h
version.o:
extern.h:
gdbmdefs.h:	gdbmconst.h systems.h
	touch gdbmdefs.h

# other programs
testgdbm.o:	../h/config.h gdbmdefs.h extern.h gdbmerrno.h systems.h
testdbm.o:	../h/config.h
testndbm.o:	../h/config.h ndbm.h
tdbm.o:		../h/config.h
conv2gdbm.o:	../h/config.h gdbm.h
