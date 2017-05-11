/*
 * tlex.c -- the lexical analyzer for icont.
 */

#include "../h/gsupport.h"
#include "../h/lexdef.h"
#include "tree.h"
#include "ttoken.h"
#include "tproto.h"

#include "../h/parserr.h"
#include "../common/lextab.h"
#include "../common/yylex.h"
#define SEPARATE_YYERROR
#include "../common/error.h"
