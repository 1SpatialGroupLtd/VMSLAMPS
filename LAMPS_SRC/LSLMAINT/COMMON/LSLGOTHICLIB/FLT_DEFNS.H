/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-04-22 10:12:02.000000000 +0100
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
#ifndef _FLT_DEFNS
#define _FLT_DEFNS
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


/* Filter type enum definition */
/*******************************/
typedef enum filter_types  {
                            FILTER_NOT_DEFINED,
                            FILTER_MEAN,
                            FILTER_MODE,
                            FILTER_MEDIAN,
                            FILTER_SHARPEN,
                            FILTER_CONVOLUTION,
                            FILTER_CONVOLUTION_SHIFT,
                            FILTER_COLOUR_CODE_MODE,
                            FILTER_SPECKLE_REMOVAL,
                            FILTER_VARIANCE,
                            FILTER_INVERSE_VARIANCE,
			    FILTER_CONTRAST_RATIO,
			    FILTER_INVERSE_CONTRAST_RATIO,
                            FILTER_SPECKLE_CODE_REMOVAL
			   } FILTER_TYPES;

/* $Header: /lslhome/gothic/hdr/filterlib/v1-7/RCS/hdr.flt_defns.h,v 1.8 1994/01/20 17:17:03 davidm Exp $								*/
/* 									*/
/* $Log: hdr.flt_defns.h,v $
 * Revision 1.8  1994/01/20  17:17:03  davidm
 * Version v1-7 derived from v1-6
 * Implementation of speckle removle filters for coded values.
 * Code value filters work by defining speckles to
 * be aggregations of pixels with the same coded value. Pixels in the
 * speckle are replaced by the modal value of the values around the edge
 * of the pixel.
 * WICC 182
 *
 * Revision 1.7  1993/09/02  07:05:18  stevewi
 * Version v1-6 derived from v1-5
 * WICC 110 fix a bug in checking the kernel dimensions.
 * Freeze for BNSC IGIS integration testing.
 *
 * Revision 1.6  1993/07/22  10:56:35  davidm
 * Version v1-5 derived from v1-4
 * Development of a smoothing RGB filter for stipple areas.
 * Fix a bug in the row optimised convoluyion filter which led to the
 * incorrect result due to incorrectly positioned pointers.
 *
 * Revision 1.5  1993/06/23  14:56:58  davidm
 * Version v1-4 derived from v1-3
 * Incorpoarate a stipple removal filter into filterlib.
 *
 * Revision 1.4  1993/03/30  14:21:55  davidm
 * Version v1-3 derived from v1-2
 * Fix a bug in convolution filter for binary data with incorrect pointer increment.
 * Convert to using `GOTH_1U_INTEGER' etc..
 *
 * Revision 1.3  1993/01/04  15:40:31  olivia
 * Version v1-2 derived from v1-1
 * leak in flt_build_filter jacket routine
 *
 * Revision 1.2  1992/08/26  14:47:54  davidm
 * Version v1-1 derived from v1-0
 * Extraction to import test library.
 * Enahancements to use more input datatypes ad use quicker algorithms to
 * perform filtering.
 *								*/
#endif
