#  Makefile for testing Icon

E=/bin/echo

# define UC if it is not defined already
UC?=../bin/unicon

TESTS=general posix thread pattern mt unicon

#  The default is to run all tests, using icont.

default: Test

Test: Hdr
	@for dir in $(TESTS); do \
	$(MAKE) -C $$dir; \
	done
	@make -s Summary

all: Hdr
	@for dir in $(TESTS); do \
	$(MAKE) -C $$dir all; \
	done
	@make -s Summary

Hdr:
	@echo
	@echo "   ====================================="
	@echo "           Unicon Test Suite"
	@$E -n "    "
	@$(UC) -version
	@echo "   ====================================="	
	@echo

Summary: Hdr summary

summary:
	@for dir in $(TESTS); do \
	 $(MAKE) -C $$dir Summary; \
	done

Report:  Hdr
	@for dir in $(TESTS); do \
	$(MAKE) -C $$dir Report; \
	done
	@make -s Summary
	@echo "====================================="
	@echo " This Unicon Build:"
	@$(UC) -features
	@echo "====================================="

ARCH=$(shell $(UC) -features | grep Arch | cut -d " " -f 2)
UNAME=$(shell uname )
RNAME=unicon-$(UNAME)-$(ARCH).report

publish:
	make -s Report > $(RNAME)
	scp $(RNAME) web.sf.net:/home/project-web/unicon/htdocs/test/auto/

Test-icont:	; cd general; $(MAKE) Test; cd ../posix; $(MAKE) Test
Samples Samples-icont:	; cd general; $(MAKE) Samples

Test-iconc:		; cd general; $(MAKE) Test-iconc
Samples-iconc:		; cd general; $(MAKE) Samples-iconc

.PHONY:  clean Clean Test Test-icon Test-icont Test-iconc Samples $(TESTS)
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
