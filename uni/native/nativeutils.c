#include "nativeutils.h"

#include <stdlib.h>

/*
  List creation helper funcs.  Example usage:

   l = create_empty_list();

   for (i = 0; i < 10; ++i) {
      struct descrip intval;
      MakeInt(i, &intval);
      c_put(&l, &intval);
   }
*/

struct descrip create_empty_list() {
   return create_list(0, NULL);
}

struct descrip create_list(int n, dptr d) {
   struct descrip res;

   struct b_list *hp;
   struct b_lelem *bp;
   word i, size;
   word nslots;
 
   nslots = size = n;
 
   if (nslots == 0)
      nslots = MinListSlots;

   hp = alclist(size, nslots);
   bp = (struct b_lelem*)hp->listhead;
 
   /*
    * Initialize each slot.
    */
   for (i = 0; i < size; i++)
      bp->lslots[i] = *d;
 
   res.dword = D_List;
   res.vword.bptr = (union  block *)hp;

   return res;
}

struct descrip create_string(char *s) {
    struct descrip res;
    char *a;
    int n;

    if (s == NULL)
        return nulldesc;

    n = strlen(s);

    a = alcstr(s, n);
    
    MakeStr(a, n, &res);

    return res;
}

struct descrip create_string2(char *s, int len) {
    struct descrip res;

    if (s == NULL)
        return nulldesc;

    MakeStr(alcstr(s, len), len, &res);

    return res;
}
