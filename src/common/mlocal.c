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

char patchpath[MaxPath+18] = "%PatchStringHere->";
char uniroot[MaxPath+18] = "%PatchUnirotHere->";

static char *findexe(char *name, char *buf, size_t len);
char *findonpath(char *name, char *buf, size_t len);
static char *followsym(char *name, char *buf, size_t len);
static char *canonize(char *path);

#if HAVE_GETENV_R
int
getenv_r(const char *name, char *buf, size_t len);
#endif					/* HAVE_GETENV_R */

char *
getenv_var(const char *name)
{
  char *buf, *buf2;
  int rv, len = 512;

#if HAVE_GETENV_R
  buf = malloc(len);
  if (buf == NULL)
    return NULL;
  
  while (1) {
    rv = getenv_r(name, buf, len-1);
    if (rv == 0)
      return buf;
    else if (errno == ERANGE) {
      len = len * 2;
      buf2 = realloc(buf, len);
      if (buf2 == NULL ) {
	free(buf);
	return NULL;
	}
      buf = buf2;
    }
    else {
      free(buf);
      return NULL;
    }
  }
#else 					/* HAVE_GETENV_R */
  if ((buf = getenv(name)) != NULL)
    return strdup(buf);
  else
    return NULL;
#endif 					/* HAVE_GETENV_R */
}

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
 *  unirootfile(prog, mod) -- find related file.
 *
 * relfile(), overridden to find unicon libraries from the unicon root.
 * Look at patch location if present, and compute relative to that. If
 * no patch location, then do it relative to prog like before.
 */
char *unirootfile(char *prog, char *mod) {
  char *rv;
  if (strlen(uniroot)>18) {
    /*
     * use mod, but relative to uniroot location, which is above
     * mod's reference two levels down into bin/prog.  Remove /../..
     * from mod.
     */
    mod += 6;
    rv = malloc(strlen(uniroot+18) + strlen(mod) + 1);
    strcpy(rv, uniroot+18);
    strcat(rv, mod);
    return rv;
  }
  else return relfile(prog, mod);
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

FILE *pathOpen(char *fname, char *mode)
{
   char tmp[256];
   char *s = findexe(fname, tmp, 255);
   if (s) {
#if MSDOS
     int pathOpenHandle(char *fname, char *mode);
     int handle = pathOpenHandle(s, mode);
     if (handle == -1) return NULL;
     return fdopen(handle, mode);
#else
     return fopen(tmp, mode);
#endif
      }
   return NULL;
}


void quotestrcat(char *buf, char *s)
{
   if (strchr(s, ' ')) strcat(buf, "\"");
   strcat(buf, s);
   if (strchr(s, ' ')) strcat(buf, "\"");
}

/*
 * Return path after appending lib directories.
 * FIXME: replace localbuf+salloc with precalculated malloc.
 */
char *libpath(char *prog, char *envname) {
   char buf[2000], *s;
   char *sep = ";";

   s = getenv(envname);
   if (s != NULL)
      strcpy(buf, s);
   else
      strcpy(buf, ".");
   if (!strcmp(envname, "IPATH")) {
      strcat(buf, sep);
      quotestrcat(buf, unirootfile(prog, "/../../ipl/lib"));
     }
   else if (!strcmp(envname, "LPATH")) {
      strcat(buf, sep);
      quotestrcat(buf, unirootfile(prog, "/../../ipl/mincl"));
      strcat(buf, sep);
      quotestrcat(buf, unirootfile(prog, "/../../ipl/gincl"));
      strcat(buf, sep);
      quotestrcat(buf, unirootfile(prog, "/../../ipl/incl"));
      }
   strcat(buf, sep);
   quotestrcat(buf, unirootfile(prog, "/../../uni/lib"));
   strcat(buf, sep);
   quotestrcat(buf, unirootfile(prog, "/../../uni/gui"));
   strcat(buf, sep);
   quotestrcat(buf, unirootfile(prog, "/../../uni/xml"));
   strcat(buf, sep);
   quotestrcat(buf, unirootfile(prog, "/../../uni/parser"));
   strcat(buf, sep);
   quotestrcat(buf, unirootfile(prog, "/../../uni/3d"));
   strcat(buf, sep);
   quotestrcat(buf, unirootfile(prog, "/../../plugins/lib"));

   return salloc(buf);
   }

#else                                  /* UNIX */

static char junk;		/* avoid empty module */

#endif					/* UNIX */


#if !UNIX
char junkclocal; /* avoid empty module */
#endif					/* !UNIX */


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
#elif defined(_M_ARM) || defined(__arm) || defined(__arm__) || defined(__aarch32__) || defined(__aarch64__)
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
