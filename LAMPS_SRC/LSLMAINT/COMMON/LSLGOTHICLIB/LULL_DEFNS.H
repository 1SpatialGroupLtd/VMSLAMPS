/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-04-19 18:23:50.000000000 +0100
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/.
 */
/* $Header: /gothic/RCSroot/dictlib/RCS/hdr.lull_defns.h,v 1.16 1994/02/16 18:58:48 olivia Exp $								*/
/* 									*/
/* $Log: hdr.lull_defns.h,v $
 * Revision 1.16  1994/02/16  18:58:48  olivia
 * Version v1-15 derived from v1-14
 * Develop mechanism for reading a file containing the relationship between
 * lull string variables and their values so that foreign characters can
 * be placed into LULL strings.
 *
 * Revision 1.15  1993/12/16  10:48:41  davidr
 * Version v1-14 derived from v1-13
 * add function 'lull_declare_intrinsic_function' which declares both
 * the intrinsic and its argument list. This eases the task of writing jackets
 * in user-supplied libraries.
 * WICC 202
 *
 * Revision 1.14  1993/11/25  18:54:02  jon
 * Version v1-13 derived from v1-12
 * See Gothic WICC 169.
 *
 * 1) Added `last_right' and `last_left' fields to `_lull_parse_record' structure
 * in `lull_defns.h'.
 *
 * 2) Changed `lull_create_terminal_node()' and `lull_create_node()' routines in
 * `parse_tree_handler.c' to initialise the `last_right' and `last_left' field in
 * the parse node structure to point to the node itself.
 *
 * 3) Changed `lull_add_last_sibling()' in `parse_tree_handler.c' to use and
 * maintain the `last_right' and `last_left' fields.
 *
 * 4) Changed loops constructs in `lull_add_descendant()' in
 * `parse_tree_handler.c' to make them more readable. Modified the routine to
 * maintain the `last_left' and `last_right' fields.
 *
 * 5) Modified `literal_table_handler.c' so that literal table array holds
 * pointers to literal structures rather than the literal structures themselves.
 * This means that reallocing the array does not cause problems because parse
 * tree nodes hold pointers to the literal structures held in the array.
 *
 * Revision 1.13  1993/09/16  15:03:04  stevewi
 * Version v1-12 derived from v1-11
 * See Gothic WICC 126.
 *
 * Modify ICODE interpreter to reset its counts of functions when it
 * encounters an error during execution - e.g. an error returned by
 * a jacket routine.
 * Freeze for BSNC IGIS Analysis integration testing.
 *
 * Revision 1.12  1993/09/10  20:53:13  stevewi
 * Version v1-11 derived from v1-10
 * See Gothic WICC 116.
 *
 * Added new routine `lull_compile_link_text()'. This should be used in place of
 * `lull_compile()'.
 *
 * Added extra `tolerate_errors' argument to `lull_compile_execute_text()'.
 * Freeze for BNSC IGIS Analysis integration testing.
 *
 * Revision 1.11  1993/08/06  15:55:02  davida
 * Version v1-10 derived from v1-9
 * WICC 82
 *
 * lull_stack_call_stack() stacks function names as GOTH__LULLSTACK
 * messages rather than strings. This allows schlib to selectively
 * disable printing of the call stack.
 *
 * Revision 1.10  1993/07/15  09:40:59  davidr
 * Version v1-9 derived from v1-8
 * Extracted to improve trace capabilities.
 * Fixed small memory leak in lull_load_icode_file().
 * Fixed memory leak when attempting to load files and the file is not present.
 * The filename string is now freed in all cases.
 *
 * Revision 1.9  1993/03/10  10:49:21  jon
 * Version v1-8 derived from v1-7
 * Added `include' directive to Lull.
 *
 * Modified routines in `parse_tree_handler.c', `top_level.c', `lull.yacc' and
 * `lull.lex' to record the current source file name and the file name for all
 * the nodes in the parse tree.
 *
 * Added extra routine `lull_compile_file()' and changed
 * `lull_compile_execute_source()' to `lull_compile_execute_file()'. Both these
 * routines no have `tolerate_errors' parameters which allow selection of whether
 * to stop if compilation errors, such as undeclared identifiers, are found.
 *
 * Modified the reporting of the following errors to include information about
 * the source file in which the problem occurred:
 *
 * SOURCEERROR		ASSIGNTYPE
 * DECLSYN			ARITHTYPE
 * STATESYN		NUMTYPE
 * VARDECLSYN		NUMSTRTYPE
 * NOSUCHIDENT		RELTYPE
 * UNRECCHAR		BOOLTYPE
 * VARSUB			MISSUB
 * BADSYMTABTYPE		BADARGLIST
 * LINENO			BADNUMARGS
 * BADCAST
 *
 * Added macro `icode_check_offset()' to `icode_defns.h'. Made use of macro in
 * `icode_path_literals()' to check whether sensible offsets were being
 * requested. Failure to check this could lead to problems if files which did not
 * contain correct icode were loaded and linked.
 *
 * Revision 1.8  1993/02/23  10:22:37  davidr
 * Version v1-7 derived from v1-6
 * Extracted to add routine `lull_get_function_parameter_info()'.
 *
 * Modified `load_source_file_lull()' jacket routine so that it checks the return
 * code of the C routine.
 *
 * Revision 1.7  1993/01/22  16:26:22  olivia
 * Version v1-6 derived from v1-5
 * Extracted to investigate problems with the use of saved icode.
 * Default declarations for link in addition to compile
 * Turn lull reporting off by default
 *
 * Revision 1.6  1992/12/01  11:00:27  olivia
 * Version v1-5 derived from v1-4
 * investigating problems with lex/yacc producing non-portable code
 * Changed makefile to use sparc for precompilers / edit out non-ANSI
 * code.
 *
 * Revision 1.5  1992/10/21  11:57:46  jon
 * Version v1-4 derived from v1-3
 * investigating peculiar problems on HP with 'lull_load_source_file'
 *
 * Modified `make_parser' and `make_analyser' scripts to refer to
 * the new directory structure for holding source code.
 *
 * Revision 1.4  1992/08/19  18:13:22  snail
 * Version v1-3 derived from v1-2
 * Extracted to allow experimentation with simple debugging aids.
 *
 * Added routine `lull_record_call_stack()' to allow call stack information
 * (routine names only) to be recorded in Lull. Added routine
 * `lull_print_call_stack()' to allow the current Lull call stack to be printed.
 *
 * Performed modifications, to ensure function prototypes work even when the
 * function is declared in a different Lull file (icode segment) to the
 * declaration of the prototype, as follows:
 *
 * 1) Modified `lull_function_head()' in icode_generator.c so that function
 * prototypes are flagged as imported symbols in link table for an icode
 * segment.
 *
 * 2) Modified `lull_declare_symbol()' to re-use any existing symbol
 * definition, when a duplicate symbol definition occurs, providing the
 * old and new symbol definitions agree on the kind and type of the
 * symbol. If they disagree, then the new symbol is added in addition to
 * the old one, and a warning message is printed.
 *
 * 3) Modified `lull_declare_parameter_list()' to check that new parameter
 * type lists match any previous parameter type lists. If they do not, a
 * warning is printed, and the new type lists supersede the previous
 * lists.
 *
 * 4) Modified `lull_declare_parametet_list_from_table()' to set parameter
 * arrays to NULL if a function is declared to have no parameters.
 *
 * Modified `lull_type_check_expression()': to report expected and found types
 * when any mismatch is found; to print type errors rather than stacking them; to
 * carry on with remainder of type checking after some errors have been found.
 *
 * Modified `lull_identifier()' in construct_symbol_table.c so that it creates a
 * default declaration for any undeclared identifier found, and then continues
 * with compilation.
 *
 * Modified `lull_update_static_vector()' so that it sets the icode segment parts
 * of the static values to null whenever the static vector is extended.
 *
 * Modified `icode_o_call()' in icode_interpreter.c so that it checks for icode
 * segments which are null before attempting to call Lull functions.
 *
 * Added routine `lull_stack_call_stack()' which behaves the same as
 * `lull_print_call_stack()' except the output is placed on the message stack
 * as a series of strings.
 * Purify memory fix.
 *
 * Revision 1.3  1992/05/17  17:07:25  jon
 * Version v1-2 derived from v1-1
 * Extracted to fix memory leak problems, particularly in the
 * symbol table handler. Fixing these problems may involve converting the
 * symbol table handler to using COLNLIB rather than BINLIB.
 * Converted symbol table handler to use collections rather than binary
 * trees, which fixed the most serious memory leak. This should also have
 * fixed the bug which resulted in duplicate definitions of the same variable
 * inside the same scope causing the Lull compiler to crash.
 *
 * Revision 1.2  1992/03/31  11:35:48  jon
 * Version v1-1 derived from v1-0
 * Fixed stack overflow problem in Icode interpreter which was resulting
 * in severe memory trampling after prolonged run.
 *								*/
#ifndef _LULL_DEFNS
#define _LULL_DEFNS

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Jonathan Billing, 14-Aug-1989				*/
/************************************************************************/

/************************************************************************/
/*									*/
/*			L U L L _ D E F N S . H 			*/
/*									*/
/* Part of GOTHIC module LULL						*/
/* Version 0.1, Jonathan Billing 14-Aug-1989				*/
/* Version 0.1-1, Tony J Ibbs, 15-Jan-1990				*/
/*		  Added a temporary definition of object_id to		*/
/*		   LULL_VALUE.						*/
/*		  Added a value _d_object_id=_d_real to _lull_datatype	*/
/*		+++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*		+ This is a temporary hack, until proper handling of  +	*/
/* 		+ automatically allocated special datatypes can be    + */
/* 		+ implemented. Anyone who assumes that this is a      + */
/* 		+ permanent feature deserves everything that will     + */
/* 		+ happen to them (AND THEY'LL BE WRONG!!).	      + */
/*		+++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Version 1.1 David Radcliffe, 10-May-1990				*/
/* 		Modified to use 'goth_datatypes' definitions		*/
/*									*/
/* Definitions for use in the LULL compiler.				*/
/************************************************************************/



/*----------------------------------------------------------------------*/
/* Definitions of error checking macro used in the LULL compiler	*/
/*----------------------------------------------------------------------*/
/*
#define LULL_CHECK_ERROR(status, extra_text, give_up) \
{ \
   if (status != GOTH__NORMAL) \
   { \
      lull_check_error(status, extra_text); \
      if (give_up) return status; \
   } \
}
*/

/*----------------------------------------------------------------------*/
/* Macros to allocate space for the various structures and dynamic 	*/
/* datatypes declared in this header file				*/
/*----------------------------------------------------------------------*/

#define lull_alloc_parse_node(node) \
{ node = (LULL_PARSE_NODE) malloc(sizeof(LULL_PARSE_RECORD)); (node)->source_name = NULL; if (node == NULL) return GOTH__NOVM; }

#define lull_free_parse_node(node) \
{ goth_free(node->source_name); goth_free(node); }

#define lull_alloc_identifier(ident, size) \
{ ident = (GOTH_STRING) calloc(size, sizeof(char)); if (ident == NULL) return GOTH__NOVM; }

#define lull_extend_identifier(ident, size) \
{ ident = (GOTH_STRING) realloc((char *) ident, (size) * sizeof(char)); if (ident == NULL) return GOTH__NOVM; }

#define lull_free_identifier(ident) \
{ free(ident); }

#define lull_alloc_string(string, size) \
{ string = (GOTH_STRING) calloc(size, sizeof(char)); if (string == NULL) return GOTH__NOVM; }

#define lull_extend_string(string, size) \
{ string = (GOTH_STRING) realloc((char *) string, (size) * sizeof(char)); if (string == NULL) return GOTH__NOVM; }

#define lull_free_string(string) \
{ free(string); }

#define lull_alloc_text(text, size) \
{ text = (GOTH_STRING) calloc(size, sizeof(char)); if (text == NULL) return GOTH__NOVM; }

#define lull_extend_text(text, size) \
{ text = (GOTH_STRING) realloc((char *) text, (size) * sizeof(char)); if (text == NULL) return GOTH__NOVM; }

#define lull_free_text(text) \
{ free(text); }

#define lull_alloc_symbol_table(table) \
{ table = (LULL_SYMBOL_TABLE_ID) malloc(sizeof(LULL_SYMBOL_TABLE_HEADER)); if (table == NULL) return GOTH__NOVM; }

#define lull_free_symbol_table(table) \
{ free(table); }

#define lull_alloc_symbol_entry(symbol) \
{ symbol = (LULL_SYMBOL_ID) malloc(sizeof(LULL_SYMBOL_RECORD)); if (symbol == NULL) return GOTH__NOVM; }

#define lull_free_symbol_entry(symbol) \
{ free(symbol); }

#define lull_alloc_symbol_id_list(list,size) \
{ list = (LULL_SYMBOL_ID *) calloc(size,sizeof(LULL_SYMBOL_ID)); if (list == NULL) return GOTH__NOVM; }

#define lull_extend_symbol_id_list(list,size) \
{ list = (LULL_SYMBOL_ID *) realloc(list,(size)*sizeof(LULL_SYMBOL_ID)); \
  if (list == NULL) return GOTH__NOVM; }

#define lull_free_symbol_id_list(list) \
{ free(list); }

#define lull_alloc_offset_list(list,size) \
{ list = (GOTH_INTEGER *) calloc(size,sizeof(GOTH_INTEGER)); if (list == NULL) return GOTH__NOVM; }

#define lull_extend_offset_list(list,size) \
{ list = (GOTH_INTEGER *) realloc(list,(size)*sizeof(GOTH_INTEGER)); if (list == NULL) return GOTH__NOVM; }

#define lull_free_offset_list(list) \
{ free(list); }


#define lull_alloc_value_vector(vector) \
{ vector = (LULL_VALUE_VECTOR) malloc(sizeof(LULL_VALUE_HEADER)); if (vector == NULL) return GOTH__NOVM; }

#define lull_free_value_vector(vector) \
{ free(vector); }

#define lull_alloc_value_list(list,number) \
{ list = (GOTH_VALUE *) calloc(number, sizeof(GOTH_VALUE)); if (list == NULL) return GOTH__NOVM; }

#define lull_extend_value_list(list,number) \
{ list = (GOTH_VALUE *) realloc(list, (number) * sizeof(GOTH_VALUE)); if (list == NULL) return GOTH__NOVM; }

#define lull_free_value_list(list) \
{ free(list); }

#define lull_alloc_segment_list(list,number) \
{ list = (ICODE_SEGMENT_ID *) calloc(number, sizeof(ICODE_SEGMENT_ID)); if (list == NULL) return GOTH__NOVM; }

#define lull_extend_segment_list(list,number) \
{ list = (ICODE_SEGMENT_ID *) realloc(list, (number) * sizeof(ICODE_SEGMENT_ID)); if (list == NULL) return GOTH__NOVM; }

#define lull_free_segment_list(list) \
{ free(list); }


/*----------------------------------------------------------------------*/
/* Definitions of macros for providing text equivalents of various	*/
/* enumeration elements.						*/
/*----------------------------------------------------------------------*/

#define lull_kind_to_text(kind) \
   (kind == _k_variable 		? "variable" : \
    kind == _k_constant			? "constant" : \
    kind == _k_type		 	? "type" : \
    kind == _k_array		 	? "array" : \
    kind == _k_enumeration_element	? "enumeration element" : \
    kind == _k_function		 	? "function" : \
    kind == _k_intrinsic	 	? "intrinsic" : \
    kind == _k_parameter		? "parameter" : \
    kind == _k_program		 	? "program" : \
    "unknown")

#define lull_table_type_to_text(type) \
   (type == _s_static			? "static table" : \
    type == _s_program			? "program wide table" : \
    type == _s_external			? "external link table" : \
    type == _s_new_frame		? "frame start table" : \
    type == _s_local			? "local table" : \
    "unknown table type")

#define lull_node_type_to_text1(ntype) \
   (ntype == _t_and_expr		? "and expr" : \
    ntype == _t_assignment_statement	? "assignment statement" : \
    ntype == _t_boolean_literal		? "boolean literal" : \
    ntype == _t_boolean_type		? "boolean type" : \
    ntype == _t_compilation_unit	? "compilation unit" : \
    ntype == _t_complex_type		? "complex type" : \
    ntype == _t_compound_statement	? "compound statement" : \
    ntype == _t_declaration		? "declaration" : \
    ntype == _t_divide_expr		? "divide expr" : \
    ntype == _t_do_statement		? "do statement" : \
    ntype == _t_enumeration_type	? "enumeration type" : \
    ntype == _t_equal_expr		? "equal expr" : \
    ntype == _t_function_call		? "function call" : \
    ntype == _t_function_declaration	? "function declaration" : \
    ntype == _t_function_head		? "function head" : \
    ntype == _t_function_prototype	? "function prototype" : \
    ntype == _t_greater_equal_expr	? "greater equal expr" : \
    ntype == _t_greater_than_expr	? "greater than expr" : \
    ntype == _t_identifier		? "identifier" : \
    ntype == _t_if_statement		? "if_statement" : \
    ntype == _t_integer_literal		? "integer literal" : \
    ntype == _t_object_type		? "object type" : \
    ntype == _t_integer_type		? "integer type" : \
    ntype == _t_less_equal_expr		? "less equal expr" : \
    ntype == _t_less_than_expr		? "less than expr" : \
    "unknown parse node type")

#define lull_node_type_to_text2(ntype) \
   (ntype == _t_minus_expr		? "minus expr" : \
    ntype == _t_multiply_expr		? "multiply expr" : \
    ntype == _t_not_equal_expr		? "not equal expr" : \
    ntype == _t_or_expr			? "or expr" : \
    ntype == _t_parameters		? "parameters" : \
    ntype == _t_plus_expr		? "plus expr" : \
    ntype == _t_program_declaration	? "program declaration" : \
    ntype == _t_real_literal		? "real literal" : \
    ntype == _t_real_type		? "real type" : \
    ntype == _t_return_statement	? "return statement" : \
    ntype == _t_routine_call		? "routine call" : \
    ntype == _t_simple_type		? "simple type" : \
    ntype == _t_single_parameter	? "single parameter" : \
    ntype == _t_special_type		? "special type" : \
    ntype == _t_statement		? "statement" : \
    ntype == _t_string_literal		? "string literal" : \
    ntype == _t_string_type		? "string type" : \
    ntype == _t_unary_minus_expr	? "unary minus expr" : \
    ntype == _t_unary_not_expr		? "unary not expr" : \
    ntype == _t_unary_plus_expr		? "unary plus expr" : \
    ntype == _t_variable		? "variable" : \
    ntype == _t_variable_declaration	? "variable declaration" : \
    ntype == _t_void_type		? "void type" : \
    ntype == _t_while_statement		? "while statement" : \
    "unknown parse node type")

#define lull_node_type_to_text(ntype) \
   (ntype <= _t_less_than_expr \
   ? (lull_node_type_to_text1(ntype)) \
   : (lull_node_type_to_text2(ntype)))


/*----------------------------------------------------------------------*/
/* Definitions of types used by the LULL compiler			*/
/* These types are used for:						*/
/*									*/
/* Describing the nodes in the parse tree:				*/
/*									*/
/*	LULL_PARSE_TOKEN	an enumeration				*/
/*	LULL_PARSE_RECORD	a structure				*/
/*	LULL_PARSE_NODE		a pointer to LULL_PARSE_RECORD		*/
/*									*/
/* Describing identifier (symbol) type:					*/
/*									*/
/*	GOTH_STRING		a char * type				*/
/*									*/
/*									*/
/* Describing terminal parse tree nodes (identifiers, literals etc):	*/
/*									*/
/*	LULL_TERMINAL		initially, a union			*/
/*									*/
/* Describing the symbol table:						*/
/*									*/
/*	LULL_SYMBOL_KIND	 an enumeration				*/
/*	LULL_TABLE_TYPE		 an enumeration				*/
/*	LULL_SYMBOL_TABLE_HEADER a structure				*/
/*	LULL_SYMBOL_TABLE_ID	 a pointer to LULL_SYMBOL_TABLE_HEADER	*/
/*	LULL_SYMBOL_RECORD	 a structure				*/
/*	LULL_SYMBOL_ID		 a pointer to LULL_SYMBOL_RECORD	*/
/*									*/
/* Describing the literal table:					*/
/* 									*/
/* 	LULL_LITERAL_TABLE_HEADER a structure				*/
/* 	LULL_LITERAL_TABLE_ID	  a pointer to LULL_LITERAL_TABLE_...	*/
/* 	LULL_LITERAL_RECORD	  a structure				*/
/* 	LULL_LITERAL_ID		  a pointer to LULL_LITERAL_RECORD	*/
/*									*/
/* Describing values and symbol value vectors:				*/
/* 									*/
/* 	LULL_VALUE_HEADER	a record				*/
/* 	LULL_VALUE_VECTOR	a pointer to LULL_VALUE_HEADER		*/
/*	LULL_VECTOR_SIZE	default vector size and size increment	*/
/*									*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* Definition of tokens for identifying the nodes of a parse tree.	*/
/*----------------------------------------------------------------------*/

enum _lull_parse_token_enum
{ 
   _t_and_expr,
   _t_assignment_statement,
   _t_boolean_literal,
   _t_boolean_type,
   _t_compilation_unit,
   _t_complex_type,
   _t_compound_statement,
   _t_declaration,
   _t_divide_expr,
   _t_do_statement,
   _t_enumeration_type,
   _t_equal_expr,
   _t_function_call,
   _t_function_declaration,
   _t_function_head,
   _t_function_prototype,
   _t_greater_equal_expr,
   _t_greater_than_expr,
   _t_identifier,
   _t_if_statement,
   _t_integer_literal,
   _t_object_type,
   _t_integer_type,
   _t_less_equal_expr,
   _t_less_than_expr,
   _t_minus_expr,
   _t_multiply_expr,
   _t_not_equal_expr,
   _t_or_expr,
   _t_parameters,
   _t_plus_expr,
   _t_program_declaration,
   _t_real_literal,
   _t_real_type,
   _t_return_statement,
   _t_routine_call,
   _t_simple_type,
   _t_single_parameter,
   _t_special_type,
   _t_statement,
   _t_string_literal,
   _t_string_type,
   _t_unary_minus_expr,
   _t_unary_not_expr,
   _t_unary_plus_expr,
   _t_variable,
   _t_variable_declaration,
   _t_void_type,
   _t_while_statement
};



/*----------------------------------------------------------------------*/
/* Definition of enumeration to indicate the datatypes available within	*/
/* LULL.								*/
/*									*/
/* This is used in the symbol table and in type checking operations.	*/
/*									*/
/* The ordering of the elements in this enumeration is significant. For	*/
/* example, when type casts are being performed between the numeric	*/
/* datatypes in expressions, the cast is made to the datatype later in	*/
/* the enumeration:							*/
/* 									*/
/* 			_d_real > _d_integer				*/
/*----------------------------------------------------------------------*/



/*----------------------------------------------------------------------*/
/* Definition of enumeration to indicate the kinds of symbol which can	*/
/* be defined in the symbol table.					*/
/*----------------------------------------------------------------------*/


enum _lull_symbol_kind
{
   _k_variable,
   _k_constant,
   _k_type,
   _k_array,
   _k_enumeration_element,
   _k_function,
   _k_intrinsic,
   _k_parameter,
   _k_program
};


/*----------------------------------------------------------------------*/
/* Definition of an enumeration to indicate the types of symbol tables	*/
/*----------------------------------------------------------------------*/

enum _lull_table_type
{
   _s_static,		/* Static (global) symbol table */
   _s_program,		/* Program wide symbol table */
   _s_external,		/* Compilation unit external symbol table */
   _s_new_frame,	/* Symbol table contents will start new stack frame */
   _s_local		/* Local symbol table (not start of frame) */
};

typedef enum _lull_parse_token_enum	LULL_PARSE_TOKEN;
typedef struct _lull_parse_record	LULL_PARSE_RECORD;
typedef struct _lull_parse_record	*LULL_PARSE_NODE;

/* typedef char 				*GOTH_STRING; */

typedef union _lull_terminal		LULL_TERMINAL;

typedef enum _lull_symbol_kind		LULL_SYMBOL_KIND;

typedef enum _lull_table_type		LULL_TABLE_TYPE;

typedef struct _lull_symbol_table_header LULL_SYMBOL_TABLE_HEADER;
typedef struct _lull_symbol_table_header *LULL_SYMBOL_TABLE_ID;

typedef struct _lull_symbol_record	LULL_SYMBOL_RECORD;
typedef struct _lull_symbol_record	*LULL_SYMBOL_ID;

typedef struct _lull_literal_table_header LULL_LITERAL_TABLE_HEADER;
typedef struct _lull_literal_table_header *LULL_LITERAL_TABLE_ID;
typedef struct _lull_literal_record	  LULL_LITERAL_RECORD;
typedef struct _lull_literal_record	  *LULL_LITERAL_ID;

typedef struct _lull_value_header	LULL_VALUE_HEADER;
typedef struct _lull_value_header	*LULL_VALUE_VECTOR;


/*----------------------------------------------------------------------*/
/* Definitions of sizes, or initial sizes of various vectors, icode	*/
/* records, etc								*/
/*----------------------------------------------------------------------*/

/* Initial value vector size */

#define LULL_VECTOR_SIZE 100

/* Initial symbol table size */

#define LULL_SYMBOL_TABLE_SIZE 30

/* Initial literal table size */
/* NOTE - the literal table needs redesigning, since any attempt to extend */
/* it dynamically to hold more than 8000 will almost certainly lead to a */
/* bug */

#define LULL_LITERAL_TABLE_SIZE 8000

#define LULL_LITERAL_HEAP_SIZE 1000



/*----------------------------------------------------------------------*/
/* Definition for union to hold the values associated with terminal	*/
/* nodes in the parse tree.						*/
/* 									*/
/* Initially, this will hold the literals, identifiers etc exactly	*/
/* as they are returned from the lexical analyser and parser.		*/
/*									*/
/* Eventually, this system will be modified with appropriate use of 	*/
/* tables to hold such values and names, with integer identifiers being	*/
/* held in the parse tree.						*/
/*----------------------------------------------------------------------*/

union _lull_terminal
{
   GOTH_STRING		string;
   GOTH_INTEGER		integer;
   GOTH_REAL		real;
   GOTH_STRING	identifier;
   GOTH_BOOLEAN		boolean;
};


/*----------------------------------------------------------------------*/
/* Structure for the parse tree nodes.					*/
/*									*/
/* Eventually this structure will have to be compressed, by removing	*/
/* unecessary fields and by combining fields which can never be present	*/
/* together into one or more unions.					*/
/* 									*/
/* For example, "literal", "symbol", "table" and the "type<n>" fields 	*/
/* are mutually exclusive.						*/
/*----------------------------------------------------------------------*/

struct _lull_parse_record
{
   LULL_PARSE_TOKEN	type;		/* type of parse tree node */
   GOTH_INTEGER		line_num;	/* corresponding source line number */
   GOTH_STRING		source_name;	/* source file (or other) name */
   LULL_TERMINAL	terminal;	/* value of terminal, if this is one */
   LULL_SYMBOL_TABLE_ID	table;		/* associated symbol table */
   LULL_SYMBOL_ID	symbol;		/* associated symbol table entry */
   LULL_LITERAL_ID	literal;	/* associated literal table entry */
   GOTH_DATATYPE	datatype;	/* datatype of operand */
   GOTH_DATATYPE	lh_datatype;	/* type of lhs operand (expressions) */
   GOTH_DATATYPE	rh_datatype;	/* type of rhs operand (expressions) */
   LULL_PARSE_NODE	last_right;	/* last right hand sibling node */
   LULL_PARSE_NODE	last_left;	/* last left hand sibling node */
   LULL_PARSE_NODE	right;		/* right hand sibling node */
   LULL_PARSE_NODE	left;		/* left hand sibling node */
   LULL_PARSE_NODE	first;		/* first descendant node */
   LULL_PARSE_NODE	last;		/* last descendant node */
   LULL_PARSE_NODE	parent;		/* parent node */
};



/*----------------------------------------------------------------------*/
/* Structure for symbol table header records				*/
/*----------------------------------------------------------------------*/

struct _lull_symbol_table_header
{
   LULL_TABLE_TYPE	type;		/* Type of table */
   GOTH_INTEGER		next_offset;	/* Next identifier offset in frame */
   LULL_SYMBOL_TABLE_ID	parent;		/* parent scope */
   LULL_SYMBOL_TABLE_ID	first;		/* first descendant table */
   LULL_SYMBOL_TABLE_ID	last;		/* last descendant table */
   LULL_SYMBOL_TABLE_ID	left;		/* left sibling table */
   LULL_SYMBOL_TABLE_ID	right;		/* right sibling table */
   GOTH_INTEGER		vector_size;	/* Size of offset indexed vector */
   LULL_SYMBOL_ID	*offset_vector;	/* symbols indexed by their offsets */
   LULL_PARSE_NODE	parse_tree;	/* associated tree node */
   GD_COLLECTION	symbol_dict_id;	/* Maps identifiers to offsets */
};



/*----------------------------------------------------------------------*/
/* Structure for symbol table entry					*/
/*----------------------------------------------------------------------*/

struct _lull_symbol_record
{
   GOTH_INTEGER		offset;		/* candidate symbol offset in frame */
   LULL_SYMBOL_KIND	kind;		/* kind of symbol */
   GOTH_DATATYPE	type;		/* datatype of symbol */
   GOTH_STRING		special;	/* name of any special datatype */
   GOTH_STRING		identifier;	/* name of identifier */
   LULL_SYMBOL_TABLE_ID	parent;		/* parent symbol table */

   GOTH_BOOLEAN		params_declared;/* True if parameters declared */
   GOTH_INTEGER		num_params;	/* Number of parameters */
   GOTH_DATATYPE		*params_simple_type;
   GOTH_DESCRIPTOR_DATATYPE	*params_desc_type;
};



/*----------------------------------------------------------------------*/
/* Structure for holding the literal table header information.		*/
/*									*/
/* The "heap" is used for storing the values of the only 		*/
/* variable length literals - strings. This heap will later be copied	*/
/* into the icode generated as output.					*/
/*----------------------------------------------------------------------*/

struct _lull_literal_table_header
{
   GOTH_INTEGER		num_entries;	/* No. entries in table */
   GOTH_INTEGER		max_entries;	/* Max. entries before extend */
   LULL_LITERAL_ID	*list;		/* Vector of pointers to literal entries */
   GOTH_INTEGER		heap_offset;	/* Next offset in string heap */
   GOTH_INTEGER		heap_size;	/* Current string heap size */
   ICODE_WORD		*heap;		/* Pointer to string heap */
};
   

/*----------------------------------------------------------------------*/
/* Structure for holding a literal record.				*/
/*									*/
/* For string literals, the value may be a pointer into the string_heap	*/
/* attached to the literal table header.				*/
/*----------------------------------------------------------------------*/

struct _lull_literal_record
{
   LULL_LITERAL_TABLE_ID	parent;	/* Literal table containing entry */
   GOTH_INTEGER			offset;	/* Literal offset in table */
   GOTH_DATATYPE		type;	/* Datatype of literal */
   GOTH_VALUE			value;	/* Value of literal */
};



/*----------------------------------------------------------------------*/
/* Structure for holding symbol value vector header information.	*/
/*----------------------------------------------------------------------*/

struct _lull_value_header
{
   GOTH_INTEGER		max_entries;	 /* Maximum number of entries */
   GOTH_INTEGER		num_entries;	 /* Current number of entries */
   GOTH_MEM_DESCRIPTOR	descriptor_list; /* List of descriptors */
   GOTH_VALUE		*value;		 /* List of values */
   ICODE_SEGMENT_ID	*segment;	 /* List of segments in which */
					 /* symbols are defined */   
};


#include "lull_environ.h"

#endif
