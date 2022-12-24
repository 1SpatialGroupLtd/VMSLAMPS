/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-04-19 18:23:52.000000000 +0100
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
/* $Header: /gothic/RCSroot/dictlib/RCS/hdr.icode_defns.h,v 1.16 1994/02/16 18:58:45 olivia Exp $								*/
/* 									*/
/* $Log: hdr.icode_defns.h,v $
 * Revision 1.16  1994/02/16  18:58:45  olivia
 * Version v1-15 derived from v1-14
 * Develop mechanism for reading a file containing the relationship between
 * lull string variables and their values so that foreign characters can
 * be placed into LULL strings.
 *
 * Revision 1.15  1993/12/16  10:48:38  davidr
 * Version v1-14 derived from v1-13
 * add function 'lull_declare_intrinsic_function' which declares both
 * the intrinsic and its argument list. This eases the task of writing jackets
 * in user-supplied libraries.
 * WICC 202
 *
 * Revision 1.14  1993/11/25  18:53:54  jon
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
 * Revision 1.13  1993/09/16  15:02:56  stevewi
 * Version v1-12 derived from v1-11
 * See Gothic WICC 126.
 *
 * Modify ICODE interpreter to reset its counts of functions when it
 * encounters an error during execution - e.g. an error returned by
 * a jacket routine.
 * Freeze for BSNC IGIS Analysis integration testing.
 *
 * Revision 1.12  1993/09/10  20:52:59  stevewi
 * Version v1-11 derived from v1-10
 * See Gothic WICC 116.
 *
 * Added new routine `lull_compile_link_text()'. This should be used in place of
 * `lull_compile()'.
 *
 * Added extra `tolerate_errors' argument to `lull_compile_execute_text()'.
 * Freeze for BNSC IGIS Analysis integration testing.
 *
 * Revision 1.11  1993/08/06  15:54:57  davida
 * Version v1-10 derived from v1-9
 * WICC 82
 *
 * lull_stack_call_stack() stacks function names as GOTH__LULLSTACK
 * messages rather than strings. This allows schlib to selectively
 * disable printing of the call stack.
 *
 * Revision 1.10  1993/07/15  09:40:55  davidr
 * Version v1-9 derived from v1-8
 * Extracted to improve trace capabilities.
 * Fixed small memory leak in lull_load_icode_file().
 * Fixed memory leak when attempting to load files and the file is not present.
 * The filename string is now freed in all cases.
 *
 * Revision 1.9  1993/03/10  10:49:14  jon
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
 * Revision 1.8  1993/02/23  10:22:34  davidr
 * Version v1-7 derived from v1-6
 * Extracted to add routine `lull_get_function_parameter_info()'.
 *
 * Modified `load_source_file_lull()' jacket routine so that it checks the return
 * code of the C routine.
 *
 * Revision 1.7  1993/01/22  16:26:16  olivia
 * Version v1-6 derived from v1-5
 * Extracted to investigate problems with the use of saved icode.
 * Default declarations for link in addition to compile
 * Turn lull reporting off by default
 *
 * Revision 1.6  1992/12/01  11:00:23  olivia
 * Version v1-5 derived from v1-4
 * investigating problems with lex/yacc producing non-portable code
 * Changed makefile to use sparc for precompilers / edit out non-ANSI
 * code.
 *
 * Revision 1.5  1992/10/21  11:57:37  jon
 * Version v1-4 derived from v1-3
 * investigating peculiar problems on HP with 'lull_load_source_file'
 *
 * Modified `make_parser' and `make_analyser' scripts to refer to
 * the new directory structure for holding source code.
 *
 * Revision 1.4  1992/08/19  18:13:16  snail
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
 * Revision 1.3  1992/05/17  17:07:21  jon
 * Version v1-2 derived from v1-1
 * Extracted to fix memory leak problems, particularly in the
 * symbol table handler. Fixing these problems may involve converting the
 * symbol table handler to using COLNLIB rather than BINLIB.
 * Converted symbol table handler to use collections rather than binary
 * trees, which fixed the most serious memory leak. This should also have
 * fixed the bug which resulted in duplicate definitions of the same variable
 * inside the same scope causing the Lull compiler to crash.
 *
 * Revision 1.2  1992/03/31  11:35:43  jon
 * Version v1-1 derived from v1-0
 * Fixed stack overflow problem in Icode interpreter which was resulting
 * in severe memory trampling after prolonged run.
 *								*/
#ifndef _ICODE_DEFNS
#define _ICODE_DEFNS
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Jonathan Billing,  3-Oct-1989				*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		       I C O D E _ D E F N S . H 			*/
/*									*/
/* Part of GOTHIC module LULL						*/
/* Version 0.1, Jonathan Billing  3-Oct-1989				*/
/*									*/
/* Definition for icode, as used by the Gothic product user language	*/
/* compiler(s)								*/
/************************************************************************/



/*----------------------------------------------------------------------*/
/* Macros for allocating and freeing space to do with icode		*/
/*----------------------------------------------------------------------*/

#define icode_alloc_header(segment) \
{ segment = (ICODE_SEGMENT_ID) malloc(sizeof(ICODE_SEGMENT_HEADER)); \
  if (segment == NULL) return GOTH__NOVM; }

#define icode_free_header(segment) \
{ free(segment); }

#define icode_alloc_vector(vector,number) \
{ vector = (ICODE_WORD *) calloc(number, sizeof(ICODE_WORD)); \
  if (vector == NULL) return GOTH__NOVM; }

#define icode_extend_vector(vector, number) \
{ vector = (ICODE_WORD *) realloc(vector, (number) * sizeof(ICODE_WORD)); \
  if (vector == NULL) return GOTH__NOVM; }

#define icode_free_vector(vector) \
{ free(vector); }

#define icode_alloc_descriptor(descrip) \
{ descrip = (GOTH_MEM_DESCRIPTOR) malloc(GOTH_MEM_DESCRIPTOR_SIZE); \
  if (descrip == NULL) return GOTH__NOVM; }

#define icode_free_descriptor(descrip) \
{ free(descrip); }

#define icode_alloc_memory(mem,num_element,size_element) \
{ mem = (GOTH_SPECIAL) calloc(num_element,size_element); \
  if (mem == NULL) return GOTH__NOVM; }

#define icode_extend_memory(mem,num_element,size_element) \
{ mem = (GOTH_SPECIAL) realloc((char *) mem, \
				(num_element)*(size_element)); \
  if (mem == NULL) return GOTH__NOVM; }

#define icode_free_memory(mem) \
{ cfree((char *) mem); }


/*----------------------------------------------------------------------*/
/* Definition of initial size of an icode segment			*/
/*----------------------------------------------------------------------*/

#define ICODE_SEGMENT_SIZE 1000


/*----------------------------------------------------------------------*/
/* Definitions of macros for converting icode operators and address	*/
/* modes into text							*/
/*----------------------------------------------------------------------*/


#define icode_misc_op_to_text(oper) \
   oper == _o_null			? "_o_null" : \
   oper == _o_error			? "_o_error" : \
   oper == _o_stop			? "_o_stop" : \
   "unknown operator"
   
#define icode_arith_op_to_text(oper) \
   oper == _o_add_integer 		? "_o_add_integer" : \
   oper == _o_add_real 			? "_o_add_real" : \
   oper == _o_add_string 		? "_o_add_string" : \
   oper == _o_sub_integer 		? "_o_sub_integer" : \
   oper == _o_sub_real 			? "_o_sub_real" : \
   oper == _o_mul_integer 		? "_o_mul_integer" : \
   oper == _o_mul_real 			? "_o_mul_real" : \
   oper == _o_div_integer 		? "_o_div_integer" : \
   oper == _o_div_real 			? "_o_div_real" : \
   oper == _o_negate_integer 		? "_o_negate_integer" : \
   oper == _o_negate_real 		? "_o_negate_real" : \
   "unknown operator"

#define icode_exact_rel_op_to_text(oper) \
   oper == _o_equal_integer 		? "_o_equal_integer" : \
   oper == _o_equal_real 		? "_o_equal_real" : \
   oper == _o_equal_boolean 		? "_o_equal_boolean" : \
   oper == _o_equal_string 		? "_o_equal_string" : \
   oper == _o_not_equal_integer 	? "_o_not_equal_integer" : \
   oper == _o_not_equal_real 		? "_o_not_equal_real" : \
   oper == _o_not_equal_boolean 	? "_o_not_equal_boolean" : \
   oper == _o_not_equal_string 		? "_o_not_equal_string" : \
   "unknown operator"

#define icode_inexact_rel_op_to_text(oper) \
   oper == _o_less_than_integer 	? "_o_less_than_integer" : \
   oper == _o_less_than_real 		? "_o_less_than_real" : \
   oper == _o_less_than_boolean 	? "_o_less_than_boolean" : \
   oper == _o_less_than_string 		? "_o_less_than_string" : \
   oper == _o_less_equal_integer 	? "_o_less_equal_integer" : \
   oper == _o_less_equal_real 		? "_o_less_equal_real" : \
   oper == _o_less_equal_boolean 	? "_o_less_equal_boolean" : \
   oper == _o_less_equal_string 	? "_o_less_equal_string" : \
   oper == _o_greater_than_integer 	? "_o_greater_than_integer" : \
   oper == _o_greater_than_real 	? "_o_greater_than_real" : \
   oper == _o_greater_than_boolean 	? "_o_greater_than_boolean" : \
   oper == _o_greater_than_string 	? "_o_greater_than_string" : \
   oper == _o_greater_equal_integer 	? "_o_greater_equal_integer" : \
   oper == _o_greater_equal_real 	? "_o_greater_equal_real" : \
   oper == _o_greater_equal_boolean 	? "_o_greater_equal_boolean" : \
   oper == _o_greater_equal_string 	? "_o_greater_equal_string" : \
   "unknown operator"

#define icode_log_op_to_text(oper) \
   oper == _o_and 			? "_o_and" : \
   oper == _o_or 			? "_o_or" : \
   oper == _o_not 			? "_o_not" : \
   "unknown operator"

#define icode_cast_op_to_text(oper) \
   oper == _o_cast_integer_to_real 	? "_o_cast_integer_to_real" : \
   oper == _o_cast_real_to_integer 	? "_o_cast_real_to_integer" : \
   "unknown operator"

#define icode_branch_op_to_text(oper) \
   oper == _o_jump 			? "_o_jump" : \
   oper == _o_jump_true 		? "_o_jump_true" : \
   oper == _o_jump_false 		? "_o_jump_false" : \
   oper == _o_call 			? "_o_call" : \
   oper == _o_return			? "_o_return" : \
   "unknown operator"

#define icode_stack_op_to_text(oper) \
   oper == _o_generate_pointer		? "_o_generate_pointer" : \
   oper == _o_push 			? "_o_push" : \
   oper == _o_pop 			? "_o_pop" : \
   oper == _o_push_string		? "_o_push_string" : \
   oper == _o_pop_string 		? "_o_pop_string" : \
   oper == _o_extend_stack 		? "_o_extend_stack" : \
   oper == _o_shrink_stack		? "_o_shrink_stack" : \
   "unknown operator"

#define icode_alloc_op_to_text(oper) \
   oper == _o_alloc_string		? "_o_alloc_string" : \
   oper == _o_alloc_array		? "_o_alloc_array" : \
   oper == _o_alloc_string_array	? "_o_alloc_string_array" : \
   "unknown operator"

#define icode_operator_to_text(oper) \
   ((oper <= _o_stop)			? icode_misc_op_to_text(oper) : \
    (oper <= _o_negate_real)	 	? icode_arith_op_to_text(oper) : \
    (oper <= _o_not_equal_string)       ? icode_exact_rel_op_to_text(oper) : \
    (oper <= _o_greater_equal_string)	? icode_inexact_rel_op_to_text(oper) : \
    (oper <= _o_not) 			? icode_log_op_to_text(oper) : \
    (oper <= _o_cast_real_to_integer)	? icode_cast_op_to_text(oper) : \
    (oper <= _o_return)			? icode_branch_op_to_text(oper) : \
    (oper <= _o_shrink_stack)		? icode_stack_op_to_text(oper) : \
    icode_alloc_op_to_text(oper))

#define icode_address_mode_to_text(amode) \
   amode == _a_null			? "_a_null" : \
   amode == _a_dummy			? "_a_dummy" : \
   amode == _a_abs_value		? "_a_abs_value" : \
   amode == _a_rel_segment_base		? "_a_rel_segment_base" : \
   amode == _a_rel_static_base		? "_a_rel_static_base" : \
   amode == _a_rel_frame_base		? "_a_rel_frame_base" : \
   amode == _a_rel_stk_address		? "_a_rel_stk_address" : \
   amode == _a_abs_offset		? "_a_abs_offset" : \
   amode == _a_stk_offset		? "_a_stk_offset" : \
   "unknown addressing mode"



/*----------------------------------------------------------------------*/
/* Declarations of macros determining layout of entries in icode	*/
/* segment.								*/
/*									*/
/* The icode segments are laid out as follows:				*/
/*									*/
/* Header record:							*/
/* 									*/
/* GOTH_INTEGER		offset to start of exectutable code		*/
/* 									*/
/* GOTH_INTEGER		offset to start of external link indirection	*/
/* 			vector						*/
/* 									*/
/* GOTH_INTEGER		number of entries in external link vector	*/
/* 									*/
/* GOTH_INTEGER		offset to start of program symbol vector	*/
/* 									*/
/* GOTH_INTEGER		number of entries in program symbol vector	*/
/* 									*/
/* GOTH_INTEGER		offset to start of literal vector		*/
/* 									*/
/* GOTH_INTEGER		number of entries in literal vector		*/
/* 									*/
/* GOTH_INTEGER		offset to start of literal heap			*/
/* 									*/
/* GOTH_INTEGER	        size of literal heap				*/
/* 									*/
/* External link indirection vector:					*/
/* 									*/
/* As many entries as required, each of size				*/
/* icode_sizeof(ICODE_WORD) * ICODE_EXT_RECORD_SIZE			*/
/*									*/
/* ICODE_WORD * n	symbol identifier (NULL terminated)		*/
/* 									*/
/* GOTH_INTEGER		symbol kind (cast from LULL_SYMBOL_KIND)	*/
/* 									*/
/* GOTH_INTEGER		symbol datatype (cast from LULL_DATATYPE)	*/
/* 									*/
/* GOTH_INTEGER		slot for execution address at runtime		*/
/*									*/
/* 									*/
/* Program wide symbol vector:						*/
/* 									*/
/* GOTH_VALUE		as many slots as needed				*/
/* 									*/
/* Literal vector:							*/
/* 									*/
/* GOTH_VALUE		as many slots as needed				*/
/* 									*/
/* Literal heap:							*/
/* 									*/
/* ICODE_WORD		as many slots as needed				*/
/* 									*/
/* Executable code:							*/
/* 									*/
/* ICODE_WORD		as many words as needed				*/
/*----------------------------------------------------------------------*/

/* Offsets for the entries in the icode header record */

#define ICODE_HDR_CODE_START 	(0 * icode_sizeof(GOTH_INTEGER))

#define ICODE_HDR_EXT_START	(1 * icode_sizeof(GOTH_INTEGER))
#define ICODE_HDR_EXT_SIZE	(2 * icode_sizeof(GOTH_INTEGER))

#define ICODE_HDR_PROG_START	(3 * icode_sizeof(GOTH_INTEGER))
#define ICODE_HDR_PROG_SIZE	(4 * icode_sizeof(GOTH_INTEGER))

#define ICODE_HDR_LIT_START	(5 * icode_sizeof(GOTH_INTEGER))
#define ICODE_HDR_LIT_SIZE	(6 * icode_sizeof(GOTH_INTEGER))

#define ICODE_HDR_HEAP_START	(7 * icode_sizeof(GOTH_INTEGER))
#define ICODE_HDR_HEAP_SIZE		(8 * icode_sizeof(GOTH_INTEGER))

#define ICODE_HDR_SIZE 			(9 * icode_sizeof(GOTH_INTEGER))

/* Size of each icode external link indirection record, and field, in 	*/
/* icode "words" - ie bytes, and the offset of each field within the 	*/
/* record.								*/
/*									*/
/* The fields in the link record are:					*/
/* 									*/
/* 		External symbol identifier				*/
/* 		Import/Export flag (TRUE if imported)			*/
/* 		Symbol kind						*/
/* 		Symbol type						*/
/*		Exported offset (in current segment)			*/
/* 		Offset in static vector					*/
/*		Number of arguments (for functions) (-ve if undeclared)	*/
/*									*/

#define ICODE_EXT_IDENT_SIZE 		(50 * icode_sizeof(ICODE_WORD))

#define ICODE_EXT_FLAG_SIZE		icode_sizeof(ICODE_WORD)

#define ICODE_EXT_KIND_SIZE		icode_sizeof(GOTH_INTEGER)

#define ICODE_EXT_TYPE_SIZE		icode_sizeof(GOTH_INTEGER)

#define ICODE_EXT_EXPORT_SIZE		icode_sizeof(GOTH_INTEGER)

#define ICODE_EXT_OFFSET_SIZE		icode_sizeof(GOTH_INTEGER)

#define ICODE_EXT_NUM_PARAMS_SIZE	icode_sizeof(GOTH_INTEGER)

#define ICODE_EXT_RECORD_SIZE \
					(ICODE_EXT_IDENT_SIZE + \
					 ICODE_EXT_FLAG_SIZE + \
					 ICODE_EXT_KIND_SIZE + \
					 ICODE_EXT_TYPE_SIZE + \
					 ICODE_EXT_EXPORT_SIZE + \
					 ICODE_EXT_OFFSET_SIZE + \
					 ICODE_EXT_NUM_PARAMS_SIZE)

#define ICODE_EXT_IDENT_OFFSET	0

#define ICODE_EXT_FLAG_OFFSET \
	(ICODE_EXT_IDENT_OFFSET + ICODE_EXT_IDENT_SIZE)

#define ICODE_EXT_KIND_OFFSET \
	(ICODE_EXT_FLAG_OFFSET + ICODE_EXT_FLAG_SIZE)

#define ICODE_EXT_TYPE_OFFSET \
	(ICODE_EXT_KIND_OFFSET + ICODE_EXT_KIND_SIZE)

#define ICODE_EXT_EXPORT_OFFSET \
	(ICODE_EXT_TYPE_OFFSET + ICODE_EXT_TYPE_SIZE)

#define ICODE_EXT_OFFSET_OFFSET \
	(ICODE_EXT_EXPORT_OFFSET + ICODE_EXT_EXPORT_SIZE)

#define ICODE_EXT_NUM_PARAMS_OFFSET \
	(ICODE_EXT_OFFSET_OFFSET + ICODE_EXT_OFFSET_SIZE)

/* Size of record in the program wide vector */

#define ICODE_PROG_RECORD_SIZE icode_sizeof(GOTH_VALUE)

/* Format of record in literal vector 					*/
/* 									*/
/* These consist of :							*/
/* 									*/
/* 		runtime value slot					*/
/* 		permanent value slot (to hold values when saved)	*/
/* 		datatype 						*/

#define ICODE_LIT_VALUE_SIZE	icode_sizeof(GOTH_VALUE)
#define ICODE_LIT_PERM_SIZE	icode_sizeof(GOTH_VALUE)
#define ICODE_LIT_TYPE_SIZE	icode_sizeof(GOTH_INTEGER)

#define ICODE_LIT_RECORD_SIZE \
	(ICODE_LIT_VALUE_SIZE + ICODE_LIT_TYPE_SIZE + ICODE_LIT_PERM_SIZE)

#define ICODE_LIT_VALUE_OFFSET	0

#define ICODE_LIT_PERM_OFFSET \
	(ICODE_LIT_VALUE_OFFSET + ICODE_LIT_VALUE_SIZE)

#define ICODE_LIT_TYPE_OFFSET \
	(ICODE_LIT_PERM_OFFSET + ICODE_LIT_PERM_SIZE)


/* Size, in terms of stack entries, of the header at the start of each	*/
/* new stack frame.							*/
/* This header will contain such things as the return address, the	*/
/* pointer to the previous frame, and other machine status information.	*/
/*									*/
/* The following information is stored in the stack frame :		*/
/* 									*/
/* 		return value						*/
/* 		previous frame base pointer				*/
/* 		previous stack top pointer				*/
/* 		return address						*/
/* 		parameters						*/
/* 		local variables						*/
/* 		temporaries						*/
/* 									*/
/* The first four items comprise the stack frame header.		*/

#define ICODE_FRAME_RET_VAL_OFFSET 0
#define ICODE_FRAME_PREV_BASE_OFFSET 1
#define ICODE_FRAME_PREV_TOP_OFFSET 2
#define ICODE_FRAME_RET_ADDR_OFFSET 3
#define ICODE_FRAME_DYNAMIC_OFFSET 4
#define ICODE_FRAME_PREV_SEG_OFFSET 5

#define ICODE_FRAME_HDR_SIZE 6


/*----------------------------------------------------------------------*/
/* Macros for manipulating and examining icode and related items	*/
/*----------------------------------------------------------------------*/

#define icode_sizeof(type)		sizeof(type)

#define icode_get_segment_base(icode_segment) \
   (icode_segment->vector)

#define icode_check_offset(segment,offset) \
{ \
   if ((segment)->num_entries < (offset)) \
   { \
      SCH_STACK_STRING("Attempt to access icode offset outside segment."); \
      SCH_STACK_STRING("Icode segment may be corrupt."); \
      SCH_RETURN(GOTH__ERROR); \
   } \
}

/* Use of memcpy for "icode_get_value", to copy from the icode segment	*/
/* to a dummy variable, before casting the value to the required type,	*/
/* ensures that the data will be properly aligned in memory on RISC	*/
/* machines.								*/
/* This is messy and inefficient, and should be re-examined if and when	*/
/* the iciode instruction set is redesigned.				*/

double icode_memcpy_dummy[20];

#define icode_get_value(value_type,segment,offset) \
   (memcpy((char *) icode_memcpy_dummy, \
	   (char *) &(segment->vector[offset]), \
	   sizeof(value_type)), \
    *((value_type *) icode_memcpy_dummy))

/* *((value_type *) &(segment->vector[offset]))) */


#define icode_get_value_ptr(ptr_type,segment,offset) \
   ((ptr_type) &(segment->vector[offset]))

#define icode_get_code_start(segment) \
   icode_get_value(GOTH_INTEGER,segment,ICODE_HDR_CODE_START)

#define icode_get_external_start(segment) \
   icode_get_value(GOTH_INTEGER,segment,ICODE_HDR_EXT_START)

#define icode_get_external_size(segment) \
   icode_get_value(GOTH_INTEGER,segment,ICODE_HDR_EXT_SIZE)

#define icode_get_external_offset(segment,index) \
   (icode_get_external_start(segment) + \
    index * ICODE_EXT_RECORD_SIZE)

#define icode_get_program_start(segment) \
   icode_get_value(GOTH_INTEGER,segment,ICODE_HDR_PROG_START)
   
#define icode_get_program_size(segment) \
   icode_get_value(GOTH_INTEGER,segment,ICODE_HDR_PROG_SIZE)
   
#define icode_get_program_offset(segment,index) \
   (icode_get_program_start(segment) + \
    index * ICODE_PROG_RECORD_SIZE)

#define icode_get_literal_start(segment) \
   icode_get_value(GOTH_INTEGER,segment,ICODE_HDR_LIT_START)

#define icode_get_literal_size(segment) \
   icode_get_value(GOTH_INTEGER,segment,ICODE_HDR_LIT_SIZE)

#define icode_get_literal_offset(segment,index) \
   (icode_get_literal_start(segment) + \
    index * ICODE_LIT_RECORD_SIZE)

#define icode_get_heap_start(segment) \
   icode_get_value(GOTH_INTEGER,segment,ICODE_HDR_HEAP_START)

#define icode_get_heap_size(segment) \
   icode_get_value(GOTH_INTEGER,segment,ICODE_HDR_HEAP_SIZE)



/*----------------------------------------------------------------------*/
/* Definitions of types used in dealing with icode			*/
/*									*/
/* Describing icode:							*/
/* 									*/
/* 	ICODE_SEGMENT_HEADER	a structure				*/
/* 	ICODE_SEGMENT_ID	a pointer to ICODE_SEGMENT_HEADER	*/
/*	ICODE_WORD		a "char"				*/
/*									*/
/* Desribing icode operators, addresses etc				*/
/* 									*/
/*	GOTH_INTEGER		an integer				*/
/* 	ICODE_OPERATOR		an enumeration				*/
/* 	ICODE_ADDRESS_MODE	an enumeration				*/
/*	GOTH_SPECIAL		a pointer to "void"			*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* Definition of an enumeration representing the operators available	*/
/* in icode 								*/
/*									*/
/* "ST" refers to the stack top pointer.				*/
/* 									*/
/* An instruction involving an operation of the form:			*/
/* 									*/
/* 		(ST-1) = (ST-1) + ST					*/
/* 									*/
/* includes an implicit decrement in the stack pointer, as two		*/
/* values are replaced by one.						*/
/*----------------------------------------------------------------------*/

enum _icode_operator
{
   _o_null,			/* Null operator */
   _o_error,			/* Error operator */
   _o_stop,			/* Stop - finish code execution */

   _o_add_integer,		/* Integer 	(ST-1) = (ST-1) + ST */
   _o_add_real,			/* Real 	(ST-1) = (ST-1) * ST */

   _o_add_string,		/* String 	(ST-1) = (ST-1) concat (ST) */

   _o_sub_integer,		/* Integer	(ST-1) = (ST-1) - ST */
   _o_sub_real,			/* Real		(ST-1) = (ST-1) - ST */

   _o_mul_integer,		/* Integer	(ST-1) = (ST-1) * ST */
   _o_mul_real,			/* Real		(ST-1) = (ST-1) * ST */

   _o_div_integer,		/* Integer	(ST-1) = (ST-1) / ST */
   _o_div_real,			/* Real		(ST-1) = (ST-1) / ST */

   _o_negate_integer,		/* Integer	ST = -ST */
   _o_negate_real,		/* Real		ST = -ST */

   _o_equal_integer,		/* Integer	(ST-1) = (ST-1) == ST */
   _o_equal_real,		/* Real		(ST-1) = (ST-1) == ST */
   _o_equal_boolean,		/* Boolean	(ST-1) = (ST-1) == ST */
   _o_equal_string,		/* String	(ST-1) = (ST-1) == ST */

   _o_not_equal_integer,	/* Integer	(ST-1) = (ST-1) != ST */
   _o_not_equal_real,		/* Real		(ST-1) = (ST-1) != ST */
   _o_not_equal_boolean,	/* Boolean	(ST-1) = (ST-1) != ST */
   _o_not_equal_string,		/* String	(ST-1) = (ST-1) != ST */

   _o_less_than_integer,	/* Integer	(ST-1) = (ST-1) < ST */
   _o_less_than_real,
   _o_less_than_boolean,
   _o_less_than_string,

   _o_less_equal_integer,	/* Integer	(ST-1) = (ST-1) <= ST */
   _o_less_equal_real,
   _o_less_equal_boolean,
   _o_less_equal_string,

   _o_greater_than_integer,	/* Integer	(ST-1) = (ST-1) > ST */
   _o_greater_than_real,
   _o_greater_than_boolean,
   _o_greater_than_string,

   _o_greater_equal_integer,	/* Integer	(ST-1) = (ST-1) >= ST */
   _o_greater_equal_real,
   _o_greater_equal_boolean,
   _o_greater_equal_string,

   _o_and,			/* Boolean	(ST-1) = (ST-1) && ST */
   _o_or,			/* Boolean	(ST-1) = (ST-1) || ST */
   _o_not,			/* Boolean	ST = !ST */

   _o_cast_integer_to_real,	/* Boolean	ST = (LULL_REAl) ST */
   _o_cast_real_to_integer,	/* Boolean	ST = (LULL_INTEGER) ST */

   _o_jump,			/*	  jump <mode> [<mode>] [<offset>] */
   _o_jump_true,		/* if ST  jump <mode> [<mode>] [<offset>] */
   _o_jump_false,		/* if !ST jump <mode> [<mode>] [<offset>] */

   _o_call,			/* jumpsubroutine <mode> [<mode>] [<offset>] */
   _o_return,			/* return from subroutine */

   _o_generate_pointer,		/* push pointer corresponding to address */
   _o_push,			/* push <mode> [<mode>] [<offset>] */
   _o_pop,			/* pop  <mode> [<mode>] [<offset>] */
   _o_push_string,		/* push <mode> [<mode>] [<offset>] */
   _o_pop_string,		/* pop  <mode> [<mode>] [<offset>] */
   _o_extend_stack,		/* extend <offset> ie ST = ST + offset */
   _o_shrink_stack,		/* shrink <offset> ie ST = ST - offset */

   _o_alloc_string,		/* value.string = malloc(ST) */
   _o_alloc_array,		/* allocate array */
   _o_alloc_string_array,	/* allocate whole array of strings */

   _o_pop_inform		/* pop inform <mode> - for debugging only */
};


/*----------------------------------------------------------------------*/
/* An enumeration for describing the different addressing modes 	*/
/* in icode								*/
/*----------------------------------------------------------------------*/


enum _icode_address_mode
{
   _a_null,			/* Null addressing mode */
   _a_dummy,			/* Dummy addressing mode - throw away */
				/* value or use dummy value */   

   _a_abs_value,		/* Use absolute value following instruction */

   _a_rel_segment_base,		/* Indexed relative to icode segment */
   _a_rel_static_base,		/* Indexed relative to static vector */
   _a_rel_frame_base,		/* Indexed relative to current frame */
   _a_rel_stk_address,		/* Indexed relative to address on stack */

   _a_abs_offset,		/* Absolute offset from specified address */
   _a_stk_offset		/* Stack-top offset from specified address */
};

typedef struct _icode_segment_header	ICODE_SEGMENT_HEADER;
typedef struct _icode_segment_header	*ICODE_SEGMENT_ID;
typedef char				ICODE_WORD;

typedef enum _icode_operator		ICODE_OPERATOR;
typedef enum _icode_address_mode	ICODE_ADDRESS_MODE;


/*----------------------------------------------------------------------*/
/* Structure for holding an icode segment (header)			*/
/*----------------------------------------------------------------------*/

struct _icode_segment_header
{
   GOTH_INTEGER		max_entries;
   GOTH_INTEGER		num_entries;
   GOTH_MEM_DESCRIPTOR 	descriptor_list;
   ICODE_WORD		*vector;
};




#endif
