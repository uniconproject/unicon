#  Makefile for testing Icon

TESTS=general posix thread

#  The default is to run all tests, using icont.

default: Test


Test: $(TESTS)
	@echo "[Test suite ran to compeletion]"

%.u: %.icn
	@$(UC) $<

$(TESTS):
	@echo "[ ----- Running test suite: $@ ----- ]"
	cd $@ && $(MAKE) Test
	@echo "[ ----- Done with test suite: $@ ----- ]"
	@echo ""


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
