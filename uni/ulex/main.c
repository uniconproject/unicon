/*
 * Katie Ray
 * Project: ulex
 * March 15, 2003
 * main.c
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
FILE *yyin;
char *begintext;
extern int yylineno;

char* grab_upto_percents();
char *yyfilename;
char *outfilename;
FILE *outfile;

int main(int argc, char *argv[])
{
   int i;
   int nextchar, nextchar2;
   char ppcmdline[1024];
   int arg = 1;
   int pp = 1;
   outfilename = "lex.yy.icn";

   if (argc > arg && !strcmp(argv[arg], "-nopp")) {
      pp = 0;
      arg++;
      }

   if (argc > arg && argv[arg][0]=='-' && argv[arg][1]=='o') {
      if (strlen(argv[arg]+2))
	 outfilename = argv[arg]+2;
      else {
	 arg++;
	 outfilename = argv[arg];
	 }
      arg++;
      }

   if (arg >= argc) {
      fprintf(stderr, "usage: ulex [-nopp] [-ooutfile] file\n");
      fflush(stderr);
      exit(-1);
      }

   yyfilename = argv[arg];
   if (pp) {
      sprintf(ppcmdline, "ulpp < %s", yyfilename);
      if (strcmp(ppcmdline+strlen(ppcmdline)-2, ".l"))
	 strcat(ppcmdline, ".l");
      yyin = popen(ppcmdline, "r");
      }
   else {
      yyin = fopen(yyfilename, "r");
      }

   if (yyin == NULL) {
      fprintf(stderr, "Failed to open %s\n", yyfilename);
      fflush(stderr);
      exit(-1);
      }
   else {
#if 0
      printf("ulex: opened %s\n", pp ? ppcmdline : yyfilename);
#endif
      }

   /* process up to first %% */

   if ((nextchar = fgetc(yyin)) == EOF) {
      fprintf(stderr, "Unexpected EOF in %s\n", yyfilename);
      }
   if (nextchar == 10 || nextchar == 13)
      yylineno++;
  
   if ((nextchar2 = fgetc(yyin)) == EOF) {
      fprintf(stderr, "Unexpected EOF in %s\n", yyfilename);
      }
   if(nextchar2 == 10 || nextchar2 == 13)
      yylineno++;

   while(nextchar != '%' || (nextchar2 != '%' && nextchar2 != '{')) {
      /*
       * ignore everything until either %% or %{
       */
      nextchar = nextchar2;
      if ((nextchar2 = fgetc(yyin)) == EOF) {
	 fprintf(stderr, "Unexpected EOF in %s\n", yyfilename);
	 }
      if (nextchar2 == 10 || nextchar2 == 13)
	 yylineno++;
      }

   if (nextchar2 == '{')
      grab_upto_percents();
     
   i = yyparse();

   /*
    * copy out remainder, up to EOF, into output file.
    */

   yyin = fopen("ulex.tmp","r");
   while (((nextchar = fgetc(yyin)) != EOF) && (nextchar != '%'))
      fprintf(outfile, "%c", nextchar);
   if (nextchar == '%') nextchar = fgetc(yyin);
   if (nextchar == '%') nextchar = fgetc(yyin);

   nextchar = fgetc(yyin);
   while(nextchar != EOF) {
      fprintf(outfile, "%c", nextchar);
      if ((nextchar = fgetc(yyin)) == EOF) break;
      }

   fclose(outfile);
   fclose(yyin);
   unlink("ulex.tmp");
   printf("\n");
   return 0;
}

char* grab_upto_percents()
{
   int quotemode = 0, slash = 0, index = 0, size = 20, reset;
   int nextchar, nextchar2;

   begintext = (char *) calloc(size, sizeof(char));
   if (begintext == NULL) {
      fprintf(stderr, "calloc failed in grab_upto_percents\n");
      fflush(stderr);
      exit(-1);
      }

   if ((nextchar = fgetc(yyin)) == EOF) {
      fprintf(stderr, "Unexpected EOF in %s\n", yyfilename);
      }
   if (nextchar == 10 || nextchar == 13)
      yylineno++;

   if ((nextchar2 = fgetc(yyin)) == EOF) {
      fprintf(stderr, "Unexpected EOF in %s\n", yyfilename);
      }
   if (nextchar2 == 10 || nextchar2 == 13)
      yylineno++;

   while (nextchar != '%' || nextchar2 != '}') {
      if (nextchar2 == -1) {
	 fprintf(stderr, "error in processing upto first percents");
	 fflush(stderr);
	 exit(-1);
	 }

      if (nextchar == '"' && slash == 0)
	 quotemode = 1 - quotemode;

      if (nextchar == '\\') slash = 1 - slash;

      if (index >= size-2) {
	 size = size * 2;
	 begintext = realloc(begintext, size * sizeof(char));
	 if (begintext == NULL) {
	    fprintf(stderr, "calloc failed in makebigger\n");
	    fflush(stderr);
	    exit(-1);
	    }
	 }

      begintext[index] = nextchar;
      index++;
      begintext[index] = '\0';

      nextchar = nextchar2;
      if ((nextchar2 = fgetc(yyin)) == EOF) {
	 fprintf(stderr, "Unexpected EOF in %s\n", yyfilename);
	 }
      if (nextchar2 == 10 || nextchar2 == 13)
	 yylineno++;
      }

   while(nextchar != '%' || nextchar2 != '%') {
      nextchar = nextchar2;
      if ((nextchar2 = fgetc(yyin)) == EOF) {
	 fprintf(stderr, "Unexpected EOF in %s\n", yyfilename);
	 }
      if (nextchar2 == 10 || nextchar2 == 13)
	 yylineno++;
      }
   }
