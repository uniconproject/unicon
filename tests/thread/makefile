all: test-load

test-load: load
	./load >& load.out
	diff load.std load.out
	
load: load.icn
	icont load
