/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:11:34.000000000 +0000
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
#ifndef _LSR_EXPORT
#define _LSR_EXPORT


#include "lsr_access.h"

/*----------------------------------------------------------------------*/
/* LIBRARY lsr_buffer_min_max						*/
/*......................................................................*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  lsr_buffer_min_max(RAST_PACK_TYPE  buffer_type,
			       GOTH_SPECIAL    buffer,
			       GOTH_INTEGER    size1,
			       GOTH_INTEGER    size2,
			       GOTH_INTEGER    wl1,
			       GOTH_INTEGER    wl2,
			       GOTH_INTEGER    wh1,
			       GOTH_INTEGER    wh2,
			       GOTH_REAL       *min_value,	
			       GOTH_REAL       *max_value,
			       VOID_P	       unknown_tile) ;


/*----------------------------------------------------------------------*/
/* LIBRARY lsr_corner_pixels						*/
/*......................................................................*/
/* 									*/
/*----------------------------------------------------------------------*/

extern void lsr_corner_pixels(GOTH_REAL		low1,
			      GOTH_REAL		low2,
			      GOTH_REAL		high1,
			      GOTH_REAL		high2,
			      GOTH_REAL		scale1,
			      GOTH_REAL		scale2,
			      GOTH_REAL		origin1,
			      GOTH_REAL		origin2,
			      RAST_POINT_TYPE   point,
			      GOTH_INTEGER	tilesz1,
			      GOTH_INTEGER	tilesz2,
			      GOTH_INTEGER    	*plow1,
			      GOTH_INTEGER    	*tlow1,
			      GOTH_INTEGER    	*olow1,
			      GOTH_INTEGER    	*plow2,
			      GOTH_INTEGER    	*tlow2,
			      GOTH_INTEGER    	*olow2,
			      GOTH_INTEGER    	*phigh1,
			      GOTH_INTEGER    	*thigh1,
			      GOTH_INTEGER    	*ohigh1,
			      GOTH_INTEGER    	*phigh2,
			      GOTH_INTEGER    	*thigh2,
			      GOTH_INTEGER    	*ohigh2) ;

/*----------------------------------------------------------------------*/
/* LIBRARY lsr_plane_data                                               */
/*......................................................................*/
/*----------------------------------------------------------------------*/

extern void lsr_plane_data(GOTH_INTEGER    nplanes_in,
			   GOTH_INTEGER    tot_bits_in,
			   RAST_PACK_TYPE  pack_type_in,
			   GOTH_INTEGER    *nplanes_out,
			   GOTH_INTEGER    *pixel_size_out) ;


extern void lsr_test_coords(REGION_ALIGNMENT_TYPE alignment,
                            RAST_POINT_TYPE       grid_point,
                            GOTH_REAL             inlow1,
                            GOTH_REAL             inlow2,
                            GOTH_REAL             inhigh1,
                            GOTH_REAL             inhigh2,
                            GOTH_REAL             scale1,
                            GOTH_REAL             scale2,
                            GOTH_REAL             *tlcoord1,
                            GOTH_REAL             *tlcoord2,
                            GOTH_REAL             *brcoord1,
                            GOTH_REAL             *brcoord2) ;

/*----------------------------------------------------------------------*/
/* LIBRARY lsr_efill_buffer                                              */
/*......................................................................*/
/* Return a pointer to a copy of part of the raster data                */
/* 									*/
/* data_type -in-  the type of data with which to fill buffer           */
/* pack_type -in- the pack type of the data				*/
/* nsigbits  -in- th enumber of significant bits in the data 		*/			
/* rvalue -in- the vallue of the pixel to fil buffer with               */
/* lowc1 -in-  the total extent of the region to be filled in pixels    */
/* lowc2                                                                */
/* highc1                                                               */
/* highc2                                                               */
/* pixel_order_type -in- the pixel order of the input buffer            */
/* bits_per_pixel -in- the bits per pixel in input buffer               */
/* buffer_out -in- the buffer to copy to                                */
/* lowo1 -in-  the total extent of the out buffer in pixels             */
/* lowo2                                                                */
/* higho1                                                               */
/* higho2                                                               */
/* N.B. The copy region should lie wholely within the                   */
/*      output buffer. It is the callers responsibility to make sure    */
/*      this is correct as no checking is done in this routine          */
/* N.B. Fill region does not have to be byte aligned with the           */
/*      output buffer,but performance will be much better if it is      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS lsr_efill_buffer(RAST_DATA_TYPE data_type,
			      RAST_PACK_TYPE pack_type,
			      GOTH_INTEGER   nsigbits,
			      GOTH_VALUE *rvalue,
                             GOTH_INTEGER lowc1,  GOTH_INTEGER lowc2,
                             GOTH_INTEGER highc1, GOTH_INTEGER highc2,
                             PIXEL_ORDER_TYPE pixel_order_in,
                             VOID_P buffer_out,
                             GOTH_INTEGER lowo1,GOTH_INTEGER lowo2,
                             GOTH_INTEGER higho1,GOTH_INTEGER higho2) ;

extern void  lsr_copy_buffer2(VOID_P buffer_in, 
                              GOTH_INTEGER lowi1,  GOTH_INTEGER lowi2,
                              GOTH_INTEGER highi1, GOTH_INTEGER highi2,
                              GOTH_INTEGER lowc1,  GOTH_INTEGER lowc2,
                              GOTH_INTEGER highc1, GOTH_INTEGER highc2,
                              PIXEL_ORDER_TYPE pixel_order_in,
                              GOTH_INTEGER bits_per_pixel,
                              VOID_P buffer_out,
                              GOTH_INTEGER lowo1,GOTH_INTEGER lowo2,
                              GOTH_INTEGER higho1,GOTH_INTEGER higho2,
                              GOTH_INTEGER lowco1,GOTH_INTEGER lowco2,
                              GOTH_INTEGER highco1,GOTH_INTEGER highco2) ;

extern void  lsr_copy_buffer(VOID_P buffer_in, 
                             GOTH_INTEGER lowi1,  GOTH_INTEGER lowi2,
                             GOTH_INTEGER highi1, GOTH_INTEGER highi2,
                             GOTH_INTEGER lowc1,  GOTH_INTEGER lowc2,
                             GOTH_INTEGER highc1, GOTH_INTEGER highc2,
                             PIXEL_ORDER_TYPE pixel_order_in,
                             GOTH_INTEGER bits_per_pixel,
                             VOID_P buffer_out,
                             GOTH_INTEGER lowo1,GOTH_INTEGER lowo2,
                             GOTH_INTEGER higho1,GOTH_INTEGER higho2) ;

extern GOTH_STATUS lsr_change_packtype(RAST_PACK_TYPE 		packtype_in,
				       RAST_PACK_TYPE 		packtype_out,
				       GOTH_SPECIAL       	buffer_in,
				       GOTH_SPECIAL       	buffer_out,
				       GOTH_VALUE	 	pack_value,
				       GOTH_INTEGER 		nplanes,
				       GOTH_INTEGER 		pixel_size_in,
				       GOTH_INTEGER 		pixel_size_out,
				       GOTH_INTEGER       	widthi,
				       GOTH_INTEGER      	heighti,
				       GOTH_INTEGER   		inoffset1,
				       GOTH_INTEGER 		inoffset2,
				       GOTH_INTEGER       	widthci,
				       GOTH_INTEGER       	heightci,
				       GOTH_INTEGER   		widtho,
				       GOTH_INTEGER   		heighto,
				       GOTH_INTEGER   		outoffset1,
				       GOTH_INTEGER   		outoffset2,
				       GOTH_INTEGER   		widthco,
				       GOTH_INTEGER   		heightco) ;

extern GOTH_STATUS lsrc_subsample_raster_map(
                                      GOTH_DESCRIPTOR    source_rac_id,
                                      GOTH_DESCRIPTOR    rac_id,
                                      GOTH_REAL          inlow1,
                                      GOTH_REAL          inlow2,
                                      GOTH_REAL          inhigh1,
                                      GOTH_REAL          inhigh2,
                                      GOTH_INTEGER       rast_access,
                                      VOID_P             pai,
                                      VOID_P             buffer,
                                      GOTH_INTEGER       bufsize1,
                                      GOTH_INTEGER       bufsize2,
                                      TRANS_COORD_FUNC   coord_func,
                                      GOTH_INTEGER       ntrans_params,
                                      GOTH_VALUE         trans_params[],
                                      GOTH_INTEGER       ninput_space_params,
                                      GOTH_VALUE         input_space_params[],
                                      GOTH_INTEGER       noutput_space_params,
                                      GOTH_VALUE         out_space_params[],
                                      GOTH_INTEGER       nraster_params,
                                      GOTH_VALUE         raster_params[]) ;


extern GOTH_STATUS lsrc_subsample_mbr_map(GOTH_REAL      inlow1,
                                       GOTH_REAL      inlow2,
                                       GOTH_REAL      inhigh1,
                                       GOTH_REAL      inhigh2,
                                       GOTH_REAL      *outlow1,
                                       GOTH_REAL      *outlow2,
                                       GOTH_REAL      *outhigh1,
                                       GOTH_REAL      *outhigh2,
                                       TRANS_COORD_FUNC         coordmap,
                                       GOTH_INTEGER   ntrans_params,
                                       GOTH_VALUE     trans_params[],
                                       GOTH_INTEGER   nmbr_params,
                                       GOTH_VALUE     mbr_params[],
                                       GOTH_INTEGER   ninput_space_params,
                                       GOTH_VALUE     input_space_params[],
                                       GOTH_INTEGER   noutput_space_params,
                                       GOTH_VALUE     out_space_params[]) ;

extern GOTH_STATUS lsrc_replicate_raster_map(
                                      GOTH_DESCRIPTOR    source_rac_id,
                                      GOTH_DESCRIPTOR    rac_id,
                                      GOTH_REAL          inlow1,
                                      GOTH_REAL          inlow2,
                                      GOTH_REAL          inhigh1,
                                      GOTH_REAL          inhigh2,
                                      GOTH_INTEGER       rast_access,
                                      VOID_P             pai,
                                      VOID_P             buffer,
                                      GOTH_INTEGER       bufsize1,
                                      GOTH_INTEGER       bufsize2,
                                      TRANS_COORD_FUNC   coord_func,
                                      GOTH_INTEGER       ntrans_params,
                                      GOTH_VALUE         trans_params[],
                                      GOTH_INTEGER       ninput_space_params,
                                      GOTH_VALUE         input_space_params[],
                                      GOTH_INTEGER       noutput_space_params,
                                      GOTH_VALUE         out_space_params[],
                                      GOTH_INTEGER       nraster_params,
                                      GOTH_VALUE         raster_params[]) ;


extern void lsr_pixel_diff(GOTH_REAL    startpoint1,
                           GOTH_REAL    startpoint2,
                           GOTH_REAL    endpoint1,
                           GOTH_REAL    endpoint2,
                           GOTH_REAL    scale1,
                           GOTH_REAL    scale2,
                           GOTH_INTEGER *idiff1,
                           GOTH_INTEGER *idiff2,
                           GOTH_REAL    *rdiff1,
                           GOTH_REAL    *rdiff2) ;

extern GOTH_STATUS lsli_read(
                              GOTH_DESCRIPTOR     rac_id,
                              VOID_P              out_buffer,
                              GOTH_INTEGER        buffsize1,
                              GOTH_INTEGER        buffsize2,
                              GOTH_REAL           low1,
                              GOTH_REAL           low2,
                              GOTH_REAL           high1,
                              GOTH_REAL           high2,
                              GOTH_INTEGER        nextern_params,
                              GOTH_VALUE          extern_params[]) ;

/*----------------------------------------------------------------------*/
/* EXTERN lsr_packtype_bytes						*/
/*......................................................................*/
/*----------------------------------------------------------------------*/

extern void lsr_packtype_bytes(RAST_PACK_TYPE    pack_type,
			       GOTH_INTEGER	 *nbits,
			       GOTH_INTEGER	 *nbytes) ;

extern void lsr_get_pixel_access_buffer(PIXEL_ACCESS_INFO *pa,
                                        VOID_P            *buffer,
                                        GOTH_INTEGER      *bufsize1,
                                        GOTH_INTEGER      *bufsize2,
                                        GOTH_REAL         *blow1,
                                        GOTH_REAL         *blow2,
                                        GOTH_REAL         *bhigh1,
                                        GOTH_REAL         *bhigh2) ;

#endif
/* $Header: /gothic/hdr/rasterlib/v1-20a-4/RCS/hdr.lsr_export.h,v 1.26 1995/03/13 11:44:04 clarke Exp $								*/
/* 									*/
/* $Log: hdr.lsr_export.h,v $
 * Revision 1.26  1995/03/13  11:44:04  clarke
 * Version v1-20a-4 derived from v1-20a-3
 * Need to include LSR_GET_PIXEL_ACCESS_PARAMS macro in lsr_access.h
 * because it is required by lsrclib v1-16 and later.
 *
 * Revision 1.25  1995/02/23  15:24:25  clarke
 * Version v1-20a-3 derived from v1-20a-2
 * Optimisation in lsr_access.h which was found be be much faster on VAX
 * and Alpha AXP (VMS)
 * See WICC 479. incorporate optimisation developed on VAX.
 *
 * Revision 1.23  1995/01/06  11:34:06  andyb
 * Version v1-20a-2 derived from v1-20a-1
 *
 * GOTHIC WICC 436.
 *
 * Fix problem in 'mbr_map' function in lsr.c where extra parameters
 * are assigned for 'lsrc_subsample_mbr_map()' and 'lsrc_affine_mbr_map()'
 * when not required resulting in an array bounds write. See GOTHIC error
 * log 477 for details.
 *
 * NB. Also requires lsrclib/v1-15. Copied lsr_external_defns.h and
 * lsr_external_cache_defns.h from rasterlib/v1-21 so lsrclib/v1-15
 * compiles against this version of rasterlib.
 *
 * Revision 1.22  1994/09/06  08:50:56  euanc
 * Version v1-20a-1 derived from v1-20
 * Make the tile hashing function independent of the RAC of the
 * tile to which it is attached. This is good policy anyway and
 * gets around the problem of having index blocks hanging around in the
 * cache which have no corresponding RAC then using the hash function to
 * delete themselves from the hash table.
 * WICC 321.
 * Implement writing through tiled rasters.
 * Fix bug in LSR_GET_NEXT_PIXEL.... macros when the next pixel is in a
 * new tile. The intile pixel position should be updated to the next tile.
 * Fix bug in subsampling of point rasters so that extra pixels are
 * pulled in at the high end of the the input range.
 * Frozen prior to CDCO system tests.
 *
 * Revision 1.21  1994/05/06  08:28:58  davidm
 * Version v1-20 derived from v1-19
 * Include interface to allow general transformation functions.
 * Fix jacket for lsr_set_rac_layered to stop seg falut if no
 * arguments.
 * WICC 284.
 *
 * Revision 1.20  1994/03/14  10:47:11  davida
 * Version v1-19 derived from v1-18
 * Fix a bug in the reference count for the unknown tile of a raster.
 * The reference count should not be decremented when the unknown value
 * for a tile is reset but the raster has not yet been initialised.
 * WICC 269 Error log 148
 *
 * Revision 1.16.1.7  1994/02/16  18:39:12  olivia
 * Version v1-18 derived from v1-17
 * Allow rasters which are input to raster call-backs to be edited within
 * a read call-back. This amounts to calling cache_value_altered for this
 * tile after the call-back has executed. The input raster must be
 * writeable,and it is the responsibility of the call-back to do
 * the editing and to ensure that it doesn't edit the unknown tile etc,etc.
 * WICC 163
 * Update header version number to 7, indicating use of SPAM files.
 * Tidy up tile locking structure to ease development of the side effect
 * editing.
 * Ensure that correct conversion is performed when writing out to files.
 * FIx bug in replication of tile buffers when pixels and tile edges are not
 * coincident.
 *
 * Revision 1.16.1.3  1993/10/07  16:07:32  davidm
 * Version v1-17 derived from v1-16
 * Develop lsr_get_reg_ptr to read the tiles in orders other than
 * top left horizontal
 * WICC 124
 * Replace the option RAST_TL_READ_X_WRITE_XW - that is on write dont do
 * a cache read but do a cache write (??????) with the correct option
 * RAST_TL_READ_X_WRITE_RX - that is the layering callback does a read on
 * a tile,but not a write.
 *
 * Revision 1.16.1.2  1993/08/11  09:34:39  davidr
 * Version v1-16 derived from v1-15
 * WIC 71 - Include FSM calls in the ``lsr_size...'' routines
 * which are altered to return reals.
 * Include new macros in lsr_access.h to deal with a union
 * containing the pointer types supported by reasterlib.
 * Include call to lsr_get_rac_unknown_real to return the
 * unknown value of a raster.
 *
 * Revision 1.16.1.1  1993/07/07  12:48:53  davidr
 * Version v1-15 derived from v1-14
 * Allow conversion of other datatypes to binary bit packed data.
 * .,
 *
 * Revision 1.16  1993/03/10  20:31:30  jon
 * Version v1-14 derived from v1-13
 * Fix a bug in lsr_copy and insert lsr_rename
 *
 * Revision 1.15  1993/02/08  16:45:52  davidm
 * Version v1-13 derived from v1-12
 * Allow scaling of rasters in transform racs to take account of resampling scheme.
 *
 * Revision 1.14  1993/01/15  15:24:54  olivia
 * Version v1-12 derived from v1-11
 * Allow file protection to be changed on data racs.
 * Change the handling of newly created files so that files are only
 * produced when data is to be written out from cache.
 *
 * Revision 1.13  1992/12/03  14:22:38  davidm
 * Version v1-11 derived from v1-10
 * Development of compression schemes using quad searches for areas
 * which compress well.
 * Use of speeded up default nearest neighbour sampling for non-integer replication
 * and subsampling.
 * Fix free memory read problem in `lsr_delete_rac_by_rac'
 * Set lsr_delete to return GOTH__NORMAL if the data files do not exist.
 *
 * Revision 1.12  1992/11/16  14:25:22  davidm
 * Version v1-10 derived from v1-9
 * Change delete functions so that they no longer return GOTH__ATTACH.
 * Remove a bug where the unknown tile pointer was being stored away and then
 * being realloced elsewhere so that the unknown tile was effectively being
 * overwritten.
 *
 * Revision 1.11  1992/10/19  22:42:40  jon
 * Version v1-9 derived from v1-8
 * Enable the setting of different resampling schemes to override the default
 * scheme of nearest neighbour when the transformation is automatically
 * invoked from rasterlib.
 * Add a function to enable a region to mark tiles as edited as they are
 * extracted through ``lsr_get_reg_ptr''. This will facilitate in situ
 * editing of files for raster editing etc..
 * Set an area of memory blatted with zero so this can be shared by all RAcs
 * with unknown value zero, and so save quite large areas of memory.
 * (e.g. c 50k for RGB byte tiles) .
 *
 * Revision 1.10  1992/09/24  15:06:06  davidr
 * Version v1-8 derived from v1-7
 * Automatatic forward mapping of the source data mbr onto the output dataset
 * for the case where no output data window has been explicitly set.
 * Automatic forward mapping of the source data tiling origin onto the
 * output dataset for the case where no tiling origin has been explicitly set.
 *
 * Revision 1.9  1992/09/21  10:19:01  davidm
 * Version v1-7 derived from v1-6
 * Fix a nasty bug relating to the attachment of rasters to regions.
 * Add a jacket for lsr_r_delete_rac.
 *
 * Revision 1.8  1992/09/15  10:30:24  davidm
 * Version v1-6 derived from v1-5
 * Fix a bug in snapping a tiling origin between a transform raster and its
 * source data when the offsets between the tiling origins are negative.
 * Inclusion of routine lsr_packtype_bytes to return the number of bytes
 * associated with a packing type.
 *
 * Revision 1.7  1992/09/06  19:55:21  jon
 * Version v1-5 derived from v1-4
 * To allow the conversion of short integer type datatypes to byte pack
 * datatypes.
 *
 * Revision 1.6  1992/08/26  20:07:50  jon
 * Version v1-4 derived from v1-3
 * fixed bug in 'lsr_set_space_tree'
 * Fixes to support raster transformations for Translate application.
 *
 * Revision 1.5  1992/08/17  09:58:27  davidm
 * Version v1-3 derived from v1-2
 * Inclusion of routines useful for raster import and export.
 * Various bug fixes and checking of enhancements for SMART release.
 *
 * Revision 1.4  1992/05/28  15:44:52  davidm
 * Version v1-2 derived from v1-1-1
 * Development of a raster using a MRB tree for the index.
 * Bug fixes for layering RACs where the layering function is null.
 *
 * Revision 1.3  1992/05/14  12:00:17  davidr
 * Version v1-1-1 derived from v1-1
 * Merge of old system VTRAK work with development version.
 * Miscellaneous bugfixes for SMART
 *
 * Revision 1.2  1992/04/24  13:04:51  jon
 * Version v1-1 derived from v1-0
 * Alternative extracted to enter access version of library.
 * Raster handling of look up tables with more than 256 entries.
 *								*/
