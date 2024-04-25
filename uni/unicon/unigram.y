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
%token  POR        /* .|         */
%token  PUNEVAL      /* ` */
%token  PASSNONMATCH  /* -> */
%token  PIMDASSN      /* $$ */
%token  PSETCUR       /* .$ */

%token  SND          /* @>       */
%token  SNDBK        /* @>>      */
%token  RCV          /* @<       */
%token  RCVBK        /* @<<      */

%{

procedure Keyword(x1,x2)
   static keywords
   initial {
      keywords := set(["allocated","clock","collections","column","current",
                       "date","now","dateline","digits","e","error",
                       "errornumber","errortext","errorvalue","errout","fail",
                       "eventcode","eventsource","eventvalue","features",
                       "file","host","input","lcase","letters","level",
                       "line","main","null","output","phi","pi","pick","pos",
                       "progname","random","regions","source","storage",
                       "subject","time","trace","dump","ucase","version",
                       "errno","window","col","row","x","y","interval",
                       "control","shift","meta","lpress","mpress","rpress",
                       "lrelease","mrelease","rrelease","ldrag","mdrag",
                       "rdrag","resize","ascii","cset"])
      }

   # verify that x2 is a valid keyword
   if not member(keywords, x2.s) then
      yyerror("&" || x2.s ||" is not a valid keyword!")

   return node("keyword",x1,x2)
end

global set_of_all_fields, dummyrecno
procedure Field(x1,x2,x3)
initial { set_of_all_fields := set(); dummyrecno := 1 }

   if \iconc then {
      if type(x3) == "token" then {
         insert(set_of_all_fields, x3.s)
#        write(&errout, "field ", image(x3.s))
         }
      }

   return node("field",x1,x2,x3)
end

procedure Clone1stToken(n)
   case type(n) of {
      "token": return copy(n)
      "treenode": {
         return Clone1stToken(!n.children)
         }
      }
end

global outline, outcol, outfilename,package_level_syms,package_level_class_syms

procedure Progend(x1)

   if *\parsingErrors > 0 then {
      every pe := !parsingErrors do {
         write(&errout, pe.errorMessage)
         }
      istop(*\parsingErrors || " error" ||
            (if *\parsingErrors > 1 then "s" else ""))
      }

   if /x1 then istop("error: empty file")

   package_level_syms := set()
   package_level_class_syms := set()
   set_package_level_syms(x1)
   scopecheck_superclass_decs(x1)

   outline := 1
   outcol := 1
   #
   # export specifications for each class
   #
   native := set()
   every cl := classes.foreach_t() do {
      cl.WriteSpec()
      insert(native, cl)
      }
   #
   # import class specifications, transitively
   #
   repeat {
      added := 0
      every super := ((classes.foreach_t()).foreachsuper() | !imports) do {
         if /classes.lookup(super) then {
            added := 1
            readspec(super)
            cl := classes.lookup(super)
            if /cl then halt("can't inherit class '",super,"'")
            iwrite("  inherits ", super, " from ", cl.linkfile)
            writelink(cl.dir, cl.linkfile)
            }
       }
    if added = 0 then break
  }
  #
  # Compute the transitive closure of the superclass graph. Then
  # resolve inheritance for each class, and use it to apply scoping rules.
  #
  every (classes.foreach_t()).transitive_closure()
  every (classes.foreach_t()).resolve()

  scopecheck_bodies(x1)

   if \thePackage then {
      every thePackage.insertsym(!package_level_syms)
      }

  if \iconc then  {
     iconc_prep_parse_tree(&null, x1)
     }

  #
  # generate output
  #
#  iwrite("Generating code:")
   yyprint(x1)
   write(yyout)

$ifndef NoPatternIntegration
   # generate invocable declarations for identifiers in unevaluated exprs
   if (*\list_of_invocables)>0 then {
      writes(yyout, "invocable ")
      every temp := list_of_invocables[i := 1 to *list_of_invocables] do {
         writes(yyout, image(temp))
         if i < *list_of_invocables then writes(yyout, ",")
         }
      write(yyout)
      }
$endif                                  # NoPatternIntegration

   if \iconc & (type(set_of_all_fields) == "set") &
        (*set_of_all_fields > 0) then {
        arandomfield := !set_of_all_fields
      writes(yyout, "record __dummyrecord",dummyrecno,"(",arandomfield)
      delete(set_of_all_fields, arandomfield)
      every writes(yyout, ",", !set_of_all_fields)
      write(yyout, ")")
      dummyrecno +:= 1
      set_of_all_fields := set()
      }
end
%}

%%

/*
 * igram.y -- iYacc grammar for Icon
 *
 * This file is the iYacc input for building Icon-based Icon tools.
 */

program : decls EOFX { Progend($1) } ;

decls   : { $$ := &null } ;
        | decls decl {
             if /parsingErrors | *parsingErrors = 0 then iwrites(&errout,".")
             $$ := node("decls", $1, $2)
             } ;

decl    : record
        | proc
        | global
        | link
        | package
        | import
        | invocable
        | cl
        ;

initiallysection: { $$ := &null }
        | INITIALLY SEMICOL locals initial procbody {
           $$ := Method( , , , , , $1, "initially", &null, "method", "(", ")")
           $$.locals := $3
           $$.initl := $4
           $$.procbody := $5
        }
        | INITIALLY LPAREN arglist RPAREN SEMICOL locals initial procbody {
           $$ := Method( , , , , , $1, "initially", $3, "method", "(", ")")
           $$.locals := $6
           $$.initl := $7
           $$.procbody := $8
        }
        ;

optsemi : { $$ := &null } ;
        | SEMICOL;

cl: classhead optsemi clocals methods optsemi initiallysection END {
    $$ := class_from_parts($1, $3, $4, $6)
   } ;

classhead : CLASS IDENT supers LPAREN carglist RPAREN {
   $$ := Class()
   $$.tag := $1
   $$.unmangled_name := $2.s
   $$.name := package_mangled_symbol($2.s)
   if proc($$.name, 0) then
      warning("Warning: class "|| $$.name ||" overrides the built-in function")
   if \ (foobar := classes.lookup($$.name)) then {
      yyerror("redeclaration of class " || $$.name)
      }
   else
      classes.insert($$, $$.name)

   $$.supers_node := $3
   $$.fields := $5
   $$.lptoken := $4
   $$.rptoken := $6
   } ;

supers: { $$ := &null } ;
   | COLON IDENT supers { $$ := node("supers", $1, $2, $3) }
   | COLON packageref supers { $$ := node("supers", $1, $2, $3) }
   ;

packageref : IDENT COLONCOLON IDENT { $$ := node("packageref", $1,$2,$3) }
   | COLONCOLON IDENT { $$ := node("packageref", $1,$2) }
   ;

methods: { $$ := &null } ;
   | meth methods { $$ := node("methods", $1,$2) }
   | global methods { $$ := node("methods", $1,$2) }
   | record methods { $$ := node("methods", $1,$2) }
   ;

invocable : INVOCABLE invoclist { $$ := node("invocable", $1, $2) } ;

invoclist : invocop;
          | invoclist COMMA invocop { $$ := node("invoclist", $1,$2,$3) } ;

invocop  : IDENT ;
         | STRINGLIT ;
         | STRINGLIT COLON INTLIT {$$ := node("invocop3", $1,$2,$3) } ;

package  : PACKAGE lnkfile {
   if \thePackage then {
      if not (thePackage.name == $2.s) then {
         yyerror(yyfilename || " cannot be in both package "|| thePackage.name ||
            " and package " || $2.s)
         $$ := &null
         }
      else { # this branch allowed for -C / iconc
         thePackage.insertfname(yyfilename)
         thePackage.add_imported()
         }
      }
   else {
      $$ := node("package", $1,$2);
      thePackage := Package($2.s)
      thePackage.insertfname(yyfilename)
      thePackage.add_imported()
      }
   } ;

import: IMPORT implist {
   $$ := node("import", $1,$2," ")
   import_class($2)
   } ;

link    : LINK lnklist { $$ := node("link", $1,$2," ") } ;

lnklist : lnkfile ;
        | lnklist COMMA lnkfile { $$ := node("lnklist", $1,$2,$3) } ;

implist : lnkfile ;
        | implist COMMA lnkfile { $$ := node("implist", $1,$2,$3) } ;

lnkfile : IDENT ;
        | STRINGLIT ;

global  : GLOBAL idlist { $$ := node("global", $1,$2) } ;

record  : RECORD IDENT LPAREN fldlist RPAREN {
                $$ := declaration($2,$4,$1,$3,$5)
                if \iconc then
                   ca_add_proc(yyfilename, $2.s)
                } ;

fldlist : { $$ := &null } ;
        | idlist ;

proc    : prochead SEMICOL locals initial procbody END {
#               body_scopeck($5)
                $3 := AppendListCompTemps($3, $5)
                $$ := node("proc", $1,";",$3,$4,$5,$6)
                } ;

meth    : methhead SEMICOL locals initial procbody END {
                $$ := $1
                $$.locals := $3
                $$.initl := $4
                $$.procbody := $5
                }
        | ABSTRACT methhead {
                $$ := $2
                $$.abstract_flag := 1
                } ;

prochead: PROCEDURE IDENT LPAREN arglist RPAREN {
                $$ := declaration($2, $4, $1, $3, $5)
                if \iconc then
                   ca_add_proc(yyfilename, $2.s)
                } ;

methhead: METHOD IDENT LPAREN arglist RPAREN {
                $$ := Method( , , , , , $1, $2.s, $4, $1.s, $3, $5)
                } ;


arglist : { $$ := argList( , , &null) } ;
        | parmlist { $$ := argList( , , $1) } ;
        | parmlist LBRACK RBRACK { $$ := argList("[]" , , $1) } ;

carglist: { $$ := argList( , , &null) } ;
        | cparmlist { $$ := argList( , , $1) } ;
        | cparmlist LBRACK RBRACK { $$ := argList("[]" , , $1) } ;


idlist  : IDENT ;
        | idlist COMMA IDENT { $$ := node("idlist", $1,$2,$3) } ;

varlist : IDENT ;
        | IDENT ASSIGN expr1 { $$ := node("varlist2", $1, $2, $3)}
        | varlist COMMA IDENT { $$ := node("varlist3", $1, $2, $3)}
        | varlist COMMA IDENT ASSIGN expr1 { $$ := node("varlist4",$1,$2,$3,$4,$5)};

stalist : IDENT ;
        | IDENT ASSIGN expr1 { $$ := node("stalist2", $1, $2, $3)}
        | stalist COMMA IDENT { $$ := node("stalist3", $1, $2, $3)}
        | stalist COMMA IDENT ASSIGN expr1 { $$ := node("stalist4",$1,$2,$3,$4,$5)};

parmlist: arg ;
        | parmlist COMMA arg { $$ := node("parmlist", $1,$2,$3) } ;

cparmlist: carg ;
        | cparmlist COMMA carg { $$ := node("parmlist", $1,$2,$3) } ;

arg     : IDENT ;
        | IDENT COLON IDENT { $$ := node("arg2", $1, $2, $3) } ;
        | IDENT COLON literal { $$ := node("arg3", $1, $2, $3) } ;
        | IDENT COLON IDENT COLON literal { $$ := node("arg4", $1,$2,$3,$4,$5)};
        | IDENT COLON AND IDENT { $$ := node("arg5", $1, $2, Keyword($3, $4)) };
        | IDENT COLON IDENT COLON AND IDENT { $$ := node("arg6", $1, $2, $3, $4, Keyword($5, $6)) } ;
        | IDENT COLON LBRACK RBRACK { $$ := node("arg7", $1, $2, "[]") } ;
        | IDENT COLON IDENT COLON LBRACK RBRACK { $$ := node("arg8", $1, $2, $3, $4, "[]") } ;


carg    : priv arg { $$ := $2 };

priv: { $$ := &null } ;
        | PLUS  ;
        | MINUS ;

clocals : { $$ := &null } ;
        | clocals LOCAL varlist optsemi { $$ := node("locals2", $1,$2,$3,";") } ;

locals  : { $$ := &null } ;
        | locals LOCAL varlist SEMICOL { $$ := node("locals2", $1,$2,$3,";") } ;
        | locals STATIC stalist SEMICOL { $$ := node("locals3", $1,$2,$3,";") } ;

initial : { $$ := &null } ;
        | iconINITIAL expr SEMICOL {
           $$ := node("initial", $1, $2,";")
              } ;

procbody: { $$ := &null } ;
        | nexpr SEMICOL procbody { $$ := node("procbody", $1,";",$3) } ;

nexpr   : { $$ := &null } ;
        | expr ;

expr    : expr1a ;
        | expr AND expr1a       { $$ := node("and", $1,$2,$3) } ;

expr1a  : expr1 ;
        | expr1a QMARK expr1    { $$ := node("binques", $1,$2,$3) } ;

expr1   : expr2a ;
        | expr2a SWAP expr1      { $$ := node("swap", $1,$2,$3) } ;
        | expr2a ASSIGN expr1    {
          $$ := parenthesize_assign(node("assign",$1,$2,$3))
          } ;
        | expr2a REVSWAP expr1   { $$ := node("revswap", $1,$2,$3) } ;
        | expr2a REVASSIGN expr1 { $$ := node("revasgn", $1,$2,$3) } ;
        | expr2a AUGCONCAT expr1 { $$ := node("augcat", $1,$2,$3) } ;
        | expr2a AUGLCONCAT expr1 { $$ := node("auglcat", $1,$2,$3) } ;
        | expr2a AUGDIFF expr1   { $$ := node("Bdiffa", $1,$2,$3) } ;
        | expr2a AUGUNION expr1  { $$ := node("Buniona", $1,$2,$3) } ;
        | expr2a AUGPLUS expr1   { $$ := node("Bplusa", $1,$2,$3) } ;
        | expr2a AUGMINUS expr1  { $$ := node("Bminusa", $1,$2,$3) } ;
        | expr2a AUGSTAR expr1   { $$ := node("Bstara", $1,$2,$3) } ;
        | expr2a AUGINTER expr1  { $$ := node("Bintera", $1,$2,$3) } ;
        | expr2a AUGSLASH expr1  { $$ := node("Bslasha", $1,$2,$3) } ;
        | expr2a AUGMOD expr1    { $$ := node("Bmoda", $1,$2,$3) } ;
        | expr2a AUGCARET expr1  { $$ := node("Bcareta", $1,$2,$3) } ;
        | expr2a AUGNMEQ expr1   { $$ := node("Baugeq", $1,$2,$3) } ;
        | expr2a AUGEQUIV expr1  { $$ := node("Baugeqv", $1,$2,$3) } ;
        | expr2a AUGNMGE expr1   { $$ := node("Baugge", $1,$2,$3) } ;
        | expr2a AUGNMGT expr1   { $$ := node("Bauggt", $1,$2,$3) } ;
        | expr2a AUGNMLE expr1   { $$ := node("Baugle", $1,$2,$3) } ;
        | expr2a AUGNMLT expr1   { $$ := node("Bauglt", $1,$2,$3) } ;
        | expr2a AUGNMNE expr1   { $$ := node("Baugne", $1,$2,$3) } ;
        | expr2a AUGNEQUIV expr1 { $$ := node("Baugneqv", $1,$2,$3) } ;
        | expr2a AUGSEQ expr1    { $$ := node("Baugseq", $1,$2,$3) } ;
        | expr2a AUGSGE expr1    { $$ := node("Baugsge", $1,$2,$3) } ;
        | expr2a AUGSGT expr1    { $$ := node("Baugsgt", $1,$2,$3) } ;
        | expr2a AUGSLE expr1    { $$ := node("Baugsle", $1,$2,$3) } ;
        | expr2a AUGSLT expr1    { $$ := node("Baugslt", $1,$2,$3) } ;
        | expr2a AUGSNE expr1    { $$ := node("Baugsne", $1,$2,$3) } ;
        | expr2a AUGQMARK expr1  { $$ := node("Baugques", $1,$2,$3) } ;
        | expr2a AUGAND expr1    { $$ := node("Baugamper", $1,$2,$3) } ;
        | expr2a AUGAT expr1     { $$ := node("Baugact", $1,$2,$3) } ;

expr2a  : expr2;
        | expr2a PMATCH expr2   { $$ := node("BPmatch", $1,$2,$3) } ;

expr2   : expr3 ;
        | expr2 TO expr3 { $$ := node("to", $1,$2,$3) } ;
        | expr2 TO expr3 BY expr3 { $$ := node("toby", $1,$2,$3,$4,$5) } ;
        | expr2 POR expr3 { $$ := node("BPor", $1,$2,$3) };

expr3   : expr4 ;
        | expr4 PAND expr3 { $$ := node("BPand", $1,$2,$3) };
        | expr4 BAR expr3  { $$ := node(BAR, $1,$2,$3) } ;

expr4   : expr5;
        | expr4 SEQ expr5 { $$ := node("Bseq", $1,$2,$3) } ;
        | expr4 SGE expr5 { $$ := node("Bsge", $1,$2,$3) } ;
        | expr4 SGT expr5 { $$ := node("Bsgt", $1,$2,$3) } ;
        | expr4 SLE expr5 { $$ := node("Bsle", $1,$2,$3) } ;
        | expr4 SLT expr5 { $$ := node("Bslt", $1,$2,$3) } ;
        | expr4 SNE expr5 { $$ := node("Bsne", $1,$2,$3) } ;
        | expr4 NMEQ expr5 { $$ := node("Beq", $1,$2,$3) } ;
        | expr4 NMGE expr5 { $$ := node("Bge", $1,$2,$3) } ;
        | expr4 NMGT expr5 { $$ := node("Bgt", $1,$2,$3) } ;
        | expr4 NMLE expr5 { $$ := node("Ble", $1,$2,$3) } ;
        | expr4 NMLT expr5 { $$ := node("Blt", $1,$2,$3) } ;
        | expr4 NMNE expr5 { $$ := node("Bne", $1,$2,$3) } ;
        | expr4 EQUIV expr5 { $$ := node("Beqv", $1,$2,$3) } ;
        | expr4 NEQUIV expr5 { $$ := node("Bneqv", $1,$2,$3) } ;

expr5   : expr6 ;
        | expr5 CONCAT expr6 { $$ := node("Bcat", $1,$2,$3) } ;
        | expr5 LCONCAT expr6 { $$ := node("Blcat", $1,$2,$3) } ;

expr6   : expr7 ;
        | expr6 PIMDASSN expr7 { $$ := node("BPiam", $1,$2,$3) } ;
        | expr6 PASSNONMATCH expr7 { $$ := node("BPaom", $1,$2,$3) } ;
        | expr6 PLUS expr7 { $$ := node("Bplus", $1,$2,$3) } ;
        | expr6 DIFF expr7 { $$ := node("Bdiff", $1,$2,$3) } ;
        | expr6 UNION expr7 { $$ := node("Bunion", $1,$2,$3) } ;
        | expr6 MINUS expr7 { $$ := node("Bminus", $1,$2,$3) } ;

expr7   : expr8 ;
        | expr7 STAR expr8 { $$ := node("Bstar", $1,$2,$3) } ;
        | expr7 INTER expr8 { $$ := node("Binter", $1,$2,$3) } ;
        | expr7 SLASH expr8 { $$ := node("Bslash", $1,$2,$3) } ;
        | expr7 MOD expr8 { $$ := node("Bmod", $1,$2,$3) } ;

expr8   : expr9 ;
        | postfixthreadop ;
        | expr9 CARET expr8 { $$ := node("Bcaret", $1,$2,$3) } ;

postfixthreadop:
          expr9 SND { $$ := node("Bsnd", $1,$2,&null) } ;
        | expr9 SNDBK { $$ := node("Bsndbk", $1,$2,&null) } ;
        | expr9 RCV { $$ := node("Brcv", $1,$2,&null) } ;
        | expr9 RCVBK { $$ := node("Brcvbk", $1,$2,&null) } ;

expr9   : expr10 ;
        | expr9 BACKSLASH expr10 { $$ := node("limit", $1,$2,$3) } ;
        | expr9 AT expr10 { $$ := node("at", $1,$2,$3) } ;
        | expr9 SND expr10 { $$ := node("Bsnd", $1,$2,$3) } ;
        | expr9 SNDBK expr10 { $$ := node("Bsndbk", $1,$2,$3) } ;
        | expr9 RCV expr10 { $$ := node("Brcv", $1,$2,$3) } ;
        | expr9 RCVBK expr10 { $$ := node("Brcvbk", $1,$2,$3) } ;
        | expr9 BANG expr10 { $$ := node("apply", $1,$2,$3) };

expr10  : expr11 ;
        | AT expr10 { $$ := node("uat", $1,$2) } ;
        | SND expr10 { $$ := node("Bsnd", &null,$1,$2) } ;
        | SNDBK expr10 { $$ := node("Bsndbk", &null,$1,$2) } ;
        | RCV expr10 { $$ := node("Brcv", &null,$1,$2) } ;
        | RCVBK expr10 { $$ := node("Brcvbk", &null,$1,$2) } ;
        | NOT expr10 { $$ := node("unot", $1,$2) } ;
        | BAR expr10 { $$ := node("ubar", $1,$2) } ;
        | CONCAT expr10 { $$ := node("uconcat", $1,$2) } ;
        | LCONCAT expr10 { $$ := node("ulconcat", $1,$2) } ;
        | DOT expr10 { $$ := node("udot", $1,$2) } ;
        | BANG expr10 { $$ := node("ubang", $1,$2) } ;
        | DIFF expr10 { $$ := node("udiff", $1,$2) } ;
        | PLUS expr10 { $$ := node("uplus", $1,$2) } ;
        | STAR expr10 { $$ := node("ustar", $1,$2) } ;
        | SLASH expr10 { $$ := node("uslash", $1,$2) } ;
        | CARET expr10 { $$ := node("ucaret", $1,$2) } ;
        | INTER expr10 { $$ := node("uinter", $1,$2) } ;
        | TILDE expr10 { $$ := node("utilde", $1,$2) } ;
        | MINUS expr10 { $$ := node("uminus", $1,$2) } ;
        | NMEQ expr10 { $$ := node("unumeq", $1,$2) } ;
        | NMNE expr10 { $$ := node("unumne", $1,$2) } ;
        | SEQ expr10 { $$ := node("ulexeq", $1,$2) } ;
        | SNE expr10 { $$ := node("ulexne", $1,$2) } ;
        | EQUIV expr10 { $$ := node("uequiv", $1,$2) } ;
        | UNION expr10 { $$ := node("uunion", $1,$2) } ;
        | QMARK expr10 { $$ := node("uqmark", $1,$2) } ;
        | NEQUIV expr10 { $$ := node("unotequiv", $1,$2) } ;
        | BACKSLASH expr10 { $$ := node("ubackslash", $1,$2) } ;
        | PSETCUR expr10 { $$ := node("upsetcur", $1,$2) } ;

expr11  : literal ;
        | NMLT { next_gt_is_ender := 1 } regex NMGT { $$ := node("regex", $3) }
        | section ;
        | return ;
        | if ;
        | case ;
        | while ;
        | until ;
        | every ;
        | repeat ;
        | SND { $$ := node("Bsnd", &null,$1,&null) } ;
        | SNDBK { $$ := node("Bsndbk", &null,$1,&null) } ;
        | RCV { $$ := node("Brcv", &null,$1,&null) } ;
        | RCVBK { $$ := node("Brcvbk", &null,$1,&null) } ;
        | PUNEVAL { $$ := node("BPuneval", $1) } ;
        | CREATE expr { $$ := node("create", $1,$2) } ;
        | THREAD expr {
              fakeThreadIdent := Clone1stToken($1)
              fakeThreadIdent.tok := IDENT
              fakeCreate := Clone1stToken($1)
              fakeCreate.tok := CREATE
              fakeCreate.s := "create"
              fakeThreadIdent.s := "spawn"
              fakeLParen := Clone1stToken($1)
              fakeLParen.tok := LPAREN
              fakeLParen.s := "("
              fakeRParen := Clone1stToken($1)
              fakeRParen.tok := RPAREN
              fakeRParen.s := ")"

              $$ := SimpleInvocation(fakeThreadIdent,fakeLParen,
                                     node("create", fakeCreate, $2),
                                     fakeRParen)
              } ;
        | CRITICAL expr2a COLON expr { $$ := node("critical", $1,$2,$3,$4) } ;
        | IDENT ;
        | NEXT { $$ := node("Next", $1) } ;
        | BREAK nexpr { $$ := node("Break", $1,$2) } ;
        | LPAREN exprlist RPAREN { $$ := node("Paren", $1,$2,$3) } ;
        | LBRACE compound RBRACE { $$ := node("Brace", $1,$2,$3) } ;
        | LBRACK caselist RBRACK { $$ := tablelit($1,$2,$3) } ;
        | LBRACK exprlist RBRACK { $$ := node("Brack", $1,$2,$3) } ;
        | LBRACK COLON expr COLON RBRACK { $$ := ListComp($3) } ;
        | expr11 LBRACK exprlist RBRACK { $$ := node("Subscript", $1,$2,$3,$4) } ;
        | expr11 LBRACE RBRACE { $$ := node("Pdco0", $1,$2,$3) } ;
        | expr11 LBRACE pdcolist RBRACE { $$ := node("Pdco1", $1,$2,$3,$4) } ;
        | expr11 LPAREN exprlist RPAREN {
           $$ := SimpleInvocation($1,$2,$3,$4)
      } ;
        | expr11 DOLLAR INITIALLY LPAREN exprlist RPAREN {
           $$ := InvocationNode($1,$2,$3,$4,$5,$6)
           } ;
        | expr11 DOLLAR IDENT LPAREN exprlist RPAREN {
           $$ := InvocationNode($1,$2,$3,$4,$5,$6)
           } ;
        | expr11 DOLLAR IDENT DOT INITIALLY LPAREN exprlist RPAREN {
           $$ := InvocationNode($1,$2,$3,$4,$5,$6,$7,$8)
           } ;
        | expr11 DOLLAR IDENT DOT IDENT LPAREN exprlist RPAREN {
           $$ := InvocationNode($1,$2,$3,$4,$5,$6,$7,$8)
           } ;
        | expr11 DOT IDENT {
           $$ := FieldRef($1,$2,$3)
      } ;
        | packageref;
        | expr11 DOT INITIALLY { $$ := Field($1,$2,$3) } ;
        | AND FAIL { $$ := node("keyword",$1,$2) } ;
        | AND IDENT { $$ := Keyword($1,$2) } ;

while   : WHILE expr {
            $$ := node("While0", $1,$2)
            } ;
        | WHILE expr DO expr {
            # warn if a while loop should be an every.
            # should generalize; compute a semantic attribute and
            # warn if a while loop control expression is a generator.
            # but for now, only complain about the most obvious case
            if type($2) == "treenode" & $2.label === "assign" &
               *$2.children = 3 & type($2.children[3]) == "treenode" &
               $2.children[3].label == "to" & *($2.children[3].children)=3 &
                     (type($2.children[3].children[1]) ===
                      type($2.children[3].children[3]) === "token") &
                     ($2.children[3].children[1].tok =
                      $2.children[3].children[3].tok = INTLIT) &
                     $2.children[3].children[1].s<=$2.children[3].children[3].s
            then {
                warning("infinite loop; use \"every\" to loop on generator results",
                        $1.line, $1.filename, $1.s
                        )
               }
            $$ := node("While1", $1,$2,$3,$4)
            } ;

until   : UNTIL expr { $$ := node("until", $1,$2) } ;
        | UNTIL expr DO expr { $$ := node("until1", $1,$2,$3,$4) } ;

every   : EVERY expr { $$ := node("every", $1,$2) } ;
        | EVERY expr DO expr { $$ := node("every1", $1,$2,$3,$4) } ;

repeat  : REPEAT expr { $$ := node("repeat", $1,$2) } ;

return  : FAIL ;
        | RETURN nexpr { $$ := node("return", $1, $2) } ;
        | SUSPEND nexpr { $$ := node("Suspend0", $1,$2) } ;
        | SUSPEND expr DO expr { $$ := node("Suspend1", $1,$2,$3,$4) };

if      : IF expr THEN expr { $$ := node("If0", $1,$2,$3,$4) } ;
        | IF expr THEN expr ELSE expr { $$ := node("If1", $1,$2,$3,$4,$5,$6) } ;

case    : CASE expr OF LBRACE caselist RBRACE { $$ := node("Case", $1,$2,$3,$4,$5,$6) } ;

caselist: cclause ;
        | caselist SEMICOL cclause { $$ := node("Caselist", $1,";",$3) } ;

cclause : DEFAULT COLON expr { $$ := node("cclause0", $1,$2,$3) } ;
        | expr COLON expr { $$ := node("cclause1", $1,$2,$3) } ;

exprlist: nexpr ;
        | exprlist COMMA nexpr {
           if type($1)=="treenode" & ($1.label=="elst1") then {
              $$ := $1; put($$.children, $2, $3)
              }
           else
              $$ := node("elst1", $1,$2,$3)
           } ;

pdcolist: nexpr { $$ := node("pdcolist0", $1) } ;
        | pdcolist COMMA nexpr { $$ := node("pdcolist1", $1,$2,$3) } ;

literal : INTLIT ;
        | REALLIT ;
        | STRINGLIT ;
        | CSETLIT ;

regex: neregex { $$ := regexp($1) }
        |  { $$ := "emptyregex" }
        ;

/* nonempty regexp */
neregex: neregex2a
        | neregex2a BAR neregex { $$ := node("regexbar", $1, $2, $3) }
        ;

neregex2a: neregex2
        | neregex2 neregex2a { $$ := node("regexconcat", $1, $2) }
        ;

neregex2: neregex3 ;
        | neregex2 STAR { $$ := node("kleene", $1, $2) }
        | neregex2 PLUS { $$ := node("oneormore", $1, $2) }
        | neregex2 QMARK { $$ := node("optional", $1, $2) }
        | neregex2 LBRACE INTLIT RBRACE {
           if $3.s < 0 then {
              yyerror("regex occurrences may not be negative")
              $$ := node("error")
              }
           else if $3.s = 0 then {
              yyerror("regex occurrences may not be zero yet")
              $$ := node("error")
              }
           else if $3.s = 1 then $$ := $1
           else { # normal case, positive number of repeats of $1
              $$ := $1
              every i := 2 to $3.s do {
                 $$ := node("regexconcat", $$, $1)
                 }
              }
           }
        ;

neregex3:  IDENT
        | BREAK { $$ := $1; $$.tok := IDENT }
        | BY { $$ := $1; $$.tok := IDENT }
        | PROCEDURE { $$ := $1; $$.tok := IDENT }
        | INTLIT
        | REALLIT
        | STRINGLIT
        | CSETLIT
        | DOT
        | LPAREN regex RPAREN { $$ := node("Paren",$1,$2,$3) }
        | LBRACK brackchars RBRACK {
              $$ := node("acset", $1, $2, $3)
              if type($2) == "token" then {
                 if not (($1.line == $2.line) &
                         ($1.column + 1 == $2.column)) then {
                    # [ is nonadjacent, add space
                    $2.s := " " || $2.s
                    }
                 }
                 else { /* write("[ followed by ", type($2), " so not checking for space") */}
              }
        | LBRACK CARET brackchars RBRACK { $$ := node("notany", $1, $2, $3, $4) }
        | BACKSLASH neregex { $$ := node("escape", $1, $2) }
        ;

brackchars: brackchars2
        | brackchars MINUS brackchars2 { $$ := node("brackchars", $1, $2, $3) }
        | brackchars brackchars2 {
           if type($1) == "treenode" then {
             c1 := csetify($1)
             }
           if type($2) == "treenode" then c2 := csetify($2)

           $$ := copy($1)
           while type($$) == "treenode" do {
              $$ := copy($$.children[1])
              $$.s := c1
              }
           if type($$) ~== "token" then stop("regex type ", image($$))

           if type($2) == "treenode" then $$.s ||:= c2
           else $$.s ||:= $2.s
           }
        ;

brackchars2: IDENT | INTLIT | REALLIT | DOT
        | BACKSLASH IDENT { # ordinary escape char
           $$ := $2
           $$.column := $1.column
           case $$.s[1] of {
              "b"|"d"|"e"|"f"|"l"|"n"|"r"|"t"|"v": $$.s[1] := "\\" || $$.s[1]
              default: stop("unrecognized escape char \\", $$.s[1])
              }
        }
        | BACKSLASH INTLIT { #escaped octal?
           $$ := $2
           $$.column := $1.column
           case $$.s[1] of {
              "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7": $$.s[1] := "\\" || $$.s[1]
              default: stop("non-octal numeric escape char \\", $$.s[1])
              }
           }
        ;

section : expr11 LBRACK expr sectop expr RBRACK { $$ := node("section", $1,$2,$3,$4,$5,$6) } ;

sectop  : COLON ;
        | PCOLON ;
        | MCOLON ;

compound: nexpr ;
        | nexpr SEMICOL compound { $$ := node("compound", $1,";",$3) } ;

program : error decls EOFX ;
proc    : prochead error procbody END { $$ := node("error", $1,$3,$4) } ;
expr    : error { $$ := node("error") } ;

%%

#
# This procedure parenthesizes the right-hand side of an expression,
# apparently to simplify or correct any precedence or semantic issues
# when passing the code on to iconc.
#
procedure parenthesize_assign(nd)
   local rhs

   if /iconc then
      return nd
   if not (*nd.children = 3) then
      return nd
   rhs := nd.children[3]
   if (not(type(rhs) == "treenode")) then
      return nd
   if (not(rhs.label == "invoke")) then
      return nd
   rhs := node("Paren", "(", rhs, ")")
   nd.children[3] := rhs
   return nd
end

procedure FieldRef(lhs, dot, rhs)
   if /iconc | (type(lhs) ~== "treenode") then
      return Field(lhs, dot, rhs)

   if (lhs.label == "invoke") then {
      tmpcount +:= 1;
      return node("Paren", "(",
         node("assign", "__" || tmpcount, " := ", lhs, ")", "& "),
         node("invoke", Field("__" || tmpcount, ".", rhs))
         )
      }
   return Field(lhs, dot, rhs)
end

procedure InvocationNode(args[])
   tmpcount +:= 1
   if type(args[1]) == "token" & (args[1].tok = IDENT) then {
       n1 := args[1]
       lparen := copy(args[1])
       lparen.tok := LPAREN
       lparen.s := "("
   }
   else {
       n1 := node("Paren","(",node("assign","__"||tmpcount,":=",args[1]),")")
       if lparen := Clone1stToken(args[1]) then {
           lparen.tok := LPAREN
           lparen.s := "("
       }
       else lparen := "("
   }
   if *args = 6 then {
       return node("Paren",lparen,node("invoke",
                    # iconc uses no __m business
                   (if /iconc then Field(Field(n1, ".", "__m"), "." , args[3])
                              else Field(n1, ".", args[3])),

             args[4], node("exprlist",
             if n1 === args[1] then args[1] else "__"||tmpcount,
             if args[5] === &null then &null else ",",args[5]),args[6])
             ,")")
      }
   else {
      if /iconc then
         return  node("Paren",lparen,node("invoke",Field(Field(
                          Field(n1,".", "__m"),
                         "." , args[3]),".",args[5]),
                       args[6], node("exprlist",
                                if n1 === args[1] then args[1] else "__"||tmpcount,
                                if args[7] === &null then &null else ",",args[7]),args[8])
                      ,")")
      else return SuperMethodInvok ! args
   }
end

procedure SimpleInvocation(expr11, lparen, args, rparen)
   if /iconc then
      return node("invoke", expr11, lparen, args, rparen)

   if ((type(expr11) == "token") & (expr11.tok = IDENT)) then {
      return node("invoke", expr11, lparen, args, rparen)
      }

   if (type(expr11) == "treenode") then {
      case expr11.label of {
         "field": {
            #
            # need to examine lhs of field-ref to determine
            # whether we need to decompose the expr11 further...
            #
            if (type(expr11.children[1]) == "treenode") then {
               tmpcount +:= 1;
               n1 := node("Paren", "(", node("assign", "__"||tmpcount, ":=",
                  expr11.children[1]), ")")
               return node("exprlist", "(", n1, "&",
                  node("invoke", Field("__"||tmpcount, ".", expr11.children[3]),
                  lparen, args, rparen), ")")
               }
            else {
               return node("invoke", expr11, lparen, args, rparen)
               }
            }
         default: {
            return node("invoke", expr11, lparen, args, rparen)
            }
         }
      }
   return node("invoke", expr11, lparen, args, rparen)
end

procedure SuperMethodInvok(args[])
   tmpcount +:= 1
   if (type(args[1]) == "token") & (args[1].tok = IDENT) then {
      n1 := args[1]
      lparen := copy(args[1])
      lparen.tok := LPAREN
      lparen.s := "("
      }
   else {
      n1 := node("Paren","(",node("assign","__"||tmpcount,":=",args[1]),")")
      if lparen := Clone1stToken(args[1]) then {
         lparen.tok := LPAREN
         lparen.s := "("
         }
      else
         lparen := "("
      }

   args[3].s := mangle_class_sym(args[3].s)
   args[3].s ||:= "__oprec"
   return node("exprlist", "(", n1, ")", " & ",
      node("Paren", lparen, node("invoke",
      Field(args[3], ".", args[5]),
      args[6], node("exprlist",
      if n1 === args[1] then args[1] else "__" || tmpcount,
      if args[7] === &null then &null else ",", args[7]), args[8]),
      ")", ))
end

procedure isloco(node, s)
case type(node) of {
   "treenode": {
      if *node.children > 0 then return isloco(!node.children, s)
      }
   "token" : {
      if (node.tok = IDENT) & (node.s == s) then return
      }
   }
end

procedure buildtab_from_cclause(n, args)
   if type(n) ~== "treenode" then stop("bad table literal")
   comma := copy(n.children[2])
   comma.tok := COMMA
   comma.s := ","
   case n.label of {
     "cclause0": {
        if *args.children > 0 then push(args.children, comma)
        push(args.children, n.children[3])
        }
     "cclause1": {
        if *args.children > 0 then push(args.children, comma)
        push(args.children, n.children[3])
        push(args.children, comma)
        push(args.children, n.children[1])
        }
   }
end

# build a tree equivalent to
# {__tmp :=[]; every put(__tmp, expr); if __tmp>0 then __tmp}
# The enclosing procedure/method also needs to declare this temp var;
# see AppendListCompTemps
#
procedure ListComp(expr)
   local tmp
   tmpcount +:= 1
   tmp := "__" || tmpcount
   return node("ListComp",
                "{", string(tmp), " :=[]; every put(" || tmp || ", ",
                expr,
                "); if *" || tmp || ">0 then " || tmp || "}")
end

#
# AppendListCompTemps(localdecls, procbody) - at the procedure/method
# outermost level, we may need to add some declarations based on what's
# in the procbody. If there are changes to the declared lcls section,
# returns changed locals.
#
procedure AppendListCompTemps(lcls, body)
   # if there is, in the procbody, a list of varnames to declare
   if *\(ltmps := ListCompTemps(body)) > 0 then {
      # make a varlist containing ltmps
      if *ltmps > 1 then {
         vl := token(IDENT, ltmps[1], 0, 0, "lambda.icn")
         every i := 2 to *ltmps do
            vl := node("varlist3", vl, ",",
                        token(IDENT, ltmps[i], 0, 0, "lambda.icn"))
         }
      else {
         # the varlist will just be an IDENT
         vl := token(IDENT, ltmps[1], 0, 0, "lambda.icn")
         }
      if (lcls === &null) |
          (type(lcls)==="treenode" & lcls.label==("locals2"|"locals3")) then {
         return node("locals2", lcls, "local", vl, ";")
         }
      else
         write(&errout, "don't know what to do with ", image(lcls))
      }
end

#
# ListCompTemps(n) - lower level temp. var extraction from proc body.
# returns list of strings containing temp. variables from list comprehension
# L
procedure ListCompTemps(n)
   local LCT
   if type(n) == "treenode" then {
      if n.label=="ListComp" then {
         LCT := [n.children[2]]
         LCT |||:= ListCompTemps(n.children[4])
         return LCT
         }
      else if LCT := ListCompTemps(n.children[k := 1 to *(n.children)]) then {
         every kk := k+1 to *(n.children) do {
            LCT |||:= ListCompTemps(n.children[kk])
            }
         return LCT
         }
      }
end

procedure tablelit(lb, cl, rb)
local tabid, lp, rp, args
   args := node("elst1")
   while type(cl)=="treenode" & cl.label == "Caselist" do {
      buildtab_from_cclause(cl.children[3], args)
      cl := cl.children[1]
      }
   buildtab_from_cclause(cl, args)
   tabid := copy(lb); tabid.tok := IDENT; tabid.s := "table"
   lp := copy(lb); lp.tok := LPAREN; lp.s := "("
   rp := copy(rb); rp.tok := RPAREN; rp.s := ")"
   return node("invoke", tabid, lp, args, rp)
end

#
# A record type for recording errors for later reporting e.g. within an IDE,
# or to stderr.
#
record ParseError ( lineNumber, errorMessage )
