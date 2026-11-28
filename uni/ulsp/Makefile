BASE = ../..
UNICON_TOP_BUILDDIR ?= $(BASE)
include $(UNICON_TOP_BUILDDIR)/Makedefs.uni

UFLAGS=-s -u

prog=ulsp

SRC=launch-lsp.icn uri.icn diagnostics.icn file_handler.icn database.icn server.icn completion.icn signature.icn hover.icn \
	definition.icn lsif.icn symbols.icn folding.icn unifmt.icn formatting.icn scopes.icn references.icn
OBJ=launch-lsp.u uri.u diagnostics.u file_handler.u database.u server.u completion.u signature.u hover.u definition.u \
	lsif.u symbols.u folding.u unifmt.u formatting.u scopes.u references.u

export IPATH=$(UNI)/unidoc

.PHONY: all

all: $(prog)
$(prog): $(OBJ)
	$(UC) -o $(prog) $(OBJ)
	$(CP) $(prog)$(EXE) ../../bin

jsonrpc-test: jsonrpc-test.u
	$(UC) -o jsonrpc-test jsonrpc-test.u

launch-lsp.u:launch-lsp.icn file_handler.u database.u server.u completion.u signature.u hover.u \
				 definition.u symbols.u folding.u formatting.u

server.u:server.icn uri.u diagnostics.u references.u database.u completion.u file_handler.u signature.u hover.u definition.u \
		   symbols.u folding.u formatting.u
hover.u:hover.icn signature.u
definition.u: definition.icn hover.u
formatting.u: formatting.icn unifmt.u diagnostics.u
scopes.u: scopes.icn unifmt.u formatting.u
references.u: references.icn scopes.u
file_handler.u: file_handler.icn scopes.u

zip:
	zip ulsp.zip Makefile *.icn

clean:
	$(RM) -f *.u $(prog) uniclass*