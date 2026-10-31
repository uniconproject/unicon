/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 6 "rttgram.y"

#include "rtt1.h"
#include "yyerror.h"
#define YYMAXDEPTH 10000

#line 77 "rttgram.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

#include "ltoken.h"
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_Identifier = 3,                 /* Identifier  */
  YYSYMBOL_StrLit = 4,                     /* StrLit  */
  YYSYMBOL_LStrLit = 5,                    /* LStrLit  */
  YYSYMBOL_FltConst = 6,                   /* FltConst  */
  YYSYMBOL_DblConst = 7,                   /* DblConst  */
  YYSYMBOL_LDblConst = 8,                  /* LDblConst  */
  YYSYMBOL_CharConst = 9,                  /* CharConst  */
  YYSYMBOL_LCharConst = 10,                /* LCharConst  */
  YYSYMBOL_IntConst = 11,                  /* IntConst  */
  YYSYMBOL_UIntConst = 12,                 /* UIntConst  */
  YYSYMBOL_LIntConst = 13,                 /* LIntConst  */
  YYSYMBOL_ULIntConst = 14,                /* ULIntConst  */
  YYSYMBOL_Arrow = 15,                     /* Arrow  */
  YYSYMBOL_Incr = 16,                      /* Incr  */
  YYSYMBOL_Decr = 17,                      /* Decr  */
  YYSYMBOL_LShft = 18,                     /* LShft  */
  YYSYMBOL_RShft = 19,                     /* RShft  */
  YYSYMBOL_Leq = 20,                       /* Leq  */
  YYSYMBOL_Geq = 21,                       /* Geq  */
  YYSYMBOL_Equal = 22,                     /* Equal  */
  YYSYMBOL_Neq = 23,                       /* Neq  */
  YYSYMBOL_And = 24,                       /* And  */
  YYSYMBOL_Or = 25,                        /* Or  */
  YYSYMBOL_MultAsgn = 26,                  /* MultAsgn  */
  YYSYMBOL_DivAsgn = 27,                   /* DivAsgn  */
  YYSYMBOL_ModAsgn = 28,                   /* ModAsgn  */
  YYSYMBOL_PlusAsgn = 29,                  /* PlusAsgn  */
  YYSYMBOL_MinusAsgn = 30,                 /* MinusAsgn  */
  YYSYMBOL_LShftAsgn = 31,                 /* LShftAsgn  */
  YYSYMBOL_RShftAsgn = 32,                 /* RShftAsgn  */
  YYSYMBOL_AndAsgn = 33,                   /* AndAsgn  */
  YYSYMBOL_XorAsgn = 34,                   /* XorAsgn  */
  YYSYMBOL_OrAsgn = 35,                    /* OrAsgn  */
  YYSYMBOL_Sizeof = 36,                    /* Sizeof  */
  YYSYMBOL_Intersect = 37,                 /* Intersect  */
  YYSYMBOL_OpSym = 38,                     /* OpSym  */
  YYSYMBOL_Typedef = 39,                   /* Typedef  */
  YYSYMBOL_Extern = 40,                    /* Extern  */
  YYSYMBOL_Static = 41,                    /* Static  */
  YYSYMBOL_Auto = 42,                      /* Auto  */
  YYSYMBOL_Register = 43,                  /* Register  */
  YYSYMBOL_Tended = 44,                    /* Tended  */
  YYSYMBOL_Char = 45,                      /* Char  */
  YYSYMBOL_Short = 46,                     /* Short  */
  YYSYMBOL_Int = 47,                       /* Int  */
  YYSYMBOL_Long = 48,                      /* Long  */
  YYSYMBOL_Signed = 49,                    /* Signed  */
  YYSYMBOL_Unsigned = 50,                  /* Unsigned  */
  YYSYMBOL_Float = 51,                     /* Float  */
  YYSYMBOL_Doubl = 52,                     /* Doubl  */
  YYSYMBOL_Const = 53,                     /* Const  */
  YYSYMBOL_Volatile = 54,                  /* Volatile  */
  YYSYMBOL_Void = 55,                      /* Void  */
  YYSYMBOL_TypeDefName = 56,               /* TypeDefName  */
  YYSYMBOL_Struct = 57,                    /* Struct  */
  YYSYMBOL_Union = 58,                     /* Union  */
  YYSYMBOL_Enum = 59,                      /* Enum  */
  YYSYMBOL_Ellipsis = 60,                  /* Ellipsis  */
  YYSYMBOL_Case = 61,                      /* Case  */
  YYSYMBOL_Default = 62,                   /* Default  */
  YYSYMBOL_If = 63,                        /* If  */
  YYSYMBOL_Else = 64,                      /* Else  */
  YYSYMBOL_Switch = 65,                    /* Switch  */
  YYSYMBOL_While = 66,                     /* While  */
  YYSYMBOL_Do = 67,                        /* Do  */
  YYSYMBOL_For = 68,                       /* For  */
  YYSYMBOL_Goto = 69,                      /* Goto  */
  YYSYMBOL_Continue = 70,                  /* Continue  */
  YYSYMBOL_Break = 71,                     /* Break  */
  YYSYMBOL_Return = 72,                    /* Return  */
  YYSYMBOL_73_ = 73,                       /* '%'  */
  YYSYMBOL_74_ = 74,                       /* '&'  */
  YYSYMBOL_75_ = 75,                       /* '('  */
  YYSYMBOL_76_ = 76,                       /* ')'  */
  YYSYMBOL_77_ = 77,                       /* '*'  */
  YYSYMBOL_78_ = 78,                       /* '+'  */
  YYSYMBOL_79_ = 79,                       /* ','  */
  YYSYMBOL_80_ = 80,                       /* '-'  */
  YYSYMBOL_81_ = 81,                       /* '.'  */
  YYSYMBOL_82_ = 82,                       /* '/'  */
  YYSYMBOL_83_ = 83,                       /* '{'  */
  YYSYMBOL_84_ = 84,                       /* '|'  */
  YYSYMBOL_85_ = 85,                       /* '}'  */
  YYSYMBOL_86_ = 86,                       /* '~'  */
  YYSYMBOL_87_ = 87,                       /* '['  */
  YYSYMBOL_88_ = 88,                       /* ']'  */
  YYSYMBOL_89_ = 89,                       /* '^'  */
  YYSYMBOL_90_ = 90,                       /* ':'  */
  YYSYMBOL_91_ = 91,                       /* ';'  */
  YYSYMBOL_92_ = 92,                       /* '<'  */
  YYSYMBOL_93_ = 93,                       /* '='  */
  YYSYMBOL_94_ = 94,                       /* '>'  */
  YYSYMBOL_95_ = 95,                       /* '?'  */
  YYSYMBOL_96_ = 96,                       /* '!'  */
  YYSYMBOL_97_ = 97,                       /* '@'  */
  YYSYMBOL_98_ = 98,                       /* '\\'  */
  YYSYMBOL_Runerr = 99,                    /* Runerr  */
  YYSYMBOL_Is = 100,                       /* Is  */
  YYSYMBOL_Cnv = 101,                      /* Cnv  */
  YYSYMBOL_Def = 102,                      /* Def  */
  YYSYMBOL_Exact = 103,                    /* Exact  */
  YYSYMBOL_Empty_type = 104,               /* Empty_type  */
  YYSYMBOL_IconType = 105,                 /* IconType  */
  YYSYMBOL_Component = 106,                /* Component  */
  YYSYMBOL_Variable = 107,                 /* Variable  */
  YYSYMBOL_Any_value = 108,                /* Any_value  */
  YYSYMBOL_Named_var = 109,                /* Named_var  */
  YYSYMBOL_Struct_var = 110,               /* Struct_var  */
  YYSYMBOL_C_Integer = 111,                /* C_Integer  */
  YYSYMBOL_Arith_case = 112,               /* Arith_case  */
  YYSYMBOL_C_Double = 113,                 /* C_Double  */
  YYSYMBOL_C_String = 114,                 /* C_String  */
  YYSYMBOL_Tmp_string = 115,               /* Tmp_string  */
  YYSYMBOL_Tmp_cset = 116,                 /* Tmp_cset  */
  YYSYMBOL_Body = 117,                     /* Body  */
  YYSYMBOL_End = 118,                      /* End  */
  YYSYMBOL_Function = 119,                 /* Function  */
  YYSYMBOL_Keyword = 120,                  /* Keyword  */
  YYSYMBOL_Operator = 121,                 /* Operator  */
  YYSYMBOL_Underef = 122,                  /* Underef  */
  YYSYMBOL_Declare = 123,                  /* Declare  */
  YYSYMBOL_Suspend = 124,                  /* Suspend  */
  YYSYMBOL_Fail = 125,                     /* Fail  */
  YYSYMBOL_Inline = 126,                   /* Inline  */
  YYSYMBOL_Abstract = 127,                 /* Abstract  */
  YYSYMBOL_Store = 128,                    /* Store  */
  YYSYMBOL_Type = 129,                     /* Type  */
  YYSYMBOL_New = 130,                      /* New  */
  YYSYMBOL_All_fields = 131,               /* All_fields  */
  YYSYMBOL_Then = 132,                     /* Then  */
  YYSYMBOL_Type_case = 133,                /* Type_case  */
  YYSYMBOL_Of = 134,                       /* Of  */
  YYSYMBOL_Len_case = 135,                 /* Len_case  */
  YYSYMBOL_Constant = 136,                 /* Constant  */
  YYSYMBOL_Errorfail = 137,                /* Errorfail  */
  YYSYMBOL_Declspec = 138,                 /* Declspec  */
  YYSYMBOL_B_IProc_Type = 139,             /* B_IProc_Type  */
  YYSYMBOL_Offsetof = 140,                 /* Offsetof  */
  YYSYMBOL_Thread_local = 141,             /* Thread_local  */
  YYSYMBOL_HostDir = 142,                  /* HostDir  */
  YYSYMBOL_IfStmt = 143,                   /* IfStmt  */
  YYSYMBOL_YYACCEPT = 144,                 /* $accept  */
  YYSYMBOL_primary_expr = 145,             /* primary_expr  */
  YYSYMBOL_postfix_expr = 146,             /* postfix_expr  */
  YYSYMBOL_arg_expr_lst = 147,             /* arg_expr_lst  */
  YYSYMBOL_unary_expr = 148,               /* unary_expr  */
  YYSYMBOL_unary_op = 149,                 /* unary_op  */
  YYSYMBOL_cast_expr = 150,                /* cast_expr  */
  YYSYMBOL_multiplicative_expr = 151,      /* multiplicative_expr  */
  YYSYMBOL_additive_expr = 152,            /* additive_expr  */
  YYSYMBOL_shift_expr = 153,               /* shift_expr  */
  YYSYMBOL_relational_expr = 154,          /* relational_expr  */
  YYSYMBOL_equality_expr = 155,            /* equality_expr  */
  YYSYMBOL_and_expr = 156,                 /* and_expr  */
  YYSYMBOL_exclusive_or_expr = 157,        /* exclusive_or_expr  */
  YYSYMBOL_inclusive_or_expr = 158,        /* inclusive_or_expr  */
  YYSYMBOL_logical_and_expr = 159,         /* logical_and_expr  */
  YYSYMBOL_logical_or_expr = 160,          /* logical_or_expr  */
  YYSYMBOL_conditional_expr = 161,         /* conditional_expr  */
  YYSYMBOL_assign_expr = 162,              /* assign_expr  */
  YYSYMBOL_assign_op = 163,                /* assign_op  */
  YYSYMBOL_expr = 164,                     /* expr  */
  YYSYMBOL_opt_expr = 165,                 /* opt_expr  */
  YYSYMBOL_constant_expr = 166,            /* constant_expr  */
  YYSYMBOL_opt_constant_expr = 167,        /* opt_constant_expr  */
  YYSYMBOL_dcltion = 168,                  /* dcltion  */
  YYSYMBOL_typ_dcltion_specs = 169,        /* typ_dcltion_specs  */
  YYSYMBOL_dcltion_specs = 170,            /* dcltion_specs  */
  YYSYMBOL_type_ind = 171,                 /* type_ind  */
  YYSYMBOL_type_storcl_tqual_lst = 172,    /* type_storcl_tqual_lst  */
  YYSYMBOL_storcl_tqual_lst = 173,         /* storcl_tqual_lst  */
  YYSYMBOL_init_dcltor_lst = 174,          /* init_dcltor_lst  */
  YYSYMBOL_no_tdn_init_dcltor_lst = 175,   /* no_tdn_init_dcltor_lst  */
  YYSYMBOL_init_dcltor = 176,              /* init_dcltor  */
  YYSYMBOL_no_tdn_init_dcltor = 177,       /* no_tdn_init_dcltor  */
  YYSYMBOL_storage_class_spec = 178,       /* storage_class_spec  */
  YYSYMBOL_type_spec = 179,                /* type_spec  */
  YYSYMBOL_stnd_type = 180,                /* stnd_type  */
  YYSYMBOL_struct_or_union_spec = 181,     /* struct_or_union_spec  */
  YYSYMBOL_struct_or_union = 182,          /* struct_or_union  */
  YYSYMBOL_struct_dcltion_lst = 183,       /* struct_dcltion_lst  */
  YYSYMBOL_struct_dcltion = 184,           /* struct_dcltion  */
  YYSYMBOL_struct_dcltion_specs = 185,     /* struct_dcltion_specs  */
  YYSYMBOL_struct_type_ind = 186,          /* struct_type_ind  */
  YYSYMBOL_struct_type_lst = 187,          /* struct_type_lst  */
  YYSYMBOL_struct_dcltor_lst = 188,        /* struct_dcltor_lst  */
  YYSYMBOL_struct_dcltor = 189,            /* struct_dcltor  */
  YYSYMBOL_190_1 = 190,                    /* $@1  */
  YYSYMBOL_struct_no_tdn_dcltor_lst = 191, /* struct_no_tdn_dcltor_lst  */
  YYSYMBOL_struct_no_tdn_dcltor = 192,     /* struct_no_tdn_dcltor  */
  YYSYMBOL_193_2 = 193,                    /* $@2  */
  YYSYMBOL_enum_spec = 194,                /* enum_spec  */
  YYSYMBOL_195_3 = 195,                    /* $@3  */
  YYSYMBOL_196_4 = 196,                    /* $@4  */
  YYSYMBOL_enumerator_lst = 197,           /* enumerator_lst  */
  YYSYMBOL_enumerator = 198,               /* enumerator  */
  YYSYMBOL_type_qual = 199,                /* type_qual  */
  YYSYMBOL_dcltor = 200,                   /* dcltor  */
  YYSYMBOL_no_tdn_dcltor = 201,            /* no_tdn_dcltor  */
  YYSYMBOL_direct_dcltor = 202,            /* direct_dcltor  */
  YYSYMBOL_203_5 = 203,                    /* $@5  */
  YYSYMBOL_no_tdn_direct_dcltor = 204,     /* no_tdn_direct_dcltor  */
  YYSYMBOL_205_6 = 205,                    /* $@6  */
  YYSYMBOL_parm_dcls_or_ids = 206,         /* parm_dcls_or_ids  */
  YYSYMBOL_pointer = 207,                  /* pointer  */
  YYSYMBOL_opt_pointer = 208,              /* opt_pointer  */
  YYSYMBOL_tqual_lst = 209,                /* tqual_lst  */
  YYSYMBOL_param_type_lst = 210,           /* param_type_lst  */
  YYSYMBOL_opt_param_type_lst = 211,       /* opt_param_type_lst  */
  YYSYMBOL_param_lst = 212,                /* param_lst  */
  YYSYMBOL_param_dcltion = 213,            /* param_dcltion  */
  YYSYMBOL_ident_lst = 214,                /* ident_lst  */
  YYSYMBOL_type_tqual_lst = 215,           /* type_tqual_lst  */
  YYSYMBOL_type_name = 216,                /* type_name  */
  YYSYMBOL_abstract_dcltor = 217,          /* abstract_dcltor  */
  YYSYMBOL_direct_abstract_dcltor = 218,   /* direct_abstract_dcltor  */
  YYSYMBOL_219_7 = 219,                    /* $@7  */
  YYSYMBOL_220_8 = 220,                    /* $@8  */
  YYSYMBOL_initializer = 221,              /* initializer  */
  YYSYMBOL_initializer_lst = 222,          /* initializer_lst  */
  YYSYMBOL_stmt = 223,                     /* stmt  */
  YYSYMBOL_non_lbl_stmt = 224,             /* non_lbl_stmt  */
  YYSYMBOL_225_9 = 225,                    /* $@9  */
  YYSYMBOL_labeled_stmt = 226,             /* labeled_stmt  */
  YYSYMBOL_compound_stmt = 227,            /* compound_stmt  */
  YYSYMBOL_dcltion_lst = 228,              /* dcltion_lst  */
  YYSYMBOL_opt_dcltion_lst = 229,          /* opt_dcltion_lst  */
  YYSYMBOL_local_dcls = 230,               /* local_dcls  */
  YYSYMBOL_local_dcl = 231,                /* local_dcl  */
  YYSYMBOL_tended_type = 232,              /* tended_type  */
  YYSYMBOL_stmt_lst = 233,                 /* stmt_lst  */
  YYSYMBOL_opt_stmt_lst = 234,             /* opt_stmt_lst  */
  YYSYMBOL_expr_stmt = 235,                /* expr_stmt  */
  YYSYMBOL_selection_stmt = 236,           /* selection_stmt  */
  YYSYMBOL_c_type_select_lst = 237,        /* c_type_select_lst  */
  YYSYMBOL_c_type_select = 238,            /* c_type_select  */
  YYSYMBOL_c_opt_default = 239,            /* c_opt_default  */
  YYSYMBOL_iteration_stmt = 240,           /* iteration_stmt  */
  YYSYMBOL_jump_stmt = 241,                /* jump_stmt  */
  YYSYMBOL_translation_unit = 242,         /* translation_unit  */
  YYSYMBOL_extrn_decltn_lst = 243,         /* extrn_decltn_lst  */
  YYSYMBOL_external_dcltion = 244,         /* external_dcltion  */
  YYSYMBOL_function_definition = 245,      /* function_definition  */
  YYSYMBOL_246_10 = 246,                   /* $@10  */
  YYSYMBOL_func_head = 247,                /* func_head  */
  YYSYMBOL_any_ident = 248,                /* any_ident  */
  YYSYMBOL_label = 249,                    /* label  */
  YYSYMBOL_typedefname = 250,              /* typedefname  */
  YYSYMBOL_definition = 251,               /* definition  */
  YYSYMBOL_252_11 = 252,                   /* $@11  */
  YYSYMBOL_operation = 253,                /* operation  */
  YYSYMBOL_description = 254,              /* description  */
  YYSYMBOL_fnc_oper = 255,                 /* fnc_oper  */
  YYSYMBOL_256_12 = 256,                   /* $@12  */
  YYSYMBOL_257_13 = 257,                   /* $@13  */
  YYSYMBOL_keyword = 258,                  /* keyword  */
  YYSYMBOL_key_const = 259,                /* key_const  */
  YYSYMBOL_identifier = 260,               /* identifier  */
  YYSYMBOL_op_name = 261,                  /* op_name  */
  YYSYMBOL_result_seq = 262,               /* result_seq  */
  YYSYMBOL_length = 263,                   /* length  */
  YYSYMBOL_opt_plus = 264,                 /* opt_plus  */
  YYSYMBOL_opt_s_parm_lst = 265,           /* opt_s_parm_lst  */
  YYSYMBOL_s_parm_lst = 266,               /* s_parm_lst  */
  YYSYMBOL_s_parm = 267,                   /* s_parm  */
  YYSYMBOL_op_declare = 268,               /* op_declare  */
  YYSYMBOL_opt_actions = 269,              /* opt_actions  */
  YYSYMBOL_actions = 270,                  /* actions  */
  YYSYMBOL_action = 271,                   /* action  */
  YYSYMBOL_272_14 = 272,                   /* $@14  */
  YYSYMBOL_273_15 = 273,                   /* $@15  */
  YYSYMBOL_checking_conversions = 274,     /* checking_conversions  */
  YYSYMBOL_type_select_lst = 275,          /* type_select_lst  */
  YYSYMBOL_type_select = 276,              /* type_select  */
  YYSYMBOL_opt_default = 277,              /* opt_default  */
  YYSYMBOL_selector_lst = 278,             /* selector_lst  */
  YYSYMBOL_len_select_lst = 279,           /* len_select_lst  */
  YYSYMBOL_len_select = 280,               /* len_select  */
  YYSYMBOL_type_check = 281,               /* type_check  */
  YYSYMBOL_simple_check_conj = 282,        /* simple_check_conj  */
  YYSYMBOL_simple_check = 283,             /* simple_check  */
  YYSYMBOL_detail_code = 284,              /* detail_code  */
  YYSYMBOL_285_16 = 285,                   /* $@16  */
  YYSYMBOL_286_17 = 286,                   /* $@17  */
  YYSYMBOL_runerr = 287,                   /* runerr  */
  YYSYMBOL_opt_semi = 288,                 /* opt_semi  */
  YYSYMBOL_variable = 289,                 /* variable  */
  YYSYMBOL_dest_type = 290,                /* dest_type  */
  YYSYMBOL_i_type_name = 291,              /* i_type_name  */
  YYSYMBOL_ret_val = 292,                  /* ret_val  */
  YYSYMBOL_type_computations = 293,        /* type_computations  */
  YYSYMBOL_side_effect_lst = 294,          /* side_effect_lst  */
  YYSYMBOL_side_effect = 295,              /* side_effect  */
  YYSYMBOL_type = 296,                     /* type  */
  YYSYMBOL_basic_type = 297,               /* basic_type  */
  YYSYMBOL_union = 298,                    /* union  */
  YYSYMBOL_type_lst = 299,                 /* type_lst  */
  YYSYMBOL_attrb_name = 300                /* attrb_name  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_int16 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if !defined yyoverflow

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* !defined yyoverflow */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  104
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   3657

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  144
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  157
/* YYNRULES -- Number of rules.  */
#define YYNRULES  491
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  845

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   373


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    96,     2,     2,     2,    73,    74,     2,
      75,    76,    77,    78,    79,    80,    81,    82,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    90,    91,
      92,    93,    94,    95,    97,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    87,    98,    88,    89,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    83,    84,    85,    86,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
      66,    67,    68,    69,    70,    71,    72,    99,   100,   101,
     102,   103,   104,   105,   106,   107,   108,   109,   110,   111,
     112,   113,   114,   115,   116,   117,   118,   119,   120,   121,
     122,   123,   124,   125,   126,   127,   128,   129,   130,   131,
     132,   133,   134,   135,   136,   137,   138,   139,     2,   140,
     141,   142,     2,   143
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   110,   110,   111,   112,   113,   114,   115,   116,   117,
     118,   119,   120,   121,   122,   126,   127,   129,   131,   133,
     134,   135,   136,   137,   139,   142,   148,   149,   153,   154,
     155,   156,   157,   158,   164,   171,   172,   173,   174,   175,
     176,   180,   181,   185,   186,   187,   188,   192,   193,   194,
     198,   199,   200,   204,   205,   206,   207,   208,   212,   213,
     214,   218,   219,   223,   224,   228,   229,   233,   234,   238,
     239,   243,   244,   250,   251,   255,   256,   257,   258,   259,
     260,   261,   262,   263,   264,   265,   269,   270,   274,   275,
     279,   283,   284,   288,   290,   292,   298,   299,   303,   304,
     308,   309,   311,   315,   316,   317,   318,   322,   323,   324,
     325,   329,   330,   334,   335,   340,   341,   345,   346,   357,
     358,   359,   360,   361,   362,   367,   368,   375,   376,   380,
     381,   382,   383,   384,   385,   386,   387,   388,   389,   390,
     391,   397,   400,   403,   407,   408,   412,   413,   417,   419,
     423,   424,   428,   429,   430,   434,   435,   436,   439,   440,
     444,   446,   447,   447,   452,   453,   458,   460,   461,   461,
     466,   466,   468,   468,   470,   474,   475,   479,   480,   485,
     486,   491,   495,   499,   500,   502,   504,   504,   514,   515,
     517,   520,   520,   530,   531,   535,   536,   537,   538,   542,
     543,   547,   548,   552,   553,   557,   558,   562,   563,   567,
     569,   570,   574,   575,   579,   580,   581,   582,   586,   587,
     591,   592,   596,   598,   601,   604,   604,   608,   608,   615,
     616,   617,   619,   625,   626,   630,   631,   635,   635,   636,
     637,   638,   639,   640,   642,   644,   648,   649,   650,   654,
     655,   659,   660,   664,   665,   669,   670,   674,   675,   680,
     681,   682,   683,   687,   688,   689,   693,   694,   697,   701,
     703,   705,   707,   712,   713,   717,   721,   722,   726,   728,
     731,   738,   739,   740,   741,   742,   743,   744,   748,   749,
     753,   754,   758,   759,   760,   761,   765,   765,   770,   771,
     772,   776,   777,   781,   782,   786,   787,   788,   789,   797,
     797,   801,   802,   803,   807,   808,   812,   815,   816,   815,
     821,   826,   827,   828,   829,   836,   837,   838,   839,   840,
     841,   842,   843,   844,   845,   846,   847,   848,   849,   850,
     851,   852,   853,   854,   855,   856,   857,   858,   859,   866,
     867,   868,   869,   870,   871,   872,   873,   874,   875,   876,
     877,   878,   879,   880,   881,   882,   883,   884,   885,   886,
     887,   888,   889,   890,   891,   892,   893,   894,   895,   896,
     897,   898,   899,   900,   901,   902,   903,   904,   905,   906,
     907,   908,   909,   910,   914,   915,   916,   920,   921,   925,
     926,   930,   931,   932,   936,   937,   941,   942,   943,   948,
     949,   954,   955,   959,   960,   964,   965,   966,   967,   968,
     969,   968,   974,   976,   978,   980,   983,   991,   992,   996,
    1000,  1001,  1005,  1007,  1012,  1013,  1017,  1021,  1022,  1026,
    1027,  1031,  1033,  1036,  1039,  1042,  1048,  1048,  1050,  1050,
    1055,  1058,  1064,  1065,  1069,  1070,  1075,  1076,  1077,  1078,
    1079,  1080,  1081,  1083,  1088,  1089,  1090,  1091,  1095,  1096,
    1097,  1098,  1102,  1103,  1104,  1108,  1109,  1113,  1118,  1119,
    1120,  1123,  1125,  1127,  1129,  1131,  1133,  1137,  1141,  1142,
    1146,  1147
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if YYDEBUG || 0
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "Identifier", "StrLit",
  "LStrLit", "FltConst", "DblConst", "LDblConst", "CharConst",
  "LCharConst", "IntConst", "UIntConst", "LIntConst", "ULIntConst",
  "Arrow", "Incr", "Decr", "LShft", "RShft", "Leq", "Geq", "Equal", "Neq",
  "And", "Or", "MultAsgn", "DivAsgn", "ModAsgn", "PlusAsgn", "MinusAsgn",
  "LShftAsgn", "RShftAsgn", "AndAsgn", "XorAsgn", "OrAsgn", "Sizeof",
  "Intersect", "OpSym", "Typedef", "Extern", "Static", "Auto", "Register",
  "Tended", "Char", "Short", "Int", "Long", "Signed", "Unsigned", "Float",
  "Doubl", "Const", "Volatile", "Void", "TypeDefName", "Struct", "Union",
  "Enum", "Ellipsis", "Case", "Default", "If", "Else", "Switch", "While",
  "Do", "For", "Goto", "Continue", "Break", "Return", "'%'", "'&'", "'('",
  "')'", "'*'", "'+'", "','", "'-'", "'.'", "'/'", "'{'", "'|'", "'}'",
  "'~'", "'['", "']'", "'^'", "':'", "';'", "'<'", "'='", "'>'", "'?'",
  "'!'", "'@'", "'\\\\'", "Runerr", "Is", "Cnv", "Def", "Exact",
  "Empty_type", "IconType", "Component", "Variable", "Any_value",
  "Named_var", "Struct_var", "C_Integer", "Arith_case", "C_Double",
  "C_String", "Tmp_string", "Tmp_cset", "Body", "End", "Function",
  "Keyword", "Operator", "Underef", "Declare", "Suspend", "Fail", "Inline",
  "Abstract", "Store", "Type", "New", "All_fields", "Then", "Type_case",
  "Of", "Len_case", "Constant", "Errorfail", "Declspec", "B_IProc_Type",
  "Offsetof", "Thread_local", "HostDir", "IfStmt", "$accept",
  "primary_expr", "postfix_expr", "arg_expr_lst", "unary_expr", "unary_op",
  "cast_expr", "multiplicative_expr", "additive_expr", "shift_expr",
  "relational_expr", "equality_expr", "and_expr", "exclusive_or_expr",
  "inclusive_or_expr", "logical_and_expr", "logical_or_expr",
  "conditional_expr", "assign_expr", "assign_op", "expr", "opt_expr",
  "constant_expr", "opt_constant_expr", "dcltion", "typ_dcltion_specs",
  "dcltion_specs", "type_ind", "type_storcl_tqual_lst", "storcl_tqual_lst",
  "init_dcltor_lst", "no_tdn_init_dcltor_lst", "init_dcltor",
  "no_tdn_init_dcltor", "storage_class_spec", "type_spec", "stnd_type",
  "struct_or_union_spec", "struct_or_union", "struct_dcltion_lst",
  "struct_dcltion", "struct_dcltion_specs", "struct_type_ind",
  "struct_type_lst", "struct_dcltor_lst", "struct_dcltor", "$@1",
  "struct_no_tdn_dcltor_lst", "struct_no_tdn_dcltor", "$@2", "enum_spec",
  "$@3", "$@4", "enumerator_lst", "enumerator", "type_qual", "dcltor",
  "no_tdn_dcltor", "direct_dcltor", "$@5", "no_tdn_direct_dcltor", "$@6",
  "parm_dcls_or_ids", "pointer", "opt_pointer", "tqual_lst",
  "param_type_lst", "opt_param_type_lst", "param_lst", "param_dcltion",
  "ident_lst", "type_tqual_lst", "type_name", "abstract_dcltor",
  "direct_abstract_dcltor", "$@7", "$@8", "initializer", "initializer_lst",
  "stmt", "non_lbl_stmt", "$@9", "labeled_stmt", "compound_stmt",
  "dcltion_lst", "opt_dcltion_lst", "local_dcls", "local_dcl",
  "tended_type", "stmt_lst", "opt_stmt_lst", "expr_stmt", "selection_stmt",
  "c_type_select_lst", "c_type_select", "c_opt_default", "iteration_stmt",
  "jump_stmt", "translation_unit", "extrn_decltn_lst", "external_dcltion",
  "function_definition", "$@10", "func_head", "any_ident", "label",
  "typedefname", "definition", "$@11", "operation", "description",
  "fnc_oper", "$@12", "$@13", "keyword", "key_const", "identifier",
  "op_name", "result_seq", "length", "opt_plus", "opt_s_parm_lst",
  "s_parm_lst", "s_parm", "op_declare", "opt_actions", "actions", "action",
  "$@14", "$@15", "checking_conversions", "type_select_lst", "type_select",
  "opt_default", "selector_lst", "len_select_lst", "len_select",
  "type_check", "simple_check_conj", "simple_check", "detail_code", "$@16",
  "$@17", "runerr", "opt_semi", "variable", "dest_type", "i_type_name",
  "ret_val", "type_computations", "side_effect_lst", "side_effect", "type",
  "basic_type", "union", "type_lst", "attrb_name", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-705)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-468)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     770,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,
    -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,
    1516,    67,  -705,  -705,  -705,  -705,   -34,     1,  -705,  -705,
    -705,    77,  -705,  1744,  3250,  -705,  -705,  -705,  1377,  -705,
    -705,  -705,  -705,  1909,   133,   901,  -705,  -705,  -705,   346,
    -705,   149,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,
    -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,
    -705,  -705,  -705,  -705,  -705,  -705,   107,   116,  -705,  -705,
    -705,  -705,    67,  1238,  2682,  -705,    73,  -705,   124,   858,
    -705,  -705,  -705,  -705,   147,  -705,  -705,  -705,   131,  2656,
     121,   162,   158,  -705,  -705,  -705,  3396,   346,  -705,   323,
    1516,   160,  -705,  -705,   171,  -705,  -705,  -705,  -705,  -705,
    -705,  -705,  -705,  -705,  -705,  -705,  2821,  2821,  2960,  -705,
    1848,  -705,  -705,  -705,  -705,  -705,   205,   247,   265,   196,
    -705,    91,  -705,  2682,  -705,   111,    22,   365,    30,   396,
     233,   271,   230,   345,    15,  -705,   289,  -705,   162,  -705,
    2404,   162,   175,  -705,   162,  -705,  2404,  -705,   559,  -705,
      46,  -705,  1014,  2378,   411,  2656,   298,  -705,  2682,  -705,
      77,  3250,  3396,   296,   313,   385,   388,  -705,   301,   458,
      -8,  -705,   386,  1516,  -705,  2682,  -705,  -705,  1848,  -705,
     424,  -705,  -705,    95,  2656,  -705,  2656,   232,   372,  -705,
     299,   225,   225,  2656,  1516,  -705,  -705,  2543,  1516,  2682,
    -705,  2682,  2682,  2682,  2682,  2682,  2682,  2682,  2682,  2682,
    2682,  2682,  2682,  2682,  2682,  2682,  2682,  2682,  2682,  2682,
    -705,  -705,   390,  2126,  -705,  -705,   409,  -705,  2682,  -705,
     402,  -705,  -705,  -705,  2682,   174,  -705,   406,  -705,  -705,
    2682,  -705,   184,  -705,   407,   411,  2517,  -705,  3068,  -705,
     401,  -705,  1041,  -705,    41,    41,    41,   415,  2081,   257,
    2081,   436,   438,  -705,  -705,  -705,  1238,  1238,   357,   663,
    -705,  -705,  -705,  -705,  1516,  -705,  2682,   144,   423,  -705,
    -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,
    2682,  -705,  2682,  -705,  -705,   181,   198,  -705,  2682,  -705,
    -705,  -705,  -705,   440,   416,  -705,  -705,  -705,  -705,  -705,
    -705,   447,   448,   446,  -705,  -705,   244,  -705,  -705,   210,
    -705,  -705,  -705,   111,   111,    22,    22,   365,   365,   365,
     365,    30,    30,   396,   233,   271,   230,   345,   101,  -705,
    -705,   161,  -705,  3068,   439,  -705,    46,  -705,  -705,  -705,
      71,  -705,  -705,  -705,  3130,  3562,  -705,   333,  3396,   450,
    -705,  -705,   449,  -705,   451,  -705,  -705,   173,  2682,   442,
     454,   459,   460,  1321,   461,  1516,   452,   455,  1987,   463,
    1987,   456,  2682,   462,  -705,   465,   467,  -705,  -705,  -705,
     296,  -705,  1041,  -705,  1181,   457,  -705,  -705,  -705,  -705,
     469,    87,   470,  -705,  -705,   477,   399,   479,  -705,  3353,
     804,   360,   475,   476,   478,   408,   515,  -705,   482,  2081,
     534,  1238,   296,   296,   488,   486,   418,   443,  -705,  -705,
    -705,  -705,   432,  -705,  -705,  -705,  -705,  -705,  -705,  -705,
    -705,   132,  2682,   216,  -705,  2682,   498,  2682,  2682,  1238,
    -705,  2682,  -705,  2682,  2265,  -705,   500,  -705,  -705,  2682,
    -705,  2682,  -705,  3126,  -705,  -705,  3374,  1238,  -705,  2043,
    1238,   162,   492,  1321,  2682,  2682,  2682,   512,  -705,  2682,
     495,  -705,  -705,  -705,  2682,  2682,  2682,  -705,   496,  2682,
     499,  -705,   -37,  -705,  -705,  -705,  -705,   504,  -705,  -705,
    -705,  1321,  1709,  -705,    41,  -705,  1709,   507,  3229,  -705,
    -705,   299,   225,   225,  2081,   360,  -705,   268,   516,  -705,
    -705,   -36,   572,   518,   519,  -705,   522,  3396,   511,  -705,
    2682,   527,   176,   540,   543,   547,  -705,  -705,  -705,  -705,
    -705,  -705,  -705,  3499,  -705,  -705,  -705,  -705,  -705,  -705,
     227,  1321,  -705,   314,   322,   329,   552,   537,  -705,  -705,
    -705,  -705,  -705,   341,  -705,   549,  -705,  -705,  -705,  -705,
    -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,
    -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,
    -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,
    -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,  -705,
    -705,  -705,  -705,   555,   556,  -705,   595,  -705,   560,   561,
     562,   574,  -705,   548,  1238,  1238,   197,   553,  -705,   -33,
    -705,   554,   299,   630,  -705,   567,  -705,  3396,   557,  -705,
    -705,  -705,  2682,  2682,  -705,  -705,  -705,  1321,  1321,  1321,
    2682,  2682,   565,  2682,   299,  2180,  -705,  -705,  1238,  1238,
    1238,  2081,  -705,  -705,   570,   577,   197,   575,   582,   299,
    -705,    18,   580,   197,   578,   197,  -705,  -705,   189,  -705,
     660,   602,   603,    69,  -705,  -705,   588,  -705,   592,   615,
     631,  -705,  -705,   347,   605,  -705,   621,   224,  -705,  1461,
    1238,  -705,   623,   157,  -705,  1709,   626,   355,   624,  -705,
     548,   576,    38,   197,  1238,   629,  -705,   197,  -705,   197,
     -48,    54,  -705,    18,   616,  -705,   627,  -705,   619,  -705,
    2081,   628,  -705,  -705,  -705,  2682,  1321,   620,  2682,   625,
     632,  -705,   634,   635,   637,   638,   639,  -705,   702,  -705,
    2180,  1238,   645,  -705,  -705,  2682,  2682,  -705,   641,  -705,
      57,   654,   197,   580,   580,  -705,  -705,  -705,   640,  -705,
    2081,  -705,  -705,  -705,  2081,   655,  -705,  -705,   658,  -705,
    1601,  -705,  1238,  -705,   647,  2180,   661,   356,   225,  -705,
    -705,    52,   361,   197,  -705,   636,  -705,  1321,  -705,  -705,
    -705,   662,  -705,  -705,  2682,   651,  -705,   197,    18,  -705,
    -705,  -705,   666,  2081,    52,  -705,  -705,   225,   657,  2081,
     225,   664,  2081,   659,  -705
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int16 yydefact[] =
{
     199,   119,   120,   121,   123,   124,   130,   131,   132,   133,
     136,   137,   134,   135,   179,   180,   129,   305,   144,   145,
     170,   195,   306,   307,   308,   125,     0,     0,   122,   295,
     293,   199,    96,   102,   199,   107,   103,   138,     0,   139,
     108,   298,   200,     0,     0,   199,   290,   292,   296,   100,
     294,   314,   335,   333,   331,   334,   329,   348,   327,   338,
     342,   345,   344,   328,   332,   347,   330,   336,   325,   341,
     346,   339,   326,   343,   340,   337,     0,   174,   302,   301,
     201,   197,   196,     0,     0,    93,     0,   111,   300,     0,
     105,   104,   106,    97,     0,   113,   109,   110,   299,     0,
     143,   199,   182,   188,     1,   291,   253,   101,   315,     0,
       0,     0,   202,   198,     0,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,     0,     0,     0,    35,
       0,    36,    37,    38,    39,    40,     0,     0,     0,     0,
      15,    28,    41,     0,    43,    47,    50,    53,    58,    61,
      63,    65,    67,    69,    71,    90,     0,     2,   199,    94,
       0,   199,   181,   183,   199,    95,     0,   155,     0,   146,
     199,   150,   154,   199,   152,     0,     0,   191,    91,   251,
     199,   199,   254,     0,     0,     0,     0,   310,   409,     0,
       0,   175,   177,     0,   126,     0,    29,    30,     0,    32,
      41,    73,    86,     0,   214,   127,   215,   199,     0,   128,
       0,     0,     0,     0,     0,    21,    22,     0,     0,     0,
      31,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     140,   112,   115,     0,   229,   116,     0,   186,    91,   114,
     117,   118,   142,   147,     0,     0,   158,   160,   156,   157,
       0,   151,     0,   164,   166,   153,     0,   189,   205,    92,
       0,   252,    88,   297,   394,   394,   394,     0,     0,     0,
     411,     0,     0,   446,   448,   419,     0,     0,     0,     0,
     413,   415,   416,   417,     0,   171,     0,     0,     0,    76,
      77,    78,    79,    80,    81,    82,    83,    84,    85,    75,
       0,    14,     0,   216,   217,   200,     0,   219,     0,   465,
     466,   467,   464,     0,     0,   456,   457,   458,   459,   460,
     461,     0,     0,     0,    20,    17,     0,    26,    19,     0,
      46,    44,    45,    48,    49,    51,    52,    56,    57,    54,
      55,    59,    60,    62,    64,    66,    68,    70,     0,   230,
     233,     0,   184,   205,     0,   161,   199,   148,   162,   167,
     199,   149,   168,   141,   125,   122,    98,   199,    99,     0,
     206,   193,   203,   207,   194,   212,   190,     0,     0,     0,
       0,     0,     0,    88,     0,     0,     0,     0,    88,     0,
      88,     0,     0,     0,   245,    89,     0,   257,   263,   236,
       0,   235,    88,   255,    88,     0,   239,   240,   241,   242,
       0,   100,     2,   397,   398,     0,   399,     0,   317,     0,
       0,     0,     0,     0,     0,     0,   437,   439,     0,   412,
       0,     0,     0,     0,     0,   454,     0,     0,   321,   323,
     322,   324,     0,   312,   414,   176,   178,   173,    33,    74,
      87,   225,    91,   221,    42,     0,     0,     0,     0,     0,
      18,     0,    16,     0,     0,   231,     0,   185,   159,     0,
     165,     0,   209,     0,   211,   192,     0,     0,   259,     0,
       0,   199,     0,    88,     0,     0,     0,     0,   304,    88,
       0,   303,   282,   283,     0,     0,     0,   468,     0,     0,
       0,   286,     0,   287,   268,   238,   256,     0,   264,   265,
     249,    88,     0,   400,     0,   395,     0,     0,     0,   311,
     438,     0,     0,     0,     0,     0,   418,     0,     0,   447,
     449,     0,     0,     0,     0,   313,     0,   205,     0,   227,
      91,     0,     0,     0,     0,     0,    27,    72,   232,   234,
     187,   163,   169,   199,   204,   208,   213,   261,   260,   262,
       0,    88,   248,     0,     0,     0,     0,     0,   281,   469,
     470,   471,   284,     0,   285,     0,   250,   246,   382,   388,
     365,   383,   351,   377,   387,   354,   380,   372,   375,   381,
     390,   367,   361,   356,   392,   391,   384,   389,   363,   353,
     359,   371,   362,   386,   393,   360,   368,   370,   357,   352,
     378,   379,   373,   355,   358,   369,   374,   376,   385,   366,
     364,   350,   349,     0,   399,   320,     0,   410,     0,     0,
       0,   422,   440,   452,     0,     0,     0,     0,   420,   474,
     475,     0,     0,     0,   222,     0,   223,   205,     0,    23,
     462,   463,     0,     0,    34,   258,   247,    88,    88,    88,
       0,    88,     0,     0,     0,   401,   396,   318,     0,     0,
       0,     0,   453,   450,     0,     0,     0,     0,     0,     0,
     481,   452,   478,     0,     0,     0,   476,   455,   430,   427,
       0,     0,     0,     0,   434,   226,     0,   224,     0,     0,
     269,   271,   278,     0,     0,   243,     0,   276,   273,    88,
     347,   406,     0,   402,   404,     0,     0,     0,     0,   423,
     452,     0,     0,     0,     0,     0,   487,     0,   473,     0,
       0,     0,   421,   452,     0,   428,     0,   429,     0,   432,
       0,     0,   435,   228,    24,     0,    88,     0,    88,     0,
       0,   274,     0,   331,   334,   348,   327,   275,   407,   316,
       0,     0,     0,   441,   442,     0,     0,   451,     0,   486,
       0,     0,     0,   480,   479,   490,   491,   485,     0,   472,
       0,   424,   433,   436,     0,     0,   270,   279,     0,   244,
      88,   272,     0,   405,     0,   401,     0,     0,     0,   484,
     482,   488,     0,     0,   431,     0,    25,    88,   277,   408,
     403,     0,   443,   444,     0,     0,   483,     0,   452,   425,
     280,   319,     0,     0,   489,   477,   445,     0,     0,     0,
       0,     0,     0,     0,   426
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -705,  -705,  -705,  -705,   453,  -705,  -106,   250,   255,   185,
     258,   514,   510,   517,   520,   523,  -705,   -40,  -155,  -705,
    -114,  -388,   -54,  -235,    29,    14,  -705,   -32,  -705,     8,
     261,  -705,   597,   594,    -6,  -705,    86,  -705,  -705,   581,
    -119,  -705,   587,  -705,  -705,   400,  -705,  -705,   403,  -705,
    -705,  -705,  -705,   583,   484,   633,   -24,   -14,  -705,  -705,
    -705,  -705,   420,   -15,    25,    -4,  -705,  -514,  -705,   283,
    -705,   129,  -134,  -175,  -705,  -705,  -705,  -157,  -705,  -389,
    -704,  -705,  -705,  -344,  -705,  -705,   350,  -366,  -705,  -705,
     376,  -705,  -705,  -705,    74,  -705,  -705,  -705,  -705,  -705,
     739,  -705,  -705,  -705,    23,   397,   -17,  -705,  -705,  -705,
    -705,  -705,  -705,  -705,  -705,  -705,   -20,  -504,   217,   270,
     165,    -3,  -705,    33,  -705,  -705,   167,  -270,  -705,  -705,
    -705,  -705,   106,  -705,  -614,  -705,   127,  -705,  -705,  -396,
    -705,  -705,  -705,  -705,  -665,  -410,  -211,  -186,   433,  -705,
    -705,   183,  -648,  -301,  -705,  -705,  -705
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
       0,   140,   141,   336,   200,   143,   144,   145,   146,   147,
     148,   149,   150,   151,   152,   153,   154,   201,   202,   310,
     405,   406,   269,   270,   407,   180,   377,    32,    33,   181,
      86,    94,    87,    95,    35,   204,    36,    37,    38,   168,
     169,   170,   171,   172,   255,   256,   479,   262,   263,   481,
      39,    76,   111,   190,   191,    40,   242,    41,   162,   363,
     102,   268,   379,    42,    43,   173,   380,   381,   382,   383,
     384,   207,   208,   546,   463,   547,   657,   245,   361,   408,
     409,   410,   411,   273,   182,   183,   412,   413,   491,   414,
     415,   416,   417,   717,   718,   762,   418,   419,    44,    45,
      46,    47,   106,    48,   192,   420,    49,    50,    51,   187,
     109,   188,   527,   725,   189,   452,   157,   633,   425,   426,
     525,   722,   723,   724,   278,   438,   289,   290,   444,   694,
     291,   698,   699,   746,   700,   703,   704,   435,   436,   437,
     292,   442,   443,   293,   683,   446,   331,   690,   508,   648,
     649,   650,   691,   692,   739,   812,   787
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      79,   332,    93,    78,   497,   244,    81,    88,    34,   251,
     507,   244,   507,   364,    31,   767,   203,    82,    79,   454,
      98,    78,   635,   103,   323,   518,   738,    90,    96,    30,
     156,   538,   317,   655,   736,   530,   646,   220,   732,   695,
     238,    83,   312,    77,   155,   741,   516,   743,   519,   253,
     228,   229,   423,    34,   736,   737,    89,   107,   785,    31,
     719,   100,   337,   114,   298,   777,   515,   113,   736,    79,
     736,   294,    78,   736,    30,   737,    84,   295,   789,   333,
     702,   203,   174,   786,   203,   780,   360,   176,   244,   737,
      79,   737,   647,    78,   737,   647,   818,   585,   539,   540,
     224,    96,   225,   719,   572,   339,   214,   215,   216,   682,
     239,   577,   163,   209,   779,   340,   341,   342,   424,    91,
      14,    15,   230,    21,   231,   358,     1,     2,     3,     4,
       5,   751,   587,   104,   811,   179,   254,   246,   155,   642,
      14,    15,   788,   706,    21,   809,   257,   253,    21,    93,
     250,   174,   158,   108,    21,   459,   174,   460,   174,   264,
     454,   260,   516,   835,   159,   828,   217,   250,    85,   454,
     265,   311,   218,    79,   312,    96,    78,  -304,   219,   834,
     312,   209,   666,    89,   221,   167,    89,   209,   222,   209,
     110,   473,   315,   223,    79,    89,   209,    78,    79,  -172,
     365,    78,   484,  -115,   175,    89,   369,  -199,   155,    21,
    -117,   271,   464,    25,   155,  -115,   205,   160,   488,  -199,
     155,   772,  -117,   294,   166,    26,   164,   548,    28,   457,
     489,   490,   316,   177,   684,   685,   770,   334,   165,    21,
     474,   338,   456,   193,   771,   178,   475,   194,   385,   174,
     247,   744,   422,   366,   167,   421,   155,  -220,   258,   167,
    -220,   167,   248,   370,   641,   367,   445,   447,   726,   727,
     728,   213,   686,   461,    79,   371,   378,    78,   710,   711,
     712,   660,   376,   714,   205,   462,   760,   661,   512,   312,
     205,   549,   205,   319,   320,   210,   321,   322,   472,   205,
     324,   319,   320,   550,   321,   322,   158,   234,  -218,    21,
     551,  -218,   553,   554,   236,   658,   556,   559,   665,   244,
     470,   639,   640,   471,   781,   687,   688,   689,   319,   320,
     325,   321,   322,   313,   492,   314,   326,   211,   327,   328,
     329,   330,   257,   385,   643,   638,    93,   644,   155,   579,
     580,   581,   167,   431,   583,   212,   264,   432,   433,   434,
     235,   448,   315,   482,   449,   240,   450,   796,   451,   237,
     798,   378,    96,   422,   267,   501,   498,   376,   498,   272,
     573,   574,   575,   226,   227,     1,     2,     3,     4,     5,
     667,    89,   422,   312,   422,   421,   274,   421,   668,    14,
      15,   312,   483,   319,   320,   669,   321,   322,   312,  -210,
      21,   729,  -210,   347,   348,   349,   350,   672,   232,   233,
     673,   445,   155,   757,   277,   561,   312,   562,   830,   107,
     747,   774,   823,   557,   775,   824,   783,   826,   784,   155,
     827,   155,   184,   185,   186,   430,   315,   439,   318,   555,
     299,   300,   301,   302,   303,   304,   305,   306,   307,   308,
     432,   433,   434,   103,    14,    15,   701,   566,   275,   568,
     569,   276,    25,   422,   343,   344,   498,   523,   524,   296,
     793,   345,   346,   160,    26,   362,   316,    28,   701,   386,
     351,   352,   427,   428,   378,   166,   368,   372,   429,   458,
     376,   422,   632,   735,   498,   631,   632,   708,   709,   631,
     155,   440,   701,   441,   748,   465,    89,   309,   716,   466,
     814,   279,   467,   468,   815,   469,   485,   477,   486,   494,
     487,   701,   493,   748,   495,   496,   499,   142,   509,   535,
     534,   280,   520,   502,   312,   537,   503,   511,   315,   176,
     545,   422,   543,   513,   498,   378,   713,   281,   514,   521,
    -303,   376,   522,   837,   526,   531,   532,   536,   533,   840,
     282,   541,   843,   542,   552,   283,   560,   544,   576,   196,
     197,   199,   571,   651,   284,   285,   578,   582,   483,   586,
     584,   286,   636,   287,   288,   645,   142,   825,   654,   656,
     795,   652,   653,   659,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,    20,   662,
     806,   807,   663,   664,   445,   445,   838,   670,   671,   841,
     675,   142,   674,   677,   523,   678,   679,   680,   681,   682,
     693,   702,   697,   705,   252,   707,   730,   422,   422,   422,
     498,   498,   498,   731,    80,   721,   715,   734,   445,   445,
     445,   740,   733,   742,   753,   378,    92,    97,   754,   832,
      22,   376,    23,    24,   142,   142,   142,   142,   142,   142,
     142,   142,   142,   142,   142,   142,   142,   142,   142,   142,
     142,   142,   749,   750,   755,   756,   758,   759,    27,   769,
     768,   142,   773,   776,   782,   632,   790,   142,   631,   792,
     778,   797,   791,   142,   445,   112,   799,   802,   794,   801,
     805,   829,   800,   279,   808,  -465,   279,  -466,  -467,  -464,
     810,   816,    80,   813,   817,   820,   422,   822,   831,   498,
      97,   833,   836,   280,   844,   354,   280,   839,   353,   142,
     721,   804,   570,   355,   842,   241,   266,   356,   249,   281,
     261,   357,   281,   206,   319,   320,   478,   321,   322,   565,
    -288,   142,   282,   480,  -309,   282,   297,   283,   455,   528,
     283,   453,   819,   476,   105,   721,   284,   285,   517,   284,
     285,   761,   500,   286,   634,   287,   286,   422,   287,   676,
     498,    80,   821,   803,   745,   259,   112,    80,    80,     1,
       2,     3,     4,     5,    97,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
     752,   206,   696,   510,     0,     0,     0,   206,     0,   206,
       0,   142,     0,     0,     0,     0,   206,    21,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    52,     0,     0,     0,     0,     0,   279,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    22,     0,    23,    24,     0,     0,   280,     0,  -309,
    -309,  -309,     0,     0,     0,     0,    25,     0,   112,    80,
       0,  -289,     0,   281,     0,  -309,     0,     0,    26,    27,
       0,    28,    29,     0,    17,   142,   282,     0,     0,     0,
       0,   283,   529,     0,     0,     0,   142,     0,     0,     0,
     284,   285,   142,   161,   142,     0,     0,   286,     0,   287,
       1,     2,     3,     4,     5,     0,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,    53,    54,    55,    56,    57,    58,    59,    60,    22,
       0,    23,    24,    61,    62,    63,    64,     0,    21,     0,
      65,    66,     0,     0,    67,    68,    69,    70,    71,    72,
      73,     0,    74,     0,     0,     0,     0,     0,     0,    75,
       0,     0,     0,   142,     0,     0,     0,     0,     0,     0,
       0,    97,    22,     0,    23,    24,     0,     0,     0,     0,
    -309,  -309,  -309,     0,     0,     0,     0,    25,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    26,
      27,     0,    28,    29,    52,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,     0,   126,   127,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
       0,    18,    19,    20,     0,     0,     0,   128,     0,     0,
       1,     2,     3,     4,     5,   387,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,     0,   388,   389,   390,     0,   391,   392,   393,   394,
     395,   396,   397,   398,     0,   129,   130,     0,   131,   132,
       0,   133,     0,     0,  -237,     0,  -266,   134,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   135,     0,     0,
     399,   136,   137,   138,    53,    54,    55,    56,    57,    58,
      59,    60,    22,    27,    23,    24,    61,    62,    63,    64,
       0,     0,     0,    65,    66,   400,   401,   374,    68,    69,
      70,    71,    72,    73,   402,    74,     0,     0,   403,    26,
      27,   139,   375,   404,    52,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,     0,   126,   127,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   128,     0,     0,
       1,     2,     3,     4,     5,   387,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,    52,   388,   389,   390,     0,   391,   392,   393,   394,
     395,   396,   397,   398,     0,   129,   130,     0,   131,   132,
       0,   133,     0,     0,  -237,     0,  -267,   134,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   135,     0,     0,
     399,   136,   137,   138,    53,    54,    55,    56,    57,    58,
      59,    60,    22,     0,    23,    24,    61,    62,    63,    64,
       0,     0,     0,    65,    66,   400,   401,   374,    68,    69,
      70,    71,    72,    73,   402,    74,     0,     0,   403,    26,
      27,   139,   375,   404,    52,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,     0,   126,   127,     0,
       0,    53,    54,    55,    56,    57,    58,    59,    60,     0,
       0,     0,     0,    61,    62,    63,    64,   128,     0,     0,
      65,    66,     0,     0,    67,    68,    69,    70,    71,    72,
      73,     0,    74,     0,     0,     0,     0,    17,     0,    75,
      52,     0,   388,   389,   390,     0,   391,   392,   393,   394,
     395,   396,   397,   398,     0,   129,   130,     0,   131,   132,
       0,   133,     0,     0,  -237,     0,     0,   134,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   135,     0,     0,
     399,   136,   137,   138,    53,    54,    55,    56,    57,    58,
      59,    60,    22,    17,    23,    24,    61,    62,    63,    64,
       0,     0,     0,    65,    66,   400,   401,    67,    68,    69,
      70,    71,    72,    73,   402,    74,     0,     0,   403,     0,
      99,   139,    75,   404,    52,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,     0,   126,   127,     0,
      53,    54,    55,    56,    57,    58,    59,    60,    22,     0,
      23,    24,    61,    62,    63,    64,     0,   128,     0,    65,
      66,     0,     0,    67,    68,    69,    70,    71,    72,    73,
       0,    74,     0,     0,     0,     0,     0,     0,    75,    52,
       0,     0,     0,     0,   390,     0,   391,   392,   393,   394,
     395,   396,   397,   398,     0,   129,   130,     0,   131,   132,
       0,   133,     0,     0,  -237,     0,     0,   134,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   135,     0,     0,
     399,   136,   137,   138,    53,   763,   764,    56,   765,   766,
      59,    60,    17,     0,     0,     0,    61,    62,    63,    64,
       0,     0,     0,    65,    66,   400,   401,    67,    68,    69,
      70,    71,    72,    73,   402,    74,     0,     0,   403,     0,
       0,   139,    75,   404,    52,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,     0,   126,   127,    53,
      54,    55,    56,    57,    58,    59,    60,    22,     0,    23,
      24,    61,    62,    63,    64,     0,     0,   128,    65,    66,
       0,     0,    67,    68,    69,    70,    71,    72,    73,     0,
      74,     0,     0,     0,     0,     0,     0,    75,     0,     0,
       0,     0,     0,     0,   390,     0,   391,   392,   393,   394,
     395,   396,   397,   398,     0,   129,   130,     0,   131,   132,
       0,   133,     0,     0,  -237,     0,     0,   134,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   135,     0,     0,
     399,   136,   137,   138,    53,    54,    55,    56,    57,    58,
      59,    60,    52,     0,     0,     0,    61,    62,    63,    64,
       0,     0,     0,    65,    66,   400,   401,    67,    68,    69,
      70,    71,    72,    73,   402,    74,     0,     0,   403,     0,
       0,   139,    75,   404,     0,   588,     0,     0,   589,   590,
     591,   592,   593,   594,   595,   596,   597,   598,   599,   600,
     601,   602,   603,   604,   605,    17,   606,   607,   608,     0,
     609,   610,   611,   612,   613,   614,   615,   616,   617,   618,
     619,   620,     0,     1,     2,     3,     4,     5,     0,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
       0,    18,    19,    20,     0,     0,     0,     0,   621,   622,
     623,   624,    53,    54,    55,    56,    57,    58,    59,    60,
      22,     0,    23,    24,    61,    62,    63,    64,   625,   626,
     627,    65,    66,   628,   629,    67,    68,    69,    70,    71,
      72,    73,     0,    74,     0,     0,   630,     0,     0,     0,
      75,    52,   115,   116,   117,   118,   119,   120,   121,   122,
     123,   124,   125,     0,   126,   127,     0,     0,     0,     0,
      25,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    26,    27,   128,    28,     0,     0,     0,     0,
       0,     0,     0,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,     0,     0,
       0,     0,    52,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   129,   130,     0,   131,   132,     0,   133,     0,
       0,     0,     0,     0,   134,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   135,     0,     0,     0,   136,   137,
     138,    53,    54,    55,    56,    57,    58,    59,    60,    22,
       0,    23,    24,    61,    62,    63,    64,     0,     0,     0,
      65,    66,     0,     0,    67,    68,    69,    70,    71,    72,
      73,     0,    74,     0,   101,     0,     0,    27,   139,    75,
      52,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,     0,   126,   127,     0,     0,     0,     0,     0,
       0,     0,    53,    54,    55,    56,    57,    58,    59,    60,
       0,     0,     0,   128,    61,    62,    63,    64,     0,     0,
       0,    65,    66,     0,     0,    67,    68,    69,    70,    71,
      72,    73,     0,    74,     0,     0,    52,     0,     0,     0,
      75,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   129,   130,     0,   131,   132,     0,   133,     0,     0,
       0,     0,     0,   134,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   135,     0,     0,     0,   136,   137,   138,
      53,    54,    55,    56,    57,    58,    59,    60,   504,   567,
     505,   506,    61,    62,    63,    64,     0,     0,     0,    65,
      66,     0,     0,    67,    68,    69,    70,    71,    72,    73,
       0,    74,     0,     0,     0,     0,     0,   139,    75,    52,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,     0,   126,   127,   279,     0,    53,    54,    55,    56,
      57,    58,    59,    60,     0,     0,     0,     0,    61,    62,
      63,    64,   128,     0,   280,    65,    66,     0,     0,    67,
      68,    69,    70,    71,    72,    73,     0,    74,     0,     0,
     281,     0,     0,    52,    75,     0,     0,     0,     0,     0,
       0,     0,     0,   282,     0,     0,     0,     0,   283,     0,
     129,   130,     0,   131,   132,     0,   133,   284,   285,   243,
       0,   359,   134,     0,   286,     0,   287,     0,     0,     0,
       0,     0,   135,     0,     0,     0,   136,   137,   138,    53,
      54,    55,    56,    57,    58,    59,    60,     0,     0,     0,
       0,    61,    62,    63,    64,     0,     0,     0,    65,    66,
       0,     0,    67,    68,    69,    70,    71,    72,    73,     0,
      74,     0,     0,     0,     0,     0,   139,    75,    52,   115,
     116,   117,   118,   119,   120,   121,   122,   123,   124,   125,
       0,   126,   127,    53,    54,    55,    56,    57,    58,    59,
      60,     0,     0,     0,     0,    61,    62,    63,    64,     0,
       0,   128,   720,    66,     0,     0,    67,    68,    69,    70,
      71,    72,    73,     0,    74,     0,     0,     0,     0,     0,
       0,    75,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   129,
     130,     0,   131,   132,     0,   133,     0,     0,   243,     0,
     558,   134,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   135,     0,     0,     0,   136,   137,   138,    53,    54,
      55,    56,    57,    58,    59,    60,     0,     0,     0,     0,
      61,    62,    63,    64,     0,     0,     0,    65,    66,     0,
       0,    67,    68,    69,    70,    71,    72,    73,     0,    74,
       0,     0,     0,     0,     0,   139,    75,    52,   115,   116,
     117,   118,   119,   120,   121,   122,   123,   124,   125,     0,
     126,   127,     0,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,     0,     0,
     128,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    21,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   260,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   129,   130,
       0,   131,   132,     0,   133,     0,     0,   243,     0,    22,
     134,    23,    24,     0,     0,     0,     0,     0,     0,     0,
     135,     0,     0,     0,   136,   137,   138,    53,    54,    55,
      56,    57,    58,    59,    60,     0,     0,    27,     0,    61,
      62,    63,    64,     0,     0,     0,    65,    66,     0,     0,
      67,    68,    69,    70,    71,    72,    73,     0,    74,     0,
       0,     0,     0,     0,   139,    75,    52,   115,   116,   117,
     118,   119,   120,   121,   122,   123,   124,   125,     0,   126,
     127,     0,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,     0,     0,   128,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   373,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   129,   130,   335,
     131,   132,     0,   133,     0,     0,     0,     0,    22,   134,
      23,    24,     0,     0,     0,     0,     0,     0,     0,   135,
       0,     0,     0,   136,   137,   138,    53,    54,    55,    56,
      57,    58,    59,    60,     0,     0,    27,     0,    61,    62,
      63,    64,     0,     0,     0,    65,    66,     0,     0,    67,
      68,    69,    70,    71,    72,    73,     0,    74,     0,     0,
       0,     0,     0,   139,    75,    52,   115,   116,   117,   118,
     119,   120,   121,   122,   123,   124,   125,     0,   126,   127,
       0,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,     0,     0,   128,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   129,   130,     0,   131,
     132,     0,   133,     0,     0,     0,     0,    22,   134,    23,
      24,     0,     0,     0,     0,     0,     0,     0,   135,     0,
       0,     0,   136,   137,   138,    53,    54,    55,    56,    57,
      58,    59,    60,     0,     0,    27,     0,    61,    62,    63,
      64,     0,     0,     0,    65,    66,     0,     0,    67,    68,
      69,    70,    71,    72,    73,     0,    74,     0,     0,     0,
       0,     0,   139,    75,    52,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,     0,   126,   127,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   128,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   129,   195,     0,   131,   132,
       0,   133,     0,     0,     0,     0,     0,   134,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   135,     0,     0,
       0,   136,   137,   138,    53,    54,    55,    56,    57,    58,
      59,    60,     0,     0,     0,     0,    61,    62,    63,    64,
       0,     0,     0,    65,    66,     0,     0,    67,    68,    69,
      70,    71,    72,    73,     0,    74,     0,     0,     0,     0,
       0,   139,    75,    52,   115,   116,   117,   118,   119,   120,
     121,   122,   123,   124,   125,     0,   126,   127,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   128,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   129,   198,     0,   131,   132,     0,
     133,     0,     0,     0,     0,     0,   134,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   135,     0,     0,     0,
     136,   137,   138,    53,    54,    55,    56,    57,    58,    59,
      60,    52,     0,     0,     0,    61,    62,    63,    64,     0,
       0,     0,    65,    66,     0,     0,    67,    68,    69,    70,
      71,    72,    73,     0,    74,     0,     0,     0,     0,     0,
     139,    75,     0,     0,     0,     0,     0,     1,     2,     3,
       4,     5,     0,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,     0,    52,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,  -336,  -336,  -336,  -336,  -336,
    -336,  -336,  -336,  -336,  -336,  -336,  -336,  -336,  -336,  -336,
    -336,  -336,  -336,  -336,  -336,  -336,     0,     0,     0,     0,
       0,    53,    54,    55,    56,    57,    58,    59,    60,    22,
       0,    23,    24,    61,    62,    63,    64,     0,     0,     0,
      65,    66,     0,     0,   374,    68,    69,    70,    71,    72,
      73,   563,    74,  -336,  -336,     0,    26,    27,  -336,   375,
    -336,  -336,  -336,   462,  -336,     0,     0,     0,     0,  -336,
    -336,  -336,  -336,  -336,  -336,  -336,     0,     0,     0,    53,
      54,    55,    56,    57,    58,    59,    60,     0,     0,     0,
       0,    61,    62,    63,    64,     0,     0,     0,    65,    66,
       0,     0,    67,    68,    69,    70,    71,    72,    73,     0,
      74,     0,     0,     0,     0,     0,     0,    75,     1,     2,
       3,     4,     5,   387,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,    20,     1,
       2,     3,     4,     5,     0,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
       0,     0,     0,     0,   637,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    21,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      22,     0,    23,    24,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    25,     0,     0,     0,     0,
       0,    22,     0,    23,    24,     0,     0,    26,    27,     0,
      28,     0,     0,     0,     0,     0,    25,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    26,    27,
       0,    28,     1,     2,     3,     4,     5,   387,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
      18,    19,    20,     1,     2,     3,     4,     5,     0,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,   564,     1,     2,     3,     4,     5,
       0,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,     0,     0,     0,     0,
       0,     0,     0,     0,    22,     0,    23,    24,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    25,
       0,     0,     0,     0,     0,    22,     0,    23,    24,     0,
       0,    26,    27,     0,    28,     0,     0,     0,     0,     0,
      25,     0,     0,     0,     0,     0,     0,    22,     0,    23,
      24,     0,    26,    27,     0,    28,     0,     0,     0,     0,
       0,     0,    25,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    26,    27,     0,    28,  -225,  -225,
    -225,  -225,  -225,     0,  -225,  -225,  -225,  -225,  -225,  -225,
    -225,  -225,  -225,  -225,  -225,  -225,  -225,  -225,  -225,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,  -225,    21,  -337,  -337,  -337,
    -337,  -337,  -337,  -337,  -337,  -337,  -337,  -337,  -337,  -337,
    -337,  -337,  -337,  -337,  -337,  -337,  -337,  -337,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
    -225,     0,  -225,  -225,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,  -337,  -337,  -225,  -225,     0,
    -337,     0,  -337,  -337,  -337,     0,  -337,     0,     0,     0,
       0,  -337,  -337,  -337,  -337,  -337,  -337,  -337
};

static const yytype_int16 yycheck[] =
{
      20,   212,    34,    20,   393,   160,    21,    31,     0,   166,
     398,   166,   400,   248,     0,   719,   130,    21,    38,   289,
      34,    38,   526,    43,   210,   414,   691,    33,    34,     0,
      84,   441,   207,   547,    16,   431,    72,   143,   686,    72,
      25,    75,    79,    20,    84,   693,   412,   695,   414,   168,
      20,    21,    11,    45,    16,    37,    31,    49,   106,    45,
     674,    38,   217,    83,   198,   730,   410,    82,    16,    89,
      16,    79,    89,    16,    45,    37,    75,    85,   743,   213,
      11,   195,    99,   131,   198,   733,   243,   101,   243,    37,
     110,    37,   128,   110,    37,   128,   800,   134,   442,   443,
      78,   107,    80,   717,   493,   219,    15,    16,    17,    91,
      95,   499,    89,   130,    76,   221,   222,   223,    77,    33,
      53,    54,    92,    77,    94,   239,    39,    40,    41,    42,
      43,    62,   521,     0,   782,   106,    90,   161,   178,   535,
      53,    54,    88,   657,    77,    88,   170,   266,    77,   181,
     164,   168,    79,     4,    77,   310,   173,   312,   175,   173,
     430,    90,   528,   828,    91,   813,    75,   181,    91,   439,
     174,    76,    81,   193,    79,   181,   193,    90,    87,   827,
      79,   198,   571,   158,    73,    99,   161,   204,    77,   206,
      83,    90,   207,    82,   214,   170,   213,   214,   218,    83,
     254,   218,   377,    79,    83,   180,   260,    75,   248,    77,
      79,   182,   318,   126,   254,    91,   130,    93,    45,    87,
     260,   725,    91,    79,    93,   138,    79,   462,   141,    85,
      57,    58,   207,    75,   644,   645,    79,   214,    91,    77,
      79,   218,   296,    83,    87,    87,    85,    76,   268,   266,
      75,    62,   272,    79,   168,   272,   296,    76,   172,   173,
      79,   175,    87,    79,   534,    91,   286,   287,   678,   679,
     680,    75,    75,    75,   294,    91,   268,   294,   667,   668,
     669,   105,   268,   671,   198,    87,    62,   111,   402,    79,
     204,    75,   206,   104,   105,    90,   107,   108,    88,   213,
      75,   104,   105,    87,   107,   108,    79,    74,    76,    77,
     465,    79,   467,   468,    84,   550,   471,   474,    91,   474,
      76,   532,   533,    79,   734,   128,   129,   130,   104,   105,
     105,   107,   108,   204,   388,   206,   111,    90,   113,   114,
     115,   116,   366,   363,    76,   531,   378,    79,   388,   504,
     505,   506,   266,    96,   509,    90,   370,   100,   101,   102,
      89,     4,   377,   377,     7,    76,     9,   756,    11,    24,
     758,   363,   378,   393,    76,   395,   393,   363,   395,    83,
     494,   495,   496,    18,    19,    39,    40,    41,    42,    43,
      76,   366,   412,    79,   414,   412,    83,   414,    76,    53,
      54,    79,   377,   104,   105,    76,   107,   108,    79,    76,
      77,   681,    79,   228,   229,   230,   231,    76,    22,    23,
      79,   441,   462,    76,   123,   479,    79,   481,   817,   421,
     700,    76,    76,   473,    79,    79,   737,    76,   739,   479,
      79,   481,   119,   120,   121,   278,   461,   280,    76,   469,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
     100,   101,   102,   483,    53,    54,   652,   487,    83,   489,
     490,    83,   126,   493,   224,   225,   493,    78,    79,    93,
     750,   226,   227,    93,   138,    76,   461,   141,   674,    88,
     232,   233,   275,   276,   486,    93,    90,    90,    83,    76,
     486,   521,   522,   689,   521,   522,   526,   662,   663,   526,
     550,    75,   698,    75,   700,    75,   491,    93,   673,   103,
     790,    63,    75,    75,   794,    79,    76,    88,    79,    75,
      79,   717,    90,   719,    75,    75,    75,    84,    75,    24,
     132,    83,    85,    91,    79,    11,    91,    91,   563,   563,
     118,   571,   134,    91,   571,   547,   670,    99,    91,    90,
      90,   547,    85,   833,    85,    90,    90,    85,    90,   839,
     112,    83,   842,    87,    76,   117,    76,   134,    66,   126,
     127,   128,    90,    11,   126,   127,    91,    91,   563,    85,
      91,   133,    85,   135,   136,    79,   143,   808,    76,    88,
     755,    83,    83,    76,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    79,
     775,   776,    79,    76,   644,   645,   837,    75,    91,   840,
      75,   178,    83,    38,    78,    75,    75,    75,    64,    91,
      87,    11,    88,    76,    85,    88,    76,   667,   668,   669,
     667,   668,   669,    76,    21,   675,    91,    75,   678,   679,
     680,    81,    87,    85,    76,   657,    33,    34,    76,   824,
     111,   657,   113,   114,   221,   222,   223,   224,   225,   226,
     227,   228,   229,   230,   231,   232,   233,   234,   235,   236,
     237,   238,    90,    90,    79,    64,    91,    76,   139,    76,
     720,   248,    76,    79,    75,   725,    90,   254,   725,    90,
     134,    91,    85,   260,   734,    82,    91,    15,    90,    85,
      75,    85,    90,    63,    83,    90,    63,    90,    90,    90,
      76,    76,    99,    93,    76,    88,   756,    76,    76,   756,
     107,    90,    76,    83,    85,   235,    83,    90,   234,   296,
     770,   771,   491,   236,    90,   158,   175,   237,   164,    99,
     173,   238,    99,   130,   104,   105,   366,   107,   108,   486,
       0,   318,   112,   370,     4,   112,   193,   117,   294,   429,
     117,   118,   802,   363,    45,   805,   126,   127,   412,   126,
     127,   717,   395,   133,   524,   135,   133,   817,   135,   634,
     817,   168,   805,   770,   698,   172,   173,   174,   175,    39,
      40,    41,    42,    43,   181,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
     703,   198,   649,   400,    -1,    -1,    -1,   204,    -1,   206,
      -1,   388,    -1,    -1,    -1,    -1,   213,    77,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,     3,    -1,    -1,    -1,    -1,    -1,    63,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   111,    -1,   113,   114,    -1,    -1,    83,    -1,   119,
     120,   121,    -1,    -1,    -1,    -1,   126,    -1,   265,   266,
      -1,     0,    -1,    99,    -1,     4,    -1,    -1,   138,   139,
      -1,   141,   142,    -1,    56,   462,   112,    -1,    -1,    -1,
      -1,   117,   118,    -1,    -1,    -1,   473,    -1,    -1,    -1,
     126,   127,   479,    75,   481,    -1,    -1,   133,    -1,   135,
      39,    40,    41,    42,    43,    -1,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,   103,   104,   105,   106,   107,   108,   109,   110,   111,
      -1,   113,   114,   115,   116,   117,   118,    -1,    77,    -1,
     122,   123,    -1,    -1,   126,   127,   128,   129,   130,   131,
     132,    -1,   134,    -1,    -1,    -1,    -1,    -1,    -1,   141,
      -1,    -1,    -1,   550,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   378,   111,    -1,   113,   114,    -1,    -1,    -1,    -1,
     119,   120,   121,    -1,    -1,    -1,    -1,   126,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   138,
     139,    -1,   141,   142,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    -1,    16,    17,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      -1,    57,    58,    59,    -1,    -1,    -1,    36,    -1,    -1,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    -1,    61,    62,    63,    -1,    65,    66,    67,    68,
      69,    70,    71,    72,    -1,    74,    75,    -1,    77,    78,
      -1,    80,    -1,    -1,    83,    -1,    85,    86,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,   111,   139,   113,   114,   115,   116,   117,   118,
      -1,    -1,    -1,   122,   123,   124,   125,   126,   127,   128,
     129,   130,   131,   132,   133,   134,    -1,    -1,   137,   138,
     139,   140,   141,   142,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    -1,    16,    17,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    36,    -1,    -1,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,     3,    61,    62,    63,    -1,    65,    66,    67,    68,
      69,    70,    71,    72,    -1,    74,    75,    -1,    77,    78,
      -1,    80,    -1,    -1,    83,    -1,    85,    86,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,   111,    -1,   113,   114,   115,   116,   117,   118,
      -1,    -1,    -1,   122,   123,   124,   125,   126,   127,   128,
     129,   130,   131,   132,   133,   134,    -1,    -1,   137,   138,
     139,   140,   141,   142,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    -1,    16,    17,    -1,
      -1,   103,   104,   105,   106,   107,   108,   109,   110,    -1,
      -1,    -1,    -1,   115,   116,   117,   118,    36,    -1,    -1,
     122,   123,    -1,    -1,   126,   127,   128,   129,   130,   131,
     132,    -1,   134,    -1,    -1,    -1,    -1,    56,    -1,   141,
       3,    -1,    61,    62,    63,    -1,    65,    66,    67,    68,
      69,    70,    71,    72,    -1,    74,    75,    -1,    77,    78,
      -1,    80,    -1,    -1,    83,    -1,    -1,    86,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,   111,    56,   113,   114,   115,   116,   117,   118,
      -1,    -1,    -1,   122,   123,   124,   125,   126,   127,   128,
     129,   130,   131,   132,   133,   134,    -1,    -1,   137,    -1,
      83,   140,   141,   142,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    -1,    16,    17,    -1,
     103,   104,   105,   106,   107,   108,   109,   110,   111,    -1,
     113,   114,   115,   116,   117,   118,    -1,    36,    -1,   122,
     123,    -1,    -1,   126,   127,   128,   129,   130,   131,   132,
      -1,   134,    -1,    -1,    -1,    -1,    -1,    -1,   141,     3,
      -1,    -1,    -1,    -1,    63,    -1,    65,    66,    67,    68,
      69,    70,    71,    72,    -1,    74,    75,    -1,    77,    78,
      -1,    80,    -1,    -1,    83,    -1,    -1,    86,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,    56,    -1,    -1,    -1,   115,   116,   117,   118,
      -1,    -1,    -1,   122,   123,   124,   125,   126,   127,   128,
     129,   130,   131,   132,   133,   134,    -1,    -1,   137,    -1,
      -1,   140,   141,   142,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    -1,    16,    17,   103,
     104,   105,   106,   107,   108,   109,   110,   111,    -1,   113,
     114,   115,   116,   117,   118,    -1,    -1,    36,   122,   123,
      -1,    -1,   126,   127,   128,   129,   130,   131,   132,    -1,
     134,    -1,    -1,    -1,    -1,    -1,    -1,   141,    -1,    -1,
      -1,    -1,    -1,    -1,    63,    -1,    65,    66,    67,    68,
      69,    70,    71,    72,    -1,    74,    75,    -1,    77,    78,
      -1,    80,    -1,    -1,    83,    -1,    -1,    86,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,     3,    -1,    -1,    -1,   115,   116,   117,   118,
      -1,    -1,    -1,   122,   123,   124,   125,   126,   127,   128,
     129,   130,   131,   132,   133,   134,    -1,    -1,   137,    -1,
      -1,   140,   141,   142,    -1,    36,    -1,    -1,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    -1,
      61,    62,    63,    64,    65,    66,    67,    68,    69,    70,
      71,    72,    -1,    39,    40,    41,    42,    43,    -1,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      -1,    57,    58,    59,    -1,    -1,    -1,    -1,    99,   100,
     101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
     111,    -1,   113,   114,   115,   116,   117,   118,   119,   120,
     121,   122,   123,   124,   125,   126,   127,   128,   129,   130,
     131,   132,    -1,   134,    -1,    -1,   137,    -1,    -1,    -1,
     141,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    -1,    16,    17,    -1,    -1,    -1,    -1,
     126,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   138,   139,    36,   141,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    -1,    -1,
      -1,    -1,     3,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    74,    75,    -1,    77,    78,    -1,    80,    -1,
      -1,    -1,    -1,    -1,    86,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    96,    -1,    -1,    -1,   100,   101,
     102,   103,   104,   105,   106,   107,   108,   109,   110,   111,
      -1,   113,   114,   115,   116,   117,   118,    -1,    -1,    -1,
     122,   123,    -1,    -1,   126,   127,   128,   129,   130,   131,
     132,    -1,   134,    -1,    75,    -1,    -1,   139,   140,   141,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    -1,    16,    17,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   103,   104,   105,   106,   107,   108,   109,   110,
      -1,    -1,    -1,    36,   115,   116,   117,   118,    -1,    -1,
      -1,   122,   123,    -1,    -1,   126,   127,   128,   129,   130,
     131,   132,    -1,   134,    -1,    -1,     3,    -1,    -1,    -1,
     141,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    74,    75,    -1,    77,    78,    -1,    80,    -1,    -1,
      -1,    -1,    -1,    86,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    96,    -1,    -1,    -1,   100,   101,   102,
     103,   104,   105,   106,   107,   108,   109,   110,   111,    56,
     113,   114,   115,   116,   117,   118,    -1,    -1,    -1,   122,
     123,    -1,    -1,   126,   127,   128,   129,   130,   131,   132,
      -1,   134,    -1,    -1,    -1,    -1,    -1,   140,   141,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    -1,    16,    17,    63,    -1,   103,   104,   105,   106,
     107,   108,   109,   110,    -1,    -1,    -1,    -1,   115,   116,
     117,   118,    36,    -1,    83,   122,   123,    -1,    -1,   126,
     127,   128,   129,   130,   131,   132,    -1,   134,    -1,    -1,
      99,    -1,    -1,     3,   141,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   112,    -1,    -1,    -1,    -1,   117,    -1,
      74,    75,    -1,    77,    78,    -1,    80,   126,   127,    83,
      -1,    85,    86,    -1,   133,    -1,   135,    -1,    -1,    -1,
      -1,    -1,    96,    -1,    -1,    -1,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,    -1,    -1,    -1,
      -1,   115,   116,   117,   118,    -1,    -1,    -1,   122,   123,
      -1,    -1,   126,   127,   128,   129,   130,   131,   132,    -1,
     134,    -1,    -1,    -1,    -1,    -1,   140,   141,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      -1,    16,    17,   103,   104,   105,   106,   107,   108,   109,
     110,    -1,    -1,    -1,    -1,   115,   116,   117,   118,    -1,
      -1,    36,   122,   123,    -1,    -1,   126,   127,   128,   129,
     130,   131,   132,    -1,   134,    -1,    -1,    -1,    -1,    -1,
      -1,   141,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    74,
      75,    -1,    77,    78,    -1,    80,    -1,    -1,    83,    -1,
      85,    86,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    96,    -1,    -1,    -1,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,    -1,    -1,    -1,    -1,
     115,   116,   117,   118,    -1,    -1,    -1,   122,   123,    -1,
      -1,   126,   127,   128,   129,   130,   131,   132,    -1,   134,
      -1,    -1,    -1,    -1,    -1,   140,   141,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    -1,
      16,    17,    -1,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    -1,    -1,
      36,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    77,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    90,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    74,    75,
      -1,    77,    78,    -1,    80,    -1,    -1,    83,    -1,   111,
      86,   113,   114,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      96,    -1,    -1,    -1,   100,   101,   102,   103,   104,   105,
     106,   107,   108,   109,   110,    -1,    -1,   139,    -1,   115,
     116,   117,   118,    -1,    -1,    -1,   122,   123,    -1,    -1,
     126,   127,   128,   129,   130,   131,   132,    -1,   134,    -1,
      -1,    -1,    -1,    -1,   140,   141,     3,     4,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    -1,    16,
      17,    -1,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    -1,    -1,    36,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    85,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    74,    75,    76,
      77,    78,    -1,    80,    -1,    -1,    -1,    -1,   111,    86,
     113,   114,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,
      -1,    -1,    -1,   100,   101,   102,   103,   104,   105,   106,
     107,   108,   109,   110,    -1,    -1,   139,    -1,   115,   116,
     117,   118,    -1,    -1,    -1,   122,   123,    -1,    -1,   126,
     127,   128,   129,   130,   131,   132,    -1,   134,    -1,    -1,
      -1,    -1,    -1,   140,   141,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    -1,    16,    17,
      -1,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    -1,    -1,    36,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    74,    75,    -1,    77,
      78,    -1,    80,    -1,    -1,    -1,    -1,   111,    86,   113,
     114,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,
      -1,    -1,   100,   101,   102,   103,   104,   105,   106,   107,
     108,   109,   110,    -1,    -1,   139,    -1,   115,   116,   117,
     118,    -1,    -1,    -1,   122,   123,    -1,    -1,   126,   127,
     128,   129,   130,   131,   132,    -1,   134,    -1,    -1,    -1,
      -1,    -1,   140,   141,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    -1,    16,    17,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    36,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    74,    75,    -1,    77,    78,
      -1,    80,    -1,    -1,    -1,    -1,    -1,    86,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,
      -1,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,    -1,    -1,    -1,    -1,   115,   116,   117,   118,
      -1,    -1,    -1,   122,   123,    -1,    -1,   126,   127,   128,
     129,   130,   131,   132,    -1,   134,    -1,    -1,    -1,    -1,
      -1,   140,   141,     3,     4,     5,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    -1,    16,    17,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    36,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    74,    75,    -1,    77,    78,    -1,
      80,    -1,    -1,    -1,    -1,    -1,    86,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,    -1,
     100,   101,   102,   103,   104,   105,   106,   107,   108,   109,
     110,     3,    -1,    -1,    -1,   115,   116,   117,   118,    -1,
      -1,    -1,   122,   123,    -1,    -1,   126,   127,   128,   129,
     130,   131,   132,    -1,   134,    -1,    -1,    -1,    -1,    -1,
     140,   141,    -1,    -1,    -1,    -1,    -1,    39,    40,    41,
      42,    43,    -1,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    -1,     3,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    15,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    -1,    -1,    -1,    -1,
      -1,   103,   104,   105,   106,   107,   108,   109,   110,   111,
      -1,   113,   114,   115,   116,   117,   118,    -1,    -1,    -1,
     122,   123,    -1,    -1,   126,   127,   128,   129,   130,   131,
     132,    75,   134,    73,    74,    -1,   138,   139,    78,   141,
      80,    81,    82,    87,    84,    -1,    -1,    -1,    -1,    89,
      90,    91,    92,    93,    94,    95,    -1,    -1,    -1,   103,
     104,   105,   106,   107,   108,   109,   110,    -1,    -1,    -1,
      -1,   115,   116,   117,   118,    -1,    -1,    -1,   122,   123,
      -1,    -1,   126,   127,   128,   129,   130,   131,   132,    -1,
     134,    -1,    -1,    -1,    -1,    -1,    -1,   141,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    39,
      40,    41,    42,    43,    -1,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      -1,    -1,    -1,    -1,    85,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    77,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     111,    -1,   113,   114,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   126,    -1,    -1,    -1,    -1,
      -1,   111,    -1,   113,   114,    -1,    -1,   138,   139,    -1,
     141,    -1,    -1,    -1,    -1,    -1,   126,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   138,   139,
      -1,   141,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    52,    53,    54,    55,    56,
      57,    58,    59,    39,    40,    41,    42,    43,    -1,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,    39,    40,    41,    42,    43,
      -1,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   111,    -1,   113,   114,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   126,
      -1,    -1,    -1,    -1,    -1,   111,    -1,   113,   114,    -1,
      -1,   138,   139,    -1,   141,    -1,    -1,    -1,    -1,    -1,
     126,    -1,    -1,    -1,    -1,    -1,    -1,   111,    -1,   113,
     114,    -1,   138,   139,    -1,   141,    -1,    -1,    -1,    -1,
      -1,    -1,   126,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   138,   139,    -1,   141,    39,    40,
      41,    42,    43,    -1,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    76,    77,    15,    16,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     111,    -1,   113,   114,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    73,    74,   138,   139,    -1,
      78,    -1,    80,    81,    82,    -1,    84,    -1,    -1,    -1,
      -1,    89,    90,    91,    92,    93,    94,    95
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int16 yystos[] =
{
       0,    39,    40,    41,    42,    43,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    77,   111,   113,   114,   126,   138,   139,   141,   142,
     168,   169,   171,   172,   173,   178,   180,   181,   182,   194,
     199,   201,   207,   208,   242,   243,   244,   245,   247,   250,
     251,   252,     3,   103,   104,   105,   106,   107,   108,   109,
     110,   115,   116,   117,   118,   122,   123,   126,   127,   128,
     129,   130,   131,   132,   134,   141,   195,   248,   250,   260,
     199,   207,   209,    75,    75,    91,   174,   176,   200,   208,
     178,   180,   199,   171,   175,   177,   178,   199,   201,    83,
     248,    75,   204,   260,     0,   244,   246,   173,     4,   254,
      83,   196,   199,   207,   260,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    16,    17,    36,    74,
      75,    77,    78,    80,    86,    96,   100,   101,   102,   140,
     145,   146,   148,   149,   150,   151,   152,   153,   154,   155,
     156,   157,   158,   159,   160,   161,   166,   260,    79,    91,
      93,    75,   202,   248,    79,    91,    93,   180,   183,   184,
     185,   186,   187,   209,   250,    83,   201,    75,    87,   168,
     169,   173,   228,   229,   119,   120,   121,   253,   255,   258,
     197,   198,   248,    83,    76,    75,   148,   148,    75,   148,
     148,   161,   162,   164,   179,   180,   199,   215,   216,   250,
      90,    90,    90,    75,    15,    16,    17,    75,    81,    87,
     150,    73,    77,    82,    78,    80,    18,    19,    20,    21,
      92,    94,    22,    23,    74,    89,    84,    24,    25,    95,
      76,   176,   200,    83,   162,   221,   200,    75,    87,   177,
     201,   221,    85,   184,    90,   188,   189,   200,   180,   199,
      90,   186,   191,   192,   201,   209,   183,    76,   205,   166,
     167,   168,    83,   227,    83,    83,    83,   123,   268,    63,
      83,    99,   112,   117,   126,   127,   133,   135,   136,   270,
     271,   274,   284,   287,    79,    85,    93,   197,   216,    26,
      27,    28,    29,    30,    31,    32,    33,    34,    35,    93,
     163,    76,    79,   215,   215,   207,   208,   217,    76,   104,
     105,   107,   108,   291,    75,   105,   111,   113,   114,   115,
     116,   290,   290,   216,   248,    76,   147,   162,   248,   164,
     150,   150,   150,   151,   151,   152,   152,   153,   153,   153,
     153,   154,   154,   155,   156,   157,   158,   159,   164,    85,
     221,   222,    76,   203,   167,   166,    79,    91,    90,   166,
      79,    91,    90,    85,   126,   141,   169,   170,   173,   206,
     210,   211,   212,   213,   214,   260,    88,    44,    61,    62,
      63,    65,    66,    67,    68,    69,    70,    71,    72,    99,
     124,   125,   133,   137,   142,   164,   165,   168,   223,   224,
     225,   226,   230,   231,   233,   234,   235,   236,   240,   241,
     249,   250,   260,    11,    77,   262,   263,   262,   262,    83,
     270,    96,   100,   101,   102,   281,   282,   283,   269,   270,
      75,    75,   285,   286,   272,   260,   289,   260,     4,     7,
       9,    11,   259,   118,   271,   198,   166,    85,    76,   162,
     162,    75,    87,   218,   150,    75,   103,    75,    75,    79,
      76,    79,    88,    90,    79,    85,   206,    88,   189,   190,
     192,   193,   201,   208,   217,    76,    79,    79,    45,    57,
      58,   232,   166,    90,    75,    75,    75,   223,   250,    75,
     249,   260,    91,    91,   111,   113,   114,   165,   292,    75,
     292,    91,   164,    91,    91,   227,   231,   234,   223,   231,
      85,    90,    85,    78,    79,   264,    85,   256,   230,   118,
     283,    90,    90,    90,   132,    24,    85,    11,   289,   227,
     227,    83,    87,   134,   134,   118,   217,   219,   167,    75,
      87,   162,    76,   162,   162,   260,   162,   161,    85,   221,
      76,   166,   166,    75,    60,   213,   260,    56,   260,   260,
     174,    90,   223,   164,   164,   164,    66,   165,    91,   162,
     162,   162,    91,   162,    91,   134,    85,   223,    36,    39,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    57,    58,    59,    61,
      62,    63,    64,    65,    66,    67,    68,    69,    70,    71,
      72,    99,   100,   101,   102,   119,   120,   121,   124,   125,
     137,   250,   260,   261,   263,   261,    85,    85,   291,   290,
     290,   271,   283,    76,    79,    79,    72,   128,   293,   294,
     295,    11,    83,    83,    76,   211,    88,   220,   167,    76,
     105,   111,    79,    79,    76,    91,   223,    76,    76,    76,
      75,    91,    76,    79,    83,    75,   264,    38,    75,    75,
      75,    64,    91,   288,   289,   289,    75,   128,   129,   130,
     291,   296,   297,    87,   273,    72,   295,    88,   275,   276,
     278,   291,    11,   279,   280,    76,   211,    88,   162,   162,
     223,   223,   223,   164,   165,    91,   162,   237,   238,   278,
     122,   260,   265,   266,   267,   257,   289,   289,   289,   271,
      76,    76,   296,    87,    75,   291,    16,    37,   288,   298,
      81,   296,    85,   296,    62,   276,   277,   271,   291,    90,
      90,    62,   280,    76,    76,    79,    64,    76,    91,    76,
      62,   238,   239,   104,   105,   107,   108,   224,   260,    76,
      79,    87,   261,    76,    76,    79,    79,   288,   134,    76,
     296,   289,    75,   297,   297,   106,   131,   300,    88,   288,
      90,    85,    90,   271,    90,   162,   223,    91,   165,    91,
      90,    85,    15,   267,   260,    75,   162,   162,    83,    88,
      76,   296,   299,    93,   271,   271,    76,    76,   224,   260,
      88,   265,    76,    76,    79,   290,    76,    79,   296,    85,
     223,    76,   162,    90,   296,   288,    76,   271,   290,    90,
     271,   290,    90,   271,    85
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int16 yyr1[] =
{
       0,   144,   145,   145,   145,   145,   145,   145,   145,   145,
     145,   145,   145,   145,   145,   146,   146,   146,   146,   146,
     146,   146,   146,   146,   146,   146,   147,   147,   148,   148,
     148,   148,   148,   148,   148,   149,   149,   149,   149,   149,
     149,   150,   150,   151,   151,   151,   151,   152,   152,   152,
     153,   153,   153,   154,   154,   154,   154,   154,   155,   155,
     155,   156,   156,   157,   157,   158,   158,   159,   159,   160,
     160,   161,   161,   162,   162,   163,   163,   163,   163,   163,
     163,   163,   163,   163,   163,   163,   164,   164,   165,   165,
     166,   167,   167,   168,   168,   168,   169,   169,   170,   170,
     171,   171,   171,   172,   172,   172,   172,   173,   173,   173,
     173,   174,   174,   175,   175,   176,   176,   177,   177,   178,
     178,   178,   178,   178,   178,   178,   178,   179,   179,   180,
     180,   180,   180,   180,   180,   180,   180,   180,   180,   180,
     180,   181,   181,   181,   182,   182,   183,   183,   184,   184,
     185,   185,   186,   186,   186,   187,   187,   187,   188,   188,
     189,   189,   190,   189,   191,   191,   192,   192,   193,   192,
     195,   194,   196,   194,   194,   197,   197,   198,   198,   199,
     199,   200,   201,   202,   202,   202,   203,   202,   204,   204,
     204,   205,   204,   206,   206,   207,   207,   207,   207,   208,
     208,   209,   209,   210,   210,   211,   211,   212,   212,   213,
     213,   213,   214,   214,   215,   215,   215,   215,   216,   216,
     217,   217,   218,   218,   218,   219,   218,   220,   218,   221,
     221,   221,   221,   222,   222,   223,   223,   225,   224,   224,
     224,   224,   224,   224,   224,   224,   226,   226,   226,   227,
     227,   228,   228,   229,   229,   230,   230,   231,   231,   232,
     232,   232,   232,   233,   233,   233,   234,   234,   235,   236,
     236,   236,   236,   237,   237,   238,   239,   239,   240,   240,
     240,   241,   241,   241,   241,   241,   241,   241,   242,   242,
     243,   243,   244,   244,   244,   244,   246,   245,   247,   247,
     247,   248,   248,   249,   249,   250,   250,   250,   250,   252,
     251,   253,   253,   253,   254,   254,   255,   256,   257,   255,
     258,   259,   259,   259,   259,   260,   260,   260,   260,   260,
     260,   260,   260,   260,   260,   260,   260,   260,   260,   260,
     260,   260,   260,   260,   260,   260,   260,   260,   260,   261,
     261,   261,   261,   261,   261,   261,   261,   261,   261,   261,
     261,   261,   261,   261,   261,   261,   261,   261,   261,   261,
     261,   261,   261,   261,   261,   261,   261,   261,   261,   261,
     261,   261,   261,   261,   261,   261,   261,   261,   261,   261,
     261,   261,   261,   261,   262,   262,   262,   263,   263,   264,
     264,   265,   265,   265,   266,   266,   267,   267,   267,   268,
     268,   269,   269,   270,   270,   271,   271,   271,   271,   272,
     273,   271,   274,   274,   274,   274,   274,   275,   275,   276,
     277,   277,   278,   278,   279,   279,   280,   281,   281,   282,
     282,   283,   283,   283,   283,   283,   285,   284,   286,   284,
     287,   287,   288,   288,   289,   289,   290,   290,   290,   290,
     290,   290,   290,   290,   291,   291,   291,   291,   292,   292,
     292,   292,   293,   293,   293,   294,   294,   295,   296,   296,
     296,   297,   297,   297,   297,   297,   297,   298,   299,   299,
     300,   300
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     3,     1,     4,     3,     4,     3,
       3,     2,     2,     6,     8,    10,     1,     3,     1,     2,
       2,     2,     2,     4,     6,     1,     1,     1,     1,     1,
       1,     1,     4,     1,     3,     3,     3,     1,     3,     3,
       1,     3,     3,     1,     3,     3,     3,     3,     1,     3,
       3,     1,     3,     1,     3,     1,     3,     1,     3,     1,
       3,     1,     5,     1,     3,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     3,     0,     1,
       1,     0,     1,     2,     3,     3,     1,     2,     1,     1,
       1,     2,     1,     1,     2,     2,     2,     1,     1,     2,
       2,     1,     3,     1,     3,     1,     3,     1,     3,     1,
       1,     1,     1,     1,     1,     1,     4,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       4,     5,     4,     2,     1,     1,     1,     2,     3,     3,
       1,     2,     1,     2,     1,     1,     2,     2,     1,     3,
       1,     2,     0,     4,     1,     3,     1,     2,     0,     4,
       0,     5,     0,     6,     2,     1,     3,     1,     3,     1,
       1,     2,     2,     1,     3,     4,     0,     5,     1,     3,
       4,     0,     5,     1,     1,     1,     2,     2,     3,     0,
       1,     1,     2,     1,     3,     0,     1,     1,     3,     2,
       1,     2,     1,     3,     1,     1,     2,     2,     1,     2,
       1,     2,     3,     3,     4,     0,     4,     0,     5,     1,
       2,     3,     4,     1,     3,     1,     1,     0,     2,     1,
       1,     1,     1,     5,     7,     1,     3,     4,     3,     3,
       4,     1,     2,     0,     1,     1,     2,     1,     4,     1,
       2,     2,     2,     1,     2,     2,     0,     1,     2,     5,
       7,     5,     7,     1,     2,     2,     0,     3,     5,     7,
       9,     3,     2,     2,     3,     3,     2,     2,     0,     1,
       1,     2,     1,     1,     1,     1,     0,     4,     1,     2,
       2,     1,     1,     1,     1,     1,     1,     1,     1,     0,
       3,     4,     3,     4,     0,     1,     8,     0,     0,    11,
       5,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     0,     2,     4,     1,     1,     0,
       1,     0,     1,     4,     1,     3,     1,     2,     4,     0,
       4,     0,     1,     1,     2,     1,     1,     1,     3,     0,
       0,     6,     4,     6,     7,     9,    18,     1,     2,     2,
       0,     3,     2,     3,     1,     2,     3,     1,     2,     1,
       3,     6,     6,     8,     8,    10,     0,     3,     0,     3,
       5,     7,     0,     1,     1,     4,     1,     1,     1,     1,
       1,     1,     4,     4,     1,     1,     1,     1,     1,     2,
       2,     2,     4,     3,     1,     1,     2,     7,     1,     3,
       3,     1,     4,     5,     4,     3,     3,     1,     1,     3,
       1,     1
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2: /* primary_expr: identifier  */
#line 110 "rttgram.y"
                  {(yyval.n) = sym_node((yyvsp[0].t));}
#line 2575 "rttgram.tab.c"
    break;

  case 3: /* primary_expr: StrLit  */
#line 111 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2581 "rttgram.tab.c"
    break;

  case 4: /* primary_expr: LStrLit  */
#line 112 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2587 "rttgram.tab.c"
    break;

  case 5: /* primary_expr: FltConst  */
#line 113 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2593 "rttgram.tab.c"
    break;

  case 6: /* primary_expr: DblConst  */
#line 114 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2599 "rttgram.tab.c"
    break;

  case 7: /* primary_expr: LDblConst  */
#line 115 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2605 "rttgram.tab.c"
    break;

  case 8: /* primary_expr: CharConst  */
#line 116 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2611 "rttgram.tab.c"
    break;

  case 9: /* primary_expr: LCharConst  */
#line 117 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2617 "rttgram.tab.c"
    break;

  case 10: /* primary_expr: IntConst  */
#line 118 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2623 "rttgram.tab.c"
    break;

  case 11: /* primary_expr: UIntConst  */
#line 119 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2629 "rttgram.tab.c"
    break;

  case 12: /* primary_expr: LIntConst  */
#line 120 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2635 "rttgram.tab.c"
    break;

  case 13: /* primary_expr: ULIntConst  */
#line 121 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2641 "rttgram.tab.c"
    break;

  case 14: /* primary_expr: '(' expr ')'  */
#line 122 "rttgram.y"
                  {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 2647 "rttgram.tab.c"
    break;

  case 16: /* postfix_expr: postfix_expr '[' expr ']'  */
#line 127 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                        free_t((yyvsp[0].t));}
#line 2654 "rttgram.tab.c"
    break;

  case 17: /* postfix_expr: postfix_expr '(' ')'  */
#line 129 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), NULL);
                                        free_t((yyvsp[-1].t));}
#line 2661 "rttgram.tab.c"
    break;

  case 18: /* postfix_expr: postfix_expr '(' arg_expr_lst ')'  */
#line 131 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                        free_t((yyvsp[-2].t));}
#line 2668 "rttgram.tab.c"
    break;

  case 19: /* postfix_expr: postfix_expr '.' any_ident  */
#line 133 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2674 "rttgram.tab.c"
    break;

  case 20: /* postfix_expr: postfix_expr Arrow any_ident  */
#line 134 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2680 "rttgram.tab.c"
    break;

  case 21: /* postfix_expr: postfix_expr Incr  */
#line 135 "rttgram.y"
                                       {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-1].n));}
#line 2686 "rttgram.tab.c"
    break;

  case 22: /* postfix_expr: postfix_expr Decr  */
#line 136 "rttgram.y"
                                       {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-1].n));}
#line 2692 "rttgram.tab.c"
    break;

  case 23: /* postfix_expr: Is ':' i_type_name '(' assign_expr ')'  */
#line 138 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-5].t), (yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 2698 "rttgram.tab.c"
    break;

  case 24: /* postfix_expr: Cnv ':' dest_type '(' assign_expr ',' assign_expr ')'  */
#line 140 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-7].t), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-6].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 2705 "rttgram.tab.c"
    break;

  case 25: /* postfix_expr: Def ':' dest_type '(' assign_expr ',' assign_expr ',' assign_expr ')'  */
#line 143 "rttgram.y"
      {(yyval.n) = node4(QuadNd, (yyvsp[-9].t), (yyvsp[-7].n), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-8].t)); free_t((yyvsp[-6].t));
       free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 2712 "rttgram.tab.c"
    break;

  case 27: /* arg_expr_lst: arg_expr_lst ',' assign_expr  */
#line 149 "rttgram.y"
                                  {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2718 "rttgram.tab.c"
    break;

  case 29: /* unary_expr: Incr unary_expr  */
#line 154 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2724 "rttgram.tab.c"
    break;

  case 30: /* unary_expr: Decr unary_expr  */
#line 155 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2730 "rttgram.tab.c"
    break;

  case 31: /* unary_expr: unary_op cast_expr  */
#line 156 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2736 "rttgram.tab.c"
    break;

  case 32: /* unary_expr: Sizeof unary_expr  */
#line 157 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2742 "rttgram.tab.c"
    break;

  case 33: /* unary_expr: Sizeof '(' type_name ')'  */
#line 158 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                               free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 2749 "rttgram.tab.c"
    break;

  case 34: /* unary_expr: Offsetof '(' type_name ',' identifier ')'  */
#line 165 "rttgram.y"
      {(yyval.n) = node1(PrefxNd, (yyvsp[-5].t),
                   node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), node0(PrimryNd, (yyvsp[-1].t))));
       free_t((yyvsp[-4].t)); free_t((yyvsp[0].t));}
#line 2757 "rttgram.tab.c"
    break;

  case 42: /* cast_expr: '(' type_name ')' cast_expr  */
#line 181 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-3].t), (yyvsp[-2].n), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 2763 "rttgram.tab.c"
    break;

  case 44: /* multiplicative_expr: multiplicative_expr '*' cast_expr  */
#line 186 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2769 "rttgram.tab.c"
    break;

  case 45: /* multiplicative_expr: multiplicative_expr '/' cast_expr  */
#line 187 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2775 "rttgram.tab.c"
    break;

  case 46: /* multiplicative_expr: multiplicative_expr '%' cast_expr  */
#line 188 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2781 "rttgram.tab.c"
    break;

  case 48: /* additive_expr: additive_expr '+' multiplicative_expr  */
#line 193 "rttgram.y"
                                           {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2787 "rttgram.tab.c"
    break;

  case 49: /* additive_expr: additive_expr '-' multiplicative_expr  */
#line 194 "rttgram.y"
                                           {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2793 "rttgram.tab.c"
    break;

  case 51: /* shift_expr: shift_expr LShft additive_expr  */
#line 199 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2799 "rttgram.tab.c"
    break;

  case 52: /* shift_expr: shift_expr RShft additive_expr  */
#line 200 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2805 "rttgram.tab.c"
    break;

  case 54: /* relational_expr: relational_expr '<' shift_expr  */
#line 205 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2811 "rttgram.tab.c"
    break;

  case 55: /* relational_expr: relational_expr '>' shift_expr  */
#line 206 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2817 "rttgram.tab.c"
    break;

  case 56: /* relational_expr: relational_expr Leq shift_expr  */
#line 207 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2823 "rttgram.tab.c"
    break;

  case 57: /* relational_expr: relational_expr Geq shift_expr  */
#line 208 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2829 "rttgram.tab.c"
    break;

  case 59: /* equality_expr: equality_expr Equal relational_expr  */
#line 213 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2835 "rttgram.tab.c"
    break;

  case 60: /* equality_expr: equality_expr Neq relational_expr  */
#line 214 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2841 "rttgram.tab.c"
    break;

  case 62: /* and_expr: and_expr '&' equality_expr  */
#line 219 "rttgram.y"
                                {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2847 "rttgram.tab.c"
    break;

  case 64: /* exclusive_or_expr: exclusive_or_expr '^' and_expr  */
#line 224 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2853 "rttgram.tab.c"
    break;

  case 66: /* inclusive_or_expr: inclusive_or_expr '|' exclusive_or_expr  */
#line 229 "rttgram.y"
                                             {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2859 "rttgram.tab.c"
    break;

  case 68: /* logical_and_expr: logical_and_expr And inclusive_or_expr  */
#line 234 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2865 "rttgram.tab.c"
    break;

  case 70: /* logical_or_expr: logical_or_expr Or logical_and_expr  */
#line 239 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2871 "rttgram.tab.c"
    break;

  case 72: /* conditional_expr: logical_or_expr '?' expr ':' conditional_expr  */
#line 245 "rttgram.y"
                                         {(yyval.n) = node3(TrnryNd, (yyvsp[-3].t), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n));
                                          free_t((yyvsp[-1].t));}
#line 2878 "rttgram.tab.c"
    break;

  case 74: /* assign_expr: unary_expr assign_op assign_expr  */
#line 251 "rttgram.y"
                                      {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2884 "rttgram.tab.c"
    break;

  case 87: /* expr: expr ',' assign_expr  */
#line 270 "rttgram.y"
                          {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2890 "rttgram.tab.c"
    break;

  case 88: /* opt_expr: %empty  */
#line 274 "rttgram.y"
     {(yyval.n) = NULL;}
#line 2896 "rttgram.tab.c"
    break;

  case 91: /* opt_constant_expr: %empty  */
#line 283 "rttgram.y"
     {(yyval.n) = NULL;}
#line 2902 "rttgram.tab.c"
    break;

  case 93: /* dcltion: typ_dcltion_specs ';'  */
#line 288 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-1].n), NULL);
                                             dcl_stk->kind_dcl = OtherDcl;}
#line 2909 "rttgram.tab.c"
    break;

  case 94: /* dcltion: typ_dcltion_specs init_dcltor_lst ';'  */
#line 290 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));
                                             dcl_stk->kind_dcl = OtherDcl;}
#line 2916 "rttgram.tab.c"
    break;

  case 95: /* dcltion: storcl_tqual_lst no_tdn_init_dcltor_lst ';'  */
#line 293 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));
                                             dcl_stk->kind_dcl = OtherDcl;}
#line 2923 "rttgram.tab.c"
    break;

  case 97: /* typ_dcltion_specs: storcl_tqual_lst type_ind  */
#line 299 "rttgram.y"
                               {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2929 "rttgram.tab.c"
    break;

  case 100: /* type_ind: typedefname  */
#line 308 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2935 "rttgram.tab.c"
    break;

  case 101: /* type_ind: typedefname storcl_tqual_lst  */
#line 310 "rttgram.y"
                             {(yyval.n) = node2(LstNd, NULL, node0(PrimryNd, (yyvsp[-1].t)), (yyvsp[0].n));}
#line 2941 "rttgram.tab.c"
    break;

  case 104: /* type_storcl_tqual_lst: type_storcl_tqual_lst stnd_type  */
#line 316 "rttgram.y"
                                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2947 "rttgram.tab.c"
    break;

  case 105: /* type_storcl_tqual_lst: type_storcl_tqual_lst storage_class_spec  */
#line 317 "rttgram.y"
                                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2953 "rttgram.tab.c"
    break;

  case 106: /* type_storcl_tqual_lst: type_storcl_tqual_lst type_qual  */
#line 318 "rttgram.y"
                                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2959 "rttgram.tab.c"
    break;

  case 109: /* storcl_tqual_lst: storcl_tqual_lst storage_class_spec  */
#line 324 "rttgram.y"
                                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2965 "rttgram.tab.c"
    break;

  case 110: /* storcl_tqual_lst: storcl_tqual_lst type_qual  */
#line 325 "rttgram.y"
                                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2971 "rttgram.tab.c"
    break;

  case 112: /* init_dcltor_lst: init_dcltor_lst ',' init_dcltor  */
#line 330 "rttgram.y"
                                     {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2977 "rttgram.tab.c"
    break;

  case 114: /* no_tdn_init_dcltor_lst: no_tdn_init_dcltor_lst ',' no_tdn_init_dcltor  */
#line 336 "rttgram.y"
                                              {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2983 "rttgram.tab.c"
    break;

  case 115: /* init_dcltor: dcltor  */
#line 340 "rttgram.y"
                            {(yyval.n) = (yyvsp[0].n); id_def((yyvsp[0].n), NULL);}
#line 2989 "rttgram.tab.c"
    break;

  case 116: /* init_dcltor: dcltor '=' initializer  */
#line 341 "rttgram.y"
                            {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n)); id_def((yyvsp[-2].n), (yyvsp[0].n));}
#line 2995 "rttgram.tab.c"
    break;

  case 117: /* no_tdn_init_dcltor: no_tdn_dcltor  */
#line 345 "rttgram.y"
                              {(yyval.n) = (yyvsp[0].n); id_def((yyvsp[0].n), NULL);}
#line 3001 "rttgram.tab.c"
    break;

  case 118: /* no_tdn_init_dcltor: no_tdn_dcltor '=' initializer  */
#line 347 "rttgram.y"
                              {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n)); id_def((yyvsp[-2].n), (yyvsp[0].n));}
#line 3007 "rttgram.tab.c"
    break;

  case 119: /* storage_class_spec: Typedef  */
#line 357 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t)); dcl_stk->kind_dcl = IsTypedef;}
#line 3013 "rttgram.tab.c"
    break;

  case 120: /* storage_class_spec: Extern  */
#line 358 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3019 "rttgram.tab.c"
    break;

  case 121: /* storage_class_spec: Static  */
#line 359 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3025 "rttgram.tab.c"
    break;

  case 122: /* storage_class_spec: Thread_local  */
#line 360 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3031 "rttgram.tab.c"
    break;

  case 123: /* storage_class_spec: Auto  */
#line 361 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3037 "rttgram.tab.c"
    break;

  case 124: /* storage_class_spec: Register  */
#line 362 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3043 "rttgram.tab.c"
    break;

  case 125: /* storage_class_spec: Inline  */
#line 367 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3049 "rttgram.tab.c"
    break;

  case 126: /* storage_class_spec: Declspec '(' identifier ')'  */
#line 368 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[0].t),
                                             node0(PrimryNd, (yyvsp[-3].t)),
                                             node0(PrimryNd, (yyvsp[-1].t)));
                                  free_t((yyvsp[-2].t));}
#line 3058 "rttgram.tab.c"
    break;

  case 128: /* type_spec: typedefname  */
#line 376 "rttgram.y"
                 {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3064 "rttgram.tab.c"
    break;

  case 129: /* stnd_type: Void  */
#line 380 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3070 "rttgram.tab.c"
    break;

  case 130: /* stnd_type: Char  */
#line 381 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3076 "rttgram.tab.c"
    break;

  case 131: /* stnd_type: Short  */
#line 382 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3082 "rttgram.tab.c"
    break;

  case 132: /* stnd_type: Int  */
#line 383 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3088 "rttgram.tab.c"
    break;

  case 133: /* stnd_type: Long  */
#line 384 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3094 "rttgram.tab.c"
    break;

  case 134: /* stnd_type: Float  */
#line 385 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3100 "rttgram.tab.c"
    break;

  case 135: /* stnd_type: Doubl  */
#line 386 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3106 "rttgram.tab.c"
    break;

  case 136: /* stnd_type: Signed  */
#line 387 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3112 "rttgram.tab.c"
    break;

  case 137: /* stnd_type: Unsigned  */
#line 388 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3118 "rttgram.tab.c"
    break;

  case 140: /* stnd_type: B_IProc_Type '(' constant_expr ')'  */
#line 391 "rttgram.y"
                                        {(yyval.n) = node2(BinryNd, (yyvsp[0].t),
                                                    node0(PrimryNd, (yyvsp[-3].t)), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t));}
#line 3126 "rttgram.tab.c"
    break;

  case 141: /* struct_or_union_spec: struct_or_union any_ident '{' struct_dcltion_lst '}'  */
#line 398 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                             free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3133 "rttgram.tab.c"
    break;

  case 142: /* struct_or_union_spec: struct_or_union '{' struct_dcltion_lst '}'  */
#line 401 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-3].t), NULL, (yyvsp[-1].n));
                                             free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3140 "rttgram.tab.c"
    break;

  case 143: /* struct_or_union_spec: struct_or_union any_ident  */
#line 403 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[0].n), NULL);}
#line 3146 "rttgram.tab.c"
    break;

  case 147: /* struct_dcltion_lst: struct_dcltion_lst struct_dcltion  */
#line 413 "rttgram.y"
                                       {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3152 "rttgram.tab.c"
    break;

  case 148: /* struct_dcltion: struct_dcltion_specs struct_dcltor_lst ';'  */
#line 418 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));}
#line 3158 "rttgram.tab.c"
    break;

  case 149: /* struct_dcltion: tqual_lst struct_no_tdn_dcltor_lst ';'  */
#line 419 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));}
#line 3164 "rttgram.tab.c"
    break;

  case 151: /* struct_dcltion_specs: tqual_lst struct_type_ind  */
#line 424 "rttgram.y"
                                {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3170 "rttgram.tab.c"
    break;

  case 152: /* struct_type_ind: typedefname  */
#line 428 "rttgram.y"
                            {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3176 "rttgram.tab.c"
    break;

  case 153: /* struct_type_ind: typedefname tqual_lst  */
#line 429 "rttgram.y"
                            {(yyval.n) = node2(LstNd, NULL, node0(PrimryNd, (yyvsp[-1].t)), (yyvsp[0].n));}
#line 3182 "rttgram.tab.c"
    break;

  case 156: /* struct_type_lst: struct_type_lst stnd_type  */
#line 435 "rttgram.y"
                               {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3188 "rttgram.tab.c"
    break;

  case 157: /* struct_type_lst: struct_type_lst type_qual  */
#line 436 "rttgram.y"
                               {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3194 "rttgram.tab.c"
    break;

  case 159: /* struct_dcltor_lst: struct_dcltor_lst ',' struct_dcltor  */
#line 440 "rttgram.y"
                                         {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3200 "rttgram.tab.c"
    break;

  case 160: /* struct_dcltor: dcltor  */
#line 444 "rttgram.y"
                              {(yyval.n) = node2(StrDclNd, NULL, (yyvsp[0].n), NULL);
                               if (dcl_stk->parms_done) pop_cntxt();}
#line 3207 "rttgram.tab.c"
    break;

  case 161: /* struct_dcltor: ':' constant_expr  */
#line 446 "rttgram.y"
                              {(yyval.n) = node2(StrDclNd, (yyvsp[-1].t), NULL, (yyvsp[0].n));}
#line 3213 "rttgram.tab.c"
    break;

  case 162: /* $@1: %empty  */
#line 447 "rttgram.y"
                {if (dcl_stk->parms_done) pop_cntxt();}
#line 3219 "rttgram.tab.c"
    break;

  case 163: /* struct_dcltor: dcltor ':' $@1 constant_expr  */
#line 448 "rttgram.y"
                              {(yyval.n) = node2(StrDclNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[0].n));}
#line 3225 "rttgram.tab.c"
    break;

  case 165: /* struct_no_tdn_dcltor_lst: struct_no_tdn_dcltor_lst ',' struct_no_tdn_dcltor  */
#line 454 "rttgram.y"
                                              {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3231 "rttgram.tab.c"
    break;

  case 166: /* struct_no_tdn_dcltor: no_tdn_dcltor  */
#line 458 "rttgram.y"
                                     {(yyval.n) = node2(StrDclNd, NULL, (yyvsp[0].n), NULL);
                                      if (dcl_stk->parms_done) pop_cntxt();}
#line 3238 "rttgram.tab.c"
    break;

  case 167: /* struct_no_tdn_dcltor: ':' constant_expr  */
#line 460 "rttgram.y"
                                     {(yyval.n) = node2(StrDclNd, (yyvsp[-1].t), NULL, (yyvsp[0].n));}
#line 3244 "rttgram.tab.c"
    break;

  case 168: /* $@2: %empty  */
#line 461 "rttgram.y"
                       {if (dcl_stk->parms_done) pop_cntxt();}
#line 3250 "rttgram.tab.c"
    break;

  case 169: /* struct_no_tdn_dcltor: no_tdn_dcltor ':' $@2 constant_expr  */
#line 462 "rttgram.y"
                                     {(yyval.n) = node2(StrDclNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[0].n));}
#line 3256 "rttgram.tab.c"
    break;

  case 170: /* $@3: %empty  */
#line 466 "rttgram.y"
          {push_cntxt(0);}
#line 3262 "rttgram.tab.c"
    break;

  case 171: /* enum_spec: Enum $@3 '{' enumerator_lst '}'  */
#line 467 "rttgram.y"
       {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), NULL, (yyvsp[-1].n)); pop_cntxt(); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3268 "rttgram.tab.c"
    break;

  case 172: /* $@4: %empty  */
#line 468 "rttgram.y"
                    {push_cntxt(0);}
#line 3274 "rttgram.tab.c"
    break;

  case 173: /* enum_spec: Enum any_ident $@4 '{' enumerator_lst '}'  */
#line 469 "rttgram.y"
       {(yyval.n) = node2(BinryNd, (yyvsp[-5].t), (yyvsp[-4].n),  (yyvsp[-1].n)); pop_cntxt(); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3280 "rttgram.tab.c"
    break;

  case 174: /* enum_spec: Enum any_ident  */
#line 470 "rttgram.y"
                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[0].n),  NULL);}
#line 3286 "rttgram.tab.c"
    break;

  case 176: /* enumerator_lst: enumerator_lst ',' enumerator  */
#line 475 "rttgram.y"
                                   {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3292 "rttgram.tab.c"
    break;

  case 177: /* enumerator: any_ident  */
#line 479 "rttgram.y"
                              {(yyval.n) = (yyvsp[0].n); id_def((yyvsp[0].n), NULL);}
#line 3298 "rttgram.tab.c"
    break;

  case 178: /* enumerator: any_ident '=' constant_expr  */
#line 481 "rttgram.y"
                              {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n)); id_def((yyvsp[-2].n), (yyvsp[0].n));}
#line 3304 "rttgram.tab.c"
    break;

  case 179: /* type_qual: Const  */
#line 485 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3310 "rttgram.tab.c"
    break;

  case 180: /* type_qual: Volatile  */
#line 486 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3316 "rttgram.tab.c"
    break;

  case 181: /* dcltor: opt_pointer direct_dcltor  */
#line 491 "rttgram.y"
                                {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3322 "rttgram.tab.c"
    break;

  case 182: /* no_tdn_dcltor: opt_pointer no_tdn_direct_dcltor  */
#line 495 "rttgram.y"
                                      {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3328 "rttgram.tab.c"
    break;

  case 184: /* direct_dcltor: '(' dcltor ')'  */
#line 500 "rttgram.y"
                                              {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3335 "rttgram.tab.c"
    break;

  case 185: /* direct_dcltor: direct_dcltor '[' opt_constant_expr ']'  */
#line 502 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3342 "rttgram.tab.c"
    break;

  case 186: /* $@5: %empty  */
#line 504 "rttgram.y"
                       {push_cntxt(1);}
#line 3348 "rttgram.tab.c"
    break;

  case 187: /* direct_dcltor: direct_dcltor '(' $@5 parm_dcls_or_ids ')'  */
#line 505 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                               if (dcl_stk->nest_lvl == 2)
                                                  dcl_stk->parms_done = 1;
                                                else
                                                  pop_cntxt();
                                               free_t((yyvsp[-3].t));}
#line 3359 "rttgram.tab.c"
    break;

  case 188: /* no_tdn_direct_dcltor: identifier  */
#line 514 "rttgram.y"
                                              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3365 "rttgram.tab.c"
    break;

  case 189: /* no_tdn_direct_dcltor: '(' no_tdn_dcltor ')'  */
#line 515 "rttgram.y"
                                              {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3372 "rttgram.tab.c"
    break;

  case 190: /* no_tdn_direct_dcltor: no_tdn_direct_dcltor '[' opt_constant_expr ']'  */
#line 518 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3379 "rttgram.tab.c"
    break;

  case 191: /* $@6: %empty  */
#line 520 "rttgram.y"
                              {push_cntxt(1);}
#line 3385 "rttgram.tab.c"
    break;

  case 192: /* no_tdn_direct_dcltor: no_tdn_direct_dcltor '(' $@6 parm_dcls_or_ids ')'  */
#line 521 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                               if (dcl_stk->nest_lvl == 2)
                                                  dcl_stk->parms_done = 1;
                                                else
                                                  pop_cntxt();
                                               free_t((yyvsp[-3].t));}
#line 3396 "rttgram.tab.c"
    break;

  case 195: /* pointer: '*'  */
#line 535 "rttgram.y"
                           {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3402 "rttgram.tab.c"
    break;

  case 196: /* pointer: '*' tqual_lst  */
#line 536 "rttgram.y"
                           {(yyval.n) = node1(PreSpcNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 3408 "rttgram.tab.c"
    break;

  case 197: /* pointer: '*' pointer  */
#line 537 "rttgram.y"
                           {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 3414 "rttgram.tab.c"
    break;

  case 198: /* pointer: '*' tqual_lst pointer  */
#line 538 "rttgram.y"
                           {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), node2(LstNd, NULL, (yyvsp[-1].n),(yyvsp[0].n)));}
#line 3420 "rttgram.tab.c"
    break;

  case 199: /* opt_pointer: %empty  */
#line 542 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3426 "rttgram.tab.c"
    break;

  case 202: /* tqual_lst: tqual_lst type_qual  */
#line 548 "rttgram.y"
                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3432 "rttgram.tab.c"
    break;

  case 204: /* param_type_lst: param_lst ',' Ellipsis  */
#line 553 "rttgram.y"
                            {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), node0(PrimryNd, (yyvsp[0].t)));}
#line 3438 "rttgram.tab.c"
    break;

  case 205: /* opt_param_type_lst: %empty  */
#line 557 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3444 "rttgram.tab.c"
    break;

  case 208: /* param_lst: param_lst ',' param_dcltion  */
#line 563 "rttgram.y"
                                 {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3450 "rttgram.tab.c"
    break;

  case 209: /* param_dcltion: dcltion_specs no_tdn_dcltor  */
#line 567 "rttgram.y"
                                   {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));
                                    id_def((yyvsp[0].n), NULL);}
#line 3457 "rttgram.tab.c"
    break;

  case 211: /* param_dcltion: dcltion_specs abstract_dcltor  */
#line 570 "rttgram.y"
                                   {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3463 "rttgram.tab.c"
    break;

  case 212: /* ident_lst: identifier  */
#line 574 "rttgram.y"
                              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3469 "rttgram.tab.c"
    break;

  case 213: /* ident_lst: ident_lst ',' identifier  */
#line 575 "rttgram.y"
                              {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), node0(PrimryNd,(yyvsp[0].t)));}
#line 3475 "rttgram.tab.c"
    break;

  case 216: /* type_tqual_lst: type_spec type_tqual_lst  */
#line 581 "rttgram.y"
                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3481 "rttgram.tab.c"
    break;

  case 217: /* type_tqual_lst: type_qual type_tqual_lst  */
#line 582 "rttgram.y"
                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3487 "rttgram.tab.c"
    break;

  case 219: /* type_name: type_tqual_lst abstract_dcltor  */
#line 587 "rttgram.y"
                                    {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3493 "rttgram.tab.c"
    break;

  case 221: /* abstract_dcltor: opt_pointer direct_abstract_dcltor  */
#line 592 "rttgram.y"
                                        {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3499 "rttgram.tab.c"
    break;

  case 222: /* direct_abstract_dcltor: '(' abstract_dcltor ')'  */
#line 596 "rttgram.y"
                                            {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n));
                                             free_t((yyvsp[0].t));}
#line 3506 "rttgram.tab.c"
    break;

  case 223: /* direct_abstract_dcltor: '[' opt_constant_expr ']'  */
#line 599 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), NULL, (yyvsp[-1].n));
                                             free_t((yyvsp[0].t));}
#line 3513 "rttgram.tab.c"
    break;

  case 224: /* direct_abstract_dcltor: direct_abstract_dcltor '[' opt_constant_expr ']'  */
#line 602 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                             free_t((yyvsp[0].t));}
#line 3520 "rttgram.tab.c"
    break;

  case 225: /* $@7: %empty  */
#line 604 "rttgram.y"
                                {push_cntxt(1);}
#line 3526 "rttgram.tab.c"
    break;

  case 226: /* direct_abstract_dcltor: '(' $@7 opt_param_type_lst ')'  */
#line 605 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), NULL, (yyvsp[-1].n));
                                             pop_cntxt();
                                             free_t((yyvsp[-3].t));}
#line 3534 "rttgram.tab.c"
    break;

  case 227: /* $@8: %empty  */
#line 608 "rttgram.y"
                                {push_cntxt(1);}
#line 3540 "rttgram.tab.c"
    break;

  case 228: /* direct_abstract_dcltor: direct_abstract_dcltor '(' $@8 opt_param_type_lst ')'  */
#line 609 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                             pop_cntxt();
                                             free_t((yyvsp[-3].t));}
#line 3548 "rttgram.tab.c"
    break;

  case 230: /* initializer: '{' '}'  */
#line 616 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), NULL); free_t((yyvsp[0].t));}
#line 3554 "rttgram.tab.c"
    break;

  case 231: /* initializer: '{' initializer_lst '}'  */
#line 618 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3560 "rttgram.tab.c"
    break;

  case 232: /* initializer: '{' initializer_lst ',' '}'  */
#line 620 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), NULL));
                          free_t((yyvsp[0].t));}
#line 3567 "rttgram.tab.c"
    break;

  case 234: /* initializer_lst: initializer_lst ',' initializer  */
#line 626 "rttgram.y"
                                     {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3573 "rttgram.tab.c"
    break;

  case 237: /* $@9: %empty  */
#line 635 "rttgram.y"
     {push_cntxt(1);}
#line 3579 "rttgram.tab.c"
    break;

  case 238: /* non_lbl_stmt: $@9 compound_stmt  */
#line 635 "rttgram.y"
                                    {(yyval.n) = (yyvsp[0].n); pop_cntxt();}
#line 3585 "rttgram.tab.c"
    break;

  case 243: /* non_lbl_stmt: Runerr '(' assign_expr ')' ';'  */
#line 641 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-2].n), NULL); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3591 "rttgram.tab.c"
    break;

  case 244: /* non_lbl_stmt: Runerr '(' assign_expr ',' assign_expr ')' ';'  */
#line 643 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-6].t), (yyvsp[-4].n), (yyvsp[-2].n)); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3597 "rttgram.tab.c"
    break;

  case 245: /* non_lbl_stmt: HostDir  */
#line 644 "rttgram.y"
               {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3603 "rttgram.tab.c"
    break;

  case 246: /* labeled_stmt: label ':' stmt  */
#line 648 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3609 "rttgram.tab.c"
    break;

  case 247: /* labeled_stmt: Case constant_expr ':' stmt  */
#line 649 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-3].t), (yyvsp[-2].n), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 3615 "rttgram.tab.c"
    break;

  case 248: /* labeled_stmt: Default ':' stmt  */
#line 650 "rttgram.y"
                                 {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 3621 "rttgram.tab.c"
    break;

  case 249: /* compound_stmt: '{' opt_stmt_lst '}'  */
#line 654 "rttgram.y"
                                     {(yyval.n) = comp_nd((yyvsp[-2].t), NULL, (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3627 "rttgram.tab.c"
    break;

  case 250: /* compound_stmt: '{' local_dcls opt_stmt_lst '}'  */
#line 655 "rttgram.y"
                                     {(yyval.n) = comp_nd((yyvsp[-3].t), (yyvsp[-2].n),   (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3633 "rttgram.tab.c"
    break;

  case 252: /* dcltion_lst: dcltion_lst dcltion  */
#line 660 "rttgram.y"
                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3639 "rttgram.tab.c"
    break;

  case 253: /* opt_dcltion_lst: %empty  */
#line 664 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3645 "rttgram.tab.c"
    break;

  case 256: /* local_dcls: local_dcls local_dcl  */
#line 670 "rttgram.y"
                          {(yyval.n) = ((yyvsp[0].n) == NULL ? (yyvsp[-1].n) : node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n)));}
#line 3651 "rttgram.tab.c"
    break;

  case 258: /* local_dcl: Tended tended_type init_dcltor_lst ';'  */
#line 676 "rttgram.y"
             {(yyval.n) = NULL; free_t((yyvsp[-3].t)); free_t((yyvsp[0].t)); dcl_stk->kind_dcl = OtherDcl;}
#line 3657 "rttgram.tab.c"
    break;

  case 259: /* tended_type: Char  */
#line 680 "rttgram.y"
                        {tnd_char(); free_t((yyvsp[0].t));}
#line 3663 "rttgram.tab.c"
    break;

  case 260: /* tended_type: Struct identifier  */
#line 681 "rttgram.y"
                        {tnd_strct((yyvsp[0].t)); free_t((yyvsp[-1].t));}
#line 3669 "rttgram.tab.c"
    break;

  case 261: /* tended_type: Struct TypeDefName  */
#line 682 "rttgram.y"
                        {tnd_strct((yyvsp[0].t)); free_t((yyvsp[-1].t));}
#line 3675 "rttgram.tab.c"
    break;

  case 262: /* tended_type: Union identifier  */
#line 683 "rttgram.y"
                        {tnd_union((yyvsp[0].t)); free_t((yyvsp[-1].t));}
#line 3681 "rttgram.tab.c"
    break;

  case 264: /* stmt_lst: stmt_lst stmt  */
#line 688 "rttgram.y"
                   {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3687 "rttgram.tab.c"
    break;

  case 265: /* stmt_lst: stmt_lst local_dcl  */
#line 689 "rttgram.y"
                        {(yyval.n) = ((yyvsp[0].n) == NULL ? (yyvsp[-1].n) : node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n)));}
#line 3693 "rttgram.tab.c"
    break;

  case 266: /* opt_stmt_lst: %empty  */
#line 693 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3699 "rttgram.tab.c"
    break;

  case 268: /* expr_stmt: opt_expr ';'  */
#line 697 "rttgram.y"
                  {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-1].n));}
#line 3705 "rttgram.tab.c"
    break;

  case 269: /* selection_stmt: If '(' expr ')' stmt  */
#line 701 "rttgram.y"
                                         {(yyval.n) = node3(TrnryNd, (yyvsp[-4].t), (yyvsp[-2].n), (yyvsp[0].n),NULL);
                                          free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3712 "rttgram.tab.c"
    break;

  case 270: /* selection_stmt: If '(' expr ')' stmt Else stmt  */
#line 703 "rttgram.y"
                                         {(yyval.n) = node3(TrnryNd, (yyvsp[-6].t), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n));
                                          free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3719 "rttgram.tab.c"
    break;

  case 271: /* selection_stmt: Switch '(' expr ')' stmt  */
#line 705 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-2].n), (yyvsp[0].n));
                                          free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3726 "rttgram.tab.c"
    break;

  case 272: /* selection_stmt: Type_case expr Of '{' c_type_select_lst c_opt_default '}'  */
#line 708 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-6].t), (yyvsp[-5].n), (yyvsp[-2].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[0].t));}
#line 3732 "rttgram.tab.c"
    break;

  case 273: /* c_type_select_lst: c_type_select  */
#line 712 "rttgram.y"
                                     {(yyval.n) = node2(ConCatNd, NULL, NULL, (yyvsp[0].n));}
#line 3738 "rttgram.tab.c"
    break;

  case 274: /* c_type_select_lst: c_type_select_lst c_type_select  */
#line 713 "rttgram.y"
                                     {(yyval.n) = node2(ConCatNd, NULL,   (yyvsp[-1].n), (yyvsp[0].n));}
#line 3744 "rttgram.tab.c"
    break;

  case 275: /* c_type_select: selector_lst non_lbl_stmt  */
#line 717 "rttgram.y"
                               {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3750 "rttgram.tab.c"
    break;

  case 276: /* c_opt_default: %empty  */
#line 721 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3756 "rttgram.tab.c"
    break;

  case 277: /* c_opt_default: Default ':' non_lbl_stmt  */
#line 722 "rttgram.y"
                              {(yyval.n) = (yyvsp[0].n); free_t((yyvsp[-2].t)); free_t((yyvsp[-1].t));}
#line 3762 "rttgram.tab.c"
    break;

  case 278: /* iteration_stmt: While '(' expr ')' stmt  */
#line 726 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-2].n), (yyvsp[0].n));
                                        free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3769 "rttgram.tab.c"
    break;

  case 279: /* iteration_stmt: Do stmt While '(' expr ')' ';'  */
#line 728 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-6].t), (yyvsp[-5].n), (yyvsp[-2].n));
                                        free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));
                                        free_t((yyvsp[0].t));}
#line 3777 "rttgram.tab.c"
    break;

  case 280: /* iteration_stmt: For '(' opt_expr ';' opt_expr ';' opt_expr ')' stmt  */
#line 732 "rttgram.y"
                                       {(yyval.n) = node4(QuadNd, (yyvsp[-8].t), (yyvsp[-6].n), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n));
                                        free_t((yyvsp[-7].t)); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t));
                                        free_t((yyvsp[-1].t));}
#line 3785 "rttgram.tab.c"
    break;

  case 281: /* jump_stmt: Goto label ';'  */
#line 738 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3791 "rttgram.tab.c"
    break;

  case 282: /* jump_stmt: Continue ';'  */
#line 739 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3797 "rttgram.tab.c"
    break;

  case 283: /* jump_stmt: Break ';'  */
#line 740 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3803 "rttgram.tab.c"
    break;

  case 284: /* jump_stmt: Return ret_val ';'  */
#line 741 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3809 "rttgram.tab.c"
    break;

  case 285: /* jump_stmt: Suspend ret_val ';'  */
#line 742 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3815 "rttgram.tab.c"
    break;

  case 286: /* jump_stmt: Fail ';'  */
#line 743 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3821 "rttgram.tab.c"
    break;

  case 287: /* jump_stmt: Errorfail ';'  */
#line 744 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3827 "rttgram.tab.c"
    break;

  case 293: /* external_dcltion: dcltion  */
#line 759 "rttgram.y"
                            {dclout((yyvsp[0].n));}
#line 3833 "rttgram.tab.c"
    break;

  case 295: /* external_dcltion: HostDir  */
#line 761 "rttgram.y"
                            {hostdir((yyvsp[0].t));}
#line 3839 "rttgram.tab.c"
    break;

  case 296: /* $@10: %empty  */
#line 765 "rttgram.y"
               {func_def((yyvsp[0].n));}
#line 3845 "rttgram.tab.c"
    break;

  case 297: /* function_definition: func_head $@10 opt_dcltion_lst compound_stmt  */
#line 766 "rttgram.y"
                                                          {fncout((yyvsp[-3].n), (yyvsp[-1].n), (yyvsp[0].n));}
#line 3851 "rttgram.tab.c"
    break;

  case 298: /* func_head: no_tdn_dcltor  */
#line 770 "rttgram.y"
                                     {(yyval.n) = node2(LstNd, NULL, NULL, (yyvsp[0].n));}
#line 3857 "rttgram.tab.c"
    break;

  case 299: /* func_head: storcl_tqual_lst no_tdn_dcltor  */
#line 771 "rttgram.y"
                                     {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3863 "rttgram.tab.c"
    break;

  case 300: /* func_head: typ_dcltion_specs dcltor  */
#line 772 "rttgram.y"
                                     {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3869 "rttgram.tab.c"
    break;

  case 301: /* any_ident: identifier  */
#line 776 "rttgram.y"
                 {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3875 "rttgram.tab.c"
    break;

  case 302: /* any_ident: typedefname  */
#line 777 "rttgram.y"
                 {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3881 "rttgram.tab.c"
    break;

  case 303: /* label: identifier  */
#line 781 "rttgram.y"
                 {(yyval.n) = lbl((yyvsp[0].t));}
#line 3887 "rttgram.tab.c"
    break;

  case 304: /* label: typedefname  */
#line 782 "rttgram.y"
                 {(yyval.n) = lbl((yyvsp[0].t));}
#line 3893 "rttgram.tab.c"
    break;

  case 309: /* $@11: %empty  */
#line 797 "rttgram.y"
     {strt_def();}
#line 3899 "rttgram.tab.c"
    break;

  case 311: /* operation: fnc_oper op_declare actions End  */
#line 801 "rttgram.y"
                                     {defout((yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3905 "rttgram.tab.c"
    break;

  case 312: /* operation: keyword actions End  */
#line 802 "rttgram.y"
                                     {defout((yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3911 "rttgram.tab.c"
    break;

  case 313: /* operation: keyword Constant key_const End  */
#line 803 "rttgram.y"
                                     {keyconst((yyvsp[-1].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3917 "rttgram.tab.c"
    break;

  case 314: /* description: %empty  */
#line 807 "rttgram.y"
             {comment = NULL;}
#line 3923 "rttgram.tab.c"
    break;

  case 315: /* description: StrLit  */
#line 808 "rttgram.y"
             {comment = (yyvsp[0].t);}
#line 3929 "rttgram.tab.c"
    break;

  case 316: /* fnc_oper: Function '{' result_seq '}' op_name '(' opt_s_parm_lst ')'  */
#line 813 "rttgram.y"
      {impl_fnc((yyvsp[-3].t)); free_t((yyvsp[-7].t)); free_t((yyvsp[-6].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 3936 "rttgram.tab.c"
    break;

  case 317: /* $@12: %empty  */
#line 815 "rttgram.y"
                             {lex_state = OpHead;}
#line 3942 "rttgram.tab.c"
    break;

  case 318: /* $@13: %empty  */
#line 816 "rttgram.y"
      {lex_state = DfltLex;}
#line 3948 "rttgram.tab.c"
    break;

  case 319: /* fnc_oper: Operator '{' result_seq $@12 '}' OpSym $@13 op_name '(' opt_s_parm_lst ')'  */
#line 817 "rttgram.y"
      {impl_op((yyvsp[-5].t), (yyvsp[-3].t)); free_t((yyvsp[-10].t)); free_t((yyvsp[-9].t)); free_t((yyvsp[-6].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 3955 "rttgram.tab.c"
    break;

  case 320: /* keyword: Keyword '{' result_seq '}' op_name  */
#line 822 "rttgram.y"
       {impl_key((yyvsp[0].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3961 "rttgram.tab.c"
    break;

  case 394: /* result_seq: %empty  */
#line 914 "rttgram.y"
                                {set_r_seq(NoRsltSeq, NoRsltSeq, 0);}
#line 3967 "rttgram.tab.c"
    break;

  case 395: /* result_seq: length opt_plus  */
#line 915 "rttgram.y"
                                {set_r_seq((yyvsp[-1].i), (yyvsp[-1].i), (int)(yyvsp[0].i));}
#line 3973 "rttgram.tab.c"
    break;

  case 396: /* result_seq: length ',' length opt_plus  */
#line 916 "rttgram.y"
                                {set_r_seq((yyvsp[-3].i), (yyvsp[-1].i), (int)(yyvsp[0].i)); free_t((yyvsp[-2].t));}
#line 3979 "rttgram.tab.c"
    break;

  case 397: /* length: IntConst  */
#line 920 "rttgram.y"
              {(yyval.i) = ttol((yyvsp[0].t)); free_t((yyvsp[0].t));}
#line 3985 "rttgram.tab.c"
    break;

  case 398: /* length: '*'  */
#line 921 "rttgram.y"
              {(yyval.i) = UnbndSeq; free_t((yyvsp[0].t));}
#line 3991 "rttgram.tab.c"
    break;

  case 399: /* opt_plus: %empty  */
#line 925 "rttgram.y"
         {(yyval.i) = 0;}
#line 3997 "rttgram.tab.c"
    break;

  case 400: /* opt_plus: '+'  */
#line 926 "rttgram.y"
         {(yyval.i) = 1; free_t((yyvsp[0].t));}
#line 4003 "rttgram.tab.c"
    break;

  case 403: /* opt_s_parm_lst: s_parm_lst '[' identifier ']'  */
#line 932 "rttgram.y"
                                   {var_args((yyvsp[-1].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4009 "rttgram.tab.c"
    break;

  case 405: /* s_parm_lst: s_parm_lst ',' s_parm  */
#line 937 "rttgram.y"
                           {free_t((yyvsp[-1].t));}
#line 4015 "rttgram.tab.c"
    break;

  case 406: /* s_parm: identifier  */
#line 941 "rttgram.y"
                                         {s_prm_def(NULL, (yyvsp[0].t));}
#line 4021 "rttgram.tab.c"
    break;

  case 407: /* s_parm: Underef identifier  */
#line 942 "rttgram.y"
                                         {s_prm_def((yyvsp[0].t), NULL); free_t((yyvsp[-1].t));}
#line 4027 "rttgram.tab.c"
    break;

  case 408: /* s_parm: Underef identifier Arrow identifier  */
#line 943 "rttgram.y"
                                         {s_prm_def((yyvsp[-2].t), (yyvsp[0].t));   free_t((yyvsp[-3].t));
                                          free_t((yyvsp[-1].t));}
#line 4034 "rttgram.tab.c"
    break;

  case 409: /* op_declare: %empty  */
#line 948 "rttgram.y"
     {}
#line 4040 "rttgram.tab.c"
    break;

  case 410: /* op_declare: Declare '{' local_dcls '}'  */
#line 949 "rttgram.y"
                                {d_lst_typ((yyvsp[-1].n)); free_t((yyvsp[-3].t)); free_t((yyvsp[-2].t));
                                 free_t((yyvsp[0].t));}
#line 4047 "rttgram.tab.c"
    break;

  case 411: /* opt_actions: %empty  */
#line 954 "rttgram.y"
     {(yyval.n) = NULL;}
#line 4053 "rttgram.tab.c"
    break;

  case 414: /* actions: actions action  */
#line 960 "rttgram.y"
                    {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4059 "rttgram.tab.c"
    break;

  case 418: /* action: '{' opt_actions '}'  */
#line 967 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 4065 "rttgram.tab.c"
    break;

  case 419: /* $@14: %empty  */
#line 968 "rttgram.y"
              {lex_state = TypeComp;}
#line 4071 "rttgram.tab.c"
    break;

  case 420: /* $@15: %empty  */
#line 969 "rttgram.y"
         {lex_state = DfltLex;}
#line 4077 "rttgram.tab.c"
    break;

  case 421: /* action: Abstract $@14 '{' type_computations $@15 '}'  */
#line 970 "rttgram.y"
         {(yyval.n) = (yyvsp[-2].n); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[0].t));}
#line 4083 "rttgram.tab.c"
    break;

  case 422: /* checking_conversions: If type_check Then action  */
#line 975 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-3].t), (yyvsp[-2].n), (yyvsp[0].n), NULL); free_t((yyvsp[-1].t));}
#line 4089 "rttgram.tab.c"
    break;

  case 423: /* checking_conversions: If type_check Then action Else action  */
#line 977 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-5].t), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4095 "rttgram.tab.c"
    break;

  case 424: /* checking_conversions: Type_case variable Of '{' type_select_lst opt_default '}'  */
#line 979 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-6].t), (yyvsp[-5].n), (yyvsp[-2].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[0].t));}
#line 4101 "rttgram.tab.c"
    break;

  case 425: /* checking_conversions: Len_case identifier Of '{' len_select_lst Default ':' action '}'  */
#line 981 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-8].t), sym_node((yyvsp[-7].t)), (yyvsp[-4].n), (yyvsp[-1].n)); free_t((yyvsp[-6].t)), free_t((yyvsp[-5].t));
       free_t((yyvsp[-3].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4108 "rttgram.tab.c"
    break;

  case 426: /* checking_conversions: Arith_case '(' variable ',' variable ')' Of '{' dest_type ':' action dest_type ':' action dest_type ':' action '}'  */
#line 985 "rttgram.y"
      {(yyval.n) = arith_nd((yyvsp[-17].t), (yyvsp[-15].n), (yyvsp[-13].n), (yyvsp[-9].n), (yyvsp[-7].n), (yyvsp[-6].n), (yyvsp[-4].n), (yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-16].t));
       free_t((yyvsp[-14].t)), free_t((yyvsp[-12].t)); free_t((yyvsp[-11].t)); free_t((yyvsp[-10].t)); free_t((yyvsp[-8].t));
       free_t((yyvsp[-5].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4116 "rttgram.tab.c"
    break;

  case 427: /* type_select_lst: type_select  */
#line 991 "rttgram.y"
                                 {(yyval.n) = node2(ConCatNd, NULL, NULL, (yyvsp[0].n));}
#line 4122 "rttgram.tab.c"
    break;

  case 428: /* type_select_lst: type_select_lst type_select  */
#line 992 "rttgram.y"
                                 {(yyval.n) = node2(ConCatNd, NULL,   (yyvsp[-1].n), (yyvsp[0].n));}
#line 4128 "rttgram.tab.c"
    break;

  case 429: /* type_select: selector_lst action  */
#line 996 "rttgram.y"
                         {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4134 "rttgram.tab.c"
    break;

  case 430: /* opt_default: %empty  */
#line 1000 "rttgram.y"
     {(yyval.n) = NULL;}
#line 4140 "rttgram.tab.c"
    break;

  case 431: /* opt_default: Default ':' action  */
#line 1001 "rttgram.y"
                        {(yyval.n) = (yyvsp[0].n); free_t((yyvsp[-2].t)); free_t((yyvsp[-1].t));}
#line 4146 "rttgram.tab.c"
    break;

  case 432: /* selector_lst: i_type_name ':'  */
#line 1005 "rttgram.y"
                                  {(yyval.n) = node2(ConCatNd, NULL, NULL, (yyvsp[-1].n));
                                   free_t((yyvsp[0].t));}
#line 4153 "rttgram.tab.c"
    break;

  case 433: /* selector_lst: selector_lst i_type_name ':'  */
#line 1007 "rttgram.y"
                                  {(yyval.n) = node2(ConCatNd, NULL,   (yyvsp[-2].n), (yyvsp[-1].n));
                                   free_t((yyvsp[0].t));}
#line 4160 "rttgram.tab.c"
    break;

  case 435: /* len_select_lst: len_select_lst len_select  */
#line 1013 "rttgram.y"
                               {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4166 "rttgram.tab.c"
    break;

  case 436: /* len_select: IntConst ':' action  */
#line 1017 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 4172 "rttgram.tab.c"
    break;

  case 438: /* type_check: '!' simple_check  */
#line 1022 "rttgram.y"
                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4178 "rttgram.tab.c"
    break;

  case 440: /* simple_check_conj: simple_check_conj And simple_check  */
#line 1027 "rttgram.y"
                                        {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4184 "rttgram.tab.c"
    break;

  case 441: /* simple_check: Is ':' i_type_name '(' variable ')'  */
#line 1032 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-5].t), (yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4190 "rttgram.tab.c"
    break;

  case 442: /* simple_check: Cnv ':' dest_type '(' variable ')'  */
#line 1034 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-5].t), (yyvsp[-3].n), (yyvsp[-1].n), NULL), dst_alloc((yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t));
       free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4197 "rttgram.tab.c"
    break;

  case 443: /* simple_check: Cnv ':' dest_type '(' variable ',' assign_expr ')'  */
#line 1037 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-7].t), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-6].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 4204 "rttgram.tab.c"
    break;

  case 444: /* simple_check: Def ':' dest_type '(' variable ',' assign_expr ')'  */
#line 1040 "rttgram.y"
      {(yyval.n) = node4(QuadNd, (yyvsp[-7].t), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n), NULL), dst_alloc((yyvsp[-5].n), (yyvsp[-3].n)); free_t((yyvsp[-6].t));
       free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4211 "rttgram.tab.c"
    break;

  case 445: /* simple_check: Def ':' dest_type '(' variable ',' assign_expr ',' assign_expr ')'  */
#line 1043 "rttgram.y"
      {(yyval.n) = node4(QuadNd, (yyvsp[-9].t), (yyvsp[-7].n), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-8].t)); free_t((yyvsp[-6].t));
       free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4218 "rttgram.tab.c"
    break;

  case 446: /* $@16: %empty  */
#line 1048 "rttgram.y"
            {push_cntxt(1);}
#line 4224 "rttgram.tab.c"
    break;

  case 447: /* detail_code: Body $@16 compound_stmt  */
#line 1049 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); pop_cntxt();}
#line 4230 "rttgram.tab.c"
    break;

  case 448: /* $@17: %empty  */
#line 1050 "rttgram.y"
            {push_cntxt(1);}
#line 4236 "rttgram.tab.c"
    break;

  case 449: /* detail_code: Inline $@17 compound_stmt  */
#line 1051 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); pop_cntxt();}
#line 4242 "rttgram.tab.c"
    break;

  case 450: /* runerr: Runerr '(' IntConst ')' opt_semi  */
#line 1056 "rttgram.y"
                    {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), node0(PrimryNd, (yyvsp[-2].t)), NULL);
                     free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4249 "rttgram.tab.c"
    break;

  case 451: /* runerr: Runerr '(' IntConst ',' variable ')' opt_semi  */
#line 1059 "rttgram.y"
                    {(yyval.n) = node2(BinryNd, (yyvsp[-6].t), node0(PrimryNd, (yyvsp[-4].t)), (yyvsp[-2].n));
                     free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4256 "rttgram.tab.c"
    break;

  case 453: /* opt_semi: ';'  */
#line 1065 "rttgram.y"
         {free_t((yyvsp[0].t));}
#line 4262 "rttgram.tab.c"
    break;

  case 454: /* variable: identifier  */
#line 1069 "rttgram.y"
                                 {(yyval.n) = sym_node((yyvsp[0].t));}
#line 4268 "rttgram.tab.c"
    break;

  case 455: /* variable: identifier '[' IntConst ']'  */
#line 1070 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), sym_node((yyvsp[-3].t)),
                                    node0(PrimryNd, (yyvsp[-1].t)));
                                  free_t((yyvsp[0].t));}
#line 4276 "rttgram.tab.c"
    break;

  case 456: /* dest_type: IconType  */
#line 1075 "rttgram.y"
                             {(yyval.n) = dest_node((yyvsp[0].t));}
#line 4282 "rttgram.tab.c"
    break;

  case 457: /* dest_type: C_Integer  */
#line 1076 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4288 "rttgram.tab.c"
    break;

  case 458: /* dest_type: C_Double  */
#line 1077 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4294 "rttgram.tab.c"
    break;

  case 459: /* dest_type: C_String  */
#line 1078 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4300 "rttgram.tab.c"
    break;

  case 460: /* dest_type: Tmp_string  */
#line 1079 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t)); ++n_tmp_str;}
#line 4306 "rttgram.tab.c"
    break;

  case 461: /* dest_type: Tmp_cset  */
#line 1080 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t)); ++n_tmp_cset;}
#line 4312 "rttgram.tab.c"
    break;

  case 462: /* dest_type: '(' Exact ')' IconType  */
#line 1081 "rttgram.y"
                             {(yyval.n) = node0(ExactCnv, chk_exct((yyvsp[0].t))); free_t((yyvsp[-3].t));
                              free_t((yyvsp[-2].t)); free_t((yyvsp[-1].t));}
#line 4319 "rttgram.tab.c"
    break;

  case 463: /* dest_type: '(' Exact ')' C_Integer  */
#line 1083 "rttgram.y"
                             {(yyval.n) = node0(ExactCnv, (yyvsp[0].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-2].t));
                              free_t((yyvsp[-1].t));}
#line 4326 "rttgram.tab.c"
    break;

  case 464: /* i_type_name: Any_value  */
#line 1088 "rttgram.y"
                {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4332 "rttgram.tab.c"
    break;

  case 465: /* i_type_name: Empty_type  */
#line 1089 "rttgram.y"
                {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4338 "rttgram.tab.c"
    break;

  case 466: /* i_type_name: IconType  */
#line 1090 "rttgram.y"
                {(yyval.n) = sym_node((yyvsp[0].t));}
#line 4344 "rttgram.tab.c"
    break;

  case 467: /* i_type_name: Variable  */
#line 1091 "rttgram.y"
                {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4350 "rttgram.tab.c"
    break;

  case 469: /* ret_val: C_Integer assign_expr  */
#line 1096 "rttgram.y"
                                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4356 "rttgram.tab.c"
    break;

  case 470: /* ret_val: C_Double assign_expr  */
#line 1097 "rttgram.y"
                                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4362 "rttgram.tab.c"
    break;

  case 471: /* ret_val: C_String assign_expr  */
#line 1098 "rttgram.y"
                                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4368 "rttgram.tab.c"
    break;

  case 472: /* type_computations: side_effect_lst Return type opt_semi  */
#line 1102 "rttgram.y"
                                          {(yyval.n) = node2(AbstrNd, (yyvsp[-2].t),   (yyvsp[-3].n),   (yyvsp[-1].n));}
#line 4374 "rttgram.tab.c"
    break;

  case 473: /* type_computations: Return type opt_semi  */
#line 1103 "rttgram.y"
                                          {(yyval.n) = node2(AbstrNd, (yyvsp[-2].t),   NULL, (yyvsp[-1].n));}
#line 4380 "rttgram.tab.c"
    break;

  case 474: /* type_computations: side_effect_lst  */
#line 1104 "rttgram.y"
                                          {(yyval.n) = node2(AbstrNd, NULL, (yyvsp[0].n), NULL);}
#line 4386 "rttgram.tab.c"
    break;

  case 476: /* side_effect_lst: side_effect_lst side_effect  */
#line 1109 "rttgram.y"
                                 {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4392 "rttgram.tab.c"
    break;

  case 477: /* side_effect: Store '[' type ']' '=' type opt_semi  */
#line 1113 "rttgram.y"
                                          {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                           free_t((yyvsp[-6].t)); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t));}
#line 4399 "rttgram.tab.c"
    break;

  case 479: /* type: type union basic_type  */
#line 1119 "rttgram.y"
                               {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4405 "rttgram.tab.c"
    break;

  case 480: /* type: type Intersect basic_type  */
#line 1120 "rttgram.y"
                               {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4411 "rttgram.tab.c"
    break;

  case 481: /* basic_type: i_type_name  */
#line 1123 "rttgram.y"
                                        {(yyval.n) = node1(IcnTypNd,
                                         copy_t((yyvsp[0].n)->tok), (yyvsp[0].n));}
#line 4418 "rttgram.tab.c"
    break;

  case 482: /* basic_type: Type '(' variable ')'  */
#line 1125 "rttgram.y"
                                        {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4425 "rttgram.tab.c"
    break;

  case 483: /* basic_type: New i_type_name '(' type_lst ')'  */
#line 1127 "rttgram.y"
                                        {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4432 "rttgram.tab.c"
    break;

  case 484: /* basic_type: Store '[' type ']'  */
#line 1129 "rttgram.y"
                                        {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4439 "rttgram.tab.c"
    break;

  case 485: /* basic_type: basic_type '.' attrb_name  */
#line 1131 "rttgram.y"
                                        {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-2].n));
                                         free_t((yyvsp[-1].t));}
#line 4446 "rttgram.tab.c"
    break;

  case 486: /* basic_type: '(' type ')'  */
#line 1133 "rttgram.y"
                                        {(yyval.n) = (yyvsp[-1].n); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4452 "rttgram.tab.c"
    break;

  case 489: /* type_lst: type_lst ',' type  */
#line 1142 "rttgram.y"
                       {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4458 "rttgram.tab.c"
    break;


#line 4462 "rttgram.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 1150 "rttgram.y"


/*
 * xfree(p) -- used with free(p) macro to avoid compiler errors from
 *  miscast free calls generated by Yacc.
 */
 /*
static void xfree(char *p)
{
   free(p);
}

#define free(p) xfree((char*)p)
 */
