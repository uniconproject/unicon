/*
 * File:  fdb.r
 *  Contents: dbcolumns, dbdriver, dbkeys, dblimits, dbproduct, sql, dbtables
 */

#ifdef ISQL

SQLHENV ISQLEnv=NULL;           /* global environment variable */

#define STR_LEN        256+1
#define REM_LEN        256+1

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
#define FSTATUS(f) BlkD(f,File)->status		/* file status */
#define FDESC(f)   BlkD(f,File)->fd.sqlf		/* ISQLFile * */


/*-- functions implementation --*/

"dbcolumns(f, T) - get information about columns in an ODBC table"
function{0,1} dbcolumns(f,table_name)
   if !is:file(f) then runerr(105, f)   /* f is not a file */

   abstract {
      return list
      }

  body {
    tended struct descrip R;
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    static struct b_proc *proc;
    
    /* list declarations */
    tended struct descrip L;
    tended struct b_list *hp;
    
    struct ISQLFile *fp;
    
    /* result set data buffers */

    SQLCHAR szCatalog[STR_LEN], szSchema[STR_LEN];
    SQLCHAR szTableName[STR_LEN], szColumnName[STR_LEN];
    SQLCHAR szTypeName[STR_LEN], szRemarks[REM_LEN];
#ifdef MSWIN64
    SQLLEN ColumnSize, BufferLength;
#else					/* MSWIN64 */
    SQLINTEGER ColumnSize, BufferLength;
#endif					/* MSWIN64 */
    SQLSMALLINT DataType, DecimalDigits, NumPrecRadix, Nullable;
   
    SQLRETURN retcode;
    
    /* buffers for bytes available to return */

    SQL_LENORIND cbCatalog, cbSchema, cbTableName, cbColumnName;
    SQL_LENORIND cbDataType, cbTypeName, cbColumnSize, cbBufferLength;
    SQL_LENORIND cbDecimalDigits, cbNumPrecRadix, cbNullable, cbRemarks;
    
    HSTMT hstmt;
    
#ifdef MacOS
    static struct descrip colnames[12];
    static int cnm=0;  /* FIXME: thread unsafe  */
    if (!cnm) {
       AsgnCStr(colnames[cnm], "catalog");
       cnm++;
       AsgnCStr(colnames[cnm], "schema");
       cnm++;
       AsgnCStr(colnames[cnm], "tablename");
       cnm++;
       AsgnCStr(colnames[cnm], "colname");
       cnm++;
       AsgnCStr(colnames[cnm], "datatype");
       cnm++;
       AsgnCStr(colnames[cnm], "typename");
       cnm++;
       AsgnCStr(colnames[cnm], "colsize");
       cnm++;
       AsgnCStr(colnames[cnm], "buflen");
       cnm++;
       AsgnCStr(colnames[cnm], "decdigits");
       cnm++;
       AsgnCStr(colnames[cnm], "numprecradix");
       cnm++;
       AsgnCStr(colnames[cnm], "nullable");
       cnm++;
       AsgnCStr(colnames[cnm], "remarks");
       cnm++;
       };
#else					/* MacOS */
    static struct descrip colnames[12] = {
       {7,(word)"catalog"}, {6,(word)"schema"}, {9,(word)"tablename"},
       {7,(word)"colname"}, {8,(word)"datatype"}, {8,(word)"typename"},
       {7,(word)"colsize"}, {6,(word)"buflen"}, {9,(word)"decdigits"},
       {12,(word)"numprecradix"}, {8,(word)"nullable"}, {7,(word)"remarks"}
       };
#endif					/* MacOS */

    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* ODBC file */
      runerr(NOT_ODBC_FILE_ERR, f);
      }

    fp=FDESC(f); /* file descriptor */

    if (is:null(table_name) && (fp->tablename != NULL)) {
       MakeStr(fp->tablename, strlen(fp->tablename), &table_name);
       }
    else if (!Qual(table_name)) runerr(103, table_name);

    if (SQLAllocStmt(fp->hdbc, &hstmt)==SQL_ERROR) {
      odbcerror(fp, ALLOC_STMT_ERR);
      fail;
    }

    retcode=SQLColumns(hstmt,      
                       NULL, 0,                /* all catalogs */
                       NULL, 0,                /* all schemas */
                       (SQLCHAR *) StrLoc(table_name), StrLen(table_name), /* table */
                       NULL, 0);               /* All columns */

    if (retcode!=SQL_SUCCESS) {
      odbcerror(fp, COLUMNS_ERR);
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
    
    if ((hp=alclist(0, MinListSlots)) == NULL) fail;
    L.dword=D_List;
    L.vword.bptr=(union block *) hp;

    /* create record fields definition */
    if (proc == NULL)
       proc = dynrecord(&rectypename, colnames, DBCOLNCOLS);

    while (SQLFetch(hstmt)==SQL_SUCCESS) {

      /* allocate record */
      r = alcrecd(DBCOLNCOLS, (union block *)proc);
      R.dword=D_Record;
      R.vword.bptr=(union block *) r;

      /* populate list with column info */
      /* TABLE_CAT (varchar) */
      StrLoc(r->fields[0])=cbCatalog>0?alcstr((char *) szCatalog, cbCatalog):"";
      StrLen(r->fields[0])=cbCatalog>0?cbCatalog:0;

      /* TABLE_SCHEM (varchar) */
      StrLoc(r->fields[1])=cbSchema>0?alcstr((char *) szSchema, cbSchema):"";
      StrLen(r->fields[1])=cbSchema>0?cbSchema:0;  /* cbSchema could be -1 */

      /* TABLE_NAME (varchar not NULL) */
      StrLoc(r->fields[2])=cbTableName>0?alcstr((char *) szTableName, cbTableName):"";
      StrLen(r->fields[2])=cbTableName>0?cbTableName:0;                     

      /* COLUMN_NAME (varchar not NULL) */
      StrLoc(r->fields[3])=cbColumnName>0?alcstr((char *) szColumnName, cbColumnName):"";
      StrLen(r->fields[3])=cbColumnName>0?cbColumnName:0;                     
              
      /* DATA_TYPE (Smallint not NULL) */
      MakeInt(DataType, &(r->fields[4]));

      /* TYPE_NAME (varchar not NULL) */
      StrLoc(r->fields[5])=cbTypeName>0?alcstr((char *) szTypeName, cbTypeName):"";
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
      StrLoc(r->fields[11])=cbRemarks>0?alcstr((char *) szRemarks, cbRemarks):"";
      StrLen(r->fields[11])=cbRemarks>0?cbRemarks:0;
      if (StrLoc(r->fields[11]) == NULL) {
         runerr(306);
         }

      c_put(&L, &R);
    }
      
    if (SQLFreeStmt(hstmt, SQL_DROP)!=SQL_SUCCESS) { /* release statement */
      odbcerror(fp, FREE_STMT_ERR);
      fail;
    }
    return L;
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

    /* record structures */
    tended struct descrip R;
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    short i;

    /* SQLGetInfo() information requested */
    static int  sql_parm[DBDRVNCOLS]={SQL_DRIVER_NAME, SQL_DRIVER_VER,
         SQL_DRIVER_ODBC_VER, SQL_ACTIVE_CONNECTIONS, SQL_ACTIVE_STATEMENTS,
         SQL_DATA_SOURCE_NAME};
         
    /* SQLGetInfo() result is a string */
    static int  is_str[DBDRVNCOLS]={1,1,1,0,0,1};
                               
    /* unicon field names */
#ifdef MacOS
    static struct descrip colnames[6];
    static int cnm=0;  /* FIXME: thread unsafe  */
    if (!cnm) {
       AsgnCStr(colnames[cnm], "name");
       cnm++;
       AsgnCStr(colnames[cnm], "ver");
       cnm++;
       AsgnCStr(colnames[cnm], "odbcver");
       cnm++;
       AsgnCStr(colnames[cnm], "connections");
       cnm++;
       AsgnCStr(colnames[cnm], "statements");
       cnm++;
       AsgnCStr(colnames[cnm], "dsn");
       cnm++;
       }
#else					/* MacOS */
    static struct descrip colnames[6]={
       {4,(word)"name"}, {3,(word)"ver"}, {7,(word)"odbcver"},
       {11,(word)"connections"}, {10,(word)"statements"}, {3,(word)"dsn"}};
#endif					/* MacOS */
                               
    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* not an ODBC file */
      runerr(NOT_ODBC_FILE_ERR, f);
      }
    fp=FDESC(f); /* file descriptor */
    fp->proc = NULL;

    /* allocate record */
    if (proc == NULL) {
       proc = dynrecord(&rectypename, colnames, DBDRVNCOLS);
       }
    r = alcrecd(DBDRVNCOLS, (union block *)proc);
    R.dword=D_Record;
    R.vword.bptr=(union block *) r;

    for (i=0; i<DBDRVNCOLS; i++) {
      if (is_str[i]) { /* result is a string */
        SQLGetInfo(fp->hdbc, (SQLUSMALLINT)sql_parm[i], sbuf, 255, &len);
        StrLoc(r->fields[i])=alcstr(sbuf, len);
        StrLen(r->fields[i])=len;
        if (StrLoc(r->fields[i]) == NULL)
           runerr(306);
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


"dbkeys(f, T) - get information about ODBC table primary keys"
function{1} dbkeys(f, table_name)
  if !is:file(f) then
    runerr(105, f)              /* f is not a file */

  abstract {
    return list
  }

  body {

    /* record declarations */
    tended struct descrip R;
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    static struct b_proc *proc;

    /* list declarations */
    tended struct descrip L;
    tended struct b_list *hp;
    
    struct ISQLFile *fp;
    
    UCHAR szPkCol[COL_LEN];   /* primary key column     */

    SQL_LENORIND cbPkCol, cbKeySeq;
    short iKeySeq;

    SQLHSTMT hstmt;
    SQLRETURN retcode;

#ifdef MacOS
    static struct descrip colnames[2];
    static int cnm=0;  /* FIXME: thread unsafe  */
    if (!cnm) {
       AsgnCStr(colnames[cnm], "col");
       cnm++;
       AsgnCStr(colnames[cnm], "seq");
       cnm++;
       }
#else					/* MacOS */
    static struct descrip colnames[2]={{3,(word)"col"}, {3,(word)"seq"}};
#endif					/* MacOS */
    
    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* ODBC mode */
      runerr(NOT_ODBC_FILE_ERR, f);
    }

    fp=FDESC(f); /* file descriptor */
    fp->proc = NULL;
      
    if (is:null(table_name) && (fp->tablename != NULL)) {
       MakeStr(fp->tablename, strlen(fp->tablename), &table_name);
       }
    else if (!Qual(table_name)) runerr(103, table_name);

    if (SQLAllocStmt(fp->hdbc, &hstmt)!=SQL_SUCCESS) {
      odbcerror(fp, ALLOC_STMT_ERR);
      fail;
    }

    SQLBindCol(hstmt, 4, SQL_C_CHAR, szPkCol, COL_LEN, &cbPkCol);
    SQLBindCol(hstmt, 5, SQL_C_SSHORT, &iKeySeq, TAB_LEN, &cbKeySeq);

    retcode=SQLPrimaryKeys(hstmt,      
                           NULL, 0,                 /* all catalogs */
                           NULL, 0,                 /* all schemas */
                           (SQLCHAR *) StrLoc(table_name), StrLen(table_name)); /* table */

    if (retcode!=SQL_SUCCESS) {
      odbcerror(fp, PRIMARY_KEYS_ERR);
      fail;
    }
   
    /* create empty list */
    
    if ((hp=alclist(0, MinListSlots)) == NULL) fail;
    L.dword=D_List;
    L.vword.bptr=(union block *) hp;

    /* create record fields definition */
    if (proc == NULL)
       proc=dynrecord(&rectypename, colnames, DBKEYSNCOLS);
    

    /* populate list with column info */

    while (SQLFetch(hstmt)==SQL_SUCCESS) {
      /* allocate record */
      r = alcrecd(DBKEYSNCOLS, (union block *)proc);
      R.dword=D_Record;
      R.vword.bptr=(union block *) r;

      /* key column (varchar) */
      StrLoc(r->fields[0])=cbPkCol>0?alcstr((char *) szPkCol, cbPkCol):"";
      StrLen(r->fields[0])=cbPkCol>0?cbPkCol:0;
      if (StrLoc(r->fields[0]) == NULL) runerr(306);
          
      /* key sequence (integer) */
      MakeInt(iKeySeq, &(r->fields[1]));
        
      c_put(&L, &R);
    }

    if (SQLFreeStmt(hstmt, SQL_DROP)!=SQL_SUCCESS) {
      odbcerror(fp, FREE_STMT_ERR);
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
    tended struct descrip R;
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    static struct b_proc *proc;
    char sbuf[256];
    short i;
    
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
    
#ifdef MacOS
    static struct descrip colnames[19];
    static int cnm=0;  /* FIXME: thread unsafe  */
    if (!cnm) {
       AsgnCStr(colnames[cnm], "maxbinlitlen");
       cnm++;
       AsgnCStr(colnames[cnm], "maxcharlitlen");
       cnm++;
       AsgnCStr(colnames[cnm], "maxcolnamelen");
       cnm++;
       AsgnCStr(colnames[cnm], "maxgroupbycols");
       cnm++;
       AsgnCStr(colnames[cnm], "maxorderbycols");
       cnm++;
       AsgnCStr(colnames[cnm], "maxindexcols");
       cnm++;
       AsgnCStr(colnames[cnm], "maxselectcols");
       cnm++;
       AsgnCStr(colnames[cnm], "maxtblcols");
       cnm++;
       AsgnCStr(colnames[cnm], "maxcursnamelen");
       cnm++;
       AsgnCStr(colnames[cnm], "maxindexsize");
       cnm++;
       AsgnCStr(colnames[cnm], "maxownnamelen");
       cnm++;
       AsgnCStr(colnames[cnm], "maxprocnamelen");
       cnm++;
       AsgnCStr(colnames[cnm], "maxqualnamelen");
       cnm++;
       AsgnCStr(colnames[cnm], "maxrowsize");
       cnm++;
       AsgnCStr(colnames[cnm], "maxrowsizelong");
       cnm++;
       AsgnCStr(colnames[cnm], "maxstmtlen");
       cnm++;
       AsgnCStr(colnames[cnm], "maxtblnamelen");
       cnm++;
       AsgnCStr(colnames[cnm], "maxselecttbls");
       cnm++;
       AsgnCStr(colnames[cnm], "maxusernamelen");
       cnm++;
       }
#else					/* MacOS */
    static struct descrip colnames[19]={{12,(word)"maxbinlitlen"},
         {13,(word)"maxcharlitlen"}, {13,(word)"maxcolnamelen"},
         {14,(word)"maxgroupbycols"}, {14,(word)"maxorderbycols"},
         {12,(word)"maxindexcols"}, {13,(word)"maxselectcols"},
         {10,(word)"maxtblcols"}, {14,(word)"maxcursnamelen"},
         {12,(word)"maxindexsize"}, {13,(word)"maxownnamelen"},
         {14,(word)"maxprocnamelen"}, {14,(word)"maxqualnamelen"},
         {10,(word)"maxrowsize"}, {14,(word)"maxrowsizelong"},
         {10,(word)"maxstmtlen"}, {13,(word)"maxtblnamelen"},
         {13,(word)"maxselecttbls"}, {14,(word)"maxusernamelen"}};
#endif					/* MacOS */

    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* not an ODBC file */
      runerr(NOT_ODBC_FILE_ERR, f);
      }
    fp=FDESC(f); /* file descriptor */
    fp->proc = NULL;

    /* create record type */
    if (proc == NULL)
       proc=dynrecord(&rectypename, colnames, DBLIMITSNCOLS);

    /* allocate record */
    r = alcrecd(DBLIMITSNCOLS, (union block *)proc);
    R.dword=D_Record;
    R.vword.bptr=(union block *) r;

    for (i=0; i<DBLIMITSNCOLS; i++) {
      if (is_str[i]) {
        SQLGetInfo(fp->hdbc, (SQLUSMALLINT)sql_parm[i], sbuf, 255, &len);
        StrLoc(r->fields[i])=alcstr(sbuf,len);
        if (StrLoc(r->fields[i]) == NULL) runerr(306);
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
      char sbuf[256];    

      /* record structures */
      tended struct descrip R;
      tended struct descrip rectypename=emptystr;
      tended struct b_record *r;
      static struct b_proc *proc;
      short i;
      static int sql_parm[DBPRODNCOLS]={SQL_DBMS_NAME, SQL_DBMS_VER};
#ifdef MacOS
      static struct descrip colnames[2];
      static int cnm=0;  /* FIXME: thread unsafe  */
      if (!cnm) {
	 AsgnCStr(colnames[cnm], "name");
         cnm++;
	 AsgnCStr(colnames[cnm], "ver");
         cnm++;
	 }
#else
      static struct descrip colnames[]={{4,(word)"name"}, {3,(word)"ver"}};
#endif

      if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* not an ODBC file */
         runerr(NOT_ODBC_FILE_ERR, f);
         }

      fp=FDESC(f); /* file descriptor */
      fp->proc = NULL;

      /* allocate record */
      if (proc == NULL)
         proc = (struct b_proc *)dynrecord(&rectypename, colnames,DBPRODNCOLS);

      r = alcrecd(DBPRODNCOLS, (union block *)proc);
      R.dword=D_Record;
      R.vword.bptr=(union block *) r;
      for (i=0; i<DBPRODNCOLS; i++) {
         SQLGetInfo(fp->hdbc, (SQLUSMALLINT)sql_parm[i], sbuf, 255, &len);
         StrLoc(r->fields[i])=alcstr(sbuf, len);
         if (StrLoc(r->fields[i]) == NULL) runerr(306);
         StrLen(r->fields[i])=len;
         }
      return R;
      }
end


"sql(f, query) - submit an SQL query on an ODBC file f"
function{0,1} sql(f, query)
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
    fp->proc = NULL;

    SQLFreeStmt(fp->hstmt, SQL_CLOSE);

    rc=SQLExecDirect(fp->hstmt, (SQLCHAR *) StrLoc(query), StrLen(query));

    if(rc==SQL_ERROR || rc==SQL_SUCCESS_WITH_INFO) {
      odbcerror(fp, EXEC_DIRECT_ERR);
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

    tended struct descrip R;
    tended struct descrip rectypename=emptystr;
    tended struct b_record *r;
    static struct b_proc *proc;
    
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

    SQL_LENORIND cbQualif, cbOwner, cbName, cbType, cbRemarks;
    
    HSTMT hstmt;
    
#ifdef MacOS
      static struct descrip colnames[5];
      static int cnm=0; /* FIXME: thread unsafe  */
      if (!cnm) {
	 AsgnCStr(colnames[cnm], "qualifier");
	 cnm++;
	 AsgnCStr(colnames[cnm], "owner");
	 cnm++;
	 AsgnCStr(colnames[cnm], "name");
	 cnm++;
	 AsgnCStr(colnames[cnm], "type");
	 cnm++;
	 AsgnCStr(colnames[cnm], "remarks");
	 cnm++;
	 }
#else					/* MacOS */
    static struct descrip colnames[5]={
      {9,(word)"qualifier"}, {5,(word)"owner"}, {4,(word)"name"},
      {4,(word)"type"}, {7,(word)"remarks"}
    };
#endif					/* MacOS */

    if ((FSTATUS(f) & Fs_ODBC)!=Fs_ODBC) { /* ODBC file */
      runerr(NOT_ODBC_FILE_ERR, f);
    }

    fp=FDESC(f); /* file descriptor */
    fp->proc = NULL;

    if (SQLAllocStmt(fp->hdbc, &hstmt) != SQL_SUCCESS) {
      odbcerror(fp, ALLOC_STMT_ERR);
      fail;
    }

    retcode=SQLTables(hstmt, NULL, 0, NULL, 0, (SQLCHAR *) "%", SQL_NTS, NULL, 0);

    if (retcode!=SQL_SUCCESS) {
      odbcerror(fp, TABLES_ERR);
      fail;
    }    
     
    /* bind columns in result set to buffer (ODBC 2.x) */
    
    SQLBindCol(hstmt, 1, SQL_C_CHAR, szTblQualif, STR_LEN, &cbQualif);
    SQLBindCol(hstmt, 2, SQL_C_CHAR, szTblOwner, STR_LEN, &cbOwner);
    SQLBindCol(hstmt, 3, SQL_C_CHAR, szTblName, STR_LEN, &cbName);
    SQLBindCol(hstmt, 4, SQL_C_SSHORT, szTblType, 0, &cbType);
    SQLBindCol(hstmt, 5, SQL_C_CHAR, szRemarks, STR_LEN, &cbRemarks);
        
    /* create empty list */
    
    if ((hp=alclist(0, MinListSlots)) == NULL) fail;
    L.dword=D_List;
    L.vword.bptr=(union block *) hp;

    /* create record type */
    if (proc == NULL)
       proc=dynrecord(&rectypename, colnames, DBTBLNCOLS);
    
    while (SQLFetch(hstmt)==SQL_SUCCESS) {
      /* allocate record */
      r = alcrecd(DBTBLNCOLS, (union block *)proc);
      R.dword=D_Record;
      R.vword.bptr=(union block *) r;

      /* fill fields */
      StrLoc(r->fields[0])=cbQualif>0?alcstr((char *) szTblQualif,cbQualif):"";
      if (StrLoc(r->fields[0]) == NULL) runerr(306);
      StrLen(r->fields[0])=cbQualif>0?cbQualif:0;
      StrLoc(r->fields[1])=cbOwner>0?alcstr((char *) szTblOwner,cbOwner):"";
      if (StrLoc(r->fields[1]) == NULL) runerr(306);
      StrLen(r->fields[1])=cbOwner>0?cbOwner:0;
      StrLoc(r->fields[2])=cbName>0?alcstr((char *) szTblName,cbName):"";
      if (StrLoc(r->fields[2]) == NULL) runerr(306);
      StrLen(r->fields[2])=cbName>0?cbName:0;
      StrLoc(r->fields[3])=cbType>0?alcstr((char *) szTblType,cbType):"";
      if (StrLoc(r->fields[3]) == NULL) runerr(306);
      StrLen(r->fields[3])=cbType>0?cbType:0;
      StrLoc(r->fields[4])=cbRemarks>0?alcstr((char *) szRemarks,cbRemarks):"";
      if (StrLoc(r->fields[4]) == NULL) runerr(306);
      StrLen(r->fields[4])=cbRemarks>0?cbRemarks:0;
      
      c_put(&L, &R);
    }
    
    if (SQLFreeStmt(hstmt, SQL_DROP)!=SQL_SUCCESS) {
      odbcerror(fp, FREE_STMT_ERR);
      fail;
    }

    return L;
  }
end

#else					/* ISQL */
MissingFunc2(dbcolumns)
MissingFunc1(dbdriver)
MissingFunc2(dbkeys)
MissingFunc1(dblimits)
MissingFunc1(dbproduct)
MissingFunc2(sql)
MissingFunc1(dbtables)
#endif					/* ISQL */
