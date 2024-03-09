/*
 * monitor.h - This file contains definitions for the various
 * event codes and values that go to make up event streams.
 *
 * The macro structure here allows the entire set of events to be enabled
 * by a single macro (EventMon) or, each individual event can be enabled
 * separately, to produce specialized virtual machines.
 */

/*
 * Note: the blank character should *not* be used as an event code.
 */

/*
 * Allocation events use lowercase codes.
 */
#if defined(EventMon) || defined(E_Lrgint)
#undef E_Lrgint
#define E_Lrgint        '\114'          /* Large integer allocation */
#else
#define E_Lrgint 0
#endif

#if defined(EventMon) || defined(E_Real)
#undef E_Real
#define E_Real          '\144'          /* Real allocation */
#else
#define E_Real 0
#endif

#if defined(EventMon) || defined(E_Cset)
#undef E_Cset
#define E_Cset          '\145'          /* Cset allocation */
#else
#define E_Cset 0
#endif

#if defined(EventMon) || defined(E_File)
#undef E_File
#define E_File          '\147'          /* File allocation */
#else
#define E_File 0
#endif

#if defined(EventMon) || defined(E_Record)
#undef E_Record
#define E_Record        '\150'          /* Record allocation */
#else
#define E_Record 0
#endif

#if defined(EventMon) || defined(E_Tvsubs)
#undef E_Tvsubs
#define E_Tvsubs        '\151'          /* Substring tv allocation */
#else
#define E_Tvsubs 0
#endif

#if defined(EventMon) || defined(E_External)
#undef E_External
#define E_External      '\152'          /* External allocation */
#else
#define E_External 0
#endif

#if defined(EventMon) || defined(E_List)
#undef E_List
#define E_List          '\153'          /* List allocation */
#else
#define E_List 0
#endif

#if defined(EventMon) || defined(E_Lelem)
#undef E_Lelem
#define E_Lelem         '\155'          /* List element allocation */
#else
#define E_Lelem 0
#endif

#if defined(EventMon) || defined(E_Table)
#undef E_Table
#define E_Table         '\156'          /* Table allocation */
#else
#define E_Table 0
#endif

#if defined(EventMon) || defined(E_Telem)
#undef E_Telem
#define E_Telem         '\157'          /* Table element allocation */
#else
#define E_Telem 0
#endif

#if defined(EventMon) || defined(E_Tvtbl)
#undef E_Tvtbl
#define E_Tvtbl         '\160'          /* Table-element tv allocation */
#else
#define E_Tvtbl 0
#endif

#if defined(EventMon) || defined(E_Set)
#undef E_Set
#define E_Set           '\161'          /* Set allocation */
#else
#define E_Set 0
#endif

#if defined(EventMon) || defined(E_Selem)
#undef E_Selem
#define E_Selem         '\164'          /* Set element allocation */
#else
#define E_Selem 0
#endif

#if defined(EventMon) || defined(E_Slots)
#undef E_Slots
#define E_Slots         '\167'          /* Hash header allocation */
#else
#define E_Slots 0
#endif

#if defined(EventMon) || defined(E_CoCreate)
#undef E_CoCreate
#define E_CoCreate      '\177'          /* Co-expression creation */
#else
#define E_CoCreate 0
#endif

#if defined(EventMon) || defined(E_Coexpr)
#undef E_Coexpr
#define E_Coexpr        '\170'          /* Co-expression allocation */
#else
#define E_Coexpr 0
#endif

#if defined(EventMon) || defined(E_Refresh)
#undef E_Refresh
#define E_Refresh       '\171'          /* Refresh allocation */
#else
#define E_Refresh 0
#endif

#if defined(EventMon) || defined(E_Alien)
#undef E_Alien
#define E_Alien         '\172'          /* Alien allocation */
#else
#define E_Alien 0
#endif

#if defined(EventMon) || defined(E_Free)
#undef E_Free
#define E_Free          '\132'          /* Free region */
#else
#define E_Free 0
#endif

#if defined(EventMon) || defined(E_String)
#undef E_String
#define E_String        '\163'          /* String allocation */
#else
#define E_String 0
#endif


/*
 * Some other monitoring codes.
 */
#if defined(EventMon) || defined(E_BlkDeAlc)
#undef E_BlkDeAlc
#define E_BlkDeAlc      '\055'          /* Block deallocation */
#else
#define E_BlkDeAlc 0
#endif

#if defined(EventMon) || defined(E_StrDeAlc)
#undef E_StrDeAlc
#define E_StrDeAlc      '\176'          /* String deallocation */
#else
#define E_StrDeAlc 0
#endif


/*
 * These are not "events"; they are provided for uniformity in tools
 *  that deal with types.
 */
#if defined(EventMon) || defined(E_Integer)
#undef E_Integer
#define E_Integer       '\100'          /* Integer value pseudo-event */
#else
#define E_Integer 0
#endif

#if defined(EventMon) || defined(E_Null)
#undef E_Null
#define E_Null          '\044'          /* Null value pseudo-event */
#else
#define E_Null 0
#endif

#if defined(EventMon) || defined(E_Proc)
#undef E_Proc
#define E_Proc          '\045'          /* Procedure value pseudo-event */
#else
#define E_Proc 0
#endif

#if defined(EventMon) || defined(E_Kywdint)
#undef E_Kywdint
#define E_Kywdint       '\136'          /* Integer keyword value pseudo-event */
#else
#define E_Kywdint 0
#endif

#if defined(EventMon) || defined(E_Kywdpos)
#undef E_Kywdpos
#define E_Kywdpos       '\046'          /* Position value pseudo-event */
#else
#define E_Kywdpos 0
#endif

#if defined(EventMon) || defined(E_Kywdsubj)
#undef E_Kywdsubj
#define E_Kywdsubj      '\052'          /* Subject value pseudo-event */
#else
#define E_Kywdsubj 0
#endif


/*
 * Codes for main sequence events
 */

   /*
    * Timing events
    */
#if defined(EventMon) || defined(E_Tick)
#undef E_Tick
#define E_Tick          '\270'          /* Clock tick */
#else
#define E_Tick 0
#endif



   /*
    * Code-location event
    */
#if defined(EventMon) || defined(E_Loc)
#undef E_Loc
#define E_Loc           '\273'          /* Location change */
#else
#define E_Loc 0
#endif

#if defined(EventMon) || defined(E_Line)
#undef E_Line
#define E_Line          '\274'          /* Line change */
#else
#define E_Line 0
#endif


   /*
    * Virtual-machine instructions
    */
#if defined(EventMon) || defined(E_Opcode)
#undef E_Opcode
#define E_Opcode        '\240'          /* Virtual-machine instruction */
#else
#define E_Opcode 0
#endif

#if defined(EventMon) || defined(E_Operand)
#undef E_Operand
#define E_Operand       '\241'          /* Virtual-machine Operand*/
#else
#define E_Operand 0
#endif


   /*
    * Type-conversion events
    */
#if defined(EventMon) || defined(E_Aconv)
#undef E_Aconv
#define E_Aconv         '\111'          /* Conversion attempt */
#else
#define E_Aconv 0
#endif

#if defined(EventMon) || defined(E_Tconv)
#undef E_Tconv
#define E_Tconv         '\113'          /* Conversion target */
#else
#define E_Tconv 0
#endif

#if defined(EventMon) || defined(E_Nconv)
#undef E_Nconv
#define E_Nconv         '\116'          /* Conversion not needed */
#else
#define E_Nconv 0
#endif

#if defined(EventMon) || defined(E_Sconv)
#undef E_Sconv
#define E_Sconv         '\121'          /* Conversion success */
#else
#define E_Sconv 0
#endif

#if defined(EventMon) || defined(E_Fconv)
#undef E_Fconv
#define E_Fconv         '\112'          /* Conversion failure */
#else
#define E_Fconv 0
#endif


   /*
    * Structure events
    */
#if defined(EventMon) || defined(E_Lbang)
#undef E_Lbang
#define E_Lbang         '\301'          /* List generation */
#else
#define E_Lbang 0
#endif

#if defined(EventMon) || defined(E_Lcreate)
#undef E_Lcreate
#define E_Lcreate       '\302'          /* List creation */
#else
#define E_Lcreate 0
#endif

#if defined(EventMon) || defined(E_Lget)
#undef E_Lget
#define E_Lget          '\356'          /* List get/pop -- only E_Lget used */
#else
#define E_Lget 0
#endif

#if defined(EventMon) || defined(E_Lpop)
#undef E_Lpop
#define E_Lpop          '\356'          /* List get/pop */
#else
#define E_Lpop 0
#endif

#if defined(EventMon) || defined(E_Lpull)
#undef E_Lpull
#define E_Lpull         '\304'          /* List pull */
#else
#define E_Lpull 0
#endif

#if defined(EventMon) || defined(E_Lpush)
#undef E_Lpush
#define E_Lpush         '\305'          /* List push */
#else
#define E_Lpush 0
#endif

#if defined(EventMon) || defined(E_Lput)
#undef E_Lput
#define E_Lput          '\306'          /* List put */
#else
#define E_Lput 0
#endif

#if defined(EventMon) || defined(E_Lrand)
#undef E_Lrand
#define E_Lrand         '\307'          /* List random reference */
#else
#define E_Lrand 0
#endif

#if defined(EventMon) || defined(E_Lref)
#undef E_Lref
#define E_Lref          '\310'          /* List reference */
#else
#define E_Lref 0
#endif

#if defined(EventMon) || defined(E_Lsub)
#undef E_Lsub
#define E_Lsub          '\311'          /* List subscript */
#else
#define E_Lsub 0
#endif

#if defined(EventMon) || defined(E_Ldelete)
#undef E_Ldelete
#define E_Ldelete       '\357'          /* List delete */
#else
#define E_Ldelete 0
#endif

#if defined(EventMon) || defined(E_Rbang)
#undef E_Rbang
#define E_Rbang         '\312'          /* Record generation */
#else
#define E_Rbang 0
#endif

#if defined(EventMon) || defined(E_Rcreate)
#undef E_Rcreate
#define E_Rcreate       '\313'          /* Record creation */
#else
#define E_Rcreate 0
#endif

#if defined(EventMon) || defined(E_Rrand)
#undef E_Rrand
#define E_Rrand         '\314'          /* Record random reference */
#else
#define E_Rrand 0
#endif

#if defined(EventMon) || defined(E_Rref)
#undef E_Rref
#define E_Rref          '\315'          /* Record reference */
#else
#define E_Rref 0
#endif

#if defined(EventMon) || defined(E_Rsub)
#undef E_Rsub
#define E_Rsub          '\316'          /* Record subscript */
#else
#define E_Rsub 0
#endif

#if defined(EventMon) || defined(E_Sbang)
#undef E_Sbang
#define E_Sbang         '\317'          /* Set generation */
#else
#define E_Sbang 0
#endif

#if defined(EventMon) || defined(E_Screate)
#undef E_Screate
#define E_Screate       '\320'          /* Set creation */
#else
#define E_Screate 0
#endif

#if defined(EventMon) || defined(E_Sdelete)
#undef E_Sdelete
#define E_Sdelete       '\321'          /* Set deletion */
#else
#define E_Sdelete 0
#endif

#if defined(EventMon) || defined(E_Sinsert)
#undef E_Sinsert
#define E_Sinsert       '\322'          /* Set insertion */
#else
#define E_Sinsert 0
#endif

#if defined(EventMon) || defined(E_Smember)
#undef E_Smember
#define E_Smember       '\323'          /* Set membership */
#else
#define E_Smember 0
#endif

#if defined(EventMon) || defined(E_Srand)
#undef E_Srand
#define E_Srand         '\336'          /* Set random reference */
#else
#define E_Srand 0
#endif

#if defined(EventMon) || defined(E_Sval)
#undef E_Sval
#define E_Sval          '\324'          /* Set value */
#else
#define E_Sval 0
#endif

#if defined(EventMon) || defined(E_Tbang)
#undef E_Tbang
#define E_Tbang         '\325'          /* Table generation */
#else
#define E_Tbang 0
#endif

#if defined(EventMon) || defined(E_Tcreate)
#undef E_Tcreate
#define E_Tcreate       '\326'          /* Table creation */
#else
#define E_Tcreate 0
#endif

#if defined(EventMon) || defined(E_Tdelete)
#undef E_Tdelete
#define E_Tdelete       '\327'          /* Table deletion */
#else
#define E_Tdelete 0
#endif

#if defined(EventMon) || defined(E_Tinsert)
#undef E_Tinsert
#define E_Tinsert       '\330'          /* Table insertion */
#else
#define E_Tinsert 0
#endif

#if defined(EventMon) || defined(E_Tkey)
#undef E_Tkey
#define E_Tkey          '\331'          /* Table key generation */
#else
#define E_Tkey 0
#endif

#if defined(EventMon) || defined(E_Tmember)
#undef E_Tmember
#define E_Tmember       '\332'          /* Table membership */
#else
#define E_Tmember 0
#endif

#if defined(EventMon) || defined(E_Trand)
#undef E_Trand
#define E_Trand         '\337'          /* Table random reference */
#else
#define E_Trand 0
#endif

#if defined(EventMon) || defined(E_Tref)
#undef E_Tref
#define E_Tref          '\333'          /* Table reference */
#else
#define E_Tref 0
#endif

#if defined(EventMon) || defined(E_Tsub)
#undef E_Tsub
#define E_Tsub          '\334'          /* Table subscript */
#else
#define E_Tsub 0
#endif

#if defined(EventMon) || defined(E_Tval)
#undef E_Tval
#define E_Tval          '\335'          /* Table value */
#else
#define E_Tval 0
#endif


   /*
    * Scanning events
    */

#if defined(EventMon) || defined(E_Snew)
#undef E_Snew
#define E_Snew          '\340'          /* Scanning environment creation */
#else
#define E_Snew 0
#endif

#if defined(EventMon) || defined(E_Sfail)
#undef E_Sfail
#define E_Sfail         '\341'          /* Scanning failure */
#else
#define E_Sfail 0
#endif

#if defined(EventMon) || defined(E_Ssusp)
#undef E_Ssusp
#define E_Ssusp         '\266'          /* Scanning suspension */
#else
#define E_Ssusp 0
#endif

#if defined(EventMon) || defined(E_Sresum)
#undef E_Sresum
#define E_Sresum        '\267'          /* Scanning resumption */
#else
#define E_Sresum 0
#endif

#if defined(EventMon) || defined(E_Srem)
#undef E_Srem
#define E_Srem          '\344'          /* Scanning environment removal */
#else
#define E_Srem 0
#endif

#if defined(EventMon) || defined(E_Spos)
#undef E_Spos
#define E_Spos          '\346'          /* Scanning position */
#else
#define E_Spos 0
#endif


   /*
    * Assignment
    */

#if defined(EventMon) || defined(E_Assign)
#undef E_Assign
#define E_Assign        '\347'          /* Assignment */
#else
#define E_Assign 0
#endif

#if defined(EventMon) || defined(E_Value)
#undef E_Value
#define E_Value         '\350'          /* Value assigned */
#else
#define E_Value 0
#endif

#if defined(EventMon) || defined(E_Deref)
#undef E_Deref
#define E_Deref         '\363'          /* Dereference */
#else
#define E_Deref 0
#endif



   /*
    * Sub-string assignment
    */

#if defined(EventMon) || defined(E_Ssasgn)
#undef E_Ssasgn
#define E_Ssasgn        '\354'          /* Sub-string assignment */
#else
#define E_Ssasgn 0
#endif


   /*
    * Interpreter stack events
    */

#if defined(EventMon) || defined(E_Intcall)
#undef E_Intcall
#define E_Intcall       '\275'          /* interpreter call */
#else
#define E_Intcall 0
#endif

#if defined(EventMon) || defined(E_Intret)
#undef E_Intret
#define E_Intret        '\276'          /* interpreter return */
#else
#define E_Intret 0
#endif

#if defined(EventMon) || defined(E_Stack)
#undef E_Stack
#define E_Stack         '\272'          /* stack depth */
#else
#define E_Stack 0
#endif

#if defined(EventMon) || defined(E_Cstack)
#undef E_Cstack
#define E_Cstack                '\271'          /* C stack depth */
#else
#define E_Cstack 0
#endif

   /*
    * Expression events
    */
#if defined(EventMon) || defined(E_Ecall)
#undef E_Ecall
#define E_Ecall         '\143'          /* Call of operation */
#else
#define E_Ecall 0
#endif

#if defined(EventMon) || defined(E_Efail)
#undef E_Efail
#define E_Efail         '\251'          /* Failure from expression */
#else
#define E_Efail 0
#endif

#if defined(EventMon) || defined(E_Bsusp)
#undef E_Bsusp
#define E_Bsusp         '\250'          /* Suspension from operation */
#else
#define E_Bsusp 0
#endif

#if defined(EventMon) || defined(E_Esusp)
#undef E_Esusp
#define E_Esusp         '\141'          /* Suspension from alternation */
#else
#define E_Esusp 0
#endif

#if defined(EventMon) || defined(E_Lsusp)
#undef E_Lsusp
#define E_Lsusp         '\154'          /* Suspension from limitation */
#else
#define E_Lsusp 0
#endif

#if defined(EventMon) || defined(E_Eresum)
#undef E_Eresum
#define E_Eresum        '\236'          /* Resumption of expression */
#else
#define E_Eresum 0
#endif

#if defined(EventMon) || defined(E_Erem)
#undef E_Erem
#define E_Erem          '\237'          /* Removal of a suspended generator */
#else
#define E_Erem 0
#endif

#if defined(EventMon) || defined(E_Syntax)
#undef E_Esyntax
#define E_Syntax        '\242'          /* Source code syntax change */
#else
#define E_Syntax 0
#endif

   /*
    * Co-expression events
    */

#if defined(EventMon) || defined(E_Coact)
#undef E_Coact
#define E_Coact         '\101'          /* Co-expression activation */
#else
#define E_Coact 0
#endif

#if defined(EventMon) || defined(E_Coret)
#undef E_Coret
#define E_Coret         '\102'          /* Co-expression return */
#else
#define E_Coret 0
#endif

#if defined(EventMon) || defined(E_Cofail)
#undef E_Cofail
#define E_Cofail        '\104'          /* Co-expression failure */
#else
#define E_Cofail 0
#endif


   /*
    * Procedure events
    */

#if defined(EventMon) || defined(E_Pcall)
#undef E_Pcall
#define E_Pcall         '\103'          /* Procedure call */
#else
#define E_Pcall 0
#endif

#if defined(EventMon) || defined(E_Pfail)
#undef E_Pfail
#define E_Pfail         '\246'          /* Procedure failure */
#else
#define E_Pfail 0
#endif

#if defined(EventMon) || defined(E_Pret)
#undef E_Pret
#define E_Pret          '\245'          /* Procedure return */
#else
#define E_Pret 0
#endif

#if defined(EventMon) || defined(E_Psusp)
#undef E_Psusp
#define E_Psusp         '\243'          /* Procedure suspension */
#else
#define E_Psusp 0
#endif

#if defined(EventMon) || defined(E_Presum)
#undef E_Presum
#define E_Presum        '\244'          /* Procedure resumption */
#else
#define E_Presum 0
#endif

#if defined(EventMon) || defined(E_Prem)
#undef E_Prem
#define E_Prem          '\247'          /* Suspended procedure removal */
#else
#define E_Prem 0
#endif


#if defined(EventMon) || defined(E_Fcall)
#undef E_Fcall
#define E_Fcall         '\252'          /* Function call */
#else
#define E_Fcall 0
#endif

#if defined(EventMon) || defined(E_Ffail)
#undef E_Ffail
#define E_Ffail         '\256'          /* Function failure */
#else
#define E_Ffail 0
#endif

#if defined(EventMon) || defined(E_Fret)
#undef E_Fret
#define E_Fret          '\255'          /* Function return */
#else
#define E_Fret 0
#endif

#if defined(EventMon) || defined(E_Fsusp)
#undef E_Fsusp
#define E_Fsusp         '\253'          /* Function suspension */
#else
#define E_Fsusp 0
#endif

#if defined(EventMon) || defined(E_Fresum)
#undef E_Fresum
#define E_Fresum        '\254'          /* Function resumption */
#else
#define E_Fresum 0
#endif

#if defined(EventMon) || defined(E_Frem)
#undef E_Frem
#define E_Frem          '\257'          /* Function suspension removal */
#else
#define E_Frem 0
#endif


#if defined(EventMon) || defined(E_Ocall)
#undef E_Ocall
#define E_Ocall         '\260'          /* Operator call */
#else
#define E_Ocall 0
#endif

#if defined(EventMon) || defined(E_Ofail)
#undef E_Ofail
#define E_Ofail         '\262'          /* Operator failure */
#else
#define E_Ofail 0
#endif

#if defined(EventMon) || defined(E_Oret)
#undef E_Oret
#define E_Oret          '\261'          /* Operator return */
#else
#define E_Oret 0
#endif

#if defined(EventMon) || defined(E_Osusp)
#undef E_Osusp
#define E_Osusp         '\263'          /* Operator suspension */
#else
#define E_Osusp 0
#endif

#if defined(EventMon) || defined(E_Oresum)
#undef E_Oresum
#define E_Oresum        '\264'          /* Operator resumption */
#else
#define E_Oresum 0
#endif

#if defined(EventMon) || defined(E_Orem)
#undef E_Orem
#define E_Orem          '\265'          /* Operator suspension removal */
#else
#define E_Orem 0
#endif


   /*
    * Garbage collections
    */

#if defined(EventMon) || defined(E_Collect)
#undef E_Collect
#define E_Collect       '\107'          /* Garbage collection */
#else
#define E_Collect 0
#endif

#if defined(EventMon) || defined(E_EndCollect)
#undef E_EndCollect
#define E_EndCollect    '\360'          /* End of garbage collection */
#else
#define E_EndCollect 0
#endif

#if defined(EventMon) || defined(E_TenureString)
#undef E_TenureString
#define E_TenureString  '\361'          /* Tenure a string region */
#else
#define E_TenureString 0
#endif

#if defined(EventMon) || defined(E_TenureBlock)
#undef E_TenureBlock
#define E_TenureBlock   '\362'          /* Tenure a block region */
#else
#define E_TenureBlock 0
#endif


/*
 * Termination Events
 */
#if defined(EventMon) || defined(E_Error)
#undef E_Error
#define E_Error         '\105'          /* Run-time error */
#else
#define E_Error 0
#endif

#if defined(EventMon) || defined(E_Exit)
#undef E_Exit
#define E_Exit          '\130'          /* Program exit */
#else
#define E_Exit 0
#endif


   /*
    * I/O events
    */
#if defined(EventMon) || defined(E_MXevent)
#undef E_MXevent
#define E_MXevent       '\370'          /* monitor input event */
#else
#define E_MXevent 0
#endif

#if defined(EventMon) || defined(E_Literal)
#undef E_Literal
#define E_Literal       '\277'
#else
#define E_Literal 0
#endif

#if defined(EventMon) || defined(E_Signal)
#undef E_Signal
#define E_Signal        '\300'
#else
#define E_Signal 0
#endif

#if defined(EventMon) || defined(E_Pattern)
#undef E_Pattern
#define E_Pattern       '\060'
#else
#define E_Pattern 0
#endif

#if defined(EventMon) || defined(E_Pelem)
#undef E_Pelem
#define E_Pelem         '\061'
#else
#define E_Pelem 0
#endif

#if defined(EventMon) || defined(E_PatCode)
#undef E_PatCode
#define E_PatCode        '\062'
#else
#define E_PatCode 0
#endif

#if defined(EventMon) || defined(E_PatAttempt)
#undef E_PatAttempt
#define E_PatAttempt '\063'
#else
#define E_PatAttempt 0
#endif

#if defined(EventMon) || defined(E_PatMatch)
#undef E_PatMatch
#define E_PatMatch '\064'
#else
#define E_PatMatch 0
#endif

#if defined(EventMon) || defined(E_PatFail)
#undef E_PatFail
#define E_PatFail '\065'
#else
#define E_PatFail 0
#endif

#if defined(EventMon) || defined(E_PelemAttempt)
#undef E_PelemAttempt
#define E_PelemAttempt '\066'
#else
#define E_PelemAttempt 0
#endif

#if defined(EventMon) || defined(E_PelemMatch)
#undef E_PelemMatch
#define E_PelemMatch '\067'
#else
#define E_PelemMatch 0
#endif

#if defined(EventMon) || defined(E_PelemFail)
#undef E_PelemFail
#define E_PelemFail '\070'
#else
#define E_PelemFail 0
#endif

#if defined(EventMon) || defined(E_PatArg)
#undef E_PatArg
#define E_PatArg '\071'
#else
#define E_PatArg 0
#endif

#if defined(EventMon) || defined(E_PatVal)
#undef E_PatVal
#define E_PatVal '\072'
#else
#define E_PatVal 0
#endif

#if defined(EventMon) || defined(E_PatPush)
#undef E_PatPush
#define E_PatPush '\073'
#else
#define E_PatPush 0
#endif

#if defined(EventMon) || defined(E_PatPop)
#undef E_PatPop
#define E_PatPop '\074'
#else
#define E_PatPop 0
#endif

/*
 * Events for hash table details. The table events like E_Tsub
 * already provide keys.  E_HashNum is a number returned by hash().
 * E_HashSlots is an expansion of the buckets for a given set/table.
 * E_HashChain is the number of link list elements traversed in a lookup.
 */

#if defined(EventMon) || defined(E_HashNum)
#undef E_HashNum
#define E_HashNum       '\173'
#else
#define E_HashNum 0
#endif

#if defined(EventMon) || defined(E_HashSlots)
#undef E_HashSlots
#define E_HashSlots       '\174'
#else
#define E_HashSlots 0
#endif

#if defined(EventMon) || defined(E_HashChain)
#undef E_HashChain
#define E_HashChain       '\175'
#else
#define E_HashChain 0
#endif



/* unused pool.  how many event codes are unused?  DON'T USE 000.
                                        Decimal
000 001 002 003 004 005 006 007
010 011 012 013 014 015 016 017
020 021 022 023 024 025 026 027         16
030 031 032 033 034 035 036 037
                                                blank line for readability
040 041 042 043 047                     32
050 051     053 054     056 057

                    075 076 077
-------------------------------                 blank line for readability
                        106             64
110                 115     117
120     122 123 124 125 126 127
    131     133 134 135     137
-------------------------------                 blank line for readability
140     142             146             96

        162         165 166

-------------------------------                 blank line for readability
200 201 202 203 204 205 206 207         128     SPECIAL SECTION. From 128-191
210 211 212 213 214 215 216 217                 RESERVED FOR interp() stuff.
220 221 222 223 224 225 226 227         144
230 231 232 233 234 235
-------------------------------                 blank line for readability
                                        160     SPECIAL SECTION. From 128-191
                                                RESERVED FOR interp() stuff.


-------------------------------
            303                         192



        342 343     345
    351 352 353     355
                364 365 366 367
    371 372 373 374 375 376 377
*/
