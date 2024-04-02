/*
 * patchstr.c -- install a string at preconfigured points in an executable
 *
 *  Original
 *  Usage:  patchstr filename newstring         -- to patch a file
 *          patchstr filename                   -- to report existing values
 *
 *  Extended Usage:
 *          patchstr -DPATCHSTRING filename newstring -- to patch
 *          patchstr -DPATCHSTRING filename           -- to report value
 *
 *  Patchstr installs or changes strings in an executable file.  It replaces
 *  null-terminated strings of up to 500 characters that are immediately
 *  preceded by the eighteen (unterminated) characters "%PatchStringHere->".
 *  -D option, if given, is preceded by % and suffixed by ->.
 *  Recommended -D values would be things like -DPatchUnilibHere,
 *  resulting in patch patterns like "%PatchUnilibHere->".
 *
 *  If the new string is shorter than the old string, it is null-padded.
 *  If the old string is shorter, it must have suffient null padding to
 *  accept the new string.
 *
 *  If no "newstring" is specified, existing values are printed.
 *
 *  4-Aug-91, 14-Feb-92 gmt
 */

#define PATCHSTR 1
#include "../h/rt.h"

#undef strlen

/* guard pattern; first character must not reappear later */
#define PATTERN "%PatchStringHere->"

/* maximum string length */
#define MAXLEN 500

#ifndef NOMAIN
void    report          (char *filename);
#endif
void    patchstr        (char *filename, char *newstring);
int     findpattern     (FILE *f);
int     oldval          (FILE *f, char buf[MAXLEN+2]);


int exitcode = 0;               /* exit code; nonzero if any problems */
int nfound = 0;                 /* number of strings found */
int nchanged = 0;               /* number of strings changed */

char *thepattern = PATTERN;

#ifndef NOMAIN

/*
 * main program
 */
int main (int argc, char *argv[])
   {
   char *fname, *newstr;

   if ((argc > 1) && (argv[1][0]=='-') && (argv[1][1]=='D')) {
      /* handle -D */
      int i;
      thepattern = malloc(strlen(argv[1])+2);
      strcpy(thepattern, "%");
      strcat(thepattern, argv[1]+2);
      strcat(thepattern, "->");
      fprintf(stderr, "patch pattern set to %s\n", thepattern);
      for (i = 1; i+1 < argc; i++) {
         argv[i] = argv[i+1];
      }
      argv[i] = NULL;
      argc--;
   }

   if (argc < 2 || argc > 3) {
      fprintf(stderr, "usage: %s filename [newstring]\n", argv[0]);
      exit(1);
      }
   fname = argv[1];
   newstr = argv[2];
   if (newstr)
      patchstr(fname, newstr);
   else
      report(fname);
   exit(exitcode);
   /*NOTREACHED*/
   }


/*
 * report (filename) -- report existing string values in a file
 */
void report (char *fname)
   {
   FILE *f;
   long posn;
   int n;
   char buf[MAXLEN+2];

   if (!(f = fopen(fname, ReadBinary))) {       /* open read-only */
      perror(fname);
      exit(1);
      }
   while (findpattern(f)) {             /* find occurrence of magic string */
      nfound++;
      posn = ftell(f);                  /* remember current location */
      n = oldval(f, buf);               /* check available space */
      fseek(f, posn, 0);                /* reposition to beginning of string */
      if (n > MAXLEN) {
         strcpy (buf+40, "...  [unterminated]");
         exitcode = 1;
         }
      printf("at byte %ld:\t%s\n", posn, buf);  /* print value */
      }
   if (nfound == 0) {
      fprintf(stderr, "flag pattern not found\n");
      exitcode = 1;
      }
   }
#endif                                  /* NOMAIN */

/*
 * patchstr (filename, newstring) -- patch a file
 */
void patchstr (char *fname, char *newstr)
   {
   FILE *f;
   long posn;
   int n;
   char buf[MAXLEN+2];

   if (!(f = fopen(fname, ReadEndBinary))) {    /* open for read-and-update */
      perror(fname);
      exit(1);
      }
   while (findpattern(f)) {             /* find occurrence of magic string */
      nfound++;
      posn = ftell(f);                  /* remember current location */
      n = oldval(f, buf);               /* check available space */
      fseek(f, posn, 0);                /* reposition to beginning of string */
      if (n > MAXLEN) {
         fprintf(stderr, "at byte %ld: unterminated string\n", posn);
         exitcode = 1;
         }
      else if (n < (int)strlen(newstr)) {
         fprintf (stderr, "at byte %ld: buffer only holds %d characters\n",
            posn, n);
         exitcode = 1;
         }
      else {
         fputs(newstr, f);              /* rewrite string with new value */
         n -= strlen(newstr);
         while (n-- > 0)
            putc('\0', f);              /* pad out with NUL characters */
         nchanged++;
         fseek(f, 0L, 1);               /* re-enable reading */
         }
      }
   if (nfound == 0) {
      fprintf(stderr, "flag pattern not found\n");
      exitcode = 1;
      }
#ifndef NOMAIN
   else
      fprintf(stderr, "replaced %d occurrence%s\n", nchanged,
         nchanged == 1 ? "" : "s");
#endif                                  /* NOMAIN */
   }

/*
 * findpattern(f) - read until the magic pattern has been matched
 *
 *  Return 1 if successful, 0 if not.
 */
int findpattern(FILE *f)
   {
   int c;
   char *p;

   p = thepattern;                      /* p points to next char we're looking for */
   for (;;) {
      c = getc(f);              /* get next char from file */
      if (c == EOF)
         return 0;              /* if EOF, give up */
      if (c != *p) {
         p = thepattern;                /* if mismatch, start over */
         if (c == *p)           /* (but see if matched pattern start) */
            p++;
         continue;
         }
      if (*++p == '\0')         /* if entire pattern matched */
         return 1;
      }
   }

/*
 * oldval(f, buf) - read old string into buf and return usable length
 *
 *  The "usable" (replaceable) length for rewriting takes null padding into
 *  account up to MAXLEN.  A returned value greater than that indicates an
 *  unterminated string.  The file will need to be repositioned after calling
 *  this function.
 */
int oldval(FILE *f, char buf[MAXLEN+2])
   {
   int n;
   char *e, *p;

   n = fread(buf, 1, MAXLEN+1, f);      /* read up to MAXLEN + null char */
   e = buf + n;                         /* note end of read area */
   n = strlen(buf);                     /* count string length proper */
   for (p = buf + n + 1; p < e && *p == '\0'; p++)
      n++;                              /* count nulls beyond end */
   return n;                            /* return usable length */
   }
