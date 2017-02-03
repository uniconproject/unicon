include ../../Makedefs

export IPATH:=$(UNI)/lib $(UNI)/unicon $(UNI)/gui $(UNI)/xml $(ICON_IPL)/lib
export LPATH:=$(UNI)/gui $(ICON_IPL)/incl $(ICON_IPL)/gincl  $(ICON_IPL)/mincl

UC=../../bin/unicon
WUC=../../bin/unicon -G
UFLAGS=-s -c -u
SO=so

# list of libraries
LXC=lxcunicon



all: uso.u $(LXC)


# Each dynamic library should have two rules

# LXC rules:
$(LXC): $(LXC).$(SO) $(LXC).u
	cp  $(LXC).$(SO) $(LXC).u uniclass.* ../lib/

$(LXC).$(SO): $(LXC).u $(LXC).o
	$(CC) -D_GNU_SOURCE -std=c11 -shared -fpic -o $(LXC).$(SO) $(LXC).o -llxc

# Foo rules

#1

#2


# Generic rules

%.u:	%.icn
	 $(UC) $(UFLAGS) $<

%.o:	%.c
	 $(CC) $(CFLAGS) -D_GNU_SOURCE -std=c11 -shared -fpic -c $<

zip:
	 zip uso.zip makefile *.icn *.c *.h

clean:
	$(RM) *.u *.o *.$(SO) uniclass.dir uniclass.pag *~
