/*
 * error.h -- routines for producing error messages.
 *
 * This source file contains the routines for issuing error messages.
 * It is built by inclusion in ../icont/tlex.c and ../iconc/clex.c,
 * with slight variations depending on whether "Iconc" is defined.
 */

/*
 * Prototype.
 */

extern int  __merr_errors;
#ifndef SEPARATE_YYERROR
static  char    *mapterm        (int typ,struct node *val);

/*
 * yyerror produces syntax error messages.  tok is the offending token
 *  (yychar), lval is yylval, and state is the parser's state.
 *
 * errtab is searched for the state, if it is found, the associated
 *  message is produced; if the state isn't found, "syntax error"
 *  is produced.
 */
void yyerror(int tok, nodeptr lval, int state)
   {
   register struct errmsg *p;
   int line;
#ifdef ConsoleWindow
   extern int silent;
#endif                                  /* ConsoleWindow */

   if (lval == NULL)
      line = 0;
   else
      line = Line(lval);

#ifdef ConsoleWindow
   if (!silent) {
#endif                                  /* ConsoleWindow */
   if (tok_loc.n_file)
      fprintf(stderr, "File %s; ", tok_loc.n_file);
   if (tok == EOFX)   /* special case end of file */
      fprintf(stderr, "unexpected end of file\n");
   else {
      fprintf(stderr, "Line %d # ", line);
      if (Col(lval))
         fprintf(stderr, "\"%s\": ", mapterm(tok,lval));
      for (p = errtab; p->e_state != state && p->e_state >= 0; p++) ;
      fprintf(stderr, "%s\n", p->e_mesg);
      }
#ifdef ConsoleWindow
      }
   else if (flog != NULL) {
   if (tok_loc.n_file)
      fprintf(flog, "File %s; ", tok_loc.n_file);
   if (tok == EOFX)   /* special case end of file */
      fprintf(flog, "unexpected end of file\n");
   else {
      fprintf(flog, "Line %d # ", line);
      if (Col(lval))
         fprintf(flog, "\"%s\": ", mapterm(tok,lval));
      for (p = errtab; p->e_state != state && p->e_state >= 0; p++) ;
      fprintf(flog, "%s\n", p->e_mesg);
      }
      }
#endif                                  /* ConsoleWindow */
   __merr_errors++;
   nocode++;
   }

/*
 * mapterm finds a printable string for the given token type
 *  and value.
 */
static char *mapterm(int typ, nodeptr val)
   {
   register struct toktab *t;
   register struct optab *ot;
   register int i;

   i = typ;
   if (i == IDENT || i == INTLIT || i == REALLIT || i == STRINGLIT ||
      i == CSETLIT)
         return Str0(val);
   for (t = toktab; t->t_type != 0; t++)
      if (t->t_type == i)
         return t->t_word;
   for (ot = optab; ot->tok.t_type != 0; ot++)
      if (ot->tok.t_type == i)
         return ot->tok.t_word;
   return "???";
   }
#endif                                  /* SEPARATE_YYERROR */

/*
 * tfatal produces the translator error messages s1 and s2 (if nonnull).  The
 *  location of the error is found in tok_loc.
 */
void tfatal(char *s1, char *s2)
   {

#ifdef ConsoleWindow
   extern int silent;

   if (!silent) {
#endif                                  /* ConsoleWindow */

   if (tok_loc.n_file)
      fprintf(stderr, "File %s; ", tok_loc.n_file);
   fprintf(stderr, "Line %d # ", tok_loc.n_line);
   if (s2)
      fprintf(stderr, "\"%s\": ", s2);
   fprintf(stderr, "%s\n", s1);

#ifdef ConsoleWindow
      }
   else if (flog != NULL) {
      if (tok_loc.n_file)
         fprintf(flog, "File %s; ", tok_loc.n_file);
      fprintf(flog, "Line %d # ", tok_loc.n_line);
      if (s2)
         fprintf(flog, "\"%s\": ", s2);
      fprintf(flog, "%s\n", s1);
      }
#endif                                  /* ConsoleWindow */
   __merr_errors++;
   nocode++;
   }

/*
 * nfatal produces the error messages s1 and s2 (if nonnull), and associates
 *  it with source location of node.
 */
void nfatal(nodeptr n, char *s1, char *s2)
   {

   if (n != NULL) {
      fprintf(stderr, "File %s; ", File(n));
      fprintf(stderr, "Line %d # ", Line(n));
      }
   if (s2)
      fprintf(stderr, "\"%s\": ", s2);
   fprintf(stderr, "%s\n", s1);

   __merr_errors++;
   nocode++;
   }


/*
 * twarn produces s1 and s2 (if nonnull) as translator warning messages.
 *  The location of the error is found in tok_loc.
 */
void twarn(char *s1, char *s2)
   {

   if (tok_loc.n_file)
      fprintf(stderr, "File %s; ", tok_loc.n_file);
   fprintf(stderr, "Line %d # ", tok_loc.n_line);
   if (s2)
      fprintf(stderr, "\"%s\": ", s2);
   fprintf(stderr, "%s\n", s1);
#ifdef Iconc
   twarns++;
#endif
   }


/*
 * tsyserr is called for fatal errors.  The message s is produced and the
 *  translator exits.
 */
void tsyserr( char *s)
   {


   if (tok_loc.n_file)
      fprintf(stderr, "File %s; ", tok_loc.n_file);
   fprintf(stderr, "Line %d # %s\n", in_line, s);

   exit(EXIT_FAILURE);
   }

/*
 * quit - immediate exit with error message
 */

void quit(char *msg)
   {
   quitf(msg,"");
   }

/*
 * quitf - immediate exit with message format and argument
 */
void quitf(char *msg, char *arg)
   {
   extern char *progname;
#ifdef ConsoleWindow
   extern int silent;
   if (!silent || flog==NULL) {
#endif
      fprintf(stderr,"%s: ",progname);
      fprintf(stderr,msg,arg);
      fprintf(stderr,"\n");
#ifdef ConsoleWindow
   } else if (flog != NULL) {
      fprintf(flog, "%s: ", progname);
      fprintf(flog, msg, arg);
      fprintf(flog, "\n");
      }
#endif                                  /* ConsoleWindow */

#if !defined(Iconc)
   {
      extern char *ofile;
      if (ofile)
         remove(ofile);                 /* remove bad icode file */
   }
#endif                                  /* !Iconc */

   exit(EXIT_FAILURE);
   }
