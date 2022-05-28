/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-04-19 19:27:50.000000000 +0100
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
#ifndef _RASSCAN_INTRINSICS
#define _RASSCAN_INTRINSICS

/*>>> EXTERN functions from RASSCAN.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN rasscan_build_rasscan						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Build a RASSCAN descriptor block.					*/
/* A RASSCAN descriptor block holds the data necessary to convert from  */
/* geometries (given as a list of closed lines) to scan lines.		*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/* rasscan_id	     -out- the built descriptor.			*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__MALLOC if insufficient memory for operation                   */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS rasscan_build_rasscan(GD_RASSCAN *rasscan_id)
;
/*----------------------------------------------------------------------*/
/* EXTERN rasscan_destroy_rasscan					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Build a RASSCAN descriptor block.					*/
/* A RASSCAN descriptor block holds the data necessary to convert from  */
/* geometries (given as a list of closed lines) to scan lines.		*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/* rasscan_id	     -out- the built descriptor.			*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__MALLOC if insufficient memory for operation                   */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS rasscan_destroy_rasscan(GD_RASSCAN rasscan_id);
/*----------------------------------------------------------------------*/
/* EXTERN rasscan_set_points						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Set the points for the the rasterising algorithm.			*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/* rasscan_id	     -in- the RASSCAN descriptor.			*/
/* backward	     -in- TRUE - scanlines to be output in increasing y */
/*			  FALSE - scanlines to be output in decreasing y*/
/* check_order	     -in- TRUE - Check that the output pioints are in   */
/*				 the correct order and reaarange if     */
/*				 necessary.				*/
/*			  FALSE - do not check 				*/
/* npoint_sets       -in- the number of point sets.			*/
/* points_in_set     -in- +array+ the number of points in each point    */
/*			  set.						*/
/* points	     -in- +array+ the set of point values for the point */
/*			  set.						*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__MALLOC if insufficient memory for operation                   */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS rasscan_set_points(GD_RASSCAN       rasscan_id,
				      GOTH_BOOLEAN     backward,
				      GOTH_INTEGER     check_order,
				      GOTH_INTEGER     npoint_sets,
				      GOTH_INTEGER     *points_in_set,
				      GOTH_REAL        **points) ;
/*----------------------------------------------------------------------*/
/* EXTERN rasscan_set_extent						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Set the extents for the the rasterising algorithm.			*/
/* The extent should lie outside the extent of the points defining the  */
/* area to be rasterised.						*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/* rasscan_id	     -in- the RASSCAN descriptor.			*/
/* xlow	             -in- the first coord of the bottom left hand       */
/*			  corner.					*/ 
/* ylow	             -in- the second coord of the bottom left hand      */
/*			  corner.					*/ 
/* xhigh	     -in- the first coord of the top right hand		*/
/*			  corner.					*/ 
/* yhigh	     -in- the second coord of the top right hand	*/
/*			  corner.					*/ 
/* ydiff	     -in- the spacing of the rasterization.		*/
/*			  corner.					*/ 
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__MALLOC if insufficient memory for operation                   */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS rasscan_set_extent(GD_RASSCAN rasscan_id,
				      GOTH_REAL     xlow,
				      GOTH_REAL     ylow,
				      GOTH_REAL     xhigh,
				      GOTH_REAL     yhigh,
				      GOTH_REAL     ydiff);
/*----------------------------------------------------------------------*/
/* EXTERN rasscan_get_scanlines						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Set the points for the the rasterising algorithm.			*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/* rasscan_id	     -in- the RASSCAN descriptor.			*/
/* get_backward	     -in- FALSE - get the values out in increasing x.  !*/
/*			  TRUE - get the vaues in decreasing x.	        */
/* yvalue	     -out- the y values of the x values.		*/
/* nxvalues	     -out- the number of xvalues.			*/
/* xvalues	     -out- the x value array for the runlengths.	*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__MALLOC if insufficient memory for operation                   */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS rasscan_get_scanlines(GD_RASSCAN	rasscan_id,
					 GOTH_BOOLEAN	get_backward,
					 GOTH_REAL      *yvalue,
					 GOTH_INTEGER 	*nxvalues,
					 GOTH_REAL    	**xvalues) ;
/* $Header: /lslhome/gothic/hdr/rasscanlib/v1-7/RCS/hdr.rasscan_intrinsics.h,v 1.8 1993/10/18 14:37:22 johnh Exp $								*/
/* 									*/
/* $Log: hdr.rasscan_intrinsics.h,v $
 * Revision 1.8  1993/10/18  14:37:22  johnh
 * Version v1-7 derived from v1-6
 * Use const void in arguments to qsort call-backs for complation on the
 * alpha axp.
 * Fix 2 bugs shown up by the geometries created by POLYFORMLIB.
 * When checking for intersections and looking for a join point along
 * a level stretch and fail to find the join point backtrack along the
 * level section.
 * When not checking for intersections use > instead of >= test.
 *
 * Revision 1.7  1993/03/22  15:07:00  olivia
 * Version v1-6 derived from v1-5
 * Try to fix a rather horrible bug where qsort has deferenced before
 * the base pointer passed to it.
 * The problem is that the comparison functions for real numbers
 * does not test equality.
 *
 * Revision 1.6  1993/03/15  12:43:37  olivia
 * Version v1-5 derived from v1-4
 * Make rasscanlib robust to the case where the caller of the rasscanlib
 * routines lies about the suitability of his geometry e.g. says it is
 * a well defined area when the geometry is really self-intersecting.
 *
 * Revision 1.5  1992/10/19  21:54:31  jon
 * Version v1-4 derived from v1-3
 * Fix a bug to increment the number of turns found when the found turn is
 * at the end of a set of points. The increment is necessary when more than
 * point set is present.
 *
 * Revision 1.4  1992/10/02  14:54:51  snail
 * Version v1-3 derived from v1-2
 * Fix up leaks when the rasscan descriptor is reused.
 *
 * Revision 1.3  1992/09/08  11:33:15  davidm
 * Version v1-2 derived from v1-1
 * Enable scan-lines to be output in increasing y value as well as decreasing
 * y value.
 * Enable intersecting lines to be scanned in an ON/OFF switch mode.
 *
 * Revision 1.2  1992/07/17  12:38:05  davidm
 * Version v1-1 derived from v1-0
 * Correction in pointer where the pointer moves back across the start of a loop.
 *
 * Revision 1.1  1992/07/02  13:56:26  davidm
 * Version v1-0 derived from root
 * Initial development work.
 *								*/
#endif
