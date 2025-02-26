BASE = ../..
include $(BASE)/Makedefs.uni

UFLAGS=-s -u

prog=ulsp

SRC=launch-lsp.icn filespace.icn database.icn server.icn completion.icn signature.icn hover.icn \
	definition.icn jsonrpc.icn logger.icn lsif.icn
OBJ=launch-lsp.u filespace.u database.u server.u completion.u signature.u hover.u definition.u \
	jsonrpc.u logger.u lsif.u

export IPATH=$(UNI)/unidoc

.PHONY: all

all: $(prog)
$(prog): $(OBJ)
	$(UC) -o $(prog) $(OBJ)
	$(CP) -f $(prog)$(EXE) ../../bin

jsonrpc-test: jsonrpc-test.u jsonrpc.u
	$(UC) -o jsonrpc-test jsonrpc-test.u jsonrpc.u

launch-lsp.u:launch-lsp.icn filespace.u database.u server.u completion.u signature.u hover.u definition.u

server.u:server.icn database.u completion.u filespace.u signature.u hover.u definition.u jsonrpc.u logger.u
hover.u:hover.icn signature.u
definition.u: definition.icn hover.u
lsif.u: lsif.icn

zip:
	zip ulsp.zip Makefile *.icn

clean:
	$(RM) -f *.u $(prog) uniclass*
