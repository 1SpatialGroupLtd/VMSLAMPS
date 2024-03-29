/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:24:02.000000000 +0000
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
#ifndef _UTIL_FUNCTIONS
#define _UTIL_FUNCTIONS

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Mike Cook,  6-May-1992					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		    U T I L _ F U N C T I O N S . H 			*/
/*									*/
/* Part of GOTHIC module UTILLIB					*/
/*									*/
/* This header is now obsolete. All public functions are now declared	*/
/* in <<util_intrinsics.h>>.						*/
/*									*/
/************************************************************************/

#include "util_intrinsics.h

#endif
/* $Header: /gothic/RCSroot/utillib/RCS/RCS/hdr.util_functions.h,v 1.7 1995/01/15 21:18:21 jon Exp $								*/
/* 									*/
/* $Log: hdr.util_functions.h,v $
 * Revision 1.7  1995/01/15  21:18:21  jon
 * Version v1-6 derived from v1-5
 * See if I can speed things up.
 *
 * Revision 1.6  1994/12/11  18:11:51  jon
 * Version v1-5 derived from v1-4
 * Adding a function:
 *
 * util_extend_alloc() - which will only increase the amount of memory
 * allocated to a buffer.
 *
 * In addition, updated the other util_xxxx_xalloc() routines to use GOTHIC
 * versions of malloc() and realloc().
 * The above functions were added or modified as part of work required for
 * the versioned raster backup/restore work package.
 *
 * See WICC. 350.
 *
 * Revision 1.5  1994/05/19  17:44:22  jon
 * Version v1-4 derived from v1-3
 * See GWI 244.
 * Incorporation of additional utility functions for copying/replacing
 * buffers of data. Status check macros changed to wrappers for new SCHLIB
 * check macros.
 *
 * Added a function: util_copy_buffer(num_bytes, source, *dest) which creates
 * and returns a dynamic copy of a data buffer if the source buffer address is
 * non-NULL and the number of bytes to copy is positive. It returns NULL
 * otherwise.
 *
 * Added a function: util_replace_buffer(num_bytes, source, *dest) which destroys
 * (frees up) the data buffer defined by <<*dest>> on input (if non-NULL), then
 * creates and returns a dynamic copy of the contents of <<source>> via <<*dest>>
 * if the source data buffer address is non-NULL and the number of bytes to copy
 * is positive.
 *
 * Added a function util_strcat, that is like strcat but does a realoc when needed.
 *
 * Moved all the exported function declarations into <<util_intrinsics.h>>. The
 * header file <util_functions.h>> is now obsolete (just includes
 * <<util_intrinsics.h>>.
 *
 * WICC 244.
 *
 * Revision 1.4  1993/09/08  08:31:42  stevewi
 * Version v1-3 derived from v1-2
 * Added generic goth_descriptor alloc() and free() routines to the library.
 * Freeze for BNSC IGIS integration testing.
 *
 * Revision 1.3  1992/08/10  08:45:48  davida
 * Version v1-2 derived from v1-1
 * Fix includes of util_intrinsics.h (fix previous fix).
 *
 * Revision 1.2  1992/08/10  08:31:42  davida
 * Version v1-1 derived from v1-0
 * Removed duplicated rcsid in util_funcs.c.
 * Removed old file utilx_intrinsics.h
 *
 * Revision 1.1  1992/08/08  17:13:20  davida
 * Version v1-0 derived from root
 * First version.
 * y
 * y
 *								*/
