
/*
 * This is a file of debugging conveniences that should not be integrated
 * into the mainstream iconc cvs branch.
 */
#include <stdarg.h>
#include "../h/gsupport.h"
#include "ctrans.h"
#include "csym.h"
#include "ctree.h"
#include "ctoken.h"
#include "cglobals.h"
#include "ccode.h"
#include "cproto.h"

static char * treenodetypenames[] = {
   "invalid node type",
   "N_Activat",/* activation control structure */
   "N_Alt",/* alternation operator */
   "N_Apply",/* procedure application */
   "N_Augop",/* augmented operator */
   "N_Bar",/* generator control structure */
   "N_Break",/* break statement */
   "N_Case",/* case statement */
   "N_Ccls",/* case clause */
   "N_Clist",/* list of case clauses */
   "N_Create",/* create control structure */
   "N_Cset",/* cset literal */
   "N_Elist",/* list of expressions */
   "N_Empty",/* empty expression or statement */
   "N_Field",/* record field reference */
   "N_Id",/* identifier token */
   "N_If",  /* if-then-else statement */
   "N_Int",/* integer literal */
   "N_Invok",/* invocation */
   "N_InvOp",/* invoke operation */
   "N_InvProc",/* invoke operation */
   "N_InvRec",/* invoke operation */
   "N_Limit",/* LIMIT control structure */
   "N_Loop",/* while, until, every, or repeat */
   "N_Next",/* next statement */
   "N_Not",/* not prefix control structure */
   "N_Op",  /* operator token */
   "N_Proc",/* procedure */
   "N_Real",/* real literal */
   "N_Res",/* reserved word token */
   "N_Ret",/* fail, return, or succeed */
   "N_Scan",/* scan-using statement */
   "N_Sect",/* s[i:j] (section) */
   "N_Slist",/* list of statements */
   "N_Str",/* string literal */
   "N_SmplAsgn",/* simple assignment to named var */
   "N_SmplAug"/* simple assignment to named var */
   };

static int varflags[] = {
   F_Global,
   F_Proc,
   F_Record,
   F_Dynamic,
   F_Static,
   F_Builtin,
   F_StrInv,
   F_ImpError,
   F_Argument,
   F_IntLit,
   F_RealLit,
   F_StrLit,
   F_CsetLit,
   F_Field,
   F_SmplInv
   };

static char * varflagnames[] = {
   "F_Global ",
   "F_Proc ",
   "F_Record ",
   "F_Dynamic ",
   "F_Static ",
   "F_Builtin ",
   "F_StrInv ",
   "F_ImpError ",
   "F_Argument ",
   "F_IntLit ",
   "F_RealLit ",
   "F_StrLit ",
   "F_CsetLit ",
   "F_Field ",
   "F_SmplInv "
   };

extern
struct code *
util_gencodeary(int size, ...)
{
   int i, typ;
   va_list ap;
   struct code * rslt;

   rslt = alc_ary(size);
   va_start(ap, size);
   for (i=0; i<size; i++) {
      typ = va_arg(ap, int);
      rslt->ElemTyp(i) = typ;
      switch (typ) {
         case A_Str:
            rslt->Str(i) = va_arg(ap, char *);
            break;
         case A_ValLoc:
            rslt->ValLoc(i) = va_arg(ap, struct val_loc *);
            break;
         case A_Intgr:
            rslt->Intgr(i) = va_arg(ap, int);
            break;
         case A_Ary:
            rslt->Array(i) = va_arg(ap, struct code *);
            break;
         default:
            printf("gen_code_ary: Nak elem-typ: %d\n", typ);
            rslt = NULL;
            break;
         }
      }
   va_end(ap);
   return rslt;
}

extern
char *
util_gettreenodetypename(int type)
{
   if (type < 1 || type > (sizeof(treenodetypenames)/sizeof(char *)))
      type = 0;
   return treenodetypenames[type];
}

extern
int
util_getvarflags(int flags, char * buf, int bufmax)
{
   int i, len;

   for (*buf=0,i=0,len=0; i<sizeof(varflags)/sizeof(int); i++) {
      if ((flags & varflags[i]) != varflags[i])
         continue;
      len += strlen(varflagnames[i]);
      if (len >= bufmax)
         return -len;
      strcat(buf, varflagnames[i]);
      }
   return 0;
}

