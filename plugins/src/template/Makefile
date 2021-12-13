# Makefile example for a Unicon plugin
#
# Look for @Replace and change the line(s) that follow(s)  
#

# @Replace: What is the name of this library?
LNAME=template

# @Replace: add any additional (non-standard name) c source file(s) here
COBJ = $(LNAME).o 
CSRC = $(LNAME).c

# @Replace: If additional libraries need to be linked in append them here:
MYLIBS=$(LIBS)

# Relative to top level
TOPDIR=../../..

# lib relative to top
TDIR=../..

include ../Makedefs

default:	$(LIBD)/$(LNAME).u

# @Replace: To add plugin specific clean up actions, include a clean:: target
# n.b. clean:: not clean:
# For example
#clean::
#	$(RM) $(LNAME).test-results
