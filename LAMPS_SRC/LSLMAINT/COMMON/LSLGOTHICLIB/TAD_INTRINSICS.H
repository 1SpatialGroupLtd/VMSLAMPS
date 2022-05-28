/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:16:22.000000000 +0000
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
#ifndef _TAD_INTRINSICS
#define _TAD_INTRINSICS
/* $Header: /lslhome/gothic/RCSroot/tadlib/RCS/RCS/hdr.tad_intrinsics.h,v 1.5 1994/05/03 09:29:18 davida Exp $								*/
/* 									*/
/* $Log: hdr.tad_intrinsics.h,v $
 * Revision 1.5  1994/05/03  09:29:18  davida
 * Version v1-7 derived from v1-5a-1
 * Change variable called "min" in compare.c to variable
 * minute to get compilation on VMS where it clashes with
 * macro called min.
 * WICC 284.
 *
 * Revision 1.3.1.5  1993/07/14  19:44:32  jon
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
 * Revision 1.3.1.3  1993/01/15  16:43:50  olivia
 * Version v1-5 derived from v1-4
 * Providing more Lull jacket routines.
 *
 * Revision 1.3.1.2  1992/11/30  12:44:21  snail
 * Version v1-4 derived from v1-3
 * Addition of jacket routines to existing routines that support conversion
 * between times and integers and dates and integers. Added by SRK for Simon
 * Hancock.
 *
 * Revision 1.3.1.1  1992/08/19  18:55:56  snail
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
 * Revision 1.3  1992/07/08  09:39:46  snail
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
 *
 * Revision 1.2  1992/03/19  19:23:55  james
 * Version v1-1 derived from v1-0
 * Added function tad_time_diffs ( difference in seconds between two times
 * in tad format ).
 *								*/
#ifndef TAD_INTRINSICS_H
#define TAD_INTRINSICS_H
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    James Pearson,  2-Oct-1991					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		      T A D _ I N T R I N S I C S 			*/
/*									*/
/* Part of GOTHIC module TADLIB						*/
/* Version 0.1, James Pearson  2-Oct-1991				*/
/************************************************************************/

#include <time.h>	/* Needed by the LIBRARY functions below */

/*>>> LIBRARY functions from COMPARE.C <<<*/

/*>>> LIBRARY functions from LIBCONVERT.C <<<*/

extern GOTH_STATUS tad_struct2txt(struct    tm *tp, 
				  int       centisec,
				  GOTH_TIME gv_date,
				  GOTH_DATE gv_time);

extern GOTH_STATUS tad_txt2struct(GOTH_DATE gv_date,
				  GOTH_TIME gv_time,
				  struct tm *tp,
				  int       *centisecs);

extern GOTH_STATUS tad_struct2secs(struct tm tp, time_t *secs);

/*>>> LIBRARY functions from MODIFY.C <<<*/

/*>>> LIBRARY functions from NOW.C <<<*/

/*>>> EXTERN functions from COMPARE.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN tad_year_is_leap						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine returns TRUE or FALSE to indicate if the year passed to	*/
/* the routine is a leap year. This routine is taken from page 2172 of	*/
/* July-August 1978 Bell System Technical Journal, owned by DJ Radcliffe*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* year		-in-	The year to check				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* TRUE			The year in question is a leap year.		*/
/* FALSE		The year in question is not a leap year.	*/
/*----------------------------------------------------------------------*/

extern GOTH_BOOLEAN tad_year_is_leap(GOTH_INTEGER	year);

extern GOTH_STATUS tad_compare_dates( GOTH_DATE gv1, GOTH_DATE gv2);

extern GOTH_STATUS tad_compare_times( GOTH_TIME gv1, GOTH_TIME gv2);

extern GOTH_BOOLEAN tad_same_date(GOTH_DATE gv1, GOTH_DATE gv2);

extern GOTH_BOOLEAN tad_same_time(GOTH_TIME gv1, GOTH_TIME gv2);

extern GOTH_STATUS tad_time_diffs(GOTH_TIME t1, 
                                  GOTH_TIME t2,
                                  GOTH_REAL *diff);

/*>>> EXTERN functions from CONVERT.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN tad_date_is_valid						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine checks that a date is valid.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* date		-in-	Date to check.					*/
/* *valid	-out-	TRUE if date is valid.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS tad_date_is_valid(GOTH_DATE		date,
				     GOTH_BOOLEAN	*valid);
/*----------------------------------------------------------------------*/
/* EXTERN tad_time_is_valid						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine checks that a time is valid.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* time		-in-	Time to check.					*/
/* *valid	-out-	TRUE if time is valid.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS tad_time_is_valid(GOTH_TIME		time,
				     GOTH_BOOLEAN	*valid);
extern GOTH_STATUS tad_txt2time(GOTH_STRING txt_time, GOTH_TIME gv_time);

extern GOTH_STATUS tad_time2txt(GOTH_TIME gv_time, GOTH_STRING txt_time);

extern GOTH_STATUS tad_txt2date(GOTH_STRING txt_date, GOTH_DATE gv_date);

extern GOTH_STATUS tad_date2txt(GOTH_DATE gv_date, GOTH_STRING txt_date);

/*----------------------------------------------------------------------*/
/* EXTERN tad_date_to_integers						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Given a Gothic date, return the day (1-31), month (1-12) and year	*/
/* (????-????) as integers						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* date		- in  - Gothic date					*/
/* day		- out - day index					*/
/* month	- out - month index					*/
/* year		- out - the year					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		if all goes well				*/
/* GOTH__BADTIMEDATE	if the date does not make sense			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS tad_date_to_integers( GOTH_DATE	 date,
					 GOTH_INTEGER	*day,
					 GOTH_INTEGER	*month,
					 GOTH_INTEGER	*year );
/*----------------------------------------------------------------------*/
/* EXTERN tad_integers_to_date						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Given day (1-31), month (1-12) and year (0-9999) indexes, produce	*/
/* a Gothic date. The day will be righ-justified in its field, the	*/
/* year will be zero filled to four digits.				*/
/*									*/
/* Note: the ranges in parentheses above are enforced - an error will 	*/
/*	 be produced for any value outwith these ranges.		*/
/*									*/
/* Caveat: doesn't check that a date makes sense (in terms of Feb 29,	*/
/*         Sep 31, etc) - so beware what you ask for!			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* day		- in  - day index					*/
/* month	- in  - month index					*/
/* year		- in  - the year					*/
/* date		- out - a Gothic date					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		if all goes well				*/
/* GOTH__BADTIMEDATE	if the date does not make sense			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS tad_integers_to_date( GOTH_INTEGER	day,
					 GOTH_INTEGER	month,
					 GOTH_INTEGER	year,
					 GOTH_DATE	date );
/*----------------------------------------------------------------------*/
/* EXTERN tad_time_to_integers						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Takes a Gothic time and returns its components as integers		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* time		- in  - Gothic time					*/
/* hour		- out - hour number					*/
/* minute	- out - minute number					*/
/* second	- out - second number					*/
/* centisecond	- out - number of centiseconds				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		if all goes well				*/
/* GOTH__BADTIMEDATE	if the date does not make sense			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS tad_time_to_integers( GOTH_TIME	 time,
					 GOTH_INTEGER	*hour,
					 GOTH_INTEGER	*minute,
					 GOTH_INTEGER	*second,
					 GOTH_INTEGER	*centisecond );
/*----------------------------------------------------------------------*/
/* EXTERN tad_integers_to_time						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Takes time as a series of integers and produces a Gothic time	*/
/* Minutes, seconds and centiseconds are filled with zeroes to the left	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* hour		- in  - hour number		(must be 0-23)		*/
/* minute	- in  - minute number		(must be 0-59)		*/
/* second	- in  - second number		(must be 0-59)		*/
/* centisecond	- in  - number of centiseconds	(must be 0-99)		*/
/* time		- out - Gothic time					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		if all goes well				*/
/* GOTH__BADTIMEDATE	if the date does not make sense			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS tad_integers_to_time( GOTH_INTEGER	hour,
					 GOTH_INTEGER	minute,
					 GOTH_INTEGER	second,
					 GOTH_INTEGER	centisecond,
					 GOTH_TIME	time );


/*----------------------------------------------------------------------*/
/* EXTERN tad_get_month_name						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Convert a month number (1..12) into a month name, according to the	*/
/* following rules:							*/
/*									*/
/* `length' may be 0, 2 or 3						*/
/*									*/
/* if length == 2, month is one of JA,FE,MR,AP,MY,JN,JL,AU,SE,OC,NO,DE	*/
/* if length == 3, month is one of JAN,...,DEC				*/
/* if length == 0, month is one of JANUARY,...,DECEMBER			*/
/*									*/
/* `upcase' and `capitalise' determine exactly how the month name is	*/
/* returned:								*/
/*									*/
/* if upcase == TRUE, then the month name is totally uppercase		*/
/* if upcase == FALSE and capitalise == TRUE, then the month name	*/
/*	starts with a capital letter, and following letters are		*/
/*	lowercase (which is rather strange if length == 2, but still)	*/
/* if upcase == FALSE and capitalise == FALSE, then the month name	*/
/*	is totally lowercase						*/
/*									*/
/* Obviously, month is allocated for the caller, so they must remember	*/
/* to free it.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* month_number	- in  - the number for the month - 1 to 12		*/
/* month_name	- out - the name for the month				*/
/* length	- in  - see above					*/
/* upcase	- in  - see above					*/
/* capitalise	- in  - see above					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS tad_get_month_name( GOTH_INTEGER	 month_number,
				       GOTH_STRING	*month_name,
				       GOTH_INTEGER	 length,
				       GOTH_BOOLEAN	 upcase,
 				       GOTH_BOOLEAN	 capitalise);

/*----------------------------------------------------------------------*/
/* EXTERN tad_get_name_extension					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return a string which can be used as an extension to 	*/
/* version names and the like. It is generated from the current date	*/
/* and time but only includes alphanumerics and underscores. It is	*/
/* ordered so that common roots with these extensions are ordered	*/
/* chronologically.							*/
/*..ARGUMENTS...........................................................*/
/* ret_extension	-out-	returned extension			*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Normal, successful completion			*/
/* GOTH__ERROR		Error, problem encountered, more data on stack	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS tad_get_name_extension( GOTH_STRING	*ret_extension );

/*>>> EXTERN functions from LIBCONVERT.C <<<*/

/*>>> EXTERN functions from MODIFY.C <<<*/

extern GOTH_STATUS tad_advance_time(GOTH_TIME    time, 
                                    GOTH_INTEGER hr_adv,
                                    GOTH_INTEGER min_adv,
                                    GOTH_INTEGER sec_adv,
                                    GOTH_INTEGER centi_adv);

extern GOTH_STATUS tad_advance_date(GOTH_DATE    date,
				    GOTH_INTEGER yrs_adv,
				    GOTH_INTEGER mths_adv,
				    GOTH_INTEGER days_adv);

/*>>> EXTERN functions from NOW.C <<<*/

extern GOTH_STATUS tad_get_time_now(GOTH_TIME time);

extern GOTH_STATUS tad_get_todays_date(GOTH_DATE gv_date);


/*>>> EXTERN functions from PRINTF.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN tad_printf							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*     Prints out a time or a date. Will be superfluous when goth_printf*/
/* can handle these itself.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  stream -in- The stream to print the time or date to.		*/
/*  td     -in- The time (or date) to print.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Function completed successfully.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS tad_printf(GOTH_DESCRIPTOR stream,
			      GOTH_TIME td);
#endif
#endif
