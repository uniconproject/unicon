/*
 * doincl.c -- expand include directives (recursively)
 *
 *  Usage:  doinclude [-o outfile] filename...
 *
 *  Doinclude copies a C source file, expanding non-system include directives.
 *  For each line of the form
 *      #include "filename"
 *  the named file is interpolated; all other lines are copied verbatim.
 *
 *  No error is generated if a file cannot be opened.
 */

#include "../h/rt.h"
#include <string.h>

void    doinclude       (char *fname);

#define MAXLINE 500     /* maximum line length */
#define MAXPATH 4096    /* resolved #include "..." paths */

FILE *outfile;          /* output file */

/*
 * Copy directory prefix of fname (through final '/') into dir, or "" if none.
 * Matches how the C preprocessor resolves #include "x" relative to the file.
 */
static void file_dirname(const char *fname, char *dir, size_t dlen)
   {
   const char *slash;

   if (fname == NULL || *fname == '\0' || dlen == 0) {
      if (dlen > 0)
         dir[0] = '\0';
      return;
      }
   slash = strrchr(fname, '/');
   if (slash == NULL) {
      dir[0] = '\0';
      return;
      }
   {
   size_t n = (size_t)(slash - fname) + 1;

   if (n >= dlen) {
      fprintf(stderr, "%s: directory prefix too long for doincl buffer\n", fname);
      n = dlen - 1;
      }
   memcpy(dir, fname, n);
   dir[n] = '\0';
   }
   }

int main(int argc, char *argv[])
   {
   char *progname = argv[0];

   outfile = stdout;
   if (argc > 3 && strcmp(argv[1], "-o") == 0) {
      if ((outfile = fopen(argv[2], "w")) != NULL) {
         argv += 2;
         argc -= 2;
         }
      else {
         perror(argv[2]);
         exit(1);
         }
      }
   if (argc < 2) {
      fprintf(stderr, "usage: %s [-o outfile] filename...\n", progname);
      exit(1);
      }

   fprintf(outfile,
      "/***** do not edit -- this file was generated mechanically *****/\n\n");
   while (--argc > 0)
      doinclude(*++argv);
   exit(0);
   /*NOTREACHED*/
   }

void doinclude(char *fname)
   {
   FILE *f;
   char line[MAXLINE], newname[MAXLINE], *p;
   char dir[MAXPATH], fullpath[MAXPATH];

   file_dirname(fname, dir, sizeof(dir));

   fprintf(outfile, "\n\n/****************************************");
   fprintf(outfile, "  from %s:  */\n\n", fname);
   if ((f = fopen(fname, "r")) != NULL) {
      while (fgets(line, MAXLINE, f))
         if (sscanf(line, " # include \"%s\"", newname) == 1) {
            for (p = newname; *p != '\0' && *p != '"'; p++)
               ;
            *p = '\0';                          /* strip off trailing '"' */
            if (newname[0] == '/') {
               doinclude(newname);              /* absolute path */
               }
            else {
               int plen = snprintf(fullpath, sizeof(fullpath), "%s%s", dir, newname);

               if (plen < 0) {
                  fprintf(stderr, "%s: cannot build include path\n", fname);
                  fprintf(outfile, "/* [file not found] */\n");
                  }
               else if ((size_t)plen >= sizeof(fullpath)) {
                  fprintf(stderr, "%s: include path too long: %s%s\n",
                          fname, dir, newname);
                  fprintf(outfile, "/* [file not found] */\n");
                  }
               else
                  doinclude(fullpath);         /* relative to this file */
               }
            }
         else
            fputs(line, outfile);               /* not an include directive */
      fclose(f);
      }
   else {
      fprintf(outfile, "/* [file not found] */\n");
      }
   fprintf(outfile, "\n/****************************************");
   fprintf(outfile, "   end %s   */\n", fname);
   }
