/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:16:22.000000000 +0000
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
#ifndef _TAD_DEFNS
#define _TAD_DEFNS
#endif
/* $Header: /lslhome/gothic/RCSroot/tadlib/RCS/RCS/hdr.tad_defns.h,v 1.5 1994/05/03 09:29:23 davida Exp $								*/
/* 									*/
/* $Log: hdr.tad_defns.h,v $
 * Revision 1.5  1994/05/03  09:29:23  davida
 * Version v1-7 derived from v1-5a-1
 * Change variable called "min" in compare.c to variable
 * minute to get compilation on VMS where it clashes with
 * macro called min.
 * WICC 284.
 *
 * Revision 1.3.1.5  1993/07/14  19:44:46  jon
 * Version v1-5a-1 derived from v1-5
 * Changes to tad_date_to_integers() to give correct error messages and also to
 * make it insist that the DD and YYYY fields have a valid digit in the each
 * position in the field. Currently 199P as year would give 199 instead of an
 * error. Similarly 19Q4 would give 19, rather than an error. Also a function,
 * tad_date_is_valid() and tad_time_is_valid() will be added to the library.
 * Upgrade makefile to new format.
 * Added new function tad_get_name_extension() which produces a string suitable
 * for using as part of a version name.
 *
 * Revision 1.3.1.3  1993/01/15  16:43:55  olivia
 * Version v1-5 derived from v1-4
 * Providing more Lull jacket routines.
 *
 * Revision 1.3.1.2  1992/11/30  12:44:35  snail
 * Version v1-4 derived from v1-3
 * Addition of jacket routines to existing routines that support conversion
 * between times and integers and dates and integers. Added by SRK for Simon
 * Hancock.
 *
 * Revision 1.3.1.1  1992/08/19  18:56:08  snail
 * Version v1-3 derived from v1-2
 * Adding new function to return a month as a string when given an integer (1-12)
 * the returned string can be specified to be upper/lower case , and can be 2 or
 * 3 characters long or its full length (eg ja,jan,january). Added for init-devt
 * siflib.
 *
 * Fixed bug in tad_advance_date to work correctly when advancing past
 * February 29th in a leap year (29 was subtracted twice in
 * _tad_recursive_add_date().)
 *
 * Revision 1.3  1992/07/08  09:39:59  snail
 * Version v1-2 derived from v1-1
 * Bug Fix to tad_advance_time, so that
 * a) advancing past 23:59:59.99 goes to 00:00:00.00
 * b) decrementing time through the 00 for hours, minutes, seconds or centiseconds
 * loops round to 23, 59, 59, 99 respectively.
 * Add new functions to:
 * 1) convert GOTH_DATE to three integers, for year/month/day
 * 2) convert those integers back again
 * 3) convert GOTH_TIME to integers for hours/minutes/centiseconds (whatever)
 * 4) and back again
 * - (1) and (2) are needed in NTFLIB to allow conversion from Gothic dates
 * to and from NTF dates
 * Bug fix to tad_date2txt, tad_txt2date, tad_time2txt, tad_txt2time:
 * Set the last byte of the string to NULL, not the one after last!
 * Change month_str in tad_advance_date to a 4 byte char array instead of a
 * GOTH_STRING. This is necessary since sscanf requires the space to have been
 * malloced before it is called. Also change month_str = "MON" to strncpy.
 *
 * Fixed a bug in tad_recursive_add_date so that when subtracting months past the
 * beginning of the year, the year was also decremented. Also changed all leap
 * year calculations to use the public function tad_year_is_leap for consistency.
 *								*/
