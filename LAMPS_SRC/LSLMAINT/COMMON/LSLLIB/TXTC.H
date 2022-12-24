/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1988-10-28 12:15:26.000000000 +0000
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
/************************************************************************/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England	*/
/* Author    TJ Ibbs, 27 October 1988					*/
/*									*/
/*		       T X T C . H					*/
/*									*/
/* this header file is a C version of the LSLLIB 'common block' file	*/
/* TXTC.CMN (used for text input and command decoding)			*/
/************************************************************************/ 

/************************************************************************/ 
/* The FORTRAN definitions are:						*/
/*									*/
/*	INTEGER*2 	DCPTR   	! decode pointer		*/
/*	INTEGER*2 	TXTPTR  	! end of line pointer		*/
/*	BYTE		TXTTYP  	! type of fake string		*/
/*	BYTE		TXTCLA  	! class of fake string		*/
/*	INTEGER*4 	TXTADD  	! address of buffer		*/
/*	INTEGER*2 	TXTLIM  	! actual buffer length		*/
/*	BYTE 		TXTBUF(MAX_TXTLIM)  	! text buffer		*/
/*									*/
/* with aliases:							*/
/*									*/
/*	INTEGER*4	TXTDSC(2)	! fake string descriptor	*/
/*	EQUIVALENCE	(TXTDSC,TXTPTR)					*/
/*									*/
/* common block:							*/
/*									*/
/*	COMMON/LSL_TXTC/DCPTR,TXTPTR,TXTTYP,TXTCLA,TXTADD,TXTLIM,TXTBUF	*/
/*									*/
/************************************************************************/ 

#define	MAX_TXTLIM	1024	/* maximum possible buffer length */
#define	DEF_TXTLIM	 255	/* default buffer length	  */

extern struct {
   INT_2	DCPTR;
   LSL_DESC	TXTDSC;
   INT_2	TXTLIM;
   BYTE		TXTBUF[MAX_TXTLIM];
} LSL_TXTC;
