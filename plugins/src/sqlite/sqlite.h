/* ---------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 */
#include "../icall.h"


RTEX int SQLi_Init(UARGS);
RTEX int SQLi_libversion(UARGS);
RTEX int SQLi_libversion_number(UARGS);
RTEX int SQLi_errmsg(UARGS);
RTEX int SQLi_Error(UARGS);
RTEX int SQLi_open(UARGS);
RTEX int SQLi_close(UARGS);
RTEX int SQLi_prepare(UARGS);
RTEX int SQLi_bindArg(UARGS);
RTEX int SQLi_bind(UARGS);
RTEX int SQLi_step(UARGS);
RTEX int SQLi_finalize(UARGS);
RTEX int SQLi_column_count(UARGS);
RTEX int SQLi_column_type(UARGS);
RTEX int SQLi_column_name(UARGS);
RTEX int SQLi_column_string(UARGS);
RTEX int SQLi_column_integer(UARGS);
RTEX int SQLi_column_real(UARGS);
RTEX int SQLi_column(UARGS);
