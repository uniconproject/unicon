################################################################################
# 
# This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
# (LGPL) version 2. The licence may be found in the root directory of the Unicon
# source directory in the file COPYING.
#
################################################################################
#
#     Makefile for the rngRbt shared library
#
#     Don Ward
#     August 2019
#
################################################################################
include ../../../Makedefs

.PHONY: Pure clean install test

# Source files for the shared library
SRC=rngRbt.c rabbit.c ecrypt-sync.c
# Name of the target shared library
RNGLIB=rngRbt.so
# Special flags for dynamic shared libraries
CCSHFLAGS=-shared -fpic
# Installation directory is plugins/lib
LIBSDIR=../../lib

all: $(RNGLIB)

$(RNGLIB): $(SRC)
	$(CC) $(CFLAGS) $(CCSHFLAGS) $^ -o $@

install: $(RNGLIB)
	cp $^ $(LIBSDIR)

clean:
	rm -f *.o *.so test.output test-vectors

Pure: clean
	rm -f $(LIBDIR)/$(RNGLIB)

etest: ecrypt-test.c rabbit.c ecrypt-sync.c
	$(CC) $(CFLAGS) $^ -o $@

test:
	unicon -s -u test-vectors.icn
	./test-vectors > test.output
	diff selected.test-vectors test.output

