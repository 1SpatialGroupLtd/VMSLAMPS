/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-04-22 11:12:04.000000000 +0100
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
#ifndef _FLT_INTRINSICS
#define _FLT_INTRINSICS
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Ian Fisher  13-Mar-91					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*			      F I L T E R 				*/
/*									*/
/* Part of GOTHIC module 						*/
/************************************************************************/

#include "tran_defns.h"


/* Exported functions from FLT.C */
/*********************************/
/*****************************************************************************/
/* CREATION   CREATION   CREATION   CREATION   CREATION   CREATION   CREATION*/
/*****************************************************************************/

extern GOTH_DESCRIPTOR flt_alloc_filter();

extern GOTH_STATUS     flt_create_filter( GOTH_DESCRIPTOR  flt_desc,
                                          FILTER_TYPES     flt_type,
                                          GOTH_BOOLEAN     abs_flag,
                                          GOTH_REAL        sharpen,
		                          GOTH_REAL        threshold[2],
                                          GOTH_BOOLEAN     threshold_flag,
                                          GOTH_INTEGER     kernel_width,
                                          GOTH_INTEGER     kernel_height,
                                          GOTH_INTEGER     src_pix_row,
                                          GOTH_INTEGER     src_pix_col,
                                          GOTH_REAL        kernel[] );

extern GOTH_STATUS     flt_build_filter ( GOTH_DESCRIPTOR *flt_desc,
                                          FILTER_TYPES     flt_type,
                                          GOTH_BOOLEAN     abs_flag,
                                          GOTH_REAL        sharpen,
		                          GOTH_REAL        threshold[2],
                                          GOTH_BOOLEAN     threshold_flag,
                                          GOTH_INTEGER     kernel_width,
                                          GOTH_INTEGER     kernel_height,
                                          GOTH_INTEGER     src_pix_row,
                                          GOTH_INTEGER     src_pix_col,
                                          GOTH_REAL        kernel[] );


/****************************************************************************/
/*  FREE  DELETE  FREE  DELETE  FREE  DELETE  FREE  DELETE  FREE   DELETE   */ 
/****************************************************************************/

extern GOTH_STATUS   flt_free_filter   ( GOTH_DESCRIPTOR flt_desc );
extern GOTH_STATUS   flt_delete_filter ( GOTH_DESCRIPTOR flt_desc );
extern GOTH_STATUS   flt_destroy_filter( GOTH_DESCRIPTOR flt_desc );

/****************************************************************************/
/*  SET    SET   SET   SET   SET   SET   SET   SET   SET   SET   SET   SET  */
/****************************************************************************/


/*---------------------------------------------------------------------------*/
/* EXTERN flt_set_diagonal						     */
/*...........................................................................*/
/* Set a speckle removal fiter to consider diagonal moves.		     */
/*                                                                           */
/* Returns  : GOTH__NORMAL, GOTH__DESC                                       */
/*                                                                           */
/* Modifies : flt_desc - Absolute value in filter data structure set to      */
/*                       given value.                                        */
/*                                                                           */
/* Recieves : use_diag - TRUE - set diagonal moves (the default) 	     */
/*                                                                           */
/*---------------------------------------------------------------------------*/

extern GOTH_STATUS flt_set_diagonal( GOTH_DESCRIPTOR flt_desc,
				     GOTH_BOOLEAN    use_diag) ;

/*---------------------------------------------------------------------------*/
/* EXTERN flt_set_filter_offset		                                     */
/*...........................................................................*/
/* Sets the offset flag and the filter offset				     */
/*                                                                           */
/* Returns  : GOTH__NORMAL, GOTH__DESC                                       */
/*                                                                           */
/* Modifies : flt_desc - Absolute value in filter data structure set to      */
/*                       given value.                                        */
/*                                                                           */
/* Recieves : offset_flag - The given offset flag.			     */
/* 			    TRUE implies the offset is to be used	     */
/*	      offset      - The offset to apply			             */
/*                                                                           */
/*---------------------------------------------------------------------------*/

extern GOTH_STATUS flt_set_filter_offset( GOTH_DESCRIPTOR flt_desc,
					 GOTH_BOOLEAN    offset_flag, 
					 GOTH_REAL       offset) ;
/*---------------------------------------------------------------------------*/
/* EXTERN flt_set_filter_range						     */
/*...........................................................................*/
/* Sets an estimate for the range of values of a convolution filter prior to */
/* any scaling.								     */
/*                                                                           */
/* Returns  : GOTH__NORMAL, GOTH__DESC                                       */
/*                                                                           */
/* Modifies : flt_desc - Absolute value in filter data structure set to      */
/*                       given value.                                        */
/*                                                                           */
/* Recieves : range_flag - TRUE - set range.				     */
/* Recieves : low - The low range value.				     */
/* Recieves : high - The high range value.				     */
/*                                                                           */
/*---------------------------------------------------------------------------*/

extern GOTH_STATUS flt_set_filter_range( GOTH_DESCRIPTOR flt_desc,
				   GOTH_BOOLEAN	   range_flag,
				   GOTH_REAL       low,
				   GOTH_REAL       high) ;

extern GOTH_STATUS   flt_set_filter_type     ( GOTH_DESCRIPTOR  flt_desc,
                                               FILTER_TYPES     flt_type );

extern GOTH_STATUS   flt_set_filter_absolute ( GOTH_DESCRIPTOR flt_desc,
                                               GOTH_BOOLEAN    absolute );

extern GOTH_STATUS   flt_set_sharpen_factor ( GOTH_DESCRIPTOR flt_desc,
                                              GOTH_REAL       sharpen );

extern GOTH_STATUS   flt_set_filter_threshold( GOTH_DESCRIPTOR flt_desc,
                                               GOTH_REAL       threshold[2],
                                               GOTH_BOOLEAN    threshold_flag);

extern GOTH_STATUS   flt_set_filter_src_pixel( GOTH_DESCRIPTOR  flt_desc,
                                               GOTH_INTEGER     src_pix_row,
                                               GOTH_INTEGER     src_pix_col );

extern GOTH_STATUS   flt_set_filter_kernel   ( GOTH_DESCRIPTOR  flt_desc,
                                               GOTH_INTEGER     kernel_width,
                                               GOTH_INTEGER     kernel_height,
                                               GOTH_REAL        kernel[] );

extern GOTH_STATUS flt_set_colour_code_count( GOTH_DESCRIPTOR flt_desc,
                                              GOTH_INTEGER    colour_code,
                                              GOTH_INTEGER    count );

/****************************************************************************/
/*  GET    GET   GET   GET   GET   GET   GET   GET   GET   GET   GET   GET  */
/****************************************************************************/

extern GOTH_STATUS   flt_get_filter_type(      GOTH_DESCRIPTOR  flt_desc,
                                               FILTER_TYPES    *flt_type );

extern GOTH_STATUS   flt_get_filter_absolute(  GOTH_DESCRIPTOR  flt_desc,
                                               GOTH_BOOLEAN    *absolute );

extern GOTH_STATUS   flt_get_sharpen_factor ( GOTH_DESCRIPTOR   flt_desc,
                                              GOTH_REAL        *sharpen );

extern GOTH_STATUS   flt_get_filter_threshold( GOTH_DESCRIPTOR flt_desc,
                                               GOTH_REAL       threshold[2],
                                               GOTH_BOOLEAN   *threshold_flag);

extern GOTH_STATUS   flt_get_filter_src_pixel( GOTH_DESCRIPTOR  flt_desc,
                                               GOTH_INTEGER    *src_pix_row,
                                               GOTH_INTEGER    *src_pix_col );

extern GOTH_STATUS   flt_get_filter_kernel(    GOTH_DESCRIPTOR  flt_desc,
                                               GOTH_INTEGER    *kernel_width,
                                               GOTH_INTEGER    *kernel_height,
                                               GOTH_REAL        kernel[] );

/*****************************************************************************/
/*  FILTER     FILTER     FILTER     FILTER     FILTER     FILTER     FILTER */
/*****************************************************************************/

/*---------------------------------------------------------------------------*/
/* EXTERN flt_set_filter_transform                                           */
/*...........................................................................*/
/* Set up the transform rac information for filtering.                       */
/*                                                                           */
/*---------------------------------------------------------------------------*/

extern GOTH_STATUS flt_set_filter_transform( GOTH_DESCRIPTOR rac_id,
                                             GOTH_DESCRIPTOR filter );

/*---------------------------------------------------------------------------*/
/* EXTERN flt_create_filter_transform                                        */
/*...........................................................................*/
/* Create a filter RAC                                                       */
/*                                                                           */
/*---------------------------------------------------------------------------*/
extern GOTH_STATUS flt_create_filter_transform( GOTH_DESCRIPTOR  source_rac_id,
                                                GOTH_DESCRIPTOR  filter,
                                                GOTH_DESCRIPTOR *flt_rac );

/*----------------------------------------------------------------------*/
/* EXTERN flt_filter_point_map						*/
/*......................................................................*/
/* Identity map for filter points.                                      */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS flt_filter_point_map(
                                         GOTH_INTEGER   n_coord,
                                         GOTH_REAL      xy_in[][2],
                                         GOTH_REAL      xy_out[][2],
                                         GOTH_INTEGER   ntrans_params,
                                         GOTH_VALUE     trans_params[],
                                         GOTH_INTEGER   ninput_space_params,
                                         GOTH_VALUE     input_space_params[],
                                         GOTH_INTEGER   noutput_space_params,
                                         GOTH_VALUE     out_space_params[] );

/*---------------------------------------------------------------------------*/
/* EXTERN flt_filter_mbr_map                                                 */
/*...........................................................................*/
/* Set up the minimum bounding rectangle map for filter operations.          */
/*                                                                           */
/*---------------------------------------------------------------------------*/
extern GOTH_STATUS flt_filter_mbr_map( GOTH_REAL      inlow1,
                                           GOTH_REAL      inlow2,
                                           GOTH_REAL      inhigh1,
                                           GOTH_REAL      inhigh2,
                                           GOTH_REAL      *outlow1,
                                           GOTH_REAL      *outlow2,
                                           GOTH_REAL      *outhigh1,
                                           GOTH_REAL      *outhigh2,
                                           TRANS_COORD_FUNC coordmap,
                                           GOTH_INTEGER   ntrans_params,
                                           GOTH_VALUE     trans_params[],
                                           GOTH_INTEGER   nmbr_params,
                                           GOTH_VALUE     mbr_params[],
                                           GOTH_INTEGER   ninput_space_params,
                                           GOTH_VALUE     input_space_params[],
                                           GOTH_INTEGER   noutput_space_params,
                                           GOTH_VALUE     out_space_params[] );

/*---------------------------------------------------------------------------*/
/* EXTERN flt_filter_raster_map                                              */
/*...........................................................................*/
/* Filter raster data                                                        */
/*                                                                           */
/*---------------------------------------------------------------------------*/
extern GOTH_STATUS flt_filter_raster_map(
                                        GOTH_DESCRIPTOR  source_rac_id,
                                        GOTH_DESCRIPTOR  rac_id,
                                        GOTH_REAL        inlow1,
                                        GOTH_REAL        inlow2,
                                        GOTH_REAL        inhigh1,
                                        GOTH_REAL        inhigh2,
                                        GOTH_INTEGER     rast_access,
                                        VOID_P           pixel_access,
                                        VOID_P           buffer,
                                        GOTH_INTEGER     bufsize1,
                                        GOTH_INTEGER     bufsize2,
                                        TRANS_COORD_FUNC dummy_func,
                                        GOTH_INTEGER     ntrans_params,
                                        GOTH_VALUE       trans_params[],
                                        GOTH_INTEGER     ninput_space_params,
                                        GOTH_VALUE       input_space_params[],
                                        GOTH_INTEGER     noutput_space_params,
                                        GOTH_VALUE       output_space_params[],
                                        GOTH_INTEGER     nraster_params,
                                        GOTH_VALUE       raster_params[]
                                       );


/*---------------------------------------------------------------------------*/
/* EXTERN flt_tran_init                                                      */
/*...........................................................................*/
/* Register the filter intrinsics with the transforamtion dictionary         */
/*                                                                           */
/*                                                                           */
/*---------------------------------------------------------------------------*/
extern GOTH_STATUS  flt_tran_init(GOTH_BOOLEAN init_dict);


/*----------------------------------------------------------------------*/
/* EXTERN flt_dict_get_filter       					*/
/*......................................................................*/
/* Function returns a copy of the filter descriptor stored in the filter*/
/* dictionary.                                                          */
/*									*/
/* filter_name	- in	- name of filter (dictionary key)		*/
/* filt_desc	- out	- New filter descriptor                         */
/*                        (Null if filter did not exist in dictionary.) */
/*----------------------------------------------------------------------*/
extern GOTH_STATUS flt_dict_get_filter( GOTH_STRING       filter_name,
				        GOTH_DESCRIPTOR  *filter_desc );


/*----------------------------------------------------------------------*/
/* EXTERN flt_dict_set_filter                                           */
/*......................................................................*/
/* function sets filter name associated with a filter descriptor.       */
/*									*/
/* filter_name	- in	- name of filter (dictionary key)		*/
/* filter_desc	- in	- Filter descriptor (a copy is made of the      */
/*                        whole structure).                             */
/*----------------------------------------------------------------------*/
extern GOTH_STATUS flt_dict_set_filter( GOTH_STRING      filter_name,
                                        GOTH_DESCRIPTOR  filter_desc );


/*---------------------------------------------------------------------------*/
/* EXTERN flt_set_colour_removal					     */
/*...........................................................................*/
/* Set the a coded colour for a speckle removal testing			     */
/*                                                                           */
/* Returns  : GOTH__NORMAL, GOTH__DESC                                       */
/*                                                                           */
/* Modifies : flt_desc - Absolute value in filter data structure set to      */
/*                       given value.                                        */
/*                                                                           */
/* Receives : set_all - set all colours for test removal		     */
/*            do_set  - set flag on					     */
/*            colour_code - if set_all false the value to remove	     */
/*                                                                           */
/*---------------------------------------------------------------------------*/

extern GOTH_STATUS flt_set_colour_removal(GOTH_DESCRIPTOR flt_desc,
					  GOTH_BOOLEAN	  do_set,
					  GOTH_BOOLEAN	  set_all,
					  GOTH_INTEGER    colour_code) ;

/*---------------------------------------------------------------------------*/
/* EXTERN flt_set_removal						     */
/*...........................................................................*/
/* Set the value for a speckle removal fiter to replace.		     */
/*                                                                           */
/* Returns  : GOTH__NORMAL, GOTH__DESC                                       */
/*                                                                           */
/* Modifies : flt_desc - Absolute value in filter data structure set to      */
/*                       given value.                                        */
/*                                                                           */
/* Receives : remove_value - set value to try to remove (default (1)) 	     */
/*            replace_value - set value to try to replace with (default (0)) */
/*                                                                           */
/*---------------------------------------------------------------------------*/

extern GOTH_STATUS flt_set_removal(GOTH_DESCRIPTOR flt_desc,
				   GOTH_INTEGER    remove_value,
				   GOTH_INTEGER    replace_value) ;

/******************************** EOF ****************************************/



/* $Header: /lslhome/gothic/hdr/filterlib/v1-7/RCS/hdr.flt_intrinsics.h,v 1.8 1994/01/20 17:17:10 davidm Exp $								*/
/* 									*/
/* $Log: hdr.flt_intrinsics.h,v $
 * Revision 1.8  1994/01/20  17:17:10  davidm
 * Version v1-7 derived from v1-6
 * Implementation of speckle removle filters for coded values.
 * Code value filters work by defining speckles to
 * be aggregations of pixels with the same coded value. Pixels in the
 * speckle are replaced by the modal value of the values around the edge
 * of the pixel.
 * WICC 182
 *
 * Revision 1.7  1993/09/02  07:05:21  stevewi
 * Version v1-6 derived from v1-5
 * WICC 110 fix a bug in checking the kernel dimensions.
 * Freeze for BNSC IGIS integration testing.
 *
 * Revision 1.6  1993/07/22  10:56:40  davidm
 * Version v1-5 derived from v1-4
 * Development of a smoothing RGB filter for stipple areas.
 * Fix a bug in the row optimised convoluyion filter which led to the
 * incorrect result due to incorrectly positioned pointers.
 *
 * Revision 1.5  1993/06/23  14:57:02  davidm
 * Version v1-4 derived from v1-3
 * Incorpoarate a stipple removal filter into filterlib.
 *
 * Revision 1.4  1993/03/30  14:22:00  davidm
 * Version v1-3 derived from v1-2
 * Fix a bug in convolution filter for binary data with incorrect pointer increment.
 * Convert to using `GOTH_1U_INTEGER' etc..
 *
 * Revision 1.3  1993/01/04  15:40:37  olivia
 * Version v1-2 derived from v1-1
 * leak in flt_build_filter jacket routine
 *
 * Revision 1.2  1992/08/26  14:47:59  davidm
 * Version v1-1 derived from v1-0
 * Extraction to import test library.
 * Enahancements to use more input datatypes ad use quicker algorithms to
 * perform filtering.
 *								*/
#endif
