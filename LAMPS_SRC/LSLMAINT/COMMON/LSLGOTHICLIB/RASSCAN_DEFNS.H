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
#ifndef _RASSCAN_DEFNS
#define _RASSCAN_DEFNS
#ifndef RASSCAN_DEFNS
#define RASSCAN_DEFNS





#endif
/* $Header: /lslhome/gothic/hdr/rasscanlib/v1-7/RCS/hdr.rasscan_defns.h,v 1.8 1993/10/18 14:37:18 johnh Exp $								*/
/* 									*/
/* $Log: hdr.rasscan_defns.h,v $
 * Revision 1.8  1993/10/18  14:37:18  johnh
 * Version v1-7 derived from v1-6
 * Use const void in arguments to qsort call-backs for complation on the
 * alpha axp.
 * Fix 2 bugs shown up by the geometries created by POLYFORMLIB.
 * When checking for intersections and looking for a join point along
 * a level stretch and fail to find the join point backtrack along the
 * level section.
 * When not checking for intersections use > instead of >= test.
 *
 * Revision 1.7  1993/03/22  15:06:59  olivia
 * Version v1-6 derived from v1-5
 * Try to fix a rather horrible bug where qsort has deferenced before
 * the base pointer passed to it.
 * The problem is that the comparison functions for real numbers
 * does not test equality.
 *
 * Revision 1.6  1993/03/15  12:43:36  olivia
 * Version v1-5 derived from v1-4
 * Make rasscanlib robust to the case where the caller of the rasscanlib
 * routines lies about the suitability of his geometry e.g. says it is
 * a well defined area when the geometry is really self-intersecting.
 *
 * Revision 1.5  1992/10/19  21:54:27  jon
 * Version v1-4 derived from v1-3
 * Fix a bug to increment the number of turns found when the found turn is
 * at the end of a set of points. The increment is necessary when more than
 * point set is present.
 *
 * Revision 1.4  1992/10/02  14:54:47  snail
 * Version v1-3 derived from v1-2
 * Fix up leaks when the rasscan descriptor is reused.
 *
 * Revision 1.3  1992/09/08  11:33:09  davidm
 * Version v1-2 derived from v1-1
 * Enable scan-lines to be output in increasing y value as well as decreasing
 * y value.
 * Enable intersecting lines to be scanned in an ON/OFF switch mode.
 *
 * Revision 1.2  1992/07/17  12:38:03  davidm
 * Version v1-1 derived from v1-0
 * Correction in pointer where the pointer moves back across the start of a loop.
 *
 * Revision 1.1  1992/07/02  13:56:23  davidm
 * Version v1-0 derived from root
 * Initial development work.
 *								*/
#endif
