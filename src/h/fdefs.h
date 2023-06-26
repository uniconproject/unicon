/*
 * Definitions of functions.
 */

#undef exit		/* may be defined under ConsoleWindow */

#if defined(Audio)
FncDef(PlayAudio,1)
FncDef(StopAudio,1)
#endif					/* Audio */

#if defined(Audio) || defined(HAVE_VOICE)
FncDefV(VAttrib)
#endif

FncDef(abs,1)
FncDef(acos,1)
FncDef(any,4)
FncDef(args,2)
FncDef(asin,1)
FncDef(atan,2)
FncDef(atanh,1)
FncDef(bal,6)
FncDef(center,3)
FncDef(char,1)
FncDef(chdir,1)
FncDef(close,1)
FncDef(cofail,1)
FncDef(collect,2)
FncDefV(constructor)
FncDef(copy,1)
FncDef(cos,1)
FncDef(cset,1)
#if defined(DEVELOPMODE)
FncDef(dbgbrk,0)
#endif                     /* DEVELOPMODE */
FncDef(delay,1)
FncDefV(delete)
FncDefV(detab)
FncDef(dtor,1)
FncDefV(entab)
FncDef(errorclear,0)
FncDef(exit,1)
FncDef(exp,1)
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
FncDef(key,1)
FncDef(left,3)
FncDef(list,2)
FncDef(log,2)
FncDef(many,4)
FncDef(map,3)
FncDef(match,4)
FncDefV(max)
FncDefV(member)
FncDefV(min)
FncDef(move,1)
FncDef(numeric,1)
FncDef(ord,1)
FncDef(pop,1)
FncDef(pos,1)
FncDef(pull,2)
FncDefV(push)
FncDefV(put)
FncDef(read,1)
FncDef(reads,2)
FncDef(real,1)
FncDef(remove,1)
FncDef(rename,2)
FncDef(repl,2)
FncDef(reverse,1)
FncDef(right,3)
FncDef(rtod,1)
FncDefV(runerr)
FncDef(seek,2)
FncDef(seq,2)
FncDef(serial,1)
FncDefV(set)
FncDef(sin,1)
FncDef(sort,2)
FncDef(sortf,2)
FncDef(sqrt,1)
FncDefV(stop)
FncDef(string,1)
FncDef(system,5)
FncDef(tab,1)
FncDefV(table)
FncDef(tan,1)
FncDef(trim,3)
FncDef(type,1)
FncDef(upto,4)
FncDef(where,1)
FncDefV(write)
FncDefV(writes)
#ifdef PatternType
     FncDef(pattern_match,2) /* ?? */
     FncDef(Any,1)    
     FncDef(Break,1) 
     FncDef(NotAny,1)
     FncDef(Span,1)
     FncDef(Nspan,1)
     FncDef(Arb,0)
     FncDef(Arbno,1)
     FncDef(pattern_concat,2) /* || */
     FncDef(pattern_alternate,2) /* .| */
     FncDef(pattern_setcur,1) /* .> */
     FncDef(Succeed,0)
     FncDef(Bal,0)
     FncDef(Breakx,1)
     FncDef(pattern_assign_immediate,2) /* => */
     FncDef(pattern_assign_onmatch,2)  /* -> */
     FncDef(Fence,1)
     FncDef(pattern_unevalvar,1)   /* `` */
     FncDef(Len,1)
     FncDef(Abort,0)
     FncDef(Rem,0)
     FncDef(pattern_stringfunccall,1)  /* ```` */
     FncDef(pattern_boolfunccall,1)    /* `` */
     FncDef(pattern_stringmethodcall,1)  /* ``x.y`` */
     FncDef(pattern_boolmethodcall,1)    /* `x.y` */
#undef Fail
     FncDef(Fail,0)
#define Fail return A_Resume
     FncDef(Pos,1)
     FncDef(Rpos,1)
     FncDef(Tab,1)
     FncDef(Rtab,1)
     FncDef(pindex_image, 1)
#endif					/* PatternType */


/*
 * Introspection functions initially introduced for Uniconc
 */
   FncDef(classname,1)
   FncDef(membernames,1)
   FncDef(methodnames,2)
   FncDef(methods,1)
   FncDef(oprec,1)


#ifdef Graphics
   FncDefV(open)
#else					/* Graphics */
   FncDef(open,3)
#endif					/* Graphics */

#ifdef MultiProgram
   FncDef(display,3)
   FncDef(name,2)
   FncDef(proc,3)
   FncDef(variable,4)
   FncDef(istate,2)
#else					/* MultiProgram */
   FncDef(display,2)
   FncDef(name,1)
   FncDef(proc,2)
   FncDef(variable,1)
#endif					/* MultiProgram */

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
FncDef(hardlink,2)
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
FncDef(getrusage, 1)
FncDefV(select)
FncDef(crypt,2)
FncDef(getpw,1)
FncDef(getgr,1)
FncDef(gethost,2)
FncDef(getserv,1)
FncDef(setpwent,0)
FncDef(setgrent,0)
FncDef(sethostent,1)
FncDef(setservent,1)
FncDef(ready,2)
FncDef(syswrite,2)
FncDef(send,2)
FncDef(receive,1)
FncDef(setenv,2)
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

   FncDef(WinAssociate, 1)
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

   FncDef(fieldnames,1)

#ifdef MultiProgram
   /*
    * These functions are under MultiProgram for no good reason.
    */
   FncDef(globalnames,1)
   FncDef(localnames,2)
   FncDef(staticnames,2)
   FncDef(paramnames,2)
   FncDef(structure,1)
   /*
    * These functions are inherent to MultiProgram and multiple Icon programs
    */
   FncDefV(load)
   FncDef(parent,1)
   FncDef(keyword,3)

   /*
    * Event processing functions.  These won't get you very far if no
    * events have been instrumented.
    */
   FncDef(EvGet,2)
   FncDef(EvSend,3)
   FncDef(eventmask,2)

#endif					/* MultiProgram */

/* SQL/ODBC database support */
#ifdef ISQL
  FncDef(dbcolumns,2)
  FncDef(dbdriver,1)
  FncDef(dbkeys,2)
  FncDef(dblimits,1)
  FncDef(dbproduct,1)
  FncDef(sql,2)
  FncDef(dbtables,1)
#endif					/* ISQL */

  FncDefV(DrawTorus)
  FncDefV(DrawCube)
  FncDefV(DrawSphere)
  FncDefV(Eye)
  FncDefV(Rotate)
  FncDefV(Translate)
  FncDefV(Scale)
  FncDefV(PushMatrix)
  FncDefV(PushTranslate)
  FncDefV(PushRotate)
  FncDefV(PushScale)
  FncDefV(PopMatrix)
  FncDefV(MultMatrix)
  FncDefV(IdentityMatrix)
  FncDefV(MatrixMode)
  FncDefV(DrawCylinder)
  FncDefV(DrawDisk)
  FncDefV(Texture)
  FncDefV(Texcoord)
  FncDefV(Normals)
  FncDefV(Refresh)
  FncDefV(WindowContents)
  FncDefV(WSection)

  FncDefV(array)

  FncDef(spawn,1)
  FncDef(mutex,2)
  FncDef(trylock,1)
  FncDef(lock,1)
  FncDef(unlock,1)
  FncDef(condvar,1)
  FncDef(signal,2)
  FncDefV(Attrib)

#ifdef HAVE_LIBCL
  FncDef(opencl, 1)
#endif					/* HAVE_LIBCL */
