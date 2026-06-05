/*
 * C11 threading/atomic surface: RTT parses _Atomic(...) and thread_local;
 * stdatomic.h / threads.h remain for real runtime via #passthru / #host.
 */

int rtt_c11_concurrency_probe(void)
{
   thread_local static int rtt_tls_slot;
   _Atomic(unsigned int) rtt_atomic_slot;
   atomic_int *rtt_ai = 0;

   (void)rtt_tls_slot;
   (void)rtt_atomic_slot;
   (void)rtt_ai;
   return 0;
}
