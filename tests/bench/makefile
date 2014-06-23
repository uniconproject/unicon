#
# makefile
#

UFLAGS=-c
CFLAGS=-DMAIN -o

EXE=binary-trees chameneos-redux fannkuch fasta fasta k-nucleotide	\
	mandelbrot meteor-contest n-body pidigits reverse-complement	\
	regex-dna spectral-norm thread-ring generate run-test		\
	run-shootout run-benchmark run-med concord deal ipxref queens	\
	rsg

SRC=binary-trees.icn chameneos-redux.icn fannkuch.icn fasta.icn		\
	fasta.icn k-nucleotide.icn mandelbrot.icn meteor-contest.icn	\
	n-body.icn pidigits.icn reverse-complement.icn regex-dna.icn	\
	spectral-norm.icn thread-ring.icn concord.icn deal.icn		\
	ipxref.icn queens.icn rsg.icn auxiliary.icn pool.icn		\
	shuffle.icn

OBJ=binary-trees.u chameneos-redux.u fannkuch.u fasta.u fasta.u		\
	k-nucleotide.u mandelbrot.u meteor-contest.u n-body.u		\
	pidigits.u reverse-complement.u regex-dna.u spectral-norm.u	\
	thread-ring.u concord.u deal.u ipxref.u queens.u rsg.u		\
	auxiliary.u pool.u shuffle.u

INPUT=ipxref.dat 1-thou.dat 10-thou.dat 25-thou.dat 5-mil.dat 25-mil.dat


all: $(EXE) input 

build: $(EXE)

input:
	./generate

generate: generate.u
	unicon -o generate generate.u

generate.u: generate.icn 
	unicon $(UFLAGS) generate.icn

run-test: run-test.u $(OBJ)
	unicon -o run-test run-test.u auxiliary.u

run-test.u: run-test.icn 
	unicon $(UFLAGS) run-test.icn 

run-benchmark: run-benchmark.u $(OBJ)
	unicon -o run-benchmark run-benchmark.u auxiliary.u

run-benchmark.u: run-benchmark.icn 
	unicon $(UFLAGS) run-benchmark.icn 

run-med: run-med.u $(OBJ)
	unicon -o run-med run-med.u auxiliary.u

run-med.u: run-med.icn $(OBJ)
	unicon $(UFLAGS) run-med.icn 

run-shootout: run-shootout.u $(OBJ)
	unicon -o run-shootout run-shootout.u auxiliary.u

run-shootout.u: run-shootout.icn 
	unicon $(UFLAGS) run-shootout.icn

auxiliary.u: auxiliary.icn
	unicon $(UFLAGS) auxiliary.icn

fasta.o: fasta.c
	gcc $(UFLAGS) fasta.c

pool.u: pool.icn 
	unicon $(UFLAGS) pool.icn 

binary-trees: binary-trees.icn pool.u
	unicon $(CFLAGS) binary-trees binary-trees.icn pool.u

binary-trees.u: binary-trees.icn
	unicon $(UFLAGS) binary-trees.icn

chameneos-redux: chameneos-redux.icn
	unicon $(CFLAGS) chameneos-redux chameneos-redux.icn

chameneos-redux.u: chameneos-redux.icn
	unicon $(UFLAGS) chameneos-redux.icn

fannkuch: fannkuch.icn
	unicon $(CFLAGS) fannkuch fannkuch.icn 

fannkuch.u: fannkuch.icn
	unicon $(UFLAGS) fannkuch.icn

fasta: fasta.icn
	unicon $(CFLAGS) fasta fasta.icn 

fasta.u: fasta.icn
	unicon $(UFLAGS) fasta.icn

k-nucleotide: k-nucleotide.icn
	unicon $(CFLAGS) k-nucleotide k-nucleotide.icn 

k-nucleotide.u: k-nucleotide.icn
	unicon $(UFLAGS) k-nucleotide.icn

mandelbrot: mandelbrot.icn pool.u
	unicon $(CFLAGS) mandelbrot mandelbrot.icn pool.u

mandelbrot.u: mandelbrot.icn
	unicon $(UFLAGS) mandelbrot.icn

meteor-contest: meteor-contest.icn
	unicon $(CFLAGS) meteor-contest meteor-contest.icn 

meteor-contest.u: meteor-contest.icn
	unicon $(UFLAGS) meteor-contest.icn

n-body: n-body.icn
	unicon $(CFLAGS) n-body n-body.icn 

n-body.u: n-body.icn
	unicon $(UFLAGS) n-body.icn

pidigits: pidigits.icn
	unicon $(CFLAGS) pidigits pidigits.icn 

pidigits.u: pidigits.icn
	unicon $(UFLAGS) pidigits.icn

reverse-complement: reverse-complement.icn
	unicon $(CFLAGS) reverse-complement reverse-complement.icn 

reverse-complement.u: reverse-complement.icn
	unicon $(UFLAGS) reverse-complement.icn

regex-dna: regex-dna.icn pool.u
	unicon $(CFLAGS) regex-dna regex-dna.icn pool.u

regex-dna.u: regex-dna.icn
	unicon $(UFLAGS) regex-dna.icn

spectral-norm: spectral-norm.icn
	unicon $(CFLAGS) spectral-norm spectral-norm.icn

spectral-norm.u: spectral-norm.icn
	unicon $(UFLAGS) spectral-norm.icn

thread-ring: thread-ring.icn
	unicon $(CFLAGS) thread-ring thread-ring.icn 

thread-ring.u: thread-ring.icn
	unicon $(UFLAGS) thread-ring.icn

concord:
	unicon $(CFLAGS) concord concord.icn 

concord.u:
	unicon $(UFLAGS) concord.icn 

deal:
	unicon $(CFLAGS) deal deal.icn 

deal.u:
	unicon $(UFLAGS) deal.icn 

ipxref:
	unicon $(CFLAGS) ipxref ipxref.icn 

ipxref.u:
	unicon $(UFLAGS) ipxref.icn 

queens:
	unicon $(CFLAGS) queens queens.icn 

queens.u:
	unicon $(UFLAGS) queens.icn 

rsg:
	unicon $(CFLAGS) rsg rsg.icn 

rsg.u:
	unicon $(UFLAGS) rsg.icn 

shuffle.u:
	unicon $(UFLAGS) shuffle.icn


clean:
	rm -f *.u uni* *.o *.exe thread-ring spectral-norm		\
	reverse-complement regex-dna pidigits n-body binary-trees	\
	chameneos-redux fannkuch fasta k-nucleotide mandelbrot		\
	meteor-contest queens rsg concord deal ipxref run-test		\
	run-shootout run-benchmark run-med generate.out generate

