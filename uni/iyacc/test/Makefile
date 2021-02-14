BASE=../../..
include $(BASE)/Makedefs.uni

test: 		calc.out 
		diff -w  calc.out calc.correct

calc.out: 	calc.in calc
		./calc < calc.in > calc.out

calc: 		calc.icn
		$(ICONT) -s calc.icn

calc.icn: 	calc.y
		$(BIN)/iyacc -i calc.y

clean:		
		@$(RM) -f *.icn *.out calc$(EXE) *~ iyacc$(EXE)


