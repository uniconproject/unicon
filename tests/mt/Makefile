#  Makefile for testing Icon

MTTST=level load
#TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
TARGETS=$(MTTST)

# Do the tests
Test: DoTest

#test-level: level level_tp
#	./level > level.out
#	@diff level.out stand/level.std # && echo $@ === FAILED ===


level : level_tp 

level_tp : level_tp.icn 
	@$(RM) level_tp
	$(UC) level_tp

Clean :  Pure 

clean :  pure 

include ../Makefile.test

Pure :
	rm -f $(TARGETS) level level_tp *.out load local/*.out

pure :
	@rm -f $(TARGETS) level level_tp *.out load local/*.out
