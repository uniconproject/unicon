BASE=../../..
include $(BASE)/Makedefs.uni

test: 		calc.out 
		diff -w  calc.out calc.correct

calc.out: 	calc.in calc
		./calc < calc.in > calc.out

calc: 		calc.icn
		ASAN_OPTIONS="detect_leaks=0$${ASAN_OPTIONS:+:$${ASAN_OPTIONS}}" $(ICONT) -s calc.icn

calc.icn: 	calc.y
		ASAN_OPTIONS="detect_leaks=0$${ASAN_OPTIONS:+:$${ASAN_OPTIONS}}" $(BIN)/iyacc -i calc.y

clean:		
		@$(RM) -f *.icn *.out calc$(EXE) *~ iyacc$(EXE)


