BASE=../..
include ../makedefs

all:	ivibmigrate

clean:	
	$(RM) ivibmigrate \
              *.u uniclass.dir uniclass.pag 

ivibmigrate : ivibmigrate.icn
	$(UNICON) ivibmigrate.icn
	$(CP) ivibmigrate$(EXE) $(BIN)
