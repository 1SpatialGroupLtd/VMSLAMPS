/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 17:57:20.000000000 +0000
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
#ifndef _GOTH_INTRINSICS
#define _GOTH_INTRINSICS
/* $Header: /usr/users/jon/RCS/hdr.goth_intrinsics.h,v 1.9 1995/01/22 20:01:19 jon Exp $								*/
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Jonathan Billing, 26-Apr-1990				*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		   G O T H _ I N T R I N S I C S . H 			*/
/*									*/
/* Part of GOTHIC module GOTHLIB					*/
/* Version 0.1, Jonathan Billing 26-Apr-1990				*/
/************************************************************************/

#include <stdarg.h>		/* For input_output.c			*/


/*----------------------------------------------------------------------*/
/* EXTERN *GOTH_U_COMP_FUNC						*/
/*......................................................................*/
/* In	:	addr1, addr2.	Addresses of two arguments to compare	*/
/* Out	:	*result.	Pointer to result			*/
/*				which is one of GOTH__GT,GOTH__LT or	*/
/*				GOTH__EQ				*/
/* Ret	:	GOTH_STATUS.	OK or not.				*/
/* User defined data type compare function.				*/
/*----------------------------------------------------------------------*/

typedef GOTH_STATUS (*GOTH_U_COMP_FUNC)(VOID_P		addr1,
				        VOID_P		addr2,
				        GOTH_STATUS	*result);


/*----------------------------------------------------------------------*/
/* EXTERN *GOTH_U_IDENT_FUNC						*/
/*......................................................................*/
/* In	:	addr1, addr2.	Addresses of two arguments to compare	*/
/* Out	:	*result.	Pointer to result.			*/
/* Ret	:	GOTH_STATUS.	OK or not.				*/
/* User defined data type identity function.				*/
/*----------------------------------------------------------------------*/

typedef GOTH_STATUS (*GOTH_U_IDENT_FUNC)(VOID_P		addr1,
				         VOID_P		addr2,
				         GOTH_BOOLEAN	*result);


/*----------------------------------------------------------------------*/
/* EXTERN *GOTH_U_COPY_FUNC						*/
/*......................................................................*/
/* In	:	addr1.	Address of arguments to copy			*/
/* Out	:	*addr2.	Pointer to where copy exists			*/
/* Ret	:	GOTH_STATUS.	OK or not.				*/
/* User defined data type copy function.				*/
/*----------------------------------------------------------------------*/

typedef GOTH_STATUS (*GOTH_U_COPY_FUNC)(VOID_P		in_addr,
				        VOID_P		*out_addr);


/*----------------------------------------------------------------------*/
/* EXTERN *GOTH_U_DEL_FUNC						*/
/*......................................................................*/
/* In	:	addr1		Address of data type to delete		*/
/* Out	:								*/
/* Ret	:	GOTH_STATUS.	OK or not.				*/
/* User defined data type deletion function.				*/
/*----------------------------------------------------------------------*/

typedef GOTH_STATUS (*GOTH_U_DEL_FUNC)(VOID_P		addr1);


/*----------------------------------------------------------------------*/
/* EXTERN *GOTH_U_PRINT_FUNC						*/
/*......................................................................*/
/* In   :	interface_id	Output interface to display on.		*/
/* In	:	addr1		Address of data type to print		*/
/* Out	:								*/
/* Ret	:	GOTH_STATUS.	OK or not.				*/
/* User defined data type printing function.				*/
/*----------------------------------------------------------------------*/

typedef GOTH_STATUS (*GOTH_U_PRINT_FUNC)(GOTH_DESCRIPTOR	interface_id,
					 VOID_P			addr1);


/*>>> EXTERN functions from GOTH_USER_ADDRESS.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_alloc_user_address		       			*/
/*......................................................................*/
/* In	:	Nothing.						*/
/* Out	:	Nothing.						*/
/* Ret	:	GOTH_DESCRIPTOR.					*/
/*									*/
/* Allocate a user defined data type.	 				*/
/*----------------------------------------------------------------------*/

extern GOTH_DESCRIPTOR goth_alloc_user_address();

/*----------------------------------------------------------------------*/
/* EXTERN goth_create_user_address					*/
/*......................................................................*/
/* In	:	GOTH_DESCRIPTOR		user_addr_id.			*/
/*		GOTH_U_COMP_FUNC	user_comp_func.			*/
/*		GOTH_U_IDENT_FUNC	user_ident_func.		*/
/*		GOTH_U_COPY_FUNC	user_copy_func.			*/
/*		GOTH_U_DEL_FUNC		user_del_func.			*/
/*		GOTH_U_PRINT_FUNC	user_print_func.		*/
/* Out	:	Nothing.						*/
/* Ret	:	GOTH_STATUS.						*/
/*									*/
/* Create a user defined data type in memory allocated by previous func.*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_create_user_address(
					    GOTH_DESCRIPTOR   user_addr_id,
					    GOTH_U_COMP_FUNC  user_comp_func,
				            GOTH_U_IDENT_FUNC user_ident_func,
					    GOTH_U_COPY_FUNC  user_copy_func,
					    GOTH_U_DEL_FUNC   user_del_func,
					    GOTH_U_PRINT_FUNC user_print_func);

/*----------------------------------------------------------------------*/
/* EXTERN goth_delete_user_address					*/
/*......................................................................*/
/* In	:	GOTH_DESCRIPTOR user_addr_id				*/
/* Out	:	Nothing.						*/
/* Ret	:	GOTH_STATUS.						*/
/*									*/
/* Delete a user defined data type.	 				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_delete_user_address(GOTH_DESCRIPTOR user_addr_id);

/*----------------------------------------------------------------------*/
/* EXTERN goth_free_user_address					*/
/*......................................................................*/
/* In	:	GOTH_DESCRIPTOR user_addr_id				*/
/* Out	:	Nothing.						*/
/* Ret	:	GOTH_STATUS.						*/
/*									*/
/* Delete a descriptor block for a user defined data type.	 	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_free_user_address(GOTH_DESCRIPTOR user_addr_id);

/*----------------------------------------------------------------------*/
/* EXTERN goth_build_user_address					*/
/*......................................................................*/
/* In	:	GOTH_DESCRIPTOR		*user_addr_id.			*/
/*		GOTH_U_COMP_FUNC	user_comp_func.			*/
/*		GOTH_U_IDENT_FUNC	user_ident_func.		*/
/*		GOTH_U_COPY_FUNC	user_copy_func.			*/
/*		GOTH_U_DEL_FUNC		user_del_func.			*/
/*		GOTH_U_PRINT_FUNC	user_print_func.		*/
/* Out	:	GOTH_DESCRIPTOR		*user_addr_id.			*/
/* Ret	:	GOTH_STATUS.						*/
/*									*/
/* Allocate and Create a user defined data type.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_build_user_address(
					    GOTH_DESCRIPTOR   *user_addr_id,
					    GOTH_U_COMP_FUNC  user_comp_func,
				            GOTH_U_IDENT_FUNC user_ident_func,
					    GOTH_U_COPY_FUNC  user_copy_func,
					    GOTH_U_DEL_FUNC   user_del_func,
					    GOTH_U_PRINT_FUNC user_print_func);

/*----------------------------------------------------------------------*/
/* EXTERN goth_destroy_user_address					*/
/*......................................................................*/
/* In	:	GOTH_DESCRIPTOR user_addr_id				*/
/* Out	:	Nothing.						*/
/* Ret	:	GOTH_STATUS.						*/
/*									*/
/* Delete a user defined data type and its descriptor block.	 	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_destroy_user_address(GOTH_DESCRIPTOR user_addr_id);

/*----------------------------------------------------------------------*/
/* EXTERN goth_user_compare_address					*/
/*......................................................................*/
/* In	: addr1, addr2. Two addresses to compare.			*/
/* Out	: *result. Pointer to result of compare.			*/
/* Ret	: GOTH_STATUS							*/
/*									*/
/* Compare two user defined data types.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_user_compare_address(GOTH_VALUE		addr1,
					     GOTH_VALUE		addr2,
					     GOTH_INTEGER	*result);

/*----------------------------------------------------------------------*/
/* EXTERN goth_user_same_address					*/
/*......................................................................*/
/* In	: addr1, addr2. user_data_type values to compare.		*/
/* Out	: *result. Pointer to TRUE/FALSE result for identity check.	*/
/* Ret	: GOTH_STATUS							*/
/*									*/
/* Test if both input values are the same.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_user_same_address(GOTH_VALUE	addr1,
					  GOTH_VALUE	addr2,
					  GOTH_BOOLEAN	*result);

/*----------------------------------------------------------------------*/
/* EXTERN goth_user_copy_address					*/
/*......................................................................*/
/* In	: addr1.	Data type to copy.				*/
/* Out	: addr2.	Where to copy data type to.			*/
/* Ret	: GOTH_STATUS							*/
/*									*/
/* Copy one data item to another.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_user_copy_address(GOTH_VALUE	in_addr,
					  GOTH_VALUE	*out_addr);

/*----------------------------------------------------------------------*/
/* EXTERN goth_user_delete_address					*/
/*......................................................................*/
/* In	: Data type to delete.						*/
/* Out	: 								*/
/* Ret	: GOTH_STATUS							*/
/*									*/
/* Delete a user defined data type.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_user_delete_address(GOTH_VALUE	addr);

/*----------------------------------------------------------------------*/
/* EXTERN goth_user_print_address					*/
/*......................................................................*/
/* In   : interface_id	Output interface to display on.			*/
/* In	: Addr1.	Data type to print.				*/
/* Out	:								*/
/* Ret	: GOTH_STATUS							*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_user_print_address(GOTH_DESCRIPTOR	interface_id,
					   GOTH_VALUE		Addr1);

/*>>> EXTERN functions from GOTH_MEM_DESCRIPTOR.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_md_free							*/
/*......................................................................*/
/* Routine to free the space allocated for the descriptor.	 	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  goth_md_free(GOTH_MEM_DESCRIPTOR mem_desc) ;

/*----------------------------------------------------------------------*/
/* EXTERN goth_md_free_list						*/
/*......................................................................*/
/* Routine to free the space allocated for the descriptor list passed 	*/
/* to this routine.							*/
/*									*/
/* If the "free_memory" parameter is TRUE, the memory pointed at by 	*/
/* each descriptor will also be freed.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_md_free_list(
			      GOTH_MEM_DESCRIPTOR *list,
			      GOTH_BOOLEAN	free_memory);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_create_string						*/
/*......................................................................*/
/* Routine to allocate space for a string and its descriptor,		*/
/* and return a pointer to the string descriptor.			*/
/* 									*/
/* The descriptor will be added to a list of descriptors passed as	*/
/* "list", providing "list" is non null.				*/
/* 									*/
/* The string will have "string_length" characters.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_md_create_string(
				  GOTH_INTEGER		string_length,
				  GOTH_MEM_DESCRIPTOR	*descriptor,
				  GOTH_MEM_DESCRIPTOR	*list);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_params						*/
/*......................................................................*/
/* Routine to return the defining parameters of a MEM_DESCRIPTOR	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_md_params(GOTH_MEM_DESCRIPTOR    descriptor,
			   GOTH_MEM_DESCRIPTOR_DATATYPE  *type,
			   GOTH_INTEGER	                 *element_count,
			   GOTH_INTEGER		         *string_length) ;
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_copy							*/
/*......................................................................*/
/* Routine to copy a mem descriptor to another mem descriptor involving */
/* copying of all arrays, arrays of strings etc.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_md_copy(GOTH_MEM_DESCRIPTOR         in_descriptor,
				GOTH_MEM_DESCRIPTOR        *out_descriptor,
				GOTH_MEM_DESCRIPTOR        *list) ;
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_create_array						*/
/*......................................................................*/
/* Routine to allocate space for an array and its descriptor,		*/
/* and return a to the array descriptor.				*/
/*									*/
/* The array descriptor will be added to a list of such descriptors,	*/
/* passed as "list", provided "list" is non null.			*/
/* 									*/
/* The array will have "element_count" elements.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_md_create_array(
				 GOTH_INTEGER		element_count,
				 GOTH_MEM_DESCRIPTOR	*descriptor,
				 GOTH_MEM_DESCRIPTOR	*list);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_create_string_array					*/
/*......................................................................*/
/* Routine to allocate space for a string array, its descriptor, and	*/
/* each of its string elements. The routine returns a pointer to the	*/
/* array descriptor							*/
/*									*/
/* The descriptor will be added to a list of descriptors passed as 	*/
/* "list", provided "list" is non null.					*/
/* 									*/
/* The array will have "element_count" elements, which will point to	*/
/* descriptors for strings of "string_length" characters.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_md_create_string_array(
					GOTH_INTEGER		element_count,
					GOTH_INTEGER		string_length,
					GOTH_MEM_DESCRIPTOR	*descriptor,
					GOTH_MEM_DESCRIPTOR	*list);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_create_memory						*/
/*......................................................................*/
/* Routine to create and add a descriptor for a dynamically allocated	*/
/* piece of memory, and to allocate that memory				*/
/* 									*/
/* If a pointer to the start of a list of descriptors is specified,	*/
/* the new descriptor will be added to that list. If the "list"		*/
/* parameter is NULL, the descriptor is not added to a list.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   goth_md_create_memory(
			 GOTH_MEM_DESCRIPTOR_DATATYPE	type,
			 GOTH_INTEGER			element_count,
			 GOTH_INTEGER			element_size,
			 GOTH_MEM_DESCRIPTOR 		*descriptor,
			 GOTH_MEM_DESCRIPTOR 		*list);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_create						*/
/*......................................................................*/
/* Routine to create and add a descriptor for a dynamically allocated	*/
/* piece of memory.							*/
/* 									*/
/* If a pointer to the start of a list of descriptors is specified,	*/
/* the new descriptor will be added to that list. If the "list"		*/
/* parameter is NULL, the descriptor is not added to a list.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS	goth_md_create(
			       GOTH_MEM_DESCRIPTOR_DATATYPE	type,
			       GOTH_SPECIAL			memory,
			       GOTH_INTEGER			element_count,
			       GOTH_MEM_DESCRIPTOR 		*descriptor,
			       GOTH_MEM_DESCRIPTOR 		*list);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_alter_array_size					*/
/*......................................................................*/
/* Routine to alter the size of the array passed in the "descriptor"	*/
/* parameter to that specified by the "element_count" argument.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   goth_md_alter_array_size(
			    GOTH_MEM_DESCRIPTOR	descriptor,
			    GOTH_INTEGER	element_count);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_alter_string_array_size				*/
/*......................................................................*/
/* Routine to alter the size of the array passed in the "descriptor"	*/
/* parameter to that specified by the "element_count" argument.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   goth_md_alter_string_array_size(
				   GOTH_MEM_DESCRIPTOR	descriptor,
				   GOTH_INTEGER		element_count);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_get_array_element					*/
/*......................................................................*/
/* Routine to retrieve the specified element, of type "GOTH_VALUE", 	*/
/* from the descriptored array.						*/
/* 									*/
/* The offset should be in the range 1 to the number of elements in	*/
/* the array.								*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_md_get_array_element(
					  GOTH_MEM_DESCRIPTOR descriptor,
					  GOTH_INTEGER		offset,
					  GOTH_VALUE		*value);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_put_array_element					*/
/*......................................................................*/
/* Routine to store the specified element, of type "GOTH_VALUE", 	*/
/* in the descriptored array.						*/
/* 									*/
/* The offset should be in the range 1 to the number of elements in	*/
/* the array.								*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_md_put_array_element(
					  GOTH_MEM_DESCRIPTOR descriptor,
					  GOTH_INTEGER		offset,
					  GOTH_VALUE		value);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_strlen       						*/
/*......................................................................*/
/* Routine to return the number of characters before the terminating	*/
/* NULL in a string, the descriptor for which is passed to this 	*/
/* routine.								*/
/*----------------------------------------------------------------------*/

extern int goth_md_strlen(
			GOTH_MEM_DESCRIPTOR descriptor);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_strcpy       						*/
/*......................................................................*/
/* Routine to copy the string, with "descriptor2", into the string with	*/
/* "descriptor1", extending the string copied to if needed.		*/
/*----------------------------------------------------------------------*/

extern GOTH_MEM_DESCRIPTOR goth_md_strcpy(
				      GOTH_MEM_DESCRIPTOR descriptor1,
				      GOTH_MEM_DESCRIPTOR descriptor2);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_strcat						*/
/*......................................................................*/
/* Routine to concatenate the string, with "descriptor2", onto the	*/
/* string with "descriptor1", extending the string copied to if needed.	*/
/*----------------------------------------------------------------------*/

extern GOTH_MEM_DESCRIPTOR goth_md_strcat(
				      GOTH_MEM_DESCRIPTOR descriptor1,
				      GOTH_MEM_DESCRIPTOR descriptor2);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_strcmp						*/
/*......................................................................*/
/* Routine to compare the string, with "descriptor1", with the string	*/
/* with "descriptor2", returning the following:				*/
/* 									*/
/* 		d1 < d2		return < 0				*/
/* 		d1 = d2		return 0				*/
/* 		d1 > d2		return > 0				*/
/*----------------------------------------------------------------------*/

extern int goth_md_strcmp(
			  GOTH_MEM_DESCRIPTOR descriptor1,
			  GOTH_MEM_DESCRIPTOR descriptor2);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_strncmp						*/
/*......................................................................*/
/* Routine to compare n characters of the string, with "descriptor1",	*/
/* with n characters of the string  with "descriptor2", returning the	*/
/* following:								*/
/* 									*/
/* 		d1 < d2		return < 0				*/
/* 		d1 = d2		return 0				*/
/* 		d1 > d2		return > 0				*/
/*----------------------------------------------------------------------*/

extern int goth_md_strncmp(
			  GOTH_MEM_DESCRIPTOR	descriptor1,
			  GOTH_MEM_DESCRIPTOR	descriptor2,
			  GOTH_INTEGER		n);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_strncpy      						*/
/*......................................................................*/
/* Routine to copy up to n characters of the string, with "descriptor2",*/
/* into the string with "descriptor1", extending the string copied to   */
/* if needed. The string in "descriptor1" is always null terminated.	*/
/*----------------------------------------------------------------------*/

extern GOTH_MEM_DESCRIPTOR goth_md_strncpy(
				      GOTH_MEM_DESCRIPTOR descriptor1,
				      GOTH_MEM_DESCRIPTOR descriptor2,
				      GOTH_INTEGER        n);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_copy_string						*/
/*......................................................................*/
/* Routine to copy the C string, "string", into the string with		*/
/* "descriptor", extending the string copied to if needed.		*/
/*----------------------------------------------------------------------*/

extern GOTH_MEM_DESCRIPTOR goth_md_copy_string(
				       GOTH_MEM_DESCRIPTOR descriptor,

				       GOTH_STRING         string);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_append_string						*/
/*......................................................................*/
/* Routine to concatenate the C string, "string", onto the string with 	*/
/* "descriptor", extending the string copied to if needed.		*/
/*----------------------------------------------------------------------*/

extern GOTH_MEM_DESCRIPTOR goth_md_append_string(
					 GOTH_MEM_DESCRIPTOR descriptor,
					 GOTH_STRING         string);
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_sizeof						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Calculate the memory occupied by a memory descriptor.	        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* md		-in- The memory descriptor for which the size is to be	*/
/*		     returned.						*/
/*									*/
/* size		-out- The number of bytes of memory occupied by the	*/
/*		      memory descriptor (not including the size of the	*/
/*		      GOTH_MEM_DESCRIPTOR structure.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__MEM_DESC	Memory descriptor has bad type.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_md_sizeof(GOTH_MEM_DESCRIPTOR	md,
				  GOTH_INTEGER	       *size);

/*>>> EXTERN functions from GOTH_DATATYPES.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_get_DT_description					*/
/*......................................................................*/
/*									*/
/* Routine that takes a GOTH_DATATYPE and returns a textural description*/
/* of it								*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_get_DT_description(
					   GOTH_DATATYPE	type,
					   GOTH_STRING		*description);
/*----------------------------------------------------------------------*/
/* EXTERN goth_DT_to_text						*/
/*......................................................................*/
/* Routine to return a readonly pointer to the description string	*/
/* for a specified DT_ enumeration element.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STRING goth_DT_to_text(GOTH_DATATYPE	type);
/*----------------------------------------------------------------------*/
/* EXTERN goth_DT_Lull_to_text						*/
/*......................................................................*/
/* Routine to return a readonly pointer to the description string for a */
/* specified DT_ Lull constant string element.			        */
/*----------------------------------------------------------------------*/

extern GOTH_STRING goth_DT_Lull_to_text(GOTH_DATATYPE	type);
/*----------------------------------------------------------------------*/
/* EXTERN goth_get_DDT_description					*/
/*......................................................................*/
/*									*/
/* Routine that takes a GOTH_DESCRIPTOR_DATATYPE and returns a textural	*/
/* description of it							*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_get_DDT_description(
				    GOTH_DESCRIPTOR_DATATYPE	type,
				    GOTH_STRING		*description);
/*----------------------------------------------------------------------*/
/* EXTERN goth_DDT_to_text						*/
/*......................................................................*/
/* Routine to return a readonly pointer to the description string	*/
/* for a specified DDT_ enumeration element.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STRING goth_DDT_to_text(GOTH_DESCRIPTOR_DATATYPE	type);
/*----------------------------------------------------------------------*/
/* EXTERN goth_DDT_Lull_to_text						*/
/*......................................................................*/
/* Routine to return a readonly pointer to the Lull constant string	*/
/* for a specified DDT_ enumeration element.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STRING goth_DDT_Lull_to_text(GOTH_DESCRIPTOR_DATATYPE	type);
/*----------------------------------------------------------------------*/
/* EXTERN goth_get_MDT_description					*/
/*......................................................................*/
/*									*/
/* Routine that takes a GOTH_MEM_DESCRIPTOR_DATATYPE and returns a 	*/
/* textural description of it						*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_get_MDT_description(
			       GOTH_MEM_DESCRIPTOR_DATATYPE	type,
			       GOTH_STRING		*description);
/*----------------------------------------------------------------------*/
/* EXTERN goth_MDT_to_text						*/
/*......................................................................*/
/* Routine to return a readonly pointer to the description string	*/
/* for a specified MDT_ enumeration element.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STRING goth_MDT_to_text(GOTH_MEM_DESCRIPTOR_DATATYPE	type);


/*>>> EXTERN functions from SIGNAL_HANDLER.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_establish_signal_handler					*/
/*......................................................................*/
/* Code to set up the exerimental signal handling routine for 		*/
/* all possible signals 						*/
/*									*/
/* Establish the GOTHIC platform signal handling 			*/
/*									*/
/* This routine will establish a hardcoded set of signal handlers, and	*/
/* then call a routine for which those signals will be handled.		*/
/* The routine to be called is passed to this routine as a parameter.	*/
/*									*/
/* The return codes of this routine are as follows: 			*/
/*  									*/
/* GOTH__NORMAL			When signal handler is successfully	*/
/*				established. 				*/
/* 									*/
/* GOTH__CONTSIG		When a signal has been trapped and	*/
/*				dealt with successfully. The program	*/
/*				should continue processing from a	*/
/*				suitable warmstart point.		*/
/*									*/
/* GOTH__STOPSIG		When a signal has been trapped, and	*/
/*				the program should exit.		*/
/*									*/
/* The use of general status codes is, hopefully, temporary, and	*/
/* more precise and descriptive ones will be introduced when		*/
/* appropriate.								*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   goth_establish_signal_handler(
				 GOTH_STATUS	(*continue_func)(),
				 ...);
/*----------------------------------------------------------------------*/
/* EXTERN goth_remove_signal_handler					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine sets all the signal handlers back to their default	*/
/* actions.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_remove_signal_handler();


/*>>> EXTERN functions from INPUT_OUTPUT.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_vprintf							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* This routine is the core routine that is responsible for outputting	*/
/* text. It is called by most of the other ???_?printf functions.       */
/* If the descriptor is NULL the output goes to goth_stdout, otherwise	*/
/* it goes to the generic printf routine.				*/
/* This function takes the same arguments as "vprintf".			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_vprintf(GOTH_DESCRIPTOR	interface_id,
				char		*format,
				va_list		parameter_list);
/*----------------------------------------------------------------------*/
/* EXTERN goth_printf							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine prints a formatted message to the specified display 	*/
/* device. 								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* interface_id -in- The output display device.				*/
/* format       -in- The string and $$format$$ information. The 	*/
/*		     arguments following the format are a list of 	*/
/*		     parameters	whose type is determined from the 	*/
/*		     format string. The format string has the same  	*/
/*		     form as the format string used in the C run-time 	*/
/*		     library function printf. Two new format specifiers	*/
/*		     are %b and %B which specify the following:		*/
/*									*/
/*		     %B - Uppercase boolean (ie. TRUE)			*/
/*		     %b - Lowercase boolean (ie. true)			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL	Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_printf(GOTH_DESCRIPTOR 	interface_id,
			       GOTH_STRING	format,
			       ...);
/*----------------------------------------------------------------------*/
/* EXTERN goth_process_backslashes					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* this routine goes through a character string replacing backslash	*/
/* escape sequences by their ASCII equivalents				*/
/* it works recursively by calling itself for each significant bslash	*/
/* and replacing the escape sequences as it unwinds			*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*----------------------------------------------------------------------*/
extern GOTH_STATUS goth_process_backslashes(char *literal_string);
/*----------------------------------------------------------------------*/
/* EXTERN goth_beep							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine produces a `beep' noise from the display that contains	*/
/* the interface parent. The loudness of the beep is dependant on the	*/
/* percent argument and the base volume of the display.	If percent is 	*/
/* set to zero then the default volume of the display is used. A value 	*/
/* of plus 100 specifies that the loudest beep possible on the 		*/
/* display, irrespective of the setting of the display, is used and 	*/
/* minus 100 will always be inaudible, irrespective of the volume 	*/
/* setting of the display.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* parent	-in-	Identifier of any interface. The shell of this	*/
/*			interface is fetched and used to determine the	*/
/*			display to send the beep to.			*/
/* percent	-in-	How loud the beep should be. This takes a value */
/*			of between plus 100 and minus 100. Zero 	*/
/*			specifies to use the default volume of the 	*/
/*			display. Plus 100 will always be the loudest 	*/
/*			beep possible and minus 100 will always be 	*/
/*			inaudible.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successfully completion.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_beep(GOTH_DESCRIPTOR	parent,
			     GOTH_INTEGER	percent);

/*>>> EXTERN functions from GOTH_VALUE.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_value_print						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Print the goth_value's datatype value..???				*/
/* 									*/
/* In	:	out_id		used to determine output device		*/
/*				(ie: goth_stdout, history_id etc..)	*/
/*		value		Value to print.				*/
/*		datatype	Datatype of value to print.		*/
/* Out	:	NOTHING							*/
/* Ret	:	GOTH__NORMAL						*/
/*		GOTH__BADCASEVALUE	Unknown datatype.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_print(
				    GOTH_DESCRIPTOR	out_id,
				    GOTH_VALUE		value,
				    GOTH_DATATYPE	datatype);
/*----------------------------------------------------------------------*/
/* EXTERN goth_value_print_value					*/
/*......................................................................*/
/* Print the value's datatype value..???				*/
/* 									*/
/* In	:	out_id		used to determine output device		*/
/*				(ie: goth_stdout, history_id etc..)	*/
/*		value		Value to print.				*/
/*		datatype	Datatype of value to print.		*/
/* Out	:	NOTHING							*/
/* Ret	:	GOTH__NORMAL						*/
/*		GOTH__BADCASEVALUE	Unknown datatype.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_print_value(GOTH_DESCRIPTOR	out_id,
					  VOID_P		value,
					  GOTH_DATATYPE		datatype);
/*----------------------------------------------------------------------*/
/* EXTERN goth_value_same						*/
/*......................................................................*/
/* Compare two GOTH_VALUE values, assumed to be of an indicated		*/
/* datatype								*/
/*									*/
/* one		- in  - the first variable				*/
/* two		- in  - the second variable				*/
/* datatype	- in  - what datatype they are				*/
/* *result	- out - TRUE if they are the same			*/
/*			FALSE if they are not				*/
/* Ret	:	GOTH__NORMAL	if OK					*/
/*		GOTH__BADCASEVALUE	Unknown datatype.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_same(GOTH_VALUE		one,
				   GOTH_VALUE		two,
				   GOTH_DATATYPE	datatype,
				   GOTH_BOOLEAN		*result);

/*----------------------------------------------------------------------*/
/* EXTERN goth_same_typed_value						*/
/*......................................................................*/
/*..HIDE................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine that determines if two typed GOTH_VALUEs are the same. 	*/
/* Clearly if they have different types they are not.			*/
/* DO NOT call this function, it is here as GOTH_VALUE_SAME needs it.   */
/*..ARGUMENTS...........................................................*/
/*..RETURN-CODES........................................................*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_same_typed_value(
					 GOTH_VALUE	v1,
					 GOTH_VALUE	v2,
					 GOTH_BOOLEAN	*ret_result );


/*----------------------------------------------------------------------*/
/* EXTERN goth_compare_typed_value					*/
/*......................................................................*/
/*..HIDE................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to compare two typed GOTH_VALUEs. If the types are not the 	*/
/* same then, quite arbitarily, they are ranked according to their	*/
/* This has to be extern for GOTH_COMARE_VALUE, not should be be called.*/
/* DATATYPE.								*/
/*..ARGUMENTS...........................................................*/
/*..RETURN-CODES........................................................*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_compare_typed_value(
					    GOTH_VALUE	v1,
					    GOTH_VALUE	v2,
					    GOTH_STATUS	*ret_result );
     

/*----------------------------------------------------------------------*/
/* EXTERN goth_value_compare						*/
/*......................................................................*/
/* Compare two goth values of the same type. If the function has not	*/
/* been implemented for a specific type then GOTH__NOTIMPLEMENTED is	*/
/* returned. If the datatype is unknown then GOTH__BADCASEVALUE.	*/
/*									*/
/* In	: one		First goth value to compare			*/
/*	  two		Second goth value to compare			*/
/*	  datatype	Datatype for comparison				*/
/* Out	: *result	Result. GOTH__GT, GOTH__EQ, GOTH__LT.		*/
/* Ret	: 	GOTH__NORMAL						*/
/*		GOTH__BADCASEVALUE					*/
/*		GOTH__NOTIMPLEMENTED					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_compare(GOTH_VALUE	one,
				      GOTH_VALUE	two,
				      GOTH_DATATYPE	datatype,
				      GOTH_STATUS	*result);
/*----------------------------------------------------------------------*/
/* EXTERN goth_value_compare_value					*/
/*......................................................................*/
/* Compare a goth value and a value of the same type. If the function	*/
/* has not been implemented for a specific type then			*/
/* GOTH__NOTIMPLEMENTED is returned. If the datatype is unknown then	*/
/* GOTH__BADCASEVALUE.							*/
/*									*/
/* In	: one		First goth value to compare			*/
/*	  two		pointer to Second value to compare		*/
/*	  datatype	Datatype for comparison				*/
/* Out	: *result	Result. GOTH__GT, GOTH__EQ, GOTH__LT.		*/
/* Ret	: 	GOTH__NORMAL						*/
/*		GOTH__BADCASEVALUE					*/
/*		GOTH__NOTIMPLEMENTED					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_compare_value(GOTH_VALUE		one,
					    VOID_P		two,
					    GOTH_DATATYPE	datatype,
					    GOTH_STATUS		*result);
/*----------------------------------------------------------------------*/
/* EXTERN goth_value_insert						*/
/*......................................................................*/
/* Insert a datatype into a GOTH_VALUE. Check the implementation is	*/
/* what you expect.. some of the types allocate memory and some don't	*/
/*									*/
/* In	:	datatype	Type of data to be inserted in GOTH_VAL	*/
/* 		bap		Pointer to data to insert		*/
/* Out	:	*value		Pointer to GOTH_VALUE to update		*/
/* Ret	:	GOTH__NORMAL if all OK					*/
/*		GOTH__BADCASEVALUE	Unknown datatype.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_insert(GOTH_VALUE		*value,
				     VOID_P		datapointer,
				     GOTH_DATATYPE	datatype);
/*----------------------------------------------------------------------*/
/* EXTERN goth_value_copy						*/
/*......................................................................*/
/* Copy one goth_value to another goth_value. Both GOTH_VALUES EXIST	*/
/* before the copy, but the destination one is empty.			*/
/* Check the implementation is what you expect.. some of the types	*/
/* allocate memory and some don't					*/
/*									*/
/* In	:	source		Pointer to source goth_value		*/
/*		datatype	Type of data to be inserted in GOTH_VAL	*/
/* Out	:	*dest		Pointer to GOTH_VALUE to update		*/
/* Ret	:	GOTH__NORMAL if all OK					*/
/*		GOTH__BADCASEVALUE	Unknown datatype.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_copy(GOTH_VALUE		source,
				   GOTH_VALUE		*dest,
				   GOTH_DATATYPE	datatype);
/*----------------------------------------------------------------------*/
/* EXTERN goth_value_address						*/
/*......................................................................*/
/* Routine to return the address of an element in a GOTH_VALUE.	For a	*/
/* string this returns the address of the string and not the address of	*/
/* the pointer to the string.						*/
/*									*/
/* In	:	*value		GOTH_VALUE to use.			*/
/*		datatype	Datatype to check.			*/
/* Out	:	*address	Address of datatype in *value.		*/
/* Ret	:	GOTH__NORMAL						*/
/*		GOTH__BADCASEVALUE	Unknown datatype.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_address(GOTH_VALUE	*value,
				      GOTH_DATATYPE	datatype,
				      VOID_P		*address);
/*----------------------------------------------------------------------*/
/* EXTERN goth_value_free						*/
/*......................................................................*/
/* Free the space associated with a goth_value				*/
/*									*/
/* value	-in- the value						*/
/* datatype	-in- what datatype the value is				*/
/*									*/
/* Returns GOTH__NORMAL		 if it thinks it has succeeded		*/
/*	   GOTH__NOTIMPLEMENTED  for those options that aren't		*/
/*	   GOTH__BADCASEVALUE	 Unknown datatype.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_free(GOTH_VALUE		value,
				   GOTH_DATATYPE	datatype);
/*----------------------------------------------------------------------*/
/* EXTERN goth_value_sizeof						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Return the number of bytes of storage used by a GOTH_VALUE, given    */
/* the value and its type.  This includes the size of the union itself  */
/* plus the size of any referenced data (if known).		        */
/*									*/
/* If the value holds a descriptor which has registered a sizeof        */
/* function with genlib, that callback will be used.  Otherwise, the    */
/* size of the descriptor itself is assumed to be GOTH_DESCRIPTOR_SIZE. */
/* The size of a user defined datatype is unknown and will be returned  */
/* as the size of the GOTH_VALUE.				        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* value	-in- The GOTH_VALUE.					*/
/* 									*/
/* type		-in- The Gothic datatype of the data stored in the	*/
/*		     GOTH_VALUE.					*/
/*									*/
/* size		-out- The number of bytes used by the GOTH_VALUE.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__BADCASEVALUE	Unknown datatype.				*/
/* 									*/
/* GOTH_ERROR		Type is DT_NULL.				*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_sizeof(GOTH_VALUE		value,
				     GOTH_DATATYPE	type,
				     GOTH_INTEGER      *size);
/*----------------------------------------------------------------------*/
/* EXTERN goth_value_copy_array						*/
/*......................................................................*/
/* Copy an array of GOTH_VALUEs to a new array of GOTH_VALUEs. The new	*/
/* array is allocated by this routine. If copy_types is TRUE the type	*/
/* array is also copied.						*/
/*									*/
/* In	:	source_array	Source array of GOTH_VALUEs.		*/
/*		source_types	Source array of GOTH_VALUE datatypes.	*/
/*		copy_types	TRUE if should copy source_types array.	*/
/*		array_length	Number of GOTH_VALUEs to copy.		*/
/* Out	:	*dest_array	Destination GOTH_VALUE array after copy.*/
/*		*dest_types	Destination datatypes array after copy.	*/
/* Ret	:	GOTH__NORMAL.						*/
/*	        GOTH__BADCASEVALUE	 Unknown datatype.		*/
/*		GOTH__FAIL.	Negative array length.			*/
/*		GOTH__MALLOC.	No memory for copy.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_copy_array(GOTH_VALUE	source_array[],
					 GOTH_VALUE	*dest_array[],
					 GOTH_DATATYPE	source_types[],
					 GOTH_DATATYPE	*dest_types[],
					 GOTH_BOOLEAN	copy_types,
					 GOTH_INTEGER	array_length);
/*----------------------------------------------------------------------*/
/* EXTERN goth_value_free_array						*/
/*......................................................................*/
/* Free an array of GOTH_VALUEs and an array of datatypes of the	*/
/* GOTH_VALUEs								*/
/*									*/
/* In	:	value_array[]	Array of GOTH_VALUEs.			*/
/*		type_array[]	Array of datatypes of the GOTH_VALUEs.	*/
/*		free_types	If true, type array is freed		*/
/*		array_length	Number of GOTH_VALUEs to free.		*/
/* Out	:	NOTHING							*/
/* Ret	:	GOTH__NORMAL						*/
/*	        GOTH__BADCASEVALUE	 Unknown datatype.		*/
/*		GOTH__FAIL.	Negative array length.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_free_array(
					 GOTH_VALUE	value_array[],
					 GOTH_DATATYPE	type_array[],
					 GOTH_BOOLEAN	free_types,
					 GOTH_INTEGER	array_length);
/*----------------------------------------------------------------------*/
/* EXTERN goth_delete_value						*/
/*......................................................................*/
/* Routine to deallocate any space allocated for storing a GOTH_VALUE	*/
/* of the specified type, in addition to the space taken by the		*/
/* value union itself.							*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_delete_value(GOTH_DATATYPE	type,
				     GOTH_VALUE		value);
/*----------------------------------------------------------------------*/
/* EXTERN goth_value_delete_array					*/
/*......................................................................*/
/* Delete an array of GOTH_VALUEs and an array of datatypes of the	*/
/* GOTH_VALUEs								*/
/*									*/
/* In	:	value_array[]	Array of GOTH_VALUEs.			*/
/*		type_array[]	Array of datatypes of the GOTH_VALUEs.	*/
/*		array_length	Number of GOTH_VALUEs to delete.	*/
/* Out	:	NOTHING							*/
/* Ret	:	GOTH__NORMAL						*/
/*	        GOTH__BADCASEVALUE	 Unknown datatype.		*/
/*		GOTH__FAIL.	Negative array length.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_delete_array(GOTH_VALUE		value_array[],
					   GOTH_DATATYPE	type_array[],
					   GOTH_INTEGER		array_length);
/*----------------------------------------------------------------------*/
/* EXTERN goth_value_sprint						*/
/*......................................................................*/
/* Print the goth_value's datatype value to a character buffer. The user*/
/* must ensure the buffer is large enough.				*/
/* 									*/
/* In	:	buffer		Buffer to print to.			*/
/*		value		Value to print.				*/
/*		datatype	Datatype of value to print.		*/
/* Out	:	NOTHING							*/
/* Ret	:	GOTH__NORMAL						*/
/*		GOTH__BADCASEVALUE	Unknown datatype.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_value_sprint(char		buffer[],
				     GOTH_VALUE		value,
				     GOTH_DATATYPE	datatype);


/*>>> EXTERN functions from GOTH_UTIL.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_program_size						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the size of the running program in bytes.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*..RETURN-CODES........................................................*/
/*----------------------------------------------------------------------*/

extern GOTH_INTEGER goth_program_size();
/*----------------------------------------------------------------------*/
/* EXTERN goth_sleep							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine causes the currently executing program to sleep for the */
/* specified number of seconds.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* nsecs -in- The number of seconds to sleep.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL 	Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_INTEGER goth_sleep(GOTH_INTEGER nsecs);
/*----------------------------------------------------------------------*/
/* EXTERN goth_note_time						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is for timing operations when assessing program		*/
/* performance.								*/
/*									*/
/* The time is noted whenever this routine is called. If a non NULL	*/
/* string is passed down, the routine prints the string and the		*/
/* current time in the display.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* mess -in- String to be printed with the current time.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL 	Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_note_time(
				  GOTH_STRING	mess);
/*----------------------------------------------------------------------*/
/* EXTERN goth_newstring						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Allocates space for and makes a copy of a string			*/
/*									*/
/* string	-in- the string						*/
/*									*/
/* Returns the address of the copy, or NULL				*/
/*----------------------------------------------------------------------*/

extern GOTH_STRING goth_newstring( GOTH_STRING	string );
/*----------------------------------------------------------------------*/
/* EXTERN goth_get_pid							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine returns the process id for the current process.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* pid		-out-	The process identification.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_get_pid(
				GOTH_INTEGER	*pid);
/*----------------------------------------------------------------------*/
/* EXTERN goth_get_hostid						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*  Returns an alphanumeric character string which is guaranteed to be  */
/*  unique for a machine within a platform (it may be remotely possible */
/*  that a SUN and an HP, for example, could have the same host id)     */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* hostid_string   -out- the hostid string                              */
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL 	Successful completion				*/
/*  GOTH__ERROR         Could not retrieve the host id                  */
/*  GOTH__MALLOC        Insufficient memory to store the host id        */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_get_hostid(GOTH_STRING *hostid_string);


/*----------------------------------------------------------------------*/
/* EXTERN goth_get_host_name						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*  Returns an alphanumeric character string which represents the 	*/
/*  standard host name for the current processor. 			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* hostname_string   -out- The host name string.                        */
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL 	Successful completion				*/
/*  GOTH__ERROR         Could not retrieve the host name.               */
/*  GOTH__MALLOC        Insufficient memory to store the host name.     */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_get_host_name(GOTH_STRING *hostname_string);


/*----------------------------------------------------------------------*/
/* EXTERN goth_get_login_name						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* 									*/
/*  Returns the name under which the user logged in 			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* login_name	-out-	the user's login name				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL 	Successful completion				*/
/*  GOTH__ERROR         Could not retrieve the login name               */
/*  GOTH__MALLOC        Insufficient memory to store the login name     */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_get_login_name(GOTH_STRING *login_name);

/*----------------------------------------------------------------------*/
/* EXTERN goth_get_product_name						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*  Returns an alphanumeric character string which represents the 	*/
/*  the current executing product. At the moment this function just	*/
/*  returns a copy of whatever the environment variable, 'goth_prodname'*/
/*  contains. If the environment does not exist, then "(unknown)" is	*/
/*  returned.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* prodname_string	-out-	The product name string.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL 	Successful completion.				*/
/*  GOTH__MALLOC        Insufficient memory to store the product name.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_get_product_name(GOTH_STRING *prodname_string);


/*----------------------------------------------------------------------*/
/* EXTERN goth_enable_echo						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* 									*/
/*  Enables or disables echoing of typed input  			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  echo_state	-in-	TRUE  - enable echo				*/
/*			FALSE - disable echo                            */
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL 	Successful completion				*/
/*  GOTH__ERROR         System error in changing echo state		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_enable_echo(GOTH_BOOLEAN	echo_state);
/*----------------------------------------------------------------------*/
/* EXTERN goth_system							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine passes the command argument to the operating system's	*/
/* $$command$$ processor for execution in an operating system dependent	*/
/* way. In UNIX systems, the $$command$$ processor is the shell.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* command	-in-	The operating system $$command$$.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL 	Normal, successful completion.			*/
/*  GOTH__ERROR         Operating system error.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_system(GOTH_STRING	command);
/*----------------------------------------------------------------------*/
/* EXTERN goth_get_descriptor_type					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine returns the descriptor datatype for the specified DED.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* ded_id	-in-	The descriptor.					*/
/* 									*/
/* type		-out-	The descriptor's type.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_get_descriptor_type(
					    GOTH_DESCRIPTOR		ded_id,
					    GOTH_DESCRIPTOR_DATATYPE	*type);


/*>>> EXTERN functions from GOTH_EXIT_HANDLER.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_init_exit_handler					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* this routine sets up exit handling.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*..RETURN-CODES........................................................*/
/* 	GOTH__NORMAL - exit handling set up OK				*/
/* 	GOTH__ERROR  - exit handling set up failed			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_init_exit_handler();
/*----------------------------------------------------------------------*/
/* EXTERN goth_register_exit_handler					*/
/*......................................................................*/
/* registers a function to be called on normal exit.If several 		*/
/* functions are registered they are called in the opposite order to	*/
/* that in which they were registered.					*/
/* Arguments:-								*/
/* 	func - function to be called on exit				*/
/* 	param - argument with which function is called			*/
/* Returns:-								*/
/* 	GOTH__NORMAL - O.K.						*/
/* 	GOTH__MALLOC - insufficient memory available			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_register_exit_handler(GOTH_STATUS (*func)(VOID_P),
					      VOID_P param);


/*>>> EXTERN functions from GOTH_MALLOC.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_dbg_malloc						*/
/*......................................................................*/
/* Debugging subsitute for 'malloc()'					*/
/*----------------------------------------------------------------------*/

extern VOID_P goth_dbg_malloc(
			      size_t		size,
			      GOTH_STRING	file,
			      GOTH_INTEGER	line);
/*----------------------------------------------------------------------*/
/* EXTERN goth_dbg_calloc						*/
/*......................................................................*/
/* Debugging subsitute for 'calloc()'					*/
/*----------------------------------------------------------------------*/

extern VOID_P goth_dbg_calloc(
			      size_t		elt_count,
			      size_t		elt_size,
			      GOTH_STRING	file,
			      GOTH_INTEGER	line);
/*----------------------------------------------------------------------*/
/* EXTERN goth_dbg_realloc						*/
/*......................................................................*/
/* Debugging subsitute for 'realloc()'					*/
/*----------------------------------------------------------------------*/

extern VOID_P goth_dbg_realloc(
			       VOID_P		ptr,
			       size_t		size,
			       GOTH_STRING	file,
			       GOTH_INTEGER	line);
/*----------------------------------------------------------------------*/
/* EXTERN goth_dbg_free							*/
/*......................................................................*/
/* Debugging subsitute for 'free()'					*/
/*----------------------------------------------------------------------*/

extern void goth_dbg_free(
			  VOID_P	ptr,
			  GOTH_STRING	file,
			  GOTH_INTEGER	line);
/*----------------------------------------------------------------------*/
/* EXTERN goth_malloc_initialise					*/
/*......................................................................*/
/* Routine to initialise memory allocation tracing.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_malloc_initialise();
/*----------------------------------------------------------------------*/
/* EXTERN goth_malloc_shutdown						*/
/*......................................................................*/
/* Routine to stop memory allocation tracing.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_malloc_shutdown();
/*----------------------------------------------------------------------*/
/* EXTERN goth_malloc_fail_action					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine allows the action required whenever a memory 		*/
/* allocation operation fails, as indicated by a NULL return from 	*/
/* a memory allocation routine. 					*/
/* 									*/
/* These actions occur even if memory leak testing has not been		*/
/* enabled.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* report_failure	-in-	If true, a report of any failure is	*/
/* 				printed on the standard output		*/
/* 				device.					*/
/* 									*/
/* abort_failure	-in-	If true, any failure will result in	*/
/* 				an abort operation. This occurs		*/
/* 				after any report, requested with the	*/
/* 				other argument, has been printed.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_malloc_fail_action(
					   GOTH_BOOLEAN	report_failure,
					   GOTH_BOOLEAN	abort_failure);
/*----------------------------------------------------------------------*/
/* EXTERN goth_malloc_add_criterion					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine allows a leak testing criterion to be added. Leak	*/
/* testing will be enabled for any calls which pass down file paths	*/
/* including the specified substring.					*/
/*									*/
/* Duplicate calls of this routine will have no effect.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* subtring	-in-	The substring for which to search in the	*/
/* 			paths of any files which call the memory	*/
/* 			allocation routines.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_malloc_add_criterion(
					     GOTH_STRING	substring);
/*----------------------------------------------------------------------*/
/* EXTERN goth_malloc_remove_criterion					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to remove a memory leak test file search criterion.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* substring	-in-	The search substring to be removed from the	*/
/* 			list of those searched for when deciding	*/
/* 			whether to record a particular call to the	*/
/* 			memory management routines. If this string	*/
/* 			is NULL or empty, all search criteria are	*/
/* 			removed.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/* 									*/
/* GOTH__ERROR		The substring was not found in the current	*/
/* 			list.						*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_malloc_remove_criterion(
						GOTH_STRING	substring);
/*----------------------------------------------------------------------*/
/* EXTERN goth_malloc_report						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to print report on currently unfreed memory which was	*/
/* allocated via the memory allocation tracing/debugging routines.	*/
/*									*/
/* The address of each unfreed memory block is printed. Also printed are*/
/* the first ten (arbitary choice) bytes in HEX and also in characters	*/
/* if possible.								*/
/*									*/
/* This routine also re-initialises the memory tracing.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_malloc_report(
				      GOTH_DESCRIPTOR	out_id);

/*>>> EXTERN functions from GOTH_DESCRIPTOR.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_descriptor_build						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to build the descriptor *desc with the 		*/
/* descriptor datatype gddt. If the descriptor datatype is not a valid	*/
/* datatype then an error is raised.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* *desc	-out-	Descriptor built by the function.		*/
/* gddt		-in-	Type of descriptor to build.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/* GOTH__ERROR		The descriptor datatype is not valid.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_descriptor_build(GOTH_DESCRIPTOR		*desc,
					 GOTH_DESCRIPTOR_DATATYPE	gddt);
/*----------------------------------------------------------------------*/
/* EXTERN goth_descriptor_destroy					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to destroy goth_descriptors. If the <<refs>>	*/
/* field is non zero, the routine returns GOTH__ERROR, and does not	*/
/* destroy the descriptor. If the <<sod>> field is not NULL, the routine*/
/* returns GOTH__DESC and does not dsetroy the descriptor.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* desc	-in-	descriptor to destroy.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		The sod pointer in the descriptor is not NULL.	*/
/* GOTH__ERROR		The descriptor refs is not zero.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_descriptor_destroy(GOTH_DESCRIPTOR	desc);
/*----------------------------------------------------------------------*/
/* EXTERN goth_desc_same						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine compares the two descriptor pointers, returning a	*/
/* boolean result to indicate whether they are the same.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* desc1	-in-	The first descriptor.				*/
/* 									*/
/* desc2	-in-	The second descriptor.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* NOT_A_STATUS_CODE	A boolean which is true if the descriptors are	*/
/* 			pointers.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_BOOLEAN goth_desc_same(
				   GOTH_DESCRIPTOR	desc1,
				   GOTH_DESCRIPTOR	desc2);
/*----------------------------------------------------------------------*/
/* EXTERN goth_desc_compare						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine compares the two descriptor pointers, returning a	*/
/* status code to indicate their ordering.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* desc1	-in-	The first descriptor.				*/
/* 									*/
/* desc2	-in-	The second descriptor.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__LT		If desc1 < desc2.				*/
/* 									*/
/* GOTH__EQ		If desc1 == desc2.				*/
/* 									*/
/* GOTH__GT		If desc1 > desc2.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_desc_compare(
				     GOTH_DESCRIPTOR	desc1,
				     GOTH_DESCRIPTOR	desc2);

/*>>> EXTERN functions from GOTH_TYPED_VALUE.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_create_typed_value					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Create a typed GOTH_VALUE.  Allocates memory for the intermediate    */
/* GOTH_VALUE, sets the type and copies tyhe value.		        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* source_value	-in-  Value to insert into the intermediate GOTH_VALUE.	*/
/* dest_value	-out- Output GOTH_VALUE containing a typed value.	*/
/* type		-in-  Gothic datatype held in intermediate GOTH_VALUE.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/* GOTH__MALLOC		Out of memory.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_create_typed_value(GOTH_VALUE		source_value,
					   GOTH_VALUE	       *dest_value,
					   GOTH_DATATYPE	type);

/*----------------------------------------------------------------------*/
/* EXTERN goth_md_list_to_array						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to convert a list into a mem_descriptor array.		*/
/* If the list is a list of strings the mem_descriptor array is a string*/
/* array. Any previuos values in the mem_descriptor array are cleared,	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* list_id  -in-	the list to copy from.		                */
/* md	    -in-	the mem descriptor to copy to.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__MALLOC if insufficient memory for operation                   */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_md_list_to_array(GOTH_MEM_DESCRIPTOR md,
					 GD_COLLECTION	 list_id) ;
/*----------------------------------------------------------------------*/
/* EXTERN goth_md_array_to_list						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to convert a mem_descriptor array into a list.		*/
/* If the array is an array of strings the GOTH_VALUES have their 	*/
/* `string' field filled. The list collection is cleared of all 	*/
/* previous values that it held.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* md	    -in-	the mem descriptor to copy from.		*/
/* list_id  -in-	the list to copy to.		                */
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__MALLOC if insufficient memory for operation                   */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_md_array_to_list(GOTH_MEM_DESCRIPTOR md,
					 GD_COLLECTION	     list_id) ;


/*>>> EXTERN functions from SOS_HANDLER.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_strstr							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* jacket for the ANSI routine "strstr"					*/
/* this was previously hand coded when not all supported GOTHIC 	*/
/* platforms had a 'C' library version					*/
/* 									*/
/*----------------------------------------------------------------------*/

extern char *goth_strstr(
			 char	*src,
			 char	*sub);
/*----------------------------------------------------------------------*/
/* EXTERN goth_sos_to_sys_spec						*/
/*......................................................................*/
/* Routine to convert a Gothic platform Saved Object Specification	*/
/* (SOS) into a system specific file specification.			*/
/* 									*/
/* This now calls an FSMLIB routine and warns the user that the 	*/
/* GOTHLIB call is obsolete						*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_sos_to_sys_spec(
					GOTH_STRING	sos,
				       	GOTH_STRING	*sys_spec);



/*>>> EXTERN functions from GOTH_OBJECT.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_decompose_flagged_object_id				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine converts a flagged object identifier into its 		*/
/* constituent object id and flag.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* flagged_object_id	-in-	The flagged object identifier.		*/
/* 									*/
/* object_id		-out-	The object identifier,			*/
/* 									*/
/* flag			-out-	The flag in the range 0 to 127.		*/
/*				If a negative flag is returned, the	*/
/* 				object was unflagged.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_decompose_flagged_object_id(
						    GOTH_OBJECT_ID	flagged_object_id,
						    GOTH_OBJECT_ID	*object_id,
						    GOTH_INTEGER	*flag);
/*----------------------------------------------------------------------*/
/* EXTERN goth_compose_flagged_object_id				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine converts a flag and an object identifier into a 	*/
/* flagged object identifier.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* object_id		-in-	The object identifier,			*/
/* 									*/
/* flag			-in-	The flag in the range 0 to 127.		*/
/*									*/
/* flagged_object_id	-out-	The flagged object identifier.		*/
/* 									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_compose_flagged_object_id(
						  GOTH_OBJECT_ID	object_id,
						  GOTH_INTEGER		flag,
						  GOTH_OBJECT_ID	*flagged_object_id);
/*----------------------------------------------------------------------*/
/* EXTERN goth_compose_object_id					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is for testing purposes only.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_compose_object_id(
					  GOTH_ID		class_id,
					  GOTH_ID		id1,
					  GOTH_ID		id2,
					  GOTH_OBJECT_ID	*object_id);
/*----------------------------------------------------------------------*/
/* EXTERN goth_decompose_object_id					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is for testing purposes only.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS goth_decompose_object_id(
					    GOTH_OBJECT_ID	object_id,
					    GOTH_ID		*class_id,
					    GOTH_ID		*id1,
					    GOTH_ID		*id2);
/*----------------------------------------------------------------------*/
/* EXTERN goth_test_object_flagged					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine determines whether an object identifier is flagged	*/
/* or not.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* object_id	-in-	The object identifier.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* NONE		Returns TRUE if the object is a flagged object.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_BOOLEAN goth_test_object_flagged(
					     GOTH_OBJECT_ID	object_id);
/*----------------------------------------------------------------------*/
/* EXTERN goth_get_object_object_id					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine returns the object id minus its flags, if any.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* object_id	-in-	The object identifier.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* NONE	The object id without its flag.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_OBJECT_ID goth_get_object_object_id(
						GOTH_OBJECT_ID	object_id);
/*----------------------------------------------------------------------*/
/* EXTERN goth_get_object_class_id					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine returns an object's class identifier.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* object_id	-in-	The object identifier.			        */
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* NONE		Returns the class id.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_ID goth_get_object_class_id(
					GOTH_OBJECT_ID		object_id);
/*----------------------------------------------------------------------*/
/* EXTERN goth_get_object_flag						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine returns an object's flag.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* object_id		-in-	The object id.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* NONE		Returns the flag or -1 if the object is not flagged.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_INTEGER goth_get_object_flag(GOTH_OBJECT_ID		object_id);
/*----------------------------------------------------------------------*/
/* EXTERN goth_set_object_flag						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine combines an object id and a flag and returns the	*/
/* resulting object id.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* object_id	-in-	The object id.					*/
/* 									*/
/* flag		-in-	The object's flag (between 0 and 127).		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* NONE		The flagged object id.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_OBJECT_ID goth_set_object_flag(
					   GOTH_OBJECT_ID	object_id,
					   GOTH_INTEGER		flag);



/*>>> EXTERN functions from GOTH_BIT_MASH.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN goth_bit_mash						        */
/*......................................................................*/
/*  Takes a value and a bit mask.  The least significant bits in 'value'*/
/*  are repositioned (mashed) such that they correspond to the positions*/
/*  of the ones in the bit mask.  The mashed value is returned.         */
/*  For example:                                                        */
/*               value = abcdef (a-f each represent one bit)            */
/*               mask  = 110000010                                      */
/*    returned value is  de00000f0                                      */
/*----------------------------------------------------------------------*/

unsigned long goth_bit_mash(unsigned long value, unsigned long bit_mask);


/*These should not be in here, but they depend on typedefs that are in  */
/*here so can't do in the defins file. 	*/

/* This struct is PRIVATE to gothlib but is needed by GOTH_USER_SOME_ADDRESS */
/* if you change it, you will have to recompile all code that use            */
/* GOTH_USER_SOME_ADDRESS or GOTH_VALUE_SAME, however you can add to the end */
/* of it.								     */

struct _goth_user_address_struct
{
   GOTH_U_COMP_FUNC     comp_func;
   GOTH_U_IDENT_FUNC    ident_func;
   GOTH_U_COPY_FUNC     copy_func;
   GOTH_U_DEL_FUNC      del_func;
   GOTH_U_PRINT_FUNC    print_func;
};
 
typedef struct _goth_user_address_struct *_GOTH_USER_ADDRESS;

/* these are in here so I don't need to include tad_intrinsics witch will slow */
/* down the compile of ALL c files. */

extern GOTH_STATUS tad_compare_dates( GOTH_DATE gv1, GOTH_DATE gv2);
 
extern GOTH_STATUS tad_compare_times( GOTH_TIME gv1, GOTH_TIME gv2);




/************************************************************************/
/* This macro, can be used instead of status = goth_user_same_address , */
/* it is be used on code that is speed critical,                        */
/************************************************************************/
#define GOTH_USER_SOME_ADDRESS(_addr1_, _addr2_, _result_, _status_)\
do\
{\
    GOTH_VALUE   __addr1__;\
    GOTH_VALUE   __addr2__;\
    _GOTH_USER_ADDRESS __address__;\
\
    /* only use our args once */\
    __addr1__ =  (_addr1_);\
    __addr2__ =  (_addr2_);\
    \
    if (__addr1__.user_address.user_addr_id != __addr2__.user_address.user_addr_id)\
    {\
       sch_stack_message(GOTH__ERROR,"GOTHLIB");\
       sch_stack_string("Different User Address Types");\
       (_status_) = GOTH__ERROR;\
       break;\
    }\
\
   /* check that the data type is valid	*/\
\
   if (__addr1__.user_address.user_addr_id->type != DDT_USER_ADDRESS || \
       __addr1__.user_address.user_addr_id->sod == NULL )\
   {\
      (_status_) = GOTH__DESC;\
      break;\
   }\
\
   __address__ = __addr1__.user_address.user_addr_id->sod;\
   \
   /* perform user identity check function	*/\
\
   if (__address__->ident_func == NULL)\
   {\
      SCH_STACK_STRING("User defined type requires an identity function");\
      (_status_) = GOTH__BADFUN;\
      break;\
   }\
\
   (_status_) = (*(__address__->ident_func))(__addr1__.user_address.user_data,\
				         __addr2__.user_address.user_data,\
				         &(_result_));\
}\
while(FALSE)
    


/************************************************************************/
/* This macro, can be used instead of status = goth_value_same , it is  */
/* be used on code that is speed critical, and expands into a LOTS of c. */
/************************************************************************/
#define GOTH_VALUE_SAME(_one_, _two_, _datatype_, _result_, _status_)\
do\
{\
   \
  GOTH_VALUE	 __one__;\
  GOTH_VALUE	 __two__;\
  GOTH_DATATYPE	 __datatype__;\
  GOTH_BOOLEAN	 __result__;\
  GOTH_STATUS    __status__;\
\
  /* only eval our args once, the compiler will take care of the common case */\
  /* of them being varables. */\
\
  __one__      = (_one_);\
  __two__      = (_two_);\
  __datatype__ = (_datatype_);\
\
  __status__ = GOTH__NORMAL; \
\
   switch (__datatype__)\
   {\
   case DT_INTEGER:\
      __result__ = (__one__.integer == __two__.integer);\
      break;\
\
   case DT_REAL:\
      __result__ = (__one__.real == __two__.real);\
      break;\
\
   case DT_OBJECT_ID:\
   case DT_FLAGGED_OBJECT_ID:\
      __result__ = GOTH_SAME_OBJECT_ID(__one__.object_id,__two__.object_id);\
      break;\
\
   case DT_STRING:\
      if ((__one__.string == NULL) || (__two__.string == NULL))\
	 __result__ = (__one__.string == __two__.string);\
      else\
	 __result__ = (strcmp(__one__.string, __two__.string) == 0);\
      break;\
\
   case DT_COPY_DELETABLE_DESCRIPTOR:\
   case DT_DELETABLE_DESCRIPTOR:\
   case DT_DESCRIPTOR:\
   case DT_CLASS:\
      __result__ = ( ( __one__.descriptor == NULL && __two__.descriptor == NULL ) ||\
                   ( __one__.descriptor != NULL && __two__.descriptor != NULL &&\
                     __one__.descriptor->type == __two__.descriptor->type &&\
                    __one__.descriptor->sod  == __two__.descriptor->sod ) );\
      break;\
\
   case DT_USER:\
      GOTH_USER_SOME_ADDRESS(__one__, __two__, __result__, __status__);\
      break;\
\
   case DT_TYPED_VALUE:\
      __status__ = goth_same_typed_value(__one__, __two__, &__result__);\
      break;\
\
   case DT_STATUS:\
      __result__ = __one__.status == __two__.status;\
      break;\
\
   case DT_ID:\
      __result__ = __one__.id == __two__.id;\
      break;\
\
   case DT_BOOLEAN:\
      __result__ = !goth_xor(__one__.boolean,__two__.boolean);\
      break;\
\
   case DT_MEM_DESCRIPTOR:\
   case DT_COPY_MEM_DESCRIPTOR:\
      __result__ = ( __one__.mem_descriptor == __two__.mem_descriptor );\
      break;\
\
   case DT_SPECIAL:\
      __result__ = __one__.special == __two__.special;\
      break;\
\
   case DT_INTRINSIC:\
      __result__ = __one__.intrinsic == __two__.intrinsic;\
      break;\
      \
   case DT_DATE:\
      __result__ = strcmp(__one__.date, __two__.date) == 0;\
      break;\
\
   case DT_TIME:\
      __result__ = strcmp(__one__.time, __two__.time) == 0;\
      break;\
\
   case DT_ADDRESS:\
      __result__ = __one__.address == __two__.address;\
      break;\
\
   case DT_SCRATCH:\
      __result__ = memcmp(__one__.scratch, __two__.scratch, sizeof(__one__.scratch)) == 0;\
      break;\
\
   case DT_NULL:\
      SCH_STACK_STRING("Cannot use type DT_NULL");\
      __status__ = GOTH__ERROR;\
      break;\
\
   case DT_VARIANT:\
      SCH_STACK_STRING("Cannot use type DT_VARIANT");\
      __status__ = GOTH__ERROR;\
      break;\
\
   default:\
      __status__ = GOTH__BADCASEVALUE;\
   }\
\
  (_result_) = __result__;\
  (_status_) = __status__; \
\
}\
while(FALSE)


/************************************************************************/
/* This macro, can be used instead of status = goth_value_compare , it is*/
/* be used on code that is speed critical, and expands into a LOTS of c. */
/************************************************************************/
#define GOTH_VALUE_COMPARE(_one_, _two_, _datatype_, _result_, _status_)\
do\
{\
   \
  GOTH_VALUE	 __one__;\
  GOTH_VALUE	 __two__;\
  GOTH_DATATYPE	 __datatype__;\
  GOTH_STATUS	 __result__;\
  GOTH_STATUS    __status__;\
\
  /* only eval our args once, the compiler will take care of the common case */\
  /* of them being varables. */\
\
  __one__      = (_one_);\
  __two__      = (_two_);\
  __datatype__ = (_datatype_);\
\
  __status__ = GOTH__NORMAL; \
\
  switch(__datatype__)\
   {\
   case DT_INTEGER:\
      if (__one__.integer < __two__.integer)\
	 __result__ = GOTH__LT;\
      else if (__one__.integer > __two__.integer)\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_REAL:\
      if (__one__.real < __two__.real)\
	 __result__ = GOTH__LT;\
      else if (__one__.real > __two__.real)\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_COPY_DELETABLE_DESCRIPTOR:\
   case DT_DELETABLE_DESCRIPTOR:\
   case DT_DESCRIPTOR:\
   case DT_CLASS:\
      if (__one__.descriptor < __two__.descriptor)\
	 __result__ = GOTH__LT;\
      else if (__one__.descriptor > __two__.descriptor)\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_OBJECT_ID:\
   case DT_FLAGGED_OBJECT_ID:\
      __result__ = GOTH_COMPARE_OBJECT_ID(__one__.object_id, __two__.object_id);\
      break;\
      \
   case DT_STRING:\
      /* NOTE that a NULL string is less than all other strings */\
      if ((__one__.string == NULL) || (__two__.string == NULL))\
      {\
	 if (__one__.string == __two__.string) \
	    __result__ = GOTH__EQ;\
	 else if (__one__.string == NULL)\
	    __result__ = GOTH__LT;\
	 else\
	    __result__ = GOTH__GT;\
      }\
      else \
      {\
	 GOTH_INTEGER __val__;\
	 \
	 __val__ = (GOTH_INTEGER) strcmp(__one__.string, __two__.string);\
	 if (__val__ < 0)\
	    __result__ = GOTH__LT;\
	 else if (__val__ == 0)\
	    __result__ = GOTH__EQ;\
	 else\
	    __result__ = GOTH__GT;\
      }\
      break;\
\
   case DT_USER:\
      __status__ = goth_user_compare_address(__one__, __two__, &__result__ );\
      if (__status__ != GOTH__NORMAL)\
	 __status__ = GOTH__FAIL;\
      break;\
      \
   case DT_TYPED_VALUE:\
      __status__ = goth_compare_typed_value(__one__, __two__, &__result__ );\
      if (__status__ != GOTH__NORMAL)\
	 __status__ = GOTH__FAIL;\
      break;\
      \
   case DT_MEM_DESCRIPTOR:\
   case DT_COPY_MEM_DESCRIPTOR:\
      if (__one__.mem_descriptor < __two__.mem_descriptor)\
	 __result__ = GOTH__LT;\
      else if (__one__.mem_descriptor > __two__.mem_descriptor)\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_STATUS:\
      if (__one__.status < __two__.status)\
	 __result__ = GOTH__LT;\
      else if (__one__.status > __two__.status)\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_ID:\
      if (__one__.id < __two__.id)\
	 __result__ = GOTH__LT;\
      else if (__one__.id > __two__.id)\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_SPECIAL:\
      if ((GOTH_INTEGER) __one__.special < (GOTH_INTEGER) __two__.special)\
	 __result__ = GOTH__LT;\
      else if ((GOTH_INTEGER) __one__.special > (GOTH_INTEGER) __two__.special)\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_INTRINSIC:\
      if ((GOTH_INTEGER) __one__.intrinsic < (GOTH_INTEGER) __two__.intrinsic)\
	 __result__ = GOTH__LT;\
      else if ((GOTH_INTEGER) __one__.intrinsic > (GOTH_INTEGER) __two__.intrinsic)\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_BOOLEAN:\
      if (__one__.boolean && __two__.boolean)\
	 __result__ = GOTH__EQ;\
      else if (!__one__.boolean && !__two__.boolean)\
	 __result__ = GOTH__EQ;\
      else if (__one__.boolean && !__two__.boolean)\
	 __result__ = GOTH__GT;\
      else if (!__one__.boolean && __two__.boolean)\
	 __result__ = GOTH__LT;\
      break;\
      \
   case DT_DATE:\
      __result__ = tad_compare_dates(__one__.date, __two__.date);\
      break;\
\
   case DT_TIME:\
      __result__ = tad_compare_times(__one__.time, __two__.time);\
      break;\
\
   case DT_ADDRESS:\
      if ((GOTH_INTEGER) __one__.address < (GOTH_INTEGER) __two__.address)\
	 __result__ = GOTH__LT;\
      else if ((GOTH_INTEGER) __one__.address > (GOTH_INTEGER) __two__.address)\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_SCRATCH:\
      __status__ = GOTH__NOTIMPLEMENTED;\
      break;\
      \
   case DT_NULL:\
      SCH_STACK_STRING("Cannot use type DT_NULL");\
      __status__ = GOTH__ERROR;\
      break;\
\
   case DT_VARIANT:\
      SCH_STACK_STRING("Cannot use type DT_VARIANT");\
      __status__ = GOTH__ERROR;\
      break;\
\
   default:\
      __status__ = GOTH__BADCASEVALUE;\
   }\
\
  (_result_) = __result__;\
  (_status_) = __status__; \
\
}\
while(FALSE)


/************************************************************************/
/* This macro, can be used instead of goth_value_compare_value , it is to*/
/* be used on code that is speed critical, and expands into a LOTS of c. */
/************************************************************************/
#define GOTH_VALUE_COMPARE_VALUE(_one_, _two_, _datatype_, _result_, _status_)\
do\
{\
   \
  GOTH_VALUE	 __one__;\
  VOID_P	 __two__;\
  GOTH_DATATYPE	 __datatype__;\
  GOTH_STATUS	 __result__;\
  GOTH_STATUS    __status__;\
\
  /* only eval our args once, the compiler will take care of the common case */\
  /* of them being varables. */\
\
  __one__      = (_one_);\
  __two__      = (_two_);\
  __datatype__ = (_datatype_);\
\
  __status__ = GOTH__NORMAL; \
\
   switch(__datatype__)\
   {\
   case DT_INTEGER:\
      if (__one__.integer < *((GOTH_INTEGER *)__two__))\
	 __result__ = GOTH__LT;\
      else if (__one__.integer > *((GOTH_INTEGER *)__two__))\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_REAL:\
      if (__one__.real < *((GOTH_REAL *)__two__))\
	 __result__ = GOTH__LT;\
      else if (__one__.real > *((GOTH_REAL *)__two__))\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_COPY_DELETABLE_DESCRIPTOR:\
   case DT_DELETABLE_DESCRIPTOR:\
   case DT_DESCRIPTOR:\
   case DT_CLASS:\
      if (__one__.descriptor < *((GOTH_DESCRIPTOR *)__two__))\
	 __result__ = GOTH__LT;\
      else if (__one__.descriptor > *((GOTH_DESCRIPTOR *)__two__))\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_OBJECT_ID:\
   case DT_FLAGGED_OBJECT_ID:\
      __result__ = GOTH_COMPARE_OBJECT_ID(__one__.object_id,\
				       *((GOTH_OBJECT_ID *)__two__));\
      break;\
      \
   case DT_STRING:\
      /* NOTE that a NULL string is less than all other strings */\
      if ((__one__.string == NULL) || ((GOTH_STRING) __two__ == NULL))\
      {\
	 if (__one__.string == __two__) \
	    __result__ = GOTH__EQ;\
	 else if (__one__.string == NULL)\
	    __result__ = GOTH__LT;\
	 else\
	    __result__ = GOTH__GT;\
      }\
      else \
      {\
	 GOTH_INTEGER __val__;\
	 \
	 __val__ = (GOTH_INTEGER) strcmp(__one__.string, (GOTH_STRING)__two__);\
	 if (__val__ < 0)\
	    __result__ = GOTH__LT;\
	 else if (__val__ == 0)\
	    __result__ = GOTH__EQ;\
	 else\
	    __result__ = GOTH__GT;\
      }\
      break;\
\
   case DT_USER:\
      __status__ = goth_user_compare_address(__one__, *((GOTH_VALUE *)__two__), &__result__ );\
      if (__status__ != GOTH__NORMAL)\
	 __status__ = GOTH__FAIL;\
      break;\
      \
   case DT_TYPED_VALUE:\
      __status__ = goth_compare_typed_value(__one__, *((GOTH_VALUE *)__two__), &__result__ );\
      if (__status__ != GOTH__NORMAL)\
	 __status__ = GOTH__FAIL;\
      break;\
      \
   case DT_MEM_DESCRIPTOR:\
   case DT_COPY_MEM_DESCRIPTOR:\
      if (__one__.mem_descriptor < *((GOTH_MEM_DESCRIPTOR *)__two__))\
	 __result__ = GOTH__LT;\
      else if (__one__.mem_descriptor > *((GOTH_MEM_DESCRIPTOR *)__two__))\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_STATUS:\
      if (__one__.status < *((GOTH_STATUS *)__two__))\
	 __result__ = GOTH__LT;\
      else if (__one__.status > *((GOTH_STATUS *)__two__))\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_ID:\
      if (__one__.id < *((GOTH_ID *)__two__))\
	 __result__ = GOTH__LT;\
      else if (__one__.id > *((GOTH_ID *)__two__))\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_SPECIAL:\
      if ((GOTH_INTEGER) __one__.special < *((GOTH_INTEGER *)__two__))\
	 __result__ = GOTH__LT;\
      else if ((GOTH_INTEGER) __one__.special > *((GOTH_INTEGER *)__two__))\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_INTRINSIC:\
      if ((GOTH_INTEGER) __one__.intrinsic < *((GOTH_INTEGER *)__two__))\
	 __result__ = GOTH__LT;\
      else if ((GOTH_INTEGER) __one__.intrinsic > *((GOTH_INTEGER *)__two__))\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_BOOLEAN:\
      if (__one__.boolean < *((GOTH_BOOLEAN *)__two__))\
 	 __result__ = GOTH__LT;\
      else if (__one__.boolean > *((GOTH_BOOLEAN *)__two__))\
 	 __result__ = GOTH__GT;\
      else\
 	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_DATE:\
      __result__ = tad_compare_dates(__one__.date, *((GOTH_DATE *)__two__));\
      break;\
\
   case DT_TIME:\
      __result__ = tad_compare_times(__one__.time, *((GOTH_TIME *)__two__));\
      break;\
\
   case DT_ADDRESS:\
      if ((GOTH_INTEGER) __one__.address < *((GOTH_INTEGER *)__two__))\
	 __result__ = GOTH__LT;\
      else if ((GOTH_INTEGER) __one__.address > *((GOTH_INTEGER *)__two__))\
	 __result__ = GOTH__GT;\
      else\
	 __result__ = GOTH__EQ;\
      break;\
      \
   case DT_SCRATCH:\
      __status__ = GOTH__NOTIMPLEMENTED;\
      break;\
  \
   case DT_NULL:\
      SCH_STACK_STRING("Cannot use type DT_NULL");\
      __status__ = GOTH__ERROR;\
      break;\
\
   case DT_VARIANT:\
      SCH_STACK_STRING("Cannot use type DT_VARIANT");\
      __status__ = GOTH__ERROR;\
      break;\
\
   default:\
      __status__ = GOTH__BADCASEVALUE;\
  }\
\
  (_result_) = __result__;\
  (_status_) = __status__; \
\
}\
while(FALSE)

#endif
