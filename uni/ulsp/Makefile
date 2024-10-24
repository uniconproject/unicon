BASE = ../..
include $(BASE)/Makedefs.uni

UFLAGS=-s -u

prog=ulsp

SRC=launch-lsp.icn workspace.icn database.icn server.icn completion.icn signature.icn hover.icn definition.icn context.icn resources.icn
OBJ=launch-lsp.u workspace.u database.u server.u completion.u signature.u hover.u definition.u context.u resources.u

export IPATH=$(UNI)/unidoc

.PHONY: all

all: $(prog)

$(prog): $(OBJ)
	$(UC) -o $(prog) $(OBJ)
	$(CP) $(prog)$(EXE) ../../bin

launch-lsp.u:launch-lsp.icn server.u
resources.u:resources.icn database.u
database.u:database.icn
context.u:context.icn resources.u
workspace.u:workspace.icn resources.u context.u
server.u:server.icn workspace.u resources.u completion.u signature.u hover.u definition.u
completion.u:completion.icn resources.u context.u
signature.u:signature.icn resources.u context.u
hover.u:hover.icn resources.u context.u
definition.u: definition.icn resources.u context.u

zip:
	zip ulsp.zip Makefile *.icn

clean:
	$(RM) -f *.u $(prog) uniclass*
