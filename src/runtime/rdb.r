/*
 *
 * File: RDB.R
 *
 * -- error handler for FDB.R
 *
 */
 
#ifdef ISQL /* ODBC support */

#define BUFF_SZ      32768      /* 32Kb buffer size for C/S data transfer */
#define MAX_COL_NAME    64      /* max column name length    */
#define MAXTABLECOLS   256      /* try driver specific const */

int dbclose(struct ISQLFile *fp)
{
    if (SQLFreeStmt(fp->hstmt, SQL_DROP)!=SQL_SUCCESS) {
       odbcerror(FREE_STMT_ERR);
       return -1;
       }
      
    if (SQLDisconnect(fp->hdbc)!=SQL_SUCCESS) {
       odbcerror(DISCONNECT_ERR);
       return -1;
       }
      
    if (SQLFreeConnect(fp->hdbc)!=SQL_SUCCESS) {
       odbcerror(FREE_CONNECT_ERR);
       return -1;
       }
            
    free(fp->tablename);  /* release table name     */

    free(fp->query);      /* release query buffer   */
    fp->qsize = 0;        /* reset query buffer sz  */

    free(fp);             /* release file structure */
    return 0;
}

FILE *isql_open(char *db, dptr table, dptr user, dptr password)
{
   struct ISQLFile *fp = (struct ISQLFile *) malloc(sizeof(struct ISQLFile));
   if (fp == NULL) return NULL;

   if (ISQLEnv==NULL) {
      if (SQLAllocEnv(&ISQLEnv)!=SQL_SUCCESS) {
	 odbcerror(ALLOC_ENV_ERR);
	 return 0;
	 }

#if (ODBCVER >= 0x0300)
      SQLSetEnvAttr(ISQLEnv, SQL_ATTR_ODBC_VERSION, (SQLPOINTER) SQL_OV_ODBC3,
                    SQL_IS_INTEGER);
#endif					/* ODBCVER >= 0x0300 */
      }

   if (SQLAllocConnect(ISQLEnv, &(fp->hdbc))!=SQL_SUCCESS) {
      odbcerror(ALLOC_CONNECT_ERR);
      return 0;
      }

   if (SQLConnect(fp->hdbc,
		  db, (SQLSMALLINT)strlen(db), 
		  StrLoc(*user), (SQLSMALLINT)StrLen(*user),
		  StrLoc(*password), (SQLSMALLINT)StrLen(*password)) ==
       SQL_ERROR){
      odbcerror(CONNECT_ERR);
      return 0;
      }

   if (SQLAllocStmt(fp->hdbc, &(fp->hstmt))!=SQL_SUCCESS) {
      odbcerror(ALLOC_STMT_ERR);
      return 0;
      }

   fp->tablename=malloc(StrLen(*table)+1); /* allocate space for table name */
   strncpy(fp->tablename, StrLoc(*table), StrLen(*table));
   fp->tablename[StrLen(*table)]='\0';

   /* empty query buffer */
   fp->query=NULL;
   fp->qsize=0;
   return (FILE *) fp;
   }

int dbfetch(struct ISQLFile *fp, dptr pR)
{
    UWORD i, p;
    int rc;

    SWORD numcols;
    SWORD colsize;
    SDWORD colsz;  /* SQLGetData() wants an SDWORD */
    SDWORD len;
    
    char buff[BUFF_SZ]; /* data buffer */

    UCHAR colname[MAX_COL_NAME];
    SWORD SQLType;
    UDWORD typesize;
    SWORD scale;
    SWORD nullable;

    struct descrip fieldname[MAXTABLECOLS];
    
    /* record structures */
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    struct b_proc *proc;


    /* num columns in table */
    if (SQLNumResultCols(fp->hstmt, &numcols)!=SQL_SUCCESS) {
      odbcerror(NUM_RESULT_COLS_ERR);
      return Failed;
      }
    
    /* record field names */
    for (i=1; i<=numcols; i++) {
      p=i-1;
      rc=SQLDescribeCol(fp->hstmt, i, colname, MAX_COL_NAME, &colsize,
                       &SQLType, &typesize, &scale, &nullable);
      
      if (rc!=SQL_SUCCESS) {
        odbcerror(DESCRIBE_COL_ERR);
        return Failed;
      }
      
      len=strlen(colname);
      StrLoc(fieldname[p])=alcstr(colname, len);
      StrLen(fieldname[p])=len;
    }
   
    /* allocate record */

    proc=dynrecord(&rectypename, fieldname, numcols); 
    r = alcrecd(numcols, (union block *)proc);
    pR->dword=D_Record;
    pR->vword.bptr=(union block *) r;

    /* while data to retrieve */

    if (SQLFetch(fp->hstmt)!=SQL_SUCCESS) {
       odbcerror(FETCH_ERR);
       return Failed;
    }
     
    for(i=1; i<=numcols; i++) {
      SQLDescribeCol(fp->hstmt, i, colname, MAX_COL_NAME, &colsize,
                     &SQLType, &typesize, &scale, &nullable);

      rc=SQLGetData(fp->hstmt, i, SQL_C_CHAR, buff, BUFF_SZ, &colsz);

      /* if the column is NULL colsz=-1 */
      colsz=colsz>0?colsz:0; /* normalize colsz to prevent a crash! */

      p=i-1;

      switch (SQLType) {
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
            
          /* allocate column */
          StrLoc(r->fields[p])=colsz>0?alcstr(NULL, colsz):"";
          StrLen(r->fields[p])=colsz>0?colsz:0;
            
          /* copy buffer to column */
            
          len=colsz>BUFF_SZ?BUFF_SZ-1:colsz;
          memcpy(StrLoc(r->fields[p]), buff, len);
            
          /* still data to read (BLOBs) */
          while (rc==SQL_SUCCESS_WITH_INFO) {
            rc=SQLGetData(fp->hstmt, i, SQL_C_CHAR,
                          StrLoc(r->fields[p])+len, BUFF_SZ, &colsz);
            len+=colsz>BUFF_SZ?BUFF_SZ-1:colsz;
	    }
            
          break;

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
          BlkLoc(r->fields[p])=(union block *) alcreal(atof(buff));
          (r->fields[p]).dword=D_Real;
          break;

        default:
          /*
           * this is another data type that may occur so try to
           * convert it to string
           */

          /* allocate column */
          StrLoc(r->fields[p])=colsz>0?alcstr(NULL, colsz):"";
          StrLen(r->fields[p])=colsz>0?colsz:0;
            
          /* copy buffer to column */
            
          len=colsz>BUFF_SZ?BUFF_SZ-1:colsz;
          memcpy(StrLoc(r->fields[p]), buff, len);
            
          /* still data to read (BLOBs) */
          while (rc==SQL_SUCCESS_WITH_INFO) {
            rc=SQLGetData(fp->hstmt, i, SQL_C_CHAR,
                          StrLoc(r->fields[p])+len, BUFF_SZ, &colsz);
            len+=colsz>BUFF_SZ?BUFF_SZ-1:colsz;
	    }

          break;
	  } /* switch */
        
      } /* for */

   return Succeeded;
}


void odbcerror(int errno)
{
  /*
  char SQLState[6];
  char ErrMsg[SQL_MAX_MESSAGE_LENGTH];

  SDWORD NativeErr;
  SWORD  ErrMsgLen;
  
  SQLError(ISQLEnv, SQL_NULL_HDBC, hstmt, SQLState,&NativeErr,
           ErrMsg, SQL_MAX_MESSAGE_LENGTH-1, &ErrMsgLen);

  printf("*** %s ***\n", ErrMsg);
  
  */
  
  char *errmsg[]={
    "file is not ODBC", "cannot release statement",
    "cannot disconnect from database", "cannot release connection", 
    "cannot allocate statement", "cannot allocate environment",
    "cannot allocate connection", "cannot connect to database",
    "cannot exec SQL command", "cannot close cursor",
    "cannot get table columns", "cannot get table primary keys",
    "cannot determine number result columns","cannot get columns description",
    "cannot fetch data", "cannot get tables information", 
    "row has no key definition", "row has too many keys defined",
    "row is missing one or more table keys"
  };

  
  /* set Icon error constants */
  
  k_errornumber=errno;
  k_errortext=errmsg[errno-NOT_ODBC_FILE_ERR];
}

/* allocate memory for query buffer */
void qalloc(struct ISQLFile *f, long n)
{
  if (f->qsize < n) { /* not enough buffer space */
    f->qsize = n;
    f->query = (char *) realloc(f->query, n); /* enlarge buffer */
  }
}

#else					/* ISQL */
static int nothing;
#endif					/* ISQL */
