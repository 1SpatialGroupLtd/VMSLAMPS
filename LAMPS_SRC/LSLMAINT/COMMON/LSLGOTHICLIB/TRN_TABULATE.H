/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:19:44.000000000 +0000
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
#ifndef _TRN_TABULATE
#define _TRN_TABULATE
/* $Header: /gothic/hdr/trnlib/v1-8/RCS/hdr.trn_tabulate.h,v 1.9 1995/02/21 18:27:51 clarke Exp $								*/
/* 									*/
/* $Log: hdr.trn_tabulate.h,v $
 * Revision 1.9  1995/02/21  18:27:51  clarke
 * Version v1-8 derived from v1-7
 * Add support for user defined subsampling routines in trnreslib.
 * WICC 284.
 *
 * Revision 1.8  1993/07/22  10:30:52  davidm
 * Version v1-7 derived from v1-6
 * Addition of colour weight average for MCE.
 *
 * Revision 1.7  1992/12/08  17:28:27  mikec
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
 * Revision 1.6  1992/10/07  14:47:28  andyb
 * Version v1-5 derived from v1-4
 * Change space_kind_init, tran_kind_init to ensure that multiple
 * space datasets can be created within a session.
 *
 * Revision 1.5  1992/10/06  11:54:26  andyb
 * Version v1-4 derived from v1-3
 * To correct erroneous conversion of MBR 'add on' margin from a real to
 * an integer within the MBR functions.
 * Correction to tiling-priority call-back so that the output buffer is
 * specified to be the whole tile.
 *
 * Revision 1.4  1992/09/11  15:26:21  mikec
 * Version v1-3 derived from v1-2
 * Remove trans kind "Identity" from trn_trans_kind_init. It screws spacelib
 * by having no parameters.
 * oFroze version so that bug-fixes to the MBR software can be made.
 *
 * Revision 1.3  1992/08/26  20:16:44  jon
 * Version v1-2 derived from v1-1
 * Upgrade TRNLIB to make use of the `any' space-kind option when defining the
 * source and destination space-kinds of a transformation-kind.
 *
 * Revision 1.2  1992/08/06  20:23:46  adrian
 * Version v1-1 derived from v1-0
 * Partial rewrite of resampling schemes for the case where the data is not
 * byte data.
 *
 * Also added new routines to allow trnlib to tell spacelib about its
 * transformation kinds, space kinds and the names that trnlib has used to
 * register its function addresses with tranlib.
 *
 * Revision 1.1  1992/03/16  22:55:04  jon
 * Version v1-0 derived from root
 * Version containing `smart' alternative from old system
 *								*/

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/************************************************************************/

/************************************************************************/
/*									*/
/*			  T A B U L A T E                               */
/*									*/
/* Part of GOTHIC module 						*/
/*									*/
/* GOTHIC include file with tabulation data structures and function     */
/* typedefs.                                                            */
/*									*/
/************************************************************************/

/*****************************************************************************/
/*   Functions      Functions      Functions      Functions      Functions   */
/*****************************************************************************/


#endif
