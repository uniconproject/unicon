################################################################################
# 
# This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
# (LGPL) version 2. The licence may be found in the root directory of the Unicon
# source directory in the file COPYING.
#
################################################################################
#
#     Makefile for the rng shared libraries
#
#     Don Ward
#     March 2021
#
################################################################################
include ../../Makedefs

.PHONY: Pure clean install test testPrograms ConfidenceTest

TESTPROGS = rngConfidence rngPutGet speedtest

default: all_prngs

all_prngs:
ifdef RNGLIBS
	$(MAKE) -C rngIconEx
	$(MAKE) -C rngRbt
	$(MAKE) -C rngRlx
ifdef GSLRNG
	$(MAKE) -C rngGSL
endif
# Each install places a shared library in plugins/lib (a.k.a ../lib)
	@$(MAKE) -C rngIconEx install
	@$(MAKE) -C rngRbt install
	@$(MAKE) -C rngRlx install
ifdef GSLRNG
	@$(MAKE) -C rngGSL install
endif
endif

test: all_prngs testPrograms
ifdef RNGLIBS
	$(MAKE) -C rngIconEx test
	$(MAKE) -C rngRbt test
	$(MAKE) -C rngRlx test
ifdef GSLRNG
	$(MAKE) -C rngGSL test
endif
	./rngConfidence >/dev/null
endif

testPrograms: $(TESTPROGS)

rngConfidence: rngConfidence.icn
	unicon -s $^ -o $@

ConfidenceTest: rngConfidence
	./rngConfidence >/dev/null

rngPutGet: rngPutGet.icn
	unicon -s $^ -o $@

speedtest: speedtest.icn
	unicon -s $^ -o $@


install: all_prngs

clean:
	$(MAKE) -C rngIconEx clean
	$(MAKE) -C rngRbt clean
	$(MAKE) -C rngRlx clean
	$(MAKE) -C rngGSL clean
	rm -f $(TESTPROGS)

Pure:
	$(MAKE) -C rngIconEx Pure
	$(MAKE) -C rngRbt Pure
	$(MAKE) -C rngRlx Pure
	$(MAKE) -C rngGSL clean
	rm -f $(TESTPROGS)


