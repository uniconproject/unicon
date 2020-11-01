/*
 * File: oarith.r
 *  Contents: arithmetic operators + - * / % ^.  Auxiliary routines
 *   iipow, ripow.
 *
 * The arithmetic operators all follow a canonical conversion
 * protocol encapsulated in the macro ArithOp.
 */

#ifdef DataParallel
int list_add(dptr x, dptr y, dptr z);
#endif					/* DataParallel */

#begdef ArithOp(icon_op, func_name, c_int_op, c_real_op, c_list_op)

   operator{1} icon_op func_name(x, y)
      declare {
#ifdef LargeInts
         tended struct descrip lx, ly;
#endif					/* LargeInts */
	 C_integer irslt;
         }
#ifdef DataParallel
      if is:list(x) then {
         abstract {
            return type(x) ++ type(y)
	    }
	 inline { c_list_op(&x, &y, &result); return result; }
         }
      else
#endif					/* DataParallel */
      arith_case (x, y) of {
         C_integer: {
            abstract {
               return integer
               }
            inline {
               int over_flow = 0;
               c_int_op(x,y);
               }
            }
         integer: { /* large integers only */
            abstract {
               return integer
               }
            inline {
               big_ ## c_int_op(x,y);
               }
            }
         C_double: {
            abstract {
               return real
               }
            inline {
               c_real_op(x, y);
               }
            }
         }
end

#enddef

/*
 * check real expr for overflow before returning
 */
#begdef RealResult(expr)
{
   double z;
   z = expr;
   if (isinf(z))
      runerr(204);
   return C_double z;
}
#enddef

/*
 * x / y
 */

#begdef big_Divide(x,y)
{
   if ( ( Type ( y ) == T_Integer ) && ( IntVal ( y ) == 0 ) )
      runerr(201);  /* Divide fix */

   if (bigdiv(&x,&y,&result) == RunError) /* alcbignum failed */
      runerr(0);
   return result;
}
#enddef
#begdef Divide(x,y)
{
   if (y == 0)
      runerr(201);  /* divide fix */

   irslt = div3(x,y, &over_flow);
   if (over_flow) {
#ifdef LargeInts
      MakeInt(x,&lx);
      MakeInt(y,&ly);
      if (bigdiv(&lx,&ly,&result) == RunError) /* alcbignum failed */
	 runerr(0);
      return result;
#else                                   /* LargeInts */
      runerr(203);
#endif                                  /* LargeInts */
      }
   else return C_integer irslt;
}
#enddef
#begdef RealDivide(x,y)
{
   double z;

   if (y == 0.0)
      runerr(204);

   RealResult(x / y);
}
#enddef


ArithOp( / , divide , Divide , RealDivide, list_add /* bogus */)

/*
 * x - y
 */

#begdef big_Sub(x,y)
{
   if (bigsub(&x,&y,&result) == RunError) /* alcbignum failed */
      runerr(0);
   return result;
}
#enddef

#begdef Sub(x,y)
   irslt = sub(x,y, &over_flow);
   if (over_flow) {
#ifdef LargeInts
      MakeInt(x,&lx);
      MakeInt(y,&ly);
      if (bigsub(&lx,&ly,&result) == RunError) /* alcbignum failed */
         runerr(0);
      return result;
#else					/* LargeInts */
      runerr(203);
#endif					/* LargeInts */
      }
   else return C_integer irslt;
#enddef

#define RealSub(x,y) RealResult(x - y);

ArithOp( - , minus , Sub , RealSub, list_add /* bogus */)


/*
 * x % y
 */

#define Abs(x) ((x) > 0 ? (x) : -(x))

#begdef big_IntMod(x,y)
{
   if ( ( Type ( y ) == T_Integer ) && ( IntVal ( y ) == 0 ) ) {
      irunerr(202,0);
      errorfail;
      }
   if (bigmod(&x,&y,&result) == RunError)
      runerr(0);
   return result;
}
#enddef

#begdef IntMod(x,y)
{
   irslt = mod3(x,y, &over_flow);
   if (over_flow) {
      irunerr(202,y);
      errorfail;
      }
   return C_integer irslt;
}
#enddef

#begdef RealMod(x,y)
{
   double d;

   if (y == 0.0)
      runerr(204);

   d = fmod(x, y);
   /* d must have the same sign as x */
   if (x < 0.0) {
      if (d > 0.0) {
         d -= Abs(y);
         }
      }
   else if (d < 0.0) {
      d += Abs(y);
      }
   return C_double d;
}
#enddef

ArithOp( % , mod , IntMod , RealMod, list_add /* bogus */ )

/*
 * x * y
 */

#begdef big_Mpy(x,y)
{
   if (bigmul(&x,&y,&result) == RunError)
      runerr(0);
   return result;
}
#enddef

#begdef Mpy(x,y)
   irslt = mul(x,y,&over_flow);
   if (over_flow) {
#ifdef LargeInts
      MakeInt(x,&lx);
      MakeInt(y,&ly);
      if (bigmul(&lx,&ly,&result) == RunError) /* alcbignum failed */
         runerr(0);
      return result;
#else					/* LargeInts */
      runerr(203);
#endif					/* LargeInts */
      }
   else return C_integer irslt;
#enddef


#define RealMpy(x,y) RealResult(x * y);

ArithOp( * , mult , Mpy , RealMpy, list_add /* bogus */ )


"-x - negate x."

operator{1} - neg(x)
   if cnv:(exact)C_integer(x) then {
      abstract {
         return integer
         }
      inline {
	    C_integer i;
	    int over_flow = 0;

	    i = neg(x, &over_flow);
	    if (over_flow) {
#ifdef LargeInts
	       struct descrip tmp;
	       MakeInt(x,&tmp);
	       if (bigneg(&tmp, &result) == RunError)  /* alcbignum failed */
	          runerr(0);
               return result;
#else					/* LargeInts */
	       irunerr(203,x);
               errorfail;
#endif					/* LargeInts */
               }
         return C_integer i;
         }
      }
#ifdef LargeInts
   else if cnv:(exact) integer(x) then {
      abstract {
         return integer
         }
      inline {
	 if (bigneg(&x, &result) == RunError)  /* alcbignum failed */
	    runerr(0);
	 return result;
         }
      }
#endif					/* LargeInts */
   else {
      if !cnv:C_double(x) then
         runerr(102, x)
      abstract {
         return real
         }
      inline {
         double drslt;
	 drslt = -x;
         return C_double drslt;
         }
      }
end


"+x - convert x to a number."
/*
 *  Operational definition: generate runerr if x is not numeric.
 */
operator{1} + number(x)
   if cnv:(exact)C_integer(x) then {
       abstract {
          return integer
          }
       inline {
          return C_integer x;
          }
      }
#ifdef LargeInts
   else if cnv:(exact) integer(x) then {
       abstract {
          return integer
          }
       inline {
          return x;
          }
      }
#endif					/* LargeInts */
   else if cnv:C_double(x) then {
       abstract {
          return real
          }
       inline {
          return C_double x;
          }
      }
   else
      runerr(102, x)
end

/*
 * x + y
 */

#begdef big_Add(x,y)
{
   if (bigadd(&x,&y,&result) == RunError)
      runerr(0);
   return result;
}
#enddef

#begdef Add(x,y)
   irslt = add(x,y, &over_flow);
   if (over_flow) {
#ifdef LargeInts
      MakeInt(x,&lx);
      MakeInt(y,&ly);
      if (bigadd(&lx, &ly, &result) == RunError)  /* alcbignum failed */
	 runerr(0);
      return result;
#else					/* LargeInts */
      runerr(203);
#endif					/* LargeInts */
      }
   else return C_integer irslt;
#enddef

#define RealAdd(x,y) RealResult(x + y);

ArithOp( + , plus , Add , RealAdd, list_add )

#ifdef DataParallel

int list_add(dptr x, dptr y, dptr z)
{
   tended struct b_list *lp1;
   word size1, size2;
   word i, j, slot;

   if (is:list(*x) && is:list(*y)) {
      size1 = BlkLoc(*x)->List.size;
      size2 = BlkLoc(*y)->List.size;
      if (size1 != size2) return RunError;
#ifdef Arrays      
      if ( BlkType(BlkD(*x,List)->listhead)==T_Realarray){
	 double *a, *c;

	 if ( BlkType(BlkD(*y,List)->listhead)==T_Realarray){ /*the two are real arrays*/
	    double *b;
	    if (cprealarray(x, z, (word) 1, size1 + 1) == RunError)
	       return RunError;
	    /* points to the three arrays data and copy! */
	    a = ((struct b_realarray *) BlkLoc(*x)->List.listhead )->a;
	    b = ((struct b_realarray *) BlkLoc(*y)->List.listhead )->a;
	    c = ((struct b_realarray *) BlkLoc(*z)->List.listhead)->a;
	 
	    for(i=0; i<size1; i++)
	       c[i] = a[i] + b[i];
	    } /* two real arrays*/
	 else if ( BlkType(BlkD(*y,List)->listhead)==T_Intarray){ /*first arrays is real, second is int*/
	    word *b;

	    if (cprealarray(x, z, (word) 1, size1 + 1) == RunError)
	       return RunError;
	    
	    a = ((struct b_realarray *) BlkLoc(*x)->List.listhead )->a;
	    b =  ((struct b_intarray *) BlkLoc(*y)->List.listhead )->a;
	    c = ((struct b_realarray *) BlkLoc(*z)->List.listhead)->a;
	    /* a is real, b is int, hopefully the c compiler knows how to do it*/
	    for(i=0; i<size1; i++)
	       c[i] = a[i] + b[i];
	    } /* two real arrays*/
	 else{
	    /* the second list is a List */
	    tended union block *ep;
	    tended struct b_realarray *apa, *apc;
	    word k=0;
	    double f;
	    
	    if (cprealarray(x, z, (word) 1, size1 + 1) == RunError)
	       return RunError;

	    apa = (struct b_realarray *) BlkLoc(*x)->List.listhead;
	    apc = (struct b_realarray *) BlkLoc(*z)->List.listhead;
	    
	    for (ep = BlkD(*y,List)->listhead; BlkType(ep) == T_Lelem;
	       ep = Blk(ep,Lelem)->listnext){
	       for (i = 0; i < Blk(ep,Lelem)->nused; i++) {
		  j = ep->Lelem.first + i;
		  if (j >= ep->Lelem.nslots)
		  j -= ep->Lelem.nslots;
		     
		  if (!cnv:C_double(ep->Lelem.lslots[j], f)) 
		     return RunError;
		  
		  apc->a[k] = apa->a[k] + f;
		  k++;
		  }
	       }
	    }
	 }
      else if ( BlkType(BlkD(*x,List)->listhead)==T_Intarray){
	 word *a;
	 
	 if ( BlkType(BlkD(*y,List)->listhead)==T_Realarray){ /*first arrays is int, second is real*/
	    double *b, *c;
	    if (cprealarray(y, z, (word) 1, size1 + 1) == RunError)
	       return RunError;
	    /* points to the three arrays data and copy! */
	    a = ((struct b_intarray *) BlkLoc(*x)->List.listhead )->a;
	    b = ((struct b_realarray *) BlkLoc(*y)->List.listhead )->a;
	    c = ((struct b_realarray *) BlkLoc(*z)->List.listhead)->a;
	 
	    for(i=0; i<size1; i++)
	       c[i] = a[i] + b[i];
	    } 
	 else if ( BlkType(BlkD(*y,List)->listhead)==T_Intarray){  /*the two are int arrays*/
	    word *b, *c;

	    if (cpintarray(x, z, (word) 1, size1 + 1) == RunError)
	       return RunError;
	    
	    a = ((struct b_intarray *) BlkLoc(*x)->List.listhead )->a;
	    b =  ((struct b_intarray *) BlkLoc(*y)->List.listhead )->a;
	    c = ((struct b_intarray *) BlkLoc(*z)->List.listhead)->a;
	    /* a is real, b is int, hopefully the c compiler knows how to do it*/
	    for(i=0; i<size1; i++)
	       c[i] = a[i] + b[i];
	    } /* two real arrays*/
	 else{
	    /* the second list is a List */
	    tended union block *ep;
	    tended struct b_intarray *apa, *apc;
	    word k=0, d;
	    
	    if (cpintarray(x, z, (word) 1, size1 + 1) == RunError)
	       return RunError;
	    
	    apa = (struct b_intarray *) BlkLoc(*x)->List.listhead;
	    apc = (struct b_intarray *) BlkLoc(*z)->List.listhead;
	    
	    for (ep = BlkD(*y,List)->listhead; BlkType(ep) == T_Lelem;
	       ep = Blk(ep,Lelem)->listnext){
	       for (i = 0; i < Blk(ep,Lelem)->nused; i++) {
		  j = ep->Lelem.first + i;
		  if (j >= ep->Lelem.nslots)
		     j -= ep->Lelem.nslots;
		  
		  /* default : The resutling array is of type int */
		  if (Type(ep->Lelem.lslots[j]) == T_Integer ){
		     if (!cnv:C_integer(ep->Lelem.lslots[j], d))
			return RunError;
		     apc->a[k] = apa->a[k] + d;
		     k++;
		     }
		  else{ 
		     /* we might be able to continue with real, copy the elements to 
		      * a new realarray and continue
		      */
		     tended struct b_realarray *apc2;
		     double f;
		     word ii;
		     if (cpint2realarray(x, z, (word) 1, size1 + 1) == RunError)
			return RunError;
		     
		     apc2 = (struct b_realarray *) BlkLoc(*z)->List.listhead;
		     for (ii=0; ii<k; ii++)
			apc2->a[ii] = apc->a[ii];
		     
		     /* where we stoped in the last list lelem*/
		     ii=i;
		     /* no need to start over since elements were copied already*/
		     for (/*ep = BlkD(*y,List)->listhead*/;
			BlkType(ep) == T_Lelem; ep = Blk(ep,Lelem)->listnext){
			for (i = ii; i < Blk(ep,Lelem)->nused; i++) {
			   j = ep->Lelem.first + i;
			   if (j >= ep->Lelem.nslots)
			      j -= ep->Lelem.nslots;
			   if (!cnv:C_double(ep->Lelem.lslots[j], f))
			      return RunError;
			   apc2->a[k] = apa->a[k] + f;
			   k++;
			   }
			ii=0;
			}
		     return Succeeded;
		     }
		  } /*for i=0 */
	       } /* for ep = */
	    }
	 }
      else if ( BlkType(BlkD(*y,List)->listhead)==T_Realarray){
	 tended union block *ep;
	 tended struct b_realarray *apa, *apc;
	 word k=0;
	 double f;
	 
	 if (cprealarray(y, z, (word) 1, size1 + 1) == RunError)
	    return RunError;
	 
	 apa = (struct b_realarray *) BlkLoc(*y)->List.listhead;
	 apc = (struct b_realarray *) BlkLoc(*z)->List.listhead;
	 
	 for (ep = BlkD(*x,List)->listhead; BlkType(ep) == T_Lelem;
	    ep = Blk(ep,Lelem)->listnext){
	    for (i = 0; i < Blk(ep,Lelem)->nused; i++) {
	       j = ep->Lelem.first + i;
	       if (j >= ep->Lelem.nslots)
		  j -= ep->Lelem.nslots;
	       
	       if (!cnv:C_double(ep->Lelem.lslots[j], f)) 
		  return RunError;
	       
	       apc->a[k] = apa->a[k] + f;
	       k++;
	       }
	    }
	 }
      else if ( BlkType(BlkD(*y,List)->listhead)==T_Intarray){
	 tended union block *ep;
	 tended struct b_intarray *apa, *apc;
	 word k=0, d;

	 if (cpintarray(y, z, (word) 1, size1 + 1) == RunError)
	    return RunError;
	 
	 apa = (struct b_intarray *) BlkLoc(*y)->List.listhead;
	 apc = (struct b_intarray *) BlkLoc(*z)->List.listhead;
	 
	 for (ep = BlkD(*x,List)->listhead; BlkType(ep) == T_Lelem;
	    ep = Blk(ep,Lelem)->listnext){
	    for (i = 0; i < Blk(ep,Lelem)->nused; i++) {
	       j = ep->Lelem.first + i;
	       if (j >= ep->Lelem.nslots)
		  j -= ep->Lelem.nslots;
	       
	       /* default : The resutling array is of type int */
	       if (Type(ep->Lelem.lslots[j]) == T_Integer ){
		  if (!cnv:C_integer(ep->Lelem.lslots[j], d))
		     return RunError;
		  apc->a[k] = apa->a[k] + d;
		  k++;
		  }
	       else{ 
		  /* we might be able to continue with real, copy the elements to 
		   * a new realarray and continue
		   */
		  tended struct b_realarray *apc2;
		  double f;
		  word ii;
		  if (cpint2realarray(y, z, (word) 1, size1 + 1) == RunError)
		     return RunError;
		  
		  apc2 = (struct b_realarray *) BlkLoc(*z)->List.listhead;
		  for (ii=0; ii<k; ii++)
		     apc2->a[ii] = apc->a[ii];
		   /* where we stoped in the last list lelem*/
		  ii=i;
		  /* no need to start over since elements were copied already*/
		  for (/*ep = BlkD(*x,List)->listhead*/;
		     BlkType(ep) == T_Lelem; ep = Blk(ep,Lelem)->listnext){
		     for (i = ii; i < Blk(ep,Lelem)->nused; i++) {
			j = ep->Lelem.first + i;
			if (j >= ep->Lelem.nslots)
			   j -= ep->Lelem.nslots;
			if (!cnv:C_double(ep->Lelem.lslots[j], f))
			   return RunError;
			apc2->a[k] = apa->a[k] + f;
			k++;
			
			}
			ii=0;
		     }
		  return Succeeded;
		  
		  }
	       } /*for i=0*/
	    } /* for ep */
	 }
      else{ /* the two lists are of type List  */
#endif					/* Arrays */
	 struct descrip *slotptr;
	 tended struct b_lelem *bp1;
	 if (cplist(x, z, (word)1, size1 + 1) == RunError)
	    return RunError;
	 /* add in values from y */

	 lp1 = (struct b_list *) BlkLoc(*y);
	 bp1 = (struct b_lelem *) lp1->listhead;
	 i = 1;
	 slot = 0;
	 while (size2 > 0) {
	    j = bp1->first + i - 1;
	    if (j >= bp1->nslots)
	       j -= bp1->nslots;
	    slotptr = BlkLoc(*z)->List.listhead->Lelem.lslots + slot++;
	    list_add(slotptr, bp1->lslots+j, slotptr);
	    if (++i > bp1->nused) {
	       i = 1;
	       bp1 = (struct b_lelem *) bp1->listnext;
	       }
	    size2--;
	    }
#ifdef Arrays
	 }
#endif
      }
   else if (is:list(*x)) {
      /* x a list, y a scalar */
#ifdef Arrays
      if ( BlkType(BlkD(*x,List)->listhead)==T_Realarray){
	 double *a, *c, f;
	 size1 = BlkLoc(*x)->List.size;
	 
	 if (cprealarray(x, z, (word) 1, size1 + 1) == RunError)
	    return RunError;
	 if (!cnv:C_double(*y, f)) 
	    return RunError;
	 
	 a =  ((struct b_realarray *) BlkLoc(*x)->List.listhead )->a;
	 c =  ((struct b_realarray *) BlkLoc(*z)->List.listhead )->a;

	 for(i=0; i<size1; i++)
	    c[i] = a[i] + f ;
	 }
      else if ( BlkType(BlkD(*x,List)->listhead)==T_Intarray){
	 word *a, d;
	 double f;
	 size1 = BlkLoc(*x)->List.size;
	 if ( Type ( *y ) == T_Integer ){
	    word *c;
	    if (!cnv:C_integer(*y, d)) 
	       return RunError;
	    if (cpintarray(x, z, (word) 1, size1 + 1) == RunError)
	       return RunError;
	    a =  ((struct b_intarray *) BlkLoc(*x)->List.listhead )->a;
	    c =  ((struct b_intarray *) BlkLoc(*z)->List.listhead )->a;
	    for(i=0; i<size1; i++)
	       c[i] = a[i] + d ;
	    }
	 else if (cnv:C_double(*y, f)){
	    double *c;
	    if (cpint2realarray(x, z, (word) 1, size1 + 1, 0 /* no need to copy elements */) == RunError)
	       return RunError;
	    a =  ((struct b_intarray *) BlkLoc(*x)->List.listhead )->a;
	    c =  ((struct b_realarray *) BlkLoc(*z)->List.listhead )->a;
	    for(i=0; i<size1; i++)
	       c[i] = a[i] + f ;
	    }
	 else
	    return RunError;
	 }
      else{
#endif					/* Arrays*/
	 struct descrip *slotptr;
	 size1 = BlkLoc(*x)->List.size;
	 if (cplist(x, z, (word)1, size1 + 1) == RunError)
	    return RunError;
	 for (i=0; i<size1; i++) {
	    slotptr = BlkLoc(*z)->List.listhead->Lelem.lslots + i;
	    list_add(slotptr, y, slotptr);
	    }
#ifdef Arrays	 
      }
#endif					/* Arrays */
      }
   else if (is:list(*y)) {
      /* y a list, x a scalar */
#ifdef Arrays      
      if ( BlkType(BlkD(*y,List)->listhead)==T_Realarray){
	 double *a, *c, f;
	 size1 = BlkLoc(*y)->List.size;
	 
	 if (cprealarray(y, z, (word) 1, size1 + 1) == RunError)
	    return RunError;
	 if (!cnv:C_double(*x, f)) 
	    return RunError;
	 
	 a =  ((struct b_realarray *) BlkLoc(*y)->List.listhead )->a;
	 c =  ((struct b_realarray *) BlkLoc(*z)->List.listhead )->a;

	 for(i=0; i<size1; i++)
	    c[i] = a[i] + f ;
	 }
      else if ( BlkType(BlkD(*y,List)->listhead)==T_Intarray){
	 word *a, d;
	 double f;
	 size1 = BlkLoc(*y)->List.size;
	 if ( Type ( *x ) == T_Integer ){
	    word *c;
	    if (!cnv:C_integer(*x, d)) 
	       return RunError;
	    if (cpintarray(y, z, (word) 1, size1 + 1) == RunError)
	       return RunError;
	    a =  ((struct b_intarray *) BlkLoc(*y)->List.listhead )->a;
	    c =  ((struct b_intarray *) BlkLoc(*z)->List.listhead )->a;
	    for(i=0; i<size1; i++)
	       c[i] = a[i] + d ;
	    }
	 else if (cnv:C_double(*x, f)){
	    double *c;
	    if (cpint2realarray(y, z, (word) 1, size1 + 1, 0 /* no need to copy elements */) == RunError)
	       return RunError;
	    a =  ((struct b_intarray *) BlkLoc(*y)->List.listhead )->a;
	    c =  ((struct b_realarray *) BlkLoc(*z)->List.listhead )->a;
	    for(i=0; i<size1; i++)
	       c[i] = a[i] + f ;
	    }
	 else
	    return RunError;
	 }
      else{
#endif					/* Arrays */
	 struct descrip *slotptr;
	 size1 = BlkLoc(*y)->List.size;
	 if (cplist(y, z, (word)1, size1 + 1) == RunError)
	    return RunError;
	 for (i=0; i<size1; i++) {
	    slotptr = BlkLoc(*z)->List.listhead->Lelem.lslots + i;
	 list_add(slotptr, x, slotptr);
	 }
#ifdef Arrays
	 }
#endif					/* Arrays */	 
      }
   else {
      C_integer tmp, tmp2, irslt;
      double tmp3, tmp4;
#ifdef LargeInts
      tended struct descrip lx, ly;
#endif					/* LargeInts */
      
      /* x, y must be numeric */
      if (cnv:(exact)C_integer(*x, tmp) && cnv:(exact)C_integer(*y, tmp2)) {
         irslt = add(tmp,tmp2);
	 if (over_flow) {
#ifdef LargeInts
            MakeInt(x,&lx);
            MakeInt(y,&ly);
            if (bigadd(&lx, &ly, z) == RunError)  /* alcbignum failed */
               return RunError;
#endif					/* LargeInts */
	    }
	 else MakeInt(irslt, z);
         }
      else if (cnv:C_double(*x, tmp3) && cnv:C_double(*y, tmp4)) {
         }
      else return RunError;
      }
   return Succeeded;
}
#endif					/* DataParallel */




"x ^ y - raise x to the y power."

operator{1} ^ powr(x, y)
   if cnv:(exact)C_integer(y) then {
      if cnv:(exact)integer(x) then {
	 abstract {
	    return integer
	    }
	 inline {
#ifdef LargeInts
	    tended struct descrip ly;
	    MakeInt ( y, &ly );
	    if (bigpow(&x, &ly, &result) == RunError)  /* alcbignum failed */
	       runerr(0);
	    return result;
#else
	    int over_flow;
	    C_integer r = iipow(IntVal(x), y, &over_flow);
	    if (over_flow)
	       runerr(203);
	    return C_integer r;
#endif
	   }
	 }
      else {
	 if !cnv:C_double(x) then
	    runerr(102, x)
	 abstract {
	    return real
	    }
	 inline {
	    if (ripow( x, y, &result) ==  RunError)
	       runerr(0);
	    return result;
	    }
	 }
      }
#ifdef LargeInts
   else if cnv:(exact)integer(y) then {
      if cnv:(exact)integer(x) then {
	 abstract {
	    return integer
	    }
	 inline {
	    if (bigpow(&x, &y, &result) == RunError)  /* alcbignum failed */
	       runerr(0);
	    return result;
	    }
	 }
      else {
	 if !cnv:C_double(x) then
	    runerr(102, x)
	 abstract {
	    return real
	    }
	 inline {
	    if ( bigpowri ( x, &y, &result ) == RunError )
	       runerr(0);
	    return result;
	    }
	 }
      }
#endif					/* LargeInts */
   else {
      if !cnv:C_double(x) then
	 runerr(102, x)
      if !cnv:C_double(y) then
	 runerr(102, y)
      abstract {
	 return real
	 }
      inline {
	 double z;
	 if (x == 0.0 && y < 0.0)
	     runerr(204);
	 if (x < 0.0)
	    runerr(206);
	 z = pow(x, y);
	 if (isinf(z))
	    runerr(204);
	 return C_double z;
	 }
      }
end

#if COMPILER || !(defined LargeInts)
/*
 * iipow - raise an integer to an integral power. 
 */
C_integer iipow(C_integer n1, C_integer n2, int *over_flowp)
   {
   C_integer result;

   /* Handle some special cases first */
   *over_flowp = 0;
   switch ( n1 ) {
      case 1:
	 return 1;
      case -1:
	 /* Result depends on whether n2 is even or odd */
	 return ( n2 & 01 ) ? -1 : 1;
      case 0:
	 if ( n2 <= 0 )
	    *over_flowp = 1;
	 return 0;
      default:
	 if (n2 < 0)
	    return 0;
      }

   result = 1L;
   for ( ; ; ) {
      if (n2 & 01L)
	 {
	 result = mul(result, n1, over_flowp);
	 if (*over_flowp)
	    return 0;
	 }

      if ( ( n2 >>= 1 ) == 0 ) break;
      n1 = mul(n1, n1, over_flowp);
      if (*over_flowp)
	 return 0;
      }
   *over_flowp = 0;
   return result;
   }
#endif					/* COMPILER || !(defined LargeInts) */


/*
 * ripow - raise a real number to an integral power.
 */
int ripow(r, n, drslt)
double r;
C_integer n;
dptr drslt;
   {
   double retval;
   CURTSTATE();

   if (r == 0.0 && n <= 0) 
      ReturnErrNum(204, RunError);
   if (n < 0) {
      /*
       * r ^ n = ( 1/r ) * ( ( 1/r ) ^ ( -1 - n ) )
       *
       * (-1) - n never overflows, even when n == MinLong.
       */
      n = (-1) - n;
      r = 1.0 / r;
      retval = r;
      }
   else 	
      retval = 1.0;

   /* multiply retval by r ^ n */
   while (n > 0) {
      if (n & 01L)
	 retval *= r;
      r *= r;
      n >>= 1;
      }
   if (isinf(retval))
      ReturnErrNum(204, RunError);

#ifdef DescriptorDouble
   drslt->vword.realval = retval;
#else					/* DescriptorDouble */
   Protect(BlkLoc(*drslt) = (union block *)alcreal(retval), return RunError);
#endif					/* DescriptorDouble */
   drslt->dword = D_Real;
   return Succeeded;
   }
