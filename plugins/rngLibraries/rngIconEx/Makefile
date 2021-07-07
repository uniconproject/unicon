################################################################################
# 
# This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
# (LGPL) version 2. The licence may be found in the root directory of the Unicon
# source directory in the file COPYING.
#
################################################################################
#
#     Makefile for the rngIconEx shared library
#
#     Don Ward
#     August 2019
#
################################################################################
include ../../../Makedefs

.PHONY: Pure clean install test

# Source files for the shared library
SRC=rngIconEx.c
# Name of the target shared library
RNGLIB=rngIconEx.so
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
	rm -f *.o *.so test-vectors test.output

Pure: clean
	rm -f $(LIBDIR)/$(RNGLIB)

test:
	unicon -s test-vectors
	./test-vectors > test.output
	diff Icon.test-vectors test.output
