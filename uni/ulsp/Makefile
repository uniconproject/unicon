BASE = ../..
include $(BASE)/Makedefs.uni

prog=ulsp

SRC=launch-lsp.icn workspace.icn database.icn server.icn completion.icn
OBJ=launch-lsp.u workspace.u database.u server.u completion.u

export IPATH=$(UNI)/unidoc

$(prog): $(OBJ)
	$(UC) $(DASHG) -o $(prog) $(OBJ)
	$(CP) $(prog)$(EXE) ../../bin

launch-lsp.u:launch-lsp.icn workspace.u database.u server.u completion.u
workspace.u:workspace.icn
database.u:database.icn
server.u:server.icn database.u completion.u workspace.u
completion.u:completion.icn

zip:
	 zip ulsp.zip Makefile *.icn

clean:
	$(RM) -f *.u $(prog) uniclass*
