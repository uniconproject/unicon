#host #define RTT_HOST_TEST 1
#host #if defined(__GNUC__)
#host #define RTT_HOST_COMPILER_SEES_GNUC 1
#host #endif

#host #define RTT_HOST_DIRECTIVE_PROBE 42

#rawc int rtt_raw_helper(void) { return RTT_HOST_TEST; }

int rtt_mixed_decl_test(void)
{
   int a = 1;
   a++;
   int b = a + 1;
   return b;
}
