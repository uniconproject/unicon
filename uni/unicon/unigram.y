/*
 * NOTE: these %token declarations are generated
 *  automatically by mktoktab from tokens.txt and 
 *  op.txt.
 */

/* primitive tokens */

%token	IDENT
%token	INTLIT
%token	REALLIT
%token	STRINGLIT
%token	CSETLIT
%token	EOFX

/* reserved words */

%token	BREAK       /* break     */
%token	BY          /* by        */
%token	CASE        /* case      */
%token	CLASS       /* class     */
%token	CREATE      /* create    */
%token	DEFAULT     /* default   */
%token	DO          /* do        */
%token	ELSE        /* else      */
%token	END         /* end       */
%token	EVERY       /* every     */
%token	FAIL        /* fail      */
%token	GLOBAL      /* global    */
%token	IF          /* if        */
%token  IMPORT      /* import    */
%token	iconINITIAL /* initial   */
%token	INITIALLY   /* initially */
%token	INVOCABLE   /* invocable */
%token	LINK        /* link      */
%token	LOCAL       /* local     */
%token	METHOD      /* method    */
%token	NEXT        /* next      */
%token	NOT         /* not       */
%token	OF          /* of        */
%token	PACKAGE     /* package   */
%token	PROCEDURE   /* procedure */
%token	RECORD      /* record    */
%token	REPEAT      /* repeat    */
%token	RETURN      /* return    */
%token	STATIC      /* static    */
%token	SUSPEND     /* suspend   */
%token	THEN        /* then      */
%token	TO          /* to        */
%token	UNTIL       /* until     */
%token	WHILE       /* while     */

/* operators */

%token	BANG        /* !         */
%token	MOD         /* %         */
%token	AUGMOD      /* %:=       */
%token	AND         /* &         */
%token	AUGAND      /* &:=       */
%token	STAR        /* *         */
%token	AUGSTAR     /* *:=       */
%token	INTER       /* **        */
%token	AUGINTER    /* **:=      */
%token	PLUS        /* +         */
%token	AUGPLUS     /* +:=       */
%token	UNION       /* ++        */
%token	AUGUNION    /* ++:=      */
%token	MINUS       /* -         */
%token	AUGMINUS    /* -:=       */
%token	DIFF        /* --        */
%token	AUGDIFF     /* --:=      */
%token	DOT         /* .         */
%token	SLASH       /* /         */
%token	AUGSLASH    /* /:=       */
%token	ASSIGN      /* :=        */
%token	SWAP        /* :=:       */
%token	NMLT        /* <         */
%token	AUGNMLT     /* <:=       */
%token	REVASSIGN   /* <-        */
%token	REVSWAP     /* <->       */
%token	SLT         /* <<        */
%token	AUGSLT      /* <<:=      */
%token	SLE         /* <<=       */
%token	AUGSLE      /* <<=:=     */
%token	NMLE        /* <=        */
%token	AUGNMLE     /* <=:=      */
%token	NMEQ        /* =         */
%token	AUGNMEQ     /* =:=       */
%token	SEQ         /* ==        */
%token	AUGSEQ      /* ==:=      */
%token	EQUIV       /* ===       */
%token	AUGEQUIV    /* ===:=     */
%token	NMGT        /* >         */
%token	AUGNMGT     /* >:=       */
%token	NMGE        /* >=        */
%token	AUGNMGE     /* >=:=      */
%token	SGT         /* >>        */
%token	AUGSGT      /* >>:=      */
%token	SGE         /* >>=       */
%token	AUGSGE      /* >>=:=     */
%token	QMARK       /* ?         */
%token	AUGQMARK    /* ?:=       */
%token	AT          /* @         */
%token	AUGAT       /* @:=       */
%token	BACKSLASH   /* \         */
%token	CARET       /* ^         */
%token	AUGCARET    /* ^:=       */
%token	BAR         /* |         */
%token	CONCAT      /* ||        */
%token	AUGCONCAT   /* ||:=      */
%token	LCONCAT     /* |||       */
%token	AUGLCONCAT  /* |||:=     */
%token	TILDE       /* ~         */
%token	NMNE        /* ~=        */
%token	AUGNMNE     /* ~=:=      */
%token	SNE         /* ~==       */
%token	AUGSNE      /* ~==:=     */
%token	NEQUIV      /* ~===      */
%token	AUGNEQUIV   /* ~===:=    */
%token	LPAREN      /* (         */
%token	RPAREN      /* )         */
%token	PCOLON      /* +:        */
%token	COMMA       /* ,         */
%token	MCOLON      /* -:        */
%token	COLON       /* :         */
%token	COLONCOLON  /* ::        */
%token	SEMICOL     /* ;         */
%token	LBRACK      /* [         */
%token	RBRACK      /* ]         */
%token	LBRACE      /* {         */
%token	RBRACE      /* }         */

%token	DOLLAR      /* $         */

%{

procedure Keyword(x1,x2)
   static keywords
   initial {
      keywords := set(["allocated","clock","collections","column","current",
		       "date","now","dateline","digits","e","error",
		       "errornumber","errortext","errorvalue","errout","fail",
		       "eventcode","eventsource","eventvalue","features",
		       "file","host","input","lcase","letters","level",
		       "line","main","null","output","phi","pi","pos",
		       "progname","random","regions","source","storage",
		       "subject","time","trace","dump","ucase","version",
		       "errno","window","col","row","x","y","interval",
		       "control","shift","meta","lpress","mpress","rpress",
		       "lrelease","mrelease","rrelease","ldrag","mdrag",
		       "rdrag","resize","ascii","cset"])
      }

   # verify that x2 is a valid keyword
   if not member(keywords, x2.s) then
      write(&errout, "&",x2.s," is not a valid keyword!")

   return node("keyword",x1,x2)
end

procedure Field(x1,x2,x3)
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

global outline, outcol, outfilename
procedure Progend(x1)
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
	    writelink(cl.linkfile)
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
  #
  # scope check on classes defined in this source file
  # fix me
  #
#  every (!native).scopeck()
  every (classes.foreach_t()).scopeck()
  #
  # generate output
  #
#  iwrite("Generating code:")
   yyprint(x1)
   write(yyout)
end
%}

%%

/*
 * igram.y -- iYacc grammar for Icon
 *
 * This file is the iYacc input for building Icon-based Icon tools.
 */

program	: decls EOFX { Progend($1);} ;

decls	: { $$ := EmptyNode } ;
	| decls decl {
	   if yynerrs = 0 then iwrites(&errout,".");
	   $$ := node("decls", $1, $2)
	      } ;

decl	: record
	| proc
	| global
	| link
	| package
	| import
        | invocable
	| cl
	;

initiallysection: { $$ := EmptyNode }
	| INITIALLY SEMICOL locals initial procbody {
	   $$ := Method( , , , , "initially", EmptyNode, "method", "(", ")")
	   $$.locals := $3
	   $$.initl := $4
	   $$.procbody := $5
	}
	| INITIALLY LPAREN arglist RPAREN SEMICOL locals initial procbody {
	   $$ := Method( , , , , "initially", $3, "method", "(", ")")
	   $$.locals := $6
	   $$.initl := $7
	   $$.procbody := $8
	}
	;

cl : classhead SEMICOL END {
   $$ := $1;
   $$.methods := methodstaque(&null, $$)
   }
   | classhead methods initiallysection END {
   $$ := $1;
   if $3 ~=== EmptyNode then
      $2 := node("methods", $2, $3)
   $$.methods := methodstaque($2, $$)
   } ;

classhead : CLASS IDENT supers LPAREN arglist RPAREN {
   $$ := Class()
   $$.tag := $1
   $$.name := $2.s
   classes.insert($$, $$.name)
   $$.supers := $3
   $$.fields := $5
   $$.lptoken := $4
   $$.rptoken := $6
   } ;

supers: { $$ := idTaque(":") } ;
   | COLON IDENT supers { $$ := $3; taque_Push($$, $2.s) }
   ;

methods: { $$ := EmptyNode } ;
   | meth methods { $$ := node("methods", $1,$2) }
   | global methods { $$ := node("methods", $1,$2) }
   | record methods { $$ := node("methods", $1,$2) }
   ;

invocable : INVOCABLE invoclist { $$ := node("invocable", $1, $2);} ;

invoclist : invocop;
	  | invoclist COMMA invocop { $$ := node("invoclist", $1,$2,$3);} ;

invocop  : IDENT ;
	 | STRINGLIT ;
	 | STRINGLIT COLON INTLIT {$$ := node("invocop3", $1,$2,$3);} ;

package	: PACKAGE lnkfile {
   if \thePackage then {
      yyerror(fName || " cannot be in both package "|| thePackage.name ||
	      " and package " || $2.s)
      $$ := EmptyNode
      }
   else {
      $$ := node("package", $1,$2);
      thePackage := Package( , $2.s)
      thePackage.insertfname(fName)
      }
   } ;

import	: IMPORT lnklist {
   $$ := node("import", $1,$2," ")
   import_class($2)
   } ;

link	: LINK lnklist { $$ := node("link", $1,$2," "); } ;

lnklist	: lnkfile ;
	| lnklist COMMA lnkfile { $$ := node("lnklist", $1,$2,$3); } ;

lnkfile	: IDENT ;
	| STRINGLIT ;

global	: GLOBAL idlist { $$ := node("global", $1,$2) } ;

record	: RECORD IDENT LPAREN fldlist RPAREN {
		$$ := declaration($2,$4,$1,$3,$5)
		} ;

fldlist	: { $$ := EmptyNode } ;
	| idlist ;

proc	: prochead SEMICOL locals initial procbody END {
		body_scopeck($5)
		$$ := node("proc", $1,";",$3,$4,$5,$6)
		} ;

meth	: methhead SEMICOL locals initial procbody END {
		$$ := $1
		$$.locals := $3
		$$.initl := $4
		$$.procbody := $5
		} ;

prochead: PROCEDURE IDENT LPAREN arglist RPAREN {
		$$ := declaration($2, $4, $1, $3, $5)
		} ;

methhead: METHOD IDENT LPAREN arglist RPAREN {
		$$ := Method( , , , , $2.s, $4, $1.s, $3, $5)
		} ;

arglist	: { $$ := argList( , , &null) } ;
	| parmlist { $$ := argList( , , $1) } ;
	| parmlist LBRACK RBRACK { $$ := argList("[]" , , $1) } ;


idlist	: IDENT ;
	| idlist COMMA IDENT { $$ := node("idlist", $1,$2,$3) } ;

parmlist: arg ;
	| parmlist COMMA arg { $$ := node("parmlist", $1,$2,$3) } ;

arg	: IDENT ;
	| IDENT COLON IDENT { $$ := node("arg2", $1, $2, $3) } ;
	| IDENT COLON literal { $$ := node("arg3", $1, $2, $3) } ;
	| IDENT COLON IDENT COLON literal { $$ := node("arg4", $1, $2, $3, $4, $5) } ;

locals	: { $$ := EmptyNode;} ;
	| locals retention idlist SEMICOL { $$ := node("locals2", $1,$2,$3,";");} ;

retention: LOCAL ;
	| STATIC ;

initial	: { $$ := EmptyNode } ;
	| iconINITIAL expr SEMICOL {
	   $$ := node("initial", $1, $2,";")
	      } ;

procbody: { $$ := EmptyNode } ;
	| nexpr SEMICOL procbody { $$ := node("procbody", $1,";",$3);} ;

nexpr	: { $$ := EmptyNode } ;
	| expr ;

expr	: expr1a ;
	| expr AND expr1a	{ $$ := node("and", $1,$2,$3) } ;

expr1a	: expr1 ;
	| expr1a QMARK expr1	{ $$ := node("binques", $1,$2,$3);} ;

expr1	: expr2 ;
	| expr2 SWAP expr1      { $$ := node("swap", ckfnasgn($1),$2,$3);} ;
	| expr2 ASSIGN expr1    { $$ := node("assign", ckfnasgn($1),$2,$3);} ;
	| expr2 REVSWAP expr1   { $$ := node("revswap", ckfnasgn($1),$2,$3);} ;
	| expr2 REVASSIGN expr1 { $$ := node("revasgn", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGCONCAT expr1 { $$ := node("augcat", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGLCONCAT expr1 { $$ := node("auglcat", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGDIFF expr1   { $$ := node("Bdiffa", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGUNION expr1  { $$ := node("Buniona", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGPLUS expr1   { $$ := node("Bplusa", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGMINUS expr1  { $$ := node("Bminusa", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGSTAR expr1   { $$ := node("Bstara", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGINTER expr1  { $$ := node("Bintera", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGSLASH expr1  { $$ := node("Bslasha", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGMOD expr1    { $$ := node("Bmoda", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGCARET expr1  { $$ := node("Bcareta", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGNMEQ expr1   { $$ := node("Baugeq", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGEQUIV expr1  { $$ := node("Baugeqv", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGNMGE expr1   { $$ := node("Baugge", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGNMGT expr1   { $$ := node("Bauggt", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGNMLE expr1   { $$ := node("Baugle", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGNMLT expr1   { $$ := node("Bauglt", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGNMNE expr1   { $$ := node("Baugne", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGNEQUIV expr1 { $$ := node("Baugneqv", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGSEQ expr1    { $$ := node("Baugseq", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGSGE expr1    { $$ := node("Baugsge", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGSGT expr1    { $$ := node("Baugsgt", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGSLE expr1    { $$ := node("Baugsle", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGSLT expr1    { $$ := node("Baugslt", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGSNE expr1    { $$ := node("Baugsne", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGQMARK expr1  { $$ := node("Baugques", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGAND expr1    { $$ := node("Baugamper", ckfnasgn($1),$2,$3);} ;
	| expr2 AUGAT expr1     { $$ := node("Baugact", ckfnasgn($1),$2,$3);} ;

expr2	: expr3 ;
	| expr2 TO expr3 { $$ := node("to", $1,$2,$3);} ;
	| expr2 TO expr3 BY expr3 { $$ := node("toby", $1,$2,$3,$4,$5);} ;

expr3	: expr4 ;
	| expr4 BAR expr3 {$$ := node(BAR, $1,$2,$3);} ;

expr4	: expr5 ;
	| expr4 SEQ expr5 { $$ := node("Bseq", $1,$2,$3);} ;
	| expr4 SGE expr5 { $$ := node("Bsge", $1,$2,$3);} ;
	| expr4 SGT expr5 { $$ := node("Bsgt", $1,$2,$3);} ;
	| expr4 SLE expr5 { $$ := node("Bsle", $1,$2,$3);} ;
	| expr4 SLT expr5 { $$ := node("Bslt", $1,$2,$3);} ;
	| expr4 SNE expr5 { $$ := node("Bsne", $1,$2,$3);} ;
	| expr4 NMEQ expr5 { $$ := node("Beq", $1,$2,$3);} ;
	| expr4 NMGE expr5 { $$ := node("Bge", $1,$2,$3);} ;
	| expr4 NMGT expr5 { $$ := node("Bgt", $1,$2,$3);} ;
	| expr4 NMLE expr5 { $$ := node("Ble", $1,$2,$3);} ;
	| expr4 NMLT expr5 { $$ := node("Blt", $1,$2,$3);} ;
	| expr4 NMNE expr5 { $$ := node("Bne", $1,$2,$3);} ;
	| expr4 EQUIV expr5 { $$ := node("Beqv", $1,$2,$3);} ;
	| expr4 NEQUIV expr5 { $$ := node("Bneqv", $1,$2,$3);} ;

expr5	: expr6 ;
	| expr5 CONCAT expr6 { $$ := node("Bcat", $1,$2,$3);} ;
	| expr5 LCONCAT expr6 { $$ := node("Blcat", $1,$2,$3);} ;

expr6	: expr7 ;
	| expr6 PLUS expr7 { $$ := node("Bplus", $1,$2,$3);} ;
	| expr6 DIFF expr7 { $$ := node("Bdiff", $1,$2,$3);} ;
	| expr6 UNION expr7 { $$ := node("Bunion", $1,$2,$3);} ;
	| expr6 MINUS expr7 { $$ := node("Bminus", $1,$2,$3);} ;

expr7	: expr8 ;
	| expr7 STAR expr8 { $$ := node("Bstar", $1,$2,$3);} ;
	| expr7 INTER expr8 { $$ := node("Binter", $1,$2,$3);} ;
	| expr7 SLASH expr8 { $$ := node("Bslash", $1,$2,$3);} ;
	| expr7 MOD expr8 { $$ := node("Bmod", $1,$2,$3);} ;

expr8	: expr9 ;
	| expr9 CARET expr8 { $$ := node("Bcaret", $1,$2,$3);} ;

expr9	: expr10 ;
	| expr9 BACKSLASH expr10 { $$ := node("limit", $1,$2,$3);} ;
	| expr9 AT expr10 { $$ := node("at", $1,$2,$3) };
	| expr9 BANG expr10 { $$ := node("apply", $1,$2,$3);};

expr10	: expr11 ;
	| AT expr10 { $$ := node("uat", $1,$2);} ;
	| NOT expr10 { $$ := node("unot", $1,$2);} ;
	| BAR expr10 { $$ := node("ubar", $1,$2);} ;
	| CONCAT expr10 { $$ := node("uconcat", $1,$2);} ;
	| LCONCAT expr10 { $$ := node("ulconcat", $1,$2);} ;
	| DOT expr10 { $$ := node("udot", $1,$2);} ;
	| BANG expr10 { $$ := node("ubang", $1,$2);} ;
	| DIFF expr10 { $$ := node("udiff", $1,$2);} ;
	| PLUS expr10 { $$ := node("uplus", $1,$2);} ;
	| STAR expr10 { $$ := node("ustar", $1,$2);} ;
	| SLASH expr10 { $$ := node("uslash", $1,$2);} ;
	| CARET expr10 { $$ := node("ucaret", $1,$2);} ;
	| INTER expr10 { $$ := node("uinter", $1,$2);} ;
	| TILDE expr10 { $$ := node("utilde", $1,$2);} ;
	| MINUS expr10 { $$ := node("uminus", $1,$2);} ;
	| NMEQ expr10 { $$ := node("unumeq", $1,$2);} ;
	| NMNE expr10 { $$ := node("unumne", $1,$2);} ;
	| SEQ expr10 { $$ := node("ulexeq", $1,$2);} ;
	| SNE expr10 { $$ := node("ulexne", $1,$2);} ;
	| EQUIV expr10 { $$ := node("uequiv", $1,$2);} ;
	| UNION expr10 { $$ := node("uunion", $1,$2);} ;
	| QMARK expr10 { $$ := node("uqmark", $1,$2);} ;
	| NEQUIV expr10 { $$ := node("unotequiv", $1,$2);} ;
	| BACKSLASH expr10 { $$ := node("ubackslash", $1,$2);} ;

expr11	: literal ;
	| section ;
	| return ;
	| if ;
	| case ;
	| while ;
	| until ;
	| every ;
	| repeat ;
	| CREATE expr { $$ := node("create", $1,$2);} ;
	| IDENT ;
	| NEXT { $$ := node("Next", $1);} ;
	| BREAK nexpr { $$ := node("Break", $1,$2);} ;
	| LPAREN exprlist RPAREN { $$ := node("Paren", $1,$2,$3);} ;
	| LBRACE compound RBRACE { $$ := node("Brace", $1,$2,$3);} ;
	| LBRACK exprlist RBRACK { $$ := node("Brack", $1,$2,$3);} ;
	| expr11 LBRACK exprlist RBRACK { $$ := node("Subscript", $1,$2,$3,$4);} ;
	| expr11 LBRACE	RBRACE { $$ := node("Pdco0", $1,$2,$3);} ;
	| expr11 LBRACE pdcolist RBRACE { $$ := node("Pdco1", $1,$2,$3,$4);} ;
	| expr11 LPAREN exprlist RPAREN { $$ := node("invoke", $1,$2,$3,$4);} ;
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
	| expr11 DOT IDENT { $$ := Field($1,$2,$3);} ;
	| IDENT COLONCOLON IDENT { $$ := node("packageref", $1,$2,$3);} ;
	| expr11 DOT INITIALLY { $$ := Field($1,$2,$3);} ;
	| AND FAIL { $$ := node("keyword",$1,$2);} ;
	| AND IDENT { $$ := Keyword($1,$2);} ;

while	: WHILE expr { $$ := node("While0", $1,$2);} ;
	| WHILE expr DO expr { $$ := node("While1", $1,$2,$3,$4);} ;

until	: UNTIL expr { $$ := node("until", $1,$2);} ;
	| UNTIL expr DO expr { $$ := node("until1", $1,$2,$3,$4);} ;

every	: EVERY expr { $$ := node("every", $1,$2);} ;
	| EVERY expr DO expr { $$ := node("every1", $1,$2,$3,$4);} ;

repeat	: REPEAT expr { $$ := node("repeat", $1,$2);} ;

return	: FAIL ;
	| RETURN nexpr { $$ := node("return", $1, $2);} ;
	| SUSPEND nexpr { $$ := node("Suspend0", $1,$2);} ;
        | SUSPEND expr DO expr { $$ := node("Suspend1", $1,$2,$3,$4);};

if	: IF expr THEN expr { $$ := node("If0", $1,$2,$3,$4);} ;
	| IF expr THEN expr ELSE expr { $$ := node("If1", $1,$2,$3,$4,$5,$6);} ;

case	: CASE expr OF LBRACE caselist RBRACE { $$ := node("Case", $1,$2,$3,$4,$5,$6);} ;

caselist: cclause ;
	| caselist SEMICOL cclause { $$ := node("Caselist", $1,";",$3);} ;

cclause	: DEFAULT COLON expr { $$ := node("cclause0", $1,$2,$3);} ;
	| expr COLON expr { $$ := node("cclause1", $1,$2,$3);} ;

exprlist: nexpr ;
	| exprlist COMMA nexpr {
	   if type($1)=="treenode" & ($1.label=="elst1") then {
	      $$ := $1; put($$.children, $2, $3)
	      }
	   else
	      $$ := node("elst1", $1,$2,$3)
	   } ;

pdcolist: nexpr { $$ := node("pdcolist0", $1) } ;
	| pdcolist COMMA nexpr { $$ := node("pdcolist1", $1,$2,$3); } ;

literal	: INTLIT ;
	| REALLIT ;
	| STRINGLIT ;
	| CSETLIT ;

section	: expr11 LBRACK expr sectop expr RBRACK { $$ := node("section", $1,$2,$3,$4,$5,$6);} ;

sectop	: COLON ;
	| PCOLON ;
	| MCOLON ;

compound: nexpr ;
	| nexpr SEMICOL compound { $$ := node("compound", $1,";",$3);} ;

program	: error decls EOFX ;
proc	: prochead error procbody END { $$ := node("error", $1,$3,$4); } ;
expr	: error { $$ := node("error"); } ;

%%

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
   if *args = 6 then
       return node("Paren",lparen,node("invoke",
	  Field(Field(n1, ".", "__m"), "." , args[3]),
	     args[4], node("exprlist",
	     if n1 === args[1] then args[1] else "__"||tmpcount,
	     if args[5] === EmptyNode then EmptyNode else ",",args[5]),args[6])
	     ,")")
   else return  node("Paren",lparen,node("invoke",Field(Field(
			  Field(n1,".", "__m"),
			 "." , args[3]),".",args[5]),
		       args[6], node("exprlist",
				if n1 === args[1] then args[1] else "__"||tmpcount,
				if args[7] === EmptyNode then EmptyNode else ",",args[7]),args[8])
		      ,")")
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

#
# check whether x is the name of a function that is accidentally being
# assgined.  if it is, issue a warning unless a flag has been set.
#
procedure ckfnasgn(x)

if type(x)=="token" & proc(x.s, 0) then
   warning("Warning: assignment to built-in function "|| x.s)
return x
end
