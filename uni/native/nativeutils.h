#ifndef NATIVE_UTILS_H
#define NATIVE_UTILS_H

#include "rt.h"

extern struct descrip create_list(int n, dptr d);
extern struct descrip create_empty_list();
extern struct descrip create_string(char *s);
extern struct descrip create_string2(char *s, int len);

#endif
