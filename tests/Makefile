#  Makefile for testing Icon

E=/bin/echo

# Quiet recursive make: no "Entering directory ... / Leaving directory ..." lines.
MAKEFLAGS += --no-print-directory

# define UC if it is not defined already
UC?=../bin/unicon

TESTS=udb

#  The default is to run all tests, using icont.
#  Test / all / summary / Summary below use recursive Summary (Makefile.test):
#  each line is P (passed), F (failed), S (skipped), Time, and Result.
#  .suite_duration (seconds) is written when each suite is run under Test/all.
#  Per-test diff output (.report) and the full aggregate summary together: make Report.

default: Test

Test: Hdr
	@for dir in $(TESTS); do \
	  t0=$$(date +%s); \
	  $(MAKE) -C $$dir; \
	  t1=$$(date +%s); \
	  echo $$((t1 - t0)) > $$dir/.suite_duration; \
	done
	@echo ""
	@echo "Test Suite   P   F   S   Time   Result"
	@echo "==========  === === ===  ======  ================================================================"
	@for dir in $(TESTS); do \
	$(MAKE) -C $$dir Summary; \
	done
	@$(MAKE) -s aggregate-summary
	@echo ""

all: Hdr
	@for dir in $(TESTS); do \
	  t0=$$(date +%s); \
	  $(MAKE) -C $$dir all; \
	  t1=$$(date +%s); \
	  echo $$((t1 - t0)) > $$dir/.suite_duration; \
	done
	@echo ""
	@echo "Test Suite   P   F   S   Time   Result"
	@echo "==========  === === ===  ======  ================================================================"
	@for dir in $(TESTS); do \
	$(MAKE) -C $$dir Summary; \
	done
	@$(MAKE) -s aggregate-summary
	@echo ""

Hdr:
	@echo ""
	@echo "Unicon Test Suite"
	@$(UC) -version 2>/dev/null | sed 's/^/  /' || true
	@echo ""

Summary: Hdr summary

summary:
	@echo ""
	@echo "Test Suite   P   F   S   Time   Result"
	@echo "==========  === === ===  ======  ================================================================"
	@for dir in $(TESTS); do \
	 $(MAKE) -C $$dir Summary; \
	done
	@$(MAKE) -s aggregate-summary
	@echo ""

aggregate-summary:
	@tp=0; tf=0; ts=0; tt=0; \
	for d in $(TESTS); do \
	  pfs=`$(MAKE) -C $$d -s print-pfs`; \
	  p=`echo $$pfs | awk '{print $$1}'`; \
	  f=`echo $$pfs | awk '{print $$2}'`; \
	  s=`echo $$pfs | awk '{print $$3}'`; \
	  tp=`expr $$tp + $$p`; \
	  tf=`expr $$tf + $$f`; \
	  ts=`expr $$ts + $$s`; \
	  if [ -f $$d/.suite_duration ]; then \
	    tt=`expr $$tt + $$(cat $$d/.suite_duration)`; \
	  fi; \
	done; \
	if [ $$tf -eq 0 ]; then res=pass; else res=FAIL; fi; \
	echo "-------------------------------------------------------------------------------"; \
	if [ $$tt -gt 0 ]; then \
	  echo "Result: $$res  ($$tp passed, $$tf failed, $$ts skipped) in $$tt seconds"; \
	else \
	  echo "Result: $$res  ($$tp passed, $$tf failed, $$ts skipped)"; \
	fi

# Per-suite diff reports only for suites with *.diff; then summary table + aggregate Result.
Report:
	@echo ""
	@echo "Unicon Test Suite"
	@echo ""
	@$(UC) -features
	@echo "====================================="
	@for dir in $(TESTS); do \
	  has=0; \
	  for f in $$dir/*.diff; do \
	    [ -f "$$f" ] || continue; \
	    has=1; \
	    break; \
	  done; \
	  if [ $$has -eq 1 ]; then \
	    echo ""; \
	    echo "-------------------------- $$dir --------------------------"; \
	    $(MAKE) -C $$dir Report REPORT_FROM_TOP=1; \
	  fi; \
	done
	@$(MAKE) -s summary

ARCH=$(shell $(UC) -features | grep Arch | cut -d " " -f 2)
UNAME=$(shell uname )
RNAME=unicon-$(UNAME)-$(ARCH).report

publish:
	$(MAKE) -s Report > $(RNAME)
	scp $(RNAME) web.sf.net:/home/project-web/unicon/htdocs/test/auto/

Test-icont:	; cd general; $(MAKE) Test; cd ../posix; $(MAKE) Test
Samples Samples-icont:	; cd general; $(MAKE) Samples

Test-iconc:		; cd general; $(MAKE) Test-iconc
Samples-iconc:		; cd general; $(MAKE) Samples-iconc

.PHONY:  clean Clean Test Test-icon Test-icont Test-iconc Samples aggregate-summary $(TESTS)
#  Clean up.

distclean:
		-cd bench;	$(MAKE) distclean
		-cd calling;	$(MAKE) distclean
		-cd general;	$(MAKE) distclean
		-cd graphics;	$(MAKE) distclean
		-cd ipl;	$(MAKE) distclean
		-cd preproc;	$(MAKE) distclean
		-cd samples;	$(MAKE) distclean
		-cd special;	$(MAKE) distclean
		-cd posix;	$(MAKE) distclean
		-cd mt;		$(MAKE) distclean
		-cd pattern &&	$(MAKE) distclean
		-cd thread &&	$(MAKE) distclean
		-cd coexpr &&	$(MAKE) distclean
		-rm -f posix/x.icn
		-rm -f posix/1

clean Clean Pure:
		-cd bench;	$(MAKE) Clean
		-cd calling;	$(MAKE) Clean
		-cd general;	$(MAKE) Clean
		-cd graphics;	$(MAKE) Clean
		-cd ipl;	$(MAKE) Clean
		-cd preproc;	$(MAKE) Clean
		-cd samples;	$(MAKE) Clean
		-cd special;	$(MAKE) Clean
		-cd posix;	$(MAKE) Clean
		-cd mt;		$(MAKE) Clean
		-cd pattern &&	$(MAKE) Clean
		-cd thread &&	$(MAKE) Clean
		-cd coexpr &&	$(MAKE) Clean
		-cd lib &&	$(MAKE) Clean
		-for d in $(TESTS); do rm -f $$d/.suite_duration; done
