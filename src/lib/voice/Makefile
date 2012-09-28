# Ziad Al-Sharif	2/11/2005

SUBDIRS = jthread-1.1.1 jrtplib-3.1.0 jvoiplib-1.3.0


LIBRARYNAME = libvoip
ARCHIVE = $(LIBRARYNAME).a


INCLUDES		= -I jvoiplib-1.3.0/include -I jthread-1.1.1/include -I jrtplib-3.1.0 
LIBRARIES		= -L. ../../../bin/libjvoip.a ../../../bin/libjthread.a ../../../bin/libjrtp.a 
#-ljrtp -ljthread -lpthread 

ARFLAGS = qc

# Flags and objects

CC 	= g++
FLAGS 	= -g
OBJECTS =  voip.o #PlaySound.o


# Rules to make the compilation possible

.SUFFIXES: .cpp

.cpp.o:
	$(CC) $(FLAGS) $(INCLUDES) -c -o $@ $< 

all: jvoip_libs staticlib #clean

jvoip_libs: 
	@for i in $(SUBDIRS) ; do\
		if ! (cd $$i && ./configure && make ) ; then\
			exit 1;\
		fi;\
	done
	
	mv jrtplib-3.1.0/src/.libs/libjrtp.a  ../../../bin/libjrtp.a


staticlib: $(ARCHIVE)

$(ARCHIVE): $(OBJECTS)
	rm -f $(ARCHIVE)
	ar $(ARFLAGS) $(ARCHIVE) $(OBJECTS)
	mv libvoip.a  ../../../bin/libvoip.a

voip.o : voip.cpp

Clean:	
	rm -f *.o
	@for i in $(SUBDIRS) ; do\
		if ! (cd $$i && make clean ) ; then\
			exit 1;\
		fi;\
	done
