#  Makefile for testing Icon

E=/bin/echo

TESTS=general posix thread pattern

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
	@unicon -version
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
	@unicon -features
	@echo "====================================="

ARCH=$(shell unicon -features | grep Arch | cut -d " " -f 2)
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

Clean Pure:
		-cd bench;	$(MAKE) Clean
		-cd calling;	$(MAKE) Clean
		-cd general;	$(MAKE) Clean
		-cd graphics;	$(MAKE) Clean
		-cd ipl;	$(MAKE) Clean
		-cd preproc;	$(MAKE) Clean
		-cd samples;	$(MAKE) Clean
		-cd special;	$(MAKE) Clean
		-cd posix;	$(MAKE) Clean
