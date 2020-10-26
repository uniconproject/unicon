#
# makefile
#

#
# CFLAGS is universal for "compile flags"
# LDFLAGS stands for "link flags"
#
CFLAGS=-s -c
LDFLAGS=-s -DMAIN

EXE=binary-trees chameneos-redux fannkuch fasta k-nucleotide rsg	\
	mandelbrot meteor-contest n-body pidigits reverse-complement	\
	regex-dna spectral-norm thread-ring concord deal ipxref queens	\
	generate run-test run-shootout run-benchmark run-med 

SRC=binary-trees.icn chameneos-redux.icn fannkuch.icn fasta.icn		\
	k-nucleotide.icn mandelbrot.icn meteor-contest.icn		\
	n-body.icn pidigits.icn reverse-complement.icn regex-dna.icn	\
	spectral-norm.icn thread-ring.icn concord.icn deal.icn		\
	ipxref.icn queens.icn rsg.icn auxiliary.icn pool.icn		\
	shuffle.icn

OBJ=binary-trees.u chameneos-redux.u fannkuch.u fasta.u			\
	k-nucleotide.u mandelbrot.u meteor-contest.u n-body.u		\
	pidigits.u reverse-complement.u regex-dna.u spectral-norm.u	\
	thread-ring.u concord.u deal.u ipxref.u queens.u rsg.u		\
	auxiliary.u pool.u shuffle.u

INPUT=ipxref.dat 1-thou.dat 10-thou.dat 25-thou.dat 5-mil.dat 25-mil.dat


all: $(EXE) input 

build: $(EXE)

input: generate
	./generate

generate:  generate.u
	unicon -s -o generate generate.u

generate.u: generate.icn binary-trees.u
	unicon $(CFLAGS) generate.icn

run-test: run-test.u $(OBJ)
	unicon -s -o run-test run-test.u auxiliary.u

run-test.u: run-test.icn 
	unicon $(CFLAGS) run-test.icn 

run-benchmark: run-benchmark.u $(OBJ)
	unicon -s -o run-benchmark run-benchmark.u auxiliary.u

run-benchmark.u: run-benchmark.icn 
	unicon $(CFLAGS) run-benchmark.icn 

run-med: run-med.u $(OBJ)
	unicon -s -o run-med run-med.u auxiliary.u

run-med.u: run-med.icn $(OBJ)
	unicon $(CFLAGS) run-med.icn 

run-shootout: run-shootout.u $(OBJ)
	unicon -s -o run-shootout run-shootout.u auxiliary.u

run-shootout.u: run-shootout.icn 
	unicon $(CFLAGS) run-shootout.icn

auxiliary.u: auxiliary.icn
	unicon $(CFLAGS) auxiliary.icn

fasta.o: fasta.c
	gcc $(CFLAGS) fasta.c

pool.u: pool.icn 
	unicon $(CFLAGS) pool.icn 

binary-trees: binary-trees.icn pool.u
	unicon $(LDFLAGS) binary-trees.icn pool.u

binary-trees.u: binary-trees.icn
	unicon $(CFLAGS) binary-trees.icn

chameneos-redux: chameneos-redux.icn
	unicon $(LDFLAGS) chameneos-redux.icn

chameneos-redux.u: chameneos-redux.icn
	unicon $(CFLAGS) chameneos-redux.icn

fannkuch: fannkuch.icn
	unicon $(LDFLAGS) fannkuch.icn 

fannkuch.u: fannkuch.icn
	unicon $(CFLAGS) fannkuch.icn

fasta: fasta.icn
	unicon $(LDFLAGS) fasta.icn 

fasta.u: fasta.icn
	unicon $(CFLAGS) fasta.icn

k-nucleotide: k-nucleotide.icn
	unicon $(LDFLAGS) k-nucleotide.icn 

k-nucleotide.u: k-nucleotide.icn
	unicon $(CFLAGS) k-nucleotide.icn

mandelbrot: mandelbrot.icn pool.u
	unicon $(LDFLAGS) mandelbrot.icn pool.u

mandelbrot.u: mandelbrot.icn
	unicon $(CFLAGS) mandelbrot.icn

meteor-contest: meteor-contest.icn
	unicon $(LDFLAGS) meteor-contest.icn 

meteor-contest.u: meteor-contest.icn
	unicon $(CFLAGS) meteor-contest.icn

n-body: n-body.icn
	unicon $(LDFLAGS) n-body.icn 

n-body.u: n-body.icn
	unicon $(CFLAGS) n-body.icn

pidigits: pidigits.icn
	unicon $(LDFLAGS) pidigits.icn 

pidigits.u: pidigits.icn
	unicon $(CFLAGS) pidigits.icn

reverse-complement: reverse-complement.icn
	unicon $(LDFLAGS) reverse-complement.icn 

reverse-complement.u: reverse-complement.icn
	unicon $(CFLAGS) reverse-complement.icn

regex-dna: regex-dna.icn pool.u
	unicon $(LDFLAGS) regex-dna.icn pool.u

regex-dna.u: regex-dna.icn
	unicon $(CFLAGS) regex-dna.icn

spectral-norm: spectral-norm.icn
	unicon $(LDFLAGS) spectral-norm.icn

spectral-norm.u: spectral-norm.icn
	unicon $(CFLAGS) spectral-norm.icn

thread-ring: thread-ring.icn
	unicon $(LDFLAGS) thread-ring.icn 

thread-ring.u: thread-ring.icn
	unicon $(CFLAGS) thread-ring.icn

concord:
	unicon $(LDFLAGS) concord.icn 

concord.u: concord.icn
	unicon $(CFLAGS) concord.icn 

deal: deal.icn shuffle.u
	unicon $(LDFLAGS) deal.icn 

deal.u: deal.icn shuffle.u
	unicon $(CFLAGS) deal.icn 

ipxref:
	unicon $(LDFLAGS) ipxref.icn 

ipxref.u: ipxref.icn
	unicon $(CFLAGS) ipxref.icn 

queens:
	unicon $(LDFLAGS) queens.icn 

queens.u: queens.icn
	unicon $(CFLAGS) queens.icn 

rsg:
	unicon $(LDFLAGS) rsg.icn 

rsg.u: rsg.icn
	unicon $(CFLAGS) rsg.icn 

shuffle.u: shuffle.icn
	unicon $(CFLAGS) shuffle.icn


Clean clean:
	rm -f *.u uni* *.o *.exe generate.out $(EXE)

distclean Pure: clean
	rm -f *.dat
