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
#line 7 "rttgram.y"

#include "rtt1.h"
#include "yyerror.h"
#define YYMAXDEPTH 10000

#line 77 "rttparse.c"

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
  YYSYMBOL_Atomic = 142,                   /* Atomic  */
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
#define YYFINAL  106
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   3846

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  144
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  157
/* YYNRULES -- Number of rules.  */
#define YYNRULES  492
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  849

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
       0,   108,   108,   109,   110,   111,   112,   113,   114,   115,
     116,   117,   118,   119,   120,   124,   125,   127,   129,   131,
     132,   133,   134,   135,   137,   140,   146,   147,   151,   152,
     153,   154,   155,   156,   162,   169,   170,   171,   172,   173,
     174,   178,   179,   183,   184,   185,   186,   190,   191,   192,
     196,   197,   198,   202,   203,   204,   205,   206,   210,   211,
     212,   216,   217,   221,   222,   226,   227,   231,   232,   236,
     237,   241,   242,   248,   249,   253,   254,   255,   256,   257,
     258,   259,   260,   261,   262,   263,   267,   268,   272,   273,
     277,   281,   282,   286,   288,   290,   296,   297,   301,   302,
     306,   307,   309,   313,   314,   315,   316,   320,   321,   322,
     323,   327,   328,   332,   333,   338,   339,   343,   344,   355,
     356,   357,   358,   359,   360,   365,   366,   373,   374,   378,
     379,   380,   381,   382,   383,   384,   385,   386,   387,   390,
     391,   392,   398,   401,   404,   408,   409,   413,   414,   418,
     420,   424,   425,   429,   430,   431,   435,   436,   437,   440,
     441,   445,   447,   448,   448,   453,   454,   459,   461,   462,
     462,   467,   467,   469,   469,   471,   475,   476,   480,   481,
     486,   487,   488,   493,   497,   501,   502,   504,   506,   506,
     516,   517,   519,   522,   522,   532,   533,   537,   538,   539,
     540,   544,   545,   549,   550,   554,   555,   559,   560,   564,
     565,   569,   571,   572,   576,   577,   581,   582,   583,   584,
     588,   589,   593,   594,   598,   600,   603,   606,   606,   610,
     610,   617,   618,   619,   621,   627,   628,   632,   633,   637,
     637,   638,   639,   640,   641,   642,   644,   649,   650,   651,
     655,   656,   660,   661,   665,   666,   670,   671,   675,   676,
     681,   682,   683,   684,   688,   689,   690,   694,   695,   698,
     702,   704,   706,   708,   713,   714,   718,   722,   723,   727,
     729,   732,   739,   740,   741,   742,   743,   744,   745,   749,
     750,   754,   755,   759,   760,   761,   765,   765,   770,   771,
     772,   776,   777,   781,   782,   786,   787,   788,   789,   797,
     797,   801,   802,   803,   807,   808,   812,   815,   816,   815,
     821,   826,   827,   828,   829,   836,   837,   838,   839,   840,
     841,   842,   843,   844,   845,   846,   847,   848,   849,   850,
     851,   852,   853,   854,   855,   856,   857,   858,   859,   866,
     867,   868,   869,   870,   871,   872,   873,   874,   875,   876,
     877,   878,   879,   880,   881,   882,   883,   884,   885,   886,
     887,   888,   889,   890,   891,   892,   893,   894,   895,   896,
     897,   898,   899,   900,   901,   902,   903,   904,   905,   906,
     907,   908,   909,   910,   911,   915,   916,   917,   921,   922,
     926,   927,   931,   932,   933,   937,   938,   942,   943,   944,
     949,   950,   955,   956,   960,   961,   965,   966,   967,   968,
     969,   970,   969,   975,   977,   979,   981,   984,   992,   993,
     997,  1001,  1002,  1006,  1008,  1013,  1014,  1018,  1022,  1023,
    1027,  1028,  1032,  1034,  1037,  1040,  1043,  1049,  1049,  1051,
    1051,  1056,  1059,  1065,  1066,  1070,  1071,  1076,  1077,  1078,
    1079,  1080,  1081,  1082,  1084,  1089,  1090,  1091,  1092,  1096,
    1097,  1098,  1099,  1103,  1104,  1105,  1109,  1110,  1114,  1119,
    1120,  1121,  1124,  1126,  1128,  1130,  1132,  1134,  1138,  1142,
    1143,  1147,  1148
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
  "Offsetof", "Thread_local", "Atomic", "IfStmt", "$accept",
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

#define YYPACT_NINF (-666)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-469)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     774,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,
    -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,
    1814,   -19,  -666,  -666,  -666,  -666,    24,    86,  -666,    93,
    -666,    11,  -666,  1322,  3241,  -666,  -666,  -666,  1675,  -666,
    -666,  -666,  -666,   316,    60,   897,  -666,  -666,  -666,   194,
    -666,   304,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,
    -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,
    -666,  -666,  -666,  -666,  -666,  -666,    58,   257,  -666,  -666,
    -666,  -666,  -666,   -19,  2090,  2731,  3614,  -666,   124,  -666,
      94,   854,  -666,  -666,  -666,  -666,   132,  -666,  -666,  -666,
     123,  3614,   273,   178,   137,  -666,  -666,  -666,  3388,   194,
    -666,   250,  1814,   280,  -666,  -666,   258,  -666,  -666,  -666,
    -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  2870,  2870,
    3009,  -666,  1426,  -666,  -666,  -666,  -666,  -666,   317,   323,
     351,   376,  -666,   214,  -666,  2731,  -666,   251,    68,    57,
      80,   172,   381,   375,   385,   441,    21,  -666,   396,  -666,
    3614,  -666,  3614,   272,   397,  -666,   178,  -666,  2453,   178,
     164,  -666,   178,  -666,  2453,  -666,  3501,  -666,    17,  -666,
    1553,  3486,   -12,  3614,   398,  -666,  2731,  -666,    11,  3241,
    3388,   393,   400,   402,   403,  -666,   364,   649,   140,  -666,
     399,  1814,  -666,  2731,  -666,  -666,  1426,  -666,   694,  -666,
    -666,   184,   413,   234,   422,   422,  3614,  1814,  -666,  -666,
    2592,  1814,  2731,  -666,  2731,  2731,  2731,  2731,  2731,  2731,
    2731,  2731,  2731,  2731,  2731,  2731,  2731,  2731,  2731,  2731,
    2731,  2731,  2731,  -666,  -666,  -666,   206,   169,  -666,  -666,
    -666,   406,  2175,  -666,  -666,   414,  -666,  2731,  -666,   407,
    -666,  -666,  -666,  2731,   180,  -666,   401,  -666,  -666,  2731,
    -666,   183,  -666,   405,   -12,  3599,  -666,  1535,  -666,   416,
    -666,  1037,  -666,    44,    44,    44,   410,  2527,   229,  2527,
     426,   440,  -666,  -666,  -666,  2090,  2090,   287,   791,  -666,
    -666,  -666,  -666,  1814,  -666,  2731,   220,   442,  -666,  -666,
    -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  2731,
    -666,  2731,  2731,  -666,  -666,  -666,  -666,   448,   421,  -666,
    -666,  -666,  -666,  -666,  -666,   450,   453,   451,  -666,  -666,
     238,  -666,  -666,    -9,  -666,  -666,  -666,   251,   251,    68,
      68,    57,    57,    57,    57,    80,    80,   172,   381,   375,
     385,   441,   159,   203,  2731,   190,  -666,  -666,   228,  -666,
    1535,   444,  -666,    17,  -666,  -666,  -666,    42,  -666,  -666,
    -666,  3670,  3751,  -666,   288,  3388,   463,  -666,  -666,   461,
    -666,   462,  -666,  -666,   148,  2731,   439,   468,   469,   471,
    1619,   472,  1814,   457,   458,  2036,   475,  2036,   465,  2731,
     467,   482,   473,  -666,  -666,  -666,   393,  -666,  1037,  -666,
    1177,   478,  -666,  -666,  -666,  -666,   477,   717,   479,  -666,
    -666,   485,   131,   486,  -666,  3345,  2388,   360,   483,   487,
     488,   447,   548,  -666,   495,  2527,   570,  2090,   393,   393,
     499,   496,   452,   454,  -666,  -666,  -666,  -666,   466,  -666,
    -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  2731,   513,
    2731,  2731,  2090,  -666,  2731,  -666,  2731,   514,  3388,   504,
    -666,  2731,  2314,  -666,   518,  -666,  -666,  2731,  -666,  2731,
    -666,  3117,  -666,  -666,  3366,  2090,  -666,  1953,  2090,   178,
     506,  1619,  2731,  2731,  2731,   531,  -666,  2731,   508,  -666,
    -666,  -666,  2731,  2731,  2731,  -666,   511,  2731,   512,  -666,
     -14,  -666,  -666,  -666,  -666,   519,  -666,  -666,  -666,  1619,
    1286,  -666,    44,  -666,  1286,   522,  3220,  -666,  -666,   234,
     422,   422,  2527,   360,  -666,   281,   532,  -666,  -666,   -22,
     599,   529,   534,  -666,   542,   205,   540,   544,   549,  -666,
    -666,  -666,   550,  -666,  3388,   536,  -666,  -666,  -666,  -666,
    -666,  3067,  -666,  -666,  -666,  -666,  -666,  -666,   209,  1619,
    -666,   311,   313,   318,   553,   538,  -666,  -666,  -666,  -666,
    -666,   326,  -666,   552,  -666,  -666,  -666,  -666,  -666,  -666,
    -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,
    -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,
    -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,
    -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,  -666,
    -666,  -666,   561,   559,  -666,   600,  -666,   565,   567,   568,
     580,  -666,   554,  2090,  2090,   138,   560,  -666,   -15,  -666,
     558,   234,   637,  -666,  -666,  -666,  2731,  2731,  -666,  -666,
     574,  -666,  -666,  -666,  1619,  1619,  1619,  2731,  2731,   562,
    2731,   234,  2229,  -666,  -666,  2090,  2090,  2090,  2527,  -666,
    -666,   575,   576,   138,   573,   586,   234,  -666,    40,   582,
     138,   579,   138,  -666,  -666,    71,  -666,  1991,   578,   598,
      87,  -666,   613,   611,  -666,   627,  -666,  -666,   330,   601,
    -666,   617,   165,  -666,  1758,  2090,  -666,   618,    35,  -666,
    1286,   619,   332,   620,  -666,   554,   563,    66,   138,  2090,
     621,  -666,   138,  -666,   138,   -26,    46,  -666,    40,   608,
    -666,   616,  -666,   612,  -666,  2527,   614,  -666,  -666,  2731,
    1619,   615,  2731,   623,   626,  -666,   632,   628,   640,   641,
     643,  -666,   696,  -666,  2229,  2090,   659,  -666,  -666,  2731,
    2731,  -666,   652,  -666,    52,   660,   138,   582,   582,  -666,
    -666,  -666,   644,  -666,  2527,  -666,  -666,  -666,  2527,   662,
    -666,  -666,   663,  -666,  1897,  -666,  2090,  -666,   653,  2229,
     666,   361,   422,  -666,  -666,    50,   377,   138,  -666,   661,
    -666,  1619,  -666,  -666,  -666,   668,  -666,  -666,  2731,   655,
    -666,   138,    40,  -666,  -666,  -666,   671,  2527,    50,  -666,
    -666,   422,   672,  2527,   422,   673,  2527,   664,  -666
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int16 yydefact[] =
{
     201,   119,   120,   121,   123,   124,   130,   131,   132,   133,
     136,   137,   134,   135,   180,   181,   129,   305,   145,   146,
     171,   197,   306,   307,   308,   125,     0,     0,   122,   182,
     294,   201,    96,   102,   201,   107,   103,   139,     0,   140,
     108,   298,   202,     0,     0,   201,   291,   293,   296,   100,
     295,   314,   335,   333,   331,   334,   329,   348,   327,   338,
     342,   345,   344,   328,   332,   347,   330,   336,   325,   341,
     346,   339,   326,   343,   340,   337,     0,   175,   302,   301,
     182,   203,   199,   198,     0,     0,     0,    93,     0,   111,
     300,     0,   105,   104,   106,    97,     0,   113,   109,   110,
     299,     0,   144,   201,   184,   190,     1,   292,   254,   101,
     315,     0,     0,     0,   204,   200,     0,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,     0,     0,
       0,    35,     0,    36,    37,    38,    39,    40,     0,     0,
       0,     0,    15,    28,    41,     0,    43,    47,    50,    53,
      58,    61,    63,    65,    67,    69,    71,    90,     0,     2,
     216,   127,   217,   201,     0,   128,   201,    94,     0,   201,
     183,   185,   201,    95,     0,   156,     0,   147,   201,   151,
     155,   201,   153,     0,     0,   193,    91,   252,   201,   201,
     255,     0,     0,     0,     0,   310,   410,     0,     0,   176,
     178,     0,   126,     0,    29,    30,     0,    32,    41,    73,
      86,     0,     0,     0,     0,     0,     0,     0,    21,    22,
       0,     0,     0,    31,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   141,   218,   219,   202,     0,   221,   138,
     112,   115,     0,   231,   116,     0,   188,    91,   114,   117,
     118,   143,   148,     0,     0,   159,   161,   157,   158,     0,
     152,     0,   165,   167,   154,     0,   191,   207,    92,     0,
     253,    88,   297,   395,   395,   395,     0,     0,     0,   412,
       0,     0,   447,   449,   420,     0,     0,     0,     0,   414,
     416,   417,   418,     0,   172,     0,     0,     0,    76,    77,
      78,    79,    80,    81,    82,    83,    84,    85,    75,     0,
      14,     0,     0,   466,   467,   468,   465,     0,     0,   457,
     458,   459,   460,   461,   462,     0,     0,     0,    20,    17,
       0,    26,    19,     0,    46,    44,    45,    48,    49,    51,
      52,    56,    57,    54,    55,    59,    60,    62,    64,    66,
      68,    70,     0,   227,    91,   223,   232,   235,     0,   186,
     207,     0,   162,   201,   149,   163,   168,   201,   150,   169,
     142,   125,   122,    98,   201,    99,     0,   208,   195,   205,
     209,   196,   214,   192,     0,     0,     0,     0,     0,     0,
      88,     0,     0,     0,     0,    88,     0,    88,     0,     0,
       0,    89,     0,   258,   264,   238,     0,   237,    88,   256,
      88,     0,   241,   242,   243,   244,     0,   100,     2,   398,
     399,     0,   400,     0,   317,     0,     0,     0,     0,     0,
       0,     0,   438,   440,     0,   413,     0,     0,     0,     0,
       0,   455,     0,     0,   321,   323,   322,   324,     0,   312,
     415,   177,   179,   174,    33,    74,    87,    42,     0,     0,
       0,     0,     0,    18,     0,    16,     0,     0,   207,     0,
     229,    91,     0,   233,     0,   187,   160,     0,   166,     0,
     211,     0,   213,   194,     0,     0,   260,     0,     0,   201,
       0,    88,     0,     0,     0,     0,   304,    88,     0,   303,
     283,   284,     0,     0,     0,   469,     0,     0,     0,   287,
       0,   288,   269,   240,   257,     0,   265,   266,   250,    88,
       0,   401,     0,   396,     0,     0,     0,   311,   439,     0,
       0,     0,     0,     0,   419,     0,     0,   448,   450,     0,
       0,     0,     0,   313,     0,     0,     0,     0,     0,    27,
      72,   224,     0,   225,   207,     0,   234,   236,   189,   164,
     170,   227,   206,   210,   215,   262,   261,   263,     0,    88,
     249,     0,     0,     0,     0,     0,   282,   470,   471,   472,
     285,     0,   286,     0,   251,   247,   382,   389,   365,   384,
     351,   377,   388,   354,   380,   372,   375,   381,   391,   367,
     361,   356,   393,   392,   385,   390,   363,   353,   359,   371,
     362,   387,   394,   360,   368,   370,   357,   352,   378,   379,
     373,   355,   358,   369,   374,   376,   386,   366,   364,   383,
     350,   349,     0,   400,   320,     0,   411,     0,     0,     0,
     423,   441,   453,     0,     0,     0,     0,   421,   475,   476,
       0,     0,     0,    23,   463,   464,     0,     0,    34,   228,
       0,   226,   259,   248,    88,    88,    88,     0,    88,     0,
       0,     0,   402,   397,   318,     0,     0,     0,     0,   454,
     451,     0,     0,     0,     0,     0,     0,   482,   453,   479,
       0,     0,     0,   477,   456,   431,   428,     0,     0,     0,
       0,   435,     0,     0,   230,   270,   272,   279,     0,     0,
     245,     0,   277,   274,    88,   347,   407,     0,   403,   405,
       0,     0,     0,     0,   424,   453,     0,     0,     0,     0,
       0,   488,     0,   474,     0,     0,     0,   422,   453,     0,
     429,     0,   430,     0,   433,     0,     0,   436,    24,     0,
      88,     0,    88,     0,     0,   275,     0,   331,   334,   348,
     327,   276,   408,   316,     0,     0,     0,   442,   443,     0,
       0,   452,     0,   487,     0,     0,     0,   481,   480,   491,
     492,   486,     0,   473,     0,   425,   434,   437,     0,     0,
     271,   280,     0,   246,    88,   273,     0,   406,     0,   402,
       0,     0,     0,   485,   483,   489,     0,     0,   432,     0,
      25,    88,   278,   409,   404,     0,   444,   445,     0,     0,
     484,     0,   453,   426,   281,   319,     0,     0,   490,   478,
     446,     0,     0,     0,     0,     0,     0,     0,   427
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -666,  -666,  -666,  -666,   446,  -666,  -114,    65,   146,   112,
     182,   515,   526,   528,   510,   524,  -666,   -77,  -159,  -666,
    -125,  -381,   -73,  -240,    27,     4,  -666,   -24,  -666,     2,
     254,  -666,   603,   605,    -1,  -666,   425,  -666,  -666,   589,
    -147,  -666,   592,  -666,  -666,   408,  -666,  -666,   411,  -666,
    -666,  -666,  -666,   590,   476,   433,    13,   -18,  -666,  -666,
    -666,  -666,   420,   -16,   -11,    16,  -666,  -439,  -666,   286,
    -666,   233,   -79,  -144,  -666,  -666,  -666,  -161,  -666,  -372,
    -665,  -666,  -666,  -298,  -666,  -666,   348,  -380,  -666,  -666,
     374,  -666,  -666,  -666,    72,  -666,  -666,  -666,  -666,  -666,
     748,  -666,  -666,  -666,     5,   394,   -17,  -666,  -666,  -666,
    -666,  -666,  -666,  -666,  -666,  -666,   -20,  -512,   151,   263,
     154,   -10,  -666,    26,  -666,  -666,   141,  -292,  -666,  -666,
    -666,  -666,    97,  -666,  -618,  -666,    88,  -666,  -666,  -407,
    -666,  -666,  -666,  -666,  -662,  -433,  -214,  -202,   404,  -666,
    -666,   145,  -648,  -274,  -666,  -666,  -666
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
       0,   142,   143,   340,   208,   145,   146,   147,   148,   149,
     150,   151,   152,   153,   154,   155,   156,   209,   210,   319,
     411,   412,   278,   279,   413,   188,   384,    32,    33,   189,
      88,    96,    89,    97,    35,   160,    36,    37,    38,   176,
     177,   178,   179,   180,   264,   265,   487,   271,   272,   489,
      39,    76,   113,   198,   199,    40,   251,    41,   170,   370,
     104,   277,   386,    42,    43,   181,   387,   388,   389,   390,
     391,   163,   164,   477,   365,   478,   564,   254,   368,   414,
     415,   416,   417,   282,   190,   191,   418,   419,   499,   420,
     421,   422,   423,   722,   723,   766,   424,   425,    44,    45,
      46,    47,   108,    48,   200,   426,    49,    50,    51,   195,
     111,   196,   535,   730,   197,   458,   159,   642,   431,   432,
     533,   727,   728,   729,   287,   444,   298,   299,   450,   701,
     300,   705,   706,   751,   707,   710,   711,   441,   442,   443,
     301,   448,   449,   302,   690,   452,   335,   697,   516,   657,
     658,   659,   698,   699,   744,   816,   791
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      79,   336,    34,    78,    31,    82,   460,   211,   157,   253,
      95,   327,   158,   260,   546,   253,   100,   371,    79,   248,
      91,    78,   644,   105,   515,    77,   515,    30,   505,   262,
     538,   223,    92,    98,    14,    15,   743,    83,   524,   562,
     527,    14,    15,   102,    90,   737,   241,    34,   526,    31,
     655,   109,   746,   212,   748,   429,   741,   702,    21,   771,
     106,   341,   741,   724,   116,   321,   741,   115,   741,   165,
     321,    79,    30,   781,    78,   229,   230,   742,   211,   475,
     789,   211,   741,   742,   182,   184,   793,   742,    21,   742,
     784,   367,    79,   253,    21,    78,   171,   343,   709,    84,
     231,   232,    87,   742,   724,   790,   656,   263,    98,   157,
     344,   345,   346,   656,   774,   165,   242,   362,   523,    21,
     593,   430,   775,    80,   479,   670,   585,   307,   262,   580,
      80,   689,   269,   749,   792,   187,   651,   337,   815,   822,
     813,   112,   783,   165,   460,   165,   227,   246,   228,   756,
     547,   548,   247,   460,   259,    91,   524,   595,    91,   182,
     465,    85,   466,   273,   182,    95,   182,    91,    86,   832,
     839,   259,   233,  -115,   234,   323,   324,    91,   325,   326,
     157,    79,   255,   838,    78,  -115,   157,   168,    98,   165,
     372,   266,   157,   496,   235,   236,   376,    79,   274,   165,
      78,    79,  -117,   166,    78,   497,   498,   673,   467,   531,
     532,   172,   185,   693,  -117,   167,   174,   280,   776,   303,
     691,   692,   338,   173,   186,   304,   342,   764,   157,   217,
     218,   219,   462,     1,     2,     3,     4,     5,   321,   256,
     492,   565,   323,   324,   363,   325,   326,    14,    15,   476,
     650,   257,   731,   732,   733,    21,   364,   392,   182,   373,
     320,   428,   377,   321,   427,   480,   694,   695,   696,   323,
     324,   374,   325,   326,   378,   451,   453,   481,  -201,   385,
      21,   383,  -222,    79,   520,  -222,    78,   157,   166,   220,
    -201,   454,   347,   348,   455,   221,   456,   719,   457,   303,
     672,   222,   715,   716,   717,   463,   785,   482,   110,   554,
     664,   556,   557,   483,   473,   559,   665,   474,   157,    52,
      25,   567,   500,   253,   224,   437,   648,   649,   225,   438,
     439,   440,    26,   226,   202,    28,    80,   647,   323,   324,
    -173,   325,   326,   351,   352,   353,   354,   246,  -220,    21,
     392,  -220,   247,   587,   588,   589,   183,   652,   591,   273,
     653,    95,    91,   201,  -212,    21,   490,  -212,   246,   192,
     193,   194,   385,   491,   383,   349,   350,   581,   582,   583,
     428,   802,   509,   506,    98,   506,   266,   674,   800,   675,
     321,   103,   321,   244,   676,   245,   734,   321,   428,   560,
     428,   427,   679,   427,   157,   680,   761,   213,   778,   321,
     157,   779,   157,   214,   569,   752,   570,   355,   356,    53,
      54,    55,    56,    57,    58,    59,    60,   451,   436,   109,
     445,    61,    62,    63,    64,   433,   434,   827,    65,    66,
     828,   215,    67,    68,    69,    70,    71,    72,    73,   834,
      74,   216,   558,   830,    81,   237,   831,    75,    93,   708,
     438,   439,   440,   797,   238,   240,    94,    99,   787,   239,
     788,   105,   243,   249,   276,   574,   281,   576,   577,   708,
     385,   428,   383,   283,   506,   284,   285,   286,    91,   322,
     369,   375,   305,   435,   740,   379,   385,   328,   383,   168,
     174,   446,   818,   708,   393,   753,   819,   712,   713,   428,
     641,   161,   506,   640,   641,   447,   114,   640,   464,   162,
     708,   721,   753,   468,   469,   470,   175,   329,   471,   501,
     472,   144,   485,   330,    81,   331,   332,   333,   334,   493,
     494,   495,    99,   502,   503,   841,   504,   507,   510,   511,
     517,   844,   718,   184,   847,   246,   519,   161,   521,   428,
     491,   321,   506,   528,   522,   162,   385,   529,   383,  -303,
     530,   534,   543,   539,   204,   205,   207,   540,   541,   542,
     544,   545,   549,   550,   553,   161,   551,   161,   552,   555,
     561,   144,   563,   162,   568,   162,   579,   584,   829,   586,
     799,   175,   590,   592,   594,   267,   175,   645,   175,    81,
     660,   654,   661,   268,   114,    81,    81,   662,   663,   666,
     810,   811,    99,   667,   671,   668,   669,   842,   677,   678,
     845,   161,   144,   451,   451,   681,   682,   531,   684,   162,
     685,   161,   686,   687,   688,   689,   704,   700,   709,   162,
     714,   735,   736,   720,   428,   428,   428,   506,   506,   506,
     738,   739,   726,   745,   747,   451,   451,   451,   754,   836,
     144,   144,   144,   144,   144,   144,   144,   144,   144,   144,
     144,   144,   144,   144,   144,   144,   144,   144,   755,   758,
     759,   760,   762,   763,   773,   777,   786,   782,   794,   780,
     175,   795,   796,   144,   798,   772,   801,   114,    81,   144,
     641,   806,   288,   640,   803,   144,   804,   805,  -466,   451,
     308,   309,   310,   311,   312,   313,   314,   315,   316,   317,
    -467,  -468,   289,  -465,   809,   812,   814,   817,   820,   821,
     428,   824,   826,   506,   835,   837,   833,   840,   290,   848,
     360,   144,   357,   578,   726,   808,     1,     2,     3,     4,
       5,   291,   843,   846,   358,   361,   292,   359,   144,   250,
      14,    15,   275,   270,  -289,   293,   294,   258,  -309,   461,
     573,   486,   295,   536,   296,   297,   823,   318,   488,   726,
     484,   306,   525,   107,   765,   643,   508,   683,   757,   825,
     807,   428,   750,   703,   506,     0,     0,  -304,     0,     0,
     144,   518,     0,     1,     2,     3,     4,     5,    99,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,     0,     0,     0,     0,     0,     0,
       0,   144,     0,    25,     0,     0,     0,     0,     0,     0,
       0,    21,     0,     0,   288,    26,     0,    52,    28,    80,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   289,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    22,     0,    23,    24,     0,
     290,     0,     0,  -309,  -309,  -309,     0,  -290,     0,     0,
      25,  -309,     0,   291,     0,     0,     0,     0,   292,   459,
      17,     0,    26,    27,     0,    28,    29,   293,   294,     0,
       0,     0,   144,     0,   295,     0,   296,   144,     0,   169,
       0,     0,     0,   144,     0,   144,     1,     2,     3,     4,
       5,     0,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,    53,    54,    55,
      56,    57,    58,    59,    60,    22,     0,    23,    24,    61,
      62,    63,    64,     0,    21,     0,    65,    66,     0,     0,
      67,    68,    69,    70,    71,    72,    73,     0,    74,     0,
       0,     0,     0,     0,     0,    75,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    22,     0,
      23,    24,     0,     0,     0,     0,  -309,  -309,  -309,     0,
       0,     0,     0,    25,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    26,    27,     0,    28,    29,
      52,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126,   127,     0,   128,   129,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   130,     0,     0,     1,     2,     3,     4,
       5,   394,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,     0,   395,   396,
     397,     0,   398,   399,   400,   401,   402,   403,   404,   405,
       0,   131,   132,     0,   133,   134,     0,   135,     0,     0,
    -239,     0,  -267,   136,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   137,     0,     0,   406,   138,   139,   140,
      53,    54,    55,    56,    57,    58,    59,    60,    22,     0,
      23,    24,    61,    62,    63,    64,     0,     0,     0,    65,
      66,   407,   408,   381,    68,    69,    70,    71,    72,    73,
     409,    74,     0,     0,   410,    26,    27,   141,   382,    29,
      52,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126,   127,     0,   128,   129,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   130,     0,     0,     1,     2,     3,     4,
       5,   394,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,     0,   395,   396,
     397,     0,   398,   399,   400,   401,   402,   403,   404,   405,
       0,   131,   132,     0,   133,   134,     0,   135,     0,     0,
    -239,     0,  -268,   136,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   137,     0,     0,   406,   138,   139,   140,
      53,    54,    55,    56,    57,    58,    59,    60,    22,    52,
      23,    24,    61,    62,    63,    64,     0,     0,     0,    65,
      66,   407,   408,   381,    68,    69,    70,    71,    72,    73,
     409,    74,     0,     0,   410,    26,    27,   141,   382,    29,
       0,     0,   596,     0,     0,   597,   598,   599,   600,   601,
     602,   603,   604,   605,   606,   607,   608,   609,   610,   611,
     612,   613,    17,   614,   615,   616,     0,   617,   618,   619,
     620,   621,   622,   623,   624,   625,   626,   627,   628,     0,
       0,     1,     2,     3,     4,     5,     0,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,     0,    18,
      19,    20,     0,     0,     0,   629,   630,   631,   632,    53,
      54,    55,    56,    57,    58,    59,    60,    22,     0,    23,
      24,    61,    62,    63,    64,   633,   634,   635,    65,    66,
     636,   637,    67,    68,    69,    70,    71,    72,    73,     0,
      74,     0,     0,   638,     0,     0,     0,    75,   639,    52,
     117,   118,   119,   120,   121,   122,   123,   124,   125,   126,
     127,     0,   128,   129,     0,     0,     0,     0,    25,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      26,    27,   130,    28,    29,     0,     0,     0,     0,     0,
       0,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     131,   132,     0,   133,   134,     0,   135,     0,     0,     0,
       0,     0,   136,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   137,     0,     0,     0,   138,   139,   140,    53,
      54,    55,    56,    57,    58,    59,    60,    22,    52,    23,
      24,    61,    62,    63,    64,     0,     0,     0,    65,    66,
       0,     0,    67,    68,    69,    70,    71,    72,    73,     0,
      74,     0,     0,     0,     0,    27,   141,    75,    29,     0,
       0,     0,     0,     0,     1,     2,     3,     4,     5,     0,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,     0,     0,     0,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    15,    16,     0,
      18,    19,    20,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    52,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,     0,   128,   129,     0,    53,    54,
      55,    56,    57,    58,    59,    60,    22,     0,    23,    24,
      61,    62,    63,    64,     0,   130,     0,    65,    66,     0,
       0,   381,    68,    69,    70,    71,    72,    73,     0,    74,
       0,     0,     0,    26,    27,    17,   382,    29,    52,     0,
     395,   396,   397,     0,   398,   399,   400,   401,   402,   403,
     404,   405,    27,   131,   132,    29,   133,   134,     0,   135,
       0,     0,  -239,     0,     0,   136,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   137,     0,     0,   406,   138,
     139,   140,    53,    54,    55,    56,    57,    58,    59,    60,
      22,    17,    23,    24,    61,    62,    63,    64,     0,     0,
       0,    65,    66,   407,   408,    67,    68,    69,    70,    71,
      72,    73,   409,    74,     0,     0,   410,     0,   101,   141,
      75,    52,   117,   118,   119,   120,   121,   122,   123,   124,
     125,   126,   127,     0,   128,   129,     0,     0,    53,    54,
      55,    56,    57,    58,    59,    60,    22,     0,    23,    24,
      61,    62,    63,    64,   130,     0,     0,    65,    66,     0,
       0,    67,    68,    69,    70,    71,    72,    73,     0,    74,
       0,     0,     0,     0,     0,     0,    75,    52,     0,     0,
       0,   397,     0,   398,   399,   400,   401,   402,   403,   404,
     405,     0,   131,   132,     0,   133,   134,     0,   135,     0,
       0,  -239,     0,     0,   136,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   137,     0,     0,   406,   138,   139,
     140,    53,   767,   768,    56,   769,   770,    59,    60,     0,
      17,     0,     0,    61,    62,    63,    64,     0,     0,     0,
      65,    66,   407,   408,    67,    68,    69,    70,    71,    72,
      73,   409,    74,     0,     0,   410,     0,     0,   141,    75,
      52,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126,   127,     0,   128,   129,     0,     0,    53,    54,    55,
      56,    57,    58,    59,    60,    22,     0,    23,    24,    61,
      62,    63,    64,   130,     0,     0,    65,    66,     0,     0,
      67,    68,    69,    70,    71,    72,    73,     0,    74,     0,
       0,     0,     0,     0,     0,    75,    52,     0,     0,     0,
     397,     0,   398,   399,   400,   401,   402,   403,   404,   405,
       0,   131,   132,     0,   133,   134,     0,   135,     0,     0,
    -239,     0,     0,   136,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   137,     0,     0,   406,   138,   139,   140,
      53,    54,    55,    56,    57,    58,    59,    60,     0,   575,
       0,     0,    61,    62,    63,    64,     0,     0,     0,    65,
      66,   407,   408,    67,    68,    69,    70,    71,    72,    73,
     409,    74,     0,     0,   410,     0,     0,   141,    75,    52,
     117,   118,   119,   120,   121,   122,   123,   124,   125,   126,
     127,     0,   128,   129,   288,     0,    53,    54,    55,    56,
      57,    58,    59,    60,     0,     0,     0,     0,    61,    62,
      63,    64,   130,     0,   289,    65,    66,     0,     0,    67,
      68,    69,    70,    71,    72,    73,     0,    74,     0,     0,
     290,     0,     0,    52,    75,   323,   324,     0,   325,   326,
       0,     0,     0,   291,     0,     0,     0,     0,   292,     0,
     131,   132,     0,   133,   134,     0,   135,   293,   294,     0,
       0,     0,   136,     0,   295,     0,   296,     0,     0,     0,
       0,     0,   137,     0,     0,     0,   138,   139,   140,    53,
      54,    55,    56,    57,    58,    59,    60,   512,     0,   513,
     514,    61,    62,    63,    64,     0,     0,     0,    65,    66,
       0,     0,    67,    68,    69,    70,    71,    72,    73,     0,
      74,     0,     0,     0,     0,     0,   141,    75,    52,   117,
     118,   119,   120,   121,   122,   123,   124,   125,   126,   127,
       0,   128,   129,    53,    54,    55,    56,    57,    58,    59,
      60,     0,     0,     0,     0,    61,    62,    63,    64,     0,
       0,   130,    65,    66,     0,     0,    67,    68,    69,    70,
      71,    72,    73,     0,    74,     0,     0,     0,     0,     0,
       0,    75,    52,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   131,
     132,     0,   133,   134,     0,   135,     0,     0,   252,     0,
     366,   136,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   137,     0,     0,     0,   138,   139,   140,    53,    54,
      55,    56,    57,    58,    59,    60,     0,     0,     0,     0,
      61,    62,    63,    64,     0,     0,     0,    65,    66,     0,
       0,    67,    68,    69,    70,    71,    72,    73,     0,    74,
       0,     0,     0,     0,     0,   141,    75,    52,   117,   118,
     119,   120,   121,   122,   123,   124,   125,   126,   127,     0,
     128,   129,    53,    54,    55,    56,    57,    58,    59,    60,
       0,     0,     0,     0,    61,    62,    63,    64,     0,     0,
     130,   725,    66,     0,     0,    67,    68,    69,    70,    71,
      72,    73,     0,    74,     0,     0,     0,     0,     0,     0,
      75,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   131,   132,
       0,   133,   134,     0,   135,     0,     0,   252,     0,   566,
     136,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     137,     0,     0,     0,   138,   139,   140,    53,    54,    55,
      56,    57,    58,    59,    60,     0,     0,     0,     0,    61,
      62,    63,    64,     0,     0,     0,    65,    66,     0,     0,
      67,    68,    69,    70,    71,    72,    73,     0,    74,     0,
       0,   288,     0,     0,   141,    75,    52,   117,   118,   119,
     120,   121,   122,   123,   124,   125,   126,   127,     0,   128,
     129,   289,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   290,     0,   130,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     291,     0,     0,     0,     0,   292,   537,     0,     0,     0,
       0,     0,     0,     0,   293,   294,     0,     0,     0,     0,
       0,   295,     0,   296,     0,     0,     0,   131,   132,     0,
     133,   134,     0,   135,     0,     0,   252,     0,     0,   136,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   137,
       0,     0,     0,   138,   139,   140,    53,    54,    55,    56,
      57,    58,    59,    60,     0,     0,     0,     0,    61,    62,
      63,    64,     0,     0,     0,    65,    66,     0,     0,    67,
      68,    69,    70,    71,    72,    73,     0,    74,     0,     0,
     288,     0,     0,   141,    75,    52,   117,   118,   119,   120,
     121,   122,   123,   124,   125,   126,   127,     0,   128,   129,
     289,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   290,     0,   130,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   291,
       0,     0,     0,     0,   292,     0,     0,     0,     0,     0,
       0,     0,     0,   293,   294,     0,     0,     0,     0,     0,
     295,     0,   296,     0,     0,     0,   131,   132,   339,   133,
     134,     0,   135,     0,     0,     0,     0,     0,   136,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   137,     0,
       0,     0,   138,   139,   140,    53,    54,    55,    56,    57,
      58,    59,    60,     0,     0,     0,     0,    61,    62,    63,
      64,     0,     0,     0,    65,    66,     0,     0,    67,    68,
      69,    70,    71,    72,    73,     0,    74,     0,     0,     0,
       0,     0,   141,    75,    52,   117,   118,   119,   120,   121,
     122,   123,   124,   125,   126,   127,     0,   128,   129,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   130,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   131,   132,     0,   133,   134,
       0,   135,     0,     0,     0,     0,     0,   136,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   137,     0,     0,
       0,   138,   139,   140,    53,    54,    55,    56,    57,    58,
      59,    60,     0,     0,     0,     0,    61,    62,    63,    64,
       0,     0,     0,    65,    66,     0,     0,    67,    68,    69,
      70,    71,    72,    73,     0,    74,     0,     0,     0,     0,
       0,   141,    75,    52,   117,   118,   119,   120,   121,   122,
     123,   124,   125,   126,   127,     0,   128,   129,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   130,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   131,   203,     0,   133,   134,     0,
     135,     0,     0,     0,     0,     0,   136,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   137,     0,     0,     0,
     138,   139,   140,    53,    54,    55,    56,    57,    58,    59,
      60,     0,     0,     0,     0,    61,    62,    63,    64,     0,
       0,     0,    65,    66,     0,     0,    67,    68,    69,    70,
      71,    72,    73,     0,    74,     0,     0,     0,     0,     0,
     141,    75,    52,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,     0,   128,   129,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   130,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
    -201,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   131,   206,     0,   133,   134,     0,   135,
       0,     0,     0,     0,     0,   136,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   137,     0,     0,     0,   138,
     139,   140,    53,    54,    55,    56,    57,    58,    59,    60,
      52,     0,     0,     0,    61,    62,    63,    64,     0,     0,
       0,    65,    66,     0,     0,    67,    68,    69,    70,    71,
      72,    73,  -201,    74,    21,     0,     0,     0,     0,   141,
      75,     0,     0,     0,  -201,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
    -201,  -201,  -201,  -201,  -201,  -201,  -201,  -201,     0,     0,
       0,     0,  -201,  -201,  -201,  -201,     0,     0,     0,  -201,
    -201,     0,   571,  -201,  -201,  -201,  -201,  -201,  -201,  -201,
       0,  -201,     0,     0,   364,     0,     0,     0,  -201,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      53,    54,    55,    56,    57,    58,    59,    60,     0,     0,
       0,     0,    61,    62,    63,    64,     0,     0,     0,    65,
      66,     0,     0,    67,    68,    69,    70,    71,    72,    73,
       0,    74,     0,     0,     0,     0,     0,     0,    75,     1,
       2,     3,     4,     5,   394,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
       1,     2,     3,     4,     5,     0,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,     0,     0,     0,     0,   646,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    21,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    22,     0,    23,    24,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    25,     0,     0,     0,
       0,     0,    22,     0,    23,    24,     0,     0,    26,    27,
       0,    28,    29,     0,     0,     0,     0,    25,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    26,
      27,     0,    28,    29,     1,     2,     3,     4,     5,   394,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,     1,     2,     3,     4,     5,
       0,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,   572,     1,     2,     3,
       4,     5,     0,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,     0,     0,
       0,     0,     0,     0,     0,     0,    22,     0,    23,    24,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    25,     0,     0,     0,     0,     0,    22,     0,    23,
      24,     0,     0,    26,    27,     0,    28,    29,     0,     0,
       0,     0,    25,     0,     0,     0,     0,     0,     0,    22,
       0,    23,    24,     0,    26,    27,     0,    28,    29,     0,
       0,     0,     0,     0,    25,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    26,    27,     0,    28,
      29,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,     0,     0,    21,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   269,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   261,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    22,     0,    23,
      24,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    22,     0,    23,    24,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    27,     0,     0,    29,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      27,     0,     0,    29,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,    20,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   380,  -336,  -336,  -336,  -336,  -336,
    -336,  -336,  -336,  -336,  -336,  -336,  -336,  -336,  -336,  -336,
    -336,  -336,  -336,  -336,  -336,  -336,     0,     0,     0,     0,
      22,     0,    23,    24,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    22,     0,    23,    24,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    27,     0,
       0,    29,     0,  -336,  -336,     0,     0,     0,  -336,     0,
    -336,  -336,  -336,    27,  -336,     0,    29,     0,     0,  -336,
    -336,  -336,  -336,  -336,  -336,  -336,  -337,  -337,  -337,  -337,
    -337,  -337,  -337,  -337,  -337,  -337,  -337,  -337,  -337,  -337,
    -337,  -337,  -337,  -337,  -337,  -337,  -337,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,  -337,  -337,     0,     0,     0,  -337,
       0,  -337,  -337,  -337,     0,  -337,     0,     0,     0,     0,
    -337,  -337,  -337,  -337,  -337,  -337,  -337
};

static const yytype_int16 yycheck[] =
{
      20,   215,     0,    20,     0,    21,   298,   132,    85,   168,
      34,   213,    85,   174,   447,   174,    34,   257,    38,   163,
      31,    38,   534,    43,   405,    20,   407,     0,   400,   176,
     437,   145,    33,    34,    53,    54,   698,    21,   418,   478,
     420,    53,    54,    38,    31,   693,    25,    45,   420,    45,
      72,    49,   700,   132,   702,    11,    16,    72,    77,   724,
       0,   220,    16,   681,    84,    79,    16,    83,    16,    86,
      79,    91,    45,   735,    91,    18,    19,    37,   203,    88,
     106,   206,    16,    37,   101,   103,   748,    37,    77,    37,
     738,   252,   112,   252,    77,   112,    91,   222,    11,    75,
      20,    21,    91,    37,   722,   131,   128,    90,   109,   186,
     224,   225,   226,   128,    79,   132,    95,   242,   416,    77,
     134,    77,    87,   142,   364,   564,   507,   206,   275,   501,
     142,    91,    90,    62,    88,   108,   543,   216,   786,   804,
      88,    83,    76,   160,   436,   162,    78,   163,    80,    62,
     448,   449,   163,   445,   172,   166,   536,   529,   169,   176,
     319,    75,   321,   181,   181,   189,   183,   178,    75,   817,
     832,   189,    92,    79,    94,   104,   105,   188,   107,   108,
     257,   201,   169,   831,   201,    91,   263,    93,   189,   206,
     263,   178,   269,    45,    22,    23,   269,   217,   182,   216,
     217,   221,    79,    79,   221,    57,    58,   579,   322,    78,
      79,    79,    75,    75,    91,    91,    93,   190,   730,    79,
     653,   654,   217,    91,    87,    85,   221,    62,   305,    15,
      16,    17,   305,    39,    40,    41,    42,    43,    79,    75,
     384,   481,   104,   105,    75,   107,   108,    53,    54,    90,
     542,    87,   685,   686,   687,    77,    87,   277,   275,    79,
      76,   281,    79,    79,   281,    75,   128,   129,   130,   104,
     105,    91,   107,   108,    91,   295,   296,    87,    75,   277,
      77,   277,    76,   303,   409,    79,   303,   364,    79,    75,
      87,     4,   227,   228,     7,    81,     9,   678,    11,    79,
      91,    87,   674,   675,   676,    85,   739,    79,     4,   468,
     105,   470,   471,    85,    76,   474,   111,    79,   395,     3,
     126,   482,   395,   482,    73,    96,   540,   541,    77,   100,
     101,   102,   138,    82,    76,   141,   142,   539,   104,   105,
      83,   107,   108,   231,   232,   233,   234,   363,    76,    77,
     370,    79,   363,   512,   513,   514,    83,    76,   517,   377,
      79,   385,   373,    83,    76,    77,   384,    79,   384,   119,
     120,   121,   370,   384,   370,   229,   230,   502,   503,   504,
     400,   762,   402,   400,   385,   402,   373,    76,   760,    76,
      79,    75,    79,   160,    76,   162,   688,    79,   418,   476,
     420,   418,    76,   420,   481,    79,    76,    90,    76,    79,
     487,    79,   489,    90,   487,   707,   489,   235,   236,   103,
     104,   105,   106,   107,   108,   109,   110,   447,   287,   427,
     289,   115,   116,   117,   118,   284,   285,    76,   122,   123,
      79,    90,   126,   127,   128,   129,   130,   131,   132,   821,
     134,    75,   472,    76,    21,    74,    79,   141,    33,   661,
     100,   101,   102,   755,    89,    24,    33,    34,   742,    84,
     744,   491,    76,    76,    76,   495,    83,   497,   498,   681,
     478,   501,   478,    83,   501,    83,    83,   123,   499,    76,
      76,    90,    93,    83,   696,    90,   494,    75,   494,    93,
      93,    75,   794,   705,    88,   707,   798,   666,   667,   529,
     530,    86,   529,   530,   534,    75,    83,   534,    76,    86,
     722,   680,   724,    75,   103,    75,   101,   105,    75,    90,
      79,    85,    88,   111,   101,   113,   114,   115,   116,    76,
      79,    79,   109,    75,    75,   837,    75,    75,    91,    91,
      75,   843,   677,   571,   846,   571,    91,   132,    91,   579,
     571,    79,   579,    85,    91,   132,   564,    90,   564,    90,
      85,    85,    24,    90,   128,   129,   130,    90,    90,   132,
      85,    11,    83,    87,   118,   160,   134,   162,   134,    76,
      76,   145,    88,   160,    76,   162,    90,    66,   812,    91,
     759,   176,    91,    91,    85,   180,   181,    85,   183,   176,
      11,    79,    83,   180,   181,   182,   183,    83,    76,    79,
     779,   780,   189,    79,    88,    76,    76,   841,    75,    91,
     844,   206,   186,   653,   654,    83,    75,    78,    38,   206,
      75,   216,    75,    75,    64,    91,    88,    87,    11,   216,
      76,    76,    76,    91,   674,   675,   676,   674,   675,   676,
      87,    75,   682,    81,    85,   685,   686,   687,    90,   828,
     224,   225,   226,   227,   228,   229,   230,   231,   232,   233,
     234,   235,   236,   237,   238,   239,   240,   241,    90,    76,
      79,    64,    91,    76,    76,    76,    75,   134,    90,    79,
     275,    85,    90,   257,    90,   725,    91,   274,   275,   263,
     730,    15,    63,   730,    91,   269,    90,    85,    90,   739,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      90,    90,    83,    90,    75,    83,    76,    93,    76,    76,
     760,    88,    76,   760,    76,    90,    85,    76,    99,    85,
     240,   305,   237,   499,   774,   775,    39,    40,    41,    42,
      43,   112,    90,    90,   238,   241,   117,   239,   322,   166,
      53,    54,   183,   181,     0,   126,   127,   172,     4,   303,
     494,   373,   133,   435,   135,   136,   806,    93,   377,   809,
     370,   201,   418,    45,   722,   532,   402,   643,   710,   809,
     774,   821,   705,   658,   821,    -1,    -1,    90,    -1,    -1,
     364,   407,    -1,    39,    40,    41,    42,    43,   385,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   395,    -1,   126,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    77,    -1,    -1,    63,   138,    -1,     3,   141,   142,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    83,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   111,    -1,   113,   114,    -1,
      99,    -1,    -1,   119,   120,   121,    -1,     0,    -1,    -1,
     126,     4,    -1,   112,    -1,    -1,    -1,    -1,   117,   118,
      56,    -1,   138,   139,    -1,   141,   142,   126,   127,    -1,
      -1,    -1,   476,    -1,   133,    -1,   135,   481,    -1,    75,
      -1,    -1,    -1,   487,    -1,   489,    39,    40,    41,    42,
      43,    -1,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,   103,   104,   105,
     106,   107,   108,   109,   110,   111,    -1,   113,   114,   115,
     116,   117,   118,    -1,    77,    -1,   122,   123,    -1,    -1,
     126,   127,   128,   129,   130,   131,   132,    -1,   134,    -1,
      -1,    -1,    -1,    -1,    -1,   141,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   111,    -1,
     113,   114,    -1,    -1,    -1,    -1,   119,   120,   121,    -1,
      -1,    -1,    -1,   126,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   138,   139,    -1,   141,   142,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    -1,    16,    17,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    36,    -1,    -1,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    -1,    61,    62,
      63,    -1,    65,    66,    67,    68,    69,    70,    71,    72,
      -1,    74,    75,    -1,    77,    78,    -1,    80,    -1,    -1,
      83,    -1,    85,    86,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    96,    -1,    -1,    99,   100,   101,   102,
     103,   104,   105,   106,   107,   108,   109,   110,   111,    -1,
     113,   114,   115,   116,   117,   118,    -1,    -1,    -1,   122,
     123,   124,   125,   126,   127,   128,   129,   130,   131,   132,
     133,   134,    -1,    -1,   137,   138,   139,   140,   141,   142,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    -1,    16,    17,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    36,    -1,    -1,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    -1,    61,    62,
      63,    -1,    65,    66,    67,    68,    69,    70,    71,    72,
      -1,    74,    75,    -1,    77,    78,    -1,    80,    -1,    -1,
      83,    -1,    85,    86,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    96,    -1,    -1,    99,   100,   101,   102,
     103,   104,   105,   106,   107,   108,   109,   110,   111,     3,
     113,   114,   115,   116,   117,   118,    -1,    -1,    -1,   122,
     123,   124,   125,   126,   127,   128,   129,   130,   131,   132,
     133,   134,    -1,    -1,   137,   138,   139,   140,   141,   142,
      -1,    -1,    36,    -1,    -1,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    -1,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    -1,
      -1,    39,    40,    41,    42,    43,    -1,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    -1,    57,
      58,    59,    -1,    -1,    -1,    99,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   111,    -1,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,   128,   129,   130,   131,   132,    -1,
     134,    -1,    -1,   137,    -1,    -1,    -1,   141,   142,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    -1,    16,    17,    -1,    -1,    -1,    -1,   126,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     138,   139,    36,   141,   142,    -1,    -1,    -1,    -1,    -1,
      -1,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      74,    75,    -1,    77,    78,    -1,    80,    -1,    -1,    -1,
      -1,    -1,    86,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    96,    -1,    -1,    -1,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   111,     3,   113,
     114,   115,   116,   117,   118,    -1,    -1,    -1,   122,   123,
      -1,    -1,   126,   127,   128,   129,   130,   131,   132,    -1,
     134,    -1,    -1,    -1,    -1,   139,   140,   141,   142,    -1,
      -1,    -1,    -1,    -1,    39,    40,    41,    42,    43,    -1,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    -1,    -1,    -1,    45,    46,
      47,    48,    49,    50,    51,    52,    53,    54,    55,    -1,
      57,    58,    59,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    -1,    16,    17,    -1,   103,   104,
     105,   106,   107,   108,   109,   110,   111,    -1,   113,   114,
     115,   116,   117,   118,    -1,    36,    -1,   122,   123,    -1,
      -1,   126,   127,   128,   129,   130,   131,   132,    -1,   134,
      -1,    -1,    -1,   138,   139,    56,   141,   142,     3,    -1,
      61,    62,    63,    -1,    65,    66,    67,    68,    69,    70,
      71,    72,   139,    74,    75,   142,    77,    78,    -1,    80,
      -1,    -1,    83,    -1,    -1,    86,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,    99,   100,
     101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
     111,    56,   113,   114,   115,   116,   117,   118,    -1,    -1,
      -1,   122,   123,   124,   125,   126,   127,   128,   129,   130,
     131,   132,   133,   134,    -1,    -1,   137,    -1,    83,   140,
     141,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    -1,    16,    17,    -1,    -1,   103,   104,
     105,   106,   107,   108,   109,   110,   111,    -1,   113,   114,
     115,   116,   117,   118,    36,    -1,    -1,   122,   123,    -1,
      -1,   126,   127,   128,   129,   130,   131,   132,    -1,   134,
      -1,    -1,    -1,    -1,    -1,    -1,   141,     3,    -1,    -1,
      -1,    63,    -1,    65,    66,    67,    68,    69,    70,    71,
      72,    -1,    74,    75,    -1,    77,    78,    -1,    80,    -1,
      -1,    83,    -1,    -1,    86,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    96,    -1,    -1,    99,   100,   101,
     102,   103,   104,   105,   106,   107,   108,   109,   110,    -1,
      56,    -1,    -1,   115,   116,   117,   118,    -1,    -1,    -1,
     122,   123,   124,   125,   126,   127,   128,   129,   130,   131,
     132,   133,   134,    -1,    -1,   137,    -1,    -1,   140,   141,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    -1,    16,    17,    -1,    -1,   103,   104,   105,
     106,   107,   108,   109,   110,   111,    -1,   113,   114,   115,
     116,   117,   118,    36,    -1,    -1,   122,   123,    -1,    -1,
     126,   127,   128,   129,   130,   131,   132,    -1,   134,    -1,
      -1,    -1,    -1,    -1,    -1,   141,     3,    -1,    -1,    -1,
      63,    -1,    65,    66,    67,    68,    69,    70,    71,    72,
      -1,    74,    75,    -1,    77,    78,    -1,    80,    -1,    -1,
      83,    -1,    -1,    86,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    96,    -1,    -1,    99,   100,   101,   102,
     103,   104,   105,   106,   107,   108,   109,   110,    -1,    56,
      -1,    -1,   115,   116,   117,   118,    -1,    -1,    -1,   122,
     123,   124,   125,   126,   127,   128,   129,   130,   131,   132,
     133,   134,    -1,    -1,   137,    -1,    -1,   140,   141,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    -1,    16,    17,    63,    -1,   103,   104,   105,   106,
     107,   108,   109,   110,    -1,    -1,    -1,    -1,   115,   116,
     117,   118,    36,    -1,    83,   122,   123,    -1,    -1,   126,
     127,   128,   129,   130,   131,   132,    -1,   134,    -1,    -1,
      99,    -1,    -1,     3,   141,   104,   105,    -1,   107,   108,
      -1,    -1,    -1,   112,    -1,    -1,    -1,    -1,   117,    -1,
      74,    75,    -1,    77,    78,    -1,    80,   126,   127,    -1,
      -1,    -1,    86,    -1,   133,    -1,   135,    -1,    -1,    -1,
      -1,    -1,    96,    -1,    -1,    -1,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   111,    -1,   113,
     114,   115,   116,   117,   118,    -1,    -1,    -1,   122,   123,
      -1,    -1,   126,   127,   128,   129,   130,   131,   132,    -1,
     134,    -1,    -1,    -1,    -1,    -1,   140,   141,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      -1,    16,    17,   103,   104,   105,   106,   107,   108,   109,
     110,    -1,    -1,    -1,    -1,   115,   116,   117,   118,    -1,
      -1,    36,   122,   123,    -1,    -1,   126,   127,   128,   129,
     130,   131,   132,    -1,   134,    -1,    -1,    -1,    -1,    -1,
      -1,   141,     3,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    74,
      75,    -1,    77,    78,    -1,    80,    -1,    -1,    83,    -1,
      85,    86,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    96,    -1,    -1,    -1,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,    -1,    -1,    -1,    -1,
     115,   116,   117,   118,    -1,    -1,    -1,   122,   123,    -1,
      -1,   126,   127,   128,   129,   130,   131,   132,    -1,   134,
      -1,    -1,    -1,    -1,    -1,   140,   141,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    -1,
      16,    17,   103,   104,   105,   106,   107,   108,   109,   110,
      -1,    -1,    -1,    -1,   115,   116,   117,   118,    -1,    -1,
      36,   122,   123,    -1,    -1,   126,   127,   128,   129,   130,
     131,   132,    -1,   134,    -1,    -1,    -1,    -1,    -1,    -1,
     141,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    74,    75,
      -1,    77,    78,    -1,    80,    -1,    -1,    83,    -1,    85,
      86,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      96,    -1,    -1,    -1,   100,   101,   102,   103,   104,   105,
     106,   107,   108,   109,   110,    -1,    -1,    -1,    -1,   115,
     116,   117,   118,    -1,    -1,    -1,   122,   123,    -1,    -1,
     126,   127,   128,   129,   130,   131,   132,    -1,   134,    -1,
      -1,    63,    -1,    -1,   140,   141,     3,     4,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    -1,    16,
      17,    83,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    99,    -1,    36,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     112,    -1,    -1,    -1,    -1,   117,   118,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   126,   127,    -1,    -1,    -1,    -1,
      -1,   133,    -1,   135,    -1,    -1,    -1,    74,    75,    -1,
      77,    78,    -1,    80,    -1,    -1,    83,    -1,    -1,    86,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,
      -1,    -1,    -1,   100,   101,   102,   103,   104,   105,   106,
     107,   108,   109,   110,    -1,    -1,    -1,    -1,   115,   116,
     117,   118,    -1,    -1,    -1,   122,   123,    -1,    -1,   126,
     127,   128,   129,   130,   131,   132,    -1,   134,    -1,    -1,
      63,    -1,    -1,   140,   141,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    -1,    16,    17,
      83,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    99,    -1,    36,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   112,
      -1,    -1,    -1,    -1,   117,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   126,   127,    -1,    -1,    -1,    -1,    -1,
     133,    -1,   135,    -1,    -1,    -1,    74,    75,    76,    77,
      78,    -1,    80,    -1,    -1,    -1,    -1,    -1,    86,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,
      -1,    -1,   100,   101,   102,   103,   104,   105,   106,   107,
     108,   109,   110,    -1,    -1,    -1,    -1,   115,   116,   117,
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
     110,    -1,    -1,    -1,    -1,   115,   116,   117,   118,    -1,
      -1,    -1,   122,   123,    -1,    -1,   126,   127,   128,   129,
     130,   131,   132,    -1,   134,    -1,    -1,    -1,    -1,    -1,
     140,   141,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    -1,    16,    17,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    36,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
       3,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    74,    75,    -1,    77,    78,    -1,    80,
      -1,    -1,    -1,    -1,    -1,    86,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,    -1,   100,
     101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
       3,    -1,    -1,    -1,   115,   116,   117,   118,    -1,    -1,
      -1,   122,   123,    -1,    -1,   126,   127,   128,   129,   130,
     131,   132,    75,   134,    77,    -1,    -1,    -1,    -1,   140,
     141,    -1,    -1,    -1,    87,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     103,   104,   105,   106,   107,   108,   109,   110,    -1,    -1,
      -1,    -1,   115,   116,   117,   118,    -1,    -1,    -1,   122,
     123,    -1,    75,   126,   127,   128,   129,   130,   131,   132,
      -1,   134,    -1,    -1,    87,    -1,    -1,    -1,   141,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     103,   104,   105,   106,   107,   108,   109,   110,    -1,    -1,
      -1,    -1,   115,   116,   117,   118,    -1,    -1,    -1,   122,
     123,    -1,    -1,   126,   127,   128,   129,   130,   131,   132,
      -1,   134,    -1,    -1,    -1,    -1,    -1,    -1,   141,    39,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      39,    40,    41,    42,    43,    -1,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    -1,    -1,    -1,    -1,    85,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    77,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   111,    -1,   113,   114,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   126,    -1,    -1,    -1,
      -1,    -1,   111,    -1,   113,   114,    -1,    -1,   138,   139,
      -1,   141,   142,    -1,    -1,    -1,    -1,   126,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   138,
     139,    -1,   141,   142,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    39,    40,    41,    42,    43,
      -1,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    39,    40,    41,
      42,    43,    -1,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   111,    -1,   113,   114,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   126,    -1,    -1,    -1,    -1,    -1,   111,    -1,   113,
     114,    -1,    -1,   138,   139,    -1,   141,   142,    -1,    -1,
      -1,    -1,   126,    -1,    -1,    -1,    -1,    -1,    -1,   111,
      -1,   113,   114,    -1,   138,   139,    -1,   141,   142,    -1,
      -1,    -1,    -1,    -1,   126,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   138,   139,    -1,   141,
     142,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    -1,    -1,    77,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    90,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    85,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   111,    -1,   113,
     114,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   111,    -1,   113,   114,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   139,    -1,    -1,   142,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     139,    -1,    -1,   142,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    85,    15,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    -1,    -1,    -1,    -1,
     111,    -1,   113,   114,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   111,    -1,   113,   114,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   139,    -1,
      -1,   142,    -1,    73,    74,    -1,    -1,    -1,    78,    -1,
      80,    81,    82,   139,    84,    -1,   142,    -1,    -1,    89,
      90,    91,    92,    93,    94,    95,    15,    16,    17,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    73,    74,    -1,    -1,    -1,    78,
      -1,    80,    81,    82,    -1,    84,    -1,    -1,    -1,    -1,
      89,    90,    91,    92,    93,    94,    95
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
     142,   199,   207,   209,    75,    75,    75,    91,   174,   176,
     200,   208,   178,   180,   199,   171,   175,   177,   178,   199,
     201,    83,   248,    75,   204,   260,     0,   244,   246,   173,
       4,   254,    83,   196,   199,   207,   260,     4,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    16,    17,
      36,    74,    75,    77,    78,    80,    86,    96,   100,   101,
     102,   140,   145,   146,   148,   149,   150,   151,   152,   153,
     154,   155,   156,   157,   158,   159,   160,   161,   166,   260,
     179,   180,   199,   215,   216,   250,    79,    91,    93,    75,
     202,   248,    79,    91,    93,   180,   183,   184,   185,   186,
     187,   209,   250,    83,   201,    75,    87,   168,   169,   173,
     228,   229,   119,   120,   121,   253,   255,   258,   197,   198,
     248,    83,    76,    75,   148,   148,    75,   148,   148,   161,
     162,   164,   216,    90,    90,    90,    75,    15,    16,    17,
      75,    81,    87,   150,    73,    77,    82,    78,    80,    18,
      19,    20,    21,    92,    94,    22,    23,    74,    89,    84,
      24,    25,    95,    76,   215,   215,   207,   208,   217,    76,
     176,   200,    83,   162,   221,   200,    75,    87,   177,   201,
     221,    85,   184,    90,   188,   189,   200,   180,   199,    90,
     186,   191,   192,   201,   209,   183,    76,   205,   166,   167,
     168,    83,   227,    83,    83,    83,   123,   268,    63,    83,
      99,   112,   117,   126,   127,   133,   135,   136,   270,   271,
     274,   284,   287,    79,    85,    93,   197,   216,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,    93,   163,
      76,    79,    76,   104,   105,   107,   108,   291,    75,   105,
     111,   113,   114,   115,   116,   290,   290,   216,   248,    76,
     147,   162,   248,   164,   150,   150,   150,   151,   151,   152,
     152,   153,   153,   153,   153,   154,   154,   155,   156,   157,
     158,   159,   164,    75,    87,   218,    85,   221,   222,    76,
     203,   167,   166,    79,    91,    90,   166,    79,    91,    90,
      85,   126,   141,   169,   170,   173,   206,   210,   211,   212,
     213,   214,   260,    88,    44,    61,    62,    63,    65,    66,
      67,    68,    69,    70,    71,    72,    99,   124,   125,   133,
     137,   164,   165,   168,   223,   224,   225,   226,   230,   231,
     233,   234,   235,   236,   240,   241,   249,   250,   260,    11,
      77,   262,   263,   262,   262,    83,   270,    96,   100,   101,
     102,   281,   282,   283,   269,   270,    75,    75,   285,   286,
     272,   260,   289,   260,     4,     7,     9,    11,   259,   118,
     271,   198,   166,    85,    76,   162,   162,   150,    75,   103,
      75,    75,    79,    76,    79,    88,    90,   217,   219,   167,
      75,    87,    79,    85,   206,    88,   189,   190,   192,   193,
     201,   208,   217,    76,    79,    79,    45,    57,    58,   232,
     166,    90,    75,    75,    75,   223,   250,    75,   249,   260,
      91,    91,   111,   113,   114,   165,   292,    75,   292,    91,
     164,    91,    91,   227,   231,   234,   223,   231,    85,    90,
      85,    78,    79,   264,    85,   256,   230,   118,   283,    90,
      90,    90,   132,    24,    85,    11,   289,   227,   227,    83,
      87,   134,   134,   118,   162,    76,   162,   162,   260,   162,
     161,    76,   211,    88,   220,   167,    85,   221,    76,   166,
     166,    75,    60,   213,   260,    56,   260,   260,   174,    90,
     223,   164,   164,   164,    66,   165,    91,   162,   162,   162,
      91,   162,    91,   134,    85,   223,    36,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    57,    58,    59,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    99,
     100,   101,   102,   119,   120,   121,   124,   125,   137,   142,
     250,   260,   261,   263,   261,    85,    85,   291,   290,   290,
     271,   283,    76,    79,    79,    72,   128,   293,   294,   295,
      11,    83,    83,    76,   105,   111,    79,    79,    76,    76,
     211,    88,    91,   223,    76,    76,    76,    75,    91,    76,
      79,    83,    75,   264,    38,    75,    75,    75,    64,    91,
     288,   289,   289,    75,   128,   129,   130,   291,   296,   297,
      87,   273,    72,   295,    88,   275,   276,   278,   291,    11,
     279,   280,   162,   162,    76,   223,   223,   223,   164,   165,
      91,   162,   237,   238,   278,   122,   260,   265,   266,   267,
     257,   289,   289,   289,   271,    76,    76,   296,    87,    75,
     291,    16,    37,   288,   298,    81,   296,    85,   296,    62,
     276,   277,   271,   291,    90,    90,    62,   280,    76,    79,
      64,    76,    91,    76,    62,   238,   239,   104,   105,   107,
     108,   224,   260,    76,    79,    87,   261,    76,    76,    79,
      79,   288,   134,    76,   296,   289,    75,   297,   297,   106,
     131,   300,    88,   288,    90,    85,    90,   271,    90,   162,
     223,    91,   165,    91,    90,    85,    15,   267,   260,    75,
     162,   162,    83,    88,    76,   296,   299,    93,   271,   271,
      76,    76,   224,   260,    88,   265,    76,    76,    79,   290,
      76,    79,   296,    85,   223,    76,   162,    90,   296,   288,
      76,   271,   290,    90,   271,   290,    90,   271,    85
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
     180,   180,   181,   181,   181,   182,   182,   183,   183,   184,
     184,   185,   185,   186,   186,   186,   187,   187,   187,   188,
     188,   189,   189,   190,   189,   191,   191,   192,   192,   193,
     192,   195,   194,   196,   194,   194,   197,   197,   198,   198,
     199,   199,   199,   200,   201,   202,   202,   202,   203,   202,
     204,   204,   204,   205,   204,   206,   206,   207,   207,   207,
     207,   208,   208,   209,   209,   210,   210,   211,   211,   212,
     212,   213,   213,   213,   214,   214,   215,   215,   215,   215,
     216,   216,   217,   217,   218,   218,   218,   219,   218,   220,
     218,   221,   221,   221,   221,   222,   222,   223,   223,   225,
     224,   224,   224,   224,   224,   224,   224,   226,   226,   226,
     227,   227,   228,   228,   229,   229,   230,   230,   231,   231,
     232,   232,   232,   232,   233,   233,   233,   234,   234,   235,
     236,   236,   236,   236,   237,   237,   238,   239,   239,   240,
     240,   240,   241,   241,   241,   241,   241,   241,   241,   242,
     242,   243,   243,   244,   244,   244,   246,   245,   247,   247,
     247,   248,   248,   249,   249,   250,   250,   250,   250,   252,
     251,   253,   253,   253,   254,   254,   255,   256,   257,   255,
     258,   259,   259,   259,   259,   260,   260,   260,   260,   260,
     260,   260,   260,   260,   260,   260,   260,   260,   260,   260,
     260,   260,   260,   260,   260,   260,   260,   260,   260,   261,
     261,   261,   261,   261,   261,   261,   261,   261,   261,   261,
     261,   261,   261,   261,   261,   261,   261,   261,   261,   261,
     261,   261,   261,   261,   261,   261,   261,   261,   261,   261,
     261,   261,   261,   261,   261,   261,   261,   261,   261,   261,
     261,   261,   261,   261,   261,   262,   262,   262,   263,   263,
     264,   264,   265,   265,   265,   266,   266,   267,   267,   267,
     268,   268,   269,   269,   270,   270,   271,   271,   271,   271,
     272,   273,   271,   274,   274,   274,   274,   274,   275,   275,
     276,   277,   277,   278,   278,   279,   279,   280,   281,   281,
     282,   282,   283,   283,   283,   283,   283,   285,   284,   286,
     284,   287,   287,   288,   288,   289,   289,   290,   290,   290,
     290,   290,   290,   290,   290,   291,   291,   291,   291,   292,
     292,   292,   292,   293,   293,   293,   294,   294,   295,   296,
     296,   296,   297,   297,   297,   297,   297,   297,   298,   299,
     299,   300,   300
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
       1,     1,     1,     1,     1,     1,     1,     1,     4,     1,
       1,     4,     5,     4,     2,     1,     1,     1,     2,     3,
       3,     1,     2,     1,     2,     1,     1,     2,     2,     1,
       3,     1,     2,     0,     4,     1,     3,     1,     2,     0,
       4,     0,     5,     0,     6,     2,     1,     3,     1,     3,
       1,     1,     1,     2,     2,     1,     3,     4,     0,     5,
       1,     3,     4,     0,     5,     1,     1,     1,     2,     2,
       3,     0,     1,     1,     2,     1,     3,     0,     1,     1,
       3,     2,     1,     2,     1,     3,     1,     1,     2,     2,
       1,     2,     1,     2,     3,     3,     4,     0,     4,     0,
       5,     1,     2,     3,     4,     1,     3,     1,     1,     0,
       2,     1,     1,     1,     1,     5,     7,     3,     4,     3,
       3,     4,     1,     2,     0,     1,     1,     2,     1,     4,
       1,     2,     2,     2,     1,     2,     2,     0,     1,     2,
       5,     7,     5,     7,     1,     2,     2,     0,     3,     5,
       7,     9,     3,     2,     2,     3,     3,     2,     2,     0,
       1,     1,     2,     1,     1,     1,     0,     4,     1,     2,
       2,     1,     1,     1,     1,     1,     1,     1,     1,     0,
       3,     4,     3,     4,     0,     1,     8,     0,     0,    11,
       5,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     0,     2,     4,     1,     1,
       0,     1,     0,     1,     4,     1,     3,     1,     2,     4,
       0,     4,     0,     1,     1,     2,     1,     1,     1,     3,
       0,     0,     6,     4,     6,     7,     9,    18,     1,     2,
       2,     0,     3,     2,     3,     1,     2,     3,     1,     2,
       1,     3,     6,     6,     8,     8,    10,     0,     3,     0,
       3,     5,     7,     0,     1,     1,     4,     1,     1,     1,
       1,     1,     1,     4,     4,     1,     1,     1,     1,     1,
       2,     2,     2,     4,     3,     1,     1,     2,     7,     1,
       3,     3,     1,     4,     5,     4,     3,     3,     1,     1,
       3,     1,     1
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
#line 108 "rttgram.y"
                  {(yyval.n) = sym_node((yyvsp[0].t));}
#line 2613 "rttparse.c"
    break;

  case 3: /* primary_expr: StrLit  */
#line 109 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2619 "rttparse.c"
    break;

  case 4: /* primary_expr: LStrLit  */
#line 110 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2625 "rttparse.c"
    break;

  case 5: /* primary_expr: FltConst  */
#line 111 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2631 "rttparse.c"
    break;

  case 6: /* primary_expr: DblConst  */
#line 112 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2637 "rttparse.c"
    break;

  case 7: /* primary_expr: LDblConst  */
#line 113 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2643 "rttparse.c"
    break;

  case 8: /* primary_expr: CharConst  */
#line 114 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2649 "rttparse.c"
    break;

  case 9: /* primary_expr: LCharConst  */
#line 115 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2655 "rttparse.c"
    break;

  case 10: /* primary_expr: IntConst  */
#line 116 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2661 "rttparse.c"
    break;

  case 11: /* primary_expr: UIntConst  */
#line 117 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2667 "rttparse.c"
    break;

  case 12: /* primary_expr: LIntConst  */
#line 118 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2673 "rttparse.c"
    break;

  case 13: /* primary_expr: ULIntConst  */
#line 119 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2679 "rttparse.c"
    break;

  case 14: /* primary_expr: '(' expr ')'  */
#line 120 "rttgram.y"
                  {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 2685 "rttparse.c"
    break;

  case 16: /* postfix_expr: postfix_expr '[' expr ']'  */
#line 125 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                        free_t((yyvsp[0].t));}
#line 2692 "rttparse.c"
    break;

  case 17: /* postfix_expr: postfix_expr '(' ')'  */
#line 127 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), NULL);
                                        free_t((yyvsp[-1].t));}
#line 2699 "rttparse.c"
    break;

  case 18: /* postfix_expr: postfix_expr '(' arg_expr_lst ')'  */
#line 129 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                        free_t((yyvsp[-2].t));}
#line 2706 "rttparse.c"
    break;

  case 19: /* postfix_expr: postfix_expr '.' any_ident  */
#line 131 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2712 "rttparse.c"
    break;

  case 20: /* postfix_expr: postfix_expr Arrow any_ident  */
#line 132 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2718 "rttparse.c"
    break;

  case 21: /* postfix_expr: postfix_expr Incr  */
#line 133 "rttgram.y"
                                       {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-1].n));}
#line 2724 "rttparse.c"
    break;

  case 22: /* postfix_expr: postfix_expr Decr  */
#line 134 "rttgram.y"
                                       {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-1].n));}
#line 2730 "rttparse.c"
    break;

  case 23: /* postfix_expr: Is ':' i_type_name '(' assign_expr ')'  */
#line 136 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-5].t), (yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 2736 "rttparse.c"
    break;

  case 24: /* postfix_expr: Cnv ':' dest_type '(' assign_expr ',' assign_expr ')'  */
#line 138 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-7].t), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-6].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 2743 "rttparse.c"
    break;

  case 25: /* postfix_expr: Def ':' dest_type '(' assign_expr ',' assign_expr ',' assign_expr ')'  */
#line 141 "rttgram.y"
      {(yyval.n) = node4(QuadNd, (yyvsp[-9].t), (yyvsp[-7].n), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-8].t)); free_t((yyvsp[-6].t));
       free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 2750 "rttparse.c"
    break;

  case 27: /* arg_expr_lst: arg_expr_lst ',' assign_expr  */
#line 147 "rttgram.y"
                                  {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2756 "rttparse.c"
    break;

  case 29: /* unary_expr: Incr unary_expr  */
#line 152 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2762 "rttparse.c"
    break;

  case 30: /* unary_expr: Decr unary_expr  */
#line 153 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2768 "rttparse.c"
    break;

  case 31: /* unary_expr: unary_op cast_expr  */
#line 154 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2774 "rttparse.c"
    break;

  case 32: /* unary_expr: Sizeof unary_expr  */
#line 155 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2780 "rttparse.c"
    break;

  case 33: /* unary_expr: Sizeof '(' type_name ')'  */
#line 156 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                               free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 2787 "rttparse.c"
    break;

  case 34: /* unary_expr: Offsetof '(' type_name ',' identifier ')'  */
#line 163 "rttgram.y"
      {(yyval.n) = node1(PrefxNd, (yyvsp[-5].t),
                   node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), node0(PrimryNd, (yyvsp[-1].t))));
       free_t((yyvsp[-4].t)); free_t((yyvsp[0].t));}
#line 2795 "rttparse.c"
    break;

  case 42: /* cast_expr: '(' type_name ')' cast_expr  */
#line 179 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-3].t), (yyvsp[-2].n), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 2801 "rttparse.c"
    break;

  case 44: /* multiplicative_expr: multiplicative_expr '*' cast_expr  */
#line 184 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2807 "rttparse.c"
    break;

  case 45: /* multiplicative_expr: multiplicative_expr '/' cast_expr  */
#line 185 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2813 "rttparse.c"
    break;

  case 46: /* multiplicative_expr: multiplicative_expr '%' cast_expr  */
#line 186 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2819 "rttparse.c"
    break;

  case 48: /* additive_expr: additive_expr '+' multiplicative_expr  */
#line 191 "rttgram.y"
                                           {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2825 "rttparse.c"
    break;

  case 49: /* additive_expr: additive_expr '-' multiplicative_expr  */
#line 192 "rttgram.y"
                                           {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2831 "rttparse.c"
    break;

  case 51: /* shift_expr: shift_expr LShft additive_expr  */
#line 197 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2837 "rttparse.c"
    break;

  case 52: /* shift_expr: shift_expr RShft additive_expr  */
#line 198 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2843 "rttparse.c"
    break;

  case 54: /* relational_expr: relational_expr '<' shift_expr  */
#line 203 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2849 "rttparse.c"
    break;

  case 55: /* relational_expr: relational_expr '>' shift_expr  */
#line 204 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2855 "rttparse.c"
    break;

  case 56: /* relational_expr: relational_expr Leq shift_expr  */
#line 205 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2861 "rttparse.c"
    break;

  case 57: /* relational_expr: relational_expr Geq shift_expr  */
#line 206 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2867 "rttparse.c"
    break;

  case 59: /* equality_expr: equality_expr Equal relational_expr  */
#line 211 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2873 "rttparse.c"
    break;

  case 60: /* equality_expr: equality_expr Neq relational_expr  */
#line 212 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2879 "rttparse.c"
    break;

  case 62: /* and_expr: and_expr '&' equality_expr  */
#line 217 "rttgram.y"
                                {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2885 "rttparse.c"
    break;

  case 64: /* exclusive_or_expr: exclusive_or_expr '^' and_expr  */
#line 222 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2891 "rttparse.c"
    break;

  case 66: /* inclusive_or_expr: inclusive_or_expr '|' exclusive_or_expr  */
#line 227 "rttgram.y"
                                             {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2897 "rttparse.c"
    break;

  case 68: /* logical_and_expr: logical_and_expr And inclusive_or_expr  */
#line 232 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2903 "rttparse.c"
    break;

  case 70: /* logical_or_expr: logical_or_expr Or logical_and_expr  */
#line 237 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2909 "rttparse.c"
    break;

  case 72: /* conditional_expr: logical_or_expr '?' expr ':' conditional_expr  */
#line 243 "rttgram.y"
                                         {(yyval.n) = node3(TrnryNd, (yyvsp[-3].t), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n));
                                          free_t((yyvsp[-1].t));}
#line 2916 "rttparse.c"
    break;

  case 74: /* assign_expr: unary_expr assign_op assign_expr  */
#line 249 "rttgram.y"
                                      {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2922 "rttparse.c"
    break;

  case 87: /* expr: expr ',' assign_expr  */
#line 268 "rttgram.y"
                          {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2928 "rttparse.c"
    break;

  case 88: /* opt_expr: %empty  */
#line 272 "rttgram.y"
     {(yyval.n) = NULL;}
#line 2934 "rttparse.c"
    break;

  case 91: /* opt_constant_expr: %empty  */
#line 281 "rttgram.y"
     {(yyval.n) = NULL;}
#line 2940 "rttparse.c"
    break;

  case 93: /* dcltion: typ_dcltion_specs ';'  */
#line 286 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-1].n), NULL);
                                             dcl_stk->kind_dcl = OtherDcl;}
#line 2947 "rttparse.c"
    break;

  case 94: /* dcltion: typ_dcltion_specs init_dcltor_lst ';'  */
#line 288 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));
                                             dcl_stk->kind_dcl = OtherDcl;}
#line 2954 "rttparse.c"
    break;

  case 95: /* dcltion: storcl_tqual_lst no_tdn_init_dcltor_lst ';'  */
#line 291 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));
                                             dcl_stk->kind_dcl = OtherDcl;}
#line 2961 "rttparse.c"
    break;

  case 97: /* typ_dcltion_specs: storcl_tqual_lst type_ind  */
#line 297 "rttgram.y"
                               {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2967 "rttparse.c"
    break;

  case 100: /* type_ind: typedefname  */
#line 306 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2973 "rttparse.c"
    break;

  case 101: /* type_ind: typedefname storcl_tqual_lst  */
#line 308 "rttgram.y"
                             {(yyval.n) = node2(LstNd, NULL, node0(PrimryNd, (yyvsp[-1].t)), (yyvsp[0].n));}
#line 2979 "rttparse.c"
    break;

  case 104: /* type_storcl_tqual_lst: type_storcl_tqual_lst stnd_type  */
#line 314 "rttgram.y"
                                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2985 "rttparse.c"
    break;

  case 105: /* type_storcl_tqual_lst: type_storcl_tqual_lst storage_class_spec  */
#line 315 "rttgram.y"
                                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2991 "rttparse.c"
    break;

  case 106: /* type_storcl_tqual_lst: type_storcl_tqual_lst type_qual  */
#line 316 "rttgram.y"
                                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2997 "rttparse.c"
    break;

  case 109: /* storcl_tqual_lst: storcl_tqual_lst storage_class_spec  */
#line 322 "rttgram.y"
                                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3003 "rttparse.c"
    break;

  case 110: /* storcl_tqual_lst: storcl_tqual_lst type_qual  */
#line 323 "rttgram.y"
                                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3009 "rttparse.c"
    break;

  case 112: /* init_dcltor_lst: init_dcltor_lst ',' init_dcltor  */
#line 328 "rttgram.y"
                                     {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3015 "rttparse.c"
    break;

  case 114: /* no_tdn_init_dcltor_lst: no_tdn_init_dcltor_lst ',' no_tdn_init_dcltor  */
#line 334 "rttgram.y"
                                              {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3021 "rttparse.c"
    break;

  case 115: /* init_dcltor: dcltor  */
#line 338 "rttgram.y"
                            {(yyval.n) = (yyvsp[0].n); id_def((yyvsp[0].n), NULL);}
#line 3027 "rttparse.c"
    break;

  case 116: /* init_dcltor: dcltor '=' initializer  */
#line 339 "rttgram.y"
                            {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n)); id_def((yyvsp[-2].n), (yyvsp[0].n));}
#line 3033 "rttparse.c"
    break;

  case 117: /* no_tdn_init_dcltor: no_tdn_dcltor  */
#line 343 "rttgram.y"
                              {(yyval.n) = (yyvsp[0].n); id_def((yyvsp[0].n), NULL);}
#line 3039 "rttparse.c"
    break;

  case 118: /* no_tdn_init_dcltor: no_tdn_dcltor '=' initializer  */
#line 345 "rttgram.y"
                              {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n)); id_def((yyvsp[-2].n), (yyvsp[0].n));}
#line 3045 "rttparse.c"
    break;

  case 119: /* storage_class_spec: Typedef  */
#line 355 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t)); dcl_stk->kind_dcl = IsTypedef;}
#line 3051 "rttparse.c"
    break;

  case 120: /* storage_class_spec: Extern  */
#line 356 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3057 "rttparse.c"
    break;

  case 121: /* storage_class_spec: Static  */
#line 357 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3063 "rttparse.c"
    break;

  case 122: /* storage_class_spec: Thread_local  */
#line 358 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3069 "rttparse.c"
    break;

  case 123: /* storage_class_spec: Auto  */
#line 359 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3075 "rttparse.c"
    break;

  case 124: /* storage_class_spec: Register  */
#line 360 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3081 "rttparse.c"
    break;

  case 125: /* storage_class_spec: Inline  */
#line 365 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3087 "rttparse.c"
    break;

  case 126: /* storage_class_spec: Declspec '(' identifier ')'  */
#line 366 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[0].t),
                                             node0(PrimryNd, (yyvsp[-3].t)),
                                             node0(PrimryNd, (yyvsp[-1].t)));
                                  free_t((yyvsp[-2].t));}
#line 3096 "rttparse.c"
    break;

  case 128: /* type_spec: typedefname  */
#line 374 "rttgram.y"
                 {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3102 "rttparse.c"
    break;

  case 129: /* stnd_type: Void  */
#line 378 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3108 "rttparse.c"
    break;

  case 130: /* stnd_type: Char  */
#line 379 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3114 "rttparse.c"
    break;

  case 131: /* stnd_type: Short  */
#line 380 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3120 "rttparse.c"
    break;

  case 132: /* stnd_type: Int  */
#line 381 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3126 "rttparse.c"
    break;

  case 133: /* stnd_type: Long  */
#line 382 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3132 "rttparse.c"
    break;

  case 134: /* stnd_type: Float  */
#line 383 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3138 "rttparse.c"
    break;

  case 135: /* stnd_type: Doubl  */
#line 384 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3144 "rttparse.c"
    break;

  case 136: /* stnd_type: Signed  */
#line 385 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3150 "rttparse.c"
    break;

  case 137: /* stnd_type: Unsigned  */
#line 386 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3156 "rttparse.c"
    break;

  case 138: /* stnd_type: Atomic '(' type_name ')'  */
#line 388 "rttgram.y"
                           {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                            free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3163 "rttparse.c"
    break;

  case 141: /* stnd_type: B_IProc_Type '(' constant_expr ')'  */
#line 392 "rttgram.y"
                                        {(yyval.n) = node2(BinryNd, (yyvsp[0].t),
                                                    node0(PrimryNd, (yyvsp[-3].t)), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t));}
#line 3171 "rttparse.c"
    break;

  case 142: /* struct_or_union_spec: struct_or_union any_ident '{' struct_dcltion_lst '}'  */
#line 399 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                             free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3178 "rttparse.c"
    break;

  case 143: /* struct_or_union_spec: struct_or_union '{' struct_dcltion_lst '}'  */
#line 402 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-3].t), NULL, (yyvsp[-1].n));
                                             free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3185 "rttparse.c"
    break;

  case 144: /* struct_or_union_spec: struct_or_union any_ident  */
#line 404 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[0].n), NULL);}
#line 3191 "rttparse.c"
    break;

  case 148: /* struct_dcltion_lst: struct_dcltion_lst struct_dcltion  */
#line 414 "rttgram.y"
                                       {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3197 "rttparse.c"
    break;

  case 149: /* struct_dcltion: struct_dcltion_specs struct_dcltor_lst ';'  */
#line 419 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));}
#line 3203 "rttparse.c"
    break;

  case 150: /* struct_dcltion: tqual_lst struct_no_tdn_dcltor_lst ';'  */
#line 420 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));}
#line 3209 "rttparse.c"
    break;

  case 152: /* struct_dcltion_specs: tqual_lst struct_type_ind  */
#line 425 "rttgram.y"
                                {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3215 "rttparse.c"
    break;

  case 153: /* struct_type_ind: typedefname  */
#line 429 "rttgram.y"
                            {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3221 "rttparse.c"
    break;

  case 154: /* struct_type_ind: typedefname tqual_lst  */
#line 430 "rttgram.y"
                            {(yyval.n) = node2(LstNd, NULL, node0(PrimryNd, (yyvsp[-1].t)), (yyvsp[0].n));}
#line 3227 "rttparse.c"
    break;

  case 157: /* struct_type_lst: struct_type_lst stnd_type  */
#line 436 "rttgram.y"
                               {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3233 "rttparse.c"
    break;

  case 158: /* struct_type_lst: struct_type_lst type_qual  */
#line 437 "rttgram.y"
                               {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3239 "rttparse.c"
    break;

  case 160: /* struct_dcltor_lst: struct_dcltor_lst ',' struct_dcltor  */
#line 441 "rttgram.y"
                                         {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3245 "rttparse.c"
    break;

  case 161: /* struct_dcltor: dcltor  */
#line 445 "rttgram.y"
                              {(yyval.n) = node2(StrDclNd, NULL, (yyvsp[0].n), NULL);
                               if (dcl_stk->parms_done) pop_cntxt();}
#line 3252 "rttparse.c"
    break;

  case 162: /* struct_dcltor: ':' constant_expr  */
#line 447 "rttgram.y"
                              {(yyval.n) = node2(StrDclNd, (yyvsp[-1].t), NULL, (yyvsp[0].n));}
#line 3258 "rttparse.c"
    break;

  case 163: /* $@1: %empty  */
#line 448 "rttgram.y"
                {if (dcl_stk->parms_done) pop_cntxt();}
#line 3264 "rttparse.c"
    break;

  case 164: /* struct_dcltor: dcltor ':' $@1 constant_expr  */
#line 449 "rttgram.y"
                              {(yyval.n) = node2(StrDclNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[0].n));}
#line 3270 "rttparse.c"
    break;

  case 166: /* struct_no_tdn_dcltor_lst: struct_no_tdn_dcltor_lst ',' struct_no_tdn_dcltor  */
#line 455 "rttgram.y"
                                              {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3276 "rttparse.c"
    break;

  case 167: /* struct_no_tdn_dcltor: no_tdn_dcltor  */
#line 459 "rttgram.y"
                                     {(yyval.n) = node2(StrDclNd, NULL, (yyvsp[0].n), NULL);
                                      if (dcl_stk->parms_done) pop_cntxt();}
#line 3283 "rttparse.c"
    break;

  case 168: /* struct_no_tdn_dcltor: ':' constant_expr  */
#line 461 "rttgram.y"
                                     {(yyval.n) = node2(StrDclNd, (yyvsp[-1].t), NULL, (yyvsp[0].n));}
#line 3289 "rttparse.c"
    break;

  case 169: /* $@2: %empty  */
#line 462 "rttgram.y"
                       {if (dcl_stk->parms_done) pop_cntxt();}
#line 3295 "rttparse.c"
    break;

  case 170: /* struct_no_tdn_dcltor: no_tdn_dcltor ':' $@2 constant_expr  */
#line 463 "rttgram.y"
                                     {(yyval.n) = node2(StrDclNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[0].n));}
#line 3301 "rttparse.c"
    break;

  case 171: /* $@3: %empty  */
#line 467 "rttgram.y"
          {push_cntxt(0);}
#line 3307 "rttparse.c"
    break;

  case 172: /* enum_spec: Enum $@3 '{' enumerator_lst '}'  */
#line 468 "rttgram.y"
       {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), NULL, (yyvsp[-1].n)); pop_cntxt(); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3313 "rttparse.c"
    break;

  case 173: /* $@4: %empty  */
#line 469 "rttgram.y"
                    {push_cntxt(0);}
#line 3319 "rttparse.c"
    break;

  case 174: /* enum_spec: Enum any_ident $@4 '{' enumerator_lst '}'  */
#line 470 "rttgram.y"
       {(yyval.n) = node2(BinryNd, (yyvsp[-5].t), (yyvsp[-4].n),  (yyvsp[-1].n)); pop_cntxt(); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3325 "rttparse.c"
    break;

  case 175: /* enum_spec: Enum any_ident  */
#line 471 "rttgram.y"
                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[0].n),  NULL);}
#line 3331 "rttparse.c"
    break;

  case 177: /* enumerator_lst: enumerator_lst ',' enumerator  */
#line 476 "rttgram.y"
                                   {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3337 "rttparse.c"
    break;

  case 178: /* enumerator: any_ident  */
#line 480 "rttgram.y"
                              {(yyval.n) = (yyvsp[0].n); id_def((yyvsp[0].n), NULL);}
#line 3343 "rttparse.c"
    break;

  case 179: /* enumerator: any_ident '=' constant_expr  */
#line 482 "rttgram.y"
                              {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n)); id_def((yyvsp[-2].n), (yyvsp[0].n));}
#line 3349 "rttparse.c"
    break;

  case 180: /* type_qual: Const  */
#line 486 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3355 "rttparse.c"
    break;

  case 181: /* type_qual: Volatile  */
#line 487 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3361 "rttparse.c"
    break;

  case 182: /* type_qual: Atomic  */
#line 488 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3367 "rttparse.c"
    break;

  case 183: /* dcltor: opt_pointer direct_dcltor  */
#line 493 "rttgram.y"
                                {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3373 "rttparse.c"
    break;

  case 184: /* no_tdn_dcltor: opt_pointer no_tdn_direct_dcltor  */
#line 497 "rttgram.y"
                                      {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3379 "rttparse.c"
    break;

  case 186: /* direct_dcltor: '(' dcltor ')'  */
#line 502 "rttgram.y"
                                              {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3386 "rttparse.c"
    break;

  case 187: /* direct_dcltor: direct_dcltor '[' opt_constant_expr ']'  */
#line 504 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3393 "rttparse.c"
    break;

  case 188: /* $@5: %empty  */
#line 506 "rttgram.y"
                       {push_cntxt(1);}
#line 3399 "rttparse.c"
    break;

  case 189: /* direct_dcltor: direct_dcltor '(' $@5 parm_dcls_or_ids ')'  */
#line 507 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                               if (dcl_stk->nest_lvl == 2)
                                                  dcl_stk->parms_done = 1;
                                                else
                                                  pop_cntxt();
                                               free_t((yyvsp[-3].t));}
#line 3410 "rttparse.c"
    break;

  case 190: /* no_tdn_direct_dcltor: identifier  */
#line 516 "rttgram.y"
                                              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3416 "rttparse.c"
    break;

  case 191: /* no_tdn_direct_dcltor: '(' no_tdn_dcltor ')'  */
#line 517 "rttgram.y"
                                              {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3423 "rttparse.c"
    break;

  case 192: /* no_tdn_direct_dcltor: no_tdn_direct_dcltor '[' opt_constant_expr ']'  */
#line 520 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3430 "rttparse.c"
    break;

  case 193: /* $@6: %empty  */
#line 522 "rttgram.y"
                              {push_cntxt(1);}
#line 3436 "rttparse.c"
    break;

  case 194: /* no_tdn_direct_dcltor: no_tdn_direct_dcltor '(' $@6 parm_dcls_or_ids ')'  */
#line 523 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                               if (dcl_stk->nest_lvl == 2)
                                                  dcl_stk->parms_done = 1;
                                                else
                                                  pop_cntxt();
                                               free_t((yyvsp[-3].t));}
#line 3447 "rttparse.c"
    break;

  case 197: /* pointer: '*'  */
#line 537 "rttgram.y"
                           {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3453 "rttparse.c"
    break;

  case 198: /* pointer: '*' tqual_lst  */
#line 538 "rttgram.y"
                           {(yyval.n) = node1(PreSpcNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 3459 "rttparse.c"
    break;

  case 199: /* pointer: '*' pointer  */
#line 539 "rttgram.y"
                           {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 3465 "rttparse.c"
    break;

  case 200: /* pointer: '*' tqual_lst pointer  */
#line 540 "rttgram.y"
                           {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), node2(LstNd, NULL, (yyvsp[-1].n),(yyvsp[0].n)));}
#line 3471 "rttparse.c"
    break;

  case 201: /* opt_pointer: %empty  */
#line 544 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3477 "rttparse.c"
    break;

  case 204: /* tqual_lst: tqual_lst type_qual  */
#line 550 "rttgram.y"
                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3483 "rttparse.c"
    break;

  case 206: /* param_type_lst: param_lst ',' Ellipsis  */
#line 555 "rttgram.y"
                            {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), node0(PrimryNd, (yyvsp[0].t)));}
#line 3489 "rttparse.c"
    break;

  case 207: /* opt_param_type_lst: %empty  */
#line 559 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3495 "rttparse.c"
    break;

  case 210: /* param_lst: param_lst ',' param_dcltion  */
#line 565 "rttgram.y"
                                 {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3501 "rttparse.c"
    break;

  case 211: /* param_dcltion: dcltion_specs no_tdn_dcltor  */
#line 569 "rttgram.y"
                                   {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));
                                    id_def((yyvsp[0].n), NULL);}
#line 3508 "rttparse.c"
    break;

  case 213: /* param_dcltion: dcltion_specs abstract_dcltor  */
#line 572 "rttgram.y"
                                   {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3514 "rttparse.c"
    break;

  case 214: /* ident_lst: identifier  */
#line 576 "rttgram.y"
                              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3520 "rttparse.c"
    break;

  case 215: /* ident_lst: ident_lst ',' identifier  */
#line 577 "rttgram.y"
                              {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), node0(PrimryNd,(yyvsp[0].t)));}
#line 3526 "rttparse.c"
    break;

  case 218: /* type_tqual_lst: type_spec type_tqual_lst  */
#line 583 "rttgram.y"
                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3532 "rttparse.c"
    break;

  case 219: /* type_tqual_lst: type_qual type_tqual_lst  */
#line 584 "rttgram.y"
                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3538 "rttparse.c"
    break;

  case 221: /* type_name: type_tqual_lst abstract_dcltor  */
#line 589 "rttgram.y"
                                    {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3544 "rttparse.c"
    break;

  case 223: /* abstract_dcltor: opt_pointer direct_abstract_dcltor  */
#line 594 "rttgram.y"
                                        {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3550 "rttparse.c"
    break;

  case 224: /* direct_abstract_dcltor: '(' abstract_dcltor ')'  */
#line 598 "rttgram.y"
                                            {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n));
                                             free_t((yyvsp[0].t));}
#line 3557 "rttparse.c"
    break;

  case 225: /* direct_abstract_dcltor: '[' opt_constant_expr ']'  */
#line 601 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), NULL, (yyvsp[-1].n));
                                             free_t((yyvsp[0].t));}
#line 3564 "rttparse.c"
    break;

  case 226: /* direct_abstract_dcltor: direct_abstract_dcltor '[' opt_constant_expr ']'  */
#line 604 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                             free_t((yyvsp[0].t));}
#line 3571 "rttparse.c"
    break;

  case 227: /* $@7: %empty  */
#line 606 "rttgram.y"
                                {push_cntxt(1);}
#line 3577 "rttparse.c"
    break;

  case 228: /* direct_abstract_dcltor: '(' $@7 opt_param_type_lst ')'  */
#line 607 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), NULL, (yyvsp[-1].n));
                                             pop_cntxt();
                                             free_t((yyvsp[-3].t));}
#line 3585 "rttparse.c"
    break;

  case 229: /* $@8: %empty  */
#line 610 "rttgram.y"
                                {push_cntxt(1);}
#line 3591 "rttparse.c"
    break;

  case 230: /* direct_abstract_dcltor: direct_abstract_dcltor '(' $@8 opt_param_type_lst ')'  */
#line 611 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                             pop_cntxt();
                                             free_t((yyvsp[-3].t));}
#line 3599 "rttparse.c"
    break;

  case 232: /* initializer: '{' '}'  */
#line 618 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), NULL); free_t((yyvsp[0].t));}
#line 3605 "rttparse.c"
    break;

  case 233: /* initializer: '{' initializer_lst '}'  */
#line 620 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3611 "rttparse.c"
    break;

  case 234: /* initializer: '{' initializer_lst ',' '}'  */
#line 622 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), NULL));
                          free_t((yyvsp[0].t));}
#line 3618 "rttparse.c"
    break;

  case 236: /* initializer_lst: initializer_lst ',' initializer  */
#line 628 "rttgram.y"
                                     {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3624 "rttparse.c"
    break;

  case 239: /* $@9: %empty  */
#line 637 "rttgram.y"
     {push_cntxt(1);}
#line 3630 "rttparse.c"
    break;

  case 240: /* non_lbl_stmt: $@9 compound_stmt  */
#line 637 "rttgram.y"
                                    {(yyval.n) = (yyvsp[0].n); pop_cntxt();}
#line 3636 "rttparse.c"
    break;

  case 245: /* non_lbl_stmt: Runerr '(' assign_expr ')' ';'  */
#line 643 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-2].n), NULL); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3642 "rttparse.c"
    break;

  case 246: /* non_lbl_stmt: Runerr '(' assign_expr ',' assign_expr ')' ';'  */
#line 645 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-6].t), (yyvsp[-4].n), (yyvsp[-2].n)); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3648 "rttparse.c"
    break;

  case 247: /* labeled_stmt: label ':' stmt  */
#line 649 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3654 "rttparse.c"
    break;

  case 248: /* labeled_stmt: Case constant_expr ':' stmt  */
#line 650 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-3].t), (yyvsp[-2].n), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 3660 "rttparse.c"
    break;

  case 249: /* labeled_stmt: Default ':' stmt  */
#line 651 "rttgram.y"
                                 {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 3666 "rttparse.c"
    break;

  case 250: /* compound_stmt: '{' opt_stmt_lst '}'  */
#line 655 "rttgram.y"
                                     {(yyval.n) = comp_nd((yyvsp[-2].t), NULL, (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3672 "rttparse.c"
    break;

  case 251: /* compound_stmt: '{' local_dcls opt_stmt_lst '}'  */
#line 656 "rttgram.y"
                                     {(yyval.n) = comp_nd((yyvsp[-3].t), (yyvsp[-2].n),   (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3678 "rttparse.c"
    break;

  case 253: /* dcltion_lst: dcltion_lst dcltion  */
#line 661 "rttgram.y"
                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3684 "rttparse.c"
    break;

  case 254: /* opt_dcltion_lst: %empty  */
#line 665 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3690 "rttparse.c"
    break;

  case 257: /* local_dcls: local_dcls local_dcl  */
#line 671 "rttgram.y"
                          {(yyval.n) = ((yyvsp[0].n) == NULL ? (yyvsp[-1].n) : node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n)));}
#line 3696 "rttparse.c"
    break;

  case 259: /* local_dcl: Tended tended_type init_dcltor_lst ';'  */
#line 677 "rttgram.y"
             {(yyval.n) = NULL; free_t((yyvsp[-3].t)); free_t((yyvsp[0].t)); dcl_stk->kind_dcl = OtherDcl;}
#line 3702 "rttparse.c"
    break;

  case 260: /* tended_type: Char  */
#line 681 "rttgram.y"
                        {tnd_char(); free_t((yyvsp[0].t));}
#line 3708 "rttparse.c"
    break;

  case 261: /* tended_type: Struct identifier  */
#line 682 "rttgram.y"
                        {tnd_strct((yyvsp[0].t)); free_t((yyvsp[-1].t));}
#line 3714 "rttparse.c"
    break;

  case 262: /* tended_type: Struct TypeDefName  */
#line 683 "rttgram.y"
                        {tnd_strct((yyvsp[0].t)); free_t((yyvsp[-1].t));}
#line 3720 "rttparse.c"
    break;

  case 263: /* tended_type: Union identifier  */
#line 684 "rttgram.y"
                        {tnd_union((yyvsp[0].t)); free_t((yyvsp[-1].t));}
#line 3726 "rttparse.c"
    break;

  case 265: /* stmt_lst: stmt_lst stmt  */
#line 689 "rttgram.y"
                   {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3732 "rttparse.c"
    break;

  case 266: /* stmt_lst: stmt_lst local_dcl  */
#line 690 "rttgram.y"
                        {(yyval.n) = ((yyvsp[0].n) == NULL ? (yyvsp[-1].n) : node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n)));}
#line 3738 "rttparse.c"
    break;

  case 267: /* opt_stmt_lst: %empty  */
#line 694 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3744 "rttparse.c"
    break;

  case 269: /* expr_stmt: opt_expr ';'  */
#line 698 "rttgram.y"
                  {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-1].n));}
#line 3750 "rttparse.c"
    break;

  case 270: /* selection_stmt: If '(' expr ')' stmt  */
#line 702 "rttgram.y"
                                         {(yyval.n) = node3(TrnryNd, (yyvsp[-4].t), (yyvsp[-2].n), (yyvsp[0].n),NULL);
                                          free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3757 "rttparse.c"
    break;

  case 271: /* selection_stmt: If '(' expr ')' stmt Else stmt  */
#line 704 "rttgram.y"
                                         {(yyval.n) = node3(TrnryNd, (yyvsp[-6].t), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n));
                                          free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3764 "rttparse.c"
    break;

  case 272: /* selection_stmt: Switch '(' expr ')' stmt  */
#line 706 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-2].n), (yyvsp[0].n));
                                          free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3771 "rttparse.c"
    break;

  case 273: /* selection_stmt: Type_case expr Of '{' c_type_select_lst c_opt_default '}'  */
#line 709 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-6].t), (yyvsp[-5].n), (yyvsp[-2].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[0].t));}
#line 3777 "rttparse.c"
    break;

  case 274: /* c_type_select_lst: c_type_select  */
#line 713 "rttgram.y"
                                     {(yyval.n) = node2(ConCatNd, NULL, NULL, (yyvsp[0].n));}
#line 3783 "rttparse.c"
    break;

  case 275: /* c_type_select_lst: c_type_select_lst c_type_select  */
#line 714 "rttgram.y"
                                     {(yyval.n) = node2(ConCatNd, NULL,   (yyvsp[-1].n), (yyvsp[0].n));}
#line 3789 "rttparse.c"
    break;

  case 276: /* c_type_select: selector_lst non_lbl_stmt  */
#line 718 "rttgram.y"
                               {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3795 "rttparse.c"
    break;

  case 277: /* c_opt_default: %empty  */
#line 722 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3801 "rttparse.c"
    break;

  case 278: /* c_opt_default: Default ':' non_lbl_stmt  */
#line 723 "rttgram.y"
                              {(yyval.n) = (yyvsp[0].n); free_t((yyvsp[-2].t)); free_t((yyvsp[-1].t));}
#line 3807 "rttparse.c"
    break;

  case 279: /* iteration_stmt: While '(' expr ')' stmt  */
#line 727 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-2].n), (yyvsp[0].n));
                                        free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3814 "rttparse.c"
    break;

  case 280: /* iteration_stmt: Do stmt While '(' expr ')' ';'  */
#line 729 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-6].t), (yyvsp[-5].n), (yyvsp[-2].n));
                                        free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));
                                        free_t((yyvsp[0].t));}
#line 3822 "rttparse.c"
    break;

  case 281: /* iteration_stmt: For '(' opt_expr ';' opt_expr ';' opt_expr ')' stmt  */
#line 733 "rttgram.y"
                                       {(yyval.n) = node4(QuadNd, (yyvsp[-8].t), (yyvsp[-6].n), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n));
                                        free_t((yyvsp[-7].t)); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t));
                                        free_t((yyvsp[-1].t));}
#line 3830 "rttparse.c"
    break;

  case 282: /* jump_stmt: Goto label ';'  */
#line 739 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3836 "rttparse.c"
    break;

  case 283: /* jump_stmt: Continue ';'  */
#line 740 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3842 "rttparse.c"
    break;

  case 284: /* jump_stmt: Break ';'  */
#line 741 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3848 "rttparse.c"
    break;

  case 285: /* jump_stmt: Return ret_val ';'  */
#line 742 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3854 "rttparse.c"
    break;

  case 286: /* jump_stmt: Suspend ret_val ';'  */
#line 743 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3860 "rttparse.c"
    break;

  case 287: /* jump_stmt: Fail ';'  */
#line 744 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3866 "rttparse.c"
    break;

  case 288: /* jump_stmt: Errorfail ';'  */
#line 745 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3872 "rttparse.c"
    break;

  case 294: /* external_dcltion: dcltion  */
#line 760 "rttgram.y"
                            {dclout((yyvsp[0].n));}
#line 3878 "rttparse.c"
    break;

  case 296: /* $@10: %empty  */
#line 765 "rttgram.y"
               {func_def((yyvsp[0].n));}
#line 3884 "rttparse.c"
    break;

  case 297: /* function_definition: func_head $@10 opt_dcltion_lst compound_stmt  */
#line 766 "rttgram.y"
                                                          {fncout((yyvsp[-3].n), (yyvsp[-1].n), (yyvsp[0].n));}
#line 3890 "rttparse.c"
    break;

  case 298: /* func_head: no_tdn_dcltor  */
#line 770 "rttgram.y"
                                     {(yyval.n) = node2(LstNd, NULL, NULL, (yyvsp[0].n));}
#line 3896 "rttparse.c"
    break;

  case 299: /* func_head: storcl_tqual_lst no_tdn_dcltor  */
#line 771 "rttgram.y"
                                     {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3902 "rttparse.c"
    break;

  case 300: /* func_head: typ_dcltion_specs dcltor  */
#line 772 "rttgram.y"
                                     {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3908 "rttparse.c"
    break;

  case 301: /* any_ident: identifier  */
#line 776 "rttgram.y"
                 {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3914 "rttparse.c"
    break;

  case 302: /* any_ident: typedefname  */
#line 777 "rttgram.y"
                 {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3920 "rttparse.c"
    break;

  case 303: /* label: identifier  */
#line 781 "rttgram.y"
                 {(yyval.n) = lbl((yyvsp[0].t));}
#line 3926 "rttparse.c"
    break;

  case 304: /* label: typedefname  */
#line 782 "rttgram.y"
                 {(yyval.n) = lbl((yyvsp[0].t));}
#line 3932 "rttparse.c"
    break;

  case 309: /* $@11: %empty  */
#line 797 "rttgram.y"
     {strt_def();}
#line 3938 "rttparse.c"
    break;

  case 311: /* operation: fnc_oper op_declare actions End  */
#line 801 "rttgram.y"
                                     {defout((yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3944 "rttparse.c"
    break;

  case 312: /* operation: keyword actions End  */
#line 802 "rttgram.y"
                                     {defout((yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3950 "rttparse.c"
    break;

  case 313: /* operation: keyword Constant key_const End  */
#line 803 "rttgram.y"
                                     {keyconst((yyvsp[-1].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3956 "rttparse.c"
    break;

  case 314: /* description: %empty  */
#line 807 "rttgram.y"
             {comment = NULL;}
#line 3962 "rttparse.c"
    break;

  case 315: /* description: StrLit  */
#line 808 "rttgram.y"
             {comment = (yyvsp[0].t);}
#line 3968 "rttparse.c"
    break;

  case 316: /* fnc_oper: Function '{' result_seq '}' op_name '(' opt_s_parm_lst ')'  */
#line 813 "rttgram.y"
      {impl_fnc((yyvsp[-3].t)); free_t((yyvsp[-7].t)); free_t((yyvsp[-6].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 3975 "rttparse.c"
    break;

  case 317: /* $@12: %empty  */
#line 815 "rttgram.y"
                             {lex_state = OpHead;}
#line 3981 "rttparse.c"
    break;

  case 318: /* $@13: %empty  */
#line 816 "rttgram.y"
      {lex_state = DfltLex;}
#line 3987 "rttparse.c"
    break;

  case 319: /* fnc_oper: Operator '{' result_seq $@12 '}' OpSym $@13 op_name '(' opt_s_parm_lst ')'  */
#line 817 "rttgram.y"
      {impl_op((yyvsp[-5].t), (yyvsp[-3].t)); free_t((yyvsp[-10].t)); free_t((yyvsp[-9].t)); free_t((yyvsp[-6].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 3994 "rttparse.c"
    break;

  case 320: /* keyword: Keyword '{' result_seq '}' op_name  */
#line 822 "rttgram.y"
       {impl_key((yyvsp[0].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4000 "rttparse.c"
    break;

  case 395: /* result_seq: %empty  */
#line 915 "rttgram.y"
                                {set_r_seq(NoRsltSeq, NoRsltSeq, 0);}
#line 4006 "rttparse.c"
    break;

  case 396: /* result_seq: length opt_plus  */
#line 916 "rttgram.y"
                                {set_r_seq((yyvsp[-1].i), (yyvsp[-1].i), (int)(yyvsp[0].i));}
#line 4012 "rttparse.c"
    break;

  case 397: /* result_seq: length ',' length opt_plus  */
#line 917 "rttgram.y"
                                {set_r_seq((yyvsp[-3].i), (yyvsp[-1].i), (int)(yyvsp[0].i)); free_t((yyvsp[-2].t));}
#line 4018 "rttparse.c"
    break;

  case 398: /* length: IntConst  */
#line 921 "rttgram.y"
              {(yyval.i) = ttol((yyvsp[0].t)); free_t((yyvsp[0].t));}
#line 4024 "rttparse.c"
    break;

  case 399: /* length: '*'  */
#line 922 "rttgram.y"
              {(yyval.i) = UnbndSeq; free_t((yyvsp[0].t));}
#line 4030 "rttparse.c"
    break;

  case 400: /* opt_plus: %empty  */
#line 926 "rttgram.y"
         {(yyval.i) = 0;}
#line 4036 "rttparse.c"
    break;

  case 401: /* opt_plus: '+'  */
#line 927 "rttgram.y"
         {(yyval.i) = 1; free_t((yyvsp[0].t));}
#line 4042 "rttparse.c"
    break;

  case 404: /* opt_s_parm_lst: s_parm_lst '[' identifier ']'  */
#line 933 "rttgram.y"
                                   {var_args((yyvsp[-1].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4048 "rttparse.c"
    break;

  case 406: /* s_parm_lst: s_parm_lst ',' s_parm  */
#line 938 "rttgram.y"
                           {free_t((yyvsp[-1].t));}
#line 4054 "rttparse.c"
    break;

  case 407: /* s_parm: identifier  */
#line 942 "rttgram.y"
                                         {s_prm_def(NULL, (yyvsp[0].t));}
#line 4060 "rttparse.c"
    break;

  case 408: /* s_parm: Underef identifier  */
#line 943 "rttgram.y"
                                         {s_prm_def((yyvsp[0].t), NULL); free_t((yyvsp[-1].t));}
#line 4066 "rttparse.c"
    break;

  case 409: /* s_parm: Underef identifier Arrow identifier  */
#line 944 "rttgram.y"
                                         {s_prm_def((yyvsp[-2].t), (yyvsp[0].t));   free_t((yyvsp[-3].t));
                                          free_t((yyvsp[-1].t));}
#line 4073 "rttparse.c"
    break;

  case 410: /* op_declare: %empty  */
#line 949 "rttgram.y"
     {}
#line 4079 "rttparse.c"
    break;

  case 411: /* op_declare: Declare '{' local_dcls '}'  */
#line 950 "rttgram.y"
                                {d_lst_typ((yyvsp[-1].n)); free_t((yyvsp[-3].t)); free_t((yyvsp[-2].t));
                                 free_t((yyvsp[0].t));}
#line 4086 "rttparse.c"
    break;

  case 412: /* opt_actions: %empty  */
#line 955 "rttgram.y"
     {(yyval.n) = NULL;}
#line 4092 "rttparse.c"
    break;

  case 415: /* actions: actions action  */
#line 961 "rttgram.y"
                    {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4098 "rttparse.c"
    break;

  case 419: /* action: '{' opt_actions '}'  */
#line 968 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 4104 "rttparse.c"
    break;

  case 420: /* $@14: %empty  */
#line 969 "rttgram.y"
              {lex_state = TypeComp;}
#line 4110 "rttparse.c"
    break;

  case 421: /* $@15: %empty  */
#line 970 "rttgram.y"
         {lex_state = DfltLex;}
#line 4116 "rttparse.c"
    break;

  case 422: /* action: Abstract $@14 '{' type_computations $@15 '}'  */
#line 971 "rttgram.y"
         {(yyval.n) = (yyvsp[-2].n); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[0].t));}
#line 4122 "rttparse.c"
    break;

  case 423: /* checking_conversions: If type_check Then action  */
#line 976 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-3].t), (yyvsp[-2].n), (yyvsp[0].n), NULL); free_t((yyvsp[-1].t));}
#line 4128 "rttparse.c"
    break;

  case 424: /* checking_conversions: If type_check Then action Else action  */
#line 978 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-5].t), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4134 "rttparse.c"
    break;

  case 425: /* checking_conversions: Type_case variable Of '{' type_select_lst opt_default '}'  */
#line 980 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-6].t), (yyvsp[-5].n), (yyvsp[-2].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[0].t));}
#line 4140 "rttparse.c"
    break;

  case 426: /* checking_conversions: Len_case identifier Of '{' len_select_lst Default ':' action '}'  */
#line 982 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-8].t), sym_node((yyvsp[-7].t)), (yyvsp[-4].n), (yyvsp[-1].n)); free_t((yyvsp[-6].t)), free_t((yyvsp[-5].t));
       free_t((yyvsp[-3].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4147 "rttparse.c"
    break;

  case 427: /* checking_conversions: Arith_case '(' variable ',' variable ')' Of '{' dest_type ':' action dest_type ':' action dest_type ':' action '}'  */
#line 986 "rttgram.y"
      {(yyval.n) = arith_nd((yyvsp[-17].t), (yyvsp[-15].n), (yyvsp[-13].n), (yyvsp[-9].n), (yyvsp[-7].n), (yyvsp[-6].n), (yyvsp[-4].n), (yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-16].t));
       free_t((yyvsp[-14].t)), free_t((yyvsp[-12].t)); free_t((yyvsp[-11].t)); free_t((yyvsp[-10].t)); free_t((yyvsp[-8].t));
       free_t((yyvsp[-5].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4155 "rttparse.c"
    break;

  case 428: /* type_select_lst: type_select  */
#line 992 "rttgram.y"
                                 {(yyval.n) = node2(ConCatNd, NULL, NULL, (yyvsp[0].n));}
#line 4161 "rttparse.c"
    break;

  case 429: /* type_select_lst: type_select_lst type_select  */
#line 993 "rttgram.y"
                                 {(yyval.n) = node2(ConCatNd, NULL,   (yyvsp[-1].n), (yyvsp[0].n));}
#line 4167 "rttparse.c"
    break;

  case 430: /* type_select: selector_lst action  */
#line 997 "rttgram.y"
                         {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4173 "rttparse.c"
    break;

  case 431: /* opt_default: %empty  */
#line 1001 "rttgram.y"
     {(yyval.n) = NULL;}
#line 4179 "rttparse.c"
    break;

  case 432: /* opt_default: Default ':' action  */
#line 1002 "rttgram.y"
                        {(yyval.n) = (yyvsp[0].n); free_t((yyvsp[-2].t)); free_t((yyvsp[-1].t));}
#line 4185 "rttparse.c"
    break;

  case 433: /* selector_lst: i_type_name ':'  */
#line 1006 "rttgram.y"
                                  {(yyval.n) = node2(ConCatNd, NULL, NULL, (yyvsp[-1].n));
                                   free_t((yyvsp[0].t));}
#line 4192 "rttparse.c"
    break;

  case 434: /* selector_lst: selector_lst i_type_name ':'  */
#line 1008 "rttgram.y"
                                  {(yyval.n) = node2(ConCatNd, NULL,   (yyvsp[-2].n), (yyvsp[-1].n));
                                   free_t((yyvsp[0].t));}
#line 4199 "rttparse.c"
    break;

  case 436: /* len_select_lst: len_select_lst len_select  */
#line 1014 "rttgram.y"
                               {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4205 "rttparse.c"
    break;

  case 437: /* len_select: IntConst ':' action  */
#line 1018 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 4211 "rttparse.c"
    break;

  case 439: /* type_check: '!' simple_check  */
#line 1023 "rttgram.y"
                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4217 "rttparse.c"
    break;

  case 441: /* simple_check_conj: simple_check_conj And simple_check  */
#line 1028 "rttgram.y"
                                        {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4223 "rttparse.c"
    break;

  case 442: /* simple_check: Is ':' i_type_name '(' variable ')'  */
#line 1033 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-5].t), (yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4229 "rttparse.c"
    break;

  case 443: /* simple_check: Cnv ':' dest_type '(' variable ')'  */
#line 1035 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-5].t), (yyvsp[-3].n), (yyvsp[-1].n), NULL), dst_alloc((yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t));
       free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4236 "rttparse.c"
    break;

  case 444: /* simple_check: Cnv ':' dest_type '(' variable ',' assign_expr ')'  */
#line 1038 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-7].t), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-6].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 4243 "rttparse.c"
    break;

  case 445: /* simple_check: Def ':' dest_type '(' variable ',' assign_expr ')'  */
#line 1041 "rttgram.y"
      {(yyval.n) = node4(QuadNd, (yyvsp[-7].t), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n), NULL), dst_alloc((yyvsp[-5].n), (yyvsp[-3].n)); free_t((yyvsp[-6].t));
       free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4250 "rttparse.c"
    break;

  case 446: /* simple_check: Def ':' dest_type '(' variable ',' assign_expr ',' assign_expr ')'  */
#line 1044 "rttgram.y"
      {(yyval.n) = node4(QuadNd, (yyvsp[-9].t), (yyvsp[-7].n), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-8].t)); free_t((yyvsp[-6].t));
       free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4257 "rttparse.c"
    break;

  case 447: /* $@16: %empty  */
#line 1049 "rttgram.y"
            {push_cntxt(1);}
#line 4263 "rttparse.c"
    break;

  case 448: /* detail_code: Body $@16 compound_stmt  */
#line 1050 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); pop_cntxt();}
#line 4269 "rttparse.c"
    break;

  case 449: /* $@17: %empty  */
#line 1051 "rttgram.y"
            {push_cntxt(1);}
#line 4275 "rttparse.c"
    break;

  case 450: /* detail_code: Inline $@17 compound_stmt  */
#line 1052 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); pop_cntxt();}
#line 4281 "rttparse.c"
    break;

  case 451: /* runerr: Runerr '(' IntConst ')' opt_semi  */
#line 1057 "rttgram.y"
                    {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), node0(PrimryNd, (yyvsp[-2].t)), NULL);
                     free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4288 "rttparse.c"
    break;

  case 452: /* runerr: Runerr '(' IntConst ',' variable ')' opt_semi  */
#line 1060 "rttgram.y"
                    {(yyval.n) = node2(BinryNd, (yyvsp[-6].t), node0(PrimryNd, (yyvsp[-4].t)), (yyvsp[-2].n));
                     free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4295 "rttparse.c"
    break;

  case 454: /* opt_semi: ';'  */
#line 1066 "rttgram.y"
         {free_t((yyvsp[0].t));}
#line 4301 "rttparse.c"
    break;

  case 455: /* variable: identifier  */
#line 1070 "rttgram.y"
                                 {(yyval.n) = sym_node((yyvsp[0].t));}
#line 4307 "rttparse.c"
    break;

  case 456: /* variable: identifier '[' IntConst ']'  */
#line 1071 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), sym_node((yyvsp[-3].t)),
                                    node0(PrimryNd, (yyvsp[-1].t)));
                                  free_t((yyvsp[0].t));}
#line 4315 "rttparse.c"
    break;

  case 457: /* dest_type: IconType  */
#line 1076 "rttgram.y"
                             {(yyval.n) = dest_node((yyvsp[0].t));}
#line 4321 "rttparse.c"
    break;

  case 458: /* dest_type: C_Integer  */
#line 1077 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4327 "rttparse.c"
    break;

  case 459: /* dest_type: C_Double  */
#line 1078 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4333 "rttparse.c"
    break;

  case 460: /* dest_type: C_String  */
#line 1079 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4339 "rttparse.c"
    break;

  case 461: /* dest_type: Tmp_string  */
#line 1080 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t)); ++n_tmp_str;}
#line 4345 "rttparse.c"
    break;

  case 462: /* dest_type: Tmp_cset  */
#line 1081 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t)); ++n_tmp_cset;}
#line 4351 "rttparse.c"
    break;

  case 463: /* dest_type: '(' Exact ')' IconType  */
#line 1082 "rttgram.y"
                             {(yyval.n) = node0(ExactCnv, chk_exct((yyvsp[0].t))); free_t((yyvsp[-3].t));
                              free_t((yyvsp[-2].t)); free_t((yyvsp[-1].t));}
#line 4358 "rttparse.c"
    break;

  case 464: /* dest_type: '(' Exact ')' C_Integer  */
#line 1084 "rttgram.y"
                             {(yyval.n) = node0(ExactCnv, (yyvsp[0].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-2].t));
                              free_t((yyvsp[-1].t));}
#line 4365 "rttparse.c"
    break;

  case 465: /* i_type_name: Any_value  */
#line 1089 "rttgram.y"
                {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4371 "rttparse.c"
    break;

  case 466: /* i_type_name: Empty_type  */
#line 1090 "rttgram.y"
                {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4377 "rttparse.c"
    break;

  case 467: /* i_type_name: IconType  */
#line 1091 "rttgram.y"
                {(yyval.n) = sym_node((yyvsp[0].t));}
#line 4383 "rttparse.c"
    break;

  case 468: /* i_type_name: Variable  */
#line 1092 "rttgram.y"
                {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4389 "rttparse.c"
    break;

  case 470: /* ret_val: C_Integer assign_expr  */
#line 1097 "rttgram.y"
                                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4395 "rttparse.c"
    break;

  case 471: /* ret_val: C_Double assign_expr  */
#line 1098 "rttgram.y"
                                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4401 "rttparse.c"
    break;

  case 472: /* ret_val: C_String assign_expr  */
#line 1099 "rttgram.y"
                                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4407 "rttparse.c"
    break;

  case 473: /* type_computations: side_effect_lst Return type opt_semi  */
#line 1103 "rttgram.y"
                                          {(yyval.n) = node2(AbstrNd, (yyvsp[-2].t),   (yyvsp[-3].n),   (yyvsp[-1].n));}
#line 4413 "rttparse.c"
    break;

  case 474: /* type_computations: Return type opt_semi  */
#line 1104 "rttgram.y"
                                          {(yyval.n) = node2(AbstrNd, (yyvsp[-2].t),   NULL, (yyvsp[-1].n));}
#line 4419 "rttparse.c"
    break;

  case 475: /* type_computations: side_effect_lst  */
#line 1105 "rttgram.y"
                                          {(yyval.n) = node2(AbstrNd, NULL, (yyvsp[0].n), NULL);}
#line 4425 "rttparse.c"
    break;

  case 477: /* side_effect_lst: side_effect_lst side_effect  */
#line 1110 "rttgram.y"
                                 {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4431 "rttparse.c"
    break;

  case 478: /* side_effect: Store '[' type ']' '=' type opt_semi  */
#line 1114 "rttgram.y"
                                          {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                           free_t((yyvsp[-6].t)); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t));}
#line 4438 "rttparse.c"
    break;

  case 480: /* type: type union basic_type  */
#line 1120 "rttgram.y"
                               {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4444 "rttparse.c"
    break;

  case 481: /* type: type Intersect basic_type  */
#line 1121 "rttgram.y"
                               {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4450 "rttparse.c"
    break;

  case 482: /* basic_type: i_type_name  */
#line 1124 "rttgram.y"
                                        {(yyval.n) = node1(IcnTypNd,
                                         copy_t((yyvsp[0].n)->tok), (yyvsp[0].n));}
#line 4457 "rttparse.c"
    break;

  case 483: /* basic_type: Type '(' variable ')'  */
#line 1126 "rttgram.y"
                                        {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4464 "rttparse.c"
    break;

  case 484: /* basic_type: New i_type_name '(' type_lst ')'  */
#line 1128 "rttgram.y"
                                        {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4471 "rttparse.c"
    break;

  case 485: /* basic_type: Store '[' type ']'  */
#line 1130 "rttgram.y"
                                        {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4478 "rttparse.c"
    break;

  case 486: /* basic_type: basic_type '.' attrb_name  */
#line 1132 "rttgram.y"
                                        {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-2].n));
                                         free_t((yyvsp[-1].t));}
#line 4485 "rttparse.c"
    break;

  case 487: /* basic_type: '(' type ')'  */
#line 1134 "rttgram.y"
                                        {(yyval.n) = (yyvsp[-1].n); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4491 "rttparse.c"
    break;

  case 490: /* type_lst: type_lst ',' type  */
#line 1143 "rttgram.y"
                       {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4497 "rttparse.c"
    break;


#line 4501 "rttparse.c"

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

#line 1151 "rttgram.y"


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
