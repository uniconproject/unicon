#include "icall.h"

rtentryvector rtfuncs;

static int is_inited;


RTEX int init(rtentryvector *rtev)
{
  if(!is_inited) {
    is_inited = 1;
    rtfuncs = *rtev;
    return 1;
    }
  return 0;
}
RTEX int destroy()
{
  return 0;
}
