/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:45:34.000000000 +0000
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
#ifndef _COLN_DEFNS
#define _COLN_DEFNS
/* $Header: /lslhome/gothic/hdr/colnlib/v1-6/RCS/hdr.coln_defns.h,v 1.7 1994/02/16 20:45:26 jon Exp $								*/
/* 									*/
/* $Log: hdr.coln_defns.h,v $
 * Revision 1.7  1994/02/16  20:45:26  jon
 * Version v1-6 derived from v1-5
 * WICC 146.
 *
 * Extracted to implement coln_get_element_value() which allows the user to
 * fetch the element with the value 'value'. This sounds bizarre but when working
 * with DT_USER user defined types this allows partial matching of data and is
 * highly useful when coding the new VADERLIB routines also described by WICC 146.
 *
 * Added routines `coln_remove_collection()' and `coln_combine_existing_set()'.
 * The latter does not yet work if the output set is the same as one of its input
 * sets.
 *
 * Revision 1.6  1993/09/21  16:24:09  jon
 * Version v1-5 derived from v1-4
 * See Gothic WICC 125
 *
 * Fix routine which applies a Lull callable callback to a dictionary.
 *
 * This version of COLNLIB has received no formal testing - it is not
 * to be included in any products which are to be shipped without
 * further attention.
 *
 * Revision 1.5  1993/07/14  12:36:23  davidr
 * Version v1-4 derived from v1-3
 * Extracted to develop ability to traverse a collection appyling a Lull
 * callable callback to all the elements.
 *
 * Revision 1.4  1993/01/15  15:17:21  snail
 * Version v1-3 derived from v1-2
 * Extracted to fix a bug in coln_get_value_of_dict_value() where agoth_value_copy
 * Extracted to fix a bug in coln_get_value_of_dict_value() where a
 * goth_value_copy() has been used instead of goth_value_insert(). Only fails
 * with strings, but does cause a seg fault when it fails.
 *
 * Revision 1.3  1992/11/30  12:35:03  snail
 * Version v1-2 derived from v1-1
 * Addition of a routine to allow a list of GOTH_VALUEs to be sorted.
 * Addition of coln_merge_collections(). This routine is used to merge two
 * collections to form one collection. One of the source collections is also the
 * destination collection. The collections do not need to be the same type of
 * collection, although the datatype(s) handled by the collections do need to be
 * the same.
 * Fixing of memory leaks in coln_combine_set(). This memory leak was very hard
 * to track. Do not change the code in combine_set() unless you are sure what you
 * are doing. Some of it looks like it can obviously be simplified. I tried, and
 * leaks appeared from nowhere. Leave it as it is. It is now fixed. This should
 * give a performance increase for Adrians demographic analysis type applications.
 *
 * Revision 1.2  1992/08/19  17:26:43  snail
 * Version v1-1 derived from v1-0
 * Addition of gen_register_destroy() call function to allow generic
 * destruction of collections.
 * Removal of code that was commented out in coln_dict.c. Also removal of
 * related unused variables.
 * Addition of better error messages to coln_list.c
 * Addition of function coln_count_matches_in_bag() for RWR. Addition of this
 * function to jacket routines. Addition of GENLIB header files in coln_jacket.c
 * because someone else had been too lazy to put them to stop getting warning
 * messages about gen_register_destroy() (very sloppy).
 *
 * Revision 1.1  1992/03/16  21:23:14  jon
 * Version v1-0 derived from root
 * Version containing `speed' alternative from old system
 *								*/

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Tony J Ibbs, 18-Apr-1990					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*			  C O L N _ D E F N S 				*/
/*									*/
/* Public definitions for COLNLIB, the Collections library		*/
/*									*/
/* Part of GOTHIC module COLNLIB					*/
/* Version 0.1, Tony J Ibbs 18-Apr-1990					*/
/************************************************************************/

/************************************************************************/
/* Define an enumeration to allow us to describe what a collection is	*/
/* - that is, what it is called (bag, set, etc)				*/
/* and a macro to convert said values to convenient text strings	*/
/************************************************************************/


/*----------------------------------------------------------------------*/
/* ENUM COLLECTION_TYPE                                                 */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of collections which are        */
/* implemented within the COLNLIB library                               */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* CT_INVALID           -       Invalid type of collection              */
/* CT_SET,              -       A set is an collection ordered by the   */
/*                              the magnitude of its elements with each */
/*                              element occuring only once in the set.  */
/* CT_BAG               -       A bag is an collection ordered by the   */
/*                              the magnitude of its elements with but  */
/*                              element value may have multiple entries */
/*                              in the bag.                             */
/* CT_LIST               -      A list is an collection ordered in the  */
/*                              the way determined by the user. A list  */
/*                              may have multiple entries and can be    */
/*                              either closed or open.  A closed list   */
/*                              has no end or beginning.                */
/* CT_DICT               -      A dictionary is an collection of        */
/*                              of elements ordered by the magnitude of */
/*                              a key which is seperate from the value  */
/*                              of the element.                         */
/*----------------------------------------------------------------------*/

typedef enum
{
   CT_INVALID,
   CT_SET,
   CT_BAG,
   CT_LIST,
   CT_XXX,		/* not yet well-defined 'Call this CT_SPIN' (SRK) */
   CT_DICT,
   CT_TABLE
} COLLECTION_TYPE;

#define goth_CT_to_text(type)\
   (type == CT_INVALID,	? "invalid"	:\
    type == CT_SET,	? "Set"		:\
    type == CT_BAG,	? "Bag"		:\
    type == CT_LIST,	? "List"	:\
    type == CT_XXX,	? "XXX"		:\
    type == CT_DICT,	? "Dict"	:\
    type == CT_TABLE,	? "Table"	:\
    "unknown")

/************************************************************************/
/* Collection combining mode.						*/
/************************************************************************/

/*----------------------------------------------------------------------*/
/* ENUM COLN_COMBINE_MODE                                               */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of ways in which two <<sets>>   */
/* may be combined to create a new set.                                 */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* _COLN_OR  - "or" the two sets together                               */
/* _COLN_XOR - "exclusive or" the two sets together                     */
/* _COLN_AND - "and" the two sets together                              */
/* _COLN_AND_NOT - "and not" the two sets together                      */
/* _COLN_NOT_AND - "not and" the two sets together                      */
/*                                                                      */
/*----------------------------------------------------------------------*/

typedef enum 
{
   _COLN_OR,
   _COLN_XOR,
   _COLN_AND,
   _COLN_AND_NOT,
   _COLN_NOT_AND
} COLN_COMBINE_MODE; 

/************************************************************************/
/* In this file, we don't know anything about the internal structure of	*/
/* the collection data structure...					*/
/*				 ...or of marks...			*/
/************************************************************************/

/*
  #ifndef  COLN_LIBRARY_COMPILE
     typedef  VOID_P  COLLECTION;
     typedef  VOID_P  MARK_PTR;
  #endif
*/

/************************************************************************/
/* We need to be able to select a particular element, and also indicate	*/
/* whether we want before or after that element...			*/
/************************************************************************/


/*----------------------------------------------------------------------*/
/* ENUM COLLECTION_WHICH                                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines methods of locating elements within a       */
/* collection. Some of the methods require a qualifying value.          */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/*  CPT_POSITION - Locate the element by ordinal position.              */
/*                 The qualifying value specifies the position.         */
/*  CPT_VALUE    - Locate the element by value.                         */
/*                 The qualifying value specifies the value.            */
/*  CPT_FIRST    - Locate the first element of the list.                */
/*                 No qualifing value is required.                      */
/*  CPT_LAST     - Locate the last element of the list.                 */
/*                 No qualifing value is required.                      */
/*  CPT_MARK     - Locate the marked element of the list.               */
/*                 The qualifying value specifies the mark.             */
/*                                                                      */
/*----------------------------------------------------------------------*/

typedef enum
{
   CPT_POSITION,	/* the `n'th element			*/
   CPT_VALUE,		/* the (first) element with `value'	*/
   CPT_FIRST,		/* the first element			*/
   CPT_LAST,		/* the last element			*/
   CPT_MARK,		/* the marked element			*/
   CPT_MIN,		/* the element with minimum value	*/
   CPT_MAX		/* the element with maximum value	*/
} COLLECTION_WHICH;

/*----------------------------------------------------------------------*/
/* ENUM COLLECTION_WHERE                                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines whether an operation is to occur on the     */
/* element before or after an element selected using the COLLECION_WHICH*/
/* mechanism. This addressing mode is used most frequently in lists.    */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* CPTW_BEFORE -  Operate on the element before the chosen element.     */
/* CPTW_AFTER  -  Operate on the element after the chosen element.      */
/*                                                                      */
/*----------------------------------------------------------------------*/

typedef enum
{
   CPTW_BEFORE,		/* before that element	*/
   CPTW_AFTER		/* after that element	*/
} COLLECTION_WHERE;


/*----------------------------------------------------------------------*/
/* TYPE FUNC COLN_APPLY_FN						*/
/* DESCRIPTION								*/
/* 									*/
/* The type of the callbacks which can be applied by COLNLIB to all	*/
/* the elements in a collection.					*/
/* 									*/
/* ARGUMENTS								*/
/* 									*/
/* param		-	A caller supplied parameter passed	*/
/* 				to each call made to the callback.	*/
/*									*/
/* value_type		-	The type of the value.			*/
/* 									*/
/* value		-	The value of the current collection	*/
/* 				element.				*/
/* 									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef GOTH_STATUS (*COLN_APPLY_FN)(
				     VOID_P		param,
				     GOTH_DATATYPE	value_type,
				     GOTH_VALUE		value);

/* end-def */


/*----------------------------------------------------------------------*/
/* TYPE FUNC COLN_DICT_APPLY_FN						*/
/* DESCRIPTION								*/
/* 									*/
/* The type of the callbacks which can be applied by COLNLIB to all	*/
/* the keys and values in a dictionary.					*/
/* 									*/
/* ARGUMENTS								*/
/* 									*/
/* param		-	A caller supplied parameter passed	*/
/* 				to each call made to the callback.	*/
/* 									*/
/* key_type		-	The type of the key.			*/
/* 									*/
/* key			-	The current key taken from the		*/
/* 				dictionary.				*/
/* 									*/
/* value_type		-	The type of the value.			*/
/* 									*/
/* value		-	The current value taken from the	*/
/* 				dictionary.				*/
/* 									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef GOTH_STATUS (*COLN_DICT_APPLY_FN)(
					  VOID_P		param,
					  GOTH_DATATYPE		key_type,
					  GOTH_VALUE		key,
					  GOTH_DATATYPE		value_type,
					  GOTH_VALUE		value);

/* end-def */

#endif
