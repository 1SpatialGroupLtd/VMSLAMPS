/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1987-05-27 16:11:18.000000000 +0100
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
/************************************************************************//* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England	*//* Author    TJ Ibbs, 26 May 1987     					*//*									*//*		           C L D . H  					*//*									*//* this header file is a C version of the LSLLIB 'common block' CLD.CMN	*//* which is used by the DCL command line parts of the library		*//*									*//* BEWARE that C array indices start at [0]				*//*									*//************************************************************************/ /************************************************************************/ /* the FORTRAN definitions for /LSL_CLD/ (in common block order) are:	*//*									*//*	REAL*8 		DBLRAY(MAX_REAL)				*//*	REAL*4 		RARRAY(MAX_REAL)				*//*	INTEGER*4	IARRAY(MAX_LONG)				*//*	INTEGER*4	NUMDBL						*//*	INTEGER*4	NUMREA						*//*	INTEGER*4	NUMINT						*//*	INTEGER*4       NUMSTR						*//*	INTEGER*4	NUMFIL						*//*	INTEGER*2       FIL_LEN(MAX_FIL)				*//*	INTEGER*2       STR_LEN(MAX_STR)				*//*									*//* and those in /LSL_CLDCHR/ are:					*//*									*//*	CHARACTER*128   CARRAY(MAX_STR)					*//*	CHARACTER*128	FILARY(MAX_FIL)					*//*									*//************************************************************************/ #define	MAX_STR	   16#define MAX_FIL    16#define MAX_REAL  128#define MAX_LONG 1024extern struct	{	REAL_8	DBLRAY[MAX_REAL];	REAL_4	RARRAY[MAX_REAL];	INT_4	IARRAY[MAX_LONG];	INT_4	NUMDBL;	INT_4	NUMREA;	INT_4	NUMINT;	INT_4	NUMSTR;	INT_4	NUMFIL;	INT_2	FIL_LEN[MAX_FIL];	INT_2	STR_LEN[MAX_STR];	} LSL_CLD;extern struct	{	char	CARRAY[MAX_STR][128];	char	FILARY[MAX_FIL][128];	} LSL_CLDCHR;