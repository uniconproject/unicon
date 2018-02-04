BASE=../../..
include ../../Makedefs

test: 		calc.out 
		diff calc.out calc.correct

calc.out: 	calc.in calc
		./calc < calc.in > calc.out

calc: 		calc.icn
		$(BIN)/icont -s calc.icn

calc.icn: 	calc.y
		$(BIN)/iyacc -i calc.y

clean:		
		@$(RM) -f *.icn *.out calc *~ iyacc$(EXE)


