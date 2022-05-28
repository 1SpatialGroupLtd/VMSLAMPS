/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:04:48.000000000 +0000
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
#ifndef _MATRIX_DEFNS
#define _MATRIX_DEFNS


/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Mike Cook, 21-Feb-1991					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		      M A T R I X _ D E F N S . H 			*/
/*									*/
/* Part of GOTHIC module MATRIXLIB					*/
/* Version 0.1, Mike Cook 21-Feb-1991					*/
/************************************************************************/

#include <matrix_typedefs.h>


/*----------------------------------------------------------------------*/
/* Useful MACROs for use with MATRIX operations				*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------*/
/* MACRO to execute a function and exit the           */
/* invoking function if a bad return code is received */
/*----------------------------------------------------*/

#define MATRIX_SAFE(op, txt)				\
{							\
   GOTH_STATUS status_macro = (op);			\
   if (status_macro != GOTH__NORMAL)			\
   {							\
      if (status_macro != GOTH__ERROR)			\
	 sch_stack_message(status_macro);		\
      sch_stack_message(GOTH__CALL, txt);		\
      return GOTH__ERROR;				\
   }							\
}


/*---------------------------------------------*/
/* MACRO for general function abort situations */
/*---------------------------------------------*/

#define MATRIX_ABORT(txt)				\
{							\
   sch_stack_message(GOTH__ABORT);			\
   sch_stack_string(txt);				\
   return GOTH__ABORT;					\
}


/*-----------------------------------*/
/* MACRO for general malloc failures */
/*-----------------------------------*/

#define MATRIX_MALLOC(txt)				\
{							\
   sch_stack_message(GOTH__MALLOC);			\
   sch_stack_string(txt);				\
   return GOTH__MALLOC;					\
}


/*---------------------------------------*/
/* MACRO for general descriptor failures */
/*---------------------------------------*/

#define MATRIX_DESC(txt)				\
{							\
   sch_stack_message(GOTH__DESC);			\
   sch_stack_string(txt);				\
   return GOTH__DESC;					\
}


/*-----------------------------------------*/
/* MACRO to test whether a GOTH_DESCRIPTOR */
/* is new and of type DDT_MATRIX           */
/*-----------------------------------------*/

#define NEW_MATRIX_DESCRIPTOR(desc)					\
{									\
   if((desc        == NULL) || ((desc)->type != DDT_MATRIX) || 		\
      ((desc)->sod != NULL) || ((desc)->refs != 0))			\
	MATRIX_DESC("descriptor is not a new MATRIX descriptor");	\
}


/*--------------------------------------------------*/
/* MACRO to test for a valid matrix goth_descriptor */
/* and then extract matrix substructure fields 	    */
/*--------------------------------------------------*/

#define GOOD_MATRIX_DESCRIPTOR(desc, matp, base_matp)		\
{								\
   if (desc                             == NULL        ||	\
       (desc)->type                     != DDT_MATRIX  || 	\
       (matp = (desc)->sod)             == NULL        || 	\
       (base_matp = (matp)->basematrix) == NULL)		\
	MATRIX_DESC("descriptor does not define a matrix");	\
}




/*----------------------------------------------------------------------*/
/* MACROs involving row/col indices of matrix elements			*/
/*----------------------------------------------------------------------*/


/*-----------------------------------------*/
/* define the index of the 'base' row/col, */
/* the index of the 1st valid row/col,     */
/* and a 'bad' index                       */
/*-----------------------------------------*/

#define BASE_INDEX			-1
#define BASE_INDEX_PLUS 		 1 + BASE_INDEX


/*---------------------------------------*/
/* MACRO to check that an index is valid */
/* (i.e. not less than the BASE_INDEX )  */
/*---------------------------------------*/

#define CHECK_INDEX(index)			\
{						\
   if ((index) < BASE_INDEX)			\
      MATRIX_ABORT("invalid row/column index");	\
}


/*-----------------------------------*/
/* MACRO to check that a row/col     */
/* index is within a specified range */
/*-----------------------------------*/

#define CHECK_INDEX_IN_RANGE(index, range) \
   (((index) >= (range).index_min) && ((index) <= (range).index_max))


/*---------------------------------*/
/* MACRO to compute the difference */
/* in index range limits           */
/*---------------------------------*/

#define RANGE_DIFFERENCE(range)  ((range).index_max - (range).index_min)


/*----------------------------*/
/* MACRO to check that two    */
/* index ranges are identical */
/*----------------------------*/

#define CHECK_SAME_RANGE(range1, range2) 		\
   (((range1).index_min == (range2).index_min) &&	\
    ((range1).index_max == (range2).index_max))


/*---------------------------------*/
/* MACRO to check two index ranges */
/* have identical 'lengths'        */
/*---------------------------------*/

#define CHECK_SAME_RANGE_DIFFERENCE(range1, range2) \
   (RANGE_DIFFERENCE(range1) == RANGE_DIFFERENCE(range2))


/*-------------------------------------*/
/* MACRO to convert relative (row,col) */
/* indices of a matrix into absolute   */
/* (row,col) indices for the matrix    */
/*-------------------------------------*/

#define SET_ABSOLUTE_MATRIX_INDICES(matp, t_row, t_col) \
{                                                       \
   t_row += (matp)->row.index_min;                      \
   t_col += (matp)->col.index_min;                      \
}


/*-------------------------------------*/
/* MACRO to convert absolute (row,col) */
/* indices of a matrix into relative   */
/* (row,col) indices for the matrix    */
/*-------------------------------------*/

#define SET_RELATIVE_MATRIX_INDICES(matp, t_row, t_col) \
{                                                       \
   t_row -= (matp)->row.index_min;                      \
   t_col -= (matp)->col.index_min;                      \
}


/*---------------------------------------------*/
/* MACRO to check that absolute (row,col)      */
/* indices lie within index limits of a matrix */
/*---------------------------------------------*/

#define CHECK_ABSOLUTE_MATRIX_INDICES(matp, t_row, t_col)  	            \
{                                                           		    \
   if ( t_row < (matp)->row.index_min || t_row > (matp)->row.index_max ||   \
        t_col < (matp)->col.index_min || t_col > (matp)->col.index_max )    \
      MATRIX_ABORT("invalid absolute row or column index");		    \
}


/*---------------------------------------------*/
/* MACRO to check that relative (row,col)      */
/* indices lie within index limits of a matrix */
/*---------------------------------------------*/

#define CHECK_RELATIVE_MATRIX_INDICES(matp, t_row, t_col)	              \
{                                                      			      \
   if ( t_row < 0 || t_row > (matp)->row.index_max - (matp)->row.index_min || \
        t_col < 0 || t_col > (matp)->col.index_max - (matp)->col.index_min )  \
      MATRIX_ABORT("invalid relative row or column index");		      \
}




/*----------------------------------------------------------------------*/
/* MACRO's involving MATRIX_ELEMENTS					*/
/*----------------------------------------------------------------------*/


/*------------------------*/
/* MATRIX_ELEMENT fields  */
/*------------------------*/

#define ELEMENT_ROW(mep)		(mep)->row
#define ELEMENT_COL(mep)		(mep)->col
	
#define ELEMENT_LEFT(mep)		(mep)->left
#define ELEMENT_RIGHT(mep)		(mep)->right
#define ELEMENT_UP(mep)			(mep)->up
#define ELEMENT_DOWN(mep)		(mep)->down

#define ELEMENT_GO_LEFT(mep)		(mep) = (mep)->left
#define ELEMENT_GO_RIGHT(mep)		(mep) = (mep)->right
#define ELEMENT_GO_UP(mep)		(mep) = (mep)->up
#define ELEMENT_GO_DOWN(mep)		(mep) = (mep)->down

#define ELEMENT_VALUE(mep)		(mep)->value
#define ELEMENT_REAL_VALUE(mep)		(mep)->value.real
#define ELEMENT_INTEGER_VALUE(mep)	(mep)->value.integer



/*---------------------------*/
/* MACRO to see if the       */
/* element data type is okay */
/*---------------------------*/

#define CHECK_DATA_TYPE(type)					\
{								\
   switch (type)						\
   {								\
   case DT_REAL:	/* data type is GOTH_REAL */		\
      break;							\
   default:		/* data type not (yet) supported */	\
      MATRIX_ABORT("unsupported data type");			\
   }								\
}


/*---------------------------*/
/* MACRO to see if the       */
/* matrix type is okay       */
/*---------------------------*/

#define CHECK_MATRIX_TYPE(type)					\
{								\
   switch (type)						\
   {								\
   case GENERAL_MATRIX:	/* matrix type is GENERAL_MATRIX */	\
      break;							\
   default:		/* matrix type not (yet) supported */	\
      MATRIX_ABORT("unsupported matrix type");			\
   }								\
}



/*---------------------------------------------------*/
/* MACRO to move along a matrix row until at a       */ 
/* specified column or at the nearest left neighbour */
/*---------------------------------------------------*/

#define ELEMENT_GOTO_COL_OR_LEFT(mep, t_col)                                  \
{                                                                             \
   GOTH_INTEGER c_col = (mep)->col;   /* column index of current element */   \
   GOTH_INTEGER n_col;		      /* column index of next element */      \
   MATRIX_ELEMENT_PTR n_mep;	      /* element to move to */                \
                                                                              \
   /*-----------------------------------------------------*/                  \
   /* move along the row designated by the matrix element */                  \
   /* 'mep' until at column 'col', or its nearest left    */                  \
   /* neighbour. Terminate loops when 'loop back occurs'  */                  \
   /*-----------------------------------------------------*/                  \
                                                                              \
   while ((c_col > t_col) && ((n_col = (n_mep = (mep)->left)->col) < c_col))  \
      mep = n_mep , c_col = n_col;      /* move to the left */		      \
	                                                                      \
   if (c_col > t_col)			/* error, should not happen */        \
      MATRIX_ABORT("corrupted matrix row");				      \
	                                                                      \
   while (((n_col = (n_mep = (mep)->right)->col) <= t_col) && (n_col > c_col))\
      mep = n_mep , c_col = n_col;	/* move to the right */		      \
                                                                              \
   if ((n_col <= c_col) && (n_col !=  BASE_INDEX))   /* shouldn't happen */   \
      MATRIX_ABORT("corrupted matrix row");				      \
}



/*----------------------------------------------------*/
/* MACRO to move along a matrix row until at a        */ 
/* specified column or at the nearest right neighbour */
/*----------------------------------------------------*/

#define ELEMENT_GOTO_COL_OR_RIGHT(mep, t_col)	\
{				 		\
   ELEMENT_GOTO_COL_OR_LEFT(mep, t_col);	\
   if ( (mep)->col != t_col )			\
      ELEMENT_GO_RIGHT(mep);			\
}



/*-------------------------------------------------*/
/* MACRO to move along a matrix column until at a  */ 
/* specified row or at the nearest above neighbour */
/*-------------------------------------------------*/

#define ELEMENT_GOTO_ROW_OR_ABOVE(mep, t_row)                                 \
{                                                                             \
   GOTH_INTEGER c_row = (mep)->row;   /* row index of current element */      \
   GOTH_INTEGER n_row;		      /* row index of next element */         \
   MATRIX_ELEMENT_PTR n_mep;	      /* element to move to */                \
                                                                              \
   /*-----------------------------------------------------*/                  \
   /* move along the col designated by the matrix element */                  \
   /* 'mep' until at row 'row', or its nearest above	  */                  \
   /* neighbour. Terminate loops when 'loop back occurs'  */                  \
   /*-----------------------------------------------------*/                  \
                                                                              \
   while ((c_row > t_row) && ((n_row = (n_mep = (mep)->up)->row) < c_row))    \
      mep = n_mep , c_row = n_row;      /* move upwards */		      \
	                                                                      \
   if (c_row > t_row)			/* error, should not happen */        \
      MATRIX_ABORT("corrupted matrix column");				      \
	                                                                      \
   while (((n_row = (n_mep = (mep)->down)->row) <= t_row) && (n_row > c_row)) \
      mep = n_mep , c_row = n_row;	/* move downwards */		      \
                                                                              \
   if ((n_row <= c_row) && (n_row !=  BASE_INDEX))   /* shouldn't happen */   \
      MATRIX_ABORT("corrupted matrix column");				      \
}


/*-------------------------------------------------*/
/* MACRO to move along a matrix column until at a  */ 
/* specified row or at the nearest neighbour below */
/*-------------------------------------------------*/

#define ELEMENT_GOTO_ROW_OR_BELOW(mep, t_row)	\
{				 		\
   ELEMENT_GOTO_ROW_OR_ABOVE(mep, t_row);	\
   if ( (mep)->row != t_row )			\
      ELEMENT_GO_DOWN(mep);			\
}




/*------------------------------------*/
/* MACRO to return the pointer to the */
/* 'base' element of a specified row  */
/*------------------------------------*/

#define ELEMENT_GOTO_ROW_BASE(matp, t_row, basep)	\
{							\
   basep = (matp)->baserow;				\
   ELEMENT_GOTO_ROW_OR_ABOVE(basep, t_row);		\
}


/*------------------------------------*/
/* MACRO to return the pointer to the */
/* 'base' element of a specified col  */
/*------------------------------------*/

#define ELEMENT_GOTO_COL_BASE(matp, t_col, basep)	\
{							\
   basep = (matp)->basecol;				\
   ELEMENT_GOTO_COL_OR_LEFT(basep, t_col);		\
}





#endif
/* $Header: /lslhome/gothic/hdr/matrixlib/v1-2/RCS/hdr.matrix_defns.h,v 1.3 1993/04/14 10:30:47 olivia Exp $								*/
/* 									*/
/* $Log: hdr.matrix_defns.h,v $
 * Revision 1.3  1993/04/14  10:30:47  olivia
 * Version v1-2 derived from v1-1
 * makefile converted to new format
 *
 * Revision 1.2  1992/07/13  16:32:56  davida
 * Version v1-1 derived from v1-0
 * Copes with NULL descriptors.
 *								*/
