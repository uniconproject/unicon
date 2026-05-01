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
  YYSYMBOL_IfStmt = 142,                   /* IfStmt  */
  YYSYMBOL_YYACCEPT = 143,                 /* $accept  */
  YYSYMBOL_primary_expr = 144,             /* primary_expr  */
  YYSYMBOL_postfix_expr = 145,             /* postfix_expr  */
  YYSYMBOL_arg_expr_lst = 146,             /* arg_expr_lst  */
  YYSYMBOL_unary_expr = 147,               /* unary_expr  */
  YYSYMBOL_unary_op = 148,                 /* unary_op  */
  YYSYMBOL_cast_expr = 149,                /* cast_expr  */
  YYSYMBOL_multiplicative_expr = 150,      /* multiplicative_expr  */
  YYSYMBOL_additive_expr = 151,            /* additive_expr  */
  YYSYMBOL_shift_expr = 152,               /* shift_expr  */
  YYSYMBOL_relational_expr = 153,          /* relational_expr  */
  YYSYMBOL_equality_expr = 154,            /* equality_expr  */
  YYSYMBOL_and_expr = 155,                 /* and_expr  */
  YYSYMBOL_exclusive_or_expr = 156,        /* exclusive_or_expr  */
  YYSYMBOL_inclusive_or_expr = 157,        /* inclusive_or_expr  */
  YYSYMBOL_logical_and_expr = 158,         /* logical_and_expr  */
  YYSYMBOL_logical_or_expr = 159,          /* logical_or_expr  */
  YYSYMBOL_conditional_expr = 160,         /* conditional_expr  */
  YYSYMBOL_assign_expr = 161,              /* assign_expr  */
  YYSYMBOL_assign_op = 162,                /* assign_op  */
  YYSYMBOL_expr = 163,                     /* expr  */
  YYSYMBOL_opt_expr = 164,                 /* opt_expr  */
  YYSYMBOL_constant_expr = 165,            /* constant_expr  */
  YYSYMBOL_opt_constant_expr = 166,        /* opt_constant_expr  */
  YYSYMBOL_dcltion = 167,                  /* dcltion  */
  YYSYMBOL_typ_dcltion_specs = 168,        /* typ_dcltion_specs  */
  YYSYMBOL_dcltion_specs = 169,            /* dcltion_specs  */
  YYSYMBOL_type_ind = 170,                 /* type_ind  */
  YYSYMBOL_type_storcl_tqual_lst = 171,    /* type_storcl_tqual_lst  */
  YYSYMBOL_storcl_tqual_lst = 172,         /* storcl_tqual_lst  */
  YYSYMBOL_init_dcltor_lst = 173,          /* init_dcltor_lst  */
  YYSYMBOL_no_tdn_init_dcltor_lst = 174,   /* no_tdn_init_dcltor_lst  */
  YYSYMBOL_init_dcltor = 175,              /* init_dcltor  */
  YYSYMBOL_no_tdn_init_dcltor = 176,       /* no_tdn_init_dcltor  */
  YYSYMBOL_storage_class_spec = 177,       /* storage_class_spec  */
  YYSYMBOL_type_spec = 178,                /* type_spec  */
  YYSYMBOL_stnd_type = 179,                /* stnd_type  */
  YYSYMBOL_struct_or_union_spec = 180,     /* struct_or_union_spec  */
  YYSYMBOL_struct_or_union = 181,          /* struct_or_union  */
  YYSYMBOL_struct_dcltion_lst = 182,       /* struct_dcltion_lst  */
  YYSYMBOL_struct_dcltion = 183,           /* struct_dcltion  */
  YYSYMBOL_struct_dcltion_specs = 184,     /* struct_dcltion_specs  */
  YYSYMBOL_struct_type_ind = 185,          /* struct_type_ind  */
  YYSYMBOL_struct_type_lst = 186,          /* struct_type_lst  */
  YYSYMBOL_struct_dcltor_lst = 187,        /* struct_dcltor_lst  */
  YYSYMBOL_struct_dcltor = 188,            /* struct_dcltor  */
  YYSYMBOL_189_1 = 189,                    /* $@1  */
  YYSYMBOL_struct_no_tdn_dcltor_lst = 190, /* struct_no_tdn_dcltor_lst  */
  YYSYMBOL_struct_no_tdn_dcltor = 191,     /* struct_no_tdn_dcltor  */
  YYSYMBOL_192_2 = 192,                    /* $@2  */
  YYSYMBOL_enum_spec = 193,                /* enum_spec  */
  YYSYMBOL_194_3 = 194,                    /* $@3  */
  YYSYMBOL_195_4 = 195,                    /* $@4  */
  YYSYMBOL_enumerator_lst = 196,           /* enumerator_lst  */
  YYSYMBOL_enumerator = 197,               /* enumerator  */
  YYSYMBOL_type_qual = 198,                /* type_qual  */
  YYSYMBOL_dcltor = 199,                   /* dcltor  */
  YYSYMBOL_no_tdn_dcltor = 200,            /* no_tdn_dcltor  */
  YYSYMBOL_direct_dcltor = 201,            /* direct_dcltor  */
  YYSYMBOL_202_5 = 202,                    /* $@5  */
  YYSYMBOL_no_tdn_direct_dcltor = 203,     /* no_tdn_direct_dcltor  */
  YYSYMBOL_204_6 = 204,                    /* $@6  */
  YYSYMBOL_parm_dcls_or_ids = 205,         /* parm_dcls_or_ids  */
  YYSYMBOL_pointer = 206,                  /* pointer  */
  YYSYMBOL_opt_pointer = 207,              /* opt_pointer  */
  YYSYMBOL_tqual_lst = 208,                /* tqual_lst  */
  YYSYMBOL_param_type_lst = 209,           /* param_type_lst  */
  YYSYMBOL_opt_param_type_lst = 210,       /* opt_param_type_lst  */
  YYSYMBOL_param_lst = 211,                /* param_lst  */
  YYSYMBOL_param_dcltion = 212,            /* param_dcltion  */
  YYSYMBOL_ident_lst = 213,                /* ident_lst  */
  YYSYMBOL_type_tqual_lst = 214,           /* type_tqual_lst  */
  YYSYMBOL_type_name = 215,                /* type_name  */
  YYSYMBOL_abstract_dcltor = 216,          /* abstract_dcltor  */
  YYSYMBOL_direct_abstract_dcltor = 217,   /* direct_abstract_dcltor  */
  YYSYMBOL_218_7 = 218,                    /* $@7  */
  YYSYMBOL_219_8 = 219,                    /* $@8  */
  YYSYMBOL_initializer = 220,              /* initializer  */
  YYSYMBOL_initializer_lst = 221,          /* initializer_lst  */
  YYSYMBOL_stmt = 222,                     /* stmt  */
  YYSYMBOL_non_lbl_stmt = 223,             /* non_lbl_stmt  */
  YYSYMBOL_224_9 = 224,                    /* $@9  */
  YYSYMBOL_labeled_stmt = 225,             /* labeled_stmt  */
  YYSYMBOL_compound_stmt = 226,            /* compound_stmt  */
  YYSYMBOL_dcltion_lst = 227,              /* dcltion_lst  */
  YYSYMBOL_opt_dcltion_lst = 228,          /* opt_dcltion_lst  */
  YYSYMBOL_local_dcls = 229,               /* local_dcls  */
  YYSYMBOL_local_dcl = 230,                /* local_dcl  */
  YYSYMBOL_tended_type = 231,              /* tended_type  */
  YYSYMBOL_stmt_lst = 232,                 /* stmt_lst  */
  YYSYMBOL_opt_stmt_lst = 233,             /* opt_stmt_lst  */
  YYSYMBOL_expr_stmt = 234,                /* expr_stmt  */
  YYSYMBOL_selection_stmt = 235,           /* selection_stmt  */
  YYSYMBOL_c_type_select_lst = 236,        /* c_type_select_lst  */
  YYSYMBOL_c_type_select = 237,            /* c_type_select  */
  YYSYMBOL_c_opt_default = 238,            /* c_opt_default  */
  YYSYMBOL_iteration_stmt = 239,           /* iteration_stmt  */
  YYSYMBOL_jump_stmt = 240,                /* jump_stmt  */
  YYSYMBOL_translation_unit = 241,         /* translation_unit  */
  YYSYMBOL_extrn_decltn_lst = 242,         /* extrn_decltn_lst  */
  YYSYMBOL_external_dcltion = 243,         /* external_dcltion  */
  YYSYMBOL_function_definition = 244,      /* function_definition  */
  YYSYMBOL_245_10 = 245,                   /* $@10  */
  YYSYMBOL_func_head = 246,                /* func_head  */
  YYSYMBOL_any_ident = 247,                /* any_ident  */
  YYSYMBOL_label = 248,                    /* label  */
  YYSYMBOL_typedefname = 249,              /* typedefname  */
  YYSYMBOL_definition = 250,               /* definition  */
  YYSYMBOL_251_11 = 251,                   /* $@11  */
  YYSYMBOL_operation = 252,                /* operation  */
  YYSYMBOL_description = 253,              /* description  */
  YYSYMBOL_fnc_oper = 254,                 /* fnc_oper  */
  YYSYMBOL_255_12 = 255,                   /* $@12  */
  YYSYMBOL_256_13 = 256,                   /* $@13  */
  YYSYMBOL_keyword = 257,                  /* keyword  */
  YYSYMBOL_key_const = 258,                /* key_const  */
  YYSYMBOL_identifier = 259,               /* identifier  */
  YYSYMBOL_op_name = 260,                  /* op_name  */
  YYSYMBOL_result_seq = 261,               /* result_seq  */
  YYSYMBOL_length = 262,                   /* length  */
  YYSYMBOL_opt_plus = 263,                 /* opt_plus  */
  YYSYMBOL_opt_s_parm_lst = 264,           /* opt_s_parm_lst  */
  YYSYMBOL_s_parm_lst = 265,               /* s_parm_lst  */
  YYSYMBOL_s_parm = 266,                   /* s_parm  */
  YYSYMBOL_op_declare = 267,               /* op_declare  */
  YYSYMBOL_opt_actions = 268,              /* opt_actions  */
  YYSYMBOL_actions = 269,                  /* actions  */
  YYSYMBOL_action = 270,                   /* action  */
  YYSYMBOL_271_14 = 271,                   /* $@14  */
  YYSYMBOL_272_15 = 272,                   /* $@15  */
  YYSYMBOL_checking_conversions = 273,     /* checking_conversions  */
  YYSYMBOL_type_select_lst = 274,          /* type_select_lst  */
  YYSYMBOL_type_select = 275,              /* type_select  */
  YYSYMBOL_opt_default = 276,              /* opt_default  */
  YYSYMBOL_selector_lst = 277,             /* selector_lst  */
  YYSYMBOL_len_select_lst = 278,           /* len_select_lst  */
  YYSYMBOL_len_select = 279,               /* len_select  */
  YYSYMBOL_type_check = 280,               /* type_check  */
  YYSYMBOL_simple_check_conj = 281,        /* simple_check_conj  */
  YYSYMBOL_simple_check = 282,             /* simple_check  */
  YYSYMBOL_detail_code = 283,              /* detail_code  */
  YYSYMBOL_284_16 = 284,                   /* $@16  */
  YYSYMBOL_285_17 = 285,                   /* $@17  */
  YYSYMBOL_runerr = 286,                   /* runerr  */
  YYSYMBOL_opt_semi = 287,                 /* opt_semi  */
  YYSYMBOL_variable = 288,                 /* variable  */
  YYSYMBOL_dest_type = 289,                /* dest_type  */
  YYSYMBOL_i_type_name = 290,              /* i_type_name  */
  YYSYMBOL_ret_val = 291,                  /* ret_val  */
  YYSYMBOL_type_computations = 292,        /* type_computations  */
  YYSYMBOL_side_effect_lst = 293,          /* side_effect_lst  */
  YYSYMBOL_side_effect = 294,              /* side_effect  */
  YYSYMBOL_type = 295,                     /* type  */
  YYSYMBOL_basic_type = 296,               /* basic_type  */
  YYSYMBOL_union = 297,                    /* union  */
  YYSYMBOL_type_lst = 298,                 /* type_lst  */
  YYSYMBOL_attrb_name = 299                /* attrb_name  */
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
#define YYFINAL  103
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   3549

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  143
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  157
/* YYNRULES -- Number of rules.  */
#define YYNRULES  489
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  843

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   371


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
     141,   142
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
     328,   329,   330,   331,   332,   333,   334,   341,   342,   346,
     347,   348,   349,   350,   351,   352,   353,   354,   355,   356,
     357,   363,   366,   369,   373,   374,   378,   379,   383,   385,
     389,   390,   394,   395,   396,   400,   401,   402,   405,   406,
     410,   412,   413,   413,   418,   419,   424,   426,   427,   427,
     432,   432,   434,   434,   436,   440,   441,   445,   446,   451,
     452,   457,   461,   465,   466,   468,   470,   470,   480,   481,
     483,   486,   486,   496,   497,   501,   502,   503,   504,   508,
     509,   513,   514,   518,   519,   523,   524,   528,   529,   533,
     535,   536,   540,   541,   545,   546,   547,   548,   552,   553,
     557,   558,   562,   564,   567,   570,   570,   574,   574,   581,
     582,   583,   585,   591,   592,   596,   597,   601,   601,   602,
     603,   604,   605,   606,   608,   613,   614,   615,   619,   620,
     624,   625,   629,   630,   634,   635,   639,   640,   645,   646,
     647,   648,   652,   653,   654,   658,   659,   662,   666,   668,
     670,   672,   677,   678,   682,   686,   687,   691,   693,   696,
     703,   704,   705,   706,   707,   708,   709,   713,   714,   718,
     719,   723,   724,   725,   729,   729,   734,   735,   736,   740,
     741,   745,   746,   750,   751,   752,   753,   761,   761,   765,
     766,   767,   771,   772,   776,   779,   780,   779,   785,   790,
     791,   792,   793,   800,   801,   802,   803,   804,   805,   806,
     807,   808,   809,   810,   811,   812,   813,   814,   815,   816,
     817,   818,   819,   820,   821,   822,   823,   830,   831,   832,
     833,   834,   835,   836,   837,   838,   839,   840,   841,   842,
     843,   844,   845,   846,   847,   848,   849,   850,   851,   852,
     853,   854,   855,   856,   857,   858,   859,   860,   861,   862,
     863,   864,   865,   866,   867,   868,   869,   870,   871,   872,
     873,   874,   878,   879,   880,   884,   885,   889,   890,   894,
     895,   896,   900,   901,   905,   906,   907,   912,   913,   918,
     919,   923,   924,   928,   929,   930,   931,   932,   933,   932,
     938,   940,   942,   944,   947,   955,   956,   960,   964,   965,
     969,   971,   976,   977,   981,   985,   986,   990,   991,   995,
     997,  1000,  1003,  1006,  1012,  1012,  1014,  1014,  1019,  1022,
    1028,  1029,  1033,  1034,  1039,  1040,  1041,  1042,  1043,  1044,
    1045,  1047,  1052,  1053,  1054,  1055,  1059,  1060,  1061,  1062,
    1066,  1067,  1068,  1072,  1073,  1077,  1082,  1083,  1084,  1087,
    1089,  1091,  1093,  1095,  1097,  1101,  1105,  1106,  1110,  1111
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
  "Offsetof", "Thread_local", "IfStmt", "$accept", "primary_expr",
  "postfix_expr", "arg_expr_lst", "unary_expr", "unary_op", "cast_expr",
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

#define YYPACT_NINF (-679)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-466)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     668,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,
    -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,
    1795,   145,  -679,  -679,  -679,  -679,     7,    20,  -679,  -679,
     -13,  -679,   635,  3142,  -679,  -679,  -679,  1656,  -679,  -679,
    -679,  -679,  1524,   117,   797,  -679,  -679,  -679,  1219,  -679,
     118,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,
    -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,
    -679,  -679,  -679,  -679,  -679,   104,   109,  -679,  -679,  -679,
    -679,   145,  2072,  2574,  -679,    12,  -679,   110,   754,  -679,
    -679,  -679,  -679,   134,  -679,  -679,  -679,   150,  2826,   132,
     176,   -10,  -679,  -679,  -679,  3288,  1219,  -679,   114,  1795,
     177,  -679,  -679,   202,  -679,  -679,  -679,  -679,  -679,  -679,
    -679,  -679,  -679,  -679,  -679,  2713,  2713,  2852,  -679,  1462,
    -679,  -679,  -679,  -679,  -679,   196,   208,   225,   258,  -679,
     127,  -679,  2574,  -679,   222,   183,   108,    36,   271,   266,
     300,   323,   331,    10,  -679,   305,  -679,   176,  -679,  2296,
     176,   155,  -679,   176,  -679,  2296,  -679,  2548,  -679,    41,
    -679,   909,  2409,   347,  2826,   335,  -679,  2574,  -679,   -13,
    3142,  3288,   358,   362,   368,   379,  -679,   349,   687,    88,
    -679,   377,  1795,  -679,  2574,  -679,  -679,  1462,  -679,   400,
    -679,  -679,    72,  2826,  -679,  2826,   281,   402,  -679,   246,
     343,   343,  2826,  1795,  -679,  -679,  2435,  1795,  2574,  -679,
    2574,  2574,  2574,  2574,  2574,  2574,  2574,  2574,  2574,  2574,
    2574,  2574,  2574,  2574,  2574,  2574,  2574,  2574,  2574,  -679,
    -679,   387,  2018,  -679,  -679,   421,  -679,  2574,  -679,   416,
    -679,  -679,  -679,  2574,   165,  -679,   424,  -679,  -679,  2574,
    -679,   173,  -679,   425,   347,  2687,  -679,  2960,  -679,   423,
    -679,   936,  -679,    34,    34,    34,   435,  2648,   235,  2648,
     444,   445,  -679,  -679,  -679,  2072,  2072,   298,  2370,  -679,
    -679,  -679,  -679,  1795,  -679,  2574,   195,   446,  -679,  -679,
    -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  2574,
    -679,  2574,  -679,  -679,   283,   192,  -679,  2574,  -679,  -679,
    -679,  -679,   448,   418,  -679,  -679,  -679,  -679,  -679,  -679,
     449,   450,   447,  -679,  -679,   297,  -679,  -679,    95,  -679,
    -679,  -679,   222,   222,   183,   183,   108,   108,   108,   108,
      36,    36,   271,   266,   300,   323,   331,    91,  -679,  -679,
     227,  -679,  2960,   439,  -679,    41,  -679,  -679,  -679,    68,
    -679,  -679,  -679,  3022,  3454,  -679,   292,  3288,   452,  -679,
    -679,   453,  -679,   455,  -679,  -679,   107,  2574,   451,   460,
     462,   464,  1323,   465,  1795,   454,   456,  1879,   467,  1879,
     457,  2574,   466,   472,   468,  -679,  -679,  -679,   358,  -679,
     936,  -679,  1075,   458,  -679,  -679,  -679,  -679,   470,  1227,
     471,  -679,  -679,   459,   398,   473,  -679,  3245,  2509,   394,
     474,   476,   477,   431,   531,  -679,   483,  2648,   558,  2072,
     358,   358,   487,   484,   438,   440,  -679,  -679,  -679,  -679,
     479,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,   130,
    2574,   194,  -679,  2574,   497,  2574,  2574,  2072,  -679,  2574,
    -679,  2574,  2157,  -679,   499,  -679,  -679,  2574,  -679,  2574,
    -679,  3018,  -679,  -679,  3266,  2072,  -679,  1935,  2072,   176,
     504,  1323,  2574,  2574,  2574,   529,  -679,  2574,   508,  -679,
    -679,  -679,  2574,  2574,  2574,  -679,   509,  2574,   510,  -679,
      -5,  -679,  -679,  -679,  -679,   517,  -679,  -679,  -679,  1323,
    1184,  -679,    34,  -679,  1184,   519,  3121,  -679,  -679,   246,
     343,   343,  2648,   394,  -679,   306,   526,  -679,  -679,   -32,
     595,   524,   525,  -679,   535,  3288,   528,  -679,  2574,   536,
     211,   534,   538,   544,  -679,  -679,  -679,  -679,  -679,  -679,
    -679,  3391,  -679,  -679,  -679,  -679,  -679,  -679,   180,  1323,
    -679,   330,   341,   364,   539,   530,  -679,  -679,  -679,  -679,
    -679,   370,  -679,   541,  -679,  -679,  -679,  -679,  -679,  -679,
    -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,
    -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,
    -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,
    -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,  -679,
    -679,   551,   549,  -679,   591,  -679,   555,   556,   557,   569,
    -679,   543,  2072,  2072,   308,   548,  -679,   -28,  -679,   550,
     246,   625,  -679,   561,  -679,  3288,   552,  -679,  -679,  -679,
    2574,  2574,  -679,  -679,  -679,  1323,  1323,  1323,  2574,  2574,
     553,  2574,   246,  2211,  -679,  -679,  2072,  2072,  2072,  2648,
    -679,  -679,   563,   565,   308,   567,   568,   246,  -679,    18,
     571,   308,   570,   308,  -679,  -679,   184,  -679,  1973,   572,
     574,    59,  -679,  -679,   566,  -679,   583,   582,   601,  -679,
    -679,   374,   575,  -679,   593,   220,  -679,  1601,  2072,  -679,
     594,   137,  -679,  1184,   603,   376,   592,  -679,   543,   562,
      26,   308,  2072,   616,  -679,   308,  -679,   308,   -30,    22,
    -679,    18,   605,  -679,   612,  -679,   609,  -679,  2648,   610,
    -679,  -679,  -679,  2574,  1323,   611,  2574,   613,   615,  -679,
     643,   639,   640,   641,   642,  -679,   686,  -679,  2211,  2072,
     658,  -679,  -679,  2574,  2574,  -679,   652,  -679,    35,   660,
     308,   571,   571,  -679,  -679,  -679,   645,  -679,  2648,  -679,
    -679,  -679,  2648,   663,  -679,  -679,   664,  -679,  1740,  -679,
    2072,  -679,   653,  2211,   666,   384,   343,  -679,  -679,    38,
     390,   308,  -679,   659,  -679,  1323,  -679,  -679,  -679,   670,
    -679,  -679,  2574,   657,  -679,   308,    18,  -679,  -679,  -679,
     675,  2648,    38,  -679,  -679,   343,   662,  2648,   343,   665,
    2648,   669,  -679
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int16 yydefact[] =
{
     199,   119,   120,   121,   123,   124,   130,   131,   132,   133,
     136,   137,   134,   135,   179,   180,   129,   303,   144,   145,
     170,   195,   304,   305,   306,   125,     0,     0,   122,   292,
     199,    96,   102,   199,   107,   103,   138,     0,   139,   108,
     296,   200,     0,     0,   199,   289,   291,   294,   100,   293,
     312,   333,   331,   329,   332,   327,   346,   325,   336,   340,
     343,   342,   326,   330,   345,   328,   334,   323,   339,   344,
     337,   324,   341,   338,   335,     0,   174,   300,   299,   201,
     197,   196,     0,     0,    93,     0,   111,   298,     0,   105,
     104,   106,    97,     0,   113,   109,   110,   297,     0,   143,
     199,   182,   188,     1,   290,   252,   101,   313,     0,     0,
       0,   202,   198,     0,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,     0,     0,     0,    35,     0,
      36,    37,    38,    39,    40,     0,     0,     0,     0,    15,
      28,    41,     0,    43,    47,    50,    53,    58,    61,    63,
      65,    67,    69,    71,    90,     0,     2,   199,    94,     0,
     199,   181,   183,   199,    95,     0,   155,     0,   146,   199,
     150,   154,   199,   152,     0,     0,   191,    91,   250,   199,
     199,   253,     0,     0,     0,     0,   308,   407,     0,     0,
     175,   177,     0,   126,     0,    29,    30,     0,    32,    41,
      73,    86,     0,   214,   127,   215,   199,     0,   128,     0,
       0,     0,     0,     0,    21,    22,     0,     0,     0,    31,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   140,
     112,   115,     0,   229,   116,     0,   186,    91,   114,   117,
     118,   142,   147,     0,     0,   158,   160,   156,   157,     0,
     151,     0,   164,   166,   153,     0,   189,   205,    92,     0,
     251,    88,   295,   392,   392,   392,     0,     0,     0,   409,
       0,     0,   444,   446,   417,     0,     0,     0,     0,   411,
     413,   414,   415,     0,   171,     0,     0,     0,    76,    77,
      78,    79,    80,    81,    82,    83,    84,    85,    75,     0,
      14,     0,   216,   217,   200,     0,   219,     0,   463,   464,
     465,   462,     0,     0,   454,   455,   456,   457,   458,   459,
       0,     0,     0,    20,    17,     0,    26,    19,     0,    46,
      44,    45,    48,    49,    51,    52,    56,    57,    54,    55,
      59,    60,    62,    64,    66,    68,    70,     0,   230,   233,
       0,   184,   205,     0,   161,   199,   148,   162,   167,   199,
     149,   168,   141,   125,   122,    98,   199,    99,     0,   206,
     193,   203,   207,   194,   212,   190,     0,     0,     0,     0,
       0,     0,    88,     0,     0,     0,     0,    88,     0,    88,
       0,     0,     0,    89,     0,   256,   262,   236,     0,   235,
      88,   254,    88,     0,   239,   240,   241,   242,     0,   100,
       2,   395,   396,     0,   397,     0,   315,     0,     0,     0,
       0,     0,     0,     0,   435,   437,     0,   410,     0,     0,
       0,     0,     0,   452,     0,     0,   319,   321,   320,   322,
       0,   310,   412,   176,   178,   173,    33,    74,    87,   225,
      91,   221,    42,     0,     0,     0,     0,     0,    18,     0,
      16,     0,     0,   231,     0,   185,   159,     0,   165,     0,
     209,     0,   211,   192,     0,     0,   258,     0,     0,   199,
       0,    88,     0,     0,     0,     0,   302,    88,     0,   301,
     281,   282,     0,     0,     0,   466,     0,     0,     0,   285,
       0,   286,   267,   238,   255,     0,   263,   264,   248,    88,
       0,   398,     0,   393,     0,     0,     0,   309,   436,     0,
       0,     0,     0,     0,   416,     0,     0,   445,   447,     0,
       0,     0,     0,   311,     0,   205,     0,   227,    91,     0,
       0,     0,     0,     0,    27,    72,   232,   234,   187,   163,
     169,   199,   204,   208,   213,   260,   259,   261,     0,    88,
     247,     0,     0,     0,     0,     0,   280,   467,   468,   469,
     283,     0,   284,     0,   249,   245,   380,   386,   363,   381,
     349,   375,   385,   352,   378,   370,   373,   379,   388,   365,
     359,   354,   390,   389,   382,   387,   361,   351,   357,   369,
     360,   384,   391,   358,   366,   368,   355,   350,   376,   377,
     371,   353,   356,   367,   372,   374,   383,   364,   362,   348,
     347,     0,   397,   318,     0,   408,     0,     0,     0,   420,
     438,   450,     0,     0,     0,     0,   418,   472,   473,     0,
       0,     0,   222,     0,   223,   205,     0,    23,   460,   461,
       0,     0,    34,   257,   246,    88,    88,    88,     0,    88,
       0,     0,     0,   399,   394,   316,     0,     0,     0,     0,
     451,   448,     0,     0,     0,     0,     0,     0,   479,   450,
     476,     0,     0,     0,   474,   453,   428,   425,     0,     0,
       0,     0,   432,   226,     0,   224,     0,     0,   268,   270,
     277,     0,     0,   243,     0,   275,   272,    88,   345,   404,
       0,   400,   402,     0,     0,     0,     0,   421,   450,     0,
       0,     0,     0,     0,   485,     0,   471,     0,     0,     0,
     419,   450,     0,   426,     0,   427,     0,   430,     0,     0,
     433,   228,    24,     0,    88,     0,    88,     0,     0,   273,
       0,   329,   332,   346,   325,   274,   405,   314,     0,     0,
       0,   439,   440,     0,     0,   449,     0,   484,     0,     0,
       0,   478,   477,   488,   489,   483,     0,   470,     0,   422,
     431,   434,     0,     0,   269,   278,     0,   244,    88,   271,
       0,   403,     0,   399,     0,     0,     0,   482,   480,   486,
       0,     0,   429,     0,    25,    88,   276,   406,   401,     0,
     441,   442,     0,     0,   481,     0,   450,   423,   279,   317,
       0,     0,   487,   475,   443,     0,     0,     0,     0,     0,
       0,     0,   424
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -679,  -679,  -679,  -679,   356,  -679,  -106,   198,   259,   169,
     256,   520,   522,   523,   527,   532,  -679,   -69,  -155,  -679,
    -114,  -372,   -74,  -229,    29,     8,  -679,   -14,  -679,     5,
     270,  -679,   607,   597,   -21,  -679,   129,  -679,  -679,   588,
    -130,  -679,   596,  -679,  -679,   401,  -679,  -679,   396,  -679,
    -679,  -679,  -679,   579,   482,    65,     0,   -31,  -679,  -679,
    -679,  -679,   405,   -15,    49,     3,  -679,  -517,  -679,   288,
    -679,  -145,  -113,  -199,  -679,  -679,  -679,  -149,  -679,  -279,
    -678,  -679,  -679,  -301,  -679,  -679,   350,  -379,  -679,  -679,
     375,  -679,  -679,  -679,    63,  -679,  -679,  -679,  -679,  -679,
     740,  -679,  -679,  -679,     6,   397,   -17,  -679,  -679,  -679,
    -679,  -679,  -679,  -679,  -679,  -679,   -20,  -503,   216,   268,
     160,    -7,  -679,    25,  -679,  -679,    67,  -275,  -679,  -679,
    -679,  -679,   106,  -679,  -625,  -679,    99,  -679,  -679,  -397,
    -679,  -679,  -679,  -679,  -622,  -393,  -210,  -186,   404,  -679,
    -679,   158,  -643,  -371,  -679,  -679,  -679
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
       0,   139,   140,   335,   199,   142,   143,   144,   145,   146,
     147,   148,   149,   150,   151,   152,   153,   200,   201,   309,
     403,   404,   268,   269,   405,   179,   376,    31,    32,   180,
      85,    93,    86,    94,    34,   203,    35,    36,    37,   167,
     168,   169,   170,   171,   254,   255,   477,   261,   262,   479,
      38,    75,   110,   189,   190,    39,   241,    40,   161,   362,
     101,   267,   378,    41,    42,   172,   379,   380,   381,   382,
     383,   206,   207,   544,   461,   545,   655,   244,   360,   406,
     407,   408,   409,   272,   181,   182,   410,   411,   489,   412,
     413,   414,   415,   715,   716,   760,   416,   417,    43,    44,
      45,    46,   105,    47,   191,   418,    48,    49,    50,   186,
     108,   187,   525,   723,   188,   450,   156,   631,   423,   424,
     523,   720,   721,   722,   277,   436,   288,   289,   442,   692,
     290,   696,   697,   744,   698,   701,   702,   433,   434,   435,
     291,   440,   441,   292,   681,   444,   330,   688,   506,   646,
     647,   648,   689,   690,   737,   810,   785
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      78,   331,    97,    77,   243,    33,    80,   316,    30,   155,
     243,    89,    95,   452,   154,   202,   250,    78,   363,    92,
      77,   633,   102,   322,    81,   505,    76,   505,   653,    29,
      87,   514,   528,   517,   734,   237,   219,   252,   734,   765,
     644,   730,   734,    99,   693,   421,   536,   717,   739,    33,
     741,   734,    30,   106,   734,   735,   227,   228,   312,   735,
     313,   336,   113,   735,    21,   176,   112,   736,    78,   175,
     700,    77,   735,    29,   311,   735,   783,   177,    84,    88,
     202,   173,    82,   202,   297,    95,    79,   243,   778,    78,
     717,   157,    77,   359,   162,    83,   645,    91,    96,   332,
     645,   784,   777,   158,   338,   238,   775,   513,   154,   680,
     786,   422,   208,   495,   339,   340,   341,   103,    21,   787,
     816,   749,   107,   807,   357,   575,   225,   226,   229,   583,
     230,   253,   249,   516,   178,   252,   640,   809,   704,   537,
     538,   263,   213,   214,   215,    21,   111,   514,   310,   249,
     173,   311,   486,   452,   457,   173,   458,   173,   259,    95,
     245,    90,   452,    79,   487,   488,    92,   293,   826,   256,
     311,    96,    78,   294,   311,    77,   264,   482,   154,   364,
     208,   471,   832,   470,   154,   368,   208,   109,   208,  -115,
     154,   314,  -172,    78,   205,   208,    77,    78,    14,    15,
      77,  -115,   216,   159,   833,  -199,    88,    21,   217,    88,
     270,   462,   570,   163,   218,   174,   768,  -199,    88,   333,
     770,   454,    21,   337,   769,   164,   154,   166,    88,  -117,
     246,   546,    79,   183,   184,   185,   258,   111,    79,    79,
     585,  -117,   247,   165,   365,    96,   742,   384,   173,   682,
     683,   420,   369,    21,   419,   315,   366,   639,   204,   157,
     192,   223,   205,   224,   370,   443,   445,   459,   205,   547,
     205,   663,   377,    78,   293,   375,    77,   205,   193,   460,
     455,   548,   758,   724,   725,   726,   209,   510,   318,   319,
     664,   320,   321,   231,   232,   220,   166,   712,   210,   221,
     257,   166,   446,   166,   222,   447,   472,   448,   549,   449,
     551,   552,   473,   490,   554,   211,   658,   243,   154,   656,
     637,   638,   659,   557,   318,   319,   204,   320,   321,   111,
      79,   429,   204,   212,   204,   430,   431,   432,   263,   779,
     233,   204,   384,   636,   428,   480,   437,   577,   578,   579,
     318,   319,   581,   320,   321,   236,    95,  -218,    21,  -220,
    -218,   314,  -220,    92,   781,   256,   782,   377,  -210,    21,
     375,  -210,   420,   468,   499,   496,   469,   496,   571,   572,
     573,   239,   641,   684,   796,   642,   708,   709,   710,   234,
     420,   154,   420,   419,   166,   419,   346,   347,   348,   349,
      14,    15,   555,   559,   727,   560,   665,   235,   154,   311,
     154,   266,   318,   319,    88,   320,   321,   666,   323,   443,
     311,   342,   343,   745,   106,   481,   298,   299,   300,   301,
     302,   303,   304,   305,   306,   307,   685,   686,   687,   141,
     667,   271,    96,   311,   314,   273,   670,   553,   324,   671,
     755,   274,   772,   311,   325,   773,   326,   327,   328,   329,
     821,   102,   275,   822,   699,   564,   824,   566,   567,   825,
     295,   420,   276,   791,   496,   794,   521,   522,   317,   154,
     159,   195,   196,   198,   344,   345,   699,   350,   351,   377,
     425,   426,   375,   308,   430,   431,   432,   361,   141,   420,
     630,   733,   496,   629,   630,   706,   707,   629,   315,   165,
     699,   385,   746,   812,   367,   371,   714,   813,   427,   438,
     439,   464,   456,   463,   465,   466,   467,   475,   483,   699,
     175,   746,   484,   141,   485,   492,   828,   493,    88,   494,
     497,   491,   507,   518,   520,   500,   314,   501,   509,   420,
     377,   311,   496,   375,   711,   533,   835,   511,   524,   512,
     519,  -301,   838,   532,   529,   841,   530,   531,   534,   535,
     539,   540,   541,   550,   542,   558,   141,   141,   141,   141,
     141,   141,   141,   141,   141,   141,   141,   141,   141,   141,
     141,   141,   141,   141,   569,   574,   823,   543,   793,   576,
     580,   582,   584,   141,   634,   643,   649,   650,   651,   141,
     481,   652,   657,   660,   668,   141,   654,   661,   804,   805,
     662,   669,   443,   443,   672,   836,   673,   521,   839,   675,
     676,   677,   678,   679,   680,   691,   700,   703,   695,   728,
     705,   729,   751,   732,   713,   420,   420,   420,   496,   496,
     496,   141,   738,   719,   731,   740,   443,   443,   443,   752,
     377,   753,   747,   375,   748,   754,   756,   830,  -287,   757,
     767,   774,  -307,   141,     1,     2,     3,     4,     5,   771,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,   780,    18,    19,    20,   788,   776,   789,   766,   790,
     792,   800,   795,   630,   797,   798,   629,     1,     2,     3,
       4,     5,   443,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,   799,  -463,
    -464,  -465,  -462,   803,   420,   806,   808,   496,   811,   814,
     815,   818,   820,   141,   827,    21,   829,   831,   719,   802,
     278,   834,   837,   352,   842,   840,   353,    51,   354,   568,
     248,    25,   265,   355,   240,   478,   476,   474,   260,   356,
     279,   296,   563,    26,    27,   453,    28,   526,   759,    22,
     817,    23,    24,   719,   104,   515,   280,  -307,  -307,  -307,
     632,   498,   674,   801,    25,   420,   819,  -288,   496,   281,
     750,  -307,   743,   508,   282,   694,    26,    27,     0,    28,
      17,     0,     0,   283,   284,     0,   141,     0,     0,     0,
     285,     0,   286,   287,     0,     0,     0,   141,     0,   160,
       0,     0,     0,   141,     0,   141,     1,     2,     3,     4,
       5,     0,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,    52,    53,    54,
      55,    56,    57,    58,    59,    22,     0,    23,    24,    60,
      61,    62,    63,     0,    21,     0,    64,    65,     0,     0,
      66,    67,    68,    69,    70,    71,    72,     0,    73,     0,
       0,     0,     0,     0,     0,    74,     0,     0,     0,     0,
       0,     0,     0,     0,   141,     0,     0,     0,    22,     0,
      23,    24,     0,     0,     0,     0,  -307,  -307,  -307,     0,
       0,     0,     0,    25,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    26,    27,     0,    28,    51,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,     0,   125,   126,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,     0,    18,    19,    20,     0,
       0,     0,   127,     0,     0,     1,     2,     3,     4,     5,
     386,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,     0,   387,   388,   389,
       0,   390,   391,   392,   393,   394,   395,   396,   397,     0,
     128,   129,     0,   130,   131,     0,   132,     0,     0,  -237,
       0,  -265,   133,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   134,     0,     0,   398,   135,   136,   137,    52,
      53,    54,    55,    56,    57,    58,    59,    22,    27,    23,
      24,    60,    61,    62,    63,     0,     0,     0,    64,    65,
     399,   400,   373,    67,    68,    69,    70,    71,    72,   401,
      73,     0,     0,   402,    26,    27,   138,   374,    51,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
       0,   125,   126,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   127,     0,     0,     1,     2,     3,     4,     5,   386,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,     0,   387,   388,   389,     0,
     390,   391,   392,   393,   394,   395,   396,   397,     0,   128,
     129,     0,   130,   131,     0,   132,     0,     0,  -237,     0,
    -266,   133,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   134,     0,     0,   398,   135,   136,   137,    52,    53,
      54,    55,    56,    57,    58,    59,    22,    51,    23,    24,
      60,    61,    62,    63,     0,     0,     0,    64,    65,   399,
     400,   373,    67,    68,    69,    70,    71,    72,   401,    73,
       0,     0,   402,    26,    27,   138,   374,     0,     0,     0,
     586,     0,     0,   587,   588,   589,   590,   591,   592,   593,
     594,   595,   596,   597,   598,   599,   600,   601,   602,   603,
      17,   604,   605,   606,     0,   607,   608,   609,   610,   611,
     612,   613,   614,   615,   616,   617,   618,     0,     1,     2,
       3,     4,     5,     0,     0,     0,     1,     2,     3,     4,
       5,     0,    14,    15,     0,     0,     0,     0,     0,     0,
      14,    15,     0,   619,   620,   621,   622,    52,    53,    54,
      55,    56,    57,    58,    59,    22,     0,    23,    24,    60,
      61,    62,    63,   623,   624,   625,    64,    65,   626,   627,
      66,    67,    68,    69,    70,    71,    72,  -302,    73,     0,
       0,   628,     0,     0,     0,    74,    51,   114,   115,   116,
     117,   118,   119,   120,   121,   122,   123,   124,     0,   125,
     126,     0,     0,     0,     0,    25,     0,     0,     0,     0,
       0,     0,     0,    25,     0,     0,     0,    26,     0,   127,
      28,     0,     0,     0,     0,    26,     0,     0,    28,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    17,
       0,     0,     0,     0,   387,   388,   389,     0,   390,   391,
     392,   393,   394,   395,   396,   397,     0,   128,   129,     0,
     130,   131,     0,   132,     0,     0,  -237,     0,     0,   133,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   134,
       0,     0,   398,   135,   136,   137,    52,    53,    54,    55,
      56,    57,    58,    59,    22,     0,    23,    24,    60,    61,
      62,    63,     0,     0,     0,    64,    65,   399,   400,    66,
      67,    68,    69,    70,    71,    72,   401,    73,     0,     0,
     402,     0,     0,   138,    74,    51,   114,   115,   116,   117,
     118,   119,   120,   121,   122,   123,   124,     0,   125,   126,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   127,     0,
       0,     0,     0,     0,     0,     0,     0,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,     0,     0,     0,     0,     0,    51,     0,     0,
       0,     0,     0,     0,     0,     0,   128,   129,     0,   130,
     131,     0,   132,     0,     0,     0,     0,     0,   133,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   134,     0,
       0,     0,   135,   136,   137,    52,    53,    54,    55,    56,
      57,    58,    59,    22,     0,    23,    24,    60,    61,    62,
      63,     0,     0,     0,    64,    65,     0,     0,    66,    67,
      68,    69,    70,    71,    72,     0,    73,     0,     0,   100,
       0,    27,   138,    74,    51,   114,   115,   116,   117,   118,
     119,   120,   121,   122,   123,   124,     0,   125,   126,     0,
       0,     0,     0,     0,     0,     0,     0,    52,    53,    54,
      55,    56,    57,    58,    59,     0,     0,   127,     0,    60,
      61,    62,    63,     0,     0,     0,    64,    65,     0,     0,
      66,    67,    68,    69,    70,    71,    72,     0,    73,    51,
       0,     0,     0,     0,   389,    74,   390,   391,   392,   393,
     394,   395,   396,   397,     0,   128,   129,     0,   130,   131,
       0,   132,     0,     0,  -237,     0,     0,   133,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   134,     0,     0,
     398,   135,   136,   137,    52,   761,   762,    55,   763,   764,
      58,    59,    17,     0,     0,     0,    60,    61,    62,    63,
       0,     0,     0,    64,    65,   399,   400,    66,    67,    68,
      69,    70,    71,    72,   401,    73,     0,     0,   402,    98,
       0,   138,    74,    51,   114,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,     0,   125,   126,     0,    52,
      53,    54,    55,    56,    57,    58,    59,    22,     0,    23,
      24,    60,    61,    62,    63,     0,   127,     0,    64,    65,
       0,     0,    66,    67,    68,    69,    70,    71,    72,     0,
      73,     0,     0,     0,     0,     0,     0,    74,    51,     0,
       0,     0,     0,   389,     0,   390,   391,   392,   393,   394,
     395,   396,   397,     0,   128,   129,     0,   130,   131,     0,
     132,     0,     0,  -237,     0,     0,   133,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   134,     0,     0,   398,
     135,   136,   137,    52,    53,    54,    55,    56,    57,    58,
      59,    17,     0,     0,     0,    60,    61,    62,    63,     0,
       0,     0,    64,    65,   399,   400,    66,    67,    68,    69,
      70,    71,    72,   401,    73,     0,     0,   402,     0,     0,
     138,    74,    51,   114,   115,   116,   117,   118,   119,   120,
     121,   122,   123,   124,     0,   125,   126,     0,    52,    53,
      54,    55,    56,    57,    58,    59,    22,     0,    23,    24,
      60,    61,    62,    63,     0,   127,     0,    64,    65,     0,
       0,    66,    67,    68,    69,    70,    71,    72,     0,    73,
       0,     0,     0,     0,     0,     0,    74,     0,    51,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   128,   129,     0,   130,   131,     0,   132,
       0,     0,     0,     0,     0,   133,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   134,     0,     0,     0,   135,
     136,   137,    52,    53,    54,    55,    56,    57,    58,    59,
     502,   565,   503,   504,    60,    61,    62,    63,     0,     0,
       0,    64,    65,     0,     0,    66,    67,    68,    69,    70,
      71,    72,     0,    73,     0,     0,     0,     0,     0,   138,
      74,    51,   114,   115,   116,   117,   118,   119,   120,   121,
     122,   123,   124,     0,   125,   126,   278,     0,    52,    53,
      54,    55,    56,    57,    58,    59,     0,     0,     0,     0,
      60,    61,    62,    63,   127,     0,   279,    64,    65,     0,
       0,    66,    67,    68,    69,    70,    71,    72,     0,    73,
       0,     0,   280,     0,     0,    51,    74,   318,   319,     0,
     320,   321,     0,     0,     0,   281,     0,     0,     0,     0,
     282,     0,   128,   129,     0,   130,   131,     0,   132,   283,
     284,   242,     0,   358,   133,     0,   285,     0,   286,     0,
       0,     0,     0,     0,   134,     0,     0,     0,   135,   136,
     137,    52,    53,    54,    55,    56,    57,    58,    59,     0,
       0,     0,     0,    60,    61,    62,    63,     0,     0,     0,
      64,    65,     0,     0,    66,    67,    68,    69,    70,    71,
      72,     0,    73,     0,     0,     0,     0,     0,   138,    74,
      51,   114,   115,   116,   117,   118,   119,   120,   121,   122,
     123,   124,     0,   125,   126,    52,    53,    54,    55,    56,
      57,    58,    59,     0,     0,     0,     0,    60,    61,    62,
      63,     0,     0,   127,    64,    65,     0,     0,    66,    67,
      68,    69,    70,    71,    72,     0,    73,     0,     0,     0,
       0,     0,     0,    74,    51,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   128,   129,     0,   130,   131,     0,   132,     0,     0,
     242,     0,   556,   133,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   134,     0,     0,     0,   135,   136,   137,
      52,    53,    54,    55,    56,    57,    58,    59,     0,     0,
       0,     0,    60,    61,    62,    63,     0,     0,     0,    64,
      65,     0,     0,    66,    67,    68,    69,    70,    71,    72,
       0,    73,     0,     0,     0,     0,     0,   138,    74,    51,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,     0,   125,   126,    52,    53,    54,    55,    56,    57,
      58,    59,     0,     0,     0,     0,    60,    61,    62,    63,
       0,     0,   127,   718,    65,     0,     0,    66,    67,    68,
      69,    70,    71,    72,     0,    73,     0,     0,     0,     0,
       0,     0,    74,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     128,   129,     0,   130,   131,     0,   132,     0,     0,   242,
       0,     0,   133,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   134,     0,     0,     0,   135,   136,   137,    52,
      53,    54,    55,    56,    57,    58,    59,     0,     0,     0,
       0,    60,    61,    62,    63,     0,     0,     0,    64,    65,
       0,     0,    66,    67,    68,    69,    70,    71,    72,     0,
      73,     0,     0,   278,     0,     0,   138,    74,    51,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
       0,   125,   126,   279,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,    20,   280,
       0,   127,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   281,     0,     0,     0,    21,   282,   451,     0,
       0,     0,     0,     0,     0,     0,   283,   284,     0,   259,
       0,     0,     0,   285,     0,   286,     0,     0,     0,   128,
     129,   334,   130,   131,     0,   132,     0,     0,     0,     0,
      22,   133,    23,    24,     0,     0,     0,     0,     0,     0,
       0,   134,     0,     0,     0,   135,   136,   137,    52,    53,
      54,    55,    56,    57,    58,    59,     0,     0,    27,     0,
      60,    61,    62,    63,     0,     0,     0,    64,    65,     0,
       0,    66,    67,    68,    69,    70,    71,    72,     0,    73,
       0,     0,   278,     0,     0,   138,    74,    51,   114,   115,
     116,   117,   118,   119,   120,   121,   122,   123,   124,     0,
     125,   126,   279,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,   280,     0,
     127,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   281,     0,     0,     0,     0,   282,   527,     0,     0,
       0,     0,     0,   251,     0,   283,   284,     0,     0,     0,
       0,     0,   285,     0,   286,     0,     0,     0,   128,   129,
       0,   130,   131,     0,   132,     0,     0,     0,     0,    22,
     133,    23,    24,     0,     0,     0,     0,     0,     0,     0,
     134,     0,     0,     0,   135,   136,   137,    52,    53,    54,
      55,    56,    57,    58,    59,     0,     0,    27,     0,    60,
      61,    62,    63,     0,     0,     0,    64,    65,     0,     0,
      66,    67,    68,    69,    70,    71,    72,     0,    73,     0,
       0,   278,     0,     0,   138,    74,    51,   114,   115,   116,
     117,   118,   119,   120,   121,   122,   123,   124,     0,   125,
     126,   279,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,   280,     0,   127,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     281,     0,     0,     0,     0,   282,     0,     0,     0,     0,
       0,     0,   372,     0,   283,   284,     0,     0,     0,     0,
       0,   285,     0,   286,     0,     0,     0,   128,   194,     0,
     130,   131,     0,   132,     0,     0,     0,     0,    22,   133,
      23,    24,     0,     0,     0,     0,     0,     0,     0,   134,
       0,     0,     0,   135,   136,   137,    52,    53,    54,    55,
      56,    57,    58,    59,     0,     0,    27,     0,    60,    61,
      62,    63,     0,     0,     0,    64,    65,     0,     0,    66,
      67,    68,    69,    70,    71,    72,     0,    73,     0,     0,
       0,     0,     0,   138,    74,    51,   114,   115,   116,   117,
     118,   119,   120,   121,   122,   123,   124,     0,   125,   126,
       0,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,     0,     0,   127,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   128,   197,     0,   130,
     131,     0,   132,     0,     0,     0,     0,    22,   133,    23,
      24,     0,     0,     0,     0,     0,     0,     0,   134,     0,
       0,     0,   135,   136,   137,    52,    53,    54,    55,    56,
      57,    58,    59,    51,     0,    27,     0,    60,    61,    62,
      63,     0,     0,     0,    64,    65,     0,     0,    66,    67,
      68,    69,    70,    71,    72,     0,    73,     0,     0,     0,
       0,     0,   138,    74,     0,     0,     0,     0,     0,     1,
       2,     3,     4,     5,     0,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
       0,    51,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,  -334,  -334,  -334,
    -334,  -334,  -334,  -334,  -334,  -334,  -334,  -334,  -334,  -334,
    -334,  -334,  -334,  -334,  -334,  -334,  -334,  -334,     0,     0,
       0,     0,     0,    52,    53,    54,    55,    56,    57,    58,
      59,    22,     0,    23,    24,    60,    61,    62,    63,     0,
       0,     0,    64,    65,     0,     0,   373,    67,    68,    69,
      70,    71,    72,   561,    73,  -334,  -334,     0,    26,    27,
    -334,   374,  -334,  -334,  -334,   460,  -334,     0,     0,     0,
       0,  -334,  -334,  -334,  -334,  -334,  -334,  -334,     0,     0,
       0,    52,    53,    54,    55,    56,    57,    58,    59,     0,
       0,     0,     0,    60,    61,    62,    63,     0,     0,     0,
      64,    65,     0,     0,    66,    67,    68,    69,    70,    71,
      72,     0,    73,     0,     0,     0,     0,     0,     0,    74,
       1,     2,     3,     4,     5,   386,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,     1,     2,     3,     4,     5,     0,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,     0,     0,     0,     0,   635,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    21,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    22,     0,    23,    24,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    25,     0,     0,
       0,     0,     0,    22,     0,    23,    24,     0,     0,    26,
      27,     0,    28,     0,     0,     0,     0,     0,    25,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      26,    27,     0,    28,     1,     2,     3,     4,     5,   386,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,     1,     2,     3,     4,     5,
       0,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,   562,     1,     2,     3,
       4,     5,     0,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,     0,     0,
       0,     0,     0,     0,     0,     0,    22,     0,    23,    24,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    25,     0,     0,     0,     0,     0,    22,     0,    23,
      24,     0,     0,    26,    27,     0,    28,     0,     0,     0,
       0,     0,    25,     0,     0,     0,     0,     0,     0,    22,
       0,    23,    24,     0,    26,    27,     0,    28,     0,     0,
       0,     0,     0,     0,    25,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    26,    27,     0,    28,
    -225,  -225,  -225,  -225,  -225,     0,  -225,  -225,  -225,  -225,
    -225,  -225,  -225,  -225,  -225,  -225,  -225,  -225,  -225,  -225,
    -225,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,  -225,    21,  -335,
    -335,  -335,  -335,  -335,  -335,  -335,  -335,  -335,  -335,  -335,
    -335,  -335,  -335,  -335,  -335,  -335,  -335,  -335,  -335,  -335,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,  -225,     0,  -225,  -225,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,  -335,  -335,  -225,
    -225,     0,  -335,     0,  -335,  -335,  -335,     0,  -335,     0,
       0,     0,     0,  -335,  -335,  -335,  -335,  -335,  -335,  -335
};

static const yytype_int16 yycheck[] =
{
      20,   211,    33,    20,   159,     0,    21,   206,     0,    83,
     165,    32,    33,   288,    83,   129,   165,    37,   247,    33,
      37,   524,    42,   209,    21,   397,    20,   399,   545,     0,
      30,   410,   429,   412,    16,    25,   142,   167,    16,   717,
      72,   684,    16,    37,    72,    11,   439,   672,   691,    44,
     693,    16,    44,    48,    16,    37,    20,    21,   203,    37,
     205,   216,    82,    37,    77,    75,    81,   689,    88,   100,
      11,    88,    37,    44,    79,    37,   106,    87,    91,    30,
     194,    98,    75,   197,   197,   106,    21,   242,   731,   109,
     715,    79,   109,   242,    88,    75,   128,    32,    33,   212,
     128,   131,    76,    91,   218,    95,   728,   408,   177,    91,
      88,    77,   129,   392,   220,   221,   222,     0,    77,   741,
     798,    62,     4,    88,   238,   497,    18,    19,    92,   134,
      94,    90,   163,   412,   105,   265,   533,   780,   655,   440,
     441,   172,    15,    16,    17,    77,    81,   526,    76,   180,
     167,    79,    45,   428,   309,   172,   311,   174,    90,   180,
     160,    32,   437,    98,    57,    58,   180,    79,   811,   169,
      79,   106,   192,    85,    79,   192,   173,   376,   247,   253,
     197,    90,   825,    88,   253,   259,   203,    83,   205,    79,
     259,   206,    83,   213,   129,   212,   213,   217,    53,    54,
     217,    91,    75,    93,   826,    75,   157,    77,    81,   160,
     181,   317,   491,    79,    87,    83,    79,    87,   169,   213,
     723,   295,    77,   217,    87,    91,   295,    98,   179,    79,
      75,   460,   167,   119,   120,   121,   171,   172,   173,   174,
     519,    91,    87,    93,    79,   180,    62,   267,   265,   642,
     643,   271,    79,    77,   271,   206,    91,   532,   129,    79,
      83,    78,   197,    80,    91,   285,   286,    75,   203,    75,
     205,    91,   267,   293,    79,   267,   293,   212,    76,    87,
      85,    87,    62,   676,   677,   678,    90,   401,   104,   105,
     569,   107,   108,    22,    23,    73,   167,   669,    90,    77,
     171,   172,     4,   174,    82,     7,    79,     9,   463,    11,
     465,   466,    85,   387,   469,    90,   105,   472,   387,   548,
     530,   531,   111,   472,   104,   105,   197,   107,   108,   264,
     265,    96,   203,    75,   205,   100,   101,   102,   369,   732,
      74,   212,   362,   529,   277,   376,   279,   502,   503,   504,
     104,   105,   507,   107,   108,    24,   377,    76,    77,    76,
      79,   376,    79,   377,   735,   365,   737,   362,    76,    77,
     362,    79,   392,    76,   394,   392,    79,   394,   492,   493,
     494,    76,    76,    75,   756,    79,   665,   666,   667,    89,
     410,   460,   412,   410,   265,   412,   227,   228,   229,   230,
      53,    54,   471,   477,   679,   479,    76,    84,   477,    79,
     479,    76,   104,   105,   365,   107,   108,    76,    75,   439,
      79,   223,   224,   698,   419,   376,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,   128,   129,   130,    83,
      76,    83,   377,    79,   459,    83,    76,   467,   105,    79,
      76,    83,    76,    79,   111,    79,   113,   114,   115,   116,
      76,   481,    83,    79,   650,   485,    76,   487,   488,    79,
      93,   491,   123,   748,   491,   754,    78,    79,    76,   548,
      93,   125,   126,   127,   225,   226,   672,   231,   232,   484,
     274,   275,   484,    93,   100,   101,   102,    76,   142,   519,
     520,   687,   519,   520,   524,   660,   661,   524,   459,    93,
     696,    88,   698,   788,    90,    90,   671,   792,    83,    75,
      75,   103,    76,    75,    75,    75,    79,    88,    76,   715,
     561,   717,    79,   177,    79,    75,   815,    75,   489,    75,
      75,    90,    75,    85,    85,    91,   561,    91,    91,   569,
     545,    79,   569,   545,   668,    24,   831,    91,    85,    91,
      90,    90,   837,   132,    90,   840,    90,    90,    85,    11,
      83,    87,   134,    76,   134,    76,   220,   221,   222,   223,
     224,   225,   226,   227,   228,   229,   230,   231,   232,   233,
     234,   235,   236,   237,    90,    66,   806,   118,   753,    91,
      91,    91,    85,   247,    85,    79,    11,    83,    83,   253,
     561,    76,    76,    79,    75,   259,    88,    79,   773,   774,
      76,    91,   642,   643,    83,   835,    75,    78,   838,    38,
      75,    75,    75,    64,    91,    87,    11,    76,    88,    76,
      88,    76,    76,    75,    91,   665,   666,   667,   665,   666,
     667,   295,    81,   673,    87,    85,   676,   677,   678,    76,
     655,    79,    90,   655,    90,    64,    91,   822,     0,    76,
      76,    79,     4,   317,    39,    40,    41,    42,    43,    76,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    75,    57,    58,    59,    90,   134,    85,   718,    90,
      90,    15,    91,   723,    91,    90,   723,    39,    40,    41,
      42,    43,   732,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    85,    90,
      90,    90,    90,    75,   754,    83,    76,   754,    93,    76,
      76,    88,    76,   387,    85,    77,    76,    90,   768,   769,
      63,    76,    90,   233,    85,    90,   234,     3,   235,   489,
     163,   126,   174,   236,   157,   369,   365,   362,   172,   237,
      83,   192,   484,   138,   139,   293,   141,   427,   715,   111,
     800,   113,   114,   803,    44,   410,    99,   119,   120,   121,
     522,   394,   632,   768,   126,   815,   803,     0,   815,   112,
     701,     4,   696,   399,   117,   647,   138,   139,    -1,   141,
      56,    -1,    -1,   126,   127,    -1,   460,    -1,    -1,    -1,
     133,    -1,   135,   136,    -1,    -1,    -1,   471,    -1,    75,
      -1,    -1,    -1,   477,    -1,   479,    39,    40,    41,    42,
      43,    -1,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,   103,   104,   105,
     106,   107,   108,   109,   110,   111,    -1,   113,   114,   115,
     116,   117,   118,    -1,    77,    -1,   122,   123,    -1,    -1,
     126,   127,   128,   129,   130,   131,   132,    -1,   134,    -1,
      -1,    -1,    -1,    -1,    -1,   141,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   548,    -1,    -1,    -1,   111,    -1,
     113,   114,    -1,    -1,    -1,    -1,   119,   120,   121,    -1,
      -1,    -1,    -1,   126,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   138,   139,    -1,   141,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    -1,    16,    17,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    -1,    57,    58,    59,    -1,
      -1,    -1,    36,    -1,    -1,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    -1,    61,    62,    63,
      -1,    65,    66,    67,    68,    69,    70,    71,    72,    -1,
      74,    75,    -1,    77,    78,    -1,    80,    -1,    -1,    83,
      -1,    85,    86,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    96,    -1,    -1,    99,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   111,   139,   113,
     114,   115,   116,   117,   118,    -1,    -1,    -1,   122,   123,
     124,   125,   126,   127,   128,   129,   130,   131,   132,   133,
     134,    -1,    -1,   137,   138,   139,   140,   141,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      -1,    16,    17,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    36,    -1,    -1,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    -1,    61,    62,    63,    -1,
      65,    66,    67,    68,    69,    70,    71,    72,    -1,    74,
      75,    -1,    77,    78,    -1,    80,    -1,    -1,    83,    -1,
      85,    86,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    96,    -1,    -1,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,   111,     3,   113,   114,
     115,   116,   117,   118,    -1,    -1,    -1,   122,   123,   124,
     125,   126,   127,   128,   129,   130,   131,   132,   133,   134,
      -1,    -1,   137,   138,   139,   140,   141,    -1,    -1,    -1,
      36,    -1,    -1,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    -1,    61,    62,    63,    64,    65,
      66,    67,    68,    69,    70,    71,    72,    -1,    39,    40,
      41,    42,    43,    -1,    -1,    -1,    39,    40,    41,    42,
      43,    -1,    53,    54,    -1,    -1,    -1,    -1,    -1,    -1,
      53,    54,    -1,    99,   100,   101,   102,   103,   104,   105,
     106,   107,   108,   109,   110,   111,    -1,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126,   127,   128,   129,   130,   131,   132,    90,   134,    -1,
      -1,   137,    -1,    -1,    -1,   141,     3,     4,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    -1,    16,
      17,    -1,    -1,    -1,    -1,   126,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   126,    -1,    -1,    -1,   138,    -1,    36,
     141,    -1,    -1,    -1,    -1,   138,    -1,    -1,   141,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    56,
      -1,    -1,    -1,    -1,    61,    62,    63,    -1,    65,    66,
      67,    68,    69,    70,    71,    72,    -1,    74,    75,    -1,
      77,    78,    -1,    80,    -1,    -1,    83,    -1,    -1,    86,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,
      -1,    -1,    99,   100,   101,   102,   103,   104,   105,   106,
     107,   108,   109,   110,   111,    -1,   113,   114,   115,   116,
     117,   118,    -1,    -1,    -1,   122,   123,   124,   125,   126,
     127,   128,   129,   130,   131,   132,   133,   134,    -1,    -1,
     137,    -1,    -1,   140,   141,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    -1,    16,    17,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    36,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    -1,    -1,    -1,    -1,    -1,     3,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    74,    75,    -1,    77,
      78,    -1,    80,    -1,    -1,    -1,    -1,    -1,    86,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,
      -1,    -1,   100,   101,   102,   103,   104,   105,   106,   107,
     108,   109,   110,   111,    -1,   113,   114,   115,   116,   117,
     118,    -1,    -1,    -1,   122,   123,    -1,    -1,   126,   127,
     128,   129,   130,   131,   132,    -1,   134,    -1,    -1,    75,
      -1,   139,   140,   141,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    -1,    16,    17,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   103,   104,   105,
     106,   107,   108,   109,   110,    -1,    -1,    36,    -1,   115,
     116,   117,   118,    -1,    -1,    -1,   122,   123,    -1,    -1,
     126,   127,   128,   129,   130,   131,   132,    -1,   134,     3,
      -1,    -1,    -1,    -1,    63,   141,    65,    66,    67,    68,
      69,    70,    71,    72,    -1,    74,    75,    -1,    77,    78,
      -1,    80,    -1,    -1,    83,    -1,    -1,    86,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,    56,    -1,    -1,    -1,   115,   116,   117,   118,
      -1,    -1,    -1,   122,   123,   124,   125,   126,   127,   128,
     129,   130,   131,   132,   133,   134,    -1,    -1,   137,    83,
      -1,   140,   141,     3,     4,     5,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    -1,    16,    17,    -1,   103,
     104,   105,   106,   107,   108,   109,   110,   111,    -1,   113,
     114,   115,   116,   117,   118,    -1,    36,    -1,   122,   123,
      -1,    -1,   126,   127,   128,   129,   130,   131,   132,    -1,
     134,    -1,    -1,    -1,    -1,    -1,    -1,   141,     3,    -1,
      -1,    -1,    -1,    63,    -1,    65,    66,    67,    68,    69,
      70,    71,    72,    -1,    74,    75,    -1,    77,    78,    -1,
      80,    -1,    -1,    83,    -1,    -1,    86,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,    99,
     100,   101,   102,   103,   104,   105,   106,   107,   108,   109,
     110,    56,    -1,    -1,    -1,   115,   116,   117,   118,    -1,
      -1,    -1,   122,   123,   124,   125,   126,   127,   128,   129,
     130,   131,   132,   133,   134,    -1,    -1,   137,    -1,    -1,
     140,   141,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    -1,    16,    17,    -1,   103,   104,
     105,   106,   107,   108,   109,   110,   111,    -1,   113,   114,
     115,   116,   117,   118,    -1,    36,    -1,   122,   123,    -1,
      -1,   126,   127,   128,   129,   130,   131,   132,    -1,   134,
      -1,    -1,    -1,    -1,    -1,    -1,   141,    -1,     3,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    74,    75,    -1,    77,    78,    -1,    80,
      -1,    -1,    -1,    -1,    -1,    86,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,    -1,   100,
     101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
     111,    56,   113,   114,   115,   116,   117,   118,    -1,    -1,
      -1,   122,   123,    -1,    -1,   126,   127,   128,   129,   130,
     131,   132,    -1,   134,    -1,    -1,    -1,    -1,    -1,   140,
     141,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    -1,    16,    17,    63,    -1,   103,   104,
     105,   106,   107,   108,   109,   110,    -1,    -1,    -1,    -1,
     115,   116,   117,   118,    36,    -1,    83,   122,   123,    -1,
      -1,   126,   127,   128,   129,   130,   131,   132,    -1,   134,
      -1,    -1,    99,    -1,    -1,     3,   141,   104,   105,    -1,
     107,   108,    -1,    -1,    -1,   112,    -1,    -1,    -1,    -1,
     117,    -1,    74,    75,    -1,    77,    78,    -1,    80,   126,
     127,    83,    -1,    85,    86,    -1,   133,    -1,   135,    -1,
      -1,    -1,    -1,    -1,    96,    -1,    -1,    -1,   100,   101,
     102,   103,   104,   105,   106,   107,   108,   109,   110,    -1,
      -1,    -1,    -1,   115,   116,   117,   118,    -1,    -1,    -1,
     122,   123,    -1,    -1,   126,   127,   128,   129,   130,   131,
     132,    -1,   134,    -1,    -1,    -1,    -1,    -1,   140,   141,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    -1,    16,    17,   103,   104,   105,   106,   107,
     108,   109,   110,    -1,    -1,    -1,    -1,   115,   116,   117,
     118,    -1,    -1,    36,   122,   123,    -1,    -1,   126,   127,
     128,   129,   130,   131,   132,    -1,   134,    -1,    -1,    -1,
      -1,    -1,    -1,   141,     3,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    74,    75,    -1,    77,    78,    -1,    80,    -1,    -1,
      83,    -1,    85,    86,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    96,    -1,    -1,    -1,   100,   101,   102,
     103,   104,   105,   106,   107,   108,   109,   110,    -1,    -1,
      -1,    -1,   115,   116,   117,   118,    -1,    -1,    -1,   122,
     123,    -1,    -1,   126,   127,   128,   129,   130,   131,   132,
      -1,   134,    -1,    -1,    -1,    -1,    -1,   140,   141,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    -1,    16,    17,   103,   104,   105,   106,   107,   108,
     109,   110,    -1,    -1,    -1,    -1,   115,   116,   117,   118,
      -1,    -1,    36,   122,   123,    -1,    -1,   126,   127,   128,
     129,   130,   131,   132,    -1,   134,    -1,    -1,    -1,    -1,
      -1,    -1,   141,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      74,    75,    -1,    77,    78,    -1,    80,    -1,    -1,    83,
      -1,    -1,    86,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    96,    -1,    -1,    -1,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,    -1,    -1,    -1,
      -1,   115,   116,   117,   118,    -1,    -1,    -1,   122,   123,
      -1,    -1,   126,   127,   128,   129,   130,   131,   132,    -1,
     134,    -1,    -1,    63,    -1,    -1,   140,   141,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      -1,    16,    17,    83,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    99,
      -1,    36,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   112,    -1,    -1,    -1,    77,   117,   118,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   126,   127,    -1,    90,
      -1,    -1,    -1,   133,    -1,   135,    -1,    -1,    -1,    74,
      75,    76,    77,    78,    -1,    80,    -1,    -1,    -1,    -1,
     111,    86,   113,   114,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    96,    -1,    -1,    -1,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,    -1,    -1,   139,    -1,
     115,   116,   117,   118,    -1,    -1,    -1,   122,   123,    -1,
      -1,   126,   127,   128,   129,   130,   131,   132,    -1,   134,
      -1,    -1,    63,    -1,    -1,   140,   141,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    -1,
      16,    17,    83,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    99,    -1,
      36,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   112,    -1,    -1,    -1,    -1,   117,   118,    -1,    -1,
      -1,    -1,    -1,    85,    -1,   126,   127,    -1,    -1,    -1,
      -1,    -1,   133,    -1,   135,    -1,    -1,    -1,    74,    75,
      -1,    77,    78,    -1,    80,    -1,    -1,    -1,    -1,   111,
      86,   113,   114,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      96,    -1,    -1,    -1,   100,   101,   102,   103,   104,   105,
     106,   107,   108,   109,   110,    -1,    -1,   139,    -1,   115,
     116,   117,   118,    -1,    -1,    -1,   122,   123,    -1,    -1,
     126,   127,   128,   129,   130,   131,   132,    -1,   134,    -1,
      -1,    63,    -1,    -1,   140,   141,     3,     4,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    -1,    16,
      17,    83,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    99,    -1,    36,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     112,    -1,    -1,    -1,    -1,   117,    -1,    -1,    -1,    -1,
      -1,    -1,    85,    -1,   126,   127,    -1,    -1,    -1,    -1,
      -1,   133,    -1,   135,    -1,    -1,    -1,    74,    75,    -1,
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
     108,   109,   110,     3,    -1,   139,    -1,   115,   116,   117,
     118,    -1,    -1,    -1,   122,   123,    -1,    -1,   126,   127,
     128,   129,   130,   131,   132,    -1,   134,    -1,    -1,    -1,
      -1,    -1,   140,   141,    -1,    -1,    -1,    -1,    -1,    39,
      40,    41,    42,    43,    -1,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      -1,     3,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    15,    16,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,    -1,    -1,
      -1,    -1,    -1,   103,   104,   105,   106,   107,   108,   109,
     110,   111,    -1,   113,   114,   115,   116,   117,   118,    -1,
      -1,    -1,   122,   123,    -1,    -1,   126,   127,   128,   129,
     130,   131,   132,    75,   134,    73,    74,    -1,   138,   139,
      78,   141,    80,    81,    82,    87,    84,    -1,    -1,    -1,
      -1,    89,    90,    91,    92,    93,    94,    95,    -1,    -1,
      -1,   103,   104,   105,   106,   107,   108,   109,   110,    -1,
      -1,    -1,    -1,   115,   116,   117,   118,    -1,    -1,    -1,
     122,   123,    -1,    -1,   126,   127,   128,   129,   130,   131,
     132,    -1,   134,    -1,    -1,    -1,    -1,    -1,    -1,   141,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    39,    40,    41,    42,    43,    -1,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    -1,    -1,    -1,    -1,    85,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    77,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   111,    -1,   113,   114,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   126,    -1,    -1,
      -1,    -1,    -1,   111,    -1,   113,   114,    -1,    -1,   138,
     139,    -1,   141,    -1,    -1,    -1,    -1,    -1,   126,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     138,   139,    -1,   141,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    39,    40,    41,    42,    43,
      -1,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    39,    40,    41,
      42,    43,    -1,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   111,    -1,   113,   114,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   126,    -1,    -1,    -1,    -1,    -1,   111,    -1,   113,
     114,    -1,    -1,   138,   139,    -1,   141,    -1,    -1,    -1,
      -1,    -1,   126,    -1,    -1,    -1,    -1,    -1,    -1,   111,
      -1,   113,   114,    -1,   138,   139,    -1,   141,    -1,    -1,
      -1,    -1,    -1,    -1,   126,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   138,   139,    -1,   141,
      39,    40,    41,    42,    43,    -1,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    76,    77,    15,
      16,    17,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   111,    -1,   113,   114,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    73,    74,   138,
     139,    -1,    78,    -1,    80,    81,    82,    -1,    84,    -1,
      -1,    -1,    -1,    89,    90,    91,    92,    93,    94,    95
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int16 yystos[] =
{
       0,    39,    40,    41,    42,    43,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    77,   111,   113,   114,   126,   138,   139,   141,   167,
     168,   170,   171,   172,   177,   179,   180,   181,   193,   198,
     200,   206,   207,   241,   242,   243,   244,   246,   249,   250,
     251,     3,   103,   104,   105,   106,   107,   108,   109,   110,
     115,   116,   117,   118,   122,   123,   126,   127,   128,   129,
     130,   131,   132,   134,   141,   194,   247,   249,   259,   198,
     206,   208,    75,    75,    91,   173,   175,   199,   207,   177,
     179,   198,   170,   174,   176,   177,   198,   200,    83,   247,
      75,   203,   259,     0,   243,   245,   172,     4,   253,    83,
     195,   198,   206,   259,     4,     5,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    16,    17,    36,    74,    75,
      77,    78,    80,    86,    96,   100,   101,   102,   140,   144,
     145,   147,   148,   149,   150,   151,   152,   153,   154,   155,
     156,   157,   158,   159,   160,   165,   259,    79,    91,    93,
      75,   201,   247,    79,    91,    93,   179,   182,   183,   184,
     185,   186,   208,   249,    83,   200,    75,    87,   167,   168,
     172,   227,   228,   119,   120,   121,   252,   254,   257,   196,
     197,   247,    83,    76,    75,   147,   147,    75,   147,   147,
     160,   161,   163,   178,   179,   198,   214,   215,   249,    90,
      90,    90,    75,    15,    16,    17,    75,    81,    87,   149,
      73,    77,    82,    78,    80,    18,    19,    20,    21,    92,
      94,    22,    23,    74,    89,    84,    24,    25,    95,    76,
     175,   199,    83,   161,   220,   199,    75,    87,   176,   200,
     220,    85,   183,    90,   187,   188,   199,   179,   198,    90,
     185,   190,   191,   200,   208,   182,    76,   204,   165,   166,
     167,    83,   226,    83,    83,    83,   123,   267,    63,    83,
      99,   112,   117,   126,   127,   133,   135,   136,   269,   270,
     273,   283,   286,    79,    85,    93,   196,   215,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,    93,   162,
      76,    79,   214,   214,   206,   207,   216,    76,   104,   105,
     107,   108,   290,    75,   105,   111,   113,   114,   115,   116,
     289,   289,   215,   247,    76,   146,   161,   247,   163,   149,
     149,   149,   150,   150,   151,   151,   152,   152,   152,   152,
     153,   153,   154,   155,   156,   157,   158,   163,    85,   220,
     221,    76,   202,   166,   165,    79,    91,    90,   165,    79,
      91,    90,    85,   126,   141,   168,   169,   172,   205,   209,
     210,   211,   212,   213,   259,    88,    44,    61,    62,    63,
      65,    66,    67,    68,    69,    70,    71,    72,    99,   124,
     125,   133,   137,   163,   164,   167,   222,   223,   224,   225,
     229,   230,   232,   233,   234,   235,   239,   240,   248,   249,
     259,    11,    77,   261,   262,   261,   261,    83,   269,    96,
     100,   101,   102,   280,   281,   282,   268,   269,    75,    75,
     284,   285,   271,   259,   288,   259,     4,     7,     9,    11,
     258,   118,   270,   197,   165,    85,    76,   161,   161,    75,
      87,   217,   149,    75,   103,    75,    75,    79,    76,    79,
      88,    90,    79,    85,   205,    88,   188,   189,   191,   192,
     200,   207,   216,    76,    79,    79,    45,    57,    58,   231,
     165,    90,    75,    75,    75,   222,   249,    75,   248,   259,
      91,    91,   111,   113,   114,   164,   291,    75,   291,    91,
     163,    91,    91,   226,   230,   233,   222,   230,    85,    90,
      85,    78,    79,   263,    85,   255,   229,   118,   282,    90,
      90,    90,   132,    24,    85,    11,   288,   226,   226,    83,
      87,   134,   134,   118,   216,   218,   166,    75,    87,   161,
      76,   161,   161,   259,   161,   160,    85,   220,    76,   165,
     165,    75,    60,   212,   259,    56,   259,   259,   173,    90,
     222,   163,   163,   163,    66,   164,    91,   161,   161,   161,
      91,   161,    91,   134,    85,   222,    36,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    57,    58,    59,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    99,
     100,   101,   102,   119,   120,   121,   124,   125,   137,   249,
     259,   260,   262,   260,    85,    85,   290,   289,   289,   270,
     282,    76,    79,    79,    72,   128,   292,   293,   294,    11,
      83,    83,    76,   210,    88,   219,   166,    76,   105,   111,
      79,    79,    76,    91,   222,    76,    76,    76,    75,    91,
      76,    79,    83,    75,   263,    38,    75,    75,    75,    64,
      91,   287,   288,   288,    75,   128,   129,   130,   290,   295,
     296,    87,   272,    72,   294,    88,   274,   275,   277,   290,
      11,   278,   279,    76,   210,    88,   161,   161,   222,   222,
     222,   163,   164,    91,   161,   236,   237,   277,   122,   259,
     264,   265,   266,   256,   288,   288,   288,   270,    76,    76,
     295,    87,    75,   290,    16,    37,   287,   297,    81,   295,
      85,   295,    62,   275,   276,   270,   290,    90,    90,    62,
     279,    76,    76,    79,    64,    76,    91,    76,    62,   237,
     238,   104,   105,   107,   108,   223,   259,    76,    79,    87,
     260,    76,    76,    79,    79,   287,   134,    76,   295,   288,
      75,   296,   296,   106,   131,   299,    88,   287,    90,    85,
      90,   270,    90,   161,   222,    91,   164,    91,    90,    85,
      15,   266,   259,    75,   161,   161,    83,    88,    76,   295,
     298,    93,   270,   270,    76,    76,   223,   259,    88,   264,
      76,    76,    79,   289,    76,    79,   295,    85,   222,    76,
     161,    90,   295,   287,    76,   270,   289,    90,   270,   289,
      90,   270,    85
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int16 yyr1[] =
{
       0,   143,   144,   144,   144,   144,   144,   144,   144,   144,
     144,   144,   144,   144,   144,   145,   145,   145,   145,   145,
     145,   145,   145,   145,   145,   145,   146,   146,   147,   147,
     147,   147,   147,   147,   147,   148,   148,   148,   148,   148,
     148,   149,   149,   150,   150,   150,   150,   151,   151,   151,
     152,   152,   152,   153,   153,   153,   153,   153,   154,   154,
     154,   155,   155,   156,   156,   157,   157,   158,   158,   159,
     159,   160,   160,   161,   161,   162,   162,   162,   162,   162,
     162,   162,   162,   162,   162,   162,   163,   163,   164,   164,
     165,   166,   166,   167,   167,   167,   168,   168,   169,   169,
     170,   170,   170,   171,   171,   171,   171,   172,   172,   172,
     172,   173,   173,   174,   174,   175,   175,   176,   176,   177,
     177,   177,   177,   177,   177,   177,   177,   178,   178,   179,
     179,   179,   179,   179,   179,   179,   179,   179,   179,   179,
     179,   180,   180,   180,   181,   181,   182,   182,   183,   183,
     184,   184,   185,   185,   185,   186,   186,   186,   187,   187,
     188,   188,   189,   188,   190,   190,   191,   191,   192,   191,
     194,   193,   195,   193,   193,   196,   196,   197,   197,   198,
     198,   199,   200,   201,   201,   201,   202,   201,   203,   203,
     203,   204,   203,   205,   205,   206,   206,   206,   206,   207,
     207,   208,   208,   209,   209,   210,   210,   211,   211,   212,
     212,   212,   213,   213,   214,   214,   214,   214,   215,   215,
     216,   216,   217,   217,   217,   218,   217,   219,   217,   220,
     220,   220,   220,   221,   221,   222,   222,   224,   223,   223,
     223,   223,   223,   223,   223,   225,   225,   225,   226,   226,
     227,   227,   228,   228,   229,   229,   230,   230,   231,   231,
     231,   231,   232,   232,   232,   233,   233,   234,   235,   235,
     235,   235,   236,   236,   237,   238,   238,   239,   239,   239,
     240,   240,   240,   240,   240,   240,   240,   241,   241,   242,
     242,   243,   243,   243,   245,   244,   246,   246,   246,   247,
     247,   248,   248,   249,   249,   249,   249,   251,   250,   252,
     252,   252,   253,   253,   254,   255,   256,   254,   257,   258,
     258,   258,   258,   259,   259,   259,   259,   259,   259,   259,
     259,   259,   259,   259,   259,   259,   259,   259,   259,   259,
     259,   259,   259,   259,   259,   259,   259,   260,   260,   260,
     260,   260,   260,   260,   260,   260,   260,   260,   260,   260,
     260,   260,   260,   260,   260,   260,   260,   260,   260,   260,
     260,   260,   260,   260,   260,   260,   260,   260,   260,   260,
     260,   260,   260,   260,   260,   260,   260,   260,   260,   260,
     260,   260,   261,   261,   261,   262,   262,   263,   263,   264,
     264,   264,   265,   265,   266,   266,   266,   267,   267,   268,
     268,   269,   269,   270,   270,   270,   270,   271,   272,   270,
     273,   273,   273,   273,   273,   274,   274,   275,   276,   276,
     277,   277,   278,   278,   279,   280,   280,   281,   281,   282,
     282,   282,   282,   282,   284,   283,   285,   283,   286,   286,
     287,   287,   288,   288,   289,   289,   289,   289,   289,   289,
     289,   289,   290,   290,   290,   290,   291,   291,   291,   291,
     292,   292,   292,   293,   293,   294,   295,   295,   295,   296,
     296,   296,   296,   296,   296,   297,   298,   298,   299,   299
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
       1,     1,     1,     5,     7,     3,     4,     3,     3,     4,
       1,     2,     0,     1,     1,     2,     1,     4,     1,     2,
       2,     2,     1,     2,     2,     0,     1,     2,     5,     7,
       5,     7,     1,     2,     2,     0,     3,     5,     7,     9,
       3,     2,     2,     3,     3,     2,     2,     0,     1,     1,
       2,     1,     1,     1,     0,     4,     1,     2,     2,     1,
       1,     1,     1,     1,     1,     1,     1,     0,     3,     4,
       3,     4,     0,     1,     8,     0,     0,    11,     5,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     0,     2,     4,     1,     1,     0,     1,     0,
       1,     4,     1,     3,     1,     2,     4,     0,     4,     0,
       1,     1,     2,     1,     1,     1,     3,     0,     0,     6,
       4,     6,     7,     9,    18,     1,     2,     2,     0,     3,
       2,     3,     1,     2,     3,     1,     2,     1,     3,     6,
       6,     8,     8,    10,     0,     3,     0,     3,     5,     7,
       0,     1,     1,     4,     1,     1,     1,     1,     1,     1,
       4,     4,     1,     1,     1,     1,     1,     2,     2,     2,
       4,     3,     1,     1,     2,     7,     1,     3,     3,     1,
       4,     5,     4,     3,     3,     1,     1,     3,     1,     1
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
#line 2549 "rttgram.tab.c"
    break;

  case 3: /* primary_expr: StrLit  */
#line 91 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2555 "rttgram.tab.c"
    break;

  case 4: /* primary_expr: LStrLit  */
#line 92 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2561 "rttgram.tab.c"
    break;

  case 5: /* primary_expr: FltConst  */
#line 93 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2567 "rttgram.tab.c"
    break;

  case 6: /* primary_expr: DblConst  */
#line 94 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2573 "rttgram.tab.c"
    break;

  case 7: /* primary_expr: LDblConst  */
#line 95 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2579 "rttgram.tab.c"
    break;

  case 8: /* primary_expr: CharConst  */
#line 96 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2585 "rttgram.tab.c"
    break;

  case 9: /* primary_expr: LCharConst  */
#line 97 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2591 "rttgram.tab.c"
    break;

  case 10: /* primary_expr: IntConst  */
#line 98 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2597 "rttgram.tab.c"
    break;

  case 11: /* primary_expr: UIntConst  */
#line 99 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2603 "rttgram.tab.c"
    break;

  case 12: /* primary_expr: LIntConst  */
#line 100 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2609 "rttgram.tab.c"
    break;

  case 13: /* primary_expr: ULIntConst  */
#line 101 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2615 "rttgram.tab.c"
    break;

  case 14: /* primary_expr: '(' expr ')'  */
#line 102 "rttgram.y"
                  {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 2621 "rttgram.tab.c"
    break;

  case 16: /* postfix_expr: postfix_expr '[' expr ']'  */
#line 107 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                        free_t((yyvsp[0].t));}
#line 2628 "rttgram.tab.c"
    break;

  case 17: /* postfix_expr: postfix_expr '(' ')'  */
#line 109 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), NULL);
                                        free_t((yyvsp[-1].t));}
#line 2635 "rttgram.tab.c"
    break;

  case 18: /* postfix_expr: postfix_expr '(' arg_expr_lst ')'  */
#line 111 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                        free_t((yyvsp[-2].t));}
#line 2642 "rttgram.tab.c"
    break;

  case 19: /* postfix_expr: postfix_expr '.' any_ident  */
#line 113 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2648 "rttgram.tab.c"
    break;

  case 20: /* postfix_expr: postfix_expr Arrow any_ident  */
#line 114 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2654 "rttgram.tab.c"
    break;

  case 21: /* postfix_expr: postfix_expr Incr  */
#line 115 "rttgram.y"
                                       {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-1].n));}
#line 2660 "rttgram.tab.c"
    break;

  case 22: /* postfix_expr: postfix_expr Decr  */
#line 116 "rttgram.y"
                                       {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-1].n));}
#line 2666 "rttgram.tab.c"
    break;

  case 23: /* postfix_expr: Is ':' i_type_name '(' assign_expr ')'  */
#line 118 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-5].t), (yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 2672 "rttgram.tab.c"
    break;

  case 24: /* postfix_expr: Cnv ':' dest_type '(' assign_expr ',' assign_expr ')'  */
#line 120 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-7].t), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-6].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 2679 "rttgram.tab.c"
    break;

  case 25: /* postfix_expr: Def ':' dest_type '(' assign_expr ',' assign_expr ',' assign_expr ')'  */
#line 123 "rttgram.y"
      {(yyval.n) = node4(QuadNd, (yyvsp[-9].t), (yyvsp[-7].n), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-8].t)); free_t((yyvsp[-6].t));
       free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 2686 "rttgram.tab.c"
    break;

  case 27: /* arg_expr_lst: arg_expr_lst ',' assign_expr  */
#line 129 "rttgram.y"
                                  {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2692 "rttgram.tab.c"
    break;

  case 29: /* unary_expr: Incr unary_expr  */
#line 134 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2698 "rttgram.tab.c"
    break;

  case 30: /* unary_expr: Decr unary_expr  */
#line 135 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2704 "rttgram.tab.c"
    break;

  case 31: /* unary_expr: unary_op cast_expr  */
#line 136 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2710 "rttgram.tab.c"
    break;

  case 32: /* unary_expr: Sizeof unary_expr  */
#line 137 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 2716 "rttgram.tab.c"
    break;

  case 33: /* unary_expr: Sizeof '(' type_name ')'  */
#line 138 "rttgram.y"
                              {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                               free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 2723 "rttgram.tab.c"
    break;

  case 34: /* unary_expr: Offsetof '(' type_name ',' identifier ')'  */
#line 141 "rttgram.y"
      {(yyval.n) = node1(PrefxNd, (yyvsp[-5].t),
                   node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), node0(PrimryNd, (yyvsp[-1].t))));
       free_t((yyvsp[-4].t)); free_t((yyvsp[0].t));}
#line 2731 "rttgram.tab.c"
    break;

  case 42: /* cast_expr: '(' type_name ')' cast_expr  */
#line 157 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-3].t), (yyvsp[-2].n), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 2737 "rttgram.tab.c"
    break;

  case 44: /* multiplicative_expr: multiplicative_expr '*' cast_expr  */
#line 162 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2743 "rttgram.tab.c"
    break;

  case 45: /* multiplicative_expr: multiplicative_expr '/' cast_expr  */
#line 163 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2749 "rttgram.tab.c"
    break;

  case 46: /* multiplicative_expr: multiplicative_expr '%' cast_expr  */
#line 164 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2755 "rttgram.tab.c"
    break;

  case 48: /* additive_expr: additive_expr '+' multiplicative_expr  */
#line 169 "rttgram.y"
                                           {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2761 "rttgram.tab.c"
    break;

  case 49: /* additive_expr: additive_expr '-' multiplicative_expr  */
#line 170 "rttgram.y"
                                           {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2767 "rttgram.tab.c"
    break;

  case 51: /* shift_expr: shift_expr LShft additive_expr  */
#line 175 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2773 "rttgram.tab.c"
    break;

  case 52: /* shift_expr: shift_expr RShft additive_expr  */
#line 176 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2779 "rttgram.tab.c"
    break;

  case 54: /* relational_expr: relational_expr '<' shift_expr  */
#line 181 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2785 "rttgram.tab.c"
    break;

  case 55: /* relational_expr: relational_expr '>' shift_expr  */
#line 182 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2791 "rttgram.tab.c"
    break;

  case 56: /* relational_expr: relational_expr Leq shift_expr  */
#line 183 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2797 "rttgram.tab.c"
    break;

  case 57: /* relational_expr: relational_expr Geq shift_expr  */
#line 184 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2803 "rttgram.tab.c"
    break;

  case 59: /* equality_expr: equality_expr Equal relational_expr  */
#line 189 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2809 "rttgram.tab.c"
    break;

  case 60: /* equality_expr: equality_expr Neq relational_expr  */
#line 190 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2815 "rttgram.tab.c"
    break;

  case 62: /* and_expr: and_expr '&' equality_expr  */
#line 195 "rttgram.y"
                                {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2821 "rttgram.tab.c"
    break;

  case 64: /* exclusive_or_expr: exclusive_or_expr '^' and_expr  */
#line 200 "rttgram.y"
                                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2827 "rttgram.tab.c"
    break;

  case 66: /* inclusive_or_expr: inclusive_or_expr '|' exclusive_or_expr  */
#line 205 "rttgram.y"
                                             {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2833 "rttgram.tab.c"
    break;

  case 68: /* logical_and_expr: logical_and_expr And inclusive_or_expr  */
#line 210 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2839 "rttgram.tab.c"
    break;

  case 70: /* logical_or_expr: logical_or_expr Or logical_and_expr  */
#line 215 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2845 "rttgram.tab.c"
    break;

  case 72: /* conditional_expr: logical_or_expr '?' expr ':' conditional_expr  */
#line 221 "rttgram.y"
                                         {(yyval.n) = node3(TrnryNd, (yyvsp[-3].t), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n));
                                          free_t((yyvsp[-1].t));}
#line 2852 "rttgram.tab.c"
    break;

  case 74: /* assign_expr: unary_expr assign_op assign_expr  */
#line 227 "rttgram.y"
                                      {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2858 "rttgram.tab.c"
    break;

  case 87: /* expr: expr ',' assign_expr  */
#line 246 "rttgram.y"
                          {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2864 "rttgram.tab.c"
    break;

  case 88: /* opt_expr: %empty  */
#line 250 "rttgram.y"
     {(yyval.n) = NULL;}
#line 2870 "rttgram.tab.c"
    break;

  case 91: /* opt_constant_expr: %empty  */
#line 259 "rttgram.y"
     {(yyval.n) = NULL;}
#line 2876 "rttgram.tab.c"
    break;

  case 93: /* dcltion: typ_dcltion_specs ';'  */
#line 264 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-1].n), NULL);
                                             dcl_stk->kind_dcl = OtherDcl;}
#line 2883 "rttgram.tab.c"
    break;

  case 94: /* dcltion: typ_dcltion_specs init_dcltor_lst ';'  */
#line 266 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));
                                             dcl_stk->kind_dcl = OtherDcl;}
#line 2890 "rttgram.tab.c"
    break;

  case 95: /* dcltion: storcl_tqual_lst no_tdn_init_dcltor_lst ';'  */
#line 269 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));
                                             dcl_stk->kind_dcl = OtherDcl;}
#line 2897 "rttgram.tab.c"
    break;

  case 97: /* typ_dcltion_specs: storcl_tqual_lst type_ind  */
#line 275 "rttgram.y"
                               {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2903 "rttgram.tab.c"
    break;

  case 100: /* type_ind: typedefname  */
#line 284 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2909 "rttgram.tab.c"
    break;

  case 101: /* type_ind: typedefname storcl_tqual_lst  */
#line 286 "rttgram.y"
                             {(yyval.n) = node2(LstNd, NULL, node0(PrimryNd, (yyvsp[-1].t)), (yyvsp[0].n));}
#line 2915 "rttgram.tab.c"
    break;

  case 104: /* type_storcl_tqual_lst: type_storcl_tqual_lst stnd_type  */
#line 292 "rttgram.y"
                                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2921 "rttgram.tab.c"
    break;

  case 105: /* type_storcl_tqual_lst: type_storcl_tqual_lst storage_class_spec  */
#line 293 "rttgram.y"
                                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2927 "rttgram.tab.c"
    break;

  case 106: /* type_storcl_tqual_lst: type_storcl_tqual_lst type_qual  */
#line 294 "rttgram.y"
                                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2933 "rttgram.tab.c"
    break;

  case 109: /* storcl_tqual_lst: storcl_tqual_lst storage_class_spec  */
#line 300 "rttgram.y"
                                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2939 "rttgram.tab.c"
    break;

  case 110: /* storcl_tqual_lst: storcl_tqual_lst type_qual  */
#line 301 "rttgram.y"
                                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 2945 "rttgram.tab.c"
    break;

  case 112: /* init_dcltor_lst: init_dcltor_lst ',' init_dcltor  */
#line 306 "rttgram.y"
                                     {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2951 "rttgram.tab.c"
    break;

  case 114: /* no_tdn_init_dcltor_lst: no_tdn_init_dcltor_lst ',' no_tdn_init_dcltor  */
#line 312 "rttgram.y"
                                              {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 2957 "rttgram.tab.c"
    break;

  case 115: /* init_dcltor: dcltor  */
#line 316 "rttgram.y"
                            {(yyval.n) = (yyvsp[0].n); id_def((yyvsp[0].n), NULL);}
#line 2963 "rttgram.tab.c"
    break;

  case 116: /* init_dcltor: dcltor '=' initializer  */
#line 317 "rttgram.y"
                            {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n)); id_def((yyvsp[-2].n), (yyvsp[0].n));}
#line 2969 "rttgram.tab.c"
    break;

  case 117: /* no_tdn_init_dcltor: no_tdn_dcltor  */
#line 321 "rttgram.y"
                              {(yyval.n) = (yyvsp[0].n); id_def((yyvsp[0].n), NULL);}
#line 2975 "rttgram.tab.c"
    break;

  case 118: /* no_tdn_init_dcltor: no_tdn_dcltor '=' initializer  */
#line 323 "rttgram.y"
                              {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n)); id_def((yyvsp[-2].n), (yyvsp[0].n));}
#line 2981 "rttgram.tab.c"
    break;

  case 119: /* storage_class_spec: Typedef  */
#line 327 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t)); dcl_stk->kind_dcl = IsTypedef;}
#line 2987 "rttgram.tab.c"
    break;

  case 120: /* storage_class_spec: Extern  */
#line 328 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2993 "rttgram.tab.c"
    break;

  case 121: /* storage_class_spec: Static  */
#line 329 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 2999 "rttgram.tab.c"
    break;

  case 122: /* storage_class_spec: Thread_local  */
#line 330 "rttgram.y"
                  {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3005 "rttgram.tab.c"
    break;

  case 123: /* storage_class_spec: Auto  */
#line 331 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3011 "rttgram.tab.c"
    break;

  case 124: /* storage_class_spec: Register  */
#line 332 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3017 "rttgram.tab.c"
    break;

  case 125: /* storage_class_spec: Inline  */
#line 333 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3023 "rttgram.tab.c"
    break;

  case 126: /* storage_class_spec: Declspec '(' identifier ')'  */
#line 334 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[0].t),
                                             node0(PrimryNd, (yyvsp[-3].t)),
                                             node0(PrimryNd, (yyvsp[-1].t)));
                                  free_t((yyvsp[-2].t));}
#line 3032 "rttgram.tab.c"
    break;

  case 128: /* type_spec: typedefname  */
#line 342 "rttgram.y"
                 {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3038 "rttgram.tab.c"
    break;

  case 129: /* stnd_type: Void  */
#line 346 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3044 "rttgram.tab.c"
    break;

  case 130: /* stnd_type: Char  */
#line 347 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3050 "rttgram.tab.c"
    break;

  case 131: /* stnd_type: Short  */
#line 348 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3056 "rttgram.tab.c"
    break;

  case 132: /* stnd_type: Int  */
#line 349 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3062 "rttgram.tab.c"
    break;

  case 133: /* stnd_type: Long  */
#line 350 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3068 "rttgram.tab.c"
    break;

  case 134: /* stnd_type: Float  */
#line 351 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3074 "rttgram.tab.c"
    break;

  case 135: /* stnd_type: Doubl  */
#line 352 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3080 "rttgram.tab.c"
    break;

  case 136: /* stnd_type: Signed  */
#line 353 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3086 "rttgram.tab.c"
    break;

  case 137: /* stnd_type: Unsigned  */
#line 354 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3092 "rttgram.tab.c"
    break;

  case 140: /* stnd_type: B_IProc_Type '(' constant_expr ')'  */
#line 357 "rttgram.y"
                                        {(yyval.n) = node2(BinryNd, (yyvsp[0].t),
                                                    node0(PrimryNd, (yyvsp[-3].t)), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t));}
#line 3100 "rttgram.tab.c"
    break;

  case 141: /* struct_or_union_spec: struct_or_union any_ident '{' struct_dcltion_lst '}'  */
#line 364 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                             free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3107 "rttgram.tab.c"
    break;

  case 142: /* struct_or_union_spec: struct_or_union '{' struct_dcltion_lst '}'  */
#line 367 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-3].t), NULL, (yyvsp[-1].n));
                                             free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3114 "rttgram.tab.c"
    break;

  case 143: /* struct_or_union_spec: struct_or_union any_ident  */
#line 369 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[0].n), NULL);}
#line 3120 "rttgram.tab.c"
    break;

  case 147: /* struct_dcltion_lst: struct_dcltion_lst struct_dcltion  */
#line 379 "rttgram.y"
                                       {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3126 "rttgram.tab.c"
    break;

  case 148: /* struct_dcltion: struct_dcltion_specs struct_dcltor_lst ';'  */
#line 384 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));}
#line 3132 "rttgram.tab.c"
    break;

  case 149: /* struct_dcltion: tqual_lst struct_no_tdn_dcltor_lst ';'  */
#line 385 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-2].n), (yyvsp[-1].n));}
#line 3138 "rttgram.tab.c"
    break;

  case 151: /* struct_dcltion_specs: tqual_lst struct_type_ind  */
#line 390 "rttgram.y"
                                {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3144 "rttgram.tab.c"
    break;

  case 152: /* struct_type_ind: typedefname  */
#line 394 "rttgram.y"
                            {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3150 "rttgram.tab.c"
    break;

  case 153: /* struct_type_ind: typedefname tqual_lst  */
#line 395 "rttgram.y"
                            {(yyval.n) = node2(LstNd, NULL, node0(PrimryNd, (yyvsp[-1].t)), (yyvsp[0].n));}
#line 3156 "rttgram.tab.c"
    break;

  case 156: /* struct_type_lst: struct_type_lst stnd_type  */
#line 401 "rttgram.y"
                               {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3162 "rttgram.tab.c"
    break;

  case 157: /* struct_type_lst: struct_type_lst type_qual  */
#line 402 "rttgram.y"
                               {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3168 "rttgram.tab.c"
    break;

  case 159: /* struct_dcltor_lst: struct_dcltor_lst ',' struct_dcltor  */
#line 406 "rttgram.y"
                                         {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3174 "rttgram.tab.c"
    break;

  case 160: /* struct_dcltor: dcltor  */
#line 410 "rttgram.y"
                              {(yyval.n) = node2(StrDclNd, NULL, (yyvsp[0].n), NULL);
                               if (dcl_stk->parms_done) pop_cntxt();}
#line 3181 "rttgram.tab.c"
    break;

  case 161: /* struct_dcltor: ':' constant_expr  */
#line 412 "rttgram.y"
                              {(yyval.n) = node2(StrDclNd, (yyvsp[-1].t), NULL, (yyvsp[0].n));}
#line 3187 "rttgram.tab.c"
    break;

  case 162: /* $@1: %empty  */
#line 413 "rttgram.y"
                {if (dcl_stk->parms_done) pop_cntxt();}
#line 3193 "rttgram.tab.c"
    break;

  case 163: /* struct_dcltor: dcltor ':' $@1 constant_expr  */
#line 414 "rttgram.y"
                              {(yyval.n) = node2(StrDclNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[0].n));}
#line 3199 "rttgram.tab.c"
    break;

  case 165: /* struct_no_tdn_dcltor_lst: struct_no_tdn_dcltor_lst ',' struct_no_tdn_dcltor  */
#line 420 "rttgram.y"
                                              {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3205 "rttgram.tab.c"
    break;

  case 166: /* struct_no_tdn_dcltor: no_tdn_dcltor  */
#line 424 "rttgram.y"
                                     {(yyval.n) = node2(StrDclNd, NULL, (yyvsp[0].n), NULL);
                                      if (dcl_stk->parms_done) pop_cntxt();}
#line 3212 "rttgram.tab.c"
    break;

  case 167: /* struct_no_tdn_dcltor: ':' constant_expr  */
#line 426 "rttgram.y"
                                     {(yyval.n) = node2(StrDclNd, (yyvsp[-1].t), NULL, (yyvsp[0].n));}
#line 3218 "rttgram.tab.c"
    break;

  case 168: /* $@2: %empty  */
#line 427 "rttgram.y"
                       {if (dcl_stk->parms_done) pop_cntxt();}
#line 3224 "rttgram.tab.c"
    break;

  case 169: /* struct_no_tdn_dcltor: no_tdn_dcltor ':' $@2 constant_expr  */
#line 428 "rttgram.y"
                                     {(yyval.n) = node2(StrDclNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[0].n));}
#line 3230 "rttgram.tab.c"
    break;

  case 170: /* $@3: %empty  */
#line 432 "rttgram.y"
          {push_cntxt(0);}
#line 3236 "rttgram.tab.c"
    break;

  case 171: /* enum_spec: Enum $@3 '{' enumerator_lst '}'  */
#line 433 "rttgram.y"
       {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), NULL, (yyvsp[-1].n)); pop_cntxt(); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3242 "rttgram.tab.c"
    break;

  case 172: /* $@4: %empty  */
#line 434 "rttgram.y"
                    {push_cntxt(0);}
#line 3248 "rttgram.tab.c"
    break;

  case 173: /* enum_spec: Enum any_ident $@4 '{' enumerator_lst '}'  */
#line 435 "rttgram.y"
       {(yyval.n) = node2(BinryNd, (yyvsp[-5].t), (yyvsp[-4].n),  (yyvsp[-1].n)); pop_cntxt(); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3254 "rttgram.tab.c"
    break;

  case 174: /* enum_spec: Enum any_ident  */
#line 436 "rttgram.y"
                    {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[0].n),  NULL);}
#line 3260 "rttgram.tab.c"
    break;

  case 176: /* enumerator_lst: enumerator_lst ',' enumerator  */
#line 441 "rttgram.y"
                                   {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3266 "rttgram.tab.c"
    break;

  case 177: /* enumerator: any_ident  */
#line 445 "rttgram.y"
                              {(yyval.n) = (yyvsp[0].n); id_def((yyvsp[0].n), NULL);}
#line 3272 "rttgram.tab.c"
    break;

  case 178: /* enumerator: any_ident '=' constant_expr  */
#line 447 "rttgram.y"
                              {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n)); id_def((yyvsp[-2].n), (yyvsp[0].n));}
#line 3278 "rttgram.tab.c"
    break;

  case 179: /* type_qual: Const  */
#line 451 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3284 "rttgram.tab.c"
    break;

  case 180: /* type_qual: Volatile  */
#line 452 "rttgram.y"
              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3290 "rttgram.tab.c"
    break;

  case 181: /* dcltor: opt_pointer direct_dcltor  */
#line 457 "rttgram.y"
                                {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3296 "rttgram.tab.c"
    break;

  case 182: /* no_tdn_dcltor: opt_pointer no_tdn_direct_dcltor  */
#line 461 "rttgram.y"
                                      {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3302 "rttgram.tab.c"
    break;

  case 184: /* direct_dcltor: '(' dcltor ')'  */
#line 466 "rttgram.y"
                                              {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3309 "rttgram.tab.c"
    break;

  case 185: /* direct_dcltor: direct_dcltor '[' opt_constant_expr ']'  */
#line 468 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3316 "rttgram.tab.c"
    break;

  case 186: /* $@5: %empty  */
#line 470 "rttgram.y"
                       {push_cntxt(1);}
#line 3322 "rttgram.tab.c"
    break;

  case 187: /* direct_dcltor: direct_dcltor '(' $@5 parm_dcls_or_ids ')'  */
#line 471 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                               if (dcl_stk->nest_lvl == 2)
                                                  dcl_stk->parms_done = 1;
                                                else
                                                  pop_cntxt();
                                               free_t((yyvsp[-3].t));}
#line 3333 "rttgram.tab.c"
    break;

  case 188: /* no_tdn_direct_dcltor: identifier  */
#line 480 "rttgram.y"
                                              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3339 "rttgram.tab.c"
    break;

  case 189: /* no_tdn_direct_dcltor: '(' no_tdn_dcltor ')'  */
#line 481 "rttgram.y"
                                              {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3346 "rttgram.tab.c"
    break;

  case 190: /* no_tdn_direct_dcltor: no_tdn_direct_dcltor '[' opt_constant_expr ']'  */
#line 484 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                               free_t((yyvsp[0].t));}
#line 3353 "rttgram.tab.c"
    break;

  case 191: /* $@6: %empty  */
#line 486 "rttgram.y"
                              {push_cntxt(1);}
#line 3359 "rttgram.tab.c"
    break;

  case 192: /* no_tdn_direct_dcltor: no_tdn_direct_dcltor '(' $@6 parm_dcls_or_ids ')'  */
#line 487 "rttgram.y"
                                              {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                               if (dcl_stk->nest_lvl == 2)
                                                  dcl_stk->parms_done = 1;
                                                else
                                                  pop_cntxt();
                                               free_t((yyvsp[-3].t));}
#line 3370 "rttgram.tab.c"
    break;

  case 195: /* pointer: '*'  */
#line 501 "rttgram.y"
                           {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3376 "rttgram.tab.c"
    break;

  case 196: /* pointer: '*' tqual_lst  */
#line 502 "rttgram.y"
                           {(yyval.n) = node1(PreSpcNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 3382 "rttgram.tab.c"
    break;

  case 197: /* pointer: '*' pointer  */
#line 503 "rttgram.y"
                           {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 3388 "rttgram.tab.c"
    break;

  case 198: /* pointer: '*' tqual_lst pointer  */
#line 504 "rttgram.y"
                           {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), node2(LstNd, NULL, (yyvsp[-1].n),(yyvsp[0].n)));}
#line 3394 "rttgram.tab.c"
    break;

  case 199: /* opt_pointer: %empty  */
#line 508 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3400 "rttgram.tab.c"
    break;

  case 202: /* tqual_lst: tqual_lst type_qual  */
#line 514 "rttgram.y"
                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3406 "rttgram.tab.c"
    break;

  case 204: /* param_type_lst: param_lst ',' Ellipsis  */
#line 519 "rttgram.y"
                            {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), node0(PrimryNd, (yyvsp[0].t)));}
#line 3412 "rttgram.tab.c"
    break;

  case 205: /* opt_param_type_lst: %empty  */
#line 523 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3418 "rttgram.tab.c"
    break;

  case 208: /* param_lst: param_lst ',' param_dcltion  */
#line 529 "rttgram.y"
                                 {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3424 "rttgram.tab.c"
    break;

  case 209: /* param_dcltion: dcltion_specs no_tdn_dcltor  */
#line 533 "rttgram.y"
                                   {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));
                                    id_def((yyvsp[0].n), NULL);}
#line 3431 "rttgram.tab.c"
    break;

  case 211: /* param_dcltion: dcltion_specs abstract_dcltor  */
#line 536 "rttgram.y"
                                   {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3437 "rttgram.tab.c"
    break;

  case 212: /* ident_lst: identifier  */
#line 540 "rttgram.y"
                              {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3443 "rttgram.tab.c"
    break;

  case 213: /* ident_lst: ident_lst ',' identifier  */
#line 541 "rttgram.y"
                              {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), node0(PrimryNd,(yyvsp[0].t)));}
#line 3449 "rttgram.tab.c"
    break;

  case 216: /* type_tqual_lst: type_spec type_tqual_lst  */
#line 547 "rttgram.y"
                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3455 "rttgram.tab.c"
    break;

  case 217: /* type_tqual_lst: type_qual type_tqual_lst  */
#line 548 "rttgram.y"
                              {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3461 "rttgram.tab.c"
    break;

  case 219: /* type_name: type_tqual_lst abstract_dcltor  */
#line 553 "rttgram.y"
                                    {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3467 "rttgram.tab.c"
    break;

  case 221: /* abstract_dcltor: opt_pointer direct_abstract_dcltor  */
#line 558 "rttgram.y"
                                        {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3473 "rttgram.tab.c"
    break;

  case 222: /* direct_abstract_dcltor: '(' abstract_dcltor ')'  */
#line 562 "rttgram.y"
                                            {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n));
                                             free_t((yyvsp[0].t));}
#line 3480 "rttgram.tab.c"
    break;

  case 223: /* direct_abstract_dcltor: '[' opt_constant_expr ']'  */
#line 565 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), NULL, (yyvsp[-1].n));
                                             free_t((yyvsp[0].t));}
#line 3487 "rttgram.tab.c"
    break;

  case 224: /* direct_abstract_dcltor: direct_abstract_dcltor '[' opt_constant_expr ']'  */
#line 568 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                             free_t((yyvsp[0].t));}
#line 3494 "rttgram.tab.c"
    break;

  case 225: /* $@7: %empty  */
#line 570 "rttgram.y"
                                {push_cntxt(1);}
#line 3500 "rttgram.tab.c"
    break;

  case 226: /* direct_abstract_dcltor: '(' $@7 opt_param_type_lst ')'  */
#line 571 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), NULL, (yyvsp[-1].n));
                                             pop_cntxt();
                                             free_t((yyvsp[-3].t));}
#line 3508 "rttgram.tab.c"
    break;

  case 227: /* $@8: %empty  */
#line 574 "rttgram.y"
                                {push_cntxt(1);}
#line 3514 "rttgram.tab.c"
    break;

  case 228: /* direct_abstract_dcltor: direct_abstract_dcltor '(' $@8 opt_param_type_lst ')'  */
#line 575 "rttgram.y"
                                            {(yyval.n) = node2(BinryNd, (yyvsp[0].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                             pop_cntxt();
                                             free_t((yyvsp[-3].t));}
#line 3522 "rttgram.tab.c"
    break;

  case 230: /* initializer: '{' '}'  */
#line 582 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), NULL); free_t((yyvsp[0].t));}
#line 3528 "rttgram.tab.c"
    break;

  case 231: /* initializer: '{' initializer_lst '}'  */
#line 584 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3534 "rttgram.tab.c"
    break;

  case 232: /* initializer: '{' initializer_lst ',' '}'  */
#line 586 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), NULL));
                          free_t((yyvsp[0].t));}
#line 3541 "rttgram.tab.c"
    break;

  case 234: /* initializer_lst: initializer_lst ',' initializer  */
#line 592 "rttgram.y"
                                     {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3547 "rttgram.tab.c"
    break;

  case 237: /* $@9: %empty  */
#line 601 "rttgram.y"
     {push_cntxt(1);}
#line 3553 "rttgram.tab.c"
    break;

  case 238: /* non_lbl_stmt: $@9 compound_stmt  */
#line 601 "rttgram.y"
                                    {(yyval.n) = (yyvsp[0].n); pop_cntxt();}
#line 3559 "rttgram.tab.c"
    break;

  case 243: /* non_lbl_stmt: Runerr '(' assign_expr ')' ';'  */
#line 607 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-2].n), NULL); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3565 "rttgram.tab.c"
    break;

  case 244: /* non_lbl_stmt: Runerr '(' assign_expr ',' assign_expr ')' ';'  */
#line 609 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-6].t), (yyvsp[-4].n), (yyvsp[-2].n)); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3571 "rttgram.tab.c"
    break;

  case 245: /* labeled_stmt: label ':' stmt  */
#line 613 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 3577 "rttgram.tab.c"
    break;

  case 246: /* labeled_stmt: Case constant_expr ':' stmt  */
#line 614 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-3].t), (yyvsp[-2].n), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 3583 "rttgram.tab.c"
    break;

  case 247: /* labeled_stmt: Default ':' stmt  */
#line 615 "rttgram.y"
                                 {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 3589 "rttgram.tab.c"
    break;

  case 248: /* compound_stmt: '{' opt_stmt_lst '}'  */
#line 619 "rttgram.y"
                                     {(yyval.n) = comp_nd((yyvsp[-2].t), NULL, (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3595 "rttgram.tab.c"
    break;

  case 249: /* compound_stmt: '{' local_dcls opt_stmt_lst '}'  */
#line 620 "rttgram.y"
                                     {(yyval.n) = comp_nd((yyvsp[-3].t), (yyvsp[-2].n),   (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3601 "rttgram.tab.c"
    break;

  case 251: /* dcltion_lst: dcltion_lst dcltion  */
#line 625 "rttgram.y"
                         {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3607 "rttgram.tab.c"
    break;

  case 252: /* opt_dcltion_lst: %empty  */
#line 629 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3613 "rttgram.tab.c"
    break;

  case 255: /* local_dcls: local_dcls local_dcl  */
#line 635 "rttgram.y"
                          {(yyval.n) = ((yyvsp[0].n) == NULL ? (yyvsp[-1].n) : node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n)));}
#line 3619 "rttgram.tab.c"
    break;

  case 257: /* local_dcl: Tended tended_type init_dcltor_lst ';'  */
#line 641 "rttgram.y"
             {(yyval.n) = NULL; free_t((yyvsp[-3].t)); free_t((yyvsp[0].t)); dcl_stk->kind_dcl = OtherDcl;}
#line 3625 "rttgram.tab.c"
    break;

  case 258: /* tended_type: Char  */
#line 645 "rttgram.y"
                        {tnd_char(); free_t((yyvsp[0].t));}
#line 3631 "rttgram.tab.c"
    break;

  case 259: /* tended_type: Struct identifier  */
#line 646 "rttgram.y"
                        {tnd_strct((yyvsp[0].t)); free_t((yyvsp[-1].t));}
#line 3637 "rttgram.tab.c"
    break;

  case 260: /* tended_type: Struct TypeDefName  */
#line 647 "rttgram.y"
                        {tnd_strct((yyvsp[0].t)); free_t((yyvsp[-1].t));}
#line 3643 "rttgram.tab.c"
    break;

  case 261: /* tended_type: Union identifier  */
#line 648 "rttgram.y"
                        {tnd_union((yyvsp[0].t)); free_t((yyvsp[-1].t));}
#line 3649 "rttgram.tab.c"
    break;

  case 263: /* stmt_lst: stmt_lst stmt  */
#line 653 "rttgram.y"
                   {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3655 "rttgram.tab.c"
    break;

  case 264: /* stmt_lst: stmt_lst local_dcl  */
#line 654 "rttgram.y"
                        {(yyval.n) = ((yyvsp[0].n) == NULL ? (yyvsp[-1].n) : node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n)));}
#line 3661 "rttgram.tab.c"
    break;

  case 265: /* opt_stmt_lst: %empty  */
#line 658 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3667 "rttgram.tab.c"
    break;

  case 267: /* expr_stmt: opt_expr ';'  */
#line 662 "rttgram.y"
                  {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-1].n));}
#line 3673 "rttgram.tab.c"
    break;

  case 268: /* selection_stmt: If '(' expr ')' stmt  */
#line 666 "rttgram.y"
                                         {(yyval.n) = node3(TrnryNd, (yyvsp[-4].t), (yyvsp[-2].n), (yyvsp[0].n),NULL);
                                          free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3680 "rttgram.tab.c"
    break;

  case 269: /* selection_stmt: If '(' expr ')' stmt Else stmt  */
#line 668 "rttgram.y"
                                         {(yyval.n) = node3(TrnryNd, (yyvsp[-6].t), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n));
                                          free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3687 "rttgram.tab.c"
    break;

  case 270: /* selection_stmt: Switch '(' expr ')' stmt  */
#line 670 "rttgram.y"
                                         {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-2].n), (yyvsp[0].n));
                                          free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3694 "rttgram.tab.c"
    break;

  case 271: /* selection_stmt: Type_case expr Of '{' c_type_select_lst c_opt_default '}'  */
#line 673 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-6].t), (yyvsp[-5].n), (yyvsp[-2].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[0].t));}
#line 3700 "rttgram.tab.c"
    break;

  case 272: /* c_type_select_lst: c_type_select  */
#line 677 "rttgram.y"
                                     {(yyval.n) = node2(ConCatNd, NULL, NULL, (yyvsp[0].n));}
#line 3706 "rttgram.tab.c"
    break;

  case 273: /* c_type_select_lst: c_type_select_lst c_type_select  */
#line 678 "rttgram.y"
                                     {(yyval.n) = node2(ConCatNd, NULL,   (yyvsp[-1].n), (yyvsp[0].n));}
#line 3712 "rttgram.tab.c"
    break;

  case 274: /* c_type_select: selector_lst non_lbl_stmt  */
#line 682 "rttgram.y"
                               {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3718 "rttgram.tab.c"
    break;

  case 275: /* c_opt_default: %empty  */
#line 686 "rttgram.y"
     {(yyval.n) = NULL;}
#line 3724 "rttgram.tab.c"
    break;

  case 276: /* c_opt_default: Default ':' non_lbl_stmt  */
#line 687 "rttgram.y"
                              {(yyval.n) = (yyvsp[0].n); free_t((yyvsp[-2].t)); free_t((yyvsp[-1].t));}
#line 3730 "rttgram.tab.c"
    break;

  case 277: /* iteration_stmt: While '(' expr ')' stmt  */
#line 691 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-2].n), (yyvsp[0].n));
                                        free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3737 "rttgram.tab.c"
    break;

  case 278: /* iteration_stmt: Do stmt While '(' expr ')' ';'  */
#line 693 "rttgram.y"
                                       {(yyval.n) = node2(BinryNd, (yyvsp[-6].t), (yyvsp[-5].n), (yyvsp[-2].n));
                                        free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));
                                        free_t((yyvsp[0].t));}
#line 3745 "rttgram.tab.c"
    break;

  case 279: /* iteration_stmt: For '(' opt_expr ';' opt_expr ';' opt_expr ')' stmt  */
#line 697 "rttgram.y"
                                       {(yyval.n) = node4(QuadNd, (yyvsp[-8].t), (yyvsp[-6].n), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n));
                                        free_t((yyvsp[-7].t)); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t));
                                        free_t((yyvsp[-1].t));}
#line 3753 "rttgram.tab.c"
    break;

  case 280: /* jump_stmt: Goto label ';'  */
#line 703 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3759 "rttgram.tab.c"
    break;

  case 281: /* jump_stmt: Continue ';'  */
#line 704 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3765 "rttgram.tab.c"
    break;

  case 282: /* jump_stmt: Break ';'  */
#line 705 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3771 "rttgram.tab.c"
    break;

  case 283: /* jump_stmt: Return ret_val ';'  */
#line 706 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3777 "rttgram.tab.c"
    break;

  case 284: /* jump_stmt: Suspend ret_val ';'  */
#line 707 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3783 "rttgram.tab.c"
    break;

  case 285: /* jump_stmt: Fail ';'  */
#line 708 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3789 "rttgram.tab.c"
    break;

  case 286: /* jump_stmt: Errorfail ';'  */
#line 709 "rttgram.y"
                         {(yyval.n) = node0(PrimryNd, (yyvsp[-1].t)); free_t((yyvsp[0].t));}
#line 3795 "rttgram.tab.c"
    break;

  case 292: /* external_dcltion: dcltion  */
#line 724 "rttgram.y"
                            {dclout((yyvsp[0].n));}
#line 3801 "rttgram.tab.c"
    break;

  case 294: /* $@10: %empty  */
#line 729 "rttgram.y"
               {func_def((yyvsp[0].n));}
#line 3807 "rttgram.tab.c"
    break;

  case 295: /* function_definition: func_head $@10 opt_dcltion_lst compound_stmt  */
#line 730 "rttgram.y"
                                                          {fncout((yyvsp[-3].n), (yyvsp[-1].n), (yyvsp[0].n));}
#line 3813 "rttgram.tab.c"
    break;

  case 296: /* func_head: no_tdn_dcltor  */
#line 734 "rttgram.y"
                                     {(yyval.n) = node2(LstNd, NULL, NULL, (yyvsp[0].n));}
#line 3819 "rttgram.tab.c"
    break;

  case 297: /* func_head: storcl_tqual_lst no_tdn_dcltor  */
#line 735 "rttgram.y"
                                     {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3825 "rttgram.tab.c"
    break;

  case 298: /* func_head: typ_dcltion_specs dcltor  */
#line 736 "rttgram.y"
                                     {(yyval.n) = node2(LstNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 3831 "rttgram.tab.c"
    break;

  case 299: /* any_ident: identifier  */
#line 740 "rttgram.y"
                 {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3837 "rttgram.tab.c"
    break;

  case 300: /* any_ident: typedefname  */
#line 741 "rttgram.y"
                 {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 3843 "rttgram.tab.c"
    break;

  case 301: /* label: identifier  */
#line 745 "rttgram.y"
                 {(yyval.n) = lbl((yyvsp[0].t));}
#line 3849 "rttgram.tab.c"
    break;

  case 302: /* label: typedefname  */
#line 746 "rttgram.y"
                 {(yyval.n) = lbl((yyvsp[0].t));}
#line 3855 "rttgram.tab.c"
    break;

  case 307: /* $@11: %empty  */
#line 761 "rttgram.y"
     {strt_def();}
#line 3861 "rttgram.tab.c"
    break;

  case 309: /* operation: fnc_oper op_declare actions End  */
#line 765 "rttgram.y"
                                     {defout((yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3867 "rttgram.tab.c"
    break;

  case 310: /* operation: keyword actions End  */
#line 766 "rttgram.y"
                                     {defout((yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 3873 "rttgram.tab.c"
    break;

  case 311: /* operation: keyword Constant key_const End  */
#line 767 "rttgram.y"
                                     {keyconst((yyvsp[-1].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3879 "rttgram.tab.c"
    break;

  case 312: /* description: %empty  */
#line 771 "rttgram.y"
             {comment = NULL;}
#line 3885 "rttgram.tab.c"
    break;

  case 313: /* description: StrLit  */
#line 772 "rttgram.y"
             {comment = (yyvsp[0].t);}
#line 3891 "rttgram.tab.c"
    break;

  case 314: /* fnc_oper: Function '{' result_seq '}' op_name '(' opt_s_parm_lst ')'  */
#line 777 "rttgram.y"
      {impl_fnc((yyvsp[-3].t)); free_t((yyvsp[-7].t)); free_t((yyvsp[-6].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 3898 "rttgram.tab.c"
    break;

  case 315: /* $@12: %empty  */
#line 779 "rttgram.y"
                             {lex_state = OpHead;}
#line 3904 "rttgram.tab.c"
    break;

  case 316: /* $@13: %empty  */
#line 780 "rttgram.y"
      {lex_state = DfltLex;}
#line 3910 "rttgram.tab.c"
    break;

  case 317: /* fnc_oper: Operator '{' result_seq $@12 '}' OpSym $@13 op_name '(' opt_s_parm_lst ')'  */
#line 781 "rttgram.y"
      {impl_op((yyvsp[-5].t), (yyvsp[-3].t)); free_t((yyvsp[-10].t)); free_t((yyvsp[-9].t)); free_t((yyvsp[-6].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 3917 "rttgram.tab.c"
    break;

  case 318: /* keyword: Keyword '{' result_seq '}' op_name  */
#line 786 "rttgram.y"
       {impl_key((yyvsp[0].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 3923 "rttgram.tab.c"
    break;

  case 392: /* result_seq: %empty  */
#line 878 "rttgram.y"
                                {set_r_seq(NoRsltSeq, NoRsltSeq, 0);}
#line 3929 "rttgram.tab.c"
    break;

  case 393: /* result_seq: length opt_plus  */
#line 879 "rttgram.y"
                                {set_r_seq((yyvsp[-1].i), (yyvsp[-1].i), (int)(yyvsp[0].i));}
#line 3935 "rttgram.tab.c"
    break;

  case 394: /* result_seq: length ',' length opt_plus  */
#line 880 "rttgram.y"
                                {set_r_seq((yyvsp[-3].i), (yyvsp[-1].i), (int)(yyvsp[0].i)); free_t((yyvsp[-2].t));}
#line 3941 "rttgram.tab.c"
    break;

  case 395: /* length: IntConst  */
#line 884 "rttgram.y"
              {(yyval.i) = ttol((yyvsp[0].t)); free_t((yyvsp[0].t));}
#line 3947 "rttgram.tab.c"
    break;

  case 396: /* length: '*'  */
#line 885 "rttgram.y"
              {(yyval.i) = UnbndSeq; free_t((yyvsp[0].t));}
#line 3953 "rttgram.tab.c"
    break;

  case 397: /* opt_plus: %empty  */
#line 889 "rttgram.y"
         {(yyval.i) = 0;}
#line 3959 "rttgram.tab.c"
    break;

  case 398: /* opt_plus: '+'  */
#line 890 "rttgram.y"
         {(yyval.i) = 1; free_t((yyvsp[0].t));}
#line 3965 "rttgram.tab.c"
    break;

  case 401: /* opt_s_parm_lst: s_parm_lst '[' identifier ']'  */
#line 896 "rttgram.y"
                                   {var_args((yyvsp[-1].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 3971 "rttgram.tab.c"
    break;

  case 403: /* s_parm_lst: s_parm_lst ',' s_parm  */
#line 901 "rttgram.y"
                           {free_t((yyvsp[-1].t));}
#line 3977 "rttgram.tab.c"
    break;

  case 404: /* s_parm: identifier  */
#line 905 "rttgram.y"
                                         {s_prm_def(NULL, (yyvsp[0].t));}
#line 3983 "rttgram.tab.c"
    break;

  case 405: /* s_parm: Underef identifier  */
#line 906 "rttgram.y"
                                         {s_prm_def((yyvsp[0].t), NULL); free_t((yyvsp[-1].t));}
#line 3989 "rttgram.tab.c"
    break;

  case 406: /* s_parm: Underef identifier Arrow identifier  */
#line 907 "rttgram.y"
                                         {s_prm_def((yyvsp[-2].t), (yyvsp[0].t));   free_t((yyvsp[-3].t));
                                          free_t((yyvsp[-1].t));}
#line 3996 "rttgram.tab.c"
    break;

  case 407: /* op_declare: %empty  */
#line 912 "rttgram.y"
     {}
#line 4002 "rttgram.tab.c"
    break;

  case 408: /* op_declare: Declare '{' local_dcls '}'  */
#line 913 "rttgram.y"
                                {d_lst_typ((yyvsp[-1].n)); free_t((yyvsp[-3].t)); free_t((yyvsp[-2].t));
                                 free_t((yyvsp[0].t));}
#line 4009 "rttgram.tab.c"
    break;

  case 409: /* opt_actions: %empty  */
#line 918 "rttgram.y"
     {(yyval.n) = NULL;}
#line 4015 "rttgram.tab.c"
    break;

  case 412: /* actions: actions action  */
#line 924 "rttgram.y"
                    {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4021 "rttgram.tab.c"
    break;

  case 416: /* action: '{' opt_actions '}'  */
#line 931 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[-1].n)); free_t((yyvsp[0].t));}
#line 4027 "rttgram.tab.c"
    break;

  case 417: /* $@14: %empty  */
#line 932 "rttgram.y"
              {lex_state = TypeComp;}
#line 4033 "rttgram.tab.c"
    break;

  case 418: /* $@15: %empty  */
#line 933 "rttgram.y"
         {lex_state = DfltLex;}
#line 4039 "rttgram.tab.c"
    break;

  case 419: /* action: Abstract $@14 '{' type_computations $@15 '}'  */
#line 934 "rttgram.y"
         {(yyval.n) = (yyvsp[-2].n); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[0].t));}
#line 4045 "rttgram.tab.c"
    break;

  case 420: /* checking_conversions: If type_check Then action  */
#line 939 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-3].t), (yyvsp[-2].n), (yyvsp[0].n), NULL); free_t((yyvsp[-1].t));}
#line 4051 "rttgram.tab.c"
    break;

  case 421: /* checking_conversions: If type_check Then action Else action  */
#line 941 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-5].t), (yyvsp[-4].n), (yyvsp[-2].n), (yyvsp[0].n)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4057 "rttgram.tab.c"
    break;

  case 422: /* checking_conversions: Type_case variable Of '{' type_select_lst opt_default '}'  */
#line 943 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-6].t), (yyvsp[-5].n), (yyvsp[-2].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[0].t));}
#line 4063 "rttgram.tab.c"
    break;

  case 423: /* checking_conversions: Len_case identifier Of '{' len_select_lst Default ':' action '}'  */
#line 945 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-8].t), sym_node((yyvsp[-7].t)), (yyvsp[-4].n), (yyvsp[-1].n)); free_t((yyvsp[-6].t)), free_t((yyvsp[-5].t));
       free_t((yyvsp[-3].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4070 "rttgram.tab.c"
    break;

  case 424: /* checking_conversions: Arith_case '(' variable ',' variable ')' Of '{' dest_type ':' action dest_type ':' action dest_type ':' action '}'  */
#line 949 "rttgram.y"
      {(yyval.n) = arith_nd((yyvsp[-17].t), (yyvsp[-15].n), (yyvsp[-13].n), (yyvsp[-9].n), (yyvsp[-7].n), (yyvsp[-6].n), (yyvsp[-4].n), (yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-16].t));
       free_t((yyvsp[-14].t)), free_t((yyvsp[-12].t)); free_t((yyvsp[-11].t)); free_t((yyvsp[-10].t)); free_t((yyvsp[-8].t));
       free_t((yyvsp[-5].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4078 "rttgram.tab.c"
    break;

  case 425: /* type_select_lst: type_select  */
#line 955 "rttgram.y"
                                 {(yyval.n) = node2(ConCatNd, NULL, NULL, (yyvsp[0].n));}
#line 4084 "rttgram.tab.c"
    break;

  case 426: /* type_select_lst: type_select_lst type_select  */
#line 956 "rttgram.y"
                                 {(yyval.n) = node2(ConCatNd, NULL,   (yyvsp[-1].n), (yyvsp[0].n));}
#line 4090 "rttgram.tab.c"
    break;

  case 427: /* type_select: selector_lst action  */
#line 960 "rttgram.y"
                         {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4096 "rttgram.tab.c"
    break;

  case 428: /* opt_default: %empty  */
#line 964 "rttgram.y"
     {(yyval.n) = NULL;}
#line 4102 "rttgram.tab.c"
    break;

  case 429: /* opt_default: Default ':' action  */
#line 965 "rttgram.y"
                        {(yyval.n) = (yyvsp[0].n); free_t((yyvsp[-2].t)); free_t((yyvsp[-1].t));}
#line 4108 "rttgram.tab.c"
    break;

  case 430: /* selector_lst: i_type_name ':'  */
#line 969 "rttgram.y"
                                  {(yyval.n) = node2(ConCatNd, NULL, NULL, (yyvsp[-1].n));
                                   free_t((yyvsp[0].t));}
#line 4115 "rttgram.tab.c"
    break;

  case 431: /* selector_lst: selector_lst i_type_name ':'  */
#line 971 "rttgram.y"
                                  {(yyval.n) = node2(ConCatNd, NULL,   (yyvsp[-2].n), (yyvsp[-1].n));
                                   free_t((yyvsp[0].t));}
#line 4122 "rttgram.tab.c"
    break;

  case 433: /* len_select_lst: len_select_lst len_select  */
#line 977 "rttgram.y"
                               {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4128 "rttgram.tab.c"
    break;

  case 434: /* len_select: IntConst ':' action  */
#line 981 "rttgram.y"
                         {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); free_t((yyvsp[-1].t));}
#line 4134 "rttgram.tab.c"
    break;

  case 436: /* type_check: '!' simple_check  */
#line 986 "rttgram.y"
                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4140 "rttgram.tab.c"
    break;

  case 438: /* simple_check_conj: simple_check_conj And simple_check  */
#line 991 "rttgram.y"
                                        {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4146 "rttgram.tab.c"
    break;

  case 439: /* simple_check: Is ':' i_type_name '(' variable ')'  */
#line 996 "rttgram.y"
      {(yyval.n) = node2(BinryNd, (yyvsp[-5].t), (yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4152 "rttgram.tab.c"
    break;

  case 440: /* simple_check: Cnv ':' dest_type '(' variable ')'  */
#line 998 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-5].t), (yyvsp[-3].n), (yyvsp[-1].n), NULL), dst_alloc((yyvsp[-3].n), (yyvsp[-1].n)); free_t((yyvsp[-4].t));
       free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4159 "rttgram.tab.c"
    break;

  case 441: /* simple_check: Cnv ':' dest_type '(' variable ',' assign_expr ')'  */
#line 1001 "rttgram.y"
      {(yyval.n) = node3(TrnryNd, (yyvsp[-7].t), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-6].t)); free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t));
       free_t((yyvsp[0].t));}
#line 4166 "rttgram.tab.c"
    break;

  case 442: /* simple_check: Def ':' dest_type '(' variable ',' assign_expr ')'  */
#line 1004 "rttgram.y"
      {(yyval.n) = node4(QuadNd, (yyvsp[-7].t), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n), NULL), dst_alloc((yyvsp[-5].n), (yyvsp[-3].n)); free_t((yyvsp[-6].t));
       free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4173 "rttgram.tab.c"
    break;

  case 443: /* simple_check: Def ':' dest_type '(' variable ',' assign_expr ',' assign_expr ')'  */
#line 1007 "rttgram.y"
      {(yyval.n) = node4(QuadNd, (yyvsp[-9].t), (yyvsp[-7].n), (yyvsp[-5].n), (yyvsp[-3].n), (yyvsp[-1].n)), free_t((yyvsp[-8].t)); free_t((yyvsp[-6].t));
       free_t((yyvsp[-4].t)); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4180 "rttgram.tab.c"
    break;

  case 444: /* $@16: %empty  */
#line 1012 "rttgram.y"
            {push_cntxt(1);}
#line 4186 "rttgram.tab.c"
    break;

  case 445: /* detail_code: Body $@16 compound_stmt  */
#line 1013 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); pop_cntxt();}
#line 4192 "rttgram.tab.c"
    break;

  case 446: /* $@17: %empty  */
#line 1014 "rttgram.y"
            {push_cntxt(1);}
#line 4198 "rttgram.tab.c"
    break;

  case 447: /* detail_code: Inline $@17 compound_stmt  */
#line 1015 "rttgram.y"
                        {(yyval.n) = node1(PrefxNd, (yyvsp[-2].t), (yyvsp[0].n)); pop_cntxt();}
#line 4204 "rttgram.tab.c"
    break;

  case 448: /* runerr: Runerr '(' IntConst ')' opt_semi  */
#line 1020 "rttgram.y"
                    {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), node0(PrimryNd, (yyvsp[-2].t)), NULL);
                     free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4211 "rttgram.tab.c"
    break;

  case 449: /* runerr: Runerr '(' IntConst ',' variable ')' opt_semi  */
#line 1023 "rttgram.y"
                    {(yyval.n) = node2(BinryNd, (yyvsp[-6].t), node0(PrimryNd, (yyvsp[-4].t)), (yyvsp[-2].n));
                     free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-1].t));}
#line 4218 "rttgram.tab.c"
    break;

  case 451: /* opt_semi: ';'  */
#line 1029 "rttgram.y"
         {free_t((yyvsp[0].t));}
#line 4224 "rttgram.tab.c"
    break;

  case 452: /* variable: identifier  */
#line 1033 "rttgram.y"
                                 {(yyval.n) = sym_node((yyvsp[0].t));}
#line 4230 "rttgram.tab.c"
    break;

  case 453: /* variable: identifier '[' IntConst ']'  */
#line 1034 "rttgram.y"
                                 {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), sym_node((yyvsp[-3].t)),
                                    node0(PrimryNd, (yyvsp[-1].t)));
                                  free_t((yyvsp[0].t));}
#line 4238 "rttgram.tab.c"
    break;

  case 454: /* dest_type: IconType  */
#line 1039 "rttgram.y"
                             {(yyval.n) = dest_node((yyvsp[0].t));}
#line 4244 "rttgram.tab.c"
    break;

  case 455: /* dest_type: C_Integer  */
#line 1040 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4250 "rttgram.tab.c"
    break;

  case 456: /* dest_type: C_Double  */
#line 1041 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4256 "rttgram.tab.c"
    break;

  case 457: /* dest_type: C_String  */
#line 1042 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4262 "rttgram.tab.c"
    break;

  case 458: /* dest_type: Tmp_string  */
#line 1043 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t)); ++n_tmp_str;}
#line 4268 "rttgram.tab.c"
    break;

  case 459: /* dest_type: Tmp_cset  */
#line 1044 "rttgram.y"
                             {(yyval.n) = node0(PrimryNd, (yyvsp[0].t)); ++n_tmp_cset;}
#line 4274 "rttgram.tab.c"
    break;

  case 460: /* dest_type: '(' Exact ')' IconType  */
#line 1045 "rttgram.y"
                             {(yyval.n) = node0(ExactCnv, chk_exct((yyvsp[0].t))); free_t((yyvsp[-3].t));
                              free_t((yyvsp[-2].t)); free_t((yyvsp[-1].t));}
#line 4281 "rttgram.tab.c"
    break;

  case 461: /* dest_type: '(' Exact ')' C_Integer  */
#line 1047 "rttgram.y"
                             {(yyval.n) = node0(ExactCnv, (yyvsp[0].t)); free_t((yyvsp[-3].t)); free_t((yyvsp[-2].t));
                              free_t((yyvsp[-1].t));}
#line 4288 "rttgram.tab.c"
    break;

  case 462: /* i_type_name: Any_value  */
#line 1052 "rttgram.y"
                {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4294 "rttgram.tab.c"
    break;

  case 463: /* i_type_name: Empty_type  */
#line 1053 "rttgram.y"
                {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4300 "rttgram.tab.c"
    break;

  case 464: /* i_type_name: IconType  */
#line 1054 "rttgram.y"
                {(yyval.n) = sym_node((yyvsp[0].t));}
#line 4306 "rttgram.tab.c"
    break;

  case 465: /* i_type_name: Variable  */
#line 1055 "rttgram.y"
                {(yyval.n) = node0(PrimryNd, (yyvsp[0].t));}
#line 4312 "rttgram.tab.c"
    break;

  case 467: /* ret_val: C_Integer assign_expr  */
#line 1060 "rttgram.y"
                                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4318 "rttgram.tab.c"
    break;

  case 468: /* ret_val: C_Double assign_expr  */
#line 1061 "rttgram.y"
                                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4324 "rttgram.tab.c"
    break;

  case 469: /* ret_val: C_String assign_expr  */
#line 1062 "rttgram.y"
                                       {(yyval.n) = node1(PrefxNd, (yyvsp[-1].t), (yyvsp[0].n));}
#line 4330 "rttgram.tab.c"
    break;

  case 470: /* type_computations: side_effect_lst Return type opt_semi  */
#line 1066 "rttgram.y"
                                          {(yyval.n) = node2(AbstrNd, (yyvsp[-2].t),   (yyvsp[-3].n),   (yyvsp[-1].n));}
#line 4336 "rttgram.tab.c"
    break;

  case 471: /* type_computations: Return type opt_semi  */
#line 1067 "rttgram.y"
                                          {(yyval.n) = node2(AbstrNd, (yyvsp[-2].t),   NULL, (yyvsp[-1].n));}
#line 4342 "rttgram.tab.c"
    break;

  case 472: /* type_computations: side_effect_lst  */
#line 1068 "rttgram.y"
                                          {(yyval.n) = node2(AbstrNd, NULL, (yyvsp[0].n), NULL);}
#line 4348 "rttgram.tab.c"
    break;

  case 474: /* side_effect_lst: side_effect_lst side_effect  */
#line 1073 "rttgram.y"
                                 {(yyval.n) = node2(ConCatNd, NULL, (yyvsp[-1].n), (yyvsp[0].n));}
#line 4354 "rttgram.tab.c"
    break;

  case 475: /* side_effect: Store '[' type ']' '=' type opt_semi  */
#line 1077 "rttgram.y"
                                          {(yyval.n) = node2(BinryNd, (yyvsp[-2].t), (yyvsp[-4].n), (yyvsp[-1].n));
                                           free_t((yyvsp[-6].t)); free_t((yyvsp[-5].t)); free_t((yyvsp[-3].t));}
#line 4361 "rttgram.tab.c"
    break;

  case 477: /* type: type union basic_type  */
#line 1083 "rttgram.y"
                               {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4367 "rttgram.tab.c"
    break;

  case 478: /* type: type Intersect basic_type  */
#line 1084 "rttgram.y"
                               {(yyval.n) = node2(BinryNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4373 "rttgram.tab.c"
    break;

  case 479: /* basic_type: i_type_name  */
#line 1087 "rttgram.y"
                                        {(yyval.n) = node1(IcnTypNd,
                                         copy_t((yyvsp[0].n)->tok), (yyvsp[0].n));}
#line 4380 "rttgram.tab.c"
    break;

  case 480: /* basic_type: Type '(' variable ')'  */
#line 1089 "rttgram.y"
                                        {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4387 "rttgram.tab.c"
    break;

  case 481: /* basic_type: New i_type_name '(' type_lst ')'  */
#line 1091 "rttgram.y"
                                        {(yyval.n) = node2(BinryNd, (yyvsp[-4].t), (yyvsp[-3].n), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4394 "rttgram.tab.c"
    break;

  case 482: /* basic_type: Store '[' type ']'  */
#line 1093 "rttgram.y"
                                        {(yyval.n) = node1(PrefxNd, (yyvsp[-3].t), (yyvsp[-1].n));
                                         free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4401 "rttgram.tab.c"
    break;

  case 483: /* basic_type: basic_type '.' attrb_name  */
#line 1095 "rttgram.y"
                                        {(yyval.n) = node1(PstfxNd, (yyvsp[0].t), (yyvsp[-2].n));
                                         free_t((yyvsp[-1].t));}
#line 4408 "rttgram.tab.c"
    break;

  case 484: /* basic_type: '(' type ')'  */
#line 1097 "rttgram.y"
                                        {(yyval.n) = (yyvsp[-1].n); free_t((yyvsp[-2].t)); free_t((yyvsp[0].t));}
#line 4414 "rttgram.tab.c"
    break;

  case 487: /* type_lst: type_lst ',' type  */
#line 1106 "rttgram.y"
                       {(yyval.n) = node2(CommaNd, (yyvsp[-1].t), (yyvsp[-2].n), (yyvsp[0].n));}
#line 4420 "rttgram.tab.c"
    break;


#line 4424 "rttgram.tab.c"

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

#line 1114 "rttgram.y"


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
