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

.PHONY: Pure clean install test

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

test: all_prngs
ifdef RNGLIBS
	$(MAKE) -C rngIconEx test
	$(MAKE) -C rngRbt test
	$(MAKE) -C rngRlx test
ifdef GSLRNG
	$(MAKE) -C rngGSL test
endif
endif


install: all_prngs

clean:
	$(MAKE) -C rngIconEx clean
	$(MAKE) -C rngRbt clean
	$(MAKE) -C rngRlx clean

Pure:
	$(MAKE) -C rngIconEx Pure
	$(MAKE) -C rngRbt Pure
	$(MAKE) -C rngRlx Pure


