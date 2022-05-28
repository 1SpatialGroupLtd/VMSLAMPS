/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:18:06.000000000 +0000
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
#ifndef _TRAN_INTRINSICS
#define _TRAN_INTRINSICS

/*>>> EXTERN functions from TRANSFORM.C <<<*/
extern GOTH_STATUS init_tranlib();

extern GOTH_STATUS tran_cb_get_cb(TRANS_CB_FUNC_TYPE   func_type,
				  GOTH_STRING    func_name,
				  TRANS_CB_DATA  **cb) ;

extern GOTH_STATUS tran_cb_get_func(TRANS_CB_FUNC_TYPE   func_type,
				    GOTH_STRING    func_name,
				    VOID_P         *func,
				    GOTH_INTEGER   *nfunc_values,
				    GOTH_DATATYPE  **func_datatypes,
				    GOTH_INTEGER   *nfunc_chars,
				    GOTH_DATATYPE  **func_chardatatypes,
				    GOTH_VALUE     **func_chars) ;

extern GOTH_STATUS tran_cb_set_func(TRANS_CB_FUNC_TYPE   func_type,
				    GOTH_STRING    func_name,
				    VOID_P         func,
				    GOTH_INTEGER   nfunc_values,
				    GOTH_DATATYPE  *func_datatypes,
				    GOTH_INTEGER   nfunc_chars,
				    GOTH_DATATYPE  *func_chardatatypes,
				    GOTH_VALUE     *func_chars) ;

extern GOTH_STATUS tran_cb_func(TRANS_CB_DATA *cb,
				VOID_P        func,
				GOTH_INTEGER  nfunc_values,
				GOTH_DATATYPE *func_datatypes) ;

extern GOTH_STATUS tran_get_cfunc_values(GOTH_STRING	func_name,
					 GOTH_BOOLEAN	get_min_points,
					 GOTH_INTEGER	*min_points,
					 VOID_P	        *func,
					 GOTH_INTEGER	offset) ;

extern GOTH_STATUS tran_set_cfunc_values(GOTH_STRING	func_name,
				 GOTH_BOOLEAN	set_min_points,
				 GOTH_INTEGER	min_points,
				 VOID_P	        func,
				 GOTH_INTEGER	offset) ;

extern GOTH_STATUS tran_cb_test_func(TRANS_CB_FUNC_TYPE   func_type,
				    GOTH_STRING    func_name,
				    GOTH_BOOLEAN   *is_present) ;

extern GOTH_STATUS tran_set_general_func(
					GOTH_STRING	     general_func_name,
					TRANS_GENERAL_FUNC   general_func,
                                        GOTH_INTEGER         nargs,
                                        GOTH_DATATYPE       types[],
                                        GOTH_BOOLEAN         scaleable) ;

extern GOTH_STATUS tran_get_general_func(
					GOTH_STRING	     general_func_name,
					TRANS_GENERAL_FUNC    *general_func,
					GOTH_INTEGER         *nargs,
                                        GOTH_DATATYPE       **datatypes,
                                        GOTH_BOOLEAN         *scaleable) ;

extern GOTH_STATUS tran_get_rescale_func(
				      GOTH_STRING	     rescale_func_name,
				      TRANS_UNIT_CONV_FUNC  *rescale_func );

extern GOTH_STATUS tran_set_rescale_func(
				      GOTH_STRING	     rescale_func_name,
				      TRANS_UNIT_CONV_FUNC   rescale_func );

extern GOTH_STATUS tran_get_load_func(
				      GOTH_STRING	load_func_name,
				      TRANS_LOAD_FUNC   *load_func );

extern GOTH_STATUS tran_set_load_func(
				      GOTH_STRING	load_func_name,
				      TRANS_LOAD_FUNC  	load_func );

extern GOTH_STATUS tran_get_coord_func(
					GOTH_STRING	       coord_func_name,
					TRANS_COORD_FUNC       *coord_func,
					GOTH_INTEGER           *nargs,
                                        GOTH_DATATYPE          **datatypes) ;

extern GOTH_STATUS tran_test_coord_func(
					GOTH_STRING	       coord_func_name,
					GOTH_BOOLEAN	       *is_present);

extern GOTH_STATUS tran_set_coord_func(
					GOTH_STRING	       coord_func_name,
					TRANS_COORD_FUNC       coord_func,
                                        GOTH_INTEGER           nargs,
                                        GOTH_DATATYPE          types[]) ;

extern GOTH_STATUS tran_get_mbr_func(
					GOTH_STRING	       mbr_func_name,
					TRANS_MBR_FUNC         *mbr_func,
					GOTH_INTEGER           *nargs,
                                        GOTH_DATATYPE          **datatypes) ;

extern GOTH_STATUS tran_set_mbr_func(
					GOTH_STRING	       mbr_func_name,
					TRANS_MBR_FUNC         mbr_func,
                                        GOTH_INTEGER           nargs,
                                        GOTH_DATATYPE          types[]) ;


extern GOTH_STATUS tran_get_data_func(
					GOTH_STRING	       data_func_name,
					TRANS_DATA_FUNC        *data_func,
					GOTH_INTEGER           *nargs,
                                        GOTH_DATATYPE          **datatypes,
				        GOTH_BOOLEAN	       *lookup,
				        GOTH_BOOLEAN	       *spatial) ;


extern GOTH_STATUS tran_set_data_func(
					GOTH_STRING	       data_func_name,
					TRANS_DATA_FUNC        data_func,
                                        GOTH_INTEGER           nargs,
                                        GOTH_DATATYPE          types[],
				        GOTH_BOOLEAN	       lookup,
				        GOTH_BOOLEAN	       spatial) ;


extern GOTH_STATUS tran_get_layer_func(
					GOTH_STRING	       layer_func_name,
					TRANS_LAYER_FUNC       *layer_func,
					GOTH_INTEGER           *nargs,
                                        GOTH_DATATYPE          **datatypes) ;

extern GOTH_STATUS tran_set_layer_func(
					GOTH_STRING	       layer_func_name,
					TRANS_LAYER_FUNC       layer_func,
                                        GOTH_INTEGER           nargs,
                                        GOTH_DATATYPE          types[]) ;



extern GOTH_STATUS tran_get_tile_func(
					GOTH_STRING	       tile_func_name,
					TRANS_TILE_FUNC        *tile_func,
					GOTH_INTEGER           *nargs,
                                        GOTH_DATATYPE          **datatypes) ;

extern GOTH_STATUS tran_set_tile_func(
					GOTH_STRING	       tile_func_name,
					TRANS_TILE_FUNC        tile_func,
                                        GOTH_INTEGER           nargs,
                                        GOTH_DATATYPE          types[]) ;


extern GOTH_STATUS tran_set_raster_func(
					GOTH_STRING	     raster_func_name,
					TRANS_RASTER_FUNC    raster_func,
                                        GOTH_INTEGER         nargs,
                                        GOTH_DATATYPE        types[], 
                                        GOTH_BOOLEAN         scaleable) ;

extern GOTH_STATUS tran_get_raster_func(
					GOTH_STRING	     raster_func_name,
					TRANS_RASTER_FUNC    *raster_func,
					GOTH_INTEGER         *nargs,
                                        GOTH_DATATYPE       **datatypes,
                                        GOTH_BOOLEAN         *scaleable) ;


extern GOTH_STATUS tran_set_gentrans_func(
					GOTH_STRING	    gentrans_func_name,
					TRANS_GENTRANS_FUNC gentrans_func,
                                        GOTH_INTEGER        nargs,
                                        GOTH_DATATYPE       types[], 
                                        GOTH_BOOLEAN        scaleable) ;

extern GOTH_STATUS tran_get_gentrans_func(
					GOTH_STRING	    gentrans_func_name,
					TRANS_GENTRANS_FUNC *gentrans_func,
					GOTH_INTEGER        *nargs,
                                        GOTH_DATATYPE       **datatypes,
                                        GOTH_BOOLEAN        *scaleable) ;


extern GOTH_STATUS tran_set_extern_func(
					GOTH_STRING	     extern_func_name,
					TRANS_RASEXT_FUNC    extern_func,
					GOTH_INTEGER         nargs,
                                        GOTH_DATATYPE        types[]) ;

extern GOTH_STATUS tran_get_extern_func(
					GOTH_STRING	     extern_func_name,
					TRANS_RASEXT_FUNC    *extern_func,
					GOTH_INTEGER         *nargs,
                                        GOTH_DATATYPE       **datatypes) ;

extern GOTH_STATUS tran_get_display_func(
                                         GOTH_STRING         func_name,
					 TRANS_DISPLAY_FUNC *display_func) ;

extern GOTH_STATUS tran_set_display_func(
                                        GOTH_STRING       func_name,
					TRANS_DISPLAY_FUNC display_func) ;

extern GOTH_STATUS tran_get_min_number_of_points(
                                                 GOTH_STRING   func_name,
						 GOTH_INTEGER *min_points) ;

extern GOTH_STATUS tran_set_min_number_of_points(
                                                 GOTH_STRING  func_name,
						 GOTH_INTEGER min_points) ;

#endif
/* $Header: /lslhome/gothic/hdr/tranlib/v1-6/RCS/hdr.tran_intrinsics.h,v 1.7 1994/09/08 06:05:44 adrian Exp $								*/
/* 									*/
/* $Log: hdr.tran_intrinsics.h,v $
 * Revision 1.7  1994/09/08  06:05:44  adrian
 * Version v1-6 derived from v1-5
 * Give the correct prototype for a general function in tran_defsn.h
 * WICC 284
 *
 * Revision 1.6  1993/11/29  19:18:07  davidm
 * Version v1-5 derived from v1-4
 * Update tranlib calls to tran_cb_set_func to take VOID_P instead of
 * function pointer to enable compilation on the VAX>
 * WICC 164.
 * Compiled successfully on ULTRIX.
 *
 * Revision 1.5  1993/07/07  13:02:23  davidm
 * Version v1-4 derived from v1-3
 * Development of aspect call-back for surfaces .
 *
 * Revision 1.4  1993/01/15  15:05:56  olivia
 * Version v1-3 derived from v1-2
 * Update the parameters of raster data transformations to tell whether
 * 1) The transformation can be accomplished via a lookup table
 * 2) The transformation has a spatial component, that is the output
 * pixel value is a function both of its value and its position.
 *
 * Revision 1.3  1992/08/26  17:22:58  snail
 * Version v1-2 derived from v1-1
 * Resolve NULL/0 conflicts
 * Added new (LULL callable) routine to test if coordinate function has been
 * registered with tranlib (tran_test_coord_func).
 * Purify fixes.
 *
 * Revision 1.2  1992/04/24  16:04:22  jon
 * Version v1-1 derived from v1-0
 * Addition of general transformations to the types of functions treated by TRANLIB
 * Inclusion of general transformation RACs
 *								*/
