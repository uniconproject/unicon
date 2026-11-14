#
# Performance micro-benchmarks for the interpreter and the threaded
# runtime.  Not part of "make Test": timings vary from machine to machine
# and run to run.
#
#    make                     run every benchmark, 5 runs each
#    make Save OUT=base.txt   run and save the results
#    make Compare BASE=base.txt
#                             run and compare with saved results
#    make RUNPERF="-r 3 -s 0.5"
#                             pass options to runperf
#

include ../Makedefs

RUNPERF ?=

Perf: perfbench runperf
	./runperf $(RUNPERF)

Save: perfbench runperf
	./runperf $(RUNPERF) -o $(OUT)

Compare: perfbench runperf
	./runperf $(RUNPERF) -c $(BASE)

perfbench: perfbench.icn
	$(UC) -s perfbench.icn

runperf: runperf.icn
	$(UC) -s runperf.icn

Clean clean:
	rm -f perfbench runperf *.u uniclass.dir uniclass.pag
