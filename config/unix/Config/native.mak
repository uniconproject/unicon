BASE=../..
GCC=gcc
GCC_OPTS =

.PHONY: all clean

all : uniipclib.so libnativeutils.a

clean :
	rm -f *.u *.o *.so *.a

ipc.o : ipc.c
	$(GCC)  -fPIC -O2 \
		-I$(BASE)/src/h \
		-I- \
		-I. \
		-I$(BASE)/src/gdbm \
		-I$(BASE)/src/libtp \
		-c ipc.c

nativeutils.o : nativeutils.c
	$(GCC)  -fPIC -O2 \
		-I$(BASE)/src/h \
		-I- \
		-I. \
		-I$(BASE)/src/gdbm \
		-I$(BASE)/src/libtp \
		-c nativeutils.c

libnativeutils.a : nativeutils.o
	ar -r libnativeutils.a nativeutils.o

uniipclib.so : ipc.o libnativeutils.a
	$(GCC) -shared -o uniipclib.so -fPIC ipc.o libnativeutils.a
