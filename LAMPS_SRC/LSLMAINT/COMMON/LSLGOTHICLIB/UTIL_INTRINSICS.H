/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:24:02.000000000 +0000
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
#ifndef _UTIL_INTRINSICS
#define _UTIL_INTRINSICS
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    DJ Allen,  5-May-1992					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		   U T I L _ I N T R I N S I C S . H 			*/
/*									*/
/* Part of GOTHIC module UTILLIB					*/
/* Version 0.1, DJ Allen  5-May-1992					*/
/************************************************************************/

#include <stddef.h>
#include "goth_datatypes.h"
#include "gen_defns.h"

/*>>> EXTERN functions from UTIL.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN util_replace_string						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Special string copying routine for use with malloc'd strings.	*/
/* If the destination pointer is non-null it is freed.			*/
/* If the source pointer is null, the destination pointer is set null.	*/
/* Otherwise, the destination pointer is set to a new copy of the	*/
/* source data.  This is useful for updating strings in SODs.		*/
/* 									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* source	-in-  String to copy.					*/
/*									*/
/* dest		-out- Pointer to new copy.  Must come in with the	*/
/* 		      pointed-to pointer set to NULL or a malloc'ed	*/
/* 		      string.						*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/* GOTH__MALLOC		Out of memory.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS util_replace_string(GOTH_STRING	source,
				       GOTH_STRING     *dest);
/*----------------------------------------------------------------------*/
/* EXTERN util_copy_string						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Special string copying routine for use with malloc'd strings.	*/
/* If the source pointer is null, the destination pointer is set null.	*/
/* Otherwise, the destination pointer is set to a new copy of the	*/
/* source data.  							*/
/* 									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* source	-in-  String to copy.					*/
/*									*/
/* dest		-out- Pointer to new copy.  				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/* GOTH__MALLOC		Out of memory.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS util_copy_string(GOTH_STRING		source,
				    GOTH_STRING        *dest);
/*----------------------------------------------------------------------*/
/* EXTERN util_replace_buffer						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Function replaces an existing (malloc'd) data buffer with a dynamic 	*/
/* copy of another data buffer.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* num_bytes	-in-	 Number of bytes in the data buffer to be 	*/
/*			 copied.					*/
/*									*/
/* source	-in-	 Address of the data buffer to be copied.	*/
/*									*/
/* dest		-in/out- On input, address of the data buffer to 	*/
/*			 replace. If non-NULL, this memory will be	*/
/*			 freed up. On output, the address of the data	*/
/*			 buffer created to contain a copy of the	*/
/*			 contents of <<source>>. This will be NULL if	*/
/*			 <<source>> is NULL or <<num_bytes <= 0>>.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Function was successful.			*/
/* GOTH__MALLOC		Failed to reallocate memory for the buffer 	*/
/*			replacement.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS util_replace_buffer(GOTH_INTEGER num_bytes,
				       GOTH_ADDRESS source,
				       GOTH_ADDRESS *dest);
/*----------------------------------------------------------------------*/
/* EXTERN util_copy_buffer						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Function creates and returns a dynamic copy of a supplied data 	*/
/* buffer.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* num_bytes	-in-	Number of bytes in the data buffer to be 	*/
/*			copied.						*/
/*									*/
/* source	-in-	Address of the data buffer to be copied.	*/
/*									*/
/* dest		-out-	Address of the destination data buffer. Will	*/
/*			be NULL if <<source>> is NULL or 		*/
/*			<<num_bytes <= 0>>.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Function was successful.			*/
/* GOTH__MALLOC		Failed to allocate memory for the buffer copy.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS util_copy_buffer(GOTH_INTEGER  num_bytes,
				    GOTH_ADDRESS  source,
				    GOTH_ADDRESS *dest);

/*>>> EXTERN functions from UTIL_DESCRIPTOR.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN util_alloc_goth_descriptor					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Function builds an empty GOTH_DESCRIPTOR of the required type.	*/ 
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* desc		-out-	Descriptor built by the function.		*/
/*									*/
/* type		-in-	Descriptor type to build.			*/ 
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Function was successful.			*/
/* GOTH__MALLOC		Memory exhausted, descriptor not built.		*/
/* GOTH__ERROR		Invalid descriptor type, not built.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS util_alloc_goth_descriptor(GOTH_DESCRIPTOR          *desc,
					      GOTH_DESCRIPTOR_DATATYPE  type);
/*----------------------------------------------------------------------*/
/* EXTERN util_free_goth_descriptor					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Function frees up the memory associated with a GOTH_DESCRIPTOR data	*/
/* structure. To be freed up, the GOTH_DESCRIPTOR must be of the	*/
/* correct type, have a NULL [[->sod]] field (no attached SOD) and have	*/
/* a zero reference count.						*/
/*									*/
/* Note, NULL descriptors are ignored. The [[->type]] field of freed up */
/* descriptors is set to DDT_INVALID  					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* desc		-in-	Descriptor to be freed.				*/
/*									*/
/* type		-in-	Expected descriptor type.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Function was successful.			*/
/* GOTH__DESC		Invalid descriptor passed to the routine.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS util_free_goth_descriptor(GOTH_DESCRIPTOR          desc,
					     GOTH_DESCRIPTOR_DATATYPE type);
/*----------------------------------------------------------------------*/
/* EXTERN util_register_descriptor					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Function registers descriptor destruction and copy functions with	*/
/* GENLIB.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt		-in-	Enumerated descriptor type.			*/
/*									*/
/* destroy_fn	-in-	descriptor destruction function, ignored if	*/
/*			NULL.						*/
/*									*/
/* destroy_done	-out-	Flag, TRUE if the destruction function was	*/
/*			registered with GENLIB, ignore if destroy_fn	*/
/*			was NULL.					*/
/*									*/
/* copy_fn	-in-	Descriptor copy function, ignored if		*/
/*			NULL.						*/
/*									*/
/* copy_done	-out-	Flag, TRUE if the copy function was		*/
/*			registered with GENLIB, ignore if copy_fn	*/
/*			was NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		All registrations performed okay.		*/
/* GOTH__FAIL		Failed to register one or both functions.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS util_register_descriptor(
				    GOTH_DESCRIPTOR_DATATYPE  gddt,
				    G_DESTROY_FUNC  	      destroy_fn,
				    GOTH_BOOLEAN   	     *destroy_done,
				    G_COPY_FUNC               copy_fn,
				    GOTH_BOOLEAN             *copy_done);

/*>>> EXTERN functions from UTIL_FUNCS.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN util_strcpy							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Function returns a dynamic copy of a character string. It is an	*/
/* enhanced version of the standard C library routine strcpy().		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* str	-in- 	Character string to copy. If NULL, NULL is returned.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* Address of the string copy.						*/
/*									*/
/*----------------------------------------------------------------------*/

extern char *util_strcpy(char *str);
/*----------------------------------------------------------------------*/
/* EXTERN util_memcpy							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Function returns a dynamic copy of a buffer of data. It is an	*/
/* enhanced version of the standard C library routine memcpy().		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* buffer	-in- 	Address of the data buffer. If NULL, NULL is	*/
/*			returned.					*/
/*									*/
/* num_ele	-in-	Number of array elements. If <= 0, NULL is	*/
/*			returned.		 			*/
/*									*/
/* ele_size	-in-	Size of array element in bytes.	if <= 0, NULL	*/
/*			is returned.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern void *util_memcpy(void   *buffer, 
			 size_t  num_ele, 
			 size_t  ele_size);
/*----------------------------------------------------------------------*/
/* EXTERN util_strncat							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* This function allows a string to be added to the end of a buffer,    */
/* no more then <<n>> bytes will be copied, the buffer will be expanded */
/* by a realloc if needed.                                              */
/*                                                                      */
/* <<Examples of use>>							*/
/* @ util_strcat(&s, "a string", -1, 0, 0, NULL);			*/
/* @ util_strcat(&s, s1, 1024, 28, max_len, &max_len);			*/
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*									*/
/* s1          -in/out- A pointer to the <<address>> of the buffer.     */
/*                                                                      */
/*                      This must be at least <<in_max_len>> long.      */
/*                                                                      */
/*			Contain a '\0' terminated string.               */
/*                                                                      */
/*                      Have been allocated by realloc, malloc, or      */
/*                      calloc.                                         */
/*                                                                      */
/*                      As it may be moved by realloc, all pointers to  */
/*			it must be updated after a call to util_strcat. */
/*								        */
/* s2	       -in-	A '\0' terminated string, to add onto the end   */
/*                      of the string in s1.                            */
/*                                                                      */
/* n           -in-     No more then <<n>> bytes will be copied form    */
/*                      <<s2>>.                                         */
/*                      If <<n>> is -1, <<n>> is set to strlen(s2).     */
/*									*/
/* increment   -in-	The amount (in byes) of addition memory to      */
/*                      allocate, if the buffer is realloc.             */
/*                      Must be >= 0.                                   */
/*		                                                        */
/* in_max_len  -in-     The size of the buffer, when it is passed in,   */
/*                      if this is set to 0, the buffer size is taken   */
/*                      to be strlen(s1)+1 .                            */
/*                                                                      */
/*                      <<NOTE:>> This is the size of the <<buffer>>    */
/*                      not the size of the string.                     */
/*                                                                      */
/* out_max_len -out-   If not NULL, the <<new>> size of the buffer.     */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH_NORMAL	Normal, successful completion.                          */
/* GOTH__MALLOC The realloc failed for some reason. S1 and out_max_len  */
/*		have not been changed.					*/
/*									*/
/*----------------------------------------------------------------------*/


extern GOTH_STATUS util_strncat(GOTH_STRING  *s1,
			        GOTH_STRING   s2,
			        GOTH_INTEGER  n,
			        GOTH_INTEGER  increment,
			        GOTH_INTEGER  in_max_len,
			        GOTH_INTEGER *out_max_len);
/*----------------------------------------------------------------------*/
/* EXTERN util_strcat							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* This function allows a string to be added to the end of a buffer,    */
/* the buffer will be expanded by a realloc if needed.                  */
/*                                                                      */
/* <<Examples of use>>                                                  */
/* utill_strcat(&s, "a string", 0, 0, NULL);                            */
/* utill_strcat(&s, s1, 1024, max_len, &max_len);                       */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*									*/
/* s1           -in/out- A pointer to the <<address>> of the buffer.    */
/*                                                                      */
/*                       This must be at least <<in_max_len>> long.     */
/*                                                                      */
/*			 Contain a '\0' terminated string.              */
/*                                                                      */
/*                       Have been allocated by realloc, malloc, or     */
/*                       calloc.                                        */
/*                                                                      */
/*                       As it may be moved by realloc, all pointers to */
/*			 it must be updated after a call to util_strcat.*/
/*								        */
/* s2	        -in-	 A '\0' terminated string, to add onto the end  */
/*                       of the string in s1.                           */
/*									*/
/* increment    -in-     The amount (in bytes) of addition memory to     */
/*                       allocate, if the buffer is realloc.            */
/*                       Must be >= 0.                                  */
/*		                                                        */
/* in_max_len   -in-     The size of the buffer, when it is passed in,  */
/*                       if this is set to 0, the buffer size is taken  */
/*                       to be strlen(s1)+1 .                           */
/*                                                                      */
/*                       <<NOTE:>> This is the size of the <<buffer>>   */
/*                       not the size of the string.                    */
/*                                                                      */
/* out_max_len -out-     If not NULL, the <<new>> size of the buffer.   */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL	Normal, successful completion.                          */
/* GOTH__MALLOC The realloc failed for some reason. S1 and out_max_len  */
/*		has not been changed.                                   */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS util_strcat(GOTH_STRING  *s1,
			       GOTH_STRING   s2,
			       GOTH_INTEGER  increment,
			       GOTH_INTEGER  in_max_len,
			       GOTH_INTEGER *out_max_len);
/*----------------------------------------------------------------------*/
/* EXTERN util_realloc							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Function reallocates a block of memory, i.e. the function is a	*/
/* GOTHIC wrapper for the ANSI realloc() function.			*/
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*									*/
/* nbytes	-in-	 The number of bytes of memory to (re)allocate.	*/
/*									*/
/* addr		-in/out- On input, the current address of the block of 	*/
/*			 memory. On output, the new address of the	*/
/*			 block of memory. Note, if will be unchanged	*/
/*			 if the realloc() operation fails.		*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Function was successful.			*/
/* GOTH__MALLOC		Failed to reallocate the block of memory.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS util_realloc(GOTH_INTEGER  nbytes,
				GOTH_ADDRESS *addr);
/*----------------------------------------------------------------------*/
/* EXTERN util_malloc							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Function allocates a block of memory, i.e. the function is a		*/
/* GOTHIC wrapper for the ANSI malloc() function.			*/
/*                                                                      */
/* Think about using UTIL_MALLOC instead.				*/
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/*									*/
/* nbytes	-in-	The number of bytes of memory to allocate.	*/
/*									*/
/* addr		-out-	Address of the allocated block of memory.	*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Function was successful.			*/
/* GOTH__MALLOC		Failed to allocate the block of memory.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS util_malloc(GOTH_INTEGER  nbytes,
			       GOTH_ADDRESS *addr);
/*----------------------------------------------------------------------*/
/* EXTERN util_extend_alloc						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Function increases the amount of memory allocated to a buffer.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* num_bytes	-in-	 Minimum required size for the buffer.		*/
/*									*/
/* buf_size	-in/out- The size of the buffer. This will be changed	*/
/*			 if the buffer has to be increased in size.	*/
/*									*/
/* buffer	-in/out- Address of the data buffer. This may change	*/
/*			 if the buffer has to be increased in size.	*/
/*			 If NULL on input, the buffer will be created	*/
/*			 by this function (if <<num_bytes > 0>>).	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Function was successful.			*/
/* GOTH__MALLOC		Failed to (re)allocate memory for the buffer.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS util_extend_alloc(GOTH_INTEGER  num_bytes,
				     GOTH_INTEGER *buf_size,
				     GOTH_ADDRESS *buffer);
/*----------------------------------------------------------------------*/
/* EXTERN util_str_case_cmp						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine does a case insensitive string comparison.  Two NULL    */
/* pointers are taken to be equal, and a NULL pointer is taken be be    */
/* less then any string.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  s1		-in-	The first string.				*/
/*  s2		-in-	The second string.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  0 if s1 == s1							*/
/* >0 if s1 > s2							*/
/* <0 if s1 > s1							*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_INTEGER util_str_case_cmp(GOTH_STRING s1,
				       GOTH_STRING s2);

    
#endif

