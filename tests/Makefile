#  Makefile for testing Icon

TESTS=general posix thread

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

Hdr:  Hdr
	@echo
	@echo "   ====================================="
	@echo "           Unicon Test Suite"
	@echo -n "    "
	@unicon -version
	@echo "   ====================================="	
	@echo

Summary: Hdr
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

Test-icont:	; cd general; $(MAKE) Test; cd ../posix; $(MAKE) Test
Samples Samples-icont:	; cd general; $(MAKE) Samples

Test-iconc:		; cd general; $(MAKE) Test-iconc
Samples-iconc:		; cd general; $(MAKE) Samples-iconc

.PHONY:  clean Clean Test $(TESTS)
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
