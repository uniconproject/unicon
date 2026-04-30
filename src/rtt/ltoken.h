/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_RTTGRAM_TAB_H_INCLUDED
# define YY_YY_RTTGRAM_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 368,                 /* "invalid token"  */
    Identifier = 257,              /* Identifier  */
    StrLit = 258,                  /* StrLit  */
    LStrLit = 259,                 /* LStrLit  */
    FltConst = 260,                /* FltConst  */
    DblConst = 261,                /* DblConst  */
    LDblConst = 262,               /* LDblConst  */
    CharConst = 263,               /* CharConst  */
    LCharConst = 264,              /* LCharConst  */
    IntConst = 265,                /* IntConst  */
    UIntConst = 266,               /* UIntConst  */
    LIntConst = 267,               /* LIntConst  */
    ULIntConst = 268,              /* ULIntConst  */
    Arrow = 269,                   /* Arrow  */
    Incr = 270,                    /* Incr  */
    Decr = 271,                    /* Decr  */
    LShft = 272,                   /* LShft  */
    RShft = 273,                   /* RShft  */
    Leq = 274,                     /* Leq  */
    Geq = 275,                     /* Geq  */
    Equal = 276,                   /* Equal  */
    Neq = 277,                     /* Neq  */
    And = 278,                     /* And  */
    Or = 279,                      /* Or  */
    MultAsgn = 280,                /* MultAsgn  */
    DivAsgn = 281,                 /* DivAsgn  */
    ModAsgn = 282,                 /* ModAsgn  */
    PlusAsgn = 283,                /* PlusAsgn  */
    MinusAsgn = 284,               /* MinusAsgn  */
    LShftAsgn = 285,               /* LShftAsgn  */
    RShftAsgn = 286,               /* RShftAsgn  */
    AndAsgn = 287,                 /* AndAsgn  */
    XorAsgn = 288,                 /* XorAsgn  */
    OrAsgn = 289,                  /* OrAsgn  */
    Sizeof = 290,                  /* Sizeof  */
    Intersect = 291,               /* Intersect  */
    OpSym = 292,                   /* OpSym  */
    Typedef = 293,                 /* Typedef  */
    Extern = 294,                  /* Extern  */
    Static = 295,                  /* Static  */
    Auto = 296,                    /* Auto  */
    Register = 297,                /* Register  */
    Tended = 298,                  /* Tended  */
    Char = 299,                    /* Char  */
    Short = 300,                   /* Short  */
    Int = 301,                     /* Int  */
    Long = 302,                    /* Long  */
    Signed = 303,                  /* Signed  */
    Unsigned = 304,                /* Unsigned  */
    Float = 305,                   /* Float  */
    Doubl = 306,                   /* Doubl  */
    Const = 307,                   /* Const  */
    Volatile = 308,                /* Volatile  */
    Void = 309,                    /* Void  */
    TypeDefName = 310,             /* TypeDefName  */
    Struct = 311,                  /* Struct  */
    Union = 312,                   /* Union  */
    Enum = 313,                    /* Enum  */
    Ellipsis = 314,                /* Ellipsis  */
    Case = 315,                    /* Case  */
    Default = 316,                 /* Default  */
    If = 317,                      /* If  */
    Else = 318,                    /* Else  */
    Switch = 319,                  /* Switch  */
    While = 320,                   /* While  */
    Do = 321,                      /* Do  */
    For = 322,                     /* For  */
    Goto = 323,                    /* Goto  */
    Continue = 324,                /* Continue  */
    Break = 325,                   /* Break  */
    Return = 326,                  /* Return  */
    Runerr = 327,                  /* Runerr  */
    Is = 328,                      /* Is  */
    Cnv = 329,                     /* Cnv  */
    Def = 330,                     /* Def  */
    Exact = 331,                   /* Exact  */
    Empty_type = 332,              /* Empty_type  */
    IconType = 333,                /* IconType  */
    Component = 334,               /* Component  */
    Variable = 335,                /* Variable  */
    Any_value = 336,               /* Any_value  */
    Named_var = 337,               /* Named_var  */
    Struct_var = 338,              /* Struct_var  */
    C_Integer = 339,               /* C_Integer  */
    Arith_case = 340,              /* Arith_case  */
    C_Double = 341,                /* C_Double  */
    C_String = 342,                /* C_String  */
    Tmp_string = 343,              /* Tmp_string  */
    Tmp_cset = 344,                /* Tmp_cset  */
    Body = 345,                    /* Body  */
    End = 346,                     /* End  */
    Function = 347,                /* Function  */
    Keyword = 348,                 /* Keyword  */
    Operator = 349,                /* Operator  */
    Underef = 350,                 /* Underef  */
    Declare = 351,                 /* Declare  */
    Suspend = 352,                 /* Suspend  */
    Fail = 353,                    /* Fail  */
    Inline = 354,                  /* Inline  */
    Abstract = 355,                /* Abstract  */
    Store = 356,                   /* Store  */
    Type = 357,                    /* Type  */
    New = 358,                     /* New  */
    All_fields = 359,              /* All_fields  */
    Then = 360,                    /* Then  */
    Type_case = 361,               /* Type_case  */
    Of = 362,                      /* Of  */
    Len_case = 363,                /* Len_case  */
    Constant = 364,                /* Constant  */
    Errorfail = 365,               /* Errorfail  */
    Declspec = 366,                /* Declspec  */
    B_IProc_Type = 367,            /* B_IProc_Type  */
    Offsetof = 369,                /* Offsetof  */
    Thread_local = 370,            /* Thread_local  */
    IfStmt = 371                   /* IfStmt  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 12 "rttgram.y"

   struct token *t;
   struct node *n;
   long i;
   

#line 187 "rttgram.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);

/*
 * Historical token names used by rttlex.c and other RTT sources (yytokentype
 * uses shorter names from the grammar).
 */
#ifndef TokEqual
#define TokEqual Equal
#endif
#ifndef TokRegister
#define TokRegister Register
#endif
#ifndef TokChar
#define TokChar Char
#endif
#ifndef TokShort
#define TokShort Short
#endif
#ifndef TokLong
#define TokLong Long
#endif
#ifndef TokEnum
#define TokEnum Enum
#endif
#ifndef TokFunction
#define TokFunction Function
#endif
#ifndef TokType
#define TokType Type
#endif

#endif /* !YY_YY_RTTGRAM_TAB_H_INCLUDED  */
