BASE = ../../..
include $(BASE)/Makedefs.uni

UFLAGS=-s -u

SRC=launch-dap.icn server.icn communicator.icn
OBJ=launch-dap.u server.u communicator.u

.PHONY:all

all: dapcom udap

udap: $(OBJ)
	$(UC) $(DASHG) -o udap $(OBJ)
	$(CP) udap$(EXE) ../../../bin

launch-dap.u:launch-dap.icn server.u
server.u:server.icn communicator.u
communicator.u:communicator.icn

dapcom:dapcom.icn
	$(UC) $(DASHG) -o dapcom dapcom.icn
	$(CP) dapcom$(EXE) ../../../bin

zip:
	zip udap.zip Makefile *.icn

clean:
	$(RM) -f *.u $(prog)$(EXE) uniclass* dapcom$(EXE)