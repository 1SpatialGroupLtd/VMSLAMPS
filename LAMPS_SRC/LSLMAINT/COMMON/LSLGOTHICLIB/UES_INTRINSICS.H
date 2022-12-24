/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-04-19 18:35:46.000000000 +0100
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
#ifndef _UES_INTRINSICS
#define _UES_INTRINSICS

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England                 */
/* Author    Adrian Cuthbert,  6-Apr-1992                               */
/************************************************************************/

/************************************************************************/
/*                                                                      */
/*                    U E S _ I N T R I N S I C S                       */
/*                                                                      */
/* Part of GOTHIC module UESLIB                                         */
/* Version 0.1, Adrian Cuthbert  6-Apr-1992                             */
/************************************************************************/


/*>>> EXTERN functions from UESLIB.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN ues_make_change_from_object					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to make the specified change (change_type) based on a 	*/
/* description in the specified store (store_id). The description is 	*/
/* identified by the supplied object, handle_obj_id. The relevant 	*/
/* `make-change' callback is invoked, and passed the additional 	*/
/* arguments specified by n_params and params[]. The types of the	*/
/* parameters will have been specified when the callback was registered	*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being accessed			*/
/* change_type	-in-	the type of change to be stored			*/
/* handle_obj_id-in-	the object identifying the description		*/
/* n_params	-in-    the number of additional parameters to be passed*/
/* 			to the callback					*/
/* params[]	-in-	array of n_params values			*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_make_change_from_object(
			       GD_UES          	store_id,
			       GOTH_STRING	change_type,
			       GOTH_OBJECT_ID   handle_obj_id,
			       GOTH_INTEGER    	n_params,
			       GOTH_VALUE      	params[] );
/*----------------------------------------------------------------------*/
/* EXTERN ues_make_change			       			*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to make the specified change (change_type) based on a 	*/
/* description in the specified store (store_id). The description is 	*/
/* identified by the supplied string, change_name. The relevant 	*/
/* `make-change' callback is invoked, and passed the additional 	*/
/* arguments specified by n_params and params[]. The types of the	*/
/* parameters will have been specified when the callback was registered	*/
/*									*/
/* If, during the load operation, descriptors are encountered whose	*/
/* details should not be stored, than a tag can be substituted. The 	*/
/* supplies n_tag such mappings, with tag_desc_ids[] containing the	*/
/* descriptors not be stored, and tag_names[] to supply the name	*/
/* that will be stored in their place.					*/
/* 									*/
/* <<NOTE: this does not apply to change_name.>>		       	*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being accessed			*/
/* change_type	-in-	the type of change to be stored			*/
/* change_name  -in-	the name given to the new description		*/
/* n_params	-in-    the number of additional parameters to be passed*/
/* 			to the callback					*/
/* params[]	-in-	array of n_params values			*/
/* n_tag	-in-	the number of tags				*/
/* tag_names	-in- +list+ array of n_tag names	       		*/
/* tag_desc_ids	-in- +list+ array of n_tag descriptors			*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_make_change(
		   GD_UES      		store_id,
		   GOTH_STRING		change_type,
		   GOTH_STRING      	change_name,
		   GOTH_INTEGER		n_params,
		   GOTH_VALUE		params[],
		   GOTH_INTEGER		n_tag,
		   GOTH_STRING		tag_names[],
		   GOTH_DESCRIPTOR     	tag_desc_ids[] );
/*----------------------------------------------------------------------*/
/* EXTERN ues_load_descriptor						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to retrieve a descriptor of the specified type (ddt_type) 	*/
/* from the specified store (store_id), identified by the string 	*/
/* desc_name. The returned descriptor is given in ret_desc_id.		*/
/*									*/
/* Named descriptors encountered during the load can be substituted for	*/
/* by supplying a set of tags. This array has n_tag elements and	*/
/* substitutes the descriptors from tag_desc_ids[] when the when a name	*/
/* from tag_names[] is found.						*/
/* 									*/
/* <<NOTE: this does not apply to desc_name.>>				*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being accessed			*/
/* ddt_type	-in-	type of descriptor to be retrieved		*/
/* desc_name   	-in-	the name to identify the descriptor		*/
/* ret_desc_id	-out-	the returned descriptor				*/
/* n_tag	-in-	the number of tags				*/
/* tag_names	-in- +list+ array of n_tag names	       		*/
/* tag_desc_ids	-in- +list+ array of n_tag descriptors			*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_load_descriptor(
		       GD_UES			store_id,
		       GOTH_DESCRIPTOR_DATATYPE	ddt_type,
		       GOTH_STRING             	desc_name,
		       GOTH_DESCRIPTOR         	*ret_desc_id,
		       GOTH_INTEGER		n_tag,
		       GOTH_STRING		tag_names[],
		       GOTH_DESCRIPTOR		tag_desc_ids[] );
/*----------------------------------------------------------------------*/
/* EXTERN ues_intern_load_descriptor			       		*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine used inside callbacks supplied to UESLIB to load a 		*/
/* descriptor.								*/
/*..ARGUMENTS...........................................................*/
/* ues_arg_id	-in-	internal UES argument				*/
/* ret_desc_id	-out-	the loaded descriptor				*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_intern_load_descriptor(
			      GD_UES_INTERNAL	ues_arg_id,
			      GOTH_DESCRIPTOR	*ret_desc_id );
/*----------------------------------------------------------------------*/
/* EXTERN ues_intern_load_arguments		      			*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine used inside callbacks supplied to UESLIB to load an array	*/
/* of arguments, be they simple datatypes (integers, strings, reals, 	*/
/* booleans, dates and times) or descriptors.				*/
/* 									*/
/* If there are zero arguments returned then ret_arg_types and 		*/
/* ret_arg_values will be set to NULL.					*/
/*..ARGUMENTS...........................................................*/
/* ues_arg_id	-in-	internal UES argument				*/
/* ret_n_arg	-out-	the number of elements returned in the arrays  	*/
/* ret_arg_types -out-	returned array of argument types	     	*/
/* ret_arg_values -out-	returned array of argument values	   	*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_intern_load_arguments(
			     GD_UES_INTERNAL	ues_arg_id,
			     GOTH_INTEGER	*ret_n_arg,
			     GOTH_DATATYPE	*ret_arg_types[],
			     GOTH_VALUE       	*ret_arg_values[] );
/*----------------------------------------------------------------------*/
/* EXTERN ues_intern_load_gv_array		      			*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine used inside callbacks supplied to UESLIB to load a 		*/
/* gv-array.								*/
/*..ARGUMENTS...........................................................*/
/* ues_arg_id		-in-	internal UES argument	       		*/
/* ret_gv_array_id	-out-	the loaded descriptor	       		*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_intern_load_gv_array(
		     GD_UES_INTERNAL	ues_arg_id,
		     GD_GV_ARRAY	*ret_gv_array_id );
/*----------------------------------------------------------------------*/
/* EXTERN ues_store_descriptor			       			*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to save a description of the specified descriptor (desc_id)	*/
/* in the specified store (store_id). The description is therafter 	*/
/* identified by the supplied string, desc_name.			*/
/*									*/
/* If, during the store operation, descriptors are encountered whose	*/
/* details should not be stored, than a tag can be substituted. The 	*/
/* supplies n_tag such mappings, with tag_desc_ids[] containing the	*/
/* descriptors not be stored, and tag_names[] to supply the name	*/
/* that will be stored in their place.					*/
/* 									*/
/* <<NOTE: this does not apply to desc_name.>>				*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being accessed			*/
/* desc_id	-in-	the descriptor to be stored			*/
/* desc_name   	-in-	the name given to the new description		*/
/* n_tag	-in-	the number of tags				*/
/* tag_names	-in- +list+ array of n_tag names	       		*/
/* tag_desc_ids	-in- +list+ array of n_tag descriptors			*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_store_descriptor(
			GD_UES			store_id,
			GOTH_DESCRIPTOR  	desc_id,
			GOTH_STRING      	desc_name,
			GOTH_INTEGER		n_tag,
			GOTH_STRING		tag_names[],
			GOTH_DESCRIPTOR		tag_desc_ids[] );
/*----------------------------------------------------------------------*/
/* EXTERN ues_overwrite_descriptor		      			*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to overwrite a description of the specified descriptor 	*/
/* (desc_id) in the specified store (store_id). The description is 	*/
/* identified by the supplied string, desc_name. 	    		*/
/*									*/
/* If, during the store operation, descriptors are encountered whose	*/
/* details should not be stored, than a tag can be substituted. The 	*/
/* supplies n_tag such mappings, with tag_desc_ids[] containing the	*/
/* descriptors not be stored, and tag_names[] to supply the name	*/
/* that will be stored in their place.					*/
/* 									*/
/* <<NOTE: this does not apply to desc_name.>>				*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being accessed			*/
/* desc_id	-in-	the descriptor to be stored			*/
/* desc_name   	-in-	the name given to the new description		*/
/* n_tag	-in-	the number of tags				*/
/* tag_names	-in- +list+ array of n_tag names	       		*/
/* tag_desc_ids	-in- +list+ array of n_tag descriptors			*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_overwrite_descriptor(
			    GD_UES	       	store_id,
			    GOTH_DESCRIPTOR  	desc_id,
			    GOTH_STRING      	desc_name,
			    GOTH_INTEGER       	n_tag,
			    GOTH_STRING		tag_names[],
			    GOTH_DESCRIPTOR    	tag_desc_ids[] );
/*----------------------------------------------------------------------*/
/* EXTERN ues_save_change			       			*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to save a description of the specified change (change_type)	*/
/* in the specified store (store_id). The description is therafter 	*/
/* identified by the supplied string, change_name. The relevant 	*/
/* `save-change' callback is invoked, and passed the additional 	*/
/* arguments specified by n_params and params[]. The types of the	*/
/* parameters will have been specified when the callback was registered	*/
/*									*/
/* If, during the store operation, descriptors are encountered whose	*/
/* details should not be stored, than a tag can be substituted. The 	*/
/* supplies n_tag such mappings, with tag_desc_ids[] containing the	*/
/* descriptors not be stored, and tag_names[] to supply the name	*/
/* that will be stored in their place.					*/
/* 									*/
/* <<NOTE: this does not apply to change_name.>>		       	*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being accessed			*/
/* change_type	-in-	the type of change to be stored			*/
/* change_name  -in-	the name given to the new description		*/
/* n_params	-in-    the number of additional parameters to be passed*/
/* 			to the callback					*/
/* params[]	-in-	array of n_params values			*/
/* n_tag	-in-	the number of tags				*/
/* tag_names	-in- +list+ array of n_tag names	       		*/
/* tag_desc_ids	-in- +list+ array of n_tag descriptors			*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_save_change(
		   GD_UES      		store_id,
		   GOTH_STRING		change_type,
		   GOTH_STRING      	change_name,
		   GOTH_INTEGER		n_params,
		   GOTH_VALUE		params[],
		   GOTH_INTEGER		n_tag,
		   GOTH_STRING		tag_names[],
		   GOTH_DESCRIPTOR     	tag_desc_ids[] );
/*----------------------------------------------------------------------*/
/* EXTERN ues_overwrite_change_on_object 	       			*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to overwrite description of the specified change (change_type)*/
/* in the specified store (store_id). The description is therafter 	*/
/* identified by the supplied object, handle_obj_id. The relevant 	*/
/* `save-change' callback is invoked, and passed the additional 	*/
/* arguments specified by n_params and params[]. The types of the	*/
/* parameters will have been specified when the callback was registered	*/
/*									*/
/* <<NOTE:>> This routine does not need to be called inside a 		*/
/* transaction.	However an error will occur if the version to which	*/
/* the store is attached does not have write access.			*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being accessed			*/
/* change_type	-in-	the type of change to be stored			*/
/* change_name  -in-	the name given to the new description		*/
/* n_params	-in-    the number of additional parameters to be passed*/
/* 			to the callback					*/
/* params[]	-in-	array of n_params values			*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_overwrite_change_on_object(
				  GD_UES      		store_id,
				  GOTH_STRING		change_type,
				  GOTH_OBJECT_ID	handle_obj_id,
				  GOTH_INTEGER		n_params,
				  GOTH_VALUE		params[] );
extern GOTH_STATUS 
   ues_overwrite_change(
			GD_UES      		store_id,
			GOTH_STRING		change_type,
			GOTH_STRING      	change_name,
			GOTH_INTEGER		n_params,
			GOTH_VALUE		params[],
			GOTH_INTEGER		n_tag,
			GOTH_STRING		tag_names[],
			GOTH_DESCRIPTOR     	tag_desc_ids[] );
/*----------------------------------------------------------------------*/
/* EXTERN ues_intern_store_descriptor				       	*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine used inside callbacks supplied to UESLIB to store a 		*/
/* descriptor, desc_id.	The descriptor may be given an identifying	*/
/* string (desc_name). If a descriptor of the correct type and name 	*/
/* already exists, then it shall be used and the supplied descriptor	*/
/* will not be saved directly. An empty string will ensure that a 	*/
/* descriptor is stored.						*/
/*..ARGUMENTS...........................................................*/
/* ues_arg_id	-in-	internal UES argument				*/
/* desc_id	-in-	the descriptor to be stored			*/
/* desc_name	-in-	the name of the descriptor			*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_intern_store_descriptor(
			       GD_UES_INTERNAL	ues_arg_id,
			       GOTH_DESCRIPTOR	desc_id,
			       GOTH_STRING	desc_name );
/*----------------------------------------------------------------------*/
/* EXTERN ues_intern_store_arguments	       				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine used inside callbacks supplied to UESLIB to store an array	*/
/* of arguments. These may be simple datatypes (integers, strings, 	*/
/* reals, booleans, dates and times) or descriptors. If a descriptor is */
/* found then it will be stored with the name obtained from 		*/
/* gen_generic_name().							*/
/* 									*/
/* This routine can be used to store zero arguments.			*/
/*..ARGUMENTS...........................................................*/
/* ues_arg_id	-in-	internal UES argument				*/
/* n_arg	-in-	the number of elements in the arrays		*/
/* arg_types	-in-	array of argument types				*/
/* arg_values	-in-	array of argument values			*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_intern_store_arguments(
			      GD_UES_INTERNAL	ues_arg_id,
			      GOTH_INTEGER	n_arg,
			      GOTH_DATATYPE	arg_types[],
			      GOTH_VALUE      	arg_values[] );
/*----------------------------------------------------------------------*/
/* EXTERN ues_intern_store_gv_array			     		*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine used inside callbacks supplied to UESLIB to store a 		*/
/* gv-array. It CANNOT be used to store descriptors. 			*/
/*..ARGUMENTS...........................................................*/
/* ues_arg_id	-in-	internal UES argument				*/
/* gv_array_id	-in-	the gv-array to be stored			*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_intern_store_gv_array(
		      GD_UES_INTERNAL	ues_arg_id,
		      GD_GV_ARRAY	gv_array_id );
/*----------------------------------------------------------------------*/
/* EXTERN ues_register_desc_callbacks					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to register Lull-callable callbacks to store (set) and 	*/
/* load (get) descriptors of the type ddt_type.				*/
/*									*/
/* The store/retrieve callbacks have the form: 				*/
/*                                                                      */
/* ^^									*/
/*	integer		status;				      		*/
/* 	UES_INTERNAL	ues_arg_id;					*/
/* 	status := my_callback( use_arg_id,desc_id );			*/
/* ^^									*/
/*	 								*/
/* which should reduce to a series of use_intern_load/store_xxxx() 	*/
/* calls, all of which take the ues_arg_id as their first argument.	*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being used				*/
/* ddt_type    	-in-	type of descriptor that routines act on 	*/
/* set_desc_func  -in-	name of function that can store descriptor 	*/
/* get_desc_func  -in- 	name of function that can retrieve descriptor	*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_register_desc_callbacks(
			       GD_UES		       	store_id,
			       GOTH_DESCRIPTOR_DATATYPE	ddt_type,
			       GOTH_STRING	       	set_desc_func,
			       GOTH_STRING	       	get_desc_func );
/*----------------------------------------------------------------------*/
/* EXTERN ues_register_change_callbacks					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to register Lull-callable callbacks to save (set) and 	*/
/* make (get) changes of the type change_type.				*/
/*									*/
/* The save/make change callbacks have the form:     			*/
/*                                                                      */
/* ^^									*/
/*	integer		status;				      		*/
/* 	UES_INTERNAL	ues_arg_id;					*/
/* 	status := my_callback( use_arg_id,user_args.... );	     	*/
/* ^^									*/
/*	 								*/
/* where the list of user_args matches the types passed in the		*/
/* arrays save_types[] and make_types[]. These arrays	 		*/
/* n_save_params and n_make_params entries respectively.		*/
/* The callbacks should reduce to a series of 				*/
/* use_intern_load/store_xxxx() calls, all of which take the ues_arg_id */
/* as their first argument.						*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being used				*/
/* change_type 	-in-	type of descriptor that routines act on 	*/
/* n_save_params     -in- number of user parameters for save callback	*/
/* save_types	     -in- array of types for the above			*/
/* n_make_params     -in- number of user parameters for make callback	*/
/* make_types	     -in- array of types for the above			*/
/* save_change_func  -in- name of function that can save change		*/
/* make_change_func  -in- name of function that can make change		*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_register_change_callbacks(
				 GD_UES	       	store_id,
				 GOTH_STRING	change_type,
				 GOTH_INTEGER	n_save_params,
				 GOTH_DATATYPE	save_types[],
				 GOTH_INTEGER	n_make_params,
				 GOTH_DATATYPE	make_types[],
				 GOTH_STRING   	save_change_func,
				 GOTH_STRING   	make_change_func );
/*----------------------------------------------------------------------*/
/* EXTERN ues_setup_schema						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to ammend the schema for the specified VAC so it can be used */
/* to store User-Environment components.				*/
/*..ARGUMENTS...........................................................*/
/* vac_id	-in-	the VAC whose schema is to be updated		*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS ues_setup_schema( GD_VAC	vac_id );
/*----------------------------------------------------------------------*/
/* EXTERN ues_build_store_id						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return an identifier for the store contained in the 	*/
/* specified VAC. The VAC should have read-only access. After this call	*/
/* components can be retrieved from the store.				*/
/*..ARGUMENTS...........................................................*/
/* vac_id	-in-	the VAC that already contains a store		*/
/* ret_store_id	-out-	the identifier for the store 			*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS ues_build_store_id(
				      GD_VAC	vac_id,
				      GD_UES	*ret_store_id );
/*----------------------------------------------------------------------*/
/* EXTERN ues_get_named_descriptors					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return a set of the names of all the descriptors stored	*/
/* of the specified type.						*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store to be searched			*/
/* ddt_type	-in-	descriptor typebeing searched for		*/
/* ret_name_set	-out-	set of names of descriptors found		*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_get_named_descriptors(
			     GD_UES			store_id,
			     GOTH_DESCRIPTOR_DATATYPE	ddt_type,
			     GD_COLLECTION		*ret_name_set );
extern GOTH_STATUS 
   ues_get_named_changes(
			 GD_UES			store_id,
			 GOTH_STRING		change_type,
			 GD_COLLECTION		*ret_name_set );
/*----------------------------------------------------------------------*/
/* EXTERN ues_get_object_id						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the UES-object corresponding to the specified 	*/
/* descriptor type and name. The NULL object-id is returned if the 	*/
/* specified object cannot be found.					*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being used				*/
/* ddt_type	-in-	type of descriptor				*/
/* desc_name	-in-	name of descriptor				*/
/* ret_object_id -out-	the object-id corresponding to the descriptor	*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_get_object_id(
		     GD_UES			store_id,
		     GOTH_DESCRIPTOR_DATATYPE	ddt_type,
		     GOTH_STRING		desc_name,
		     GOTH_OBJECT_ID		*ret_object_id );
/*----------------------------------------------------------------------*/
/* EXTERN ues_get_name_and_type						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the descriptor name and type for the specified 	*/
/* UES-object, complement to ues_get_object_id(). An empty string will	*/
/* be returned for descriptors without a name.				*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being used				*/
/* object_id 	-in-	the object-id corresponding to the descriptor	*/
/* ret_ddt_type	-out-	type of descriptor				*/
/* ret_desc_name -out-	name of descriptor				*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_get_name_and_type(
			 GD_UES				store_id,
			 GOTH_OBJECT_ID			object_id,
			 GOTH_STRING			*ret_desc_name,
			 GOTH_DESCRIPTOR_DATATYPE	*ret_ddt_type );
/*----------------------------------------------------------------------*/
/* EXTERN ues_delete_descriptor						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to delete a descriptor and those (unnamed) descriptors that	*/
/* are uniquely referenced by it.					*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being used				*/
/* ddt_type	-in-	type of descriptor				*/
/* desc_name	-in-	name of descriptor				*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_delete_descriptor(
			 GD_UES				store_id,
			 GOTH_DESCRIPTOR_DATATYPE	ddt_type,
			 GOTH_STRING			desc_name );
extern GOTH_STATUS 
   ues_delete_change(
		     GD_UES   		store_id,
		     GOTH_STRING	change_type,
		     GOTH_STRING      	change_name );
/*-------------------	---------------------------------------------------*/
/* EXTERN ues_start_transaction						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to start a transaction, thus allowing calls to ues_store_xxx	*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being used				*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS ues_start_transaction( GD_UES	store_id );
/*----------------------------------------------------------------------*/
/* EXTERN ues_commit_transaction           				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to commit a transaction, thus no longer allowing calls to 	*/
/* ues_store_xxx							*/
/*..ARGUMENTS...........................................................*/
/* store_id	-in-	the store being used				*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS ues_commit_transaction( GD_UES	store_id );
extern GOTH_STATUS ues_rollback_transaction( GD_UES	store_id );
/*----------------------------------------------------------------------*/
/* EXTERN ues_intern_get_vac_id						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*..ARGUMENTS...........................................................*/
/*..RETURN-CODES........................................................*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   ues_intern_get_vac_id(
			 GD_UES_INTERNAL	ues_intern_id,
			 GD_UES			*ret_vac_id );
/*----------------------------------------------------------------------*/
/* EXTERN ues_store_vr_contents						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine that acts as a UESLIB callback to store the contents of the	*/
/* specified value-record.						*/
/*..ARGUMENTS...........................................................*/
/* ues_arg	-in-	used for UESLIB calls				*/
/* vr_id	-in-	value record whose content is to be stored	*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS ues_store_vr_contents(
					 GD_UES_INTERNAL	ues_arg,
					 GD_VR			vr_id );
/*----------------------------------------------------------------------*/
/* EXTERN ues_load_vr_contents						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine that acts as a UESLIB callback to load the contents of the	*/
/* specified value-record.						*/
/*..ARGUMENTS...........................................................*/
/* ues_arg	-in-	used for UESLIB calls				*/
/* vr_id	-in-	value record whose content is to be loaded	*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	Normal Successful Completion				*/
/* GOTH__ERROR  Problem encountered, more information on message stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS ues_load_vr_contents(
					GD_UES_INTERNAL	ues_arg,
					GD_VR	       	vr_id );
#endif

/* $Header: /lslhome/gothic/hdr/ueslib/v1-11/RCS/hdr.ues_intrinsics.h,v 1.12 1994/02/16 19:19:26 jon Exp $								*/
/* 									*/
/* $Log: hdr.ues_intrinsics.h,v $
 * Revision 1.12  1994/02/16  19:19:26  jon
 * Version v1-11 derived from v1-10
 * TOPOPRIMLIB uses UESLIB technology to store its rules. Some of the
 * private UESLIB routines need to be made public.
 * See WICC 137
 * Also included changes described in WICC 151
 *
 * Revision 1.11  1993/09/10  21:06:15  stevewi
 * Version v1-10 derived from v1-9
 * Add ISSUE_LULLS = _ues_prototypes.lull
 * to makefile to allow user customisation of Analysis.
 *
 * See WICC GOTHIC 130
 * Freeze for BNSC IGIS Analysis integration testing.
 *
 * Revision 1.10  1993/07/08  20:12:35  adrian
 * Version v1-9 derived from v1-8
 * Make extensions to the LULL part of ueslib to add three functions:
 * ues_build_name form
 * ues_do_name_blocking
 * ues_destroy_name_form
 * To enable multiple forms to be created with different parents.
 * See WICC GOTHIC 25
 *
 * Revision 1.9  1993/03/26  20:01:51  olivia
 * Version v1-8 derived from v1-7
 * Change to ues_get_name to clear text field if supplied
 * name is not in list. Otherwise get strange hangovers
 * between selections.
 *
 * Revision 1.8  1993/03/15  12:58:26  olivia
 * Version v1-7 derived from v1-6
 * New lull include mechanism
 * Modified the callbacks that cope with value-records to convert any NULL
 * strings returned by PMSXLIB back to zero-length strings.
 *
 * Revision 1.7  1993/03/03  18:14:55  olivia
 * Version v1-6 derived from v1-5
 * Introduce routine `ues_get_name()' for use by frames.
 *
 * Revision 1.6  1993/01/04  15:57:48  olivia
 * Version v1-5 derived from v1-4
 * Fix a bug in the callback to store/load the contents of a VR which causes a
 * failure when the VR's internal index and the user-supplied id's do not match.
 * Fixed some leaks
 *
 * Revision 1.5  1992/09/22  22:16:36  jon
 * Version v1-4 derived from v1-3
 * Extracted to replace calls to `lullx_invoke_lcc()' with calls to
 * `lullx_invoke_lcc2()' and to make the UES routines return any erros
 * passed back to them by the storage and retrieval callbacks, rather than
 * simply returning GOTH__ERROR whenever there is a problem.
 *
 * Revision 1.4  1992/08/26  20:05:19  jon
 * Version v1-3 derived from v1-2
 * Extracted to fix descriptor deletion which could result in a
 * descriptor with a name being recusively deleted as a result of
 * deleting a different descriptor.
 *
 * Revision 1.3  1992/08/10  19:38:21  adrian
 * Version v1-2 derived from v1-1
 * Addition of a routine to allow overwrite of stored description.
 *
 * Revision 1.2  1992/07/13  17:29:13  adrian
 * Version v1-1 derived from v1-0
 * Introduction of `transactions' in UESLIB to enable multi-user usage.
 * Introduction of `changes' in UESLIB allowing the storage and retrieval of
 * changes to existing descriptors as well as building/destroying descriptors.
 * Addition of an `overwrite' mode to storage routines.
 *
 * Revision 1.1  1992/06/08  19:10:30  adrian
 * Version v1-0 derived from root
 * Initial implementation of UESLIB
 *								*/












