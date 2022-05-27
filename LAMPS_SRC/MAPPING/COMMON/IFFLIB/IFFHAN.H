/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1986-12-18 15:41:36.000000000 +0000
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
/************************************************************************//* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England	*//* Author    TJ Ibbs, 18 December 1986					*//*									*//*		       I F F H A N . H					*//*									*//* this header file is a C version of the IFF 'common block' IFFHAN.CMN	*//* which is used by the IFF library to record exceptions and current	*//* positions								*//************************************************************************/ /************************************************************************/ /* the FORTRAN definitions (in common block order) are:			*//*									*//*	INTEGER*4 LPOSE,LPOSR,LPOSW,LPOSH,LPOSM,LPOSF			*//*	INTEGER*4 IERCD,IERAD,IERNM					*//*	LOGICAL*2 WATEOF						*//*	INTEGER*2 IFOREL						*//*									*//* and they live in COMMON /IFFHAN/					*//************************************************************************/ extern struct	{	INT_4	LPOSE;	/* current EOF word number (next free word)	*/	INT_4	LPOSR;	/* current reading position			*/	INT_4	LPOSW;	/* current writing position			*/	INT_4	LPOSH;	/* posn of entry-in-hand (0 if none)		*/	INT_4	LPOSM;	/* posn of marked entry  (0 if none)		*/	INT_4	LPOSF;	/* posn of start of current feature (0 if none)	*/	INT_4	IERCD;	/* latest error code (0 if no error)		*/	INT_4	IERAD;	/* locates latest call to IFF error handler	*/	INT_4	IERNM;	/* VMS numerical error code			*/	INT_2	WATEOF;	/* is Fortran TRUE if writing at EOF		*/	INT_2	IFOREL; /* number of virtual blocks in the forepart	*/	} IFFHAN;