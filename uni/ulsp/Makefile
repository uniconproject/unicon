BASE = ../..
include $(BASE)/Makedefs.uni

progs=unicon-lsp

SRC=launch-lsp.icn workspace.icn database.icn server.icn completion.icn
OBJ=launch-lsp.u workspace.u database.u server.u completion.u

default=$(progs)

export IPATH=$(UNI)/unidoc

unicon-lsp: $(OBJ)
	$(UC) $(DASHG) -o unicon-lsp $(OBJ)
	$(CP) unicon-lsp$(EXE) ../../bin

launch-lsp.u:launch-lsp.icn workspace.u database.u server.u completion.u
workspace.u:workspace.icn
database.u:database.icn
server.u:server.icn database.u completion.u workspace.u
completion.u:completion.icn

clean:
	$(RM) -f *.u $(progs) uniclass*
