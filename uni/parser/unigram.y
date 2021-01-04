/*
 * NOTE: these %token declarations are generated
 *  automatically by mktoktab from tokens.txt and
 *  op.txt.
 */

/* primitive tokens */

%token  IDENT
%token  INTLIT
%token  REALLIT
%token  STRINGLIT
%token  CSETLIT
%token  EOFX

/* reserved words */

%token  BREAK       /* break     */
%token  BY          /* by        */
%token  CASE        /* case      */
%token  CLASS       /* class     */
%token  CREATE      /* create    */
%token  CRITICAL    /* critical  */
%token  DEFAULT     /* default   */
%token  DO          /* do        */
%token  ELSE        /* else      */
%token  END         /* end       */
%token  EVERY       /* every     */
%token  FAIL        /* fail      */
%token  GLOBAL      /* global    */
%token  IF          /* if        */
%token  IMPORT      /* import    */
%token  iconINITIAL /* initial   */
%token  INITIALLY   /* initially */
%token  INVOCABLE   /* invocable */
%token  LINK        /* link      */
%token  LOCAL       /* local     */
%token  METHOD      /* method    */
%token  NEXT        /* next      */
%token  NOT         /* not       */
%token  OF          /* of        */
%token  PACKAGE     /* package   */
%token  PROCEDURE   /* procedure */
%token  RECORD      /* record    */
%token  REPEAT      /* repeat    */
%token  RETURN      /* return    */
%token  STATIC      /* static    */
%token  SUSPEND     /* suspend   */
%token  THEN        /* then      */
%token  THREAD      /* thread    */
%token  TO          /* to        */
%token  UNTIL       /* until     */
%token  WHILE       /* while     */

/* operators */

%token  BANG        /* !         */
%token  MOD         /* %         */
%token  AUGMOD      /* %:=       */
%token  AND         /* &         */
%token  AUGAND      /* &:=       */
%token  STAR        /* *         */
%token  AUGSTAR     /* *:=       */
%token  INTER       /* **        */
%token  AUGINTER    /* **:=      */
%token  PLUS        /* +         */
%token  AUGPLUS     /* +:=       */
%token  UNION       /* ++        */
%token  AUGUNION    /* ++:=      */
%token  MINUS       /* -         */
%token  AUGMINUS    /* -:=       */
%token  DIFF        /* --        */
%token  AUGDIFF     /* --:=      */
%token  DOT         /* .         */
%token  SLASH       /* /         */
%token  AUGSLASH    /* /:=       */
%token  ASSIGN      /* :=        */
%token  SWAP        /* :=:       */
%token  NMLT        /* <         */
%token  AUGNMLT     /* <:=       */
%token  REVASSIGN   /* <-        */
%token  REVSWAP     /* <->       */
%token  SLT         /* <<        */
%token  AUGSLT      /* <<:=      */
%token  SLE         /* <<=       */
%token  AUGSLE      /* <<=:=     */
%token  NMLE        /* <=        */
%token  AUGNMLE     /* <=:=      */
%token  NMEQ        /* =         */
%token  AUGNMEQ     /* =:=       */
%token  SEQ         /* ==        */
%token  AUGSEQ      /* ==:=      */
%token  EQUIV       /* ===       */
%token  AUGEQUIV    /* ===:=     */
%token  NMGT        /* >         */
%token  AUGNMGT     /* >:=       */
%token  NMGE        /* >=        */
%token  AUGNMGE     /* >=:=      */
%token  SGT         /* >>        */
%token  AUGSGT      /* >>:=      */
%token  SGE         /* >>=       */
%token  AUGSGE      /* >>=:=     */
%token  QMARK       /* ?         */
%token  AUGQMARK    /* ?:=       */
%token  AT          /* @         */
%token  AUGAT       /* @:=       */
%token  BACKSLASH   /* \         */
%token  CARET       /* ^         */
%token  AUGCARET    /* ^:=       */
%token  BAR         /* |         */
%token  CONCAT      /* ||        */
%token  AUGCONCAT   /* ||:=      */
%token  LCONCAT     /* |||       */
%token  AUGLCONCAT  /* |||:=     */
%token  TILDE       /* ~         */
%token  NMNE        /* ~=        */
%token  AUGNMNE     /* ~=:=      */
%token  SNE         /* ~==       */
%token  AUGSNE      /* ~==:=     */
%token  NEQUIV      /* ~===      */
%token  AUGNEQUIV   /* ~===:=    */
%token  LPAREN      /* (         */
%token  RPAREN      /* )         */
%token  PCOLON      /* +:        */
%token  COMMA       /* ,         */
%token  MCOLON      /* -:        */
%token  COLON       /* :         */
%token  COLONCOLON  /* ::        */
%token  SEMICOL     /* ;         */
%token  LBRACK      /* [         */
%token  RBRACK      /* ]         */
%token  LBRACE      /* {         */
%token  RBRACE      /* }         */

%token  DOLLAR      /* $         */
%token  ABSTRACT    /* abstract  */
%token  PMATCH      /*??         */
%token  PAND        /*&&         */
%token  POR         /* .|        */
%token  PUNEVAL     /* ` */
%token  PASSNONMATCH  /* ->      */
%token  PIMDASSN    /* $$        */
%token  PSETCUR     /* .$        */

%token  SND          /* @>       */
%token  SNDBK        /* @>>      */
%token  RCV          /* @<       */
%token  RCVBK        /* @<<      */

%{

#
# Bruce Rennie: 2021-01-03
#
# This is the suggested standardised form to be applicable to both the Unicon
# compiler and the parser library. Every production has the parsing action defined
# as a procedure call which will be defined in the appropriate "unigram.action.icn"
# file local to the particular application files.
#
# For any application needing access to the structure of the Unicon language, the
# parser application can produce a standardised parse tree. For the Unicon compiler,
# there are two different usages for the parse tree that require slightly different
# processing. The first being for the icont compiler (interpreter) and the second
# being for the iconc compiler (c-code compiler).
#
# These differences are handled in the respective "unigram.action", "unigram.prefix"
# and "unigram.suffix" files.
#

link "unigram.prefix"

link "unigram.action"

%}

%%

/*
 * igram.y -- iYacc grammar for Icon
 *
 * This file is the iYacc input for building Icon-based Icon tools.
 *

 * Updated: Bruce Rennie - convert all productions to use a standard semantic
 * procedure, which will be defined in the files
 * Date:    2020-12-28
 *
 * unigram.action.icn
 *
 * with the associated code being found in either of
 *
 * unigram.prefix.icn
 *
 * or
 *
 * unigram.suffix.icn
 *
 * For the standardisation to work across all applications that use this grammar
 * file, every production is required to have its own semantic procedure. This
 * includes all "null" or "epsilon" productions within the grammar as defined. The
 * first part of the name is the "production" name, the second part is the word
 * "action" and the third part is a numeric value indicating which specific
 * procedure is to be called within the yyparser action procedures.
 *
 * At this point, the only "tricky" production difference is found in the production
 * "expr11", which is for the regex processing capabilities now in Unicon.
 *
 * It also means that only one grammar file is required to be used and the specific
 * requirements for each application can be confined to the "action", "prefix"
 * and "suffix"files.
 *
 * This could mean that the specific semantic actions that are required for the
 * iconc compiler can be different to what is required for the Unicon interpreter.
 *
 * At present, the specific differences in semantic actions are localised for the
 * compiler/interpreter and for the parser package.

 */

program : decls EOFX                { $$ := program_action_1($1, $2) }
        ;

decls   :                           { $$ := decls_action_1() }
        | decls decl                { $$ := decls_action_2($1, $2) }
        ;

decl    : record                    { $$ := decl_action_1($1) }
        | proc                      { $$ := decl_action_2($1) }
        | global                    { $$ := decl_action_3($1) }
        | link                      { $$ := decl_action_4($1) }
        | package                   { $$ := decl_action_5($1) }
        | import                    { $$ := decl_action_6($1) }
        | invocable                 { $$ := decl_action_7($1) }
        | cl                        { $$ := decl_action_8($1) }
        ;

initiallysection:                   { $$ := initiallysection_action_1() }
        | INITIALLY SEMICOL locals initial procbody
                                    { $$ := initiallysection_action_2($1, $2, $3, $4, $5) }
        | INITIALLY LPAREN arglist RPAREN SEMICOL locals initial procbody
                                    { $$ := initiallysection_action_3($1, $2, $3, $4, $5, $6, $7, $8) }
        ;

optsemi :                           { $$ := semicolon_action_1() }
        | SEMICOL                   { $$ := semicolon_action_2($1) }
        ;

cl      : classhead optsemi clocals methods optsemi initiallysection END
                                    { $$ := cl_action_1($1, $2, $3, $4, $5, $6, $7) }
        ;

classhead : CLASS IDENT supers LPAREN carglist RPAREN
                                    { $$ := classhead_action_1($1, $2, $3, $4, $5, $6) }
        ;

supers  :                           { $$ := supers_action_1() }
        | COLON IDENT supers        { $$ := supers_action_2($1, $2, $3) }
        | COLON packageref supers   { $$ := supers_action_3($1, $2, $3) }
        ;

packageref : IDENT COLONCOLON IDENT { $$ := packageref_action_1($1, $2, $3) }
        | COLONCOLON IDENT          { $$ := packageref_action_2($1, $2) }
        ;

methods :                           { $$ := methods_action_1() }
        | meth methods              { $$ := methods_action_2($1, $2) }
        | global methods            { $$ := methods_action_3($1, $2) }
        | record methods            { $$ := methods_action_4($1, $2) }
        ;

invocable : INVOCABLE invoclist     { $$ := invocable_action_1($1, $2) }
        ;

invoclist : invocop                 { $$ := invoclist_action_1($1) }
        | invoclist COMMA invocop   { $$ := invoclist_action_2($1, $2, $3) }
        ;

invocop : IDENT                     { $$ := invocop_action_1($1) }
        | STRINGLIT                 { $$ := invocop_action_2($1) }
        | STRINGLIT COLON INTLIT    { $$ := invocop_action_3($1, $2, $3) }
        ;

package : PACKAGE lnkfile           { $$ := package_action_1($1, $2); }
        ;

import  : IMPORT implist            { $$ := import_action_1($1, $2) }
        ;

link    : LINK lnklist              { $$ := link_action_1($1, $2) }
        ;

lnklist : lnkfile                   { $$ := lnklist_action_1($1) }
        | lnklist COMMA lnkfile     { $$ := lnklist_action_2($1, $2, $3) }
        ;

implist : lnkfile                   { $$ := implist_action_1($1) }
        | implist COMMA lnkfile     { $$ := implist_action_2($1, $2, $3) }
        ;

lnkfile : IDENT                     { $$ := lnkfile_action_1($1) }
        | STRINGLIT                 { $$ := lnkfile_action_2($1) }
        ;

global  : GLOBAL idlist             { $$ := global_action_1($1, $2) }
        ;

record  : RECORD IDENT LPAREN fldlist RPAREN
                                    { $$ := record_action_1($1, $2, $3, $4, $5) }
        ;

fldlist :                           { $$ := fldlist_action_1() }
        | idlist                    { $$ := fldlist_action_2($1) }
        ;

proc    : prochead SEMICOL locals initial procbody END
                                    { $$ := proc_action_1($1, $2, $3, $4, $5, $6) }
        ;

meth    : methhead SEMICOL locals initial procbody END
                                    { $$ := meth_action_1($1, $2, $3, $4, $5, $6) }
        | ABSTRACT methhead         { $$ := meth_action_2($1, $2) }
        ;

prochead: PROCEDURE IDENT LPAREN arglist RPAREN
                                    { $$ := prochead_action_1($1, $2, $3, $4, $5) }
        ;

methhead: METHOD IDENT LPAREN arglist RPAREN
                                    { $$ := methhead_action_1($1, $2, $3, $4, $5) }
        ;


arglist :                           { $$ := arglist_action_1() }
        | parmlist                  { $$ := arglist_action_2($1) }
        | parmlist LBRACK RBRACK    { $$ := arglist_action_3($1, $2, $3) }
        ;

carglist:                           { $$ := carglist_action_1() }
        | cparmlist                 { $$ := carglist_action_2($1) }
        | cparmlist LBRACK RBRACK   { $$ := carglist_action_3($1, $2, $3) }
        ;


idlist  : IDENT                     { $$ := idlist_action_1($1) }
        | idlist COMMA IDENT        { $$ := idlist_action_2($1, $2, $3) }
        ;

varlist : IDENT                     { $$ := varlist_action_1($1)}
        | IDENT ASSIGN expr1        { $$ := varlist_action_2($1, $2, $3)}
        | varlist COMMA IDENT       { $$ := varlist_action_3($1, $2, $3)}
        | varlist COMMA IDENT ASSIGN expr1
                                    { $$ := varlist_action_4($1, $2, $3, $4, $5)}
        ;

stalist : IDENT                     { $$ := stalist_action_1($1)}
        | IDENT ASSIGN expr1        { $$ := stalist_action_2($1, $2, $3)}
        | stalist COMMA IDENT       { $$ := stalist_action_3($1, $2, $3)}
        | stalist COMMA IDENT ASSIGN expr1
                                    { $$ := stalist_action_4($1, $2, $3, $4, $5)}
        ;

parmlist: arg                       { $$ := parmlist_action_1($1) }
        | parmlist COMMA arg        { $$ := parmlist_action_2($1, $2, $3) }
        ;

cparmlist: carg                     { $$ := cparmlist_action_1($1) }
        | cparmlist COMMA carg      { $$ := cparmlist_action_2($1, $2, $3) }
        ;

arg     : IDENT                     { $$ := arg_action_1($1) }
        | IDENT COLON IDENT         { $$ := arg_action_2($1, $2, $3) }
        | IDENT COLON literal       { $$ := arg_action_3($1, $2, $3) }
        | IDENT COLON IDENT COLON literal
                                    { $$ := arg_action_4($1, $2, $3, $4, $5)}
        | IDENT COLON AND IDENT     { $$ := arg_action_5($1, $2, $3, $4) }
        | IDENT COLON IDENT COLON AND IDENT
                                    { $$ := arg_action_6($1, $2, $3, $4, $5, $6) }
        | IDENT COLON LBRACK RBRACK { $$ := arg_action_7($1, $2, $3, $4) }
        | IDENT COLON IDENT COLON LBRACK RBRACK
                                    { $$ := arg_action_8($1, $2, $3, $4, $5, $6) }
        ;


carg    : priv arg                  { $$ := carg_action_1($1, $2) }
        ;

priv    :                           { $$ := priv_action_1() }
        | PLUS                      { $$ := priv_action_2($1)}
        | MINUS                     { $$ := priv_action_3($1)}
        ;

clocals :                           { $$ := clocals_action_1() }
        | clocals LOCAL varlist optsemi
                                    { $$ := clocals_action_2($1, $2, $3, $4) }
        ;

locals  :                           { $$ := locals_action_1() }
        | locals LOCAL varlist SEMICOL
                                    { $$ := locals_action_2($1, $2, $3, $4) }
        | locals STATIC stalist SEMICOL
                                    { $$ := locals_action_3($1, $2, $3, $4) }
        ;

initial :                           { $$ := initial_action_1() }
        | iconINITIAL expr SEMICOL  { $$ := initial_action_2($1, $2, $3) }
        ;

procbody:                           { $$ := procbody_action_1() }
        | nexpr SEMICOL procbody    { $$ := procbody_action_2($1, $2, $3) }
        ;

nexpr   :                           { $$ := nexpr_action_1() }
        | expr                      { $$ := nexpr_action_2($1) }
        ;

expr    : expr1a                    { $$ := expr_action_1($1)}
        | expr AND expr1a           { $$ := expr_action_2($1, $2, $3) }
        ;

expr1a  : expr1                     { $$ := expr1a_action_1($1)}
        | expr1a QMARK expr1        { $$ := expr1a_action_2($1, $2, $3) }
        ;

expr1   : expr2a                    { $$ := expr1_action_1($1)}
        | expr2a SWAP expr1         { $$ := expr1_action_2($1, $2, $3) }
        | expr2a ASSIGN expr1       { $$ := expr1_action_3($1, $2, $3) }
        | expr2a REVSWAP expr1      { $$ := expr1_action_4($1, $2, $3) }
        | expr2a REVASSIGN expr1    { $$ := expr1_action_5($1, $2, $3) }
        | expr2a AUGCONCAT expr1    { $$ := expr1_action_6($1, $2, $3) }
        | expr2a AUGLCONCAT expr1   { $$ := expr1_action_7($1, $2, $3) }
        | expr2a AUGDIFF expr1      { $$ := expr1_action_8($1, $2, $3) }
        | expr2a AUGUNION expr1     { $$ := expr1_action_9($1, $2, $3) }
        | expr2a AUGPLUS expr1      { $$ := expr1_action_10($1, $2, $3) }
        | expr2a AUGMINUS expr1     { $$ := expr1_action_11($1, $2, $3) }
        | expr2a AUGSTAR expr1      { $$ := expr1_action_12($1, $2, $3) }
        | expr2a AUGINTER expr1     { $$ := expr1_action_13($1, $2, $3) }
        | expr2a AUGSLASH expr1     { $$ := expr1_action_14($1, $2, $3) }
        | expr2a AUGMOD expr1       { $$ := expr1_action_15($1, $2, $3) }
        | expr2a AUGCARET expr1     { $$ := expr1_action_16($1, $2, $3) }
        | expr2a AUGNMEQ expr1      { $$ := expr1_action_17($1, $2, $3) }
        | expr2a AUGEQUIV expr1     { $$ := expr1_action_18($1, $2, $3) }
        | expr2a AUGNMGE expr1      { $$ := expr1_action_19($1, $2, $3) }
        | expr2a AUGNMGT expr1      { $$ := expr1_action_20($1, $2, $3) }
        | expr2a AUGNMLE expr1      { $$ := expr1_action_21($1, $2, $3) }
        | expr2a AUGNMLT expr1      { $$ := expr1_action_22($1, $2, $3) }
        | expr2a AUGNMNE expr1      { $$ := expr1_action_23($1, $2, $3) }
        | expr2a AUGNEQUIV expr1    { $$ := expr1_action_24($1, $2, $3) }
        | expr2a AUGSEQ expr1       { $$ := expr1_action_25($1, $2, $3) }
        | expr2a AUGSGE expr1       { $$ := expr1_action_26($1, $2, $3) }
        | expr2a AUGSGT expr1       { $$ := expr1_action_27($1, $2, $3) }
        | expr2a AUGSLE expr1       { $$ := expr1_action_28($1, $2, $3) }
        | expr2a AUGSLT expr1       { $$ := expr1_action_29($1, $2, $3) }
        | expr2a AUGSNE expr1       { $$ := expr1_action_30($1, $2, $3) }
        | expr2a AUGQMARK expr1     { $$ := expr1_action_31($1, $2, $3) }
        | expr2a AUGAND expr1       { $$ := expr1_action_32($1, $2, $3) }
        | expr2a AUGAT expr1        { $$ := expr1_action_33($1, $2, $3) }
        ;

expr2a  : expr2                     { $$ := expr2a_action_1($1)}
        | expr2a PMATCH expr2       { $$ := expr2a_action_1($1, $2, $3) }
        ;

expr2   : expr3                     { $$ := expr2_action_1($1)}
        | expr2 TO expr3            { $$ := expr2_action_2($1, $2, $3) }
        | expr2 TO expr3 BY expr3   { $$ := expr2_action_3($1, $2, $3, $4, $5) }
        | expr2 POR expr3           { $$ := expr2_action_4($1, $2, $3) }
        ;

expr3   : expr4                     { $$ := expr3_action_1($1)}
        | expr4 PAND expr3          { $$ := expr3_action_2($1, $2, $3) }
        | expr4 BAR expr3           { $$ := expr3_action_3($1, $2, $3) }
        ;

expr4   : expr5                     { $$ := expr4_action_1($1)}
        | expr4 SEQ expr5           { $$ := expr4_action_2($1, $2, $3) }
        | expr4 SGE expr5           { $$ := expr4_action_3($1, $2, $3) }
        | expr4 SGT expr5           { $$ := expr4_action_4($1, $2, $3) }
        | expr4 SLE expr5           { $$ := expr4_action_5($1, $2, $3) }
        | expr4 SLT expr5           { $$ := expr4_action_6($1, $2, $3) }
        | expr4 SNE expr5           { $$ := expr4_action_7($1, $2, $3) }
        | expr4 NMEQ expr5          { $$ := expr4_action_8($1, $2, $3) }
        | expr4 NMGE expr5          { $$ := expr4_action_9($1, $2, $3) }
        | expr4 NMGT expr5          { $$ := expr4_action_10($1, $2, $3) }
        | expr4 NMLE expr5          { $$ := expr4_action_11($1, $2, $3) }
        | expr4 NMLT expr5          { $$ := expr4_action_12($1, $2, $3) }
        | expr4 NMNE expr5          { $$ := expr4_action_13($1, $2, $3) }
        | expr4 EQUIV expr5         { $$ := expr4_action_14($1, $2, $3) }
        | expr4 NEQUIV expr5        { $$ := expr4_action_15($1, $2, $3) }
        ;

expr5   : expr6                     { $$ := expr5_action_1($1)}
        | expr5 CONCAT expr6        { $$ := expr5_action_2($1, $2, $3) }
        | expr5 LCONCAT expr6       { $$ := expr5_action_3($1, $2, $3) }
        ;

expr6   : expr7                     { $$ := expr6_action_1($1)}
        | expr6 PIMDASSN expr7      { $$ := expr6_action_2($1, $2, $3) }
        | expr6 PASSNONMATCH expr7  { $$ := expr6_action_3($1, $2, $3) }
        | expr6 PLUS expr7          { $$ := expr6_action_4($1, $2, $3) }
        | expr6 DIFF expr7          { $$ := expr6_action_5($1, $2, $3) }
        | expr6 UNION expr7         { $$ := expr6_action_6($1, $2, $3) }
        | expr6 MINUS expr7         { $$ := expr6_action_7($1, $2, $3) }
        ;

expr7   : expr8                     { $$ := expr7_action_1($1)}
        | expr7 STAR expr8          { $$ := expr7_action_2($1, $2, $3) }
        | expr7 INTER expr8         { $$ := expr7_action_3($1, $2, $3) }
        | expr7 SLASH expr8         { $$ := expr7_action_4($1, $2, $3) }
        | expr7 MOD expr8           { $$ := expr7_action_5($1, $2, $3) }
        ;

expr8   : expr9                     { $$ := expr8_action_1($1)}
        | postfixthreadop           { $$ := expr8_action_2($1)}
        | expr9 CARET expr8         { $$ := expr8_action_3($1, $2, $3) }
        ;

postfixthreadop:
          expr9 SND                 { $$ := postfixthreadop_action_1($1, $2) }
        | expr9 SNDBK               { $$ := postfixthreadop_action_1($1, $2) }
        | expr9 RCV                 { $$ := postfixthreadop_action_1($1, $2) }
        | expr9 RCVBK               { $$ := postfixthreadop_action_1($1, $2) }
        ;

expr9   : expr10                    { $$ := expr9_action_1($1)}
        | expr9 BACKSLASH expr10    { $$ := expr9_action_2($1, $2, $3) }
        | expr9 AT expr10           { $$ := expr9_action_3($1, $2, $3) }
        | expr9 SND expr10          { $$ := expr9_action_4($1, $2, $3) }
        | expr9 SNDBK expr10        { $$ := expr9_action_5($1, $2, $3) }
        | expr9 RCV expr10          { $$ := expr9_action_6($1, $2, $3) }
        | expr9 RCVBK expr10        { $$ := expr9_action_7($1, $2, $3) }
        | expr9 BANG expr10         { $$ := expr9_action_8($1, $2, $3) }
        ;

expr10  : expr11                    { $$ := expr10_action_1($1)}
        | AT expr10                 { $$ := expr10_action_2($1, $2) }
        | SND expr10                { $$ := expr10_action_3($1, $2) }
        | SNDBK expr10              { $$ := expr10_action_4($1, $2) }
        | RCV expr10                { $$ := expr10_action_5($1, $2) }
        | RCVBK expr10              { $$ := expr10_action_6($1, $2) }
        | NOT expr10                { $$ := expr10_action_7($1, $2) }
        | BAR expr10                { $$ := expr10_action_8($1, $2) }
        | CONCAT expr10             { $$ := expr10_action_9($1, $2) }
        | LCONCAT expr10            { $$ := expr10_action_10($1, $2) }
        | DOT expr10                { $$ := expr10_action_11($1, $2) }
        | BANG expr10               { $$ := expr10_action_12($1, $2) }
        | DIFF expr10               { $$ := expr10_action_13($1, $2) }
        | PLUS expr10               { $$ := expr10_action_14($1, $2) }
        | STAR expr10               { $$ := expr10_action_15($1, $2) }
        | SLASH expr10              { $$ := expr10_action_16($1, $2) }
        | CARET expr10              { $$ := expr10_action_17($1, $2) }
        | INTER expr10              { $$ := expr10_action_18($1, $2) }
        | TILDE expr10              { $$ := expr10_action_19($1, $2) }
        | MINUS expr10              { $$ := expr10_action_20($1, $2) }
        | NMEQ expr10               { $$ := expr10_action_21($1, $2) }
        | NMNE expr10               { $$ := expr10_action_22($1, $2) }
        | SEQ expr10                { $$ := expr10_action_23($1, $2) }
        | SNE expr10                { $$ := expr10_action_24($1, $2) }
        | EQUIV expr10              { $$ := expr10_action_25($1, $2) }
        | UNION expr10              { $$ := expr10_action_26($1, $2) }
        | QMARK expr10              { $$ := expr10_action_27($1, $2) }
        | NEQUIV expr10             { $$ := expr10_action_28($1, $2) }
        | BACKSLASH expr10          { $$ := expr10_action_29($1, $2) }
        | PSETCUR expr10            { $$ := expr10_action_30($1, $2) }
        ;

expr11  : literal                   { $$ := expr11_action_1($1) }
        | NMLT                      { expr11_action_2a() }
          regex NMGT                { $$ := expr11_action_2b($1, $2, $3, $4) }
        | section                   { $$ := expr11_action_3($1)}
        | return                    { $$ := expr11_action_4($1)}
        | if                        { $$ := expr11_action_5($1)}
        | case                      { $$ := expr11_action_6($1)}
        | while                     { $$ := expr11_action_7($1)}
        | until                     { $$ := expr11_action_8($1)}
        | every                     { $$ := expr11_action_9($1)}
        | repeat                    { $$ := expr11_action_10($1)}
        | SND                       { $$ := expr11_action_11($1) }
        | SNDBK                     { $$ := expr11_action_12($1) }
        | RCV                       { $$ := expr11_action_13($1) }
        | RCVBK                     { $$ := expr11_action_14($1) }
        | PUNEVAL                   { $$ := expr11_action_15($1) }
        | CREATE expr               { $$ := expr11_action_16($1, $2) }
        | THREAD expr               { $$ := expr11_action_17($1, $2) }
        | CRITICAL expr2a COLON expr
                                    { $$ := expr11_action_18($1, $2, $3, $4) }
        | IDENT                     { $$ := expr11_action_19($1) }
        | NEXT                      { $$ := expr11_action_20($1) }
        | BREAK nexpr               { $$ := expr11_action_21($1, $2) }
        | LPAREN exprlist RPAREN    { $$ := expr11_action_22($1, $2, $3) }
        | LBRACE compound RBRACE    { $$ := expr11_action_23($1, $2, $3) }
        | LBRACK caselist RBRACK    { $$ := expr11_action_24($1, $2, $3) }
        | LBRACK exprlist RBRACK    { $$ := expr11_action_25($1, $2, $3) }
        | LBRACK COLON expr COLON RBRACK
                                    { $$ := expr11_action_26($1, $2, $3, $4, $5) }
        | expr11 LBRACK exprlist RBRACK
                                    { $$ := expr11_action_27($1, $2, $3, $4) }
        | expr11 LBRACE RBRACE      { $$ := expr11_action_28($1, $2, $3) } ;
        | expr11 LBRACE pdcolist RBRACE
                                    { $$ := expr11_action_29($1, $2, $3, $4) }
        | expr11 LPAREN exprlist RPAREN
                                    { $$ := expr11_action_30($1, $2, $3, $4) }
        | expr11 DOLLAR INITIALLY LPAREN exprlist RPAREN
                                    { $$ := expr11_action_31($1, $2, $3, $4, $5, $6) }
        | expr11 DOLLAR IDENT LPAREN exprlist RPAREN
                                    { $$ := expr11_action_32($1, $2, $3, $4, $5, $6) }
        | expr11 DOLLAR IDENT DOT INITIALLY LPAREN exprlist RPAREN
                                    { $$ := expr11_action_33($1, $2, $3, $4, $5, $6, $7, $8) }
        | expr11 DOLLAR IDENT DOT IDENT LPAREN exprlist RPAREN
                                    { $$ := expr11_action_34($1, $2, $3, $4, $5, $6, $7, $8) }
        | expr11 DOT IDENT          { $$ := expr11_action_35($1, $2, $3) }
        | packageref                { $$ := expr11_action_36($1) }
        | expr11 DOT INITIALLY      { $$ := expr11_action_37($1, $2, $3) }
        | AND FAIL                  { $$ := expr11_action_38($1, $2) }
        | AND IDENT                 { $$ := expr11_action_39($1, $2) }
        ;

while   : WHILE expr                { $$ := while_action_1($1, $2) }
        | WHILE expr DO expr        { $$ := while_action_2($1, $2, $3, $4) }
        ;

until   : UNTIL expr                { $$ := until_action_1($1, $2) }
        | UNTIL expr DO expr        { $$ := until_action_2($1, $2, $3, $4) }
        ;

every   : EVERY expr                { $$ := every_action_1($1, $2) }
        | EVERY expr DO expr        { $$ := every_action_2($1, $2, $3, $4) }
        ;

repeat  : REPEAT expr               { $$ := repeat_action_1($1, $2) }
        ;

return  : FAIL                      { $$ := return_action_1($1) }
        | RETURN nexpr              { $$ := return_action_2($1, $2) }
        | SUSPEND nexpr             { $$ := return_action_3($1, $2) }
        | SUSPEND expr DO expr      { $$ := return_action_4($1, $2, $3, $4) }
        ;

if      : IF expr THEN expr         { $$ := if_action_1($1, $2, $3, $4) }
        | IF expr THEN expr ELSE expr
                                    { $$ := if_action_2($1, $2, $3, $4, $5, $6) }
        ;

case    : CASE expr OF LBRACE caselist RBRACE
                                    { $$ := case_action_1($1, $2, $3, $4, $5, $6) }
        ;

caselist: cclause                   { $$ := caselist_action_1($1) }
        | caselist SEMICOL cclause  { $$ := caselist_action_2($1, $2, $3) }
        ;

cclause : DEFAULT COLON expr        { $$ := cclause_action_1($1, $2, $3) }
        | expr COLON expr           { $$ := cclause_action_2($1, $2, $3) }
        ;

exprlist: nexpr                     { $$ := exprlist_action_1($1) }
        | exprlist COMMA nexpr      { $$ := exprlist_action_2($1, $2, $3) }
        ;

pdcolist: nexpr                     { $$ := return_action_1($1) }
        | pdcolist COMMA nexpr      { $$ := return_action_2($1, $2, $3) }
        ;

literal : INTLIT                    { $$ := literal_action_1($1) }
        | REALLIT                   { $$ := literal_action_2($1) }
        | STRINGLIT                 { $$ := literal_action_3($1) }
        | CSETLIT                   { $$ := literal_action_4($1) }
        ;

regex: neregex                      { $$ := regex_action_2($1) }
        |                           { $$ := regex_action_1() }
        ;

/* nonempty regexp */
neregex: neregex2a                  { $$ := neregex_action_1($1) }
        | neregex2a BAR neregex     { $$ := neregex_action_2($1, $2, $3) }
        ;

neregex2a: neregex2                 { $$ := neregex2a_action_1($1) }
        | neregex2 neregex2a        { $$ := neregex2a_action_2($1, $2) }
        ;

neregex2: neregex3                  { $$ := neregex2_action_1($1) }
        | neregex2 STAR             { $$ := neregex2_action_2($1, $2) }
        | neregex2 PLUS             { $$ := neregex2_action_3($1, $2) }
        | neregex2 QMARK            { $$ := neregex2_action_4($1, $2) }
        | neregex2 LBRACE INTLIT RBRACE
                                    { $$ := neregex2_action_5($1, $2, $3, $4) }
        ;

neregex3: IDENT                     { $$ := neregex3_action_1($1) }
        | BREAK                     { $$ := neregex3_action_2($1) }
        | BY                        { $$ := neregex3_action_3($1) }
        | PROCEDURE                 { $$ := neregex3_action_4($1) }
        | INTLIT                    { $$ := neregex3_action_5($1) }
        | REALLIT                   { $$ := neregex3_action_6($1) }
        | STRINGLIT                 { $$ := neregex3_action_7($1) }
        | CSETLIT                   { $$ := neregex3_action_8($1) }
        | DOT                       { $$ := neregex3_action_9($1) }
        | LPAREN regex RPAREN       { $$ := neregex3_action_10($1, $2, $3) }
        | LBRACK brackchars RBRACK  { $$ := neregex3_action_11($1, $2, $3) }
        | LBRACK CARET brackchars RBRACK
                                    { $$ := neregex3_action_12($1, $2, $3, $4) }
        | BACKSLASH neregex         { $$ := neregex3_action_13($1, $2) }
        ;

brackchars: brackchars2             { $$ := brackchars_action_1($1) }
        | brackchars MINUS brackchars2
                                    { $$ := brackchars_action_2($1, $2, $3) }
        | brackchars brackchars2    { $$ := brackchars_action_3($1, $2) }
        ;

brackchars2: IDENT                  { $$ := brackchars2_action_1($1) }
        | INTLIT                    { $$ := brackchars2_action_2($1) }
        | REALLIT                   { $$ := brackchars2_action_3($1) }
        | DOT                       { $$ := brackchars2_action_4($1) }
        | BACKSLASH IDENT           { $$ := brackchars2_action_5($1, $2) }
        | BACKSLASH INTLIT          { $$ := brackchars2_action_6($1, $2) }
        ;

section : expr11 LBRACK expr sectop expr RBRACK
                                    { $$ := section_action_1($1, $2, $3, $4, $5, $6) }
        ;

sectop  : COLON                     { $$ := sectop_action_1($1) }
        | PCOLON                    { $$ := sectop_action_2($1) }
        | MCOLON                    { $$ := sectop_action_3($1) }
        ;

compound: nexpr                     { $$ := compound_action_1($1) }
        | nexpr SEMICOL compound    { $$ := compound_action_2($1, $2, $3) }
        ;

program : error decls EOFX          { $$ := program_action_2($1, $2, $3) }
        ;
proc    : prochead error procbody END
                                    { $$ := proc_action_2($1, $2, $3, $4) }
        ;
expr    : error                     { $$ := expr_action_3($1) }
        ;

%%

link "unigram.suffix"
