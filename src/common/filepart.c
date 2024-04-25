/*
 * This file contains pathfind(), fparse(), makename(), smatch(),
 * pathOpen(), pathOpenHandle(), and openlog().
 */
#include "../h/gsupport.h"

static char *pathelem   (char *s, char *buf);
static char *tryfile    (char *buf, char *dir, char *name, char *extn);

/*
 * The following code is operating-system dependent [@filepart.01].
 *
 *  Define symbols for building file names.
 *  1. Prefix: the characters that terminate a file name prefix
 *  2. FileSep: the char to insert after a dir name, if any
 *  2. DefPath: the default IPATH/LPATH, if not null
 *  3. PathSep: allowable IPATH/LPATH separators, if not just " "
 */

#if PORT
   #define Prefix "/"
   #define FileSep '/'
   Deliberate Syntax Error
#endif                                  /* PORT */

#if MSDOS
   #define Prefix "/:\\"
   #define DefPath ";"
   #define PathSep " ;"
   #define FileSep '/'
#endif                                  /* MSDOS */

#if MVS
   #define Prefix ""
   #define FileSep '('
#endif                                  /* MVS */

#if VM
   #define Prefix ""
#endif                                  /* VM */

#if UNIX
   #define Prefix "/"
   #define FileSep '/'
   #define PathSep " ;"
#endif                                  /* UNIX */

#if VMS
   #define Prefix "]:"
#endif                                  /* VMS */

/*
 * End of operating-system specific code.
 */

#ifndef DefPath
   #define DefPath ""
#endif                                  /* DefPath */

#ifndef PathSep
   #define PathSep " ;"
#endif                                  /* PathSep */

static char *last_vetted_path;
static char *vetted_PathSep;
void vet_the_PathSep(char *s)
{
   vetted_PathSep = NULL;
   /*
    * if there exists a non-space char in PathSep, and if s contains an
    * instance of that character, search only using that non-space char.
    */
   if (strlen(PathSep)>1) {
      if (PathSep[0] == ' ') {
         vetted_PathSep = PathSep;
         vetted_PathSep++;
      }
      else if ((vetted_PathSep = malloc(2)) != NULL) {
         vetted_PathSep[0] = PathSep[0]; vetted_PathSep[1] = '\0';
         }
      if (!strchr(s, vetted_PathSep[0])) vetted_PathSep = PathSep;
      }
   if (vetted_PathSep == NULL) vetted_PathSep = PathSep;
}


/*
 * pathfind(buf,path,name,extn) -- find file in path and return name.
 *
 *  pathfind looks for a file on a path, begining with the current
 *  directory.  Details vary by platform, but the general idea is
 *  that the file must be a readable simple text file.  pathfind
 *  returns buf if it finds a file or NULL if not.
 *
 *  buf[MaxFileName] is a buffer in which to put the constructed file name.
 *  path is the IPATH or LPATH value, or NULL if unset.
 *  name is the file name.
 *  extn is the file extension (.icn or .u1) to be appended, or NULL if none.
 */
char *pathfind(char *buf, char *path, char *name, char *extn)
   {
   char *s;
   char pbuf[MaxFileName];

   if (tryfile(buf, (char *)NULL, name, extn))  /* try curr directory first */
      return buf;
   if (!path)                           /* if no path, use default */
      path = DefPath;
   s = path;

   if ((last_vetted_path == NULL) || strcmp(last_vetted_path, path)) {
      vet_the_PathSep(path);
      if (last_vetted_path != NULL) free(last_vetted_path);
      last_vetted_path = strdup(path);
      }

   while ((s = pathelem(s, pbuf)) != 0) {       /* for each path element */
      if (tryfile(buf, pbuf, name, extn))       /* look for file */
         return buf;
   }
   return NULL;                         /* return NULL if no file found */
   }

/*
 * pathelem(s,buf) -- copy next path element from s to buf.
 *
 *  Returns the updated pointer s.
 */
static char *pathelem(char *s, char *buf)
   {
   char c;

   while ((c = *s) != '\0' && strchr(vetted_PathSep, c))
      s++;
   if (!*s)
      return NULL;

   if (*s == '"') {
     s++;
     while ((c = *s) != '\0' && (c != '"')) {
      *buf++ = c;
       s++;
     }
     s++;
   }
   else {
     while ((c = *s) != '\0' && !strchr(vetted_PathSep, c)) {
       *buf++ = c;
       s++;
     }
   }
#ifdef FileSep
   /*
    * We have to append a path separator here.
    *  Seems like makename should really be the one to do that.
    */
   if (!strchr(Prefix, buf[-1])) {      /* if separator not already there */
      *buf++ = FileSep;
      }
#endif                                  /* FileSep */

   *buf = '\0';
   return s;
   }

/*
 * tryfile(buf, dir, name, extn) -- check to see if file is readable.
 *
 *  The file name is constructed in buf from dir + name + extn.
 *  findfile returns buf if successful or NULL if not.
 */
static char *tryfile(char *buf, char *dir, char *name, char *extn)
   {
   FILE *f;
   makename(buf, dir, name, extn);
   if ((f = fopen(buf, ReadText)) != NULL) {
      fclose(f);
      return buf;
      }
   else
      return NULL;
   }

/*
 * fparse - break a file name down into component parts.
 * Result is a pointer to a struct of static pointers good until the next call.
 */
struct fileparts *fparse(char *s)
   {
   static char buf[MaxFileName+2];
   static struct fileparts fp;
   int n;
   char *p, *q;

#if MVS
   static char extbuf [MaxFileName+2] ;

   p = strchr(s, '(');
   if (p) {
      fp.member = p+1;
      memcpy(extbuf, s, p-s);
      extbuf [p-s]  = '\0';
      s = extbuf;
   }
   else fp.member = s + strlen(s);
#endif                                  /* MVS */

   q = s;
   fp.ext = p = s + strlen(s);
   while (--p >= s) {
      if (*p == '.' && *fp.ext == '\0')
         fp.ext = p;
      else if (strchr(Prefix,*p)) {
         q = p+1;
         break;
         }
      }

   fp.dir = buf;
   n = q - s;
   strncpy(fp.dir,s,n);
   fp.dir[n] = '\0';
   fp.name = buf + n + 1;
   n = fp.ext - q;
   strncpy(fp.name,q,n);
   fp.name[n] = '\0';

#if VMS
   /* if a version is included, get separate extension and version */
   if (p = strchr(fp.ext, ';')) {
      fp.version = p;
      p = fp.ext;
      fp.ext = fp.name + n + 1;
      n = fp.version - p;
      strncpy(fp.ext, p, n);
      fp.ext[n] = '\0';
      }
   else
      fp.version = fp.name + n;         /* point version to '\0' */
#endif                                  /* VMS */

   return &fp;
   }

/*
 * makename - make a file name, optionally substituting a new dir and/or ext
 */
char *makename(char *dest, char *d, char *name, char *e)
   {
   struct fileparts fp;
   fp = *fparse(name);
   if (d != NULL)
      fp.dir = d;
   if (e != NULL)
      fp.ext = e;

#if MVS
   if (*fp.member)
      sprintf(dest,"%s%s%s(%s", fp.dir, fp.name, fp.ext, fp.member);
   else
#endif                                  /* MVS */

   sprintf(dest,"%s%s%s",fp.dir,fp.name,fp.ext);

   return dest;
   }

/*
 * smatch - case-insensitive string match - returns nonzero if they match
 */
int smatch(char *s, char *t)
   {
   char a, b;
   for (;;) {
      while (*s == *t)
         if (*s++ == '\0')
            return 1;
         else
            t++;
      a = *s++;
      b = *t++;
      if (isupper(a))  a = tolower(a);
      if (isupper(b))  b = tolower(b);
      if (a != b)
         return 0;
      }
   }


#if NT
#include <sys/stat.h>
#include <direct.h>
#endif                                  /* NT */

/*
 * this version of pathfind, unlike the one above, is looking on
 * the real path to find an executable.
 */
int pathFind(char target[], char buf[], int n)
   {
   char *path;
   register int i;
   int res;
   struct stat sbuf;

   if ((target[0] == '/') || (target[0] == '\\') ||
       (target[1]==':' && target[2]=='\\')) {
      if ((res = stat(target, &sbuf)) == 0) {
         strcpy(buf, target);
         return 1;
         }
      }

   if ((path = getenv("PATH")) == 0)
      path = "";
#if NT
   else if (strlen(path)==0) {
      /*
       * PATH was not NULL, but is the empty string, on some  versions of
       * Windows the PATH was too long. Try and read it via a pipe from cmd.exe.
       */
      FILE *fpath;
      char buf[32768];
      if ((fpath = popen("cmd /C set PATH", "r")) != NULL) {
         if (fgets(buf, 32768, fpath) != NULL) {
            if (strncasecmp("path=", buf, 5) == 0) {
               path = strdup(buf+5);
               }
            }
         pclose(fpath);
         }
      }
#endif                                  /* NT */

   if (!getcwd(buf, n)) {               /* get current working directory */
      *buf = 0;         /* may be better to do something nicer if we can't */
      return 0;         /* find out where we are -- struggling to achieve */
      }                 /* something can be better than not trying */

   /* attempt to find the icode file in the current directory first */
   /* this mimicks the behavior of COMMAND.COM */
   if ((i = strlen(buf)) > 0) {
      i = buf[i - 1];
      if (i != '\\' && i != '/' && i != ':')
#if UNIX
         strcat(buf, "/");
#else                                   /* UNIX */
         strcat(buf, "\\");
#endif                                  /* UNIX */
      }
   strcat(buf, target);

   res = stat(buf, &sbuf);

   while(res && *path) {
#if UNIX
      for (i = 0; *path && *path != ':' && *path != ';' ; ++i)
#else
      for (i = 0; *path && *path != ';' ; ++i)
#endif
         buf[i] = *path++;
      if (*path)                        /* skip the ; or : separator */
         ++path;
      if (i == 0)                       /* skip empty fragments in PATH */
         continue;
#if UNIX
      if (i > 0 && buf[i-1] != '/' && buf[i-1] != '\\' && buf[i-1] != ':')
            buf[i++] = '/';
#else                                   /* UNIX */
      if (i > 0 && buf[i-1] != '/' && buf[i-1] != '\\')
            buf[i++] = '\\';
#endif                                  /* UNIX */
      strcpy(buf + i, target);
      res = stat(buf, &sbuf);
      /* exclude directories (and any other nasties) from selection */
      if (res == 0 && sbuf.st_mode & S_IFDIR)
         res = -1;
      }
   if (res != 0)
      *buf = 0;
   return res == 0;
   }



#if MSDOS
int pathOpenHandle(char *fname, char *mode)
   {
   char buf[260 + 1];
   int i, use = 1;

   /*
    * Find out if a path has been given in the file name.
    * If a path has been given with the file name, don't bother to
    * use the PATH.
    */
   for( i = 0; buf[i] = fname[i]; ++i)
      if ((buf[i] == '/') || (buf[i] == ':') || (buf[i] == '\\')) {
         use = 0;
         if (buf[i] == '/') buf[i] = '\\';
         }

   if (use && !pathFind(fname, buf, 250)) {
       return -1;
      }

#if NT
   if (mode[1] == 'b')
     return open(buf, ( mode[0]=='r' ? O_RDONLY : O_WRONLY) | O_BINARY);
   else
#endif                                  /* NT */
     return open(buf, mode[0]=='r' ? O_RDONLY : O_WRONLY);
   }

#endif                                  /* MSDOS */

/*
 * Global variables for logfiles.
 */
char *lognam;
FILE *flog;
char tmplognam[128];

void openlog(char *p)
{
   lognam = p;
   /*
    * Open logfile, if it was requested on the command line (-l option).
    * The log file is used by IDE's to report
    * translation errors and jump to the offending source code line.
    */
   if (lognam != NULL) {
      /*
       * Append to logfile if it exists, otherwise write to it;
       * reader of the logfile is responsible for deleting it.  Maybe also
       * need to think about: don't generate a logfile unless asked, because
       * if you weren't asked, there is no reader to delete that logfile.
       */
      if ((flog = fopen(lognam, "r")) != NULL) {
         flog = freopen(lognam, "a", flog);
         }
      else {
         flog = fopen(lognam, "w");
         }
      }
}

void closelog()
{
   if (flog) {
      fclose(flog);
      flog = NULL;
      }
}
