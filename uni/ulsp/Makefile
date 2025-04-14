BASE = ../..
include $(BASE)/Makedefs.uni

UFLAGS=-s -u

prog=ulsp

SRC=launch-lsp.icn file_handler.icn database.icn server.icn completion.icn signature.icn hover.icn \
	definition.icn jsonrpc.icn logger.icn lsif.icn symbols.icn folding.icn formatting.icn
OBJ=launch-lsp.u file_handler.u database.u server.u completion.u signature.u hover.u definition.u \
	jsonrpc.u logger.u lsif.u symbols.u folding.u formatting.u

export IPATH=$(UNI)/unidoc

.PHONY: all

all: $(prog)
$(prog): $(OBJ)
	$(UC) -o $(prog) $(OBJ)
	$(CP) $(prog)$(EXE) ../../bin

jsonrpc-test: jsonrpc-test.u jsonrpc.u
	$(UC) -o jsonrpc-test jsonrpc-test.u jsonrpc.u

launch-lsp.u:launch-lsp.icn file_handler.u database.u server.u completion.u signature.u hover.u \
				 definition.u symbols.u folding.u formatting.u

server.u:server.icn database.u completion.u file_handler.u signature.u hover.u definition.u jsonrpc.u \
		   logger.u symbols.u folding.u formatting.u
hover.u:hover.icn signature.u
definition.u: definition.icn hover.u

zip:
	zip ulsp.zip Makefile *.icn

clean:
	$(RM) -f *.u $(prog) uniclass*