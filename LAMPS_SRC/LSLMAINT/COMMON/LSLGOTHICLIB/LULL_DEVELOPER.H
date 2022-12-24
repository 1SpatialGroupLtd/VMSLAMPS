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
/* $Header: /gothic/RCSroot/dictlib/RCS/hdr.lull_developer.h,v 1.16 1994/02/16 18:58:49 olivia Exp $								*/
/* 									*/
/* $Log: hdr.lull_developer.h,v $
 * Revision 1.16  1994/02/16  18:58:49  olivia
 * Version v1-15 derived from v1-14
 * Develop mechanism for reading a file containing the relationship between
 * lull string variables and their values so that foreign characters can
 * be placed into LULL strings.
 *
 * Revision 1.15  1993/12/16  10:48:43  davidr
 * Version v1-14 derived from v1-13
 * add function 'lull_declare_intrinsic_function' which declares both
 * the intrinsic and its argument list. This eases the task of writing jackets
 * in user-supplied libraries.
 * WICC 202
 *
 * Revision 1.14  1993/11/25  18:54:06  jon
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
 * Revision 1.13  1993/09/16  15:03:08  stevewi
 * Version v1-12 derived from v1-11
 * See Gothic WICC 126.
 *
 * Modify ICODE interpreter to reset its counts of functions when it
 * encounters an error during execution - e.g. an error returned by
 * a jacket routine.
 * Freeze for BSNC IGIS Analysis integration testing.
 *
 * Revision 1.12  1993/09/10  20:53:20  stevewi
 * Version v1-11 derived from v1-10
 * See Gothic WICC 116.
 *
 * Added new routine `lull_compile_link_text()'. This should be used in place of
 * `lull_compile()'.
 *
 * Added extra `tolerate_errors' argument to `lull_compile_execute_text()'.
 * Freeze for BNSC IGIS Analysis integration testing.
 *
 * Revision 1.11  1993/08/06  15:55:05  davida
 * Version v1-10 derived from v1-9
 * WICC 82
 *
 * lull_stack_call_stack() stacks function names as GOTH__LULLSTACK
 * messages rather than strings. This allows schlib to selectively
 * disable printing of the call stack.
 *
 * Revision 1.10  1993/07/15  09:41:01  davidr
 * Version v1-9 derived from v1-8
 * Extracted to improve trace capabilities.
 * Fixed small memory leak in lull_load_icode_file().
 * Fixed memory leak when attempting to load files and the file is not present.
 * The filename string is now freed in all cases.
 *
 * Revision 1.9  1993/03/10  10:49:25  jon
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
 * Revision 1.8  1993/02/23  10:22:39  davidr
 * Version v1-7 derived from v1-6
 * Extracted to add routine `lull_get_function_parameter_info()'.
 *
 * Modified `load_source_file_lull()' jacket routine so that it checks the return
 * code of the C routine.
 *
 * Revision 1.7  1993/01/22  16:26:24  olivia
 * Version v1-6 derived from v1-5
 * Extracted to investigate problems with the use of saved icode.
 * Default declarations for link in addition to compile
 * Turn lull reporting off by default
 *
 * Revision 1.6  1992/12/01  11:00:29  olivia
 * Version v1-5 derived from v1-4
 * investigating problems with lex/yacc producing non-portable code
 * Changed makefile to use sparc for precompilers / edit out non-ANSI
 * code.
 *
 * Revision 1.5  1992/10/21  11:57:53  jon
 * Version v1-4 derived from v1-3
 * investigating peculiar problems on HP with 'lull_load_source_file'
 *
 * Modified `make_parser' and `make_analyser' scripts to refer to
 * the new directory structure for holding source code.
 *
 * Revision 1.4  1992/08/19  18:13:26  snail
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
 * Revision 1.3  1992/05/17  17:07:27  jon
 * Version v1-2 derived from v1-1
 * Extracted to fix memory leak problems, particularly in the
 * symbol table handler. Fixing these problems may involve converting the
 * symbol table handler to using COLNLIB rather than BINLIB.
 * Converted symbol table handler to use collections rather than binary
 * trees, which fixed the most serious memory leak. This should also have
 * fixed the bug which resulted in duplicate definitions of the same variable
 * inside the same scope causing the Lull compiler to crash.
 *
 * Revision 1.2  1992/03/31  11:35:50  jon
 * Version v1-1 derived from v1-0
 * Fixed stack overflow problem in Icode interpreter which was resulting
 * in severe memory trampling after prolonged run.
 *								*/
#ifndef _LULL_DEVELOPER
#define _LULL_DEVELOPER
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Jonathan Billing,  9-Nov-1989				*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		    L U L L _ D E V E L O P E R . H 			*/
/*									*/
/* Part of GOTHIC module LULL						*/
/* Version 0.1, Jonathan Billing  9-Nov-1989				*/
/*									*/
/* Header file, containing all the header file includes needed by 	*/
/* developers using LULL, and some more besides.			*/
/*									*/
/* The following files should be included before this header file:	*/
/*									*/
/*	<stdio.h>			Standard i/o			*/
/*	<string.h>			String handling			*/
/*	"gothic_hdr:lsldef.h"		LSL definitions			*/
/*	"gothic_hdr:gothic_status_codes.h" Gothic status codes		*/
/*	"gothic_hdr:config.h"	        Configuration header file	*/
/*	"gothic_hdr:bin_defns.h"	BINLIB definitions		*/
/*									*/
/* This may lead to some unnecessary included header files, but it	*/
/* saves time and trouble getting all the right header files, in the	*/
/* right order, in the C modules.					*/
/************************************************************************/

#include "icode_defns.h"	/* ICODE definitions */
#include "lull_defns.h"		/* LULL definitions */
#include "lull_functions.h"	/* LULL function prototypes */



#endif
