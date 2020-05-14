/*
 * ccomp.c - routines for compiling and linking the C program produced
 *   by the translator.
 */
#include "../h/gsupport.h"
#include "cglobals.h"
#include "ctrans.h"
#include "ctree.h"
#include "ccode.h"
#include "csym.h"
#include "cproto.h"

extern char *refpath;

/*
 * The following code is operating-system dependent [@tccomp.01].  Definition
 *  of ExeFlag and LinkLibs.
 */

#if PORT
   /* something is needed */
Deliberate Syntax Error
#endif						/* PORT */

#if MSDOS
#ifdef NTGCC
#define ExeFlag "-o"
#define LinkLibs " -lm"
#else
#define ExeFlag " "
#define LinkLibs " rt.lib libtp.lib gdbm.lib kernel32.lib winmm.lib WSOCK32.LIB ODBC32.LIB SHELL32.LIB"
#endif
#endif

#if UNIX || MACINTOSH || MVS || VM
#define ExeFlag "-o"
#define LinkLibs " -lm"
#endif						/* UNIX ... */
 
#if VMS
#include file
#define ExeFlag "link/exe="
#define LinkLibs ""
#endif						/* VMS */

/*
 * End of operating-system specific code.
 */

/*
 * Structure to hold the list of Icon run-time libraries that must be
 *  linked in.
 */
struct lib {
   char *libname;
   int nm_sz;
   struct lib *next;
   };
static struct lib *liblst;

/*
 * addlib - add a new library to the list the must be linked.
 */
void addlib(libname)
char *libname;
   {
   static struct lib **nxtlib = &liblst;
   struct lib *l;

   l = NewStruct(lib);

/*
 * The following code is operating-system dependent [@tccomp.02].
 *   Change path syntax if necessary.
 */

#if PORT
   /* something is needed */
Deliberate Syntax Error
#endif						/* PORT */

#if UNIX || MACINTOSH || MSDOS || MVS || VM
   l->libname = libname;
   l->nm_sz = strlen(libname);
#endif						/* UNIX ... */

#if VMS
   /* change directory string to VMS format */
   {
      struct fileparts *fp;
      char   *newlibname = alloc(strlen(libname) + 20);

      strcpy(newlibname, libname);
      fp = fparse(libname);
      if (strcmp(fp->name, "rt") == 0 && strcmp(fp->ext, ".olb") == 0)
         strcat(newlibname, "/lib/include=data");
      else
	 strcat(newlibname, "/lib");
      l->libname = newlibname;
      l->nm_sz = strlen(newlibname);
      }
#endif						/* VMS */

/*
 * End of operating-system specific code.
 */

   l->next = NULL;
   *nxtlib = l;
   nxtlib = &l->next;
   }

/*
 * This routine removes the optimizations options from
 * the string of options to be sent to the host compiler
 */
static
char *
rmv_ccomp_opts(opts)
   char * opts;
{
   char * p;
   char * q;
   char * rslt;

#if PORT || MACINTOSH || MSDOS || MVS || VM || VMS
   /* something may be needed */
   fprintf(stderr, "warning: option \"-nO\" unsupported on this platform.\n");
   return opts;
#endif						/* PORT || ... */

#if UNIX
   /*
    * on unix, -O is the first member of COpts
    */
   rslt = alloc(sizeof(char) * (strlen(opts) + 1));
   for (p=opts+1; p && *p != '-'; p++)
      ;
   q = rslt;
   while (p && *p)
      *q++ = *p++;
   *q = 0;
   return rslt;
#endif
}

/*
 * Grow a string.
 */
char *growcat(char *buf, int *buflenp, int n, ...)
{
   int i;
   char *s;
   va_list args;
   va_start(args, n);
   for(i=0; i<n; i++) {
      s = va_arg(args, char *);
      if (strlen(buf) + strlen(s) >= *buflenp) {
	 *buflenp *= 2;
	 if ((buf = realloc(buf, *buflenp)) == NULL) return NULL;
	 }
      strcat(buf, s);
      }
   va_end(args);
   return buf;
}

/*
 * ccomp - perform C compilation and linking.
 */
int ccomp(srcname, exename)
char *srcname;
char *exename;
   {
   struct lib *l;
   char sbuf[MaxFileName];		/* file name construction buffer */
   int  rv, buflen;
   char *buf, objname[MaxFileName];
   char *s;
   char *dlrgint;
   extern int opt_hc_opts;

   if (!opt_hc_opts)
      /*
       * The user has requested that all optimization
       * options be removed when invoking the host compiler
       */
      c_opts = rmv_ccomp_opts(c_opts);


#if 0
   /*
    * dlrgint disabled for now; linking in rt.a/rlrgint seems to conflict.
    */
   if (!largeints) {
      dlrgint = makename(sbuf, refpath, "dlrgint", ObjSuffix);
      }
#endif

   buflen = 256;
   buf = alloc(buflen);
   buf[0] = '\0';

/*
 * The following code is operating-system dependent [@tccomp.03].
 *  Construct the command line to do the compilation.
 *  This used to be very precise and efficient, but for every optional
 *  library the text and the ifdef had to happen twice, once for the
 *  length pre-count and then again for the string concatenation. Over
 *  time as the number of libraries grew, it became a maintenance problem.
 */

#if PORT || MACINTOSH || MVS || VM
   /* something may be needed */
Deliberate Syntax Error
#endif						/* PORT || ... */

#if MSDOS && !NTGCC
   /*
    * Visual Studio / VC++ / cl.exe
    */
   buf = growcat(buf, &buflen, 10, c_comp, " /c ", c_opts, " /I", refpath,
		 "..\\src\\gdbm /I", refpath, "..\\src\\libtp ", srcname, " ");

   /* First, the compile. */
   /*
    * Emit command-line if verbosity is set above 2
    */
   if (verbose > 2)
      fprintf(stdout, "%s\n", buf);

   if ((rv = system(buf)) != 0)
      return EXIT_FAILURE;

   /* then, the link */
   strcpy(objname, srcname);
   strcpy(objname+strlen(objname)-1, "obj"); /* replace .c with .obj */

   sprintf(buf, "link -subsystem:console %s /LIBPATH:%s %s -out:%s.exe",
	   objname, refpath, LinkLibs, exename);
#endif					/* MS-DOS && !NTGCC */

#if UNIX || NTGCC

   buf = growcat(buf, &buflen, 3, c_comp, " ", c_opts);

#ifdef Messaging
#if NTGCC
   buf = growcat(buf, &buflen, 3, " -I", refpath, "..\\src\\libtp");
#else					/* NTGCC */
   buf = growcat(buf, &buflen, 3, " -I", refpath, "../src/libtp");
#endif					/* NTGCC */
#endif					/* Messaging */
#ifdef Dbm
#if NTGCC
   buf = growcat(buf, &buflen, 3, " -I", refpath, "..\\src\\gdbm");
#else					/* NTGCC */
   buf = growcat(buf, &buflen, 3, " -I", refpath, "../src/gdbm");
#endif					/* NTGCC */
#endif					/* Dbm */
#ifdef Graphics
#if NTGCC
   buf = growcat(buf, &buflen, 3, " -I", refpath, "..\\src\\xpm");
#else					/* NTGCC */
   buf = growcat(buf, &buflen, 3, " -I", refpath, "../src/xpm");
#endif					/* NTGCC */
#endif					/* Graphics */
#if NTGCC
   buf = growcat(buf, &buflen, 3, " -I", refpath, "..\\src\\common");
#else					/* NTGCC */
   buf = growcat(buf, &buflen, 3, " -I", refpath, "../src/common");
#endif					/* NTGCC */
   buf = growcat(buf, &buflen, 6, " ", ExeFlag, " ", exename, " ", srcname);

#if 0
   if (!largeints) {
      buf = growcat(buf, &buflen, 2, " ", dlrgint);
      }
#endif
   for (l = liblst; l != NULL; l = l->next) {
      buf = growcat(buf, &buflen, 2, " ", l->libname);
      }

   buf = growcat(buf, &buflen, 2, " -L", refpath);

#ifdef Messaging
   buf = growcat(buf, &buflen, 1, " -ltp");
#endif					/* Messaging */

#ifdef Dbm
   buf = growcat(buf, &buflen, 1, " -lgdbm");
#endif					/* Dbm */

#ifdef Graphics
   buf = growcat(buf, &buflen, 1, " -lXpm");
#ifdef Graphics3D
   buf = growcat(buf, &buflen, 1, " -lGL -lGLU");
#endif					/* Graphics3D */
#endif					/* Graphics */

   buf = growcat(buf, &buflen, 1, " -luconsole");
   buf = growcat(buf, &buflen, 2, " ", ICONC_LIB);

#if HAVE_LIBZ
   buf = growcat(buf, &buflen, 1, " -lz");
#endif					/* HAVE_LIBZ */

#if HAVE_LIBJPEG
   buf = growcat(buf, &buflen, 1, " -ljpeg");
#endif					/* HAVE_LIBJPEG */

#if HAVE_LIBPTHREAD
   buf = growcat(buf, &buflen, 1, " -lpthread");
#endif					/* HAVE_LIBPTHREAD */

   buf = growcat(buf, &buflen, 2, " ", LinkLibs);

#if defined(MacOSX) || defined(HAVE_LIBFTGL)
   buf = growcat(buf, &buflen, 1, " -lstdc++");
#endif					/* MacOSX || HAVE_LIBFTGL */

#if HAVE_LIBSSL
   buf = growcat(buf, &buflen, 1, " -lssl -lcrypto");
#endif					/* HAVE_LIBSSL */

#if NTGCC
   buf = growcat(buf, &buflen, 1, " -lwinmm -lwsock32 -lodbc32 -lws2_32"); 
#endif					/* NTGCC */

#if UNIX
   /* needs to be more precise, add a HAVE_LIBDL or some such */
   buf = growcat(buf, &buflen, 1, " -ldl -export-dynamic ");
#endif					/* UNIX */

#endif					/* UNIX || NTGCC */

   /*
    * Emit command-line if verbosity is set above 2
    */
   if (verbose > 2)
      fprintf(stdout, "%s\n", buf);

#ifndef HAVE_SYS_WAIT_H
   // FIXME: this is a quick hack to solve iconc build on Windows
#define WEXITSTATUS(wstat)    (((wstat) >> 8) & 0xff)
#endif

   /*
    * FIXME: Man page says this about WEXITSTATUS
    * This macro should be employed only if WIFEXITED returned true.
    */
   /* Execute the (compile+)link */
   if ((rv = system(buf)) == -1)
      return EXIT_FAILURE;	/* fork() failed, or whatever */
   if (WEXITSTATUS(rv) != 0)
      return EXIT_FAILURE;	/* command failed */

#if UNIX || NTGCC
   /* Strip debug symbols from target unless they were requested. */
   if (!strstr(buf, " -g ") && !dbgsyms) {
      strcpy(buf, "strip ");
      s = buf + 6;
      strcpy(s, exename);
      if ((rv = system(buf)) == -1) return EXIT_FAILURE;
      if (WEXITSTATUS(rv) != 0) return EXIT_FAILURE;
      }
#endif						/* UNIX */

#if VMS

   buf = growcat(buf, &buflen, 5, c_comp, " ", c_opts, " ", srcname);

   /* compile */
   if (system(buf) == 0)
      return EXIT_FAILURE;

   /* link */
   buf[0] = '\0';
   buf = growcat(buf, &buflen, 4, ExeFlag, exename, " ", srcname);
   /* trim extension */
   buf[strlen(buf)-1] = '\0';
   buf = growcat(buf, &buflen, 1, "obj");

   for (l = liblst; l != NULL; l = l->next) {
      buf = growcat(buf, &buflen, 2, ",", l->libname);
      }

#ifdef Graphics
#ifdef HAVE_LIBXPM
   buf = growcat(buf, &buflen, 3, ",", refpath, "Xpm/lib");
#endif						/* HAVE_LIBXPM */
   buf = growcat(buf, &buflen, 3, ",", refpath, "X11.opt/opt");
#endif						/* Graphics */

   if (system(buf) == 0)
      return EXIT_FAILURE;
#endif						/* VMS */

/*
 * End of operating-system specific code.
 */

   return EXIT_SUCCESS;
   }
