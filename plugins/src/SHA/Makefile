#-------------------------------------------------------------------------------
#
# This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
# (LGPL) version 2. The licence may be found in the root directory of the Unicon
# source directory in the file COPYING.
#
#-------------------------------------------------------------------------------
# Makefile for the secure hash plugin
#
# Look for @Replace and change the line(s) that follow(s)
#

# @Replace: What is the name of this library?
LNAME=shalib

RFCDIR = ./RFC6234
RFC6234Files = $(RFCDIR)/sha1.o $(RFCDIR)/sha224-256.o ./$(RFCDIR)/sha384-512.o \
			./$(RFCDIR)/usha.o ./$(RFCDIR)/hkdf.o ./$(RFCDIR)/hmac.o

# @Replace: add any additional (non-standard name) c source file(s) here
COBJ = $(LNAME).o $(RFC6234Files)
CSRC = $(LNAME).c

# @Replace: If additional libraries need to be linked in append them here:
MYLIBS=$(LIBS)

# Relative to top level
TOPDIR=../../..

# lib relative to top
TDIR=../..

include ../Makedefs

default:	 $(LIBD)/$(LNAME).u

$(RFC6234Files):
	cd $(RFCDIR); $(MAKE)

shaPlugTest: shaPlugTest.icn
	$(TOPDIR)/bin/unicon -s $< -o $@

test: shaPlugTest
	./shaPlugTest All

# @Replace: To add plugin specific clean up actions, include a clean:: target
clean::
	$(RM) shaPlugTest
	cd $(RFCDIR); $(MAKE) $@

