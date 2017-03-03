#  Makefile for testing Icon

E=/bin/echo

TESTS=general posix thread

#  The default is to run all tests, using icont.

default: Test

Test: Hdr
	@for dir in $(TESTS); do \
	$(MAKE) -C $$dir; \
	done
	@make -s summary

all: Hdr
	@for dir in $(TESTS); do \
	$(MAKE) -C $$dir all; \
	done
	@make -s summary

Hdr:  Hdr
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
	@make -s summary
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
