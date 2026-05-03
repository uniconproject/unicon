include ../../Makedefs

LDLIBS = -pthread

TLS_BENCH_BIN = tls_state_bench
TLS_BENCH_SRC = tls_state_bench.c

.PHONY: tls_bench clean Clean

tls_bench: $(TLS_BENCH_BIN)
	./$(TLS_BENCH_BIN) $(TLS_BENCH_ARGS)

$(TLS_BENCH_BIN): $(TLS_BENCH_SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< $(LDLIBS)

clean Clean:
	$(RM) $(TLS_BENCH_BIN)
