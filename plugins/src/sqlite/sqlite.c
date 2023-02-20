/* ---------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 * ---------------------------------------------------------------------------
 * The C interface that connects Unicon programs to the SQLite code.
 *
 *     Don Ward     July 2020
 *
 * There are 300 or so individual SQlite functions in the API.
 * They aren't all here, but it should be reasonably simple to use
 * one of the functions here as a template to add a missing function.
 *
 *----------------------------------------------------------------------
 */
#include "../icall.h"
/*
 * sqlite3.h (which contains the definitions for the API of SQLite version 3
 * https://sqlite.org/index.html) is required.
 * If the file is not found, building of the sqlite plugin is not attempted.
 * In that case, you will need to install it along with the SQLite shared library.
 *    On Debian systems, something like
 *        apt-get install libsqlite3-dev
 *    will probably do the trick.
 * If the header file and/or the sqlite3 shared library are not installed, and
 * cannot be downloaded as a pre-built package for your system, an alternative is to
 * download the source files directly from the SQLite website and build them locally.
 */
#include <sqlite3.h>

#define FLOG(fmt, ...) do {fprintf(stderr, fmt, ##__VA_ARGS__); fflush(stderr);} while (0)

typedef struct sql3ExtDb{ /* external block for SQLite handle*/
  word title;             /*  T_External */
  word blksize;           /*  size of block */
  sqlite3 *db;            /*  SQLite3 db handle */
} sql3ExtDb;

typedef struct sql3ExtSt{ /* external block for SQLite prepared statement*/
  word title;             /*  T_External */
  word blksize;           /*  size of block */
  sqlite3_stmt *st;       /*  SQLite3 prepared statement */
} sql3ExtSt;

static int sqlAns;              /* ToDo: Not threadsafe */
static int colOff;              /* column number adjustment */

/*------------------------------------------------------------*/
void *SQLi_Log(void *p, int err, const char *mess)
{
  FLOG("SQLi_Log: %d %s\n", err,mess);
  return NULL;
}

#ifdef OWN_HEAP
/*------------------------------------------------------------------------------
 * SQLite uses malloc(), a lot. To avoid any unpleasantness between the Unicon
 * garbage collector and SQLite (if GC moves stuff around) we can configure
 * SQLite to use a fixed block of memory. It shouldn't be necessary because
 * Unicon code points to SQLite structures (using ptrs in  External blocks) not
 * the other way around. When GC happens, the external blocks might move, but
 * the contents -- the pointers to SQLite structures -- won't change.
 *
 * ToDo: Investigate why 255*1024*1024 works but 256*1024*1024 gets passed to
 *       sqlite3_config as 0 (and then fails later with "out of memory").
 *       i.e. why is the size parameter only 32 bit?
 *
 *       The answer appears to be "it just is".  Perhaps for portability between
 *       32 and 64 bit platforms or, maybe, for backwards compatibility.
 *
 *       So, if 255Mib is not enough, consider using SQLITE_CONFIG_PAGECACHE to
 *       supply some more memory for the page cache (and maybe reduce the size
 *       of heap to compensate).
 */
static word heap[255*1024*1024]; /* Make sure sizeof(heap) fits in 32 bits */
#endif

/*----------------------------------------------------------------------
 * This procedure should be called once, before any other SQLi_ proc
 * The interface code (sqLite.icn) does this automatically (with a null param).
 *
 * To get column numbers starting from 0, rather than 1, call this procedure
 * with a non null parameter before calling any other SQLi_ proc
 */
RTEX int SQLi_Init(int argc, descriptor argv[])
{

  /* ToDo: add other customisations? */
  if (argv[1].dword == D_Null) {
    /* FLOG("SQLi_Init()\n"); */
    colOff = -1;      /* Default column adjustment: 1st col = 1*/
  } else {
    FLOG("SQLi_Init( ... )\n");
    /* Leave column numbering as zero based */
  }


  sqlAns = sqlite3_config(SQLITE_CONFIG_LOG, SQLi_Log, NULL);
  if (sqlAns != SQLITE_OK) {
    FLOG("sqlite3_config(SQLITE_CONFIG_LOG) failed <%s>\n", sqlite3_errstr(sqlAns));
  }

#ifdef OWN_HEAP
  sqlAns = sqlite3_config(SQLITE_CONFIG_HEAP, heap, sizeof(heap), 64);
  if (sqlAns != SQLITE_OK) {
    FLOG("sqlite3_config(SQLITE_CONFIG_HEAP) failed <%s>\n",sqlite3_errstr(sqlAns));
  }
#endif

  RetNull();                    /* Success */
}

/*------------------------------------------------------------*/
RTEX int SQLi_libversion(int argc, descriptor argv[])
{
  RetConstString((char *)sqlite3_libversion());
}

/*------------------------------------------------------------*/
RTEX int SQLi_libversion_number(int argc, descriptor argv[])
{
  RetInteger(sqlite3_libversion_number());
}

RTEX int SQLi_errmsg(int argc, descriptor argv[])
{
  sqlite3 **sqlDB;

  ArgExternal(1);             /* The database Extern block */
  sqlDB = (sqlite3 **)ExternAddr(argv[1]);

  RetString((char *)sqlite3_errmsg(*sqlDB));
}

/*------------------------------------------------------------*/
RTEX int SQLi_Error(int argc, descriptor argv[])
{
  RetString((char *)sqlite3_errstr(sqlAns));
}

/*------------------------------------------------------------*/
RTEX int SQLi_open(int argc, descriptor argv[])
{
  sql3ExtDb *sqlDB;

  ArgString(1);                 /* Database name */
  ArgString(2);                 /* Database mode */
  mkExternal((void *)(sqlDB = malloc(sizeof(sql3ExtDb))), sizeof(sql3ExtDb));

  sqlAns = sqlite3_open_v2(StringVal(argv[1]),
                           &sqlDB->db,
                           (StringVal(argv[2])[0]=='b'
                            ? SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE
                            : SQLITE_OPEN_READONLY),
                           NULL);

  if (sqlAns == SQLITE_OK) {
    RetExternal(sqlDB);
  } else {
    FLOG("SQLi_open: error \"%s\"\n", sqlite3_errstr(sqlAns));
    free(sqlDB);
    Fail;
  }
}

/*------------------------------------------------------------*/
RTEX int SQLi_close(int argc, descriptor argv[])
{
  sqlite3 **sqlDB;
  ArgExternal(1);               /* The database handle */
  sqlDB = ExternAddr(argv[1]);
  (void) sqlite3_close_v2(*sqlDB); /* ignore return status */

  *sqlDB = NULL;                   /* In case it is closed twice */
  Return;
}

/*------------------------------------------------------------*/
RTEX int SQLi_prepare(int argc, descriptor argv[])
{
  sqlite3 **sqlDB;
  char *sqlText;
  sqlite3_stmt *sqlStmnt;

  ArgExternal(1);               /* The database handle */
  sqlDB = ExternAddr(argv[1]);

  ArgString(2);                 /* The SQL statement */
  sqlText = StringVal(argv[2]);

  sqlAns = sqlite3_prepare_v2(*sqlDB,     /* database handle */
                              sqlText,    /* sql statement */
                              -1,         /* let SQLite determine strlen */
                              &sqlStmnt,  /* OUT: prepared statement */
                              NULL);      /* Don't care about trailing text */
  if (sqlAns == SQLITE_OK) {
    sql3ExtSt *ans;
    mkExternal((void *)(ans = malloc(sizeof(sql3ExtSt))), sizeof(sql3ExtSt));
    ans->st = sqlStmnt;
    RetExternal(ans);
  } else {
    FLOG("SQLi_prepare: error %d \"%s\"\n", sqlAns, sqlite3_errstr(sqlAns));
    Fail;
  }
}
/*------------------------------------------------------------*/
/* Bind a single parameter to the specified column            */
RTEX int SQLi_bindArg(int argc, descriptor argv[])
{
  sqlite3_stmt **sqlStmnt;
  int col;

  ArgExternal(1);               /* The prepared statement */
  sqlStmnt = ExternAddr(argv[1]);

  ArgInteger(2);                /* The parameter number */
  col = IntegerVal(argv[2]);
  switch (IconType(argv[3])) {
  default:
    Fail;

  case 'n':                 /* NULL */
    sqlAns = sqlite3_bind_null(*sqlStmnt, col);
    if (SQLITE_OK != sqlAns) { Fail; }
    break;

  case 'i':                 /* integer */
    ArgInteger(3);
    sqlAns = sqlite3_bind_int64(*sqlStmnt, col, IntegerVal(argv[3]));
    if (SQLITE_OK != sqlAns) { Fail; }
    break;

  case 'r':                 /* real */
    ArgReal(3);
    sqlAns = sqlite3_bind_double(*sqlStmnt, col, RealVal(argv[3]));
    if (SQLITE_OK != sqlAns) { Fail; }
    break;

    /*
     * Note that the order of evaluation of parameters is not defined.
     * StringVal (sometimes) alters the length of the string, so something like
     *      sqlite3_bind_text( ... StringVal(x), StringLen(x), ... )
     * isn't safe.
     */
  case 's':                 /* string */
    {
      char *sv;
      int sl;

      ArgString(3);
      /* There is a subtle logic to the next two lines of code:
       *   StringVal sometimes adds 1 to the length of the string (if it
       *   isn't followed by a trailing nul, StringVal uses cnv_c_str() to
       *   allocate a new nul-terminated string, which is one character longer).
       *   However, we want the size of the original string to pass to SQLite.
       *   Instead of testing whether the last character of the string
       *   contains a null and, if so, decrementing the length, we obtain
       *   the string length *before* the call to StringVal().
       */
      sl = StringLen(argv[3]);
      sv = StringVal(argv[3]);
      sqlAns = sqlite3_bind_text(*sqlStmnt, col, sv, sl, SQLITE_STATIC);
      if (SQLITE_OK != sqlAns) { Fail; }
    }
    break;

  case 'a':                 /* Integer array */
  case 'A':                 /* real array */
    /* ToDo: */
    break;

  case 'E':                 /* External */
    /* ToDo: */
    break;
  }
  Return;                     /* Success */
}

/*------------------------------------------------------------*/
/* Bind a series of parameters starting from column 1         */
RTEX int SQLi_bind(int argc, descriptor argv[])
{
  sqlite3_stmt **sqlStmnt;

  ArgExternal(1);               /* The prepared statement */
  sqlStmnt = ExternAddr(argv[1]);

  if (argc >= 2)
    {
      int col;
      int sl[argc+1];
      char *throwaway;

      /* StringVal() might cause a garbage collection. If that happens in the middle of
       * binding parameters, previously bound string parameters may be in a different
       * place. So we do all of the StringVal processing before binding any parameters,
       * and call StringVal again when binding. On the second pass GC cannot occur.
       */

      for (col = 1; col < argc; ++col) /* 1st pass */
        {
          if ('s' == IconType(argv[col+1]))
            {
              ArgString(col+1);
              /* There is a subtle logic to the next two lines of code:
               *   StringVal sometimes adds 1 to the length of the string (if it
               *   isn't followed by a trailing nul, StringVal uses cnv_c_str() to
               *   allocate a new nul-terminated string, which is one character longer).
               *   However, we want the size of the original string to pass to SQLite.
               *   Instead of testing whether the last character of the string
               *   contains a null and, if so, decrementing the length, we obtain
               *   the string length *before* the call to StringVal().
               */
              sl[col] = StringLen(argv[col+1]);
              throwaway = StringVal(argv[col+1]); /* GC might happen here */
            }
        }

      for (col = 1; col < argc; ++col) /* 2nd pass */
        {
          switch (IconType(argv[col+1])) {
          default:
            Fail;

          case 'n':                 /* NULL */
            sqlAns = sqlite3_bind_null(*sqlStmnt, col);
            break;

          case 'i':                 /* integer */
            ArgInteger(col+1);
            sqlAns = sqlite3_bind_int64(*sqlStmnt, col, IntegerVal(argv[col+1]));
            break;

          case 'r':                 /* real */
            ArgReal(col+1);
            sqlAns = sqlite3_bind_double(*sqlStmnt, col, RealVal(argv[col+1]));
            break;

          case 's':                 /* string */
            sqlAns = sqlite3_bind_text(*sqlStmnt, col, StringVal(argv[col+1]), sl[col], SQLITE_STATIC);
            break;

          case 'a':                 /* Integer array */
          case 'A':                 /* real array */
            /* ToDo: */
            break;

          case 'E':                 /* External */
            /* ToDo: */
            break;
          }
          if (SQLITE_OK != sqlAns) { Fail; }
        }
      Return;                     /* Success */
    }
  Fail;
}


/*------------------------------------------------------------*/
RTEX int SQLi_step(int argc, descriptor argv[])
{
  sqlite3_stmt **sqlStmnt;

  ArgExternal(1);               /* The prepared statement */
  sqlStmnt = ExternAddr(argv[1]);
  ArgInteger(2);                /* The expectBusy flag */

  sqlAns = sqlite3_step(*sqlStmnt);
  if ((sqlAns > 0)
      && (sqlAns != SQLITE_ROW)
      && (sqlAns != SQLITE_DONE)
      ) {
    if ((sqlAns != SQLITE_BUSY) || (IntegerVal(argv[2])==0)) {
      FLOG("SQLi_step: error %d \"%s\"\n", sqlAns, sqlite3_errstr(sqlAns));
    }
  }
  RetInteger(sqlAns);
}

/*------------------------------------------------------------*/
RTEX int SQLi_finalize(int argc, descriptor argv[])
{
  sqlite3_stmt **sqlStmnt;

  ArgExternal(1);               /* The prepared statement */
  sqlStmnt = ExternAddr(argv[1]);

  sqlAns = sqlite3_finalize(*sqlStmnt);

  /* sqlite3_finalize() returns the last error (if any) from the
   * statement but, in any case, it WILL have been destroyed.
   * We fail, so the caller can collect the last status, if needed.
   */
  if (sqlAns == SQLITE_OK) { RetNull(); } else { Fail; }
}

/*------------------------------------------------------------*/
RTEX int SQLi_column_count(int argc, descriptor argv[])
{
  sqlite3_stmt **sqlStmnt;

  ArgExternal(1);               /* The prepared statement */
  sqlStmnt = ExternAddr(argv[1]);

  RetInteger(sqlite3_column_count(*sqlStmnt));
}

/*------------------------------------------------------------*/
RTEX int SQLi_column_type(int argc, descriptor argv[])
{
  sqlite3_stmt **sqlStmnt;
  long col;

  ArgExternal(1);               /* The prepared statement */
  sqlStmnt = ExternAddr(argv[1]);

  ArgInteger(2);                /* The column number */
  col = colOff + IntegerVal(argv[2]);

  RetInteger(sqlite3_column_type(*sqlStmnt,col));
}

/*------------------------------------------------------------*/
RTEX int SQLi_column_name(int argc, descriptor argv[])
{
  sqlite3_stmt **sqlStmnt;
  long col;
  const char *ans;

  ArgExternal(1);               /* The prepared statement */
  sqlStmnt = ExternAddr(argv[1]);

  ArgInteger(2);                /* The column number */
  col = colOff + IntegerVal(argv[2]);

  ans = sqlite3_column_name(*sqlStmnt,col);
  RetString((char *)ans);
}

/*------------------------------------------------------------*/
RTEX int SQLi_column_string(int argc, descriptor argv[])
{
  sqlite3_stmt **sqlStmnt;
  long col;
  const unsigned char *ans;

  ArgExternal(1);               /* The prepared statement */
  sqlStmnt = ExternAddr(argv[1]);

  ArgInteger(2);                /* The column number */
  col = colOff + IntegerVal(argv[2]);

  ans = sqlite3_column_text(*sqlStmnt,col);
  RetString((char *)ans);
}

/*------------------------------------------------------------*/
RTEX int SQLi_column_integer(int argc, descriptor argv[])
{
  sqlite3_stmt **sqlStmnt;
  long col;

  ArgExternal(1);               /* The prepared statement */
  sqlStmnt = ExternAddr(argv[1]);

  ArgInteger(2);                /* The column number */
  col = colOff + IntegerVal(argv[2]);

  RetInteger(sqlite3_column_int64(*sqlStmnt,col));
}

/*------------------------------------------------------------*/
RTEX int SQLi_column_real(int argc, descriptor argv[])
{
  sqlite3_stmt **sqlStmnt;
  long col;

  ArgExternal(1);               /* The prepared statement */
  sqlStmnt = ExternAddr(argv[1]);

  ArgInteger(2);                /* The column number */
  col = colOff + IntegerVal(argv[2]);

  RetReal(sqlite3_column_double(*sqlStmnt,col));
}

/*------------------------------------------------------------*/
RTEX int SQLi_column(int argc, descriptor argv[])
{
  sqlite3_stmt **sqlStmnt;
  long col;

  ArgExternal(1);               /* The prepared statement */
  sqlStmnt = ExternAddr(argv[1]);

  ArgInteger(2);                /* The column number */
  col = colOff + IntegerVal(argv[2]);

  switch(sqlite3_column_type(*sqlStmnt,col))
  {
    case SQLITE_INTEGER: {
      RetInteger(sqlite3_column_int64(*sqlStmnt,col));
    }

    case SQLITE_FLOAT: {
      RetReal(sqlite3_column_double(*sqlStmnt,col));
    }

    case SQLITE_TEXT: {
      const unsigned char *ans;
      ans = sqlite3_column_text(*sqlStmnt,col);
      RetString((char *)ans)
    }

    case SQLITE_BLOB: {
      /* ToDo: */
    }

    case SQLITE_NULL: {
      RetNull();
    }
  }
  Fail;
}

#if 0
const void *sqlite3_column_blob(sqlite3_stmt*, int iCol);
int sqlite3_column_bytes(sqlite3_stmt*, int iCol);
int sqlite3_column_bytes16(sqlite3_stmt*, int iCol);
#endif

