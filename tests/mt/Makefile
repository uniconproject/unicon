#  Makefile for testing Icon multiple programs 

include ../Makedefs

CON=$(shell $(UC) -features | grep -o "multiple programs")
MTTST=level load loaderr

# make sure we have mulitple programs, otherwise skip...
ifeq ($(CON),multiple programs)
TARGETS=$(MTTST)
else
skip:
	@echo "\nMultiple programs are not available in this build"
	@echo "Skipping multiple programs test...\n"

TARGETS=skip
endif



# Do the tests
Test: DoTest

#test-level: level level_tp
#	./level > level.out
#	@diff level.out stand/level.std # && echo $@ === FAILED ===


level : level_tp 

level_tp : level_tp.icn 
	@$(RM) level_tp
	$(UC) $(UFLAGS) level_tp

Clean :  Pure 

clean :  pure 

include ../Makefile.test

Pure :
	rm -f $(TARGETS) $(MTTST) level level_tp *.out load local/*.out
# still clean if no multiple programs

pure :
	@rm -f $(TARGETS) $(MTTST) level level_tp *.out load local/*.out
