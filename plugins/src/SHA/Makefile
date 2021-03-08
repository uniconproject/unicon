#-------------------------------------------------------------------------------
# 
# This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
# (LGPL) version 2. The licence may be found in the root directory of the Unicon
# source directory in the file COPYING.
#
#-------------------------------------------------------------------------------
# Makefile for the bit manipulation plugin
#
# Look for @Replace and change the line(s) that follow(s)  
#

# @Replace: What is the name of this library?
LNAME=shalib

RFCDIR = ./RFC6234
RFC6234Files = $(RFCDIR)/sha1.o $(RFCDIR)/sha224-256.o ./$(RFCDIR)/sha384-512.o \
			./$(RFCDIR)/usha.o ./$(RFCDIR)/hkdf.o ./$(RFCDIR)/hmac.o

# @Replace: add any additionl (non-standard name) c source file(s) here
COBJ = $(LNAME).o $(RFC6234Files)
CSRC = $(LNAME).c

# @Replace: If additional libraries need to be linked in append them here:
MYLIBS=$(LIBS)

# Relative to top level
TOPDIR=../../..

# lib relative to top
TDIR=../..

include ../Makedefs

default:	 $(LIBD)/$(LNAME).u shaPlugTest

$(RFC6234Files):
	cd $(RFCDIR); $(MAKE)

shaPlugTest: shaPlugTest.icn
	unicon -s $< -o $@

Clean: clean
	$(RM) shaPlugTest
	cd $(RFCDIR); $(MAKE) $@

