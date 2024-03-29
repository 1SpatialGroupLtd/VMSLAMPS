/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:24:00.000000000 +0000
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
#ifndef _UTIL_DEFNS
#define _UTIL_DEFNS

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    DJ Allen,  5-May-1992					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*			U T I L _ D E F N S . H 			*/
/*									*/
/* Part of GOTHIC module UTILLIB					*/
/* Version 0.1, DJ Allen  5-May-1992					*/
/************************************************************************/


/*----------------------------------------------------------------------*/
/* GOTHIC stuff								*/
/*----------------------------------------------------------------------*/

#include "goth_datatypes.h"
#include "goth_config.h"
#include "gothic_status_codes.h"




/*----------------------------------------------------------------------*/
/* MACRO UTIL_DO							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes a generic operation (e.g. function call) which 	*/
/* returns a status code. If the returned status code is not 		*/
/* GOTH__NORMAL, the macro outputs a set of error messages and sets the */
/* argument <<status>> to the returned code value.			*/
/*									*/
/* MACRO is now a wrapper for the SCHLIB MACRO: SCH_DO. It is kept	*/
/* because several SMART/IGIS (image classification) modules make use	*/
/* of it.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* status	- Exterior status code which may be updated.		*/
/*									*/
/* op		- Generic operation returning a status code.		*/
/*									*/
/* txt		- Error message associated with the operation. 		*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

#define UTIL_DO(status, op, txt) SCH_DO(status, op, txt)





/*----------------------------------------------------------------------*/
/* MACRO UTIL_CONDITIONAL						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes a generic operation (e.g. function call), which 	*/
/* returns a status code, if an existing status code <<status>>		*/
/* is GOTH__NORMAL.	 						*/
/*									*/
/* Note, if the operation is executed and returns a bad status code,	*/
/* the macro will output a set of error messages and set <<status>> to 	*/
/* the bad code value.							*/
/* Note, this MACRO is a wrapper for SCH_DO_IF_NOT_OKAY()		*/
/*									*/
/* MACRO is now a wrapper for the SCHLIB MACRO: SCH_COND. It is kept	*/
/* because several SMART/IGIS (image classification) modules make use	*/
/* of it.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* status	- Exterior status code which may be updated.		*/
/*									*/
/* op		- Generic operation returning a status code.		*/
/*									*/
/* txt		- Error message associated with the operation. 		*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

#define UTIL_CONDITIONAL(status, op, txt) SCH_COND(status, op, txt)





/*----------------------------------------------------------------------*/
/* MACRO UTIL_CHECK							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes a generic operation (e.g. function call) which 	*/
/* returns a status code. If the returned code is not GOTH__NORMAL, the	*/
/* MACRO outputs some error messages to the message stack and then 	*/
/* exits the enclosing function, returning the bad status code.		*/
/*									*/
/* MACRO is now a wrapper for the SCHLIB MACRO: SCH_COND. It is kept	*/
/* because several SMART/IGIS (image classification) modules make use	*/
/* of it.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* op		- Generic operation returning a status code.		*/
/*									*/
/* txt		- Error message associated with the operation. 		*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* Status returned by <<op>> if not GOTH__NORMAL.			*/
/*									*/
/*----------------------------------------------------------------------*/

#define UTIL_CHECK(op, txt) SCH_CHECK2(op, txt)




/*----------------------------------------------------------------------*/
/* MACRO UTIL_FREE							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Macro for freeing a block of memory. Macro sets the freed pointer to	*/
/* NULL after freeing the memory block. NULL pointers are ignored by	*/
/* the MACRO								*/
/*									*/
/* MACRO is now a wrapper for the GOTHLIB MACRO: goth_safe_free. It is 	*/
/* because several SMART/IGIS (image classification) modules make use	*/
/* of it.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* ptr 		- pointer to memory block to be freed			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/


#define UTIL_FREE(ptr) goth_safe_free(ptr)




/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/* GOTH_DESCRIPTOR checks						*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/*  MACRO UTIL_DESCRIPTOR_IS_TYPE					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Macro returns TRUE descriptor exists and is the required type, FALSE	*/
/* otherwise								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* dsc	- in	- descriptor						*/
/* ddt	- in	- required type of descriptor				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* TRUE		- descriptor exists and is the required type		*/
/* FALSE	- otherwise						*/
/*									*/
/*----------------------------------------------------------------------*/

#define UTIL_DESCRIPTOR_IS_TYPE(dsc, ddt)		\
(((dsc) != NULL) && ((dsc)->type == ddt))		\



/*----------------------------------------------------------------------*/
/*  MACRO UTIL_DESCRIPTOR_IS_EMPTY					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Macro returns TRUE descriptor exists, is the required type, but	*/
/* has a NULL SOD pointer, FALSE otherwise				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* dsc	- in	- descriptor						*/
/* ddt	- in	- required type of descriptor				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* TRUE		- descriptor exists, is the required type, and NULL sod	*/
/* FALSE	- otherwise						*/
/*									*/
/*----------------------------------------------------------------------*/

#define UTIL_DESCRIPTOR_IS_EMPTY(dsc, ddt)			\
(UTIL_DESCRIPTOR_IS_TYPE(dsc, ddt) &&  				\
((dsc)->sod == NULL) && ((dsc)->refs == 0))			\



/*----------------------------------------------------------------------*/
/*  MACRO UTIL_DESCRIPTOR_IS_DEFINED					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Macro returns TRUE descriptor exists, is the required type, the SOD	*/
/* exists (i.e. not NULL) and the reference count is non-negative,	*/
/* FALSE otherwise. MACRO also returns the SOD field			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* dsc	- in	- descriptor						*/
/* ddt	- in	- required type of descriptor				*/
/* obj	- out	- SOD pointer 						*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* TRUE		- descriptor exists, is the required type, sod defined	*/
/*		  and the reference count >= 0				*/
/* FALSE	- otherwise						*/
/*									*/
/*----------------------------------------------------------------------*/

#define UTIL_DESCRIPTOR_IS_DEFINED(dsc, ddt, obj)		\
(UTIL_DESCRIPTOR_IS_TYPE(dsc, ddt) &&  	          		\
(((obj) = (dsc)->sod) != NULL) && ((dsc)->refs >= 0))		\




/*----------------------------------------------------------------------*/
/*  MACRO UTIL_CHECK_DESCRIPTOR_EMPTY					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Macro checks if a descriptor exists, is the required type, and the	*/
/* SOD is NULL (undefined). If this is not the case, the MACRO exits 	*/
/* the enclosing function with a GOTH__DESC return code			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* dsc	- in	- descriptor						*/
/* ddt	- in	- required type of descriptor				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__DESC	- if the descriptor doesn't satisfy the checks		*/
/*									*/
/*----------------------------------------------------------------------*/

#define UTIL_CHECK_DESCRIPTOR_EMPTY(desc, ddt)				\
{									\
   if ( !UTIL_DESCRIPTOR_IS_EMPTY(desc, ddt) )				\
   {									\
      SCH_STACK_STRING("descriptor is not new or the correct type");	\
      SCH_RETURN(GOTH__DESC);						\
   }									\
}									\



/*----------------------------------------------------------------------*/
/*  MACRO UTIL_CHECK_DESCRIPTOR_DEFINED					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Macro checks if a descriptor exists, is the required type, the SOD	*/
/* exists (i.e. not NULL) and the reference count is non-negative.	*/
/* If this is the case, the MACRO returns the SOD pointer. If not, the	*/
/* MACRO exits the enclosing function with a GOTH__DESC return code	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* dsc	- in	- descriptor						*/
/* ddt	- in	- required type of descriptor				*/
/* obj	- out	- SOD pointer 						*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__DESC	- if the descriptor doesn't satisfy the checks		*/
/*									*/
/*----------------------------------------------------------------------*/

#define UTIL_CHECK_DESCRIPTOR_DEFINED(desc, ddt, obj)			\
{									\
   if ( !UTIL_DESCRIPTOR_IS_DEFINED(desc, ddt, obj) )			\
   {									\
      SCH_STACK_STRING("bad descriptor or invalid descriptor type");	\
      SCH_RETURN(GOTH__DESC);						\
   }									\
}



/*----------------------------------------------------------------------*/
/*  MACRO UTIL_MALLOC							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This MACRO, calls malloc with _size_, check to see if the result is	*/
/* NULL, if so, it  exits the enclosing function with a GOTH__MALLOC.   */ 
/* And sets _address_ to result of the malloc, after casting it to      */
/* _type_, _type_ should be the type of _address_.   	      		*/
/*									*/
/* e.g.  UTIL_MALLOC(strlen(string1)+1, char *, string2)		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* _size_	-in-   The size to give to malloc.			*/
/* _type_	-in-   Type type of _address_.				*/
/* _address_    -out-  The allocated memory.				*/
/*----------------------------------------------------------------------*/

#define UTIL_MALLOC(_size_, _type_, _address_)\
do\
  {\
     VOID_P __result__;\
     GOTH_INTEGER __size__;\
     \
     __size__ = _size_;\
     __result__ = malloc(__size__);\
     (_address_) = (_type_) __result__;\
     \
     if (__result__ == NULL)\
     {\
	SCH_STACK_STRING("Malloc request for %d failed", __size__);\
	SCH_RETURN(GOTH__MALLOC);\
     }\
  }\
while(FALSE)

/* $Header: /gothic/RCSroot/utillib/RCS/RCS/hdr.util_defns.h,v 1.7 1995/01/15 21:18:14 jon Exp $								*/
#endif
