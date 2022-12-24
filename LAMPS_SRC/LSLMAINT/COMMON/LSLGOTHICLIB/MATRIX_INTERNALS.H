/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:04:52.000000000 +0000
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
#ifdef  DECLARE_MATRIX_INTERNALS
#ifndef _MATRIX_INTERNALS
#define _MATRIX_INTERNALS

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Mike Cook, 27-Feb-1991					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		  M A T R I X _ I N T E R N A L S . H 			*/
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
/* Functions which create/attach/detach/destroy structures internal to  */
/* MATRIXLIB								*/
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_create						*/
/*......................................................................*/
/* Builds a complete (ie. consistent) BASE_MATRIX. This function is only*/
/* available locally				 			*/
/* (currently only GOTH_REAL (DT_REAL) is supported)			*/
/*									*/
/* descp	- in	- GOTH_DESCRIPTOR for the matrix structure	*/
/* nrows	- in	- initial number of rows in the matrix		*/
/* ncols	- in	- initial number of columns in the matrix	*/
/* expandable	- in	- flags whether the matrix can be expanded	*/
/*			  (TRUE) at a later stage or not (FALSE)	*/
/* data_type	- in	- enumerated type, specifies the data type of 	*/
/*			  an element					*/
/* matrix_type	- in	- enumerated type, specifies the type of matrix */
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_create(BASE_MATRIX_PTR *base_matp,
				      GOTH_INTEGER     nrows,
				      GOTH_INTEGER     ncols,
				      GOTH_BOOLEAN     expandable,
				      GOTH_DATATYPE    data_type,
				      MATRIX_TYPE      matrix_type);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_delete						*/
/*......................................................................*/
/* Function deallocates all memory associated with a BASE_MATRIX 	*/
/* structure if the ->ref_count field of the structure is 0 (i.e. the   */
/* structure is not referenced by more than 1 structure, decrements	*/
/* ->ref_count field if it is non-zero (i.e. reduce the number of 	*/
/* references to the structure						*/
/*									*/
/* base_matp	- in	- ptr to BASE_MATRIX structure			*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_delete(BASE_MATRIX_PTR base_matp);


/*----------------------------------------------------------------------*/
/* LOCAL matrix_element_create						*/
/*......................................................................*/
/* Creates a new matrix element. Links to itself, has value 0.  Will    */
/* not create if the row/column indices are invalid		     	*/
/*									*/
/* eptr	 - out	- pointer to new element structure			*/
/* row	 - in	- row of the new element				*/
/* col	 - in	- column of the new element				*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS matrix_element_create(MATRIX_ELEMENT_PTR *eptr,
					 GOTH_INTEGER        row,
					 GOTH_INTEGER        col);


/*----------------------------------------------------------------------*/
/* LOCAL matrix_element_delete						*/
/*......................................................................*/
/* frees the memory associated with a matrix element			*/
/*									*/
/* ep	 - in	- matrix element pointer				*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS matrix_element_delete(MATRIX_ELEMENT_PTR ep);


/*----------------------------------------------------------------------*/
/* LOCAL matrix_element_attach						*/
/*......................................................................*/
/* attaches a matrix element to a matrix given its nearest left and	*/
/* above neighbours. Checks only the existence of the neighbours, not	*/
/* the linkages, nor the row/col order.					*/
/*									*/
/* ep	   - in	- element to be attached to the matrix			*/
/* leftep  - in	- nearest left neighbour  				*/ 
/* aboveep - in	- nearest above neighbour				*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS matrix_element_attach(MATRIX_ELEMENT_PTR ep,
					 MATRIX_ELEMENT_PTR leftep,
					 MATRIX_ELEMENT_PTR abovep);


/*----------------------------------------------------------------------*/
/* LOCAL matrix_element_safe_attach					*/
/*......................................................................*/
/* attaches a matrix element to a matrix given existing elements lying  */
/* on the element's row and column. Ensures that the element is 	*/
/* correctly placed in the matrix mesh. Will not allow linkage to be	*/
/* made if an element already exists where the new element is to be 	*/
/* linked in (error condition)	       					*/
/*									*/
/* ep	 - in	- element to be attached to the matrix			*/
/* rowep - in	- existing matrix element lying on the same row as ep   */ 
/* colep - in	- existing matrix element lying on the same col as ep	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS matrix_element_safe_attach(MATRIX_ELEMENT_PTR ep,
					      MATRIX_ELEMENT_PTR rowep,
					      MATRIX_ELEMENT_PTR colep);


/*----------------------------------------------------------------------*/
/* LOCAL matrix_element_detach						*/
/*......................................................................*/
/* detaches a matrix element from a matrix 				*/
/*									*/
/* el	 - in	- element to be detached from the matrix		*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS matrix_element_detach(MATRIX_ELEMENT_PTR el);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_baserow_expand					*/
/*......................................................................*/
/* function extends the 'baserow' linked list to allow new rows to be	*/
/* added to a base_matrix						*/
/*									*/
/* basemp	- in	- pointer to BASE_MATRIX structure		*/
/* ntarget	- in	- target row					*/
/* last		- out	- pointer to last element of the 'baserow'	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_baserow_expand(BASE_MATRIX_PTR     basemp,
					      GOTH_INTEGER        ntarget,
					      MATRIX_ELEMENT_PTR *last);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_basecol_expand					*/
/*......................................................................*/
/* function extends the 'basecol' linked list to allow new columns to 	*/
/* be added to a base_matrix						*/
/*									*/
/* basemp	- in	- pointer to BASE_MATRIX structure		*/
/* ntarget	- in	- target col					*/
/* last		- out	- pointer to last element of the 'basecol'	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_basecol_expand(BASE_MATRIX_PTR     basemp,
					      GOTH_INTEGER        ntarget,
					      MATRIX_ELEMENT_PTR *last);


/*----------------------------------------------------------------------*/
/* Functions which deal internally with individual elements		*/
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_element_check					*/
/*......................................................................*/
/* function checks whether a matrix element can exist. Also sets	*/
/* pointers to the last elements of the 'baserow' or 'basecol' if	*/
/* matrix expansion was necessary. If the 'baserow' or 'basecol' were	*/
/* not expanded, then the corresponding pointers are set to NULL.      	*/
/*									*/
/* basemp 	- in	- pointer to the BASE_MATRIX structure		*/
/* row	  	- in	- row index of the element			*/
/* col	  	- in	- column index of the element			*/
/* baserow_last	- out	- ptr to last element of 'baserow' if expansion */
/*			  was necessary, NULL otherwise                 */
/* basecol_last	- out	- ptr to last element of 'basecol' if expansion */
/*			  was necessary, NULL otherwise                 */
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_element_check(BASE_MATRIX_PTR     basemp,
					     GOTH_INTEGER        row,
					     GOTH_INTEGER        col,
					     MATRIX_ELEMENT_PTR *baserow_last,
					     MATRIX_ELEMENT_PTR *basecol_last);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_find_element					*/
/*......................................................................*/
/* function tries to find the address of a specified matrix element, if */
/* the element does not exist, it returns the address of the element 	*/
/* which right or down links across the missing element (i.e. the 	*/
/* nearest neighbour to the left or above). The search procedure may	*/
/* be along the rows or down the columns.				*/
/*									*/
/* basemp - in	- pointer to the BASE_MATRIX structure			*/
/* row	  - in	- row index of the element				*/
/* col	  - in	- column index of the element				*/
/* ep	  - out	- address of the element (if found) or the element	*/
/*		  which 'links' across the requested element		*/
/* by_row - in	- flag, if true, search across the row for the element, */
/*		  if false, search down the column for the element	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_find_element(BASE_MATRIX_PTR        basemp,
					    GOTH_INTEGER           row,
					    GOTH_INTEGER           col,
					    MATRIX_ELEMENT_PTR    *ep,
					    ELEMENT_SEARCH_METHOD  method);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_set_value						*/
/*......................................................................*/
/* function sets an element of a base matrix, creating the element	*/
/* structure and setting the element links if it didn't exist on entry	*/
/* destroying the element and resetting the links if it already existed */
/* and the new value is zero.						*/
/*									*/
/* basemp	- in	- pointer to base matrix			*/
/* row		- in	- row index of the element			*/
/* col		- in	- column index of the element			*/
/* value	- in	- value of the element (GOTH_VALUE)		*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_set_value(BASE_MATRIX_PTR basemp,
					 GOTH_INTEGER    row, 
					 GOTH_INTEGER    col,
					 GOTH_VALUE      value);
      

/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_get_value						*/
/*......................................................................*/
/* function returns the value of a base matrix element			*/
/*									*/
/* basemp	- in	- pointer to base matrix			*/
/* row		- in	- row index of the element			*/
/* col		- in	- column index of the element			*/
/* value	- out	- returned value of the element (GOTH_VALUE) 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_get_value(BASE_MATRIX_PTR basemp,
					 GOTH_INTEGER    row, 
					 GOTH_INTEGER    col,
					 GOTH_VALUE     *value);



/*----------------------------------------------------------------------*/
/* functions which deal internally with blocks of elements		*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_block_check					*/
/*......................................................................*/
/* function checks that a block of elements of a base matrix has valid  */
/* row/col ranges.							*/
/*                                                                      */
/* basemp	- in	- ptr to base matrix structure 			*/
/* rows		- in	- row index range of the block			*/
/* cols		- in 	- col index range of the block			*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_block_check(BASE_MATRIX_PTR basemp,
					   INDEX_RANGE	   rows,
					   INDEX_RANGE	   cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_block_display					*/
/*......................................................................*/
/* function displays a block of elements from a base matrix             */
/*                                                                      */
/* stream	- in	- output stream descriptor			*/
/* matp		- in	- pointer to the base matrix			*/
/* rows		- in	- row range of element block 			*/
/* cols		- in	- col range of element block 			*/
/* comment	- in	- a 'comment' string for output			*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_block_display(GOTH_DESCRIPTOR stream,
					     BASE_MATRIX_PTR matp,
					     INDEX_RANGE     rows,
					     INDEX_RANGE     cols,
					     GOTH_STRING     comment);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_block_full_display					*/
/*......................................................................*/
/* function displays every aspect of a block of elements from a base    */
/* matrix							        */
/*                                                                      */
/* stream	- in	- output stream descriptor			*/
/* matp		- in	- pointer to the base matrix			*/
/* rows		- in	- row range of element block 			*/
/* cols		- in	- col range of element block 			*/
/* comment	- in	- a 'comment' string for output			*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_block_full_display(GOTH_DESCRIPTOR stream,
						  BASE_MATRIX_PTR matp,
						  INDEX_RANGE     rows,
						  INDEX_RANGE     cols,
						  GOTH_STRING     comment);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_block_skeleton					*/
/*......................................................................*/
/* function displays the skeleton a block of elements from a base matrix*/
/*                                                                      */
/* stream	- in	- output stream descriptor			*/
/* matp		- in	- pointer to the base matrix			*/
/* rows		- in	- row range of element block 			*/
/* cols		- in	- col range of element block 			*/
/* comment	- in	- a 'comment' string for output			*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_block_skeleton(GOTH_DESCRIPTOR stream,
					     BASE_MATRIX_PTR matp,
					     INDEX_RANGE     rows,
					     INDEX_RANGE     cols,
					     GOTH_STRING     comment);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_block_scale					*/
/*......................................................................*/
/* function scales a block of elements of a base matrix 		*/
/*                                                                      */
/* matp			- in	- pointer to the base matrix		*/
/* rows			- in	- row range of the element block 	*/
/* cols			- in	- col range of the element block 	*/
/* scale_factor		- in	- block scale factor			*/
/* scale_factor_type	- in	- data type of scale factor		*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_block_scale(BASE_MATRIX_PTR matp,
					   INDEX_RANGE     rows,
					   INDEX_RANGE     cols,
					   GOTH_VALUE      scale_factor,
					   GOTH_DATATYPE   scale_factor_type);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_block_swap						*/
/*......................................................................*/
/* function swaps equal sized blocks of elements from two base matrix	*/
/* structures. Function is essentially a fast once only copy routine    */
/*                                                                      */
/* mat_0_matp		- in	- pointer to the mat_0 base matrix	*/
/* mat_0_rows		- in	- row range of mat_0 element block 	*/
/* mat_0_cols		- in	- col range of mat_0 element block 	*/
/* mat_1_matp		- in	- pointer to the mat_1 base matrix	*/
/* mat_1_rows		- in	- row range of mat_1 element block 	*/
/* mat_1_cols		- in	- col range of mat_1 element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_block_swap(BASE_MATRIX_PTR mat_1_matp,
					  INDEX_RANGE     mat_1_rows,
					  INDEX_RANGE     mat_1_cols,
					  BASE_MATRIX_PTR mat_2_matp,
					  INDEX_RANGE     mat_2_rows,
					  INDEX_RANGE     mat_2_cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_block_copy						*/
/*......................................................................*/
/* function copies a block of elements from a source base matrix into   */
/* a target base matrix. Elements in the target matrix are created if   */
/* their new values are non-zero and they previously didn't exist,	*/
/* destroyed if their new values are zero and they did previously exist */
/*                                                                      */
/* source_matp		- in	- pointer to the source base matrix	*/
/* source_rows		- in	- row range of source element block 	*/
/* source_cols		- in	- col range of source element block 	*/
/* target_matp		- in	- pointer to the target base matrix	*/
/* target_rows		- in	- row range of target element block 	*/
/* target_cols		- in	- col range of target element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_block_copy(BASE_MATRIX_PTR source_matp,
					  INDEX_RANGE     source_rows,
					  INDEX_RANGE     source_cols,
					  BASE_MATRIX_PTR target_matp,
					  INDEX_RANGE     target_rows,
					  INDEX_RANGE     target_cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_block_transpose					*/
/*......................................................................*/
/* function transpose copies a block of elements from a source base	*/
/* matrix into a target base matrix. Elements in the target matrix are  */
/* created if their new values are non-zero and they previously didn't  */
/* exist, destroyed if their new values are zero and they did previously*/
/* exist                                                                */
/*                                                                      */
/* source_matp		- in	- pointer to the source base matrix	*/
/* source_rows		- in	- row range of source element block 	*/
/* source_cols		- in	- col range of source element block 	*/
/* target_matp		- in	- pointer to the target base matrix	*/
/* target_rows		- in	- row range of target element block 	*/
/* target_cols		- in	- col range of target element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_block_transpose(BASE_MATRIX_PTR source_matp,
					       INDEX_RANGE     source_rows,
					       INDEX_RANGE     source_cols,
					       BASE_MATRIX_PTR target_matp,
					       INDEX_RANGE     target_rows,
					       INDEX_RANGE     target_cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_block_add						*/
/*......................................................................*/
/* function adds blocks of elements from two source base matrices and	*/
/* copies the result into a block of a result base matrix. Elements in  */
/* the result matrix are created if their new values are non-zero and 	*/
/* they previously didn't exist, destroyed if their new values are zero */
/* and they did previously exist 					*/
/*                                                                      */
/* source_1_matp	- in	- pointer to the source 1 base matrix	*/
/* source_1_rows	- in	- row range of source 1 element block	*/
/* source_1_cols	- in	- col range of source 1 element block	*/
/* source_2_matp	- in	- pointer to the source 2 base matrix	*/
/* source_2_rows	- in	- row range of source 2 element block	*/
/* source_2_cols	- in	- col range of source 2 element block	*/
/* result_matp		- in	- pointer to the result base matrix	*/
/* result_rows		- in	- row range of result element block 	*/
/* result_cols		- in	- col range result element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_block_add(BASE_MATRIX_PTR source_1_matp,
					 INDEX_RANGE	 source_1_rows,
					 INDEX_RANGE	 source_1_cols,
					 BASE_MATRIX_PTR source_2_matp,
					 INDEX_RANGE	 source_2_rows,
					 INDEX_RANGE	 source_2_cols,
					 BASE_MATRIX_PTR result_matp,
					 INDEX_RANGE     result_rows,
					 INDEX_RANGE     result_cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_block_subtract					*/
/*......................................................................*/
/* function differences blocks of elements from two source base matrices*/
/* and copies the result into a block of a result base matrix. Elements */
/* in the result matrix are created if their new values are non-zero and*/
/* they previously didn't exist, destroyed if their new values are zero */
/* and they did previously exist 					*/
/*                                                                      */
/* source_1_matp	- in	- pointer to the source 1 base matrix	*/
/* source_1_rows	- in	- row range of source 1 element block	*/
/* source_1_cols	- in	- col range of source 1 element block	*/
/* source_2_matp	- in	- pointer to the source 2 base matrix	*/
/* source_2_rows	- in	- row range of source 2 element block	*/
/* source_2_cols	- in	- col range of source 2 element block	*/
/* result_matp		- in	- pointer to the result base matrix	*/
/* result_rows		- in	- row range of result element block 	*/
/* result_cols		- in	- col range result element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_block_subtract(BASE_MATRIX_PTR source_1_matp,
					      INDEX_RANGE     source_1_rows,
					      INDEX_RANGE     source_1_cols,
					      BASE_MATRIX_PTR source_2_matp,
					      INDEX_RANGE     source_2_rows,
					      INDEX_RANGE     source_2_cols,
					      BASE_MATRIX_PTR result_matp,
					      INDEX_RANGE     result_rows,
					      INDEX_RANGE     result_cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_block_weighted_sum					*/
/*......................................................................*/
/* function computes the weighted sum of  blocks of elements from two   */
/* source base matrices and copies the result into a block of a result  */
/* base matrix. Elements in the result matrix are created if their new  */
/* values are non-zero and they previously didn't exist, destroyed if   */
/* their new values are zero and they did previously exist		*/
/*                                                                      */
/* source_1_matp	- in	- pointer to the source 1 base matrix	*/
/* source_1_rows	- in	- row range of source 1 element block	*/
/* source_1_cols	- in	- col range of source 1 element block	*/
/* weight_1		- in	- weight factor for matrix 1		*/
/* weight_1_type	- in	- GOTH_DATATYPE of the weight factor    */
/* source_2_matp	- in	- pointer to the source 2 base matrix	*/
/* source_2_rows	- in	- row range of source 2 element block	*/
/* source_2_cols	- in	- col range of source 2 element block	*/
/* weight_2		- in	- weight factor for matrix 2		*/
/* weight_2_type	- in	- GOTH_DATATYPE of the weight factor    */
/* result_matp		- in	- pointer to the result base matrix	*/
/* result_rows		- in	- row range of result element block 	*/
/* result_cols		- in	- col range result element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_block_weighted_sum(
					 BASE_MATRIX_PTR source_1_matp,
					 INDEX_RANGE	 source_1_rows,
					 INDEX_RANGE	 source_1_cols,
					 GOTH_VALUE	 weight_1,
				         GOTH_DATATYPE   weight_1_type,
					 BASE_MATRIX_PTR source_2_matp,
					 INDEX_RANGE	 source_2_rows,
					 INDEX_RANGE	 source_2_cols,
					 GOTH_VALUE	 weight_2,
					 GOTH_DATATYPE   weight_2_type,
					 BASE_MATRIX_PTR result_matp,
					 INDEX_RANGE     result_rows,
					 INDEX_RANGE     result_cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_block_multiply					*/
/*......................................................................*/
/* function matrix multiplies blocks of elements from two source base   */
/* matrices and copies the result into a block of a result base matrix. */
/* Elements in the result matrix are created if their new values are    */
/* non-zero and they previously didn't exist, destroyed if their new    */
/* values are zero and they did previously exist			*/
/*                                                                      */
/* source_1_matp	- in	- pointer to the source 1 base matrix	*/
/* source_1_rows	- in	- row range of source 1 element block	*/
/* source_1_cols	- in	- col range of source 1 element block	*/
/* source_2_matp	- in	- pointer to the source 2 base matrix	*/
/* source_2_rows	- in	- row range of source 2 element block	*/
/* source_2_cols	- in	- col range of source 2 element block	*/
/* result_matp		- in	- pointer to the result base matrix	*/
/* result_rows		- in	- row range of result element block 	*/
/* result_cols		- in	- col range result element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_block_multiply(BASE_MATRIX_PTR source_1_matp,
					      INDEX_RANGE     source_1_rows,
					      INDEX_RANGE     source_1_cols,
					      BASE_MATRIX_PTR source_2_matp,
					      INDEX_RANGE     source_2_rows,
					      INDEX_RANGE     source_2_cols,
					      BASE_MATRIX_PTR result_matp,
					      INDEX_RANGE     result_rows,
					      INDEX_RANGE     result_cols);



/*----------------------------------------------------------------------*/
/* Functions associated with matrix division, which can only partially  */
/* handle subsets of elements (at present)				*/
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_cholesky_decompose					*/
/*......................................................................*/
/* function computes the Cholesky decomposition of a symmetric matrix.	*/
/* Current version will only work with the full base matrices (source   */
/* and result), which must be square. Only the lower triangle of the 	*/
/* source block is used, no checks as to whether 'source' block is 	*/
/* symmetric or not. The result matrix may be the same as the source	*/
/* matrix, in which case the old lower factor of the matrix is		*/
/* overwritten								*/
/*                                                                      */
/* source_matp		- in	- pointer to the source base matrix	*/
/* source_rows		- in	- row range of source element block	*/
/* source_cols		- in	- col range of source element block	*/
/* result_matp		- in	- pointer to the result base matrix	*/
/* result_rows		- in	- row range of result element block 	*/
/* result_cols		- in	- col range result element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_cholesky_decompose(BASE_MATRIX_PTR source_matp,
						  INDEX_RANGE     source_rows,
						  INDEX_RANGE     source_cols,
						  BASE_MATRIX_PTR result_matp,
						  INDEX_RANGE     result_rows,
						  INDEX_RANGE     result_cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_left_lower_divide					*/
/*......................................................................*/
/* function computes the left division of a matrix by a lower triangular*/
/* matrix.								*/
/* Current version requires the divisor to be full range and square the	*/
/* numerator and result matrices to be full range in rows and have the  */
/* same number of columns (but not necessarily the same set of columns.	*/
/* No checks are made as to whether the divisor is purely lower         */
/* triangular. The result matrix may be the same as the numerator, in   */
/* which case the old matrix will be overwritten.			*/
/*                                                                      */
/* lower_matp		- in	- pointer to the denominator base matrix*/
/* lower_rows		- in	- row range of denominator element block*/
/* lower_cols		- in	- col range of denominator element block*/
/* numer_matp		- in	- pointer to the numerator base matrix	*/
/* numer_rows		- in	- row range of numerator element block	*/
/* numer_cols		- in	- col range of numerator element block	*/
/* result_matp		- in	- pointer to the result base matrix	*/
/* result_rows		- in	- row range of result element block 	*/
/* result_cols		- in	- col range result element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_left_lower_divide(BASE_MATRIX_PTR lower_matp,
						 INDEX_RANGE	 lower_rows,
						 INDEX_RANGE	 lower_cols,
						 BASE_MATRIX_PTR numer_matp,
						 INDEX_RANGE	 numer_rows,
						 INDEX_RANGE	 numer_cols,
						 BASE_MATRIX_PTR result_matp,
						 INDEX_RANGE	 result_rows,
						 INDEX_RANGE	 result_cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_left_upper_divide					*/
/*......................................................................*/
/* function computes the left division of a matrix by a upper triangular*/
/* matrix.								*/
/* Current version requires the divisor to be full range and square the	*/
/* numerator and result matrices to be full range in rows and have the  */
/* same number of columns (but not necessarily the same set of columns.	*/
/* No checks are made as to whether the divisor is purely upper         */
/* triangular. The result matrix may be the same as the numerator, in   */
/* which case the old matrix will be overwritten.			*/
/*                                                                      */
/* upper_matp		- in	- pointer to the denominator base matrix*/
/* upper_rows		- in	- row range of denominator element block*/
/* upper_cols		- in	- col range of denominator element block*/
/* numer_matp		- in	- pointer to the numerator base matrix	*/
/* numer_rows		- in	- row range of numerator element block	*/
/* numer_cols		- in	- col range of numerator element block	*/
/* result_matp		- in	- pointer to the result base matrix	*/
/* result_rows		- in	- row range of result element block 	*/
/* result_cols		- in	- col range result element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_left_upper_divide(BASE_MATRIX_PTR upper_matp,
						 INDEX_RANGE	 upper_rows,
						 INDEX_RANGE	 upper_cols,
						 BASE_MATRIX_PTR numer_matp,
						 INDEX_RANGE	 numer_rows,
						 INDEX_RANGE	 numer_cols,
						 BASE_MATRIX_PTR result_matp,
						 INDEX_RANGE	 result_rows,
						 INDEX_RANGE	 result_cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_check_left_divide					*/
/*......................................................................*/
/* function checks base matrix structures to see if left division is	*/
/* possible. 								*/
/* Current version requires the divisor to be full range and square the	*/
/* numerator and result matrices to be full range in rows and have the  */
/* same number of columns (but not necessarily the same set of columns.	*/
/*                                                                      */
/* denom_matp		- in	- pointer to the denominator base matrix*/
/* denom_rows		- in	- row range of denominator element block*/
/* denom_cols		- in	- col range of denominator element block*/
/* numer_matp		- in	- pointer to the numerator base matrix	*/
/* numer_rows		- in	- row range of numerator element block	*/
/* numer_cols		- in	- col range of numerator element block	*/
/* result_matp		- in	- pointer to the result base matrix	*/
/* result_rows		- in	- row range of result element block 	*/
/* result_cols		- in	- col range result element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_check_left_divide(BASE_MATRIX_PTR denom_matp,
						 INDEX_RANGE	 denom_rows,
						 INDEX_RANGE	 denom_cols,
						 BASE_MATRIX_PTR numer_matp,
						 INDEX_RANGE	 numer_rows,
						 INDEX_RANGE	 numer_cols,
						 BASE_MATRIX_PTR result_matp,
						 INDEX_RANGE	 result_rows,
						 INDEX_RANGE	 result_cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_check_block_copy					*/
/*......................................................................*/
/* function checks whether matrix element blocks are compatibile for    */
/* matrix copy operations						*/
/*                                                                      */
/* m_1_matp		- in	- pointer to the source 1 base matrix	*/
/* m_1_rows		- in	- row range of source 1 element block	*/
/* m_1_cols		- in	- col range of source 1 element block	*/
/* m_2_matp		- in	- pointer to the source 2 base matrix	*/
/* m_2_rows		- in	- row range of source 2 element block	*/
/* m_2_cols		- in	- col range of source 2 element block	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_check_block_copy(BASE_MATRIX_PTR m_1_matp,
						INDEX_RANGE     m_1_rows,
						INDEX_RANGE     m_1_cols,
						BASE_MATRIX_PTR m_2_matp,
						INDEX_RANGE     m_2_rows,
						INDEX_RANGE     m_2_cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_check_block_summation				*/
/*......................................................................*/
/* function checks whether matrix element blocks are compatibile for    */
/* matrix summation operations						*/
/*                                                                      */
/* m_1_matp		- in	- pointer to the first base matrix	*/
/* m_1_rows		- in	- row range of first element block	*/
/* m_1_cols		- in	- col range of first element block	*/
/* m_2_matp		- in	- pointer to the second base matrix	*/
/* m_2_rows		- in	- row range of second element block	*/
/* m_2_cols		- in	- col range of second element block	*/
/* m_3_matp		- in	- pointer to the third base matrix	*/
/* m_3_rows		- in	- row range of third element block 	*/
/* m_3_cols		- in	- col range third element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_check_block_summation(BASE_MATRIX_PTR m_1_matp,
						     INDEX_RANGE     m_1_rows,
						     INDEX_RANGE     m_1_cols,
						     BASE_MATRIX_PTR m_2_matp,
						     INDEX_RANGE     m_2_rows,
						     INDEX_RANGE     m_2_cols,
						     BASE_MATRIX_PTR m_3_matp,
						     INDEX_RANGE     m_3_rows,
						     INDEX_RANGE     m_3_cols);


/*----------------------------------------------------------------------*/
/* LOCAL base_matrix_check_block_multiply				*/
/*......................................................................*/
/* function checks whether matrix element blocks are compatibile for    */
/* matrix product operations						*/
/*                                                                      */
/* left_matp		- in	- pointer to the left base matrix	*/
/* left_rows		- in	- row range of left element block	*/
/* left_cols		- in	- col range of left element block	*/
/* right_matp		- in	- pointer to the right base matrix	*/
/* right_rows		- in	- row range of right element block	*/
/* right_cols		- in	- col range of right element block	*/
/* res_3_matp		- in	- pointer to the result base matrix	*/
/* res_3_rows		- in	- row range of result element block 	*/
/* res_3_cols		- in	- col range result element block 	*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS base_matrix_check_block_multiply(BASE_MATRIX_PTR left_matp,
						    INDEX_RANGE     left_rows,
						    INDEX_RANGE     left_cols,
						    BASE_MATRIX_PTR right_matp,
						    INDEX_RANGE     right_rows,
						    INDEX_RANGE     right_cols,
						    BASE_MATRIX_PTR res_matp,
						    INDEX_RANGE     res_rows,
						    INDEX_RANGE     res_cols);



/*----------------------------------------------------------------------*/
/* miscellaneous usefull functions					*/
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/* LOCAL set_result_value_and_go_right					*/
/*......................................................................*/
/*									*/
/* mep		- i/o	- On input ptr to the element to be set or its  */
/*			  nearest right neigbour, on exit ptr to the    */
/*			  nearest right neighbour of the element        */
/*									*/
/* value	- in	- value of the element to be set		*/
/*									*/
/* uep		- i/o	- On input ptr to the nearest upper neighbour of*/
/*			  the element to be set, defines the column     */
/*			  index of the element ( (*uep)->col ). Note one*/
/*			  must have (*uep)->col <= (*mep)->col (with the*/
/*			  exception of wrap round)			*/
/*			  On exit, *uep points to the upper neighbour   */
/*			  for the element at row (*mep)->row + 1, col   */
/*			  (*uep)->col					*/
/*----------------------------------------------------------------------*/
 
static GOTH_STATUS set_result_value_and_go_right(MATRIX_ELEMENT_PTR *mep,
						 GOTH_VALUE          value,
						 MATRIX_ELEMENT_PTR *uep);


/*----------------------------------------------------------------------*/
/* LOCAL define_matrix_block_upper_boundary				*/
/*......................................................................*/
/* function creates an array of pointers to matrix element ptrs which   */
/* define an upper (outer) boundary to a block of elements. Elements of */
/* the array define elements which lie on the boundary or just above it */
/*									*/
/* bnd		- out	- start of the ptr array			*/
/* bmatp	- in	- ptr to the base matrix structure		*/
/* rows		- in	- defines the row range of elements, 		*/
/*			  (row.index_min)			        */
/*			  defines the upper boundary of a block		*/
/* cols		- in	- defines the col range of elements		*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS define_matrix_block_upper_boundary(MATRIX_ELEMENT_PTR **bnd,
						      BASE_MATRIX_PTR   bmatp,
						      INDEX_RANGE        rows,
						      INDEX_RANGE        cols);


/*----------------------------------------------------------------------*/
/* LOCAL undefine_matrix_block_upper_boundary				*/
/*......................................................................*/
/* function frees memory associated with an array of element ptrs	*/
/*									*/
/* bd	- in	- ptr to start of array					*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS undefine_matrix_block_upper_boundary(MATRIX_ELEMENT_PTR *p);


#endif
#endif
/* $Header: /lslhome/gothic/hdr/matrixlib/v1-2/RCS/hdr.matrix_internals.h,v 1.3 1993/04/14 10:30:53 olivia Exp $								*/
/* 									*/
/* $Log: hdr.matrix_internals.h,v $
 * Revision 1.3  1993/04/14  10:30:53  olivia
 * Version v1-2 derived from v1-1
 * makefile converted to new format
 *
 * Revision 1.2  1992/07/13  16:33:02  davida
 * Version v1-1 derived from v1-0
 * Copes with NULL descriptors.
 *								*/
