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

.PHONY: Pure clean install test testPrograms

TESTPROGS = rngConfidence rngPutGet rngSpeed
UNILIB = $(shell unicon -features | grep "Libraries at" | sed -e "s/Libraries at //")

default: all_prngs

all_prngs:
	$(MAKE) -C rngIconEx
	$(MAKE) -C rngRbt

test: all_prngs testPrograms
	$(MAKE) -C rngIconEx test
	$(MAKE) -C rngRbt test
	./rngConfidence

testPrograms: $(TESTPROGS)

rngConfidence: rngConfidence.icn
	unicon -s $^ -o $@

rngPutGet: rngPutGet.icn
	unicon -s $^ -o $@

rngSpeed: rngSpeed.icn
	unicon -s $^ -o $@

install: all_prngs
# Each install places a shared library in plugins/lib (a.k.a ../lib)
	@$(MAKE) -C rngIconEx install
	@$(MAKE) -C rngRbt install
# If Unicon is installed somewhere, place the shared libraries in
# the installed location.
	@if test  "X$(UNILIB)" != "X" ; then \
		cp ../lib/rngIconEx.so $(UNILIB); \
		cp ../lib/rngRbt.so $(UNILIB); \
	fi

clean:
	$(MAKE) -C rngIconEx clean
	$(MAKE) -C rngRbt clean
	rm -f $(TESTPROGS)

Pure:
	$(MAKE) -C rngIconEx Pure
	$(MAKE) -C rngRbt Pure
	rm -f $(TESTPROGS)

