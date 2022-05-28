/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:53:18.000000000 +0000
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
#ifndef _GEN_INTRINSICS
#define _GEN_INTRINSICS
/* $Header: /lslhome/gothic/hdr/genlib/v1-8/RCS/hdr.gen_intrinsics.h,v 1.9 1994/09/08 06:07:52 euanc Exp $								*/
/* 									*/
/* $Log: hdr.gen_intrinsics.h,v $
 * Revision 1.9  1994/09/08  06:07:52  euanc
 * Version v1-8 derived from v1-7
 * See Gothic WICC 311
 * Add generic sizeof call backs
 * Change copy and delete generic functions to make them ignore NULL pointers
 * for descriptors rather than return an error.
 * Frozen prior to VTRAK system tests.
 *
 * Revision 1.8  1994/02/16  19:37:41  jon
 * Version v1-7 derived from v1-6
 * See Gothic WICC 234.
 *
 * Add routines to test whether callbacks are registered for given
 * descriptor types. Added `gen_check_destroy_registered()' and
 * `gen_check_copy_registered()'.
 *
 * Revision 1.7  1993/01/15  16:27:22  snail
 * Version v1-6 derived from v1-5
 * Extracted to add routines for generic changing of cursor to a custom cursor
 * independent of MMILIB.
 *
 * Revision 1.6  1992/12/03  17:22:02  snail
 * Version v1-5 derived from v1-4
 * Extracted to allow addition of functions for the decoupling of libraries from
 * GENFLIB.
 *
 * Revision 1.5  1992/11/30  12:51:57  snail
 * Version v1-4 derived from v1-3
 * Extracted to add a function to allow a descriptor type to return a widget
 * id for parenting an interface, such as a GENF form.
 *
 * Revision 1.4  1992/10/08  09:53:11  davidm
 * Version v1-3 derived from v1-2
 * Make generic printf do a ``printf'' if no print functions are registered.
 * This allow progs to use genlib without the need to register special functions.
 *
 * Revision 1.3  1992/07/13  16:24:59  adrian
 * Version v1-2 derived from v1-1
 * Introduced gen_register_copy() and gen_generic_copy() to enable generic
 * copying/duplication of descriptors.
 *
 * Revision 1.2  1992/05/29  10:20:17  adrian
 * Version v1-1 derived from v1-0
 * Introduce a generic function to return the `name' of a descriptor; this
 * is to be used inside UESLIB when storing descriptors.
 *
 * Revision 1.1  1992/03/16  22:14:07  jon
 * Version v1-0 derived from root
 * Version containing `test' alternative from old system
 *								*/

#include "gen_defns.h"

/*----------------------------------------------------------------------*/
/*..INTRODUCTION........................................................*/
/*                                                                      */
/* The GENeric functions LIBrary is a library provided to allow generic */
/* access to a variety of functions and datatypes associated with       */
/* similar types of descriptor. Functions are registered with the       */
/* library and a descriptor datatype. This allows the function to be    */
/* called later by specifying what type of descriptor the user is       */
/* working with.                                                        */
/*                                                                      */
/* GENLIB provides a range of functionality independent of the libraries*/
/* used for a specific product based on the GOTHIC software core.       */
/* Regardless of whether a particular library is used, a user can call  */
/* a function is GENLIB to attempt to perform the task required, GENLIB */
/* will then perform the function (if the relevant library is being     */
/* used) or will be unable to grant the function request. This is       */
/* useful, because it obviates the need for a conditionally compiled    */
/* file with the relevant function calls in it.                         */
/*                                                                      */
/* For example, one such function is the ability to determine the       */
/* menubar widget id of a menubar on an interface described by a        */
/* descriptor. Several interfaces have menubars on them. The programmer */
/* can either remember the names of all the function calls to fetch the */
/* menubar id or can call the generic function registered in GENLIB.    */
/* Each library that has a menubar fetching function must register the  */
/* function with GENLIB before it can be used. This is done when the    */
/* LULL datatypes are being initialised. This applies to all functions  */
/* that are to be used as generic functions. By using the method of     */
/* registering functions, the need to use conditional compilation to    */
/* include and exclude various functions is removed; if the library is  */
/* included in the link, then the functions are not registered.         */
/*                                                                      */
/* <<Registration and Use>>                                            !*/
/* A convention is in use to form the first part of a GENLIB function   */
/* name. If the function is a registration function, the function starts*/
/* <<gen_register_>>. If the function is a generic function, the        */
/* function starts <<gen_generic_>>.                                    */
/*                                                                      */
/* The registration and use of the function is performed in two parts.  */
/* @ The function is registered by a call to the relevant GENLIB routine*/
/*   to register the function. IE: by calling                           */
/*   <<gen_register_my_special()>> to register a function to perform    */
/*   the function <<my_special()>> on a goth_descriptor.                */
/*   The registration call takes the form of a descriptor datatype and  */
/*   the function address to call when the generic function is called.  */
/*   The registration call should be made in `init_datatypes' section   */
/*   in the library being registered.                                  !*/
/*   IE: In <<init_my_special_datatypes()>> register all generic        */
/*   functions for the library <<my_special>>.                          */
/* @ Later on a module wants to perform <<my_special()>> on a           */
/*   goth_descriptor but does not know if it is available for that      */
/*   descriptor. It calls function <<gen_generic_my_special()>>, this   */
/*   routine then looks up the appropriate function. If registered, the */
/*   function is available and is called complete with the parameters   */
/*   passed to <<gen_generic_my_special()>>. If the function is not     */
/*   registered the function returns GOTH__NOTREGISTERED. The generic   */
/*   function call passes all arguments passed to the generic function  */
/*   to the descriptor specific function. The generic funciton call's   */
/*   first two arguments are ALWAYS a descriptor and a void pointer.    */
/*   There may be more than two arguments.                              */
/*                                                                      */
/* The types of functions that can be registered with GENLIB are        */
/* described by their function prototypes in the gen_defns.h public     */
/* header file. Examples of a registration call and a generic use call  */
/* are shown below.                                                     */
/* @ Registration.                                                     !*/
/*^^                                                                    */
/*   GOTH_STATUS gen_register_my_special(GOTH_DESCRIPTOR_DATATYPE gddt, */
/*                                       G_????_FUNC              addr);*/
/*^^                                                                    */
/* @ Generic Call.                                                     !*/
/*^^                                                                    */
/*   GOTH_STATUS gen_generic_my_special(GOTH_DESCRIPTOR descriptor,     */
/*                                      VOID_P          user_arg,       */
/*                                      GOTH_INTEGER    an_arg1,        */
/*                                      GOTH_INTEGER    an_arg2);       */
/*^^                                                                    */
/*   Note that the first two arguments are always present, the other    */
/*   arguments are optional, it is up to the function writer to decide  */
/*   how many arguments are needed.                                     */
/*----------------------------------------------------------------------*/


/*>>> EXTERN functions from GENERIC.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN gen_register_name						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register descriptors that have a name			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register menubar function for.*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic fetch on this a menubar.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion				*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_name(GOTH_DESCRIPTOR_DATATYPE	gddt,
				     G_NAME_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_name						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic fetch of descriptor name. 		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to fetch menubar id for.		*/
/* user_arg	-in-	User argument.					*/
/*									*/
/* *name	-out-	name user requested.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion.				*/
/* GOTH__DESC		Bad or NULL descriptor.				*/
/* GOTH__ABSENT		No menubar on interface.			*/
/* GOTH__NOTREGISTERED	Menubar fetching function not registered for	*/
/*			this descriptor.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_name(
				    GOTH_DESCRIPTOR	descriptor,
				    VOID_P		user_arg,
				    GOTH_STRING		*ret_name );
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_menubar_id					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that have a menubar.			*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register menubar function for.*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic fetch on this a menubar.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion				*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_menubar_id(GOTH_DESCRIPTOR_DATATYPE	gddt,
					   G_MENUBAR_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_menubar_id					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic fetch of menubar id. The function for a	*/
/* given interface (descriptor) must have been registered previously	*/
/* using gen_register_menubar_id().					*/
/*									*/
/* This routine executes the menubar fetching function for those	*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information. The menubar id	*/
/* is returned as *menubar_id.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to fetch menubar id for.		*/
/* user_arg	-in-	User argument.					*/
/*									*/
/* *menubar_id	-out-	Menubar id user requested.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion.				*/
/* GOTH__DESC		Bad or NULL descriptor.				*/
/* GOTH__ABSENT		No menubar on interface.			*/
/* GOTH__NOTREGISTERED	Menubar fetching function not registered for	*/
/*			this descriptor type.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_menubar_id(GOTH_DESCRIPTOR	descriptor,
					  VOID_P		user_arg,
					  Widget		*menubar_id);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_toplevel_id					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that have toplevel shell widget.	*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register toplevel shell for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic fetch on this routine.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion.				*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_toplevel_id(GOTH_DESCRIPTOR_DATATYPE	gddt,
					    G_TOPLEVEL_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_toplevel_id					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic fetch of toplevel id. The function for a	*/
/* given interface (descriptor) must have been registered previously	*/
/* using gen_register_toplevel_id().					*/
/*									*/
/* This routine executes the toplevel fetching function for those	*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information. The toplevel id	*/
/* is returned as *toplevel_id.	If a NULL descriptor is passed the 	*/
/* toplevel widget is returned as the main application widget shell.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to fetch toplevel shell id for.	*/
/* user_arg	-in-	User argument.					*/
/*									*/
/* *toplevel_id	-out-	Toplevel id requested.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Toplevel shell function not registered for	*/
/*			this descriptor type.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_toplevel_id(GOTH_DESCRIPTOR	descriptor,
					   VOID_P		user_arg,
					   Widget		*toplevel_id);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_printf						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that have printf capability.		*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register printf function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic printf on this routine.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_printf(GOTH_DESCRIPTOR_DATATYPE	gddt,
				       G_PRINTF_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_printf						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic printf. The function for a given		*/
/* interface (descriptor) must have been registered previously using	*/
/* gen_register_printf().						*/
/*									*/
/* This routine executes the printf function for those			*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information. A NULL		*/
/* descriptor is treated as standard output and the message is directed	*/
/* to the standard console output or standard console widget.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to display message on.		*/
/* user_arg	-in-	User argument.					*/
/* message	-in-	String to be printed.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion.				*/
/* GOTH__DESC 		Bad descriptor passed.				*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/* GOTH__NOTREGISTERED	Printf function not registered for descriptor.	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_printf(GOTH_DESCRIPTOR	descriptor,
				      VOID_P		user_arg,
				      GOTH_STRING	message);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_popup_id						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that have a popup menu display area.	*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic fetch on this routine.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, No memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_popup_id(GOTH_DESCRIPTOR_DATATYPE	gddt,
					 G_POPUP_FUNC			addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_popup_id						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic fetch of popup id. The function for a	*/
/* given interface (descriptor) must have been registered previously	*/
/* using gen_register_popup_id().					*/
/*									*/
/* This routine executes the popup-area-id fetching function for those	*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information. The popup id	*/
/* is returned as *popup_id.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to fetch popup id for.		*/
/* user_arg	-in-	User argument.					*/
/*									*/
/* *popup_id	-out-	Popup id user requested.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC 		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Popup function not registered for this		*/
/*			descriptor type.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_popup_id(GOTH_DESCRIPTOR	descriptor,
					VOID_P		user_arg,
					Widget		*popup_id);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_blocking_context					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that have a blocking context.		*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic fetch on this routine.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_blocking_context(GOTH_DESCRIPTOR_DATATYPE gddt,
						 G_BLOCKING_FUNC	  addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_blocking_context					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic fetch of blocking context. The function	*/
/* for a given interface (descriptor) must have been registered		*/
/* previously using gen_register_blocking_context().			*/
/*									*/
/* This routine executes the blocking context fetch function for those	*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information. The blocking	*/
/* context is returned as *blocking_context.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor		-in-	Descriptor to fetch blocking context	*/
/*				for.					*/
/* user_arg		-in-	User argument.				*/
/*									*/
/* *blocking_context	-out-	Blocking context user requested.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC 		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Get blocking context function not registered for*/
/*			this descriptor type.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_blocking_context(
					GOTH_DESCRIPTOR	     descriptor,
					VOID_P		     user_arg,
					GOTH_DESCRIPTOR	     *blocking_context);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_do_blocking					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can do blocking interaction.	*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic do blocking on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, no memory available.		*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_do_blocking(GOTH_DESCRIPTOR_DATATYPE	gddt,
					    G_DO_BLOCKING_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_do_blocking					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic blocking interaction. The function for a	*/
/* given interface (descriptor) must have been registered previously	*/
/* using gen_register_do_blocking(). If no function is present, the	*/
/* routine attempts to fetch a blocking context for descriptor. If	*/
/* successful, then MMILIB will be used to perform the blocking by using*/
/* the generic blocking context function.				*/
/*									*/
/* This routine executes the 'do blocking' function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information. The blocking	*/
/* status is returned as ret_code.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor		-in-	Descriptor to do blocking interaction	*/
/*				for.					*/
/* user_arg		-in-	User argument.				*/
/* parent_bc_ptr	-in-	Parent blocking context.		*/
/*									*/
/* *ret_code		-out-	Return code from blocking interaction.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Do blocking function not registered for this	*/
/*			descriptor type.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_do_blocking(GOTH_DESCRIPTOR	descriptor,
					   VOID_P		user_arg,
					   GOTH_DESCRIPTOR	parent_bc_ptr,
					   GOTH_INTEGER		*ret_code);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_make_visible					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can do non-blocking		*/
/* interactions.							*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic non-blocking interaction this descriptor type.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_make_visible(GOTH_DESCRIPTOR_DATATYPE	gddt,
					     G_MAKE_VISIBLE_FUNC	addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_make_visible					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to start or end a generic non-blocking interaction. The	*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_make_visible(). If no function is	*/
/* present, the routine attempts to fetch a blocking context for 	*/
/* descriptor. If successful, then MMILIB will be used to perform the	*/
/* non-blocking interaction by using the generic blocking context	*/
/* function.								*/
/*									*/
/* This routine executes the `make visible' function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information. The blocking	*/
/* context is returned as *blocking_context.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor		-in-	Descriptor to do non-blocking		*/
/*				interaction for.			*/
/* user_arg		-in-	User argument.				*/
/* parent_bc_ptr	-in-	Parent blocking context.		*/
/* visible		-in-	TRUE to make interface visible.	       !*/
/*				FALSE to hide interface.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC 		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Make visible function not registered for this	*/
/*			descriptor type.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_make_visible(GOTH_DESCRIPTOR	descriptor,
					    VOID_P		user_arg,
					    GOTH_DESCRIPTOR	parent_bc_ptr,
					    GOTH_BOOLEAN	visible);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_verify						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can verify interaction data.	*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic verify on this routine.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_verify(GOTH_DESCRIPTOR_DATATYPE	gddt,
				       G_VERIFY_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_verify						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic verification function associated with a	*/
/* descriptor. The function for a given interface (descriptor) must have*/
/* been registered previously using gen_register_verify(). If no	*/
/* function is present the routine attempts to fetch a blocking context	*/
/* for the descriptor. If successful, then MMILIB will be used to	*/
/* perform the verify function by using the generic blocking context	*/
/* function.								*/
/*									*/
/* This routine executes the verify function for those			*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information. The verification*/
/* OK flag is returned as *data_ok.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to perform verification function	*/
/*			for.						*/
/* user_arg	-in-	User argument.					*/
/*									*/
/* *data_ok	-out-	TRUE if verify was OK.			       !*/
/*			FALSE if verification error occurred.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC 		Bad descriptor.					*/
/* GOTH__NOTREGISTERED	Verification function not registered for the	*/
/*			descriptor.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_verify(GOTH_DESCRIPTOR	descriptor,
				      VOID_P		user_arg,
				      GOTH_BOOLEAN	*data_ok);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_position						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can position blocking and	*/
/* non-blocking interfaces.						*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic position on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_position(GOTH_DESCRIPTOR_DATATYPE	gddt,
					 G_POSITION_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_position						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic position interface. The			*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_position(). If no function is		*/
/* present the routine attempts to fetch a blocking context for the	*/
/* descriptor. If successful, then MMILIB will be used to perform the	*/
/* position function by using the generic blocking context function.	*/
/*									*/
/* This routine executes the position function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to position.				*/
/* user_arg	-in-	User argument.					*/
/* placement	-in-	Placement method.				*/
/* x		-in-	X coordinate.					*/
/* y		-in-	Y coordinate.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC 		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Position function not registered for descriptor.*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_position(GOTH_DESCRIPTOR	descriptor,
					VOID_P		user_arg,
					GOTH_INTEGER	placement,
					GOTH_INTEGER	x,
					GOTH_INTEGER	y);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_set_data						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can have their data set up.	*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic set_data on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_set_data(GOTH_DESCRIPTOR_DATATYPE	gddt,
					 G_SET_DATA_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_set_data						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic set data operation. The			*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_set_data(). If no function is		*/
/* present then an error is raised.					*/
/*									*/
/* This routine executes the set_data function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor of interface to set data in.		*/
/* user_arg	-in-	User argument.					*/
/* data		-in-	Data to set.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Set data function not registered for descriptor.*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_set_data(GOTH_DESCRIPTOR	descriptor,
					VOID_P		user_arg,
					GOTH_VALUE	data);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_get_data						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can have a single data value	*/
/* fetched.								*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic get_data on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_get_data(GOTH_DESCRIPTOR_DATATYPE	gddt,
					 G_GET_DATA_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_get_data						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic get data operation. The			*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_get_data(). If no function is		*/
/* present an error is raised.						*/
/*									*/
/* This routine executes the get_data function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to fetch data from.			*/
/* user_arg	-in-	User argument.					*/
/*									*/
/* *data	-out-	Data fetched from interface.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Get data function not registered.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_get_data(GOTH_DESCRIPTOR	descriptor,
					VOID_P		user_arg,
					GOTH_VALUE	*data);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_get_datatype					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can be interrogated as to the	*/
/* type of data that can be set or fetched from them using the generic	*/
/* (GENLIB) routines.							*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic get_datatype on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_get_datatype(GOTH_DESCRIPTOR_DATATYPE	gddt,
					     G_GET_DATATYPE_FUNC	addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_get_datatype					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic get datatype operation. The		*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_get_datatype(). If no function is	*/
/* present the routine attempts to fetch a blocking context for the	*/
/* descriptor. If successful, then MMILIB will be used to perform the	*/
/* position function by using the generic blocking context function.	*/
/*									*/
/* This routine executes the get_datatype function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to fetch datatype from.		*/
/* user_arg	-in-	User argument.					*/
/*									*/
/* *datatype	-out-	Datatype fetched from descriptor.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Get datatype function not registered.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_get_datatype(GOTH_DESCRIPTOR	descriptor,
					    VOID_P		user_arg,
					    GOTH_DATATYPE	*datatype);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_set_datatype					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can set the datatype that they	*/
/* interact with. Used for Classification Library CLASSLIB.		*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic set_datatype on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_set_datatype(GOTH_DESCRIPTOR_DATATYPE	gddt,
					     G_SET_DATATYPE_FUNC	addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_set_datatype					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic set interface datatype operation. The	*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_set_datatype(). If no function is	*/
/* present an error is raised.						*/
/*									*/
/* This routine executes the set_datatype function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to set datatype for.			*/
/* user_arg	-in-	User argument.					*/
/*									*/
/* *datatype	-out-	Datatype to be fetched.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Sucessful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Set datatype function not registered for this	*/
/*			descriptor.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_set_datatype(GOTH_DESCRIPTOR	descriptor,
					    VOID_P		user_arg,
					    GOTH_DATATYPE	datatype);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_destroy						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can destroy interaction data.	*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic destroy on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_destroy(GOTH_DESCRIPTOR_DATATYPE	gddt,
					G_DESTROY_FUNC			addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_check_destroy_registered					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine tests whether the generic destroy operation has been	*/
/* registered for the specified descriptor datatype. If it has not,	*/
/* the status code GOTH__NOTREGISTERED is returned, but no other status	*/
/* codes are stacked.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt		-in-	The descriptor datatype to be tested.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		The descriptor destroy callback is		*/
/* 			registered.					*/
/* 									*/
/* GOTH__NOTREGISTERED	The descriptor datatype is not registered.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_check_destroy_registered(
						GOTH_DESCRIPTOR_DATATYPE	gddt);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_destroy						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic destroy operation. The			*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_destroy(). If no function is		*/
/* present an error is raised.						*/
/*									*/
/* This routine executes the destroy function for those			*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to destroy.				*/
/* user_arg	-in-	User argument.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC 		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Destroy function not registered for this	*/
/*			descriptor type.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_destroy(GOTH_DESCRIPTOR	descriptor,
				       VOID_P		user_arg);

/*----------------------------------------------------------------------*/
/* EXTERN gen_register_sizeof						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can sizeof interaction data.	*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic sizeof on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_sizeof(GOTH_DESCRIPTOR_DATATYPE	gddt,
				       G_SIZEOF_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_check_sizeof_registered					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine tests whether the generic sizeof operation has been	*/
/* registered for the specified descriptor datatype. If it has not,	*/
/* the status code GOTH__NOTREGISTERED is returned, but no other status	*/
/* codes are stacked.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt		-in-	The descriptor datatype to be tested.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		The descriptor sizeof callback is		*/
/* 			registered.					*/
/* 									*/
/* GOTH__NOTREGISTERED	The descriptor datatype is not registered.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_check_sizeof_registered(
					       GOTH_DESCRIPTOR_DATATYPE	gddt);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_sizeof						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic sizeof operation. The for a given		*/
/* interface (descriptor) must have been registered previously using	*/
/* gen_register_sizeof(). If no function is present an error is raised.	*/
/*									*/
/* This routine executes the sizeof function for those descriptors that	*/
/* have registered functions to do this. The descriptor identifies the	*/
/* descriptor to perform this function for. The user_arg may be void or	*/
/* some descriptor specific information.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to sizeof.				*/
/* user_arg	-in-	User argument.					*/
/* size         -out-   sizeof descriptor                               */
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC 		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Sizeof function not registered for this	        */
/*			descriptor type.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_sizeof(GOTH_DESCRIPTOR	descriptor,
				      VOID_P		user_arg,
				      GOTH_INTEGER     *size);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_copy						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register functions which can copy/duplicate descriptors.	*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic destroy on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_copy(GOTH_DESCRIPTOR_DATATYPE	gddt,
				     G_COPY_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_check_copy_registered					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine tests whether the generic copy operation has been	*/
/* registered for the specified descriptor datatype. If it has not,	*/
/* the status code GOTH__NOTREGISTERED is returned, but no status	*/
/* codes are stacked.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt		-in-	The descriptor datatype to be tested.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		The descriptor copy callback is			*/
/* 			registered.					*/
/* 									*/
/* GOTH__NOTREGISTERED	The descriptor datatype is not registered.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_check_copy_registered(
					     GOTH_DESCRIPTOR_DATATYPE	gddt);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_copy						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic descriptor copy/duplicate operation. The	*/
/* function for a given descriptor must have been registered previously	*/
/* using gen_register_copy(). If no function is	present an error is	*/
/* raised.								*/
/*									*/
/* This routine executes the copy function for those			*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor_in 	- in	- Descriptor to be copied/duplciated.	*/
/* descriptor_copy	- out	- copy of the input descriptor		*/
/* user_arg	 	- in	- User argument.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC 		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Destroy function not registered for descriptor.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_copy(GOTH_DESCRIPTOR	 descriptor_in,
				    GOTH_DESCRIPTOR     *descriptor_copy,
				    VOID_P		 user_arg);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_set_ok_button					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can have the OK button programmed*/
/* with a specific function.						*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*			generic set_ok_button on this routine.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_set_ok_button(GOTH_DESCRIPTOR_DATATYPE	gddt,
					      G_SET_OK_BUTTON_FUNC	addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_set_ok_button					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic add Lull function to interface OK button	*/
/* function. The function for a given interface (descriptor) must have	*/
/* been registered previously using gen_register_set_ok_button(). If no	*/
/* function is present the routine attempts to fetch a blocking context	*/
/* for the descriptor. If successful, then MMILIB will be used to	*/
/* perform the set_ok_button function by using the generic blocking	*/
/* context function.							*/
/*									*/
/* This routine executes the set_ok_button function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to set OK button function for.	*/
/* user_arg	-in-	User argument.					*/
/* action	-in-	Lull string to attach to button.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Set OK button function not registered for this	*/
/*			descriptor.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_set_ok_button(GOTH_DESCRIPTOR	descriptor,
					     VOID_P		user_arg,
					     GOTH_STRING	action);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_set_cancel_button				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can have the CANCEL button	*/
/* programmed with a specific function.					*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic set_cancel_button on this routine.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_set_cancel_button(
				        GOTH_DESCRIPTOR_DATATYPE	gddt,
					G_SET_CANCEL_BUTTON_FUNC	addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_set_cancel_button					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic set cancel button Lull function. The	*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_set_cancel_button(). If no function is	*/
/* present an error is raised.						*/
/*									*/
/* This routine executes the set_cancel_button function for those	*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information. The blocking	*/
/* context is returned as *blocking_context.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to set CANCEL button for.		*/
/* user_arg	-in-	User argument.					*/
/* action	-in-	Lull string to attach to button.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Set CANCEL button function not registered for	*/
/*			this descriptor.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_set_cancel_button(GOTH_DESCRIPTOR descriptor,
						 VOID_P		 user_arg,
						 GOTH_STRING	 action);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_do_function					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that have a `do something' function.	*/
/* First used for Classification library.				*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic do_function on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_do_function(GOTH_DESCRIPTOR_DATATYPE	gddt,
					    G_DO_FUNCTION_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_do_function					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic `do something' operation. The		*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_do_function(). If no function is	*/
/* present an error is raised.						*/
/*									*/
/* This routine executes the do_function function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to do `do_function' for.		*/
/* user_arg	-in-	User argument.					*/
/* *inputs	-in-	Pointer to one (or more) inputs.		*/
/*									*/
/* *outputs	-out-	Pointer to one (or more) outputs.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Do function function not registered for this	*/
/*			descriptor.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_do_function(GOTH_DESCRIPTOR	descriptor,
					   VOID_P		user_arg,
					   GOTH_VALUE		*inputs,
					   GOTH_VALUE		*outputs);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_set_enums					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can have their enumerations	*/
/* values set.								*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic set_enums on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_set_enums(GOTH_DESCRIPTOR_DATATYPE	gddt,
					  G_SET_ENUMS_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_set_enums						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic set enumerations operation. The		*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_set_enums(). If no function is		*/
/* present an error is raised.						*/
/*									*/
/* This routine executes the set_enums function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to set enumerations for.		*/
/* user_arg	-in-	User argument.					*/
/* start_enum	-in-	Start enumeration.				*/
/* end_enum	-in-	End enumeration.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Set enumerations function not registered for	*/
/*			this descriptor.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_set_enums(GOTH_DESCRIPTOR	descriptor,
					 VOID_P			user_arg,
					 GOTH_INTEGER		start_enum,
					 GOTH_INTEGER		end_enum);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_get_enums					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can have their enumerations	*/
/* values fetched.							*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic get_enums on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_get_enums(GOTH_DESCRIPTOR_DATATYPE	gddt,
					  G_GET_ENUMS_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_get_enums						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic get enumerations operation. The		*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_get_enums(). If no function is		*/
/* present an error is raised.						*/
/*									*/
/* This routine executes the get_enums function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to set enumerations for.		*/
/* user_arg	-in-	User argument.					*/
/*									*/
/* *start_enum	-out-	Start enumeration.				*/
/* *end_enum	-out-	End enumeration.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Set enumerations function not registered for	*/
/*			this descriptor.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_get_enums(GOTH_DESCRIPTOR	descriptor,
					 VOID_P			user_arg,
					 GOTH_INTEGER		*start_enum,
					 GOTH_INTEGER		*end_enum);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_get_array					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can have multiple data		*/
/* values fetched.							*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic get_array on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_get_array(GOTH_DESCRIPTOR_DATATYPE	gddt,
					  G_GET_ARRAY_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_get_array						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic get array data operation. The		*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_get_array(). If no function is		*/
/* present an error is raised.						*/
/*									*/
/* This routine executes the get_array function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to set enumerations for.		*/
/* user_arg	-in-	User argument.					*/
/*									*/
/* *value_type	-out-	Datatype of data being passed.			*/
/* *num_data	-out-	Number of data elements.			*/
/* **data	-out-	Data elements (type known by interface).	*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Set enumerations function not registered for	*/
/*			this descriptor.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_get_array(GOTH_DESCRIPTOR	descriptor,
					 VOID_P			user_arg,
					 GOTH_DATATYPE		*value_type,
					 GOTH_INTEGER		*num_data,
					 GOTH_VALUE		**data);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_set_array					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can have multiple data		*/
/* values set.								*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic set_array on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_set_array(GOTH_DESCRIPTOR_DATATYPE	gddt,
					  G_SET_ARRAY_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_set_array						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic set array data operation. The		*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_set_array(). If no function is		*/
/* present an error is raised.						*/
/*									*/
/* This routine executes the set_array function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to set enumerations for.		*/
/* user_arg	-in-	User argument.					*/
/* value_type	-in-	Datatype of data being passed.			*/
/*									*/
/* num_data	-in-	Number of data elements.			*/
/* *data	-in-	Data elements (type known by interface).	*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Set enumerations function not registered for	*/
/*			this descriptor.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_set_array(GOTH_DESCRIPTOR	descriptor,
					 VOID_P			user_arg,
					 GOTH_DATATYPE		value_type,
					 GOTH_INTEGER		num_data,
					 GOTH_VALUE		*data);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_set_calc						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can have multiple data		*/
/* values set.								*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic set_calc on this routine.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_set_calc(GOTH_DESCRIPTOR_DATATYPE	gddt,
					 G_SET_CALC_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_set_calc						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic set array data operation. The		*/
/* function for a given interface (descriptor) must have been registered*/
/* previously using gen_register_set_calc(). If no function is		*/
/* present an error is raised.						*/
/*									*/
/* This routine executes the set_calc function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to set enumerations for.		*/
/* user_arg	-in-	User argument.					*/
/* value_index	-in-	Index for value to calculate.			*/
/* enum_index	-in-	Index for enumeration to calculate.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Set enumerations function not registered for	*/
/*			this descriptor.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_set_calc(GOTH_DESCRIPTOR	descriptor,
					VOID_P		user_arg,
					GOTH_INTEGER	value_index,
					GOTH_INTEGER	enum_index);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_update_callback					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can have an update callback	*/
/* registered.								*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic update_callback on this routine.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_update_callback(GOTH_DESCRIPTOR_DATATYPE gddt,
						G_UPDATE_CB_FUNC	 addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_set_update_callback				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to allow interfaces to have a generic update callback set on	*/
/* them. The function for a given interface (descriptor) must have been	*/
/* registered previously using gen_register_update_callback(). If no	*/
/* function is present an error is raised.				*/
/*									*/
/* This routine executes the update_callback function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor to fetch data from.			*/
/* func_name	-in-	Function name to use as update callback.	*/
/* n_params	-in-	Number of parameters to pass to function.	*/
/* params[]	-in-	Array of parameters to pass to function.	*/
/* types[]	-in-	Array of datatypes of parameters to pass to	*/
/*			function.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Get data function not registered.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_set_update_callback(
					       GOTH_DESCRIPTOR	descriptor,
					       GOTH_STRING	func_name,
					       GOTH_INTEGER	n_params,
					       GOTH_VALUE	params[],
					       GOTH_DATATYPE	types[]);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_parent_widget_form_id				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that have a parent_widget_form.	*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register parent_widget_form	*/
/*		function for.						*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic fetch on this a parent_widget_form.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion				*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_parent_widget_form_id(
					   GOTH_DESCRIPTOR_DATATYPE	gddt,
					   G_PARENT_WIDGET_FORM_FUNC	addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_parent_widget_form_id				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform generic fetch of parent_widget_form id. The	*/
/* function for a given interface (descriptor) must have been		*/
/* registered previously using gen_register_parent_widget_form_id().	*/
/*									*/
/* This routine executes the parent_widget_form fetching function for	*/
/* those descriptors that have registered functions to do this. The	*/
/* descriptor identifies the descriptor to perform this function for.	*/
/* The user_arg may be void or some descriptor specific information. The*/
/* parent_widget_form id is returned as *parent_widget_form_id.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor			-in-	Descriptor to fetch		*/
/*					parent_widget_form id for.	*/
/* user_arg			-in-	User argument.			*/
/*									*/
/* *parent_widget_form_id	-out-	Parent_Widget_Form id user	*/
/*					requested.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion.				*/
/* GOTH__DESC		Bad or NULL descriptor.				*/
/* GOTH__ABSENT		No parent_widget_form on interface.		*/
/* GOTH__NOTREGISTERED	Parent_Widget_Form fetching function not	*/
/*			registered for this descriptor type.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_parent_widget_form_id(
					GOTH_DESCRIPTOR	descriptor,
					VOID_P		user_arg,
					Widget		*parent_widget_form_id)
;
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_build_interface_id				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register routines that have can build an interface for	*/
/* a specific type of descriptor.					*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register build_interface	*/
/*		function for.						*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic fetch on this a build_interface.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion				*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_build_interface_id(
					   GOTH_DESCRIPTOR_DATATYPE	gddt,
					   G_BUILD_INTERFACE_FUNC	addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_build_interface_id				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to perform a generic build of an interface id, given a	*/
/* descriptor datatype.							*/
/* The funciton for a given descriptor datatype must have been		*/
/* registered previously using gen_register_build_interface_id().	*/
/*									*/
/* This routine executes the build_interface function for		*/
/* those descriptor datatypes that have registered functions to do this.*/
/* The descriptor datatype identifies the interface type to build.	*/
/* The user_arg may be void or some descriptor specific information. The*/
/* build_interface id is returned as *build_interface_id.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* parent_id			-in-	Parent interface to use to	*/
/*					get parent widget id from.	*/
/* has_shell			-in-	TRUE if parent_id specifies	*/
/*					that created interface is not a	*/
/*					subform of parent_id.		*/
/*					FALSE if created form is a	*/
/*					subform of parent_id.		*/
/* desc_datatype		-in-	Descriptor datatype to build	*/
/*					interface id for.		*/
/* n_params			-in-	Number of params passed.	*/
/* types[]			-in-	Datatypes of parameters passed.	*/
/* values[]			-in-	Values of parameters passed.	*/
/* *descriptor			-out-	Interface id built.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion.				*/
/* GOTH__DESC		Bad or NULL descriptor.				*/
/* GOTH__ABSENT		No build_interface on interface.		*/
/* GOTH__NOTREGISTERED	Build_Interface building function not		*/
/*			registered for this descriptor.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_build_interface_id(
			       GOTH_DESCRIPTOR          parent_id,
			       GOTH_BOOLEAN             has_shell,
			       GOTH_DESCRIPTOR_DATATYPE desc_datatype,
			       GOTH_INTEGER             num_params,
                               GOTH_DATATYPE            types[],
                               GOTH_VALUE               values[],
			       GOTH_DESCRIPTOR		*descriptor);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_visible						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can be made visible.		*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic non-blocking interaction this descriptor type.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_visible(GOTH_DESCRIPTOR_DATATYPE	gddt,
					G_VISIBLE_FUNC			addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_visible						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to make an interface visible or hide it. This routine is	*/
/* generally used to make subforms visible and invisible based on their	*/
/* descriptor type. This applies to forms using blocking contexts and	*/
/* also to free floating interfaces such as history windows and display	*/
/* windows.								*/
/*									*/
/* A function for a given interface (descriptor) must have been		*/
/* registered previously using gen_register_visible(). If no function is*/
/* present the routine attempts to fetch a blocking context for the	*/
/* descriptor. If successful, then MMILIB will be used to perform the	*/
/* non-blocking interactionby using the generic blocking context	*/
/* function.								*/
/*									*/
/* This routine executes the `visible' function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor		-in-	Descriptor of interface.		*/
/* user_arg		-in-	User argument.				*/
/* visible		-in-	TRUE to make interface visible.	       !*/
/*				FALSE to hide interface.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC 		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Make visible function not registered for this	*/
/*			descriptor type.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_visible(GOTH_DESCRIPTOR	descriptor,
				       GOTH_BOOLEAN	visible);
/*----------------------------------------------------------------------*/
/* EXTERN gen_register_set_cursor					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register interfaces that can be made set_cursor.		*/
/*									*/
/* The routine when first called, allocates enough memory for all	*/
/* possible descriptor entries. The function address is stored at it's	*/
/* GOTH_DESCRIPTOR_DATATYPE enumeration index in the array. The		*/
/* bounds of the array are not checked against the DDT enumeration	*/
/* since the function main_number_of_ddts() provides all the indexing	*/
/* information required. If a memory allocation fails, then this	*/
/* function returns the	GOTH__MALLOC error. The memory allocated is	*/
/* allocated using calloc(), so that unused entries are NULL. This means*/
/* the generic function can refuse a call to this function on the	*/
/* grounds that a NULL entry means the function is not registered with	*/
/* the generic library mechanism.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* gddt	-in-	Datatype of descriptor to register function for.	*/
/* addr	-in-	Address of routine to call when performing a		*/
/*		generic non-blocking interaction this descriptor type.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_register_set_cursor(GOTH_DESCRIPTOR_DATATYPE	gddt,
					   G_SET_CURSOR_FUNC		addr);
/*----------------------------------------------------------------------*/
/* EXTERN gen_generic_set_cursor					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to make an interface use it's custom cursor.			*/
/*									*/
/* A function for a given interface (descriptor) must have been		*/
/* registered previously using gen_register_set_cursor(). If no function is*/
/* present the routine attempts to fetch a blocking context for the	*/
/* descriptor. If successful, then MMILIB will be used to perform the	*/
/* non-blocking interactionby using the generic blocking context	*/
/* function.								*/
/*									*/
/* This routine executes the `set_cursor' function for those		*/
/* descriptors that have registered functions to do this. The descriptor*/
/* identifies the descriptor to perform this function for. The user_arg	*/
/* may be void or some descriptor specific information.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* descriptor	-in-	Descriptor of interface.			*/
/* set_cursor	-in-	TRUE to set the cursor.				*/
/*			FALSE to reset the cursor.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC 		Bad descriptor passed.				*/
/* GOTH__NOTREGISTERED	Make set_cursor function not registered for this*/
/*			descriptor type.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS gen_generic_set_cursor(GOTH_DESCRIPTOR	descriptor,
					  GOTH_BOOLEAN		set_cursor);

#endif
