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
  YYSYMBOL_IfStmt = 141,                   /* IfStmt  */
  YYSYMBOL_YYACCEPT = 142,                 /* $accept  */
  YYSYMBOL_primary_expr = 143,             /* primary_expr  */
  YYSYMBOL_postfix_expr = 144,             /* postfix_expr  */
  YYSYMBOL_arg_expr_lst = 145,             /* arg_expr_lst  */
  YYSYMBOL_unary_expr = 146,               /* unary_expr  */
  YYSYMBOL_unary_op = 147,                 /* unary_op  */
  YYSYMBOL_cast_expr = 148,                /* cast_expr  */
  YYSYMBOL_multiplicative_expr = 149,      /* multiplicative_expr  */
  YYSYMBOL_additive_expr = 150,            /* additive_expr  */
  YYSYMBOL_shift_expr = 151,               /* shift_expr  */
  YYSYMBOL_relational_expr = 152,          /* relational_expr  */
  YYSYMBOL_equality_expr = 153,            /* equality_expr  */
  YYSYMBOL_and_expr = 154,                 /* and_expr  */
  YYSYMBOL_exclusive_or_expr = 155,        /* exclusive_or_expr  */
  YYSYMBOL_inclusive_or_expr = 156,        /* inclusive_or_expr  */
  YYSYMBOL_logical_and_expr = 157,         /* logical_and_expr  */
  YYSYMBOL_logical_or_expr = 158,          /* logical_or_expr  */
  YYSYMBOL_conditional_expr = 159,         /* conditional_expr  */
  YYSYMBOL_assign_expr = 160,              /* assign_expr  */
  YYSYMBOL_assign_op = 161,                /* assign_op  */
  YYSYMBOL_expr = 162,                     /* expr  */
  YYSYMBOL_opt_expr = 163,                 /* opt_expr  */
  YYSYMBOL_constant_expr = 164,            /* constant_expr  */
  YYSYMBOL_opt_constant_expr = 165,        /* opt_constant_expr  */
  YYSYMBOL_dcltion = 166,                  /* dcltion  */
  YYSYMBOL_typ_dcltion_specs = 167,        /* typ_dcltion_specs  */
  YYSYMBOL_dcltion_specs = 168,            /* dcltion_specs  */
  YYSYMBOL_type_ind = 169,                 /* type_ind  */
  YYSYMBOL_type_storcl_tqual_lst = 170,    /* type_storcl_tqual_lst  */
  YYSYMBOL_storcl_tqual_lst = 171,         /* storcl_tqual_lst  */
  YYSYMBOL_init_dcltor_lst = 172,          /* init_dcltor_lst  */
  YYSYMBOL_no_tdn_init_dcltor_lst = 173,   /* no_tdn_init_dcltor_lst  */
  YYSYMBOL_init_dcltor = 174,              /* init_dcltor  */
  YYSYMBOL_no_tdn_init_dcltor = 175,       /* no_tdn_init_dcltor  */
  YYSYMBOL_storage_class_spec = 176,       /* storage_class_spec  */
  YYSYMBOL_type_spec = 177,                /* type_spec  */
  YYSYMBOL_stnd_type = 178,                /* stnd_type  */
  YYSYMBOL_struct_or_union_spec = 179,     /* struct_or_union_spec  */
  YYSYMBOL_struct_or_union = 180,          /* struct_or_union  */
  YYSYMBOL_struct_dcltion_lst = 181,       /* struct_dcltion_lst  */
  YYSYMBOL_struct_dcltion = 182,           /* struct_dcltion  */
  YYSYMBOL_struct_dcltion_specs = 183,     /* struct_dcltion_specs  */
  YYSYMBOL_struct_type_ind = 184,          /* struct_type_ind  */
  YYSYMBOL_struct_type_lst = 185,          /* struct_type_lst  */
  YYSYMBOL_struct_dcltor_lst = 186,        /* struct_dcltor_lst  */
  YYSYMBOL_struct_dcltor = 187,            /* struct_dcltor  */
  YYSYMBOL_188_1 = 188,                    /* $@1  */
  YYSYMBOL_struct_no_tdn_dcltor_lst = 189, /* struct_no_tdn_dcltor_lst  */
  YYSYMBOL_struct_no_tdn_dcltor = 190,     /* struct_no_tdn_dcltor  */
  YYSYMBOL_191_2 = 191,                    /* $@2  */
  YYSYMBOL_enum_spec = 192,                /* enum_spec  */
  YYSYMBOL_193_3 = 193,                    /* $@3  */
  YYSYMBOL_194_4 = 194,                    /* $@4  */
  YYSYMBOL_enumerator_lst = 195,           /* enumerator_lst  */
  YYSYMBOL_enumerator = 196,               /* enumerator  */
  YYSYMBOL_type_qual = 197,                /* type_qual  */
  YYSYMBOL_dcltor = 198,                   /* dcltor  */
  YYSYMBOL_no_tdn_dcltor = 199,            /* no_tdn_dcltor  */
  YYSYMBOL_direct_dcltor = 200,            /* direct_dcltor  */
  YYSYMBOL_201_5 = 201,                    /* $@5  */
  YYSYMBOL_no_tdn_direct_dcltor = 202,     /* no_tdn_direct_dcltor  */
  YYSYMBOL_203_6 = 203,                    /* $@6  */
  YYSYMBOL_parm_dcls_or_ids = 204,         /* parm_dcls_or_ids  */
  YYSYMBOL_pointer = 205,                  /* pointer  */
  YYSYMBOL_opt_pointer = 206,              /* opt_pointer  */
  YYSYMBOL_tqual_lst = 207,                /* tqual_lst  */
  YYSYMBOL_param_type_lst = 208,           /* param_type_lst  */
  YYSYMBOL_opt_param_type_lst = 209,       /* opt_param_type_lst  */
  YYSYMBOL_param_lst = 210,                /* param_lst  */
  YYSYMBOL_param_dcltion = 211,            /* param_dcltion  */
  YYSYMBOL_ident_lst = 212,                /* ident_lst  */
  YYSYMBOL_type_tqual_lst = 213,           /* type_tqual_lst  */
  YYSYMBOL_type_name = 214,                /* type_name  */
  YYSYMBOL_abstract_dcltor = 215,          /* abstract_dcltor  */
  YYSYMBOL_direct_abstract_dcltor = 216,   /* direct_abstract_dcltor  */
  YYSYMBOL_217_7 = 217,                    /* $@7  */
  YYSYMBOL_218_8 = 218,                    /* $@8  */
  YYSYMBOL_initializer = 219,              /* initializer  */
  YYSYMBOL_initializer_lst = 220,          /* initializer_lst  */
  YYSYMBOL_stmt = 221,                     /* stmt  */
  YYSYMBOL_non_lbl_stmt = 222,             /* non_lbl_stmt  */
  YYSYMBOL_223_9 = 223,                    /* $@9  */
  YYSYMBOL_labeled_stmt = 224,             /* labeled_stmt  */
  YYSYMBOL_compound_stmt = 225,            /* compound_stmt  */
  YYSYMBOL_dcltion_lst = 226,              /* dcltion_lst  */
  YYSYMBOL_opt_dcltion_lst = 227,          /* opt_dcltion_lst  */
  YYSYMBOL_local_dcls = 228,               /* local_dcls  */
  YYSYMBOL_local_dcl = 229,                /* local_dcl  */
  YYSYMBOL_tended_type = 230,              /* tended_type  */
  YYSYMBOL_stmt_lst = 231,                 /* stmt_lst  */
  YYSYMBOL_opt_stmt_lst = 232,             /* opt_stmt_lst  */
  YYSYMBOL_expr_stmt = 233,                /* expr_stmt  */
  YYSYMBOL_selection_stmt = 234,           /* selection_stmt  */
  YYSYMBOL_c_type_select_lst = 235,        /* c_type_select_lst  */
  YYSYMBOL_c_type_select = 236,            /* c_type_select  */
  YYSYMBOL_c_opt_default = 237,            /* c_opt_default  */
  YYSYMBOL_iteration_stmt = 238,           /* iteration_stmt  */
  YYSYMBOL_jump_stmt = 239,                /* jump_stmt  */
  YYSYMBOL_translation_unit = 240,         /* translation_unit  */
  YYSYMBOL_extrn_decltn_lst = 241,         /* extrn_decltn_lst  */
  YYSYMBOL_external_dcltion = 242,         /* external_dcltion  */
  YYSYMBOL_function_definition = 243,      /* function_definition  */
  YYSYMBOL_244_10 = 244,                   /* $@10  */
  YYSYMBOL_func_head = 245,                /* func_head  */
  YYSYMBOL_any_ident = 246,                /* any_ident  */
  YYSYMBOL_label = 247,                    /* label  */
  YYSYMBOL_typedefname = 248,              /* typedefname  */
  YYSYMBOL_definition = 249,               /* definition  */
  YYSYMBOL_250_11 = 250,                   /* $@11  */
  YYSYMBOL_operation = 251,                /* operation  */
  YYSYMBOL_description = 252,              /* description  */
  YYSYMBOL_fnc_oper = 253,                 /* fnc_oper  */
  YYSYMBOL_254_12 = 254,                   /* $@12  */
  YYSYMBOL_255_13 = 255,                   /* $@13  */
  YYSYMBOL_keyword = 256,                  /* keyword  */
  YYSYMBOL_key_const = 257,                /* key_const  */
  YYSYMBOL_identifier = 258,               /* identifier  */
  YYSYMBOL_op_name = 259,                  /* op_name  */
  YYSYMBOL_result_seq = 260,               /* result_seq  */
  YYSYMBOL_length = 261,                   /* length  */
  YYSYMBOL_opt_plus = 262,                 /* opt_plus  */
  YYSYMBOL_opt_s_parm_lst = 263,           /* opt_s_parm_lst  */
  YYSYMBOL_s_parm_lst = 264,               /* s_parm_lst  */
  YYSYMBOL_s_parm = 265,                   /* s_parm  */
  YYSYMBOL_op_declare = 266,               /* op_declare  */
  YYSYMBOL_opt_actions = 267,              /* opt_actions  */
  YYSYMBOL_actions = 268,                  /* actions  */
  YYSYMBOL_action = 269,                   /* action  */
  YYSYMBOL_270_14 = 270,                   /* $@14  */
  YYSYMBOL_271_15 = 271,                   /* $@15  */
  YYSYMBOL_checking_conversions = 272,     /* checking_conversions  */
  YYSYMBOL_type_select_lst = 273,          /* type_select_lst  */
  YYSYMBOL_type_select = 274,              /* type_select  */
  YYSYMBOL_opt_default = 275,              /* opt_default  */
  YYSYMBOL_selector_lst = 276,             /* selector_lst  */
  YYSYMBOL_len_select_lst = 277,           /* len_select_lst  */
  YYSYMBOL_len_select = 278,               /* len_select  */
  YYSYMBOL_type_check = 279,               /* type_check  */
  YYSYMBOL_simple_check_conj = 280,        /* simple_check_conj  */
  YYSYMBOL_simple_check = 281,             /* simple_check  */
  YYSYMBOL_detail_code = 282,              /* detail_code  */
  YYSYMBOL_283_16 = 283,                   /* $@16  */
  YYSYMBOL_284_17 = 284,                   /* $@17  */
  YYSYMBOL_runerr = 285,                   /* runerr  */
  YYSYMBOL_opt_semi = 286,                 /* opt_semi  */
  YYSYMBOL_variable = 287,                 /* variable  */
  YYSYMBOL_dest_type = 288,                /* dest_type  */
  YYSYMBOL_i_type_name = 289,              /* i_type_name  */
  YYSYMBOL_ret_val = 290,                  /* ret_val  */
  YYSYMBOL_type_computations = 291,        /* type_computations  */
  YYSYMBOL_side_effect_lst = 292,          /* side_effect_lst  */
  YYSYMBOL_side_effect = 293,              /* side_effect  */
  YYSYMBOL_type = 294,                     /* type  */
  YYSYMBOL_basic_type = 295,               /* basic_type  */
  YYSYMBOL_union = 296,                    /* union  */
  YYSYMBOL_type_lst = 297,                 /* type_lst  */
  YYSYMBOL_attrb_name = 298                /* attrb_name  */
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
#define YYFINAL  101
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   3652

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  142
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  157
/* YYNRULES -- Number of rules.  */
#define YYNRULES  487
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  840

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   370


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
     141
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,    90,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,   102,   106,   107,   109,   111,   113,
     114,   115,   116,   117,   119,   122,   128,   129,   133,   134,
     135,   136,   137,   138,   140,   147,   148,   149,   150,   151,
     152,   156,   157,   161,   162,   163,   164,   168,   169,   170,
     174,   175,   176,   180,   181,   182,   183,   184,   188,   189,
     190,   194,   195,   199,   200,   204,   205,   209,   210,   214,
     215,   219,   220,   226,   227,   231,   232,   233,   234,   235,
     236,   237,   238,   239,   240,   241,   245,   246,   250,   251,
     255,   259,   260,   264,   266,   268,   274,   275,   279,   280,
     284,   285,   287,   291,   292,   293,   294,   298,   299,   300,
     301,   305,   306,   310,   311,   316,   317,   321,   322,   327,
     328,   329,   330,   331,   332,   333,   340,   341,   345,   346,
     347,   348,   349,   350,   351,   352,   353,   354,   355,   356,
     362,   365,   368,   372,   373,   377,   378,   382,   384,   388,
     389,   393,   394,   395,   399,   400,   401,   404,   405,   409,
     411,   412,   412,   417,   418,   423,   425,   426,   426,   431,
     431,   433,   433,   435,   439,   440,   444,   445,   450,   451,
     456,   460,   464,   465,   467,   469,   469,   479,   480,   482,
     485,   485,   495,   496,   500,   501,   502,   503,   507,   508,
     512,   513,   517,   518,   522,   523,   527,   528,   532,   534,
     535,   539,   540,   544,   545,   546,   547,   551,   552,   556,
     557,   561,   563,   566,   569,   569,   573,   573,   580,   581,
     582,   584,   590,   591,   595,   596,   600,   600,   601,   602,
     603,   604,   605,   607,   612,   613,   614,   618,   619,   623,
     624,   628,   629,   633,   634,   638,   639,   644,   645,   646,
     647,   651,   652,   653,   657,   658,   661,   665,   667,   669,
     671,   676,   677,   681,   685,   686,   690,   692,   695,   702,
     703,   704,   705,   706,   707,   708,   712,   713,   717,   718,
     722,   723,   724,   728,   728,   733,   734,   735,   739,   740,
     744,   745,   749,   750,   751,   752,   760,   760,   764,   765,
     766,   770,   771,   775,   778,   779,   778,   784,   789,   790,
     791,   792,   799,   800,   801,   802,   803,   804,   805,   806,
     807,   808,   809,   810,   811,   812,   813,   814,   815,   816,
     817,   818,   819,   820,   821,   828,   829,   830,   831,   832,
     833,   834,   835,   836,   837,   838,   839,   840,   841,   842,
     843,   844,   845,   846,   847,   848,   849,   850,   851,   852,
     853,   854,   855,   856,   857,   858,   859,   860,   861,   862,
     863,   864,   865,   866,   867,   868,   869,   870,   871,   872,
     876,   877,   878,   882,   883,   887,   888,   892,   893,   894,
     898,   899,   903,   904,   905,   910,   911,   916,   917,   921,
     922,   926,   927,   928,   929,   930,   931,   930,   936,   938,
     940,   942,   945,   953,   954,   958,   962,   963,   967,   969,
     974,   975,   979,   983,   984,   988,   989,   993,   995,   998,
    1001,  1004,  1010,  1010,  1012,  1012,  1017,  1020,  1026,  1027,
    1031,  1032,  1037,  1038,  1039,  1040,  1041,  1042,  1043,  1045,
    1050,  1051,  1052,  1053,  1057,  1058,  1059,  1060,  1064,  1065,
    1066,  1070,  1071,  1075,  1080,  1081,  1082,  1085,  1087,  1089,
    1091,  1093,  1095,  1099,  1103,  1104,  1108,  1109
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
  "Offsetof", "IfStmt", "$accept", "primary_expr", "postfix_expr",
  "arg_expr_lst", "unary_expr", "unary_op", "cast_expr",
  "multiplicative_expr", "additive_expr", "shift_expr", "relational_expr",
  "equality_expr", "and_expr", "exclusive_or_expr", "inclusive_or_expr",
  "logical_and_expr", "logical_or_expr", "conditional_expr", "assign_expr",
  "assign_op", "expr", "opt_expr", "constant_expr", "opt_constant_expr",
  "dcltion", "typ_dcltion_specs", "dcltion_specs", "type_ind",
  "type_storcl_tqual_lst", "storcl_tqual_lst", "init_dcltor_lst",
  "no_tdn_init_dcltor_lst", "init_dcltor", "no_tdn_init_dcltor",
  "storage_class_spec", "type_spec", "stnd_type", "struct_or_union_spec",
  "struct_or_union", "struct_dcltion_lst", "struct_dcltion",
  "struct_dcltion_specs", "struct_type_ind", "struct_type_lst",
  "struct_dcltor_lst", "struct_dcltor", "$@1", "struct_no_tdn_dcltor_lst",
  "struct_no_tdn_dcltor", "$@2", "enum_spec", "$@3", "$@4",
  "enumerator_lst", "enumerator", "type_qual", "dcltor", "no_tdn_dcltor",
  "direct_dcltor", "$@5", "no_tdn_direct_dcltor", "$@6",
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

#define YYPACT_NINF (-678)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-464)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     768,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,
    -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,
    1649,   134,  -678,  -678,  -678,  -678,    17,    45,  -678,    46,
    -678,  2144,  3288,  -678,  -678,  -678,   873,  -678,  -678,  -678,
    -678,  1241,    74,   895,  -678,  -678,  -678,   226,  -678,   147,
    -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,
    -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,
    -678,  -678,  -678,    83,   145,  -678,  -678,  -678,  -678,   134,
    1785,  2560,  -678,   -16,  -678,   210,  2894,  -678,  -678,  -678,
    -678,   146,  -678,  -678,  -678,   211,  2534,   150,   178,   186,
    -678,  -678,  -678,  3432,   226,  -678,   386,  1649,   208,  -678,
    -678,   223,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,
    -678,  -678,  -678,  2698,  2698,  2836,  -678,  1456,  -678,  -678,
    -678,  -678,  -678,   192,   229,   234,   282,  -678,    30,  -678,
    2560,  -678,   323,    21,   344,    75,    35,   304,   292,   309,
     362,    13,  -678,   327,  -678,   178,  -678,  2284,   178,   206,
    -678,   178,  -678,  2284,  -678,  2258,  -678,    48,  -678,   280,
     665,    87,  2534,   352,  -678,  2560,  -678,    46,  3288,  3432,
     359,   364,   366,   370,  -678,   332,   296,   193,  -678,   368,
    1649,  -678,  2560,  -678,  -678,  1456,  -678,   606,  -678,  -678,
     241,  2534,  -678,  2534,   159,   383,  -678,   302,   172,   172,
    2534,  1649,  -678,  -678,  2422,  1649,  2560,  -678,  2560,  2560,
    2560,  2560,  2560,  2560,  2560,  2560,  2560,  2560,  2560,  2560,
    2560,  2560,  2560,  2560,  2560,  2560,  2560,  -678,  -678,   376,
    2008,  -678,  -678,   402,  -678,  2560,  -678,   395,  -678,  -678,
    -678,  2560,   230,  -678,   405,  -678,  -678,  2560,  -678,   264,
    -678,   418,    87,  2396,  -678,  2932,  -678,   410,  -678,  1042,
    -678,    39,    39,    39,   429,  2495,   338,  2495,   444,   448,
    -678,  -678,  -678,  1785,  1785,   439,   784,  -678,  -678,  -678,
    -678,  1649,  -678,  2560,   221,   450,  -678,  -678,  -678,  -678,
    -678,  -678,  -678,  -678,  -678,  -678,  -678,  2560,  -678,  2560,
    -678,  -678,   315,   279,  -678,  2560,  -678,  -678,  -678,  -678,
     456,   431,  -678,  -678,  -678,  -678,  -678,  -678,   460,   461,
     459,  -678,  -678,   354,  -678,  -678,   102,  -678,  -678,  -678,
     323,   323,    21,    21,   344,   344,   344,   344,    75,    75,
      35,   304,   292,   309,   362,     3,  -678,  -678,   231,  -678,
    2932,   453,  -678,    48,  -678,  -678,  -678,    66,  -678,  -678,
    -678,  3557,  -678,   375,  3432,   466,  -678,  -678,   469,  -678,
     471,  -678,  -678,   162,  2560,   455,   479,   480,   481,  1318,
     482,  1649,   467,   470,  1870,   488,  1870,   473,  2560,   474,
     487,   476,  -678,  -678,  -678,   359,  -678,  1042,  -678,  1180,
     483,  -678,  -678,  -678,  -678,   484,   122,   485,  -678,  -678,
     492,   339,   493,  -678,  3389,  2357,   415,   489,   490,   496,
     437,   549,  -678,   503,  2495,   579,  1785,   359,   359,   508,
     505,   462,   463,  -678,  -678,  -678,  -678,   475,  -678,  -678,
    -678,  -678,  -678,  -678,  -678,  -678,   273,  2560,   286,  -678,
    2560,   523,  2560,  2560,  1785,  -678,  2560,  -678,  2560,  2146,
    -678,   524,  -678,  -678,  2560,  -678,  2560,  -678,  3171,  -678,
    -678,  3410,  1785,  -678,  1519,  1785,   178,   511,  1318,  2560,
    2560,  2560,   536,  -678,  2560,   514,  -678,  -678,  -678,  2560,
    2560,  2560,  -678,   515,  2560,   516,  -678,   -40,  -678,  -678,
    -678,  -678,   526,  -678,  -678,  -678,  1318,  3041,  -678,    39,
    -678,  3041,   528,  3267,  -678,  -678,   302,   172,   172,  2495,
     415,  -678,   381,   529,  -678,  -678,    -4,   598,   531,   534,
    -678,   542,  3432,   533,  -678,  2560,   547,   242,   545,   546,
     550,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  3111,  -678,
    -678,  -678,  -678,  -678,  -678,   289,  1318,  -678,   387,   398,
     400,   553,   538,  -678,  -678,  -678,  -678,  -678,   404,  -678,
     548,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,
    -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,
    -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,
    -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,
    -678,  -678,  -678,  -678,  -678,  -678,  -678,  -678,   573,   571,
    -678,   613,  -678,   577,   581,   583,   595,  -678,   569,  1785,
    1785,   307,   574,  -678,     1,  -678,   575,   302,   672,  -678,
     608,  -678,  3432,   597,  -678,  -678,  -678,  2560,  2560,  -678,
    -678,  -678,  1318,  1318,  1318,  2560,  2560,   596,  2560,   302,
    1923,  -678,  -678,  1785,  1785,  1785,  2495,  -678,  -678,   610,
     612,   307,   602,   615,   302,  -678,    28,   616,   307,   609,
     307,  -678,  -678,   110,  -678,   477,   603,   617,    38,  -678,
    -678,   620,  -678,   629,   627,   644,  -678,  -678,   406,   634,
    -678,   650,   135,  -678,  1594,  1785,  -678,   651,   143,  -678,
    3041,   652,   408,   653,  -678,   569,   599,    70,   307,  1785,
     654,  -678,   307,  -678,   307,   -55,    24,  -678,    28,   640,
    -678,   656,  -678,   645,  -678,  2495,   646,  -678,  -678,  -678,
    2560,  1318,   647,  2560,   648,   657,  -678,   658,   660,   661,
     662,   663,  -678,   722,  -678,  1923,  1785,   669,  -678,  -678,
    2560,  2560,  -678,   671,  -678,    40,   680,   307,   616,   616,
    -678,  -678,  -678,   655,  -678,  2495,  -678,  -678,  -678,  2495,
     681,  -678,  -678,   682,  -678,  1732,  -678,  1785,  -678,   673,
    1923,   683,   413,   172,  -678,  -678,    72,   414,   307,  -678,
     675,  -678,  1318,  -678,  -678,  -678,   687,  -678,  -678,  2560,
     674,  -678,   307,    28,  -678,  -678,  -678,   689,  2495,    72,
    -678,  -678,   172,   677,  2495,   172,   679,  2495,   685,  -678
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int16 yydefact[] =
{
     198,   119,   120,   121,   122,   123,   129,   130,   131,   132,
     135,   136,   133,   134,   178,   179,   128,   302,   143,   144,
     169,   194,   303,   304,   305,   124,     0,     0,   291,   198,
      96,   102,   198,   107,   103,   137,     0,   138,   108,   295,
     199,     0,     0,   198,   288,   290,   293,   100,   292,   311,
     332,   330,   328,   331,   326,   344,   324,   334,   338,   341,
     340,   325,   329,   343,   327,   333,   322,   337,   342,   335,
     323,   339,   336,     0,   173,   299,   298,   200,   196,   195,
       0,     0,    93,     0,   111,   297,     0,   105,   104,   106,
      97,     0,   113,   109,   110,   296,     0,   142,   198,   181,
     187,     1,   289,   251,   101,   312,     0,     0,     0,   201,
     197,     0,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,     0,     0,     0,    35,     0,    36,    37,
      38,    39,    40,     0,     0,     0,     0,    15,    28,    41,
       0,    43,    47,    50,    53,    58,    61,    63,    65,    67,
      69,    71,    90,     0,     2,   198,    94,     0,   198,   180,
     182,   198,    95,     0,   154,     0,   145,   198,   149,   153,
     198,   151,     0,     0,   190,    91,   249,   198,   198,   252,
       0,     0,     0,     0,   307,   405,     0,     0,   174,   176,
       0,   125,     0,    29,    30,     0,    32,    41,    73,    86,
       0,   213,   126,   214,   198,     0,   127,     0,     0,     0,
       0,     0,    21,    22,     0,     0,     0,    31,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   139,   112,   115,
       0,   228,   116,     0,   185,    91,   114,   117,   118,   141,
     146,     0,     0,   157,   159,   155,   156,     0,   150,     0,
     163,   165,   152,     0,   188,   204,    92,     0,   250,    88,
     294,   390,   390,   390,     0,     0,     0,   407,     0,     0,
     442,   444,   415,     0,     0,     0,     0,   409,   411,   412,
     413,     0,   170,     0,     0,     0,    76,    77,    78,    79,
      80,    81,    82,    83,    84,    85,    75,     0,    14,     0,
     215,   216,   199,     0,   218,     0,   461,   462,   463,   460,
       0,     0,   452,   453,   454,   455,   456,   457,     0,     0,
       0,    20,    17,     0,    26,    19,     0,    46,    44,    45,
      48,    49,    51,    52,    56,    57,    54,    55,    59,    60,
      62,    64,    66,    68,    70,     0,   229,   232,     0,   183,
     204,     0,   160,   198,   147,   161,   166,   198,   148,   167,
     140,   124,    98,   198,    99,     0,   205,   192,   202,   206,
     193,   211,   189,     0,     0,     0,     0,     0,     0,    88,
       0,     0,     0,     0,    88,     0,    88,     0,     0,     0,
      89,     0,   255,   261,   235,     0,   234,    88,   253,    88,
       0,   238,   239,   240,   241,     0,   100,     2,   393,   394,
       0,   395,     0,   314,     0,     0,     0,     0,     0,     0,
       0,   433,   435,     0,   408,     0,     0,     0,     0,     0,
     450,     0,     0,   318,   320,   319,   321,     0,   309,   410,
     175,   177,   172,    33,    74,    87,   224,    91,   220,    42,
       0,     0,     0,     0,     0,    18,     0,    16,     0,     0,
     230,     0,   184,   158,     0,   164,     0,   208,     0,   210,
     191,     0,     0,   257,     0,     0,   198,     0,    88,     0,
       0,     0,     0,   301,    88,     0,   300,   280,   281,     0,
       0,     0,   464,     0,     0,     0,   284,     0,   285,   266,
     237,   254,     0,   262,   263,   247,    88,     0,   396,     0,
     391,     0,     0,     0,   308,   434,     0,     0,     0,     0,
       0,   414,     0,     0,   443,   445,     0,     0,     0,     0,
     310,     0,   204,     0,   226,    91,     0,     0,     0,     0,
       0,    27,    72,   231,   233,   186,   162,   168,   224,   203,
     207,   212,   259,   258,   260,     0,    88,   246,     0,     0,
       0,     0,     0,   279,   465,   466,   467,   282,     0,   283,
       0,   248,   244,   378,   384,   361,   379,   347,   373,   383,
     350,   376,   368,   371,   377,   386,   363,   357,   352,   388,
     387,   380,   385,   359,   349,   355,   367,   358,   382,   389,
     356,   364,   366,   353,   348,   374,   375,   369,   351,   354,
     365,   370,   372,   381,   362,   360,   346,   345,     0,   395,
     317,     0,   406,     0,     0,     0,   418,   436,   448,     0,
       0,     0,     0,   416,   470,   471,     0,     0,     0,   221,
       0,   222,   204,     0,    23,   458,   459,     0,     0,    34,
     256,   245,    88,    88,    88,     0,    88,     0,     0,     0,
     397,   392,   315,     0,     0,     0,     0,   449,   446,     0,
       0,     0,     0,     0,     0,   477,   448,   474,     0,     0,
       0,   472,   451,   426,   423,     0,     0,     0,     0,   430,
     225,     0,   223,     0,     0,   267,   269,   276,     0,     0,
     242,     0,   274,   271,    88,   343,   402,     0,   398,   400,
       0,     0,     0,     0,   419,   448,     0,     0,     0,     0,
       0,   483,     0,   469,     0,     0,     0,   417,   448,     0,
     424,     0,   425,     0,   428,     0,     0,   431,   227,    24,
       0,    88,     0,    88,     0,     0,   272,     0,   328,   331,
     344,   324,   273,   403,   313,     0,     0,     0,   437,   438,
       0,     0,   447,     0,   482,     0,     0,     0,   476,   475,
     486,   487,   481,     0,   468,     0,   420,   429,   432,     0,
       0,   268,   277,     0,   243,    88,   270,     0,   401,     0,
     397,     0,     0,     0,   480,   478,   484,     0,     0,   427,
       0,    25,    88,   275,   404,   399,     0,   439,   440,     0,
       0,   479,     0,   448,   421,   278,   316,     0,     0,   485,
     473,   441,     0,     0,     0,     0,     0,     0,     0,   422
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -678,  -678,  -678,  -678,   447,  -678,  -105,   300,   301,   199,
     303,   540,   541,   551,   552,   554,  -678,    -1,  -155,  -678,
    -114,  -368,   -72,  -230,    29,    10,  -678,   -18,  -678,     5,
     295,  -678,   628,   614,    -7,  -678,    31,  -678,  -678,   618,
    -132,  -678,   621,  -678,  -678,   419,  -678,  -678,   420,  -678,
    -678,  -678,  -678,   604,   494,   670,   -22,   -31,  -678,  -678,
    -678,  -678,   428,   -15,    25,     6,  -678,  -519,  -678,   312,
    -678,    50,  -104,  -168,  -678,  -678,  -678,  -151,  -678,  -367,
    -677,  -678,  -678,  -334,  -678,  -678,   372,  -366,  -678,  -678,
     391,  -678,  -678,  -678,    88,  -678,  -678,  -678,  -678,  -678,
     756,  -678,  -678,  -678,    -2,   411,   -17,  -678,  -678,  -678,
    -678,  -678,  -678,  -678,  -678,  -678,   -20,  -504,   257,   284,
     176,    12,  -678,    36,  -678,  -678,   -71,  -275,  -678,  -678,
    -678,  -678,   113,  -678,  -614,  -678,   130,  -678,  -678,  -396,
    -678,  -678,  -678,  -678,  -655,  -416,  -205,  -175,   433,  -678,
    -678,   188,  -546,  -335,  -678,  -678,  -678
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
       0,   137,   138,   333,   197,   140,   141,   142,   143,   144,
     145,   146,   147,   148,   149,   150,   151,   198,   199,   307,
     400,   401,   266,   267,   402,   177,   373,    30,    31,   178,
      83,    91,    84,    92,    33,   201,    34,    35,    36,   165,
     166,   167,   168,   169,   252,   253,   474,   259,   260,   476,
      37,    73,   108,   187,   188,    38,   239,    39,   159,   360,
      99,   265,   375,    40,    41,   170,   376,   377,   378,   379,
     380,   204,   205,   541,   458,   542,   652,   242,   358,   403,
     404,   405,   406,   270,   179,   180,   407,   408,   486,   409,
     410,   411,   412,   712,   713,   757,   413,   414,    42,    43,
      44,    45,   103,    46,   189,   415,    47,    48,    49,   184,
     106,   185,   522,   720,   186,   447,   154,   628,   420,   421,
     520,   717,   718,   719,   275,   433,   286,   287,   439,   689,
     288,   693,   694,   741,   695,   698,   699,   430,   431,   432,
     289,   437,   438,   290,   678,   441,   328,   685,   503,   643,
     644,   645,   686,   687,   734,   807,   782
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      76,    95,   241,    75,   329,    32,    78,    85,   241,   153,
      29,   449,   248,   200,    90,   361,    76,   630,    74,    75,
     533,   100,   492,   650,    87,    93,   502,    79,   502,    28,
     525,   733,   320,   250,    97,   217,   314,   762,   235,   309,
     731,   511,   513,   514,   731,   211,   212,   213,    32,   697,
     418,   780,   104,    29,    86,   714,   731,   229,   230,   334,
     111,   732,    88,   155,   110,   732,    76,   173,   641,    75,
     772,   510,    28,   690,   101,   156,   781,   732,   200,   171,
     152,   200,   309,   784,   160,   241,   731,    76,   731,   357,
      75,   295,    80,   468,   580,   225,   226,    93,   714,   221,
     746,   222,   336,   534,   535,   214,   330,   732,   236,   732,
     206,   215,   783,   337,   338,   339,   419,   216,   813,   677,
      81,   567,   355,    21,   642,    21,   572,   164,   804,   642,
     247,   250,   176,   701,   637,   727,   243,    82,   251,   261,
      14,    15,   736,    21,   738,   254,   774,   247,   171,   582,
     449,   105,   454,   171,   455,   171,   257,   511,   202,   449,
      90,     1,     2,     3,     4,     5,   107,   227,   830,   228,
      76,    93,   739,    75,   152,    14,    15,   262,   206,   362,
      86,   309,   775,    86,   206,   366,   206,    14,    15,   312,
     467,    76,    86,   206,    75,    76,   164,   755,    75,   661,
     255,   164,    86,   164,   425,   479,   434,   483,   268,   331,
     459,    21,  -301,   335,   316,   317,   767,   318,   319,   484,
     485,   451,   765,   679,   680,   161,   202,   543,  -171,   313,
     766,   806,   202,   172,   202,  -217,    21,   162,  -217,   316,
     317,   202,   318,   319,   152,   381,   171,   321,    25,   417,
     152,   310,   416,   311,   636,    21,   152,   721,   722,   723,
      26,   174,   823,   440,   442,     1,     2,     3,     4,     5,
     374,    76,   291,   175,    75,   372,   829,   322,   292,    14,
      15,   244,   207,   323,   507,   324,   325,   326,   327,  -115,
    -117,   190,   152,   245,   164,   705,   706,   707,   709,   191,
     291,  -115,  -117,   157,   163,   546,   452,   548,   549,   363,
     469,   551,   487,   776,   241,   653,   470,   308,   554,   208,
     309,   364,   634,   635,   209,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,   261,    18,    19,    20,
     381,   254,   477,   367,   574,   575,   576,   655,  -198,   578,
      21,   633,    25,   656,   456,   368,    90,   210,   312,   276,
    -198,   544,   223,   224,    26,   374,   457,    93,   155,   417,
     372,   496,   493,   545,   493,   568,   569,   570,   231,   277,
     660,   232,   681,   152,   791,   793,   234,   417,    86,   417,
     416,  -219,   416,   233,  -219,   278,   218,   778,   478,   779,
     219,   724,   556,   237,   557,   220,   316,   317,   279,   318,
     319,   316,   317,   280,   318,   319,   440,   518,   519,    27,
     742,   104,   281,   282,   344,   345,   346,   347,   264,   283,
     465,   284,   285,   466,   426,   682,   683,   684,   427,   428,
     429,   312,   269,   443,   550,   825,   444,   271,   445,   272,
     446,  -209,    21,   273,  -209,   274,   152,   638,   100,   315,
     639,   293,   561,   662,   563,   564,   309,   552,   417,   157,
     788,   493,   696,   152,   663,   152,   664,   309,   359,   309,
     667,   313,   752,   668,   769,   309,   374,   770,   163,   818,
     821,   372,   819,   822,   696,   365,   417,   627,   382,   493,
     626,   627,   703,   704,   626,   181,   182,   183,   369,   730,
     809,    86,   424,   711,   810,   427,   428,   429,   696,   435,
     743,   340,   341,   436,   342,   343,   453,   173,   139,   422,
     423,   460,   348,   349,   461,   462,   463,   696,   464,   743,
     276,   472,   480,   312,   152,   488,   417,   374,   481,   493,
     482,   708,   372,   832,   489,   490,   491,   494,   497,   835,
     277,   498,   838,   504,   506,   508,   309,   509,   515,   529,
     193,   194,   196,   530,   516,  -300,   278,   517,   521,   526,
     527,   316,   317,   478,   318,   319,   528,   139,   531,   279,
     532,   536,   537,   540,   280,   790,   538,   539,   820,   547,
     555,   566,   571,   281,   282,   573,   577,   579,   640,   646,
     283,   581,   284,   631,   647,   801,   802,   648,   649,   440,
     440,   651,   139,   654,   657,   658,   659,   833,   665,   666,
     836,   669,   296,   297,   298,   299,   300,   301,   302,   303,
     304,   305,   417,   417,   417,   493,   493,   493,   670,   518,
     716,   672,   673,   440,   440,   440,   674,   374,   675,   676,
     677,   688,   372,   692,   827,   139,   139,   139,   139,   139,
     139,   139,   139,   139,   139,   139,   139,   139,   139,   139,
     139,   139,   139,   697,   700,   702,   725,   710,   726,   728,
     729,    77,   139,   744,   737,   763,   748,   735,   139,   306,
     627,    89,    94,   626,   139,   749,   750,   745,   751,   440,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,   753,   754,   764,   768,   777,
     785,   417,   771,   773,   493,   787,   789,   797,   792,   794,
     139,   786,    21,   796,   800,   716,   799,   795,   808,   109,
    -461,  -462,  -463,  -460,   803,   257,   805,   811,   812,   817,
     824,   815,   139,   826,   828,   831,    77,   834,  -286,   837,
     839,   350,  -306,   351,    94,   246,    22,   814,    23,    24,
     716,   565,   473,   238,   352,   450,   353,   475,   471,   354,
     263,   258,   417,   560,   294,   493,   523,   203,   512,   102,
     756,   798,   495,   629,    27,   671,   740,     1,     2,     3,
       4,     5,   816,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,   747,   505,
       0,   139,   691,     0,     0,    77,     0,     0,     0,   256,
     109,    77,    77,     0,     0,    21,     0,   276,    94,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   203,     0,   277,     0,     0,
       0,   203,     0,   203,     0,     0,    50,     0,     0,    22,
     203,    23,    24,   278,     0,     0,     0,  -306,  -306,  -306,
       0,     0,     0,     0,    25,  -287,   279,     0,     0,  -306,
       0,   280,   448,     0,   139,     0,    26,    27,     0,     0,
     281,   282,     0,     0,     0,   139,     0,   283,     0,   284,
       0,   139,     0,   139,     0,     0,     0,     0,     0,    17,
       0,     0,   109,    77,     1,     2,     3,     4,     5,     0,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,     0,    96,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    21,     0,     0,     0,    51,    52,    53,    54,
      55,    56,    57,    58,    22,     0,    23,    24,    59,    60,
      61,    62,   139,     0,     0,    63,    64,     0,     0,    65,
      66,    67,    68,    69,    70,    71,    22,    72,    23,    24,
       0,     0,     0,     0,  -306,  -306,  -306,     0,     0,     0,
       0,    25,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    26,    27,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    94,    50,   112,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   122,     0,   123,   124,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   125,     0,
       0,     1,     2,     3,     4,     5,   383,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,     0,   384,   385,   386,     0,   387,   388,   389,
     390,   391,   392,   393,   394,     0,   126,   127,     0,   128,
     129,     0,   130,     0,     0,  -236,     0,  -264,   131,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   132,     0,
       0,   395,   133,   134,   135,    51,    52,    53,    54,    55,
      56,    57,    58,    22,     0,    23,    24,    59,    60,    61,
      62,     0,     0,     0,    63,    64,   396,   397,   371,    66,
      67,    68,    69,    70,    71,   398,    72,     0,     0,   399,
      26,    27,   136,    50,   112,   113,   114,   115,   116,   117,
     118,   119,   120,   121,   122,     0,   123,   124,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   125,     0,     0,     1,
       2,     3,     4,     5,   383,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
       0,   384,   385,   386,    50,   387,   388,   389,   390,   391,
     392,   393,   394,     0,   126,   127,     0,   128,   129,     0,
     130,     0,     0,  -236,     0,  -265,   131,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   132,     0,     0,   395,
     133,   134,   135,    51,    52,    53,    54,    55,    56,    57,
      58,    22,     0,    23,    24,    59,    60,    61,    62,     0,
       0,     0,    63,    64,   396,   397,   371,    66,    67,    68,
      69,    70,    71,   398,    72,     0,    98,   399,    26,    27,
     136,    50,   112,   113,   114,   115,   116,   117,   118,   119,
     120,   121,   122,     0,   123,   124,     0,     0,     0,     0,
       0,     0,     0,     0,    51,    52,    53,    54,    55,    56,
      57,    58,     0,     0,   125,     0,    59,    60,    61,    62,
       0,     0,     0,    63,    64,     0,     0,    65,    66,    67,
      68,    69,    70,    71,    17,    72,     0,     0,     0,   384,
     385,   386,     0,   387,   388,   389,   390,   391,   392,   393,
     394,     0,   126,   127,     0,   128,   129,     0,   130,     0,
       0,  -236,     0,     0,   131,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   132,     0,     0,   395,   133,   134,
     135,    51,    52,    53,    54,    55,    56,    57,    58,    22,
       0,    23,    24,    59,    60,    61,    62,     0,     0,     0,
      63,    64,   396,   397,    65,    66,    67,    68,    69,    70,
      71,   398,    72,     0,     0,   399,     0,     0,   136,    50,
     112,   113,   114,   115,   116,   117,   118,   119,   120,   121,
     122,     0,   123,   124,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   125,     0,     0,     0,     0,     0,     0,     0,
       0,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,     0,     0,     0,     0,
       0,     0,    50,     0,     0,     0,     0,     0,     0,     0,
     126,   127,     0,   128,   129,     0,   130,     0,     0,     0,
       0,     0,   131,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   132,     0,     0,     0,   133,   134,   135,    51,
      52,    53,    54,    55,    56,    57,    58,    22,     0,    23,
      24,    59,    60,    61,    62,   562,     0,     0,    63,    64,
       0,     0,    65,    66,    67,    68,    69,    70,    71,     0,
      72,     0,     0,     0,     0,    27,   136,    50,   112,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,     0,
     123,   124,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    51,    52,    53,    54,    55,    56,    57,    58,
     125,     0,     0,     0,    59,    60,    61,    62,     0,     0,
       0,    63,    64,     0,     0,    65,    66,    67,    68,    69,
      70,    71,    50,    72,     0,     0,     0,   386,     0,   387,
     388,   389,   390,   391,   392,   393,   394,     0,   126,   127,
       0,   128,   129,     0,   130,     0,     0,  -236,     0,     0,
     131,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     132,     0,     0,   395,   133,   134,   135,    51,   758,   759,
      54,   760,   761,    57,    58,    17,     0,     0,     0,    59,
      60,    61,    62,     0,     0,     0,    63,    64,   396,   397,
      65,    66,    67,    68,    69,    70,    71,   398,    72,     0,
       0,   399,     0,     0,   136,    50,   112,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   122,     0,   123,   124,
       0,     0,    51,    52,    53,    54,    55,    56,    57,    58,
      22,     0,    23,    24,    59,    60,    61,    62,   125,     0,
       0,    63,    64,     0,     0,    65,    66,    67,    68,    69,
      70,    71,     0,    72,     0,     0,     0,     0,    50,     0,
       0,     0,     0,     0,     0,   386,     0,   387,   388,   389,
     390,   391,   392,   393,   394,     0,   126,   127,     0,   128,
     129,     0,   130,     0,     0,  -236,     0,     0,   131,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   132,     0,
       0,   395,   133,   134,   135,    51,    52,    53,    54,    55,
      56,    57,    58,     0,     0,     0,     0,    59,    60,    61,
      62,     0,     0,     0,    63,    64,   396,   397,    65,    66,
      67,    68,    69,    70,    71,   398,    72,     0,     0,   399,
       0,     0,   136,    50,   112,   113,   114,   115,   116,   117,
     118,   119,   120,   121,   122,     0,   123,   124,    51,    52,
      53,    54,    55,    56,    57,    58,     0,     0,     0,     0,
      59,    60,    61,    62,     0,     0,   125,    63,    64,     0,
       0,    65,    66,    67,    68,    69,    70,    71,     0,    72,
       0,     0,     0,     0,     0,     0,    50,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   126,   127,     0,   128,   129,     0,
     130,     0,     0,     0,     0,     0,   131,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   132,     0,     0,     0,
     133,   134,   135,    51,    52,    53,    54,    55,    56,    57,
      58,   499,     0,   500,   501,    59,    60,    61,    62,     0,
       0,     0,    63,    64,     0,     0,    65,    66,    67,    68,
      69,    70,    71,     0,    72,     0,     0,     0,     0,     0,
     136,    50,   112,   113,   114,   115,   116,   117,   118,   119,
     120,   121,   122,     0,   123,   124,    51,    52,    53,    54,
      55,    56,    57,    58,     0,     0,     0,     0,    59,    60,
      61,    62,     0,     0,   125,   715,    64,     0,     0,    65,
      66,    67,    68,    69,    70,    71,     0,    72,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   126,   127,     0,   128,   129,     0,   130,     0,
       0,   240,     0,   356,   131,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   132,     0,     0,     0,   133,   134,
     135,    51,    52,    53,    54,    55,    56,    57,    58,     0,
       0,     0,     0,    59,    60,    61,    62,     0,     0,     0,
      63,    64,     0,     0,    65,    66,    67,    68,    69,    70,
      71,     0,    72,     0,     0,     0,     0,     0,   136,    50,
     112,   113,   114,   115,   116,   117,   118,   119,   120,   121,
     122,     0,   123,   124,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   125,     1,     2,     3,     4,     5,     0,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
       0,    18,    19,    20,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     126,   127,     0,   128,   129,     0,   130,     0,     0,   240,
       0,   553,   131,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   132,     0,     0,     0,   133,   134,   135,    51,
      52,    53,    54,    55,    56,    57,    58,     0,     0,     0,
       0,    59,    60,    61,    62,     0,     0,     0,    63,    64,
      25,     0,    65,    66,    67,    68,    69,    70,    71,     0,
      72,     0,    26,    27,     0,     0,   136,    50,   112,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,     0,
     123,   124,     0,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,     0,     0,
     125,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   249,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   126,   127,
       0,   128,   129,     0,   130,     0,     0,   240,     0,    22,
     131,    23,    24,     0,     0,     0,     0,     0,     0,     0,
     132,     0,     0,     0,   133,   134,   135,    51,    52,    53,
      54,    55,    56,    57,    58,     0,     0,    27,     0,    59,
      60,    61,    62,     0,     0,     0,    63,    64,     0,     0,
      65,    66,    67,    68,    69,    70,    71,     0,    72,     0,
     276,     0,     0,     0,   136,    50,   112,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   122,     0,   123,   124,
     277,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,   278,     0,   125,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   279,
       0,     0,     0,     0,   280,   524,     0,     0,     0,     0,
       0,   370,     0,   281,   282,     0,     0,     0,     0,     0,
     283,     0,   284,     0,     0,     0,   126,   127,   332,   128,
     129,     0,   130,     0,     0,     0,     0,    22,   131,    23,
      24,     0,     0,     0,     0,     0,     0,     0,   132,     0,
       0,     0,   133,   134,   135,    51,    52,    53,    54,    55,
      56,    57,    58,     0,     0,    27,     0,    59,    60,    61,
      62,     0,     0,     0,    63,    64,     0,     0,    65,    66,
      67,    68,    69,    70,    71,     0,    72,     0,   276,     0,
       0,     0,   136,    50,   112,   113,   114,   115,   116,   117,
     118,   119,   120,   121,   122,     0,   123,   124,   277,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,   278,     0,   125,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   279,     0,     0,
       0,     0,   280,     0,     0,     0,     0,     0,     0,     0,
       0,   281,   282,     0,     0,     0,     0,     0,   283,     0,
     284,     0,     0,     0,   126,   127,     0,   128,   129,     0,
     130,     0,     0,     0,     0,    22,   131,    23,    24,     0,
       0,     0,     0,     0,     0,     0,   132,     0,     0,     0,
     133,   134,   135,    51,    52,    53,    54,    55,    56,    57,
      58,     0,     0,    27,     0,    59,    60,    61,    62,     0,
       0,     0,    63,    64,     0,     0,    65,    66,    67,    68,
      69,    70,    71,     0,    72,     0,     0,     0,     0,     0,
     136,    50,   112,   113,   114,   115,   116,   117,   118,   119,
     120,   121,   122,     0,   123,   124,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   125,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   126,   192,     0,   128,   129,     0,   130,     0,
       0,     0,     0,     0,   131,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   132,     0,     0,     0,   133,   134,
     135,    51,    52,    53,    54,    55,    56,    57,    58,     0,
       0,     0,     0,    59,    60,    61,    62,     0,     0,     0,
      63,    64,     0,     0,    65,    66,    67,    68,    69,    70,
      71,     0,    72,     0,     0,     0,     0,     0,   136,    50,
     112,   113,   114,   115,   116,   117,   118,   119,   120,   121,
     122,     0,   123,   124,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   125,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    50,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     126,   195,     0,   128,   129,     0,   130,     0,     0,     0,
       0,     0,   131,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   132,     0,     0,    50,   133,   134,   135,    51,
      52,    53,    54,    55,    56,    57,    58,     0,     0,     0,
      17,    59,    60,    61,    62,     0,     0,     0,    63,    64,
       0,     0,    65,    66,    67,    68,    69,    70,    71,   158,
      72,     1,     2,     3,     4,     5,   136,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,     0,     0,     0,     0,     0,    51,    52,    53,
      54,    55,    56,    57,    58,    22,     0,    23,    24,    59,
      60,    61,    62,     0,     0,     0,    63,    64,     0,     0,
      65,    66,    67,    68,    69,    70,    71,     0,    72,     0,
       0,     0,     0,     0,     0,    51,    52,    53,    54,    55,
      56,    57,    58,    22,    50,    23,    24,    59,    60,    61,
      62,     0,     0,     0,    63,    64,     0,     0,   371,    66,
      67,    68,    69,    70,    71,     0,    72,     0,     0,     0,
      26,    27,     0,     0,     0,     0,     0,   583,     0,     0,
     584,   585,   586,   587,   588,   589,   590,   591,   592,   593,
     594,   595,   596,   597,   598,   599,   600,    17,   601,   602,
     603,     0,   604,   605,   606,   607,   608,   609,   610,   611,
     612,   613,   614,   615,  -198,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     616,   617,   618,   619,    51,    52,    53,    54,    55,    56,
      57,    58,    22,     0,    23,    24,    59,    60,    61,    62,
     620,   621,   622,    63,    64,   623,   624,    65,    66,    67,
      68,    69,    70,    71,    50,    72,     0,     0,   625,     0,
       0,     0,     0,     0,     0,     0,  -198,     0,    21,     0,
       0,     0,     0,     0,     0,     0,     0,     0,  -198,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,  -198,  -198,  -198,  -198,  -198,  -198,
    -198,  -198,     0,     0,     0,     0,  -198,  -198,  -198,  -198,
       0,     0,     0,  -198,  -198,     0,     0,  -198,  -198,  -198,
    -198,  -198,  -198,  -198,     0,  -198,   558,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   457,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    51,    52,    53,    54,    55,    56,
      57,    58,     0,     0,     0,     0,    59,    60,    61,    62,
       0,     0,     0,    63,    64,     0,     0,    65,    66,    67,
      68,    69,    70,    71,     0,    72,     1,     2,     3,     4,
       5,   383,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,     1,     2,     3,
       4,     5,     0,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,     0,     0,
       0,     0,   632,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    21,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    22,     0,
      23,    24,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    25,     0,     0,     0,     0,     0,    22,
       0,    23,    24,     0,     0,    26,    27,     0,     0,     0,
       0,     0,     0,     0,    25,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    26,    27,     1,     2,
       3,     4,     5,   383,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,    20,     1,
       2,     3,     4,     5,     0,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
     559,     1,     2,     3,     4,     5,     0,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,     0,     0,     0,     0,     0,     0,     0,     0,
      22,     0,    23,    24,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    25,     0,     0,     0,     0,
       0,    22,     0,    23,    24,     0,     0,    26,    27,     0,
       0,     0,     0,     0,     0,     0,    25,     0,     0,     0,
       0,     0,     0,    22,     0,    23,    24,     0,    26,    27,
       0,     0,     0,     0,     0,     0,     0,     0,    25,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      26,    27,  -333,  -333,  -333,  -333,  -333,  -333,  -333,  -333,
    -333,  -333,  -333,  -333,  -333,  -333,  -333,  -333,  -333,  -333,
    -333,  -333,  -333,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
    -333,  -333,     0,     0,     0,  -333,     0,  -333,  -333,  -333,
       0,  -333,     0,     0,     0,     0,  -333,  -333,  -333,  -333,
    -333,  -333,  -333
};

static const yytype_int16 yycheck[] =
{
      20,    32,   157,    20,   209,     0,    21,    29,   163,    81,
       0,   286,   163,   127,    32,   245,    36,   521,    20,    36,
     436,    41,   389,   542,    31,    32,   394,    21,   396,     0,
     426,   686,   207,   165,    36,   140,   204,   714,    25,    79,
      16,   407,   409,   409,    16,    15,    16,    17,    43,    11,
      11,   106,    47,    43,    29,   669,    16,    22,    23,   214,
      80,    37,    31,    79,    79,    37,    86,    98,    72,    86,
     725,   405,    43,    72,     0,    91,   131,    37,   192,    96,
      81,   195,    79,   738,    86,   240,    16,   107,    16,   240,
     107,   195,    75,    90,   134,    20,    21,   104,   712,    78,
      62,    80,   216,   437,   438,    75,   210,    37,    95,    37,
     127,    81,    88,   218,   219,   220,    77,    87,   795,    91,
      75,   488,   236,    77,   128,    77,   494,    96,    88,   128,
     161,   263,   103,   652,   530,   681,   158,    91,    90,   170,
      53,    54,   688,    77,   690,   167,    76,   178,   165,   516,
     425,     4,   307,   170,   309,   172,    90,   523,   127,   434,
     178,    39,    40,    41,    42,    43,    83,    92,   823,    94,
     190,   178,    62,   190,   175,    53,    54,   171,   195,   251,
     155,    79,   728,   158,   201,   257,   203,    53,    54,   204,
      88,   211,   167,   210,   211,   215,   165,    62,   215,   566,
     169,   170,   177,   172,   275,   373,   277,    45,   179,   211,
     315,    77,    90,   215,   104,   105,   720,   107,   108,    57,
      58,   293,    79,   639,   640,    79,   195,   457,    83,   204,
      87,   777,   201,    83,   203,    76,    77,    91,    79,   104,
     105,   210,   107,   108,   245,   265,   263,    75,   126,   269,
     251,   201,   269,   203,   529,    77,   257,   673,   674,   675,
     138,    75,   808,   283,   284,    39,    40,    41,    42,    43,
     265,   291,    79,    87,   291,   265,   822,   105,    85,    53,
      54,    75,    90,   111,   398,   113,   114,   115,   116,    79,
      79,    83,   293,    87,   263,   662,   663,   664,   666,    76,
      79,    91,    91,    93,    93,   460,    85,   462,   463,    79,
      79,   466,   384,   729,   469,   545,    85,    76,   469,    90,
      79,    91,   527,   528,    90,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,   367,    57,    58,    59,
     360,   363,   373,    79,   499,   500,   501,   105,    75,   504,
      77,   526,   126,   111,    75,    91,   374,    75,   373,    63,
      87,    75,    18,    19,   138,   360,    87,   374,    79,   389,
     360,   391,   389,    87,   391,   489,   490,   491,    74,    83,
      91,    89,    75,   384,   751,   753,    24,   407,   363,   409,
     407,    76,   409,    84,    79,    99,    73,   732,   373,   734,
      77,   676,   474,    76,   476,    82,   104,   105,   112,   107,
     108,   104,   105,   117,   107,   108,   436,    78,    79,   139,
     695,   416,   126,   127,   225,   226,   227,   228,    76,   133,
      76,   135,   136,    79,    96,   128,   129,   130,   100,   101,
     102,   456,    83,     4,   464,   812,     7,    83,     9,    83,
      11,    76,    77,    83,    79,   123,   457,    76,   478,    76,
      79,    93,   482,    76,   484,   485,    79,   468,   488,    93,
     745,   488,   647,   474,    76,   476,    76,    79,    76,    79,
      76,   456,    76,    79,    76,    79,   481,    79,    93,    76,
      76,   481,    79,    79,   669,    90,   516,   517,    88,   516,
     517,   521,   657,   658,   521,   119,   120,   121,    90,   684,
     785,   486,    83,   668,   789,   100,   101,   102,   693,    75,
     695,   221,   222,    75,   223,   224,    76,   558,    81,   272,
     273,    75,   229,   230,   103,    75,    75,   712,    79,   714,
      63,    88,    76,   558,   545,    90,   566,   542,    79,   566,
      79,   665,   542,   828,    75,    75,    75,    75,    91,   834,
      83,    91,   837,    75,    91,    91,    79,    91,    85,   132,
     123,   124,   125,    24,    90,    90,    99,    85,    85,    90,
      90,   104,   105,   558,   107,   108,    90,   140,    85,   112,
      11,    83,    87,   118,   117,   750,   134,   134,   803,    76,
      76,    90,    66,   126,   127,    91,    91,    91,    79,    11,
     133,    85,   135,    85,    83,   770,   771,    83,    76,   639,
     640,    88,   175,    76,    79,    79,    76,   832,    75,    91,
     835,    83,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    35,   662,   663,   664,   662,   663,   664,    75,    78,
     670,    38,    75,   673,   674,   675,    75,   652,    75,    64,
      91,    87,   652,    88,   819,   218,   219,   220,   221,   222,
     223,   224,   225,   226,   227,   228,   229,   230,   231,   232,
     233,   234,   235,    11,    76,    88,    76,    91,    76,    87,
      75,    21,   245,    90,    85,   715,    76,    81,   251,    93,
     720,    31,    32,   720,   257,    76,    79,    90,    64,   729,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    91,    76,    76,    76,    75,
      90,   751,    79,   134,   751,    90,    90,    15,    91,    91,
     293,    85,    77,    85,    75,   765,   766,    90,    93,    79,
      90,    90,    90,    90,    83,    90,    76,    76,    76,    76,
      85,    88,   315,    76,    90,    76,    96,    90,     0,    90,
      85,   231,     4,   232,   104,   161,   111,   797,   113,   114,
     800,   486,   363,   155,   233,   291,   234,   367,   360,   235,
     172,   170,   812,   481,   190,   812,   424,   127,   407,    43,
     712,   765,   391,   519,   139,   629,   693,    39,    40,    41,
      42,    43,   800,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,   698,   396,
      -1,   384,   644,    -1,    -1,   165,    -1,    -1,    -1,   169,
     170,   171,   172,    -1,    -1,    77,    -1,    63,   178,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   195,    -1,    83,    -1,    -1,
      -1,   201,    -1,   203,    -1,    -1,     3,    -1,    -1,   111,
     210,   113,   114,    99,    -1,    -1,    -1,   119,   120,   121,
      -1,    -1,    -1,    -1,   126,     0,   112,    -1,    -1,     4,
      -1,   117,   118,    -1,   457,    -1,   138,   139,    -1,    -1,
     126,   127,    -1,    -1,    -1,   468,    -1,   133,    -1,   135,
      -1,   474,    -1,   476,    -1,    -1,    -1,    -1,    -1,    56,
      -1,    -1,   262,   263,    39,    40,    41,    42,    43,    -1,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    -1,    83,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    77,    -1,    -1,    -1,   103,   104,   105,   106,
     107,   108,   109,   110,   111,    -1,   113,   114,   115,   116,
     117,   118,   545,    -1,    -1,   122,   123,    -1,    -1,   126,
     127,   128,   129,   130,   131,   132,   111,   134,   113,   114,
      -1,    -1,    -1,    -1,   119,   120,   121,    -1,    -1,    -1,
      -1,   126,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   138,   139,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   374,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    -1,    16,    17,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    36,    -1,
      -1,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    -1,    61,    62,    63,    -1,    65,    66,    67,
      68,    69,    70,    71,    72,    -1,    74,    75,    -1,    77,
      78,    -1,    80,    -1,    -1,    83,    -1,    85,    86,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,
      -1,    99,   100,   101,   102,   103,   104,   105,   106,   107,
     108,   109,   110,   111,    -1,   113,   114,   115,   116,   117,
     118,    -1,    -1,    -1,   122,   123,   124,   125,   126,   127,
     128,   129,   130,   131,   132,   133,   134,    -1,    -1,   137,
     138,   139,   140,     3,     4,     5,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    -1,    16,    17,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    36,    -1,    -1,    39,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      -1,    61,    62,    63,     3,    65,    66,    67,    68,    69,
      70,    71,    72,    -1,    74,    75,    -1,    77,    78,    -1,
      80,    -1,    -1,    83,    -1,    85,    86,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,    99,
     100,   101,   102,   103,   104,   105,   106,   107,   108,   109,
     110,   111,    -1,   113,   114,   115,   116,   117,   118,    -1,
      -1,    -1,   122,   123,   124,   125,   126,   127,   128,   129,
     130,   131,   132,   133,   134,    -1,    75,   137,   138,   139,
     140,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    -1,    16,    17,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   103,   104,   105,   106,   107,   108,
     109,   110,    -1,    -1,    36,    -1,   115,   116,   117,   118,
      -1,    -1,    -1,   122,   123,    -1,    -1,   126,   127,   128,
     129,   130,   131,   132,    56,   134,    -1,    -1,    -1,    61,
      62,    63,    -1,    65,    66,    67,    68,    69,    70,    71,
      72,    -1,    74,    75,    -1,    77,    78,    -1,    80,    -1,
      -1,    83,    -1,    -1,    86,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    96,    -1,    -1,    99,   100,   101,
     102,   103,   104,   105,   106,   107,   108,   109,   110,   111,
      -1,   113,   114,   115,   116,   117,   118,    -1,    -1,    -1,
     122,   123,   124,   125,   126,   127,   128,   129,   130,   131,
     132,   133,   134,    -1,    -1,   137,    -1,    -1,   140,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    -1,    16,    17,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    36,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    -1,    -1,    -1,    -1,
      -1,    -1,     3,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      74,    75,    -1,    77,    78,    -1,    80,    -1,    -1,    -1,
      -1,    -1,    86,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    96,    -1,    -1,    -1,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   111,    -1,   113,
     114,   115,   116,   117,   118,    56,    -1,    -1,   122,   123,
      -1,    -1,   126,   127,   128,   129,   130,   131,   132,    -1,
     134,    -1,    -1,    -1,    -1,   139,   140,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    -1,
      16,    17,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   103,   104,   105,   106,   107,   108,   109,   110,
      36,    -1,    -1,    -1,   115,   116,   117,   118,    -1,    -1,
      -1,   122,   123,    -1,    -1,   126,   127,   128,   129,   130,
     131,   132,     3,   134,    -1,    -1,    -1,    63,    -1,    65,
      66,    67,    68,    69,    70,    71,    72,    -1,    74,    75,
      -1,    77,    78,    -1,    80,    -1,    -1,    83,    -1,    -1,
      86,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      96,    -1,    -1,    99,   100,   101,   102,   103,   104,   105,
     106,   107,   108,   109,   110,    56,    -1,    -1,    -1,   115,
     116,   117,   118,    -1,    -1,    -1,   122,   123,   124,   125,
     126,   127,   128,   129,   130,   131,   132,   133,   134,    -1,
      -1,   137,    -1,    -1,   140,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    -1,    16,    17,
      -1,    -1,   103,   104,   105,   106,   107,   108,   109,   110,
     111,    -1,   113,   114,   115,   116,   117,   118,    36,    -1,
      -1,   122,   123,    -1,    -1,   126,   127,   128,   129,   130,
     131,   132,    -1,   134,    -1,    -1,    -1,    -1,     3,    -1,
      -1,    -1,    -1,    -1,    -1,    63,    -1,    65,    66,    67,
      68,    69,    70,    71,    72,    -1,    74,    75,    -1,    77,
      78,    -1,    80,    -1,    -1,    83,    -1,    -1,    86,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,
      -1,    99,   100,   101,   102,   103,   104,   105,   106,   107,
     108,   109,   110,    -1,    -1,    -1,    -1,   115,   116,   117,
     118,    -1,    -1,    -1,   122,   123,   124,   125,   126,   127,
     128,   129,   130,   131,   132,   133,   134,    -1,    -1,   137,
      -1,    -1,   140,     3,     4,     5,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    -1,    16,    17,   103,   104,
     105,   106,   107,   108,   109,   110,    -1,    -1,    -1,    -1,
     115,   116,   117,   118,    -1,    -1,    36,   122,   123,    -1,
      -1,   126,   127,   128,   129,   130,   131,   132,    -1,   134,
      -1,    -1,    -1,    -1,    -1,    -1,     3,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    74,    75,    -1,    77,    78,    -1,
      80,    -1,    -1,    -1,    -1,    -1,    86,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,    -1,
     100,   101,   102,   103,   104,   105,   106,   107,   108,   109,
     110,   111,    -1,   113,   114,   115,   116,   117,   118,    -1,
      -1,    -1,   122,   123,    -1,    -1,   126,   127,   128,   129,
     130,   131,   132,    -1,   134,    -1,    -1,    -1,    -1,    -1,
     140,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    -1,    16,    17,   103,   104,   105,   106,
     107,   108,   109,   110,    -1,    -1,    -1,    -1,   115,   116,
     117,   118,    -1,    -1,    36,   122,   123,    -1,    -1,   126,
     127,   128,   129,   130,   131,   132,    -1,   134,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    74,    75,    -1,    77,    78,    -1,    80,    -1,
      -1,    83,    -1,    85,    86,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    96,    -1,    -1,    -1,   100,   101,
     102,   103,   104,   105,   106,   107,   108,   109,   110,    -1,
      -1,    -1,    -1,   115,   116,   117,   118,    -1,    -1,    -1,
     122,   123,    -1,    -1,   126,   127,   128,   129,   130,   131,
     132,    -1,   134,    -1,    -1,    -1,    -1,    -1,   140,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    -1,    16,    17,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    36,    39,    40,    41,    42,    43,    -1,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      -1,    57,    58,    59,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      74,    75,    -1,    77,    78,    -1,    80,    -1,    -1,    83,
      -1,    85,    86,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    96,    -1,    -1,    -1,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,    -1,    -1,    -1,
      -1,   115,   116,   117,   118,    -1,    -1,    -1,   122,   123,
     126,    -1,   126,   127,   128,   129,   130,   131,   132,    -1,
     134,    -1,   138,   139,    -1,    -1,   140,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    -1,
      16,    17,    -1,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    -1,    -1,
      36,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    85,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    74,    75,
      -1,    77,    78,    -1,    80,    -1,    -1,    83,    -1,   111,
      86,   113,   114,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      96,    -1,    -1,    -1,   100,   101,   102,   103,   104,   105,
     106,   107,   108,   109,   110,    -1,    -1,   139,    -1,   115,
     116,   117,   118,    -1,    -1,    -1,   122,   123,    -1,    -1,
     126,   127,   128,   129,   130,   131,   132,    -1,   134,    -1,
      63,    -1,    -1,    -1,   140,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    -1,    16,    17,
      83,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    99,    -1,    36,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   112,
      -1,    -1,    -1,    -1,   117,   118,    -1,    -1,    -1,    -1,
      -1,    85,    -1,   126,   127,    -1,    -1,    -1,    -1,    -1,
     133,    -1,   135,    -1,    -1,    -1,    74,    75,    76,    77,
      78,    -1,    80,    -1,    -1,    -1,    -1,   111,    86,   113,
     114,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,
      -1,    -1,   100,   101,   102,   103,   104,   105,   106,   107,
     108,   109,   110,    -1,    -1,   139,    -1,   115,   116,   117,
     118,    -1,    -1,    -1,   122,   123,    -1,    -1,   126,   127,
     128,   129,   130,   131,   132,    -1,   134,    -1,    63,    -1,
      -1,    -1,   140,     3,     4,     5,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    -1,    16,    17,    83,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    99,    -1,    36,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   112,    -1,    -1,
      -1,    -1,   117,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   126,   127,    -1,    -1,    -1,    -1,    -1,   133,    -1,
     135,    -1,    -1,    -1,    74,    75,    -1,    77,    78,    -1,
      80,    -1,    -1,    -1,    -1,   111,    86,   113,   114,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,    -1,
     100,   101,   102,   103,   104,   105,   106,   107,   108,   109,
     110,    -1,    -1,   139,    -1,   115,   116,   117,   118,    -1,
      -1,    -1,   122,   123,    -1,    -1,   126,   127,   128,   129,
     130,   131,   132,    -1,   134,    -1,    -1,    -1,    -1,    -1,
     140,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    -1,    16,    17,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    36,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    74,    75,    -1,    77,    78,    -1,    80,    -1,
      -1,    -1,    -1,    -1,    86,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    96,    -1,    -1,    -1,   100,   101,
     102,   103,   104,   105,   106,   107,   108,   109,   110,    -1,
      -1,    -1,    -1,   115,   116,   117,   118,    -1,    -1,    -1,
     122,   123,    -1,    -1,   126,   127,   128,   129,   130,   131,
     132,    -1,   134,    -1,    -1,    -1,    -1,    -1,   140,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    -1,    16,    17,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    36,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,     3,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      74,    75,    -1,    77,    78,    -1,    80,    -1,    -1,    -1,
      -1,    -1,    86,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    96,    -1,    -1,     3,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,    -1,    -1,    -1,
      56,   115,   116,   117,   118,    -1,    -1,    -1,   122,   123,
      -1,    -1,   126,   127,   128,   129,   130,   131,   132,    75,
     134,    39,    40,    41,    42,    43,   140,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    -1,    -1,    -1,    -1,    -1,   103,   104,   105,
     106,   107,   108,   109,   110,   111,    -1,   113,   114,   115,
     116,   117,   118,    -1,    -1,    -1,   122,   123,    -1,    -1,
     126,   127,   128,   129,   130,   131,   132,    -1,   134,    -1,
      -1,    -1,    -1,    -1,    -1,   103,   104,   105,   106,   107,
     108,   109,   110,   111,     3,   113,   114,   115,   116,   117,
     118,    -1,    -1,    -1,   122,   123,    -1,    -1,   126,   127,
     128,   129,   130,   131,   132,    -1,   134,    -1,    -1,    -1,
     138,   139,    -1,    -1,    -1,    -1,    -1,    36,    -1,    -1,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    -1,    61,    62,    63,    64,    65,    66,    67,    68,
      69,    70,    71,    72,     3,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,   111,    -1,   113,   114,   115,   116,   117,   118,
     119,   120,   121,   122,   123,   124,   125,   126,   127,   128,
     129,   130,   131,   132,     3,   134,    -1,    -1,   137,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    75,    -1,    77,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    87,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   103,   104,   105,   106,   107,   108,
     109,   110,    -1,    -1,    -1,    -1,   115,   116,   117,   118,
      -1,    -1,    -1,   122,   123,    -1,    -1,   126,   127,   128,
     129,   130,   131,   132,    -1,   134,    75,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    87,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   103,   104,   105,   106,   107,   108,
     109,   110,    -1,    -1,    -1,    -1,   115,   116,   117,   118,
      -1,    -1,    -1,   122,   123,    -1,    -1,   126,   127,   128,
     129,   130,   131,   132,    -1,   134,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    39,    40,    41,
      42,    43,    -1,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    -1,    -1,
      -1,    -1,    85,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    77,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   111,    -1,
     113,   114,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   126,    -1,    -1,    -1,    -1,    -1,   111,
      -1,   113,   114,    -1,    -1,   138,   139,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   126,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   138,   139,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    39,
      40,    41,    42,    43,    -1,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    39,    40,    41,    42,    43,    -1,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     111,    -1,   113,   114,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   126,    -1,    -1,    -1,    -1,
      -1,   111,    -1,   113,   114,    -1,    -1,   138,   139,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   126,    -1,    -1,    -1,
      -1,    -1,    -1,   111,    -1,   113,   114,    -1,   138,   139,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   126,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     138,   139,    15,    16,    17,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      73,    74,    -1,    -1,    -1,    78,    -1,    80,    81,    82,
      -1,    84,    -1,    -1,    -1,    -1,    89,    90,    91,    92,
      93,    94,    95
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int16 yystos[] =
{
       0,    39,    40,    41,    42,    43,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    77,   111,   113,   114,   126,   138,   139,   166,   167,
     169,   170,   171,   176,   178,   179,   180,   192,   197,   199,
     205,   206,   240,   241,   242,   243,   245,   248,   249,   250,
       3,   103,   104,   105,   106,   107,   108,   109,   110,   115,
     116,   117,   118,   122,   123,   126,   127,   128,   129,   130,
     131,   132,   134,   193,   246,   248,   258,   197,   205,   207,
      75,    75,    91,   172,   174,   198,   206,   176,   178,   197,
     169,   173,   175,   176,   197,   199,    83,   246,    75,   202,
     258,     0,   242,   244,   171,     4,   252,    83,   194,   197,
     205,   258,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    16,    17,    36,    74,    75,    77,    78,
      80,    86,    96,   100,   101,   102,   140,   143,   144,   146,
     147,   148,   149,   150,   151,   152,   153,   154,   155,   156,
     157,   158,   159,   164,   258,    79,    91,    93,    75,   200,
     246,    79,    91,    93,   178,   181,   182,   183,   184,   185,
     207,   248,    83,   199,    75,    87,   166,   167,   171,   226,
     227,   119,   120,   121,   251,   253,   256,   195,   196,   246,
      83,    76,    75,   146,   146,    75,   146,   146,   159,   160,
     162,   177,   178,   197,   213,   214,   248,    90,    90,    90,
      75,    15,    16,    17,    75,    81,    87,   148,    73,    77,
      82,    78,    80,    18,    19,    20,    21,    92,    94,    22,
      23,    74,    89,    84,    24,    25,    95,    76,   174,   198,
      83,   160,   219,   198,    75,    87,   175,   199,   219,    85,
     182,    90,   186,   187,   198,   178,   197,    90,   184,   189,
     190,   199,   207,   181,    76,   203,   164,   165,   166,    83,
     225,    83,    83,    83,   123,   266,    63,    83,    99,   112,
     117,   126,   127,   133,   135,   136,   268,   269,   272,   282,
     285,    79,    85,    93,   195,   214,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    93,   161,    76,    79,
     213,   213,   205,   206,   215,    76,   104,   105,   107,   108,
     289,    75,   105,   111,   113,   114,   115,   116,   288,   288,
     214,   246,    76,   145,   160,   246,   162,   148,   148,   148,
     149,   149,   150,   150,   151,   151,   151,   151,   152,   152,
     153,   154,   155,   156,   157,   162,    85,   219,   220,    76,
     201,   165,   164,    79,    91,    90,   164,    79,    91,    90,
      85,   126,   167,   168,   171,   204,   208,   209,   210,   211,
     212,   258,    88,    44,    61,    62,    63,    65,    66,    67,
      68,    69,    70,    71,    72,    99,   124,   125,   133,   137,
     162,   163,   166,   221,   222,   223,   224,   228,   229,   231,
     232,   233,   234,   238,   239,   247,   248,   258,    11,    77,
     260,   261,   260,   260,    83,   268,    96,   100,   101,   102,
     279,   280,   281,   267,   268,    75,    75,   283,   284,   270,
     258,   287,   258,     4,     7,     9,    11,   257,   118,   269,
     196,   164,    85,    76,   160,   160,    75,    87,   216,   148,
      75,   103,    75,    75,    79,    76,    79,    88,    90,    79,
      85,   204,    88,   187,   188,   190,   191,   199,   206,   215,
      76,    79,    79,    45,    57,    58,   230,   164,    90,    75,
      75,    75,   221,   248,    75,   247,   258,    91,    91,   111,
     113,   114,   163,   290,    75,   290,    91,   162,    91,    91,
     225,   229,   232,   221,   229,    85,    90,    85,    78,    79,
     262,    85,   254,   228,   118,   281,    90,    90,    90,   132,
      24,    85,    11,   287,   225,   225,    83,    87,   134,   134,
     118,   215,   217,   165,    75,    87,   160,    76,   160,   160,
     258,   160,   159,    85,   219,    76,   164,   164,    75,    60,
     211,   258,    56,   258,   258,   172,    90,   221,   162,   162,
     162,    66,   163,    91,   160,   160,   160,    91,   160,    91,
     134,    85,   221,    36,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    57,    58,    59,    61,    62,    63,    64,    65,    66,
      67,    68,    69,    70,    71,    72,    99,   100,   101,   102,
     119,   120,   121,   124,   125,   137,   248,   258,   259,   261,
     259,    85,    85,   289,   288,   288,   269,   281,    76,    79,
      79,    72,   128,   291,   292,   293,    11,    83,    83,    76,
     209,    88,   218,   165,    76,   105,   111,    79,    79,    76,
      91,   221,    76,    76,    76,    75,    91,    76,    79,    83,
      75,   262,    38,    75,    75,    75,    64,    91,   286,   287,
     287,    75,   128,   129,   130,   289,   294,   295,    87,   271,
      72,   293,    88,   273,   274,   276,   289,    11,   277,   278,
      76,   209,    88,   160,   160,   221,   221,   221,   162,   163,
      91,   160,   235,   236,   276,   122,   258,   263,   264,   265,
     255,   287,   287,   287,   269,    76,    76,   294,    87,    75,
     289,    16,    37,   286,   296,    81,   294,    85,   294,    62,
     274,   275,   269,   289,    90,    90,    62,   278,    76,    76,
      79,    64,    76,    91,    76,    62,   236,   237,   104,   105,
     107,   108,   222,   258,    76,    79,    87,   259,    76,    76,
      79,    79,   286,   134,    76,   294,   287,    75,   295,   295,
     106,   131,   298,    88,   286,    90,    85,    90,   269,    90,
     160,   221,    91,   163,    91,    90,    85,    15,   265,   258,
      75,   160,   160,    83,    88,    76,   294,   297,    93,   269,
     269,    76,    76,   222,   258,    88,   263,    76,    76,    79,
     288,    76,    79,   294,    85,   221,    76,   160,    90,   294,
     286,    76,   269,   288,    90,   269,   288,    90,   269,    85
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int16 yyr1[] =
{
       0,   142,   143,   143,   143,   143,   143,   143,   143,   143,
     143,   143,   143,   143,   143,   144,   144,   144,   144,   144,
     144,   144,   144,   144,   144,   144,   145,   145,   146,   146,
     146,   146,   146,   146,   146,   147,   147,   147,   147,   147,
     147,   148,   148,   149,   149,   149,   149,   150,   150,   150,
     151,   151,   151,   152,   152,   152,   152,   152,   153,   153,
     153,   154,   154,   155,   155,   156,   156,   157,   157,   158,
     158,   159,   159,   160,   160,   161,   161,   161,   161,   161,
     161,   161,   161,   161,   161,   161,   162,   162,   163,   163,
     164,   165,   165,   166,   166,   166,   167,   167,   168,   168,
     169,   169,   169,   170,   170,   170,   170,   171,   171,   171,
     171,   172,   172,   173,   173,   174,   174,   175,   175,   176,
     176,   176,   176,   176,   176,   176,   177,   177,   178,   178,
     178,   178,   178,   178,   178,   178,   178,   178,   178,   178,
     179,   179,   179,   180,   180,   181,   181,   182,   182,   183,
     183,   184,   184,   184,   185,   185,   185,   186,   186,   187,
     187,   188,   187,   189,   189,   190,   190,   191,   190,   193,
     192,   194,   192,   192,   195,   195,   196,   196,   197,   197,
     198,   199,   200,   200,   200,   201,   200,   202,   202,   202,
     203,   202,   204,   204,   205,   205,   205,   205,   206,   206,
     207,   207,   208,   208,   209,   209,   210,   210,   211,   211,
     211,   212,   212,   213,   213,   213,   213,   214,   214,   215,
     215,   216,   216,   216,   217,   216,   218,   216,   219,   219,
     219,   219,   220,   220,   221,   221,   223,   222,   222,   222,
     222,   222,   222,   222,   224,   224,   224,   225,   225,   226,
     226,   227,   227,   228,   228,   229,   229,   230,   230,   230,
     230,   231,   231,   231,   232,   232,   233,   234,   234,   234,
     234,   235,   235,   236,   237,   237,   238,   238,   238,   239,
     239,   239,   239,   239,   239,   239,   240,   240,   241,   241,
     242,   242,   242,   244,   243,   245,   245,   245,   246,   246,
     247,   247,   248,   248,   248,   248,   250,   249,   251,   251,
     251,   252,   252,   253,   254,   255,   253,   256,   257,   257,
     257,   257,   258,   258,   258,   258,   258,   258,   258,   258,
     258,   258,   258,   258,   258,   258,   258,   258,   258,   258,
     258,   258,   258,   258,   258,   259,   259,   259,   259,   259,
     259,   259,   259,   259,   259,   259,   259,   259,   259,   259,
     259,   259,   259,   259,   259,   259,   259,   259,   259,   259,
     259,   259,   259,   259,   259,   259,   259,   259,   259,   259,
     259,   259,   259,   259,   259,   259,   259,   259,   259,   259,
     260,   260,   260,   261,   261,   262,   262,   263,   263,   263,
     264,   264,   265,   265,   265,   266,   266,   267,   267,   268,
     268,   269,   269,   269,   269,   270,   271,   269,   272,   272,
     272,   272,   272,   273,   273,   274,   275,   275,   276,   276,
     277,   277,   278,   279,   279,   280,   280,   281,   281,   281,
     281,   281,   283,   282,   284,   282,   285,   285,   286,   286,
     287,   287,   288,   288,   288,   288,   288,   288,   288,   288,
     289,   289,   289,   289,   290,   290,   290,   290,   291,   291,
     291,   292,   292,   293,   294,   294,   294,   295,   295,   295,
     295,   295,   295,   296,   297,   297,   298,   298
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
       1,     1,     1,     1,     1,     4,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     4,
       5,     4,     2,     1,     1,     1,     2,     3,     3,     1,
       2,     1,     2,     1,     1,     2,     2,     1,     3,     1,
       2,     0,     4,     1,     3,     1,     2,     0,     4,     0,
       5,     0,     6,     2,     1,     3,     1,     3,     1,     1,
       2,     2,     1,     3,     4,     0,     5,     1,     3,     4,
       0,     5,     1,     1,     1,     2,     2,     3,     0,     1,
       1,     2,     1,     3,     0,     1,     1,     3,     2,     1,
       2,     1,     3,     1,     1,     2,     2,     1,     2,     1,
       2,     3,     3,     4,     0,     4,     0,     5,     1,     2,
       3,     4,     1,     3,     1,     1,     0,     2,     1,     1,
       1,     1,     5,     7,     3,     4,     3,     3,     4,     1,
       2,     0,     1,     1,     2,     1,     4,     1,     2,     2,
       2,     1,     2,     2,     0,     1,     2,     5,     7,     5,
       7,     1,     2,     2,     0,     3,     5,     7,     9,     3,
       2,     2,     3,     3,     2,     2,     0,     1,     1,     2,
       1,     1,     1,     0,     4,     1,     2,     2,     1,     1,
       1,     1,     1,     1,     1,     1,     0,     3,     4,     3,
       4,     0,     1,     8,     0,     0,    11,     5,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       0,     2,     4,     1,     1,     0,     1,     0,     1,     4,
       1,     3,     1,     2,     4,     0,     4,     0,     1,     1,
       2,     1,     1,     1,     3,     0,     0,     6,     4,     6,
       7,     9,    18,     1,     2,     2,     0,     3,     2,     3,
       1,     2,     3,     1,     2,     1,     3,     6,     6,     8,
       8,    10,     0,     3,     0,     3,     5,     7,     0,     1,
       1,     4,     1,     1,     1,     1,     1,     1,     4,     4,
       1,     1,     1,     1,     1,     2,     2,     2,     4,     3,
       1,     1,     2,     7,     1,     3,     3,     1,     4,     5,
       4,     3,     3,     1,     1,     3,     1,     1
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
#line 90 "rttgram.y"
                  {(yyval.n) = sym_node((yyvsp[0].t));}
#line 2567 "rttgram.tab.c"
    break;

  case 3: /* primary_expr: StrLit  */
#line 91 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2573 "rttgram.tab.c"
    break;

  case 4: /* primary_expr: LStrLit  */
#line 92 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2579 "rttgram.tab.c"
    break;

  case 5: /* primary_expr: FltConst  */
#line 93 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2585 "rttgram.tab.c"
    break;

  case 6: /* primary_expr: DblConst  */
#line 94 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2591 "rttgram.tab.c"
    break;

  case 7: /* primary_expr: LDblConst  */
#line 95 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2597 "rttgram.tab.c"
    break;

  case 8: /* primary_expr: CharConst  */
#line 96 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2603 "rttgram.tab.c"
    break;

  case 9: /* primary_expr: LCharConst  */
#line 97 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2609 "rttgram.tab.c"
    break;

  case 10: /* primary_expr: IntConst  */
#line 98 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2615 "rttgram.tab.c"
    break;

  case 11: /* primary_expr: UIntConst  */
#line 99 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2621 "rttgram.tab.c"
    break;

  case 12: /* primary_expr: LIntConst  */
#line 100 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2627 "rttgram.tab.c"
    break;

  case 13: /* primary_expr: ULIntConst  */
#line 101 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2633 "rttgram.tab.c"
    break;

  case 14: /* primary_expr: '(' expr ')'  */
#line 102 "rttgram.y"
                  {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 2639 "rttgram.tab.c"
    break;

  case 16: /* postfix_expr: postfix_expr '[' expr ']'  */
#line 107 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                        free_t((yyvsp[0].t));}
#line 2646 "rttgram.tab.c"
    break;

  case 17: /* postfix_expr: postfix_expr '(' ')'  */
#line 109 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), NULL);
                                        free_t((yyvsp[-1].t));}
#line 2653 "rttgram.tab.c"
    break;

  case 18: /* postfix_expr: postfix_expr '(' arg_expr_lst ')'  */
#line 111 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                        free_t((yyvsp[-2].t));}
#line 2660 "rttgram.tab.c"
    break;

  case 19: /* postfix_expr: postfix_expr '.' any_ident  */
#line 113 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2666 "rttgram.tab.c"
    break;

  case 20: /* postfix_expr: postfix_expr Arrow any_ident  */
#line 114 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2672 "rttgram.tab.c"
    break;

  case 21: /* postfix_expr: postfix_expr Incr  */
#line 115 "rttgram.y"
                                       {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-1].n));}
#line 2678 "rttgram.tab.c"
    break;

  case 22: /* postfix_expr: postfix_expr Decr  */
#line 116 "rttgram.y"
                                       {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-1].n));}
#line 2684 "rttgram.tab.c"
    break;

  case 23: /* postfix_expr: Is ':' i_type_name '(' assign_expr ')'  */
#line 118 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-5].t), (yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 2690 "rttgram.tab.c"
    break;

  case 24: /* postfix_expr: Cnv ':' dest_type '(' assign_expr ',' assign_expr ')'  */
#line 120 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-7].t), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-6].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 2697 "rttgram.tab.c"
    break;

  case 25: /* postfix_expr: Def ':' dest_type '(' assign_expr ',' assign_expr ',' assign_expr ')'  */
#line 123 "rttgram.y"
      {(yyval.n) = node4(QuadNd, (yyvsp[-9].t), (yyvsp[-7].n), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-8].t)); free_t((yyvsp[-6].t));
       free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 2704 "rttgram.tab.c"
    break;

  case 27: /* arg_expr_lst: arg_expr_lst ',' assign_expr  */
#line 129 "rttgram.y"
                                  {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2710 "rttgram.tab.c"
    break;

  case 29: /* unary_expr: Incr unary_expr  */
#line 134 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2716 "rttgram.tab.c"
    break;

  case 30: /* unary_expr: Decr unary_expr  */
#line 135 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2722 "rttgram.tab.c"
    break;

  case 31: /* unary_expr: unary_op cast_expr  */
#line 136 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2728 "rttgram.tab.c"
    break;

  case 32: /* unary_expr: Sizeof unary_expr  */
#line 137 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2734 "rttgram.tab.c"
    break;

  case 33: /* unary_expr: Sizeof '(' type_name ')'  */
#line 138 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                               free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 2741 "rttgram.tab.c"
    break;

  case 34: /* unary_expr: Offsetof '(' type_name ',' identifier ')'  */
#line 141 "rttgram.y"
      {(yyval.n) = node1(PrefxNd, (yyvsp[-5].t),
                   node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), node0(PrimryNd, (yyvsp[-1].t))));
       free_t((yyvsp[-4].t)); free_t((yyvsp[0].t));}
#line 2749 "rttgram.tab.c"
    break;

  case 42: /* cast_expr: '(' type_name ')' cast_expr  */
#line 157 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-3].t), (yyvsp[-2].n), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 2755 "rttgram.tab.c"
    break;

  case 44: /* multiplicative_expr: multiplicative_expr '*' cast_expr  */
#line 162 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2761 "rttgram.tab.c"
    break;

  case 45: /* multiplicative_expr: multiplicative_expr '/' cast_expr  */
#line 163 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2767 "rttgram.tab.c"
    break;

  case 46: /* multiplicative_expr: multiplicative_expr '%' cast_expr  */
#line 164 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2773 "rttgram.tab.c"
    break;

  case 48: /* additive_expr: additive_expr '+' multiplicative_expr  */
#line 169 "rttgram.y"
                                           {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2779 "rttgram.tab.c"
    break;

  case 49: /* additive_expr: additive_expr '-' multiplicative_expr  */
#line 170 "rttgram.y"
                                           {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2785 "rttgram.tab.c"
    break;

  case 51: /* shift_expr: shift_expr LShft additive_expr  */
#line 175 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2791 "rttgram.tab.c"
    break;

  case 52: /* shift_expr: shift_expr RShft additive_expr  */
#line 176 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2797 "rttgram.tab.c"
    break;

  case 54: /* relational_expr: relational_expr '<' shift_expr  */
#line 181 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2803 "rttgram.tab.c"
    break;

  case 55: /* relational_expr: relational_expr '>' shift_expr  */
#line 182 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2809 "rttgram.tab.c"
    break;

  case 56: /* relational_expr: relational_expr Leq shift_expr  */
#line 183 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2815 "rttgram.tab.c"
    break;

  case 57: /* relational_expr: relational_expr Geq shift_expr  */
#line 184 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2821 "rttgram.tab.c"
    break;

  case 59: /* equality_expr: equality_expr Equal relational_expr  */
#line 189 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2827 "rttgram.tab.c"
    break;

  case 60: /* equality_expr: equality_expr Neq relational_expr  */
#line 190 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2833 "rttgram.tab.c"
    break;

  case 62: /* and_expr: and_expr '&' equality_expr  */
#line 195 "rttgram.y"
                                {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2839 "rttgram.tab.c"
    break;

  case 64: /* exclusive_or_expr: exclusive_or_expr '^' and_expr  */
#line 200 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2845 "rttgram.tab.c"
    break;

  case 66: /* inclusive_or_expr: inclusive_or_expr '|' exclusive_or_expr  */
#line 205 "rttgram.y"
                                             {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2851 "rttgram.tab.c"
    break;

  case 68: /* logical_and_expr: logical_and_expr And inclusive_or_expr  */
#line 210 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2857 "rttgram.tab.c"
    break;

  case 70: /* logical_or_expr: logical_or_expr Or logical_and_expr  */
#line 215 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2863 "rttgram.tab.c"
    break;

  case 72: /* conditional_expr: logical_or_expr '?' expr ':' conditional_expr  */
#line 221 "rttgram.y"
                                         {(yyval.n) = node3(TrnryNd, (yyvsp[-3].t), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n));
                                          free_t((yyvsp[-1].t));}
#line 2870 "rttgram.tab.c"
    break;

  case 74: /* assign_expr: unary_expr assign_op assign_expr  */
#line 227 "rttgram.y"
                                      {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2876 "rttgram.tab.c"
    break;

  case 87: /* expr: expr ',' assign_expr  */
#line 246 "rttgram.y"
                          {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2882 "rttgram.tab.c"
    break;

  case 88: /* opt_expr: %empty  */
#line 250 "rttgram.y"
     {(yyval.n) = NULL;}
#line 2888 "rttgram.tab.c"
    break;

  case 91: /* opt_constant_expr: %empty  */
#line 259 "rttgram.y"
     {(yyval.n) = NULL;}
#line 2894 "rttgram.tab.c"
    break;

  case 93: /* dcltion: typ_dcltion_specs ';'  */
#line 264 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-1].n), NULL);
                                             dcl_stk->kind_dcl = OtherDcl;}
#line 2901 "rttgram.tab.c"
    break;

  case 94: /* dcltion: typ_dcltion_specs init_dcltor_lst ';'  */
#line 266 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));
                                             dcl_stk->kind_dcl = OtherDcl;}
#line 2908 "rttgram.tab.c"
    break;

  case 95: /* dcltion: storcl_tqual_lst no_tdn_init_dcltor_lst ';'  */
#line 269 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));
                                             dcl_stk->kind_dcl = OtherDcl;}
#line 2915 "rttgram.tab.c"
    break;

  case 97: /* typ_dcltion_specs: storcl_tqual_lst type_ind  */
#line 275 "rttgram.y"
                               {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2921 "rttgram.tab.c"
    break;

  case 100: /* type_ind: typedefname  */
#line 284 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2927 "rttgram.tab.c"
    break;

  case 101: /* type_ind: typedefname storcl_tqual_lst  */
#line 286 "rttgram.y"
                             {(yyval.n) = node2(LstNd, NULL, node0(PrimryNd, (yyvsp[-1].t)), (yyvsp[0].n));}
#line 2933 "rttgram.tab.c"
    break;

  case 104: /* type_storcl_tqual_lst: type_storcl_tqual_lst stnd_type  */
#line 292 "rttgram.y"
                                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2939 "rttgram.tab.c"
    break;

  case 105: /* type_storcl_tqual_lst: type_storcl_tqual_lst storage_class_spec  */
#line 293 "rttgram.y"
                                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2945 "rttgram.tab.c"
    break;

  case 106: /* type_storcl_tqual_lst: type_storcl_tqual_lst type_qual  */
#line 294 "rttgram.y"
                                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2951 "rttgram.tab.c"
    break;

  case 109: /* storcl_tqual_lst: storcl_tqual_lst storage_class_spec  */
#line 300 "rttgram.y"
                                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2957 "rttgram.tab.c"
    break;

  case 110: /* storcl_tqual_lst: storcl_tqual_lst type_qual  */
#line 301 "rttgram.y"
                                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2963 "rttgram.tab.c"
    break;

  case 112: /* init_dcltor_lst: init_dcltor_lst ',' init_dcltor  */
#line 306 "rttgram.y"
                                     {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2969 "rttgram.tab.c"
    break;

  case 114: /* no_tdn_init_dcltor_lst: no_tdn_init_dcltor_lst ',' no_tdn_init_dcltor  */
#line 312 "rttgram.y"
                                              {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2975 "rttgram.tab.c"
    break;

  case 115: /* init_dcltor: dcltor  */
#line 316 "rttgram.y"
                            {(yyval.n) = (yyvsp[0].n); id_def((yyvsp[0].n), NULL);}
#line 2981 "rttgram.tab.c"
    break;

  case 116: /* init_dcltor: dcltor '=' initializer  */
#line 317 "rttgram.y"
                            {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n)); id_def((yyvsp[-2].n), (yyvsp[0].n));}
#line 2987 "rttgram.tab.c"
    break;

  case 117: /* no_tdn_init_dcltor: no_tdn_dcltor  */
#line 321 "rttgram.y"
                              {(yyval.n) = (yyvsp[0].n); id_def((yyvsp[0].n), NULL);}
#line 2993 "rttgram.tab.c"
    break;

  case 118: /* no_tdn_init_dcltor: no_tdn_dcltor '=' initializer  */
#line 323 "rttgram.y"
                              {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n)); id_def((yyvsp[-2].n), (yyvsp[0].n));}
#line 2999 "rttgram.tab.c"
    break;

  case 119: /* storage_class_spec: Typedef  */
#line 327 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t)); dcl_stk->kind_dcl = IsTypedef;}
#line 3005 "rttgram.tab.c"
    break;

  case 120: /* storage_class_spec: Extern  */
#line 328 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3011 "rttgram.tab.c"
    break;

  case 121: /* storage_class_spec: Static  */
#line 329 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3017 "rttgram.tab.c"
    break;

  case 122: /* storage_class_spec: Auto  */
#line 330 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3023 "rttgram.tab.c"
    break;

  case 123: /* storage_class_spec: Register  */
#line 331 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3029 "rttgram.tab.c"
    break;

  case 124: /* storage_class_spec: Inline  */
#line 332 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3035 "rttgram.tab.c"
    break;

  case 125: /* storage_class_spec: Declspec '(' identifier ')'  */
#line 333 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[0].t),
                                             node0(PrimryNd, (yyvsp[-3].t)),
                                             node0(PrimryNd, (yyvsp[-1].t)));
                                  free_t((yyvsp[-2].t));}
#line 3044 "rttgram.tab.c"
    break;

  case 127: /* type_spec: typedefname  */
#line 341 "rttgram.y"
                 {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3050 "rttgram.tab.c"
    break;

  case 128: /* stnd_type: Void  */
#line 345 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3056 "rttgram.tab.c"
    break;

  case 129: /* stnd_type: Char  */
#line 346 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3062 "rttgram.tab.c"
    break;

  case 130: /* stnd_type: Short  */
#line 347 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3068 "rttgram.tab.c"
    break;

  case 131: /* stnd_type: Int  */
#line 348 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3074 "rttgram.tab.c"
    break;

  case 132: /* stnd_type: Long  */
#line 349 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3080 "rttgram.tab.c"
    break;

  case 133: /* stnd_type: Float  */
#line 350 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3086 "rttgram.tab.c"
    break;

  case 134: /* stnd_type: Doubl  */
#line 351 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3092 "rttgram.tab.c"
    break;

  case 135: /* stnd_type: Signed  */
#line 352 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3098 "rttgram.tab.c"
    break;

  case 136: /* stnd_type: Unsigned  */
#line 353 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3104 "rttgram.tab.c"
    break;

  case 139: /* stnd_type: B_IProc_Type '(' constant_expr ')'  */
#line 356 "rttgram.y"
                                        {(yyval.n) = node2(BinryNd, (yyvsp[0].t),
                                                    node0(PrimryNd, (yyvsp[-3].t)), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t));}
#line 3112 "rttgram.tab.c"
    break;

  case 140: /* struct_or_union_spec: struct_or_union any_ident '{' struct_dcltion_lst '}'  */
#line 363 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                             free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3119 "rttgram.tab.c"
    break;

  case 141: /* struct_or_union_spec: struct_or_union '{' struct_dcltion_lst '}'  */
#line 366 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-3].t), NULL, (yyvsp[-1].n));
                                             free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3126 "rttgram.tab.c"
    break;

  case 142: /* struct_or_union_spec: struct_or_union any_ident  */
#line 368 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[0].n), NULL);}
#line 3132 "rttgram.tab.c"
    break;

  case 146: /* struct_dcltion_lst: struct_dcltion_lst struct_dcltion  */
#line 378 "rttgram.y"
                                       {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3138 "rttgram.tab.c"
    break;

  case 147: /* struct_dcltion: struct_dcltion_specs struct_dcltor_lst ';'  */
#line 383 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));}
#line 3144 "rttgram.tab.c"
    break;

  case 148: /* struct_dcltion: tqual_lst struct_no_tdn_dcltor_lst ';'  */
#line 384 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));}
#line 3150 "rttgram.tab.c"
    break;

  case 150: /* struct_dcltion_specs: tqual_lst struct_type_ind  */
#line 389 "rttgram.y"
                                {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3156 "rttgram.tab.c"
    break;

  case 151: /* struct_type_ind: typedefname  */
#line 393 "rttgram.y"
                            {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3162 "rttgram.tab.c"
    break;

  case 152: /* struct_type_ind: typedefname tqual_lst  */
#line 394 "rttgram.y"
                            {(yyval.n) = node2(LstNd, NULL, node0(PrimryNd, (yyvsp[-1].t)), (yyvsp[0].n));}
#line 3168 "rttgram.tab.c"
    break;

  case 155: /* struct_type_lst: struct_type_lst stnd_type  */
#line 400 "rttgram.y"
                               {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3174 "rttgram.tab.c"
    break;

  case 156: /* struct_type_lst: struct_type_lst type_qual  */
#line 401 "rttgram.y"
                               {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3180 "rttgram.tab.c"
    break;

  case 158: /* struct_dcltor_lst: struct_dcltor_lst ',' struct_dcltor  */
#line 405 "rttgram.y"
                                         {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3186 "rttgram.tab.c"
    break;

  case 159: /* struct_dcltor: dcltor  */
#line 409 "rttgram.y"
                              {(yyval.n) = node2(StrDclNd, NULL, (yyvsp[0].n), NULL);
                               if (dcl_stk->parms_done) pop_cntxt();}
#line 3193 "rttgram.tab.c"
    break;

  case 160: /* struct_dcltor: ':' constant_expr  */
#line 411 "rttgram.y"
                              {(yyval.n) = node2(StrDclNd, (yyvsp[-1].t), NULL, (yyvsp[0].n));}
#line 3199 "rttgram.tab.c"
    break;

  case 161: /* $@1: %empty  */
#line 412 "rttgram.y"
                {if (dcl_stk->parms_done) pop_cntxt();}
#line 3205 "rttgram.tab.c"
    break;

  case 162: /* struct_dcltor: dcltor ':' $@1 constant_expr  */
#line 413 "rttgram.y"
                              {(yyval.n) = node2(StrDclNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[0].n));}
#line 3211 "rttgram.tab.c"
    break;

  case 164: /* struct_no_tdn_dcltor_lst: struct_no_tdn_dcltor_lst ',' struct_no_tdn_dcltor  */
#line 419 "rttgram.y"
                                              {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3217 "rttgram.tab.c"
    break;

  case 165: /* struct_no_tdn_dcltor: no_tdn_dcltor  */
#line 423 "rttgram.y"
                                     {(yyval.n) = node2(StrDclNd, NULL, (yyvsp[0].n), NULL);
                                      if (dcl_stk->parms_done) pop_cntxt();}
#line 3224 "rttgram.tab.c"
    break;

  case 166: /* struct_no_tdn_dcltor: ':' constant_expr  */
#line 425 "rttgram.y"
                                     {(yyval.n) = node2(StrDclNd, (yyvsp[-1].t), NULL, (yyvsp[0].n));}
#line 3230 "rttgram.tab.c"
    break;

  case 167: /* $@2: %empty  */
#line 426 "rttgram.y"
                       {if (dcl_stk->parms_done) pop_cntxt();}
#line 3236 "rttgram.tab.c"
    break;

  case 168: /* struct_no_tdn_dcltor: no_tdn_dcltor ':' $@2 constant_expr  */
#line 427 "rttgram.y"
                                     {(yyval.n) = node2(StrDclNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[0].n));}
#line 3242 "rttgram.tab.c"
    break;

  case 169: /* $@3: %empty  */
#line 431 "rttgram.y"
          {push_cntxt(0);}
#line 3248 "rttgram.tab.c"
    break;

  case 170: /* enum_spec: Enum $@3 '{' enumerator_lst '}'  */
#line 432 "rttgram.y"
       {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), NULL, (yyvsp[-1].n)); pop_cntxt(); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3254 "rttgram.tab.c"
    break;

  case 171: /* $@4: %empty  */
#line 433 "rttgram.y"
                    {push_cntxt(0);}
#line 3260 "rttgram.tab.c"
    break;

  case 172: /* enum_spec: Enum any_ident $@4 '{' enumerator_lst '}'  */
#line 434 "rttgram.y"
       {(yyval.n) = node2(BinryNd, (yyvsp[-5].t), (yyvsp[-4].n),  (yyvsp[-1].n)); pop_cntxt(); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3266 "rttgram.tab.c"
    break;

  case 173: /* enum_spec: Enum any_ident  */
#line 435 "rttgram.y"
                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[0].n),  NULL);}
#line 3272 "rttgram.tab.c"
    break;

  case 175: /* enumerator_lst: enumerator_lst ',' enumerator  */
#line 440 "rttgram.y"
                                   {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3278 "rttgram.tab.c"
    break;

  case 176: /* enumerator: any_ident  */
#line 444 "rttgram.y"
                              {(yyval.n) = (yyvsp[0].n); id_def((yyvsp[0].n), NULL);}
#line 3284 "rttgram.tab.c"
    break;

  case 177: /* enumerator: any_ident '=' constant_expr  */
#line 446 "rttgram.y"
                              {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n)); id_def((yyvsp[-2].n), (yyvsp[0].n));}
#line 3290 "rttgram.tab.c"
    break;

  case 178: /* type_qual: Const  */
#line 450 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3296 "rttgram.tab.c"
    break;

  case 179: /* type_qual: Volatile  */
#line 451 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3302 "rttgram.tab.c"
    break;

  case 180: /* dcltor: opt_pointer direct_dcltor  */
#line 456 "rttgram.y"
                                {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3308 "rttgram.tab.c"
    break;

  case 181: /* no_tdn_dcltor: opt_pointer no_tdn_direct_dcltor  */
#line 460 "rttgram.y"
                                      {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3314 "rttgram.tab.c"
    break;

  case 183: /* direct_dcltor: '(' dcltor ')'  */
#line 465 "rttgram.y"
                                              {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3321 "rttgram.tab.c"
    break;

  case 184: /* direct_dcltor: direct_dcltor '[' opt_constant_expr ']'  */
#line 467 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3328 "rttgram.tab.c"
    break;

  case 185: /* $@5: %empty  */
#line 469 "rttgram.y"
                       {push_cntxt(1);}
#line 3334 "rttgram.tab.c"
    break;

  case 186: /* direct_dcltor: direct_dcltor '(' $@5 parm_dcls_or_ids ')'  */
#line 470 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                               if (dcl_stk->nest_lvl == 2)
                                                  dcl_stk->parms_done = 1;
                                                else
                                                  pop_cntxt();
                                               free_t((yyvsp[-3].t));}
#line 3345 "rttgram.tab.c"
    break;

  case 187: /* no_tdn_direct_dcltor: identifier  */
#line 479 "rttgram.y"
                                              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3351 "rttgram.tab.c"
    break;

  case 188: /* no_tdn_direct_dcltor: '(' no_tdn_dcltor ')'  */
#line 480 "rttgram.y"
                                              {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3358 "rttgram.tab.c"
    break;

  case 189: /* no_tdn_direct_dcltor: no_tdn_direct_dcltor '[' opt_constant_expr ']'  */
#line 483 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3365 "rttgram.tab.c"
    break;

  case 190: /* $@6: %empty  */
#line 485 "rttgram.y"
                              {push_cntxt(1);}
#line 3371 "rttgram.tab.c"
    break;

  case 191: /* no_tdn_direct_dcltor: no_tdn_direct_dcltor '(' $@6 parm_dcls_or_ids ')'  */
#line 486 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                               if (dcl_stk->nest_lvl == 2)
                                                  dcl_stk->parms_done = 1;
                                                else
                                                  pop_cntxt();
                                               free_t((yyvsp[-3].t));}
#line 3382 "rttgram.tab.c"
    break;

  case 194: /* pointer: '*'  */
#line 500 "rttgram.y"
                           {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3388 "rttgram.tab.c"
    break;

  case 195: /* pointer: '*' tqual_lst  */
#line 501 "rttgram.y"
                           {(yyval.n) = node1(PreSpcNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 3394 "rttgram.tab.c"
    break;

  case 196: /* pointer: '*' pointer  */
#line 502 "rttgram.y"
                           {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 3400 "rttgram.tab.c"
    break;

  case 197: /* pointer: '*' tqual_lst pointer  */
#line 503 "rttgram.y"
                           {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), node2(LstNd, NULL, (yyvsp[-1].n),(yyvsp[0].n)));}
#line 3406 "rttgram.tab.c"
    break;

  case 198: /* opt_pointer: %empty  */
#line 507 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3412 "rttgram.tab.c"
    break;

  case 201: /* tqual_lst: tqual_lst type_qual  */
#line 513 "rttgram.y"
                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3418 "rttgram.tab.c"
    break;

  case 203: /* param_type_lst: param_lst ',' Ellipsis  */
#line 518 "rttgram.y"
                            {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), node0(PrimryNd, (yyvsp[0].t)));}
#line 3424 "rttgram.tab.c"
    break;

  case 204: /* opt_param_type_lst: %empty  */
#line 522 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3430 "rttgram.tab.c"
    break;

  case 207: /* param_lst: param_lst ',' param_dcltion  */
#line 528 "rttgram.y"
                                 {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3436 "rttgram.tab.c"
    break;

  case 208: /* param_dcltion: dcltion_specs no_tdn_dcltor  */
#line 532 "rttgram.y"
                                   {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));
                                    id_def((yyvsp[0].n), NULL);}
#line 3443 "rttgram.tab.c"
    break;

  case 210: /* param_dcltion: dcltion_specs abstract_dcltor  */
#line 535 "rttgram.y"
                                   {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3449 "rttgram.tab.c"
    break;

  case 211: /* ident_lst: identifier  */
#line 539 "rttgram.y"
                              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3455 "rttgram.tab.c"
    break;

  case 212: /* ident_lst: ident_lst ',' identifier  */
#line 540 "rttgram.y"
                              {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), node0(PrimryNd,(yyvsp[0].t)));}
#line 3461 "rttgram.tab.c"
    break;

  case 215: /* type_tqual_lst: type_spec type_tqual_lst  */
#line 546 "rttgram.y"
                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3467 "rttgram.tab.c"
    break;

  case 216: /* type_tqual_lst: type_qual type_tqual_lst  */
#line 547 "rttgram.y"
                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3473 "rttgram.tab.c"
    break;

  case 218: /* type_name: type_tqual_lst abstract_dcltor  */
#line 552 "rttgram.y"
                                    {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3479 "rttgram.tab.c"
    break;

  case 220: /* abstract_dcltor: opt_pointer direct_abstract_dcltor  */
#line 557 "rttgram.y"
                                        {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3485 "rttgram.tab.c"
    break;

  case 221: /* direct_abstract_dcltor: '(' abstract_dcltor ')'  */
#line 561 "rttgram.y"
                                            {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n));
                                             free_t((yyvsp[0].t));}
#line 3492 "rttgram.tab.c"
    break;

  case 222: /* direct_abstract_dcltor: '[' opt_constant_expr ']'  */
#line 564 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), NULL, (yyvsp[-1].n));
                                             free_t((yyvsp[0].t));}
#line 3499 "rttgram.tab.c"
    break;

  case 223: /* direct_abstract_dcltor: direct_abstract_dcltor '[' opt_constant_expr ']'  */
#line 567 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                             free_t((yyvsp[0].t));}
#line 3506 "rttgram.tab.c"
    break;

  case 224: /* $@7: %empty  */
#line 569 "rttgram.y"
                                {push_cntxt(1);}
#line 3512 "rttgram.tab.c"
    break;

  case 225: /* direct_abstract_dcltor: '(' $@7 opt_param_type_lst ')'  */
#line 570 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), NULL, (yyvsp[-1].n));
                                             pop_cntxt();
                                             free_t((yyvsp[-3].t));}
#line 3520 "rttgram.tab.c"
    break;

  case 226: /* $@8: %empty  */
#line 573 "rttgram.y"
                                {push_cntxt(1);}
#line 3526 "rttgram.tab.c"
    break;

  case 227: /* direct_abstract_dcltor: direct_abstract_dcltor '(' $@8 opt_param_type_lst ')'  */
#line 574 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                             pop_cntxt();
                                             free_t((yyvsp[-3].t));}
#line 3534 "rttgram.tab.c"
    break;

  case 229: /* initializer: '{' '}'  */
#line 581 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), NULL); free_t((yyvsp[0].t));}
#line 3540 "rttgram.tab.c"
    break;

  case 230: /* initializer: '{' initializer_lst '}'  */
#line 583 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3546 "rttgram.tab.c"
    break;

  case 231: /* initializer: '{' initializer_lst ',' '}'  */
#line 585 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), NULL));
                          free_t((yyvsp[0].t));}
#line 3553 "rttgram.tab.c"
    break;

  case 233: /* initializer_lst: initializer_lst ',' initializer  */
#line 591 "rttgram.y"
                                     {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3559 "rttgram.tab.c"
    break;

  case 236: /* $@9: %empty  */
#line 600 "rttgram.y"
     {push_cntxt(1);}
#line 3565 "rttgram.tab.c"
    break;

  case 237: /* non_lbl_stmt: $@9 compound_stmt  */
#line 600 "rttgram.y"
                                    {(yyval.n) = (yyvsp[0].n); pop_cntxt();}
#line 3571 "rttgram.tab.c"
    break;

  case 242: /* non_lbl_stmt: Runerr '(' assign_expr ')' ';'  */
#line 606 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-2].n), NULL); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3577 "rttgram.tab.c"
    break;

  case 243: /* non_lbl_stmt: Runerr '(' assign_expr ',' assign_expr ')' ';'  */
#line 608 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-6].t), (yyvsp[-4].n), (yyvsp[-2].n)); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3583 "rttgram.tab.c"
    break;

  case 244: /* labeled_stmt: label ':' stmt  */
#line 612 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3589 "rttgram.tab.c"
    break;

  case 245: /* labeled_stmt: Case constant_expr ':' stmt  */
#line 613 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-3].t), (yyvsp[-2].n), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 3595 "rttgram.tab.c"
    break;

  case 246: /* labeled_stmt: Default ':' stmt  */
#line 614 "rttgram.y"
                                 {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 3601 "rttgram.tab.c"
    break;

  case 247: /* compound_stmt: '{' opt_stmt_lst '}'  */
#line 618 "rttgram.y"
                                     {(yyval.n) = comp_nd((yyvsp[-2].t), NULL, (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3607 "rttgram.tab.c"
    break;

  case 248: /* compound_stmt: '{' local_dcls opt_stmt_lst '}'  */
#line 619 "rttgram.y"
                                     {(yyval.n) = comp_nd((yyvsp[-3].t), (yyvsp[-2].n),   (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3613 "rttgram.tab.c"
    break;

  case 250: /* dcltion_lst: dcltion_lst dcltion  */
#line 624 "rttgram.y"
                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3619 "rttgram.tab.c"
    break;

  case 251: /* opt_dcltion_lst: %empty  */
#line 628 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3625 "rttgram.tab.c"
    break;

  case 254: /* local_dcls: local_dcls local_dcl  */
#line 634 "rttgram.y"
                          {(yyval.n) = ((yyvsp[0].n) == NULL ? (yyvsp[-1].n) : node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n)));}
#line 3631 "rttgram.tab.c"
    break;

  case 256: /* local_dcl: Tended tended_type init_dcltor_lst ';'  */
#line 640 "rttgram.y"
             {(yyval.n) = NULL; free_t((yyvsp[-3].t)); free_t((yyvsp[0].t)); dcl_stk->kind_dcl = OtherDcl;}
#line 3637 "rttgram.tab.c"
    break;

  case 257: /* tended_type: Char  */
#line 644 "rttgram.y"
                        {tnd_char(); free_t((yyvsp[0].t));}
#line 3643 "rttgram.tab.c"
    break;

  case 258: /* tended_type: Struct identifier  */
#line 645 "rttgram.y"
                        {tnd_strct((yyvsp[0].t)); free_t((yyvsp[-1].t));}
#line 3649 "rttgram.tab.c"
    break;

  case 259: /* tended_type: Struct TypeDefName  */
#line 646 "rttgram.y"
                        {tnd_strct((yyvsp[0].t)); free_t((yyvsp[-1].t));}
#line 3655 "rttgram.tab.c"
    break;

  case 260: /* tended_type: Union identifier  */
#line 647 "rttgram.y"
                        {tnd_union((yyvsp[0].t)); free_t((yyvsp[-1].t));}
#line 3661 "rttgram.tab.c"
    break;

  case 262: /* stmt_lst: stmt_lst stmt  */
#line 652 "rttgram.y"
                   {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3667 "rttgram.tab.c"
    break;

  case 263: /* stmt_lst: stmt_lst local_dcl  */
#line 653 "rttgram.y"
                        {(yyval.n) = ((yyvsp[0].n) == NULL ? (yyvsp[-1].n) : node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n)));}
#line 3673 "rttgram.tab.c"
    break;

  case 264: /* opt_stmt_lst: %empty  */
#line 657 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3679 "rttgram.tab.c"
    break;

  case 266: /* expr_stmt: opt_expr ';'  */
#line 661 "rttgram.y"
                  {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-1].n));}
#line 3685 "rttgram.tab.c"
    break;

  case 267: /* selection_stmt: If '(' expr ')' stmt  */
#line 665 "rttgram.y"
                                         {(yyval.n) = node3(TrnryNd, (yyvsp[-4].t), (yyvsp[-2].n), (yyvsp[0].n),NULL);
                                          free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3692 "rttgram.tab.c"
    break;

  case 268: /* selection_stmt: If '(' expr ')' stmt Else stmt  */
#line 667 "rttgram.y"
                                         {(yyval.n) = node3(TrnryNd, (yyvsp[-6].t), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n));
                                          free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3699 "rttgram.tab.c"
    break;

  case 269: /* selection_stmt: Switch '(' expr ')' stmt  */
#line 669 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-2].n), (yyvsp[0].n));
                                          free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3706 "rttgram.tab.c"
    break;

  case 270: /* selection_stmt: Type_case expr Of '{' c_type_select_lst c_opt_default '}'  */
#line 672 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-6].t), (yyvsp[-5].n), (yyvsp[-2].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[0].t));}
#line 3712 "rttgram.tab.c"
    break;

  case 271: /* c_type_select_lst: c_type_select  */
#line 676 "rttgram.y"
                                     {(yyval.n) = node2(ConCatNd, NULL, NULL, (yyvsp[0].n));}
#line 3718 "rttgram.tab.c"
    break;

  case 272: /* c_type_select_lst: c_type_select_lst c_type_select  */
#line 677 "rttgram.y"
                                     {(yyval.n) = node2(ConCatNd, NULL,   (yyvsp[-1].n), (yyvsp[0].n));}
#line 3724 "rttgram.tab.c"
    break;

  case 273: /* c_type_select: selector_lst non_lbl_stmt  */
#line 681 "rttgram.y"
                               {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3730 "rttgram.tab.c"
    break;

  case 274: /* c_opt_default: %empty  */
#line 685 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3736 "rttgram.tab.c"
    break;

  case 275: /* c_opt_default: Default ':' non_lbl_stmt  */
#line 686 "rttgram.y"
                              {(yyval.n) = (yyvsp[0].n); free_t((yyvsp[-2].t)); free_t((yyvsp[-1].t));}
#line 3742 "rttgram.tab.c"
    break;

  case 276: /* iteration_stmt: While '(' expr ')' stmt  */
#line 690 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-2].n), (yyvsp[0].n));
                                        free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3749 "rttgram.tab.c"
    break;

  case 277: /* iteration_stmt: Do stmt While '(' expr ')' ';'  */
#line 692 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-6].t), (yyvsp[-5].n), (yyvsp[-2].n));
                                        free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));
                                        free_t((yyvsp[0].t));}
#line 3757 "rttgram.tab.c"
    break;

  case 278: /* iteration_stmt: For '(' opt_expr ';' opt_expr ';' opt_expr ')' stmt  */
#line 696 "rttgram.y"
                                       {(yyval.n) = node4(QuadNd, (yyvsp[-8].t), (yyvsp[-6].n), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n));
                                        free_t((yyvsp[-7].t)); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t));
                                        free_t((yyvsp[-1].t));}
#line 3765 "rttgram.tab.c"
    break;

  case 279: /* jump_stmt: Goto label ';'  */
#line 702 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3771 "rttgram.tab.c"
    break;

  case 280: /* jump_stmt: Continue ';'  */
#line 703 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3777 "rttgram.tab.c"
    break;

  case 281: /* jump_stmt: Break ';'  */
#line 704 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3783 "rttgram.tab.c"
    break;

  case 282: /* jump_stmt: Return ret_val ';'  */
#line 705 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3789 "rttgram.tab.c"
    break;

  case 283: /* jump_stmt: Suspend ret_val ';'  */
#line 706 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3795 "rttgram.tab.c"
    break;

  case 284: /* jump_stmt: Fail ';'  */
#line 707 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3801 "rttgram.tab.c"
    break;

  case 285: /* jump_stmt: Errorfail ';'  */
#line 708 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3807 "rttgram.tab.c"
    break;

  case 291: /* external_dcltion: dcltion  */
#line 723 "rttgram.y"
                            {dclout((yyvsp[0].n));}
#line 3813 "rttgram.tab.c"
    break;

  case 293: /* $@10: %empty  */
#line 728 "rttgram.y"
               {func_def((yyvsp[0].n));}
#line 3819 "rttgram.tab.c"
    break;

  case 294: /* function_definition: func_head $@10 opt_dcltion_lst compound_stmt  */
#line 729 "rttgram.y"
                                                          {fncout((yyvsp[-3].n), (yyvsp[-1].n), (yyvsp[0].n));}
#line 3825 "rttgram.tab.c"
    break;

  case 295: /* func_head: no_tdn_dcltor  */
#line 733 "rttgram.y"
                                     {(yyval.n) = node2(LstNd, NULL, NULL, (yyvsp[0].n));}
#line 3831 "rttgram.tab.c"
    break;

  case 296: /* func_head: storcl_tqual_lst no_tdn_dcltor  */
#line 734 "rttgram.y"
                                     {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3837 "rttgram.tab.c"
    break;

  case 297: /* func_head: typ_dcltion_specs dcltor  */
#line 735 "rttgram.y"
                                     {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3843 "rttgram.tab.c"
    break;

  case 298: /* any_ident: identifier  */
#line 739 "rttgram.y"
                 {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3849 "rttgram.tab.c"
    break;

  case 299: /* any_ident: typedefname  */
#line 740 "rttgram.y"
                 {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3855 "rttgram.tab.c"
    break;

  case 300: /* label: identifier  */
#line 744 "rttgram.y"
                 {(yyval.n) = lbl((yyvsp[0].t));}
#line 3861 "rttgram.tab.c"
    break;

  case 301: /* label: typedefname  */
#line 745 "rttgram.y"
                 {(yyval.n) = lbl((yyvsp[0].t));}
#line 3867 "rttgram.tab.c"
    break;

  case 306: /* $@11: %empty  */
#line 760 "rttgram.y"
     {strt_def();}
#line 3873 "rttgram.tab.c"
    break;

  case 308: /* operation: fnc_oper op_declare actions End  */
#line 764 "rttgram.y"
                                     {defout((yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3879 "rttgram.tab.c"
    break;

  case 309: /* operation: keyword actions End  */
#line 765 "rttgram.y"
                                     {defout((yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3885 "rttgram.tab.c"
    break;

  case 310: /* operation: keyword Constant key_const End  */
#line 766 "rttgram.y"
                                     {keyconst((yyvsp[-1].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3891 "rttgram.tab.c"
    break;

  case 311: /* description: %empty  */
#line 770 "rttgram.y"
             {comment = NULL;}
#line 3897 "rttgram.tab.c"
    break;

  case 312: /* description: StrLit  */
#line 771 "rttgram.y"
             {comment = (yyvsp[0].t);}
#line 3903 "rttgram.tab.c"
    break;

  case 313: /* fnc_oper: Function '{' result_seq '}' op_name '(' opt_s_parm_lst ')'  */
#line 776 "rttgram.y"
      {impl_fnc((yyvsp[-3].t)); free_t((yyvsp[-7].t)); free_t((yyvsp[-6].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 3910 "rttgram.tab.c"
    break;

  case 314: /* $@12: %empty  */
#line 778 "rttgram.y"
                             {lex_state = OpHead;}
#line 3916 "rttgram.tab.c"
    break;

  case 315: /* $@13: %empty  */
#line 779 "rttgram.y"
      {lex_state = DfltLex;}
#line 3922 "rttgram.tab.c"
    break;

  case 316: /* fnc_oper: Operator '{' result_seq $@12 '}' OpSym $@13 op_name '(' opt_s_parm_lst ')'  */
#line 780 "rttgram.y"
      {impl_op((yyvsp[-5].t), (yyvsp[-3].t)); free_t((yyvsp[-10].t)); free_t((yyvsp[-9].t)); free_t((yyvsp[-6].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 3929 "rttgram.tab.c"
    break;

  case 317: /* keyword: Keyword '{' result_seq '}' op_name  */
#line 785 "rttgram.y"
       {impl_key((yyvsp[0].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3935 "rttgram.tab.c"
    break;

  case 390: /* result_seq: %empty  */
#line 876 "rttgram.y"
                                {set_r_seq(NoRsltSeq, NoRsltSeq, 0);}
#line 3941 "rttgram.tab.c"
    break;

  case 391: /* result_seq: length opt_plus  */
#line 877 "rttgram.y"
                                {set_r_seq((yyvsp[-1].i), (yyvsp[-1].i), (int)(yyvsp[0].i));}
#line 3947 "rttgram.tab.c"
    break;

  case 392: /* result_seq: length ',' length opt_plus  */
#line 878 "rttgram.y"
                                {set_r_seq((yyvsp[-3].i), (yyvsp[-1].i), (int)(yyvsp[0].i)); free_t((yyvsp[-2].t));}
#line 3953 "rttgram.tab.c"
    break;

  case 393: /* length: IntConst  */
#line 882 "rttgram.y"
              {(yyval.i) = ttol((yyvsp[0].t)); free_t((yyvsp[0].t));}
#line 3959 "rttgram.tab.c"
    break;

  case 394: /* length: '*'  */
#line 883 "rttgram.y"
              {(yyval.i) = UnbndSeq; free_t((yyvsp[0].t));}
#line 3965 "rttgram.tab.c"
    break;

  case 395: /* opt_plus: %empty  */
#line 887 "rttgram.y"
         {(yyval.i) = 0;}
#line 3971 "rttgram.tab.c"
    break;

  case 396: /* opt_plus: '+'  */
#line 888 "rttgram.y"
         {(yyval.i) = 1; free_t((yyvsp[0].t));}
#line 3977 "rttgram.tab.c"
    break;

  case 399: /* opt_s_parm_lst: s_parm_lst '[' identifier ']'  */
#line 894 "rttgram.y"
                                   {var_args((yyvsp[-1].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3983 "rttgram.tab.c"
    break;

  case 401: /* s_parm_lst: s_parm_lst ',' s_parm  */
#line 899 "rttgram.y"
                           {free_t((yyvsp[-1].t));}
#line 3989 "rttgram.tab.c"
    break;

  case 402: /* s_parm: identifier  */
#line 903 "rttgram.y"
                                         {s_prm_def(NULL, (yyvsp[0].t));}
#line 3995 "rttgram.tab.c"
    break;

  case 403: /* s_parm: Underef identifier  */
#line 904 "rttgram.y"
                                         {s_prm_def((yyvsp[0].t), NULL); free_t((yyvsp[-1].t));}
#line 4001 "rttgram.tab.c"
    break;

  case 404: /* s_parm: Underef identifier Arrow identifier  */
#line 905 "rttgram.y"
                                         {s_prm_def((yyvsp[-2].t), (yyvsp[0].t));   free_t((yyvsp[-3].t));
                                          free_t((yyvsp[-1].t));}
#line 4008 "rttgram.tab.c"
    break;

  case 405: /* op_declare: %empty  */
#line 910 "rttgram.y"
     {}
#line 4014 "rttgram.tab.c"
    break;

  case 406: /* op_declare: Declare '{' local_dcls '}'  */
#line 911 "rttgram.y"
                                {d_lst_typ((yyvsp[-1].n)); free_t((yyvsp[-3].t)); free_t((yyvsp[-2].t));
                                 free_t((yyvsp[0].t));}
#line 4021 "rttgram.tab.c"
    break;

  case 407: /* opt_actions: %empty  */
#line 916 "rttgram.y"
     {(yyval.n) = NULL;}
#line 4027 "rttgram.tab.c"
    break;

  case 410: /* actions: actions action  */
#line 922 "rttgram.y"
                    {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4033 "rttgram.tab.c"
    break;

  case 414: /* action: '{' opt_actions '}'  */
#line 929 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 4039 "rttgram.tab.c"
    break;

  case 415: /* $@14: %empty  */
#line 930 "rttgram.y"
              {lex_state = TypeComp;}
#line 4045 "rttgram.tab.c"
    break;

  case 416: /* $@15: %empty  */
#line 931 "rttgram.y"
         {lex_state = DfltLex;}
#line 4051 "rttgram.tab.c"
    break;

  case 417: /* action: Abstract $@14 '{' type_computations $@15 '}'  */
#line 932 "rttgram.y"
         {(yyval.n) = (yyvsp[-2].n); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[0].t));}
#line 4057 "rttgram.tab.c"
    break;

  case 418: /* checking_conversions: If type_check Then action  */
#line 937 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-3].t), (yyvsp[-2].n), (yyvsp[0].n), NULL); free_t((yyvsp[-1].t));}
#line 4063 "rttgram.tab.c"
    break;

  case 419: /* checking_conversions: If type_check Then action Else action  */
#line 939 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-5].t), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4069 "rttgram.tab.c"
    break;

  case 420: /* checking_conversions: Type_case variable Of '{' type_select_lst opt_default '}'  */
#line 941 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-6].t), (yyvsp[-5].n), (yyvsp[-2].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[0].t));}
#line 4075 "rttgram.tab.c"
    break;

  case 421: /* checking_conversions: Len_case identifier Of '{' len_select_lst Default ':' action '}'  */
#line 943 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-8].t), sym_node((yyvsp[-7].t)), (yyvsp[-4].n), (yyvsp[-1].n)); free_t((yyvsp[-6].t)), free_t((yyvsp[-5].t));
       free_t((yyvsp[-3].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4082 "rttgram.tab.c"
    break;

  case 422: /* checking_conversions: Arith_case '(' variable ',' variable ')' Of '{' dest_type ':' action dest_type ':' action dest_type ':' action '}'  */
#line 947 "rttgram.y"
      {(yyval.n) = arith_nd((yyvsp[-17].t), (yyvsp[-15].n), (yyvsp[-13].n), (yyvsp[-9].n), (yyvsp[-7].n), (yyvsp[-6].n), (yyvsp[-4].n), (yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-16].t));
       free_t((yyvsp[-14].t)), free_t((yyvsp[-12].t)); free_t((yyvsp[-11].t)); free_t((yyvsp[-10].t)); free_t((yyvsp[-8].t));
       free_t((yyvsp[-5].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4090 "rttgram.tab.c"
    break;

  case 423: /* type_select_lst: type_select  */
#line 953 "rttgram.y"
                                 {(yyval.n) = node2(ConCatNd, NULL, NULL, (yyvsp[0].n));}
#line 4096 "rttgram.tab.c"
    break;

  case 424: /* type_select_lst: type_select_lst type_select  */
#line 954 "rttgram.y"
                                 {(yyval.n) = node2(ConCatNd, NULL,   (yyvsp[-1].n), (yyvsp[0].n));}
#line 4102 "rttgram.tab.c"
    break;

  case 425: /* type_select: selector_lst action  */
#line 958 "rttgram.y"
                         {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4108 "rttgram.tab.c"
    break;

  case 426: /* opt_default: %empty  */
#line 962 "rttgram.y"
     {(yyval.n) = NULL;}
#line 4114 "rttgram.tab.c"
    break;

  case 427: /* opt_default: Default ':' action  */
#line 963 "rttgram.y"
                        {(yyval.n) = (yyvsp[0].n); free_t((yyvsp[-2].t)); free_t((yyvsp[-1].t));}
#line 4120 "rttgram.tab.c"
    break;

  case 428: /* selector_lst: i_type_name ':'  */
#line 967 "rttgram.y"
                                  {(yyval.n) = node2(ConCatNd, NULL, NULL, (yyvsp[-1].n));
                                   free_t((yyvsp[0].t));}
#line 4127 "rttgram.tab.c"
    break;

  case 429: /* selector_lst: selector_lst i_type_name ':'  */
#line 969 "rttgram.y"
                                  {(yyval.n) = node2(ConCatNd, NULL,   (yyvsp[-2].n), (yyvsp[-1].n));
                                   free_t((yyvsp[0].t));}
#line 4134 "rttgram.tab.c"
    break;

  case 431: /* len_select_lst: len_select_lst len_select  */
#line 975 "rttgram.y"
                               {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4140 "rttgram.tab.c"
    break;

  case 432: /* len_select: IntConst ':' action  */
#line 979 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 4146 "rttgram.tab.c"
    break;

  case 434: /* type_check: '!' simple_check  */
#line 984 "rttgram.y"
                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4152 "rttgram.tab.c"
    break;

  case 436: /* simple_check_conj: simple_check_conj And simple_check  */
#line 989 "rttgram.y"
                                        {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4158 "rttgram.tab.c"
    break;

  case 437: /* simple_check: Is ':' i_type_name '(' variable ')'  */
#line 994 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-5].t), (yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4164 "rttgram.tab.c"
    break;

  case 438: /* simple_check: Cnv ':' dest_type '(' variable ')'  */
#line 996 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-5].t), (yyvsp[-3].n), (yyvsp[-1].n), NULL), dst_alloc((yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t));
       free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4171 "rttgram.tab.c"
    break;

  case 439: /* simple_check: Cnv ':' dest_type '(' variable ',' assign_expr ')'  */
#line 999 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-7].t), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-6].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 4178 "rttgram.tab.c"
    break;

  case 440: /* simple_check: Def ':' dest_type '(' variable ',' assign_expr ')'  */
#line 1002 "rttgram.y"
      {(yyval.n) = node4(QuadNd, (yyvsp[-7].t), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n), NULL), dst_alloc((yyvsp[-5].n), (yyvsp[-3].n)); free_t((yyvsp[-6].t));
       free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4185 "rttgram.tab.c"
    break;

  case 441: /* simple_check: Def ':' dest_type '(' variable ',' assign_expr ',' assign_expr ')'  */
#line 1005 "rttgram.y"
      {(yyval.n) = node4(QuadNd, (yyvsp[-9].t), (yyvsp[-7].n), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-8].t)); free_t((yyvsp[-6].t));
       free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4192 "rttgram.tab.c"
    break;

  case 442: /* $@16: %empty  */
#line 1010 "rttgram.y"
            {push_cntxt(1);}
#line 4198 "rttgram.tab.c"
    break;

  case 443: /* detail_code: Body $@16 compound_stmt  */
#line 1011 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); pop_cntxt();}
#line 4204 "rttgram.tab.c"
    break;

  case 444: /* $@17: %empty  */
#line 1012 "rttgram.y"
            {push_cntxt(1);}
#line 4210 "rttgram.tab.c"
    break;

  case 445: /* detail_code: Inline $@17 compound_stmt  */
#line 1013 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); pop_cntxt();}
#line 4216 "rttgram.tab.c"
    break;

  case 446: /* runerr: Runerr '(' IntConst ')' opt_semi  */
#line 1018 "rttgram.y"
                    {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), node0(PrimryNd, (yyvsp[-2].t)), NULL);
                     free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4223 "rttgram.tab.c"
    break;

  case 447: /* runerr: Runerr '(' IntConst ',' variable ')' opt_semi  */
#line 1021 "rttgram.y"
                    {(yyval.n) = node2(BinryNd, (yyvsp[-6].t), node0(PrimryNd, (yyvsp[-4].t)), (yyvsp[-2].n));
                     free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4230 "rttgram.tab.c"
    break;

  case 449: /* opt_semi: ';'  */
#line 1027 "rttgram.y"
         {free_t((yyvsp[0].t));}
#line 4236 "rttgram.tab.c"
    break;

  case 450: /* variable: identifier  */
#line 1031 "rttgram.y"
                                 {(yyval.n) = sym_node((yyvsp[0].t));}
#line 4242 "rttgram.tab.c"
    break;

  case 451: /* variable: identifier '[' IntConst ']'  */
#line 1032 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), sym_node((yyvsp[-3].t)),
                                    node0(PrimryNd, (yyvsp[-1].t)));
                                  free_t((yyvsp[0].t));}
#line 4250 "rttgram.tab.c"
    break;

  case 452: /* dest_type: IconType  */
#line 1037 "rttgram.y"
                             {(yyval.n) = dest_node((yyvsp[0].t));}
#line 4256 "rttgram.tab.c"
    break;

  case 453: /* dest_type: C_Integer  */
#line 1038 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4262 "rttgram.tab.c"
    break;

  case 454: /* dest_type: C_Double  */
#line 1039 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4268 "rttgram.tab.c"
    break;

  case 455: /* dest_type: C_String  */
#line 1040 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4274 "rttgram.tab.c"
    break;

  case 456: /* dest_type: Tmp_string  */
#line 1041 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t)); ++n_tmp_str;}
#line 4280 "rttgram.tab.c"
    break;

  case 457: /* dest_type: Tmp_cset  */
#line 1042 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t)); ++n_tmp_cset;}
#line 4286 "rttgram.tab.c"
    break;

  case 458: /* dest_type: '(' Exact ')' IconType  */
#line 1043 "rttgram.y"
                             {(yyval.n) = node0(ExactCnv, chk_exct((yyvsp[0].t))); free_t((yyvsp[-3].t));
                              free_t((yyvsp[-2].t)); free_t((yyvsp[-1].t));}
#line 4293 "rttgram.tab.c"
    break;

  case 459: /* dest_type: '(' Exact ')' C_Integer  */
#line 1045 "rttgram.y"
                             {(yyval.n) = node0(ExactCnv, (yyvsp[0].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-2].t));
                              free_t((yyvsp[-1].t));}
#line 4300 "rttgram.tab.c"
    break;

  case 460: /* i_type_name: Any_value  */
#line 1050 "rttgram.y"
                {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4306 "rttgram.tab.c"
    break;

  case 461: /* i_type_name: Empty_type  */
#line 1051 "rttgram.y"
                {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4312 "rttgram.tab.c"
    break;

  case 462: /* i_type_name: IconType  */
#line 1052 "rttgram.y"
                {(yyval.n) = sym_node((yyvsp[0].t));}
#line 4318 "rttgram.tab.c"
    break;

  case 463: /* i_type_name: Variable  */
#line 1053 "rttgram.y"
                {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4324 "rttgram.tab.c"
    break;

  case 465: /* ret_val: C_Integer assign_expr  */
#line 1058 "rttgram.y"
                                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4330 "rttgram.tab.c"
    break;

  case 466: /* ret_val: C_Double assign_expr  */
#line 1059 "rttgram.y"
                                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4336 "rttgram.tab.c"
    break;

  case 467: /* ret_val: C_String assign_expr  */
#line 1060 "rttgram.y"
                                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4342 "rttgram.tab.c"
    break;

  case 468: /* type_computations: side_effect_lst Return type opt_semi  */
#line 1064 "rttgram.y"
                                          {(yyval.n) = node2(AbstrNd, (yyvsp[-2].t),   (yyvsp[-3].n),   (yyvsp[-1].n));}
#line 4348 "rttgram.tab.c"
    break;

  case 469: /* type_computations: Return type opt_semi  */
#line 1065 "rttgram.y"
                                          {(yyval.n) = node2(AbstrNd, (yyvsp[-2].t),   NULL, (yyvsp[-1].n));}
#line 4354 "rttgram.tab.c"
    break;

  case 470: /* type_computations: side_effect_lst  */
#line 1066 "rttgram.y"
                                          {(yyval.n) = node2(AbstrNd, NULL, (yyvsp[0].n), NULL);}
#line 4360 "rttgram.tab.c"
    break;

  case 472: /* side_effect_lst: side_effect_lst side_effect  */
#line 1071 "rttgram.y"
                                 {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4366 "rttgram.tab.c"
    break;

  case 473: /* side_effect: Store '[' type ']' '=' type opt_semi  */
#line 1075 "rttgram.y"
                                          {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                           free_t((yyvsp[-6].t)); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t));}
#line 4373 "rttgram.tab.c"
    break;

  case 475: /* type: type union basic_type  */
#line 1081 "rttgram.y"
                               {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4379 "rttgram.tab.c"
    break;

  case 476: /* type: type Intersect basic_type  */
#line 1082 "rttgram.y"
                               {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4385 "rttgram.tab.c"
    break;

  case 477: /* basic_type: i_type_name  */
#line 1085 "rttgram.y"
                                        {(yyval.n) = node1(IcnTypNd,
                                         copy_t((yyvsp[0].n)->tok), (yyvsp[0].n));}
#line 4392 "rttgram.tab.c"
    break;

  case 478: /* basic_type: Type '(' variable ')'  */
#line 1087 "rttgram.y"
                                        {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4399 "rttgram.tab.c"
    break;

  case 479: /* basic_type: New i_type_name '(' type_lst ')'  */
#line 1089 "rttgram.y"
                                        {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4406 "rttgram.tab.c"
    break;

  case 480: /* basic_type: Store '[' type ']'  */
#line 1091 "rttgram.y"
                                        {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4413 "rttgram.tab.c"
    break;

  case 481: /* basic_type: basic_type '.' attrb_name  */
#line 1093 "rttgram.y"
                                        {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-2].n));
                                         free_t((yyvsp[-1].t));}
#line 4420 "rttgram.tab.c"
    break;

  case 482: /* basic_type: '(' type ')'  */
#line 1095 "rttgram.y"
                                        {(yyval.n) = (yyvsp[-1].n); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4426 "rttgram.tab.c"
    break;

  case 485: /* type_lst: type_lst ',' type  */
#line 1104 "rttgram.y"
                       {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4432 "rttgram.tab.c"
    break;


#line 4436 "rttgram.tab.c"

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

#line 1112 "rttgram.y"


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
