/* Write a unicon procedure that reflects whether NoConcurrentCOMPILER has been defined */
#include <stdio.h>
#include "auto.h"

int main(void)
{
  puts("procedure NoConcurrentCOMPILER()");
#ifdef NoConcurrentCOMPILER
  puts("   return   # NoConcurrentCOMPILER is defined in auto.h");
#else
  puts("   fail     # NoConcurrentCOMPILER is not defined in auto.h");
#endif
  puts("end");
  return 0;    /* Success */
}
