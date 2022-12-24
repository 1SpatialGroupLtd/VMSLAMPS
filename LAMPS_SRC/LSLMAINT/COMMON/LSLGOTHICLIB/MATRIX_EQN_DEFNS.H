/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:04:50.000000000 +0000
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
#ifndef _MATRIX_EQN_DEFNS
#define _MATRIX_EQN_DEFNS
#ifndef _MATRIX_EQUATION_DEFNS
#define _MATRIX_EQUATION_DEFNS

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Mike Cook, 26-Feb-1991					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		  M A T R I X _ E Q N _ D E F N S . H 			*/
/*									*/
/* Part of GOTHIC module MATRIXLIB					*/
/* Version 0.1, Mike Cook 26-Feb-1991					*/
/************************************************************************/


/*----------------------------------------------------------------------*/
/* Include GOTHIC data and descriptor types, and MATRIXLIB #define's	*/
/*----------------------------------------------------------------------*/

#include <ddt_enum.h>
#include <goth_datatypes.h>
#include <matrix_defns.h>


/*----------------------------------------------------------------------*/
/* Useful MACRO's for use with matrix_equation related operations	*/
/*----------------------------------------------------------------------*/


/*---------------------------------------------*/
/* MACRO for testing whether a GOTH_DESCRIPTOR */
/* is new and of type DDT_MATRIX_EQUATION      */
/*---------------------------------------------*/

#define NEW_MATRIX_EQUATION_DESCRIPTOR(desc)				\
{									\
   if((desc        == NULL) || ((desc)->type != DDT_MATRIX_EQUATION) || \
      ((desc)->sod != NULL) || ((desc)->refs != 0))			\
      MATRIX_DESC("descriptor is not a new MATRIX_EQUATION descriptor");\
}



/*---------------------------------*/
/* Macro for testing for a valid   */
/* MATRIX_EQUATION GOTH_DESCRIPTOR */
/*---------------------------------*/

#define GOOD_MATRIX_EQUATION_DESCRIPTOR(desc, eqnp)			\
{									\
   if (desc                 == NULL                ||			\
       (desc)->type         != DDT_MATRIX_EQUATION ||			\
       (eqnp = (desc)->sod) == NULL )					\
      MATRIX_DESC("descriptor does not define a matrix_equation");	\
}



/*-------------------------------------*/
/* MACRO for deleting (detaching) a    */
/* MATRIX element of a MATRIX_EQUATION */
/*-------------------------------------*/

#define MATRIX_EQUATION_ELEMENT_DELETE(desc)	\
{						\
   if (desc != NULL)				\
   {                                            \
      MATRIX_SAFE( matrix_demolish(desc),	\
		  "matrix_demolish");		\
      desc = NULL;				\
   }						\
}


#endif
/* $Header: /lslhome/gothic/hdr/matrixlib/v1-2/RCS/hdr.matrix_eqn_defns.h,v 1.3 1993/04/14 10:30:48 olivia Exp $								*/
/* 									*/
/* $Log: hdr.matrix_eqn_defns.h,v $
 * Revision 1.3  1993/04/14  10:30:48  olivia
 * Version v1-2 derived from v1-1
 * makefile converted to new format
 *
 * Revision 1.2  1992/07/13  16:32:58  davida
 * Version v1-1 derived from v1-0
 * Copes with NULL descriptors.
 *								*/
#endif
