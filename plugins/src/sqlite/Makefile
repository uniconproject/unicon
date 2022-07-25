#-------------------------------------------------------------------------------
#
# This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
# (LGPL) version 2. The licence may be found in the root directory of the Unicon
# source directory in the file COPYING.
#
#-------------------------------------------------------------------------------
# Makefile for the sqLite interface plugin
#
# Look for @Replace and change the line(s) that follow(s)
#

# @Replace: What is the name of this library?
LNAME=sqlite

# @Replace: add any additional (non-standard name) c source file(s) here
COBJ = $(LNAME).o
CSRC = $(LNAME).c

# This plugin will not be built if the file libsqlite3.so
# (which is the SQLite version 3 shared library https://sqlite.org/index.html)
# cannot be found. 	In that case you will need to install it.
#    On Debian systems, something like
#        apt-get install libsqlite3-dev
#    will probably do the trick.
# If the shared library is not installed, and cannot be downloaded as
# a pre-built package for your system, an alternative is to download
# the source files directly from the SQLite website and build it locally.
#
# @Replace: If additional libraries need to be linked in append them here:
MYLIBS=$(LIBS) -lsqlite3

# Relative to top level
TOPDIR=../../..

# lib relative to top
TDIR=../..

include ../Makedefs

default:	 $(LIBD)/$(LNAME).u

# @Replace: To add plugin specific clean up actions, include a clean:: target
clean::
	rm -f ./testSQLite testdb

test:
	rm -f testdb
	unicon -s -u testSQLite -x
