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
RNGLIBS=1

UNILIB = $(shell unicon -features | grep "Libraries at" | sed -e "s/Libraries at //")

default: all_prngs

all_prngs:
ifdef RNGLIBS
	$(MAKE) -C rngIconEx
# Each install places a shared library in plugins/lib (a.k.a ../lib)
	@$(MAKE) -C rngIconEx install
endif

test: all_prngs
ifdef RNGLIBS
	$(MAKE) -C rngIconEx test
endif


install: all_prngs

clean:
	$(MAKE) -C rngIconEx clean

Pure:
	$(MAKE) -C rngIconEx Pure


