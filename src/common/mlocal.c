/*
 * mlocal.c - special platform specific code
 */
#include "../h/gsupport.h"

#if UNIX || NT

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#if UNIX || defined(NTGCC)
#include <unistd.h>
#endif					/* UNIX || NTGCC */
#if UNIX
#define PATHSEP ':'
#define FILESEP '/'
#endif					/* UNIX */
#if MSDOS
#define PATHSEP ';'
#define FILESEP '\\'
#if !defined(NTGCC)
#define getcwd _getcwd
#endif					/* !NTGCC */
#endif					/* MSDOS */

static char *findexe(char *name, char *buf, size_t len);
char *findonpath(char *name, char *buf, size_t len);
static char *followsym(char *name, char *buf, size_t len);
static char *canonize(char *path);

/*
 *  relfile(prog, mod) -- find related file.
 *
 *  Given that prog is the argv[0] by which this program was executed,
 *  and assuming that it was set by the shell or other equally correct
 *  invoker, relfile finds the location of a related file and returns
 *  it in an allocated string.  It takes the location of prog, appends
 *  mod, and canonizes the result; thus if argv[0] is icont or its path,
 *  relfile(argv[0],"/../iconx") finds the location of iconx.
 */
char *relfile(char *prog, char *mod) {
   static char baseloc[MaxPath];
   char buf[MaxPath];

   if (baseloc[0] == 0) {		/* if argv[0] not already found */
      if (findexe(prog, baseloc, sizeof(baseloc)) == NULL) {
	 fprintf(stderr, "cannot find location of %s\n", prog);
         exit(EXIT_FAILURE);
	 }
      if (followsym(baseloc, buf, sizeof(buf)) != NULL)
         strcpy(baseloc, buf);
   }

   strcpy(buf, baseloc);		/* start with base location */
   strcat(buf, mod);			/* append adjustment */

   canonize(buf);			/* canonize result */

   if ((mod[strlen(mod)-1] == '/')	/* if trailing slash wanted */
#if MSDOS
       ||(mod[strlen(mod)-1] == '\\')
#endif
       )
      sprintf(buf+strlen(buf), "%c", FILESEP);/* append to result */
   return salloc(buf);			/* return allocated string */
   }

/*
 *  findexe(prog, buf, len) -- find absolute executable path, given argv[0]
 *
 *  Finds the absolute path to prog, assuming that prog is the value passed
 *  by the shell in argv[0].  The result is placed in buf, which is returned.
 *  NULL is returned in case of error.
 */

static char *findexe(char *name, char *buf, size_t len) {
   int n;
   char *s;

   if (name == NULL)
      return NULL;

   /* if name does not contain a slash, search $PATH for file */
   if ((strchr(name, '/') != NULL)
#if MSDOS
       || (strchr(name, '\\') != NULL)
#endif
       )
      strcpy(buf, name);
   else if (findonpath(name, buf, len) == NULL) {
      strcpy(buf, name);
      }

   /* if path is not absolute, prepend working directory */
#if MSDOS
   if (! (isalpha(buf[0]) && buf[1] == ':'))
#endif					/* MSDOS */
   if ((buf[0] != '/')
#if MSDOS
       && (buf[0] != '\\')
#endif					/* MSDOS */
   ) {
      n = strlen(buf) + 1;
      memmove(buf + len - n, buf, n);
      if (getcwd(buf, len - n) == NULL)
         return NULL;
      s = buf + strlen(buf);
      *s = '/';
      memcpy(s + 1, buf + len - n, n);
      }
   canonize(buf);
   return buf;
   }

/*
 *  findonpath(name, buf, len) -- find name on $PATH
 *
 *  Searches $PATH (using POSIX 1003.2 rules) for executable name,
 *  writing the resulting path in buf if found.
 */
char *findonpath(char *name, char *buf, size_t len) {
   int nlen, plen;
   char *path, *next, *sep, *end;

   nlen = strlen(name);
   path = getenv("PATH");
   if (path == NULL || *path == '\0')
      path = ".";
   end = path + strlen(path);
   for (next = path; next <= end; next = sep + 1) {
      sep = strchr(next, PATHSEP);
      if (sep == NULL)
         sep = end;
      plen = sep - next;
      if (plen == 0) {
         next = ".";
         plen = 1;
         }
      if (plen + 1 + nlen + 1 > len) {
	 *buf = '\0';
         return NULL;
         }
      memcpy(buf, next, plen);
      
#if NT
      if (buf[plen-1] != '\\')
	buf[plen++] = '\\';
#else					/* NT */
      if (buf[plen-1] != '/')
	buf[plen++] = '/';
#endif					/* NT */
      strcpy(buf + plen, name);
#if NT
/* X_OK flag not reliable, just check whether the file exists */
#define access _access
#ifndef X_OK
#define X_OK 00
#endif
#endif					/* NT */
      if (access(buf, X_OK) == 0)
         return buf;
#if MSDOS
      strcat(buf, ".exe");
      if (access(buf, X_OK) == 0)
         return buf;
#endif
      }
   *buf = '\0';
   return NULL;
   }

/*
 *  followsym(name, buf, len) -- follow symlink to final destination.
 *
 *  If name specifies a file that is a symlink, resolves the symlink to
 *  its ultimate destination, and returns buf.  Otherwise, returns NULL.
 *
 *  Note that symlinks in the path to name do not make it a symlink.
 *
 *  buf should be long enough to hold name.
 */

#define MAX_FOLLOWED_LINKS 24

static char *followsym(char *name, char *buf, size_t len) {
   int i, n;
   char *s, tbuf[MaxPath];

#if UNIX
   strcpy(buf, name);

   for (i = 0; i < MAX_FOLLOWED_LINKS; i++) {
      if ((n = readlink(buf, tbuf, sizeof(tbuf) - 1)) <= 0)
         break;
      tbuf[n] = 0;

      if (tbuf[0] == '/') {
         if (n < len)
            strcpy(buf, tbuf);
         else
            return NULL;
         }
      else {
         s = strrchr(buf, '/');
         if (s != NULL)
            s++;
         else
            s = buf;
         if ((s - buf) + n < len)
            strcpy(s, tbuf);
         else
            return NULL;
         }
      canonize(buf);
      }

   if (i > 0 && i < MAX_FOLLOWED_LINKS)
      return buf;
   else
#endif
      return NULL;
   }

/*
 *  canonize(path) -- put file path in canonical form.
 *
 *  Rewrites path in place, and returns it, after excising fragments of
 *  "." or "dir/..".  All leading slashes are preserved but other extra
 *  slashes are deleted.  The path never grows longer except for the
 *  special case of an empty path, which is rewritten to be ".".
 *
 *  No check is made that any component of the path actually exists or
 *  that inner components are truly directories.  From this it follows
 *  that if "foo" is any file path, canonizing "foo/.." produces the path
 *  of the directory containing "foo".
 */

static char *canonize(char *path) {
   int len = 0;
   char *root = path, *end = path + strlen(path),
        *in = NULL, *out = NULL, *prev = NULL;

#if MSDOS
   while(strchr(path, '\\')) *strchr(path, '\\') = '/';
#endif

   /* initialize */
#ifdef MSDOS
   if (isalpha(root[0]) && root[1]==':') root += 2;
#endif
   while (*root == '/')		/* preserve all leading slashes */
      root++;
   in = root;				/* input pointer */
   out = root;				/* output pointer */

   /* scan string one component at a time */
   while (in < end) {

      /* count component length */
      for (len = 0; in + len < end && in[len] != '/'; len++)
         ;

      /* check for ".", "..", or other */
      if (len == 1 && *in == '.')	/* just ignore "." */
         in++;
      else if (len == 2 && in[0] == '.' && in[1] == '.') {
         in += 2;			/* skip over ".." */
         /* find start of previous component */
         prev = out;
         if (prev > root)
            prev--;			/* skip trailing slash */
         while (prev > root && prev[-1] != '/')
            prev--;			/* find next slash or start of path */
         if (prev < out - 1
         && (out - prev != 3 || strncmp(prev, "../", 3) != 0)) {
            out = prev;		/* trim trailing component */
            }
         else {
            memcpy(out, "../", 3);	/* cannot trim, so must keep ".." */
            out += 3;
            }
         }
      else {
         memmove(out, in, len);	/* copy component verbatim */
         out += len;
         in += len;
         *out++ = '/';		/* add output separator */
         }

      while (in < end && *in == '/')	/* consume input separators */
         in++;
      }

   /* final fixup */
   if (out > root)
      out--;				/* trim trailing slash */
   if (out == path)
      *out++ = '.';			/* change null path to "." */
   *out++ = '\0';
#if MSDOS
   while(strchr(path, '/')) *strchr(path, '/') = '\\';
#endif
   return path;			/* return result */
}

#if !MSDOS
FILE *pathOpen(char *fname, char *mode)
{
   char tmp[256];
   char *s = findexe(fname, tmp, 255);
   if (s) {
      return fopen(tmp, mode);
      }
   return NULL;
}
#endif

void quotestrcat(char *buf, char *s)
{
   if (strchr(s, ' ')) strcat(buf, "\"");
   strcat(buf, s);
   if (strchr(s, ' ')) strcat(buf, "\"");
}

/*
 * Return path after appending lib directories.
 */
char *libpath(char *prog, char *envname) {
   char buf[1000], *s;

   s = getenv(envname);
   if (s != NULL)
      strcpy(buf, s);
   else
      strcpy(buf, ".");
   if (!strcmp(envname, "IPATH")) {
      strcat(buf, " ");
      quotestrcat(buf, relfile(prog, "/../../ipl/lib"));
     }
   else if (!strcmp(envname, "LPATH")) {
      strcat(buf, " ");
      quotestrcat(buf, relfile(prog, "/../../ipl/mincl"));
      strcat(buf, " ");
      quotestrcat(buf, relfile(prog, "/../../ipl/gincl"));
      strcat(buf, " ");
      quotestrcat(buf, relfile(prog, "/../../ipl/incl"));
      }
   strcat(buf, " ");
   quotestrcat(buf, relfile(prog, "/../../uni/lib"));
   strcat(buf, " ");
   quotestrcat(buf, relfile(prog, "/../../uni/gui"));
   return salloc(buf);
   }

#else                                  /* UNIX */

static char junk;		/* avoid empty module */

#endif					/* UNIX */


#if AMIGA && __SASC
#include <workbench/startup.h>
#include <rexx/rxslib.h>
#include <proto/dos.h>
#include <proto/icon.h>
#include <proto/wb.h>
#include <proto/rexxsyslib.h>
#include <proto/exec.h>

int _WBargc;
char **_WBargv;
struct MsgPort *_IconPort = NULL;
char *_PortName;

/* This is an SAS/C auto-initialization routine.  It extracts the
 * filename arguments from the ArgList in the Workbench startup message
 * and generates an ANSI argv, argc from them.  These are given the
 * global pointers _WBargc and _WBargv.  It also checks the Tooltypes for
 * a WINDOW specification and points the ToolWindow to it.  (NOTE: the
 * ToolWindow is a reserved hook in the WBStartup structure which is
 * currently unused. When the Workbench supports editing the ToolWindow,
 * this ToolType will become obsolete.)  The priority is set to 400 so
 * this will run before the stdio initialization (_iob.c).  The code in
 * _iob.c sets up the default console window according to the ToolWindow
 * specification, provided it is not NULL. 
 */

int __stdargs _STI_400_WBstartup(void) {
   struct WBArg *wba;
   struct DiskObject *dob;
   int n;
   char buf[512];
   char *windowspec;

   _WBargc = 0;
   if(_WBenchMsg == NULL || Output() != NULL) return 0;
   _WBargv = (char **)malloc((_WBenchMsg->sm_NumArgs + 4)*sizeof(char *));
   if(_WBargv == NULL) return 1;
   wba = _WBenchMsg->sm_ArgList;

   /* Change to the WB icon's directory */
   CurrentDir((wba+1)->wa_Lock);

   /* Get the window specification */
   if(dob = GetDiskObject((wba+1)->wa_Name)) {
      if(dob->do_ToolTypes){
         windowspec = FindToolType(dob->do_ToolTypes, "WINDOW");
         if (windowspec){
            _WBenchMsg->sm_ToolWindow = malloc(strlen(windowspec)+1);
            strcpy(_WBenchMsg->sm_ToolWindow, windowspec);
            }
         }
      FreeDiskObject(dob);
      }

   /* Create argc and argv */
   for(n = 0; n < _WBenchMsg->sm_NumArgs; n++, wba++){
      if (wba->wa_Name != NULL &&
              NameFromLock(wba->wa_Lock, buf, sizeof(buf)) != 0) {
         AddPart(buf, wba->wa_Name, sizeof(buf));
         _WBargv[_WBargc] = (char *)malloc(strlen(buf) + 1);
         if (_WBargv[_WBargc] == NULL) return 1; 
         strcpy(_WBargv[_WBargc], buf);
         _WBargc++;
         }
      }

   /* Just in case ANSI is watching ... */
   _WBargv[_WBargc] = NULL;
   }

/* We open and close our message port with this auto-initializer and
 * auto-terminator to minimize disruption of the Icon code.
 */

void _STI_10000_OpenPort(void) {
   char  *name;
   char  *end;
   int   n = 1;
   char  buf[256];

   if( GetProgramName(buf, 256) == 0) {
     if (_WBargv == NULL) return; 
     else strcpy(buf, _WBargv[0]);
     }

   name = FilePart(buf);
   _PortName = malloc(strlen(name) + 2);
   strcpy(_PortName, name);
   end = _PortName + strlen(_PortName);
   /* In case there are many of us */ 
   while ( FindPort(_PortName) != NULL ) {
      sprintf(end, "%d", n++);
      if (n > 9) return;
      }
   _IconPort = CreatePort(_PortName, 0);
   }

void _STD_10000_ClosePort(void) {
   struct Message *msg;

   if (_IconPort) {
      while (msg = GetMsg(_IconPort)) ReplyMsg(msg);
      DeletePort(_IconPort);
      }
   }

/*
 * This posts an error message to the ARexx Clip List.
 * The clip is named <_PortName>Clip.<errorcount>.  The value
 * string contains the file name, line number, error number and
 *  error message.
 */
static int errorcount = 0;

void PostClip(char *file, int line, int number, char *text) {
   struct MsgPort *rexxport;
   struct RexxMsg *rxmsg;
   char name[128];
   char value[512];

   if ( _IconPort ) {
      if ( rxmsg = CreateRexxMsg(_IconPort, NULL, NULL) ) {
         errorcount++;
         sprintf(name, "%sClip.%d", _PortName, errorcount);
         sprintf(value, "File: %s Line: %d Number: %d Text: %s",
                         file, line, number, text);
         rxmsg->rm_Action = RXADDCON;
         ARG0(rxmsg) = name;
         ARG1(rxmsg) = value;
         ARG2(rxmsg) = (unsigned char *)(strlen(value) + 1);
         Forbid();
         rexxport = FindPort("REXX");
         if ( rexxport ) { 
            PutMsg(rexxport, (struct Message *)rxmsg);
            WaitPort(_IconPort);
            }
         Permit();
         GetMsg(_IconPort);
         DeleteRexxMsg(rxmsg);
         }
      }
   }


/*
 * This function sends a message to the resident ARexx process telling it to
 * run the specified script with argument a stem for the names of the clips
 * containing error information.  The intended use is to invoke an editor
 *  when a fatal error is encountered.
 */

void CallARexx(char *script) {
   struct MsgPort *rexxport;
   struct RexxMsg *rxmsg;
   char command[512];

   if ( _IconPort ) {
      if ( rxmsg = CreateRexxMsg(_IconPort, NULL, NULL) ) {
         sprintf(command, "%s %sClip", script, _PortName);
         rxmsg->rm_Action = RXCOMM | RXFB_NOIO;
         ARG0(rxmsg) = command;
         if (FillRexxMsg(rxmsg,1,0) ) {
            Forbid();
            rexxport = FindPort("REXX");
            if ( rexxport ) { 
               PutMsg(rexxport, (struct Message *)rxmsg);
               WaitPort(_IconPort);
               }
            Permit();
            GetMsg(_IconPort);
            ClearRexxMsg(rxmsg,1);
            }
         DeleteRexxMsg(rxmsg);
         }
      }
   }
#endif					/* AMIGA && __SASC */

#if !UNIX && !(AMIGA && __SASC)
char junkclocal; /* avoid empty module */
#endif					/* !UNIX && !(AMIGA && __SASC) */


/*
 * This function retrieves platform specific C compiler information for 
 * &features and is called from keyword.r. 
 */

int get_CCompiler(char *s)
{
#ifdef __GNUC__
#ifdef __MINGW32__
	 sprintf(s, "CCompiler MinGW gcc %d.%d.%d",
		 __GNUC__,  __GNUC_MINOR__, __GNUC_PATCHLEVEL__);
	 return 1;
#else					/* MINGW32 */
#ifdef __clang__
	 sprintf(s, "CCompiler clang %d.%d.%d",
		 __clang_major__,  __clang_minor__, __clang_patchlevel__);
	 return 1;
#else					/* clang */
         sprintf(s, "CCompiler gcc %d.%d.%d",
		 __GNUC__,  __GNUC_MINOR__, __GNUC_PATCHLEVEL__);
	 return 1;
#endif					/* clang */
#endif					/* MINGW32 */

#else					/* GNUC */
#ifdef MSVC
	 sprintf(s, "CCompiler MSC %d.%d",
		 _MSC_VER/100, _MSC_VER%100);
	 return 1;
#else					/* MSVC */
	 sprintf(s, "\0");
	 return 0;
#endif					/* MSVC */
#endif					/* GNUC */
} 

/*
 * This function retrieves platform architecture for
 * &features and is called from keyword.r. 
 * pre allocated buffer for s is 20 bytes, make sure to increase it
 * if you add an arch that requires more.
 */
void get_arch(char *arch){
 /* 
  * Catch different symbols defined by different 
  * compilers all at once. 
  * Need to be tested on various platforms.
  */
  char *s;  
#if defined(_M_X86) || defined(_M_X64) || defined(__i386) || defined(__amd64)
  s = "x86";
#elif defined(_M_ARM) || defined(__arm) || defined(__aarch64__)
  s = "arm";
#elif defined(__mips)
  s = "mips";
#elif defined(__powerpc)
  s = "powerpc";
#else
  s = "unknown";
#endif

  sprintf(arch, "Arch %s_%d", s, WordBits);
}
