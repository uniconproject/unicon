
/*
 * Copyright 1997-2001 Shamim Mohamed.
 *
 * Modification and redistribution is permitted as long as this (and any
 * other) copyright notices are kept intact. If you make any changes,
 * please add a short note here with your name and what changes were
 * made.
 *
 * $Id: rposix.r,v 1.23 2004-10-09 12:17:54 rparlett Exp $
 */

#ifdef PosixFns

#include "../h/opdefs.h"

#define String(d, s) do {           \
      int len = strlen(s);          \
      StrLoc(d) = alcstr((s), len); \
      StrLen(d) = len;              \
} while (0)

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
   { 0,			40 },
   { "SIGABRT",		SIGABRT },	
   { "SIGALRM",         SIGALRM },
   { "SIGBREAK",        SIGBREAK },
   { "SIGBUS",          SIGBUS },
   { "SIGCHLD",         SIGCHLD },
   { "SIGCLD",		SIGCLD },
   { "SIGCONT",         SIGCONT },
   { "SIGEMT",          SIGEMT },
   { "SIGFPE",          SIGFPE },
   { "SIGFREEZE",	SIGFREEZE },
   { "SIGHUP",          SIGHUP },
   { "SIGILL",          SIGILL },
   { "SIGINT",          SIGINT },
   { "SIGIO",           SIGIO },
   { "SIGIOT",          SIGIOT },
   { "SIGKILL",         SIGKILL },
   { "SIGLOST",         SIGLOST },
   { "SIGLWP",		SIGLWP },
   { "SIGPIPE",         SIGPIPE },
   { "SIGPOLL",		SIGPOLL },
   { "SIGPROF",         SIGPROF },
   { "SIGPWR",          SIGPWR },
   { "SIGQUIT",         SIGQUIT },
   { "SIGSEGV",         SIGSEGV },
   { "SIGSTOP",         SIGSTOP },
   { "SIGSYS",          SIGSYS },
   { "SIGTERM",         SIGTERM },
   { "SIGTHAW",		SIGTHAW },
   { "SIGTRAP",         SIGTRAP },
   { "SIGTSTP",         SIGTSTP },
   { "SIGTTIN",         SIGTTIN },
   { "SIGTTOU",         SIGTTOU },
   { "SIGURG",          SIGURG },
   { "SIGUSR1",         SIGUSR1 },
   { "SIGUSR2",         SIGUSR2 },
   { "SIGVTALRM",       SIGVTALRM },
   { "SIGWAITING",	SIGWAITING },
   { "SIGWINCH",        SIGWINCH },
   { "SIGXCPU",         SIGXCPU },
   { "SIGXFSZ",         SIGXFSZ },
};

#if NT
WORD wVersionRequested = MAKEWORD( 2, 0 );
WSADATA wsaData;
int werr;
int WINSOCK_INITIAL=0;
#endif					/* NT */

int get_fd(file, errmask)
struct descrip file;
unsigned int errmask;
{
   int status;

   status = BlkLoc(file)->file.status;
   /* Check it's opened for reading, or it's a window */
   if ((status & Fs_Directory)
#ifdef Dbm
       || (status & Fs_Dbm)
#endif
       )
     return -1;

#ifdef Graphics
   if (status & Fs_Window)
#ifdef XWindows
     return XConnectionNumber(((wbp)(BlkLoc(file)->file.fd))->
				      window->display->display);
#else
     return -1;
#endif
#endif

   if (errmask && !(status & errmask))
      return -2;
   else

#if NT
#define fileno _fileno
#endif					/* NT */

      if (status & Fs_Socket)
	 return (int)(BlkLoc(file)->file.fd);
      else
	 return fileno(BlkLoc(file)->file.fd);
}


int get_uid(name)
char *name;
{
#if NT
   return -1;
#else					/* NT */
   struct passwd *pw;
   if (!(pw = getpwnam(name)))
      return -1;
   return pw->pw_uid;
#endif					/* NT */
}

int get_gid(name)
char *name;
{
#if NT
   return -1;
#else					/* NT */
   struct group *gr;
   if (!(gr = getgrnam(name)))
      return -1;
   return gr->gr_gid;
#endif					/* NT */
}

static int newmode(mode, oldmode)
char *mode;
int oldmode;
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
	    retmode &= ~(7 << i*3);
	    retmode &= ~(1 << i + 9);
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
#else					/* NT */
	       int u = umask(0);
	       umask(u);
#endif					/* NT */	
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


int getmodefd(fd, mode)
int fd;
char *mode;
{
   struct stat st;
   if (fstat(fd, &st) < 0)
      return -1;
   return newmode(mode, st.st_mode);
}

int getmodenam(path, mode)
char *path;
char *mode;
{
   struct stat st;
   if (path) {
     if (stat(path, &st) < 0)
        return -1;
     return newmode(mode, st.st_mode);
   } else
     return newmode(mode, 0);
}



/* Here we are going to create a record of type posix_struct
 * (defined in posix.icn because it's too painful for iconc if we
 * add a new record type here) and initialise the fields with the
 * fields from the struct stat. */
void stat2rec(st, dp, rp)
#if NT
struct _stat *st;
#else					/* NT */
struct stat *st;
#endif					/* NT */
struct descrip *dp;
struct b_record *rp;
{
   int i;
   char mode[12], *user, *group;
   struct passwd *pw;
   struct group *gr;

   dp->dword = D_Record;
   dp->vword.bptr = (union block *)rp;

   for (i = 0; i < 13; i++)
     rp->fields[i].dword = D_Integer;

   IntVal(rp->fields[0]) = (int)st->st_dev;
   IntVal(rp->fields[1]) = (int)st->st_ino;
   IntVal(rp->fields[3]) = (int)st->st_nlink;
   IntVal(rp->fields[6]) = (int)st->st_rdev;
   IntVal(rp->fields[7]) = (int)st->st_size;
   IntVal(rp->fields[8]) = (int)st->st_atime;
   IntVal(rp->fields[9]) = (int)st->st_mtime;
   IntVal(rp->fields[10]) = (int)st->st_ctime;
#if NT
   IntVal(rp->fields[11]) = (int)0;
   IntVal(rp->fields[12]) = (int)0;
#else
   IntVal(rp->fields[11]) = (int)st->st_blksize;
   IntVal(rp->fields[12]) = (int)st->st_blocks;
#endif

   rp->fields[13] = nulldesc;

   strcpy(mode, "----------");
#if NT
   if (st->st_mode & _S_IFREG) mode[0] = '-';
   else if (st->st_mode & _S_IFDIR) mode[0] = 'd';
   else if (st->st_mode & _S_IFCHR) mode[0] = 'c';
   else if (st->st_mode & _S_IFMT) mode[0] = 'm';

   if (st->st_mode & S_IREAD) mode[1] = mode[4] = mode[7] = 'r';
   if (st->st_mode & S_IWRITE) mode[2] = mode[5] = mode[8] = 'w';
   if (st->st_mode & S_IEXEC) mode[3] = mode[6] = mode[9] = 'x';
#else					/* NT */
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
#endif					/* NT */

   StrLoc(rp->fields[2]) = alcstr(mode, 10);
   StrLen(rp->fields[2]) = 10;

#if NT
   rp->fields[4] = rp->fields[5] = emptystr;
#else					/* NT */
   pw = getpwuid(st->st_uid);
   if (!pw) {
      sprintf(mode, "%d", st->st_uid);
      user = mode;
   } else
      user = pw->pw_name;
   StrLoc(rp->fields[4]) = alcstr(user, strlen(user));
   StrLen(rp->fields[4]) = strlen(user);
   
   gr = getgrgid(st->st_gid);
   if (!gr) {
      sprintf(mode, "%d", st->st_gid);
      group = mode;
   } else
      group = gr->gr_name;
   StrLoc(rp->fields[5]) = alcstr(group, strlen(group));
   StrLen(rp->fields[5]) = strlen(group);
#endif					/* NT */

}

struct descrip posix_lock = {D_Null};
struct descrip posix_timeval = {D_Null};
struct descrip posix_stat = {D_Null};
struct descrip posix_message = {D_Null};
struct descrip posix_passwd = {D_Null};
struct descrip posix_group = {D_Null};
struct descrip posix_servent = {D_Null};
struct descrip posix_hostent = {D_Null};

dptr rec_structor(name)
char *name;
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
      if (eq(&s, &gnames[i]))
         if (is:proc(globals[i]))
            return &globals[i];
         else
	    return 0;

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
struct sockaddr_in saddrs[128];

#if !defined(MAXHOSTNAMELEN)
#define MAXHOSTNAMELEN 32
#endif					/* MAXHOSTNAMELEN */

/*
 * Empty handler for connection alarm signals (used for timeouts).
 */
static void on_alarm(int x) 
{
}

FILE *sock_connect(char *fn, int is_udp, int timeout)
{
   int rc, fd, s, len, fromlen;
   struct sockaddr *sa, from;
   char *p, fname[BUFSIZ];
   struct sockaddr_in saddr_in;
   char *host = fname;
   static struct hostent he;
#if UNIX
   static struct sigaction sigact;
#endif					/* UNIX */

#if UNIX
   struct sockaddr_un saddr_un;
   int pathbuf_len = sizeof(saddr_un.sun_path);
#endif					/* UNIX */

   errno = 0;
   memset(&saddr_in, 0, sizeof(saddr_in));
   strncpy(fname, fn, sizeof(fname));
   if ((p = strchr(fname, ':')) != 0) {
      /* inet domain socket */

      int port = atoi(p+1);
      char hostname[MAXHOSTNAMELEN];
      struct hostent *hp;
      *p = 0;    

      if (port == 0) {
	 errno = ENXIO;
	 return 0;
      }

#if NT
      if (!WINSOCK_INITIAL)   {
        werr = WSAStartup( wVersionRequested, &wsaData );
	if ( werr != 0 ) {
	    /* Tell the user that we couldn't find a usable */
	    /* WinSock DLL.                                  */
	    fprintf(stderr, "can't startup windows sockets\n");
	    return 0;
 	}
	WINSOCK_INITIAL = 1;
      }
#endif					/*NT*/

      if (*host == 0) {
          /* localhost - should we use gethostname() or "localhost"? SPM */
/*          gethostname(hostname, sizeof(hostname));*/
	  strncpy(hostname, "localhost", sizeof(hostname));
          host = hostname;
      }

      if ((hp = gethostbyname(host)) == NULL) {
	 return 0;
	 }

      /* Restore the argument just in case */
      *p = ':';
      
      if (is_udp) {
	 if ((s = socket(PF_INET, SOCK_DGRAM, 0)) < 0) return 0;
      } else {
	 if ((s = socket(PF_INET, SOCK_STREAM, 0)) < 0) return 0;
      }

      len = sizeof(struct sockaddr_in);
#ifdef BSD_4_4_LITE
      saddr_in.sin_len = len;
#endif
      saddr_in.sin_family = AF_INET;
      saddr_in.sin_port = htons((u_short)port);
      memcpy(&saddr_in.sin_addr, hp->h_addr, hp->h_length);
      sa = (struct sockaddr *) &saddr_in;
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
#ifdef BSD_4_4_LITE
      len += sizeof(saddr_un.sun_len);
      saddr_un.sun_len = len;
#endif
      sa = (struct sockaddr*) &saddr_un;
#endif					/* UNIX */
   }

   /* We don't connect UDP sockets but always use sendto(2). */
   if (is_udp) {
      /* save the sockaddr struct */
      saddrs[s] = saddr_in;
      return (FILE *)s;
      }

#if UNIX
   if (timeout > 0) {
      /* Set up a timeout alarm handler */
      sigact.sa_handler = on_alarm;
      sigact.sa_flags = 0;
      sigfillset(&sigact.sa_mask);
      sigaction(SIGALRM, &sigact, 0);
      /* alarm() takes seconds not millis... */
      alarm(timeout % 1000 ? 1 + timeout / 1000 : timeout / 1000);
   }
#endif					/* UNIX */

   rc = connect(s, sa, len);

#if UNIX
   if (timeout > 0)
      alarm(0);
#endif					/* UNIX */

   if (rc < 0) {
      close(s);
      return 0;
   }

   return (FILE *)s;
}

/*
 * Although this function is named "listen", it opens all incoming sockets,
 * including UDP sockets and non-blocking "listener" sockets on which a
 * later select() may turn up an accept.
 */
FILE *sock_listen(addr, is_udp_or_listener)
char *addr;
int is_udp_or_listener;
{
   int fd, s, len, fromlen;
   struct sockaddr *sa;
   struct sockaddr_in saddr_in, from;
#if UNIX
   struct sockaddr_un saddr_un;
#endif					/* UNIX */

   char hostname[MAXHOSTNAMELEN];
   struct hostent *hp;

   memset(&saddr_in, 0, sizeof(saddr_in));
   if ((s = sock_get(addr)) < 0) {
     char *p;

     /*
      * If the first argument is just a name, it's a unix domain socket.
      * If there's a : then it's host:port except if the host part is
      * empty, it means on any interface.
      */

     if ((p=strchr(addr, ':')) != NULL) {

#if NT
        if (!WINSOCK_INITIAL)   {
            werr = WSAStartup( wVersionRequested, &wsaData );
            if ( werr != 0 ) {
	        /* Tell the user that we couldn't find a usable */
	        /* WinSock DLL.                                  */
	        fprintf(stderr, "can't startup windows sockets\n");
	        return 0;
	    }
	    WINSOCK_INITIAL = 1;
        }
#endif					/*NT*/

        if (*addr == ':')
            saddr_in.sin_addr.s_addr = INADDR_ANY;
        else {
            /* XXX this part is still broken */
 
            /* Get the interface to listen on */
            *p = 0;
            strncpy(hostname, addr, sizeof(hostname)-1);
            *p = ':';

            /* Remember, gethostbyname(2) takes names as well as IPv4 & IPv6 */
            if ((hp = gethostbyname(hostname)) == NULL)
                return 0;
 
            memcpy(&saddr_in.sin_addr, hp->h_addr, hp->h_length);
            }

        len = sizeof(struct sockaddr_in);
#ifdef BSD_4_4_LITE
        saddr_in.sin_len = len;
#endif
        saddr_in.sin_family = AF_INET;
        saddr_in.sin_port = htons((u_short)atoi(p+1));
        if (saddr_in.sin_port == 0) {
           errno = ENXIO;
           return 0;
           }

        if (is_udp_or_listener == 1) {
            if ((s = socket(PF_INET, SOCK_DGRAM, 0)) < 0)
                return 0;
           }
	else {
            if ((s = socket(PF_INET, SOCK_STREAM, 0)) < 0)
                return 0;
	    }

        sa = (struct sockaddr*) &saddr_in;
      }
      else {
         /* unix domain socket */
#if NT
         return 0;
#endif
#if UNIX
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
#endif					/* UNIX */
      }
      if (bind(s, sa, len) < 0) {
	 return 0;
	 }
      if (is_udp_or_listener!=1 && listen(s, SOMAXCONN) < 0)
	 return 0;
      /* Save s for future calls to listen */
      sock_put(addr, s);
   }
    
   if (is_udp_or_listener)
      return (FILE *)s;

   fromlen = sizeof(from);
   if ((fd = accept(s, (struct sockaddr*) &from, &fromlen)) < 0)
      return 0;

   return (FILE *)fd;
}

/* Used for image() of connected sockets */
int sock_name(FILE* sock, char* addr, char* addrbuf, int bufsize)
{
   int s = (int) sock;
   int len;
   struct sockaddr_in conn;
   int addrlen = sizeof(conn);

   if (sock_get(addr) < 0)
      /* This is not a socket we know anything about */
      return 0;

   /* Otherwise we can construct a name for it and put in the string */
   if (getpeername(s, (struct sockaddr*) &conn, &addrlen) < 0)
       return 0;
   if (addrlen != sizeof(conn))
      return 0;
   len = snprintf(addrbuf, bufsize, "%s:%s:%d", addr,
                  inet_ntoa(conn.sin_addr), (int) ntohs(conn.sin_port));

   return len;
}
/* Used by function send(): in other words, create a socket, send, close it */
int sock_send(char *adr, char *msg, int msglen)
{
   struct sockaddr_in saddr_in;
   struct hostent *hp;
   char *host, *p, hostname[MAXHOSTNAMELEN], addr[BUFSIZ];
   int s, port, len;

   memset(&saddr_in, 0, sizeof(saddr_in));
   strncpy(addr, adr, sizeof(addr));
   if (!(p = strchr(addr, ':')))
      return 0;

   host = addr;
   port = atoi(p+1);
   *p = 0;
      
#if NT
   if (!WINSOCK_INITIAL)   {
      werr = WSAStartup( wVersionRequested, &wsaData );
      if ( werr != 0 ) {
	 /* Tell the user that we couldn't find a usable */
	 /* WinSock DLL.                                  */
	 fprintf(stderr, "can't startup windows sockets\n");
	 return 0;
      }
      WINSOCK_INITIAL = 1;
   }
#endif					/* NT */

   if (*host == 0) {
      /* localhost */
      /* localhost - should we use gethostname() or "localhost"? SPM */
/*          gethostname(hostname, sizeof(hostname));*/
      strncpy(hostname, "localhost", sizeof(hostname));
      host = hostname;
   }
   if ((hp = gethostbyname(host)) == NULL)
      return 0;

   /* Restore the argument just in case */
   *p = ':';
      
   if ((s = socket(PF_INET, SOCK_DGRAM, 0)) < 0)
      return 0;

   len = sizeof(saddr_in);
#ifdef BSD_4_4_LITE
   saddr_in.sin_len = len;
#endif
   saddr_in.sin_family = AF_INET;
   saddr_in.sin_port = htons((u_short)port);
   memcpy(&saddr_in.sin_addr, hp->h_addr, hp->h_length);
   len = sizeof(saddr_in);

   if (sendto(s, msg, msglen, 0, (struct sockaddr *)&saddr_in, len) < 0)
      return 0;

   close(s);

   return 1;
}

/* Used by function receive() to receive a UDP datagram into a record */
int sock_recv(f, rp)
FILE *f;
struct b_record *rp;
{
   int s, s_type;
   struct sockaddr_in saddr_in;
   struct hostent *hp;
   char buf[1024];
   int len, BUFSIZE = 1024, msglen;
   
   memset(&saddr_in, 0, sizeof(saddr_in));
   s = (int)f;
   len = sizeof(s_type);

#if NT
   if (!WINSOCK_INITIAL)   {
      werr = WSAStartup( wVersionRequested, &wsaData );
      if ( werr != 0 ) {
	 /* Tell the user that we couldn't find a usable */
	 /* WinSock DLL.                                  */
	 fprintf(stderr, "can't startup windows sockets\n");
	 return 0;
      }
      WINSOCK_INITIAL = 1;
   }
#endif					/* NT */

   if (getsockopt(s, SOL_SOCKET, SO_TYPE, (char *)&s_type, &len) < 0)
      return 0;
   if (s_type != SOCK_DGRAM)
      return -1;

   len = sizeof(saddr_in);
   if ((msglen = recvfrom(s, buf, BUFSIZE, 0, (struct sockaddr *)&saddr_in,
	 &len)) < 0)
      return 0;

   StrLen(rp->fields[1]) = msglen;
   StrLoc(rp->fields[1]) = alcstr(buf, msglen);

   hp = gethostbyaddr((char *)&saddr_in.sin_addr,
	 sizeof(saddr_in.sin_addr), saddr_in.sin_family);
   if (hp != NULL)
      sprintf(buf, "%s:%d", hp->h_name, ntohs(saddr_in.sin_port));
   else { /* Note: does not work for IPv6 addresses */
      unsigned int addr = ntohl(saddr_in.sin_addr.s_addr);
      sprintf(buf, "%d.%d.%d.%d:%d",
	     (addr & 0xff000000) >> 24, (addr & 0xff0000)   >> 16,
	     (addr & 0xff00)     >>  8, (addr & 0xff),
	     ntohs(saddr_in.sin_port));
      }

   String(rp->fields[0], buf);

   return 1;
}

int sock_write(FILE *f, char *msg, int n)
{
   int rv, s_type, len;
#if 1 /* NT */
   SOCKET fd = ((SOCKET)f);
#else					/* NT */
   int fd = fileno(f);
#endif					/* NT */

   len = sizeof(s_type);
   if (getsockopt(fd, SOL_SOCKET, SO_TYPE, (char *)&s_type, &len) < 0)
      return 0;

   if (s_type == SOCK_DGRAM)
      rv = sendto(fd, msg, n, 0,
		  (struct sockaddr *)&saddrs[fd], sizeof(struct sockaddr_in));
   else
      rv = send(fd, msg, n, 0);
   return rv;
}

static struct {
   char *name;
   int fd;
} sock_map[64] = { {0, 0} };
static int nsock = 0;

static int sock_get(s)
char *s;
{
   int i;
   for (i = 0; i < nsock; i++)
      if (strcmp(s, sock_map[i].name) == 0)
	 return sock_map[i].fd;
   return -1;
}

static void sock_put(s, fd)
char *s;
int fd;
{
   sock_map[nsock].fd = fd;
   sock_map[nsock].name = (char*) malloc(strlen(s) + 1);
   strcpy(sock_map[nsock].name, s);
   nsock++;
}

#if !NT
dptr make_pwd(pw, result)
struct passwd *pw;
dptr result;
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
#endif					/* !NT */

void catstrs(char **ptrs, dptr d)
{
   int nmem = 0, i, n;
   char *p;

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
dptr make_group(gr, result)
struct group *gr;
dptr result;
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
#endif					/* !NT */

dptr make_serv(s, result)
struct servent *s;
dptr result;
{
   struct b_record *rp;
   dptr constr;
   int nfields;
   int nmem = 0, i, n;

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

dptr make_host(hs, result)
struct hostent *hs;
 dptr result;
{
   struct b_record *rp;
   dptr constr;
   int nfields;
   int nmem = 0, i, n;
   unsigned int *addr;
   char *p;

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
 * Calling Icon from C (iconx)
 */

#if !COMPILER

/* No provision for resumption */
static word *callproc, ibuf[100];
static dptr call(proc, args, nargs)
struct descrip proc;
dptr args;
int nargs;
{
   int i, off, retval;
   inst saved_ipc;
   word *saved_sp = sp;
   inst wp;
   dptr dp, ret;

#ifdef HP
   bcopy(&ipc, &saved_ipc, sizeof(ipc));
#else					/* HP */
   saved_ipc = ipc;
#endif					/* HP */

   wp.opnd = callproc = ibuf;
   *wp.op++ = Op_Mark;   *wp.opnd++ = (2 + nargs+1)*2 * WordSize;
   *wp.op++ = Op_Copyd;  *wp.opnd++ = -(nargs+1);
   off = -nargs;
   for (i = 1; i < nargs+1; i++) {
      *wp.op++ = Op_Copyd;
      *wp.opnd++ = off++;
   }
   *wp.op++ = Op_Invoke;  *wp.opnd++ =  nargs;
   *wp.op++ = Op_Eret;
   *wp.op++ = Op_Trapret;
   *wp.op++ = Op_Trapfail;

   dp = (dptr)(sp + 1);
   dp[0] = proc;
   for (i = 0; i < nargs; i++)
      dp[i+1] = args[i];

   sp += (nargs+1)*2;
   ipc.op = (int *)callproc;
   retval = interp(0, NULL);
   if (retval != A_Resume) ret = (dptr)(sp-1);

#ifdef HP
   bcopy(&saved_ipc, &ipc, sizeof(ipc));
#else
   ipc = saved_ipc;
#endif
   sp = saved_sp;

   if (retval == A_Resume)
      return 0;
   else
      return ret;
}
#endif					/* !COMPILER */

/*
 * Signals and trapping
 */

/* Systems don't have more than, oh, about 50 signals, eh? */
static struct descrip handlers[50];
static int inited = 0;

struct descrip register_sig(sig, handler)
int sig;
struct descrip handler;
{
   struct descrip old;
   if (!inited) {
      int i;
      for(i = 0; i < 50; i++)
	 handlers[i] = nulldesc;
      inited = 1;
   }

   old = handlers[sig];
   handlers[sig] = handler;
   return old;
}

void signal_dispatcher(sig)
int sig;
{
   struct descrip proc, val;
   struct b_proc *pp;
   char *p;

   if (!inited) {
      int i;
      for(i = 0; i < 50; i++)
	 handlers[i] = nulldesc;
      inited = 1;
   }

   proc = handlers[sig];

   if (is:null(proc))
      return;

   /* Invoke proc */
   p = si_i2s(signalnames, sig);
   StrLen(val) = strlen(p);
   StrLoc(val) = p;

#if COMPILER
   syserr("signal handlers are not supported by iconc");
#else
   (void) call(proc, &val, 1);
#endif
   
   /* Restore signal just in case (for non-BSD systems) */
   signal(sig, signal_dispatcher);
}

/*
 * Unbuffered low-level reads - perform exactly one read(2) except if
 * n is zero, in which case read as much as possible without blocking
 *
 * returns an allocated string. If EOF then returns 0.
 */
dptr u_read(fd, n, d)
int fd, n;
dptr d;
{
   int tally = 0, nbytes;

   if (n > 0) {
      /* Allocate n bytes of char space */
      StrLoc(*d) = alcstr(NULL, n);
      StrLen(*d) = 0;
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
   } else {
      /* Read as much as we can without blocking, in chunks of 1000 bytes */
      char buf[1000];
      long bufsize = 1000, total = 0, i = 0;
      StrLoc(*d) = strfree;
      StrLen(*d) = 0;
      for(;;) {
	 fd_set readset;
	 struct timeval tv;
	 FD_ZERO(&readset);
	 FD_SET(fd, &readset);
	 tv.tv_sec = tv.tv_usec = 0;
	 if (select(fd+1, &readset, NULL, NULL, &tv) == 0)
 	    /* Nothing more is available */
	    break;

	 /* Something is available: allocate another chunk */
	 if (i == 0)
	    StrLoc(*d) = alcstr(NULL, bufsize);
	 else
	    /* Extend the string */
	    (void) alcstr(NULL, bufsize);
	 tally = read(fd, StrLoc(*d) + i*bufsize, bufsize);
	 if (i == 0 && tally <= 0) {
	    strtotal += bufsize;
	    strfree = StrLoc(*d);
	    return 0;
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


void dup_fds(dptr d_stdin, dptr d_stdout, dptr d_stderr)
{
   if (is:file(*d_stdin)) {
      dup2(get_fd(*d_stdin, 0), 0);
   }
   if (is:file(*d_stdout)) {
      dup2(get_fd(*d_stdout, 0), 1);
   }
   if (is:file(*d_stderr)) {
      dup2(get_fd(*d_stderr, 0), 2);
   }
}


#if 1 /* NT */
#ifdef Graphics
/*
 * Get a window that has an event pending (queued)
 */
struct b_list *findactivewindow(struct b_list *lws)
   {
   static LONG next = 0;
   LONG i, j;
   union block *ep;
   wsp ptr, ws;
   tended struct descrip d;
   extern FILE *ConsoleBinding;

   d = nulldesc;
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
   for (ep = (union block *)(lws->listhead); BlkType(ep) == T_Lelem;
	ep = ep->lelem.listnext) {
      for (i = 0; i < ep->lelem.nused; i++) {
	 dptr f;
	 j = ep->lelem.first + i;
	 if (j >= ep->lelem.nslots)
	    j -= ep->lelem.nslots;
	 f = &ep->lelem.lslots[j];
         if (!(is:file(*f) && BlkLoc(*f)->file.status & Fs_Window))
            syserr("internal error calling findactivewindow()");
	 if (BlkLoc(((wbp)(BlkLoc(*f)->file.fd))->window->listp)->list.size > 0) {
	    if (is:null(d)) {
	       BlkLoc(d) = (union block *)alclist(0, MinListSlots);
	       d.dword = D_List;
	       }
	    c_put(&d, f);
	    }
	 }
      }
   if (is:null(d)) return NULL;
   return (struct b_list *)BlkLoc(d);
}   
#endif					/* Graphics */
#endif					/* NT */
#endif					/* PosixFns */
