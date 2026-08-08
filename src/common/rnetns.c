/*
 * rnetns.c - Linux network-namespace helpers for open(...,"j") /
 * fork / spawn / system.  Plain C (not RTT) because the implementation
 * needs uid_t, struct ifreq, etc.; lives in src/common with other C helpers.
 *
 * Requires CAP_NET_ADMIN (or a prior userns=yes bootstrap) for unshare/mount.
 */

#include "../h/config.h"

#if HAVE_NETNS

#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sched.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <net/if.h>
#include <netinet/in.h>

/* Must match struct NetnsFile in ../h/rstructs.h */
struct NetnsFile {
   char *name;
   char *path;
   int persist;
   int userns;
   int refcount;
   };

struct NetnsFile *netns_create(char *name, int persist, int bridge, int userns);
int netns_join(struct NetnsFile *ns);
void netns_hold(struct NetnsFile *ns);
void netns_release(struct NetnsFile *ns);
int netns_userns_active(void);

static int netns_userns_bootstrapped = 0;

/*
 * Host uid used for /tmp/unicon-netns-<uid> pin directories.
 * Captured before any userns bootstrap: after NEWUSER, geteuid() is 0
 * and must not select /tmp/unicon-netns-0 (often owned by another user
 * who previously bootstrapped, which then fails the ownership check).
 */
static uid_t netns_host_uid;
static int netns_host_uid_valid = 0;

static void netns_remember_host_uid(void)
{
   if (!netns_host_uid_valid) {
      netns_host_uid = getuid();
      netns_host_uid_valid = 1;
      }
}

static uid_t netns_pin_uid(void)
{
   netns_remember_host_uid();
   return netns_host_uid;
}

/*
 * Live-handle table for crash / signal cleanup.  close() tears down
 * mounts on the last release; SIGKILL still orphans pins, but normal
 * exit, SIGINT, and SIGTERM walk this table and umount what remains.
 */
static struct NetnsFile **netns_live = NULL;
static size_t netns_live_n = 0;
static size_t netns_live_cap = 0;
static int netns_reaper_installed = 0;
static pid_t netns_owner_pid = 0;

/* Umount/unlink pins only — safe enough for atexit and signal paths. */
static void netns_dismount(struct NetnsFile *ns)
{
   char persist_path[PATH_MAX];

   if (ns == NULL)
      return;
   if (ns->path) {
      umount2(ns->path, MNT_DETACH);
      unlink(ns->path);
      }
   if (ns->persist && ns->name) {
      snprintf(persist_path, sizeof(persist_path), "/var/run/netns/%s",
               ns->name);
      umount2(persist_path, MNT_DETACH);
      unlink(persist_path);
      }
}

/*
 * Only the process that installed the reaper may tear down pins.
 * fork() children share the mount namespace and inherit atexit handlers;
 * if they ran cleanup they would unmount the parent's live handles.
 */
static int netns_is_owner(void)
{
   return netns_owner_pid != 0 && getpid() == netns_owner_pid;
}

static void netns_cleanup_all(void)
{
   size_t i;

   if (!netns_is_owner())
      return;
   for (i = 0; i < netns_live_n; i++)
      netns_dismount(netns_live[i]);
   netns_live_n = 0;
}

static void netns_atexit(void)
{
   netns_cleanup_all();
}

static void netns_onsignal(int sig)
{
   struct sigaction sa;

   netns_cleanup_all();
   memset(&sa, 0, sizeof(sa));
   sa.sa_handler = SIG_DFL;
   sigemptyset(&sa.sa_mask);
   sigaction(sig, &sa, NULL);
   raise(sig);
}

static void netns_install_reaper(void)
{
   struct sigaction sa, old;

   if (netns_reaper_installed)
      return;
   netns_reaper_installed = 1;
   netns_owner_pid = getpid();
   atexit(netns_atexit);

   memset(&sa, 0, sizeof(sa));
   sa.sa_handler = netns_onsignal;
   sigemptyset(&sa.sa_mask);
   sa.sa_flags = 0;
   /* Do not override an existing non-default handler (e.g. Unicon trap). */
   if (sigaction(SIGINT, NULL, &old) == 0 && old.sa_handler == SIG_DFL)
      sigaction(SIGINT, &sa, NULL);
   if (sigaction(SIGTERM, NULL, &old) == 0 && old.sa_handler == SIG_DFL)
      sigaction(SIGTERM, &sa, NULL);
}

static int netns_register(struct NetnsFile *ns)
{
   if (ns == NULL)
      return -1;
   if (netns_live_n >= netns_live_cap) {
      size_t ncap = netns_live_cap ? netns_live_cap * 2 : 8;
      struct NetnsFile **p =
         realloc(netns_live, ncap * sizeof(*netns_live));
      if (p == NULL)
         return -1;
      netns_live = p;
      netns_live_cap = ncap;
      }
   netns_live[netns_live_n++] = ns;
   netns_install_reaper();
   return 0;
}

static void netns_unregister(struct NetnsFile *ns)
{
   size_t i;

   for (i = 0; i < netns_live_n; i++) {
      if (netns_live[i] == ns) {
         netns_live[i] = netns_live[--netns_live_n];
         return;
         }
      }
}

int netns_userns_active(void)
{
   return netns_userns_bootstrapped;
}

/* Write exactly len bytes; returns 0 on success, -1 on error. */
static int netns_write_full(int fd, const char *buf, size_t len)
{
   ssize_t n;

   while (len > 0) {
      n = write(fd, buf, len);
      if (n < 0) {
         if (errno == EINTR)
            continue;
         return -1;
         }
      buf += n;
      len -= (size_t)n;
      }
   return 0;
}

/*
 * Write path from a process still in the host userns (the helper).
 * Self-writes of uid_map after unshare(CLONE_NEWUSER) are rejected with
 * EPERM on hosts that restrict unprivileged userns (e.g. AppArmor
 * kernel.apparmor_restrict_unprivileged_userns=1).
 */
static int netns_write_map_file(pid_t pid, const char *which, const char *data)
{
   char path[64];
   int fd;
   size_t len = strlen(data);

   if (snprintf(path, sizeof(path), "/proc/%ld/%s", (long)pid, which) >=
       (int)sizeof(path)) {
      errno = ENAMETOOLONG;
      return -1;
      }
   fd = open(path, O_WRONLY);
   if (fd < 0)
      return -1;
   if (netns_write_full(fd, data, len) < 0) {
      close(fd);
      return -1;
      }
   close(fd);
   return 0;
}

/*
 * Map calling uid/gid to 0 inside a new user namespace so CAP_NET_ADMIN
 * works unprivileged.  Also enter a fresh mount namespace and make the
 * tree private so later bind-mounts of /proc/self/ns/net succeed
 * (CLONE_NEWNET alone is not enough without CAP_SYS_ADMIN on the host
 * mount namespace).  Fails with EINVAL if the process is already
 * multithreaded — caller must surface that reason explicitly.
 *
 * uid/gid maps are written by a short-lived fork() helper that stays in
 * the host userns; the main process unshare(CLONE_NEWUSER)s, then the
 * helper writes /proc/<main>/{setgroups,gid_map,uid_map}.  See design
 * doc §3.7.
 */
static int netns_bootstrap_userns(void)
{
   char mapbuf[64];
   uid_t uid;
   gid_t gid;
   int sync_to_helper[2];   /* main -> helper: 'U' = unshared, ready for maps */
   int sync_from_helper[2]; /* helper -> main: 'M' = maps written, or 'E' */
   pid_t helper;
   pid_t self;
   char msg;
   int status;
   int saved_errno;

   if (netns_userns_bootstrapped)
      return 0;

   /* Freeze pin-dir uid before getuid() becomes 0 inside the userns. */
   netns_remember_host_uid();

   uid = getuid();
   gid = getgid();
   self = getpid();

   if (pipe2(sync_to_helper, O_CLOEXEC) < 0)
      return -1;
   if (pipe2(sync_from_helper, O_CLOEXEC) < 0) {
      close(sync_to_helper[0]);
      close(sync_to_helper[1]);
      return -1;
      }

   helper = fork();
   if (helper < 0) {
      saved_errno = errno;
      close(sync_to_helper[0]);
      close(sync_to_helper[1]);
      close(sync_from_helper[0]);
      close(sync_from_helper[1]);
      errno = saved_errno;
      return -1;
      }

   if (helper == 0) {
      /* Helper: remain in host userns; write maps for the parent. */
      close(sync_to_helper[1]);
      close(sync_from_helper[0]);

      if (read(sync_to_helper[0], &msg, 1) != 1 || msg != 'U')
         _exit(1);
      close(sync_to_helper[0]);

      if (netns_write_map_file(self, "setgroups", "deny") < 0 &&
          errno != ENOENT)
         goto helper_fail;

      if (snprintf(mapbuf, sizeof(mapbuf), "0 %u 1", (unsigned)gid) >=
          (int)sizeof(mapbuf))
         goto helper_fail;
      if (netns_write_map_file(self, "gid_map", mapbuf) < 0)
         goto helper_fail;

      if (snprintf(mapbuf, sizeof(mapbuf), "0 %u 1", (unsigned)uid) >=
          (int)sizeof(mapbuf))
         goto helper_fail;
      if (netns_write_map_file(self, "uid_map", mapbuf) < 0)
         goto helper_fail;

      msg = 'M';
      if (netns_write_full(sync_from_helper[1], &msg, 1) < 0)
         _exit(1);
      close(sync_from_helper[1]);
      _exit(0);

   helper_fail:
      msg = 'E';
      (void)netns_write_full(sync_from_helper[1], &msg, 1);
      close(sync_from_helper[1]);
      _exit(1);
      }

   /* Main: enter userns, then let helper write our maps. */
   close(sync_to_helper[0]);
   close(sync_from_helper[1]);

   /*
    * NEWUSER first (so uid/gid maps can be written), then NEWNS once
    * we are "root" in the user namespace.  Combining both flags in one
    * unshare() causes map writes to fail with EPERM on some kernels.
    */
   if (unshare(CLONE_NEWUSER) < 0) {
      saved_errno = errno;
      close(sync_to_helper[1]);
      close(sync_from_helper[0]);
      waitpid(helper, NULL, 0);
      errno = saved_errno;
      return -1;
      }

   msg = 'U';
   if (netns_write_full(sync_to_helper[1], &msg, 1) < 0) {
      saved_errno = errno;
      close(sync_to_helper[1]);
      close(sync_from_helper[0]);
      waitpid(helper, NULL, 0);
      errno = saved_errno;
      return -1;
      }
   close(sync_to_helper[1]);

   if (read(sync_from_helper[0], &msg, 1) != 1 || msg != 'M') {
      close(sync_from_helper[0]);
      waitpid(helper, NULL, 0);
      errno = EPERM;
      return -1;
      }
   close(sync_from_helper[0]);

   if (waitpid(helper, &status, 0) < 0 || !WIFEXITED(status) ||
       WEXITSTATUS(status) != 0) {
      errno = EPERM;
      return -1;
      }

   if (unshare(CLONE_NEWNS) < 0)
      return -1;

   /*
    * Cut propagation to the host mount ns before any new mounts.
    * SLAVE first, then PRIVATE — PRIVATE alone is not always enough
    * when the copied tree is still in a shared peer group; otherwise
    * the tmpfs below leaks onto the host /run/netns (ENOSPC after
    * enough runs).
    */
   if (mount("none", "/", NULL, MS_REC | MS_SLAVE, NULL) < 0)
      return -1;
   if (mount("none", "/", NULL, MS_REC | MS_PRIVATE, NULL) < 0)
      return -1;

   /*
    * Host /var/run/netns (often the same as /run/netns) is frequently
    * not writable to a mapped-root userns — persist=yes and `ip netns`
    * both need it.  Overlay a private tmpfs so bind-mounts and ip(8)
    * work inside this mount namespace without touching the real host
    * directory.
    */
   if (mkdir("/var/run/netns", 0755) < 0 && errno != EEXIST)
      return -1;
   if (mount("tmpfs", "/var/run/netns", "tmpfs", MS_NOSUID | MS_NODEV,
             "mode=0755") < 0)
      return -1;

   netns_userns_bootstrapped = 1;
   return 0;
}

/* Bring lo up inside the current network namespace. */
static int netns_up_lo(void)
{
   struct ifreq ifr;
   int s, rv;

   s = socket(AF_INET, SOCK_DGRAM, 0);
   if (s < 0)
      return -1;
   memset(&ifr, 0, sizeof(ifr));
   strncpy(ifr.ifr_name, "lo", IFNAMSIZ - 1);
   if (ioctl(s, SIOCGIFFLAGS, &ifr) < 0) {
      close(s);
      return -1;
      }
   ifr.ifr_flags |= IFF_UP;
   rv = ioctl(s, SIOCSIFFLAGS, &ifr);
   close(s);
   return rv;
}

/*
 * Create an empty file used as a bind-mount target for /proc/self/ns/net.
 */
static int netns_touch(const char *path)
{
   int fd;

   fd = open(path, O_RDONLY | O_CREAT | O_EXCL, 0);
   if (fd < 0)
      return -1;
   close(fd);
   return 0;
}

/*
 * Ensure privdir is a directory owned by host_uid with mode 0700
 * (not a symlink or another user's pre-created trap under /tmp).
 */
static int netns_ensure_privdir(const char *privdir, uid_t host_uid)
{
   struct stat st;

   if (mkdir(privdir, 0700) < 0 && errno != EEXIST)
      return -1;

   if (lstat(privdir, &st) < 0)
      return -1;
   if (!S_ISDIR(st.st_mode) || S_ISLNK(st.st_mode)) {
      errno = ENOTDIR;
      return -1;
      }
   /*
    * Owner must be the host pin uid, or geteuid() after userns maps
    * that host uid to 0 (stat then reports st_uid == 0).
    */
   if (st.st_uid != host_uid && st.st_uid != geteuid()) {
      errno = EPERM;
      return -1;
      }
   /* Reject group/other access; another user must not write pin paths. */
   if ((st.st_mode & 077) != 0) {
      if (chmod(privdir, 0700) < 0)
         return -1;
      if (lstat(privdir, &st) < 0)
         return -1;
      if ((st.st_mode & 077) != 0) {
         errno = EPERM;
         return -1;
         }
      }
   return 0;
}

static void netns_free(struct NetnsFile *ns)
{
   if (ns == NULL)
      return;
   free(ns->name);
   free(ns->path);
   free(ns);
}

void netns_hold(struct NetnsFile *ns)
{
   if (ns == NULL)
      return;
   ns->refcount++;
}

void netns_release(struct NetnsFile *ns)
{
   if (ns == NULL)
      return;

   if (ns->refcount > 1) {
      ns->refcount--;
      return;
      }

   /* Last reference: drop bind-mount pins and free.  Kernel ns stays
    * alive via any process still setns()'d into it. */
   netns_unregister(ns);
   netns_dismount(ns);
   netns_free(ns);
}

int netns_join(struct NetnsFile *ns)
{
   int fd, rv;

   if (ns == NULL || ns->path == NULL) {
      errno = EINVAL;
      return -1;
      }
   fd = open(ns->path, O_RDONLY | O_CLOEXEC);
   if (fd < 0)
      return -1;
   rv = setns(fd, CLONE_NEWNET);
   close(fd);
   return rv;
}

/*
 * Create a network namespace named `name`.  Always bind-mounts onto a
 * private path under /tmp/unicon-netns/; with persist also onto
 * /var/run/netns/<name>.  Optional bridge=yes pre-creates bridge0.
 */
struct NetnsFile *netns_create(char *name, int persist, int bridge, int userns)
{
   struct NetnsFile *ns;
   char privdir[PATH_MAX];
   char privpath[PATH_MAX];
   char persist_path[PATH_MAX];
   pid_t pid;
   int status;
   int pipefd[2];
   char errbyte;

   if (name == NULL || name[0] == '\0' ||
       strchr(name, '/') != NULL || strcmp(name, ".") == 0 ||
       strcmp(name, "..") == 0) {
      errno = EINVAL;
      return NULL;
      }

   if (userns) {
      if (netns_bootstrap_userns() < 0)
         return NULL;
      }

   /* Use the pre-userns host uid so pin dirs stay per-user after NEWUSER. */
   if (snprintf(privdir, sizeof(privdir), "/tmp/unicon-netns-%u",
                (unsigned)netns_pin_uid()) >= (int)sizeof(privdir)) {
      errno = ENAMETOOLONG;
      return NULL;
      }
   if (netns_ensure_privdir(privdir, netns_pin_uid()) < 0)
      return NULL;

   /* Unique pin path under our private dir (avoids predictable name.pid). */
   if (snprintf(privpath, sizeof(privpath), "%s/ns.XXXXXX", privdir) >=
       (int)sizeof(privpath)) {
      errno = ENAMETOOLONG;
      return NULL;
      }
   {
      int tfd = mkstemp(privpath);
      if (tfd < 0)
         return NULL;
      close(tfd);
      }

   if (persist) {
      if (mkdir("/var/run/netns", 0755) < 0 && errno != EEXIST) {
         unlink(privpath);
         return NULL;
         }
      /*
       * Make /var/run/netns a mount point so bind mounts propagate the
       * way ip(8) expects.  Do NOT use st_dev equality — a bind mount
       * of a directory on the same tmpfs (/run) keeps the same st_dev
       * and would re-bind forever (ENOSPC after enough opens).
       * Probe like iproute2: MS_SHARED succeeds iff it is already a
       * mount point; otherwise bind onto self, then make shared.
       */
      if (mount("none", "/var/run/netns", "none",
                MS_SHARED | MS_REC, NULL) < 0) {
         if (errno == EINVAL) {
            if (mount("/var/run/netns", "/var/run/netns", "none",
                      MS_BIND | MS_REC, NULL) == 0)
               mount("none", "/var/run/netns", "none",
                     MS_SHARED | MS_REC, NULL);
            }
         }
      snprintf(persist_path, sizeof(persist_path), "/var/run/netns/%s", name);
      if (netns_touch(persist_path) < 0) {
         unlink(privpath);
         return NULL;
         }
      }

   if (pipe2(pipefd, O_CLOEXEC) < 0) {
      unlink(privpath);
      if (persist) unlink(persist_path);
      return NULL;
      }

   pid = fork();
   if (pid < 0) {
      close(pipefd[0]);
      close(pipefd[1]);
      unlink(privpath);
      if (persist) unlink(persist_path);
      return NULL;
      }

   if (pid == 0) {
      /* Child: create netns, bind-mount, bring lo up, optional bridge. */
      close(pipefd[0]);
      if (unshare(CLONE_NEWNET) < 0)
         goto child_fail;
      if (mount("/proc/self/ns/net", privpath, "none", MS_BIND, NULL) < 0)
         goto child_fail;
      if (persist) {
         if (mount("/proc/self/ns/net", persist_path, "none", MS_BIND, NULL) < 0)
            goto child_fail;
         }
      if (netns_up_lo() < 0)
         goto child_fail;
      if (bridge) {
         /* Best-effort; failure is not fatal to namespace creation. */
         int br = system("ip link add bridge0 type bridge >/dev/null 2>&1 && "
                         "ip link set bridge0 up >/dev/null 2>&1");
         (void)br;
         }
      errbyte = 0;
      if (write(pipefd[1], &errbyte, 1) != 1) { /* ignore */ }
      close(pipefd[1]);
      _exit(0);

   child_fail:
      errbyte = (char)(errno ? errno : EIO);
      if (write(pipefd[1], &errbyte, 1) != 1) { /* ignore */ }
      close(pipefd[1]);
      _exit(1);
      }

   /* Parent */
   close(pipefd[1]);
   if (read(pipefd[0], &errbyte, 1) != 1)
      errbyte = EIO;
   close(pipefd[0]);
   if (waitpid(pid, &status, 0) < 0 || !WIFEXITED(status) ||
       WEXITSTATUS(status) != 0 || errbyte != 0) {
      int saved = errbyte ? (unsigned char)errbyte : EIO;
      umount2(privpath, MNT_DETACH);
      unlink(privpath);
      if (persist) {
         umount2(persist_path, MNT_DETACH);
         unlink(persist_path);
         }
      errno = saved;
      return NULL;
      }

   ns = (struct NetnsFile *)calloc(1, sizeof(struct NetnsFile));
   if (ns == NULL)
      goto parent_fail;
   ns->name = strdup(name);
   ns->path = strdup(privpath);
   if (ns->name == NULL || ns->path == NULL) {
      netns_free(ns);
      ns = NULL;
      goto parent_fail;
      }
   ns->persist = persist;
   ns->userns = userns || netns_userns_bootstrapped;
   ns->refcount = 1;   /* held by the open() File until close() */
   if (netns_register(ns) < 0) {
      netns_free(ns);
      ns = NULL;
      goto parent_fail;
      }
   return ns;

parent_fail:
   umount2(privpath, MNT_DETACH);
   unlink(privpath);
   if (persist) {
      umount2(persist_path, MNT_DETACH);
      unlink(persist_path);
      }
   errno = ENOMEM;
   return NULL;
}

#endif /* HAVE_NETNS */
