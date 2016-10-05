BASE=../..
include ../makedefs

all:	ivibmigrate$(EXE)

clean:	
	$(RM) ivibmigrate$(EXE) \
              *.u uniclass.dir uniclass.pag 

ivibmigrate$(EXE) : ivibmigrate.icn
	$(UNICON) $(UFLAGS) ivibmigrate.icn
	$(CP) ivibmigrate$(EXE) $(BIN)
