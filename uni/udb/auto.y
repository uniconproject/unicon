%{
#
#        File:     auto.y
#
#        Subject:  Automated debugging plugin to UDB
#
#        Author:   Eric Munson
#
#        Date:     November 2005
#

$include "evdefs.icn"

$define UNINIT 0
$define INIT 1

global convCount 
global gcStart
global gcEnd
global programStart
global runTime
global gcTime
global evCode
global value
global convLimit
global varName
global varState

record parseNode( label, varName, children )

%}

%token E_DEREF
%token E_ACONV
%token E_LRGINT
%token E_REAL
%token E_CSET
%token E_STRING
%token E_COLLECT
%token E_ENDCOLLECT
%token E_ASSIGN

%%
prog : events {
   $$ := node( "prog", "", $1 )
   };

events : events event {
   $$ := node( "events", "", $1, $2 )
   };

events : event {
   $$ := node( "events", "", $1 )
   };

event : conv_attempt |
        garbage_start |
        garbage_end |
        initialize_var { 
   $$ := node( "event", "", $1 )
   };

event : const_conv { };

event : var_read {
   $$ := node( "event read", "", $1 )
   if not( member( varState, $1.varName ) ) then {
      varState[ $1.varName ] := UNINIT
      }

   if uninitState == ON & varState[ $1.varName ] == UNINIT then {
      write( "Target program reads from uninitialized variable: " ||
             $1.varName[1: upto('-', $1.varName )] || " at " || 
             keyword( "line", Monitored ) || ":" ||
             keyword( "file", Monitored ) )
      }
   };

var_read : E_DEREF {
   $$ := node( "var read", value, $1 )
   };

conv_attempt : var_read E_ACONV {
   $$ := node( "init var", $1.varName, $1, $2 )
   if member( convCount, $$.varName ) then {
      convCount[ $$.varName ] +:= 1
      if convCount[ $$.varName ] >= convLimit then {
         write( "The type of variable " || $$.varName ||
                " is converted often enough to be suspicious." )
         }
      }
   else {
      convCount[ $$.varName ] := 1
      }

   };

const_conv : E_ACONV { };

initialize_var : E_ASSIGN {
   $$ := node( "init var", value, $1 )
   varState[ $$.varName ] := INIT
   };

garbage_start : E_COLLECT {
   gcStart := &time
   $$ := node( "garbage start", "", $1 )
   if gcEnd == 0 then {
      runTime +:= ( gcStart - programStart )
      }
   else {
      runTime +:= ( gcStart - gcEnd )
      }
   };

garbage_end : E_ENDCOLLECT {
   local ratio
   $$ := node( "garbage end", "", $1 )
   gcEnd := &time
   gcTime +:= ( gcEnd - gcStart )
   if gcTime <= 0.0 then {
      ratio := runTime
      }
   else {
      ratio := ( 1.0 * runTime ) / ( 1.0 * gcTime )
      }
   if ratio < 100.0 then {
      write( "The ratio of time spent in target program to time spent in " ||
         "the garbage collector is less than 100:1." )
      }
   };
%%

procedure yylex( )

   if evCode == 0 then {
      @&main
      }

   if evCode == E_Aconv then {
      evCode := 0
      return E_ACONV
      }
   else if evCode == E_Deref then {
      evCode := 0
      return E_DEREF
      }
   else if evCode == E_Collect then {
      evCode := 0
      return E_COLLECT
      }
   else if evCode == E_EndCollect then {
      evCode := 0
      return E_ENDCOLLECT
      }
   else if evCode == E_Assign then {
      evCode := 0
      return E_ASSIGN
      }

   return 0
end

procedure setEvCode( newCode, newValue )
   evCode := newCode
   value := newValue
end

procedure initParser( )
   convCount := table( )
   varState := table( )
   evCode := 0
   convLimit := 0
   gcTime := 0
   runTime := 0
   programStart := 0
   gcStart := 0
   gcEnd := 0
   yydebug := 0
end

procedure setConvLimit( newLimit )
   if newLimit >= 0 then
      convLimit := newLimit
end

procedure setStartTime( time )
   programStart := time
end

procedure node( label, varName, kids[] )
   return parseNode( label, varName, kids )
end

procedure leaf( label, varName )
   return parseNode( label, varName )
end
