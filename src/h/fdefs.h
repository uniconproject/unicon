/*
 * Definitions of functions.
 */

#undef exit		/* may be defined under ConsoleWindow */
#undef getenv		/* may be defined under AMIGA */

FncDef(abs,1)
FncDef(acos,1)
FncDef(any,4)
FncDef(args,1)
FncDef(asin,1)
FncDef(atan,2)
FncDef(bal,6)
FncDef(center,3)
FncDef(char,1)
FncDef(chdir,1)
FncDef(close,1)
FncDef(collect,2)
FncDefV(constructor)
FncDef(copy,1)
FncDef(cos,1)
FncDef(cset,1)
FncDef(delete,2)
FncDefV(detab)
FncDef(dtor,1)
FncDefV(entab)
FncDef(errorclear,0)
FncDef(exit,1)
FncDef(exp,2)
FncDef(find,4)
FncDef(flush,1)
FncDef(function,0)
FncDef(get,2)
FncDef(getenv,1)
FncDef(iand,2)
FncDef(icom,1)
FncDef(image,1)
FncDef(insert,3)
FncDef(integer,1)
FncDef(ior,2)
FncDef(ishift,2)
FncDef(ixor,2)
FncDef(key,2)
FncDef(left,3)
FncDef(list,2)
FncDef(log,1)
FncDef(many,4)
FncDef(map,3)
FncDef(match,4)
FncDefV(max)
FncDef(member,1)
FncDefV(min)
FncDef(move,1)
FncDef(numeric,1)
FncDef(ord,1)
FncDef(pop,1)
FncDef(pos,1)
FncDef(pull,1)
FncDefV(push)
FncDefV(put)
FncDef(read,2)
FncDef(reads,2)
FncDef(real,1)
FncDef(remove,2)
FncDef(rename,1)
FncDef(repl,2)
FncDef(reverse,1)
FncDef(right,3)
FncDef(rtod,1)
FncDefV(runerr)
FncDef(seek,2)
FncDef(seq,2)
FncDef(serial,1)
FncDef(set,1)
FncDef(sin,1)
FncDef(sort,2)
FncDef(sortf,2)
FncDef(sqrt,1)
FncDefV(stop)
FncDef(string,1)
FncDef(system,5)
FncDef(tab,1)
FncDef(table,1)
FncDef(tan,1)
FncDef(trim,2)
FncDef(type,1)
FncDef(upto,4)
FncDef(where,1)
FncDefV(write)
FncDefV(writes)

#if AMIGA || UNIX || VMS || OS2_32 || NT || SCCX_MX
   FncDef(delay,1)
#endif					/* AMIGA || UNIX || VMS || OS2_32... */

#ifdef Graphics
   FncDefV(open)
#else					/* Graphics */
   FncDef(open,3)
#endif					/* Graphics */

#ifdef MultiThread
   FncDef(display,3)
   FncDef(name,2)
   FncDef(proc,3)
   FncDef(variable,3)
#else					/* MultiThread */
   FncDef(display,2)
   FncDef(name,1)
   FncDef(proc,2)
   FncDef(variable,1)
#endif					/* MultiThread */

/*
 * Dynamic loading.
 */
#ifdef LoadFunc
   FncDef(loadfunc,2)
#endif					/* LoadFunc */

/*
 * Executable images.
 */
#ifdef ExecImages
   FncDef(save,1)
#endif					/* ExecImages */

/*
 * External functions.
 */
#ifdef ExternalFunctions
   FncDefV(callout)
#endif					/* ExternalFunctions */

/*
 * Keyboard Functions
 */
#ifdef KeyboardFncs
   FncDef(getch,0)
   FncDef(getche,0)
   FncDef(kbhit,0)
#endif					/* KeyboardFncs */

/*
 * The POSIX interface
 */
#ifdef PosixFns
FncDef(sys_errstr,1)
FncDef(getppid,0)
FncDef(getpid,0)
FncDef(kill,2)
FncDef(trap,2)
FncDef(symlink,2)
FncDef(link,2)
FncDef(readlink,1)
FncDef(mkdir,2)
FncDef(rmdir,1)
FncDef(chmod,2)
FncDef(chown,3)
FncDef(truncate,2)
FncDef(utime,3)
FncDef(flock,2)
FncDef(ioctl,3)
FncDef(fcntl,3)
FncDef(pipe,0)
FncDef(filepair,0)
FncDef(chroot,1)
FncDef(fork,0)
FncDef(fdup,2)
FncDefV(exec)
FncDef(getuid,0)
FncDef(geteuid,0)
FncDef(setuid,2)
FncDef(getgid,0)
FncDef(getegid,0)
FncDef(setgid,2)
FncDef(getpgrp,0)
FncDef(setpgrp,0)
FncDef(umask,1)
FncDef(wait,2)
FncDef(stat,1)
FncDef(lstat,1)
FncDef(ctime,1)
FncDef(gtime,1)
FncDef(gettimeofday,0)
FncDefV(select)
FncDef(crypt,2)
FncDef(getpw,1)
FncDef(getgr,1)
FncDef(gethost,1)
FncDef(getserv,1)
FncDef(setpwent,0)
FncDef(setgrent,0)
FncDef(sethostent,1)
FncDef(setservent,1)
FncDef(sysread,2)
FncDef(send,2)
FncDef(receive,1)
#endif					/* PosixFns */

#ifdef PosixFns
#ifdef Dbm
FncDef(fetch,2)
#endif					/* Dbm */
#endif					/* PosixFns */
/*
 * Functions for MS-DOS.
 */
#ifdef DosFncs
   FncDef(Int86,1)
   FncDef(Peek,1)
   FncDef(Poke,1)
   FncDef(GetSpace,1)
   FncDef(FreeSpace,1)
   FncDef(InPort,1)
   FncDef(OutPort,1)
#endif					/* DosFncs */

/*
 * Functions for the Archimedes.
 */
#ifdef ArmFncs
   FncDef(Swi,2)
   FncDef(Peek,2)
   FncDef(Poke,2)
   FncDef(GetSpace,1)
   FncDef(FreeSpace,1)
#endif					/* ArmFncs */


/*
 * Graphics functions.  These are always defined; in virtual machines
 * without graphics facilities, calling them is a runtime error.
 */

   FncDef(Active,0)
   FncDefV(Alert)
   FncDefV(Bg)
   FncDefV(Clip)
   FncDefV(Clone)
   FncDefV(Color)
   FncDefV(ColorValue)
   FncDefV(CopyArea)
   FncDefV(Couple)
   FncDefV(DrawArc)
   FncDefV(DrawCircle)
   FncDefV(DrawCurve)
   FncDefV(DrawImage)
   FncDefV(DrawLine)
   FncDefV(DrawPoint)
   FncDefV(DrawPolygon)
   FncDefV(DrawRectangle)
   FncDefV(DrawSegment)
   FncDefV(DrawString)
   FncDefV(EraseArea)
   FncDefV(Event)
   FncDefV(Fg)
   FncDefV(FillArc)
   FncDefV(FillCircle)
   FncDefV(FillPolygon)
   FncDefV(FillRectangle)
   FncDefV(Font)
   FncDefV(FreeColor)
   FncDefV(GotoRC)
   FncDefV(GotoXY)
   FncDefV(Lower)
   FncDefV(NewColor)
   FncDefV(PaletteChars)
   FncDefV(PaletteColor)
   FncDefV(PaletteKey)
   FncDefV(Pattern)
   FncDefV(Pending)
   FncDefV(Pixel)
   FncDef(QueryPointer,1)
   FncDefV(Raise)
   FncDefV(ReadImage)
   FncDefV(TextWidth)
   FncDef(Uncouple,1)
   FncDefV(WAttrib)
   FncDefV(WDefault)
   FncDefV(WFlush)
   FncDef(WSync,1)
   FncDefV(WriteImage)

   FncDefV(WinPlayMedia)
   FncDefV(WinEditRegion)
   FncDefV(WinButton)
   FncDefV(WinScrollBar)
   FncDefV(WinMenuBar)
   FncDefV(WinColorDialog)
   FncDefV(WinFontDialog)
   FncDefV(WinOpenDialog)
   FncDefV(WinSaveDialog)
   FncDefV(WinSelectDialog)
   #ifdef FAttrib
      FncDefV(fattrib)
   #endif				/* FAttrib */


#ifdef MultiThread
   /*
    * These functions are under MultiThread for no good reason.
    */
   FncDef(cofail,1)
   FncDef(globalnames,1)
   FncDef(fieldnames,1)
   FncDef(localnames,2)
   FncDef(staticnames,2)
   FncDef(paramnames,2)
   FncDef(structure,1)
   /*
    * These functions are inherent to MultiThread and multiple Icon programs
    */
   FncDefV(load)
   FncDef(parent,1)
   FncDef(keyword,2)

/*
 * Event processing functions.  Formerly under #ifdef EventMon, but now any
 * MultiThread icont believes in them; disable at runtime in non EventMon
 * versions of iconx.
 */
   FncDef(EvGet,2)
   FncDef(event,3)
   FncDef(eventmask,2)
   FncDef(opmask,2)

#endif					/* MultiThread */

/* subsumed by Unicon ? */
#ifdef FAttrib
FncDefV(fattrib)
#endif					/* FAttrib */

/* SQL/ODBC database support */
#ifdef ISQL
  FncDef(dbcolumns,1)
  FncDef(dbdelete,2)
  FncDef(dbdriver,1)
  FncDef(dbinsert,2)
  FncDef(dbkeys,1)
  FncDef(dblimits,1)
  FncDef(dbproduct,1)
  FncDefV(dbselect)
  FncDef(dbsql,2)
  FncDef(dbtables,1)
  FncDef(dbupdate,2)
#endif					/* ISQL */
