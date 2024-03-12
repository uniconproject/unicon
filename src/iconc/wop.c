
#include "../h/gsupport.h"
#include "ctrans.h"
#include "csym.h"
#include "ctree.h"
#include "ccode.h"
#include "cproto.h"
#include "wop.h"

#define isbadopbit(n) ((n) < Wop_Min || (n) > Wop_Max)

static unsigned int flags = 0;

extern
void
wop_arg_deref_insitu(struct val_loc * loc)
{
   struct code * code;

#if 0
   mdw_cdcomment("/* wop: Wop_OpArgDerefs */");
#endif
   code = alc_ary(6);
   code->ElemTyp(0) = A_ValLoc;
   code->ValLoc(0) = loc;
   code->ElemTyp(1) = A_Str;
   code->Str(1) =        " = *(dptr)((word *)VarLoc(";
   code->ElemTyp(2) = A_ValLoc;
   code->ValLoc(2) = loc;
   code->ElemTyp(3) = A_Str;
   code->Str(3) =        ") + Offset(";
   code->ElemTyp(4) = A_ValLoc;
   code->ValLoc(4) = loc;
   code->ElemTyp(5) = A_Str;
   code->Str(5) =        "));";
   cd_add(code);
}

extern
void
wop_fld_deref(struct val_loc * loc)
{
   struct code * code;

#if 0
   mdw_cdcomment("/* wop: Wop_FldDeref */");
#endif
   code = alc_ary(6);
   code->ElemTyp(0) = A_ValLoc;
   code->ValLoc(0) = loc;
   code->ElemTyp(1) = A_Str;
   code->Str(1) =        " = *(dptr)((word *)VarLoc(";
   code->ElemTyp(2) = A_ValLoc;
   code->ValLoc(2) = loc;
   code->ElemTyp(3) = A_Str;
   code->Str(3) =        ") + Offset(";
   code->ElemTyp(4) = A_ValLoc;
   code->ValLoc(4) = loc;
   code->ElemTyp(5) = A_Str;
   code->Str(5) =        "));";
   cd_add(code);
}

extern
int
wop_get(unsigned bit)
{
   if (isbadopbit(bit))
      return -1;
   return (flags & (1 << bit)) ? 1 : 0;
}

extern
int
wop_set(unsigned bit)
{
   if (isbadopbit(bit))
      return -1;
   flags |= (1 << bit);
   return 0;
}

