/*
 * Copyright 1997-2001 Shamim Mohamed.
 *
 * Modification and redistribution is permitted as long as this (and any
 * other) copyright notices are kept intact. If you make any changes,
 * please add a short note here with your name and what changes were
 * made.
 *
 * $Id: rposix.r,v 1.47 2011-01-05 21:36:22 jeffery Exp $
 */

#ifdef PosixFns

#include "../h/opdefs.h"

#define String(d, s) do {           \
      int len = strlen(s);          \
      StrLoc(d) = alcstr((s), len); \
      SetStrLen(d, len);              \
} while (0)

/*
 * Close a socket without clobbering errno.  On Windows, SOCKET handles
 * must be released with closesocket(); plain close() fails with EBADF
 * and would overwrite a more specific error (e.g. bad socket attribute).
 * Also drop per-fd metadata (UDP/raw destination addrinfo).
 */
static void sock_release_fd_meta(int fd);

void sock_close(int fd)
{
   int hold = errno;
   sock_release_fd_meta(fd);
#if NT
   closesocket(fd);
#else                                   /* NT */
   close(fd);
#endif                                  /* NT */
   errno = hold;
}

/* Padding for machines that have opcodes smaller than words */
#if IntBits != WordBits
#define ipad(wp)  do *(wp).op++ = Op_Noop; while (0)
#else
#define ipad(wp)  do ; while (0)
#endif

/* Signal definitions */
#passthru #if !defined(SIGABRT)
#passthru #define SIGABRT 0
#passthru #endif
#passthru #if !defined(SIGALRM)
#passthru #define SIGALRM 0
#passthru #endif
#passthru #if !defined(SIGBREAK)
#passthru #define SIGBREAK 0
#passthru #endif
#passthru #if !defined(SIGBUS)
#passthru #define SIGBUS 0
#passthru #endif
#passthru #if !defined(SIGCHLD)
#passthru #define SIGCHLD 0
#passthru #endif
#passthru #if !defined(SIGCLD)
#passthru #define SIGCLD 0
#passthru #endif
#passthru #if !defined(SIGCONT)
#passthru #define SIGCONT 0
#passthru #endif
#passthru #if !defined(SIGEMT)
#passthru #define SIGEMT 0
#passthru #endif
#passthru #if !defined(SIGFPE)
#passthru #define SIGFPE 0
#passthru #endif
#passthru #if !defined(SIGFREEZE)
#passthru #define SIGFREEZE 0
#passthru #endif
#passthru #if !defined(SIGHUP)
#passthru #define SIGHUP 0
#passthru #endif
#passthru #if !defined(SIGILL)
#passthru #define SIGILL 0
#passthru #endif
#passthru #if !defined(SIGINT)
#passthru #define SIGINT 0
#passthru #endif
#passthru #if !defined(SIGIO)
#passthru #define SIGIO 0
#passthru #endif
#passthru #if !defined(SIGIOT)
#passthru #define SIGIOT 0
#passthru #endif
#passthru #if !defined(SIGKILL)
#passthru #define SIGKILL 0
#passthru #endif
#passthru #if !defined(SIGLOST)
#passthru #define SIGLOST 0
#passthru #endif
#passthru #if !defined(SIGLWP)
#passthru #define SIGLWP 0
#passthru #endif
#passthru #if !defined(SIGPIPE)
#passthru #define SIGPIPE 0
#passthru #endif
#passthru #if !defined(SIGPOLL)
#passthru #define SIGPOLL 0
#passthru #endif
#passthru #if !defined(SIGPROF)
#passthru #define SIGPROF 0
#passthru #endif
#passthru #if !defined(SIGPWR)
#passthru #define SIGPWR 0
#passthru #endif
#passthru #if !defined(SIGQUIT)
#passthru #define SIGQUIT 0
#passthru #endif
#passthru #if !defined(SIGSEGV)
#passthru #define SIGSEGV 0
#passthru #endif
#passthru #if !defined(SIGSTOP)
#passthru #define SIGSTOP 0
#passthru #endif
#passthru #if !defined(SIGSYS)
#passthru #define SIGSYS 0
#passthru #endif
#passthru #if !defined(SIGTERM)
#passthru #define SIGTERM 0
#passthru #endif
#passthru #if !defined(SIGTHAW)
#passthru #define SIGTHAW 0
#passthru #endif
#passthru #if !defined(SIGTRAP)
#passthru #define SIGTRAP 0
#passthru #endif
#passthru #if !defined(SIGTSTP)
#passthru #define SIGTSTP 0
#passthru #endif
#passthru #if !defined(SIGTTIN)
#passthru #define SIGTTIN 0
#passthru #endif
#passthru #if !defined(SIGTTOU)
#passthru #define SIGTTOU 0
#passthru #endif
#passthru #if !defined(SIGURG)
#passthru #define SIGURG 0
#passthru #endif
#passthru #if !defined(SIGUSR1)
#passthru #define SIGUSR1 0
#passthru #endif
#passthru #if !defined(SIGUSR2)
#passthru #define SIGUSR2 0
#passthru #endif
#passthru #if !defined(SIGVTALRM)
#passthru #define SIGVTALRM 0
#passthru #endif
#passthru #if !defined(SIGWAITING)
#passthru #define SIGWAITING 0
#passthru #endif
#passthru #if !defined(SIGWINCH)
#passthru #define SIGWINCH 0
#passthru #endif
#passthru #if !defined(SIGXCPU)
#passthru #define SIGXCPU 0
#passthru #endif
#passthru #if !defined(SIGXFSZ)
#passthru #define SIGXFSZ 0
#passthru #endif

stringint signalnames[] = {
   { 0,                 40 },
   { "SIGABRT",         SIGABRT },
   { "SIGALRM",         SIGALRM },
   { "SIGBREAK",        SIGBREAK },
   { "SIGBUS",          SIGBUS },
   { "SIGCHLD",         SIGCHLD },
   { "SIGCLD",          SIGCLD },
   { "SIGCONT",         SIGCONT },
   { "SIGEMT",          SIGEMT },
   { "SIGFPE",          SIGFPE },
   { "SIGFREEZE",       SIGFREEZE },
   { "SIGHUP",          SIGHUP },
   { "SIGILL",          SIGILL },
   { "SIGINT",          SIGINT },
   { "SIGIO",           SIGIO },
   { "SIGIOT",          SIGIOT },
   { "SIGKILL",         SIGKILL },
   { "SIGLOST",         SIGLOST },
   { "SIGLWP",          SIGLWP },
   { "SIGPIPE",         SIGPIPE },
   { "SIGPOLL",         SIGPOLL },
   { "SIGPROF",         SIGPROF },
   { "SIGPWR",          SIGPWR },
   { "SIGQUIT",         SIGQUIT },
   { "SIGSEGV",         SIGSEGV },
   { "SIGSTOP",         SIGSTOP },
   { "SIGSYS",          SIGSYS },
   { "SIGTERM",         SIGTERM },
   { "SIGTHAW",         SIGTHAW },
   { "SIGTRAP",         SIGTRAP },
   { "SIGTSTP",         SIGTSTP },
   { "SIGTTIN",         SIGTTIN },
   { "SIGTTOU",         SIGTTOU },
   { "SIGURG",          SIGURG },
   { "SIGUSR1",         SIGUSR1 },
   { "SIGUSR2",         SIGUSR2 },
   { "SIGVTALRM",       SIGVTALRM },
   { "SIGWAITING",      SIGWAITING },
   { "SIGWINCH",        SIGWINCH },
   { "SIGXCPU",         SIGXCPU },
   { "SIGXFSZ",         SIGXFSZ },
};

#if NT
WORD wVersionRequested = MAKEWORD( 2, 0 );
extern WSADATA wsaData;
int werr;
int WINSOCK_INITIAL=0;

int StartupWinSocket(void)
{
   if (!WINSOCK_INITIAL) {
      if(WSAStartup(wVersionRequested, &wsaData)!= 0){
         fprintf(stderr, "can't startup windows sockets\n");
         return 0;
         }
      WINSOCK_INITIAL = 1;
      }
   return 1;
}

int CleanupWinSocket(void)
{
   if (WSACleanup()==SOCKET_ERROR) {
      fprintf(stderr, "cannot cleanup windows sockets\n");
      return 0;
      }
   WINSOCK_INITIAL = 0;
   return 1;
}
#endif                                  /* NT */

/*
 * get_fd() - get file descriptor
 * From a file value, obtain the UNIX file descriptor.
 */
int get_fd(struct descrip file, unsigned int errmask)
{
   int status;

   status = BlkD(file,File)->status;
   /* Check it's opened for reading, or it's a window */
   if ((status & Fs_Directory)
#ifdef Dbm
       || (status & Fs_Dbm)
#endif
       )
     return -1;

#ifdef Graphics
   if (status & Fs_Window) {
     if (!(status & Fs_Read)) {
        return -1;
        }
#ifdef XWindows
     return XConnectionNumber(BlkD(file,File)->fd.wb->
                              window->display->display);
#else                                   /* XWindows */
     return -1;
#endif                                  /* XWindows */
     }
#endif                                  /* Graphics */

#ifdef PseudoPty
   if (status & Fs_Pty) {
#if NT
      return -1;
#else                                   /* NT */
      return BlkD(file,File)->fd.pt->master_fd;
#endif                                  /* NT */
      }
#endif                                  /* PseudoPty */

   if (errmask && !(status & errmask))
      return -2;

#if NT
#define fileno _fileno
#endif                                  /* NT */

#if HAVE_LIBSSH
   if (status & Fs_SSH) {
      struct SSHfile *sshf = BlkD(file,File)->fd.sshf;
      if (sshf == NULL || sshf->closed || sshf->sess == NULL)
         return -1;
      return ssh_get_fd(sshf->sess);
      }
#endif                                  /* HAVE_LIBSSH */

   if (status & Fs_Socket) {
#if HAVE_LIBSSL
      if(status & Fs_Encrypt)
         return SSL_get_fd(BlkD(file,File)->fd.ssl);
      else
#endif                                  /* LIBSSL */
         return BlkD(file,File)->fd.fd;
      }

   if (status & Fs_Messaging)
      return tp_fileno(BlkD(file,File)->fd.mf->tp);

   return fileno(BlkD(file,File)->fd.fp);
}

#if HAVE_LIBSSH
/*
 * ssh_file_pending() - 1 if an SSH file already has stdout (or EOF)
 * waiting.  Used by select() so we do not hang when libssh buffered
 * the banner/prompt during open().  Only stdout matters here: stream
 * reads() do not consume stderr/exit queue chunks, so a nonempty
 * qhead alone must not make select() claim the file is readable.
 */
int ssh_file_pending(struct b_file *fp)
{
   struct SSHfile *sshf;

   if (fp == NULL || !(fp->status & Fs_SSH))
      return 0;
   sshf = fp->fd.sshf;
   if (sshf == NULL || sshf->closed)
      return 0;
#ifdef Concurrent
   MUTEX_LOCKID_CONTROLLED(fp->mutexid);
#endif                                  /* Concurrent */
   if (sshf->nl_pending || sshf->q_stdout > 0) {
#ifdef Concurrent
      MUTEX_UNLOCKID(fp->mutexid);
#endif                                  /* Concurrent */
      return 1;
      }
   if (sshf->chan != NULL || sshf->sfile != NULL)
      ssh_pump(sshf, 0, 1);             /* want stdout for reads()/select */
   {
   int ready = (sshf->nl_pending || sshf->q_stdout > 0 || sshf->eof_seen);
#ifdef Concurrent
   MUTEX_UNLOCKID(fp->mutexid);
#endif                                  /* Concurrent */
   return ready;
   }
}
#endif                                  /* HAVE_LIBSSH */

int get_uid(char *name)
{
#if NT
   return -1;
#else                                   /* NT */
   struct passwd *pw, pwbuf;
   char buf[1024];
   if ((getpwnam_r(name, &pwbuf, buf, 1024, &pw)!=0) || (pw == NULL))
      return -1;
   return pw->pw_uid;
#endif                                  /* NT */
}

int get_gid(char *name)
{
#if NT
   return -1;
#else                                   /* NT */
   struct group *gr, grbuf;
   char buf[4096];
   if ((getgrnam_r(name, &grbuf, buf, 4096, &gr)!=0) || (gr == NULL))
      return -1;
   return gr->gr_gid;
#endif                                  /* NT */
}

static int newmode(char *mode, int oldmode)
{
   int i;

   /* The pattern is [ugoa]*[+-=][rwxRWXstugo]* */
   int which = 0, do_umask;
   char *p = mode, *q, op;
   char *fields = "ogua";
   int retmode = oldmode & 07777;

   /* Special case: if mode is of the pattern rwxrwxrwx (with some dashes)
    * then it's ok too.
    *
    * A little extra hook: if there's a leading -ldcb|s i.e. it came
    * directly from stat(), then we allow that.
    */
   do {
      char allperms[10];
      int cmode;
      int highbits = 0;
      int mlen;

      mlen = strlen(mode);
      if (mlen != 9 && (mlen != 10 || !strchr("-ldcb|s", mode[0])))
         break;

      if (mlen == 10)
         /* We know there's a leading char we're not interested in */
         mode++;

      strcpy(allperms, "rwxrwxrwx");

      if (mode[2] == 's' || mode[2] == 'S') {
          highbits |= 1;
          if (mode[2] == 's')
              mode[2] = 'x';
          else
              mode[2] = '-';
      }
      highbits <<= 1;
      if (mode[5] == 's' || mode[5] == 'S') {
          highbits |= 1;
          if (mode[5] == 's')
              mode[5] = 'x';
          else
              mode[5] = '-';
      }
      highbits <<= 1;
      if (mode[8] == 't' || mode[8] == 'T') {
          highbits |= 1;
          if (mode[8] == 't')
              mode[8] = 'x';
          else
              mode[8] = '-';
      }

      cmode = 0;
      for(i = 0; i < 9; i++) {
         cmode = cmode << 1;
         if (mode[i] == '-') {
            cmode |= 1;
         } else if (mode[i] != allperms[i]) {
            cmode = -1;
            break;
         }
      }
      if (cmode < 0)
         break;
      cmode |= highbits << 9;
      return cmode;
   } while(0);

   while ((q = strchr(fields, *p))) {
      if (!*p)
         return -2;
      if (*p == 'a')
         which = 7;
      else
         which |= 1 << (q - fields);
      p++;
   }
   if (!strchr("+=-", *p))
      return -2;

   if ((do_umask = (which == 0)))
      which = 7;

   op = *p++;

   /* We have: which field(s) in "which", an operator in "op" */

   if (op == '=') {
      for(i = 0; i < 3; i++)
        if (which & (1 << i)) {
            retmode &= ~(7 << (i*3));
            retmode &= ~(1 << (i + 9));
        }
      op = '+';
   }

   while (*p) {
      int value = 0;
      switch (*p++) {
      case 'r': value = 4; break;
      case 'w': value = 2; break;
      case 'x': value = 1; break;
      case 'R': if (oldmode & 0444) value = 4; break;
      case 'W': if (oldmode & 0222) value = 2; break;
      case 'X': if (oldmode & 0111) value = 1; break;
      case 'u': value = (oldmode & 0700) >> 6; break;
      case 'g': value = (oldmode & 0070) >> 3; break;
      case 'o': value = oldmode & 0007; break;
      case 's':
         if (which & 4)
            value = 04000;
         if (which & 2)
            value |= 02000;
         retmode |= value;
         continue;
      case 't':
         if (which & 1)
            retmode |= 01000;
         continue;
      default:
         return -2;
      }

      for(i = 0; i < 3; i++) {
         int nvalue;
         if (which & (1 << i)) {
            if (do_umask) {
#if NT
               int u = _umask(0);
               _umask(u);
#else                                   /* NT */
               int u = umask(0);
               umask(u);
#endif                                  /* NT */
               nvalue = value & ~u;
            } else
               nvalue = value;
            switch (op) {
            case '-': retmode &= ~nvalue; break;
            case '+': retmode |= nvalue; break;
            }
         }
         value = (value << 3);
      }
   }

   if (*p)
     /* Extra chars */
      return -2;

   return retmode;
}


int getmodefd(int fd, char *mode)
{
#if defined(NTGCC) && (WordBits==32)
#passthru #if (__GNUC__==4) && (__GNUC_MINOR__>7)
#passthru #define stat _stat64i32
#passthru #endif
#endif                                  /* NTGCC && WordBits==32*/
   struct stat st;
   if (fstat(fd, &st) < 0)
      return -1;
   return newmode(mode, st.st_mode);
}

int getmodenam(char *path, char *mode)
{
   struct stat st;
   if (path) {
     if (stat(path, &st) < 0)
        return -1;
     return newmode(mode, st.st_mode);
   } else
     return newmode(mode, 0);
}



/*
 * Create a record of type posix_struct
 * (defined in posix.icn because it's too painful for iconc if we
 * add a new record type here) and initialise the fields with the
 * fields from the struct stat.  Because this allocates memory that
 * may trigger a garbage collection, the pointer parameters dp and rp
 * should point at tended variables.
 */
void stat2rec(
#if NT
              struct _stat *st, 
#else                                   /* NT */
              struct stat *st,
#endif                                  /* NT */
              struct descrip *dp, struct b_record **rp)
{
   int i;
   char mode[12], *user = NULL, *group = NULL;
#if !NT
   struct passwd *pw = NULL, pwbuf;
   struct group *gr = NULL, grbuf;
#endif                                  /* !NT */
   char buf[4096];

   dp->dword = D_Record;
   dp->vword.bptr = (union block *)(*rp);

   for (i = 0; i < 13; i++)
     (*rp)->fields[i].dword = D_Integer;

   IntVal((*rp)->fields[0]) = (word)st->st_dev;
   IntVal((*rp)->fields[1]) = (word)st->st_ino;
   IntVal((*rp)->fields[3]) = (word)st->st_nlink;
   IntVal((*rp)->fields[6]) = (word)st->st_rdev;
   IntVal((*rp)->fields[7]) = (word)st->st_size;
   IntVal((*rp)->fields[8]) = (word)st->st_atime;
   IntVal((*rp)->fields[9]) = (word)st->st_mtime;
   IntVal((*rp)->fields[10]) = (word)st->st_ctime;
#if NT
   IntVal((*rp)->fields[11]) = (word)0;
   IntVal((*rp)->fields[12]) = (word)0;
#else
   IntVal((*rp)->fields[11]) = (word)st->st_blksize;
   IntVal((*rp)->fields[12]) = (word)st->st_blocks;
#endif

   (*rp)->fields[13] = nulldesc;

   strcpy(mode, "----------");
#if NT
   if (st->st_mode & _S_IFREG) mode[0] = '-';
   else if (st->st_mode & _S_IFDIR) mode[0] = 'd';
   else if (st->st_mode & _S_IFCHR) mode[0] = 'c';
   else if (st->st_mode & _S_IFMT) mode[0] = 'm';

   if (st->st_mode & S_IREAD) mode[1] = mode[4] = mode[7] = 'r';
   if (st->st_mode & S_IWRITE) mode[2] = mode[5] = mode[8] = 'w';
   if (st->st_mode & S_IEXEC) mode[3] = mode[6] = mode[9] = 'x';
#else                                   /* NT */
   if (S_ISLNK(st->st_mode)) mode[0] = 'l';
   else if (S_ISREG(st->st_mode)) mode[0] = '-';
   else if (S_ISDIR(st->st_mode)) mode[0] = 'd';
   else if (S_ISCHR(st->st_mode)) mode[0] = 'c';
   else if (S_ISBLK(st->st_mode)) mode[0] = 'b';
   else if (S_ISFIFO(st->st_mode)) mode[0] = '|';
   else if (S_ISSOCK(st->st_mode)) mode[0] = 's';

   if (S_IRUSR & st->st_mode) mode[1] = 'r';
   if (S_IWUSR & st->st_mode) mode[2] = 'w';
   if (S_IXUSR & st->st_mode) mode[3] = 'x';
   if (S_IRGRP & st->st_mode) mode[4] = 'r';
   if (S_IWGRP & st->st_mode) mode[5] = 'w';
   if (S_IXGRP & st->st_mode) mode[6] = 'x';
   if (S_IROTH & st->st_mode) mode[7] = 'r';
   if (S_IWOTH & st->st_mode) mode[8] = 'w';
   if (S_IXOTH & st->st_mode) mode[9] = 'x';

   if (S_ISUID & st->st_mode) mode[3] = (mode[3] == 'x') ? 's' : 'S';
   if (S_ISGID & st->st_mode) mode[6] = (mode[6] == 'x') ? 's' : 'S';
   if (S_ISVTX & st->st_mode) mode[9] = (mode[9] == 'x') ? 't' : 'T';
#endif                                  /* NT */

   StrLoc((*rp)->fields[2]) = alcstr(mode, 10);
   SetStrLen((*rp)->fields[2], 10);

#if NT
   (*rp)->fields[4] = (*rp)->fields[5] = emptystr;
#else                                   /* NT */
   /*
    * If we can get the user name, use it. Otherwise use the user id #.
    * getpwuid_r's interface is a fair bit different than getpwuid!
    * It returns 0 whether or not the entry is found, but we could be
    * checking for a non-zero return value that would indicate an Error.
    */
   getpwuid_r(st->st_uid, &pwbuf, buf, 4096, &pw);
   if(pw == 0){
      sprintf(mode, "%d", st->st_uid);
      user = mode;
      }
   else {
      user = pw->pw_name;
      }
   StrLoc((*rp)->fields[4]) = alcstr(user, strlen(user));
   SetStrLen((*rp)->fields[4], strlen(user));

   getgrgid_r(st->st_gid, &grbuf, buf, 4096, &gr);
   if (gr == 0){
      sprintf(mode, "%d", st->st_gid);
      group = mode;
      }
   else {
      group = gr->gr_name;
      }
   StrLoc((*rp)->fields[5]) = alcstr(group, strlen(group));
   SetStrLen((*rp)->fields[5], strlen(group));
#endif                                  /* NT */

}

#if !NT
/*
 * Create a record of type posix_rusage
 * (defined in posix.icn because it's too painful for iconc if we
 * add a new record type here) and initialise the fields with the
 * fields from the struct rusage.  Because this allocates memory that
 * may trigger a garbage collection, the pointer parameters dp and rp
 * should point at tended variables.
 */
void rusage2rec(struct rusage *usg, struct descrip *dp, struct b_record **rp)
{
   int i;
   tended struct b_record *utime_rp, *stime_rp;

   /*
    * Initialize fields 0 and 1 to posix_timeval records.
    */
   Protect(utime_rp = alcrecd(2, BlkLoc(*timeval_constr)),syserr("allocation"));
   Protect(stime_rp = alcrecd(2, BlkLoc(*timeval_constr)),syserr("allocation"));

   dp->dword = D_Record;
   dp->vword.bptr = (union block *)(*rp);
   (*rp)->fields[0].dword = D_Record;
   (*rp)->fields[0].vword.bptr = (union block *)utime_rp;
   (*rp)->fields[1].dword = D_Record;
   (*rp)->fields[1].vword.bptr = (union block *)stime_rp;
   MakeInt(usg->ru_utime.tv_sec, &(utime_rp->fields[0]));
   MakeInt(usg->ru_utime.tv_usec, &(utime_rp->fields[1]));
   MakeInt(usg->ru_stime.tv_sec, &(stime_rp->fields[0]));
   MakeInt(usg->ru_stime.tv_usec, &(stime_rp->fields[1]));

   /*
    * The rest of the rusage are (long) integers.
    */
   for (i = 2; i < 9; i++)
     (*rp)->fields[i].dword = D_Integer;

   IntVal((*rp)->fields[2]) = (word)usg->ru_maxrss;
   IntVal((*rp)->fields[3]) = (word)usg->ru_minflt;
   IntVal((*rp)->fields[4]) = (word)usg->ru_majflt;
   IntVal((*rp)->fields[5]) = (word)usg->ru_inblock;
   IntVal((*rp)->fields[6]) = (word)usg->ru_oublock;
   IntVal((*rp)->fields[7]) = (word)usg->ru_nvcsw;
   IntVal((*rp)->fields[8]) = (word)usg->ru_nivcsw;
}
#endif                                          /* NT */

struct descrip posix_lock = {D_Null};
struct descrip posix_timeval = {D_Null};
struct descrip posix_rusage = {D_Null};
struct descrip posix_stat = {D_Null};
struct descrip posix_message = {D_Null};
struct descrip posix_passwd = {D_Null};
struct descrip posix_group = {D_Null};
struct descrip posix_servent = {D_Null};
struct descrip posix_hostent = {D_Null};

dptr rec_structor(char *name)
{
   int i;
   struct descrip s;
   struct descrip fields[14];

   if (!strcmp(name, "posix_lock")) {
      if (is:null(posix_lock)) {
         AsgnCStr(s, "posix_lock");
         AsgnCStr(fields[0], "value");
         AsgnCStr(fields[1], "pid");
         posix_lock.dword = D_Proc;
         posix_lock.vword.bptr = (union block *)dynrecord(&s, fields, 2);
         }
      return &posix_lock;
      }
   else if (!strcmp(name, "posix_message")) {
      if (is:null(posix_message)) {
         AsgnCStr(s, "posix_message");
         AsgnCStr(fields[0], "addr");
         AsgnCStr(fields[1], "msg");
         posix_message.dword = D_Proc;
         posix_message.vword.bptr = (union block *)dynrecord(&s, fields, 2);
         }
      return &posix_message;
      }
   else if (!strcmp(name, "posix_servent")) {
      if (is:null(posix_servent)) {
         AsgnCStr(s, "posix_servent");
         AsgnCStr(fields[0], "name");
         AsgnCStr(fields[1], "aliases");
         AsgnCStr(fields[2], "port");
         AsgnCStr(fields[3], "proto");
         posix_servent.dword = D_Proc;
         posix_servent.vword.bptr = (union block *)dynrecord(&s, fields, 4);
         }
      return &posix_servent;
      }
   else if (!strcmp(name, "posix_hostent")) {
      if (is:null(posix_hostent)) {
         AsgnCStr(s, "posix_hostent");
         AsgnCStr(fields[0], "name");
         AsgnCStr(fields[1], "aliases");
         AsgnCStr(fields[2], "addresses");
         posix_hostent.dword = D_Proc;
         posix_hostent.vword.bptr = (union block *)dynrecord(&s, fields, 3);
         }
      return &posix_hostent;
      }
   else if (!strcmp(name, "posix_timeval")) {
      if (is:null(posix_timeval)) {
         AsgnCStr(s, "posix_timeval");
         AsgnCStr(fields[0], "sec");
         AsgnCStr(fields[1], "usec");
         posix_timeval.dword = D_Proc;
         posix_timeval.vword.bptr = (union block *)dynrecord(&s, fields, 2);
         }
      return &posix_timeval;
      }
   else if (!strcmp(name, "posix_rusage")) {
      if (is:null(posix_rusage)) {
         AsgnCStr(s, "posix_rusage");
         AsgnCStr(fields[0], "utime");
         AsgnCStr(fields[1], "stime");
         AsgnCStr(fields[2], "maxrss");
         AsgnCStr(fields[3], "minflt");
         AsgnCStr(fields[4], "majflt");
         AsgnCStr(fields[5], "inblock");
         AsgnCStr(fields[6], "oublock");
         AsgnCStr(fields[7], "nvcsw");
         AsgnCStr(fields[8], "nivcsw");
         posix_rusage.dword = D_Proc;
         posix_rusage.vword.bptr = (union block *)dynrecord(&s, fields, 9);
         }
      return &posix_rusage;
      }
   else if (!strcmp(name, "posix_group")) {
      if (is:null(posix_group)) {
         AsgnCStr(s, "posix_group");
         AsgnCStr(fields[0], "name");
         AsgnCStr(fields[1], "passwd");
         AsgnCStr(fields[2], "gid");
         AsgnCStr(fields[3], "members");
         posix_group.dword = D_Proc;
         posix_group.vword.bptr = (union block *)dynrecord(&s, fields, 4);
         }
      return &posix_group;
      }
   else if (!strcmp(name, "posix_passwd")) {
      if (is:null(posix_passwd)) {
         AsgnCStr(s, "posix_passwd");
         AsgnCStr(fields[0], "name");
         AsgnCStr(fields[1], "passwd");
         AsgnCStr(fields[2], "uid");
         AsgnCStr(fields[3], "gid");
         AsgnCStr(fields[4], "gecos");
         AsgnCStr(fields[5], "dir");
         AsgnCStr(fields[6], "shell");
         posix_passwd.dword = D_Proc;
         posix_passwd.vword.bptr = (union block *)dynrecord(&s, fields, 7);
         }
      return &posix_passwd;
      }
   else if (!strcmp(name, "posix_stat")) {
      if (is:null(posix_stat)) {
         AsgnCStr(s, "posix_stat");
         AsgnCStr(fields[0], "dev");
         AsgnCStr(fields[1], "ino");
         AsgnCStr(fields[2], "mode");
         AsgnCStr(fields[3], "nlink");
         AsgnCStr(fields[4], "uid");
         AsgnCStr(fields[5], "gid");
         AsgnCStr(fields[6], "rdev");
         AsgnCStr(fields[7], "size");
         AsgnCStr(fields[8], "atime");
         AsgnCStr(fields[9], "mtime");
         AsgnCStr(fields[10], "ctime");
         AsgnCStr(fields[11], "blksize");
         AsgnCStr(fields[12], "blocks");
         AsgnCStr(fields[13], "symlink");
         posix_stat.dword = D_Proc;
         posix_stat.vword.bptr = (union block *)dynrecord(&s, fields, 14);
         }
      return &posix_stat;
      }

   /*
    * called rec_structor on something else ?! try globals...
    */
   StrLoc(s) = name;
   SetStrLen(s, strlen(name));
   for (i = 0; i < n_globals; ++i)
      if (eq(&s, &gnames[i])) {
         if (is:proc(globals[i]))
            return &globals[i];
         else
            return 0;
         }

   return 0;
}

/*
 * Sockets
 *
 * IMPORTANT NOTE: IPv6 (AF_INET6) is NOT implemented.
 *
 * There are two routines that are provided (via open()) - connect (for a
 * client) and listen (for servers).
 *
 * Four procedures are not required for starting a TCP server, we combine
 * them. The standard BSD way of doing it is:
 *
 *   s = socket(INET|UNIX, SOCK_STREAM, 0);
 *   bind(s, address);
 *   listen(s, n);
 *   while (fd = accept(s, &fromaddress)) { fork/exec; close(fd); }
 *
 * We combine all these into a single "listen" facility. One small wrinkle
 * is that in the usual scenario, bind and listen as well as socket
 * construction are only done once and accept is called repeatedly. We have
 * to keep track of whether this is the first time this address has been
 * open()ed and if so, construct a socket and do the bind/listen. (This
 * approach is not 100% equivalent to the BSD method, but who ever writes
 * servers that create multiple (different) sockets to listen on the same
 * address?)
 *
 * As for address family to be used, we guess that from the address - if it
 * contains a ':' (host:port) then it is an AF_INET socket; otherwise an
 * AF_UNIX socket. For AF_INET sockets, a missing 'host' component implies a
 * connection is to be made to the same machine. In the case of a listening
 * socket, a missing 'host' means listen on every interface available (i.e.
 * INADDR_ANY) otherwise it specifies the interface to listen on. It is an
 * error for this interface to not be on the local host (obviously).
 *
 * For clients, the setup is much simpler; just create the socket and call
 * connect, which returns an fd. We do both in the one procedure "connect".
 *
 * UDP is just simpler - no listen or accept, only bind for sock_listen;
 * and for sock_connect it's basically the same except that it must be
 * AF_INET.
 *
 * Implementation note: we blithely return an fd (which is an int) in a FILE*
 * to be stored in the descriptor. This is wrong, wrong, wrong. We need to
 * add another type which appears to be an Icon file but instead of storing
 * a FILE* it stores an int.
 * FIXME: see above paragraph
 */

static int sock_get (char *);
static int sock_put (char *, int);
static int sock_claim (int);
static int sock_track (int);

/*
 * We also stash the sockaddr structs we created with host and port info for
 * UDP and raw sockets (and let's hope we don't run out of file descriptors).
 *
 * All because for UDP connect/send doesn't do what sendto does. (At least
 * on Linux 2.0.36).  Raw uses the same sendto path.  sock_close() frees
 * the retained addrinfo via sock_release_fd_meta().
 */

struct addrinfo **saddrs;
static int saddrs_n;

/*
 * UDP open() stores the destination in saddrs[] and does not connect(2).
 * DTLS needs a connected datagram socket; connect using that saved peer.
 */
int sock_udp_connect_saved(int fd)
{
   if (saddrs == NULL || fd < 0 || fd >= saddrs_n || saddrs[fd] == NULL)
      return -1;
   return connect(fd, saddrs[fd]->ai_addr, saddrs[fd]->ai_addrlen);
}

#define SOCK_RECV_SMALL 2048
#define SOCK_RECV_LARGE 65535

static void sock_release_fd_meta(int fd)
{
   if (fd < 0)
      return;
   if (saddrs != NULL && fd < saddrs_n && saddrs[fd] != NULL) {
      freeaddrinfo(saddrs[fd]);
      saddrs[fd] = NULL;
      }
}

#if !defined(MAXHOSTNAMELEN)
#define MAXHOSTNAMELEN 32
#endif                                  /* MAXHOSTNAMELEN */

/*
 * debugging function to dump addrinfo struct
 */
int dump_addrinfo(struct addrinfo *ai)
{
        struct addrinfo *runp;
        char hostbuf[50], portbuf[10];
        for (runp = ai; runp != NULL; runp = runp->ai_next) {
                printf("family: %d, socktype: %d, protocol: %d, ",
                       runp->ai_family, runp->ai_socktype, runp->ai_protocol);
                (void) getnameinfo(
                        runp->ai_addr, runp->ai_addrlen,
                        hostbuf, sizeof(hostbuf),
                        portbuf, sizeof(portbuf),
                        NI_NUMERICHOST | NI_NUMERICSERV
                );
                printf("host: %s, port: %s\n", hostbuf, portbuf);
        }
        return 0;
}

char* print_sockaddr(struct sockaddr* sa, char* buf, int buflen ) {
  switch(sa->sa_family) {
  case AF_INET: {
    struct sockaddr_in *addr_in = (struct sockaddr_in *)sa;
    return (char *) inet_ntop(AF_INET, &(addr_in->sin_addr), buf, buflen);
    break;
  }
  case AF_INET6: {
    struct sockaddr_in6 *addr_in6 = (struct sockaddr_in6 *)sa;
    return (char *)  inet_ntop(AF_INET6, &(addr_in6->sin6_addr), buf, buflen);
    break;
  }
  default:
    break;
  }
  return NULL;
}

/*
 * get port, IPv4 or IPv6:
 */
short get_sa_port(struct sockaddr *sa)
{
    if (sa->sa_family == AF_INET) {
        return (((struct sockaddr_in*)sa)->sin_port);
    }

    return (((struct sockaddr_in6*)sa)->sin6_port);
}

char* print_sockaddrport(struct sockaddr* sa, char* buf, int buflen ) {
  switch(sa->sa_family) {
  case AF_INET: {
    struct sockaddr_in *addr_in = (struct sockaddr_in *)sa;
    if ((inet_ntop(AF_INET, &(addr_in->sin_addr), buf, buflen)) == NULL)
      return NULL;
    break;
  }
  case AF_INET6: {
    struct sockaddr_in6 *addr_in6 = (struct sockaddr_in6 *)sa;
    if ((inet_ntop(AF_INET6, &(addr_in6->sin6_addr), buf, buflen)) == NULL)
      return NULL;

    break;
  }
  default:
    break;
  }
  return NULL;
}

struct addrinfo *uni_getaddrinfo(char* addr, char* p, int sock_type, int family){
  int nohost = 0, rc, sock, proto;
  struct addrinfo hints, *res0;
  char *service;

  /*
   * Raw sockets often have no port (ICMP et al.).  TCP/UDP still require
   * a non-zero numeric port string, matching historical open() behavior.
   */
  if (sock_type == SOCK_T_RAW)
     service = (p && p[0]) ? p : NULL;
  else {
     if (p == NULL || p[0] == '\0' || atoi(p) == 0) {
        errno = ENXIO;
        return NULL;
        }
     service = p;
     }

  if (addr == NULL || addr[0] == '\0')
    nohost = 1;
#if NT
  if (!StartupWinSocket()) return 0;
#endif                                  /*NT*/

  if (sock_type == SOCK_T_DGRAM) {
     sock = SOCK_DGRAM;
     proto = IPPROTO_UDP;
     }
  else if (sock_type == SOCK_T_RAW) {
     sock = SOCK_RAW;
     proto = 0;                         /* real protocol chosen at socket() */
     }
  else {
     sock = SOCK_STREAM;
     proto = IPPROTO_TCP;
     }

  INIT_ADDRINFO_HINTS(hints, family, sock, (nohost?AI_PASSIVE:0), proto);
  if ( (rc = getaddrinfo((nohost?NULL:addr), service, &hints, &res0)) != 0) {
    set_gaierrortext(rc);
    return NULL;
  }

  //dump_addrinfo(res0);
  return res0;
 }

/*
 * Socket attribute support.  Trailing arguments to open() on network
 * modes may be "name=value" strings which are applied to the socket
 * with setsockopt().  Two passes are made over the attribute list,
 * because some options (the reuse flags) only have effect if they are
 * set between socket() and bind(); those are applied in a "prebind"
 * pass and everything else after the socket is bound/created.
 * Attributes are applied in the order given, which matters for
 * multicast: an "iface" attribute selects the interface used by any
 * "join" attributes that follow it.
 *
 * DWIM defaults (overridable with an explicit attribute):
 *   - listeners get reuseaddr=yes (UNIX); multicast binds also get
 *     reuseport=yes where available, and reuseaddr=yes on Windows
 *   - binding a UDP socket to a multicast group address joins it (ASM);
 *     source@group:port or source= joins that group as SSM instead
 *   - no iface=: join on all IPv4 interfaces; multicast send uses the
 *     first non-loopback IPv4 address (else loopback).  mcastloop (on
 *     by default) still delivers a local copy on that interface.
 *   - connecting/sending to 255.255.255.255 enables SO_BROADCAST
 */

static char *sock_attr_names[] = {
   "reuseaddr", "reuseport", "broadcast", "rcvbuf", "sndbuf",
   "join", "leave", "source", "ttl", "mcastloop", "iface",
   "proto", "hdrincl", NULL
   };

int is_sock_attr(char *name)
{
   int i;
   for (i = 0; sock_attr_names[i]; i++)
      if (strcmp(name, sock_attr_names[i]) == 0)
         return 1;
   return 0;
}

/*
 * Boolean attribute values follow the verifyPeer convention: exactly
 * "yes" or "no".  Returns 1/0, or -1 for anything else.
 */
static int sock_attr_bool(char *val)
{
   if (strcmp(val, "yes") == 0)
      return 1;
   if (strcmp(val, "no") == 0)
      return 0;
   return -1;
}

/*
 * Map a proto= value (name or number) to an IP protocol number.
 * Returns 1 on success, 0 if unrecognized or unavailable on this host.
 */
static int sock_lookup_proto(char *val, int *proto_out)
{
   int i, n, all_digits = 1;
   static struct { char *name; int proto; } names[] = {
      { "icmp",   IPPROTO_ICMP },
      { "icmpv6", IPPROTO_ICMPV6 },
      { "icmp6",  IPPROTO_ICMPV6 },
      { "igmp",   IPPROTO_IGMP },
      { "tcp",    IPPROTO_TCP },
      { "udp",    IPPROTO_UDP },
      { "gre",    47 },                 /* GRE (IANA) */
      { "ospf",   89 },                 /* OSPFIGP (IANA) */
      { "pim",    IPPROTO_PIM },
      { "raw",    IPPROTO_RAW },
      { NULL,     0 }
      };

   if (val == NULL || val[0] == '\0')
      return 0;
   for (i = 0; names[i].name; i++)
      if (strcasecmp(val, names[i].name) == 0) {
         if (names[i].proto < 0)
            return 0;
         *proto_out = names[i].proto;
         return 1;
         }
   for (i = 0; val[i]; i++)
      if (val[i] < '0' || val[i] > '9') {
         all_digits = 0;
         break;
         }
   if (!all_digits)
      return 0;
   n = atoi(val);
   if (n < 0 || n > 255)
      return 0;
   *proto_out = n;
   return 1;
}

/*
 * Find proto= among open() attributes.  Returns 1 if found and valid,
 * 0 if absent, -1 if present but invalid (&errortext set).
 */
static int sock_attr_proto(dptr attr, int nattr, int *proto_out)
{
   tended char *tmps;
   char abuf[256], *val;
   int a;
   C_integer tmpint;

   for (a = 0; a < nattr; a++) {
      if (is:null(attr[a]))
         continue;
      if (a == 0 && cnv:C_integer(attr[a], tmpint))
         continue;
      if (!cnv:C_string(attr[a], tmps))
         continue;
      if (strlen(tmps) < 3 || strlen(tmps) >= sizeof(abuf) ||
          tmps[0] == '=' || strchr(tmps, '=') == NULL)
         continue;
      strcpy(abuf, tmps);
      val = strchr(abuf, '=');
      *val++ = '\0';
      if (strcmp(abuf, "proto") != 0)
         continue;
      if (!sock_lookup_proto(val, proto_out)) {
         errno = 0;
         set_errortext_with_val(1310, tmps);
         return -1;
         }
      return 1;
      }
   return 0;
}

/*
 * Address family of a socket.  Works on unbound sockets too, since the
 * family is fixed at socket creation.
 */
static int sock_family(int s)
{
   struct sockaddr_storage ss;
   unsigned int sslen = sizeof(ss);
   memset(&ss, 0, sizeof(ss));
   if (getsockname(s, (struct sockaddr *)&ss, &sslen) < 0)
      return AF_INET;
   return ss.ss_family;
}

/*
 * Is this a multicast group address?
 */
static int sockaddr_is_multicast(struct sockaddr *sa)
{
   if (sa->sa_family == AF_INET)
      return IN_MULTICAST(ntohl(((struct sockaddr_in *)sa)->sin_addr.s_addr));
   if (sa->sa_family == AF_INET6)
      return IN6_IS_ADDR_MULTICAST(&((struct sockaddr_in6 *)sa)->sin6_addr);
   return 0;
}

/*
 * Split a "source@group" host part (SSM, matching VLC/ffmpeg and RFC 4607
 * (S,G) order).  On success returns 1.  With '@': copies the source into
 * srcbuf, replaces host with the group, and sets *srcp to srcbuf.
 * Without '@': *srcp is NULL and host is unchanged.  Empty either side
 * fails with EINVAL.
 */
static int sock_split_group_source(char *host, char *srcbuf, size_t srcbuf_sz,
                                   char **srcp)
{
   char *at;
   size_t slen;

   *srcp = NULL;
   if ((at = strchr(host, '@')) == NULL)
      return 1;
   if (at == host || at[1] == '\0') {
      errno = EINVAL;
      return 0;
      }
   *at = '\0';
   slen = strlen(host);
   if (slen + 1 > srcbuf_sz) {
      errno = EINVAL;
      return 0;
      }
   memcpy(srcbuf, host, slen + 1);              /* source */
   memmove(host, at + 1, strlen(at + 1) + 1);   /* group into host */
   *srcp = srcbuf;
   return 1;
}

/*
 * These conditionals test macros from system headers, which rtt's
 * preprocessor cannot see; pass them through to the C compiler.
 * (#passthru only keeps its position at file scope, so options that
 * may be missing are defined to -1 here rather than #ifdef'ed in the
 * function bodies; setsockopt(-1) fails cleanly at run time.)
 */
#passthru #if !defined(IPV6_JOIN_GROUP) && defined(IPV6_ADD_MEMBERSHIP)
#passthru #define IPV6_JOIN_GROUP IPV6_ADD_MEMBERSHIP
#passthru #endif
#passthru #ifndef SO_REUSEPORT
#passthru #define SO_REUSEPORT -1
#passthru #endif
#passthru #ifndef IP_HDRINCL
#passthru #define IP_HDRINCL -1
#passthru #endif
#passthru #ifndef IPPROTO_ICMPV6
#passthru #define IPPROTO_ICMPV6 -1
#passthru #endif
#passthru #ifndef IPPROTO_PIM
#passthru #define IPPROTO_PIM -1
#passthru #endif
#passthru #ifndef IPPROTO_RAW
#passthru #define IPPROTO_RAW -1
#passthru #endif
#passthru #ifndef IP_ADD_SOURCE_MEMBERSHIP
#passthru #define IP_ADD_SOURCE_MEMBERSHIP -1
#passthru #define UNICON_NO_IP_MREQ_SOURCE 1
#passthru #endif
#passthru #ifdef UNICON_NO_IP_MREQ_SOURCE
#passthru struct ip_mreq_source { struct in_addr imr_multiaddr, imr_interface, imr_sourceaddr; };
#passthru #endif
#passthru #if !defined(IPV6_LEAVE_GROUP) && defined(IPV6_DROP_MEMBERSHIP)
#passthru #define IPV6_LEAVE_GROUP IPV6_DROP_MEMBERSHIP
#passthru #endif
#passthru #ifndef IP_DROP_SOURCE_MEMBERSHIP
#passthru #define IP_DROP_SOURCE_MEMBERSHIP -1
#passthru #endif
#passthru #ifndef MCAST_JOIN_SOURCE_GROUP
#passthru #define MCAST_JOIN_SOURCE_GROUP -1
#passthru #define MCAST_LEAVE_SOURCE_GROUP -1
#passthru #define UNICON_NO_GROUP_SOURCE_REQ 1
#passthru #endif
#passthru #ifdef UNICON_NO_GROUP_SOURCE_REQ
#passthru struct group_source_req {
#passthru    unsigned int gsr_interface;
#passthru    struct sockaddr_storage gsr_group;
#passthru    struct sockaddr_storage gsr_source;
#passthru };
#passthru #endif

/*
 * Fill a group_source_req for an IPv6 SSM join/leave.
 */
static int sock_fill_gsr6(struct group_source_req *gsr, char *grp, char *src,
                          unsigned int if6)
{
   struct sockaddr_in6 *g6, *s6;

   if (src == NULL)
      return -1;
   memset(gsr, 0, sizeof(*gsr));
   gsr->gsr_interface = if6;
   g6 = (struct sockaddr_in6 *)&gsr->gsr_group;
   s6 = (struct sockaddr_in6 *)&gsr->gsr_source;
   g6->sin6_family = AF_INET6;
   s6->sin6_family = AF_INET6;
   /*
    * sin6_len exists on BSD/macOS.  Use config macros rtt can see,
    * not SIN6_LEN: #passthru ifdefs do not wrap following statements
    * inside functions (file-scope only).
    */
#if defined(BSD_4_4_LITE) || defined(MacOS)
   g6->sin6_len = sizeof(*g6);
   s6->sin6_len = sizeof(*s6);
#endif                                  /* BSD_4_4_LITE || MacOS */
   if (inet_pton(AF_INET6, grp, &g6->sin6_addr) != 1 ||
       inet_pton(AF_INET6, src, &s6->sin6_addr) != 1) {
      errno = EINVAL;
      return -1;
      }
   return 0;
}

/*
 * Winsock socket calls often leave errno 0; pull WSAGetLastError() so
 * soft-success checks and set_syserrortext() see the real code.
 */
static void sock_winsock_errno(void)
{
#if NT
   if (errno == 0) {
      int wsa = WSAGetLastError();
      if (wsa != 0)
         errno = wsa;
      }
#endif                                  /* NT */
}

/*
 * True if errno means an idempotent multicast membership change
 * (already a member / already not a member).  CRT EINVAL (22) and
 * WSAEINVAL (10022) are different values on Windows.
 */
static int sock_mcast_idempotent_err(void)
{
   sock_winsock_errno();
   if (errno == EADDRINUSE || errno == EADDRNOTAVAIL || errno == EINVAL)
      return 1;
#if NT
   if (errno == WSAEINVAL)
      return 1;
#endif                                  /* NT */
   return 0;
}

/*
 * IPv6 SSM join or leave via MCAST_JOIN/LEAVE_SOURCE_GROUP.
 * One setsockopt only: no multi-iface walks or ifindex retries.
 * Those patterns have triggered macOS kernel panics in IPv6 source
 * filter teardown (in6_mcast).  Prefer an explicit iface= so if6 is
 * non-zero; already-member / already-gone is success.
 */
static int sock_ssm6(int s, char *grp, char *src, unsigned int if6, int join)
{
   struct group_source_req gsr;
   int rc, opt;

   if (sock_fill_gsr6(&gsr, grp, src, if6) < 0)
      return -1;
   opt = join ? MCAST_JOIN_SOURCE_GROUP : MCAST_LEAVE_SOURCE_GROUP;
   rc = setsockopt(s, IPPROTO_IPV6, opt, (char *)&gsr, sizeof(gsr));
   if (rc < 0 && sock_mcast_idempotent_err())
      return 0;
   return rc;
}

/*
 * One ASM/SSM join attempt.  Already-member is success.
 */
static int sock_join_on_if(int s, struct in_addr g4, char *src,
                           struct in_addr if4)
{
   int rc;

   if (src == NULL) {
      struct ip_mreq mreq;
      memset(&mreq, 0, sizeof(mreq));
      mreq.imr_multiaddr = g4;
      mreq.imr_interface = if4;
      rc = setsockopt(s, IPPROTO_IP, IP_ADD_MEMBERSHIP,
                      (char *)&mreq, sizeof(mreq));
      }
   else {
      struct ip_mreq_source mreqs;
      struct in_addr s4;
      if (inet_pton(AF_INET, src, &s4) != 1) {
         errno = EINVAL;
         return -1;
         }
      memset(&mreqs, 0, sizeof(mreqs));
      mreqs.imr_multiaddr = g4;
      mreqs.imr_sourceaddr = s4;
      mreqs.imr_interface = if4;
      rc = setsockopt(s, IPPROTO_IP, IP_ADD_SOURCE_MEMBERSHIP,
                      (char *)&mreqs, sizeof(mreqs));
      }
   if (rc < 0 && sock_mcast_idempotent_err())
      return 0;
   return rc;
}

/*
 * Join a multicast group.  grp is the group address; src, when not
 * NULL, is a source address for a source-specific (SSM) join.  if4/if6
 * select the interface.  When if4 is INADDR_ANY (no iface= attribute),
 * join on every IPv4 interface so same-host and multi-homed receives
 * work without naming a NIC; an explicit iface= still joins only that one.
 */
static int sock_join_group(int s, char *grp, char *src,
                           struct in_addr if4, unsigned int if6)
{
   struct in_addr g4;
   struct in6_addr g6;
   int rc = -1;

   if (inet_pton(AF_INET, grp, &g4) == 1) {
      if (if4.s_addr != htonl(INADDR_ANY))
         return sock_join_on_if(s, g4, src, if4);
#if UNIX
      {
         struct ifaddrs *ifa0 = NULL, *ifa;
         int ok = 0, saw = 0;

         if (getifaddrs(&ifa0) == 0) {
            for (ifa = ifa0; ifa != NULL; ifa = ifa->ifa_next) {
               struct in_addr ifa4;
               if (ifa->ifa_addr == NULL ||
                   ifa->ifa_addr->sa_family != AF_INET)
                  continue;
               if (!(ifa->ifa_flags & IFF_UP))
                  continue;
               ifa4 = ((struct sockaddr_in *)ifa->ifa_addr)->sin_addr;
               saw = 1;
               if (sock_join_on_if(s, g4, src, ifa4) == 0)
                  ok = 1;
               }
            freeifaddrs(ifa0);
            }
         if (ok)
            return 0;
         if (saw) {
            /* every per-iface join failed; fall through to INADDR_ANY */
            ;
            }
         }
#endif                                  /* UNIX */
      return sock_join_on_if(s, g4, src, if4);
      }
   else if (inet_pton(AF_INET6, grp, &g6) == 1) {
      if (src != NULL)
         return sock_ssm6(s, grp, src, if6, 1);
      {
      struct ipv6_mreq mreq6;
      memset(&mreq6, 0, sizeof(mreq6));
      mreq6.ipv6mr_multiaddr = g6;
      mreq6.ipv6mr_interface = if6;
      rc = setsockopt(s, IPPROTO_IPV6, IPV6_JOIN_GROUP,
                      (char *)&mreq6, sizeof(mreq6));
      if (rc < 0 && sock_mcast_idempotent_err())
         return 0;
      if (rc < 0)
         sock_winsock_errno();
      return rc;
      }
      }
   errno = EINVAL;
   return -1;
}

/*
 * If the caller did not set iface=, pick an outbound multicast interface.
 * Prefer a non-loopback IPv4 address so packets can leave the host;
 * IP_MULTICAST_LOOP (kernel default on) still delivers a local copy to
 * receivers that joined on that interface.  Fall back to 127.0.0.1 when
 * the host has no other UP address.
 */
static void sock_ensure_mcast_if(int s)
{
   struct in_addr cur, pick;
   unsigned int olen;

   if (sock_family(s) != AF_INET)
      return;
   olen = sizeof(cur);
   if (getsockopt(s, IPPROTO_IP, IP_MULTICAST_IF,
                  (char *)&cur, &olen) == 0 &&
       cur.s_addr != htonl(INADDR_ANY) && cur.s_addr != 0)
      return;                           /* explicit iface= already applied */

   pick.s_addr = htonl(INADDR_LOOPBACK);
#if UNIX
   {
      struct ifaddrs *ifa0 = NULL, *ifa;
      if (getifaddrs(&ifa0) == 0) {
         for (ifa = ifa0; ifa != NULL; ifa = ifa->ifa_next) {
            struct in_addr a;
            if (ifa->ifa_addr == NULL ||
                ifa->ifa_addr->sa_family != AF_INET)
               continue;
            if (!(ifa->ifa_flags & IFF_UP) ||
                (ifa->ifa_flags & IFF_LOOPBACK))
               continue;
            a = ((struct sockaddr_in *)ifa->ifa_addr)->sin_addr;
            if (a.s_addr == htonl(INADDR_ANY))
               continue;
            pick = a;
            break;
            }
         freeifaddrs(ifa0);
         }
      }
#endif                                  /* UNIX */
   setsockopt(s, IPPROTO_IP, IP_MULTICAST_IF,
              (char *)&pick, sizeof(pick));
}

/*
 * Parse an iface value: IPv4 dotted address, numeric interface index,
 * or an interface name ("en0" / "eth0" / "lo0" on UNIX; "loopback_0"
 * etc. on Windows).  "lo" and "lo0" are accepted as the IPv6 loopback
 * interface on Windows too (mapped via if_nametoindex("loopback_0")).
 * On success sets *have4/*have6 and the corresponding if4/if6 values.
 */
static int sock_parse_iface(char *val, long ival,
                              struct in_addr *if4, unsigned int *if6,
                              int *have4, int *have6)
{
   struct in_addr a;
   unsigned int idx;

   *have4 = *have6 = 0;
   if (inet_pton(AF_INET, val, &a) == 1) {
      *if4 = a;
      *have4 = 1;
      return 1;
      }
   if (val[0] != '\0' && strspn(val, "0123456789") == strlen(val)) {
      *if6 = (unsigned int)ival;
      *have6 = 1;
      return 1;
      }
   idx = if_nametoindex(val);
#if NT
   /*
    * UNIX-style loopback names show up in portable examples/tests;
    * Windows exports the NDIS name "loopback_0" instead.
    */
   if (idx == 0 && (strcmp(val, "lo") == 0 || strcmp(val, "lo0") == 0))
      idx = if_nametoindex("loopback_0");
#endif                                  /* NT */
   if (idx == 0) {
      errno = EINVAL;
      return 0;
      }
   *if6 = idx;
   *have6 = 1;
#if UNIX
   {
      struct ifaddrs *ifa0, *ifa;

      if (getifaddrs(&ifa0) == 0) {
         for (ifa = ifa0; ifa != NULL; ifa = ifa->ifa_next) {
            if (ifa->ifa_addr == NULL || ifa->ifa_name == NULL)
               continue;
            if (ifa->ifa_addr->sa_family != AF_INET)
               continue;
            if (strcmp(ifa->ifa_name, val) != 0)
               continue;
            *if4 = ((struct sockaddr_in *)ifa->ifa_addr)->sin_addr;
            *have4 = 1;
            break;
            }
         freeifaddrs(ifa0);
         }
      }
#endif                                  /* UNIX */
   return 1;
}

/*
 * Leave a multicast group previously joined with sock_join_group().
 * DROP must use the same interface as the matching join; when the
 * caller omits iface= and getsockopt(IP_MULTICAST_IF) did not recover
 * it (seen on some Linux/musl builds), retry INADDR_ANY and each local
 * IPv4 address.  Already-not-a-member is success.
 */
static int sock_leave_group(int s, char *grp, char *src,
                            struct in_addr if4, unsigned int if6)
{
   struct in_addr g4;
   struct in6_addr g6;
   int rc = -1;

   if (inet_pton(AF_INET, grp, &g4) == 1) {
      if (src == NULL) {
         struct ip_mreq mreq;
         memset(&mreq, 0, sizeof(mreq));
         mreq.imr_multiaddr = g4;
         mreq.imr_interface = if4;
         rc = setsockopt(s, IPPROTO_IP, IP_DROP_MEMBERSHIP,
                         (char *)&mreq, sizeof(mreq));
         if (rc < 0 && if4.s_addr != htonl(INADDR_ANY)) {
            mreq.imr_interface.s_addr = htonl(INADDR_ANY);
            rc = setsockopt(s, IPPROTO_IP, IP_DROP_MEMBERSHIP,
                            (char *)&mreq, sizeof(mreq));
            }
#if UNIX
         /*
          * Drop on every iface: a no-iface join membership may exist on
          * several NICs, and a mismatched single DROP looks like failure.
          */
         {
            struct ifaddrs *ifa0 = NULL, *ifa;
            int ok = (rc == 0);
            if (getifaddrs(&ifa0) == 0) {
               for (ifa = ifa0; ifa != NULL; ifa = ifa->ifa_next) {
                  if (ifa->ifa_addr == NULL ||
                      ifa->ifa_addr->sa_family != AF_INET)
                     continue;
                  mreq.imr_interface =
                     ((struct sockaddr_in *)ifa->ifa_addr)->sin_addr;
                  if (setsockopt(s, IPPROTO_IP, IP_DROP_MEMBERSHIP,
                                 (char *)&mreq, sizeof(mreq)) == 0)
                     ok = 1;
                  }
               freeifaddrs(ifa0);
               }
            if (ok)
               rc = 0;
            }
#endif                                  /* UNIX */
         }
      else {
         struct ip_mreq_source mreqs;
         struct in_addr s4;
         if (inet_pton(AF_INET, src, &s4) != 1) {
            errno = EINVAL;
            return -1;
            }
         memset(&mreqs, 0, sizeof(mreqs));
         mreqs.imr_multiaddr = g4;
         mreqs.imr_sourceaddr = s4;
         mreqs.imr_interface = if4;
         rc = setsockopt(s, IPPROTO_IP, IP_DROP_SOURCE_MEMBERSHIP,
                         (char *)&mreqs, sizeof(mreqs));
         if (rc < 0 && if4.s_addr != htonl(INADDR_ANY)) {
            mreqs.imr_interface.s_addr = htonl(INADDR_ANY);
            rc = setsockopt(s, IPPROTO_IP, IP_DROP_SOURCE_MEMBERSHIP,
                            (char *)&mreqs, sizeof(mreqs));
            }
         }
      }
   else if (inet_pton(AF_INET6, grp, &g6) == 1) {
      if (src != NULL)
         return sock_ssm6(s, grp, src, if6, 0);
      {
      struct ipv6_mreq mreq6;
      memset(&mreq6, 0, sizeof(mreq6));
      mreq6.ipv6mr_multiaddr = g6;
      mreq6.ipv6mr_interface = if6;
      rc = setsockopt(s, IPPROTO_IPV6, IPV6_LEAVE_GROUP,
                      (char *)&mreq6, sizeof(mreq6));
      if (rc < 0 && if6 != 0) {
         mreq6.ipv6mr_interface = 0;
         rc = setsockopt(s, IPPROTO_IPV6, IPV6_LEAVE_GROUP,
                         (char *)&mreq6, sizeof(mreq6));
         }
      }
      }
   else {
      errno = EINVAL;
      return -1;
      }

   /*
    * Already-not-a-member: success.  Linux uses EADDRNOTAVAIL; some
    * stacks (macOS) report EINVAL for DROP when the group was never
    * joined; Windows often reports WSAEINVAL, or fails with errno left
    * at 0 and nothing useful in WSAGetLastError().
    */
   if (rc < 0 && sock_mcast_idempotent_err())
      return 0;
   if (rc < 0) {
      sock_winsock_errno();
      if (errno == 0)
         return 0;
      }
   return rc;
}

/*
 * When open() is not given an explicit "4" or "6" flag but a join
 * attribute is present, the group address determines what kind of
 * socket must be created (an IPv4 join on an IPv6 wildcard socket
 * fails with EINVAL).  Returns AF_INET/AF_INET6/AF_UNSPEC.
 */
int sock_attrs_af(dptr attr, int nattr)
{
   tended char *tmps;
   char grp[64], *e;
   struct in_addr g4;
   struct in6_addr g6;
   int a;

   for (a = 0; a < nattr; a++) {
      if (is:null(attr[a]))
         continue;
      if (!cnv:C_string(attr[a], tmps))
         continue;
      if (strncmp(tmps, "join=", 5) != 0)
         continue;
      SAFE_strncpy(grp, tmps+5, sizeof(grp));
      if ((e = strchr(grp, ',')) != NULL)
         *e = '\0';
      if (inet_pton(AF_INET, grp, &g4) == 1)
         return AF_INET;
      if (inet_pton(AF_INET6, grp, &g6) == 1)
         return AF_INET6;
      }
   return AF_UNSPEC;
}

/*
 * True if open() was given at least one socket attribute (not SSL and
 * not a leading timeout integer).  Used to decide whether a cache hit
 * can be a pure File alias or needs an independent socket.
 */
static int sock_open_has_attrs(dptr attr, int nattr)
{
   tended char *tmps;
   char abuf[256], *eq;
   int a;
   C_integer tmpint;

   for (a = 0; a < nattr; a++) {
      if (is:null(attr[a]))
         continue;
      if (a == 0 && cnv:C_integer(attr[a], tmpint))
         continue;
      if (!cnv:C_string(attr[a], tmps))
         continue;
      if (strlen(tmps) < 3 || strlen(tmps) >= sizeof(abuf))
         continue;
      strcpy(abuf, tmps);
      if ((eq = strchr(abuf, '=')) == NULL || eq == abuf || eq[1] == '\0')
         continue;
      *eq = '\0';
      if (is_sock_attr(abuf))
         return 1;
      }
   return 0;
}

/*
 * Parse and apply "name=value" socket attributes from open()'s trailing
 * arguments to socket s.  Attributes belonging to the other pass, SSL
 * attributes, and a leading integer timeout argument are skipped.
 * autojoin, when not NULL, is a multicast group the socket was bound to:
 * it is joined after the post-bind attributes, honoring any iface
 * among them, unless an explicit join attribute takes over memberships.
 * autosource (from source@group in the address) selects an SSM join of
 * that group instead of ASM; source= attributes do the same and may be
 * repeated for multiple sources.  Returns 1 on success; returns 0 with
 * &errortext/errno set on failure.
 */
int apply_sock_attrs(int s, int prebind, dptr attr, int nattr,
                     char *autojoin, char *autosource, int join_only)
{
   tended char *tmps;
   char abuf[256], *val, *src;
   long ival;
   int a, rc, on, is_pre, saw_join = 0, saw_source = 0;
   C_integer tmpint;
   struct in_addr mcif4;
   unsigned int mcif6 = 0, olen;

   /*
    * Seed the join interface from the socket's current iface, so a
    * prior Attrib(f, "iface=...") (or setsockopt) is honored by a
    * later join= in a separate apply_sock_attrs() call.
    */
   mcif4.s_addr = htonl(INADDR_ANY);
   olen = sizeof(mcif4);
   if (getsockopt(s, IPPROTO_IP, IP_MULTICAST_IF, (char *)&mcif4, &olen) < 0)
      mcif4.s_addr = htonl(INADDR_ANY);
   olen = sizeof(mcif6);
   if (getsockopt(s, IPPROTO_IPV6, IPV6_MULTICAST_IF, (char *)&mcif6, &olen) < 0)
      mcif6 = 0;

   for (a = 0; a < nattr; a++) {
      if (is:null(attr[a]))
         continue;
      /* the first extra argument may be an integer connection timeout */
      if (a == 0 && cnv:C_integer(attr[a], tmpint))
         continue;
      if (!cnv:C_string(attr[a], tmps)) {
         errno = 0;                     /* &errortext carries the error */
         set_errortext(1310);
         return 0;
         }

      /*
       * Attributes have the form name=value; same sanity checks as the
       * SSL attribute parser.  Split a private copy: cnv:C_string can
       * return the caller's own string storage (see cnv_c_str), which
       * must not be mutated because later passes parse it again.
       */
      if (strlen(tmps) < 3 || strlen(tmps) >= sizeof(abuf) ||
          tmps[0] == '=' || tmps[strlen(tmps)-1] == '=' ||
          strchr(tmps, '=') == NULL) {
         errno = 0;                     /* &errortext carries the error */
         set_errortext_with_val(1310, tmps);
         return 0;
         }
      strcpy(abuf, tmps);
      val = strchr(abuf, '=');
      *val++ = '\0';

      if (!is_sock_attr(abuf)) {
#if HAVE_LIBSSL
         if (is_ssl_attr(abuf))
            continue;                   /* handled by create_ssl_context() */
#endif                                  /* HAVE_LIBSSL */
         errno = 0;                     /* &errortext carries the error */
         set_errortext_with_val(1310, tmps);
         return 0;
         }

      /*
       * Cache-hit opens share the kernel socket with earlier aliases.
       * Only additive membership (join=/source=) is allowed; leave= and
       * option changes would retune traffic for every live File.
       */
      if (join_only &&
          strcmp(abuf, "join") != 0 && strcmp(abuf, "source") != 0) {
         errno = 0;
         set_errortext_with_val(1310, tmps);
         return 0;
         }

      /* skip attributes that belong to the other pass */
      is_pre = (strcmp(abuf, "reuseaddr") == 0 ||
                strcmp(abuf, "reuseport") == 0);
      if (is_pre != (prebind != 0))
         continue;

      /* boolean attributes take yes/no, like verifyPeer */
      if (strcmp(abuf, "reuseaddr") == 0 || strcmp(abuf, "reuseport") == 0 ||
          strcmp(abuf, "broadcast") == 0 || strcmp(abuf, "mcastloop") == 0 ||
          strcmp(abuf, "hdrincl") == 0) {
         if ((on = sock_attr_bool(val)) < 0) {
            errno = 0;
            set_errortext_with_val(1310, tmps);
            return 0;
            }
         }

      ival = atol(val);
      rc = 0;

      if (strcmp(abuf, "reuseaddr") == 0)
         rc = setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (char *)&on, sizeof(on));
      else if (strcmp(abuf, "reuseport") == 0)
         rc = setsockopt(s, SOL_SOCKET, SO_REUSEPORT, (char *)&on, sizeof(on));
      else if (strcmp(abuf, "broadcast") == 0)
         rc = setsockopt(s, SOL_SOCKET, SO_BROADCAST, (char *)&on, sizeof(on));
      else if (strcmp(abuf, "hdrincl") == 0)
         rc = setsockopt(s, IPPROTO_IP, IP_HDRINCL, (char *)&on, sizeof(on));
      else if (strcmp(abuf, "proto") == 0)
         rc = 0;                        /* consumed at socket() for SOCK_RAW */
      else if (strcmp(abuf, "rcvbuf") == 0) {
         int sz = ival;
         rc = setsockopt(s, SOL_SOCKET, SO_RCVBUF, (char *)&sz, sizeof(sz));
         }
      else if (strcmp(abuf, "sndbuf") == 0) {
         int sz = ival;
         rc = setsockopt(s, SOL_SOCKET, SO_SNDBUF, (char *)&sz, sizeof(sz));
         }
      else if (strcmp(abuf, "ttl") == 0) {
         /*
          * Set both unicast and multicast hop limits.  The stack uses
          * whichever matches the destination; one attr covers UDP/raw.
          */
         if (sock_family(s) == AF_INET6) {
            int hops = ival;
            rc = setsockopt(s, IPPROTO_IPV6, IPV6_UNICAST_HOPS,
                            (char *)&hops, sizeof(hops));
            if (rc == 0)
               rc = setsockopt(s, IPPROTO_IPV6, IPV6_MULTICAST_HOPS,
                               (char *)&hops, sizeof(hops));
            }
         else {
            int ttl4 = ival;
            unsigned char mttl = ival;
            rc = setsockopt(s, IPPROTO_IP, IP_TTL,
                            (char *)&ttl4, sizeof(ttl4));
            if (rc == 0)
               rc = setsockopt(s, IPPROTO_IP, IP_MULTICAST_TTL,
                               (char *)&mttl, sizeof(mttl));
            }
         }
      else if (strcmp(abuf, "mcastloop") == 0) {
         if (sock_family(s) == AF_INET6) {
            unsigned int loop6 = on;
            rc = setsockopt(s, IPPROTO_IPV6, IPV6_MULTICAST_LOOP,
                            (char *)&loop6, sizeof(loop6));
            }
         else {
            unsigned char loop4 = on;
            rc = setsockopt(s, IPPROTO_IP, IP_MULTICAST_LOOP,
                            (char *)&loop4, sizeof(loop4));
            }
         }
      else if (strcmp(abuf, "iface") == 0) {
         struct in_addr ifa;
         unsigned int ifx = 0;
         int have4 = 0, have6 = 0;

         if (!sock_parse_iface(val, ival, &ifa, &ifx, &have4, &have6)) {
            errno = EINVAL;
            rc = -1;
            }
         else {
            if (have4)
               mcif4 = ifa;             /* also used by subsequent joins */
            if (have6)
               mcif6 = ifx;
            if (sock_family(s) == AF_INET6) {
               if (!have6) {
                  errno = EINVAL;
                  rc = -1;
                  }
               else
                  rc = setsockopt(s, IPPROTO_IPV6, IPV6_MULTICAST_IF,
                                  (char *)&mcif6, sizeof(mcif6));
               }
            else if (have4)
               rc = setsockopt(s, IPPROTO_IP, IP_MULTICAST_IF,
                               (char *)&ifa, sizeof(ifa));
            else if (have6)
               /* bare numeric index on an IPv4 socket */
               rc = setsockopt(s, IPPROTO_IPV6, IPV6_MULTICAST_IF,
                               (char *)&mcif6, sizeof(mcif6));
            else {
               errno = EINVAL;
               rc = -1;
               }
            }
         }
      else if (strcmp(abuf, "join") == 0) {
         saw_join = 1;
         if ((src = strchr(val, ',')) != NULL)
            *src++ = '\0';
         rc = sock_join_group(s, val, src, mcif4, mcif6);
         }
      else if (strcmp(abuf, "leave") == 0) {
         if ((src = strchr(val, ',')) != NULL)
            *src++ = '\0';
         rc = sock_leave_group(s, val, src, mcif4, mcif6);
         }
      else if (strcmp(abuf, "source") == 0) {
         /*
          * SSM shortcut: join the group this socket was bound to, from
          * the given source.  Requires a multicast bind address; use
          * join=group,source when binding a wildcard instead.
          */
         if (autojoin == NULL) {
            errno = 0;
            set_errortext_with_val(1310, tmps);
            return 0;
            }
         saw_source = 1;
         rc = sock_join_group(s, autojoin, val, mcif4, mcif6);
         }

      if (rc < 0) {
         sock_winsock_errno();
         set_syserrortext(errno);
         return 0;
         }
      }

   /*
    * A socket bound to a multicast group address implicitly joins that
    * group (ASM), or does an SSM join when the address was source@group.
    * Explicit join attributes take manual control and suppress this;
    * source= attributes already joined above and suppress the ASM default
    * unless source@group also requests its own SSM membership.
    */
   if (autojoin != NULL && !prebind && !saw_join) {
      if (autosource != NULL) {
         if (sock_join_group(s, autojoin, autosource, mcif4, mcif6) < 0) {
            set_syserrortext(errno);
            return 0;
            }
         }
      else if (!saw_source) {
         if (sock_join_group(s, autojoin, NULL, mcif4, mcif6) < 0) {
            set_syserrortext(errno);
            return 0;
            }
         }
      }
   return 1;
}

/*
 * sattrib - get or set a socket attribute, WAttrib-style.
 *   str with '=' sets; without '=' queries.
 * Writes the result into *answer (string or integer) using abuf for
 * string results.  Returns Succeeded, Failed, or RunError.
 * Membership attributes (join/leave/source) are set-only.
 */
int sattrib(int s, char *str, long len, dptr answer, char *abuf)
{
   tended struct descrip attrd;
   char name[256], *eq;
   int on, v, af;
   unsigned int u, olen;
   unsigned char uc;
   struct in_addr ifa;

   if (len < 1 || len >= (long)sizeof(name))
      return RunError;
   memcpy(name, str, (size_t)len);
   name[len] = '\0';

   if ((eq = strchr(name, '=')) != NULL) {
      /*
       * Set: reuse apply_sock_attrs() so open() and Attrib() share one
       * implementation.  Both passes run so reuse* (pre-bind) and the
       * post-bind options are all reachable.  Bad names/values are
       * RunError (error 1310); setsockopt failures are Failed.
       */
      MakeStr(str, len, &attrd);
      {
      CURTSTATE();
      k_errornumber = 0;
      if (!apply_sock_attrs(s, 1, &attrd, 1, NULL, NULL, 0) ||
          !apply_sock_attrs(s, 0, &attrd, 1, NULL, NULL, 0)) {
         if (k_errornumber == 1310)
            return RunError;
         return Failed;
         }
      }
      return Succeeded;
      }

   /* query */
   if (!is_sock_attr(name))
      return RunError;
   if (strcmp(name, "join") == 0 || strcmp(name, "leave") == 0 ||
       strcmp(name, "source") == 0 || strcmp(name, "proto") == 0)
      return Failed;                    /* memberships/create-time only */

   af = sock_family(s);

   if (strcmp(name, "reuseaddr") == 0) {
      olen = sizeof(on);
      if (getsockopt(s, SOL_SOCKET, SO_REUSEADDR, (char *)&on, &olen) < 0)
         return Failed;
      strcpy(abuf, on ? "yes" : "no");
      MakeStr(abuf, strlen(abuf), answer);
      return Succeeded;
      }
   if (strcmp(name, "reuseport") == 0) {
      olen = sizeof(on);
      if (getsockopt(s, SOL_SOCKET, SO_REUSEPORT, (char *)&on, &olen) < 0)
         return Failed;
      strcpy(abuf, on ? "yes" : "no");
      MakeStr(abuf, strlen(abuf), answer);
      return Succeeded;
      }
   if (strcmp(name, "broadcast") == 0) {
      olen = sizeof(on);
      if (getsockopt(s, SOL_SOCKET, SO_BROADCAST, (char *)&on, &olen) < 0)
         return Failed;
      strcpy(abuf, on ? "yes" : "no");
      MakeStr(abuf, strlen(abuf), answer);
      return Succeeded;
      }
   if (strcmp(name, "hdrincl") == 0) {
      olen = sizeof(on);
      if (getsockopt(s, IPPROTO_IP, IP_HDRINCL, (char *)&on, &olen) < 0)
         return Failed;
      strcpy(abuf, on ? "yes" : "no");
      MakeStr(abuf, strlen(abuf), answer);
      return Succeeded;
      }
   if (strcmp(name, "rcvbuf") == 0) {
      olen = sizeof(v);
      if (getsockopt(s, SOL_SOCKET, SO_RCVBUF, (char *)&v, &olen) < 0)
         return Failed;
      MakeInt(v, answer);
      return Succeeded;
      }
   if (strcmp(name, "sndbuf") == 0) {
      olen = sizeof(v);
      if (getsockopt(s, SOL_SOCKET, SO_SNDBUF, (char *)&v, &olen) < 0)
         return Failed;
      MakeInt(v, answer);
      return Succeeded;
      }
   if (strcmp(name, "ttl") == 0) {
      /* report the multicast hop limit; set writes both uni and mcast */
      if (af == AF_INET6) {
         olen = sizeof(v);
         if (getsockopt(s, IPPROTO_IPV6, IPV6_MULTICAST_HOPS,
                        (char *)&v, &olen) < 0)
            return Failed;
         MakeInt(v, answer);
         }
      else {
         olen = sizeof(uc);
         if (getsockopt(s, IPPROTO_IP, IP_MULTICAST_TTL,
                        (char *)&uc, &olen) < 0)
            return Failed;
         MakeInt((word)uc, answer);
         }
      return Succeeded;
      }
   if (strcmp(name, "mcastloop") == 0) {
      if (af == AF_INET6) {
         olen = sizeof(u);
         if (getsockopt(s, IPPROTO_IPV6, IPV6_MULTICAST_LOOP,
                        (char *)&u, &olen) < 0)
            return Failed;
         on = u;
         }
      else {
         olen = sizeof(uc);
         if (getsockopt(s, IPPROTO_IP, IP_MULTICAST_LOOP,
                        (char *)&uc, &olen) < 0)
            return Failed;
         on = uc;
         }
      strcpy(abuf, on ? "yes" : "no");
      MakeStr(abuf, strlen(abuf), answer);
      return Succeeded;
      }
   if (strcmp(name, "iface") == 0) {
      if (af == AF_INET6) {
         olen = sizeof(u);
         if (getsockopt(s, IPPROTO_IPV6, IPV6_MULTICAST_IF,
                        (char *)&u, &olen) < 0)
            return Failed;
         MakeInt((word)u, answer);
         }
      else {
         olen = sizeof(ifa);
         if (getsockopt(s, IPPROTO_IP, IP_MULTICAST_IF,
                        (char *)&ifa, &olen) < 0)
            return Failed;
         if (inet_ntop(AF_INET, &ifa, abuf, 64) == NULL)
            return Failed;
         MakeStr(abuf, strlen(abuf), answer);
         }
      return Succeeded;
      }
   return RunError;
}

/*
 * Empty handler for connection alarm signals (used for timeouts).
 */
/* static void on_alarm(int x)
{
}
*/

int sock_connect(char *fn, int sock_type, int timeout, int af_fam,
                 dptr attr, int nattr)
{
  int saveflags, rc, s, len, ipproto = 0, stype, sproto;
   struct sockaddr *sa;
   char *p, fname[BUFSIZ];
   struct addrinfo *res, *res0, *saddrinfo;

#if UNIX
   struct sockaddr_un saddr_un;
   int pathbuf_len = sizeof(saddr_un.sun_path);
#endif                                  /* UNIX */

   errno = 0;
   SAFE_strncpy(fname, fn, sizeof(fname));

   /*
    * Raw sockets need the IP protocol number before socket().
    */
   if (sock_type == SOCK_T_RAW) {
      rc = sock_attr_proto(attr, nattr, &ipproto);
      if (rc < 0)
         return 0;
      if (rc == 0) {
         errno = 0;
         set_errortext_with_val(1310, "proto");
         return 0;
         }
      }

   /*
    * host:port for TCP/UDP.  Raw sockets usually have no port; take
    * host:port only when there is a single colon (IPv4/hostname), so a
    * bare IPv6 literal is not misparsed as host + port.
    */
   p = strrchr(fname, ':');
   if (sock_type == SOCK_T_RAW && p != NULL &&
       (strchr(fname, ':') != p || p[1] == '\0'))
      p = NULL;

   if (p != NULL || sock_type == SOCK_T_RAW) {
      char *mcsrc, srcbuf[INET6_ADDRSTRLEN];
      char *portstr = NULL;

      if (p != NULL) {
         *p = 0;
         portstr = p + 1;
         /*
          * source@group:port is an SSM receiver address; for send/connect
          * the destination is just the group, so keep only the group here.
          */
         if (!sock_split_group_source(fname, srcbuf, sizeof(srcbuf), &mcsrc)) {
            set_syserrortext(errno);
            return 0;
            }
         }
      res0 = uni_getaddrinfo(fname, portstr, sock_type, af_fam);
      /* Restore the argument just in case */
      if (p != NULL)
         *p = ':';

      if (!res0)
        return 0;

      s = -1;
      for (res = res0; res; res = res->ai_next) {
        if (sock_type == SOCK_T_RAW) {
           stype = SOCK_RAW;
           sproto = ipproto;
           }
        else {
           stype = res->ai_socktype;
           sproto = res->ai_protocol;
           }
        s = socket(res->ai_family, stype, sproto);
        if (s < 0) {
          continue;
        }

        /*
        if (connect(s, res->ai_addr, res->ai_addrlen) < 0) {
          sock_close(s);
          s = -1;
          continue;
        }
        */

        break;  /* okay we got one */
      }

      if (s < 0) {
        // failed to create a socket to any of the resloved names
        freeaddrinfo(res0);
        return 0;
      }

      // This is the node we care about, free all other nodes before and after it
      saddrinfo = res;
      sa = saddrinfo->ai_addr;
      len = saddrinfo->ai_addrlen;
      if (saddrinfo == res0){
        if (saddrinfo->ai_next != NULL){
          freeaddrinfo(saddrinfo->ai_next);
          saddrinfo->ai_next = NULL;
          }
      }
      else {
        for (res = res0; res->ai_next != saddrinfo; res = res->ai_next);
        res->ai_next = NULL;
        freeaddrinfo(res0);

        res = saddrinfo->ai_next;
        if (res){
          saddrinfo->ai_next = NULL;
          freeaddrinfo(res);
        }
      }

      /*
       * Sending to the limited broadcast address is unambiguous intent;
       * default SO_BROADCAST to on so the first write doesn't fail with
       * EACCES.  An explicit broadcast=no attribute overrides it below.
       */
      if (sock_type == SOCK_T_DGRAM && sa->sa_family == AF_INET &&
          ((struct sockaddr_in *)sa)->sin_addr.s_addr == htonl(INADDR_BROADCAST)) {
         int on = 1;
         setsockopt(s, SOL_SOCKET, SO_BROADCAST, (char *)&on, sizeof(on));
      }

      /*
       * Apply any socket attributes.  Client sockets are never bound
       * explicitly, so both attribute passes run back to back here.
       */
      if (!apply_sock_attrs(s, 1, attr, nattr, NULL, NULL, 0) ||
          !apply_sock_attrs(s, 0, attr, nattr, NULL, NULL, 0)) {
         sock_close(s);
         freeaddrinfo(saddrinfo);
         return 0;
      }

      /*
       * Multicast UDP send without iface=: choose a local interface so
       * the first writes() is not ENETUNREACH (no multicast route).
       */
      if (sock_type == SOCK_T_DGRAM && sockaddr_is_multicast(sa))
         sock_ensure_mcast_if(s);
   }
   else {
      /* UNIX domain socket */
#if NT
      return 0;
#endif
#if UNIX
      if (sock_type != SOCK_T_STREAM ||
          (s = socket(PF_UNIX, SOCK_STREAM, 0)) < 0)
         return 0;
      saddr_un.sun_family = AF_UNIX;
      strncpy(saddr_un.sun_path, fname, pathbuf_len);
      /* NUL-terminate just in case.... */
      saddr_un.sun_path[pathbuf_len - 1] = 0;
      len = sizeof(saddr_un.sun_family) + strlen(saddr_un.sun_path);
#ifdef SIN6_LEN  /* BSD_4_4_LITE */
      len += sizeof(saddr_un.sun_len);
      saddr_un.sun_len = len;
#endif
      sa = (struct sockaddr*) &saddr_un;
#endif                                  /* UNIX */
   }

   /*
    * UDP and raw: no connect(); always sendto(2) using the saved
    * destination from open().  Storing saddrinfo also keeps the
    * getaddrinfo() result owned until sock_close().
    */
   if (sock_type == SOCK_T_DGRAM || sock_type == SOCK_T_RAW) {
      if (s + 1 > saddrs_n) {
         struct addrinfo **na =
            realloc(saddrs, (s + 1) * sizeof(struct addrinfo *));
         if (na == NULL) {
            sock_close(s);
            freeaddrinfo(saddrinfo);
            return 0;
            }
         memset(na + saddrs_n, 0,
                (s + 1 - saddrs_n) * sizeof(struct addrinfo *));
         saddrs = na;
         saddrs_n = s + 1;
         }
      if (saddrs[s] != NULL)
         freeaddrinfo(saddrs[s]);
      saddrs[s] = saddrinfo;
      return s;
      }

   if (timeout > 0) {
#if UNIX
      /* Save existing flags for restore later */
      saveflags = fcntl(s, F_GETFL, 0);
      if (saveflags < 0) {
         sock_close(s);
         return 0;
      }
      /* Turn on non-blocking flag - this will make connect
         return immediately.  */
      if (fcntl(s, F_SETFL, saveflags|O_NONBLOCK) < 0) {
         sock_close(s);
         return 0;
      }
#endif                                  /* UNIX */
#if NT
      /* Turn on non-blocking flag so connect will return immediately. */
      unsigned long imode = 1;
      if (ioctlsocket(s, FIONBIO, &imode) < 0) {
         errno = WSAGetLastError();
         sock_close(s);
         return 0;
      }
#endif                                  /* NT */
   }

   rc = connect(s, sa, len);

   if (timeout > 0) {
#if UNIX
      /* Reset the old flags, but avoiding overwriting the value of errno */
      int connect_err = errno;
      if (fcntl(s, F_SETFL, saveflags) < 0) {
         sock_close(s);
         return 0;
      }
      errno = connect_err;

      if (rc < 0 && errno == EINPROGRESS) {
         /* The connect is in progress, so select() must be used to wait. */
         fd_set ws, es;
         struct timeval tv;
         int sc, cc;
         unsigned int cclen;

         tv.tv_sec = timeout / 1000;
         tv.tv_usec = 1000 * (timeout % 1000);
         FD_ZERO(&ws);
         FD_SET(s, &ws);
         FD_ZERO(&es);
         FD_SET(s, &es);
         errno = 0;
         sc = select(FD_SETSIZE, NULL, &ws, &es, &tv);
         /*
          * A result of 0 means timeout; in this case errno will be zero too,
          * and that can be used to distinguish from another error condition.
          */
         if (sc <= 0) {
            sock_close(s);
            return 0;
            }

         /* Get the error code of the connect */
         cclen = sizeof(cc);
         if (getsockopt(s, SOL_SOCKET, SO_ERROR, &cc, &cclen) < 0) {
            sock_close(s);
            return 0;
         }

         if (cc != 0) {
            /* There was an error, so set errno and fail */
            errno = cc;
            sock_close(s);
            return 0;
         }

         return s;
      }
#endif                                  /* UNIX */
#if NT
      /* Turn off non-blocking flag */
      int connect_err = WSAGetLastError();
      unsigned long imode = 0;
      if (ioctlsocket(s, FIONBIO, &imode) < 0) {
         errno = WSAGetLastError();
         sock_close(s);
         return 0;
      }
      errno = connect_err;

      if (rc < 0 && errno == WSAEWOULDBLOCK) {
         /* The connect is in progress, so select() must be used to wait. */
         fd_set ws, es;
         struct timeval tv;
         int sc, cc, cclen;

         tv.tv_sec = timeout / 1000;
         tv.tv_usec = 1000 * (timeout % 1000);
         FD_ZERO(&ws);
         FD_SET(s, &ws);
         FD_ZERO(&es);
         FD_SET(s, &es);
         WSASetLastError(0);
         sc = select(FD_SETSIZE, NULL, &ws, &es, &tv);
         /* A result of 0 means timeout; in this case WSAGetLastError() will return zero,
            and that can be used to distinguish from another error condition. */
         if (sc <= 0) {
            errno = WSAGetLastError();
            sock_close(s);
            return 0;
         }

         /* Get the error code of the connect */
         cclen = sizeof(cc);
         if (getsockopt(s, SOL_SOCKET, SO_ERROR, (char*)&cc, &cclen) < 0) {
            errno = WSAGetLastError();
            sock_close(s);
            return 0;
         }

         if (cc != 0) {
            /* There was an error, so set errno and fail */
            errno = cc;
            sock_close(s);
            return 0;
         }

         return s;
      }
#endif                                  /* NT */
   }

   if (rc < 0) {
      sock_close(s);
      return 0;
   }

   return s;
}


int
ip_version(const char *src) {
    char buf[16];
    if (inet_pton(AF_INET, src, buf)) {
        return 4;
    } else if (inet_pton(AF_INET6, src, buf)) {
        return 6;
    }
    return -1;
}


/*
 * Although this function is named "listen", it opens all incoming sockets,
 * including UDP sockets and non-blocking "listener" sockets on which a
 * later select() may turn up an accept.
 */
int sock_listen(char *addr, int sock_type, int keep_listener, int af_fam,
                dptr attr, int nattr)
{
  int fd, s, len, ipproto = 0, stype, sproto, rc;
   struct addrinfo *res0, *res;
   struct sockaddr *sa;
   unsigned int fromlen;
   struct sockaddr_storage from;
   int created = 0, uncached = 0, parallel = 0, retried = 0;
   int has_attrs = sock_open_has_attrs(attr, nattr);
   int is_dgram_or_raw = (sock_type == SOCK_T_DGRAM ||
                          sock_type == SOCK_T_RAW);

again:
   created = 0;
   uncached = 0;

   /*
    * Cache hit with no socket attributes: pure File alias of the
    * shared listener (owner refcount).  Cache hit with attributes:
    * release the pin and create an independent socket so join/leave/
    * ttl/iface/etc. cannot retune earlier aliases (reuseaddr lets the
    * second bind succeed).  sock_get pins until claim/release below.
    * After a failed claim (entry closing under us), retried!=0 forces
    * a fresh create rather than failing open().
    */
   s = sock_get(addr);
   if (s >= 0 && (has_attrs || retried)) {
      sock_release(s);
      parallel = 1;
      s = -1;
      }

   if (s < 0) {
     char *p, *mcsrc, fname[BUFSIZ], group[INET6_ADDRSTRLEN];
     char srcbuf[INET6_ADDRSTRLEN];
     int on, is_mc = 0;
     created = 1;

     /*
      * If the first argument is just a name, it's a unix domain socket.
      * If there's a : then it's host:port except if the host part is
      * empty, it means on any interface.  host may be source@group for
      * an SSM join of that group.
      */

      SAFE_strncpy(fname,addr, sizeof(fname));
      mcsrc = NULL;

      /* let a join attribute's group address pick the family */
      if (af_fam == AF_UNSPEC)
         af_fam = sock_attrs_af(attr, nattr);

      if (sock_type == SOCK_T_RAW) {
         rc = sock_attr_proto(attr, nattr, &ipproto);
         if (rc < 0)
            return 0;
         if (rc == 0) {
            errno = 0;
            set_errortext_with_val(1310, "proto");
            return 0;
            }
         }

      if ((p=strrchr(fname, ':')) != NULL) {
         *p = 0;
         if (!sock_split_group_source(fname, srcbuf, sizeof(srcbuf), &mcsrc)) {
            set_syserrortext(errno);
            return 0;
            }
         res0 = uni_getaddrinfo(fname, p+1, sock_type, af_fam);
         *p = ':';

         if (!res0)
            return 0;

         s = -1;
         for (res = res0; res; res = res->ai_next) {
           if (sock_type == SOCK_T_RAW) {
              stype = SOCK_RAW;
              sproto = ipproto;
              }
           else {
              stype = res->ai_socktype;
              sproto = res->ai_protocol;
              }
           s = socket(res->ai_family, stype, sproto);
           if (s < 0) {
             continue;
           }

           is_mc = sockaddr_is_multicast(res->ai_addr);

           /*
            * Listeners default to reuseaddr=yes so a restarted server
            * can rebind through TIME_WAIT; an explicit reuseaddr=no
            * attribute overrides it below.  On UNIX also set reuseport
            * (best effort): BSD/macOS need it on every sharer to bind the
            * same UDP port, including a later parallel open with attrs
            * beside a cached listener.  On Windows SO_REUSEADDR instead
            * allows a second live bind, so only multicast receivers and
            * parallel opens get it there.
            */
           on = 1;
#if UNIX
           setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (char *)&on, sizeof(on));
           setsockopt(s, SOL_SOCKET, SO_REUSEPORT, (char *)&on, sizeof(on));
#else                                   /* UNIX */
           /*
            * Windows: REUSEADDR on every UDP listener so a later
            * parallel/attr open can bind the same port.  Also for
            * multicast binds and any parallel create (TCP or UDP).
            */
           if (is_mc || parallel || sock_type == SOCK_T_DGRAM)
              setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (char *)&on, sizeof(on));
#endif                                  /* UNIX */

           /* reuse flags et al. only take effect before bind() */
           if (!apply_sock_attrs(s, 1, attr, nattr, NULL, NULL, 0)) {
             sock_close(s);
             freeaddrinfo(res0);
             return 0;
           }

           /*
            * Windows rejects bind() to a multicast group address
            * (WSAEADDRNOTAVAIL / "not valid in its context").  Bind the
            * wildcard instead; the group is still joined below via the
            * implicit autojoin (or an explicit join=/source= attribute).
            * UNIX stacks accept a group bind and use it as a filter.
            */
           if (is_mc) {
#if NT
              if (res->ai_family == AF_INET) {
                 struct sockaddr_in any4;
                 memcpy(&any4, res->ai_addr, sizeof(any4));
                 any4.sin_addr.s_addr = htonl(INADDR_ANY);
                 if (bind(s, (struct sockaddr *)&any4, sizeof(any4)) < 0) {
                    sock_close(s);
                    s = -1;
                    continue;
                    }
                 }
              else if (res->ai_family == AF_INET6) {
                 struct sockaddr_in6 any6;
                 memcpy(&any6, res->ai_addr, sizeof(any6));
                 any6.sin6_addr = in6addr_any;
                 if (bind(s, (struct sockaddr *)&any6, sizeof(any6)) < 0) {
                    sock_close(s);
                    s = -1;
                    continue;
                    }
                 }
              else {
                 sock_close(s);
                 s = -1;
                 continue;
                 }
#else                                   /* NT */
              if (bind(s, res->ai_addr, res->ai_addrlen) < 0) {
                 sock_close(s);
                 s = -1;
                 continue;
                 }
#endif                                  /* NT */
              /* remember the group address for the implicit join below */
              if (res->ai_family == AF_INET6)
                 inet_ntop(AF_INET6,
                           &((struct sockaddr_in6 *)res->ai_addr)->sin6_addr,
                           group, sizeof(group));
              else
                 inet_ntop(AF_INET,
                           &((struct sockaddr_in *)res->ai_addr)->sin_addr,
                           group, sizeof(group));
              }
           else if (bind(s, res->ai_addr, res->ai_addrlen) < 0) {
             sock_close(s);
             s = -1;
             continue;
           }

           break;  /* okay we got one */
         }

         if (res0)
           freeaddrinfo(res0);
         if (s < 0) {
#if NT
           /*
            * Winsock failures often leave errno 0; map WSAGetLastError
            * so open() does not report the leftover strerror(0) "Success".
            */
           if (errno == 0) {
              int wsa = WSAGetLastError();
              if (wsa != 0)
                 errno = wsa;
              }
#endif                                  /* NT */
           if (errno != 0)
              set_syserrortext(errno);
           return 0;  /* failed to bind to any address */
         }

         /*
          * Multicast joins and other post-bind socket attributes.  A
          * socket bound to a multicast group joins it implicitly (ASM,
          * or SSM when the address was source@group / source=).
          */
         if (!apply_sock_attrs(s, 0, attr, nattr,
                               is_mc ? group : NULL, is_mc ? mcsrc : NULL, 0)) {
           sock_close(s);
           return 0;
         }

      }
      else {
         /* unix domain socket */
#if NT
         return 0;
#endif
#if UNIX
         struct sockaddr_un saddr_un;
         int pathbuf_len;

         if (sock_type != SOCK_T_STREAM ||
             (s = socket(PF_UNIX, SOCK_STREAM, 0)) < 0)
            return 0;

         pathbuf_len = sizeof(saddr_un.sun_path);
         saddr_un.sun_family = AF_UNIX;
         strncpy(saddr_un.sun_path, addr, pathbuf_len);
         saddr_un.sun_path[pathbuf_len - 1] = 0;
         len = sizeof(saddr_un.sun_family) + strlen(saddr_un.sun_path);
#ifdef BSD_4_4_LITE
         len += sizeof(saddr_un.sun_len);
         saddr_un.sun_len = len;
#endif
         (void) unlink(saddr_un.sun_path);
         sa = (struct sockaddr*) &saddr_un;
#endif                                  /* UNIX */
         if (bind(s, sa, len) < 0) {
           return 0;
         }
      }
      /*
       * Cache only after listen() succeeds (below).  Putting a bound
       * but non-listening socket in the map left later opens stuck on
       * a failed listener.
       */
   }
   /*
    * Cached listeners are already pinned by sock_get.  Newly created
    * sockets are not in the map yet, so close cannot race listen.
    */
   if (!is_dgram_or_raw) {
     if (listen(s, SOMAXCONN) < 0) {
       /*
        * Not yet in sock_map when created==1, so a failed listen cannot
        * leave a stale cached descriptor.
        */
#if NT
       if (errno == 0) {
          int wsa = WSAGetLastError();
          if (wsa != 0)
             errno = wsa;
          }
#endif                                  /* NT */
       if (created)
          sock_close(s);
       else
          sock_release(s);
       return 0;
       }
     }

   if (created) {
      int put;
      /*
       * Another thread may have registered the same address first
       * (SO_REUSEADDR).  For a plain open (no attrs), drop our socket
       * and use the cached listener.  When this open requested socket
       * attributes (parallel), keep our configured socket uncached so
       * those attrs stay independent of the cached aliases.
       * Cache full (-1): keep this listener uncached rather than
       * closing a valid socket.
       */
      put = sock_put(addr, s);
      if (put == 0) {
         if (parallel || has_attrs)
            uncached = 1;
         else {
            sock_close(s);
            if ((s = sock_get(addr)) < 0) {
               if (retried)
                  return 0;
               retried = 1;
               parallel = 1;
               goto again;
               }
            }
         }
      else if (put < 0)
         uncached = 1;
      }

   if (is_dgram_or_raw || keep_listener) {
     if (!uncached) {
        /*
         * Convert the sock_get/sock_put pin into File ownership under
         * the cache lock.  If claim fails the entry is closing or gone:
         * drop the pin (may finish the close) and retry once with a
         * replacement listener instead of failing a valid open().
         */
        if (!sock_claim(s)) {
           sock_release(s);
           if (retried)
              return 0;
           retried = 1;
           parallel = 1;
           goto again;
           }
        }
     else if (!sock_track(s)) {
        /*
         * Cannot track for select()/accept pin protection.  Do not
         * return a gen-0 listener that accept() would use unpinned.
         */
        sock_close(s);
        return 0;
        }
     return s;
     }

   fromlen = sizeof(from);
   DEC_NARTHREADS;
   if ((fd = accept(s, (struct sockaddr*) &from, &fromlen)) < 0) fd = 0;
   INC_NARTHREADS_CONTROLLED;
#if NT
   if (fd == 0 && errno == 0) {
      int wsa = WSAGetLastError();
      if (wsa != 0)
         errno = wsa;
      }
#endif                                  /* NT */

   if (uncached)
      sock_close(s);                    /* not retained in the cache */
   else
      sock_release(s);
   return fd;
}

/*
 * sock_name() - return (in a buffer) info on the machine we are connected to.
 * Used for image() of connected sockets.
 */
int sock_name(int s, char* addr, char* addrbuf, int bufsize)
{
   int len;
   struct sockaddr_storage conn;
   struct sockaddr* sa = (struct sockaddr*) &conn;
   unsigned int addrlen = sizeof(conn);
   char buf[INET6_ADDRSTRLEN]; // enough for ipv4/ipv6

   /*
    * We used to check sock_get(addr) to decide if this socket was someone
    * that we know anything about... but that didn't work for clients,
    * because they never called the listen() code that would introduce
    * them into the array of sockets that sock_get() uses.  So now we
    * don't check that, we assume socket s is a valid socket we opened.
    */

   /* Otherwise we can construct a name for it and put in the string */
   if (getpeername(s, sa, &addrlen) < 0)
     return 0;

   // FIXME, this check is wrong (not needed?) if we want to support v4/6
   //if (addrlen != sizeof(conn))
   //   return 0;

   if ((print_sockaddr(sa, buf, INET6_ADDRSTRLEN)) == NULL) {
     set_syserrortext(errno);
     return 0;
   }

   len = snprintf(addrbuf, bufsize, "%s:%s:%d", addr, buf, get_sa_port(sa));
   if (len>=bufsize) {
      /*
       * Truncation occurred in snprintf, and this is catastrophic, LOL.
       * But let's not be crazy about it. Output string is really only bufsize.
       * Caller can avoid this by passing a (reasonable) C string in addr.
       */
      len = bufsize-1;
      addrbuf[len] = '\0';
      }
   return len;
}

/*
 * Used for gethost(n) of connected sockets.  Similar to sock_name,
 * except it is returning MY IP # used in this socket.
 */
int sock_me(int s, char* addrbuf, int bufsize)
{
   int len;
   struct sockaddr_storage conn;
   struct sockaddr* sa = (struct sockaddr*) &conn;
   unsigned int addrlen = sizeof(conn);
   char buf[INET6_ADDRSTRLEN]; // enough for ipv4/ipv6

   if (getsockname(s, sa, &addrlen) < 0)
       return 0;

   if ((print_sockaddr(sa, buf, INET6_ADDRSTRLEN)) == NULL) {
     set_syserrortext(errno);
     return 0;
   }

   len = snprintf(addrbuf, bufsize, "%s:%d", buf, get_sa_port(sa));
   if (len>=bufsize) {
      len = bufsize-1;
      addrbuf[len] = '\0';
      }
   return len;
}


/* Used by function send(): in other words, create a socket, send, close it */
int sock_send(char *adr, char *msg, int msglen, int af_fam)
{
   char *host, *p, hostname[MAXHOSTNAMELEN], addr[BUFSIZ];
   int s, rc;
   struct addrinfo *res0, *res;

   SAFE_strncpy(addr, adr, sizeof(addr));

   if (!(p = strchr(addr, ':')))
      return 0;

   host = addr;
   *p = 0;

   if (*host == 0) {
      strncpy(hostname, "localhost", sizeof(hostname));
      host = hostname;
   }

   res0 = uni_getaddrinfo(host, p+1, SOCK_T_DGRAM, af_fam);
   *p = ':';

   if (!res0)
     return 0;

   s = -1;
   for (res = res0; res; res = res->ai_next) {
     s = socket(res->ai_family, res->ai_socktype,
                res->ai_protocol);
     if (s >= 0)
       break;  /* okay we got one */
   }

   if (s > 0) {
     rc =sendto(s, msg, msglen, 0, res->ai_addr, res->ai_addrlen);
     sock_close(s);
     freeaddrinfo(res0);
     if (rc >= 0)
       return 1 ;
   }
   else {
       freeaddrinfo(res0);
   }

   return 0;
}

/*
 * Used by function receive() to receive a UDP or raw datagram into a
 * record.  This allocates from the heaps, so rp must point at a tended
 * pointer.  For IPPROTO_ICMP raw sockets the message typically includes
 * the IP header followed by the ICMP payload.
 *
 * MSG_PEEK into a 2K stack buffer (typical MTU-sized datagrams), then
 * consume with recvfrom.  If the peek fills the buffer, receive into a
 * 64K heap buffer so the datagram is not truncated or lost.
 */
int sock_recv(int s, struct b_record **rp)
{
   int s_type, msglen, bufsize;
   char small[SOCK_RECV_SMALL];
   char *buf, *heap = NULL;
   char addrstr[NI_MAXHOST + NI_MAXSERV + 8];

   struct sockaddr_storage conn;
   struct sockaddr* sa = (struct sockaddr*) &conn;
   unsigned int len, addrlen = sizeof(conn);
   char host[NI_MAXHOST], serv[NI_MAXSERV], addrbuf[INET6_ADDRSTRLEN];

   len = sizeof(s_type);

#if NT
   if (!StartupWinSocket()) return 0;
#endif                                  /* NT */

   if (getsockopt(s, SOL_SOCKET, SO_TYPE, (char *)&s_type, &len) < 0)
      return 0;
   if (s_type != SOCK_DGRAM && s_type != SOCK_RAW)
      return -1;

   msglen = recvfrom(s, small, SOCK_RECV_SMALL, MSG_PEEK, sa, &addrlen);
   if (msglen < 0)
      return 0;

   if (msglen >= SOCK_RECV_SMALL) {
      bufsize = SOCK_RECV_LARGE;
      heap = malloc(bufsize);
      if (heap == NULL)
         return 0;
      buf = heap;
      }
   else {
      bufsize = SOCK_RECV_SMALL;
      buf = small;
      }

   addrlen = sizeof(conn);
   if ((msglen = recvfrom(s, buf, bufsize, 0, sa, &addrlen)) < 0) {
      free(heap);
      return 0;
      }

   /*
    * Exact fill of the small buffer is ambiguous (may be truncated).
    * Exact fill of the large buffer is a valid max-size IPv4 datagram
    * (65535), so do not reject it as EMSGSIZE.
    */
   if (heap == NULL && msglen >= bufsize) {
#if NT
      errno = WSAEMSGSIZE;
#else                                   /* NT */
      errno = EMSGSIZE;
#endif                                  /* NT */
      set_syserrortext(errno);
      return 0;
      }

   SetStrLen((*rp)->fields[1], msglen);
   StrLoc((*rp)->fields[1]) = alcstr(buf, msglen);
   free(heap);

   s = getnameinfo(sa, addrlen, host,
                                NI_MAXHOST,
                               serv, NI_MAXSERV, NI_NUMERICSERV);
   if (s == 0) {
      snprintf(addrstr, sizeof(addrstr), "%s:%s", host, serv);
   }
   else {
     if ((print_sockaddr(sa, addrbuf, INET6_ADDRSTRLEN)) == NULL) {
       set_syserrortext(errno);
       return 0;
     }
     snprintf(addrstr, sizeof(addrstr), "%s:%d", addrbuf, get_sa_port(sa));
   }

   String((*rp)->fields[0], addrstr);

   return 1;
}

int sock_write(int f, char *msg, int n)
{
   int rv, s_type;
   unsigned int len;
   SOCKET fd = ((SOCKET)f); /* used to wrap f inside an fdup, but no more */

   len = sizeof(s_type);
   if (getsockopt(fd, SOL_SOCKET, SO_TYPE, (char *)&s_type, &len) < 0)
      return 0;

   if (s_type == SOCK_DGRAM || s_type == SOCK_RAW) {
      rv = sendto(fd, msg, n, 0,
                  saddrs[fd]->ai_addr, saddrs[fd]->ai_addrlen);
   }
   else
      rv = send(fd, msg, n, 0);
   return rv;
}

static struct {
   char *name;
   int fd;
   unsigned gen;        /* identity; distinguishes fd number reuse */
   int pins;            /* sock_get / sock_pin holds across listen/accept */
   int owners;          /* File objects holding this cached listener */
   int closing;         /* close deferred until pins drop to 0 */
} sock_map[64] = { {0, 0, 0, 0, 0, 0} };
static int nsock = 0;
static unsigned sock_gen_seq = 1;       /* 0 reserved for "not cached" */

/*
 * Lookup a socket by name and pin it.  Caller must sock_release().
 */
static int sock_get(char *s)
{
   int i, fd = -1;
   MUTEX_LOCKID(MTX_SOCK_MAP);
   for (i = 0; i < nsock; i++)
      if (sock_map[i].name != NULL && strcmp(s, sock_map[i].name) == 0) {
         fd = sock_map[i].fd;
         sock_map[i].pins++;
         break;
         }
   MUTEX_UNLOCKID(MTX_SOCK_MAP);
   return fd;
}

/*
 * Register a listener and pin it.
 *   1  installed (pinned)
 *   0  addr already cached — caller should close fd and sock_get()
 *  -1  cache full — caller may keep using fd uncached
 */
static int sock_put(char *s, int fd)
{
   int i;
   MUTEX_LOCKID(MTX_SOCK_MAP);
   for (i = 0; i < nsock; i++)
      if (sock_map[i].name != NULL && strcmp(s, sock_map[i].name) == 0) {
         MUTEX_UNLOCKID(MTX_SOCK_MAP);
         return 0;
         }
   if (nsock >= (int)(sizeof(sock_map) / sizeof(sock_map[0]))) {
      MUTEX_UNLOCKID(MTX_SOCK_MAP);
      return -1;
      }
   sock_map[nsock].fd = fd;
   sock_map[nsock].name = (char*) malloc(strlen(s) + 1);
   strcpy(sock_map[nsock].name, s);
   if (sock_gen_seq == 0)
      sock_gen_seq = 1;                /* skip 0 after wrap */
   sock_map[nsock].gen = sock_gen_seq++;
   sock_map[nsock].pins = 1;           /* installed and pinned */
   sock_map[nsock].owners = 0;
   sock_map[nsock].closing = 0;
   nsock++;
   MUTEX_UNLOCKID(MTX_SOCK_MAP);
   return 1;
}

/*
 * Generation of a live tracked listener fd (named cache or nameless
 * track entry), or 0 if not in the map.  Stored on the File at open so
 * sock_pin can reject a reused fd number.
 */
word sock_listener_gen(int fd)
{
   int i;
   word gen = 0;

   MUTEX_LOCKID(MTX_SOCK_MAP);
   for (i = 0; i < nsock; i++)
      if (sock_map[i].fd == fd && !sock_map[i].closing) {
         gen = (word)sock_map[i].gen;
         break;
         }
   MUTEX_UNLOCKID(MTX_SOCK_MAP);
   return gen;
}

/*
 * Convert a temporary pin into File ownership.  Returns 1 on success.
 * Fails (0) if the entry is closing or no longer visible — caller must
 * sock_release() the pin and not use the fd.  Doing owners++ and pins--
 * under one lock avoids release-then-own closing the descriptor when the
 * last prior File is purged concurrently.
 */
static int sock_claim(int fd)
{
   int i, ok = 0;

   MUTEX_LOCKID(MTX_SOCK_MAP);
   for (i = 0; i < nsock; i++) {
      if (sock_map[i].fd != fd)
         continue;
      if (sock_map[i].name == NULL || sock_map[i].closing)
         break;
      sock_map[i].owners++;
      if (sock_map[i].pins > 0)
         sock_map[i].pins--;
      ok = 1;
      break;
      }
   MUTEX_UNLOCKID(MTX_SOCK_MAP);
   return ok;
}

/*
 * Track an uncached listener (parallel/attr or map-full) so select()
 * can pin it.  Hidden from sock_get (name NULL).  owners starts at 1.
 * If the map is full, reclaim an idle named entry (owners==0, pins==0)
 * left after select()-accept (genserve).  Returns 1 if tracked, 0 if
 * no slot can be freed.
 */
static int sock_track(int fd)
{
   int i, j;
   int victim = -1;
   int do_close = 0;
   int oldfd = -1;

   MUTEX_LOCKID(MTX_SOCK_MAP);
   if (nsock >= (int)(sizeof(sock_map) / sizeof(sock_map[0]))) {
      for (i = 0; i < nsock; i++)
         if (sock_map[i].name != NULL && sock_map[i].owners == 0 &&
             sock_map[i].pins == 0 && !sock_map[i].closing) {
            victim = i;
            break;
            }
      if (victim < 0) {
         MUTEX_UNLOCKID(MTX_SOCK_MAP);
         return 0;
         }
      oldfd = sock_map[victim].fd;
      free(sock_map[victim].name);
      for (j = victim + 1; j < nsock; j++)
         sock_map[j - 1] = sock_map[j];
      nsock--;
      do_close = 1;
      }
   sock_map[nsock].fd = fd;
   sock_map[nsock].name = NULL;
   if (sock_gen_seq == 0)
      sock_gen_seq = 1;
   sock_map[nsock].gen = sock_gen_seq++;
   sock_map[nsock].pins = 0;
   sock_map[nsock].owners = 1;
   sock_map[nsock].closing = 0;
   nsock++;
   MUTEX_UNLOCKID(MTX_SOCK_MAP);
   if (do_close)
      sock_close(oldfd);
   return 1;
}

/*
 * Pin a live tracked listener that still matches gen (from open /
 * sock_listener_gen).  Returns 1 if pinned.  Fails if the fd was closed
 * and the number reused for a different cache entry, or if gen is 0.
 * Named and nameless (sock_track) entries are both eligible.
 */
int sock_pin(int fd, word gen)
{
   int i, ok = 0;

   if (gen == 0)
      return 0;
   MUTEX_LOCKID(MTX_SOCK_MAP);
   for (i = 0; i < nsock; i++)
      if (sock_map[i].fd == fd && !sock_map[i].closing &&
          sock_map[i].gen == (unsigned)gen) {
         sock_map[i].pins++;
         ok = 1;
         break;
         }
   MUTEX_UNLOCKID(MTX_SOCK_MAP);
   return ok;
}

/*
 * Drop File ownership after select() converts a listener File into an
 * accepted connection.  Named cache entries with owners==0 stay in the
 * map for the next open() (genserve).  Nameless track entries are
 * closed when the last owner and pin drop — nothing else references them.
 */
void sock_unclaim(int fd, word gen)
{
   int i, j;
   int do_close = 0;

   if (gen == 0)
      return;
   MUTEX_LOCKID(MTX_SOCK_MAP);
   for (i = 0; i < nsock; i++) {
      if (sock_map[i].fd != fd || sock_map[i].gen != (unsigned)gen)
         continue;
      if (sock_map[i].owners > 0)
         sock_map[i].owners--;
      if (sock_map[i].owners > 0)
         break;
      if (sock_map[i].pins > 0) {
         if (sock_map[i].name == NULL)
            sock_map[i].closing = 1;    /* release() will close */
         break;
         }
      if (sock_map[i].name != NULL)
         break;                         /* stay cached for sock_get */
      /* nameless track entry: remove and close */
      for (j = i + 1; j < nsock; j++)
         sock_map[j - 1] = sock_map[j];
      nsock--;
      do_close = 1;
      break;
      }
   MUTEX_UNLOCKID(MTX_SOCK_MAP);
   if (do_close)
      sock_close(fd);
}

/*
 * Drop a pin.  If a close was deferred while pinned, close the fd now.
 */
void sock_release(int fd)
{
   int i, j;
   int do_close = 0;

   MUTEX_LOCKID(MTX_SOCK_MAP);
   for (i = 0; i < nsock; i++) {
      if (sock_map[i].fd != fd)
         continue;
      if (sock_map[i].pins > 0)
         sock_map[i].pins--;
      if (sock_map[i].pins == 0 && sock_map[i].closing) {
         free(sock_map[i].name);
         for (j = i + 1; j < nsock; j++)
            sock_map[j - 1] = sock_map[j];
         nsock--;
         do_close = 1;
         }
      break;
      }
   MUTEX_UNLOCKID(MTX_SOCK_MAP);
   if (do_close)
      sock_close(fd);
}

/*
 * Drop one File ownership of a cached listener.  Returns 1 if the
 * caller should close fd now, or 0 if other owners remain or a pin is
 * still held (close runs from sock_release when the last pin drops).
 */
int sock_purge(int fd)
{
   int i, j;
   int defer = 0;

   MUTEX_LOCKID(MTX_SOCK_MAP);
   for (i = j = 0; i < nsock; i++) {
      if (sock_map[i].fd != fd) {
         sock_map[j++] = sock_map[i];
         continue;
         }
      if (sock_map[i].owners > 0)
         sock_map[i].owners--;
      if (sock_map[i].owners > 0) {
         /* other live File aliases still use this descriptor */
         sock_map[j++] = sock_map[i];
         defer = 1;
         continue;
         }
      if (sock_map[i].pins > 0) {
         free(sock_map[i].name);
         sock_map[i].name = NULL;       /* hidden from sock_get */
         sock_map[i].closing = 1;
         sock_map[j++] = sock_map[i];
         defer = 1;
         }
      else
         free(sock_map[i].name);
      }
   nsock = j;
   MUTEX_UNLOCKID(MTX_SOCK_MAP);
   return !defer;
}


#if HAVE_LIBSSL

#include "rcrypto.ri"

#endif                                  /* LIBSSL */

#if HAVE_LIBSSH

#if !NT
#passthru #include <sys/ioctl.h>
#endif                                  /* !NT */

/*
 * Authentication attributes are tried in the order they appear in the
 * open() call, not in a hardcoded priority order.
 */
#define SSH_AUTH_ATTR_KEY      1
#define SSH_AUTH_ATTR_PASSWORD 2

/*
 * Channel event queue.  Data and exit-status callbacks append tagged
 * chunks as messages are parsed off the wire, preserving the exact
 * stdout/stderr arrival order (ssh_channel_read()'s own buffers keep
 * the two streams apart and lose it).  Everything here is heap
 * allocated: callbacks can fire inside blocking libssh calls made
 * while the thread is unregistered (DEC_NARTHREADS), where Unicon
 * allocation is not allowed.
 */
static void ssh_enqueue(struct SSHfile *sshf, int tag, char *data, int len)
{
   struct SSHchunk *ck;

   ck = malloc(sizeof(struct SSHchunk) + len);
   if (ck == NULL)
      syserr("out of memory for ssh channel data");
   ck->next = NULL;
   ck->tag = tag;
   ck->off = 0;
   ck->len = len;
   if (len > 0)
      memcpy(ck->data, data, len);
   if (sshf->qtail != NULL)
      sshf->qtail->next = ck;
   else
      sshf->qhead = ck;
   sshf->qtail = ck;
   if (tag == SSH_CHUNK_STDOUT)
      sshf->q_stdout += len;
}

static int ssh_chan_data_cb(ssh_session session, ssh_channel channel,
                            void *data, uint32_t len, int is_stderr,
                            void *userdata)
{
   struct SSHfile *sshf = (struct SSHfile *)userdata;

   if (len == 0)
      return 0;
   ssh_enqueue(sshf, is_stderr ? SSH_CHUNK_STDERR : SSH_CHUNK_STDOUT,
               (char *)data, (int)len);
   return (int)len;             /* consumed: keep it out of libssh's buffer */
}

static void ssh_chan_eof_cb(ssh_session session, ssh_channel channel,
                            void *userdata)
{
   ((struct SSHfile *)userdata)->eof_seen = 1;
}

static void ssh_chan_exit_cb(ssh_session session, ssh_channel channel,
                             int exit_status, void *userdata)
{
   struct SSHfile *sshf = (struct SSHfile *)userdata;
   char buf[32];

   sshf->exit_status = exit_status;
   sshf->exit_seen = 1;
   snprintf(buf, sizeof(buf), "%d", exit_status);
   ssh_enqueue(sshf, SSH_CHUNK_EXIT, buf, (int)strlen(buf));
}

/*
 * ssh_clear_file_state() - free queued chunks and the callbacks
 * struct, leaving the SSHfile itself allocated (still owned by a
 * b_file until that file is closed).
 */
static void ssh_clear_file_state(struct SSHfile *sshf)
{
   struct SSHchunk *ck, *nextck;

   for (ck = sshf->qhead; ck != NULL; ck = nextck) {
      nextck = ck->next;
      free(ck);
      }
   sshf->qhead = sshf->qtail = NULL;
   sshf->q_stdout = 0;
   if (sshf->cbs != NULL) {
      free(sshf->cbs);
      sshf->cbs = NULL;
      }
}

/*
 * ssh_free_file_state() - clear a file's queued state and free the
 * SSHfile struct itself.
 */
static void ssh_free_file_state(struct SSHfile *sshf)
{
   ssh_clear_file_state(sshf);
   free(sshf);
}

/*
 * ssh_chan_register_callbacks() - route a channel's traffic through
 * the arrival-order queue.  Must happen before the channel is opened
 * so no early data can land in libssh's own buffers instead.
 */
static int ssh_chan_register_callbacks(struct SSHfile *sshf, ssh_channel chan)
{
   ssh_channel_callbacks cb;

   cb = malloc(sizeof(struct ssh_channel_callbacks_struct));
   if (cb == NULL)
      return -1;
   memset(cb, 0, sizeof(struct ssh_channel_callbacks_struct));
   ssh_callbacks_init(cb);
   cb->userdata = sshf;
   cb->channel_data_function = ssh_chan_data_cb;
   cb->channel_eof_function = ssh_chan_eof_cb;
   cb->channel_exit_status_function = ssh_chan_exit_cb;
   if (ssh_set_channel_callbacks(chan, cb) != SSH_OK) {
      free(cb);
      return -1;
      }
   sshf->cbs = cb;
   return 0;
}

/*
 * ssh_pump() - let libssh process incoming packets so the channel
 * callbacks can run.  Returns 1 once the queue has what the caller
 * wants (a stdout chunk when want_stdout, else any chunk), 0 at EOF
 * with nothing wanted queued, 2 when nonblocking and nothing has
 * arrived yet, -1 on error (does NOT set &errortext -- callers that
 * run under DEC_NARTHREADS must call set_ssh_errortext only after
 * re-registering the thread).
 */
int ssh_pump(struct SSHfile *sshf, int block, int want_stdout)
{
   int rc;

   if (sshf == NULL || sshf->closed)
      return -1;

   for (;;) {
      if (want_stdout ? (sshf->q_stdout > 0) : (sshf->qhead != NULL))
         return 1;
      if (sshf->chan == NULL || sshf->eof_seen ||
          ssh_channel_is_eof(sshf->chan))
         return 0;
      rc = ssh_channel_poll_timeout(sshf->chan, block ? 100 : 0, 0);
      if (rc == SSH_ERROR)
         return -1;
      if (!block) {
         if (want_stdout ? (sshf->q_stdout > 0) : (sshf->qhead != NULL))
            return 1;
         if (sshf->eof_seen || rc == SSH_EOF ||
             ssh_channel_is_eof(sshf->chan))
            return 0;
         return 2;
         }
      }
}

/*
 * ssh_chan_read() - read up to n stdout bytes out of the queue,
 * pumping the wire as needed.  Returns the byte count, 0 at EOF,
 * -1 on error (caller sets &errortext after INC_NARTHREADS).
 *
 * Under Concurrent, the caller must hold the shared session mutex
 * (b_file.mutexid) around this call: the same lock used by
 * receive()/Attrib() and by writers on sibling channels.
 */
int ssh_chan_read(struct SSHfile *sshf, char *buf, int n, int block)
{
   struct SSHchunk *ck, *prev, *nextck;
   int copied = 0, take, rc;

   if (sshf == NULL || sshf->closed)
      return -1;

   if (sshf->sfile != NULL) {
      /*
       * SFTP regular file: raw sftp_read.  Caller is responsible for
       * DEC_NARTHREADS around this (same as other blocking SSH I/O).
       */
      rc = sftp_read(sshf->sfile, buf, n);
      if (rc < 0)
         return -1;                     /* caller sets &errortext after INC */
      return rc;                        /* 0 == EOF */
      }

   if (sshf->q_stdout == 0) {
      rc = ssh_pump(sshf, block, 1);
      if (rc == -1)
         return -1;
      if (rc != 1)
         return 0;                      /* EOF (or nothing yet, nonblocking) */
      }
   prev = NULL;
   ck = sshf->qhead;
   while (ck != NULL && copied < n) {
      nextck = ck->next;
      if (ck->tag != SSH_CHUNK_STDOUT) {
         prev = ck;
         ck = nextck;
         continue;
         }
      take = ck->len - ck->off;
      if (take > n - copied)
         take = n - copied;
      memcpy(buf + copied, ck->data + ck->off, take);
      ck->off += take;
      copied += take;
      sshf->q_stdout -= take;
      if (ck->off == ck->len) {
         if (prev != NULL)
            prev->next = nextck;
         else
            sshf->qhead = nextck;
         if (sshf->qtail == ck)
            sshf->qtail = prev;
         free(ck);
         }
      ck = nextck;
      }
   return copied;
}

/*
 * ssh_drain_stderr() - remove every queued stderr chunk, producing
 * their concatenation (possibly empty) as a Unicon string in *d.
 * This is a live, incremental accessor: each call returns only the
 * bytes accumulated since the previous one.
 *
 * Under Concurrent, the caller must hold the shared session mutex
 * (same rule as ssh_chan_read).
 */
void ssh_drain_stderr(struct SSHfile *sshf, dptr d)
{
   struct SSHchunk *ck, *prev, *nextck;
   word total = 0;
   char *p;

   for (ck = sshf->qhead; ck != NULL; ck = ck->next)
      if (ck->tag == SSH_CHUNK_STDERR)
         total += ck->len;

   SetStrLen(*d, total);
   if (total == 0) {
      StrLoc(*d) = "";
      return;
      }
   Protect(StrLoc(*d) = alcstr(NULL, total), fatalerr(0,NULL));

   p = StrLoc(*d);
   prev = NULL;
   ck = sshf->qhead;
   while (ck != NULL) {
      nextck = ck->next;
      if (ck->tag == SSH_CHUNK_STDERR) {
         memcpy(p, ck->data, ck->len);
         p += ck->len;
         if (prev != NULL)
            prev->next = nextck;
         else
            sshf->qhead = nextck;
         if (sshf->qtail == ck)
            sshf->qtail = prev;
         free(ck);
         }
      else
         prev = ck;
      ck = nextck;
      }
}

/*
 * ssh_request_interactive_pty() - remote PTY with TERM + window size.
 * Without a real size, ls(1) and friends fall back to one column.
 * term NULL => $TERM or "xterm"; cols/rows <= 0 => local TIOCGWINSZ
 * (or 80x24).
 */
static int ssh_request_interactive_pty(ssh_channel chan, const char *term,
                                       int cols, int rows)
{
   const char *t = term;
#if !NT
   struct winsize ws;
#endif                                  /* !NT */

   if (t == NULL || *t == '\0') {
      t = getenv("TERM");
      if (t == NULL || *t == '\0')
         t = "xterm";
      }
   if (cols <= 0 || rows <= 0) {
#if !NT
      if (ioctl(STDIN_FILENO, TIOCGWINSZ, &ws) == 0 ||
          ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) == 0) {
         if (cols <= 0 && ws.ws_col > 0)
            cols = ws.ws_col;
         if (rows <= 0 && ws.ws_row > 0)
            rows = ws.ws_row;
         }
#endif                                  /* !NT */
      if (cols <= 0)
         cols = 80;
      if (rows <= 0)
         rows = 24;
      }
   return ssh_channel_request_pty_size(chan, t, cols, rows);
}

/*
 * create_ssh_session() - establish an authenticated SSH connection,
 * optionally with a channel on it, returning a malloc'd SSHfile.
 * Follows the same attribute-parsing shape as create_ssl_context():
 * trailing open() arguments are "key=value" strings (a leading integer
 * is a connect timeout in milliseconds, as for plain sockets).
 *
 * The first open() argument is "host", "user@host", or either with
 * ":port" (same host:port shape as socket open(); IPv6 uses
 * "[addr]:port").  Mode "hc" (ssh_cmd) opens a channel: with a cmd=
 * attribute it is a one-shot exec channel with clean command
 * boundaries; otherwise an interactive shell on a pty is requested.
 * Mode "h" without 'c' is a session plus a default shell unless
 * channel=no.  channel=no opens a transport-only session (no
 * channel); use a later open(s, "hc"/"hs", ...) for exec/shell/SFTP.
 * Mode "hs" (ssh_sftp) is a transport-only session intended for an
 * immediate SFTP open on the same handle.  channel=yes is the
 * default.  Passing do_verify = 0 (the '-' mode char) skips host-key
 * verification; verifyPeer=yes|no overrides that flag, matching TLS.
 * cmd= without mode 'c', and channel=no with 'c' or cmd=, are bad
 * attributes.
 *
 * On failure sets &errortext and returns NULL, so open() can fail
 * rather than raise a runtime error, matching the SSL connect path.
 */
struct SSHfile *create_ssh_session(char *fnamestr, dptr attr, int n,
                                   int do_verify, int ssh_cmd, int ssh_sftp)
{
   tended char *tmps, *val;
   tended char *key=NULL, *password=NULL, *keypass=NULL;
   tended char *hostkeyfile=NULL, *cmd=NULL, *userattr=NULL;
   tended char *term=NULL;
   char namebuf[512];
   char *user, *host, *at, *colon, *rbrack;
   int auth_order[2];
   int nauth = 0;
   struct SSHfile *sshf;
   ssh_session sess = NULL;
   ssh_channel chan = NULL;
   C_integer timeout = 0;
   C_integer port = 0;
   C_integer pty_cols = 0, pty_rows = 0;
   int a, authed, err;
   int want_channel = 1;                /* channel=yes by default */

   /*
    * Split "user@host[:port]" (or "[ipv6]:port") into storage that
    * cannot move if the attribute parsing below triggers a GC.  Port
    * uses the same host:port form as socket open(), not a port= attr.
    */
   if (strlen(fnamestr) >= sizeof(namebuf)) {
      set_errortext(1320);
      return NULL;
      }
   strncpy(namebuf, fnamestr, sizeof(namebuf)-1);
   namebuf[sizeof(namebuf)-1] = '\0';
   user = NULL;
   host = namebuf;
   at = strchr(namebuf, '@');
   if (at != NULL) {
      *at = '\0';
      user = namebuf;
      host = at + 1;
      }
   if (*host == '\0') {
      set_errortext_with_val(1320, fnamestr);
      return NULL;
      }
   /*
    * Optional :port.  Bracketed IPv6: "[addr]:port".  Otherwise take
    * host:port only when there is a single colon, so a bare IPv6
    * literal is not misparsed (same rule as socket open()).
    */
   if (host[0] == '[') {
      rbrack = strchr(host + 1, ']');
      if (rbrack == NULL || (rbrack[1] != '\0' && rbrack[1] != ':')) {
         set_errortext_with_val(1320, fnamestr);
         return NULL;
         }
      *rbrack = '\0';
      host++;                           /* skip '[' */
      if (*host == '\0') {
         set_errortext_with_val(1320, fnamestr);
         return NULL;
         }
      if (rbrack[1] == ':') {
         port = atol(rbrack + 2);
         if (port <= 0 || port > 65535) {
            set_errortext_with_val(1320, fnamestr);
            return NULL;
            }
         }
      }
   else {
      colon = strrchr(host, ':');
      if (colon != NULL && strchr(host, ':') == colon && colon[1] != '\0') {
         *colon = '\0';
         port = atol(colon + 1);
         if (port <= 0 || port > 65535 || *host == '\0') {
            set_errortext_with_val(1320, fnamestr);
            return NULL;
            }
         }
      }

   /*
    * Check the attributes, create_ssl_context() style.
    */
   for (a=0; a<n; a++) {
      if (is:null(attr[a])) {
         attr[a] = emptystr;
         continue;
         }
      if (a==0 && cnv:C_integer(attr[a], timeout))
         continue;
      if (!cnv:C_string(attr[a], tmps)) {
         set_errortext(1321);
         return NULL;
         }
      if (strlen(tmps) < 3 || tmps[0] == '=' || tmps[strlen(tmps)-1] == '=') {
         set_errortext_with_val(1321, tmps);
         return NULL;
         }
      /*
       * Split a private copy at the '=' sign; cnv:C_string can return
       * the caller's own string storage, which must not be mutated.
       */
      Protect(tmps = alcstr(tmps, (word)strlen(tmps)+1), fatalerr(0,NULL));
      val = strchr(tmps, '=');
      if (val == NULL) {
         set_errortext_with_val(1321, tmps);
         return NULL;
         }
      *val = '\0';
      val++;
      if (strlen(val) == 0) {
         set_errortext_with_val(1321, tmps);
         return NULL;
         }
      if (strcmp(tmps, "user") == 0)
         userattr = val;
      else if (strcmp(tmps, "key") == 0) {
         key = val;
         if (nauth < 2) auth_order[nauth++] = SSH_AUTH_ATTR_KEY;
         }
      else if (strcmp(tmps, "password") == 0) {
         password = val;
         if (nauth < 2) auth_order[nauth++] = SSH_AUTH_ATTR_PASSWORD;
         }
      else if (strcmp(tmps, "keypass") == 0)
         keypass = val;
      else if (strcmp(tmps, "hostkeyfile") == 0)
         hostkeyfile = val;
      else if (strcmp(tmps, "cmd") == 0)
         cmd = val;
      else if (strcmp(tmps, "term") == 0)
         term = val;
      else if (strcmp(tmps, "cols") == 0)
         pty_cols = atol(val);
      else if (strcmp(tmps, "rows") == 0)
         pty_rows = atol(val);
      else if (strcmp(tmps, "channel") == 0) {
         want_channel = sock_attr_bool(val);
         if (want_channel < 0) {
            set_errortext_with_val(1321, tmps);
            return NULL;
            }
         }
      else if (strcmp(tmps, "verifyPeer") == 0) {
         do_verify = sock_attr_bool(val);
         if (do_verify < 0) {
            set_errortext_with_val(1321, tmps);
            return NULL;
            }
         }
      else {
         set_errortext_with_val(1321, tmps);
         return NULL;
         }
      }

   /* an explicit user@host wins over a user= attribute */
   if (user == NULL && userattr != NULL)
      user = userattr;

   if (ssh_cmd && ssh_sftp) {
      set_errortext_with_val(1321, "c");
      return NULL;
      }
   /* cmd= is selected by mode 'c', not by the attribute alone */
   if (cmd != NULL && !ssh_cmd) {
      set_errortext_with_val(1321, "cmd");
      return NULL;
      }
   /* mode "hs": SFTP, not a shell/exec channel */
   if (ssh_sftp)
      want_channel = 0;
   /* channel=no with 'c' or cmd= is contradictory */
   if (!want_channel && (ssh_cmd || cmd != NULL)) {
      set_errortext_with_val(1321, "channel");
      return NULL;
      }

   sess = ssh_new();
   if (sess == NULL) {
      set_errortext(1320);
      return NULL;
      }
   ssh_options_set(sess, SSH_OPTIONS_HOST, host);
   if (user != NULL)
      ssh_options_set(sess, SSH_OPTIONS_USER, user);
   if (port != 0) {
      unsigned int p = (unsigned int)port;
      ssh_options_set(sess, SSH_OPTIONS_PORT, &p);
      }
   if (timeout > 0) {
      long sec = timeout / 1000;
      long usec = (timeout % 1000) * 1000;
      ssh_options_set(sess, SSH_OPTIONS_TIMEOUT, &sec);
      ssh_options_set(sess, SSH_OPTIONS_TIMEOUT_USEC, &usec);
      }
   if (hostkeyfile != NULL)
      ssh_options_set(sess, SSH_OPTIONS_KNOWNHOSTS, hostkeyfile);

   sshf = malloc(sizeof(struct SSHfile));
   if (sshf == NULL) {
      ssh_free(sess);
      set_errortext(1320);
      return NULL;
      }
   memset(sshf, 0, sizeof(struct SSHfile));

   /*
    * The network phase: no Unicon allocation may happen between
    * DEC_NARTHREADS and INC_NARTHREADS_CONTROLLED, so error text is
    * only produced at the ssh_fail label after re-registering.
    */
   err = 1320;
   DEC_NARTHREADS;

   if (ssh_connect(sess) != SSH_OK)
      goto ssh_fail;

   if (do_verify) {
      if (ssh_session_is_known_server(sess) != SSH_KNOWN_HOSTS_OK) {
         err = 1323;
         goto ssh_fail;
         }
      }

   /*
    * Authenticate: attributes in call order; with neither key= nor
    * password= fall back to the default identities (~/.ssh keys or a
    * running agent).
    */
   authed = 0;
   if (nauth == 0) {
      if (ssh_userauth_publickey_auto(sess, NULL, keypass) == SSH_AUTH_SUCCESS)
         authed = 1;
      }
   for (a = 0; a < nauth && !authed; a++) {
      if (auth_order[a] == SSH_AUTH_ATTR_KEY) {
         ssh_key privkey = NULL;
         if (ssh_pki_import_privkey_file(key, keypass, NULL, NULL,
                                         &privkey) == SSH_OK) {
            if (ssh_userauth_publickey(sess, NULL, privkey) == SSH_AUTH_SUCCESS)
               authed = 1;
            ssh_key_free(privkey);
            }
         }
      else {
         if (ssh_userauth_password(sess, NULL, password) == SSH_AUTH_SUCCESS)
            authed = 1;
         }
      }
   if (!authed) {
      err = 1322;
      goto ssh_fail;
      }

   /*
    * Open a channel unless channel=no or mode "hs" (transport-only
    * session for later open(s, "hc"/"hs", ...) / an immediate SFTP
    * attach).  With a channel: exec when cmd= was given, otherwise
    * an interactive shell on a pty.  Callbacks are set before the
    * open so no early data bypasses the event queue.
    */
   if (want_channel) {
      err = 1324;
      chan = ssh_channel_new(sess);
      if (chan == NULL)
         goto ssh_fail;
      if (ssh_chan_register_callbacks(sshf, chan) < 0)
         goto ssh_fail;
      if (ssh_channel_open_session(chan) != SSH_OK)
         goto ssh_fail;
      if (cmd != NULL) {
         if (ssh_channel_request_exec(chan, cmd) != SSH_OK)
            goto ssh_fail;
         }
      else {
         if (ssh_request_interactive_pty(chan, term,
                                         (int)pty_cols, (int)pty_rows) != SSH_OK)
            goto ssh_fail;
         if (ssh_channel_request_shell(chan) != SSH_OK)
            goto ssh_fail;
         }
      }

   INC_NARTHREADS_CONTROLLED;

   sshf->sess = sess;
   sshf->chan = chan;                   /* NULL when channel=no */
   return sshf;

ssh_fail:
   INC_NARTHREADS_CONTROLLED;
   set_ssh_errortext(sess, err);
   if (chan != NULL)
      ssh_channel_free(chan);
   ssh_disconnect(sess);
   ssh_free(sess);
   ssh_free_file_state(sshf);
   return NULL;
}

/*
 * ssh_close_file() - close-hook cleanup for an SSH file.
 *
 * Closing a channel closes/frees just that channel and unlinks it from
 * its session's list.  Closing the session file cascade-closes every
 * remaining channel (their SSHfile structs are only freed when their
 * own file is closed, but they are unusable from here on) and then
 * tears down the connection.
 */
void ssh_close_file(struct SSHfile *sshf)
{
   struct SSHfile *ch, *nextch, **pp;

   if (sshf == NULL)
      return;

   if (sshf->sfile != NULL) {
      sftp_close(sshf->sfile);
      sshf->sfile = NULL;
      }
   if (sshf->sdir != NULL) {
      sftp_closedir(sshf->sdir);
      sshf->sdir = NULL;
      }

   if (sshf->chan != NULL) {
      ssh_channel_send_eof(sshf->chan);
      ssh_channel_close(sshf->chan);
      ssh_channel_free(sshf->chan);
      sshf->chan = NULL;
      }

   if (sshf->parent != NULL) {
      /* a channel: unlink from its session owner */
      for (pp = &sshf->parent->children; *pp != NULL; pp = &(*pp)->next)
         if (*pp == sshf) {
            *pp = sshf->next;
            break;
            }
      }
   else if (sshf->sess != NULL) {
      /*
       * Session owner: invalidate every remaining channel.  Unicon-level
       * b_file handles stay alive until their own close(), but the
       * closed flag and cleared queue make them unusable immediately
       * (no dangling libssh objects, no readable leftovers).
       */
      for (ch = sshf->children; ch != NULL; ch = nextch) {
         nextch = ch->next;
         if (ch->sfile != NULL) {
            sftp_close(ch->sfile);
            ch->sfile = NULL;
            }
         if (ch->sdir != NULL) {
            sftp_closedir(ch->sdir);
            ch->sdir = NULL;
            }
         if (ch->chan != NULL) {
            ssh_channel_send_eof(ch->chan);
            ssh_channel_close(ch->chan);
            ssh_channel_free(ch->chan);
            ch->chan = NULL;
            }
         ch->sftp = NULL;               /* owned here, freed below */
         ch->sess = NULL;
         ch->parent = NULL;
         ch->next = NULL;
         ch->closed = 1;
         ssh_clear_file_state(ch);
         }
      sshf->children = NULL;
      if (sshf->sftp != NULL) {
         sftp_free(sshf->sftp);
         sshf->sftp = NULL;
         }
      ssh_disconnect(sshf->sess);
      ssh_free(sshf->sess);
      sshf->sess = NULL;
      }

   ssh_free_file_state(sshf);
}

/*
 * ssh_file_write() - write all n bytes to an SSH channel or SFTP file.
 * Retries short writes.  Returns n on success, or -1 with &errortext set.
 */
int ssh_file_write(struct SSHfile *sshf, char *s, word n)
{
   word total = 0;
   int rc;

   if (sshf == NULL || sshf->closed) {
      set_errortext(1324);
      return -1;
      }
   if (n == 0)
      return 0;
   if (sshf->sfile != NULL) {
      DEC_NARTHREADS;
      while (total < n) {
         rc = sftp_write(sshf->sfile, s + total, (size_t)(n - total));
         if (rc < 0) {
            INC_NARTHREADS_CONTROLLED;
            set_ssh_errortext(sshf->sess, 1325);
            return -1;
            }
         if (rc == 0) {
            INC_NARTHREADS_CONTROLLED;
            set_ssh_errortext(sshf->sess, 1325);
            return -1;
            }
         total += rc;
         }
      INC_NARTHREADS_CONTROLLED;
      return (int)n;
      }
   if (sshf->chan == NULL) {
      set_errortext(1324);
      return -1;
      }
   DEC_NARTHREADS;
   while (total < n) {
      rc = ssh_channel_write(sshf->chan, s + total, (uint32_t)(n - total));
      if (rc == SSH_ERROR) {
         INC_NARTHREADS_CONTROLLED;
         set_ssh_errortext(sshf->sess, 1324);
         return -1;
         }
      if (rc == 0) {
         INC_NARTHREADS_CONTROLLED;
         set_ssh_errortext(sshf->sess, 1324);
         return -1;
         }
      total += rc;
      }
   INC_NARTHREADS_CONTROLLED;
   return (int)n;
}

/*
 * ssh_getstrg() - sock_getstrg() equivalent for SSH channels: read a
 * line of at most maxi characters into buf.  Returns the length not
 * counting the newline, -1 on EOF, -3 on error.  Like sock_getstrg(),
 * the newline is delivered separately as a one-character read; libssh
 * has no MSG_PEEK, so a seen-but-unconsumed newline is remembered in
 * nl_pending instead of being left in a kernel buffer.
 */
int ssh_getstrg(char *buf, int maxi, struct SSHfile *sshf)
{
   int i = 0, n;
   char c;

   /*
    * Called under DEC_NARTHREADS.  On error return -3 without setting
    * &errortext (alcstr is unsafe here); the caller re-registers and
    * then calls set_ssh_errortext.
    */
   if (sshf == NULL || sshf->closed ||
       (sshf->chan == NULL && sshf->sfile == NULL && sshf->q_stdout == 0))
      return -3;
   if (sshf->nl_pending) {
      sshf->nl_pending = 0;
      buf[0] = '\n';
      return 1;
      }
   while (i < maxi) {
      n = ssh_chan_read(sshf, &c, 1, 1);
      if (n == 0)                       /* EOF */
         return (i > 0) ? i : -1;
      if (n < 0)                        /* error; caller sets &errortext */
         return -3;
      if (c == '\n') {
         if (i == 0) {
            buf[0] = '\n';
            return 1;
            }
         sshf->nl_pending = 1;
         return i;
         }
      buf[i++] = c;
      }
   return i;
}

/*
 * create_ssh_channel() - open another channel on an existing session,
 * reusing the transport and authentication.  Trailing open() arguments
 * are name=value attributes: with cmd= the channel is a one-shot exec
 * channel, otherwise an interactive shell on a pty.  The new SSHfile
 * is linked into the session owner's children list so that closing
 * the session closes it too.
 * On failure sets &errortext and returns NULL.
 */
struct SSHfile *create_ssh_channel(struct SSHfile *sf, dptr attr, int n)
{
   tended char *tmps, *val;
   tended char *cmd = NULL;
   tended char *term = NULL;
   struct SSHfile *owner, *sshf;
   ssh_channel chan = NULL;
   int a;
   C_integer pty_cols = 0, pty_rows = 0;

   /* resolve to the session owner: opening on a channel opens a sibling */
   owner = (sf->parent != NULL) ? sf->parent : sf;
   if (owner->sess == NULL) {
      set_errortext(1324);
      return NULL;
      }

   for (a = 0; a < n; a++) {
      if (is:null(attr[a])) {
         attr[a] = emptystr;
         continue;
         }
      if (!cnv:C_string(attr[a], tmps)) {
         set_errortext(1321);
         return NULL;
         }
      /*
       * Mode-only tokens ("hc", "w", ...) carry no '=' and are
       * handled by the caller's mode scan.
       */
      if (strchr(tmps, '=') == NULL)
         continue;
      if (strlen(tmps) < 3 || tmps[0] == '=' || tmps[strlen(tmps)-1] == '=') {
         set_errortext_with_val(1321, tmps);
         return NULL;
         }
      Protect(tmps = alcstr(tmps, (word)strlen(tmps)+1), fatalerr(0,NULL));
      val = strchr(tmps, '=');
      *val = '\0';
      val++;
      if (strlen(val) == 0) {
         set_errortext_with_val(1321, tmps);
         return NULL;
         }
      if (strcmp(tmps, "cmd") == 0)
         cmd = val;
      else if (strcmp(tmps, "term") == 0)
         term = val;
      else if (strcmp(tmps, "cols") == 0)
         pty_cols = atol(val);
      else if (strcmp(tmps, "rows") == 0)
         pty_rows = atol(val);
      else {
         set_errortext_with_val(1321, tmps);
         return NULL;
         }
      }

   sshf = malloc(sizeof(struct SSHfile));
   if (sshf == NULL) {
      set_errortext(1324);
      return NULL;
      }
   memset(sshf, 0, sizeof(struct SSHfile));

   DEC_NARTHREADS;
   chan = ssh_channel_new(owner->sess);
   if (chan == NULL)
      goto chan_fail;
   if (ssh_chan_register_callbacks(sshf, chan) < 0)
      goto chan_fail;
   if (ssh_channel_open_session(chan) != SSH_OK)
      goto chan_fail;
   if (cmd != NULL) {
      if (ssh_channel_request_exec(chan, cmd) != SSH_OK)
         goto chan_fail;
      }
   else {
      if (ssh_request_interactive_pty(chan, term,
                                      (int)pty_cols, (int)pty_rows) != SSH_OK)
         goto chan_fail;
      if (ssh_channel_request_shell(chan) != SSH_OK)
         goto chan_fail;
      }
   INC_NARTHREADS_CONTROLLED;

   sshf->sess = owner->sess;
   sshf->chan = chan;
   sshf->parent = owner;
   sshf->next = owner->children;
   owner->children = sshf;
   return sshf;

chan_fail:
   INC_NARTHREADS_CONTROLLED;
   set_ssh_errortext(owner->sess, 1324);
   if (chan != NULL)
      ssh_channel_free(chan);
   ssh_free_file_state(sshf);
   return NULL;
}

/*
 * ssh_owner_sftp() - lazily create (once) the session's shared sftp
 * subsystem, returning it or NULL with &errortext set.
 */
static sftp_session ssh_owner_sftp(struct SSHfile *owner)
{
   sftp_session sftp;

   if (owner->sftp != NULL)
      return owner->sftp;
   sftp = sftp_new(owner->sess);
   if (sftp == NULL) {
      set_ssh_errortext(owner->sess, 1325);
      return NULL;
      }
   if (sftp_init(sftp) != SSH_OK) {
      set_ssh_errortext(owner->sess, 1325);
      sftp_free(sftp);
      return NULL;
      }
   owner->sftp = sftp;
   return sftp;
}

/*
 * create_sftp_file() - open a remote path over SFTP on an existing
 * session.  Recognizes attributes path= (required), and the same r/w/a
 * intent already parsed into status.  If the path is a directory, opens
 * it for listing and sets *isdir; otherwise opens a regular file.
 * as_owner != 0 attaches the SFTP handle to sf itself (open(host,"hs"))
 * rather than allocating a child.  On failure sets &errortext and
 * returns NULL; as_owner failures leave sf for the caller to close.
 */
struct SSHfile *create_sftp_file(struct SSHfile *sf, dptr attr, int n,
                                 int status, int *isdir, int as_owner)
{
   tended char *tmps, *val, *path = NULL;
   struct SSHfile *owner, *sshf;
   sftp_session sftp;
   sftp_attributes at;
   int a, accesstype;

   *isdir = 0;
   owner = (sf->parent != NULL) ? sf->parent : sf;
   if (owner->sess == NULL) {
      set_errortext(1324);
      return NULL;
      }

   for (a = 0; a < n; a++) {
      if (is:null(attr[a])) {
         attr[a] = emptystr;
         continue;
         }
      if (!cnv:C_string(attr[a], tmps)) {
         set_errortext(1321);
         return NULL;
         }
      /*
       * Mode-only tokens ("hs", "w", "r", "a", "b", ...) carry no '='
       * and are handled by the caller's mode scan.
       */
      if (strchr(tmps, '=') == NULL)
         continue;
      if (tmps[0] == '=' || tmps[strlen(tmps)-1] == '=') {
         set_errortext_with_val(1321, tmps);
         return NULL;
         }
      Protect(tmps = alcstr(tmps, (word)strlen(tmps)+1), fatalerr(0,NULL));
      val = strchr(tmps, '=');
      *val = '\0';
      val++;
      if (strlen(val) == 0) {
         set_errortext_with_val(1321, tmps);
         return NULL;
         }
      if (strcmp(tmps, "path") == 0)
         path = val;
      else {
         set_errortext_with_val(1321, tmps);
         return NULL;
         }
      }
   if (path == NULL) {
      set_errortext(1325);
      return NULL;
      }

   sftp = ssh_owner_sftp(owner);
   if (sftp == NULL)
      return NULL;                      /* &errortext already set */

   if (as_owner)
      sshf = owner;
   else {
      sshf = malloc(sizeof(struct SSHfile));
      if (sshf == NULL) {
         set_errortext(1325);
         return NULL;
         }
      memset(sshf, 0, sizeof(struct SSHfile));
      sshf->sess = owner->sess;
      sshf->sftp = sftp;
      sshf->parent = owner;
      }

   DEC_NARTHREADS;
   at = sftp_stat(sftp, path);
   if (at != NULL && at->type == SSH_FILEXFER_TYPE_DIRECTORY) {
      sftp_attributes_free(at);
      sshf->sdir = sftp_opendir(sftp, path);
      INC_NARTHREADS_CONTROLLED;
      if (sshf->sdir == NULL) {
         set_ssh_errortext(owner->sess, 1325);
         if (!as_owner)
            free(sshf);
         return NULL;
         }
      *isdir = 1;
      }
   else {
      if (at != NULL)
         sftp_attributes_free(at);
      if (status & Fs_Append)
         accesstype = O_WRONLY | O_CREAT | O_APPEND;
      else if ((status & Fs_Write) && (status & Fs_Read))
         accesstype = O_RDWR | O_CREAT;
      else if (status & Fs_Write)
         accesstype = O_WRONLY | O_CREAT | O_TRUNC;
      else
         accesstype = O_RDONLY;
      sshf->sfile = sftp_open(sftp, path, accesstype, 0644);
      INC_NARTHREADS_CONTROLLED;
      if (sshf->sfile == NULL) {
         set_ssh_errortext(owner->sess, 1325);
         if (!as_owner)
            free(sshf);
         return NULL;
         }
      }

   if (!as_owner) {
      sshf->next = owner->children;
      owner->children = sshf;
      }
   return sshf;
}

/*
 * ssh_sftp_readdir() - copy the next directory entry name into buf,
 * returning its length, or -1 at end of directory / on error (with
 * &errortext set only on a real error).
 */
int ssh_sftp_readdir(struct SSHfile *sshf, char *buf, int maxi)
{
   sftp_attributes at;
   int len;

   if (sshf->sdir == NULL) {
      set_errortext(1325);
      return -1;
      }
   DEC_NARTHREADS;
   at = sftp_readdir(sshf->sftp, sshf->sdir);
   INC_NARTHREADS_CONTROLLED;
   if (at == NULL) {
      if (!sftp_dir_eof(sshf->sdir))
         set_ssh_errortext(sshf->sess, 1325);
      return -1;
      }
   len = (at->name != NULL) ? (int)strlen(at->name) : 0;
   if (len > maxi)
      len = maxi;
   if (len > 0)
      memcpy(buf, at->name, len);
   sftp_attributes_free(at);
   return len;
}

/*
 * sftp2rec() - populate a posix_stat record from SFTP attributes.
 * Fields the server did not send (SFTP attribute coverage is
 * protocol-version dependent) are left null rather than reported as
 * zero, so callers can tell "absent" from "genuinely zero".
 */
static void sftp2rec(sftp_attributes at, struct descrip *dp,
                     struct b_record **rp)
{
   int i;
   char mode[12];

   dp->dword = D_Record;
   dp->vword.bptr = (union block *)(*rp);

   for (i = 0; i < 14; i++)
      (*rp)->fields[i] = nulldesc;

   /* size (field 7) */
   if (at->flags & SSH_FILEXFER_ATTR_SIZE) {
      (*rp)->fields[7].dword = D_Integer;
      IntVal((*rp)->fields[7]) = (word)at->size;
      }
   /* uid/gid (fields 4,5) */
   if (at->flags & SSH_FILEXFER_ATTR_UIDGID) {
      if (at->owner != NULL) {
         Protect(StrLoc((*rp)->fields[4]) = alcstr(at->owner, strlen(at->owner)),
                 fatalerr(0,NULL));
         SetStrLen((*rp)->fields[4], strlen(at->owner));
         }
      else {
         char b[32];
         snprintf(b, sizeof(b), "%lu", (unsigned long)at->uid);
         Protect(StrLoc((*rp)->fields[4]) = alcstr(b, strlen(b)), fatalerr(0,NULL));
         SetStrLen((*rp)->fields[4], strlen(b));
         }
      if (at->group != NULL) {
         Protect(StrLoc((*rp)->fields[5]) = alcstr(at->group, strlen(at->group)),
                 fatalerr(0,NULL));
         SetStrLen((*rp)->fields[5], strlen(at->group));
         }
      else {
         char b[32];
         snprintf(b, sizeof(b), "%lu", (unsigned long)at->gid);
         Protect(StrLoc((*rp)->fields[5]) = alcstr(b, strlen(b)), fatalerr(0,NULL));
         SetStrLen((*rp)->fields[5], strlen(b));
         }
      }
   /* times (fields 8,9,10): SFTP carries atime/mtime; no ctime */
   if (at->flags & SSH_FILEXFER_ATTR_ACMODTIME) {
      (*rp)->fields[8].dword = D_Integer;
      IntVal((*rp)->fields[8]) = (word)at->atime;
      (*rp)->fields[9].dword = D_Integer;
      IntVal((*rp)->fields[9]) = (word)at->mtime;
      }
   /* permissions -> mode string (field 2) */
   if (at->flags & SSH_FILEXFER_ATTR_PERMISSIONS) {
      uint32_t m = at->permissions;
      strcpy(mode, "----------");
      switch (at->type) {
         case SSH_FILEXFER_TYPE_DIRECTORY: mode[0] = 'd'; break;
         case SSH_FILEXFER_TYPE_SYMLINK:   mode[0] = 'l'; break;
         case SSH_FILEXFER_TYPE_SPECIAL:   mode[0] = 'c'; break;
         default: break;
         }
      if (m & 0400) mode[1] = 'r';
      if (m & 0200) mode[2] = 'w';
      if (m & 0100) mode[3] = 'x';
      if (m & 040)  mode[4] = 'r';
      if (m & 020)  mode[5] = 'w';
      if (m & 010)  mode[6] = 'x';
      if (m & 04)   mode[7] = 'r';
      if (m & 02)   mode[8] = 'w';
      if (m & 01)   mode[9] = 'x';
      Protect(StrLoc((*rp)->fields[2]) = alcstr(mode, 10), fatalerr(0,NULL));
      SetStrLen((*rp)->fields[2], 10);
      }
}

/*
 * ssh_sftp_stat_rec() - stat a remote path (use_fstat==0, path given)
 * or an already-open sftp file (use_fstat==1, sf is the file), filling
 * a freshly allocated posix_stat record.  Returns 1 on success, 0 on
 * failure with &errortext set.
 */
int ssh_sftp_stat_rec(struct SSHfile *sf, char *path, int use_fstat,
                      struct descrip *dp, struct b_record **rp)
{
   struct SSHfile *owner;
   sftp_session sftp;
   sftp_attributes at;

   owner = (sf->parent != NULL) ? sf->parent : sf;
   if (use_fstat) {
      if (sf->sfile == NULL) {
         set_errortext(1325);
         return 0;
         }
      sftp = sf->sftp;
      DEC_NARTHREADS;
      at = sftp_fstat(sf->sfile);
      INC_NARTHREADS_CONTROLLED;
      }
   else {
      sftp = ssh_owner_sftp(owner);
      if (sftp == NULL)
         return 0;
      DEC_NARTHREADS;
      at = sftp_stat(sftp, path);
      INC_NARTHREADS_CONTROLLED;
      }
   if (at == NULL) {
      set_ssh_errortext(owner->sess, 1325);
      return 0;
      }
   sftp2rec(at, dp, rp);
   sftp_attributes_free(at);
   return 1;
}

/*
 * ssh_sftp_unlink() / ssh_sftp_rename() - metadata verbs, returning 0
 * on success or -1 with &errortext set.
 */
int ssh_sftp_unlink(struct SSHfile *sf, char *path)
{
   struct SSHfile *owner = (sf->parent != NULL) ? sf->parent : sf;
   sftp_session sftp = ssh_owner_sftp(owner);
   int rc;

   if (sftp == NULL)
      return -1;
   DEC_NARTHREADS;
   rc = sftp_unlink(sftp, path);
   INC_NARTHREADS_CONTROLLED;
   if (rc != SSH_OK) {
      set_ssh_errortext(owner->sess, 1325);
      return -1;
      }
   return 0;
}

int ssh_sftp_rename(struct SSHfile *sf, char *from, char *to)
{
   struct SSHfile *owner = (sf->parent != NULL) ? sf->parent : sf;
   sftp_session sftp = ssh_owner_sftp(owner);
   int rc;

   if (sftp == NULL)
      return -1;
   DEC_NARTHREADS;
   rc = sftp_rename(sftp, from, to);
   INC_NARTHREADS_CONTROLLED;
   if (rc != SSH_OK) {
      set_ssh_errortext(owner->sess, 1325);
      return -1;
      }
   return 0;
}
#endif                                  /* HAVE_LIBSSH */


#if !NT
dptr make_pwd(struct passwd *pw, dptr result)
{
   tended struct b_record *rp;
   dptr constr;
   int nfields;

   if (!(constr = rec_structor("posix_passwd")))
      return 0;

   nfields = (int) ((struct b_proc *)BlkLoc(*constr))->nfields;
   rp = alcrecd(nfields, BlkLoc(*constr));

   result->dword = D_Record;
   result->vword.bptr = (union block *)rp;
   String(rp->fields[0], pw->pw_name);
   String(rp->fields[1], pw->pw_passwd);
   rp->fields[2].dword = rp->fields[3].dword = D_Integer;
   IntVal(rp->fields[2]) = pw->pw_uid;
   IntVal(rp->fields[3]) = pw->pw_gid;
   String(rp->fields[4], pw->pw_gecos);
   String(rp->fields[5], pw->pw_dir);
   String(rp->fields[6], pw->pw_shell);
   return result;
}
#endif                                  /* !NT */

#if NT
/*
 * Synthetic posix_passwd for getpw(name) when name matches the logged-in user
 * (see fxposix.ri getpw). There is no /etc/passwd on Windows.
 */
dptr make_pwd_nt(char *name, C_integer uid, C_integer gid, dptr result)
{
   tended struct b_record *rp;
   dptr constr;
   int nfields;
   static char emptystr[] = "";
   char *dir, *sh;

   if (!(constr = rec_structor("posix_passwd")))
      return 0;

   nfields = (int) ((struct b_proc *)BlkLoc(*constr))->nfields;
   rp = alcrecd(nfields, BlkLoc(*constr));

   result->dword = D_Record;
   result->vword.bptr = (union block *)rp;
   String(rp->fields[0], name);
   String(rp->fields[1], "x");
   rp->fields[2].dword = rp->fields[3].dword = D_Integer;
   IntVal(rp->fields[2]) = uid;
   IntVal(rp->fields[3]) = gid;
   String(rp->fields[4], emptystr);
   dir = getenv("USERPROFILE");
   if (!dir || !*dir)
      dir = (char *)emptystr;
   String(rp->fields[5], dir);
   sh = getenv("ComSpec");
   if (!sh || !*sh)
      sh = (char *)emptystr;
   String(rp->fields[6], sh);
   return result;
}
#endif                                  /* NT */

void catstrs(char **ptrs, dptr d)
{
   int nmem = 0, i, n;
   char *p;
   CURTSTATE();

   while (ptrs[nmem])
      nmem++;

   StrLoc(*d) = p = alcstr(NULL, nmem*9);

   for (i = 0; i < nmem; i++) {
      char *q = ptrs[i];
      while ((*p = *q++))
         p++;
      *p++ = ',';
   }
   if (nmem > 0)
      *--p = 0;

   SetStrLen(*d, DiffPtrs(p,StrLoc(*d)));
   n = DiffPtrs(p,strfree);             /* note the deallocation */
   EVStrAlc(n);
   strtotal += n;
   strfree = p;                         /* give back unused space */
}

#if !NT
dptr make_group(struct group *gr, dptr result)
{
   struct b_record *rp;
   dptr constr;
   int nfields;

   if (!(constr = rec_structor("posix_group")))
      return 0;

   nfields = (int) ((struct b_proc *)BlkLoc(*constr))->nfields;
   rp = alcrecd(nfields, BlkLoc(*constr));

   result->dword = D_Record;
   result->vword.bptr = (union block *)rp;
   String(rp->fields[0], gr->gr_name);
   String(rp->fields[1], gr->gr_passwd);
   rp->fields[2].dword = D_Integer;
   IntVal(rp->fields[2]) = gr->gr_gid;

   catstrs(gr->gr_mem, &rp->fields[3]);
   return result;
}
#endif                                  /* !NT */

dptr make_serv(struct servent *s, dptr result)
{
   struct b_record *rp;
   dptr constr;
   int nfields;

   if (!(constr = rec_structor("posix_servent")))
      return 0;

   nfields = (int) ((struct b_proc *)BlkLoc(*constr))->nfields;
   rp = alcrecd(nfields, BlkLoc(*constr));

   result->dword = D_Record;
   result->vword.bptr = (union block *)rp;

   String(rp->fields[0], s->s_name);
   catstrs(s->s_aliases, &rp->fields[1]);
   rp->fields[2].dword = D_Integer;
   IntVal(rp->fields[2]) = ntohs((short)s->s_port);
   String(rp->fields[3], s->s_proto);

   return result;
}

#ifdef HAVE_GETADDRINFO

dptr make_host_from_addrinfo(char *name, struct addrinfo *res0,  dptr result)
{
   struct b_record *rp;
   dptr constr;
   int nfields;
   int len = 0, n;
   char *p;

   struct addrinfo *res;
   CURTSTATE();

   if (!(constr = rec_structor("posix_hostent")))
     return 0;

   nfields = (int) ((struct b_proc *)BlkLoc(*constr))->nfields;
   rp = alcrecd(nfields, BlkLoc(*constr));

   result->dword = D_Record;
   result->vword.bptr = (union block *)rp;

   if (res0->ai_canonname)
      String(rp->fields[0], res0->ai_canonname);
   else
      String(rp->fields[0], name);

   String(rp->fields[1], name);

   /* Retrieve each address and print out the hex bytes */

   for(res = res0; res != NULL ; res = res->ai_next) {
       len += res->ai_addrlen;
   }

   StrLoc(rp->fields[2]) = p = alcstr(NULL, len);

   for(res = res0; res != NULL ; res = res->ai_next) {
      char ipstrbuf[64];
      int ipbuflen = 64;
      int a;

    switch (res->ai_family) {
            case AF_INET:
                a = ntohl(((struct sockaddr_in *) res->ai_addr)->sin_addr.s_addr);
                sprintf(p, "%u.%u.%u.%u,", (a & 0xff000000) >> 24,
                        (a & 0xff0000) >> 16, (a & 0xff00)>>8, a & 0xff);

                while(*p) p++;
                break;

            case AF_INET6:
#if NT

                /*
                 * The buffer length is changed by each call to
                 * WSAAddresstoString, So we need to set it for each
                 * iteration through the loop for safety
                 */

                ipbuflen = 46;
                if (WSAAddressToString(((LPSOCKADDR) res->ai_addr),
                    (DWORD) res->ai_addrlen, NULL,
                    ipstrbuf, (LPDWORD) &ipbuflen)!=0)
                    ipstrbuf[0]='\0';
#else
                if (inet_ntop(AF_INET6, (void *)
                   &(((struct sockaddr_in6 *) res->ai_addr)->sin6_addr.s6_addr),
                   ipstrbuf, ipbuflen) == NULL)
                   ipstrbuf[0]='\0';
#endif

                sprintf(p, "%s,", ipstrbuf);

                while(*p) p++;
                break;

            default:
                /*printf("Other %ld\n", res->ai_family);*/
                break;
        }
/*
 *   Not Yet used! left here for possible expansions in the future.
 *
        printf("\tSocket type: ");
        switch (res->ai_socktype) {
            case 0:
                printf("Unspecified\n");
                break;
            case SOCK_STREAM:
                printf("SOCK_STREAM (stream)\n");
                break;
            case SOCK_DGRAM:
                printf("SOCK_DGRAM (datagram) \n");
                break;
            case SOCK_RAW:
                printf("SOCK_RAW (raw) \n");
                break;
            case SOCK_RDM:
                printf("SOCK_RDM (reliable message datagram)\n");
                break;
            case SOCK_SEQPACKET:
                printf("SOCK_SEQPACKET (pseudo-stream packet)\n");
                break;
            default:
                printf("Other %ld\n", res->ai_socktype);
                break;
        }
        printf("\tProtocol: ");
        switch (res->ai_protocol) {
            case 0:
                printf("Unspecified\n");
                break;
            case IPPROTO_TCP:
                printf("IPPROTO_TCP (TCP)\n");
                break;
            case IPPROTO_UDP:
                printf("IPPROTO_UDP (UDP) \n");
                break;
            default:
                printf("Other %ld\n", res->ai_protocol);
                break;
        }
*/
     }

   *--p = 0;
   SetStrLen(rp->fields[2], DiffPtrs(p,StrLoc(rp->fields[2])));
   n = DiffPtrs(p,strfree);             /* note the deallocation */
   EVStrAlc(n);
   strtotal += n;
   strfree = p;                         /* give back unused space */

   return result;
}
#endif                                  /* HAVE_GETADDRINFO */

dptr make_host(struct hostent *hs,  dptr result)
{
   struct b_record *rp;
   dptr constr;
   int nfields;
   int nmem = 0, i, n;
   unsigned int *addr;
   char *p;
   CURTSTATE();

   if (!(constr = rec_structor("posix_hostent")))
     return 0;

   nfields = (int) ((struct b_proc *)BlkLoc(*constr))->nfields;
   rp = alcrecd(nfields, BlkLoc(*constr));

   result->dword = D_Record;
   result->vword.bptr = (union block *)rp;

   String(rp->fields[0], hs->h_name);
   catstrs(hs->h_aliases, &rp->fields[1]);

   while (hs->h_addr_list[nmem])
      nmem++;

   StrLoc(rp->fields[2]) = p = alcstr(NULL, nmem*16);

   addr = (unsigned int *) hs->h_addr_list[0];
   for (i = 0; i < nmem; i++) {
      int a = ntohl(*addr);
      sprintf(p, "%d.%d.%d.%d,", (a & 0xff000000) >> 24,
              (a & 0xff0000) >> 16, (a & 0xff00)>>8, a & 0xff);
      while(*p) p++;
      addr++;
   }
   *--p = 0;

   SetStrLen(rp->fields[2], DiffPtrs(p,StrLoc(rp->fields[2])));
   n = DiffPtrs(p,strfree);             /* note the deallocation */
   EVStrAlc(n);
   strtotal += n;
   strfree = p;                         /* give back unused space */

   return result;
}

/*
 * Calling Icon from C
 */

#if COMPILER
dptr calliconproc(struct descrip p, dptr args, int nargs)
{
   int i;
   static struct descrip rv;
   struct descrip *cargs = calloc(nargs+1, sizeof(struct descrip));
   cargs[0] = p;
   for (i = 0; i < nargs; i++) cargs[i+1] = args[i];
   i = invoke(nargs+1, cargs , &rv , (continuation)NULL);
   free(cargs);
   if (i == -2) /* success */
      return &rv;
   return NULL; /* failure */
}
#else                                   /* COMPILER */

/* No provision for resumption */
#ifndef Concurrent
word *callproc, callproc_ibuf[100];
#endif                                  /* Concurrent */
dptr calliconproc(struct descrip proc, dptr args, int nargs)
{
   int i, off, retval;
   inst saved_ipc;
   word *saved_sp;
   inst wp;
   dptr dp, ret = NULL;
   CURTSTATE_AND_CE();

   saved_sp = sp;

#ifdef HP
   bcopy(&ipc, &saved_ipc, sizeof(ipc));
#else                                   /* HP */
   saved_ipc = ipc;
#endif                                  /* HP */

   wp.opnd = callproc = callproc_ibuf;
   ipad(wp);  *wp.op++ = Op_Mark;   *wp.opnd++ = (2 + nargs+1)*2 * WordSize;
   ipad(wp);  *wp.op++ = Op_Copyd;  *wp.opnd++ = -(nargs+1);
   off = -nargs;
   for (i = 1; i < nargs+1; i++) {
      ipad(wp);
      *wp.op++ = Op_Copyd;
      *wp.opnd++ = off++;
   }
   ipad(wp);  *wp.op++ = Op_Invoke;  *wp.opnd++ =  nargs;
   *wp.op++ = Op_Eret;
   ipad(wp);
   *wp.op++ = Op_Trapret;
   ipad(wp);
   *wp.op++ = Op_Trapfail;

   dp = (dptr)(sp + 1);
   dp[0] = proc;
   for (i = 0; i < nargs; i++)
      dp[i+1] = args[i];

   sp += (nargs+1)*2;
   ipc.op = (int *)callproc;

#ifdef TSTATARG
   retval = interp(0, NULL, CURTSTATARG);
#else                                    /* TSTATARG */
   retval = interp(0, NULL);
#endif                                   /* TSTATARG */

   /* need to double-check all return codes from interp() */
   if ((retval != A_Resume) && (retval != A_Trapfail)) ret = (dptr)(sp-1);

#ifdef HP
   bcopy(&saved_ipc, &ipc, sizeof(ipc));
#else
   ipc = saved_ipc;
#endif
   sp = saved_sp;

   return ret;
}
#endif                                  /* !COMPILER */

/*
 * Signals and trapping
 */

#ifndef MultiProgram
/* Systems don't have more than, oh, about 50 signals, eh? */
static struct descrip handlers[41];

void init_sighandlers()
{
   int i;
   for(i = 0; i < 41; i++)
      handlers[i] = nulldesc;
}
#else                                   /* MultiProgram */

void init_sighandlers(struct progstate *pstate)
{
   int i;
   for(i = 0; i < 41; i++)
      pstate->Handlers[i] = nulldesc;
}
#endif                                  /* MultiProgram */

struct descrip register_sig(int sig, struct descrip handler)
{
   struct descrip old;

#ifdef MultiProgram
   curpstate->signal = 0;
#endif                                  /* MultiProgram */
   MUTEX_LOCKID(MTX_HANDLERS);
   old = handlers[sig];
   handlers[sig] = handler;
   MUTEX_UNLOCKID(MTX_HANDLERS);
   return old;
}

void signal_dispatcher(int sig)
{
   struct descrip proc;

   proc = handlers[sig];
#ifdef MultiProgram
   curpstate->signal = 0;
#endif                                  /* MultiProgram */

   /*
    * proc is NULL if there is no signal handler for current signal.
    * How could we get a signal of a given type, if we didn't register
    * a handler for it?
    */
   if (is:null(proc)) {
#ifdef MultiProgram
      if ((!is:null(curpstate->eventmask)) &&
          Testb((word)ToAscii(E_Signal), curpstate->eventmask)) {
         /* if we are in the TP and it has no signal handling
          * report the signal back to its parent
          */
         curpstate->signal = sig;
         return;
         }
      else {
         /*
          * Child has no handler and parent does not want to deal with it.
          * Execute the default behavior for this signal.
          */
         signal(sig, SIG_DFL);
         raise(sig);
         return;
         }
#else
      signal(sig, SIG_DFL);
      raise(sig);
      return;
#endif                                  /* MultiProgram */
      }

#if COMPILER
   syserr("signal handlers are not supported by iconc");
#else
   {
     char *p;
     struct descrip val;
     /* Invoke proc */
     p = si_i2s(signalnames, sig);
     SetStrLen(val, strlen(p));
     StrLoc(val) = p;

     (void) calliconproc(proc, &val, 1);
   }
#endif                                  /* COMPILER */

   /* Restore signal just in case (for non-BSD systems) */
   signal(sig, signal_dispatcher);
}

/*
 * Unbuffered low-level reads - perform exactly one read(2) except if
 * n is zero, in which case read as much as possible without blocking
 *
 * returns an allocated string. If EOF then returns 0.
 */
dptr u_read(dptr f, int n, int fstatus, dptr d)
{
   int fd, tally = 0, nbytes;
   CURTSTATE();

   if ((fd = get_fd(*f, 0)) < 0)
     ReturnErrNum(174, f);

   IntVal(amperErrno) = 0;

   if (n > 0) {
      /* Allocate n bytes of char space */
      StrLoc(*d) = alcstr(NULL, n);
      SetStrLen(*d, 0);
#if HAVE_LIBSSH
      if (fstatus & Fs_SSH) {
         struct SSHfile *sshf = BlkD(*f,File)->fd.sshf;
#ifdef Concurrent
         MUTEX_LOCKID_CONTROLLED(BlkD(*f,File)->mutexid);
#endif                                  /* Concurrent */
         if (sshf == NULL || sshf->closed ||
             (sshf->chan == NULL && sshf->sfile == NULL &&
              sshf->q_stdout == 0)) {
            set_errortext(1324);
            tally = -1;
            }
         else if (sshf->nl_pending) {
            sshf->nl_pending = 0;
            *StrLoc(*d) = '\n';
            tally = 1;
            }
         else {
            DEC_NARTHREADS;
            tally = ssh_chan_read(sshf, StrLoc(*d), n, 1);
            INC_NARTHREADS_CONTROLLED;
            if (tally < 0)
               set_ssh_errortext(sshf->sess, sshf->sfile ? 1325 : 1324);
            }
#ifdef Concurrent
         MUTEX_UNLOCKID(BlkD(*f,File)->mutexid);
#endif                                  /* Concurrent */
         }
      else
#endif                                  /* HAVE_LIBSSH */
      if (fstatus & Fs_Socket) {
#if HAVE_LIBSSL
        if (fstatus & Fs_Encrypt) {
           tally = SSL_read(BlkD(*f,File)->fd.ssl, StrLoc(*d), n);
           if (tally <= 0)
             set_ssl_connection_errortext(BlkD(*f,File)->fd.ssl, tally);
           }
        else
#endif                                  /* LIBSSL */
          tally = recv(fd, StrLoc(*d), n, 0);
      }
      else
        tally = read(fd, StrLoc(*d), n);

      if (tally <= 0) {
         strtotal += n;
         strfree = StrLoc(*d);
         return 0;
      }
      SetStrLen(*d, tally);
      /*
       * We may not have used the entire amount of storage we reserved.
       */
      nbytes = DiffPtrs(StrLoc(*d) + tally, strfree);
      EVStrAlc(nbytes);
      strtotal += nbytes;
      strfree = StrLoc(*d) + tally;
      }
   else {
      /* Read as much as we can without blocking, in chunks of 1536 bytes */
      long bufsize = 1536, total = 0, i = 0;
#if HAVE_LIBSSH && defined(Concurrent)
      word ssh_mtx = 0;
      int ssh_have_mtx = 0;
#endif                                  /* HAVE_LIBSSH && Concurrent */
      StrLoc(*d) = strfree;
      SetStrLen(*d, 0);
#if HAVE_LIBSSH && defined(Concurrent)
      if (fstatus & Fs_SSH) {
         ssh_mtx = BlkD(*f,File)->mutexid;
         MUTEX_LOCKID_CONTROLLED(ssh_mtx);
         ssh_have_mtx = 1;
         }
#endif                                  /* HAVE_LIBSSH && Concurrent */
      for(;;) {
         int srv, kk=0;
         fd_set readset;
         struct timeval tv;
#if HAVE_LIBSSH
         if (fstatus & Fs_SSH) {
            /*
             * select() on the session fd cannot see data already
             * decrypted and queued inside libssh; pump the channel.
             * SFTP files have no channel queue -- just try a read.
             * The shared session mutex (above) covers pump + dequeue.
             */
            struct SSHfile *sshf = BlkD(*f,File)->fd.sshf;
            if (sshf == NULL || sshf->closed ||
                (sshf->chan == NULL && sshf->sfile == NULL &&
                 sshf->q_stdout == 0)) {
               set_errortext(1324);
#if defined(Concurrent)
               if (ssh_have_mtx)
                  MUTEX_UNLOCKID(ssh_mtx);
#endif                                  /* Concurrent */
               return 0;
               }
            if (sshf->sfile != NULL) {
               /* fall through to the read below */
               }
            else if (!sshf->nl_pending && sshf->q_stdout == 0) {
               int prc;
               DEC_NARTHREADS;
               prc = ssh_pump(sshf, 0, 1);
               INC_NARTHREADS_CONTROLLED;
               if (prc == -1) {
                  set_ssh_errortext(sshf->sess, 1324);
#if defined(Concurrent)
                  if (ssh_have_mtx)
                     MUTEX_UNLOCKID(ssh_mtx);
#endif                                  /* Concurrent */
                  return 0;
                  }
               if (prc == 2)
                  break;                /* nothing more is available */
               if (prc == 0) {          /* EOF */
                  if (StrLen(*d) == 0) {
#if defined(Concurrent)
                     if (ssh_have_mtx)
                        MUTEX_UNLOCKID(ssh_mtx);
#endif                                  /* Concurrent */
                     return 0;
                     }
                  break;
                  }
               }
            }
         else {
#endif                                  /* HAVE_LIBSSH */
         FD_ZERO(&readset);
         FD_SET(fd, &readset);
         tv.tv_sec = tv.tv_usec = 0;
         if ((srv = select(fd+1, &readset, NULL, NULL, &tv)) == 0) {
            /* Nothing more is available */
            break;
            }
         else if (srv == -1) {
            set_syserrortext(errno);
            return 0;
            }
#if HAVE_LIBSSH
         }
#endif                                  /* HAVE_LIBSSH */

         /* Something is available: allocate another chunk */
         if (i == 0)
            StrLoc(*d) = alcstr(NULL, bufsize);
         else {
            /* Extend the string */
           /* We must guard against running over the end of the current string region.
            * In that case, allocate a whole new buffer (which will result in a GC)
            * and copy the existing buffer into it. Don't use alcstr() to do the copy
            * because that might involve accessing potentially non-existent memory after
            * the end of the (old) string region.
            */
           if (DiffPtrs(strend,strfree) < bufsize) {
             char *newb = alcstr(NULL, StrLen(*d) + bufsize); /* a GC will occur */
             memcpy(newb, StrLoc(*d), StrLen(*d));
             StrLoc(*d) = newb;
           } else
            (void) alcstr(NULL, bufsize);
         }
tryagain:

#if HAVE_LIBSSH
         if (fstatus & Fs_SSH) {
            struct SSHfile *sshf = BlkD(*f,File)->fd.sshf;
            if (sshf->nl_pending) {
               sshf->nl_pending = 0;
               *(StrLoc(*d) + i*bufsize) = '\n';
               tally = 1;
               }
            else {
               DEC_NARTHREADS;
               tally = ssh_chan_read(sshf, StrLoc(*d) + i*bufsize,
                                     bufsize, 0);
               INC_NARTHREADS_CONTROLLED;
               if (tally < 0) {
                  set_ssh_errortext(sshf->sess, sshf->sfile ? 1325 : 1324);
                  strtotal += bufsize;
                  strfree = StrLoc(*d);
#if defined(Concurrent)
                  if (ssh_have_mtx)
                     MUTEX_UNLOCKID(ssh_mtx);
#endif                                  /* Concurrent */
                  return 0;
                  }
               }
            }
         else
#endif                                  /* HAVE_LIBSSH */
         if (fstatus & Fs_Socket) {
#if HAVE_LIBSSL
           if (fstatus & Fs_Encrypt) {
              tally = SSL_read(BlkD(*f,File)->fd.ssl, StrLoc(*d) +  i*bufsize, bufsize);
              if (tally <= 0) {
                set_ssl_connection_errortext(BlkD(*f,File)->fd.ssl, tally);
                strtotal += bufsize;
                strfree = StrLoc(*d);
                return 0;
              }
           }
           else {
#endif                                  /* LIBSSL */
             tally = recv(fd, StrLoc(*d) + i*bufsize, bufsize, 0);

              if (tally < 0) {
                 /*
                  * Error on recv().  Some kinds of errors might be recoverable.
                  */
                kk++;
#if NT
                errno = WSAGetLastError();
#endif                                  /* NT */
                switch (errno) {
#if NT
                case WSAEINTR: case WSAEINPROGRESS:
#else                                   /* NT */
                case EINTR: case EINPROGRESS:
#endif                                  /* NT */
                  if (kk < 5) goto tryagain;
                  break;
                default:
                  strtotal += bufsize;
                  strfree = StrLoc(*d);
                  set_errortext(214);
                  return 0;
                }
              } /* tally < 0 */
              if ((i == 0) && (tally == 0)) {
                strtotal += bufsize;
                strfree = StrLoc(*d);
                return 0;
              }
#if HAVE_LIBSSL
           }
#endif                                  /* LIBSSL */
         }
         else { // not a socket, use read()
           tally = read(fd, StrLoc(*d) + i*bufsize, bufsize);

           if ((i == 0) && (tally <= 0)) {
             strtotal += bufsize;
             strfree = StrLoc(*d);
             return 0;
           }
         }

         total += tally;
         SetStrLen(*d, total);
         if (tally < bufsize) {
            /* We're done; return unused storage */
            nbytes = DiffPtrs(StrLoc(*d) + total, strfree);
            EVStrAlc(nbytes);
            strtotal += nbytes;
            strfree = StrLoc(*d) + total;
            break;
         }
         i++;
      }
#if HAVE_LIBSSH && defined(Concurrent)
      if (ssh_have_mtx)
         MUTEX_UNLOCKID(ssh_mtx);
#endif                                  /* HAVE_LIBSSH && Concurrent */
   }
   return d;
}

/*
 * Duplicate the file descriptors for a child process, in support of
 * file redirection.  This may be an open file, or an integer file
 * descriptor. The integer file descriptors are only used internally
 * to the runtime system, in the case of files opened by string name
 * as a by-product of parsing a command line or taking a string
 * filename redirection argument to system().
 */
void dup_fds(dptr d_stdin, dptr d_stdout, dptr d_stderr)
{
   if (is:file(*d_stdin)) {
      dup2(get_fd(*d_stdin, 0), 0);
      }
   else if (is:integer(*d_stdin)) {
      dup2(IntVal(*d_stdin), 0);
      }
   if (is:file(*d_stdout)) {
      dup2(get_fd(*d_stdout, 0), 1);
      }
   else if (is:integer(*d_stdout)) {
      dup2(IntVal(*d_stdout), 1);
      }
   if (is:file(*d_stderr)) {
      dup2(get_fd(*d_stderr, 0), 2);
      }
   else if (is:integer(*d_stderr)) {
      dup2(IntVal(*d_stderr), 2);
      }
}


#ifdef Graphics
/*
 * Get a window that has an event pending (queued).
 * pollevent() can allocate memory, so lws is unsafe after that.
 */
struct b_list *findactivewindow(struct b_list *lws)
   {
   LONG i, j;
   tended union block *ep;
   tended struct descrip d;

   if (lws->size == 0) return NULL;
   d = nulldesc;
   ep = (union block *)(lws->listhead);
   /*
   * Check for any new pending events.
   */
   switch (pollevent()) {
      case -1: ReturnErrNum(141, NULL);
      case 0: return NULL;
      }
   /*
    * go through listed windows, looking for those with events pending
    */
   for ( ; BlkType(ep) == T_Lelem; ep = Blk(ep,Lelem)->listnext) {
      for (i = 0; i < Blk(ep,Lelem)->nused; i++) {
         union block *bp;
         wbp w;
         wsp ws;
         int status;
         j = ep->Lelem.first + i;
         if (j >= ep->Lelem.nslots)
            j -= ep->Lelem.nslots;

         if (!(is:file(ep->Lelem.lslots[j]) &&
               (status = BlkD(ep->Lelem.lslots[j],File)->status) &&
               (status & Fs_Window)))
            syserr("internal error calling findactivewindow()");
         if (!(status & Fs_Read)) {
            /* a closed window was found on the list, ignore it */
            continue;
            }
         bp = BlkLoc(ep->Lelem.lslots[j]);
         w = Blk(bp,File)->fd.wb;
         ws = w->window;
         if (BlkD(ws->listp,List)->size > 0) {
            if (is:null(d)) {
               BlkLoc(d) = (union block *)alclist(0, MinListSlots);
               d.dword = D_List;
               }
            c_put(&d, &(Blk(ep,Lelem)->lslots[j]));
            }
         }
      }
   if (is:null(d)) return NULL;
   return BlkD(d, List);
}
#endif                                  /* Graphics */
#endif                                  /* PosixFns */
