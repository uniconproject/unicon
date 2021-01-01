#  Makefile for the Icon run-time translator, rtt,
#  which is used to build the Icon run-time system.

TOPDIR=../..

default: all

include $(TOPDIR)/Makedefs

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
	strip ../../bin/urtt$(EXE)

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
yyerror.c:
	merr -B -F "yylval.t->fname" -I rtt.h -L "yylval.t->line" -T "yylval.t->image" rtt foo.r

#
# The following entry is commented out because it is not normally
# necessary to recreate rttparse.c and ltoken.h unless the grammar
# in rttgram.y for the run-time langauge is changed. Recreating these
# files is not normally a part of the installation process. Note that
# on some systems, yacc may not have large enough internal tables to
# translate this grammar.
#
#rttparse.c ltoken.h: rttgram.y
#	yacc -d $(YFLAGS) rttgram.y
#	fgrep -v -x "extern char *malloc(), *realloc();" y.tab.c > rttparse.c
#	rm y.tab.c
#	mv y.tab.h ltoken.h
