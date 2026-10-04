#define _POSIX_C_SOURCE 200809L

/*
 * Micro-benchmark for TLS / threading access patterns.
 * Single binary runs all four modes back-to-back:
 *   gcc -O2 -std=c11 -o tls-bench tls_state_bench.c -lpthread
 *
 * Run: ./tls-bench
 * Optional first arg is iterations in millions (default 500 → 500e6 per mode).
 *
 * Modes (run in order):
 *   pthread_key — pthread_getspecific each iteration (legacy CURTSTATE-like path)
 *   compiler_tls — read a _Thread_local pointer each iteration
 *   atomic — relaxed atomic_fetch_add only (no TLS); sync primitive baseline
 *   mutex — pthread_mutex lock/unlock around a counter (no TLS); uncontended
 */

#include <pthread.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct { int v; } bench_cell_t;

static pthread_key_t tls_key;
static bench_cell_t storage;

static _Thread_local bench_cell_t *tls_ptr;

static atomic_ulong atomic_counter;

static pthread_mutex_t bench_mtx = PTHREAD_MUTEX_INITIALIZER;
static unsigned long mutex_counter;

static unsigned long iter_millions = 100;
static unsigned long iterations;

static volatile uintptr_t bench_sink;

/*
 * Volatile load of the pointer stored in the TLS slot (READ_ONCE style).
 * noinline so the TLS load is not hoisted across the whole loop at -O2.
 */
__attribute__((noinline)) static bench_cell_t *bench_load_tls_ptr(void)
{
   return (bench_cell_t *)(*(volatile bench_cell_t **)&tls_ptr);
}

static void *worker_pthread_key(void *arg)
{
   (void)arg;
   pthread_setspecific(tls_key, &storage);
   for (unsigned long i = 0; i < iterations; i++) {
      volatile void *p = pthread_getspecific(tls_key);
      (void)p;
   }
   return NULL;
}

static void *worker_compiler_tls(void *arg)
{
   (void)arg;
   static bench_cell_t local;
   tls_ptr = &local;
   for (unsigned long i = 0; i < iterations; i++) {
      bench_cell_t *p = bench_load_tls_ptr();
      bench_sink ^= (uintptr_t)p + i;
   }
   return NULL;
}

static void *worker_atomic(void *arg)
{
   (void)arg;
   for (unsigned long i = 0; i < iterations; i++) {
      bench_sink ^= i;
      atomic_fetch_add_explicit(&atomic_counter, 1UL, memory_order_relaxed);
   }
   return NULL;
}

static void *worker_mutex(void *arg)
{
   (void)arg;
   for (unsigned long i = 0; i < iterations; i++) {
      bench_sink ^= i;
      pthread_mutex_lock(&bench_mtx);
      mutex_counter++;
      pthread_mutex_unlock(&bench_mtx);
   }
   return NULL;
}

static void print_table_header(void)
{
   printf("%-18s %20s %14s %12s\n",
          "mode", "iter (M)", "time_s", "Miter/s");
   printf("%-18s %20s %14s %12s\n",
          "------------------", "--------------------", "--------------", "------------");
}

static void print_table_row(const char *label, double sec)
{
   if (sec > 0.0) {
      double miter = (iterations / 1e6) / sec;
      printf("%-18s %20lu %14.6f %12.2f\n",
             label, iter_millions, sec, miter);
   } else {
      printf("%-18s %20lu %14.6f %12s\n",
             label, iter_millions, sec, "n/a");
   }
}

static int run_one(const char *label, void *(*worker)(void *), double *elapsed_out)
{
   struct timespec t0, t1;
   clock_gettime(CLOCK_MONOTONIC, &t0);
   pthread_t th;
   if (pthread_create(&th, NULL, worker, NULL) != 0) {
      perror("pthread_create");
      return 1;
   }
   pthread_join(th, NULL);
   clock_gettime(CLOCK_MONOTONIC, &t1);
   double sec = (t1.tv_sec - t0.tv_sec) + (t1.tv_nsec - t0.tv_nsec) / 1e9;
   print_table_row(label, sec);
   if (elapsed_out != NULL)
      *elapsed_out = sec;
   return 0;
}

int main(int argc, char **argv)
{
   if (argc > 1) {
      char *end = NULL;
      unsigned long v = strtoul(argv[1], &end, 10);
      if (end == argv[1] || *end != '\0' || v == 0) {
         fprintf(stderr, "usage: %s [iterations_millions]\n", argv[0]);
         return 1;
      }
      iter_millions = v;
   }

   iterations = iter_millions * 1000000UL;

   if (pthread_key_create(&tls_key, NULL) != 0) {
      perror("pthread_key_create");
      return 1;
   }

   print_table_header();

   double t_pthread_key = 0.0, t_compiler_tls = 0.0;
   double t_atomic = 0.0, t_mutex = 0.0;

   if (run_one("pthread_key", worker_pthread_key, &t_pthread_key) != 0)
      goto fail_key;

   if (run_one("compiler_tls", worker_compiler_tls, &t_compiler_tls) != 0)
      goto fail_key;

   atomic_store_explicit(&atomic_counter, 0UL, memory_order_relaxed);
   if (run_one("atomic", worker_atomic, &t_atomic) != 0)
      goto fail_key;
   if (atomic_load_explicit(&atomic_counter, memory_order_relaxed) != iterations) {
      fprintf(stderr, "atomic_counter mismatch (expected %lu)\n", iterations);
      pthread_key_delete(tls_key);
      return 1;
   }

   mutex_counter = 0;
   if (run_one("mutex", worker_mutex, &t_mutex) != 0)
      goto fail_key;
   if (mutex_counter != iterations) {
      fprintf(stderr, "mutex_counter %lu != iterations %lu\n", mutex_counter,
              iterations);
      pthread_key_delete(tls_key);
      return 1;
   }

   if (t_compiler_tls > 0.0)
      printf("pthread_key/compiler_tls: %.3f\n",
             t_pthread_key / t_compiler_tls);
   if (t_atomic > 0.0)
      printf("mutex/atomic: %.3f\n", t_mutex / t_atomic);

   pthread_key_delete(tls_key);
   return 0;

fail_key:
   pthread_key_delete(tls_key);
   return 1;
}
