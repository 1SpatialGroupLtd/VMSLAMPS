/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-04-19 19:23:48.000000000 +0100
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
/* $Header: /gothic/RCSroot/dictlib/RCS/hdr.lull_intrinsics.h,v 1.16 1994/02/16 18:58:56 olivia Exp $								*/
/* 									*/
/* $Log: hdr.lull_intrinsics.h,v $
 * Revision 1.16  1994/02/16  18:58:56  olivia
 * Version v1-15 derived from v1-14
 * Develop mechanism for reading a file containing the relationship between
 * lull string variables and their values so that foreign characters can
 * be placed into LULL strings.
 *
 * Revision 1.15  1993/12/16  10:48:54  davidr
 * Version v1-14 derived from v1-13
 * add function 'lull_declare_intrinsic_function' which declares both
 * the intrinsic and its argument list. This eases the task of writing jackets
 * in user-supplied libraries.
 * WICC 202
 *
 * Revision 1.14  1993/11/25  18:54:26  jon
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
 * Revision 1.13  1993/09/16  15:03:30  stevewi
 * Version v1-12 derived from v1-11
 * See Gothic WICC 126.
 *
 * Modify ICODE interpreter to reset its counts of functions when it
 * encounters an error during execution - e.g. an error returned by
 * a jacket routine.
 * Freeze for BSNC IGIS Analysis integration testing.
 *
 * Revision 1.12  1993/09/10  20:53:54  stevewi
 * Version v1-11 derived from v1-10
 * See Gothic WICC 116.
 *
 * Added new routine `lull_compile_link_text()'. This should be used in place of
 * `lull_compile()'.
 *
 * Added extra `tolerate_errors' argument to `lull_compile_execute_text()'.
 * Freeze for BNSC IGIS Analysis integration testing.
 *
 * Revision 1.11  1993/08/06  15:55:16  davida
 * Version v1-10 derived from v1-9
 * WICC 82
 *
 * lull_stack_call_stack() stacks function names as GOTH__LULLSTACK
 * messages rather than strings. This allows schlib to selectively
 * disable printing of the call stack.
 *
 * Revision 1.10  1993/07/15  09:41:09  davidr
 * Version v1-9 derived from v1-8
 * Extracted to improve trace capabilities.
 * Fixed small memory leak in lull_load_icode_file().
 * Fixed memory leak when attempting to load files and the file is not present.
 * The filename string is now freed in all cases.
 *
 * Revision 1.9  1993/03/10  10:49:46  jon
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
 * Revision 1.8  1993/02/23  10:22:49  davidr
 * Version v1-7 derived from v1-6
 * Extracted to add routine `lull_get_function_parameter_info()'.
 *
 * Modified `load_source_file_lull()' jacket routine so that it checks the return
 * code of the C routine.
 *
 * Revision 1.7  1993/01/22  16:26:37  olivia
 * Version v1-6 derived from v1-5
 * Extracted to investigate problems with the use of saved icode.
 * Default declarations for link in addition to compile
 * Turn lull reporting off by default
 *
 * Revision 1.6  1992/12/01  11:00:42  olivia
 * Version v1-5 derived from v1-4
 * investigating problems with lex/yacc producing non-portable code
 * Changed makefile to use sparc for precompilers / edit out non-ANSI
 * code.
 *
 * Revision 1.5  1992/10/21  11:58:17  jon
 * Version v1-4 derived from v1-3
 * investigating peculiar problems on HP with 'lull_load_source_file'
 *
 * Modified `make_parser' and `make_analyser' scripts to refer to
 * the new directory structure for holding source code.
 *
 * Revision 1.4  1992/08/19  18:13:44  snail
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
 * Revision 1.3  1992/05/17  17:07:38  jon
 * Version v1-2 derived from v1-1
 * Extracted to fix memory leak problems, particularly in the
 * symbol table handler. Fixing these problems may involve converting the
 * symbol table handler to using COLNLIB rather than BINLIB.
 * Converted symbol table handler to use collections rather than binary
 * trees, which fixed the most serious memory leak. This should also have
 * fixed the bug which resulted in duplicate definitions of the same variable
 * inside the same scope causing the Lull compiler to crash.
 *
 * Revision 1.2  1992/03/31  11:36:04  jon
 * Version v1-1 derived from v1-0
 * Fixed stack overflow problem in Icode interpreter which was resulting
 * in severe memory trampling after prolonged run.
 *								*/
#ifndef _LULL_INTRINSICS
#define _LULL_INTRINSICS
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    David Radcliffe, 29-May-1990				*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		     L U L L _ I N T R I N S I C S 			*/
/*									*/
/* Part of GOTHIC module LULLLIB					*/
/* Version 0.1, David Radcliffe 29-May-1990				*/
/************************************************************************/



/*----------------------------------------------------------------------*/
/* Interface to publicly available LULL intrinsics			*/
/* 									*/
/*----------------------------------------------------------------------*/

typedef GOTH_STATUS (*LULL_INIT_FN)(GOTH_DESCRIPTOR lull_env);

/*----------------------------------------------------------------------*/
/* EXTERN lull_init							*/
/*......................................................................*/
/* Routine to initialise the LULL compiler, creating the static		*/
/* symbol table and vector.						*/
/*----------------------------------------------------------------------*/
   
extern GOTH_STATUS lull_init(
			    GOTH_DESCRIPTOR		*lull_environ,
			    LULL_INIT_FN		init_special,
			    LULL_INIT_FN		init_intrinsic,
			    GOTH_BOOLEAN			obey_startup);
/*----------------------------------------------------------------------*/
/* EXTERN lull_compile_execute_file					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine allows a specified Lull source file to be compiled	*/
/* and executed.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* icode_segment_id	-out-	The compiled icode.			*/
/* 									*/
/* lull_environ		-in-	The Lull environment DED.		*/
/* 									*/
/* source_name		-in-	The file to be compiled.		*/
/* 									*/
/* tolerate_errors	-in-	If this is true, the compiler will be	*/
/* 				more tolerant of some compile time	*/
/* 				errors, such as identifiers		*/
/* 				referenced before they are declared.	*/
/* 									*/
/* debug_parse		-in-	Debug flag.				*/
/* 									*/
/* debug_tree		-in-	Debug flag.				*/
/* 									*/
/* debug_symbol		-in-	Debug flag.				*/
/* 									*/
/* debug_literal	-in-	Debug flag.				*/
/* 									*/
/* debug_icode		-in-	Debug flag.				*/
/* 									*/
/* debug_execution	-in-	Debug flag.				*/
/* 									*/
/* debug_result		-in-	Debug flag.				*/
/* 									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_compile_execute_file(
					     GOTH_DESCRIPTOR	lull_environ,
					     GOTH_STRING	source_name,
					     GOTH_BOOLEAN	tolerate_errors,
					     GOTH_BOOLEAN	debug_parse,
					     GOTH_BOOLEAN	debug_tree,
					     GOTH_BOOLEAN	debug_symbol,
					     GOTH_BOOLEAN	debug_literal,
					     GOTH_BOOLEAN	debug_icode,
					     GOTH_BOOLEAN	debug_execution,
					     GOTH_BOOLEAN	debug_result);
/*----------------------------------------------------------------------*/
/* EXTERN lull_compile_execute_text					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to compile, link and execute the contents of a NULL		*/
/* terminated string, as if it is a LULL compilation unit.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* lull_environ		-in-	The Lull environment DED.		*/
/* 									*/
/* input_text		-in-	The Lull source to be compiled.		*/
/*									*/
/* tolerate_errors	-in-	If this is true, the compiler will be	*/
/* 				more tolerant of some compile time	*/
/* 				errors, such as identifiers		*/
/* 				referenced before they are declared.	*/
/* 									*/
/* debug_parse		-in-	Debug flag.				*/
/* 									*/
/* debug_tree		-in-	Debug flag.				*/
/* 									*/
/* debug_symbol		-in-	Debug flag.				*/
/* 									*/
/* debug_literal	-in-	Debug flag.				*/
/* 									*/
/* debug_icode		-in-	Debug flag.				*/
/*									*/
/* debug_execution	-in-	Debug flag.				*/
/* 									*/
/* debug_result		-in-	Debug flag.				*/
/* 									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/
   
extern GOTH_STATUS lull_compile_execute_text(
					     GOTH_DESCRIPTOR	lull_environ,
					     GOTH_STRING	input_text,
					     GOTH_BOOLEAN	tolerate_errors,
					     GOTH_BOOLEAN	debug_parse,
					     GOTH_BOOLEAN	debug_tree,
					     GOTH_BOOLEAN	debug_symbol,
					     GOTH_BOOLEAN	debug_literal,
					     GOTH_BOOLEAN	debug_icode,
					     GOTH_BOOLEAN	debug_execution,
					     GOTH_BOOLEAN	debug_result);
/*----------------------------------------------------------------------*/
/* EXTERN lull_compile_execute_stdin					*/
/*......................................................................*/
/* Routine to compile, link and execute successive lines of LULL	*/
/* entered via the standard input device (stdin).			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   lull_compile_execute_stdin(
			      GOTH_DESCRIPTOR		lull_environ,
			      GOTH_BOOLEAN			debug_parse,
			      GOTH_BOOLEAN			debug_tree,
			      GOTH_BOOLEAN			debug_symbol,
			      GOTH_BOOLEAN			debug_literal,
			      GOTH_BOOLEAN			debug_icode,
			      GOTH_BOOLEAN			debug_execution,
			      GOTH_BOOLEAN			debug_result);
/*----------------------------------------------------------------------*/
/* EXTERN lull_compile_text						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to compile a LULL source held in a string. The result is	*/
/* an unlinked ICODE segment.						*/
/*									*/
/* This routine reports any errors which it encounters.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* icode_segment_id	-out-	The compiled icode.			*/
/* 									*/
/* lull_environ		-in-	The Lull environment DED.		*/
/* 									*/
/* input_text		-in-	The Lull source to be compiled.		*/
/*									*/
/* tolerate_errors	-in-	If this is true, the compiler will be	*/
/* 				more tolerant of some compile time	*/
/* 				errors, such as identifiers		*/
/* 				referenced before they are declared.	*/
/* 									*/
/* debug_parse		-in-	Debug flag.				*/
/* 									*/
/* debug_tree		-in-	Debug flag.				*/
/* 									*/
/* debug_symbol		-in-	Debug flag.				*/
/* 									*/
/* debug_literal	-in-	Debug flag.				*/
/* 									*/
/* debug_icode		-in-	Debug flag.				*/
/* 									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_compile_text(
				     GOTH_DESCRIPTOR		*icode_segment_descriptor,
				     GOTH_DESCRIPTOR		lull_environ,
				     GOTH_STRING		input_text,
				     GOTH_BOOLEAN		interactive,
				     GOTH_BOOLEAN		tolerate_errors,
				     GOTH_BOOLEAN		debug_parse,
				     GOTH_BOOLEAN		debug_tree,
				     GOTH_BOOLEAN		debug_symbol,
				     GOTH_BOOLEAN		debug_literal,
				     GOTH_BOOLEAN		debug_icode);
/*----------------------------------------------------------------------*/
/* EXTERN lull_compile							*/
/*......................................................................*/
/*									*/
/* THIS ROUTINE IS OBSOLETE - USE lull_compile_text() INSTEAD.		*/
/* 									*/
/* Routine to compile a LULL source held in a string. The result is	*/
/* an unlinked ICODE segment.						*/
/*									*/
/* This routine reports any errors which it encounters.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_compile(
			       GOTH_DESCRIPTOR	*icode_segment_descriptor,
			       GOTH_DESCRIPTOR	lull_environ,
			       GOTH_STRING	input_text,
			       GOTH_BOOLEAN	interactive,
			       GOTH_BOOLEAN	debug_parse,
			       GOTH_BOOLEAN	debug_tree,
			       GOTH_BOOLEAN	debug_symbol,
			       GOTH_BOOLEAN	debug_literal,
			       GOTH_BOOLEAN	debug_icode);
/*----------------------------------------------------------------------*/
/* EXTERN lull_compile_file						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine allows a specified Lull source file to be compiled. 	*/
/* The resulting icode segment must be linked before it can be		*/
/* executed.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* icode_segment_id	-out-	The compiled icode.			*/
/* 									*/
/* lull_environ		-in-	The Lull environment DED.		*/
/* 									*/
/* filename		-in-	The file to be compiled.		*/
/* 									*/
/* tolerate_errors	-in-	If this is true, the compiler will be	*/
/* 				more tolerant of some compile time	*/
/* 				errors, such as identifiers		*/
/* 				referenced before they are declared.	*/
/* 									*/
/* debug_parse		-in-	Debug flag.				*/
/* 									*/
/* debug_tree		-in-	Debug flag.				*/
/* 									*/
/* debug_symbol		-in-	Debug flag.				*/
/* 									*/
/* debug_literal	-in-	Debug flag.				*/
/* 									*/
/* debug_icode		-in-	Debug flag.				*/
/* 									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_compile_file(
				     GOTH_DESCRIPTOR		*icode_segment_id,
				     GOTH_DESCRIPTOR		lull_environ,
				     GOTH_STRING		filename,
				     GOTH_BOOLEAN		tolerate_errors,
				     GOTH_BOOLEAN		debug_parse,
				     GOTH_BOOLEAN		debug_tree,
				     GOTH_BOOLEAN		debug_symbol,
				     GOTH_BOOLEAN		debug_literal,
				     GOTH_BOOLEAN		debug_icode);
/*----------------------------------------------------------------------*/
/* EXTERN lull_link							*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_link(
			    GOTH_DESCRIPTOR	icode_segment_descriptor,
			    GOTH_DESCRIPTOR	lull_environ,
			    GOTH_BOOLEAN	debug_link);
/*----------------------------------------------------------------------*/
/* EXTERN lull_execute							*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_execute(
			       GOTH_DESCRIPTOR	icode_segment_descriptor,
			       GOTH_DESCRIPTOR	lull_environ,
			       GOTH_BOOLEAN	debug_execution,
			       GOTH_BOOLEAN	debug_result);
/*----------------------------------------------------------------------*/
/* EXTERN lull_load_link						*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_load_link(
				 GOTH_DESCRIPTOR *icode_segment_descriptor,
				 char		 *icodename,
				 GOTH_DESCRIPTOR lull_environ,
				 GOTH_BOOLEAN	 debug_load);
/*----------------------------------------------------------------------*/
/* EXTERN lull_save							*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_save(
			    GOTH_DESCRIPTOR	icode_segment_descriptor,
			    char		*icodename)      ;

/*----------------------------------------------------------------------*/
/* EXTERN lull_load_source_file						*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_load_source_file(
					char		*sourcename,
					GOTH_STRING	*text);
/*----------------------------------------------------------------------*/
/* EXTERN lull_save_source_file						*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_save_source_file(
					char		*sourcename,
					GOTH_STRING	text);
/*----------------------------------------------------------------------*/
/* EXTERN lull_load_icode_file						*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_load_icode_file(
				       char		*icodename,
				       GOTH_DESCRIPTOR	*icode_segment_descriptor);
/*----------------------------------------------------------------------*/
/* EXTERN lull_save_icode_file						*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_save_icode_file(
				       char		*icodename,
				       GOTH_DESCRIPTOR	icode_segment);


/*----------------------------------------------------------------------*/
/* EXTERN lull_free_segment						*/
/*......................................................................*/
/*									*/
/*	interface routine to icode_free_segment				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_free_segment(GOTH_DESCRIPTOR icode_segment_desc,
				     GOTH_DESCRIPTOR lull_environ);

/*----------------------------------------------------------------------*/
/* Public interface to the LULL declaration routines			*/
/* 									*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* EXTERN lull_declare_intrinsic_parameter_list				*/
/*......................................................................*/
/* Routine to allow the declaration of the parameter list for an	*/
/* intrinsic.								*/
/*									*/
/* Parameters:								*/
/* 									*/
/* 	lull_environ	The Lull environment SOD.			*/
/* 									*/
/* 	identifier	The intrinsic function's identifier.		*/
/* 									*/
/* 	num_params	The number of parameters for the intrinsic.	*/
/* 									*/
/* 	decl_types	TRUE if a type list is declared (as the		*/
/* 			remaining arguments).				*/
/* 			FALSE if no type list is declared.		*/
/* 									*/
/* 	...		The type list, in which each entry consists	*/
/* 			of an element of the DT_ enumeration.		*/
/* 			Any DT_DESCRIPTOR must be followed by an	*/
/* 			element of the DDT_ enumeration.		*/
/*			The DT_VARIANT and DDT_VARIANT specifiers will	*/
/* 			match any type.					*/
/*			Currently, DDT_ specifiers are ignored when	*/
/* 			type checking.					*/
/* 			The length of the type list must match the	*/
/* 			"num_params" argument.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   lull_declare_intrinsic_parameter_list(
					 GOTH_DESCRIPTOR	lull_environ,
					 GOTH_STRING		identifier,
					 GOTH_INTEGER		num_params,
					 GOTH_BOOLEAN		decl_types,
					 ...);
/*----------------------------------------------------------------------*/
/* EXTERN lull_declare_intrinsic					*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_declare_intrinsic(
					 GOTH_DESCRIPTOR 	lull_environ,
					 GOTH_STRING	identifier,
					 GOTH_DATATYPE		type,
					 GOTH_INTRINSIC	intrinsic);



/*----------------------------------------------------------------------*/
/* EXTERN lull_declare_intrinsic_function				*/
/*......................................................................*/
/* Routine to allow the declaration of the parameter list for an	*/
/* intrinsic.								*/
/*									*/
/* Parameters:								*/
/* 									*/
/* 	lull_environ	The Lull environment SOD.			*/
/* 									*/
/* 	identifier	The intrinsic function's identifier.		*/
/* 									*/
/* 	intrinsic	The pointer to the intrinsic function		*/
/* 									*/
/* 	type		The intrinsic function's return type		*/
/* 									*/
/* 	num_params	The number of parameters for the intrinsic.	*/
/* 									*/
/* 									*/
/* 	...		The type list, in which each entry consists	*/
/* 			of an element of the DT_ enumeration.		*/
/* 			Any DT_DESCRIPTOR must be followed by an	*/
/* 			element of the DDT_ enumeration.		*/
/*			The DT_VARIANT and DDT_VARIANT specifiers will	*/
/* 			match any type.					*/
/*			Currently, DDT_ specifiers are ignored when	*/
/* 			type checking.					*/
/* 			The length of the type list (where a 		*/
/*                      DT_DESCRIPTOR,DDT_VARIANT pair count as one item*/
/*			must match the "num_params" argument.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   lull_declare_intrinsic_function(
				   GOTH_DESCRIPTOR	lull_environ,
				   GOTH_STRING		identifier,
				   GOTH_INTRINSIC	intrinsic,
				   GOTH_DATATYPE     	type,
				   GOTH_INTEGER		num_params,
				   ...);

/*----------------------------------------------------------------------*/
/* EXTERN lull_declare_special_datatype					*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   lull_declare_special_datatype(
				 GOTH_DESCRIPTOR	lull_environ,
				 GOTH_STRING	identifier);

/*----------------------------------------------------------------------*/
/* EXTERN lull_declare_constant						*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_declare_constant(
					GOTH_DESCRIPTOR		lull_environ,
					GOTH_STRING		identifier,
					GOTH_DATATYPE		type,
					GOTH_VALUE		value);
/*----------------------------------------------------------------------*/
/* EXTERN lull_call_function						*/
/*......................................................................*/
/* Routine to allow the named function to be called from within a C	*/
/* program, whether the function is an intrinsic or a function defined	*/
/* in LULL.								*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_call_function(
				      GOTH_DESCRIPTOR	lull_environ,
				      GOTH_STRING	function_name,
				      GOTH_INTEGER	num_param,
				      GOTH_VALUE	*params,
				      GOTH_VALUE	*result);
/*----------------------------------------------------------------------*/
/* EXTERN lull_get_function_parameter_info				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to return information on the parameter list of the named	*/
/* function. None of the arrays returned by this routine should be	*/
/* modified or freed.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* lull_environ		-in-	The Lull exuection environment (symbol	*/
/* 				table etc.)				*/
/* 									*/
/* function_name	-in-	The name of the function.		*/
/* 									*/
/* declared		-out-	Returned as true if the parameter	*/
/* 				list has been declared for this 	*/
/* 				function.				*/
/* 									*/
/* num_params		-out-	The number of arguments which the	*/
/* 				routine takes.				*/
/* 									*/
/* simple_type		-out-	If this is not returned as null, then	*/
/* 				it will be a pointer to an array	*/
/* 				holding the simple datatypes of the	*/
/* 				function arguments.			*/
/* 									*/
/* desc_type		-out-	If this is not returned as null, then	*/
/* 				it will be a pointer to an array	*/
/* 				holding the descriptor datatypes of the	*/
/* 				function arguments.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_get_function_parameter_info(
						    GOTH_DESCRIPTOR		lull_environ,
						    GOTH_STRING			function_name,
						    GOTH_BOOLEAN		*declared,
						    GOTH_INTEGER		*num_params,
						    GOTH_DATATYPE		**simple_type,
						    GOTH_DESCRIPTOR_DATATYPE	**desc_type);
/*----------------------------------------------------------------------*/
/* EXTERN lull_get_function_info					*/
/*......................................................................*/
/* Routine to fetch the Lull callbable function information,		*/
/* suitable for passing to the lull_fast_call_function() routine.	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   lull_get_function_info(
			  GOTH_DESCRIPTOR	lull_environ,
			  GOTH_STRING		function_name,
			  GOTH_VALUE		*function_info);
/*----------------------------------------------------------------------*/
/* EXTERN lull_fast_call_function					*/
/*......................................................................*/
/* Routine to allow the named function to be called from within a C	*/
/* program, whether the function is an intrinsic or a function defined	*/
/* in LULL.								*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_fast_call_function(
					   GOTH_DESCRIPTOR	lull_environ,
					   GOTH_VALUE		function_info,
					   GOTH_INTEGER		num_params,
					   GOTH_VALUE		*params,
					   GOTH_VALUE		*result);
/*----------------------------------------------------------------------*/
/* EXTERN lull_record_state						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to record the current state of the Lull runtime module.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* state	-out-	The number used to identify the state of the	*/
/* 			Lull runtime module.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_record_state(
				     GOTH_INTEGER	*state);
/*----------------------------------------------------------------------*/
/* EXTERN lull_restore_state						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to restore the state of the Lull runtime module to a 	*/
/* previously restored state.						*/
/*									*/
/* States must be restored in the reverse order to that in which 	*/
/* they were originally recorded. That is, the last state recorded	*/
/* must be restored first.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* state	-in-	The number used to identify the state of the	*/
/* 			Lull runtime module.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_restore_state(
				     GOTH_INTEGER	state);
/*----------------------------------------------------------------------*/
/* EXTERN lull_traceon							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine turns on the Lull execution trace facility. When this	*/
/* facility is turned on, the names of all the functions which are	*/
/* called by a Lull program will be printed just before the		*/
/* calls are executed. This facility should be used when		*/
/* debugging Lull programs.						*/
/*									*/
/* The default mode of operation is for Lull tracing to be turned	*/
/* off.									*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_traceon();
/*----------------------------------------------------------------------*/
/* EXTERN lull_traceoff							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine turns off the Lull execution trace facility. This is 	*/
/* the normal default mode of operation.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_traceoff();
/*----------------------------------------------------------------------*/
/* EXTERN lull_print_call_stack						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine for printing the current Lull call stack.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* interface_id		-in-	The interface on which to print the	*/
/* 				Lull stack.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL								*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_print_call_stack(
					 GOTH_DESCRIPTOR	interface_id);
/*----------------------------------------------------------------------*/
/* EXTERN lull_stack_call_stack						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine for putting the Lull call stack on the Message stack.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL								*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_stack_call_stack( );
/*----------------------------------------------------------------------*/
/* EXTERN lull_record_call_stack					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to enable or disable the recording of the Lull call stack.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_record_call_stack(
					  GOTH_BOOLEAN	enable);
/*----------------------------------------------------------------------*/
/* EXTERN lull_reporton							*/
/*......................................................................*/
/* Routine to turn on the LULL facility which always reports		*/
/* execution start and finish etc.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_reporton();
/*----------------------------------------------------------------------*/
/* EXTERN lull_reportoff						*/
/*......................................................................*/
/* Routine to turn on the LULL facility which always reports		*/
/* execution start and finish etc.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_reportoff();
/*----------------------------------------------------------------------*/
/* EXTERN lull_informon							*/
/*......................................................................*/
/* Routine to turn on the LULL facility which always reports		*/
/* an attempt to ignore a function return.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_informon();
/*----------------------------------------------------------------------*/
/* EXTERN lull_informoff						*/
/*......................................................................*/
/* Routine to turn on the LULL facility which always reports		*/
/* an attempt to ignore a function return.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_informoff();

/*----------------------------------------------------------------------*/
/* EXTERN lull_init_string_vars						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* 									*/
/* Initialise the string variables in the string variable file		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* lull_environ -in- the LULL environment				*/
/* sos          -in- the sos of the file				*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lull_init_string_vars(GOTH_DESCRIPTOR  lull_environ,
					 GOTH_STRING	  sos) ;

/* This macro is sometimes needed for jacket routines */
#ifndef icode_free_memory
#define icode_free_memory(mem) \
{ cfree((char *)mem); }
#endif

#endif

