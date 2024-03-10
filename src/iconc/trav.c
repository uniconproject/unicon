#include "../h/gsupport.h"
#include "../h/lexdef.h"
#include "ctrans.h"
#include "csym.h"
#include "ctree.h"
#include "ctoken.h"
#include "cglobals.h"
#include "ccode.h"
#include "cproto.h"

void print_code(struct code *cd);
void print_codelist(struct code *start);

void print_union(struct gentry *g)  {
   struct fldname *i;

   if (g->flag & F_Builtin) {
      if (g->val.builtin->name != NULL)
         printf("  BI Name: \'%s\' ", g->val.builtin->name);
      if (g->val.builtin->op != NULL)
         printf("Op: \'%s\' ", g->val.builtin->op);
      if (g->val.builtin->comment != NULL)
         printf("Comment: \'%s\'", g->val.builtin->comment);
      printf("\n");
   }
   else if (g->flag & F_Proc)  {
      printf("  PROC Name: \'%s\'\n", g->val.proc->name);
      printf("    %d %s\n", g->val.proc->tree->flag, g->val.proc->tree->n_field[0].n_str);
   }
   else if (g->flag & F_Record)  {
      printf("  REC Name \'%s\' Field Names: ", g->val.rec->name);
      for (i = g->val.rec->fields; i != NULL ;i=i->next)
         printf(" \'%s\' ", i->name);
      printf("\n");
   }
}

void print_proc_lst(void)  {
   struct pentry *p;

   printf("************\n");
   for (p=proc_lst; p != NULL ;p=p->next)  {
      printf("%s n_field %s\n", p->tree->n_file, p->tree->n_field[0].n_str);
   }
   printf("************\n");
}


void print_code(struct code *cd)  {
     int    i;
     struct code *tmp;

     if (cd == NULL)
        return;
     switch  (cd->cd_id)  {
         case C_Null :     /*  0 */
             printf("C_Null\n");
             break;
         case C_NamedVar : /*  1 */
             printf("Named Var \'%s\' loc %d\n",cd->NamedVar->name,cd->NamedVar->val.index);
             break;
         case C_CallSig  : /*  2 */
             printf("Call Sig \'%s\'\n",cd->OperName);
             printf("BEGIN ARG LIST\n");
             print_code(cd->ArgLst);
             printf("END ARG LIST\n");
             break;
         case C_RetSig   : /*  3 */
             printf("Ret Sig - Not Implemented Yet\n");
             break;
         case C_Goto     : /*  4 */
             printf("Goto - \n");
             tmp = cd->Lbl;
             printf("   %s\n",tmp->Container->prefix);
             printf("   SeqNum %d\n",tmp->SeqNum);
             printf("   Desc   %s\n",tmp->Desc);
             printf("   RefCnt %d\n",tmp->RefCnt);
             break;
         case C_Label    : /*  5 */
             printf("Label - container \'%s\' seq # \'%d\' Desc \'%s\'\n",
                cd->Container->frm_prfx,cd->SeqNum,cd->Desc);
             break;
         case C_Lit      : /*  6 */
             printf("Literal \'%s\'\n",cd->Literal->image);
             break;
         case C_Resume   : /*  7 */
             printf("Resume\n");
             break;
         case C_Continue : /*  8 */
             printf("Continue\n");
             break;
         case C_FallThru : /*  9 */
             printf("Fall Thru\n");
             break;
         case C_PFail    : /* 10 */
             printf("Procedure Failure\n");
             break;
         case C_PRet     : /* 11 */
             printf("Procedure Return\n");
             break;
         case C_PSusp    : /* 12 */
             printf("Procedure Suspend\n");
             break;
         case C_Break    : /* 13 */
             printf("Procedure Break\n");
             break;
         case C_LBrack   : /* 14 */
             printf("Left bracket\n");
             break;
         case C_RBrack   : /* 15 */
             printf("Right bracket\n");
             break;
         case C_Create   : /* 16 */
             printf("Create something\n");
             break;
         case C_If       : /* 17 */
             printf("Conditional statment\n");
             printf("BEGIN Conditional\n");
             print_code(cd->Cond);
             printf("END Conditional\n");
             printf("BEGIN Then\n");
             print_code(cd->ThenStmt);
             printf("END Then\n");
             break;
         case C_SrcLoc   : /* 18 */
             printf("Src Location - name \'%s\' line num \'%d\'\n",cd->FileName, cd->LineNum);
             break;
         case C_CdAry    : /* 19 */
             printf("C_CdAry\n");
             for (i=0; cd->ElemTyp(i) != A_End ;i++)  {
                switch (cd->ElemTyp(i))  {
                   case A_Str :
                      printf("%d  A_Str \'%s\'\n",i,cd->Str(i));
                      break;
                   case A_ValLoc :
                      printf("%d  A_ValLoc:\n",i);
                      switch (cd->ValLoc(i)->mod_access)  {
                         case M_None :
                            printf("\t      access simply as descriptor\n");
                            break;
                         case M_CharPtr :
                            printf("\t      access v-word as \'char *\'\n");
                            break;
                         case M_BlkPtr :
                            printf("\t      blk_name (%s)\n",cd->ValLoc(i)->blk_name);
                            break;
                         case M_CInt :
                            printf("\t      access v-word as C integer\n");
                            break;
                         case M_Addr :
                            printf("\t      address of descriptor for varargs\n");
                            break;
                      }
                      switch (cd->ValLoc(i)->loc_type)  {
                         case V_NamedVar:
                            printf("      V_NamedVar    \'%s\' %d\n",cd->ValLoc(i)->u.nvar->name, cd->ValLoc(i)->u.nvar->val.index);
                            break;
                         case V_Temp :
                            printf("      V_Temp        \'%d\'\n",(cd->ValLoc(i)->u.tmp + cur_proc->tnd_loc));
                            break;
                         case V_ITemp :
                            printf("      V_ITemp       \'%d\'\n",cd->ValLoc(i)->u.tmp);
                            break;
                         case V_DTemp :
                            printf("      V_DTemp       \'%d\'\n",cd->ValLoc(i)->u.tmp);
                            break;
                         case V_PRslt :
                          printf("      V_PRslt - procedure result location\n");
                            break;
                         case V_Const :
                            printf("      V_Const       \'%d\'\n",cd->ValLoc(i)->u.int_const);
                            break;
                         case V_CVar  :
                            printf("      V_CVar        \'%s\'\n",cd->ValLoc(i)->u.name);
                            break;
                         case V_Ignore :
                            printf("      V_Ignore - trashcan\n");
                            break;
                      }
                      break;
                   case A_Intgr :
                      printf("%d   A_intgr      \'%d\'\n",i,cd->Intgr(i));
                      break;
                   case A_ProcCont :
                      printf("   A_ProcCont\n");
                      break;
                   case A_SBuf :
                      printf("   A_SBuf\n");
                      break;
                   case A_CBuf :
                      printf("   A_CBuf\n");
                      break;
                   case A_Ary :
                      printf("   Start A_Ary\n");
                      print_code(cd->Array(i));
                      printf("   End A_Ary\n");
                      break;
                }
             }
             break;
        default:
           printf("Unknown error!!!\n");
     }
}

void print_codelist(struct code *start)  {
   struct code *ptr;

   for(ptr=start; ptr != NULL ;ptr=ptr->next)
       print_code(ptr);
}

void print_fnc(struct c_fnc *fnclst)  {
   struct c_fnc *fnc;
   struct code  *cur;
   int           i;

   for (fnc=fnclst; fnc != NULL ;fnc=fnc->next) {
      printf("Prefix(%s) FrmPrefix(%s) Flag(%d)\n", fnc->prefix,
              fnc->frm_prfx, fnc->flag);
      cur = &(fnc->cd);
      while (cur != NULL)  {
          print_code(cur);
          cur = cur->next;
      }
   }
}

void print_ghash(void)  {
   struct gentry *g;
   int  i;

   printf("============\n");
   for (i=0; i < IHSize; i++)  {
      for (g = ghash[i]; g != NULL ;g=g->blink)  {
            printf("\'%s\' indx %d (flag %d)\n", g->name, g->index, g->flag);
            print_union(g);
      }
   }
   printf("============\n");
}

void print_val_loc(struct val_loc *vloc)  {

   if (vloc == NULL)
      return;
   printf("loc_type   ");
   switch (vloc->loc_type)  {
      case  V_NamedVar:
               printf("V_NamedVar\n");
               break;
      case  V_Temp:
               printf("V_Temp\n");
               break;
      case  V_ITemp:
               printf("V_ITemp\n");
               break;
      case  V_DTemp:
               printf("V_DTemp\n");
               break;
      case  V_PRslt:
               printf("V_PRslt\n");
               break;
      case  V_Const:
               printf("V_Const\n");
               break;
      case  V_CVar:
               printf("V_CVar\n");
               break;
      case  V_Ignore:
               printf("V_Ignore\n");
               break;
   }
   printf("mod access ");
   switch (vloc->mod_access)  {
      case  M_None:
               printf("M_None\n");
               break;
      case  M_CharPtr:
               printf("M_CharPtr\n");
               break;
      case  M_BlkPtr:
               printf("M_BlkPtr\n");
               break;
      case  M_CInt:
               printf("M_CInt\n");
               break;
      case  M_Addr:
               printf("M_Addre\n");
               break;
   }
}
