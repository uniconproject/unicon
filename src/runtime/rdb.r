/*
 * File: rdb.r
 *  Contents: dbclose, isql_open, dbfetch, odbcerror, qalloc
 */

#ifdef ISQL

#define BUFF_SZ      32768      /* 32Kb buffer size for C/S data transfer */
#define MAX_COL_NAME   128      /* max column name length    */

struct ISQLFile *isqlfiles;

int dbclose(struct ISQLFile *fp)
{
    if (SQLFreeStmt(fp->hstmt, SQL_DROP)!=SQL_SUCCESS) {
       odbcerror(fp, FREE_STMT_ERR);
       return -1;
       }

    if (SQLDisconnect(fp->hdbc)!=SQL_SUCCESS) {
       odbcerror(fp, DISCONNECT_ERR);
       return -1;
       }

    if (SQLFreeConnect(fp->hdbc)!=SQL_SUCCESS) {
       odbcerror(fp, FREE_CONNECT_ERR);
       return -1;
       }

    if (fp->tablename) {
       free(fp->tablename);  /* release table name     */
       fp->tablename = NULL;
       }

    if (fp->query) {
       free(fp->query);      /* release query buffer   */
       fp->query = NULL;
       }
    fp->qsize = 0;        /* reset query buffer sz  */

    GRFX_UNLINK(fp, isqlfiles);
    return 0;
}

FILE *isql_open(char *db, dptr table, dptr user, dptr password)
{
   struct ISQLFile *fp = NULL;
   CURTSTATE();

   GRFX_ALLOC(fp, ISQLFile);

   /* initialize DB connection and statement handlers */
   fp->hdbc = SQL_NULL_HDBC;
   fp->hstmt = SQL_NULL_HSTMT;

   if (ISQLEnv==NULL) {
      ISQLEnv=SQL_NULL_HENV;
      if (SQLAllocEnv(&ISQLEnv)!=SQL_SUCCESS) {
         odbcerror(fp, ALLOC_ENV_ERR);
isql_open_fail:
         free(fp);
         return 0;
         }

#passthru #if (ODBCVER >= 0x0300)
      SQLSetEnvAttr(ISQLEnv, SQL_ATTR_ODBC_VERSION, (SQLPOINTER) SQL_OV_ODBC3,
                    SQL_IS_INTEGER);
#passthru #endif                                        /* ODBCVER >= 0x0300 */
      }

   if (SQLAllocConnect(ISQLEnv, &(fp->hdbc))!=SQL_SUCCESS) {
      odbcerror(fp, ALLOC_CONNECT_ERR);
      goto isql_open_fail;
      }

   if (SQLConnect(fp->hdbc,
                  (SQLCHAR *) db, (SQLSMALLINT)strlen(db),
                  (SQLCHAR *) StrLoc(*user), (SQLSMALLINT)StrLen(*user),
                  (SQLCHAR *) StrLoc(*password), (SQLSMALLINT)StrLen(*password)) ==
       SQL_ERROR){
      odbcerror(fp, CONNECT_ERR);
failed_connect:
      SQLFreeConnect(fp->hdbc);
      goto isql_open_fail;
      }

   if (SQLAllocStmt(fp->hdbc, &(fp->hstmt))!=SQL_SUCCESS) {
      odbcerror(fp, ALLOC_STMT_ERR);
      goto failed_connect;
      }

   if (table) { /* allocate space for table name */
      if ((fp->tablename=malloc(StrLen(*table)+1)) == NULL) {
          if (SQLFreeStmt(fp->hstmt, SQL_DROP)!=SQL_SUCCESS) {
             odbcerror(fp, FREE_STMT_ERR);
             }
         goto failed_connect;
         }
      strncpy(fp->tablename, StrLoc(*table), StrLen(*table));
      fp->tablename[StrLen(*table)]='\0';
      }
   else fp->tablename = NULL;

   /* empty query buffer */
   fp->query=NULL;
   fp->qsize=0;
   GRFX_LINK(fp, isqlfiles);
   return (FILE *) fp;
   }

int dbfetch(struct ISQLFile *fp, dptr pR)
{
   UWORD i, p;
   int rc;
   SWORD numcols, colsize;

   /*
    * SQLINTEGER, SQLLEN, or SDWORD? Depending on ODBC version and doc
    * you read.  SQLLEN tried, and did not magically fix on AMD64.
    */
   SQLLEN colsz, len;
   SQLULEN typesize;
   char buff[BUFF_SZ*2]; /* data buffer */
   UCHAR colname[MAX_COL_NAME+1];
   SWORD SQLType, scale, nullable;
   struct descrip *fieldname;

   /* record structures */
   tended struct descrip rectypename=emptystr;
   tended struct b_record *r;

   /* num columns in table */
   if (SQLNumResultCols(fp->hstmt, &numcols)!=SQL_SUCCESS) {
      odbcerror(fp, NUM_RESULT_COLS_ERR);
      return Failed;
      }

   Protect(reserve(Blocks, sizeof (struct b_record)+(numcols-1)*sizeof(struct descrip)), return RunError);

   if (fp->proc == NULL) {
      Protect(reserve(Strings, MAX_COL_NAME * numcols), return RunError);
      fieldname = malloc(numcols * sizeof(struct descrip));
      if (fieldname == NULL) {
         t_errornumber = 305;
         t_errorvalue = nulldesc;
         t_have_val = 0;
         return RunError;
         }
      /* record field names */
      for (i=1; i<=numcols; i++) {
         p=i-1;
         rc=SQLDescribeCol(fp->hstmt, i, colname, MAX_COL_NAME, &colsize,
                           &SQLType, &typesize, &scale, &nullable);
         if (rc!=SQL_SUCCESS) {
            odbcerror(fp, DESCRIBE_COL_ERR);
            free(fieldname);
            return Failed;
            }
         if (colsize >= MAX_COL_NAME-1) printf("column name size exceeded\n");
         StrLoc(fieldname[p]) = alcstr((char *) colname, colsize);
         StrLen(fieldname[p]) = colsize;
         }
      /* allocate record */
      fp->proc = dynrecord(&rectypename, fieldname, numcols);
      free(fieldname);
      if (fp->proc==NULL) {
         t_errornumber = 305;
         t_errorvalue = nulldesc;
         t_have_val = 0;
         return RunError;
         }
      }

    r = alcrecd(numcols, (union block *)(fp->proc));
    if (r==NULL) {
       t_errornumber = 307;
       t_errorvalue = nulldesc;
       t_have_val = 0;
       return RunError;
       }
    pR->dword=D_Record;
    pR->vword.bptr=(union block *) r;

    /* while data to retrieve */

    if (SQLFetch(fp->hstmt)!=SQL_SUCCESS) {
       odbcerror(fp, FETCH_ERR);
       return Failed;
    }

    for(i=1; i<=numcols; i++) {
      SQLDescribeCol(fp->hstmt, i, colname, MAX_COL_NAME, &colsize,
                     &SQLType, &typesize, &scale, &nullable);

      rc = SQLGetData(fp->hstmt, i, SQL_C_CHAR, buff, BUFF_SZ, &colsz);

#if WordBits == 64
      /*
       * On Fedora Core 3 AMD64, SQLGetData seems to be filling
       * in the least-significant 32-bits of colsz.  This workaround
       * might be a bad idea on some platforms.
       */
      colsz = (long)(int) (colsz & 0xFFFFFFFF);
#endif                                  /* WordBits == 64 */

      /*
       * reserve contiguous space for this column
       */
      Protect(reserve(Strings, colsz), return RunError);

      /* if the column is NULL colsz=-1 */
      colsz = colsz>0?colsz:0; /* normalize colsz to prevent a crash! */
      p = i-1;

      switch (SQLType) {
        case SQL_BIT:
        case SQL_INTEGER:
        /* SQL_BIGINT (64 bits)*/
        case SQL_SMALLINT:
        case SQL_TINYINT:
          MakeInt(atol(buff),&(r->fields[p]));
          break;

        case SQL_DOUBLE:
        case SQL_FLOAT:
        case SQL_REAL:
#ifdef DescriptorDouble
          r->fields[p].vword.realval = atof(buff);
#else                                   /* DescriptorDouble */
          BlkLoc(r->fields[p])=(union block *) alcreal(atof(buff));
#endif                                  /* DescriptorDouble */
          (r->fields[p]).dword=D_Real;
          break;

        case SQL_CHAR:
        case SQL_VARCHAR:
        case SQL_LONGVARCHAR:
        case SQL_BINARY:
        case SQL_VARBINARY:
        case SQL_LONGVARBINARY:
        case SQL_DECIMAL:
        case SQL_NUMERIC:
        case SQL_DATE:
        case SQL_TIME:
        case SQL_TIMESTAMP:
        default:
          /*
           * for all other data types, try to convert it to string
           */
          /* allocate column */
          StrLoc(r->fields[p])=colsz>0?alcstr(NULL, colsz+1):"";
          if (StrLoc(r->fields[p])==NULL) {
             t_errornumber = 306;
             t_errorvalue = nulldesc;
             t_have_val = 0;
             return RunError;
             /* used to return Failed for strange types */
             }
          StrLen(r->fields[p])=colsz>0?colsz:0;

          /* copy buffer to column */

          len=colsz>BUFF_SZ?BUFF_SZ-1:colsz;
          memcpy(StrLoc(r->fields[p]), buff, len);

{int tot = colsz;
          /* still data to read (BLOBs) */
/*          while (rc==SQL_SUCCESS_WITH_INFO) { */
          while (colsz > 0 && len < tot) {
            rc=SQLGetData(fp->hstmt, i, SQL_C_CHAR,
                          StrLoc(r->fields[p])+len-1, BUFF_SZ, &colsz);
#if WordBits == 64
            /*
             * On Fedora Core 3 AMD64, SQLGetData seems to be filling
             * in the least-significant 32-bits of colsz.  This workaround
             * might be a bad idea on some platforms.
             */
            colsz = (long)(int) (colsz & 0xFFFFFFFF);
#endif                                  /* WordBits == 64 */
            len+=colsz>BUFF_SZ?BUFF_SZ-2:colsz;
            }
          break;
          } /* switch */
}

      } /* for */
   return Succeeded;
}


void odbcerror(struct ISQLFile *fp, int errornum)
{
   SQLCHAR  SQLState[6];
   static char ErrMsg[SQL_MAX_MESSAGE_LENGTH]; /* FIXME: static! */
   SQLINTEGER NativeErr;
   SWORD  ErrMsgLen;

   char *errmsg[]={
      "file is not ODBC", "cannot release statement",
      "cannot disconnect from database", "cannot release connection",
      "cannot allocate statement", "cannot allocate environment",
      "cannot allocate connection", "cannot connect to database",
      "cannot exec SQL command", "cannot close cursor",
      "cannot get table columns", "cannot get table primary keys",
      "cannot determine number result columns",
      "cannot get columns description", "cannot fetch data",
      "cannot get tables information", "row has no key definition",
      "row has too many keys defined", "row is missing one or more table keys"
      };
   CURTSTATE();

   k_errornumber=errornum;
   if (fp && (SQLError(ISQLEnv, fp->hdbc, fp->hstmt, SQLState, &NativeErr,
                       (SQLCHAR *) ErrMsg, SQL_MAX_MESSAGE_LENGTH-1, &ErrMsgLen) !=
              SQL_NO_DATA_FOUND)) {
      StrLoc(k_errortext) = alcstr(ErrMsg, ErrMsgLen);
      StrLen(k_errortext) = ErrMsgLen;
      }
   else {
      if (errornum - NOT_ODBC_FILE_ERR < sizeof(errmsg)/sizeof(char *))
         StrLoc(k_errortext)=errmsg[errornum-NOT_ODBC_FILE_ERR];
      else StrLoc(k_errortext) = "unidentified odbc error";
      StrLen(k_errortext)=strlen(StrLoc(k_errortext));
      }
}

#else                                   /* ISQL */
/* static char junk ; */
#endif                                  /* ISQL */
