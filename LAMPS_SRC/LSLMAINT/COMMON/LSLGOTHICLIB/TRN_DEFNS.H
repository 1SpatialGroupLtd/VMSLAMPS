/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:19:40.000000000 +0000
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
#ifndef _TRN_DEFNS
#define _TRN_DEFNS
/* $Header: /gothic/hdr/trnlib/v1-8/RCS/hdr.trn_defns.h,v 1.9 1995/02/21 18:27:06 clarke Exp $								*/
/* 									*/
/* $Log: hdr.trn_defns.h,v $
 * Revision 1.9  1995/02/21  18:27:06  clarke
 * Version v1-8 derived from v1-7
 * Add support for user defined subsampling routines in trnreslib.
 * WICC 284.
 *
 * Revision 1.8  1993/07/22  10:30:34  davidm
 * Version v1-7 derived from v1-6
 * Addition of colour weight average for MCE.
 *
 * Revision 1.7  1992/12/08  17:27:49  mikec
 * Version v1-6 derived from v1-5
 * Fix to the tabulated resampling function table generation functions in
 * `trn_table_fns.c' to ensure that the resampling functions are symmetric
 * about the mid-point.
 *
 * Note, a corresponding fix needs to be made to tabulated resampling functions
 * in `trn_resample_table.c' etc in TRNRESLIB. This means that this fixed version
 * of TRNLIB can only be used with versions of TRNRESLIB later than v1-3.
 * Moved the file `trn_table_fns.c' to `trnres_table.c' in TRNRESLIB since the
 * extern functions in trn_table_fns.c are declared in the TRNRESLIB intrinsics
 * file "trnres_intrinsics.h". The resampling function table generation functions
 * are essentially used in conjunction with the tabulated resampling
 * functionality of TRNRESLIB.
 * Fix implemented and tested.
 *
 * Revision 1.6  1992/10/07  14:46:56  andyb
 * Version v1-5 derived from v1-4
 * Change space_kind_init, tran_kind_init to ensure that multiple
 * space datasets can be created within a session.
 *
 * Revision 1.5  1992/10/06  11:54:02  andyb
 * Version v1-4 derived from v1-3
 * To correct erroneous conversion of MBR 'add on' margin from a real to
 * an integer within the MBR functions.
 * Correction to tiling-priority call-back so that the output buffer is
 * specified to be the whole tile.
 *
 * Revision 1.4  1992/09/11  15:25:56  mikec
 * Version v1-3 derived from v1-2
 * Remove trans kind "Identity" from trn_trans_kind_init. It screws spacelib
 * by having no parameters.
 * oFroze version so that bug-fixes to the MBR software can be made.
 *
 * Revision 1.3  1992/08/26  20:16:17  jon
 * Version v1-2 derived from v1-1
 * Upgrade TRNLIB to make use of the `any' space-kind option when defining the
 * source and destination space-kinds of a transformation-kind.
 *
 * Revision 1.2  1992/08/06  20:23:28  adrian
 * Version v1-1 derived from v1-0
 * Partial rewrite of resampling schemes for the case where the data is not
 * byte data.
 *
 * Also added new routines to allow trnlib to tell spacelib about its
 * transformation kinds, space kinds and the names that trnlib has used to
 * register its function addresses with tranlib.
 *
 * Revision 1.1  1992/03/16  22:54:52  jon
 * Version v1-0 derived from root
 * Version containing `smart' alternative from old system
 *								*/

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Ian Fisher  20-Mar-91					*/
/************************************************************************/

#include "goth_config.h"
#include "goth_datatypes.h"
#include "goth_defns.h"
#include "gothic_status_codes.h"
#include "goth_streams.h"
#include "goth_intrinsics.h"
#include "sch_functions.h"

#include "tran_defns.h"
#include "tran_intrinsics.h"
#include "lsr_defns.h"
#include "lsr_intrinsics.h"
#include "lsr_export.h"
#include "lsr_access.h"

/************************************************************************/
/*									*/
/*			  T R A N S F O R M S				*/
/*									*/
/* Part of GOTHIC module 						*/
/*									*/
/* GOTHIC include contain definitions peculiar to the TRN module        */
/* This source mainly contains documentation on how the transformations */
/* and colour cube information is passed into the rsater map functions. */
/*									*/
/************************************************************************/


/** Raster Parameters for Resampling *****************************************/
/*                                                                           */
/* The raster paramaters are passed into the raster transformatio/resampling */
/* functions via the 'nraster_params' and 'raster_params' variables in the   */
/* parameter lists.                                                          */
/* The 'nraster_params' refers to the number of parameters contained in the  */
/* 'raster_params' array. In these functions this can either be 2 or 8.      */
/*                                                                           */
/* The layout is as follows :                                                */
/*  raster_params[0].real    -  tolerance: If the tolerance is less than zero*/
/*                                         then the bilinear approximation   */
/*                                         transformation is used. Else, if  */
/*                                         the tolerance is > zero, then the */
/*                                         approx. method is only used if it */
/*                                         satisfy the accuracy requirements.*/
/*                                         Else, direct transformations are  */
/*                                         implemented whixh take a bit      */
/*                                         longer.                           */
/*                                                                           */
/*   raster_params[1].boolean - colour   : TRUE if data is to be considered  */
/*                                         colour data, else greyscale data  */
/*                                         is assumed. If TRUE, then colour  */
/*                                         map and cube data must be provided*/
/*                                         in the following 6 parameters else*/
/*                                         these parameters do not have to be*/
/*                                         present.                          */
/*                                                                           */
/*   raster_params[2].integer - colour map size : Dimension of the colour map*/
/*                                         which implies the dimension for   */
/*                                         one colour. This value must not be*/
/*                                         greater than 256.                 */
/*                                                                           */
/*   raster_params[3].integer - colour map pointer : Points to the GOTH_REAL */
/*                                         array which contains the colour   */
/*                                         map. This is a single dimension   */
/*                                         array with the different colour   */
/*                                         maps following each other in      */
/*                                         single contiguous blocks within   */
/*                                         the array. Ie. All the red data   */
/*                                         first followed by the green and   */
/*                                         lastly the blue.                  */
/*                                                                           */
/*   raster_params[4].integer - colour cube - red dimension                  */
/*   raster_params[5].integer - colour cube - green dimension                */
/*   raster_params[6].integer - colour cube - blue dimension                 */
/*                                                                           */
/*   raster_params[6].integer - colour cube pointer : Points to the unsigned */
/*                                         char. array which contains the    */
/*                                         data defining the colour cube.    */
/*                                         Again this is a single dimension  */
/*                                         array which if defined in C as a  */
/*                                         3 dimension array would be :      */
/*                                                                           */
/*                                          cube[blue][green][red];          */
/*                                                                           */
/*****************************************************************************/



/** Bicubic ******************************************************************/
/* Bicubic Transformations are expected to be stored in the array          */
/* normally called 'trans_params' in the parameter lists to the point,       */
/* minimum bounding rectangle and raster functions in the TRN module.        */
/*                                                                           */
/* The order of this array is as follows :                                   */
/*                                                                           */
/* 1) The equation :                                                         */
/* X = a1 + a2x + a3xy + a4y + a5xx + a6xxy + a7xxyy + a8xyy + a9yy +        */
/*     a10xxx + a11xxxy + a12xxxyy + a13xxxyyy + a14xxyyy + a15xyyy + a16yyy */
/*                                                                           */
/* X = b1 + b2x + b3xy + b4y + b5xx + b6xxy + b7xxyy + b8xyy + b9yy +        */
/*     b10xxx + b11xxxy + b12xxxyy + b13xxxyyy + b14xxyyy + b15xyyy + b16yyy */
/*                                                                           */
/*                                                                           */
/* 2) Storage:                                                               */
/*    a16 - trans_params[0]    .....  a1 - trans_params[15]                  */
/*    b16 - trans_params[16]   .....  b1 - trans_params[31]                  */
/*                                                                           */
/*****************************************************************************/


/** 3rd ORDER ****************************************************************/
/* 3rd Order Transformations are expected to be stored in the array          */
/* normally called 'trans_params' in the parameter lists to the point,       */
/* minimum bounding rectangle and raster functions in the TRN module.        */
/*                                                                           */
/* The order of this array is as follows :                                   */
/*                                                                           */
/* 1) The equation :                                                         */
/*  X = a1 + a2x + a3y + a4xx + a5xy + a6yy + a7xxx + a8xxy + a9xyy + a10yyy */
/*                                                                           */
/*  Y = b1 + b2x + b3y + b4xx + b5xy + b6yy + b7xxx + b8xxy + b9xyy + b10yyy */
/*                                                                           */
/* 2) Storage:                                                               */
/*    a10 - trans_params[0]    .....  a1 - trans_params[9]                   */
/*    b10 - trans_params[10]   .....  b1 - trans_params[19]                  */
/*                                                                           */
/*****************************************************************************/


/** 2nd ORDER ****************************************************************/
/* 2nd Order Transformations are expected to be stored in the array          */
/* normally called 'trans_params' in the parameter lists to the point,       */
/* minimum bounding rectangle and raster functions in the TRN module.        */
/*                                                                           */
/* The order of this array is as follows :                                   */
/*                                                                           */
/* 1) The equation :                                                         */
/*  X = a1 + a2x + a3xx + a4y + a5xy + a6yy                                  */
/*                                                                           */
/*  Y = b1 + b2x + b3xx + b4y + b5xy + b6yy                                  */
/*                                                                           */
/* 2) Storage:                                                               */
/*    a6 - trans_params[0]    .....  a1 - trans_params[5]                    */
/*    b6 - trans_params[6]    .....  b1 - trans_params[11]                   */
/*                                                                           */
/*****************************************************************************/


/** 1st ORDER ****************************************************************/
/* 1st Order Transformations are expected to be stored in the array          */
/* normally called 'trans_params' in the parameter lists to the point,       */
/* minimum bounding rectangle and raster functions in the TRN module.        */
/*                                                                           */
/* The order of this array is as follows :                                   */
/*                                                                           */
/* 1) The equation :                                                         */
/*  X = a1 + a2x + a3y                                                       */
/*                                                                           */
/*  Y = b1 + b2x + b3y                                                       */
/*                                                                           */
/* 2) Storage:                                                               */
/*    a3 - trans_params[0]    .....  a1 - trans_params[2]                    */
/*    b3 - trans_params[4]    .....  b1 - trans_params[5]                    */
/*                                                                           */
/*****************************************************************************/



/** AFFINE *******************************************************************/
/* Affine Transformations are expected to be stored in the array             */
/* normally called 'trans_params' in the parameter lists to the point,       */
/* minimum bounding rectangle and raster functions in the TRN module.        */
/*                                                                           */
/* The order of this array is as follows :                                   */
/*                                                                           */
/* 1) The equation :                                                         */
/*                                                                           */
/* 1) The equation :                                                         */
/*  X = a1 + a2x + a3y                                                       */
/*                                                                           */
/*  Y = b1 + b2x + b3y                                                       */
/*                                                                           */
/* 2) Storage:                                                               */
/*    a3 - trans_params[0]    .....  a1 - trans_params[2]                    */
/*    b3 - trans_params[4]    .....  b1 - trans_params[5]                    */
/*                                                                           */
/*****************************************************************************/


/** BILINEAR *****************************************************************/
/* Bilinear Transformations are expected to be stored in the array           */
/* normally called 'trans_params' in the parameter lists to the point,       */
/* minimum bounding rectangle and raster functions in the TRN module.        */
/*                                                                           */
/* The order of this array is as follows :                                   */
/*                                                                           */
/* 1) The equation :                                                         */
/*  X = a1 + a2x + a3y + a4xy                                                */
/*                                                                           */
/*  Y = b1 + b2x + b3y + b4xy                                                */
/*                                                                           */
/* 2) Storage:                                                               */
/*    a4 - trans_params[0]    .....  a1 - trans_params[3]                    */
/*    b4 - trans_params[4]    .....  b1 - trans_params[7]                    */
/*                                                                           */
/*****************************************************************************/



/** PROJECTED 4 POINT ********************************************************/
/* Projected 4 point Transformations are expected to be stored in the array  */
/* normally called 'trans_params' in the parameter lists to the point,       */
/* minimum bounding rectangle and raster functions in the TRN module.        */
/*                                                                           */
/* The order of this array is as follows :                                   */
/*                                                                           */
/* 1) The equation :                                                         */
/*  X = (a1 + a2x + a3y)/(1 + d1x + d2y)                                     */
/*                                                                           */
/*  Y = (b1 + b2x + b3y)/(1 + d1x + d2y)                                     */
/*                                                                           */
/* 2) Storage:                                                               */
/*    a3 - trans_params[0]    .....  a1 - trans_params[2]                    */
/*    b3 - trans_params[3]    .....  b1 - trans_params[5]                    */
/*    d2 - trans_params[6]    .....  d1 - trans_params[7]                    */
/*                                                                           */
/*****************************************************************************/



/*****************************************************************************/
/*   ENUMS  ENUMS  ENUMS  ENUMS  ENUMS  ENUMS  ENUMS  ENUMS  ENUMS  ENUMS    */
/*****************************************************************************/

/* Transformation type enum definition */
/***************************************/
typedef enum transform_types {
                              TRN_NOT_DEFINED,
                              TRN_AFFINE,
                              TRN_PROJECT_4PT,
                              TRN_BILINEAR,
                              TRN_1ST_ORDER,
                              TRN_2ND_ORDER,
                              TRN_3RD_ORDER,
                              TRN_BICUBIC,
                              TRN_BIQUADRATIC
			     }
                              TRANSFORM_TYPES;


/* Resampling type enum definition */
/***********************************/
typedef enum resampling_types {
                               TRN_RESAMPLE_NOT_DEFINED,
                               TRN_RESAMPLE_CLOSEST,
                               TRN_RESAMPLE_WEIGHTED,
                               TRN_RESAMPLE_AREA,
			       TRN_RESAMPLE_USER
			      }
                               RESAMPLING_TYPES;



/************************************** EOF **********************************/

#endif
