/*
 *
 * IODBC - Unicon ODBC Interface
 *
 * Federico Balbi - fbalbi@cs.utsa.edu
 *
 * Origin Date:  07/22/1999
 *
 * Latest Revision: 07/13/2000
 *
 * File:  FDB.R
 *
 * -- Unicon ODBC support functions (2.x compliant)
 *
 * dbcolumns, dbdelete, dbinsert, dbkeys,
 * dbselect, dbsql, dbtables, dbupdate
 */

#ifdef ISQL                     /* ODBC support */

SQLHENV ISQLEnv=NULL;           /* global environment variable */

#define STR_LEN        128+1
#define REM_LEN        128+1
#define BUFF_SZ      32768      /* 32Kb buffer size for C/S data transfer */
#define MAX_COL_NAME    64      /* max column name length    */
#define MAXTABLECOLS   256      /* try driver specific const */

/*-- catalog functions ODBC 2.x compliant --*/

#define DBCOLNCOLS      12      /* dbcolumns() rowset columns */
#define DBKEYSNCOLS      2      /* dbkeys()    rowset columns */
#define DBTBLNCOLS       5      /* dbtables()  rowset columns */
#define DBDRVNCOLS       6      /* dbdriver()  rowset columns */
#define DBPRODNCOLS      2      /* dbproduct() rowset columns */
#define DBLIMITSNCOLS   19      /* dblimits()  rowset columns */

#define TAB_LEN SQL_MAX_TABLE_NAME_LEN+1
#define COL_LEN SQL_MAX_COLUMN_NAME_LEN+1

/* hate long names... */
#define RFNAME     BlkLoc(rec)->record.recdesc->proc.lnames /* field name       */
#define RFVAL      BlkLoc(rec)->record.fields               /* field value      */

#define FSTATUS(f) BlkLoc(f)->file.status                   /* file status      */
#define FDESC(f)   (struct ISQLFile *) BlkLoc(f)->file.fd   /* file description */


/*-- functions implementation --*/

"dbcolumns(f) - get information about an ODBC file column"
function{0,1} dbcolumns(f)
  if !is:file(f) then runerr(105, f)   /* f is not a file */

  abstract {
    return list
  }

  body {

    struct descrip fieldname[DBCOLNCOLS]; /* record field names */

    tended struct descrip R;
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    struct b_proc *proc;
    
    /* list declarations */
    tended struct descrip L;
    tended struct b_list *hp;
    
    struct ISQLFile *fp;
    
    /* result set data buffers */

    SQLCHAR szCatalog[STR_LEN], szSchema[STR_LEN];
    SQLCHAR szTableName[STR_LEN], szColumnName[STR_LEN];
    SQLCHAR szTypeName[STR_LEN], szRemarks[REM_LEN];
    SQLINTEGER ColumnSize, BufferLength;
    SQLSMALLINT DataType, DecimalDigits, NumPrecRadix, Nullable;
   
    SQLRETURN retcode;
    
    short i;

    /* buffers for bytes available to return */

    SQLINTEGER cbCatalog, cbSchema, cbTableName, cbColumnName;
    SQLINTEGER cbDataType, cbTypeName, cbColumnSize, cbBufferLength;
    SQLINTEGER cbDecimalDigits, cbNumPrecRadix, cbNullable, cbRemarks;
    
    HSTMT hstmt;
    
    char *colname[DBCOLNCOLS]={
      "catalog", "schema", "tablename", "colname","datatype", "typename", 
      "colsize", "buflen", "decdigits", "numprecradix", "nullable", "remarks"
    };
    

    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* ODBC file */
      runerr(NOT_ODBC_FILE_ERR, f);
    }

    fp=FDESC(f); /* file descriptor */

    if (SQLAllocStmt(fp->hdbc, &hstmt)==SQL_ERROR) {
      odbcerror(ALLOC_STMT_ERR);
      fail;
    }

    retcode=SQLColumns(hstmt,      
                       NULL, 0,                /* all catalogs */
                       NULL, 0,                /* all schemas */
                       fp->tablename, SQL_NTS, /* table */
                       NULL, 0);               /* All columns */

    if (retcode!=SQL_SUCCESS) {
      odbcerror(COLUMNS_ERR);
      fail;
    }
        
    /* bind columns in result set to buffer (ODBC 3.x) */

    SQLBindCol(hstmt, 1, SQL_C_CHAR, szCatalog, STR_LEN, &cbCatalog);
    SQLBindCol(hstmt, 2, SQL_C_CHAR, szSchema, STR_LEN, &cbSchema);
    SQLBindCol(hstmt, 3, SQL_C_CHAR, szTableName, STR_LEN, &cbTableName);
    SQLBindCol(hstmt, 4, SQL_C_CHAR, szColumnName, STR_LEN, &cbColumnName);
    SQLBindCol(hstmt, 5, SQL_C_SSHORT, &DataType, 0, &cbDataType);
    SQLBindCol(hstmt, 6, SQL_C_CHAR, szTypeName, STR_LEN, &cbTypeName);
    SQLBindCol(hstmt, 7, SQL_C_SLONG, &ColumnSize, 0, &cbColumnSize);
    SQLBindCol(hstmt, 8, SQL_C_SLONG, &BufferLength, 0, &cbBufferLength);
    SQLBindCol(hstmt, 9, SQL_C_SSHORT, &DecimalDigits, 0, &cbDecimalDigits);
    SQLBindCol(hstmt, 10, SQL_C_SSHORT, &NumPrecRadix, 0, &cbNumPrecRadix);
    SQLBindCol(hstmt, 11, SQL_C_SSHORT, &Nullable, 0, &cbNullable);
    SQLBindCol(hstmt, 12, SQL_C_CHAR, szRemarks, REM_LEN, &cbRemarks);
      
    /* create empty list */
    
    if ((hp=emptylist()) == NULL) fail;
    L.dword=D_List;
    L.vword.bptr=(union block *) hp;

    /* create record fields definition */
    
    /* note there's no alcstr() call to allocate memory */

    for (i=0; i<DBCOLNCOLS; i++) {
      StrLoc(fieldname[i])=colname[i];
      StrLen(fieldname[i])=strlen(colname[i]);
    }

    while (SQLFetch(hstmt)==SQL_SUCCESS) {

      /* allocate record */
      proc=dynrecord(&rectypename, fieldname, DBCOLNCOLS);
      r = alcrecd(DBCOLNCOLS, (union block *)proc);
      R.dword=D_Record;
      R.vword.bptr=(union block *) r;

      /* populate list with column info */
      /* TABLE_CAT (varchar) */
      StrLoc(r->fields[0])=cbCatalog>0?alcstr(szCatalog, cbCatalog):"";
      StrLen(r->fields[0])=cbCatalog>0?cbCatalog:0;

      /* TABLE_SCHEM (varchar) */
      StrLoc(r->fields[1])=cbSchema>0?alcstr(szSchema, cbSchema):"";
      StrLen(r->fields[1])=cbSchema>0?cbSchema:0;  /* cbSchema could be -1 */

      /* TABLE_NAME (varchar not NULL) */
      StrLoc(r->fields[2])=cbTableName>0?alcstr(szTableName, cbTableName):"";
      StrLen(r->fields[2])=cbTableName>0?cbTableName:0;                     

      /* COLUMN_NAME (varchar not NULL) */
      StrLoc(r->fields[3])=cbColumnName>0?alcstr(szColumnName, cbColumnName):"";
      StrLen(r->fields[3])=cbColumnName>0?cbColumnName:0;                     
              
      /* DATA_TYPE (Smallint not NULL) */
      MakeInt(DataType, &(r->fields[4]));

      /* TYPE_NAME (varchar not NULL) */
      StrLoc(r->fields[5])=cbTypeName>0?alcstr(szTypeName, cbTypeName):"";
      StrLen(r->fields[5])=cbTypeName>0?cbTypeName:0;

      /* COLUMN_SIZE (Integer) */
      MakeInt(ColumnSize, &(r->fields[6]));

      /* BUFFER_LENGTH (Integer) */
      MakeInt(BufferLength, &(r->fields[7]));

      /* DECIMAL_DIGITS (Smallint) */
      MakeInt(DecimalDigits, &(r->fields[8]));
      
      /* NUM_PREC_RADIX (Smallint) */
      MakeInt(NumPrecRadix, &(r->fields[9]));

      /* NULLABLE (Smallint not NULL) */
      MakeInt(Nullable, &(r->fields[10]));

      /* REMARKS (varchar) */
      StrLoc(r->fields[11])=cbRemarks>0?alcstr(szRemarks, cbRemarks):"";
      StrLen(r->fields[11])=cbRemarks>0?cbRemarks:0;

      c_put(&L, &R);
    }
      
    if (SQLFreeStmt(hstmt, SQL_DROP)!=SQL_SUCCESS) { /* release statement */
      odbcerror(FREE_STMT_ERR);
      fail;
    }
    return L;
  }
end


/*
 *
 * dbdelete(f, filter)
 *
 * build a DELETE SQL query like:
 *
 * DELETE FROM <table> WHERE <filter>
 *
 * Partial parameters: dbdelete(f) => dbdelete(f,"") (DANGEROUS)
 *
 * Null parameters: dbdelete(f,) => dbdelete(f,"") (DANGEROUS)
 *
 * if filter is null/"" filter is ignored (ALL ROWS ARE REMOVED FROM TABLE)
 */

"dbdelete(f, filter) - delete one or more rows from a table"
function{0,1} dbdelete(f, x[n])
  
  abstract {
    return integer
  }

  body {
    int i;
    char *query;
    struct ISQLFile *fp;
    
    HSTMT hstmt;
    
    long querysize;

    if (!is:file(f)) runerr(105, f);

    for (i=0; i<n; i++) {
      if (!(Qual(x[i]) || is:null(x[i]))) runerr(103, x[i]);
    }
    
    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) {
      runerr(NOT_ODBC_FILE_ERR, f);
    }

    fp=FDESC(f);

    /* allocate string for SQl statement construction */
    /* DELETE FROM <table> [WHERE <filter>]\0  */
      
    querysize=(n==0 || is:null(x[0]))? strlen(fp->tablename) + 13 :
               strlen(fp->tablename) + StrLen(x[0]) + 21;
   
    
    qalloc(fp, querysize);
    query=fp->query;

    /* build SQL statement */
    strcpy(query,"DELETE ");
    strcat(query,"FROM ");
    strcat(query, fp->tablename);

    /* add criteria if any specified */
    if ((n!=0) && (!is:null(x[0])) && (StrLen(x[0])>0)) {
      strcat(query," WHERE ");
      strncat(query, StrLoc(x[0]), StrLen(x[0]));
    }

    /* allocate SQL statement handler */
    if (SQLAllocStmt(fp->hdbc, &hstmt)==SQL_ERROR) {
      odbcerror(ALLOC_STMT_ERR);
      fail;
    }

    if (SQLExecDirect(hstmt, query, SQL_NTS)!=SQL_SUCCESS) {
      odbcerror(EXEC_DIRECT_ERR);
      fail;
    }

    if (SQLFreeStmt(hstmt, SQL_DROP)!=SQL_SUCCESS) {
      odbcerror(FREE_STMT_ERR);
      fail;
    }

    return C_integer(0);
  }
end


"dbdriver(f) - return driver information"
function {0,1} dbdriver(f)
  if !is:file(f) then
    runerr(105, f);
    
  abstract {
    return record
  }
  
  body {  
    SWORD len;
    UWORD result;
    static struct b_proc *proc;
    char sbuf[256];
    struct ISQLFile *fp;

    struct descrip field[DBDRVNCOLS]; /* field names */
    
    /* record structures */
    tended struct descrip R;
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    short i;

    /* unicon field names */
    static char *colname[DBDRVNCOLS]={
       "name", "ver", "odbcver", "connections", "statements", "dsn"};
                               
    /* SQLGetInfo() information requested */
    static int  sql_parm[DBDRVNCOLS]={SQL_DRIVER_NAME, SQL_DRIVER_VER,
         SQL_DRIVER_ODBC_VER, SQL_ACTIVE_CONNECTIONS, SQL_ACTIVE_STATEMENTS,
         SQL_DATA_SOURCE_NAME};
         
    /* SQLGetInfo() result is a string */
    static int  is_str[DBDRVNCOLS]={1,1,1,0,0,1};
                               
    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* not an ODBC file */
      runerr(NOT_ODBC_FILE_ERR, f);
      }
    fp=FDESC(f); /* file descriptor */

    /* record field names */
    
    /* allocate record */
    if (proc == NULL) {
       for (i=0; i<DBDRVNCOLS; i++) {
          StrLoc(field[i])=colname[i];
          StrLen(field[i])=strlen(colname[i]);
          }
       proc = dynrecord(&rectypename, field, DBDRVNCOLS);
       }
    r = alcrecd(DBDRVNCOLS, (union block *)proc);
    R.dword=D_Record;
    R.vword.bptr=(union block *) r;

    for (i=0; i<DBDRVNCOLS; i++) {
      if (is_str[i]) { /* result is a string */
        SQLGetInfo(fp->hdbc, (SQLUSMALLINT)sql_parm[i], sbuf, 255, &len);
        StrLen(r->fields[i])=len;
        StrLoc(r->fields[i])=alcstr(sbuf, len);
      }
      else { /* result is a number */
        SQLGetInfo(fp->hdbc, (SQLUSMALLINT)sql_parm[i],
		   (PTR)&result, sizeof(result), NULL);
        MakeInt(result, &(r->fields[3]));
      }
    }

    return R;
  }
end


"dbinsert(f, rec) - insert a row into a table"
function{0,1} dbinsert(f, rec)
  if !is:file(f) then
    runerr(105, f);

  if !is:record(rec) then
    runerr(105, f);

  abstract {
    return integer;
  }

  body {
    HSTMT  hstmt;
    tended char *cfield;
    char *query;

    UWORD i;
    SWORD rc;

    SWORD nfields;
    int querysize=0;

    struct ISQLFile *fp;

    struct descrip fieldname[MAXTABLECOLS]; 

    /* record structures */
    tended struct descrip R;
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    struct b_proc *proc;


    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* not an ODBC file */
      runerr(NOT_ODBC_FILE_ERR, f);
    }

    fp=FDESC(f);

    nfields=BlkLoc(rec)->record.recdesc->proc.nfields;

    /* calculate query size */
    
    for (i=0; i<nfields; i++) {
      if (Qual(RFVAL[i])) { /* field value is a string */
        querysize+=StrLen(RFVAL[i]) + 2; /* 2 hyphens */
      }
      else {
        /* try convert field value to C string */
        if (!cnv:C_string(RFVAL[i], cfield))
          runerr(103, rec);
        querysize+=strlen(cfield);
      }

      /* field name */
      querysize+=StrLen(RFNAME[i]);
    }
   
    /* calculate amount of bytes to allocate SQL statement */
    /* INSERT INTO <table> ( , , ) VALUES ( , , )          */
    
    querysize += 26 + strlen(fp->tablename) + 2*(nfields-1);

    qalloc(fp, querysize);
    query=fp->query;

    strcpy(query, "INSERT INTO ");
    strcat(query, fp->tablename);
    strcat(query, " (");
    
    /* add record field names to the SQL statement */
    for (i=0; i<nfields-1; i++) {
      strncat(query, StrLoc(RFNAME[i]), StrLen(RFNAME[i]));
      strcat(query,","); /* separator */
    }

    /* last field name (do not append ",") */
    strncat(query, StrLoc(RFNAME[nfields-1]), StrLen(RFNAME[nfields-1]));

    strcat(query, ") VALUES (");
    
    /* record field values */
    for(i=0; i<nfields-1; i++) {
      if (Qual(RFVAL[i])) { /* field value is a string */
         strcat(query, "'");
         strncat(query, StrLoc(RFVAL[i]), StrLen(RFVAL[i]));
         strcat(query, "'");
      }
      else {
        cnv:C_string(BlkLoc(rec)->record.fields[i], cfield);
        strcat(query, cfield);
      }
      strcat(query, ",");
    }

    /* add last field */
    i=nfields-1;
    if (Qual(RFVAL[i])) { /* field value is a string */
      strcat(query, "'");
      strncat(query, StrLoc(RFVAL[i]), StrLen(RFVAL[i]));
      strcat(query, "'");
    }
    else {
      cnv:C_string(BlkLoc(rec)->record.fields[i], cfield);
      strcat(query, cfield);
    }
    
    strcat(query, ")"); /* close parameter values list */

    if (SQLAllocStmt(fp->hdbc, &hstmt)!=SQL_SUCCESS) {
      odbcerror(ALLOC_STMT_ERR);
      fail;
    }

    if (SQLExecDirect(hstmt, query, SQL_NTS)!=SQL_SUCCESS) {
      odbcerror(EXEC_DIRECT_ERR);
      fail;
    }

    if (SQLFreeStmt(hstmt, SQL_DROP)!=SQL_SUCCESS) {
      odbcerror(FREE_STMT_ERR);
      fail;
    }

    return C_integer(0);
  }
end


"dbkeys(f) - get information about ODBC file primary keys"
function{1} dbkeys(f)
  if !is:file(f) then
    runerr(105, f)              /* f is not a file */

  abstract {
    return list
  }

  body {

    /* record declarations */
    struct descrip fieldname[DBKEYSNCOLS]; /* record field names */
    tended struct descrip R;
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    struct b_proc *proc;

    /* list declarations */
    tended struct descrip L;
    tended struct b_list *hp;
    
    struct ISQLFile *fp;
    
    UCHAR szPkCol[COL_LEN];   /* primary key column     */

    SQLINTEGER cbPkCol, cbKeySeq;
    short iKeySeq;

    SQLHSTMT hstmt;
    SQLRETURN retcode;

    short i;
    
    char *colname[DBKEYSNCOLS]={"col", "seq"};
    
    
    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* ODBC mode */
      runerr(NOT_ODBC_FILE_ERR, f);
    }

    fp=FDESC(f); /* file descriptor */
      
    if (SQLAllocStmt(fp->hdbc, &hstmt)!=SQL_SUCCESS) {
      odbcerror(ALLOC_STMT_ERR);
      fail;
    }

    SQLBindCol(hstmt, 4, SQL_C_CHAR, szPkCol, COL_LEN, &cbPkCol);
    SQLBindCol(hstmt, 5, SQL_C_SSHORT, &iKeySeq, TAB_LEN, &cbKeySeq);

    retcode=SQLPrimaryKeys(hstmt,      
                           NULL, 0,                 /* all catalogs */
                           NULL, 0,                 /* all schemas */
                           fp->tablename, SQL_NTS); /* table */

    if (retcode!=SQL_SUCCESS) {
      odbcerror(PRIMARY_KEYS_ERR);
      fail;
    }
   
    /* create empty list */
    
    if ((hp=emptylist()) == NULL) fail;
    L.dword=D_List;
    L.vword.bptr=(union block *) hp;

    /* create record fields definition */
    
    for (i=0; i<DBKEYSNCOLS; i++) {
      StrLoc(fieldname[i])=colname[i];
      StrLen(fieldname[i])=strlen(colname[i]);
    }
    

    /* populate list with column info */

    while (SQLFetch(hstmt)==SQL_SUCCESS) {

      /* allocate record */
      proc=dynrecord(&rectypename, fieldname, DBKEYSNCOLS);
      r = alcrecd(DBKEYSNCOLS, (union block *)proc);
      R.dword=D_Record;
      R.vword.bptr=(union block *) r;

      /* key column (varchar) */
      StrLoc(r->fields[0])=cbPkCol>0?alcstr(szPkCol, cbPkCol):"";
      StrLen(r->fields[0])=cbPkCol>0?cbPkCol:0;
          
      /* key sequence (integer) */
      MakeInt(iKeySeq, &(r->fields[1]));
        
      c_put(&L, &R);
    }

    if (SQLFreeStmt(hstmt, SQL_DROP)!=SQL_SUCCESS) {
      odbcerror(FREE_STMT_ERR);
      fail;
    }

    return L;
  }
end


"dblimits(f) - return SQL limits"
function {0,1} dblimits(f)
  if !is:file(f) then
    runerr(105, f);
    
  abstract {
    return record
  }
  
  body {  
    SWORD len;
    UWORD result;
    
    struct ISQLFile *fp;

    struct descrip field[DBLIMITSNCOLS]; /* field names */
    
    /* record structures */
    tended struct descrip R;
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    struct b_proc *proc;

    short i;
    
    static char *colname[DBLIMITSNCOLS]={"maxbinlitlen", "maxcharlitlen",
         "maxcolnamelen",  "maxgroupbycols", "maxorderbycols", "maxindexcols",
         "maxselectcols",  "maxtblcols",     "maxcursnamelen", "maxindexsize",
         "maxownnamelen",  "maxprocnamelen", "maxqualnamelen", "maxrowsize",
         "maxrowsizelong", "maxstmtlen",     "maxtblnamelen",  "maxselecttbls",
         "maxusernamelen"};

    static int sql_parm[DBLIMITSNCOLS]={SQL_MAX_BINARY_LITERAL_LEN,
        SQL_MAX_CHAR_LITERAL_LEN, SQL_MAX_COLUMN_NAME_LEN,
        SQL_MAX_COLUMNS_IN_GROUP_BY, SQL_MAX_COLUMNS_IN_ORDER_BY,
        SQL_MAX_COLUMNS_IN_INDEX, SQL_MAX_COLUMNS_IN_SELECT,
        SQL_MAX_COLUMNS_IN_TABLE, SQL_MAX_CURSOR_NAME_LEN, SQL_MAX_INDEX_SIZE,
        SQL_MAX_OWNER_NAME_LEN, SQL_MAX_PROCEDURE_NAME_LEN,
        SQL_MAX_QUALIFIER_NAME_LEN, SQL_MAX_ROW_SIZE,
        SQL_MAX_ROW_SIZE_INCLUDES_LONG, SQL_MAX_STATEMENT_LEN,
        SQL_MAX_TABLE_NAME_LEN, SQL_MAX_TABLES_IN_SELECT,
        SQL_MAX_USER_NAME_LEN};

    static int is_str[DBLIMITSNCOLS]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0};
    
    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* not an ODBC file */
      runerr(NOT_ODBC_FILE_ERR, f);
      }
    fp=FDESC(f); /* file descriptor */

    /* record field names */
    for (i=0; i<DBLIMITSNCOLS; i++) {
      StrLoc(field[i])=colname[i];
      StrLen(field[i])=strlen(colname[i]);
    }

    /* allocate record */
    proc=dynrecord(&rectypename, field, DBLIMITSNCOLS);
    r = alcrecd(DBLIMITSNCOLS, (union block *)proc);
    R.dword=D_Record;
    R.vword.bptr=(union block *) r;

    for (i=0; i<DBLIMITSNCOLS; i++) {
      if (is_str[i]) {
        StrLoc(r->fields[i])=alcstr(NULL,255);
        SQLGetInfo(fp->hdbc, (SQLUSMALLINT)sql_parm[i], StrLoc(r->fields[i]), 255, &len);
        StrLen(r->fields[i])=len;
      }
      else {
        SQLGetInfo(fp->hdbc, (SQLUSMALLINT)sql_parm[i], (PTR)&result, sizeof(result), NULL);
        MakeInt(result, &(r->fields[i]));
      }
    }

    return R;
  }
end


"dbproduct(f) - return database name"
function {0,1} dbproduct(f)
   if !is:file(f) then
      runerr(105, f);
    
   abstract {
      return record
      }
  
   body {
      SWORD len;
      struct ISQLFile *fp;
      struct descrip field[DBPRODNCOLS];
      char sbuf[256];    

      /* record structures */
      tended struct descrip R;
      tended struct descrip rectypename=emptystr;
      tended struct b_record *r;
      static struct b_proc *proc;
      short i;
      static char *colname[DBPRODNCOLS]={"name", "ver"};
      static int sql_parm[DBPRODNCOLS]={SQL_DBMS_NAME, SQL_DBMS_VER};

      if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* not an ODBC file */
         runerr(NOT_ODBC_FILE_ERR, f);
         }

      fp=FDESC(f); /* file descriptor */

      /* allocate record */
      if (proc == NULL) {
         for (i=0; i<DBPRODNCOLS; i++) {
            StrLoc(field[i])=colname[i];
            StrLen(field[i])=strlen(colname[i]);
            }
         proc = (struct b_proc *)dynrecord(&rectypename, field, DBPRODNCOLS);
         }
      r = alcrecd(DBPRODNCOLS, (union block *)proc);
      R.dword=D_Record;
      R.vword.bptr=(union block *) r;
      for (i=0; i<DBPRODNCOLS; i++) {
         SQLGetInfo(fp->hdbc, (SQLUSMALLINT)sql_parm[i], sbuf, 255, &len);
         StrLen(r->fields[i])=len;
         StrLoc(r->fields[i])=alcstr(sbuf, len);
         }
      return R;
      }
end

/*
 * dbselect(f, cols, filter, order)
 *
 * build a SELECT SQL query like:
 *
 * SELECT <cols> FROM <table> WHERE <filter> ORDER BY <order>
 *
 * Partial parameters: dbselect(f,"*","id=1") (no order specified)
 *
 * Null parameters: dbselect(f,,,) => dbselect(f,"*")
 *
 * if cols is null/"" cols = "*"
 * if filter is null/"" filter is ignored
 * if order is null/"" order is ignored
 */
 
"dbselect(f, cols, filter, order) - select cols from f using filter/order"
function{0,1} dbselect(f, x[n])
  
  abstract {
    return integer
  }

  body {
    char *query;

    struct ISQLFile *fp;
    int rc, i;
    long querysize;

    if (!is:file(f)) runerr(105, f);
    
    /* parameter x[i] has to be a string */
    
    for (i=0; i<n; i++) {
      /* if parameters are not a string or not null */
      if (!(Qual(x[i]) || is:null(x[i]))) runerr(103, x[i]);
    }
   
    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) {
      runerr(NOT_ODBC_FILE_ERR, f); /* not ODBC file */
    }
    
    fp=FDESC(f);

    /* allocate string for SQL statement construction                   */
    /* SELECT <cols> FROM <table> [WHERE <filter>] [ORDER BY <order>]\0  */
    
    querysize=0;
    
    switch (n) {
      case 3: querysize += (is:null(x[2]))?0:StrLen(x[2]) + 10; /* " ORDER BY " */
      case 2: querysize += (is:null(x[1]))?0:StrLen(x[1]) +  7; /* " WHERE "    */
      case 1: querysize += (is:null(x[0]))?0:StrLen(x[0]);
      case 0: querysize += strlen(fp->tablename) + 15; /* "SELECT * FROM \0" */
    }
    
    qalloc(fp, querysize);
    query=fp->query;

    /* build SQL statement */
    strcpy(query,"SELECT ");
    
    /* if columns list is null put an "*" as default */
     
    if (n==0 || (n>0 && StrLen(x[0])==0) || (is:null(x[0]))) {
      strcat(query, "*");
    }
    else {
      strncat(query, StrLoc(x[0]), StrLen(x[0]));
    }
         
    strcat(query," FROM ");
    strcat(query, fp->tablename);

    /* add criteria if any */
    if (n>1 && StrLen(x[1])>0) {
      strcat(query," WHERE ");
      strncat(query, StrLoc(x[1]), StrLen(x[1]));
    }
    
    /* add order criteria if any */
    if (n>2 && StrLen(x[2])>0) {
      strcat(query," ORDER BY ");
      strncat(query, StrLoc(x[2]), StrLen(x[2]));
    }
    
    SQLFreeStmt(fp->hstmt, SQL_CLOSE);

    /* execute SQL statement */
    if (SQLExecDirect(fp->hstmt, query, SQL_NTS)!=SQL_SUCCESS) {
      odbcerror(EXEC_DIRECT_ERR);
      fail;
    }

    return C_integer(0);
  }
end


"dbsql(f, query) - submit an SQL query on an ODBC file f"
function{0,1} dbsql(f, query)
  if !is:file(f) then
    runerr(105, f)              /* f is not a file */

  abstract {
    return integer
  }

  body {
    
    int rc;

    struct ISQLFile *fp;
  
    if (!Qual(query)) runerr(103, query);          

    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* ODBC file */
      runerr(NOT_ODBC_FILE_ERR, f);
    }
    
    fp=FDESC(f);

    SQLFreeStmt(fp->hstmt, SQL_CLOSE);

    rc=SQLExecDirect(fp->hstmt, StrLoc(query), StrLen(query));

    if(rc==SQL_ERROR || rc==SQL_SUCCESS_WITH_INFO) {
      odbcerror(EXEC_DIRECT_ERR);
      fail;
    }

    return C_integer(rc);
  }
end


"dbtables(f) - get information about an ODBC file column"
function{0,1} dbtables(f)
  if !is:file(f) then runerr(105, f)   /* f is not a file */

  abstract {
    return list;
  }

  body {

    /* record declarations */
    struct descrip fieldname[DBTBLNCOLS]; /* record field names */

    tended struct descrip R;
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    struct b_proc *proc;
    
    /* file declarations */
    struct ISQLFile *fp;
    
    /* list declarations */
    tended struct descrip L;
    tended struct b_list *hp;
    
    /* result set data buffers */

    SQLCHAR szTblQualif[STR_LEN], szTblOwner[STR_LEN];
    SQLCHAR szTblName[STR_LEN], szTblType[STR_LEN];
    SQLCHAR szRemarks[REM_LEN];
   
    SQLRETURN retcode;

    /* buffers for bytes available to return */

    SQLINTEGER cbQualif, cbOwner, cbName, cbType, cbRemarks;
    
    HSTMT hstmt;
    
    short i;
    
    static char *colname[DBTBLNCOLS]={
      "qualifier", "owner", "name", "type","remarks"
    };


    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* ODBC file */
      runerr(NOT_ODBC_FILE_ERR, f);
    }

    fp=FDESC(f); /* file descriptor */

    if (SQLAllocStmt(fp->hdbc, &hstmt)!=SQL_SUCCESS) {
      odbcerror(ALLOC_STMT_ERR);
      fail;
    }

    retcode=SQLTables(hstmt, NULL, 0, NULL, 0, NULL, 0, NULL, 0);

    if (retcode!=SQL_SUCCESS) {
      odbcerror(TABLES_ERR);
      fail;
    }    
     
    /* bind columns in result set to buffer (ODBC 2.x) */
    
    SQLBindCol(hstmt, 1, SQL_C_CHAR, szTblQualif, STR_LEN, &cbQualif);
    SQLBindCol(hstmt, 2, SQL_C_CHAR, szTblOwner, STR_LEN, &cbOwner);
    SQLBindCol(hstmt, 3, SQL_C_CHAR, szTblName, STR_LEN, &cbName);
    SQLBindCol(hstmt, 4, SQL_C_SSHORT, szTblType, 0, &cbType);
    SQLBindCol(hstmt, 5, SQL_C_CHAR, szRemarks, STR_LEN, &cbRemarks);
        
    /* create empty list */
    
    if ((hp=emptylist()) == NULL) fail;
    L.dword=D_List;
    L.vword.bptr=(union block *) hp;

    /* create record fields definition */

    for (i=0; i<DBTBLNCOLS; i++) {
      StrLoc(fieldname[i])=colname[i];
      StrLen(fieldname[i])=strlen(colname[i]);
    }
    
    
    while (SQLFetch(hstmt)==SQL_SUCCESS) {
      /* allocate record */
      proc=dynrecord(&rectypename, fieldname, DBTBLNCOLS);
      r = alcrecd(DBTBLNCOLS, (union block *)proc);
      R.dword=D_Record;
      R.vword.bptr=(union block *) r;

      /* fill fields */
      StrLoc(r->fields[0])=cbQualif>0?alcstr(szTblQualif,cbQualif):"";
      StrLen(r->fields[0])=cbQualif>0?cbQualif:0;
      StrLoc(r->fields[1])=cbOwner>0?alcstr(szTblOwner,cbOwner):"";
      StrLen(r->fields[1])=cbOwner>0?cbOwner:0;
      StrLoc(r->fields[2])=cbName>0?alcstr(szTblName,cbName):"";
      StrLen(r->fields[2])=cbName>0?cbName:0;
      StrLoc(r->fields[3])=cbType>0?alcstr(szTblType,cbType):"";
      StrLen(r->fields[3])=cbType>0?cbType:0;
      StrLoc(r->fields[4])=cbRemarks>0?alcstr(szRemarks,cbRemarks):"";
      StrLen(r->fields[4])=cbRemarks>0?cbRemarks:0;
      
      c_put(&L, &R);
    }
    
    if (SQLFreeStmt(hstmt, SQL_DROP)!=SQL_SUCCESS) {
      odbcerror(FREE_STMT_ERR);
      fail;
    }

    return L;
  }
end


"dbupdate(f, rec) - update a row of a table"
function{0,1} dbupdate(f, rec)
  if !is:file(f) then
    runerr(105, f);

  if !is:record(rec) then
    runerr(105, f);

  abstract {
    return integer;
  }

  body {
    HSTMT kstmt;           /* SQLPrimaryKeys statement  */
    HSTMT hstmt;           /* query statement handler */
    
    char szPkCol[COL_LEN]; /* primary key column name   */
    char *pos=NULL;        /* key positions in record field list */
    char *query;           /* SQL query */
    
    SQLINTEGER cbPkCol;    /* column size */
    
    short nkeys=0;         /* number of key columns found */
    short keyfound=1;      /* let enter loop */

    UWORD i;
    SWORD rc;

    int nfields;           /* number of record fields */
    int n;

    long querysize=0;

    tended char *cfield;   /* field conversion */
  
    struct ISQLFile *fp;   /* file pointer */

    struct descrip fieldname[MAXTABLECOLS]; /* record field name */
    
    /* record structures */
    tended struct descrip R;
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    struct b_proc *proc;

    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* not an ODBC file */
      runerr(NOT_ODBC_FILE_ERR, f);
    }

    fp=FDESC(f);

    if (SQLAllocStmt(fp->hdbc, &kstmt)!=SQL_SUCCESS) {
      odbcerror(ALLOC_STMT_ERR);
      fail;
    }

    /* bind key column name */
    SQLBindCol(kstmt, 4, SQL_C_CHAR, szPkCol, COL_LEN, &cbPkCol);
    
    /* get column names that comprise primary key */
    rc=SQLPrimaryKeys(kstmt, NULL, 0, NULL, 0, fp->tablename, SQL_NTS);
    
    if (rc!=SQL_SUCCESS) {
      odbcerror(PRIMARY_KEYS_ERR);
      fail;
    }
    
    nfields=BlkLoc(rec)->record.recdesc->proc.nfields;
    
    pos=calloc(nfields, sizeof(int)); /* key positions (init el.s to zero) */
    
    nkeys=0; /* no keys */

    while (SQLFetch(kstmt)==SQL_SUCCESS && keyfound==1) {
      keyfound=0; /* key not found */
      
      for (i=0; i<nfields; i++) {
        /* 
           compare fetched key with i-th field name
           (no C_string conversion required using strncasecmp())
        */
        if (strncasecmp(szPkCol, StrLoc(RFNAME[i]), StrLen(RFNAME[i]))==0) {
          keyfound=1; /* key found in record */
          nkeys++;
          pos[i]='k'; /* it's a key */
          break;
        }
      } 
    }

    if (SQLFreeStmt(kstmt, SQL_DROP)!=SQL_SUCCESS) { /* release statement handler */
      free(pos);
      odbcerror(FREE_STMT_ERR);
      fail;
    }
    
    if (nkeys==0) { /* record has no key defined */
      free(pos);
      odbcerror(NO_KEY_DEFINED_ERR);
      fail;
    }

    if (nkeys==nfields) { /* record has no nonkey columns defined */
      free(pos);
      odbcerror(TOO_MANY_KEYS_ERR);
      fail;
    }
    
    if (keyfound==0) { /* record misses table keys */
      free(pos);
      odbcerror(KEY_MISSING_ERR);
      fail;
    }

    /* calculate UPDATE query length */

    for (i=0; i<nfields; i++) {
      /* field is a string */
      if (Qual(RFVAL[i])) {
        querysize+=StrLen(RFVAL[i]) + 2; /* 2 hyphens */
      }
      else {
        /* convert field value to C string */
        if (!cnv:C_string(RFVAL[i], cfield))
          runerr(103, rec);

        querysize+=strlen(cfield); /* string conversion length */
      }

      /* add field name length */
      querysize+=StrLen(RFNAME[i]);
    }
   
    /* calculate amount of bytes to allocate SQL statement       */
    /* UPDATE <table> SET c1=..., c2=... WHERE k1=... AND K2=... */
    
    querysize+=20 + strlen(fp->tablename) + nfields + nfields-nkeys-1
                  + 5*(nkeys-1);

    qalloc(fp, querysize);
    query=fp->query;

    strcpy(query, "UPDATE ");
    strcat(query, fp->tablename);
    strcat(query, " SET ");
    
    /* add record field names to the SQL statement excluding key(s) */
    
    n=nfields-nkeys;
    for (i=0; i<nfields; i++) {
      if (pos[i]!='k') {
        strncat(query, StrLoc(RFNAME[i]), StrLen(RFNAME[i])); /* field name */
        strcat(query,"=");
        
        if (Qual(RFVAL[i])) { /* field value is string */
          strcat(query, "'");
          strncat(query, StrLoc(RFVAL[i]), StrLen(RFVAL[i]));
          strcat(query, "'");
        }
        else {
          cnv:C_string(RFVAL[i], cfield);
          strcat(query, cfield);
        }
        
        if (--n==0) break; /* all fields processed */
        
        strcat(query, ","); /* fields separator */
      }
    }

    /* WHERE clause part */
    strcat(query, " WHERE ");
    
    /* key list */

    for(i=0; i<nfields; i++) {
      if (pos[i]=='k') {
        strncat(query, StrLoc(RFNAME[i]), StrLen(RFNAME[i]));
        strcat(query,"=");

        if (Qual(RFVAL[i])) { /* field value is a string */
          strcat(query, "'");
          strncat(query, StrLoc(RFVAL[i]), StrLen(RFVAL[i]));
          strcat(query, "'");
        }
        else {
          cnv:C_string(RFVAL[i], cfield);
          strcat(query, cfield);
        }

        if (--nkeys==0) break; /* all keys processed */
        
        strcat(query, " AND "); /* columns separator */
      }
    }
    
    free(pos);
    
    if (SQLAllocStmt(fp->hdbc, &hstmt)!=SQL_SUCCESS) {
      odbcerror(ALLOC_STMT_ERR);
      fail;
    }

    if (SQLExecDirect(hstmt, query, SQL_NTS)!=SQL_SUCCESS) {
      odbcerror(EXEC_DIRECT_ERR);
      fail;
    }
    
    if (SQLFreeStmt(hstmt, SQL_DROP)!=SQL_SUCCESS) {
      odbcerror(FREE_STMT_ERR);
      fail;
    }

    return C_integer(rc);
  }
end

#else					/* ISQL */
static int nothing;
#endif					/* ISQL */
