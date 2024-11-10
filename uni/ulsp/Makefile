BASE = ../..
include $(BASE)/Makedefs.uni

UFLAGS=-s -u

prog=ulsp

SRC=launch-lsp.icn workspace.icn database.icn server.icn completion.icn signature.icn hover.icn \
	definition.icn jsonrpc.icn logger.icn
OBJ=launch-lsp.u workspace.u database.u server.u completion.u signature.u hover.u definition.u \
	jsonrpc.u logger.u

export IPATH=$(UNI)/unidoc

.PHONY: all

all: $(prog)
$(prog): $(OBJ)
	$(UC) -o $(prog) $(OBJ)
	$(CP) $(prog)$(EXE) ../../bin

jsonrpc-test: jsonrpc-test.u jsonrpc.u
	$(UC) -o jsonrpc-test jsonrpc-test.u jsonrpc.u

launch-lsp.u:launch-lsp.icn workspace.u database.u server.u completion.u signature.u hover.u definition.u

server.u:server.icn database.u completion.u workspace.u signature.u hover.u definition.u jsonrpc.u logger.u
hover.u:hover.icn signature.u
definition.u: definition.icn hover.u

zip:
	zip ulsp.zip Makefile *.icn

clean:
	$(RM) -f *.u $(prog) uniclass*
