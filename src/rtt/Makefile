#  Makefile for the Icon run-time translator, rtt,
#  which is used to build the Icon run-time system.

TOPDIR=../..

default: all

UNICON_TOP_BUILDDIR ?= $(TOPDIR)
include $(UNICON_TOP_BUILDDIR)/Makedefs

ROBJS = rttparse.o rttmain.o rttlex.o rttsym.o rttnode.o rttout.o rttmisc.o\
	  rttdb.o rttinlin.o rttilc.o yyerror.o

PP_DIR = ../preproc/
P_DOT_H = $(PP_DIR)preproc.h $(PP_DIR)pproto.h ltoken.h ../h/mproto.h\
        ../h/define.h ../h/config.h ../h/typedefs.h ../h/proto.h\
        ../h/cstructs.h ../h/cpuconf.h
POBJS = pout.o pchars.o  perr.o pmem.o  bldtok.o macro.o preproc.o\
	evaluate.o files.o gettok.o pinit.o

OBJ = $(ROBJS) $(POBJS)

all:	urtt$(EXE)

urtt$(EXE):	$(OBJ)
	$(CC) $(LDFLAGS) -o urtt $(OBJ) -lucommon
	$(CP) urtt$(EXE) ../../bin/
	$(STRIP) ../../bin/urtt$(EXE)

library:	$(OBJ)
		$(RM) -r rtt.a
		$(AR) qc rtt.a $(OBJ)
		-(test -f ../../NoRanlib) || (ranlib rtt.a)

$(ROBJS): rtt.h rtt1.h rttproto.h $(P_DOT_H)

%.o: %.c
	$(CMNT)@echo "   [RTT] $<"
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

rttdb.o: ../h/version.h
rttparse.o : ../h/gsupport.h ../h/config.h ../h/cstructs.h \
	../h/proto.h ../h/typedefs.h ../h/cpuconf.h ../h/define.h

pout.o: $(PP_DIR)pout.c $(P_DOT_H)
	$(CMNT)@echo "   [RTT] $<"
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

pchars.o: $(PP_DIR)pchars.c $(P_DOT_H)
	$(CMNT)@echo "   [RTT] $<"
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

perr.o: $(PP_DIR)perr.c $(P_DOT_H)
	$(CMNT)@echo "   [RTT] $<"
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

pmem.o: $(PP_DIR)pmem.c $(P_DOT_H)
	$(CMNT)@echo "   [RTT] $<"
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

bldtok.o: $(PP_DIR)bldtok.c $(P_DOT_H)
	$(CMNT)@echo "   [RTT] $<"
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

macro.o: $(PP_DIR)macro.c $(P_DOT_H)
	$(CMNT)@echo "   [RTT] $<"
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

preproc.o: $(PP_DIR)preproc.c $(P_DOT_H)
	$(CMNT)@echo "   [RTT] $<"
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

evaluate.o: $(PP_DIR)evaluate.c $(P_DOT_H)
	$(CMNT)@echo "   [RTT] $<"
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

files.o: $(PP_DIR)files.c $(P_DOT_H)
	$(CMNT)@echo "   [RTT] $<"
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

gettok.o: $(PP_DIR)gettok.c $(P_DOT_H)
	$(CMNT)@echo "   [RTT] $<"
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

pinit.o: $(PP_DIR)pinit.c $(P_DOT_H)
	$(CMNT)@echo "   [RTT] $<"
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c $<
#
# The following entry is to help everyone remember how to run the
# merr program when it is needed.
#
# Build uni/unicon/merr first (cd ../../uni/unicon && unicon -s merr.icn).
# Run from this directory with urtt already built (make urtt).  With only the
# driver name below, merr defaults the fragment suffix file to m_err.c (-B).
# Optionally pass a second path to override that suffix.
# The historical name is "rtt"; the binary is ./urtt.  Pass -r so
# headers resolve when merr invokes the driver from varying cwd, for example:
#   ../../uni/unicon/merr -B -F "yylval.t->fname" -I rtt.h -L "yylval.t->line" \
#       -T "yylval.t->image" -s "make urtt$(EXE)" ./urtt -r ../../bin/
# After regeneration, set yymaxstate and errtab[] size to match YYNSTATES in
# rttparse.c (see yyerror.c header comment).
#
yyerror.c:
	merr -B -F "yylval.t->fname" -I rtt.h -L "yylval.t->line" -T "yylval.t->image" rtt

#
# The following entry is commented out because it is not normally
# necessary to recreate rttparse.c and ltoken.h unless the grammar
# in rttgram.y for the run-time langauge is changed. Recreating these
# files is not normally a part of the installation process. Note that
# on some systems, yacc may not have large enough internal tables to
# translate this grammar.
#
# Committed rttparse.c and ltoken.h are generated with GNU Bison (not POSIX
# yacc); the old pipeline below used yacc -d and renamed y.tab.*.  Bison
# emits a large parser skeleton, so grammar regen produces a big diff.
# Checked-in generated sources bootstrap the tree on hosts that do not have
# Bison installed; after changing rttgram.y, run bison locally and commit the
# updated rttparse.c and ltoken.h (see repository docs or history for the
# exact bison -o / --defines= flags used in this tree).
#
#rttparse.c ltoken.h: rttgram.y
#	yacc -d $(YFLAGS) rttgram.y
#	fgrep -v -x "extern char *malloc(), *realloc();" y.tab.c > rttparse.c
#	rm y.tab.c
#	mv y.tab.h ltoken.h
