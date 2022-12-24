/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:21:20.000000000 +0000
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
#ifndef _TRNRES_INTRINSICS
#define _TRNRES_INTRINSICS

/*---------------------------------------------------------------------------*/
/* LIBRARY trn_get_coord_work_space					     */
/*...........................................................................*/
/*---------------------------------------------------------------------------*/

extern GOTH_STATUS trn_get_coord_work_space(GOTH_INTEGER nget,
					    GOTH_REAL    **in_coord,
					    GOTH_REAL    **out_coord) ;
extern GOTH_STATUS trn_full_table_map( 
				      GOTH_DESCRIPTOR source_rac_id,
				      GOTH_DESCRIPTOR rac_id,
				      GOTH_REAL       start_coord1,
				      GOTH_REAL       start_coord2,	
				      GOTH_INTEGER    plow1,
				      GOTH_INTEGER    plow2,
				      GOTH_INTEGER    phigh1,
				      GOTH_INTEGER    phigh2,
				      VOID_P          buffer,
				      GOTH_INTEGER    rast_access,
				      VOID_P          pixel_access,
				      GOTH_INTEGER    bufsize1,
				      GOTH_INTEGER    bufsize2,
				      TRANS_COORD_FUNC transf_fn,
				      GOTH_INTEGER    ntrans_params,
				      GOTH_VALUE      trans_params[],
				      GOTH_INTEGER    ninput_space_params,
				      GOTH_VALUE      input_space_params[],
				      GOTH_INTEGER    noutput_space_params,
				      GOTH_VALUE      output_space_params[],
				      GOTH_INTEGER    nraster_params,
				      GOTH_VALUE      raster_params[],
				      RAST_POINT_TYPE pix_type, 
				      GOTH_REAL       scale1,
				      GOTH_REAL       scale2,
				      GOTH_REAL       origin1,
				      GOTH_REAL       origin2,
				      GOTH_REAL       out_scale1,
				      GOTH_REAL       out_scale2,
				      RAST_PACK_TYPE  pack_type,
				      GOTH_INTEGER    nplanes,
				      GOTH_INTEGER    total_bits,
				      GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_approx_table_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;

extern GOTH_STATUS trn_full_closest_map( 
					GOTH_DESCRIPTOR source_rac_id,
					GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
					VOID_P          buffer,
					GOTH_INTEGER    rast_access,
					VOID_P          pixel_access,
					GOTH_INTEGER    bufsize1,
					GOTH_INTEGER    bufsize2,
					TRANS_COORD_FUNC transf_fn,
					GOTH_INTEGER    ntrans_params,
					GOTH_VALUE      trans_params[],
					GOTH_INTEGER    ninput_space_params,
					GOTH_VALUE      input_space_params[],
					GOTH_INTEGER    noutput_space_params,
					GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
					RAST_POINT_TYPE pix_type, 
					GOTH_REAL       scale1,
					GOTH_REAL       scale2,
					GOTH_REAL       origin1,
					GOTH_REAL       origin2,
					GOTH_REAL       out_scale1,
					GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_approx_closest_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;

extern GOTH_STATUS trn_full_cweig_map( 
					GOTH_DESCRIPTOR source_rac_id,
					GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
					VOID_P          buffer,
					GOTH_INTEGER    rast_access,
					VOID_P          pixel_access,
					GOTH_INTEGER    bufsize1,
					GOTH_INTEGER    bufsize2,
					TRANS_COORD_FUNC transf_fn,
					GOTH_INTEGER    ntrans_params,
					GOTH_VALUE      trans_params[],
					GOTH_INTEGER    ninput_space_params,
					GOTH_VALUE      input_space_params[],
					GOTH_INTEGER    noutput_space_params,
					GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
					RAST_POINT_TYPE pix_type, 
					GOTH_REAL       scale1,
					GOTH_REAL       scale2,
					GOTH_REAL       origin1,
					GOTH_REAL       origin2,
					GOTH_REAL       out_scale1,
					GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_approx_cweig_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;
extern GOTH_STATUS trn_full_cuweig_map( 
					GOTH_DESCRIPTOR source_rac_id,
					GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
					VOID_P          buffer,
					GOTH_INTEGER    rast_access,
					VOID_P          pixel_access,
					GOTH_INTEGER    bufsize1,
					GOTH_INTEGER    bufsize2,
					TRANS_COORD_FUNC transf_fn,
					GOTH_INTEGER    ntrans_params,
					GOTH_VALUE      trans_params[],
					GOTH_INTEGER    ninput_space_params,
					GOTH_VALUE      input_space_params[],
					GOTH_INTEGER    noutput_space_params,
					GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
					RAST_POINT_TYPE pix_type, 
					GOTH_REAL       scale1,
					GOTH_REAL       scale2,
					GOTH_REAL       origin1,
					GOTH_REAL       origin2,
					GOTH_REAL       out_scale1,
					GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_approx_cuweig_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;

extern GOTH_STATUS trn_full_area_map( 
				      GOTH_DESCRIPTOR source_rac_id,
				      GOTH_DESCRIPTOR rac_id,
				      GOTH_REAL       start_coord1,
				      GOTH_REAL       start_coord2,	
				      GOTH_INTEGER    plow1,
				      GOTH_INTEGER    plow2,
				      GOTH_INTEGER    phigh1,
				      GOTH_INTEGER    phigh2,
				      VOID_P          buffer,
				      GOTH_INTEGER    rast_access,
				      VOID_P          pixel_access,
				      GOTH_INTEGER    bufsize1,
				      GOTH_INTEGER    bufsize2,
				      TRANS_COORD_FUNC transf_fn,
				      GOTH_INTEGER    ntrans_params,
				      GOTH_VALUE      trans_params[],
				      GOTH_INTEGER    ninput_space_params,
				      GOTH_VALUE      input_space_params[],
				      GOTH_INTEGER    noutput_space_params,
				      GOTH_VALUE      output_space_params[],
				      GOTH_INTEGER    nraster_params,
				      GOTH_VALUE      raster_params[],
				      RAST_POINT_TYPE pix_type, 
				      GOTH_REAL       scale1,
				      GOTH_REAL       scale2,
				      GOTH_REAL       origin1,
				      GOTH_REAL       origin2,
				      GOTH_REAL       out_scale1,
				      GOTH_REAL       out_scale2,
 				      RAST_PACK_TYPE  pack_type,
				      GOTH_INTEGER    nplanes,
				      GOTH_INTEGER    total_bits,
				      GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_approx_area_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;
extern GOTH_STATUS trn_full_user_map( 
				      GOTH_DESCRIPTOR source_rac_id,
				      GOTH_DESCRIPTOR rac_id,
				      GOTH_REAL       start_coord1,
				      GOTH_REAL       start_coord2,	
				      GOTH_INTEGER    plow1,
				      GOTH_INTEGER    plow2,
				      GOTH_INTEGER    phigh1,
				      GOTH_INTEGER    phigh2,
				      VOID_P          buffer,
				      GOTH_INTEGER    rast_access,
				      VOID_P          pixel_access,
				      GOTH_INTEGER    bufsize1,
				      GOTH_INTEGER    bufsize2,
				      TRANS_COORD_FUNC transf_fn,
				      GOTH_INTEGER    ntrans_params,
				      GOTH_VALUE      trans_params[],
				      GOTH_INTEGER    ninput_space_params,
				      GOTH_VALUE      input_space_params[],
				      GOTH_INTEGER    noutput_space_params,
				      GOTH_VALUE      output_space_params[],
				      GOTH_INTEGER    nraster_params,
				      GOTH_VALUE      raster_params[],
				      RAST_POINT_TYPE pix_type, 
				      GOTH_REAL       scale1,
				      GOTH_REAL       scale2,
				      GOTH_REAL       origin1,
				      GOTH_REAL       origin2,
				      GOTH_REAL       out_scale1,
				      GOTH_REAL       out_scale2,
 				      RAST_PACK_TYPE  pack_type,
				      GOTH_INTEGER    nplanes,
				      GOTH_INTEGER    total_bits,
				      GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_approx_user_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;

extern GOTH_STATUS trn_full_carea_map( 
				      GOTH_DESCRIPTOR source_rac_id,
				      GOTH_DESCRIPTOR rac_id,
				      GOTH_REAL       start_coord1,
				      GOTH_REAL       start_coord2,	
				      GOTH_INTEGER    plow1,
				      GOTH_INTEGER    plow2,
				      GOTH_INTEGER    phigh1,
				      GOTH_INTEGER    phigh2,
				      VOID_P          buffer,
				      GOTH_INTEGER    rast_access,
				      VOID_P          pixel_access,
				      GOTH_INTEGER    bufsize1,
				      GOTH_INTEGER    bufsize2,
				      TRANS_COORD_FUNC transf_fn,
				      GOTH_INTEGER    ntrans_params,
				      GOTH_VALUE      trans_params[],
				      GOTH_INTEGER    ninput_space_params,
				      GOTH_VALUE      input_space_params[],
				      GOTH_INTEGER    noutput_space_params,
				      GOTH_VALUE      output_space_params[],
				      GOTH_INTEGER    nraster_params,
				      GOTH_VALUE      raster_params[],
				      RAST_POINT_TYPE pix_type, 
				      GOTH_REAL       scale1,
				      GOTH_REAL       scale2,
				      GOTH_REAL       origin1,
				      GOTH_REAL       origin2,
				      GOTH_REAL       out_scale1,
				      GOTH_REAL       out_scale2,
 				      RAST_PACK_TYPE  pack_type,
				      GOTH_INTEGER    nplanes,
				      GOTH_INTEGER    total_bits,
				      GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_approx_carea_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;
extern GOTH_STATUS trn_full_cuarea_map( 
				      GOTH_DESCRIPTOR source_rac_id,
				      GOTH_DESCRIPTOR rac_id,
				      GOTH_REAL       start_coord1,
				      GOTH_REAL       start_coord2,	
				      GOTH_INTEGER    plow1,
				      GOTH_INTEGER    plow2,
				      GOTH_INTEGER    phigh1,
				      GOTH_INTEGER    phigh2,
				      VOID_P          buffer,
				      GOTH_INTEGER    rast_access,
				      VOID_P          pixel_access,
				      GOTH_INTEGER    bufsize1,
				      GOTH_INTEGER    bufsize2,
				      TRANS_COORD_FUNC transf_fn,
				      GOTH_INTEGER    ntrans_params,
				      GOTH_VALUE      trans_params[],
				      GOTH_INTEGER    ninput_space_params,
				      GOTH_VALUE      input_space_params[],
				      GOTH_INTEGER    noutput_space_params,
				      GOTH_VALUE      output_space_params[],
				      GOTH_INTEGER    nraster_params,
				      GOTH_VALUE      raster_params[],
				      RAST_POINT_TYPE pix_type, 
				      GOTH_REAL       scale1,
				      GOTH_REAL       scale2,
				      GOTH_REAL       origin1,
				      GOTH_REAL       origin2,
				      GOTH_REAL       out_scale1,
				      GOTH_REAL       out_scale2,
 				      RAST_PACK_TYPE  pack_type,
				      GOTH_INTEGER    nplanes,
				      GOTH_INTEGER    total_bits,
				      GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_approx_cuarea_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;

extern GOTH_STATUS trn_ifull_area_map( 
				      GOTH_DESCRIPTOR source_rac_id,
				      GOTH_DESCRIPTOR rac_id,
				      GOTH_REAL       start_coord1,
				      GOTH_REAL       start_coord2,	
				      GOTH_INTEGER    plow1,
				      GOTH_INTEGER    plow2,
				      GOTH_INTEGER    phigh1,
				      GOTH_INTEGER    phigh2,
				      VOID_P          buffer,
				      GOTH_INTEGER    rast_access,
				      VOID_P          pixel_access,
				      GOTH_INTEGER    bufsize1,
				      GOTH_INTEGER    bufsize2,
				      TRANS_COORD_FUNC transf_fn,
				      GOTH_INTEGER    ntrans_params,
				      GOTH_VALUE      trans_params[],
				      GOTH_INTEGER    ninput_space_params,
				      GOTH_VALUE      input_space_params[],
				      GOTH_INTEGER    noutput_space_params,
				      GOTH_VALUE      output_space_params[],
				      GOTH_INTEGER    nraster_params,
				      GOTH_VALUE      raster_params[],
				      RAST_POINT_TYPE pix_type, 
				      GOTH_REAL       scale1,
				      GOTH_REAL       scale2,
				      GOTH_REAL       origin1,
				      GOTH_REAL       origin2,
				      GOTH_REAL       out_scale1,
				      GOTH_REAL       out_scale2,
 				      RAST_PACK_TYPE  pack_type,
				      GOTH_INTEGER    nplanes,
				      GOTH_INTEGER    total_bits,
				      GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_iapprox_area_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;

extern GOTH_STATUS trn_sifull_area_map( 
				      GOTH_DESCRIPTOR source_rac_id,
				      GOTH_DESCRIPTOR rac_id,
				      GOTH_REAL       start_coord1,
				      GOTH_REAL       start_coord2,	
				      GOTH_INTEGER    plow1,
				      GOTH_INTEGER    plow2,
				      GOTH_INTEGER    phigh1,
				      GOTH_INTEGER    phigh2,
				      VOID_P          buffer,
				      GOTH_INTEGER    rast_access,
				      VOID_P          pixel_access,
				      GOTH_INTEGER    bufsize1,
				      GOTH_INTEGER    bufsize2,
				      TRANS_COORD_FUNC transf_fn,
				      GOTH_INTEGER    ntrans_params,
				      GOTH_VALUE      trans_params[],
				      GOTH_INTEGER    ninput_space_params,
				      GOTH_VALUE      input_space_params[],
				      GOTH_INTEGER    noutput_space_params,
				      GOTH_VALUE      output_space_params[],
				      GOTH_INTEGER    nraster_params,
				      GOTH_VALUE      raster_params[],
				      RAST_POINT_TYPE pix_type, 
				      GOTH_REAL       scale1,
				      GOTH_REAL       scale2,
				      GOTH_REAL       origin1,
				      GOTH_REAL       origin2,
				      GOTH_REAL       out_scale1,
				      GOTH_REAL       out_scale2,
 				      RAST_PACK_TYPE  pack_type,
				      GOTH_INTEGER    nplanes,
				      GOTH_INTEGER    total_bits,
				      GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_siapprox_area_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;

extern GOTH_STATUS trn_uifull_area_map( 
				      GOTH_DESCRIPTOR source_rac_id,
				      GOTH_DESCRIPTOR rac_id,
				      GOTH_REAL       start_coord1,
				      GOTH_REAL       start_coord2,	
				      GOTH_INTEGER    plow1,
				      GOTH_INTEGER    plow2,
				      GOTH_INTEGER    phigh1,
				      GOTH_INTEGER    phigh2,
				      VOID_P          buffer,
				      GOTH_INTEGER    rast_access,
				      VOID_P          pixel_access,
				      GOTH_INTEGER    bufsize1,
				      GOTH_INTEGER    bufsize2,
				      TRANS_COORD_FUNC transf_fn,
				      GOTH_INTEGER    ntrans_params,
				      GOTH_VALUE      trans_params[],
				      GOTH_INTEGER    ninput_space_params,
				      GOTH_VALUE      input_space_params[],
				      GOTH_INTEGER    noutput_space_params,
				      GOTH_VALUE      output_space_params[],
				      GOTH_INTEGER    nraster_params,
				      GOTH_VALUE      raster_params[],
				      RAST_POINT_TYPE pix_type, 
				      GOTH_REAL       scale1,
				      GOTH_REAL       scale2,
				      GOTH_REAL       origin1,
				      GOTH_REAL       origin2,
				      GOTH_REAL       out_scale1,
				      GOTH_REAL       out_scale2,
 				      RAST_PACK_TYPE  pack_type,
				      GOTH_INTEGER    nplanes,
				      GOTH_INTEGER    total_bits,
				      GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_uiapprox_area_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;

extern GOTH_STATUS trn_rfull_area_map( 
				      GOTH_DESCRIPTOR source_rac_id,
				      GOTH_DESCRIPTOR rac_id,
				      GOTH_REAL       start_coord1,
				      GOTH_REAL       start_coord2,	
				      GOTH_INTEGER    plow1,
				      GOTH_INTEGER    plow2,
				      GOTH_INTEGER    phigh1,
				      GOTH_INTEGER    phigh2,
				      VOID_P          buffer,
				      GOTH_INTEGER    rast_access,
				      VOID_P          pixel_access,
				      GOTH_INTEGER    bufsize1,
				      GOTH_INTEGER    bufsize2,
				      TRANS_COORD_FUNC transf_fn,
				      GOTH_INTEGER    ntrans_params,
				      GOTH_VALUE      trans_params[],
				      GOTH_INTEGER    ninput_space_params,
				      GOTH_VALUE      input_space_params[],
				      GOTH_INTEGER    noutput_space_params,
				      GOTH_VALUE      output_space_params[],
				      GOTH_INTEGER    nraster_params,
				      GOTH_VALUE      raster_params[],
				      RAST_POINT_TYPE pix_type, 
				      GOTH_REAL       scale1,
				      GOTH_REAL       scale2,
				      GOTH_REAL       origin1,
				      GOTH_REAL       origin2,
				      GOTH_REAL       out_scale1,
				      GOTH_REAL       out_scale2,
 				      RAST_PACK_TYPE  pack_type,
				      GOTH_INTEGER    nplanes,
				      GOTH_INTEGER    total_bits,
				      GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_rapprox_area_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;


extern GOTH_STATUS trn_usifull_area_map( 
				      GOTH_DESCRIPTOR source_rac_id,
				      GOTH_DESCRIPTOR rac_id,
				      GOTH_REAL       start_coord1,
				      GOTH_REAL       start_coord2,	
				      GOTH_INTEGER    plow1,
				      GOTH_INTEGER    plow2,
				      GOTH_INTEGER    phigh1,
				      GOTH_INTEGER    phigh2,
				      VOID_P          buffer,
				      GOTH_INTEGER    rast_access,
				      VOID_P          pixel_access,
				      GOTH_INTEGER    bufsize1,
				      GOTH_INTEGER    bufsize2,
				      TRANS_COORD_FUNC transf_fn,
				      GOTH_INTEGER    ntrans_params,
				      GOTH_VALUE      trans_params[],
				      GOTH_INTEGER    ninput_space_params,
				      GOTH_VALUE      input_space_params[],
				      GOTH_INTEGER    noutput_space_params,
				      GOTH_VALUE      output_space_params[],
				      GOTH_INTEGER    nraster_params,
				      GOTH_VALUE      raster_params[],
				      RAST_POINT_TYPE pix_type, 
				      GOTH_REAL       scale1,
				      GOTH_REAL       scale2,
				      GOTH_REAL       origin1,
				      GOTH_REAL       origin2,
				      GOTH_REAL       out_scale1,
				      GOTH_REAL       out_scale2,
 				      RAST_PACK_TYPE  pack_type,
				      GOTH_INTEGER    nplanes,
				      GOTH_INTEGER    total_bits,
				      GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_usiapprox_area_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;




extern GOTH_STATUS trn_full_weight_map( 
				      GOTH_DESCRIPTOR source_rac_id,
				      GOTH_DESCRIPTOR rac_id,
				      GOTH_REAL       start_coord1,
				      GOTH_REAL       start_coord2,	
				      GOTH_INTEGER    plow1,
				      GOTH_INTEGER    plow2,
				      GOTH_INTEGER    phigh1,
				      GOTH_INTEGER    phigh2,
				      VOID_P          buffer,
				      GOTH_INTEGER    rast_access,
				      VOID_P          pixel_access,
				      GOTH_INTEGER    bufsize1,
				      GOTH_INTEGER    bufsize2,
				      TRANS_COORD_FUNC transf_fn,
				      GOTH_INTEGER    ntrans_params,
				      GOTH_VALUE      trans_params[],
				      GOTH_INTEGER    ninput_space_params,
				      GOTH_VALUE      input_space_params[],
				      GOTH_INTEGER    noutput_space_params,
				      GOTH_VALUE      output_space_params[],
				      GOTH_INTEGER    nraster_params,
				      GOTH_VALUE      raster_params[],
				      RAST_POINT_TYPE pix_type, 
				      GOTH_REAL       scale1,
				      GOTH_REAL       scale2,
				      GOTH_REAL       origin1,
				      GOTH_REAL       origin2,
				      GOTH_REAL       out_scale1,
				      GOTH_REAL       out_scale2,
 				      RAST_PACK_TYPE  pack_type,
				      GOTH_INTEGER    nplanes,
				      GOTH_INTEGER    total_bits,
				      GOTH_INTEGER    plane_size) ;

extern GOTH_STATUS trn_approx_weight_map(
                                        GOTH_DESCRIPTOR source_rac_id,
                                        GOTH_DESCRIPTOR rac_id,
					GOTH_REAL       start_coord1,
					GOTH_REAL       start_coord2,	
					GOTH_INTEGER    plow1,
					GOTH_INTEGER    plow2,
					GOTH_INTEGER    phigh1,
					GOTH_INTEGER    phigh2,
                                        VOID_P          buffer,	
					GOTH_INTEGER    rast_access,
                                        VOID_P          pixel_access,
                                        GOTH_INTEGER    bufsize1,
                                        GOTH_INTEGER    bufsize2,
                                        TRANS_COORD_FUNC transf_fn,
                                        GOTH_INTEGER    ntrans_params,
                                        GOTH_VALUE      trans_params[],
                                        GOTH_INTEGER    ninput_space_params,
                                        GOTH_VALUE      input_space_params[],
                                        GOTH_INTEGER    noutput_space_params,
                                        GOTH_VALUE      output_space_params[],
					GOTH_INTEGER    nraster_params,
					GOTH_VALUE      raster_params[],
                                        RAST_POINT_TYPE pix_type, 
                                        GOTH_REAL       scale1,
                                        GOTH_REAL       scale2,
                                        GOTH_REAL       origin1,
                                        GOTH_REAL       origin2,
                                        GOTH_REAL       out_scale1,
                                        GOTH_REAL       out_scale2,
					RAST_PACK_TYPE  pack_type,
					GOTH_INTEGER    nplanes,
					GOTH_INTEGER    total_bits,
					GOTH_INTEGER    plane_size,
	                                GOTH_REAL       xstart,
	                                GOTH_REAL       ystart,
	                                GOTH_REAL       delta_xx,
	                                GOTH_REAL       delta_xy,
	                                GOTH_REAL       delta_yx,
	                                GOTH_REAL       delta_yy,
	                                GOTH_REAL       delta_xxy,
	                                GOTH_REAL       delta_yxy) ;


/*---------------------------------------------------------------------------*/
/* extern TRN_ALLOC_TABULATE                                                 */
/*...........................................................................*/
/* Allocates the space for tabulation descriptor.                            */
/*                                                                           */
/* Returns  : ( GOTH_DESCRIPTOR ) Gothic tabulation data descriptor.         */
/*                                                                           */
/*---------------------------------------------------------------------------*/
extern GOTH_DESCRIPTOR trn_alloc_tabulate( );

/*---------------------------------------------------------------------------*/
/* extern TRN_CREATE_TABULATE                                                */
/*...........................................................................*/
/* Creates a resampling tabulation matrix according to the given function    */
/* and parameters. This function does all the memory allocation, etc. but    */
/* expects the given function to actually do the work of generating the nos. */
/*                                                                           */
/*---------------------------------------------------------------------------*/
extern GOTH_STATUS trn_create_tabulate( GOTH_DESCRIPTOR     table_desc,
                                        GOTH_INTEGER        table_dim,
                                        GOTH_INTEGER        table_npts,
                                        TRN_TABULATE_FN     table_fn );

/*---------------------------------------------------------------------------*/
/* extern TRN_DELETE_TABULATE                                                */
/*...........................................................................*/
/* Deletes a resampling tabulation matrix structures.                        */
/*                                                                           */
/*---------------------------------------------------------------------------*/
extern GOTH_STATUS trn_delete_tabulate( GOTH_DESCRIPTOR  *table_desc );



/*----------------------------------------------------------------------*/
/* EXTERN trn_table_sincx						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Generates a tabulation for the Sinc resampling function, i.e.:	*/
/* sin(pi*x)/(pi*x)							*/
/*									*/
/* Note, the tabulation array is essentially : 				*/
/* table_values[nsub_intervals][kernal_size]				*/
/*									*/
/* The values are stored in this way to ensure fast access to the 	*/
/* required group of values within the array.                           */
/*									*/
/* See local function `trn_set_table_points()' for the actual ordering	*/
/* scheme.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* kernal_size	  - in	- Kernal size of the resampling function	*/
/* nsub_intervals - in	- Number of subintervals per kernal interval	*/
/*                        (i.e. the table resolution)			*/
/* table_values[] - in	- array to hold the resampling function		*/
/*			  tabulation					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		 - tabulation calcuation was successfull	*/
/* GOTH__BADCONVFUNCARGS - NULL pointer passed for tabulation array	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS trn_table_sincx(GOTH_INTEGER kernal_size,
				   GOTH_INTEGER nsub_intervals,
				   GOTH_REAL    table_values[]);

/*----------------------------------------------------------------------*/
/* EXTERN trn_table_hanning						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Generates a tabulation for the Hanning resampling function, i.e.:	*/
/* cos(pi*x/N)**2 * (sin(pi*x)/(pi*x))					*/
/*									*/
/* where N is the kernal size.						*/
/*									*/
/* Note, the tabulation array is essentially : 				*/
/* table_values[nsub_intervals][kernal_size]				*/
/*									*/
/* The values are stored in this way to ensure fast access to the 	*/
/* required group of values within the array.                           */
/*									*/
/* See local function `trn_set_table_points()' for the actual ordering	*/
/* scheme.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* kernal_size	  - in	- Kernal size of the resampling function	*/
/* nsub_intervals - in	- Number of subintervals per kernal interval	*/
/*                        (i.e. the table resolution)			*/
/* table_values[] - in	- array to hold the resampling function		*/
/*			  tabulation					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		 - tabulation calcuation was successfull	*/
/* GOTH__BADCONVFUNCARGS - NULL pointer passed for tabulation array	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS trn_table_hanning(GOTH_INTEGER kernal_size,
				     GOTH_INTEGER nsub_intervals,
				     GOTH_REAL    table_values[]);

/*----------------------------------------------------------------------*/
/* EXTERN trn_table_wilson						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Generates a tabulation for the Wilson resampling function, i.e.:	*/
/* cos(pi*x/N) * (sin(pi*x)/(pi*x))					*/
/*									*/
/* where N is the kernal size.						*/
/*									*/
/* Note, the tabulation array is essentially : 				*/
/* table_values[nsub_intervals][kernal_size]				*/
/*									*/
/* The values are stored in this way to ensure fast access to the 	*/
/* required group of values within the array.                           */
/*									*/
/* See local function `trn_set_table_points()' for the actual ordering	*/
/* scheme.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* kernal_size	  - in	- Kernal size of the resampling function	*/
/* nsub_intervals - in	- Number of subintervals per kernal interval	*/
/*                        (i.e. the table resolution)			*/
/* table_values[] - in	- array to hold the resampling function		*/
/*			  tabulation					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		 - tabulation calcuation was successfull	*/
/* GOTH__BADCONVFUNCARGS - NULL pointer passed for tabulation array	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS trn_table_wilson(GOTH_INTEGER kernal_size,
				     GOTH_INTEGER nsub_intervals,
				     GOTH_REAL    table_values[]);

/*----------------------------------------------------------------------*/
/* EXTERN trn_table_haskell						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Generates a tabulation for the Haskell resampling function, i.e.:	*/
/* cot(pi*x/N) * sin(pi*x)/N						*/
/*									*/
/* where N is the kernal size.						*/
/*									*/
/* Note, the tabulation array is essentially : 				*/
/* table_values[nsub_intervals][kernal_size]				*/
/*									*/
/* The values are stored in this way to ensure fast access to the 	*/
/* required group of values within the array.                           */
/*									*/
/* See local function `trn_set_table_points()' for the actual ordering	*/
/* scheme.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* kernal_size	  - in	- Kernal size of the resampling function	*/
/* nsub_intervals - in	- Number of subintervals per kernal interval	*/
/*                        (i.e. the table resolution)			*/
/* table_values[] - in	- array to hold the resampling function		*/
/*			  tabulation					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		 - tabulation calcuation was successfull	*/
/* GOTH__BADCONVFUNCARGS - NULL pointer passed for tabulation array	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS trn_table_haskell(GOTH_INTEGER kernal_size,
				     GOTH_INTEGER nsub_intervals,
				     GOTH_REAL    table_values[]);

/*----------------------------------------------------------------------*/
/* EXTERN trn_table_cubic						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Generates a tabulation for the cubic convolution resampling function,*/
/* i.e.:								*/
/*        f(x) = (1.5*x - 2.5)*x*x + 1.0           0.0 <= x <= 1.0	*/
/*             = ((-0.5*x + 2.5)*x -4.0)*x + 2.0   1.0 <= x <= 2.0      */
/*             = f(-x)							*/
/*									*/
/*									*/
/* Note, the tabulation array is essentially : 				*/
/* table_values[nsub_intervals][kernal_size]				*/
/*									*/
/* The values are stored in this way to ensure fast access to the 	*/
/* required group of values within the array.                           */
/*									*/
/* See local function `trn_set_table_points()' for the actual ordering	*/
/* scheme.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* kernal_size	  - in	- Kernal size of the resampling function	*/
/* nsub_intervals - in	- Number of subintervals per kernal interval	*/
/*                        (i.e. the table resolution)			*/
/* table_values[] - in	- array to hold the resampling function		*/
/*			  tabulation					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		 - tabulation calcuation was successfull	*/
/* GOTH__BADCONVFUNCARGS - NULL pointer passed for tabulation array	*/
/*                         or the kernal size is not 4			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS trn_table_cubic(GOTH_INTEGER kernal_size,
				   GOTH_INTEGER nsub_intervals,
				   GOTH_REAL    table_values[]);


/*****************************************************************************/


#endif 
/* $Header: /gothic/hdr/trnreslib/v1-9/RCS/hdr.trnres_intrinsics.h,v 1.10 1995/03/13 13:55:23 clarke Exp $								*/
/* 									*/
