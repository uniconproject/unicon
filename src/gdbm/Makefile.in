#### Start of system configuration section. ####

srcdir = @srcdir@
VPATH = @srcdir@

CC = @CC@

INSTALL = @INSTALL@
INSTALL_PROGRAM = @INSTALL_PROGRAM@
INSTALL_DATA = @INSTALL_DATA@

MAKEINFO = makeinfo
TEXI2DVI = texi2dvi
RANLIB = @RANLIB@

DEFS =

# Where the system [n]dbm routines are...
LIBS = @LIBS@ -lc

# SunOS users might wish to add '-fpcc-struct-return' to CFLAGS. see INSTALL.
CFLAGS = -O
LDFLAGS =

# Common prefix for installation directories
prefix = /usr/local
exec_prefix = $(prefix)
binprefix = $(exec_prefix)
manprefix = $(prefix)

# Directory in which to put libgdbm.a.
libdir = $(exec_prefix)/lib
# The include directory for gdbm.h and dbm.h.
includedir = $(prefix)/include
# Info and man directories.
infodir = $(prefix)/info
man3dir = $(prefix)/man/man3
manext = 3

#### End of system configuration section. ####

.c.o:
	$(CC) -c $(CPPFLAGS) $(DEFS) -I. -I$(srcdir) $(CFLAGS) $<

SHELL = /bin/sh

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

OBJS = $(DBM_OF) $(NDBM_OF) $(GDBM_OF) @ALLOCA@

HDRS = gdbmdefs.h extern.h gdbmerrno.h systems.h dbm.h ndbm.h gdbmconst.h \
	proto.h

MSCFILES = COPYING ChangeLog Makefile.in README gdbm.3 gdbm.texinfo \
	gdbm.info NEWS INSTALL gdbm.proto gdbm.proto2 conv2gdbm.c \
	configure configure.in alloca.c getopt.c getopt.h samp1.cc \
	autoconf.h.in

DISTFILES = $(SRCS) $(HDRS) $(MSCFILES)

all: libgdbm.a

progs: $(PROGS)

install: libgdbm.a gdbm.h gdbm.info
	$(INSTALL_DATA) libgdbm.a $(libdir)/libgdbm.a
	$(INSTALL_DATA) gdbm.h $(includedir)/gdbm.h
	$(INSTALL_DATA) $(srcdir)/gdbm.3 $(man3dir)/gdbm.3
	$(INSTALL_DATA) $(srcdir)/gdbm.info $(infodir)/gdbm.info

install-compat:
	$(INSTALL_DATA) $(srcdir)/dbm.h $(includedir)/dbm.h
	$(INSTALL_DATA) $(srcdir/ndbm.h $(includedir)/ndbm.h

libgdbm.a: $(OBJS) gdbm.h
	rm -f libgdbm.a
	ar q libgdbm.a $(OBJS)
	$(RANLIB) libgdbm.a

gdbm.h:	gdbm.proto gdbmerrno.h gdbm.proto2
	rm -f gdbm.h
	cp $(srcdir)/gdbm.proto gdbm.h
	chmod +w gdbm.h
	grep _ $(srcdir)/gdbmerrno.h >> gdbm.h
	cat $(srcdir)/gdbm.proto2 >> gdbm.h
	chmod -w gdbm.h

testgdbm: testgdbm.o libgdbm.a @LIBOBJS@
	$(CC) $(LDFLAGS) -o testgdbm testgdbm.o libgdbm.a @LIBOBJS@

testdbm: testdbm.o libgdbm.a
	$(CC) $(LDFLAGS) -o testdbm testdbm.o libgdbm.a

tdbm: testdbm.o libgdbm.a
	$(CC) $(LDFLAGS) -o tdbm testdbm.o $(LIBS)

testndbm.o: testndbm.c
	$(CC) -c -I. -I$(srcdir) $(CFLAGS) $(DEFS) -DGNU $(srcdir)/testndbm.c

testndbm: testndbm.o libgdbm.a
	$(CC) $(LDFLAGS) -o testndbm testndbm.o libgdbm.a

tndbm.o: testndbm.c
	cp $(srcdir)/testndbm.c ./tndbm.c
	$(CC) -c -I. -I$(srcdir) $(CFLAGS) $(DEFS) ./tndbm.c
	rm -f ./tndbm.c

tndbm: tndbm.o libgdbm.a
	$(CC) $(LDFLAGS) -o tndbm tndbm.o $(LIBS)

conv2gdbm: conv2gdbm.o libgdbm.a @LIBOBJS@
	$(CC) $(LDFLAGS) -o conv2gdbm conv2gdbm.o $(LIBS) libgdbm.a @LIBOBJS@

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
	rm -f $(PROGS) $(TEX_F) *.o core junk*

mostlyclean: clean

distclean: clean
	rm -f Makefile autoconf.h config.status gdbm.h $(TEXI_F) *~

realclean: distclean
	rm -f TAGS
	-rm -f \
	  `sed -n 's/.*\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/gdbm-\1/p' \
		version.c`.tar.gz

dist:
	echo \
	  `sed -n 's/.*\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/gdbm-\1/p' \
		version.c` > .fname
	rm -rf `cat .fname`
	mkdir `cat .fname`
	ln $(DISTFILES) `cat .fname`
	tar chf `cat .fname`.tar `cat .fname`
	gzip `cat .fname`.tar
	rm -rf `cat .fname` .fname

# dbm files
dbminit.o:	autoconf.h gdbmdefs.h proto.h extern.h gdbmerrno.h
delete.o:	autoconf.h gdbmdefs.h proto.h extern.h
fetch.o:	autoconf.h gdbmdefs.h proto.h extern.h
store.o:	autoconf.h gdbmdefs.h proto.h extern.h
seq.o:		autoconf.h gdbmdefs.h proto.h extern.h

# ndbm files
dbmopen.o:	autoconf.h gdbmdefs.h extern.h gdbmerrno.h
dbmdelete.o:	autoconf.h gdbmdefs.h extern.h
dbmfetch.o:	autoconf.h gdbmdefs.h extern.h
dbmstore.o:	autoconf.h gdbmdefs.h extern.h
dbmseq.o:	autoconf.h gdbmdefs.h extern.h
dbmclose.o:	autoconf.h gdbmdefs.h systems.h
dbmpagfno.o:	autoconf.h gdbmdefs.h extern.h
dbmdirfno.o:	autoconf.h gdbmdefs.h extern.h


# gdbm files
gdbmclose.o:	autoconf.h gdbmdefs.h 
gdbmdelete.o:	autoconf.h gdbmdefs.h gdbmerrno.h 
gdbmfetch.o:	autoconf.h gdbmdefs.h gdbmerrno.h 
gdbmopen.o:	autoconf.h gdbmdefs.h gdbmerrno.h 
gdbmreorg.o:	autoconf.h gdbmdefs.h gdbmerrno.h extern.h
gdbmseq.o:	autoconf.h gdbmdefs.h 
gdbmstore.o:	autoconf.h gdbmdefs.h gdbmerrno.h 

# gdbm support files
bucket.o:	autoconf.h gdbmdefs.h
falloc.o:	autoconf.h gdbmdefs.h
findkey.o:	autoconf.h gdbmdefs.h
global.o:	autoconf.h gdbmdefs.h gdbmerrno.h 
hash.o:		autoconf.h gdbmdefs.h
update.o:	autoconf.h gdbmdefs.h
version.o:
extern.h:
gdbmdefs.h:	gdbmconst.h systems.h
	touch gdbmdefs.h

# other programs
testgdbm.o:	autoconf.h gdbmdefs.h extern.h gdbmerrno.h systems.h
testdbm.o:	autoconf.h
testndbm.o:	autoconf.h ndbm.h
tdbm.o:		autoconf.h
conv2gdbm.o:	autoconf.h gdbm.h
