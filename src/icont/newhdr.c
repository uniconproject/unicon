/*
 * Intermediate program to convert iconx.hdr into a header file for inclusion
 * in icont.  This eliminates a compile-time file search on UNIX systems.
 * Definition of Header (without ShellHeader) activates the inclusion.
 */

#include "../h/gsupport.h"

/*
 * Prototype
 */

void    putbyte (int b);

#ifdef Header
main(argc, argv)
int argc;
unsigned char *argv[];
   {
   int b, n;

   /*
    * Create an array large enough to hold iconx.hdr (+1 for luck)
    * This array shall be included by link.c (and is nominally called
    * hdr.h)
    */
   printf("static unsigned char iconxhdr[MaxHdr+1] = {\n");

   /*
    * Recreate iconx.hdr as a series of hex constants, padded with zero bytes.
    */

   for (n = 0; (b = getchar()) != EOF; n++)
      putbyte(b);

#ifndef ShellHeader
   /*
    * If header is to be used, make sure it fits.
    */
   if (n > MaxHdr) {
      fprintf(stderr, "%s: file size is %d bytes but MaxHdr is only %d\n",
         argv[0], n, MaxHdr);
      unlink("hdr.h");
      exit(ErrorExit);
      }
#endif                                  /* ShellHeader */

   while (n++ < MaxHdr)
      putbyte(0);

   printf("0x00};\n");                  /* one more, sans comma, and finish */
   exit(EXIT_SUCCESS);
   }

/* putbyte(b) - output byte b as two hex digits */
void putbyte(b)
int b;
   {
   static int n = 0;

   printf("0x%02x,", b & 0xFF);
   if (++n == 16) {
      printf("\n");
      n = 0;
      }
   }

#else                                   /* Header */

main()
   {
   exit(0);
   }

#endif                                  /* Header */
