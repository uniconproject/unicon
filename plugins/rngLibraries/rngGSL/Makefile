################################################################################
# 
# This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
# (LGPL) version 2. The licence may be found in the root directory of the Unicon
# source directory in the file COPYING.
#
################################################################################
#
#     Makefile for the rngGSL shared library
#
#     Don Ward
#     March 2022
#
################################################################################
include ../../../Makedefs

.PHONY: Pure clean install test

# Source files for the shared library
SRC=rngGSL.c
# Name of the target shared library
RNGLIB=rngGSL.so
# Special flags for dynamic shared libraries
CCSHFLAGS=-shared -fpic -lgsl
# Installation directory is plugins/lib
LIBSDIR=../../lib

all: $(RNGLIB)

$(RNGLIB): $(SRC)
	$(CC) $(CFLAGS) $(CCSHFLAGS) $^ -o $@

install: $(RNGLIB)
	cp $^ $(LIBSDIR)

clean:
	rm -f *.o *.so

Pure: clean
	rm -f $(LIBDIR)/$(RNGLIB)

test:
	unicon -s -u test-vectors.icn
	./test-vectors > test.output
	diff selected.test-vectors test.output

