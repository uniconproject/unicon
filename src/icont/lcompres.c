#include "../h/gsupport.h"
#include "../h/version.h"
#include "tproto.h"
#include "tglobals.h"

#if HAVE_LIBZ

#if 0
#include "string.h"
#include <zlib.h>
#include <stdio.h>
#endif

#include "../h/header.h"

#ifdef MAIN
main(int argc, char *argv[]) {
  if (argc!=2) {
    printf("Usage: file_comp filename\n");
    return 1;
  }
  file_comp(argv[1]);
}
#endif

int file_comp(char *filename) {
  gzFile f; 
  FILE *finput;
  FILE *foutput;
  struct header *hdr;
  int n, l, i;
  char *newfname;
  char *buff;  
  char buf[200];
  char *cf;
  int c;
  
  hdr=(struct header *)malloc(sizeof(struct header));
  buff = (char *)malloc(sizeof(char)*20);
  
    
    /* use fopen() to open the target file then read the header and add "z" to the hdr->config. */
    
    if ((finput=fopen(filename,"r"))==NULL) {
      printf("Can't open the file: %s\n",filename);
      return 1;
    }
    
    newfname=(char *)malloc(strlen(filename)+3*sizeof(char));
    strcpy(newfname,filename);
    strcat(newfname,"~z");
    
    if ((foutput=fopen(newfname,"w"))==NULL) {
      printf("Can't open the file: %s\n",newfname);
      return 1;
    }

    for (;;) {
      if (fgets(buf, sizeof buf-1, finput) == NULL)
	printf("Error: Reading Error: Check if the file is executable Icon\n");
      else 
	fputs(buf, foutput);
      if (strncmp(buf, "[executable Icon binary follows]", 32) == 0)
	 break;
    }

    while ((n = getc(finput)) != EOF && n != '\f')	/* read thru \f\n\0 */
      putc(n,foutput);
    putc(n,foutput);
    putc(getc(finput),foutput);
    putc(getc(finput),foutput);

    if (fread((char *)hdr, sizeof(char), sizeof(*hdr), finput) != sizeof(*hdr)) {
      printf("Can't read the header!\n");
      return 1;
    }
    
    cf=(char *)hdr->config;
    printf("Config: %s\n", cf);  /* for test */
    if (strchr(cf, 'Z')==NULL)
      strcat(cf,"Z");
    else {
      printf("The file already has a compressed sign in its header!\n");
      return 0;
    }
    
    
    /* write the modified header into a new file */
    
    fwrite((char *)hdr, sizeof(char), sizeof(*hdr), foutput);
    
    /* close the new file */
  
    fclose(foutput);
    
    /* use gzopen() to open the new file */
    
    if ((f= gzopen(newfname,"a"))==NULL) {
      printf("Error: can not open file!");
      return 1;
    }
    
    
    /* read the rest of the target file and write the compressed data into the new file*/
    
    while((c=fgetc(finput))!=EOF) {
      gzputc(f,c);
      if (ferror(finput)) {
	printf("Error occurs while reading!\n");
	return 1;
      }
    }
   
    /* close both files */
    fclose(finput);
    gzclose(f);
    
  return 0;
}

#endif					/* HAVE_LIBZ */
