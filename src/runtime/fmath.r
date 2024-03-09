/*
 * fmath.r -- sin, cos, tan, acos, asin, atan, dtor, rtod, exp, log, sqrt
 */

/*
 * Most of the math ops are simple calls to underlying C functions,
 * sometimes with additional error checking to avoid and/or detect
 * various C runtime errors.
 */
#begdef MathOp(funcname,ccode,comment,pre,post)
#funcname "(r)" comment
function{1} funcname(x)

   if !cnv:C_double(x) then
      runerr(102, x)

   abstract {
      return real
      }
   inline {
      double y;
      pre               /* Pre math-operation range checking */
      errno = 0;
      y = ccode(x);
      post              /* Post math-operation C library error detection */
      return C_double y;
      }
end
#enddef


#define aroundone if (x < -1.0 || x > 1.0) {drunerr(205, x); errorfail;}
#define positive  if (x < 0)               {drunerr(205, x); errorfail;}

#define erange    if (errno == ERANGE)     runerr(204);
#define edom      if (errno == EDOM)       runerr(205);

MathOp(sin, sin,  ", x in radians.", ;, ;)
MathOp(cos, cos,  ", x in radians.", ;, ;)
MathOp(tan, tan,  ", x in radians.", ; , erange)
MathOp(acos,acos, ", x in radians.", aroundone, edom)
MathOp(asin,asin, ", x in radians.", aroundone, edom)

#if NT
double atanh(double x)
{
   return 0.5 * 2.302585093 * log((1 + x) / (1 - x));
}
#endif

MathOp(atanh,atanh, ", x in radians.", aroundone, edom)
MathOp(exp, exp,  " - e^x.", ; , erange)
MathOp(sqrt,sqrt, " - square root of x.", positive, edom)
#define DTOR(x) ((x) * Pi / 180)
#define RTOD(x) ((x) * 180 / Pi)
MathOp(dtor,DTOR, " - convert x from degrees to radians.", ; , ;)
MathOp(rtod,RTOD, " - convert x from radians to degrees.", ; , ;)



"atan(r1,r2) -- r1, r2  in radians; if r2 is present, produces atan2(r1,r2)."

function{1} atan(x,y)

   if !cnv:C_double(x) then
      runerr(102, x)

   abstract {
      return real
      }
   if is:null(y) then
      inline {
         return C_double atan(x);
         }
   if !cnv:C_double(y) then
      runerr(102, y)
   inline {
      return C_double atan2(x,y);
      }
end


"log(r1,r2) - logarithm of r1 to base r2."

function{1} log(x,b)

   if !cnv:C_double(x) then
      runerr(102, x)

   abstract {
      return real
      }
   inline {
      if (x <= 0.0) {
         drunerr(205, x);
         errorfail;
         }
      }
   if is:null(b) then
      inline {
         return C_double log(x);
         }
   else {
      if !cnv:C_double(b) then
         runerr(102, b)
      body {
#ifndef Concurrent
         static double lastbase = 0.0;
         static double divisor;
#endif                                  /* Concurrent */
         CURTSTATE();

         if (b <= 1.0) {
            drunerr(205, b);
            errorfail;
            }
         if (b != lastbase) {
            divisor = log(b);
            lastbase = b;
            }
         x = log(x) / divisor;
         return C_double x;
         }
      }
end

"max(x,y,...) - return the maximum of the arguments"

function{1} max(argv[argc])
abstract {
   return any_value
   }
body {
   int i;
   struct descrip dtmp;
   if (argc == 0) fail;
   dtmp = argv[0];
   if (argc == 1) {
      if (is:list(dtmp)) {
         int i, j, size;
         union block *bp;
         size = BlkD(dtmp,List)->size;
         if (size==0) fail;
#ifdef Arrays
         if (BlkD(dtmp,List)->listtail == NULL) {
            bp = BlkD(dtmp,List)->listhead;
            if (bp->Intarray.title == T_Intarray) {
               word mymax = bp->Intarray.a[0];
               for(i = 1; i < size; i++)
                  if (bp->Intarray.a[i] > mymax) mymax = bp->Intarray.a[i];
               return C_integer mymax;
               }
            else {
               double mymax = bp->Realarray.a[0];
               for(i = 1; i < size; i++)
                  if (bp->Realarray.a[i] > mymax) mymax = bp->Realarray.a[i];
               dtmp.dword = D_Real;
#ifdef DescriptorDouble
               dtmp.vword.realval = mymax;
#else                                   /* DescriptorDouble */
               dtmp.vword.bptr = (union block *)alcreal(mymax);
#endif                                  /* DescriptorDouble */
               return dtmp;
               }
            }

#endif
         /*
          * normal max(L), walk through list elements
          */
         bp = dtmp.vword.bptr;
         dtmp = nulldesc; /* the minimal value */
         for (bp = Blk(bp,List)->listhead; BlkType(bp) == T_Lelem;
              bp = Blk(bp,Lelem)->listnext) {
            for (i = 0; i < Blk(bp,Lelem)->nused; i++) {
               j = bp->Lelem.first + i;
               if (j >= bp->Lelem.nslots)
                  j -= bp->Lelem.nslots;
               if (anycmp(bp->Lelem.lslots+j, &dtmp) == Greater)
                  dtmp = bp->Lelem.lslots[j];
               }
            }
         }
      }
   else
      for(i=1;i<argc;i++) if (anycmp(&dtmp, argv+i) < 0) dtmp = argv[i];
   return dtmp;
   }
end


"min(x,y,...) - return the minimum of the arguments"

function{1} min(argv[argc])
abstract {
   return any_value
   }
body {
   int i;
   struct descrip dtmp;
   if (argc == 0) fail;
   dtmp = argv[0];
   if (argc == 1) {
      if (is:list(dtmp)) {
         int i, j, size;
         union block *bp;
         size = BlkD(dtmp,List)->size;
         if (size==0) fail;
#ifdef Arrays
         if (BlkD(dtmp,List)->listtail == NULL) {
            bp = BlkD(dtmp,List)->listhead;
            if (bp->Intarray.title == T_Intarray) {
               word mymin = bp->Intarray.a[0];
               for(i = 1; i < size; i++)
                  if (bp->Intarray.a[i] < mymin) mymin = bp->Intarray.a[i];
               return C_integer mymin;
               }
            else {
               double mymin = bp->Realarray.a[0];
               for(i = 1; i < size; i++)
                  if (bp->Realarray.a[i] < mymin) mymin = bp->Realarray.a[i];
               dtmp.dword = D_Real;
#ifdef DescriptorDouble
               dtmp.vword.realval = mymin;
#else                                   /* DescriptorDouble */
               dtmp.vword.bptr = (union block *)alcreal(mymin);
#endif                                  /* DescriptorDouble */
               return dtmp;
               }
            }

#endif
         /*
          * normal min(L), walk through list elements
          */
         bp = dtmp.vword.bptr;
         dtmp = nulldesc;
         for (bp = Blk(bp,List)->listhead; BlkType(bp) == T_Lelem;
              bp = Blk(bp,Lelem)->listnext) {
            for (i = 0; i < Blk(bp,Lelem)->nused; i++) {
               j = bp->Lelem.first + i;
               if (j >= bp->Lelem.nslots)
                  j -= bp->Lelem.nslots;
                  dtmp = bp->Lelem.lslots[j]; /* the minimal value for now */
                  break;break;
               }
            }

         for (bp = Blk(bp,List)->listhead; BlkType(bp) == T_Lelem;
              bp = Blk(bp,Lelem)->listnext) {
            for (i = 0; i < Blk(bp,Lelem)->nused; i++) {
               j = bp->Lelem.first + i;
               if (j >= bp->Lelem.nslots)
                  j -= bp->Lelem.nslots;
               if (anycmp(bp->Lelem.lslots+j, &dtmp) == Less)
                  dtmp = bp->Lelem.lslots[j];
               }
            }
         }
      }
   else
      for(i=1;i<argc;i++) if (anycmp(&dtmp, argv+i) > 0) dtmp = argv[i];
   return dtmp;
   }
end
