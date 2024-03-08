/*
 * File: rlocal.r
 * Routines needed for different systems.
 */

/*  IMPORTANT NOTE:  Because of the way RTL works, this file should not
 *  contain any includes of system files, as in
 *
 *      include <foo>
 *
 *  Instead, such includes should be placed in h/sys.h.
 */

/*
 * The following code is operating-system dependent [@rlocal.01].
 *  Routines needed by different systems.
 */

#if PORT
   /* place for anything system-specific */
Deliberate Syntax Error
#endif                                  /* PORT */

#if NT
   char *internal_cmds[] = {
      "dir", "cd", "chdir", "copy", "ren", "rename", "del", "erase",
      "md", "mkdir", "rd", "rmdir", "vol", "label", "verify", "type",
      "break", "cls", "chcp", "ctty", "date", "echo", "lh", "loadhigh",
      "lock", "path", "pause", "prompt", "set", "time", "unlock", "ver", NULL
      };
int is_internal(char *s)
{
   int i = 0;
   char cmd[12], *cmdp, *s_ptr, *p;

   if ( p = strchr(s, ' ')){
      cmdp=cmd; s_ptr=s;
      if (p-s_ptr>9) return 0;
      while (s_ptr!=p){ *cmdp=*s_ptr; cmdp++; s_ptr++;}
      *cmdp='\0';
      cmdp=cmd;
      }
   else
      cmdp=s;

   while (internal_cmds[i]) {
      if (! strcmp(cmdp, internal_cmds[i])) return 1;
      i++;
      }
   return 0;
}
#endif                                  /* NT */


/*********************************** MSDOS ***********************************/

#if MSDOS

#if TURBO
extern unsigned _stklen = 16 * 1024;
#endif                                  /* TURBO */

#endif                                  /* MSDOS */

/*********************************** UNIX ***********************************/

#if UNIX

#ifdef HAVE_WORKING_VFORK
/*
 * Modified     3/03/2001       Manuel Novoa III
 *
 * Added check for legal mode arg.
 * Call fdopen and check return value before forking.
 * Reduced code size by using variables pr and pnr instead of array refs.
 */

#if ! defined __NR_vfork && defined __UCLIBC_HAS_MMU__
#define vfork fork
#endif

struct filepid {
   FILE *f;
   int pid;
   word status;
   struct filepid *next;
   };
struct filepid *root_of_all_filepids;

void push_filepid(int pid, FILE *fp, word status){
   struct filepid *temp = malloc(sizeof(struct filepid));
   if (!temp) syserr("out of memory");
   temp->f = fp;
   temp->pid = pid;
   temp->status = status;
   MUTEX_LOCKID(MTX_ROOT_FILEPIDS);
   temp->next = root_of_all_filepids;
   root_of_all_filepids = temp;
   MUTEX_UNLOCKID(MTX_ROOT_FILEPIDS);
}

void clear_all_filepids(){
   struct filepid *temp, *temp2;
   MUTEX_LOCKID(MTX_ROOT_FILEPIDS);
   temp = root_of_all_filepids;
   root_of_all_filepids = NULL;
   MUTEX_UNLOCKID(MTX_ROOT_FILEPIDS);

   while (temp) {
      if (temp->status == Fs_BPipe)
         kill(temp->pid, SIGPIPE);
      else
         kill(temp->pid, EOF);

      temp2 = temp;
      temp = temp->next;
      free(temp2);
      }
}

FILE *popen (const char *command, const char *mode)
{
   FILE *fp;
   int pipe_fd[2];
   int pid, reading;
   int pr, pnr;

   reading = (mode[0] == 'r');
   if ((!reading && (mode[0] != 'w')) || mode[1]) {
#if 0
        __set_errno(EINVAL);                    /* Invalid mode arg. */
#else
        errno = EINVAL;
#endif
      }
   else if (pipe(pipe_fd) == 0) {
        pr = pipe_fd[reading];
        pnr = pipe_fd[1-reading];
        if ((fp = fdopen(pnr, mode)) != NULL) {
                if ((pid = vfork()) == 0) {     /* vfork -- child */
                        close(pnr);
                        close(reading);
                        if (pr != reading) {
                                dup2(pr, reading);
                                close(pr);
                        }
                        execl("/bin/sh", "sh", "-c", command, (char *) 0);
                        _exit(255);             /* execl failed! */
                } else {                        /* vfork -- parent or failed */
                        close(pr);
                        if (pid > 0) {  /* vfork -- parent */
                           push_filepid(pid, fp, Fs_Pipe);
                           return fp;
                        } else {                /* vfork -- failed! */
                           fclose(fp);
                        }
                }
        } else {                                /* fdopen failed */
                close(pr);
                close(pnr);
        }
   }
   return NULL;
}

int pclose(FILE *fd)
{
   struct filepid *temp, *temp2, *tail = NULL;
   int pid;
        int waitstat;
        if (fclose(fd) != 0) {
                return EOF;
        }
        MUTEX_LOCKID(MTX_ROOT_FILEPIDS);
        temp = root_of_all_filepids;
        while (temp) {
           if (temp->f == fd) {
              pid = temp->pid;
              if (temp->status == Fs_BPipe)
                 kill(pid, SIGPIPE);
              else
                 kill(pid, EOF);
              if (pid==waitpid(pid, &waitstat, 0 )){ /* we are good */
                 if ((temp2 = temp->next)) {
                    *temp = *(temp->next);
                    free(temp2);
                    }
                 else if (temp == root_of_all_filepids) {
                    free(temp);
                    root_of_all_filepids = NULL;
                    }
                 else if (tail && tail->next==temp) {
                    tail->next = temp->next;
                    free(temp);
                    }
                 MUTEX_UNLOCKID(MTX_ROOT_FILEPIDS);
                 return waitstat;
                 }
              }
           tail = temp;
           temp = temp->next;
           }
        MUTEX_UNLOCKID(MTX_ROOT_FILEPIDS);
        wait(&waitstat );
        return waitstat;
}
#endif

/*
 * Documentation notwithstanding, the Unix versions of the keyboard functions
 * read from standard input and not necessarily from the keyboard (/dev/tty).
 */
#define STDIN 0

/*
 * int getch() -- read character without echoing
 * int getche() -- read character with echoing
 *
 * Read and return a character from standard input in non-canonical
 * ("cbreak") mode.  Return -1 for EOF.
 *
 * Reading is done even if stdin is not a tty;
 * the tty get/set functions are just rejected by the system.
 */

int rchar(int with_echo);

int getch(void)         { return rchar(0); }
int getche(void)        { return rchar(1); }

int rchar(int with_echo)
{
   struct termios otty, tty;
   char c;
   int n;

   tcgetattr(STDIN, &otty);             /* get current tty attributes */

   tty = otty;
   tty.c_lflag &= ~ICANON;
   if (with_echo)
      tty.c_lflag |= ECHO;
   else
      tty.c_lflag &= ~ECHO;
   tcsetattr(STDIN, TCSANOW, &tty);     /* set temporary attributes */

   checkpollevent();

   n = read(STDIN, &c, 1);              /* read one char from stdin */

   tcsetattr(STDIN, TCSANOW, &otty);    /* reset tty to original state */

   if (n == 1)                          /* if read succeeded */
      return c & 0xFF;
   else
      return -1;
}

/*
 * kbhit() -- return nonzero if characters are available for getch/getche.
 */
int kbhit(void)
{

#ifdef KbhitIoctl
   unsigned i;
   ioctl(0, FIONREAD, &i);
   return i != 0;
#else                                   /* KbhitIoctl */
   struct termios otty, tty;
   fd_set fds;
   struct timeval tv;
   int rv;

   tcgetattr(STDIN, &otty);             /* get current tty attributes */

   tty = otty;
   tty.c_lflag &= ~ICANON;              /* disable input batching */
   tcsetattr(STDIN, TCSANOW, &tty);     /* set attribute temporarily */

   FD_ZERO(&fds);                       /* initialize fd struct */
   FD_SET(STDIN, &fds);                 /* set STDIN bit */
   tv.tv_sec = tv.tv_usec = 0;          /* set immediate return */
   rv = select(STDIN + 1, &fds, NULL, NULL, &tv);

   tcsetattr(STDIN, TCSANOW, &otty);    /* reset tty to original state */

   if (rv == -1) return 0;
   if (FD_ISSET(0, &fds)) return 1;
#endif                                  /* KbhitIoctl */

   return 0;
}

/*
 * kbhit_ms(n) -- return nonzero if characters are available for getch/getche,
 * waiting up to n milliseconds.
 */
int kbhit_ms(int n)
{
   struct termios otty, tty;
   struct pollfd fd_stdin;
   int rv;

   tcgetattr(STDIN, &otty);             /* get current tty attributes */

   tty = otty;
   tty.c_lflag &= ~ICANON;              /* disable input batching */
   tcsetattr(STDIN, TCSANOW, &tty);     /* set attribute temporarily */

   fd_stdin.fd = fileno(stdin);
   fd_stdin.events = POLLIN;

   rv = poll(&fd_stdin, 1, n);

   tcsetattr(STDIN, TCSANOW, &otty);    /* reset tty to original state */
   return rv == 1;                              /* return result */
}

#endif                                  /* UNIX */

/*********************************** VMS ***********************************/

#if VMS
#passthru #define LIB_GET_EF     LIB$GET_EF
#passthru #define SYS_CREMBX     SYS$CREMBX
#passthru #define LIB_FREE_EF    LIB$FREE_EF
#passthru #define DVI__DEVNAM    DVI$_DEVNAM
#passthru #define SYS_GETDVIW    SYS$GETDVIW
#passthru #define SYS_DASSGN     SYS$DASSGN
#passthru #define LIB_SPAWN      LIB$SPAWN
#passthru #define SYS_QIOW       SYS$QIOW
#passthru #define IO__WRITEOF    IO$_WRITEOF
#passthru #define SYS_WFLOR      SYS$WFLOR
#passthru #define sys_expreg     sys$expreg
#passthru #define STS_M_SUCCESS  STS$M_SUCCESS
#passthru #define sys_cretva     sys$cretva
#passthru #define SYS_ASSIGN     SYS$ASSIGN
#passthru #define SYS_QIO        SYS$QIO
#passthru #define IO__TTYREADALL IO$_TTYREADALL
#passthru #define IO__WRITEVBLK  IO$_WRITEVBLK
#passthru #define IO_M_NOECHO    IO$M_NOECHO
#passthru #define SYS_SCHDWK     SYS$SCHDWK
#passthru #define SYS_HIBER      SYS$HIBER

typedef struct _descr {
   int length;
   char *ptr;
} descriptor;

typedef struct _pipe {
   long pid;                    /* process id of child */
   long status;                 /* exit status of child */
   long flags;                  /* LIB$SPAWN flags */
   int channel;                 /* MBX channel number */
   int efn;                     /* Event flag to wait for */
   char mode;                   /* the open mode */
   FILE *fptr;                  /* file pointer (for fun) */
   unsigned running : 1;        /* 1 if child is running */
} Pipe;

Pipe _pipes[_NFILE];            /* one for every open file */

#define NOWAIT          1
#define NOCLISYM        2
#define NOLOGNAM        4
#define NOKEYPAD        8
#define NOTIFY          16
#define NOCONTROL       32
#define SFLAGS  (NOWAIT|NOKEYPAD|NOCONTROL)

/*
 * delay_vms - delay for n milliseconds
 */

void delay_vms(n)
int n;
{
   int pid = getpid();
   int delay_time[2];

   delay_time[0] = -1000 * n;
   delay_time[1] = -1;
   SYS_SCHDWK(&pid, 0, delay_time, 0);
   SYS_HIBER();
}

/*
 * popen - open a pipe command
 * Last modified 2-Apr-86/chj
 *
 *      popen("command", mode)
 */

FILE *popen(cmd, mode)
char *cmd;
char *mode;
{
   FILE *pfile;                 /* the Pfile */
   Pipe *pd;                    /* _pipe database */
   descriptor mbxname;          /* name of mailbox */
   descriptor command;          /* command string descriptor */
   descriptor nl;               /* null device descriptor */
   char mname[65];              /* mailbox name string */
   int chan;                    /* mailbox channel number */
   int status;                  /* system service status */
   int efn;
   struct {
      short len;
      short code;
      char *address;
      char *retlen;
      int last;
   } itmlst;

   if (!cmd || !mode)
      return (0);
   LIB_GET_EF(&efn);
   if (efn == -1)
      return (0);
   if (_tolower(mode[0]) != 'r' && _tolower(mode[0]) != 'w')
      return (0);
   /* create and open the mailbox */
   status = SYS_CREMBX(0, &chan, 0, 0, 0, 0, 0);
   if (!(status & 1)) {
      LIB_FREE_EF(&efn);
      return (0);
   }
   itmlst.last = mbxname.length = 0;
   itmlst.address = mbxname.ptr = mname;
   itmlst.retlen = &mbxname.length;
   itmlst.code = DVI__DEVNAM;
   itmlst.len = 64;
   status = SYS_GETDVIW(0, chan, 0, &itmlst, 0, 0, 0, 0);
   if (!(status & 1)) {
      LIB_FREE_EF(&efn);
      return (0);
   }
   mname[mbxname.length] = '\0';
   pfile = fopen(mname, mode);
   if (!pfile) {
      LIB_FREE_EF(&efn);
      SYS_DASSGN(chan);
      return (0);
   }
   /* Save file information now */
   pd = &_pipes[fileno(pfile)]; /* get Pipe pointer */
   pd->mode = _tolower(mode[0]);
   pd->fptr = pfile;
   pd->pid = pd->status = pd->running = 0;
   pd->flags = SFLAGS;
   pd->channel = chan;
   pd->efn = efn;
   /* fork the command */
   nl.length = strlen("_NL:");
   nl.ptr = "_NL:";
   command.length = strlen(cmd);
   command.ptr = cmd;
   status = LIB_SPAWN(&command,
      (pd->mode == 'r') ? 0 : &mbxname, /* input file */
      (pd->mode == 'r') ? &mbxname : 0, /* output file */
      &pd->flags, 0, &pd->pid, &pd->status, &pd->efn, 0, 0, 0, 0);
   if (!(status & 1)) {
      LIB_FREE_EF(&efn);
      SYS_DASSGN(chan);
      return (0);
   } else {
      pd->running = 1;
   }
   return (pfile);
}

/*
 * pclose - close a pipe
 * Last modified 2-Apr-86/chj
 *
 */
pclose(pfile)
FILE *pfile;
{
   Pipe *pd;
   int status;
   int fstatus;

   pd = fileno(pfile) ? &_pipes[fileno(pfile)] : 0;
   if (pd == NULL)
      return (-1);
   fflush(pd->fptr);                    /* flush buffers */
   fstatus = fclose(pfile);
   if (pd->mode == 'w') {
      status = SYS_QIOW(0, pd->channel, IO__WRITEOF, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      SYS_WFLOR(pd->efn, 1 << (pd->efn % 32));
   }
   SYS_DASSGN(pd->channel);
   LIB_FREE_EF(&pd->efn);
   pd->running = 0;
   return (fstatus);
}

/*
 * redirect(&argc,argv,nfargs) - redirect standard I/O
 *    int *argc         number of command arguments (from call to main)
 *    char *argv[]      command argument list (from call to main)
 *    int nfargs        number of filename arguments to process
 *
 * argc and argv will be adjusted by redirect.
 *
 * redirect processes a program's command argument list and handles redirection
 * of stdin, and stdout.  Any arguments which redirect I/O are removed from the
 * argument list, and argc is adjusted accordingly.  redirect would typically be
 * called as the first statement in the main program.
 *
 * Files are redirected based on syntax or position of command arguments.
 * Arguments of the following forms always redirect a file:
 *
 *    <file     redirects standard input to read the given file
 *    >file     redirects standard output to write to the given file
 *    >>file    redirects standard output to append to the given file
 *
 * It is often useful to allow alternate input and output files as the
 * first two command arguments without requiring the <file and >file
 * syntax.  If the nfargs argument to redirect is 2 or more then the
 * first two command arguments, if supplied, will be interpreted in this
 * manner:  the first argument replaces stdin and the second stdout.
 * A filename of "-" may be specified to occupy a position without
 * performing any redirection.
 *
 * If nfargs is 1, only the first argument will be considered and will
 * replace standard input if given.  Any arguments processed by setting
 * nfargs > 0 will be removed from the argument list, and again argc will
 * be adjusted.  Positional redirection follows syntax-specified
 * redirection and therefore overrides it.
 *
 */


redirect(argc,argv,nfargs)
int *argc, nfargs;
char *argv[];
{
   int i;

   i = 1;
   while (i < *argc)  {         /* for every command argument... */
      switch (argv[i][0])  {            /* check first character */
         case '<':                      /* <file redirects stdin */
            filearg(argc,argv,i,1,stdin,"r");
            break;
         case '>':                      /* >file or >>file redirects stdout */
            if (argv[i][1] == '>')
               filearg(argc,argv,i,2,stdout,"a");
            else
               filearg(argc,argv,i,1,stdout,"w");
            break;
         default:                       /* not recognized, go on to next arg */
            i++;
      }
   }
   if (nfargs >= 1 && *argc > 1)        /* if positional redirection & 1 arg */
      filearg(argc,argv,1,0,stdin,"r"); /* then redirect stdin */
   if (nfargs >= 2 && *argc > 1)        /* likewise for 2nd arg if wanted */
      filearg(argc,argv,1,0,stdout,"w");/* redirect stdout */
}



/* filearg(&argc,argv,n,i,fp,mode) - redirect and remove file argument
 *    int *argc         number of command arguments (from call to main)
 *    char *argv[]      command argument list (from call to main)
 *    int n             argv entry to use as file name and then delete
 *    int i             first character of file name to use (skip '<' etc.)
 *    FILE *fp          file pointer for file to reopen (typically stdin etc.)
 *    char mode[]       file access mode (see freopen spec)
 */

filearg(argc,argv,n,i,fp,mode)
int *argc, n, i;
char *argv[], mode[];
FILE *fp;
{
   if (strcmp(argv[n]+i,"-"))           /* alter file if arg not "-" */
      fp = freopen(argv[n]+i,mode,fp);
   if (fp == NULL)  {                   /* abort on error */
      fprintf(stderr,"%%can't open %s",argv[n]+i);
      exit(EXIT_FAILURE);
   }
   for ( ;  n < *argc;  n++)            /* move down following arguments */
      argv[n] = argv[n+1];
   *argc = *argc - 1;                   /* decrement argument count */
}

#ifdef KeyboardFncs

short channel;
int   request_queued = 0;
int   char_available = 0;
char  char_typed;

void assign_channel_to_terminal()
{
   descriptor terminal;

   terminal.length = strlen("SYS$COMMAND");
   terminal.ptr    = "SYS$COMMAND";
   SYS_ASSIGN(&terminal, &channel, 0, 0);
}

word read_a_char(echo_on)
int echo_on;
{
   if (char_available) {
      char_available = 0;
      if (echo_on)
         SYS_QIOW(2, channel, IO__WRITEVBLK, 0, 0, 0, &char_typed, 1,
                  0, 32, 0, 0);
      goto return_char;
      }
   if (echo_on)
      SYS_QIOW(1, channel, IO__TTYREADALL, 0, 0, 0, &char_typed, 1, 0, 0, 0, 0);
   else
      SYS_QIOW(1, channel, IO__TTYREADALL | IO_M_NOECHO, 0, 0, 0,
               &char_typed, 1, 0, 0, 0, 0);

return_char:
   if (char_typed == '\003' && kill(getpid(), SIGINT) == -1) {
      perror("kill");
      return 0;
      }
   if (char_typed == '\034' && kill(getpid(), SIGQUIT) == -1) {
      perror("kill");
      return 0;
      }
   return (word)char_typed;
}

int getch()
{
   return read_a_char(0);
}

int getche()
{
   return read_a_char(1);
}

void ast_proc()
{
   char_available = 1;
   request_queued = 0;
}

int kbhit()
{
   if (!request_queued) {
      request_queued = 1;
      SYS_QIO(1, channel, IO__TTYREADALL | IO_M_NOECHO, 0, ast_proc, 0,
              &char_typed, 1, 0, 0, 0, 0);
      }
   return char_available;
}

#endif                                  /* KeyboardFncs */

#endif                                  /* VMS */
/*
 * End of operating-system specific code.
 */

/* static char xjunk;                   /* avoid empty module */
