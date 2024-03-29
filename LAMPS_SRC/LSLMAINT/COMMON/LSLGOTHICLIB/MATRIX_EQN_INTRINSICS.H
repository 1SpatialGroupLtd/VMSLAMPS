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
#ifndef _MATRIX_EQN_INTRINSICS
#define _MATRIX_EQN_INTRINSICS

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Mike Cook, 27-Feb-1991					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*	     M A T R I X _ E Q N _ I N T R I N S I C S . H 		*/
/*									*/
/* Part of GOTHIC module MATRIXLIB					*/
/* Version 0.1, Mike Cook 27-Feb-1991					*/
/************************************************************************/


/*----------------------------------------------------------------------*/
/* Include GOTHIC datatype typedefs					*/
/*----------------------------------------------------------------------*/

#include <goth_datatypes.h>



/*----------------------------------------------------------------------*/
/* Define the matrix_equation functions					*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_alloc		       				*/
/*......................................................................*/
/* Allocates a MATRIX_EQUATION descriptor block				*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_DESCRIPTOR matrix_equation_alloc();


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_free 		       				*/
/*......................................................................*/
/* Frees a MATRIX_EQUATION descriptor block (only if the		*/
/* GOTH_DESCRIPTOR is the correct type, the ->refs field is zero and	*/
/* ->sod field is NULL)			   	              		*/
/*                                                                      */
/* equation_id 	-in	- The descriptor block to free                  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_free(GOTH_DESCRIPTOR equation_id);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_create					*/
/*......................................................................*/
/*									*/
/* Builds a complete (ie consistent) matrix_equation and sets its	*/
/* GOTH_DESCRIPTOR, requires MATRIX type GOTH_DESCRIPTORS for the left  */
/* and right hand sides of the matrix equation.				*/
/*						 			*/
/* eqn_desc	- in	- GOTH_DESCRIPTOR for the MATRIX_EQUATION struc	*/
/* lhs_desc	- in	- GOTH_DESCRIPTOR for the lhs MATRIX structure	*/
/* rhs_desc	- in	- GOTH_DESCRIPTOR for the rhs MATRIX structure	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_create(GOTH_DESCRIPTOR eqn_desc,
					  GOTH_DESCRIPTOR lhs_desc,
					  GOTH_DESCRIPTOR rhs_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_delete					*/
/*......................................................................*/
/* Deallocates the memory associated with a MATRIX_EQUATION structure	*/
/* if the GOTH_DESCRIPTOR reference count is zero, otherwise decrements */
/* the reference count by one. In the former case the ->sod field is	*/
/* set to NULL to prevent referencing					*/
/* 									*/
/* eqn_desc	- in	- GOTH_DESCRIPTOR for the matrix equation     	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_delete(GOTH_DESCRIPTOR eqn_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_build						*/
/*......................................................................*/
/* Allocates and returns a MATRIX_EQUATION GOTH_DESCRIPTOR and builds a */
/* complete MATRIX_EQUATION structure to go with it.			*/ 
/*						 			*/
/* eqn_desc	- out	- GOTH_DESCRIPTOR for the MATRIX_EQUATION struc	*/
/* lhs_desc	- in	- GOTH_DESCRIPTOR for the lhs MATRIX structure	*/
/* rhs_desc	- in	- GOTH_DESCRIPTOR for the rhs MATRIX structure	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_build(GOTH_DESCRIPTOR *eqn_desc,
					 GOTH_DESCRIPTOR  lhs_desc,
					 GOTH_DESCRIPTOR  rhs_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_demolish					*/
/*......................................................................*/
/* Deallocates the memory associated with a MATRIX_EQUATION type	*/
/* GOTH_DESCRIPTOR, including its MATRIX and BASE_MATRIX substructures	*/
/*									*/
/* eqn_desc	- in	- GOTH_DESCRIPTOR for the matrix equation     	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_demolish(GOTH_DESCRIPTOR eqn_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_set_lhs					*/
/*......................................................................*/
/* function sets the lhs field of a MATRIX_EQUATION structure. Requires */
/* valid (non-empty) GOTH_DESCRIPTORS for the MATRIX_EQUATION structure */
/* and the lhs MATRIX structure. Note, if the MATRIX_EQUATION already   */
/* has a lhs entry, then the old entry is 'deleted'			*/
/*									*/
/* eqn_desc	- in	- GOTH_DESCRIPTOR for the MATRIX_EQUATION struc */
/* lhs_desc	- in	- GOTH_DESCRIPTOR for the lhs MATRIX structure	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_set_lhs(GOTH_DESCRIPTOR eqn_desc,
					   GOTH_DESCRIPTOR lhs_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_set_rhs					*/
/*......................................................................*/
/* function sets the rhs field of a MATRIX_EQUATION structure. Requires */
/* valid (non-empty) GOTH_DESCRIPTORS for the MATRIX_EQUATION structure */
/* and the rhs MATRIX structure. Note, if the MATRIX_EQUATION already   */
/* has a rhs entry, then the old entry is 'deleted'			*/
/*									*/
/* eqn_desc	- in	- GOTH_DESCRIPTOR for the MATRIX_EQUATION struc */
/* rhs_desc	- in	- GOTH_DESCRIPTOR for the rhs MATRIX structure	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_set_rhs(GOTH_DESCRIPTOR eqn_desc,
					   GOTH_DESCRIPTOR rhs_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_get_lhs					*/
/*......................................................................*/
/* function returns the GOTH_DESCRIPTOR of the lhs field of a		*/
/* MATRIX_EQUATION structure, and increments its reference count. 	*/
/*									*/
/* eqn_desc	- in	- GOTH_DESCRIPTOR for the MATRIX_EQUATION struc */
/* lhs_desc	- out	- GOTH_DESCRIPTOR for the lhs MATRIX structure  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_get_lhs(GOTH_DESCRIPTOR  eqn_desc,
					   GOTH_DESCRIPTOR *lhs_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_get_rhs					*/
/*......................................................................*/
/* function returns the GOTH_DESCRIPTOR of the rhs field of a		*/
/* MATRIX_EQUATION structure, and increments its reference count. 	*/
/*									*/
/* eqn_desc	- in	- GOTH_DESCRIPTOR for the MATRIX_EQUATION struc */
/* rhs_desc	- out	- GOTH_DESCRIPTOR for the rhs MATRIX structure  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_get_rhs(GOTH_DESCRIPTOR  eqn_desc,
					   GOTH_DESCRIPTOR *rhs_desc);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_set_weight					*/
/*......................................................................*/
/* function sets the weight matrix field of a MATRIX_EQUATION structure.*/
/* Requires valid (non-empty) GOTH_DESCRIPTORS for the MATRIX_EQUATION  */
/* structure and the weight MATRIX structure. Note, if the 		*/
/* MATRIX_EQUATION already has a weight matrix entry, then the old entry*/
/* is 'deleted'								*/
/*									*/
/* eqn_desc	- in	- GOTH_DESCRIPTOR for the MATRIX_EQUATION struc */
/* weight_desc	- in	- GOTH_DESCRIPTOR for the weight MATRIX struct	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_set_weight(GOTH_DESCRIPTOR eqn_desc,
					      GOTH_DESCRIPTOR weight_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_get_weight					*/
/*......................................................................*/
/* function returns the GOTH_DESCRIPTOR of the weight field of a	*/
/* matrix_equation structure, and increments its reference count. 	*/
/*									*/
/* eqn_desc	- in	- GOTH_DESCRIPTOR for the matrix_equation struc */
/* weight_desc	- out	- GOTH_DESCRIPTOR for the weight matrix struct  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_get_weight(GOTH_DESCRIPTOR  eqn_desc,
					      GOTH_DESCRIPTOR *weight_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_display					*/
/*......................................................................*/
/* function displays a matrix equation			                */
/*                                                                      */
/* stream	- in	- output stream descriptor			*/
/* eqn_desc	- in	- GOTH_DESCRIPTOR of the matrix			*/
/* comment	- in	- a 'comment' string for output			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_display(GOTH_DESCRIPTOR stream,
					   GOTH_DESCRIPTOR eqn_desc,
					   GOTH_STRING     comment);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_skeleton					*/
/*......................................................................*/
/* function displays the skeleton of a matrix equation	                */
/*                                                                      */
/* stream	- in	- output stream descriptor			*/
/* eqn_desc	- in	- GOTH_DESCRIPTOR of the matrix			*/
/* comment	- in	- a 'comment' string for output			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_skeleton(GOTH_DESCRIPTOR stream,
					    GOTH_DESCRIPTOR eqn_desc,
					    GOTH_STRING     comment);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_normalize					*/
/*......................................................................*/
/* function normalizes the matrices associated with a matrix equation,	*/
/* and stores the normalized matrices in a newly created matrix_equation*/
/* structure.								*/
/*									*/
/* if the matrix equation is    A*X = B    with no weight matrix, the 	*/
/* normalized equation is  (A'*A)*X = A'*B where ' represents the	*/
/* tranpose operation.							*/
/*									*/
/* if a weight matrix W exists, the normalized matrix equation is	*/
/* (A'*W*A)*X = A'*W*B							*/
/*									*/
/* note W, if present, must be square					*/
/*									*/
/* source_eqn_desc	- in	- GOTH_DESCRIPTOR of the source matrix	*/
/*				  equation				*/
/* target_eqn_desc	- out	- GOTH_DESCRIPTOR of the normalized	*/
/*				  matrix equation			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_normalize(GOTH_DESCRIPTOR  source_eqn_desc,
					     GOTH_DESCRIPTOR *target_eqn_desc);


/*----------------------------------------------------------------------*/
/* EXTERN matrix_equation_solve						*/
/*......................................................................*/
/* Function solves a matrix equation by least squares (min 2 norm)	*/
/* techniques and stores the solution in the rhs component of a newly	*/
/* created MATRIX_EQUATION structure. The GOTH_DESCRIPTOR of this new	*/
/* structure is returned via the argument list				*/
/*									*/
/* Current version impliments an optional weight matrix			*/
/* (via matrix_equation_normalize)					*/
/*									*/
/* source_eqn_desc	- in	- GOTH_DESCRIPTOR of the source matrix	*/
/*				  equation				*/
/* soln_desc		- out	- GOTH_DESCRIPTOR of the solution matrix*/
/* chol_desc		- out	- GOTH_DESCRIPTOR of the Cholesky	*/
/*				  decomposition of the normalized lhs	*/
/*				  matrix				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_equation_solve(GOTH_DESCRIPTOR  eqn_desc,
					 GOTH_DESCRIPTOR *soln_desc,
					 GOTH_DESCRIPTOR *chol_desc);




/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/* MATRIX_EQUATION inquiry routines					*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* EXTERN matrix_eqn_inquire_is_valid					*/
/*......................................................................*/
/* function determines whether a GOTH_DESCRIPTOR is of type 		*/
/* DDT_MATRIX_EQUATION 							*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR to be tested			*/
/* valid	- out	- BOOLEAN flag, true if the descriptor is of	*/
/*			  type DDT_MATRIX_EQUATION			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_eqn_inquire_is_valid(
					       GOTH_DESCRIPTOR desc,
					       GOTH_BOOLEAN   *valid);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_eqn_inquire_is_defined					*/
/*......................................................................*/
/* function determines whether a GOTH_DESCRIPTOR defines a 		*/
/* MATRIX_EQUATION 							*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR to be tested			*/
/* defined	- out	- BOOLEAN flag, true if the GOTH_DESCRIPTOR 	*/
/*			  defines a valid matrix equation		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_eqn_inquire_is_defined(GOTH_DESCRIPTOR desc,
						 GOTH_BOOLEAN   *defined);




/*----------------------------------------------------------------------*/
/* EXTERN matrix_eqn_inquire_num_lhs_rows				*/
/*......................................................................*/
/* function returns the number of rows in the lhs component of a matrix */
/* equation								*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix			*/
/* rows		- out	- number of rows in the lhs matrix		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_eqn_inquire_num_lhs_rows(
						   GOTH_DESCRIPTOR desc,
						   GOTH_INTEGER   *rows);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_eqn_inquire_num_rhs_rows				*/
/*......................................................................*/
/* function returns the number of rows in the rhs component of a matrix */
/* equation								*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix			*/
/* rows		- out	- number of rows in the rhs matrix		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_eqn_inquire_num_rhs_rows(
						   GOTH_DESCRIPTOR desc,
						   GOTH_INTEGER   *rows);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_eqn_inquire_num_lhs_cols				*/
/*......................................................................*/
/* function returns the number of columns in the lhs component of a 	*/
/* matrix equation							*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix			*/
/* cols		- out	- number of columns in the lhs matrix		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_eqn_inquire_num_lhs_cols(
						   GOTH_DESCRIPTOR  desc,
						   GOTH_INTEGER    *cols);



/*----------------------------------------------------------------------*/
/* EXTERN matrix_eqn_inquire_num_rhs_cols				*/
/*......................................................................*/
/* function returns the number of columns in the rhs component of a 	*/
/* matrix equation							*/
/*									*/
/* desc		- in	- GOTH_DESCRIPTOR of the matrix			*/
/* cols		- out	- number of columns in the rhs matrix		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS matrix_eqn_inquire_num_rhs_cols(
						   GOTH_DESCRIPTOR  desc,
						   GOTH_INTEGER    *cols);




#endif
/* $Header: /lslhome/gothic/hdr/matrixlib/v1-2/RCS/hdr.matrix_eqn_intrinsics.h,v 1.3 1993/04/14 10:30:50 olivia Exp $								*/
/* 									*/
/* $Log: hdr.matrix_eqn_intrinsics.h,v $
 * Revision 1.3  1993/04/14  10:30:50  olivia
 * Version v1-2 derived from v1-1
 * makefile converted to new format
 *
 * Revision 1.2  1992/07/13  16:32:59  davida
 * Version v1-1 derived from v1-0
 * Copes with NULL descriptors.
 *								*/
