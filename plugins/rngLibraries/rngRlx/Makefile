################################################################################
# 
# This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
# (LGPL) version 2. The licence may be found in the root directory of the Unicon
# source directory in the file COPYING.
#
################################################################################
#
#     Makefile for the rngRlx++ shared library
#
#     Don Ward
#     March 2022
#
################################################################################
include ../../../Makedefs

.PHONY: Pure clean install test

# Source files for the shared library
SRC=rngRlx++.c CRanluxppEngine.c
# Name of the target shared library
RNGLIB=rngRlx++.so
# Special flags for dynamic shared libraries
CCSHFLAGS=-shared -fpic
# Installation directory is plugins/lib
LIBSDIR=../../lib

all: $(RNGLIB)

$(RNGLIB): $(SRC)
	$(CC) $(CFLAGS) $(CCSHFLAGS) $^ -o $@

$(SRC): CRanluxppEngine.h

install: $(RNGLIB)
	cp $^ $(LIBSDIR)

clean:
	rm -f *.o *.so confidenceTest
	rm -fr *.so*

Pure: clean
	rm -f $(LIBDIR)/$(RNGLIB)

test:
	unicon -s -u confidenceTest.icn -x
