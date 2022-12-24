/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1987-06-08 15:58:44.000000000 +0100
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
/* Author    A Cuthbert, 7 June 1987					*/
/*									*/
/*		   C M D C O M . H					*/
/*									*/
/* this header file is a C version of the LSLLIB 'common block' file	*/
/* CMDCOM.CMN, which is used by the command decoding parts of the	*/
/* library								*/
/************************************************************************/ 

/************************************************************************/ 
/* In order the FORTRAN definitions are:				*/
/*									*/
/* for /LSL_CMDCOM/							*/
/*									*/
/*	INTEGER*4	INTARG(8)					*/
/*	REAL		REALAR(8)					*/
/*	INTEGER*4	CMDNST(2),SECNST(2),STARST(2)			*/
/*	INTEGER*4	CMDFST(2)	! copy of 'descriptor' for	*/
/*					!  command actually found	*/
/*	INTEGER*4	CMSFST(2)	! ditto for secondary command	*/
/*	INTEGER*4	CMDAST(2)	! copy of same for subject	*/
/*					!  of any ambiguity		*/	
/*	INTEGER*4	CMDNUM						*/
/*	INTEGER*4	TABFLG,CMDFLG					*/
/*	INTEGER*4	SECMDN		! secondary command number	*/
/*	INTEGER*4	SECTAB		! table secondary command is to	*/
/*					!   be looked up in		*/
/*	INTEGER*4	CMDACT,CMDICT,CMDRCT				*/
/*	INTEGER*4	DEFBASE						*/
/*	LOGICAL*1	ARGMSG,CMDNEG,HADDOT,NOMESS			*/
/*	BYTE		INEQUAL						*/
/*	LOGICAL*1	NOUFLG		! TRUE => no user flags with	*/
/*					!	  this table		*/
/*	LOGICAL*1	NSUFLG		! ditto for 2ndary table	*/
/*	BYTE		UNXCHR		! 'unexpected character' that	*/
/*					!   would be output for error	*/
/*					!   messages			*/
/*	INTEGER*4	UFLAG		! user flag found, if any	*/
/*	INTEGER*4	SUFLAG		! secondary table user flag	*/
/*									*/
/************************************************************************/ 

#define CMDNLE 	CMDNST[0]
#define SECNLE 	SECNST[0]
#define STARLE 	STARST[0]

extern struct 
	{
	INT_4	INTARG[8];
	REAL_4	REALAR[8];
	INT_4	CMDNST[2],SECNST[2],STARST[2],
		CMDFST[2],
		CMSFST[2],
		CMDAST[2],
		CMDNUM,
		TABFLG,CMDFLG,
		SECMDN,
		SECTAB,
		CMDACT,CMDICT,CMDRCT,
		DEFBASE;
	BOOLEAN	ARGMSG,CMDNEG,HADDOT,NOMESS;
	BYTE	INEQUAL;
	BOOLEAN	NOUFLG,
		NSUFLG;
	BYTE	UNXCHR;
	INT_4	UFLAG,
		SUFLAG;
	} LSL_CMDCOM;

