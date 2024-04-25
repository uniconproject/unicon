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
      StrLen(d) = len;              \
} while (0)

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
   StrLen((*rp)->fields[2]) = 10;

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
   StrLen((*rp)->fields[4]) = strlen(user);

   getgrgid_r(st->st_gid, &grbuf, buf, 4096, &gr);
   if (gr == 0){
      sprintf(mode, "%d", st->st_gid);
      group = mode;
      }
   else {
      group = gr->gr_name;
      }
   StrLoc((*rp)->fields[5]) = alcstr(group, strlen(group));
   StrLen((*rp)->fields[5]) = strlen(group);
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
   StrLen(s) = strlen(name);
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
852 * UDP is just simpler - no listen or accept, only bind for sock_listen;
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
static void sock_put (char *, int);

/*
 * We also stash the sockaddr structs we created with host and port info for
 * any UDP sockets (and let's hope we don't run out of file descriptors)
 *
 * All because for UDP connect/send doesn't do what sendto does. (At least
 * on Linux 2.0.36)
 */

struct addrinfo **saddrs;

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

struct addrinfo *uni_getaddrinfo(char* addr, char* p, int is_udp, int family){
  int port = atoi(p);
  int nohost = 0, rc;
  struct addrinfo hints, *res0;

  if (port == 0) {
    errno = ENXIO;
    return NULL;
  }

  if (addr == NULL || addr[0] == '\0')
    nohost = 1;
#if NT
  if (!StartupWinSocket()) return 0;
#endif                                  /*NT*/

  INIT_ADDRINFO_HINTS(hints, family, (is_udp? SOCK_DGRAM : SOCK_STREAM),
                      (nohost?AI_PASSIVE:0), (is_udp?IPPROTO_UDP:IPPROTO_TCP));
  if ( (rc = getaddrinfo((nohost?NULL:addr), p, &hints, &res0)) != 0) {
    set_gaierrortext(rc);
    return NULL;
  }

  //dump_addrinfo(res0);
  return res0;
 }

/*
 * Empty handler for connection alarm signals (used for timeouts).
 */
/* static void on_alarm(int x)
{
}
*/

int sock_connect(char *fn, int is_udp, int timeout, int af_fam)
{
  int saveflags, rc, s, len;
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
    * find the last colon and get the port.
    */
   if (((p = strrchr(fname, ':')) != 0) ) {
      *p = 0;
      res0 = uni_getaddrinfo(fname, p+1, is_udp, af_fam);
      /* Restore the argument just in case */
      *p = ':';

      if (!res0)
        return 0;

      s = -1;
      for (res = res0; res; res = res->ai_next) {
        s = socket(res->ai_family, res->ai_socktype,
                   res->ai_protocol);
        if (s < 0) {
          continue;
        }

        /*
        if (connect(s, res->ai_addr, res->ai_addrlen) < 0) {
          close(s);
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
   }
   else {
      /* UNIX domain socket */
#if NT
      return 0;
#endif
#if UNIX
      if (is_udp || (s = socket(PF_UNIX, SOCK_STREAM, 0)) < 0)
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

   /* We don't connect UDP sockets but always use sendto(2). */
   if (is_udp) {
      /* save the sockaddr struct */
      saddrs = realloc(saddrs, (s+1) * (sizeof(struct addrinfo *)));
      if (saddrs == NULL) {
         close(s);
         return 0;
         }
      saddrs[s] = saddrinfo;
      return s;
      }

   if (timeout > 0) {
#if UNIX
      /* Save existing flags for restore later */
      saveflags = fcntl(s, F_GETFL, 0);
      if (saveflags < 0) {
         close(s);
         return 0;
      }
      /* Turn on non-blocking flag - this will make connect
         return immediately.  */
      if (fcntl(s, F_SETFL, saveflags|O_NONBLOCK) < 0) {
         close(s);
         return 0;
      }
#endif                                  /* UNIX */
#if NT
      /* Turn on non-blocking flag so connect will return immediately. */
      unsigned long imode = 1;
      if (ioctlsocket(s, FIONBIO, &imode) < 0) {
         errno = WSAGetLastError();
         closesocket(s);
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
         close(s);
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
            close(s);
            return 0;
            }

         /* Get the error code of the connect */
         cclen = sizeof(cc);
         if (getsockopt(s, SOL_SOCKET, SO_ERROR, &cc, &cclen) < 0) {
            close(s);
            return 0;
         }

         if (cc != 0) {
            /* There was an error, so set errno and fail */
            errno = cc;
            close(s);
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
         closesocket(s);
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
            closesocket(s);
            return 0;
         }

         /* Get the error code of the connect */
         cclen = sizeof(cc);
         if (getsockopt(s, SOL_SOCKET, SO_ERROR, (char*)&cc, &cclen) < 0) {
            errno = WSAGetLastError();
            closesocket(s);
            return 0;
         }

         if (cc != 0) {
            /* There was an error, so set errno and fail */
            errno = cc;
            closesocket(s);
            return 0;
         }

         return s;
      }
#endif                                  /* NT */
   }

   if (rc < 0) {
      close(s);
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
int sock_listen(char *addr, int is_udp_or_listener, int af_fam)
{
  int fd, s, len;
   struct addrinfo *res0, *res;
   struct sockaddr *sa;
   unsigned int fromlen;
   struct sockaddr_storage from;


   if ((s = sock_get(addr)) < 0) {
     char *p;

     /*
      * If the first argument is just a name, it's a unix domain socket.
      * If there's a : then it's host:port except if the host part is
      * empty, it means on any interface.
      */

      if ((p=strrchr(addr, ':')) != NULL) {
         *p = 0;
         res0 = uni_getaddrinfo(addr, p+1, is_udp_or_listener == 1, af_fam);
         *p = ':';

         if (!res0)
            return 0;

         s = -1;
         for (res = res0; res; res = res->ai_next) {
           s = socket(res->ai_family, res->ai_socktype,
                      res->ai_protocol);
           if (s < 0) {
             continue;
           }

           if (bind(s, res->ai_addr, res->ai_addrlen) < 0) {
             close(s);
             s = -1;
             continue;
           }

           break;  /* okay we got one */
         }

         if (res0)
           freeaddrinfo(res0);
         if (s < 0) {
           return 0;  // failed to bind to any address
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

         if ((is_udp_or_listener==1) ||
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
   }
   /* No need to listen on UDP sockets */
   if (is_udp_or_listener != 1)
     if (listen(s, SOMAXCONN) < 0)
       return 0;
   /* Save s for future calls to listen */
   sock_put(addr, s);

   if (is_udp_or_listener)
     return s;

   fromlen = sizeof(from);
   DEC_NARTHREADS;
   if ((fd = accept(s, (struct sockaddr*) &from, &fromlen)) < 0) fd = 0;
   INC_NARTHREADS_CONTROLLED;

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

   res0 = uni_getaddrinfo(host, p+1, 1, af_fam);
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
     close(s);
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
 * Used by function receive() to receive a UDP datagram into a record.
 * This allocates from the heaps, so rp must point at a tended pointer.
 */
int sock_recv(int s, struct b_record **rp)
{
   int s_type;
   char buf[2048];
   int bufsize = 2048, msglen;

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
   if (s_type != SOCK_DGRAM)
      return -1;

   if ((msglen = recvfrom(s, buf, bufsize, 0, sa, &addrlen)) < 0)
      return 0;

   StrLen((*rp)->fields[1]) = msglen;
   StrLoc((*rp)->fields[1]) = alcstr(buf, msglen);

   s = getnameinfo(sa, addrlen, host,
                                NI_MAXHOST,
                               serv, NI_MAXSERV, NI_NUMERICSERV);
   if (s == 0) {
     if ((snprintf(buf, bufsize,"%s:%s", host, serv )) >= bufsize )
       ;// TODO: handle buffer too small
   }
   else {
     if ((print_sockaddr(sa, addrbuf, INET6_ADDRSTRLEN)) == NULL) {
       set_syserrortext(errno);
       return 0;
     }
     snprintf(buf, bufsize, "%s:%d", addrbuf, get_sa_port(sa));
   }

   String((*rp)->fields[0], buf);

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

   if (s_type == SOCK_DGRAM){
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
} sock_map[64] = { {0, 0} };
static int nsock = 0;

/*
 * lookup a socket by name
 */
static int sock_get(char *s)
{
   int i;
   for (i = 0; i < nsock; i++)
      if (strcmp(s, sock_map[i].name) == 0)
         return sock_map[i].fd;
   return -1;
}

static void sock_put(char *s, int fd)
{
   MUTEX_LOCKID(MTX_SOCK_MAP);
   sock_map[nsock].fd = fd;
   sock_map[nsock].name = (char*) malloc(strlen(s) + 1);
   strcpy(sock_map[nsock].name, s);
   nsock++;
   MUTEX_UNLOCKID(MTX_SOCK_MAP);
}


#if HAVE_LIBSSL

/*
 *  Create and initialize an SSL context
 *     attr: attribute array passed to open()
 *     n   : size of the array
 *    type : connection type TLS/DTLS Server/Client
 */
SSL_CTX * create_ssl_context(dptr attr, int n, int type ) {

   SSL_CTX *ctx;
   //      if (status & Fs_Encrypt) {
   tended char *tmps, *val;
   tended char *certFile=NULL, *keyFile=NULL, *ciphers=NULL, *ciphers13=NULL, *password=NULL;
   tended char *ca_file=NULL, *ca_dir=NULL, *ca_store=NULL;
   tended char *min_proto=NULL, *max_proto=NULL, *verifyPeer=NULL;
   static int SSL_is_initialized = 0;
   C_integer timeout = 0;
   int count;
   int a;

   /*
    * Loop through and check the  attributes
    */
   for (a=0; a<n; a++) {
     if (is:null(attr[a])) {
       attr[a] = emptystr;
     }
     else if (a==0 && cnv:C_integer(attr[a], timeout)) {
       //timeout_set = 1;
     }
     else if (cnv:C_string(attr[a], tmps)) {
       /*
        * quick santiy check, reject any attribute
        *  - under 3 characters
        *  - starts or ends with '='
        */
       if (strlen(tmps) < 3 || tmps[0] == '=' || tmps[strlen(tmps)-1] == '=') {
         set_errortext_with_val(1302, tmps);
         return NULL;
       }

       /*
        * split the attribute at the '=' sign
        * attrib name up to '=', val is whatever comes after '='
        */
       val = strchr(tmps,'=');
       if (val != NULL) {
         *val = '\0';
         val++;
         if (strlen(val) == 0) {
           set_errortext_with_val(1302, tmps);
           return NULL;
         }
         //printf("attr: %s=%s\n", tmps, val);
         if (strcmp(tmps, "cert") == 0)
           certFile = val;
         else if (strcmp(tmps, "key") == 0)
           keyFile = val;
         else if (strcmp(tmps, "password") == 0)
           password = val;
         else if (strcmp(tmps, "ca") == 0)
           ca_file = val;
         else if (strcmp(tmps, "caDir") == 0)
           ca_dir = val;
         else if (strcmp(tmps, "caStore") == 0)
           ca_store = val;
         else if (strcmp(tmps, "ciphers") == 0)
           ciphers = val;
         else if (strcmp(tmps, "ciphers1.3") == 0)
           ciphers13 = val;
         else if (strcmp(tmps, "minProto") == 0)
           min_proto = val;
         else if (strcmp(tmps, "maxProto") == 0)
           max_proto = val;
         else if (strcmp(tmps, "verifyPeer") == 0)
           verifyPeer = val;
         else  {
           set_errortext_with_val(1302, tmps);
           return NULL;
         }
       }
       else  {
           set_errortext_with_val(1302, tmps);
           return NULL;
         }
     }
     else {
           set_errortext(1302);
           return NULL;
         }
    }

   /*
    * initialize OpenSSL library
    * TODO: make this thread safe.
    */
   if (!SSL_is_initialized) {
     SSL_library_init();
     OpenSSL_add_all_algorithms();  /* load & register all cryptos, etc. */
     SSL_load_error_strings();   /* load all error messages */
     SSL_is_initialized = 1;
   }

   /* the compiler wants "const", but rtt doesn't know it, just pass it through */
#passthru const SSL_METHOD *method;

   switch (type) {

#if !defined(MacOS) && OPENSSL_VERSION_NUMBER < 0x10100000L
   case TLS_SERVER: method = SSLv23_server_method(); break;
   case TLS_CLIENT: method = SSLv23_client_method(); break;
#else
   case TLS_SERVER: method = TLS_server_method(); break;
   case TLS_CLIENT: method = TLS_client_method(); break;
#endif

   case DTLS_SERVER: method = DTLS_server_method(); break;
   case DTLS_CLIENT: method = DTLS_client_method(); break;
   }

   ctx = SSL_CTX_new(method);   /* create new context from method */
   if (ctx == NULL) {
     set_ssl_context_errortext(1301, NULL);
     return NULL;
   }

   /*
    * cipher suites list for TLS 1.3 is differet hence we have ciphers and ciphers1.3.
    * Let us make the default "High" security for TLS1.2 and earlier.
    * TLS1.3 cihpher suite list is short and is already strong
    */
   if (ciphers == NULL)
     ciphers = "HIGH";
   // all ciphers string: "ALL"
   // For TLS 1.2 and below
   if (SSL_CTX_set_cipher_list(ctx, ciphers) != 1) {
     set_ssl_context_errortext(1306, ciphers);
     SSL_CTX_free(ctx);
     return NULL;
   }

#if OPENSSL_VERSION_NUMBER > 0x10100000L
   if (ciphers13 != NULL) {
     // For TLS 1.3
     if (SSL_CTX_set_ciphersuites(ctx, ciphers13) != 1) {
       set_ssl_context_errortext(1306, ciphers);
       SSL_CTX_free(ctx);
       return NULL;
     }
   }
#endif

   count = 2;
   do {
      char *proto;
      if (count == 2)
        proto = min_proto;
      else
        proto = max_proto;

      if (proto != NULL) {
        // supported versions are SSL3_VERSION, TLS1_VERSION, TLS1_1_VERSION,
        // TLS1_2_VERSION, TLS1_3_VERSION for TLS and DTLS1_VERSION, DTLS1_2_VERSION for DTLS.
#if !defined(MacOS) && (OPENSSL_VERSION_NUMBER < 0x10100000L)
#define TLS1_VERSION 10
#define TLS1_1_VERSION 11
#define TLS1_2_VERSION 12
#define TLS1_3_VERSION 13

#define DTLS1_VERSION 20
#define DTLS1_2_VERSION 22

#endif
        int ver;
        if (strcmp(proto, "TLS1.3") == 0)
          ver = TLS1_3_VERSION;
        else if (strcmp(proto, "TLS1.2") == 0)
          ver = TLS1_2_VERSION;
        else if (strcmp(proto, "TLS1.1") == 0)
          ver = TLS1_1_VERSION;
        else if (strcmp(proto, "TLS1.0") == 0)
          ver = TLS1_VERSION;
        /*      else if (strcmp(proto, "SSL3.0") == 0)
                ver = SSL3_VERSION; */
        else if (strcmp(proto, "DTLS1.2") == 0)
          ver = DTLS1_2_VERSION;
        else if (strcmp(proto, "DTLS1.0") == 0)
          ver = DTLS1_VERSION;
        else {
          set_ssl_context_errortext(1308, proto);
          SSL_CTX_free(ctx);
          return NULL;
        }

        /*
         * Set min/max acceptable protocol
         * OpenSSL 1.1 and after supports and easy way to set min/max
         * but we have to "manully" do it for earlier versions
         * Notice that only TLS protocols are considered,
         * SSL protocls are already old and deprecated
         */

        if (count == 2) {
#if !defined(MacOS) && (OPENSSL_VERSION_NUMBER < 0x10100000L)
          int old_ssl_flags=0;
          switch (ver) {
          case TLS1_2_VERSION: old_ssl_flags |= SSL_OP_NO_TLSv1 | SSL_OP_NO_TLSv1_1 |
              SSL_OP_NO_SSLv2 | SSL_OP_NO_SSLv3; break;
          case TLS1_1_VERSION: old_ssl_flags |= SSL_OP_NO_TLSv1 |
              SSL_OP_NO_SSLv2 | SSL_OP_NO_SSLv3; break;
          case TLS1_VERSION: old_ssl_flags |= SSL_OP_NO_SSLv2 | SSL_OP_NO_SSLv3; break;
          default:
            set_ssl_context_errortext(1308, proto);
            SSL_CTX_free(ctx);
            return NULL;
          }
          SSL_CTX_set_options(ctx, old_ssl_flags);
#else
          if (SSL_CTX_set_min_proto_version(ctx, ver) != 1) {
            set_ssl_context_errortext(1301, proto);
            SSL_CTX_free(ctx);
            return NULL;
          }
#endif
        }
        else {
#if !defined(MacOS) && (OPENSSL_VERSION_NUMBER < 0x10100000L)
         int old_ssl_flags=0;
          switch (ver) {
          case TLS1_2_VERSION: break;
          case TLS1_1_VERSION: old_ssl_flags |= SSL_OP_NO_TLSv1_2; break;
          case TLS1_VERSION: old_ssl_flags |= SSL_OP_NO_TLSv1_1 | SSL_OP_NO_TLSv1_2; break;
          default:
            set_ssl_context_errortext(1308, proto);
            SSL_CTX_free(ctx);
            return NULL;
            }
          SSL_CTX_set_options(ctx, old_ssl_flags);
#else
          if (SSL_CTX_set_max_proto_version(ctx, ver) != 1) {
            set_ssl_context_errortext(1301, proto);
            SSL_CTX_free(ctx);
            return NULL;
          }
#endif
        }
      }
   } while (--count>0);

   if (ca_file != NULL || ca_dir != NULL) {
     if (SSL_CTX_load_verify_locations(ctx, ca_file, ca_dir) != 1) {
       set_ssl_context_errortext(1305, ca_file);
       SSL_CTX_free(ctx);
       return NULL;
     }
   }
   if (verifyPeer == NULL) {
     if ((type == TLS_CLIENT) || (type == DTLS_CLIENT)) {
       // cannot fail
       SSL_CTX_set_verify(ctx, SSL_VERIFY_PEER,  NULL);
     }
   } else {
     if (strcmp(verifyPeer, "yes") == 0) {
       if ((type == TLS_CLIENT) || (type == DTLS_CLIENT))
         SSL_CTX_set_verify(ctx, SSL_VERIFY_PEER,  NULL);
       else
         SSL_CTX_set_verify(ctx,  SSL_VERIFY_PEER | SSL_VERIFY_FAIL_IF_NO_PEER_CERT,  NULL);
     } else if (strcmp(verifyPeer, "no") != 0) {
       set_errortext_with_val(1302, verifyPeer);
       SSL_CTX_free(ctx);
       return NULL;
       }
   }

   //SSL_CTX_set_verify_depth(ctx, 4);


   /*
   if (ca_dir != NULL) {
     if (SSL_CTX_set_default_verify_dir(ctx);SSL_CTX_load_verify_dir(ctx, ca_dir) != 1) {
       set_ssl_context_errortext(0, "ca dir");
       return NULL;
     }
   }

     if (ca_store != NULL) {
        if (SSL_CTX_load_verify_store(ctx,ca_store) <= 0) {
           set_ssl_context_errortext(0, "ca dir");
           return NULL;
         }
         SSL_CTX_set_default_verify_store(ctx);
     }
   */

   if (SSL_CTX_set_default_verify_paths(ctx) != 1) {
       set_ssl_context_errortext(1305, "verify paths");
       SSL_CTX_free(ctx);
       return NULL;
   }

   if (certFile != NULL) {
     /* set the local certificate from CertFile */
     if (SSL_CTX_use_certificate_file(ctx, certFile, SSL_FILETYPE_PEM) <= 0) {
       set_ssl_context_errortext(1304, certFile);
       SSL_CTX_free(ctx);
       return NULL;
     }
   }

   /* set the private key from KeyFile (may be the same as CertFile) */
   if (password != NULL) {
     // doesn't fail
     SSL_CTX_set_default_passwd_cb_userdata(ctx, password);

   }
   if (keyFile != NULL && SSL_CTX_use_PrivateKey_file(ctx, keyFile, SSL_FILETYPE_PEM) <= 0) {
     set_ssl_context_errortext(1303, keyFile);
     SSL_CTX_free(ctx);
     return NULL;
   }
   /* verify that the private key matches the cert */
   if (keyFile != NULL) {
     if (!SSL_CTX_check_private_key(ctx)) {
       set_ssl_context_errortext(0, NULL);
       SSL_CTX_free(ctx);
       return NULL;
     }
   }

   return ctx;
}
#endif                                  /* LIBSSL */


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

   StrLen(*d) = DiffPtrs(p,StrLoc(*d));
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
   StrLen(rp->fields[2]) = DiffPtrs(p,StrLoc(rp->fields[2]));
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

   StrLen(rp->fields[2]) = DiffPtrs(p,StrLoc(rp->fields[2]));
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
     StrLen(val) = strlen(p);
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
      StrLen(*d) = 0;
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
      StrLen(*d) = tally;
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
      StrLoc(*d) = strfree;
      StrLen(*d) = 0;
      for(;;) {
         int srv, kk=0;
         fd_set readset;
         struct timeval tv;
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

         /* Something is available: allocate another chunk */
         if (i == 0)
            StrLoc(*d) = alcstr(NULL, bufsize);
         else
            /* Extend the string */
            (void) alcstr(NULL, bufsize);
tryagain:

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
         StrLen(*d) = total;
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
