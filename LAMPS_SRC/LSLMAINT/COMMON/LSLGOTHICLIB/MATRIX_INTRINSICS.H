/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:04:54.000000000 +0000
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
#ifndef _MATRIX_INTRINSICS
#define _MATRIX_INTRINSICS

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Mike Cook, 27-Feb-1991					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		 M A T R I X _ I N T R I N S I C S . H 			*/
/*									*/
/* Part of GOTHIC module MATRIXLIB					*/
/* Version 0.1, Mike Cook 27-Feb-1991					*/
/************************************************************************/


/*----------------------------------------------------------------------*/
/* Include the GOTHIC datatype typedefs and the MATRIXLIB typedefs	*/
/*----------------------------------------------------------------------*/

#include <goth_datatypes.h>
#include <matrix_typedefs.h>


/*----------------------------------------------------------------------*/
/* Functions involved in creating/defining/resizing/destroying matrices */
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* EXTERN matrix_alloc   		       				*/
/*......................................................................*/
/* Allocates a MATRIX type GOTH_DESCRIPTOR block 			*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_DESCRIPTOR matrix_alloc();


/*----------------------------------------------------------------------*/
/* EXTERN matrix_free   		       				*/
/*......................................................................*/
/* Frees a MATRIX type GOTH_DESCRIPTOR block (only if the		*/
/* GOTH_DESCRIPTOR is the correct type, the ->refs field is zero and	*/
/* ->sod field is NULL)			   	              		*/
/*                                                                      */
/* matrix_id 	-in	- The descriptor block to free                  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_free(GOTH_DESCRIPTOR matrix_id);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_create							*/
/*......................................................................*/
/*									*/
/* Builds a complete (ie consistent) matrix and sets its GOTH_DESCRIPTOR*/
/*						 			*/
/* descp	- in	- GOTH_DESCRIPTOR for the matrix structure	*/
/* nrows	- in	- initial number of rows in the matrix		*/
/* ncols	- in	- initial number of columns in the matrix	*/
/* expandable	- in	- flags whether the matrix can be expanded	*/
/*			  (TRUE) at a later stage or not (FALSE)	*/
/* data_type	- in	- enumerated type, specifies the data type of 	*/
/*			  an element					*/
/* matrix_type	- in	- enumerated type, specifies the type of matrix */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_create(GOTH_DESCRIPTOR descp,
				 GOTH_INTEGER 	 nrows,
				 GOTH_INTEGER 	 ncols,
				 GOTH_BOOLEAN 	 expandable,
				 GOTH_DATATYPE   data_type,
				 MATRIX_TYPE     matrix_type);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_delete							*/
/*......................................................................*/
/* Deallocates the memory associated with a MATRIX structure if the	*/
/* GOTH_DESCRIPTOR reference count is zero, otherwise decrements the	*/
/* reference count by one. In the former case, the ->sod field is set 	*/
/* to NULL prevent referencing						*/
/* 									*/
/* mat_desc	- in	- GOTH_DESCRIPTOR for the matrix		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_delete(GOTH_DESCRIPTOR mat_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_build							*/
/*......................................................................*/
/* Combines the matrix_alloc() and matrix_create() functions. I.e	*/
/* allocates and returns a MATRIX GOTH_DESCRIPTOR and builds a complete	*/
/* (i.e. consistent) MATRIX structure to go with it.			*/ 
/*						 			*/
/* descp	- out	- GOTH_DESCRIPTOR for the matrix structure	*/
/* nrows	- in	- initial number of rows in the matrix		*/
/* ncols	- in	- initial number of columns in the matrix	*/
/* expandable	- in	- flags whether the matrix can be expanded	*/
/*			  (TRUE) at a later stage or not (FALSE)	*/
/* data_type	- in	- enumerated type, specifies the data type of 	*/
/*			  an element					*/
/* matrix_type	- in	- enumerated type, specifies the type of matrix */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_build(GOTH_DESCRIPTOR *descp,
				GOTH_INTEGER 	 nrows,
				GOTH_INTEGER 	 ncols,
				GOTH_BOOLEAN 	 expandable,
				GOTH_DATATYPE    data_type,
				MATRIX_TYPE      matrix_type);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_demolish						*/
/*......................................................................*/
/* Combines the matrix_delete() and matrix_free() functions. I.e.	*/
/* deallocates the memory associated with a MATRIX type GOTH_DESCRIPTOR,*/
/* including its MATRIX and BASE_MATRIX substructures if the reference  */
/* count is zero, otherwise just decrements the reference count		*/
/* 									*/
/* mat_desc	- in	- GOTH_DESCRIPTOR for the matrix		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_demolish(GOTH_DESCRIPTOR mat_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_expand							*/
/*......................................................................*/
/* function expands the number of rows/columns in a matrix		*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix			*/
/* nrows	- in	- Number of rows that the matrix is to have	*/
/* ncols	- in 	- Number of columns that the matrix is to have  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_expand(GOTH_DESCRIPTOR desc,
				 GOTH_INTEGER	 nrows,
				 GOTH_INTEGER	 ncols);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_define_submatrix					*/
/*......................................................................*/
/* function defines a submatrix of a matrix. The row/col ranges of the  */
/* submatrix must lies within the row/col ranges of the source matrix   */
/*									*/
/* source_desc	- in	- GOTH_DESCRIPTOR of the source matrix		*/
/* sub_desc	- in	- GOTH_DESCRIPTOR of the submatrix, must be	*/
/*	       		  uninitialised					*/
/* row0, row1	- in	- row range of the submatrix relative to the	*/
/*			  row range of the source matrix 		*/
/* col0, col1	- in	- col range of the submatrix relative to the	*/
/*			  col range of the source matrix 		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_define_submatrix(GOTH_DESCRIPTOR source_desc,
					   GOTH_DESCRIPTOR sub_desc,
					   GOTH_INTEGER	   row0,
					   GOTH_INTEGER    row1,
					   GOTH_INTEGER    col0,
					   GOTH_INTEGER    col1);



/*----------------------------------------------------------------------*/
/* Functions which set/get element values and display matrices		*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* EXTERN matrix_set_value						*/
/*......................................................................*/
/* function sets an element of a matrix					*/
/*									*/
/* mat_desc	- in	- GOTH_DESCRIPTOR of the matrix_structure	*/
/* row		- in 	- row index of the element			*/
/* col		- in 	- column index of the element			*/
/* value	- in 	- value of the element (GOTH_VALUE)		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_set_value(GOTH_DESCRIPTOR  mat_desc,
				    GOTH_INTEGER     row, 
				    GOTH_INTEGER     col,
				    GOTH_VALUE       value);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_get_value						*/
/*......................................................................*/
/* function returns the value of a matrix element			*/
/*									*/
/* mat_desc	- in	- GOTH_DESCRIPTOR of the matrix_structure	*/
/* row		- in 	- row index of the element			*/
/* col		- in 	- column index of the element			*/
/* value	- out 	- value of the element (GOTH_VALUE)		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_get_value(GOTH_DESCRIPTOR  mat_desc,
				    GOTH_INTEGER     row, 
				    GOTH_INTEGER     col,
				    GOTH_VALUE      *value);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_display						*/
/*......................................................................*/
/* function displays a matrix						*/
/*									*/
/* stream	- in	- output stream GOTH_DESCRIPTOR			*/
/* mat_desc	- in	- GOTH_DESCRIPTOR of the matrix			*/
/* comment	- in	- a 'comment' string for output			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_display(GOTH_DESCRIPTOR stream,
				  GOTH_DESCRIPTOR mat_desc,
				  GOTH_STRING     comment);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_full_display						*/
/*......................................................................*/
/* function displays every aspect of a matrix		       		*/
/*									*/
/* stream	- in	- output stream GOTH_DESCRIPTOR			*/
/* mat_desc	- in	- GOTH_DESCRIPTOR of the matrix			*/
/* comment	- in	- a 'comment' string for output			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_full_display(GOTH_DESCRIPTOR stream,
				       GOTH_DESCRIPTOR mat_desc,
				       GOTH_STRING     comment);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_skeleton						*/
/*......................................................................*/
/* function displays the skeleton of a matrix				*/
/*									*/
/* stream	- in	- output stream GOTH_DESCRIPTOR			*/
/* mat_desc	- in	- GOTH_DESCRIPTOR of the matrix			*/
/* comment	- in	- a 'comment' string for output			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_skeleton(GOTH_DESCRIPTOR stream,
				   GOTH_DESCRIPTOR mat_desc,
				   GOTH_STRING     comment);


/*----------------------------------------------------------------------*/
/* Functions which carry out matrix operations and store the results in */
/* a pre-existing 'result' matrix structure				*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* EXTERN matrix_zero							*/
/*......................................................................*/
/* function zero's a matrix						*/
/*									*/
/* mat_desc	- in	- GOTH_DESCRIPTOR of the matrix			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_zero(GOTH_DESCRIPTOR mat_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_scale							*/
/*......................................................................*/
/* function scales a matrix						*/
/*									*/
/* mat_desc		- in	- GOTH_DESCRIPTOR of the matrix		*/
/* scale_factor		- in	- scale factor for the matrix		*/
/* scale_factor_type	- in	- data type of the scale factor		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_scale(GOTH_DESCRIPTOR mat_desc,
				GOTH_VALUE      scale_factor,
				GOTH_DATATYPE   scale_factor_type);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_copy							*/
/*......................................................................*/
/* function copies a source matrix to a target matrix			*/
/*                                                                      */
/* source_desc		- in	- GOTH_DESCRIPTOR of the source matrix  */
/* target_desc		- in	- GOTH_DESCRIPTOR of the target matrix  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_copy(GOTH_DESCRIPTOR source_desc,
			       GOTH_DESCRIPTOR target_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_swap							*/
/*......................................................................*/
/* function swaps the elements of two matrices				*/
/*                                                                      */
/* mat_1_desc		- in	- GOTH_DESCRIPTOR of the first matrix  */
/* mat_2_desc		- in	- GOTH_DESCRIPTOR of the second matrix  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_swap(GOTH_DESCRIPTOR mat_1_desc,
			       GOTH_DESCRIPTOR mat_2_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_transpose						*/
/*......................................................................*/
/* function transpose copies a source matrix to a target matrix		*/
/*                                                                      */
/* source_desc		- in	- GOTH_DESCRIPTOR of the source matrix  */
/* target_desc		- in	- GOTH_DESCRIPTOR of the target matrix  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_transpose(GOTH_DESCRIPTOR source_desc,
				    GOTH_DESCRIPTOR target_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_add							*/
/*......................................................................*/
/* function adds two matrices together and stores the result in a 	*/
/* third 'result' matrix						*/
/*                                                                      */
/* mat_1_desc		- in	- GOTH_DESCRIPTOR of the first matrix   */
/* mat_2_desc		- in	- GOTH_DESCRIPTOR of the second matrix  */
/* result_desc		- in	- GOTH_DESCRIPTOR of the result matrix  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_add(GOTH_DESCRIPTOR mat_1_desc,
			      GOTH_DESCRIPTOR mat_2_desc,
			      GOTH_DESCRIPTOR result_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_subtract						*/
/*......................................................................*/
/* function subtracts the second matrix from the first and stores the 	*/
/* result in a third 'result' matrix					*/
/*                                                                      */
/* mat_1_desc		- in	- GOTH_DESCRIPTOR of the first matrix   */
/* mat_2_desc		- in	- GOTH_DESCRIPTOR of the second matrix  */
/* result_desc		- in	- GOTH_DESCRIPTOR of the result matrix  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_subtract(GOTH_DESCRIPTOR mat_1_desc,
				   GOTH_DESCRIPTOR mat_2_desc,
				   GOTH_DESCRIPTOR result_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_weighted_sum						*/
/*......................................................................*/
/* function computes the weighted sum of two matrices and stores the    */
/* result in a third 'result' matrix					*/
/*                                                                      */
/* mat_1_desc		- in	- GOTH_DESCRIPTOR of the first matrix   */
/* weight_1		- in	- weight factor for the first matrix    */
/* weight_1_type	- in	- GOTH_DATATYPE of the weight factor    */
/* mat_2_desc		- in	- GOTH_DESCRIPTOR of the second matrix  */
/* weight_2		- in	- weight factor for the second matrix   */
/* weight_2_type	- in	- GOTH_DATATYPE of the weight factor    */
/* result_desc		- in	- GOTH_DESCRIPTOR of the result matrix  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_weighted_sum(GOTH_DESCRIPTOR mat_1_desc,
				       GOTH_VALUE      weight_1,
				       GOTH_DATATYPE   weight_1_type,
				       GOTH_DESCRIPTOR mat_2_desc,
				       GOTH_VALUE      weight_2,
				       GOTH_DATATYPE   weight_2_type,
				       GOTH_DESCRIPTOR result_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_multiply						*/
/*......................................................................*/
/* function multiplies two matrices together and stores the result in a */
/* third 'result' matrix						*/
/*                                                                      */
/* mat_1_desc		- in	- GOTH_DESCRIPTOR of the first matrix   */
/* mat_2_desc		- in	- GOTH_DESCRIPTOR of the second matrix  */
/* result_desc		- in	- GOTH_DESCRIPTOR of the result matrix  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_multiply(GOTH_DESCRIPTOR mat_1_desc,
				   GOTH_DESCRIPTOR mat_2_desc,
				   GOTH_DESCRIPTOR result_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_cholesky_decompose					*/
/*......................................................................*/
/* function Cholesky decomposes a matrix (assumed symmetric) and stores */
/* the result in a target matrix.					*/
/*                                                                      */
/* source_desc		- in	- GOTH_DESCRIPTOR of the source matrix  */
/* target_desc		- in	- GOTH_DESCRIPTOR of the target matrix  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_cholesky_decompose(GOTH_DESCRIPTOR source_desc,
					     GOTH_DESCRIPTOR target_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_left_lower_divide					*/
/*......................................................................*/
/* function left divides a matrix by the lower triangular factor of a   */
/* denominator matrix and stores the result in a result matrix		*/
/*                                                                      */
/* lower_desc		- in	- GOTH_DESCRIPTOR of the denominator	*/
/*				  (only the lower triangle is used)	*/
/* numer_desc		- in	- GOTH_DESCRIPTOR of the numerator	*/
/* result_desc		- in	- GOTH_DESCRIPTOR of the result matrix  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_left_lower_divide(GOTH_DESCRIPTOR lower_desc,
					    GOTH_DESCRIPTOR numer_desc,
					    GOTH_DESCRIPTOR result_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_left_upper_divide					*/
/*......................................................................*/
/* function left divides a matrix by the upper triangular factor of a   */
/* denominator matrix and stores the result in a result matrix		*/
/*                                                                      */
/* upper_desc		- in	- GOTH_DESCRIPTOR of the denominator	*/
/*				  (only the upper triangle is used)	*/
/* numer_desc		- in	- GOTH_DESCRIPTOR of the numerator	*/
/* result_desc		- in	- GOTH_DESCRIPTOR of the result matrix  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_left_upper_divide(GOTH_DESCRIPTOR upper_desc,
					    GOTH_DESCRIPTOR numer_desc,
					    GOTH_DESCRIPTOR result_desc);



/*----------------------------------------------------------------------*/
/* Functions which carry out matrix operations and return the results   */
/* in a dynamically created 'result' matrix				*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* EXTERN matrix_dyn_copy						*/
/*......................................................................*/
/* function copies the elements of a source matrix to a dynamically	*/
/* created target matrix.						*/
/*                                                                      */
/* source_desc		- in	- GOTH_DESCRIPTOR of the source matrix  */
/* target_desc		- out	- GOTH_DESCRIPTOR of the target matrix  */
/* expandable		- in	- flags whether the target matrix should*/
/*				  be created as expandable (TRUE)	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_dyn_copy(GOTH_DESCRIPTOR  source_desc,
				   GOTH_DESCRIPTOR *target_desc,
				   GOTH_BOOLEAN     expandable);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_dyn_transpose						*/
/*......................................................................*/
/* function transpose copies a source matrix to a dynamically created	*/
/* target matrix.							*/
/*                                                                      */
/* source_desc		- in	- GOTH_DESCRIPTOR of the source matrix  */
/* target_desc		- out	- GOTH_DESCRIPTOR of the target matrix  */
/* expandable		- in	- flags whether the target matrix should*/
/*				  be created as expandable (TRUE)	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_dyn_transpose(GOTH_DESCRIPTOR  source_desc,
					GOTH_DESCRIPTOR *target_desc,
					GOTH_BOOLEAN     expandable);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_dyn_add						*/
/*......................................................................*/
/* function adds two matrices together and stores the result in a 	*/
/* dynamically created 'result matrix					*/
/*                                                                      */
/* mat_1_desc		- in	- GOTH_DESCRIPTOR of the first matrix   */
/* mat_2_desc		- in	- GOTH_DESCRIPTOR of the second matrix  */
/* result_desc		- out	- GOTH_DESCRIPTOR of the result matrix  */
/* expandable		- in	- flags whether the target matrix should*/
/*				  be created as expandable (TRUE)	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_dyn_add(GOTH_DESCRIPTOR  mat_1_desc,
				  GOTH_DESCRIPTOR  mat_2_desc,
				  GOTH_DESCRIPTOR *result_desc,
				  GOTH_BOOLEAN     expandable);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_dyn_subtract						*/
/*......................................................................*/
/* function computes the difference of two matrices and stores the 	*/
/* result in a dynamically created 'result matrix			*/
/*                                                                      */
/* mat_1_desc		- in	- GOTH_DESCRIPTOR of the first matrix   */
/* mat_2_desc		- in	- GOTH_DESCRIPTOR of the second matrix  */
/*				  (to be subtracted from the first)	*/
/* result_desc		- out	- GOTH_DESCRIPTOR of the result matrix  */
/* expandable		- in	- flags whether the target matrix should*/
/*				  be created as expandable (TRUE)	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_dyn_subtract(GOTH_DESCRIPTOR  mat_1_desc,
				       GOTH_DESCRIPTOR  mat_2_desc,
				       GOTH_DESCRIPTOR *result_desc,
				       GOTH_BOOLEAN     expandable);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_dyn_weighted_sum					*/
/*......................................................................*/
/* function computes the weighted sum of two matrices and stores the    */
/* result in a dynamically created 'result' matrix			*/
/*                                                                      */
/* mat_1_desc		- in	- GOTH_DESCRIPTOR of the first matrix   */
/* weight_1		- in	- weight factor for the first matrix    */
/* weight_1_type	- in	- GOTH_DATATYPE of the weight factor    */
/* mat_2_desc		- in	- GOTH_DESCRIPTOR of the second matrix  */
/* weight_2		- in	- weight factor for the second matrix   */
/* weight_2_type	- in	- GOTH_DATATYPE of the weight factor    */
/* result_desc		- out	- GOTH_DESCRIPTOR of the result matrix  */
/* expandable		- in	- flags whether the target matrix should*/
/*				  be created as expandable (TRUE)	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_dyn_weighted_sum(GOTH_DESCRIPTOR  mat_1_desc,
					   GOTH_VALUE       weight_1,
					   GOTH_DATATYPE    weight_1_type,
					   GOTH_DESCRIPTOR  mat_2_desc,
					   GOTH_VALUE       weight_2,
					   GOTH_DATATYPE    weight_2_type,
					   GOTH_DESCRIPTOR *result_desc,
					   GOTH_BOOLEAN     expandable);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_dyn_multiply						*/
/*......................................................................*/
/* function multiplies two matrices together and stores the result in a */
/* dynamically created 'result matrix					*/
/*                                                                      */
/* mat_1_desc		- in	- GOTH_DESCRIPTOR of the first matrix   */
/* mat_2_desc		- in	- GOTH_DESCRIPTOR of the second matrix  */
/* result_desc		- out	- GOTH_DESCRIPTOR of the result matrix  */
/* expandable		- in	- flags whether the target matrix should*/
/*				  be created as expandable (TRUE)	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_dyn_multiply(GOTH_DESCRIPTOR  mat_1_desc,
				       GOTH_DESCRIPTOR  mat_2_desc,
				       GOTH_DESCRIPTOR *result_desc,
				       GOTH_BOOLEAN     expandable);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_dyn_cholesky_decompose					*/
/*......................................................................*/
/* function Cholesky decomposes a matrix (assumed symmetric) and stores */
/* the result in a dynamically create target matrix.			*/
/*                                                                      */
/* source_desc		- in	- GOTH_DESCRIPTOR of the source matrix  */
/* target_desc		- out	- GOTH_DESCRIPTOR of the target matrix  */
/* expandable		- in	- flags whether the target matrix should*/
/*				  be created as expandable (TRUE)	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_dyn_cholesky_decompose(GOTH_DESCRIPTOR  source_desc,
						 GOTH_DESCRIPTOR *target_desc,
						 GOTH_BOOLEAN     expandable);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_dyn_left_lower_divide					*/
/*......................................................................*/
/* function left divides a matrix by the lower triangular factor of a   */
/* denominator matrix and stores the result in a dynamically created    */
/* result matrix							*/
/*                                                                      */
/* lower_desc		- in	- GOTH_DESCRIPTOR of the denominator	*/
/*				  (only the lower triangle is used)	*/
/* numer_desc		- in	- GOTH_DESCRIPTOR of the numerator	*/
/* result_desc		- out	- GOTH_DESCRIPTOR of the result matrix  */
/* expandable		- in	- flags whether the target matrix should*/
/*				  be created as expandable (TRUE)	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_dyn_left_lower_divide(GOTH_DESCRIPTOR  lower_desc,
						GOTH_DESCRIPTOR  numer_desc,
						GOTH_DESCRIPTOR *result_desc,
						GOTH_BOOLEAN     expandable);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_dyn_left_upper_divide					*/
/*......................................................................*/
/* function left divides a matrix by the upper triangular factor of a   */
/* denominator matrix and stores the result in a dynamically created    */
/* result matrix							*/
/*                                                                      */
/* upper_desc		- in	- GOTH_DESCRIPTOR of the denominator	*/
/*				  (only the upper triangle is used)	*/
/* numer_desc		- in	- GOTH_DESCRIPTOR of the numerator	*/
/* result_desc		- out	- GOTH_DESCRIPTOR of the result matrix  */
/* expandable		- in	- flags whether the target matrix should*/
/*				  be created as expandable (TRUE)	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_dyn_left_upper_divide(GOTH_DESCRIPTOR  upper_desc,
						GOTH_DESCRIPTOR  numer_desc,
						GOTH_DESCRIPTOR *result_desc,
						GOTH_BOOLEAN     expandable);



/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/* Inquiry functions							*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* EXTERN matrix_inquire_is_valid					*/
/*......................................................................*/
/* function determines whether a GOTH_DESCRIPTOR is of type DDT_MATRIX  */
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR to be tested			*/
/* valid	- out	- BOOLEAN flag, true if the descriptor is of	*/
/*			  type DDT_MATRIX				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_inquire_is_valid(GOTH_DESCRIPTOR  desc,
					   GOTH_BOOLEAN    *valid);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_inquire_is_defined					*/
/*......................................................................*/
/* function determines whether a GOTH_DESCRIPTOR defines a MATRIX	*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR to be tested			*/
/* defined	- out	- BOOLEAN flag, true if the GOTH_DESCRIPTOR 	*/
/*			  defines a valid matrix			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_inquire_is_defined(GOTH_DESCRIPTOR  desc,
					     GOTH_BOOLEAN    *defined);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_inquire_is_submatrix					*/
/*......................................................................*/
/* function determines whether a MATRIX type GOTH_DESCRIPTOR defines a  */
/* submatrix								*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR to be tested			*/
/* is_submatrix	- out	- BOOLEAN flag, true if the descriptor defines	*/
/*			  a submatrix					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_inquire_is_submatrix(GOTH_DESCRIPTOR  desc,
					       GOTH_BOOLEAN    *is_submatrix);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_inquire_first_row					*/
/*......................................................................*/
/* functions returns the absolute row index of the first row of a	*/
/* (sub) matrix.							*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix			*/
/* row		- out	- absolute index of the first row		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_inquire_first_row(GOTH_DESCRIPTOR  desc,
					    GOTH_INTEGER    *row);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_inquire_last_row					*/
/*......................................................................*/
/* functions returns the absolute row index of the last row of a	*/
/* (sub) matrix.							*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix			*/
/* row		- out	- absolute index of the last row		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_inquire_last_row(GOTH_DESCRIPTOR  desc,
					   GOTH_INTEGER    *row);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_inquire_first_col					*/
/*......................................................................*/
/* functions returns the absolute column index of the first column of a	*/
/* (sub) matrix.							*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix			*/
/* col		- out	- absolute index of the first column		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_inquire_first_col(GOTH_DESCRIPTOR  desc,
					    GOTH_INTEGER    *col);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_inquire_last_col					*/
/*......................................................................*/
/* functions returns the absolute column index of the first column of a	*/
/* (sub) matrix.							*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix			*/
/* col		- out	- absolute index of the first column		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_inquire_last_col(GOTH_DESCRIPTOR  desc,
					   GOTH_INTEGER    *col);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_inquire_number_of_rows					*/
/*......................................................................*/
/* functions returns the number of rows in a (sub) matrix.		*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix			*/
/* rows		- out	- number of rows in the (sub) matrix		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_inquire_number_of_rows(GOTH_DESCRIPTOR  desc,
						 GOTH_INTEGER    *rows);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_inquire_number_of_cols					*/
/*......................................................................*/
/* functions returns the number of columns in a (sub) matrix.		*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix			*/
/* cols		- out	- number of columns in the (sub) matrix		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_inquire_number_of_cols(GOTH_DESCRIPTOR  desc,
						 GOTH_INTEGER    *cols);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_inquire_is_expandable					*/
/*......................................................................*/
/* function determines whether a matrix is expandable.			*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix to be tested	*/
/* expandable	- out	- BOOLEAN flag, true if the matrix is expandable*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_inquire_is_expandable(GOTH_DESCRIPTOR  desc,
						GOTH_BOOLEAN    *expandable);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_inquire_datatype					*/
/*......................................................................*/
/* function returns the datatype of a matrix.				*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix to be tested	*/
/* type		- out	- datatype of the matrix			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_inquire_datatype(GOTH_DESCRIPTOR  desc,
					   GOTH_DATATYPE   *type);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_inquire_matrixtype					*/
/*......................................................................*/
/* function returns the matrix-type of a matrix.			*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix to be tested	*/
/* type		- out	- matrix-type of the matrix			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_inquire_matrixtype(GOTH_DESCRIPTOR  desc,
					     GOTH_DATATYPE   *type);




#endif
/* $Header: /lslhome/gothic/hdr/matrixlib/v1-2/RCS/hdr.matrix_intrinsics.h,v 1.3 1993/04/14 10:30:55 olivia Exp $								*/
/* 									*/
/* $Log: hdr.matrix_intrinsics.h,v $
 * Revision 1.3  1993/04/14  10:30:55  olivia
 * Version v1-2 derived from v1-1
 * makefile converted to new format
 *
 * Revision 1.2  1992/07/13  16:33:03  davida
 * Version v1-1 derived from v1-0
 * Copes with NULL descriptors.
 *								*/
