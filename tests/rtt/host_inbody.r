/*
 * #host directives inside function bodies must come out where they are
 * written, not ahead of the function.
 */

#host #define HOST_TOP_LEVEL 1

int host_switch(int t)
{
   int m = 0;
   switch (t) {
#host #if HOST_PROBE >= 3
      case 1: m = 3; break;
#host #else
      case 1: m = 1; break;
#host #endif
      case 2: m = 2; break;
      }
   return m;
}

/*
 * Declarations may be guarded too.  RTT still parses both branches, so
 * the same name cannot be declared in each (RTT reports a redefinition).
 */
int host_decls(int n)
{
#host #if HOST_PROBE >= 3
   int k3 = 3;
#host #else
   long k1 = 1;
#host #endif
   n += 1;
   return n;
}

"host_rtl(x) - RTL body with an in-body #host guard"

function{1} host_rtl(x)
   abstract {
      return integer
      }
   body {
      C_integer v;
#host #if HOST_PROBE >= 3
      v = 3;
#host #else
      v = 1;
#host #endif
      return C_integer v;
      }
end

"host_inl(x) - RTL inline clause with an in-body #host guard (iconc rt.db)"

function{1} host_inl(x)
   abstract {
      return integer
      }
   inline {
      C_integer w;
#host #if HOST_PROBE >= 3
      w = 3;
#host #else
      w = 1;
#host #endif
      return C_integer w;
      }
end
