

test: 		calc.out 
		diff calc.out calc.correct

calc.out: 	calc.in calc
		calc < calc.in > calc.out

calc: 		calc.icn
		icont calc.icn

calc.icn: 	calc.y
		./iyacc -i calc.y

clean:		
		@rm -f *.icn *.out calc iyacc *~


