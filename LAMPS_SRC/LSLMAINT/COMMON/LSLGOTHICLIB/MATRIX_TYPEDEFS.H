/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:04:56.000000000 +0000
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
#ifndef _MATRIX_TYPEDEFS
#define _MATRIX_TYPEDEFS

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Mike Cook, 21-Feb-1991					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		   M A T R I X _ T Y P E D E F S . H 			*/
/*									*/
/* Part of GOTHIC module MATRIXLIB					*/
/* Version 0.1, Mike Cook 21-Feb-1991					*/
/************************************************************************/


/*----------------------------------------------------------------------*/
/* Include the GOTHIC datatype typedefs					*/
/*----------------------------------------------------------------------*/

#include <goth_datatypes.h>


/*----------------------------------------------------------------------*/
/* Enumerated matrix types						*/
/*----------------------------------------------------------------------*/

typedef enum { GENERAL_MATRIX } MATRIX_TYPE, *MATRIX_TYPE_PTR;

typedef enum { ALONG_ROWS, DOWN_COLUMNS } ELEMENT_SEARCH_METHOD;



/*----------------------------------------------------------------------*/
/* MATRIXLIB structure typedefs						*/
/*----------------------------------------------------------------------*/


typedef struct index_range		/* range of index values */
{
   GOTH_INTEGER index_min;	     	/* minimum value for the index */
   GOTH_INTEGER index_max;		/* maximum value for the index */
} INDEX_RANGE, *INDEX_RANGE_PTR;


typedef struct matrix_element *MATRIX_ELEMENT_PTR;

typedef struct matrix_element		/* matrix element/node structure */
{
   GOTH_VALUE 	      value;		/* element value, can be any type */
   GOTH_INTEGER       row;		/* row index of the element */
   GOTH_INTEGER	      col;		/* column index of the element */
   MATRIX_ELEMENT_PTR left;		/* ptr to nearest left neighbour */
   MATRIX_ELEMENT_PTR right;		/* ptr to nearest right neighbour */
   MATRIX_ELEMENT_PTR up;		/* ptr to nearest above neighbour */
   MATRIX_ELEMENT_PTR down;		/* ptr to nearest below neighbour */ 
} MATRIX_ELEMENT;


typedef struct base_matrix		/* base matrix structure */
{
   GOTH_INTEGER          ref_count;	/* count of references to this struc */
   GOTH_INTEGER          num_rows;	/* number of (defined) rows */
   GOTH_INTEGER          num_cols;	/* number of (defined) columns */
   GOTH_BOOLEAN          expandable;	/* allow matrix to expand ? */
   MATRIX_TYPE		 matrix_type;	/* type of matrix */
   GOTH_DATATYPE	 data_type;	/* type of element values */
   MATRIX_ELEMENT_PTR    baserow;	/* ptr to 'baserow' structure */
   MATRIX_ELEMENT_PTR    basecol;	/* ptr to 'basecol' structure */
} BASE_MATRIX, *BASE_MATRIX_PTR;


typedef struct matrix			/* top level matrix structure */
{
   INDEX_RANGE	   row;			/* row index range structure */
   INDEX_RANGE     col;			/* column index range structure */
   GOTH_BOOLEAN	   is_submatrix;	/* is matrix a sub-matrix ? */
   BASE_MATRIX_PTR basematrix;		/* ptr to the 'base' matrix structure*/
} MATRIX, *MATRIX_PTR;


typedef struct matrix_equation		/* matrix equation structure */
{
   GOTH_DESCRIPTOR lhs;			/* lhs matrix */
   GOTH_DESCRIPTOR rhs;			/* rhs matrix */
   GOTH_DESCRIPTOR weight;		/* optional weight matrix */
} MATRIX_EQUATION, *MATRIX_EQUATION_PTR;

#endif
/* $Header: /lslhome/gothic/hdr/matrixlib/v1-2/RCS/hdr.matrix_typedefs.h,v 1.3 1993/04/14 10:30:58 olivia Exp $								*/
/* 									*/
/* $Log: hdr.matrix_typedefs.h,v $
 * Revision 1.3  1993/04/14  10:30:58  olivia
 * Version v1-2 derived from v1-1
 * makefile converted to new format
 *
 * Revision 1.2  1992/07/13  16:33:09  davida
 * Version v1-1 derived from v1-0
 * Copes with NULL descriptors.
 *								*/
