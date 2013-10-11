#
# Test all threads-tests. Not tested yet.
#

all: test-load test-bored test-channel test-error test-gc test-hellothr test-mutexfun test-queue test-rantest test-sharelist test-stress test-sum test-talloc test-tcom

test-load: load
	./load >& load.out
	diff load.std load.out

load: load.icn
	icont load

test-bored: bored
	./bored >& bored.out
	diff bored.std bored.out

bored: bored.icn
	$(UC) bored

test-channel: channel
	./channel >& channel.out
	diff channel.std channel.out

channel: channel.icn
	$(UC) channel

test-error: error
	./error >& error.out
	diff error.std error.out

error: error.icn
	$(UC) error

test-gc: gc
	./gc >& gc.out
	diff gc.std gc.out

gc: gc.icn
	$(UC) gc

test-hellothr: hellothr
	./hellothr >& hellothr.out
	diff hellothr.std hellothr.out

hellothr: hellothr.icn
	$(UC) hellothr

test-mutexfun: mutexfun
	./mutexfun >& mutexfun.out
	diff mutexfun.std mutexfun.out

mutexfun: mutexfun.icn
	$(UC) mutexfun

test-queue: queue
	./queue >& queue.out
	diff queue.std queue.out

queue: queue.icn
	$(UC) queue

test-rantest: rantest
	./rantest >& rantest.out
	diff rantest.std rantest.out

rantest: rantest.icn
	$(UC) rantest

test-sharelist: sharelist
	./sharelist >& sharelist.out
	diff sharelist.std sharelist.out

sharelist: sharelist.icn
	$(UC) sharelist

test-stress: stress
	./stress >& stress.out
	diff stress.std stress.out

stress: stress.icn
	$(UC) stress

test-sum: sum
	./sum >& sum.out
	diff sum.std sum.out

sum: sum.icn
	$(UC) sum

test-talloc: talloc
	./talloc >& talloc.out
	diff talloc.std talloc.out

talloc: talloc.icn
	$(UC) talloc

test-tcom: tcom
	./tcom >& tcom.out
	diff tcom.std tcom.out

tcom: tcom.icn
	$(UC) tcom
