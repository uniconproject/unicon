/*
 * save(s) -- for systems that support ExecImages
 */

#include "../h/gsupport.h"

#ifdef ExecImages

/*
 * save(s) -- for the Convex.
 */

#ifdef CONVEX
#define TEXT0 0x80001000		/* address of first .text page */
#define DATA0 ((int) &environ & -4096)	/* address of first .data page */
#define START TEXT0			/* start address */

#include <convex/filehdr.h>
#include <convex/opthdr.h>
#include <convex/scnhdr.h>

extern char environ;

wrtexec (ef)
int ef;
{
    struct filehdr filehdr;
    struct opthdr opthdr;
    struct scnhdr texthdr;
    struct scnhdr datahdr;

    int foffs = 0;
    int ooffs = foffs + sizeof filehdr;
    int toffs = ooffs + sizeof opthdr;
    int doffs = toffs + sizeof texthdr;

    int tsize = DATA0 - TEXT0;
    int dsize = (sbrk (0) - DATA0 + 4095) & -4096;

    bzero (&filehdr, sizeof filehdr);
    bzero (&opthdr, sizeof opthdr);
    bzero (&texthdr, sizeof texthdr);
    bzero (&datahdr, sizeof datahdr);
    
    filehdr.h_magic = SOFF_MAGIC;
    filehdr.h_nscns = 2;
    filehdr.h_scnptr = toffs;
    filehdr.h_opthdr = sizeof opthdr;

    opthdr.o_entry = START;
    opthdr.o_flags = OF_EXEC | OF_STRIPPED;

    texthdr.s_vaddr = TEXT0;
    texthdr.s_size = tsize;
    texthdr.s_scnptr = 0x1000;
    texthdr.s_prot = VM_PG_R | VM_PG_E;
    texthdr.s_flags = S_TEXT;

    datahdr.s_vaddr = DATA0;
    datahdr.s_size = dsize;
    datahdr.s_scnptr = 0x1000 + tsize;
    datahdr.s_prot = VM_PG_R | VM_PG_W;
    datahdr.s_flags = S_DATA;

    write (ef, &filehdr, sizeof filehdr);
    write (ef, &opthdr, sizeof opthdr);
    write (ef, &texthdr, sizeof texthdr);
    write (ef, &datahdr, sizeof datahdr);
    lseek (ef, 0x1000, 0);
    write (ef, TEXT0, tsize + dsize);
    close (ef);

    return dsize;
}
#endif					/* CONVEX */

/*
 * save(s) -- for generic BSD systems.
 */

#ifdef GenericBSD
#include <a.out.h>
wrtexec(ef)
int ef;
{
   struct exec hdr;
   extern environ, etext;
   int tsize, dsize;

   /*
    * Construct the header.  The text and data region sizes must be multiples
    *  of 1024.
    */

#ifdef __NetBSD__
   hdr.a_midmag = ZMAGIC;
#else
   hdr.a_magic = ZMAGIC;
#endif

   tsize = (int)&etext;
   hdr.a_text = (tsize + 1024) & ~(1024-1);
   dsize = sbrk(0) - (int)&environ;
   hdr.a_data = (dsize + 1024) & ~(1024-1);
   hdr.a_bss = 0;
   hdr.a_syms = 0;
   hdr.a_entry = 0;
   hdr.a_trsize = 0;
   hdr.a_drsize = 0;

   /*
    * Write the header.
    */
   write(ef, &hdr, sizeof(hdr));

   /*
    * Write the text, starting at N_TXTOFF.
    */
   lseek(ef, N_TXTOFF(hdr), 0);
   write(ef, 0, tsize);
   lseek(ef, hdr.a_text - tsize, 1);

   /*
    * Write the data.
    */
   write(ef, &environ, dsize);
   lseek(ef, hdr.a_data - dsize, 1);
   close(ef);
   return hdr.a_data;
}
#endif					/* GenericBSD */

/*
 * save(s) -- for Sun Workstations.
 */

#ifdef SUN
#include <a.out.h>
wrtexec(ef)
int ef;
{
   struct exec *hdrp, hdr;
   extern environ, etext;
   int tsize, dsize;

   hdrp = (struct exec *)PAGSIZ;
	
   /*
    * This code only handles the ZMAGIC format...
    */
   if (hdrp->a_magic != ZMAGIC)
      syserr("executable is not ZMAGIC format");
   /*
    * Construct the header by copying in the header in core and fixing
    *  up values as necessary.
    */
   hdr = *hdrp;
   tsize = (char *)&etext - (char *)hdrp;
   hdr.a_text = (tsize + PAGSIZ) & ~(PAGSIZ-1);
   dsize = sbrk(0) - (int)&environ;
   hdr.a_data = (dsize + PAGSIZ) & ~(PAGSIZ-1);
   hdr.a_bss = 0;
   hdr.a_syms = 0;
   hdr.a_trsize = 0;
   hdr.a_drsize = 0;

   /*
    * Write the text.
    */
   write(ef, hdrp, tsize);
   lseek(ef, hdr.a_text, 0);

   /*
    * Write the data.
    */
   write(ef, &environ, dsize);
   lseek(ef, hdr.a_data - dsize, 1);

   /*
    * Write the header.
    */
   lseek(ef, 0, 0);
   write(ef, &hdr, sizeof(hdr));

   close(ef);
   return hdr.a_data;
}
#endif					/* SUN */

#else					/* ExecImages */
/* static char junk; */
#endif					/* ExecImages */
