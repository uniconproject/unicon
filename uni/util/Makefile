BASE=../..
include $(BASE)/Makedefs.uni

all:	ivibmigrate$(EXE)

clean:	
	$(RM) ivibmigrate$(EXE) \
              *.u uniclass.dir uniclass.pag uniclass.db

ivibmigrate$(EXE) : ivibmigrate.icn
	$(UNICON) $(UFLAGS) ivibmigrate.icn
	$(CP) ivibmigrate$(EXE) $(BIN)
