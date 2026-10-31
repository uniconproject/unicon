#include "../h/gsupport.h"

/*
 * os_entropy - fill buf with n bytes from the operating system's
 *  cryptographically secure random source.  Returns 0 on success and -1
 *  if no such source is available or it fails; callers must then fall
 *  back to something weaker (e.g. the time-based seed in init.r).
 *
 * The sources, in order of preference:
 *   BSDs and macOS:        arc4random_buf(), which cannot fail
 *   Linux, glibc >= 2.25:  getentropy(), at most 256 bytes per call
 *   other UNIX:            /dev/urandom
 *   Windows:               RtlGenRandom (advapi32 SystemFunction036),
 *                          resolved at run time so no new link library
 *                          is needed
 */

#if defined(__APPLE__) || defined(__FreeBSD__) || defined(__OpenBSD__) \
   || defined(__NetBSD__) || defined(__DragonFly__)
   #define EntropyArc4random 1
   #include <stdlib.h>
#elif defined(__linux__) && defined(__GLIBC__) \
   && ((__GLIBC__ > 2) || (__GLIBC__ == 2 && __GLIBC_MINOR__ >= 25))
   #define EntropyGetentropy 1
   #include <unistd.h>
   #include <errno.h>
#endif

#if UNIX && !defined(EntropyArc4random)
   #include <fcntl.h>
   #include <unistd.h>
   #include <errno.h>
#endif                                  /* UNIX */

#if NT
   #include <windows.h>
#endif                                  /* NT */

#if UNIX && !defined(EntropyArc4random)
static int urandom_read(unsigned char *p, size_t n)
{
   int fd;
   ssize_t r;

#ifdef O_CLOEXEC
   fd = open("/dev/urandom", O_RDONLY | O_CLOEXEC);
#else                                   /* O_CLOEXEC */
   fd = open("/dev/urandom", O_RDONLY);
#endif                                  /* O_CLOEXEC */
   if (fd < 0)
      return -1;
   while (n > 0) {
      r = read(fd, p, n);
      if (r < 0 && errno == EINTR)
         continue;
      if (r <= 0) {
         close(fd);
         return -1;
         }
      p += r;
      n -= (size_t)r;
      }
   close(fd);
   return 0;
}
#endif                                  /* UNIX && !EntropyArc4random */

int os_entropy(void *buf, size_t n)
{
   unsigned char *p = (unsigned char *)buf;

   if (n == 0)
      return 0;
   if (p == NULL)
      return -1;

#if defined(EntropyArc4random)
   arc4random_buf(p, n);
   return 0;

#elif NT
   {
   typedef BOOLEAN (WINAPI *RtlGenRandomFn)(PVOID, ULONG);
   static RtlGenRandomFn genrandom = NULL;
   HMODULE lib;
   ULONG chunk;

   if (genrandom == NULL) {
      lib = LoadLibraryA("advapi32.dll");
      if (lib == NULL)
         return -1;
      genrandom = (RtlGenRandomFn)GetProcAddress(lib, "SystemFunction036");
      if (genrandom == NULL)
         return -1;
      }
   while (n > 0) {
      chunk = (n > 0x10000) ? 0x10000 : (ULONG)n;
      if (!genrandom(p, chunk))
         return -1;
      p += chunk;
      n -= chunk;
      }
   return 0;
   }

#elif UNIX
#ifdef EntropyGetentropy
   {
   size_t chunk;
   while (n > 0) {
      chunk = (n > 256) ? 256 : n;
      if (getentropy(p, chunk) != 0) {
         /* ENOSYS: running on a kernel without getrandom(2) */
         if (errno == ENOSYS)
            return urandom_read(p, n);
         return -1;
         }
      p += chunk;
      n -= chunk;
      }
   return 0;
   }
#else                                   /* EntropyGetentropy */
   return urandom_read(p, n);
#endif                                  /* EntropyGetentropy */

#else                                   /* no known source */
   return -1;
#endif
}
