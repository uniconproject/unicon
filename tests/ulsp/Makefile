BASE = ../..
include ../Makedefs



export IPATH=$(UNI)/unidoc;$(UNI)/ulsp

progs=test_jsonrpc test_lsp_protocol test_lsp_feature test_lsp_message lsp_test_suite

.PHONY: default

default: test-long

%.u: %.icn
	@$(UC) $(UFLAGS) $<

include $(BASE)/Makedefs.uni


test_jsonrpc: test_jsonrpc.u
	$(UC) -DSTANDALONE test_jsonrpc.icn

test_lsp_protocol: test_lsp_protocol.u
	$(UC) -DSTANDALONE test_lsp_protocol.icn

test_lsp_feature: test_lsp_feature.u
	$(UC) -DSTANDALONE test_lsp_feature.icn

test_lsp_message: test_lsp_message.u
	$(UC) -DSTANDALONE test_lsp_message.icn

lsp_test_suite.u: test_lsp_message.u test_lsp_feature.u test_lsp_protocol.u test_jsonrpc.u
	$(UC) -c lsp_test_suite.icn

lsp_test_suite: lsp_test_suite.u test_lsp_message.u test_lsp_feature.u test_lsp_protocol.u test_jsonrpc.u
	$(UC) -o lsp_test_suite lsp_test_suite.u test_lsp_message.u test_lsp_feature.u test_lsp_protocol.u test_jsonrpc.u

test-short: lsp_test_suite
	@echo "Running LSP Integration tests..."
	./lsp_test_suite

Test test test-long: lsp_test_suite
	@echo "Running LSP Integration tests..."
	./lsp_test_suite -l

test-debug: lsp_test_suite
	@echo "Running LSP Integration tests..."
	./lsp_test_suite -d

test-lsp: test_lsp_protocol test_lsp_feature test_lsp_message test_jsonrpc
	@echo "Running JSON-RPC tests..."
	./test_jsonrpc
	@echo ""
	@echo "Running LSP message tests..."
	./test_lsp_message
	@echo ""
	@echo "Running LSP feature tests..."
	./test_lsp_feature
	@echo ""
	@echo "Running LSP protocol tests..."
	./test_lsp_protocol

clean Clean:
	$(RM) -f $(progs) *.u uniclass*
