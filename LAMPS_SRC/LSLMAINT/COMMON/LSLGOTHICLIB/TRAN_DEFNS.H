/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:18:04.000000000 +0000
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
#ifndef _TRAN_DEFNS
#define _TRAN_DEFNS

typedef struct _tran_cb_data
{
   VOID_P        func ;
   GOTH_INTEGER	 nfunc_values ;
   GOTH_DATATYPE *func_datatypes ;
   GOTH_INTEGER	 nfunc_chars ;
   GOTH_DATATYPE *func_chardatatypes ;
   GOTH_VALUE	 *func_chars ;
} TRANS_CB_DATA ;


typedef enum
{
   TRANS_COORD,
   TRANS_MBR,
   TRANS_RASTER,
   TRANS_LAYER,
   TRANS_TILE,
   TRANS_DATA,
   TRANS_GENTRANS,
   TRANS_GENERAL,
   TRANS_EXTERN,
   TRANS_GRID_STORE,
   TRANS_GRID_RESTORE,
   TRANS_GRID_DELETE,
   TRANS_SURF_STORE,
   TRANS_SURF_RESTORE,
   TRANS_SURF_DELETE,
   TRANS_SURF_DOMAIN,
   TRANS_SURF_VALUE,
   TRANS_SURF_KNOT,
   TRANS_SURF_LINE,
   TRANS_SURF_POP,
   TRANS_SURF_PTRAST,
   TRANS_SURF_NORMAL,
   TRANS_SURF_SHRAST,
   TRANS_DTM_STORE,
   TRANS_DTM_RESTORE,
   TRANS_DTM_DELETE,
   TRANS_DTM_POINT,
   TRANS_DTM_LINE,
   TRANS_DTM_RASTER,
   TRANS_SURF_ASPECT,
   TRANS_SURF_SLOPE,
   TRANS_LAYER_COMB,
   TRANS_FUNC_ENDMARKER
} TRANS_CB_FUNC_TYPE ;	

typedef GOTH_STATUS (*TRANS_COORD_FUNC) (
				   GOTH_INTEGER	n_coord,
				   GOTH_REAL	xy_in[][2],
				   GOTH_REAL	xy_out[][2],
				   GOTH_INTEGER	n_trans_prms,
				   GOTH_VALUE	trans_prms[],
				   GOTH_INTEGER	n_src_space_prms,
				   GOTH_VALUE	src_space_prms[],
				   GOTH_INTEGER	n_dest_space_prms,
				   GOTH_VALUE	dest_space_prms[] );

typedef GOTH_STATUS (*TRANS_UNIT_CONV_FUNC) (
					GOTH_VALUE	in_coeffs[],
                                        GOTH_REAL       scale_x_in,
                                        GOTH_REAL       scale_y_in,
                                        GOTH_REAL       offset_x_in,
                                        GOTH_REAL       offset_y_in,
                                        GOTH_VALUE      out_coeffs[],
                                        GOTH_REAL       scale_x_out,
                                        GOTH_REAL       scale_y_out,
                                        GOTH_REAL       offset_x_out,
                                        GOTH_REAL       offset_y_out );

typedef GOTH_STATUS (*TRANS_LOAD_FUNC) (
					GOTH_REAL	src_x,
					GOTH_REAL	src_y,
					GOTH_REAL	dest_x,
					GOTH_REAL	dest_y,
					GOTH_INTEGER	*n_coeff,
					GOTH_REAL	**x_coeff,
					GOTH_REAL	**y_coeff );

typedef GOTH_STATUS (*TRANS_MBR_FUNC) (
				 GOTH_REAL	  src_xlo,
				 GOTH_REAL	  src_ylo,
				 GOTH_REAL  	  src_xhi,
				 GOTH_REAL	  src_yhi,
				 GOTH_REAL	  *dest_xlo,
				 GOTH_REAL	  *dest_ylo,
				 GOTH_REAL     	  *dest_xhi,
				 GOTH_REAL	  *dest_yhi,
                                 TRANS_COORD_FUNC coord_function,
				 GOTH_INTEGER	  n_trans_prms,
				 GOTH_VALUE	  trans_prms[],
				 GOTH_INTEGER	  n_mbr_prms,
				 GOTH_VALUE	  mbr_prms[],
				 GOTH_INTEGER	  n_src_space_prms,
				 GOTH_VALUE	  src_space_prms[],
				 GOTH_INTEGER	  n_dest_space_prms,
				 GOTH_VALUE	  dest_space_prms[] );

typedef GOTH_STATUS (*TRANS_RASTER_FUNC) (
				  GOTH_DESCRIPTOR	inrac_id,
				  GOTH_DESCRIPTOR	outrac_id,
				  GOTH_REAL		xlo,
				  GOTH_REAL		ylo,
				  GOTH_REAL		xhi,
				  GOTH_REAL		yhi,
				  GOTH_INTEGER		rast_access,
				  VOID_P		pixel_access,
				  VOID_P		buffer,
				  GOTH_INTEGER		bufsize1,
				  GOTH_INTEGER		bufsize2,
				  TRANS_COORD_FUNC	coord_function,
				  GOTH_INTEGER		n_trans_prms,
				  GOTH_VALUE		trans_prms[],
				  GOTH_INTEGER		n_src_space_prms,
				  GOTH_VALUE		src_space_prms[],
				  GOTH_INTEGER		n_dest_space_prms,
				  GOTH_VALUE		dest_space_prms[],
                                  GOTH_INTEGER          nraster_prms,
				  GOTH_VALUE		raster_prms[]) ;

typedef GOTH_STATUS (*TRANS_LAYER_FUNC)(
                              GOTH_DESCRIPTOR     output_rac,
                              GOTH_INTEGER        nsource_racs,
                              GOTH_DESCRIPTOR     source_racs[],
                              VOID_P              out_buffer,
                              VOID_P              input_buffer[],
                              GOTH_INTEGER        buffsize1,
                              GOTH_INTEGER        buffsize2,
                              GOTH_REAL           low1,
                              GOTH_REAL           low2,
                              GOTH_REAL           high1,
                              GOTH_REAL           high2,
                              GOTH_BOOLEAN        unknown[],
                              GOTH_BOOLEAN        boundary[],
                              GOTH_INTEGER        *clipping,
                              GOTH_INTEGER        nlayer_prms,
                              GOTH_VALUE          layer_prms[]) ;

typedef GOTH_STATUS (*TRANS_RASEXT_FUNC)(
                              GOTH_DESCRIPTOR     output_rac,
                              VOID_P              out_buffer,
                              GOTH_INTEGER        buffsize1,
                              GOTH_INTEGER        buffsize2,
                              GOTH_REAL           low1,
                              GOTH_REAL           low2,
                              GOTH_REAL           high1,
                              GOTH_REAL           high2,
                              GOTH_INTEGER        nextern_prms,
                              GOTH_VALUE          extern_prms[]) ;

typedef GOTH_STATUS (*TRANS_GENTRANS_FUNC)(
                              GOTH_DESCRIPTOR     output_rac,
                              GOTH_INTEGER        nsource_racs,
                              GOTH_DESCRIPTOR     source_racs[],
                              VOID_P              out_buffer,
			      GOTH_INTEGER	  *rast_access,
			      VOID_P		  *pixel_access,
                              GOTH_BOOLEAN        *pixel_access_unknown,
                              GOTH_INTEGER        buffsize1,
                              GOTH_INTEGER        buffsize2,
                              GOTH_REAL           low1,
                              GOTH_REAL           low2,
                              GOTH_REAL           high1,
                              GOTH_REAL           high2,
			      TRANS_COORD_FUNC	  *coord_function,
			      GOTH_INTEGER	  *n_trans_prms,
			      GOTH_VALUE	  **trans_prms,
			      GOTH_INTEGER	  *n_src_space_prms,
			      GOTH_VALUE	  **src_space_prms,
			      GOTH_INTEGER	  n_dest_space_prms,
			      GOTH_VALUE	  *dest_space_prms,
                              GOTH_INTEGER        ngentrans_prms,
                              GOTH_VALUE          *gentrans_prms) ;

typedef GOTH_STATUS (*TRANS_TILE_FUNC)(
                              GOTH_DESCRIPTOR     output_rac,
                              GOTH_INTEGER        nsource_racs,
                              GOTH_DESCRIPTOR     source_racs[],
                              VOID_P              out_buffer,
                              VOID_P              input_buffer[],
                              GOTH_INTEGER        buffsize1,
                              GOTH_INTEGER        buffsize2,
                              GOTH_REAL           low1,
                              GOTH_REAL           low2,
                              GOTH_REAL           high1,
                              GOTH_REAL           high2,
                              GOTH_BOOLEAN        unknown[],
                              GOTH_BOOLEAN        boundary[],
                              GOTH_INTEGER        *clipping,
                              GOTH_INTEGER        nlayer_prms,
                              GOTH_VALUE          layer_prms[]) ;

typedef GOTH_STATUS (*TRANS_DATA_FUNC)(
                                      GOTH_DESCRIPTOR source_rac_id,
                                      GOTH_DESCRIPTOR rac_id,
                                      GOTH_SPECIAL    buffer_in,
                                      GOTH_SPECIAL    buffer_out,
                                      GOTH_INTEGER    buffersize1,
                                      GOTH_INTEGER    buffersize2,
                                      GOTH_REAL       low1,
                                      GOTH_REAL       low2,
                                      GOTH_REAL       high1,
                                      GOTH_REAL       high2,
                                      GOTH_INTEGER    ndata_prms,
                                      GOTH_VALUE      data_prms[]) ;


typedef GOTH_STATUS (*TRANS_GENERAL_FUNC)(
                                    GOTH_DESCRIPTOR    source_rac_id,
                                    GOTH_DESCRIPTOR    rac_id,
                                    GOTH_REAL          inlow1,
                                    GOTH_REAL          inlow2,
                                    GOTH_REAL          inhigh1,
                                    GOTH_REAL          inhigh2,
                                    GOTH_INTEGER       space_access,
                                    VOID_P             pa,
                                    VOID_P             buffer,
                                    GOTH_INTEGER       bufsize1,
                                    GOTH_INTEGER       bufsize2,
                                    TRANS_COORD_FUNC   trans_function,
                                    GOTH_INTEGER       n_trans_prms,
				    GOTH_VALUE	       trans_prms[],
                                    GOTH_INTEGER       ninput_space_prms,
                                    GOTH_VALUE         input_space_prms[],
                                    GOTH_INTEGER       noutput_space_prms,
                                    GOTH_VALUE         output_space_prms[],
                                    GOTH_INTEGER       nraster_prms,
                                    GOTH_VALUE         raster_prms[]) ;

typedef GOTH_STATUS (*TRANS_DISPLAY_FUNC) (GOTH_DESCRIPTOR stream,
					   GOTH_VALUE      coeff[],
					   GOTH_INTEGER    num_coeff,
					   GOTH_STRING     comment);

typedef GOTH_STATUS  (*DTM_DELETE_FUNC)(GD_DTM_QUALITY     dtm_quality_id) ;

typedef GOTH_STATUS  (*DTM_STORE_FUNC)(GD_UES_INTERNAL		ues_arg,
					GD_DTM   	        dtm_id) ;

typedef GOTH_STATUS  (*DTM_RESTORE_FUNC)(
					GD_UES_INTERNAL	       	ues_arg,
					GOTH_INTEGER            *nprms,
					GOTH_DATATYPE           **datatypes,
					GOTH_VALUE	        **values) ;

typedef GOTH_STATUS (*DTM_POINT_FUNC)(
                           GD_DTM          dtm_id,
			   GOTH_ID         quality_id,
                           GOTH_DATATYPE   datatype,
			   GOTH_REAL       exaggeration,
			   GOTH_REAL       offset,
			   GOTH_INTEGER    nquality_prms,
			   GOTH_VALUE      quality_prms[],
                           GOTH_REAL       x,
                           GOTH_REAL       y,
                           GOTH_VALUE      *value,
                           GOTH_BOOLEAN    *is_null,
			   GOTH_INTEGER    nprms,
                           GOTH_VALUE      prms[]) ;

typedef GOTH_STATUS (*DTM_LINE_FUNC)(
			 GD_DTM          dtm_id,
			 GOTH_ID         quality_id,
                         GOTH_DATATYPE   datatype,
			 GOTH_REAL       exaggeration,
			 GOTH_REAL       offset,
			 GOTH_INTEGER    nquality_prms,
			 GOTH_VALUE      quality_prms[],
                         GOTH_INTEGER    sub_type,
			 GOTH_REAL       start_x,
			 GOTH_REAL       start_y,
		         GOTH_REAL       sep_x,
		         GOTH_REAL       sep_y,
		         GOTH_INTEGER    npoints,
                         GOTH_REAL       *points,
                         GD_GEOMETRY     in_geom_id,
                         GD_GEOMETRY     *out_geom_id,
			 GOTH_INTEGER    *nvalues,
                         GOTH_BOOLEAN    **is_null,
                         GOTH_VALUE      **value,
			 GOTH_INTEGER    nprms,
                         GOTH_VALUE      prms[]) ;

typedef GOTH_STATUS (*DTM_RASTER_FUNC)(GD_DTM         dtm_id,
			               GOTH_ID         quality_id,
                                       GOTH_DATATYPE  datatype,
				       GOTH_REAL       exaggeration,
				       GOTH_REAL       offset,
				       GOTH_INTEGER    nquality_prms,
				       GOTH_VALUE      quality_prms[],
				       GOTH_INTEGER    nprms,
				       GOTH_VALUE      prms[],
				       GD_RAC          *rac_id) ;


typedef GOTH_STATUS  (*SURF_DOMAIN_FUNC)(
			    GOTH_INTEGER   grid_type,
                            GOTH_INTEGER   ngrid_prms,
                            GOTH_VALUE     grid_prms[],
                            GOTH_REAL      x,
                            GOTH_REAL      y,
		            GOTH_INTEGER   *num_points,
			    GOTH_INTEGER   *points[][2],
  			    GOTH_INTEGER   nprms,
                            GOTH_VALUE     prms[]) ;

typedef GOTH_STATUS  (*SURF_KNOT_FUNC)(
			  GOTH_INTEGER            grid_type,
			  GOTH_BOOLEAN            action_npoints,
                          GOTH_INTEGER            ngrid_prms,
                          GOTH_VALUE              grid_prms[],
                          GOTH_INTEGER            interpolation,
                          GOTH_REAL               xin,
                          GOTH_REAL               yin,
                          GOTH_REAL               *xout,
                          GOTH_REAL               *yout,
		          GOTH_INTEGER            *num_points,
		          GOTH_REAL               *points,
  		          GOTH_INTEGER            nprms,
                          GOTH_VALUE              prms[]) ;


typedef GOTH_STATUS  (*SURF_DELETE_FUNC)(GD_SURF   	        surf_id) ;

typedef GOTH_STATUS  (*SURF_STORE_FUNC)(GD_UES_INTERNAL		ues_arg,
					GD_SURF   	        surf_id) ;

typedef GOTH_STATUS  (*SURF_RESTORE_FUNC)(
					GD_UES_INTERNAL	       	ues_arg,
					GOTH_INTEGER            *nprms,
					GOTH_DATATYPE           **datatypes,
					GOTH_VALUE	        **values) ;

typedef GOTH_STATUS  (*GRID_DELETE_FUNC)(GD_GRID   	        grid_id) ;

typedef GOTH_STATUS  (*GRID_STORE_FUNC)(GD_UES_INTERNAL	ues_arg,
					GD_GRID         grid_id) ;


typedef GOTH_STATUS  (*GRID_RESTORE_FUNC)(
					GD_UES_INTERNAL	       	ues_arg,
					GOTH_INTEGER            *nprms,
					GOTH_DATATYPE           **datatypes,
					GOTH_VALUE	        **values) ;

typedef GOTH_STATUS  (*SURF_VALUE_FUNC)(GD_SURF       surf_id,
					GOTH_DATATYPE datatype,
					GOTH_INTEGER  npoints,
					GOTH_REAL     *points,
					GOTH_DATATYPE *odatatype,
					GOTH_VALUE    *value,
					GOTH_BOOLEAN  *is_null,
					GOTH_INTEGER   nprms,
					GOTH_VALUE    prms[]) ;

typedef GOTH_STATUS  (*SURF_NORMAL_FUNC)(GD_SURF         surf_id,
                            GOTH_REAL       x_tol,
                            GOTH_REAL       y_tol,
			    GOTH_INTEGER    npoints,
                            GOTH_REAL       *points,
                            GOTH_REAL       *nx,
                            GOTH_REAL       *ny,
                            GOTH_REAL       *nz,
                            GOTH_BOOLEAN    *is_null,
			    GOTH_INTEGER    nprms,
                            GOTH_VALUE      prms[]) ;

typedef GOTH_STATUS  (*SURF_LINE_FUNC)(GD_SURF         surf_id,
                          GOTH_INTEGER    sub_type,
			  GOTH_REAL       start_x,
			  GOTH_REAL       start_y,
			  GOTH_REAL       sep_x,
			  GOTH_REAL       sep_y,
			  GOTH_INTEGER    npoints,
                          GOTH_REAL       *points,
                          GD_GEOMETRY     in_geom_id,
                          GD_GEOMETRY     *out_geom_id,
			  GOTH_INTEGER    *nvalues,
                          GOTH_BOOLEAN    *is_null,
                          GOTH_VALUE      *value,
			  GOTH_INTEGER    nprms,
                          GOTH_VALUE      prms[]) ;

typedef GOTH_STATUS (*SURF_SHRAST_FUNC)    (GD_SURF        surf_id,
					   GOTH_REAL      xn,	
					   GOTH_REAL      yn,
					   GOTH_REAL      zn,
					   GOTH_REAL      low_thresh,
					   GOTH_REAL      high_thresh,
					   GOTH_REAL      factor,
					   GOTH_REAL      x_tol,
					   GOTH_REAL      y_tol,
					   GOTH_REAL      scale1,
					   GOTH_REAL      scale2,
					   GOTH_REAL      origin1,
					   GOTH_REAL      origin2,
					   GOTH_REAL      torigin1,
					   GOTH_REAL      torigin2,
					   GOTH_INTEGER   pix_type,
					   GOTH_INTEGER   content,
					   GOTH_INTEGER   image_size1,
					   GOTH_INTEGER   image_size2,
					   GOTH_INTEGER   tile_size1,
					   GOTH_INTEGER   tile_size2,
					   GOTH_INTEGER	  pack_type,
					   GOTH_INTEGER	  nsigbits,
					   GOTH_INTEGER   nprms,
					   GOTH_VALUE     *prms,
					   GD_RAC 	  *rac_id) ;

typedef GOTH_STATUS (*SURF_APRAST_FUNC)    (GD_SURF        surf_id,
					   GOTH_REAL      xvec,	
					   GOTH_REAL      yvec,
					   GOTH_REAL      low_thresh,
					   GOTH_REAL      high_thresh,
					   GOTH_REAL      factor,
					   GOTH_REAL      x_tol,
					   GOTH_REAL      y_tol,
					   GOTH_REAL      scale1,
					   GOTH_REAL      scale2,
					   GOTH_REAL      origin1,
					   GOTH_REAL      origin2,
					   GOTH_REAL      torigin1,
					   GOTH_REAL      torigin2,
					   GOTH_INTEGER   pix_type,
					   GOTH_INTEGER   content,
					   GOTH_INTEGER   image_size1,
					   GOTH_INTEGER   image_size2,
					   GOTH_INTEGER   tile_size1,
					   GOTH_INTEGER   tile_size2,
					   GOTH_INTEGER	  pack_type,
					   GOTH_INTEGER	  nsigbits,
					   GOTH_INTEGER   nprms,
					   GOTH_VALUE     *prms,
					   GD_RAC 	  *rac_id) ;

typedef GOTH_STATUS (*SURF_SLRAST_FUNC)    (GD_SURF        surf_id,
					   GOTH_REAL      xvec,	
					   GOTH_REAL      yvec,
					   GOTH_REAL      low_thresh,
					   GOTH_REAL      high_thresh,
					   GOTH_REAL      factor,
					   GOTH_REAL      x_tol,
					   GOTH_REAL      y_tol,
					   GOTH_REAL      scale1,
					   GOTH_REAL      scale2,
					   GOTH_REAL      origin1,
					   GOTH_REAL      origin2,
					   GOTH_REAL      torigin1,
					   GOTH_REAL      torigin2,
					   GOTH_INTEGER   pix_type,
					   GOTH_INTEGER   content,
					   GOTH_INTEGER   image_size1,
					   GOTH_INTEGER   image_size2,
					   GOTH_INTEGER   tile_size1,
					   GOTH_INTEGER   tile_size2,
					   GOTH_INTEGER	  pack_type,
					   GOTH_INTEGER	  nsigbits,
					   GOTH_INTEGER   nprms,
					   GOTH_VALUE     *prms,
					   GD_RAC 	  *rac_id) ;

typedef GOTH_STATUS (*SURF_POP_FUNC)    (GD_SURF        surf_id,
					 GOTH_INTEGER   nprms,
					 GOTH_VALUE     *prms) ;

typedef GOTH_STATUS (*SURF_PTRAST_FUNC)    (GD_SURF        surf_id,
					   GOTH_REAL      exaggeration,
					   GOTH_REAL      offset,
					   GOTH_REAL      scale1,
					   GOTH_REAL      scale2,
					   GOTH_REAL      origin1,
					   GOTH_REAL      origin2,
					   GOTH_REAL      torigin1,
					   GOTH_REAL      torigin2,
					   GOTH_INTEGER   pix_type,
					   GOTH_INTEGER   content,
					   GOTH_INTEGER   image_size1,
					   GOTH_INTEGER   image_size2,
					   GOTH_INTEGER   tile_size1,
					   GOTH_INTEGER   tile_size2,
					   GOTH_INTEGER   pack_type,
					   GOTH_INTEGER	  nsigbits,
					   GOTH_INTEGER   nprms,
					   GOTH_VALUE     *prms,
					   GD_RAC 	  *rac_id) ;

typedef GOTH_STATUS (*COMB_LAYER_FUNC)    (
                 GOTH_INTEGER   ninput_datasets,   
                 GOTH_INTEGER	input_pack_types[],
                 GOTH_INTEGER   input_nplanes[],   
                 VOID_P         input_data[],     
                 GOTH_INTEGER   bit_offset,        
                 GOTH_INTEGER   npixels_to_process,
                 GOTH_REAL      start_x,           
                 GOTH_REAL      start_y,           
                 GOTH_REAL      diff_x,            
                 GOTH_INTEGER	output_pack_type,  
                 GOTH_INTEGER   output_nplanes,    
                 VOID_P         output_data,       
                 GOTH_VALUE     *function_values) ;

#endif

/* $Header: /lslhome/gothic/hdr/tranlib/v1-6/RCS/hdr.tran_defns.h,v 1.7 1994/09/08 06:05:39 adrian Exp $								*/
/* 									*/
/* $Log: hdr.tran_defns.h,v $
 * Revision 1.7  1994/09/08  06:05:39  adrian
 * Version v1-6 derived from v1-5
 * Give the correct prototype for a general function in tran_defsn.h
 * WICC 284
 *
 * Revision 1.6  1993/11/29  19:18:01  davidm
 * Version v1-5 derived from v1-4
 * Update tranlib calls to tran_cb_set_func to take VOID_P instead of
 * function pointer to enable compilation on the VAX>
 * WICC 164.
 * Compiled successfully on ULTRIX.
 *
 * Revision 1.5  1993/07/07  13:02:18  davidm
 * Version v1-4 derived from v1-3
 * Development of aspect call-back for surfaces .
 *
 * Revision 1.4  1993/01/15  15:05:54  olivia
 * Version v1-3 derived from v1-2
 * Update the parameters of raster data transformations to tell whether
 * 1) The transformation can be accomplished via a lookup table
 * 2) The transformation has a spatial component, that is the output
 * pixel value is a function both of its value and its position.
 *
 * Revision 1.3  1992/08/26  17:22:52  snail
 * Version v1-2 derived from v1-1
 * Resolve NULL/0 conflicts
 * Added new (LULL callable) routine to test if coordinate function has been
 * registered with tranlib (tran_test_coord_func).
 * Purify fixes.
 *
 * Revision 1.2  1992/04/24  16:04:18  jon
 * Version v1-1 derived from v1-0
 * Addition of general transformations to the types of functions treated by TRANLIB
 * Inclusion of general transformation RACs
 *								*/
