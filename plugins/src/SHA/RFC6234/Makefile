#CFLAGS = -D ORIGINAL_SHA_CODE_NOT_THREAD_SAFE -D USE_32BIT_ONLY
TOPDIR=../../../..
include ../../Makedefs

default:	shatest

shatest:	shatest.o sha1.o sha224-256.o sha384-512.o usha.o hkdf.o hmac.o

clean::
	rm -f shatest *.o 




