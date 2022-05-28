/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:45:38.000000000 +0000
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
#ifndef _COLN_FUNCTIONS_NEW
#define _COLN_FUNCTIONS_NEW
#ifndef _COLN_FUNCTIONS
#define _COLN_FUNCTIONS

#include <coln_defns.h>

/*----------------------------------------------------------------------*/
/* INTRODUCTION								*/
/*									*/
/* The GOTHIC library which provides support for collections of data	*/
/* values is called COLNLIB.						*/
/*									*/
/*  COLNLIB provides a variety of ways in which the data can be stored 	*/
/*  such as dictionaries,sets,lists and bags.  Procedures are available	*/
/*  for the entry,updating and deletion of elements within collections.	*/
/*									*/  
/*  COLNLIB give the user the ability to mark elements of a collection  */
/*  and these marks can be stepped through the collection to 		*/
/*  enable efficient searching procedures to be performed.		*/
/*									*/
/*  Routines are provided for the combination of existing collections   */
/*  to create new collections according to standard set operations.	*/
/*									*/
/*  The following types of collections are provided.			*/
/*									*/
/*@ SETS    		A set is an collection ordered by the   	*/
/*          		the magnitude of its elements with each 	*/
/*	    	        element occuring only once in the set.  	*/
/*@ BAGS    		A bag is an collection ordered by the   	*/
/*	    		the magnitude of its elements with but  	*/
/*	    		element value may have multiple entries 	*/
/*	                in the bag.                             	*/
/*@ LISTS     		A list is an collection ordered in the  	*/
/*	    		the way determined by the user. A list  	*/
/*	                may have multiple entries and can be    	*/
/*	                either closed or open.  A closed list   	*/
/*	                has no end or beginning.                	*/
/*@ DICTIONARIES        A dictionary is an collection of        	*/
/*                      of elements ordered by the magnitude of 	*/
/*                      a key which is seperate from the value          */
/*                      of the element.                         	*/
/*									*/
/*----------------------------------------------------------------------*/

/*>>> EXTERN functions from COLN_BAG.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN coln_create_bag                                               */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Create a bag of elements of type datatype. If the datatype is        */
/* DT_DESCRIPTOR, the descriptor type should be defined by desctype.    */
/* The descriptor for the bag must be previously allocated before       */
/* calling this routine.                                                */
/*                                                                      */
/* The collection type <<bag>> is a non-unique collection of elements   */
/* with corresponding enumeration CT_BAG.                               */
/*                                                                      */
/* Data elements in a bag are ordered by magnitude, with the lowest     */
/* valued element occuring at the start of the bag.                     */
/* Elements in a bag are not ordered in the manner in which they are    */
/* entered into a bag.                                                  */
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bag_id   -in- the bag to create.                                     */
/* datatype -in- datatype for elements of the bag.                      */
/* desctype -in- descriptor type for elements of the bag if datatype is */
/*               a descriptor.                                          */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  The collection type is not known.                      */
/*  GOTH__FAIL   There is an internal error.                            */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_create_bag(GD_COLLECTION               bag_id,
                                   GOTH_DATATYPE               datatype,
                                   GOTH_DESCRIPTOR_DATATYPE    desctype);
/*----------------------------------------------------------------------*/
/* EXTERN coln_build_bag                                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Build a bag of elements of type datatype. If the datatype is         */
/* DT_DESCRIPTOR, the descriptor type should be defined in desctype.    */
/* The descriptor need not be previously allocated before calling this  */
/* routine.                                                             */
/*                                                                      */
/* The collection type <<bag>> is a non-unique collection of elements   */
/* with corresponding enumeration CT_BAG.                               */
/*                                                                      */
/* Data elements in a bag are ordered by magnitude, with the lowest     */
/* valued element occuring at the start of the bag.                     */
/* Elements in a bag are not ordered in the manner in which they are    */
/* entered into a bag.                                                  */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bag_id   -out- the bag to create.                                    */
/* datatype -in-  datatype for elements of the bag.                     */
/* desctype -in-  descriptor type for elements of the bag if datatype is*/
/*                a descriptor.                                         */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  The collection type is not known.                      */
/*  GOTH__FAIL   There is an internal error.                            */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_build_bag(GD_COLLECTION                *bag_id,
                                  GOTH_DATATYPE                datatype,
                                  GOTH_DESCRIPTOR_DATATYPE     desctype);
/*----------------------------------------------------------------------*/
/* EXTERN coln_add_element_to_bag                                       */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Add an element to a bag. It is possible to add multiple elements     */
/* with the same value into a bag.                                      */
/* The datatype of the element should be the same as the datatype of    */
/* the bag specified when the bag was created or built.                 */
/*                                                                      */
/* The order of the new element in the bag is determined by the         */
/* magnitude of its value, not the order in which it is entered into    */
/* the bag.                                                             */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bag_id  -in- the bag to add the element to.                          */
/* element -in- element to add to the bag.                              */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__EXISTS  No more identical elements can be added.              */
/*  GOTH__ERROR   The bag has unknown datatype.                         */
/*  GOTH__NOTCOLN The descriptor is not a collection.                   */
/*  GOTH__FAIL    There is an internal error.                           */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_add_element_to_bag(GD_COLLECTION bag_id,
                                           GOTH_VALUE    element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_remove_element_from_bag                                  */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Remove an element from a bag. Note that if the element has multiple  */
/* entries it still exists in the bag.                                  */
/* An error code is returned if the element does not exist in the  bag. */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bag_id  -in- the bag to remove element from.                         */
/* element -in- value of element to remove.                             */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOSUCHELEM Element does not exist in bag.                     */
/*  GOTH__ERROR      The bag has unknown datatype.                      */
/*  GOTH__FAIL       There is an internal error.                        */
/*  GOTH__NOTCOLN    The descriptor is not a collection.                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_remove_element_from_bag(GD_COLLECTION bag_id,
                                                GOTH_VALUE    element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_remove_matches_from_bag                                  */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Remove all occurences from a bag which match a paritcular element.   */
/* Note that if the element has multiple entries all entries are        */
/* removed.                                                             */  
/* An error code is returned if the element does not exist in the  bag  */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bag_id  -in- the bag to remove matches from.                         */
/* element -in- value of element to remove.                             */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOSUCHELEM Element does not exist in bag.                     */
/*  GOTH__ERROR      The list has unknown datatype.                     */
/*  GOTH__FAIL       There is an internal error.                        */
/*  GOTH__NOTCOLN    The descriptor is not a collection.                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_remove_matches_from_bag(GD_COLLECTION bag_id,
                                                GOTH_VALUE    element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_count_matches_in_bag                                  	*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Counts all occurences from a bag which match a paritcular element.   */
/* If the element is not found the *matches parameter is set to zero.	*/
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bag_id	-in-	The bag to remove matches from.                 */
/* element	-in-	Value of element to remove.                     */
/* *matches	-out-	Number of matches of element.			*/
/*			Zero if no match found.				*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__ERROR      The list has unknown datatype.                     */
/*  GOTH__FAIL       There is an internal error.                        */
/*  GOTH__NOTCOLN    The descriptor is not a collection.                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_count_matches_in_bag(GD_COLLECTION	bag_id,
					     GOTH_VALUE		element,
					     GOTH_INTEGER	*matches);
/*----------------------------------------------------------------------*/
/* EXTERN coln_print_bag                                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Print the elements of a bag in the order specified by their          */
/* magnitude.                                                           */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bag_id -in- the bag to print.                                        */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_print_bag(GD_COLLECTION bag_id);

/*>>> EXTERN functions from COLN_SET.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN coln_create_set                                               */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Create a set of elements of type datatype. If the datatype is        */
/* DT_DESCRIPTOR, the descriptor datatype should be defined in desctype.*/
/* The descriptor must be previously allocated before calling this      */
/* routine.                                                             */
/*                                                                      */
/* The collection type <<set>> is a unique collection of elements       */
/* with corresponding enumeration CT_SET.                               */
/*                                                                      */
/* Data elements in a set are ordered by magnitude, with the lowest     */
/* valued element occuring at the start of the set.                     */
/* Elements in a set are not ordered in the manner in which they are    */
/* entered into a set.                                                  */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* set_id   -in- the set to create.                                     */
/* datatype -in- datatype for elements of the set.                      */
/* desctype -in- descriptor type for elements of the set if datatype is */
/*               a descriptor.                                          */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  The collection type is not known.                      */
/*  GOTH__FAIL   There is an internal error.                            */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_create_set(GD_COLLECTION                set_id,
                                   GOTH_DATATYPE                datatype,
                                   GOTH_DESCRIPTOR_DATATYPE     desctype);
/*----------------------------------------------------------------------*/
/* EXTERN coln_build_set                                                */
/*......................................................................*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Build a set of elements of type datatype. If the datatype is         */
/* DT_DESCRIPTOR, the descriptor datatype should be defined in `desctype*/
/* The descriptor need not be previously allocated before calling this  */
/* routine.                                                             */
/*                                                                      */
/* The collection type <<set>> is a unique collection of elements       */
/* with corresponding enumeration CT_SET.                               */
/*                                                                      */
/* Data elements in a set are ordered by magnitude, with the lowest     */
/* valued element occuring at the start of the set.                     */
/* Elements in a set are not ordered in the manner in which they are    */
/* entered into a set.                                                  */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* set_id   -out- the set to create.                                    */
/* datatype -in- datatype for elements of the set.                      */
/* desctype -in- descriptor type for elements of the set if datatype is */
/*               a descriptor.                                          */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupted or of the wrong type.	*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  The collection type is not known.                      */
/*  GOTH__FAIL   There is an internal error.                            */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_build_set(GD_COLLECTION                 *set_id,
                                  GOTH_DATATYPE                 datatype,
                                  GOTH_DESCRIPTOR_DATATYPE      desctype);
/*----------------------------------------------------------------------*/
/* EXTERN coln_add_element_to_set                                       */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Add an element to a set. It is not possible to add multiple elements */
/* into a set.                                                          */
/*                                                                      */
/* The datatype of the element should be the same as the datatype of    */
/* the set specified when the set was created or built.                 */
/*                                                                      */
/* The order of the new element in the set is determined by the         */
/* magnitude of its value, not the order in which it is entered into    */
/* the set.                                                             */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* set_id  -in- the set to have an element added.                       */
/* element -in- the element to add.                                     */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__EXISTS  No more identical elements can be added.              */
/*  GOTH__ERROR   The set has unknown datatype.                         */
/*  GOTH__NOTCOLN The descriptor is not a collection.                   */
/*  GOTH__FAIL    There is an internal error.                           */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_add_element_to_set(GD_COLLECTION   set_id,
                                           GOTH_VALUE      element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_remove_element_from_set                                  */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Remove an element from a set.                                        */
/* An error code is returned if the element does not exist in the  set. */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* set_id  -in- the set to remove the element from.                     */
/* element -in- element to remove from the set.                         */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.		        */
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOSUCHELEM The element does not exist in set.                 */
/*  GOTH__ERROR      The set has unknown datatype.                      */
/*  GOTH__FAIL       There is an internal error.                        */
/*  GOTH__NOTCOLN    The descriptor is not a collection.                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_remove_element_from_set(GD_COLLECTION   set_id,
                                                GOTH_VALUE      element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_print_set                                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Print the elements of a set in the order specified by their          */
/* magnitude.                                                           */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* set_id -in- the set to print.                                        */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_print_set(GD_COLLECTION set_id);
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_set_datatype						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Get the datatype of the elements within a set.                       */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* set_id   -in- set descriptor to test datatype.                       */
/* datatype -out- the datatype of set.			                */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__FAIL	 The collection is not a set.	 		        */
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_set_datatype(GD_COLLECTION	set_id,
					 GOTH_DATATYPE	*datatype);

/*>>> EXTERN functions from COLN_DICT.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN coln_create_dict                                              */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Create a dictionary of elements of key type key_type, and value      */
/* type value_type. If the key_type is DT_DESCRIPTOR, the descriptor    */
/* datatype should be defined in desctype. Key_type specifies the type  */
/* of key to use within the dictionary. The descriptor must be          */ 
/* previously allocated before  calling this routine.                   */
/*                                                                      */
/* The collection type <<dictionary>> is a non-unique collection of     */
/* elements each addressed by use of an unique key, with corresponding  */
/* enumeration CT_DICT.                                                 */
/* The key and value do not need to be of the same type.                */
/*                                                                      */
/* Data elements in a dictionary are ordered by magnitude of the key    */
/* with the lowest valued key occuring at the start of the dictionary.  */
/* Elements in a dictionary are not ordered in the manner in which they */
/* are entered into a dictionary.                                       */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* dict_id    -in- the dictionary to create.                            */
/* key_type   -in- datatype for the dictionary key.                     */
/* desctype   -in- descriptor type if key_type is descriptor.           */
/* value_type -in- datatype for the dictionary value.                   */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  The dictionary type is not known.                      */
/*  GOTH__FAIL   There is an internal error.                            */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_create_dict(GD_COLLECTION            dict_id,
                                    GOTH_DATATYPE            key_type,
                                    GOTH_DESCRIPTOR_DATATYPE desctype,
                                    GOTH_DATATYPE            value_type);
/*----------------------------------------------------------------------*/
/* EXTERN coln_build_dict                                               */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Create a dictionary of elements of key type key_type, and value      */
/* type value_type. If the key_type is DT_DESCRIPTOR, the descriptor    */
/* datatype should be defined in desctype. Key_type specifies the type  */
/* of key to use within the dictionary. The descriptor need not be      */ 
/* previously allocated before  calling this routine.                   */
/*                                                                      */
/*                                                                      */
/* The collection type <<dictionary>> is a non-unique collection of     */
/* elements each addressed by use of an unique key, with corresponding  */
/* enumeration CT_DICT.                                                 */
/* The key and value do not need to be of the same type.                */
/*                                                                      */
/* Data elements in a dictionary are ordered by magnitude of the key    */
/* with the lowest valued key occuring at the start of the dictionary.  */
/* Elements in a dictionary are not ordered in the manner in which they */
/* are entered into a dictionary.                                       */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* dict_id    -out- the dictionary to build.                            */
/* key_type   -in-  datatype for the dictionary key.                    */
/* desctype   -in-  descriptor type if key_type is descriptor.          */
/* value_type -in-  datatype for the dictionary value.                  */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  The dictionary type is not known.                      */
/*  GOTH__FAIL   There is an internal error.                            */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_build_dict(GD_COLLECTION             *dict_id,
                                   GOTH_DATATYPE             key_type,
                                   GOTH_DESCRIPTOR_DATATYPE  desctype,
                                   GOTH_DATATYPE             value_type);
/*----------------------------------------------------------------------*/
/* EXTERN coln_add_element_to_dict                                      */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Add a new element to a dictionary. The key and value datatypes must  */
/* correspond with the types used to create the dictionary.             */
/*                                                                      */
/* The position of the new element in the dictionary is determined by   */
/* the magnitude of its key, not the order in which it is entered into  */
/* the dictionary.                                                      */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* dict_id -in- the dictionary to add the element to.                   */
/* key     -in- key for the dictionary.                                 */
/* value   -in- element for the dictionary.                             */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__EXISTS  The element is already in the dictionary.             */
/*  GOTH__ERROR   The dictionary has unknown datatype.                  */
/*  GOTH__NOTCOLN The descriptor is not a collection.                   */
/*  GOTH__FAIL    There is an internal error.                           */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_add_element_to_dict(GD_COLLECTION       dict_id,
                                            GOTH_VALUE          key,
                                            GOTH_VALUE          value);
/*----------------------------------------------------------------------*/
/* EXTERN coln_update_element_in_dict                                   */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Change the value associated with a key in a dictionary. The key and  */
/* value datatypes must correspond with the types used to create the    */
/* dictionary.                                                          */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* dict_id -in- the dictionary whose element is to be updated.          */
/* key     -in- key for the dictionary.                                 */
/* value   -in- the new value to hold against the key.                  */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL    Normal,successful completion.			*/
/*  GOTH__DESC      A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOSUCHKEY The key does not exist in the dictionary.           */
/*  GOTH__ERROR     The dictionary has unknown datatype.                */
/*  GOTH__NOTCOLN   The descriptor is not a collection.                 */
/*  GOTH__FAIL      There is an internal error.                         */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_update_element_in_dict(GD_COLLECTION    dict_id,
                                               GOTH_VALUE       key,
                                               GOTH_VALUE       value);
/*----------------------------------------------------------------------*/
/* EXTERN coln_remove_element_from_dict                                 */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Remove the element associated with a key from a dictionary.          */
/* An error code is returned if the element does not exist in the       */
/* dictionary.                                                          */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* dict_id -in- the dictionary to remove the element from.              */
/* key     -in- key of value to remove.                                 */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL    Normal,successful completion.			*/
/*  GOTH__DESC      A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOSUCHKEY The key does not exist in dictionary.               */
/*  GOTH__ERROR     The dictionary has unknown datatype.                */
/*  GOTH__FAIL      There is an internal error.                         */
/*  GOTH__NOTCOLN   The descriptor is not a collection.                 */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_remove_element_from_dict(GD_COLLECTION dict_id,
                                                 GOTH_VALUE    key);
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_dict_key_value                                       */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Get the value associated with a key within a dictionary.             */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* dict_id -in-  the dictionary whose value is to be got.               */
/* key     -in-  key of value to get.                                   */
/* value   -out- the value indexed by the key.                          */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL    Normal,successful completion.			*/
/*  GOTH__DESC      A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOSUCHKEY The key does not exist in dictionary.               */
/*  GOTH__ERROR     The dictionary has unknown datatype.                */
/*  GOTH__FAIL      There is an internal error.                         */
/*  GOTH__NOTCOLN   The descriptor is not a collection.                 */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_dict_key_value(GD_COLLECTION        dict_id,
                                           GOTH_VALUE           key,
                                           GOTH_VALUE           *value);
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_marked_dict_key                                      */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Get the key associated with a marked element of a dictionary.        */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id -in-  the mark that marks the key.                           */
/* key     -out- the key that was marked.                               */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL    Normal,successful completion.			*/
/*  GOTH__DESC      A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOSUCHKEY The key does not exist in dictionary.               */
/*  GOTH__ERROR     The dictionary has unknown datatype.                */
/*  GOTH__FAIL      There is an internal error.                         */
/*  GOTH__NOTCOLN   The descriptor is not a collection.                 */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_marked_dict_key(GD_MARK             mark_id,
                                            GOTH_VALUE          *key);
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_marked_dict_value                                    */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Get the value associated with a marked element of a dictionary.      */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id -in-  the mark that marks the value.                         */
/* value   -out- the value that was marked.                             */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL    Normal,successful completion.			*/
/*  GOTH__DESC      A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOSUCHKEY The key does not exist in dictionary.               */
/*  GOTH__ERROR     The dictionary has unknown datatype.                */
/*  GOTH__FAIL      There is an internal error.                         */
/*  GOTH__NOTCOLN   The descriptor is not a collection.                 */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_marked_dict_value(GD_MARK           mark_id,
                                              GOTH_VALUE        *value);
/*----------------------------------------------------------------------*/
/* EXTERN coln_print_dict                                               */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* OBSELETE.. This routine may not work. SRK Jan 1992.			*/
/*......................................................................*/
/*                                                                      */
/* Print the elements in a dictionary in the order specified by the key */
/* magnitude.                                                           */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* dict_id -in- the dictionary to print.                                */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_print_dict(GD_COLLECTION dict_id);

/*>>> EXTERN functions from COLN_COMBINE_SET.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN coln_combine_set                                              */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This routine is used to combine two sets (set_1 and set_2) of the    */
/* same datatype, returning a set (ret_set) which holds the combined    */
/* sets. The method of combination is determined by the combination     */
/* mode.                                                                */
/* The output set should not be allocated before calling this routine   */
/*                                                                      */
/* Possible values of mode are                                          */
/*                                                                      */
/* @ _COLN_OR  - or the two sets                                        */
/* @ _COLN_XOR - exclusive or the two sets                              */
/* @ _COLN_AND - and the two sets                                       */
/* @ _COLN_AND_NOT - and not the two sets                               */
/* @ _COLN_NOT_AND - not and the two sets                               */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* set_1   -in-  the first set to combine.                              */
/* set_2   -in-  the second set to combine.       	                */
/* mode    -in-  the combination mode.                                  */
/* ret_set -out- the combined set.                                      */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_combine_set(GD_COLLECTION     set_1,
                                    GD_COLLECTION     set_2,
                                    COLN_COMBINE_MODE mode,
                                    GD_COLLECTION     *ret_set) ;
/*----------------------------------------------------------------------*/
/* EXTERN coln_combine_existing_set					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to combine two sets (set_1 and set_2) of the    */
/* same datatype, into an existing output set. The method of 		*/
/* combination is determined by the combination mode.                   */
/* The output set should not be allocated before calling this routine   */
/*                                                                      */
/* Possible values of mode are                                          */
/*                                                                      */
/* @ _COLN_OR  - or the two sets                                        */
/* @ _COLN_XOR - exclusive or the two sets                              */
/* @ _COLN_AND - and the two sets                                       */
/* @ _COLN_AND_NOT - and not the two sets                               */
/* @ _COLN_NOT_AND - not and the two sets                               */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* set_1   -in-  the first set to combine.                              */
/* set_2   -in-  the second set to combine.       	                */
/* mode    -in-  the combination mode.                                  */
/* out_set -in-  the combined set.                                      */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_combine_existing_set(
					     GD_COLLECTION     set_1,
					     GD_COLLECTION     set_2,
					     COLN_COMBINE_MODE mode,
					     GD_COLLECTION     out_set);

/*>>> EXTERN functions from COLN_MARK.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN coln_alloc_mark                                               */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Allocates a descriptor block for a new mark.                         */
/*                                                                      */
/* A  mark descriptor can be placed on an element of a collection and   */
/* can be used to remember important elements of a collection. Marks are*/
/* also used to enable the user to step through a collection from one   */
/* element to the next performing an operation on each element.         */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id -out- The mark to allocate.                                  */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_alloc_mark(GD_MARK      *mark_id);
/*----------------------------------------------------------------------*/
/* EXTERN coln_free_mark                                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Free a mark descriptor block.                                        */
/* This routine is the inverse operation to <<coln_alloc_mark>>         */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id -in- The mark to free.                                       */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__NOTMARK The descriptor is not a mark.                         */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_free_mark( GD_MARK      mark_id );
/*----------------------------------------------------------------------*/
/* EXTERN coln_create_mark                                              */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Creates the basics of a mark. The created mark then needs to be      */
/* attached to an element of a collection to be of any use.             */
/* The mark descriptor block must be allocated before calling this      */
/* routine                                                              */
/*                                                                      */
/* A  mark descriptor can be placed on an element of a collection and   */
/* can be used to remember important elements of a collection. Marks are*/
/* also used to enable the user to step through a collection from one   */
/* element to the next performing an operation on each element.         */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id -in/out- The mark to create.                                 */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC  No more virtual memory to allocate.                   */
/*  GOTH__NOTMARK The descriptor is not a mark.                         */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_create_mark( GD_MARK mark_id );
/*----------------------------------------------------------------------*/
/* EXTERN coln_delete_mark                                              */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Delete the data associated with a mark, leaving the descriptor block */
/* intact.                                                              */
/* This routine is the inverse operation to <<coln_create_mark>>.       */ 
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id -in- the mark to delete.                                     */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL   Normal,successful completion.			*/
/*  GOTH__DESC     A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOTMARK  The descriptor is not a mark.                        */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_delete_mark( GD_MARK    mark_id );
/*----------------------------------------------------------------------*/
/* EXTERN coln_build_mark                                               */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Creates a descriptor for a mark, and then creates a basic            */
/* mark structure within that.                                          */
/* This is the preferred method of creating a mark,and is equivalent to */
/* <<coln_alloc_mark>> followed by <<coln_create mark>>.                */
/* The mark descriptor block should not be allocated before calling this*/
/* routine.                                                             */
/*                                                                      */
/* A  mark descriptor can be placed on an element of a collection and   */
/* can be used to remember important elements of a collection. Marks are*/
/* also used to enable the user to step through a collection from one   */
/* element to the next performing an operation on each element.         */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id -out- the mark to build                                      */
/*                                                                      */
/*......................................................................*/
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/	
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_build_mark(GD_MARK      *mark_id);
/*----------------------------------------------------------------------*/
/* EXTERN coln_destroy_mark                                             */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Destroys a mark and its descriptor.                                  */
/* This routine destroys all the data associated with a mark and then   */
/* deletes the mark descriptor block.                                   */
/* The routine is equivalent to calling <<coln_delete_mark>> and then   */
/* <<coln_free_mark>>.                                                  */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id -in- the mark to destroy.                                    */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL   Normal,successful completion.			*/
/*  GOTH__NOTMARK  The descriptor is not a mark.                        */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_destroy_mark( GD_MARK   mark_id );
/*----------------------------------------------------------------------*/
/* EXTERN coln_mark_collection                                          */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Place a mark on the specified element of the collection. The         */
/* parameters p1,qual and elem_count may be used to specify the element */
/* to be marked.                                                        */
/*                                                                      */
/* Possible values of p1 and use of the qual parameter are              */
/* @ CPT_POSITION - Locate the marked element by ordinal position in the*/
/*                  collection. qual specifies the ordinal position.    */
/* @ CPT_VALUE    - Locate the marked element by value in the           */
/*                  collection. qual specifies the value.               */
/* @ CPT_FIRST    - Mark the first element in the collection.           */
/*                  qual is not used.                                   */
/* @ CPT_LAST     - Mark the last element in the collection             */
/*                  qual is not used.                                   */
/* @ CPT_MARK     - Mark the marked element in the collection.          */
/*                  qual specifies the mark.                            */
/*                                                                      */
/* For collection types which can have multiple occurences of the same  */
/* value a particular occurence of the element can be specified by using*/
/* the elem_count parameter which specifies which of the elements to    */
/* mark (e.g. elem_count is one to mark the first occurence).           */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id    -in/out- the mark to set.                                 */
/* coln_id    -in-     the collection to set mark on.                   */
/* p1         -in-     relative to which element in the list to insert  */
/*                     the new element.                                 */
/* qual       -in-     positional qualifier for p1.                     */
/* elem_count -in-     which occurence of identical elements to mark.   */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__BADPOSN    Either p1 or qual are not well defined.            */
/*  GOTH__NOTMARK    The mark_id is not a mark.                         */
/*  GOTH__NOTCOLN    The  coln_id is not a collection.                  */
/*  GOTH__NOSUCHELEM The element does not exist.                        */
/*  GOTH__ERROR      The collection type is unknown.                    */
/*  GOTH__ABSENT     The elem_count is zero for an element specified by */
/*                   value.                                             */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_mark_collection(GD_MARK                 mark_id,
                                        GD_COLLECTION           coln_id,
                                        COLLECTION_WHICH        p1,
                                        GOTH_VALUE              qual,
                                        GOTH_INTEGER            elem_count);
/*----------------------------------------------------------------------*/
/* EXTERN coln_mark_search                                              */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Search a collection for an element with the specified value,         */
/* starting at the marked element, and set the mark to the              */
/* element that is found. If the specified element is not found, the    */
/* mark is not changed.                                                 */
/*                                                                      */
/* The parameter elem_count can be used to search for a particular      */
/* instance of a multiply occuring value.                               */
/*                                                                      */
/* The search may be either backwards or forwards depending on the sign */
/* of elem_count. No action is taken if elem_count is zero. The mark is */
/* only updated if an element is found.                                 */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id      -in/out- the mark to set.                               */
/* value        -in-     the value to search for.                       */
/* elem_count   -in-     +1 => first occurrence of value,2 => second,etc!*/
/*                       -1 => first occurrence going backwards, etc   !*/
/*                        0 => do nothing.                              */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__BADMARK    The mark is invalid.                               */
/*  GOTH__NOTMARK    The decsriptor is not a mark.                      */
/*  GOTH__NOSUCHELEM The specified element does not exist.              */ 
/*  GOTH__ERROR      The collection type is not recognised.             */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_mark_search(GD_MARK             mark_id,
                                    GOTH_VALUE          value,
                                    GOTH_INTEGER        elem_count);
/*----------------------------------------------------------------------*/
/* EXTERN coln_step_mark                                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Step a mark through a collection.                                    */
/* This routine steps a mark along the elements of a collection in their*/
/* determined order. The number of elements to step is determined by the*/
/* step parameter.                                                      */
/*                                                                      */
/* If the mark would be stepped beyond the end of a collection an error */
/* occurs and the mark is not moved.                                    */
/* The step size may be negative or positive depending on the whether   */
/* the step is backwards or forwards through the collection.            */
/* If the step is zero no action is taken.                              */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id -in- the mark to step                                        */
/* step    -in- how far to step (1 => next, -1 => previous, etc).       */
/*              A step of 0 does nothing.                               */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__BADMARK The mark is invalid.                                  */
/*  GOTH__ENDCOLN Either end of a collection is reached.                */
/*  GOTH__ERROR   The collection type is unknown.                       */
/*  GOTH__NOTMARK The descriptor is not a mark.                         */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_step_mark( GD_MARK      mark_id,
                                   GOTH_INTEGER step );
/*----------------------------------------------------------------------*/
/* EXTERN coln_copy_mark                                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Copies a mark from one mark to another.                              */
/* The mark to be copied to should not be allocated before this routine */
/* is called.                                                           */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* from_mark_id -in-  the original mark.                                */ 
/* to_mark_id   -out- a new mark which is a copy of the original.       */
/*                    This mark was not in existence before this call.	*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__FAIL    There is an internal error.                           */
/*  GOTH__NOTMARK Source descriptor is not a mark.                      */
/*  GOTH__MALLOC  No more virtual memory to allocate.                   */
/*  GOTH__BADMARK The source mark is invalid.                           */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_copy_mark(GD_MARK       from_mark_id,
                                  GD_MARK       *to_mark_id);
/*----------------------------------------------------------------------*/
/* EXTERN coln_same_mark                                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Check whether two marks refer to the same element                    */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* one_mark_id    -in-  the first mark to check.                        */
/* two_mark_id    -in-  the second mark to check.                       */
/* result         -out- TRUE if the marks mark the same element,       !*/
/*                      FALSE if they do not.                           */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__BADMARK A mark is invalid.                                    */
/*  GOTH__NOTMARK A descriptor is not a mark.                           */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_same_mark(GD_MARK       one_mark_id,
                                  GD_MARK       two_mark_id,
                                  GOTH_BOOLEAN  *result);
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_marked_element                                       */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Return the value of the marked element within a collection.          */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id   -in-  the mark to retrieve the associated element from.    */
/* element   -out- the element to retrieve.                             */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__BADMARK The mark is invalid.                                  */
/*  GOTH__NOTMARK The descriptor is not a mark.                         */
/*  GOTH__ERROR   The collection type is not recognised.                */
/*  GOTH__ENDCOLN The mark is off the end of the collection.            */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_marked_element(GOTH_DESCRIPTOR      mark_id,
                                           GOTH_VALUE           *element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_mark_position                                        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Return the position of the marked element within a collection.       */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id  -in-  the mark whose position is to be retrieved.           */
/* position -out- the position of the mark within the collection.       */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__BADMARK The mark is invalid.                                  */
/*  GOTH__NOTMARK The descriptor is not a mark.                         */
/*  GOTH__ERROR   The collection type is not recognised.                */
/*  GOTH__ENDCOLN The mark is past the start or end of collection.      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_mark_position( GD_MARK              mark_id,
                                           GOTH_INTEGER         *position );
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_next_marked_element                                  */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Returns the value of the marked element and moves to the next        */
/* element.                                                             */
/* The mark is not moved if the end of the collection has been reached  */
/* in which case an error is returned.                                  */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id   -in-  the mark to move.                                    */
/* element  -out- the element associated with the mask.                 */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL   Normal,successful completion.			*/
/*  GOTH__ENDCOLN  The end of the collection has been reached.          */
/*  GOTH__DESC     A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__BADMARK  The mark is invalid.                                 */
/*  GOTH__NOTMARK  The descriptor is not a mark.                        */
/*  GOTH__ERROR    The collection type is unknown.                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_next_marked_element(GD_MARK         mark_id,
                                                GOTH_VALUE      *element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_prev_marked_element                                  */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Returns the value of the marked element and moves to the previous    */
/* element.                                                             */
/* The mark is not moved if the start of the collection has been reached*/
/* in which case an error is returned.                                  */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id -in-  the mark to move.                                      */
/* element -out- the element associated with the mask.                  */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL   Normal,successful completion.		        */
/*  GOTH__ENDCOLN  The start of the collection has been reached.        */
/*  GOTH__DESC     A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__BADMARK  The mark is invalid.                                 */
/*  GOTH__NOTMARK  The descriptor is not a mark.                        */
/*  GOTH__ERROR    The collection type is unknown.                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_prev_marked_element(GD_MARK         mark_id,
                                                GOTH_VALUE      *element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_marked_key_value                                     */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Return the value of the marked element within a dictionary.          */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id   -in-  the mark to retrieve the associated element from.    */
/* element   -out- the element to retrieve.                             */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__BADMARK The mark is invalid.                                  */
/*  GOTH__NOTMARK The descriptor is not a mark.                         */
/*  GOTH__ERROR   The collection type is not recognised.                */
/*  GOTH__ENDCOLN The mark is off the end of the collection.            */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_marked_key_value(GOTH_DESCRIPTOR      mark_id,
					     GOTH_VALUE           *element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_next_marked_key_value                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Returns the value of the marked key's value and moves to the next    */
/* element.                                                             */
/* The mark is not moved if the end of the collection has been reached  */
/* in which case an error is returned.                                  */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id   -in-  the mark to move.                                    */
/* element  -out- the element associated with the mask.                 */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL   Normal,successful completion.			*/
/*  GOTH__ENDCOLN  The end of the collection has been reached.          */
/*  GOTH__DESC     A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__BADMARK  The mark is invalid.                                 */
/*  GOTH__NOTMARK  The descriptor is not a mark.                        */
/*  GOTH__ERROR    The collection type is unknown.                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_next_marked_key_value(GD_MARK         mark_id,
						  GOTH_VALUE      *element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_prev_marked_key_value                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Returns the value of the marked key's value and moves to the previous*/
/* element.                                                             */
/* The mark is not moved if the start of the collection has been reached*/
/* in which case an error is returned.                                  */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* mark_id -in-  the mark to move.                                      */
/* element -out- the element associated with the mask.                  */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL   Normal,successful completion.			*/
/*  GOTH__ENDCOLN  The start of the collection has been reached.        */
/*  GOTH__DESC     A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__BADMARK  The mark is invalid.                                 */
/*  GOTH__NOTMARK  The descriptor is not a mark.                        */
/*  GOTH__ERROR    The collection type is unknown.                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_prev_marked_key_value(GD_MARK         mark_id,
						  GOTH_VALUE      *element);

/*>>> EXTERN functions from COLN_LIST.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN coln_build_list                                               */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Build a list of elements of type datatype. If the datatype is        */
/* DT_DESCRIPTOR, the descriptor datatype should be defined in desctype.*/
/* The descriptor need not be previously allocated before calling this  */
/* routine.                                                             */
/* The collection type <<list>> is a possibly unique collection of      */
/* elements ordered in the way that that the user specifies.            */
/* The enumertion type for a list is specified by CT_LIST.              */
/*                                                                      */
/* A list can contain either unique or non-unique elements.             */
/* Elements are ordered in the list in the manner specified by the user */
/* by the user and not by the magnitude of elements within the list.    */
/*                                                                      */
/* Lists can be opened or closed. An open list has start and end        */
/* positions beyond which the user cannot step. A closed list has a     */
/* notional start and finish. A closed list wraps around itself so that */
/* the user never steps of the end of the list.                         */
/*                                                                      */
/* Positioning around the list is achieved by three parameters.         */
/* The modes of addressing an element in a list are enumerated by       */
/* @ CPT_POSITION - Locate the element by ordinal position.             */
/* @ CPT_VALUE    - Locate the element by value.                        */
/* @ CPT_FIRST    - Locate the first element of the list.               */
/* @ CPT_LAST     - Locate the last element of the list.                */
/* @ CPT_MARK     - Locate the marked element of the list.              */
/*                                                                      */
/* For some modes of postioning a qualifier is required                 */
/* @ CPT_POSITION - the qualifier specifies the ordinal position of the */
/*                  element.                                            */
/* @ CPT_VALUE    - the qualifier specifies the value of the element.   */
/* @ CPT_FIRST    - no qualifier required.                              */
/* @ CPT_LAST     - no qualifier required.                              */
/* @ CPT_MARK     - the qualifier determines the mark to use.           */
/*                                                                      */
/* The position relative to the chosen element may be further specified */
/* by an enumeration which describes whether to operate before or after */
/* the chosen element.                                                  */
/* @ CPTW_BEFORE - operate before the chosen element.                   */
/* @ CPTW_AFTER  - oerate after the chosen element.                     */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id  -in- the list to create.                                    */
/* datatype -in- datatype for elements of the list.                     */
/* desctype -in- descriptor type for elements of the list if datatype is*/
/*               a descriptor.                                          */
/* unique   -in- TRUE if unique elements required.                      */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  The list type is not known.                            */
/*  GOTH__FAIL   There is an internal error.                            */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_build_list(GD_COLLECTION                *list_id,
                                   GOTH_DATATYPE                datatype,
                                   GOTH_DESCRIPTOR_DATATYPE     desctype,
                                   GOTH_BOOLEAN                 unique);
/*----------------------------------------------------------------------*/
/* EXTERN coln_create_list                                              */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Create a list of elements of type datatype. If the datatype is       */
/* DT_DESCRIPTOR, the descriptor datatype should be defined in desctype.*/
/* The descriptor must be previously allocated before calling this      */
/* routine.                                                             */
/* The collection type <<list>> is a possibly unique collection of      */
/* elements ordered in the way that that they are entered into the list.*/
/* The enumertion type for a list is specified by CT_LIST.              */
/*                                                                      */
/* A list can contain either unique or non-unique elements.             */
/* Elements are ordered in the list in the manner specified by the user */
/* by the user and not by the magnitude of elements within the list.    */
/*                                                                      */
/* Lists can be opened or closed. An open list has start and end        */
/* positions beyond which the user cannot step. A closed list has a     */
/* notional start and finish. A closed list wraps around itself so that */
/* the user never steps off the end of a list.                          */
/*                                                                      */
/* Positioning around the list is achieved by three parameters.         */
/* The modes of addressing an element in a list are enumerated by       */
/* @ CPT_POSITION - Locate the element by ordinal position.             */
/* @ CPT_VALUE    - Locate the element by value.                        */
/* @ CPT_FIRST    - Locate the first element of the list.               */
/* @ CPT_LAST     - Locate the last element of the list.                */
/* @ CPT_MARK     - Locate the marked element of the list.              */
/*                                                                      */
/* For some modes of postioning a qualifier is required                 */
/* @ CPT_POSITION - the qualifier specifies the ordinal position of the */
/*                  element.                                            */
/* @ CPT_VALUE    - the qualifier specifies the value of the element    */
/* @ CPT_FIRST    - no qualifier required.                              */
/* @ CPT_LAST     - no qualifier required.                              */
/* @ CPT_MARK     - the qualifier determines the mark to use.           */
/*                                                                      */
/* The position relative to the chosen element may be further specified */
/* by an enumeration which describes whether to operate before or after */
/* the chosen element                                                   */
/* @ CPTW_BEFORE - operate before the chosen element.                   */
/* @ CPTW_AFTER  - oerate after the chosen element.                     */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id  -in- the list to create.                                    */
/* datatype -in- datatype for elements of the list.                     */
/* desctype -in- descriptor type for elements of the list if datatype is*/
/*               a descriptor.                                          */
/* unique   -in- TRUE if unique elements required.                      */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  The list type is not known.                          	*/
/*  GOTH__FAIL   There is an internal error.                            */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_create_list(GD_COLLECTION               list_id,
                                    GOTH_DATATYPE               datatype,
                                    GOTH_DESCRIPTOR_DATATYPE    desctype,
                                    GOTH_BOOLEAN                unique );
/*----------------------------------------------------------------------*/
/* EXTERN coln_insert_element_in_list                                   */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Insert an element into a list. An element may be inserted at any     */
/* position within a list. The postion of insertion is determine        */
/* by the parameters p1,qual and p2.                                    */
/*                                                                      */
/* Possible values of p1 and use of the qual parameter are              */
/* @ CPT_POSITION - Locate the element by which to insert by position.  */
/*                  qual then specifies the position of the element to  */
/*                  insert the new element by.                          */
/* @ CPT_VALUE    - Locate the element by which to insert by value.     */
/*                  qual then specifies the value of the element to     */
/*                  insert by the new element by.                       */
/* @ CPT_FIRST    - Insert the new element by the first element of the  */
/*                  list. qual is not used.                             */
/* @ CPT_LAST     - Insert the new element by the last element of the   */
/*                  list. qual is not used.                             */
/* @ CPT_MARK     - Insert the new element by a marked element of the   */
/*                  list. qual then specifies the marked element to     */
/*                  insert by.                                          */
/*                                                                      */
/* Possible values of p2 are                                            */
/* @ CPTW_BEFORE - Insert before the chosen element.                    */
/* @ CPTW_AFTER  - Insert after the chosen element.                     */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id -in- the list to have element inserted.                      */
/* p1      -in- relative to which element in the list to insert the     */
/*              new element.                                            */
/* qual    -in- positional qualifier for p1.                            */
/* p2      -in- either CPTW_BEFORE or CPTW_AFTER.                       */
/* element -in- the element to insert into the list.                    */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__BADPOSN Either p1 or p2 are not well defined.                 */
/*  GOTH__NOTLIST The collection is not a list.                         */
/*  GOTH__MALLOC  No more virtual memory to allocate.                   */
/*  GOTH__ERROR   Something has gone wrong internally.                  */
/*  GOTH__EXISTS  The list is unique and element already exists.        */
/*  GOTH__NOTCOLN The descriptor is not a collection.	                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_insert_element_in_list( GD_COLLECTION          list_id,
                                                COLLECTION_WHICH       p1,
                                                GOTH_VALUE             qual,
                                                COLLECTION_WHERE       p2,
                                                GOTH_VALUE             element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_insert_list_in_list                                      */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Insert a new list in the specified place in the old list. The        */
/* insertion position is determined by the parameters p1,qual and p2.   */
/*                                                                      */
/* Possible values of p1 and use of the qual parameter are              */
/* @ CPT_POSITION - Locate the element by which to insert by position.  */
/*                  qual then specifies the position of the element to  */
/*                  insert the list by.                                 */
/* @ CPT_VALUE    - Locate the element by which to insert by value.     */
/*                  qual then specifies the value of the element to     */
/*                  insert the list by.                                 */
/* @ CPT_FIRST    - Insert the list by the first element of the list.   */
/*                  qual not used.                                      */
/* @ CPT_LAST     - Insert the list by the last element of the list.    */
/*                  qual not used.                                      */
/* @ CPT_MARK     - Insert the list by a marked element of the list.    */
/*                  qual then specifies the marked element to insert by.*/
/*                                                                      */
/* Possible values of p2 are                                            */
/* @ CPTW_BEFORE - Insert the list before the chosen element.           */
/* @ CPTW_AFTER  - Insert the list after the chosen element.            */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id        -in- the list to have list inserted.                  */
/* p1             -in- relative to which element in the list to insert  */
/*                     the new list.                                    */
/* qual           -in- positional qualifier for p1.                     */
/* p2             -in- either CPTW_BEFORE or CPTW_AFTER.                */
/* insert_list_id -in- the list to be inserted.                         */
/* copy_list      -in- TRUE  - insert a copy of the list to be inserted!*/
/*                     FALSE - insert the list to be inserted. The      */
/*                             descriptor of the inserted list then     */
/*                             points to an empty list.                 */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__BADPOSN Either p1 or p2 are not well defined.                 */
/*  GOTH__NOTLIST The collection is not a list.                         */
/*  GOTH__DIFFDT  The lists contain elements of differing datatype.     */
/*  GOTH__MALLOC  No more virtual memory to allocate.                   */
/*  GOTH__ERROR   There is an internal error.                           */
/*  GOTH__EXISTS  Creating the combined list violates the               */
/*                uniquenes property of list_id.                        */
/*  GOTH__NOTCOLN The descriptor is not a collection...                 */
/*  GOTH__EMTCOLN The inserted list is empty.                           */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_insert_list_in_list( GD_COLLECTION      list_id,
                                             COLLECTION_WHICH   p1,
                                             GOTH_VALUE         qual,
                                             COLLECTION_WHERE   p2,
                                             GD_COLLECTION      insert_list_id,
                                             GOTH_BOOLEAN       copy_list );
/*----------------------------------------------------------------------*/
/* EXTERN coln_remove_element_from_list                                 */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Remove an element from a list. The element to remove is defined by   */
/* the parameters p1 and qual.                                          */
/*                                                                      */
/* Possible values of p1 and use of the qual parameter are              */
/* @ CPT_POSITION - Locate the element to remove by ordinal position.   */
/*                  qual specifies the position.                        */
/* @ CPT_VALUE    - Locate the element to remove by value.              */
/*                  qual specifies the value.                           */
/* @ CPT_FIRST    - Remove the first element in the collection.         */
/*                  qual is not used.                                   */
/* @ CPT_LAST     - Remove the last element in the collection.          */
/*                  qual is not used.                                   */
/* @ CPT_MARK     - Remove the marked element in the collection.        */
/*                  qual specifies the marked element to remove.        */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id -in- the list to have an element removed.                    */
/* p1      -in- relative to which element in the list to remove the     */
/*              element.                                                */
/* qual    -in- positional qualifier for p1.                            */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOTLIST    The collection is not a list.                      */
/*  GOTH__BADPOSN    Either p1 or qual are not well defined.            */
/*  GOTH__NOTCOLN    The descriptor is not a collection.                */
/*  GOTH__ERROR      An internal error has occured.                     */
/*  GOTH__NOSUCHELEM The element specified by value does not exist.     */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_remove_element_from_list( GD_COLLECTION      list_id,
                                                  COLLECTION_WHICH   p1,
                                                  GOTH_VALUE         qual );
/*----------------------------------------------------------------------*/
/* EXTERN coln_remove_matches_from_list                                 */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Remove all elements with a particular value from the specified list. */
/* The list datatype must equate with the value datatype.               */
/* The routine returns successfully if the list is empty.               */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id -in- the list to have matching elements removed.             */
/* value   -in- the value to remove.                                    */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOTLIST    The collection is not a list.                      */
/*  GOTH__ERROR      An internal error has occured.                     */
/*  GOTH__NOSUCHELEM The element specified by value does not exist.     */
/*  GOTH__NOTCOLN    The descriptor is not a collection.                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_remove_matches_from_list(GD_COLLECTION list_id,
                                                 GOTH_VALUE    value );
/*----------------------------------------------------------------------*/
/* EXTERN coln_change_element_in_list                                   */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Change an element's value in a list. The element value to change is  */
/* determined from the parameters p1 and qual.                          */
/* The datatype of the new value should equate with the datatype of the */
/* list.                                                                */
/*                                                                      */
/* Possible values of p1 and use of the qual parameter are              */
/* @ CPT_POSITION - Locate the element to change by position. qual      */
/*                  specifies the position.                             */
/* @ CPT_VALUE    - Locate the element to change by value. qual         */
/*                  specifies the value to change.                      */
/* @ CPT_FIRST    - Change the first element in the collection. qual is */
/*                  not used.                                           */
/* @ CPT_LAST     - Change the last element in the collection. qual is  */
/*                  not used.                                           */
/* @ CPT_MARK     - Change the marked element in the collection.qual    */
/*                  specifies the mark element.                         */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id   -in- the list whose element is to be changed.              */ 
/* p1        -in- relative to which element in the list to change the   */
/*              element.                                                */
/* qual      -in- positional qualifier for p1.                          */
/* new_value -in- the new value of the element.                         */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOTLIST    The collection is not a list.                      */
/*  GOTH__BADPOSN    Either p1 or qual are not well defined.            */
/*  GOTH__NOSUCHELEM The element specified by value does not exist.     */
/*  GOTH__NOTCOLN    The descriptor is not a collection.                */
/*  GOTH__MALLOC     No more virtual memory to allocate.                */
/*  GOTH__ERROR      An internal error has occured.                     */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_change_element_in_list( GD_COLLECTION      list_id,
                                                COLLECTION_WHICH   p1,
                                                GOTH_VALUE         qual,
                                                GOTH_VALUE         new_value );
/*----------------------------------------------------------------------*/
/* EXTERN coln_change_matches_in_list                                   */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Change the value of all elements in a list with a particular value.  */
/* The routine returns successfully if no matches are found.            */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id   -in- the list descriptor.                                  */
/* old_value -in- the old value.                                        */
/* new_value -in- the new value.                                        */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOTLIST    The collection is not a list.                      */
/*  GOTH__NOSUCHELEM The element specified does not exist.              */
/*  GOTH__NOTCOLN    The descriptor is not a collection                 */
/*  GOTH__MALLOC     No more virtual memory to allocate.                */
/*  GOTH__ERROR      An internal error occurs.                          */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_change_matches_in_list( GD_COLLECTION   list_id,
                                                GOTH_VALUE      old_value,
                                                GOTH_VALUE      new_value );
/*----------------------------------------------------------------------*/
/* EXTERN coln_replace_element_in_list                                  */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Replace an element with a new list. This routine replace an element  */
/* within a list with a new list. The element to replace is determined  */
/* by the p1 and qual parameters.                                       */
/*                                                                      */
/* Possible values of p1 and use of the qual parameter are              */
/* @ CPT_POSITION - Locate the element to replace by position. qual     */
/*                  specifies the position.                             */
/* @ CPT_VALUE    - Locate the element to repace by value. qual         */
/*                  specifies the value.                                */
/* @ CPT_FIRST    - Replace the first element in the list. qual is not  */
/*                  used.                                               */
/* @ CPT_LAST     - Replace the last element in the list. qual is not   */
/*                  used.                                               */
/* @ CPT_MARK     - Replace the marked element in the list. qual        */
/*                  specifies the mark.                                 */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/*                                                                      */
/* list_id        -in- the list whose element is to be replaced.        */
/* p1             -in- relative to which element in the list to insert  */
/*                     the new element.                                 */
/* qual           -in- positional qualifier for p1.                     */
/* p2             -in- either CPTW_BEFORE or CPTW_AFTER.                */
/* insert_list_id -in- the list to be inserted.                         */
/* copy_list      -in- TRUE  - insert a copy of the list to be inserted!*/
/*                     FALSE - insert the list to be inserted. The      */
/*                             descriptor of the inserted list then     */
/*                             points to an empty list.                 */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.      */
/*  GOTH__NOTLISET   The collection is not a list.                      */
/*  GOTH__BADPOSN    Either p1 or qual are not well defined.            */
/*  GOTH__DIFFDT     The lists contain elements of different            */
/*                   datatypes.                                         */
/*  GOTH__EXISTS     The target list 'desc' should be unique            */
/*                   but the replacement value is already in the        */
/*                   list.                                              */
/*  GOTH__NOSUCHELEM The specified element does not exist.              */
/*  GOTH__NOTCOLN    The descriptor is not a collection.                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_replace_element_in_list( 
                                             GD_COLLECTION    list_id,
                                             COLLECTION_WHICH p1,
                                             GOTH_VALUE       qual,
                                             GD_COLLECTION    insert_list_id,
                                             GOTH_BOOLEAN     copy_list );
/*----------------------------------------------------------------------*/
/* EXTERN coln_replace_matches_in_list                                  */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Replace each matching element with a copy of the specified list.     */
/* The routine returns successfully if no matching elements are found.  */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id         -in- the list whose elements are to be replaced.     */
/* old_value       -in- the value to be replaced.                       */
/* replace_list_id -in- the replacement list descriptor.                */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOTLIST    The collection is not a list.                      */
/*  GOTH__DIFFDT     The lists contains elements of different           */
/*                   datatypes.                                         */
/*  GOTH__EXISTS     The target list 'desc' should be unique but the    */
/*                   replacement list has elements already in target    */
/*                   list.                                              */
/*  GOTH__NOSUCHELEM The specified element does not exist.              */
/*  GOTH__NOTCOLN    The descriptor is not a collection.                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_replace_matches_in_list(
                                          GD_COLLECTION list_id,
                                          GOTH_VALUE    old_value,
                                          GD_COLLECTION replace_list_id) ;
/*----------------------------------------------------------------------*/
/* EXTERN coln_reverse_list                                             */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/*  Reverse the ordering of a list.                                     */
/*  Elements are entered into a list in the order specified by the user.*/
/*  This order may be reversed, so that the list head becomes the list  */
/*  tail and vice versa, by calling this routine.                       */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id  -in- the list to reverse.                                   */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__NOTLIST The collection is not a list.                         */
/*  GOTH__NOTCOLN The descriptor is not a collection.                   */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_reverse_list( GD_COLLECTION    list_id );
/*----------------------------------------------------------------------*/
/* EXTERN coln_open_list                                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Make a list open - that is, make it start/end at the specified       */
/* location in the list. The break point is determined by the parameters*/
/* p1,qual and p2.                                                      */
/* This routine will work for both an open and a closed list. It        */
/* effectively specifies the start and end of the list for positioning. */
/* The user cannot be positioned beyond the end or before the start of a*/
/* list                                                                 */
/*                                                                      */
/* Possible values of p1 and use of the qual parameter are              */
/* @ CPT_POSITION - Locate the element for breaking by position. qual   */
/*                  specifies the position.                             */
/* @ CPT_VALUE    - Locate the element for breaking by value. qual      */
/*                  specifies the value.                                */
/* @ CPT_FIRST    - Break at the first element in the collection. qual  */
/*                  is not used.                                        */
/* @ CPT_LAST     - Break at the first element in the collection. qual  */
/*                  is not used.                                        */
/* @ CPT_MARK     - Break at the marked element in the collection. qual */
/*                  specifies the mark.                                 */
/*                                                                      */
/* Possible values of p2 are                                            */
/* @ CPTW_BEFORE - Operate before the chosen element.                   */
/* @ CPTW_AFTER  - Operate after the chosen element.                    */
/*                                                                      */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id   -in- the list to open.                                     */
/* p1        -in- relative to which element in the list to open the     */
/*                list.							*/
/* qual      -in- positional qualifier for p1.                          */
/* p2        -in- either CPTW_BEFORE or CPTW_AFTER                      */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOTLIST    The collection is not a list.                      */
/*  GOTH__BADPOSN    Either p1,p2 or qual are not well defined.         */
/*  GOTH__ERROR      An internal error has occured.                     */
/*  GOTH__NOSUCHELEM The element does not exist.                        */
/*  GOTH__NOTCOLN    The decsriptor is not a collection.                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_open_list( GD_COLLECTION        list_id,
                                   COLLECTION_WHICH     p1,
                                   GOTH_VALUE           qual,
                                   COLLECTION_WHERE     p2 );
/*----------------------------------------------------------------------*/
/* EXTERN coln_close_list                                               */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Make a list closed - that is, make it truly circular, so that a      */
/* sequence of calls to get the next element in a list will go round    */
/* and round the list and never hit a list end or beginning.            */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id -in- the list to close.                                      */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL   Normal,successful completion.			*/
/*  GOTH__DESC     A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOTLIST  The collection is not a list.                        */
/*  GOTH__NOTCOLN  The descriptor is not a collection.                  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_close_list( GD_COLLECTION       list_id );
/*----------------------------------------------------------------------*/
/* EXTERN coln_split_list                                               */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Split a list into two. The list splits of into a tail list and a head*/
/* list as specified bt the postioining parameters.                     */
/* This routine has two subtly different ways of working.               */
/*                                                                      */
/*  1)  the input list and the two output lists are all                 */
/*      separate. In this case, the input list ends up being            */
/*      empty after this routine has succeeded (since its contents      */
/*      have all been reassigned to the other two lists).               */
/*                                                                      */
/*  2)  the input list is the same as one of the output                 */
/*      lists -- for instance                                           */
/*                                                                      */
/*              status = coln_split_list(aaa,..,..,..,aaa,bbb);         */
/*                                                                      */
/*      In this case, obviously the input list is NOT left              */
/*      empty (unless the split was such as to leave aaa                */
/*      containing no elements).                                        */
/*                                                                      */
/* Also note that any previous contents of the output lists are         */
/* lost.                                                                */
/*                                                                      */
/* The position of the split is determined by the parameters p1,qual    */
/* and p2                                                               */
/*                                                                      */
/* Possible values of p1 and use of the qual parameter are              */
/* @ CPT_POSITION - Locate the element to split at by position. qual    */
/*                  specifies the position.                             */
/* @ CPT_VALUE    - Locate the element to split at by value. qual       */
/*                  specifies the value.                                */
/* @ CPT_FIRST    - Split at the first element in the list. Head list is*/
/*                  then empty. qual is not used.                       */
/* @ CPT_LAST     - Split at the last element in the list. Tail list is */
/*                  then empty. qual is not used.                       */
/* @ CPT_MARK     - Split at tge marked element of the list. qual       */
/*                  specifies the mark.                                 */
/*                                                                      */
/* Possible values of p2 are                                            */
/* @ CPTW_BEFORE - Operate before the chosen element.                   */
/* @ CPTW_AFTER  - Operate after the chosen element.                    */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id -in- the list to split.                                      */
/* p1      -in- relative to which element in the list to split the      */
/*              list.                                                   */
/* qual    -in- positional qualifier for p1.                            */
/* p2      -in- either CPTW_BEFORE or CPTW_AFTER.                       */
/* head    -in- the `head' list after split.                            */
/* tail    -in- the `tail' list after split.                            */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL   Normal,successful completion.			*/
/*  GOTH__DESC     A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOTLIST  The collection is not a list.                        */
/*  GOTH__BADPOSN  The values of  p1, qual, etc do not make sense.      */
/*  GOTH__SAMECOLN The head and tail are the same collection.           */
/*  GOTH__ERROR    An internal error has occured.                       */
/*  GOTH__NOTCOLN  The descriptor is not a collection.                  */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_split_list( GD_COLLECTION       list_id,
                                    COLLECTION_WHICH    p1,
                                    GOTH_VALUE          qual,
                                    COLLECTION_WHERE    p2,
                                    GD_COLLECTION       head,
                                    GD_COLLECTION       tail );
/*----------------------------------------------------------------------*/
/* EXTERN coln_copy_list                                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Make a copy of (part of) a list.                                     */
/* This copies from the first element specified to the last element     */
/* specified, inclusive (ie, the bounding elements are also copied)     */
/* The bounding elements are determined from the parameters p1_from,    */
/* qual_from (lower bound) and p1_to,qual_to (upper bound).             */
/*                                                                      */
/* Possible values of p1 and use of the qual parameter are              */
/* @ CPT_POSITION - Locate the bounding elements by position. qual      */
/*                  specifies the position.                             */
/* @ CPT_VALUE    - Locate the bounding element by value. qual          */
/*                  specifies the value.                                */
/* @ CPT_FIRST    - Locate a bounding element at the first element in   */
/*                  the list. qual is not used.                         */
/* @ CPT_LAST     - Locate a bounding element at the last element in    */
/*                  the list. qual is not used.                         */
/* @ CPT_MARK     - Locate a bounding element at the marked element in  */
/*                  the list. qual specifies the mark.                  */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id      -in- the original list.                                 */
/* p1_from      -in- relative to which element in the list to start     */
/*                   copy.                                              */
/* qual_from    -in- positional qualifier for p1_from.                  */
/* p1_to        -in- relative to which element in the list to end copy  */
/* qual_to      -in- positional qualifier for p1_to.                    */
/* copy_list_id -in/out- the copied list's descriptor.                  */
/* count        -out- number of elements copied.                        */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__NOTLIST The collection is not a list.                         */
/*  GOTH__BADPOSN Either p1 or qual are not well defined.               */
/*  GOTH__DIIFDT  The lists contain elements of differing datatypes.    */
/*  GOTH__NOTCOLN Either descriptor is not a collection.                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_copy_list( GD_COLLECTION         list_id,
                                   COLLECTION_WHICH      p1_from,
                                   GOTH_VALUE            qual_from,
                                   COLLECTION_WHICH      p1_to,
                                   GOTH_VALUE            qual_to,
                                   GD_COLLECTION         copy_list_id,
                                   GOTH_INTEGER          *count );
/*----------------------------------------------------------------------*/
/* EXTERN coln_print_list                                               */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Print the elements of a list in their specified order                */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id -in- the list to print                                       */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*......................................................................*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_print_list(GD_COLLECTION list_id);
/*----------------------------------------------------------------------*/
/* EXTERN coln_sort_list                                             	*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Sort a list so that the list is in order with the smallest value at	*/
/* the first position in the list.					*/
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* list_id  -in- The list to sort.                                   	*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__NOTLIST The collection is not a list.                         */
/*  GOTH__NOTCOLN The descriptor is not a collection.                   */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_sort_list( GD_COLLECTION    list_id );

/*>>> EXTERN functions from COLN_GENERIC.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN coln_alloc_collection                                         */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Allocates a descriptor block for a new collection, but does <<not>>  */
/* create the collection itself.                                        */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id -out- the collection identifier.                             */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_alloc_collection(GD_COLLECTION  *coln_id);
/*----------------------------------------------------------------------*/
/* EXTERN coln_free_collection                                          */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Frees the collection descriptor.                                     */
/* This routine is the inverse operation to <<coln_alloc_collection>>.  */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id -in- the collection to free.                                 */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_free_collection( GD_COLLECTION  coln_id );
/*----------------------------------------------------------------------*/
/* EXTERN coln_delete_collection                                        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Delete the collection associated with a descriptor.                  */
/* This routine leaves the descriptor as if it had just been allocated. */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id -in- the collection to delete.                               */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_delete_collection( GD_COLLECTION        coln_id );
/*----------------------------------------------------------------------*/
/* EXTERN coln_destroy_collection                                       */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Delete the collection associated with a descriptor and then delete   */
/* the descriptor.                                                      */
/* This routine is equivalent to <<coln_delete_collection>> followed by */
/* <<coln_free_collection>>.                                            */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id -in- the collection to destroy.                              */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_destroy_collection(GD_COLLECTION        coln_id);
/*----------------------------------------------------------------------*/
/* EXTERN coln_clear_collection                                         */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Clears the collection but leaves the collection descriptor and the   */
/* associated basic collection data structure intact.                   */
/* The descriptor is in the same state as a descriptor that that has    */
/* just been built with <<coln_build_collection>>.                      */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id -in- the collection to clear.                                */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__ERROR   The collection type is not known.                     */
/*  GOTH__NOTCOLN The descriptor is not a collection.                   */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_clear_collection(GD_COLLECTION  coln_id);
/*----------------------------------------------------------------------*/
/* EXTERN coln_elements_unique                                          */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Test if the collection is a unique type collection.                  */
/* Some collection types hold unique values whereas others can hold     */
/* the same value a multiplicity of times.                              */
/* This routine informs the user of the uniqueness property of the      */
/* input collection.                                                    */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id -in-  the collection to test for uniqueness                  */
/* result -out- TRUE if elements are guaranteed to be unique.          !*/
/*              FALSE if they are not.                                  */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__NOTCOLN The descriptor is not a collection.                   */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_elements_unique(GD_COLLECTION   coln_id,
                                        GOTH_BOOLEAN    *result);
/*----------------------------------------------------------------------*/
/* EXTERN coln_number_of_elements                                       */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This routine returns the number of elements in the collection.       */
/* Multiple entries are not counted as a single element.                */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id -in-  the collection whose element count is required.        */
/* result  -out- the number of elements in the collection.              */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__NOTCOLN The descriptor is not a collection.	                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_number_of_elements(GD_COLLECTION        coln_id,
                                           GOTH_INTEGER         *result);
/*----------------------------------------------------------------------*/
/* EXTERN coln_test_in_collection                                       */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This routine tests if a specified element is in a collection.        */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id   -in- the collection to be tested.                          */
/* value     -in- the value to look for.                                */
/* result   -out- TRUE if element is in collection.                    !*/
/*                FALSE if it is not.                                   */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__NOTCOLN The  descriptor is not a collection.                  */
/*  GOTH__ERROR   The collection type not recognised.                   */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_test_in_collection(GD_COLLECTION        coln_id,
                                           GOTH_VALUE           value,
                                           GOTH_BOOLEAN         *result);
/*----------------------------------------------------------------------*/
/* EXTERN coln_matches_in_collection                                    */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This routine returns the number of elements in a collection which    */
/* match a specified value.                                             */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id -in-  the collection to test for matches.                    */
/* value   -in-  the value to look for matches.                         */
/* result  -out- the number of matches of value found.                  */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__NOTCOLN The descriptor is not a collection.                   */
/*  GOTH__ERROR   The collection type not recognised.                   */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_matches_in_collection(GD_COLLECTION     coln_id,
                                              GOTH_VALUE        value,
                                              GOTH_INTEGER      *result);
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_value_of_element                                     */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Get the value of an element in a collection. The position of the     */
/* element is determined by the arguments p1 and qual.                  */
/*                                                                      */
/* Possible values of p1 and use of the qual parameter are              */
/* @ CPT_POSITION - Locate the element to get by position.              */
/*                  qual then specifies the ordinal position of the     */
/*                  element to get.                                     */
/* @ CPT_VALUE    - Locate the element by its value. This is useful for	*/
/*		    DT_USER datatypes.					*/
/* @ CPT_FIRST    - Get the first element of the collection.            */
/*                  qual is not then used.                              */
/* @ CPT_LAST     - Get the last element of the collection.             */
/*                  qual is not then used.                              */
/* @ CPT_MARK     - Get the marked element of the collection.           */
/*                  qual then specifies the marked element to get.      */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id  -in-  the collection whose value is to be returned.         */
/* p1       -in-  which addressing mode to use.                         */
/* qual     -in-  positional qualifier for p1.                          */
/* value   -out-  the returned value of the specified element.          */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.      */
/*  GOTH__BADPOSN    Either p1 or qual are badly defined.               */
/*  GOTH__ERROR      The collection type is not known.                  */
/*  GOTH__NOTCOLN    The descriptor is not a collection.                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_value_of_element( GD_COLLECTION      coln_id,
                                              COLLECTION_WHICH   p1,
                                              GOTH_VALUE         qual,
                                              GOTH_VALUE         *value );
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_value_of_dict_value                                  */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Get the value of a dictionary element. The element is defined        */
/* by the arguments p1 and qual.                                        */
/*                                                                      */
/* Possible values of p1 and use of the qual parameter are              */
/* @ CPT_POSITION - Locate the element to get by position.              */
/*                  qual then specifies the ordinal position of the     */
/*                  element to get.                                     */
/* @ CPT_FIRST    - Get the first element of the collection.            */
/*                  qual is not then used.                              */
/* @ CPT_LAST     - Get the last element of the collection.             */
/*                  qual is not then used.                              */
/* @ CPT_MARK     - Get the marked element of the collection.           */
/*                  qual then specifies the marked element to get.      */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id  -in-  the dictionary whose value is to be returned.         */
/* p1       -in-  which addressing mode to use.                         */
/* qual     -in-  positional qualifier for p1.                          */
/* value   -out-  the returned value of the specified element.          */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL    Normal,successful completion.			*/
/*  GOTH__DESC      A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__BADPOSN   Either p1 or qual are badly defined.                */
/*  GOTH__FAIL      The value of p1 is set to CPT_VALUE.                */
/*  GOTH__ERROR     The collection type is not known.                   */
/*  GOTH__NOTCOLN   The descriptor is not a collection.                 */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_value_of_dict_value(GD_COLLECTION    coln_id,
                                                COLLECTION_WHICH p1,
                                                GOTH_VALUE       qual,
                                                GOTH_VALUE       *value);
/*----------------------------------------------------------------------*/
/* EXTERN coln_get_collection_sort_info                                 */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Get the ordering information for a collection. The returned data     */
/* enables the type of the collection to be determined.                 */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id       -in- the collection to investigate.                    */
/* ordered      -out- TRUE if collection is a list,                    !*/
/*                    otherwise FALSE.                                  */
/* closed       -out- TRUE if collection is a closed list,             !*/
/*                    otherwise FALSE.                                  */
/* unique       -out- TRUE if collection is a SET, BAG, DICT            */
/*                    or unique LIST,                                  !*/
/*                    otherwise FALSE.                                  */
/* simple_type  -out- datatype of main (key) values in collection.      */
/* desc_type    -out- datatype of descriptors in collection.            */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__NOTCOLN The descriptor is not a collection.                   */
/*  GOTH__ERROR   The collection type not recognised.                   */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_get_collection_sort_info(
                                GD_COLLECTION                   coln_id,
                                GOTH_BOOLEAN                    *ordered,
                                GOTH_BOOLEAN                    *closed,
                                GOTH_BOOLEAN                    *unique,
                                GOTH_DATATYPE                   *simple_type,
                                GOTH_DESCRIPTOR_DATATYPE        *desc_type);
/*----------------------------------------------------------------------*/
/* EXTERN coln_build_collection                                         */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Build a collection with the specified parameters.                    */
/* Dictionaries are never created by this routine.                      */
/* The type of collection built is determined by the input parameters.  */
/*                                                                      */
/* If ordered TRUE  and closed FALSE the collection is an open list.   !*/
/* If ordered TRUE  and closed TRUE  the collection is a closed list.  !*/
/* If ordered FALSE and unique TRUE  the collection is a set.          !*/
/* If ordered FALSE and unique FALSE the collection is a bag.          !*/
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id     -out- the collection to build.                           */
/* ordered     -in-  create an ordered collection.                      */
/* closed      -in-  create a closed collection.                        */
/* unique      -in-  create a collection of unique elements.            */
/* simple_type -in-  the datatype of the created collection.            */
/* desc_type   -in-  the descriptor type of the created collection if   */
/*                   the simple_type is a descriptor.                   */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__FAIL      An internal error has occured.                      */
/*  GOTH__MALLOC    No more virtual memory to allocate.                 */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_build_collection(
                         GD_COLLECTION                  *coln_id,
                         GOTH_BOOLEAN                   ordered,
                         GOTH_BOOLEAN                   closed,
                         GOTH_BOOLEAN                   unique,
                         GOTH_DATATYPE                  simple_type,
                         GOTH_DESCRIPTOR_DATATYPE       desc_type);
/*----------------------------------------------------------------------*/
/* EXTERN coln_add_element_to_collection                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Generic routine to add an element to a collection which is a set,    */
/* bag or list. Dictionaries are not handled, at present by this        */
/* routine because dictionaries are radically different from the other  */
/* sorts of collection.                                                 */
/* If the collection is a list then the element is added at the end of  */
/* the list.                                                            */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id -in- the collection to add the element to.                   */
/* element -in- element to add to the collection.                       */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL  Normal,successful completion.				*/
/*  GOTH__DESC    A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__EXISTS  No more identical elements can be added               */
/*  GOTH__ERROR   The collection datatype is not known.                 */
/*  GOTH__NOTCOLN The descriptor is not a collection.                   */
/*  GOTH__FAIL    An internal error has occured.                        */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_add_element_to_collection(
                                  GD_COLLECTION         coln_id,
                                  GOTH_VALUE            element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_remove_element_from_collection                           */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Generic routine to remove an element from a collection which is a set*/
/* bag or list. Dictionaries are not handled at present by this         */
/* routine because dictionaries are radically different from the other  */
/* sorts of collection.                                                 */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* coln_id -in- the collection to remove the element from.              */
/* element -in- element to remove from the collection.                  */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOSUCHELEM Element does not exist in the collection.          */
/*  GOTH__ERROR      The collection has unknown datatype.               */
/*  GOTH__FAIL       An internal error has occured.                     */
/*  GOTH__NOTCOLN    The descriptor is not a collection.                */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_remove_element_from_collection(GD_COLLECTION  coln_id,
                                                       GOTH_VALUE     element);
/*----------------------------------------------------------------------*/
/* EXTERN coln_remove_collection					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Generic routine to remove the elements in one collection from 	*/
/* another collection.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* source_coln		-in-	The source collection.			*/
/* 									*/
/* remove_coln		-in-	The collection to remove from the	*/
/* 				source collection.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_remove_collection(
					  GD_COLLECTION	source_coln,
					  GD_COLLECTION	remove_coln);
/*----------------------------------------------------------------------*/
/* EXTERN coln_copy_collection                                          */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Copy one collection into another. This routine is not very fast and  */
/* it is rather expensive in CPU and so should be used in CPU intensive */
/* areas.                                                               */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* source_coln -in-  the collection to copy from.                       */
/* dest_coln   -out- the collection to copy to.                         */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL     Normal,successful completion.			*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__DESC       A descriptor is corrupt or of the wrong type.	*/
/*  GOTH__NOSUCHELEM Element does not exist in the collection.          */
/*  GOTH__ERROR      The collection has unknown datatype.               */
/*  GOTH__FAIL       An internal error has occured.                     */
/*  GOTH__NOTCOLN    The descriptor is not a collection.                */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_copy_collection(GD_COLLECTION   source_coln,
                                        GD_COLLECTION   *dest_coln);
/*----------------------------------------------------------------------*/
/* EXTERN coln_merge_collections					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to merge two collection together, resulting in	*/
/* the source collection having the logical OR of both collections.	*/
/* The collections can be different types. The collections datatypes	*/
/* must be the same.							*/
/*									*/
/* When merging sets, duplicate entries are ignored.			*/
/*									*/
/* When merging lists, duplicate entries are ignored if the src list is	*/
/* unique. The merged collection is appended to the end of the src list.*/
/*									*/
/* When merging dictionarys, if both collections are dictionarys, when	*/
/* a key is found that is already in the source collection, the value	*/
/* associated with that key is overwritten by the merge value IF the	*/
/* overwrite parameter is TRUE.						*/
/*									*/
/* It is possible to merge a dictionary with a set, bag, or list, only	*/
/* the keys are merged into the source collection.			*/
/*									*/
/* It is NOT possible to merge a set, bag, or list with a dictionary,	*/
/* since no valid values would be available for the value field of the	*/
/* source dictionary.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* src_coln	-in-	Source collection to have another collection	*/
/*			merged with it. This collection is the		*/
/*			collection that will change size as a result of	*/
/*			the merge.					*/
/* merge_coln	-in-	Collection to merge with the source collection.	*/
/*			This collection does not need to be the same	*/
/*			type of collection as the source collection.	*/
/*			This collection main datatype must be the same	*/
/*			as the other collections main datatype.		*/
/* overwrite	-in-	Used when the source collection is a dictionary.*/
/*			If TRUE, the values associated with the key in	*/
/*			the merge collection overwrite the values in the*/
/*			source collection, IF there are keys that match	*/
/*			in each collection.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__ERROR		Wrong datatypes, or wrong collection types.	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_merge_collections(GD_COLLECTION	src_coln,
					  GD_COLLECTION	merge_coln,
					  GOTH_BOOLEAN	overwrite);

/*>>> EXTERN functions from COLN_CALLBACK.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN coln_apply_callback						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine applies the specified callback to all the elements in	*/
/* the specified collection.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* coln_id	-in-	The descriptor for the collection.		*/
/* 									*/
/* apply_fn	-in-	The pointer to the callback to be applied	*/
/* 			to all the elements in the collection.		*/
/*									*/
/* param	-in-	A caller supplied parameter to be passed to	*/
/* 			the apply callback whenever it is called.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_apply_callback(
				       GD_COLLECTION	coln_id,
				       COLN_APPLY_FN	apply_fn,
				       VOID_P		param);
/*----------------------------------------------------------------------*/
/* EXTERN coln_dict_apply_callback					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine applies the specified callback to all the keys and 	*/
/* elements in the specified collection.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* coln_id	-in-	The descriptor for the collection.		*/
/* 									*/
/* apply_fn	-in-	The pointer to the callback to be applied	*/
/* 			to all the elements in the collection.		*/
/*									*/
/* param	-in-	A caller supplied parameter to be passed to	*/
/* 			the apply callback whenever it is called.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_dict_apply_callback(
					    GD_COLLECTION	coln_id,
					    COLN_DICT_APPLY_FN	apply_fn,
					    VOID_P		param);
/*----------------------------------------------------------------------*/
/* EXTERN coln_apply_lull						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine allows a Lull callbable callback to be applied to	*/
/* all the elements in a collection.					*/
/* 									*/
/* The Lull callback is expected to have the following form:		*/
/* 									*/
/* integer callback_fn(DESCRIPTOR param_id,				*/
/* 		       integer    type,					*/
/* 		       any-type   value);				*/
/* 									*/
/* A callback must be supplied in which the type of the last argument	*/
/* matches that of the collection elements.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* coln_id	-in-	The descriptor for the collection.		*/
/* 									*/
/* function_name -in-	The name of the Lull callback to be applied	*/
/* 			to all the elements in the collection.		*/
/*									*/
/* param_id	-in-	A caller supplied DED parameter to be passed to	*/
/* 			the apply callback whenever it is called.	*/
/*			This may be null.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_apply_lull(
				   GD_COLLECTION	coln_id,
				   GOTH_STRING		function_name,
				   GOTH_DESCRIPTOR	param_id);
/*----------------------------------------------------------------------*/
/* EXTERN coln_dict_apply_lull						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine allows a Lull callbable callback to be applied to	*/
/* all the elements in a dictionary.					*/
/* 									*/
/* The Lull callback is expected to have the following form:		*/
/* 									*/
/* integer callback_fn(DESCRIPTOR param_id,				*/
/* 		       integer    key_type,				*/
/* 		       any-type   key,					*/
/* 		       integer    value_type,				*/
/* 		       any-type   value);				*/
/* 									*/
/* A callback must be supplied in which the type of the last argument	*/
/* matches that of the collection elements.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* coln_id	-in-	The descriptor for the dictionary.		*/
/* 									*/
/* function_name -in-	The name of the Lull callback to be applied	*/
/* 			to all the elements in the collection.		*/
/*									*/
/* param_id	-in-	A caller supplied DED parameter to be passed to	*/
/* 			the apply callback whenever it is called.	*/
/*			This may be null.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS coln_dict_apply_lull(
					GD_COLLECTION	coln_id,
					GOTH_STRING	function_name,
					GOTH_DESCRIPTOR	param_id);
 

#endif
/* $Header: /lslhome/gothic/hdr/colnlib/v1-6/RCS/hdr.coln_functions_new.h,v 1.7 1994/02/16 20:45:40 jon Exp $								*/
/* 									*/
/* $Log: hdr.coln_functions_new.h,v $
 * Revision 1.7  1994/02/16  20:45:40  jon
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
 *								*/
#endif
