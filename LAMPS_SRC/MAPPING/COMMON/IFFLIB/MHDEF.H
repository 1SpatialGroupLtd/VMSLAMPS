/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1987-05-29 13:46:38.000000000 +0100
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
/* Author    TJ Ibbs, 29 May 1987					*/
/*									*/
/*		         M H D E F . H					*/
/*									*/
/* this header file is a C version of the IFF 'common block' MHDEF.CMN	*/
/************************************************************************/ 

/************************************************************************/ 
/* the FORTRAN definition is:						*/
/*									*/
/*	INTEGER*2 MHARR(MHLEN)						*/
/*	LOGICAL*1 MHDESC(10)						*/
/*	EQUIVALENCE (MHARR,MHDESC)					*/
/*									*/
/* and they live in COMMON /MAPHDR/					*/
/*									*/
/* Note - don't forget that C arrays start indexing at [0]		*/
/************************************************************************/ 
#define  MHLEN  350		/* the size of the basic array */

extern union
	{
	INT_2      MHARR[MHLEN];	/* either the whole array, or	*/
	LOGICAL_1  MHDESC[10];		/* just the descriptor		*/
	} MAPHDR;
